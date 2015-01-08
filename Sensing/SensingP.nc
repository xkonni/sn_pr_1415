#include <lib6lowpan/ip.h>

module SensingP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;

		interface Timer<TMilli> as SenseTimer;
		interface Read<uint16_t> as LightPar;
	}
} implementation {

	enum {
		Read_PERIOD = 250, // ms
		LightPar_THRESHOLD = 0x10,
	};

	event void Boot.booted() {
		call RadioControl.start();
		call SenseTimer.startPeriodic(Read_PERIOD);
	}

	event void SenseTimer.fired() {
		call LightPar.read();
	}

	event void LightPar.readDone(error_t e, uint16_t val) {
		if (e == SUCCESS)
			if (val < LightPar_THRESHOLD)
				call Leds.led0On();
			else
				call Leds.led0Off();
	}

	event void RadioControl.startDone(error_t e) {}

	event void RadioControl.stopDone(error_t e) {}
}
