Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3376901DC
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBIILA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBIIK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:10:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0812D15C
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:10:57 -0800 (PST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pQ20d-0007QT-Ms; Thu, 09 Feb 2023 09:10:24 +0100
Message-ID: <64ac012e-e471-9093-b253-4798bbfa8cb4@pengutronix.de>
Date:   Thu, 9 Feb 2023 09:10:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [Linux-stm32] [PATCH v3 6/6] ARM: dts: stm32: add ETZPC as a
 system bus for STM32MP13x boards
Content-Language: en-US
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>,
        Oleksii_Moisieiev@epam.com, gregkh@linuxfoundation.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        alexandre.torgue@foss.st.com, vkoul@kernel.org, jic23@kernel.org,
        olivier.moysan@foss.st.com, arnaud.pouliquen@foss.st.com,
        mchehab@kernel.org, fabrice.gasnier@foss.st.com,
        ulf.hansson@linaro.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-iio@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-i2c@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-phy@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
 <20230127164040.1047583-7-gatien.chevallier@foss.st.com>
 <da51fd69-e3e8-510c-00b1-b5213d0696b1@pengutronix.de>
In-Reply-To: <da51fd69-e3e8-510c-00b1-b5213d0696b1@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.02.23 08:46, Ahmad Fatoum wrote:
> Hello Gatien,
> 
> On 27.01.23 17:40, Gatien Chevallier wrote:
>> The STM32 System Bus is an internal bus on which devices are connected.
>> ETZPC is a peripheral overseeing the firewall bus that configures
>> and control access to the peripherals connected on it.
>>
>> For more information on which peripheral is securable, please read
>> the STM32MP13 reference manual.
> 
> Diff is way too big. Please split up the alphabetic reordering into its
> own commit, so actual functional changes are apparent.

Ah, I see now that you are moving securable peripherals into a new bus.
I share Uwe's confusion of considering the ETZPC as bus.

Does this configuration even change dynamically? Why can't you implement
this binding in the bootloader and have Linux only see a DT where unavailable
nodes are status = "disabled"; secure-status = "okay"?

For inspiration, see barebox' device tree fixups when devices are disabled
per fuse:

  https://elixir.bootlin.com/barebox/v2023.01.0/source/drivers/base/featctrl.c#L122

Cheers,
Ahmad

> 
> Thanks,
> Ahmad
> 
>>
>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>> ---
>>
>> No changes in V2.
>>
>> Changes in V3:
>> 	-Use appriopriate node name: bus
>>
>>  arch/arm/boot/dts/stm32mp131.dtsi  | 407 +++++++++++++++--------------
>>  arch/arm/boot/dts/stm32mp133.dtsi  |  51 ++--
>>  arch/arm/boot/dts/stm32mp13xc.dtsi |  19 +-
>>  arch/arm/boot/dts/stm32mp13xf.dtsi |  18 +-
>>  4 files changed, 258 insertions(+), 237 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/stm32mp131.dtsi b/arch/arm/boot/dts/stm32mp131.dtsi
>> index accc3824f7e9..24462a647101 100644
>> --- a/arch/arm/boot/dts/stm32mp131.dtsi
>> +++ b/arch/arm/boot/dts/stm32mp131.dtsi
>> @@ -253,148 +253,6 @@ dmamux1: dma-router@48002000 {
>>  			dma-channels = <16>;
>>  		};
>>  
>> -		adc_2: adc@48004000 {
>> -			compatible = "st,stm32mp13-adc-core";
>> -			reg = <0x48004000 0x400>;
>> -			interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc ADC2>, <&rcc ADC2_K>;
>> -			clock-names = "bus", "adc";
>> -			interrupt-controller;
>> -			#interrupt-cells = <1>;
>> -			#address-cells = <1>;
>> -			#size-cells = <0>;
>> -			status = "disabled";
>> -
>> -			adc2: adc@0 {
>> -				compatible = "st,stm32mp13-adc";
>> -				#io-channel-cells = <1>;
>> -				#address-cells = <1>;
>> -				#size-cells = <0>;
>> -				reg = <0x0>;
>> -				interrupt-parent = <&adc_2>;
>> -				interrupts = <0>;
>> -				dmas = <&dmamux1 10 0x400 0x80000001>;
>> -				dma-names = "rx";
>> -				status = "disabled";
>> -
>> -				channel@13 {
>> -					reg = <13>;
>> -					label = "vrefint";
>> -				};
>> -				channel@14 {
>> -					reg = <14>;
>> -					label = "vddcore";
>> -				};
>> -				channel@16 {
>> -					reg = <16>;
>> -					label = "vddcpu";
>> -				};
>> -				channel@17 {
>> -					reg = <17>;
>> -					label = "vddq_ddr";
>> -				};
>> -			};
>> -		};
>> -
>> -		usbotg_hs: usb@49000000 {
>> -			compatible = "st,stm32mp15-hsotg", "snps,dwc2";
>> -			reg = <0x49000000 0x40000>;
>> -			clocks = <&rcc USBO_K>;
>> -			clock-names = "otg";
>> -			resets = <&rcc USBO_R>;
>> -			reset-names = "dwc2";
>> -			interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
>> -			g-rx-fifo-size = <512>;
>> -			g-np-tx-fifo-size = <32>;
>> -			g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
>> -			dr_mode = "otg";
>> -			otg-rev = <0x200>;
>> -			usb33d-supply = <&usb33>;
>> -			status = "disabled";
>> -		};
>> -
>> -		spi4: spi@4c002000 {
>> -			compatible = "st,stm32h7-spi";
>> -			reg = <0x4c002000 0x400>;
>> -			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc SPI4_K>;
>> -			resets = <&rcc SPI4_R>;
>> -			#address-cells = <1>;
>> -			#size-cells = <0>;
>> -			dmas = <&dmamux1 83 0x400 0x01>,
>> -			       <&dmamux1 84 0x400 0x01>;
>> -			dma-names = "rx", "tx";
>> -			status = "disabled";
>> -		};
>> -
>> -		spi5: spi@4c003000 {
>> -			compatible = "st,stm32h7-spi";
>> -			reg = <0x4c003000 0x400>;
>> -			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc SPI5_K>;
>> -			resets = <&rcc SPI5_R>;
>> -			#address-cells = <1>;
>> -			#size-cells = <0>;
>> -			dmas = <&dmamux1 85 0x400 0x01>,
>> -			       <&dmamux1 86 0x400 0x01>;
>> -			dma-names = "rx", "tx";
>> -			status = "disabled";
>> -		};
>> -
>> -		i2c3: i2c@4c004000 {
>> -			compatible = "st,stm32mp13-i2c";
>> -			reg = <0x4c004000 0x400>;
>> -			interrupt-names = "event", "error";
>> -			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
>> -				     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc I2C3_K>;
>> -			resets = <&rcc I2C3_R>;
>> -			#address-cells = <1>;
>> -			#size-cells = <0>;
>> -			dmas = <&dmamux1 73 0x400 0x1>,
>> -			       <&dmamux1 74 0x400 0x1>;
>> -			dma-names = "rx", "tx";
>> -			st,syscfg-fmp = <&syscfg 0x4 0x4>;
>> -			i2c-analog-filter;
>> -			status = "disabled";
>> -		};
>> -
>> -		i2c4: i2c@4c005000 {
>> -			compatible = "st,stm32mp13-i2c";
>> -			reg = <0x4c005000 0x400>;
>> -			interrupt-names = "event", "error";
>> -			interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
>> -				     <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc I2C4_K>;
>> -			resets = <&rcc I2C4_R>;
>> -			#address-cells = <1>;
>> -			#size-cells = <0>;
>> -			dmas = <&dmamux1 75 0x400 0x1>,
>> -			       <&dmamux1 76 0x400 0x1>;
>> -			dma-names = "rx", "tx";
>> -			st,syscfg-fmp = <&syscfg 0x4 0x8>;
>> -			i2c-analog-filter;
>> -			status = "disabled";
>> -		};
>> -
>> -		i2c5: i2c@4c006000 {
>> -			compatible = "st,stm32mp13-i2c";
>> -			reg = <0x4c006000 0x400>;
>> -			interrupt-names = "event", "error";
>> -			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
>> -				     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc I2C5_K>;
>> -			resets = <&rcc I2C5_R>;
>> -			#address-cells = <1>;
>> -			#size-cells = <0>;
>> -			dmas = <&dmamux1 115 0x400 0x1>,
>> -			       <&dmamux1 116 0x400 0x1>;
>> -			dma-names = "rx", "tx";
>> -			st,syscfg-fmp = <&syscfg 0x4 0x10>;
>> -			i2c-analog-filter;
>> -			status = "disabled";
>> -		};
>> -
>>  		rcc: rcc@50000000 {
>>  			compatible = "st,stm32mp13-rcc", "syscon";
>>  			reg = <0x50000000 0x1000>;
>> @@ -431,34 +289,6 @@ mdma: dma-controller@58000000 {
>>  			dma-requests = <48>;
>>  		};
>>  
>> -		sdmmc1: mmc@58005000 {
>> -			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
>> -			arm,primecell-periphid = <0x20253180>;
>> -			reg = <0x58005000 0x1000>, <0x58006000 0x1000>;
>> -			interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc SDMMC1_K>;
>> -			clock-names = "apb_pclk";
>> -			resets = <&rcc SDMMC1_R>;
>> -			cap-sd-highspeed;
>> -			cap-mmc-highspeed;
>> -			max-frequency = <130000000>;
>> -			status = "disabled";
>> -		};
>> -
>> -		sdmmc2: mmc@58007000 {
>> -			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
>> -			arm,primecell-periphid = <0x20253180>;
>> -			reg = <0x58007000 0x1000>, <0x58008000 0x1000>;
>> -			interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc SDMMC2_K>;
>> -			clock-names = "apb_pclk";
>> -			resets = <&rcc SDMMC2_R>;
>> -			cap-sd-highspeed;
>> -			cap-mmc-highspeed;
>> -			max-frequency = <130000000>;
>> -			status = "disabled";
>> -		};
>> -
>>  		usbh_ohci: usb@5800c000 {
>>  			compatible = "generic-ohci";
>>  			reg = <0x5800c000 0x1000>;
>> @@ -486,29 +316,6 @@ iwdg2: watchdog@5a002000 {
>>  			status = "disabled";
>>  		};
>>  
>> -		usbphyc: usbphyc@5a006000 {
>> -			#address-cells = <1>;
>> -			#size-cells = <0>;
>> -			#clock-cells = <0>;
>> -			compatible = "st,stm32mp1-usbphyc";
>> -			reg = <0x5a006000 0x1000>;
>> -			clocks = <&rcc USBPHY_K>;
>> -			resets = <&rcc USBPHY_R>;
>> -			vdda1v1-supply = <&reg11>;
>> -			vdda1v8-supply = <&reg18>;
>> -			status = "disabled";
>> -
>> -			usbphyc_port0: usb-phy@0 {
>> -				#phy-cells = <0>;
>> -				reg = <0>;
>> -			};
>> -
>> -			usbphyc_port1: usb-phy@1 {
>> -				#phy-cells = <1>;
>> -				reg = <1>;
>> -			};
>> -		};
>> -
>>  		rtc: rtc@5c004000 {
>>  			compatible = "st,stm32mp1-rtc";
>>  			reg = <0x5c004000 0x400>;
>> @@ -536,6 +343,220 @@ ts_cal2: calib@5e {
>>  			};
>>  		};
>>  
>> +		etzpc: bus@5c007000 {
>> +			compatible = "st,stm32mp13-sys-bus";
>> +			reg = <0x5c007000 0x400>;
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			feature-domain-controller;
>> +			#feature-domain-cells = <1>;
>> +			ranges;
>> +
>> +			adc_2: adc@48004000 {
>> +				compatible = "st,stm32mp13-adc-core";
>> +				reg = <0x48004000 0x400>;
>> +				interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc ADC2>, <&rcc ADC2_K>;
>> +				clock-names = "bus", "adc";
>> +				interrupt-controller;
>> +				#interrupt-cells = <1>;
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				feature-domains = <&etzpc 33>;
>> +				status = "disabled";
>> +
>> +				adc2: adc@0 {
>> +					compatible = "st,stm32mp13-adc";
>> +					#io-channel-cells = <1>;
>> +					#address-cells = <1>;
>> +					#size-cells = <0>;
>> +					reg = <0x0>;
>> +					interrupt-parent = <&adc_2>;
>> +					interrupts = <0>;
>> +					dmas = <&dmamux1 10 0x400 0x80000001>;
>> +					dma-names = "rx";
>> +					status = "disabled";
>> +
>> +					channel@13 {
>> +						reg = <13>;
>> +						label = "vrefint";
>> +					};
>> +					channel@14 {
>> +						reg = <14>;
>> +						label = "vddcore";
>> +					};
>> +					channel@16 {
>> +						reg = <16>;
>> +						label = "vddcpu";
>> +					};
>> +					channel@17 {
>> +						reg = <17>;
>> +						label = "vddq_ddr";
>> +					};
>> +				};
>> +			};
>> +
>> +			usbotg_hs: usb@49000000 {
>> +				compatible = "st,stm32mp15-hsotg", "snps,dwc2";
>> +				reg = <0x49000000 0x40000>;
>> +				clocks = <&rcc USBO_K>;
>> +				clock-names = "otg";
>> +				resets = <&rcc USBO_R>;
>> +				reset-names = "dwc2";
>> +				interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
>> +				g-rx-fifo-size = <512>;
>> +				g-np-tx-fifo-size = <32>;
>> +				g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
>> +				dr_mode = "otg";
>> +				otg-rev = <0x200>;
>> +				usb33d-supply = <&usb33>;
>> +				feature-domains = <&etzpc 34>;
>> +				status = "disabled";
>> +			};
>> +
>> +			spi4: spi@4c002000 {
>> +				compatible = "st,stm32h7-spi";
>> +				reg = <0x4c002000 0x400>;
>> +				interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc SPI4_K>;
>> +				resets = <&rcc SPI4_R>;
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				dmas = <&dmamux1 83 0x400 0x01>,
>> +				       <&dmamux1 84 0x400 0x01>;
>> +				dma-names = "rx", "tx";
>> +				feature-domains = <&etzpc 18>;
>> +				status = "disabled";
>> +			};
>> +
>> +			spi5: spi@4c003000 {
>> +				compatible = "st,stm32h7-spi";
>> +				reg = <0x4c003000 0x400>;
>> +				interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc SPI5_K>;
>> +				resets = <&rcc SPI5_R>;
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				dmas = <&dmamux1 85 0x400 0x01>,
>> +				       <&dmamux1 86 0x400 0x01>;
>> +				dma-names = "rx", "tx";
>> +				feature-domains = <&etzpc 19>;
>> +				status = "disabled";
>> +			};
>> +
>> +			i2c3: i2c@4c004000 {
>> +				compatible = "st,stm32mp13-i2c";
>> +				reg = <0x4c004000 0x400>;
>> +				interrupt-names = "event", "error";
>> +				interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
>> +					     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc I2C3_K>;
>> +				resets = <&rcc I2C3_R>;
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				dmas = <&dmamux1 73 0x400 0x1>,
>> +				       <&dmamux1 74 0x400 0x1>;
>> +				dma-names = "rx", "tx";
>> +				st,syscfg-fmp = <&syscfg 0x4 0x4>;
>> +				i2c-analog-filter;
>> +				feature-domains = <&etzpc 20>;
>> +				status = "disabled";
>> +			};
>> +
>> +			i2c4: i2c@4c005000 {
>> +				compatible = "st,stm32mp13-i2c";
>> +				reg = <0x4c005000 0x400>;
>> +				interrupt-names = "event", "error";
>> +				interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
>> +					     <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc I2C4_K>;
>> +				resets = <&rcc I2C4_R>;
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				dmas = <&dmamux1 75 0x400 0x1>,
>> +				       <&dmamux1 76 0x400 0x1>;
>> +				dma-names = "rx", "tx";
>> +				st,syscfg-fmp = <&syscfg 0x4 0x8>;
>> +				i2c-analog-filter;
>> +				feature-domains = <&etzpc 21>;
>> +				status = "disabled";
>> +			};
>> +
>> +			i2c5: i2c@4c006000 {
>> +				compatible = "st,stm32mp13-i2c";
>> +				reg = <0x4c006000 0x400>;
>> +				interrupt-names = "event", "error";
>> +				interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
>> +					     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc I2C5_K>;
>> +				resets = <&rcc I2C5_R>;
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				dmas = <&dmamux1 115 0x400 0x1>,
>> +				       <&dmamux1 116 0x400 0x1>;
>> +				dma-names = "rx", "tx";
>> +				st,syscfg-fmp = <&syscfg 0x4 0x10>;
>> +				i2c-analog-filter;
>> +				feature-domains = <&etzpc 22>;
>> +				status = "disabled";
>> +			};
>> +
>> +			sdmmc1: mmc@58005000 {
>> +				compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
>> +				arm,primecell-periphid = <0x20253180>;
>> +				reg = <0x58005000 0x1000>, <0x58006000 0x1000>;
>> +				interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc SDMMC1_K>;
>> +				clock-names = "apb_pclk";
>> +				resets = <&rcc SDMMC1_R>;
>> +				cap-sd-highspeed;
>> +				cap-mmc-highspeed;
>> +				max-frequency = <130000000>;
>> +				feature-domains = <&etzpc 50>;
>> +				status = "disabled";
>> +			};
>> +
>> +			sdmmc2: mmc@58007000 {
>> +				compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
>> +				arm,primecell-periphid = <0x20253180>;
>> +				reg = <0x58007000 0x1000>, <0x58008000 0x1000>;
>> +				interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&rcc SDMMC2_K>;
>> +				clock-names = "apb_pclk";
>> +				resets = <&rcc SDMMC2_R>;
>> +				cap-sd-highspeed;
>> +				cap-mmc-highspeed;
>> +				max-frequency = <130000000>;
>> +				feature-domains = <&etzpc 51>;
>> +				status = "disabled";
>> +			};
>> +
>> +			usbphyc: usbphyc@5a006000 {
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				#clock-cells = <0>;
>> +				compatible = "st,stm32mp1-usbphyc";
>> +				reg = <0x5a006000 0x1000>;
>> +				clocks = <&rcc USBPHY_K>;
>> +				resets = <&rcc USBPHY_R>;
>> +				vdda1v1-supply = <&reg11>;
>> +				vdda1v8-supply = <&reg18>;
>> +				feature-domains = <&etzpc 5>;
>> +				status = "disabled";
>> +
>> +				usbphyc_port0: usb-phy@0 {
>> +					#phy-cells = <0>;
>> +					reg = <0>;
>> +				};
>> +
>> +				usbphyc_port1: usb-phy@1 {
>> +					#phy-cells = <1>;
>> +					reg = <1>;
>> +				};
>> +			};
>> +
>> +		};
>> +
>>  		/*
>>  		 * Break node order to solve dependency probe issue between
>>  		 * pinctrl and exti.
>> diff --git a/arch/arm/boot/dts/stm32mp133.dtsi b/arch/arm/boot/dts/stm32mp133.dtsi
>> index df451c3c2a26..be6061552683 100644
>> --- a/arch/arm/boot/dts/stm32mp133.dtsi
>> +++ b/arch/arm/boot/dts/stm32mp133.dtsi
>> @@ -33,35 +33,38 @@ m_can2: can@4400f000 {
>>  			bosch,mram-cfg = <0x1400 0 0 32 0 0 2 2>;
>>  			status = "disabled";
>>  		};
>> +	};
>> +};
>>  
>> -		adc_1: adc@48003000 {
>> -			compatible = "st,stm32mp13-adc-core";
>> -			reg = <0x48003000 0x400>;
>> -			interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc ADC1>, <&rcc ADC1_K>;
>> -			clock-names = "bus", "adc";
>> -			interrupt-controller;
>> -			#interrupt-cells = <1>;
>> +&etzpc {
>> +	adc_1: adc@48003000 {
>> +		compatible = "st,stm32mp13-adc-core";
>> +		reg = <0x48003000 0x400>;
>> +		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks = <&rcc ADC1>, <&rcc ADC1_K>;
>> +		clock-names = "bus", "adc";
>> +		interrupt-controller;
>> +		#interrupt-cells = <1>;
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		feature-domains = <&etzpc 32>;
>> +		status = "disabled";
>> +
>> +		adc1: adc@0 {
>> +			compatible = "st,stm32mp13-adc";
>> +			#io-channel-cells = <1>;
>>  			#address-cells = <1>;
>>  			#size-cells = <0>;
>> +			reg = <0x0>;
>> +			interrupt-parent = <&adc_1>;
>> +			interrupts = <0>;
>> +			dmas = <&dmamux1 9 0x400 0x80000001>;
>> +			dma-names = "rx";
>>  			status = "disabled";
>>  
>> -			adc1: adc@0 {
>> -				compatible = "st,stm32mp13-adc";
>> -				#io-channel-cells = <1>;
>> -				#address-cells = <1>;
>> -				#size-cells = <0>;
>> -				reg = <0x0>;
>> -				interrupt-parent = <&adc_1>;
>> -				interrupts = <0>;
>> -				dmas = <&dmamux1 9 0x400 0x80000001>;
>> -				dma-names = "rx";
>> -				status = "disabled";
>> -
>> -				channel@18 {
>> -					reg = <18>;
>> -					label = "vrefint";
>> -				};
>> +			channel@18 {
>> +				reg = <18>;
>> +				label = "vrefint";
>>  			};
>>  		};
>>  	};
>> diff --git a/arch/arm/boot/dts/stm32mp13xc.dtsi b/arch/arm/boot/dts/stm32mp13xc.dtsi
>> index 4d00e7592882..a1a7a40c2a3e 100644
>> --- a/arch/arm/boot/dts/stm32mp13xc.dtsi
>> +++ b/arch/arm/boot/dts/stm32mp13xc.dtsi
>> @@ -4,15 +4,14 @@
>>   * Author: Alexandre Torgue <alexandre.torgue@foss.st.com> for STMicroelectronics.
>>   */
>>  
>> -/ {
>> -	soc {
>> -		cryp: crypto@54002000 {
>> -			compatible = "st,stm32mp1-cryp";
>> -			reg = <0x54002000 0x400>;
>> -			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc CRYP1>;
>> -			resets = <&rcc CRYP1_R>;
>> -			status = "disabled";
>> -		};
>> +&etzpc {
>> +	cryp: crypto@54002000 {
>> +		compatible = "st,stm32mp1-cryp";
>> +		reg = <0x54002000 0x400>;
>> +		interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks = <&rcc CRYP1>;
>> +		resets = <&rcc CRYP1_R>;
>> +		feature-domains = <&etzpc 42>;
>> +		status = "disabled";
>>  	};
>>  };
>> diff --git a/arch/arm/boot/dts/stm32mp13xf.dtsi b/arch/arm/boot/dts/stm32mp13xf.dtsi
>> index 4d00e7592882..b9fb071a1471 100644
>> --- a/arch/arm/boot/dts/stm32mp13xf.dtsi
>> +++ b/arch/arm/boot/dts/stm32mp13xf.dtsi
>> @@ -4,15 +4,13 @@
>>   * Author: Alexandre Torgue <alexandre.torgue@foss.st.com> for STMicroelectronics.
>>   */
>>  
>> -/ {
>> -	soc {
>> -		cryp: crypto@54002000 {
>> -			compatible = "st,stm32mp1-cryp";
>> -			reg = <0x54002000 0x400>;
>> -			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>> -			clocks = <&rcc CRYP1>;
>> -			resets = <&rcc CRYP1_R>;
>> -			status = "disabled";
>> -		};
>> +&etzpc {
>> +	cryp: crypto@54002000 {
>> +		compatible = "st,stm32mp1-cryp";
>> +		reg = <0x54002000 0x400>;
>> +		interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks = <&rcc CRYP1>;
>> +		resets = <&rcc CRYP1_R>;
>> +		status = "disabled";
>>  	};
>>  };
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

