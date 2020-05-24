;*******************************************************************************
;                                                                              *
;    Filename:	main_p1.asm                                                    *
;    Date:      24/may/20                                                      *
;    File Version: 1.0                                                         *
;    Author:   Orozco Torrez Jose Ivan                                         *
;    Company:   CUCEI UDG                                                      *
;    Description: Rotacion puerto MSB                                          *
;                                                                              *
;*******************************************************************************

; TODO INSERT CONFIG HERE

; PIC16F628 Configuration Bit Settings

; ASM source line config statements

#include "p16f628.inc"

; CONFIG
; __config 0xFF18
 __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF


;*******************************************************************************

; VARIABLE DEFINITIONS STARTING HERE
var_a   EQU	0x20	;var_a se almacena en la direccion 20Hex de la memoria RAM (General Purpose Registers)
var_b   EQU	0x21	;var_a se almacena en la direccion 21Hex
var_c   EQU	0x22	;var_a se almacena en la direccion 21Hex
var1	EQU	0x23	;Declaramos variable var1
	
var_loop1   EQU	    0x24
var_loop2   EQU	    0x25
var_loop3   EQU	    0x26
   
;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program


;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************

MAIN_PROG CODE                      ; let linker place main program

START
;********   Configuramos puertos
    BSF	    STATUS,RP0	;Cambiamos al banco 1 de memoria, seteando RP0 en 1
    CLRF    TRISB	; Ponemos todos los bits del TRISB en 0 para indicar que son pines(bits) salidas
    BCF	    STATUS,RP0	;Regresamos al banco de memoria 0 limpiando o poniendo en 0 el bit RP0	    

;*****************************
;Programa principal
    
MAIN_PROG
   MOVLW    b'10000000'	;Inicializamos el puerto B con el bit MSB en 1
   MOVWF    PORTB
   CALL	    delay
;COMENZAMOS A ROTAR BIT HACIA LA DERECHA
VERIFY
   ;if
   BTFSS    PORTB,0		    ;verificamos si el bit 0 del puerto b este en 1, 
   GOTO	    ROTA_DER	    ; si no es asi, seguimos rotando hacia la derecha
   GOTO	    ROTA_IZQ		    ; si es asi, significa que ahora tenemos que rotar hacia el otro lado
   
ROTA_DER
   RRF	    PORTB
   CALL	    delay
   GOTO	    VERIFY

;ROTAMOS HACIA LA IZQUIERDA
ROTA_IZQ
   RLF	    PORTB
   CALL	    delay
   GOTO	    VERIFY
   

delay
;{
    MOVLW   d'4'	;inicializo var var_loop1
    MOVWF   var_loop1	;con 255
dec_loop1
    DECFSZ  var_loop1	;var_loop2--
    GOTO    loop2	;decrementa de nuevo
    RETURN		;regresamos al punto de llamada de la subrutina

loop2
    MOVLW   d'255'	;inicializo var var_loop2
    MOVWF   var_loop2	;con 255
dec_loop2
    DECFSZ  var_loop2	;var_loop2--
    GOTO    loop3	;decrementa de nuevo
    GOTO    dec_loop1
 
loop3
    MOVLW   d'255'	;inicializo var var_loop3
    MOVWF   var_loop3	;con 255
dec_loop3
    DECFSZ  var_loop3	;var_loop3--
    GOTO    dec_loop3	;decrementa de nuevo
    GOTO    dec_loop2
;}
    
END_PROG 
    END