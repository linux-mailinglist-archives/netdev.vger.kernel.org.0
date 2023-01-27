Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9853367EB67
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbjA0QpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbjA0QpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:45:11 -0500
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2988242F;
        Fri, 27 Jan 2023 08:44:45 -0800 (PST)
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RF8sGY026717;
        Fri, 27 Jan 2023 17:42:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=selector1;
 bh=9xvEZo/dhS+DQ6WEcrhaGbEf2jzDyu9Ym0qrkmNvy+E=;
 b=vtjIguzArquoePTsslSEuXsrzNDcVrEUeeR+BvVsyECmrfNabiA8ZSIZVH8h0YkjOJEy
 rGrPdTDLl98cSVPlRa7zAsz4PUa5/WZNfnMV9vSkt7EeSRZ9XxMiaHF7E9/j4RA+Ixn4
 5htp3MCOZm5jXLn9ij1+IDQI0szP8dTU376u/Ms6QRzrRgFc9ZEXB/gUln4bE5PzPBzy
 cKCN9jd43vtryxzGUrLQ4HycwDUfHaE3H/PZ2HOYPk9gN2LnrHaQVux9iCT+RJpXVEa5
 90xe7VAN2MW+MN4MMyFYcc0/wYiLOygZ7HfJk2oTm0eZRSUIx4NVMH4quWgnSi7eqzvC qw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3n89chdbbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 17:42:36 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 5FC4110002A;
        Fri, 27 Jan 2023 17:42:35 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 57BE421ED24;
        Fri, 27 Jan 2023 17:42:35 +0100 (CET)
Received: from localhost (10.201.21.177) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.13; Fri, 27 Jan
 2023 17:42:34 +0100
From:   Gatien Chevallier <gatien.chevallier@foss.st.com>
To:     <Oleksii_Moisieiev@epam.com>, <gregkh@linuxfoundation.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <alexandre.torgue@foss.st.com>, <vkoul@kernel.org>,
        <jic23@kernel.org>, <olivier.moysan@foss.st.com>,
        <arnaud.pouliquen@foss.st.com>, <mchehab@kernel.org>,
        <fabrice.gasnier@foss.st.com>, <ulf.hansson@linaro.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Gatien Chevallier <gatien.chevallier@foss.st.com>
Subject: [PATCH v3 5/6] ARM: dts: stm32: add ETZPC as a system bus for STM32MP15x boards
Date:   Fri, 27 Jan 2023 17:40:39 +0100
Message-ID: <20230127164040.1047583-6-gatien.chevallier@foss.st.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.201.21.177]
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_10,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The STM32 System Bus is an internal bus on which devices are connected.
ETZPC is a peripheral overseeing the firewall bus that configures
and control access to the peripherals connected on it.

For more information on which peripheral is securable, please read
the STM32MP15 reference manual.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---

No changes in V2.

Changes in V3:
	-Use appriopriate node name: bus

 arch/arm/boot/dts/stm32mp151.dtsi  | 2722 ++++++++++++++--------------
 arch/arm/boot/dts/stm32mp153.dtsi  |   52 +-
 arch/arm/boot/dts/stm32mp15xc.dtsi |   19 +-
 3 files changed, 1434 insertions(+), 1359 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index 5491b6c4dec2..5dab96e7c2ba 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -122,1526 +122,1600 @@ soc {
 		interrupt-parent = <&intc>;
 		ranges;
 
-		timers2: timer@40000000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40000000 0x400>;
-			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM2_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 18 0x400 0x1>,
-			       <&dmamux1 19 0x400 0x1>,
-			       <&dmamux1 20 0x400 0x1>,
-			       <&dmamux1 21 0x400 0x1>,
-			       <&dmamux1 22 0x400 0x1>;
-			dma-names = "ch1", "ch2", "ch3", "ch4", "up";
+		ipcc: mailbox@4c001000 {
+			compatible = "st,stm32mp1-ipcc";
+			#mbox-cells = <1>;
+			reg = <0x4c001000 0x400>;
+			st,proc-id = <0>;
+			interrupts-extended =
+				<&exti 61 1>,
+				<&intc GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "rx", "tx";
+			clocks = <&rcc IPCC>;
+			wakeup-source;
 			status = "disabled";
+		};
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
-			};
-
-			timer@1 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <1>;
-				status = "disabled";
-			};
-
-			counter {
-				compatible = "st,stm32-timer-counter";
-				status = "disabled";
-			};
+		rcc: rcc@50000000 {
+			compatible = "st,stm32mp1-rcc", "syscon";
+			reg = <0x50000000 0x1000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
 		};
 
-		timers3: timer@40001000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40001000 0x400>;
-			interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM3_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 23 0x400 0x1>,
-			       <&dmamux1 24 0x400 0x1>,
-			       <&dmamux1 25 0x400 0x1>,
-			       <&dmamux1 26 0x400 0x1>,
-			       <&dmamux1 27 0x400 0x1>,
-			       <&dmamux1 28 0x400 0x1>;
-			dma-names = "ch1", "ch2", "ch3", "ch4", "up", "trig";
-			status = "disabled";
+		pwr_regulators: pwr@50001000 {
+			compatible = "st,stm32mp1,pwr-reg";
+			reg = <0x50001000 0x10>;
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
+			reg11: reg11 {
+				regulator-name = "reg11";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
 			};
 
-			timer@2 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <2>;
-				status = "disabled";
+			reg18: reg18 {
+				regulator-name = "reg18";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 			};
 
-			counter {
-				compatible = "st,stm32-timer-counter";
-				status = "disabled";
+			usb33: usb33 {
+				regulator-name = "usb33";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 			};
 		};
 
-		timers4: timer@40002000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40002000 0x400>;
-			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM4_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 29 0x400 0x1>,
-			       <&dmamux1 30 0x400 0x1>,
-			       <&dmamux1 31 0x400 0x1>,
-			       <&dmamux1 32 0x400 0x1>;
-			dma-names = "ch1", "ch2", "ch3", "ch4";
-			status = "disabled";
-
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
-			};
+		pwr_mcu: pwr_mcu@50001014 {
+			compatible = "st,stm32mp151-pwr-mcu", "syscon";
+			reg = <0x50001014 0x4>;
+		};
 
-			timer@3 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <3>;
-				status = "disabled";
-			};
+		exti: interrupt-controller@5000d000 {
+			compatible = "st,stm32mp1-exti", "syscon";
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			reg = <0x5000d000 0x400>;
+		};
 
-			counter {
-				compatible = "st,stm32-timer-counter";
-				status = "disabled";
-			};
+		syscfg: syscon@50020000 {
+			compatible = "st,stm32mp157-syscfg", "syscon";
+			reg = <0x50020000 0x400>;
+			clocks = <&rcc SYSCFG>;
 		};
 
-		timers5: timer@40003000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40003000 0x400>;
-			interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM5_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 55 0x400 0x1>,
-			       <&dmamux1 56 0x400 0x1>,
-			       <&dmamux1 57 0x400 0x1>,
-			       <&dmamux1 58 0x400 0x1>,
-			       <&dmamux1 59 0x400 0x1>,
-			       <&dmamux1 60 0x400 0x1>;
-			dma-names = "ch1", "ch2", "ch3", "ch4", "up", "trig";
+		dts: thermal@50028000 {
+			compatible = "st,stm32-thermal";
+			reg = <0x50028000 0x100>;
+			interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&rcc TMPSENS>;
+			clock-names = "pclk";
+			#thermal-sensor-cells = <0>;
 			status = "disabled";
+		};
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
-			};
-
-			timer@4 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <4>;
-				status = "disabled";
-			};
-
-			counter {
-				compatible = "st,stm32-timer-counter";
-				status = "disabled";
-			};
+		mdma1: dma-controller@58000000 {
+			compatible = "st,stm32h7-mdma";
+			reg = <0x58000000 0x1000>;
+			interrupts = <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&rcc MDMA>;
+			resets = <&rcc MDMA_R>;
+			#dma-cells = <5>;
+			dma-channels = <32>;
+			dma-requests = <48>;
 		};
 
-		timers6: timer@40004000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40004000 0x400>;
-			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM6_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 69 0x400 0x1>;
-			dma-names = "up";
+		sdmmc1: mmc@58005000 {
+			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
+			arm,primecell-periphid = <0x00253180>;
+			reg = <0x58005000 0x1000>;
+			interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&rcc SDMMC1_K>;
+			clock-names = "apb_pclk";
+			resets = <&rcc SDMMC1_R>;
+			cap-sd-highspeed;
+			cap-mmc-highspeed;
+			max-frequency = <120000000>;
 			status = "disabled";
-
-			timer@5 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <5>;
-				status = "disabled";
-			};
 		};
 
-		timers7: timer@40005000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40005000 0x400>;
-			interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM7_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 70 0x400 0x1>;
-			dma-names = "up";
+		sdmmc2: mmc@58007000 {
+			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
+			arm,primecell-periphid = <0x00253180>;
+			reg = <0x58007000 0x1000>;
+			interrupts = <GIC_SPI 124 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&rcc SDMMC2_K>;
+			clock-names = "apb_pclk";
+			resets = <&rcc SDMMC2_R>;
+			cap-sd-highspeed;
+			cap-mmc-highspeed;
+			max-frequency = <120000000>;
 			status = "disabled";
-
-			timer@6 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <6>;
-				status = "disabled";
-			};
 		};
 
-		timers12: timer@40006000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40006000 0x400>;
-			interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM12_K>;
-			clock-names = "int";
+		crc1: crc@58009000 {
+			compatible = "st,stm32f7-crc";
+			reg = <0x58009000 0x400>;
+			clocks = <&rcc CRC1>;
 			status = "disabled";
-
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
-			};
-
-			timer@11 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <11>;
-				status = "disabled";
-			};
 		};
 
-		timers13: timer@40007000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40007000 0x400>;
-			interrupts = <GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM13_K>;
-			clock-names = "int";
+		usbh_ohci: usb@5800c000 {
+			compatible = "generic-ohci";
+			reg = <0x5800c000 0x1000>;
+			clocks = <&usbphyc>, <&rcc USBH>;
+			resets = <&rcc USBH_R>;
+			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
+		};
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
-			};
-
-			timer@12 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <12>;
-				status = "disabled";
-			};
+		usbh_ehci: usb@5800d000 {
+			compatible = "generic-ehci";
+			reg = <0x5800d000 0x1000>;
+			clocks = <&usbphyc>, <&rcc USBH>;
+			resets = <&rcc USBH_R>;
+			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+			companion = <&usbh_ohci>;
+			status = "disabled";
 		};
 
-		timers14: timer@40008000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x40008000 0x400>;
-			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM14_K>;
-			clock-names = "int";
+		ltdc: display-controller@5a001000 {
+			compatible = "st,stm32-ltdc";
+			reg = <0x5a001000 0x400>;
+			interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&rcc LTDC_PX>;
+			clock-names = "lcd";
+			resets = <&rcc LTDC_R>;
 			status = "disabled";
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
+			port {
+				#address-cells = <1>;
+				#size-cells = <0>;
 			};
+		};
 
-			timer@13 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <13>;
-				status = "disabled";
-			};
+		iwdg2: watchdog@5a002000 {
+			compatible = "st,stm32mp1-iwdg";
+			reg = <0x5a002000 0x400>;
+			clocks = <&rcc IWDG2>, <&rcc CK_LSI>;
+			clock-names = "pclk", "lsi";
+			status = "disabled";
 		};
 
-		lptimer1: timer@40009000 {
+		usbphyc: usbphyc@5a006000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "st,stm32-lptimer";
-			reg = <0x40009000 0x400>;
-			interrupts-extended = <&exti 47 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc LPTIM1_K>;
-			clock-names = "mux";
-			wakeup-source;
+			#clock-cells = <0>;
+			compatible = "st,stm32mp1-usbphyc";
+			reg = <0x5a006000 0x1000>;
+			clocks = <&rcc USBPHY_K>;
+			resets = <&rcc USBPHY_R>;
+			vdda1v1-supply = <&reg11>;
+			vdda1v8-supply = <&reg18>;
 			status = "disabled";
 
-			pwm {
-				compatible = "st,stm32-pwm-lp";
-				#pwm-cells = <3>;
-				status = "disabled";
-			};
-
-			trigger@0 {
-				compatible = "st,stm32-lptimer-trigger";
+			usbphyc_port0: usb-phy@0 {
+				#phy-cells = <0>;
 				reg = <0>;
-				status = "disabled";
 			};
 
-			counter {
-				compatible = "st,stm32-lptimer-counter";
-				status = "disabled";
+			usbphyc_port1: usb-phy@1 {
+				#phy-cells = <1>;
+				reg = <1>;
 			};
 		};
 
-		spi2: spi@4000b000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32h7-spi";
-			reg = <0x4000b000 0x400>;
-			interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI2_K>;
-			resets = <&rcc SPI2_R>;
-			dmas = <&dmamux1 39 0x400 0x05>,
-			       <&dmamux1 40 0x400 0x05>;
-			dma-names = "rx", "tx";
+		rtc: rtc@5c004000 {
+			compatible = "st,stm32mp1-rtc";
+			reg = <0x5c004000 0x400>;
+			clocks = <&rcc RTCAPB>, <&rcc RTC>;
+			clock-names = "pclk", "rtc_ck";
+			interrupts-extended = <&exti 19 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 		};
 
-		i2s2: audio-controller@4000b000 {
-			compatible = "st,stm32h7-i2s";
-			#sound-dai-cells = <0>;
-			reg = <0x4000b000 0x400>;
-			interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmamux1 39 0x400 0x01>,
-			       <&dmamux1 40 0x400 0x01>;
-			dma-names = "rx", "tx";
-			status = "disabled";
+		bsec: efuse@5c005000 {
+			compatible = "st,stm32mp15-bsec";
+			reg = <0x5c005000 0x400>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ts_cal1: calib@5c {
+				reg = <0x5c 0x2>;
+			};
+			ts_cal2: calib@5e {
+				reg = <0x5e 0x2>;
+			};
 		};
 
-		spi3: spi@4000c000 {
+		etzpc: bus@5c007000 {
+			compatible = "st,stm32mp15-sys-bus";
+			reg = <0x5c007000 0x400>;
 			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32h7-spi";
-			reg = <0x4000c000 0x400>;
-			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI3_K>;
-			resets = <&rcc SPI3_R>;
-			dmas = <&dmamux1 61 0x400 0x05>,
-			       <&dmamux1 62 0x400 0x05>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+			#size-cells = <1>;
+			feature-domain-controller;
+			#feature-domain-cells = <1>;
+			ranges;
 
-		i2s3: audio-controller@4000c000 {
-			compatible = "st,stm32h7-i2s";
-			#sound-dai-cells = <0>;
-			reg = <0x4000c000 0x400>;
-			interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmamux1 61 0x400 0x01>,
-			       <&dmamux1 62 0x400 0x01>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+			timers2: timer@40000000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40000000 0x400>;
+				interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM2_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 18 0x400 0x1>,
+				       <&dmamux1 19 0x400 0x1>,
+				       <&dmamux1 20 0x400 0x1>,
+				       <&dmamux1 21 0x400 0x1>,
+				       <&dmamux1 22 0x400 0x1>;
+				dma-names = "ch1", "ch2", "ch3", "ch4", "up";
+				feature-domains = <&etzpc 16>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-		spdifrx: audio-controller@4000d000 {
-			compatible = "st,stm32h7-spdifrx";
-			#sound-dai-cells = <0>;
-			reg = <0x4000d000 0x400>;
-			clocks = <&rcc SPDIF_K>;
-			clock-names = "kclk";
-			interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmamux1 93 0x400 0x01>,
-			       <&dmamux1 94 0x400 0x01>;
-			dma-names = "rx", "rx-ctrl";
-			status = "disabled";
-		};
+				timer@1 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <1>;
+					status = "disabled";
+				};
 
-		usart2: serial@4000e000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x4000e000 0x400>;
-			interrupts-extended = <&exti 27 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc USART2_K>;
-			wakeup-source;
-			dmas = <&dmamux1 43 0x400 0x15>,
-			       <&dmamux1 44 0x400 0x11>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+				counter {
+					compatible = "st,stm32-timer-counter";
+					status = "disabled";
+				};
+			};
 
-		usart3: serial@4000f000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x4000f000 0x400>;
-			interrupts-extended = <&exti 28 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc USART3_K>;
-			wakeup-source;
-			dmas = <&dmamux1 45 0x400 0x15>,
-			       <&dmamux1 46 0x400 0x11>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+			timers3: timer@40001000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40001000 0x400>;
+				interrupts = <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM3_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 23 0x400 0x1>,
+				       <&dmamux1 24 0x400 0x1>,
+				       <&dmamux1 25 0x400 0x1>,
+				       <&dmamux1 26 0x400 0x1>,
+				       <&dmamux1 27 0x400 0x1>,
+				       <&dmamux1 28 0x400 0x1>;
+				dma-names = "ch1", "ch2", "ch3", "ch4", "up", "trig";
+				feature-domains = <&etzpc 17>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-		uart4: serial@40010000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x40010000 0x400>;
-			interrupts-extended = <&exti 30 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc UART4_K>;
-			wakeup-source;
-			dmas = <&dmamux1 63 0x400 0x15>,
-			       <&dmamux1 64 0x400 0x11>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+				timer@2 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <2>;
+					status = "disabled";
+				};
 
-		uart5: serial@40011000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x40011000 0x400>;
-			interrupts-extended = <&exti 31 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc UART5_K>;
-			wakeup-source;
-			dmas = <&dmamux1 65 0x400 0x15>,
-			       <&dmamux1 66 0x400 0x11>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+				counter {
+					compatible = "st,stm32-timer-counter";
+					status = "disabled";
+				};
+			};
 
-		i2c1: i2c@40012000 {
-			compatible = "st,stm32mp15-i2c";
-			reg = <0x40012000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C1_K>;
-			resets = <&rcc I2C1_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			st,syscfg-fmp = <&syscfg 0x4 0x1>;
-			wakeup-source;
-			i2c-analog-filter;
-			status = "disabled";
-		};
+			timers4: timer@40002000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40002000 0x400>;
+				interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM4_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 29 0x400 0x1>,
+				       <&dmamux1 30 0x400 0x1>,
+				       <&dmamux1 31 0x400 0x1>,
+				       <&dmamux1 32 0x400 0x1>;
+				dma-names = "ch1", "ch2", "ch3", "ch4";
+				feature-domains = <&etzpc 18>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-		i2c2: i2c@40013000 {
-			compatible = "st,stm32mp15-i2c";
-			reg = <0x40013000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C2_K>;
-			resets = <&rcc I2C2_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			st,syscfg-fmp = <&syscfg 0x4 0x2>;
-			wakeup-source;
-			i2c-analog-filter;
-			status = "disabled";
-		};
+				timer@3 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <3>;
+					status = "disabled";
+				};
 
-		i2c3: i2c@40014000 {
-			compatible = "st,stm32mp15-i2c";
-			reg = <0x40014000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C3_K>;
-			resets = <&rcc I2C3_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			st,syscfg-fmp = <&syscfg 0x4 0x4>;
-			wakeup-source;
-			i2c-analog-filter;
-			status = "disabled";
-		};
+				counter {
+					compatible = "st,stm32-timer-counter";
+					status = "disabled";
+				};
+			};
 
-		i2c5: i2c@40015000 {
-			compatible = "st,stm32mp15-i2c";
-			reg = <0x40015000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C5_K>;
-			resets = <&rcc I2C5_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			st,syscfg-fmp = <&syscfg 0x4 0x10>;
-			wakeup-source;
-			i2c-analog-filter;
-			status = "disabled";
-		};
+			timers5: timer@40003000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40003000 0x400>;
+				interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM5_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 55 0x400 0x1>,
+				       <&dmamux1 56 0x400 0x1>,
+				       <&dmamux1 57 0x400 0x1>,
+				       <&dmamux1 58 0x400 0x1>,
+				       <&dmamux1 59 0x400 0x1>,
+				       <&dmamux1 60 0x400 0x1>;
+				dma-names = "ch1", "ch2", "ch3", "ch4", "up", "trig";
+				feature-domains = <&etzpc 19>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-		cec: cec@40016000 {
-			compatible = "st,stm32-cec";
-			reg = <0x40016000 0x400>;
-			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc CEC_K>, <&rcc CEC>;
-			clock-names = "cec", "hdmi-cec";
-			status = "disabled";
-		};
+				timer@4 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <4>;
+					status = "disabled";
+				};
 
-		dac: dac@40017000 {
-			compatible = "st,stm32h7-dac-core";
-			reg = <0x40017000 0x400>;
-			clocks = <&rcc DAC12>;
-			clock-names = "pclk";
-			#address-cells = <1>;
-			#size-cells = <0>;
-			status = "disabled";
+				counter {
+					compatible = "st,stm32-timer-counter";
+					status = "disabled";
+				};
+			};
 
-			dac1: dac@1 {
-				compatible = "st,stm32-dac";
-				#io-channel-cells = <1>;
-				reg = <1>;
-				status = "disabled";
+			timers6: timer@40004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40004000 0x400>;
+				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM6_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 69 0x400 0x1>;
+				dma-names = "up";
+				feature-domains = <&etzpc 20>;
+				status = "disabled";
+
+				timer@5 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <5>;
+					status = "disabled";
+				};
 			};
 
-			dac2: dac@2 {
-				compatible = "st,stm32-dac";
-				#io-channel-cells = <1>;
-				reg = <2>;
-				status = "disabled";
+			timers7: timer@40005000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40005000 0x400>;
+				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM7_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 70 0x400 0x1>;
+				dma-names = "up";
+				feature-domains = <&etzpc 21>;
+				status = "disabled";
+
+				timer@6 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <6>;
+					status = "disabled";
+				};
 			};
-		};
 
-		uart7: serial@40018000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x40018000 0x400>;
-			interrupts-extended = <&exti 32 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc UART7_K>;
-			wakeup-source;
-			dmas = <&dmamux1 79 0x400 0x15>,
-			       <&dmamux1 80 0x400 0x11>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+			timers12: timer@40006000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40006000 0x400>;
+				interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM12_K>;
+				clock-names = "int";
+				feature-domains = <&etzpc 22>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-		uart8: serial@40019000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x40019000 0x400>;
-			interrupts-extended = <&exti 33 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc UART8_K>;
-			wakeup-source;
-			dmas = <&dmamux1 81 0x400 0x15>,
-			       <&dmamux1 82 0x400 0x11>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+				timer@11 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <11>;
+					status = "disabled";
+				};
+			};
 
-		timers1: timer@44000000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x44000000 0x400>;
-			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "brk", "up", "trg-com", "cc";
-			clocks = <&rcc TIM1_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 11 0x400 0x1>,
-			       <&dmamux1 12 0x400 0x1>,
-			       <&dmamux1 13 0x400 0x1>,
-			       <&dmamux1 14 0x400 0x1>,
-			       <&dmamux1 15 0x400 0x1>,
-			       <&dmamux1 16 0x400 0x1>,
-			       <&dmamux1 17 0x400 0x1>;
-			dma-names = "ch1", "ch2", "ch3", "ch4",
-				    "up", "trig", "com";
-			status = "disabled";
+			timers13: timer@40007000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40007000 0x400>;
+				interrupts = <GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM13_K>;
+				clock-names = "int";
+				feature-domains = <&etzpc 23>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
+				timer@12 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <12>;
+					status = "disabled";
+				};
 			};
 
-			timer@0 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <0>;
-				status = "disabled";
-			};
+			timers14: timer@40008000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x40008000 0x400>;
+				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM14_K>;
+				clock-names = "int";
+				feature-domains = <&etzpc 24>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-			counter {
-				compatible = "st,stm32-timer-counter";
-				status = "disabled";
+				timer@13 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <13>;
+					status = "disabled";
+				};
 			};
-		};
 
-		timers8: timer@44001000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x44001000 0x400>;
-			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "brk", "up", "trg-com", "cc";
-			clocks = <&rcc TIM8_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 47 0x400 0x1>,
-			       <&dmamux1 48 0x400 0x1>,
-			       <&dmamux1 49 0x400 0x1>,
-			       <&dmamux1 50 0x400 0x1>,
-			       <&dmamux1 51 0x400 0x1>,
-			       <&dmamux1 52 0x400 0x1>,
-			       <&dmamux1 53 0x400 0x1>;
-			dma-names = "ch1", "ch2", "ch3", "ch4",
-				    "up", "trig", "com";
-			status = "disabled";
+			lptimer1: timer@40009000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-lptimer";
+				reg = <0x40009000 0x400>;
+				interrupts-extended = <&exti 47 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc LPTIM1_K>;
+				clock-names = "mux";
+				wakeup-source;
+				feature-domains = <&etzpc 25>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm-lp";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
-				status = "disabled";
+				trigger@0 {
+					compatible = "st,stm32-lptimer-trigger";
+					reg = <0>;
+					status = "disabled";
+				};
+
+				counter {
+					compatible = "st,stm32-lptimer-counter";
+					status = "disabled";
+				};
 			};
 
-			timer@7 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <7>;
+			i2s2: audio-controller@4000b000 {
+				compatible = "st,stm32h7-i2s";
+				#sound-dai-cells = <0>;
+				reg = <0x4000b000 0x400>;
+				interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
+				dmas = <&dmamux1 39 0x400 0x01>,
+				       <&dmamux1 40 0x400 0x01>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 27>;
 				status = "disabled";
 			};
 
-			counter {
-				compatible = "st,stm32-timer-counter";
+			spi2: spi@4000b000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32h7-spi";
+				reg = <0x4000b000 0x400>;
+				interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI2_K>;
+				resets = <&rcc SPI2_R>;
+				dmas = <&dmamux1 39 0x400 0x05>,
+				       <&dmamux1 40 0x400 0x05>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 27>;
 				status = "disabled";
 			};
-		};
-
-		usart6: serial@44003000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x44003000 0x400>;
-			interrupts-extended = <&exti 29 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc USART6_K>;
-			wakeup-source;
-			dmas = <&dmamux1 71 0x400 0x15>,
-			       <&dmamux1 72 0x400 0x11>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
-
-		spi1: spi@44004000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32h7-spi";
-			reg = <0x44004000 0x400>;
-			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI1_K>;
-			resets = <&rcc SPI1_R>;
-			dmas = <&dmamux1 37 0x400 0x05>,
-			       <&dmamux1 38 0x400 0x05>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
-
-		i2s1: audio-controller@44004000 {
-			compatible = "st,stm32h7-i2s";
-			#sound-dai-cells = <0>;
-			reg = <0x44004000 0x400>;
-			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmamux1 37 0x400 0x01>,
-			       <&dmamux1 38 0x400 0x01>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
-
-		spi4: spi@44005000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32h7-spi";
-			reg = <0x44005000 0x400>;
-			interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI4_K>;
-			resets = <&rcc SPI4_R>;
-			dmas = <&dmamux1 83 0x400 0x05>,
-			       <&dmamux1 84 0x400 0x05>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
-
-		timers15: timer@44006000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x44006000 0x400>;
-			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM15_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 105 0x400 0x1>,
-			       <&dmamux1 106 0x400 0x1>,
-			       <&dmamux1 107 0x400 0x1>,
-			       <&dmamux1 108 0x400 0x1>;
-			dma-names = "ch1", "up", "trig", "com";
-			status = "disabled";
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
+			i2s3: audio-controller@4000c000 {
+				compatible = "st,stm32h7-i2s";
+				#sound-dai-cells = <0>;
+				reg = <0x4000c000 0x400>;
+				interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
+				dmas = <&dmamux1 61 0x400 0x01>,
+				       <&dmamux1 62 0x400 0x01>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 28>;
 				status = "disabled";
 			};
 
-			timer@14 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <14>;
+			spi3: spi@4000c000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32h7-spi";
+				reg = <0x4000c000 0x400>;
+				interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI3_K>;
+				resets = <&rcc SPI3_R>;
+				dmas = <&dmamux1 61 0x400 0x05>,
+				       <&dmamux1 62 0x400 0x05>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 28>;
 				status = "disabled";
 			};
-		};
-
-		timers16: timer@44007000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x44007000 0x400>;
-			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM16_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 109 0x400 0x1>,
-			       <&dmamux1 110 0x400 0x1>;
-			dma-names = "ch1", "up";
-			status = "disabled";
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
+			spdifrx: audio-controller@4000d000 {
+				compatible = "st,stm32h7-spdifrx";
+				#sound-dai-cells = <0>;
+				reg = <0x4000d000 0x400>;
+				clocks = <&rcc SPDIF_K>;
+				clock-names = "kclk";
+				interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
+				dmas = <&dmamux1 93 0x400 0x01>,
+				       <&dmamux1 94 0x400 0x01>;
+				dma-names = "rx", "rx-ctrl";
+				feature-domains = <&etzpc 29>;
+				status = "disabled";
+			};
+
+			usart2: serial@4000e000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x4000e000 0x400>;
+				interrupts-extended = <&exti 27 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc USART2_K>;
+				wakeup-source;
+				dmas = <&dmamux1 43 0x400 0x15>,
+				       <&dmamux1 44 0x400 0x11>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 30>;
+				status = "disabled";
+			};
+
+			usart3: serial@4000f000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x4000f000 0x400>;
+				interrupts-extended = <&exti 28 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc USART3_K>;
+				wakeup-source;
+				dmas = <&dmamux1 45 0x400 0x15>,
+				       <&dmamux1 46 0x400 0x11>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 31>;
+				status = "disabled";
+			};
+
+			uart4: serial@40010000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x40010000 0x400>;
+				interrupts-extended = <&exti 30 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc UART4_K>;
+				wakeup-source;
+				dmas = <&dmamux1 63 0x400 0x15>,
+				       <&dmamux1 64 0x400 0x11>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 32>;
+				status = "disabled";
+			};
+
+			uart5: serial@40011000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x40011000 0x400>;
+				interrupts-extended = <&exti 31 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc UART5_K>;
+				wakeup-source;
+				dmas = <&dmamux1 65 0x400 0x15>,
+				       <&dmamux1 66 0x400 0x11>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 33>;
+				status = "disabled";
+			};
+
+			i2c1: i2c@40012000 {
+				compatible = "st,stm32mp15-i2c";
+				reg = <0x40012000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C1_K>;
+				resets = <&rcc I2C1_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				st,syscfg-fmp = <&syscfg 0x4 0x1>;
+				wakeup-source;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 34>;
 				status = "disabled";
 			};
-			timer@15 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <15>;
+
+			i2c2: i2c@40013000 {
+				compatible = "st,stm32mp15-i2c";
+				reg = <0x40013000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C2_K>;
+				resets = <&rcc I2C2_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				st,syscfg-fmp = <&syscfg 0x4 0x2>;
+				wakeup-source;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 35>;
 				status = "disabled";
 			};
-		};
 
-		timers17: timer@44008000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-timers";
-			reg = <0x44008000 0x400>;
-			interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "global";
-			clocks = <&rcc TIM17_K>;
-			clock-names = "int";
-			dmas = <&dmamux1 111 0x400 0x1>,
-			       <&dmamux1 112 0x400 0x1>;
-			dma-names = "ch1", "up";
-			status = "disabled";
+			i2c3: i2c@40014000 {
+				compatible = "st,stm32mp15-i2c";
+				reg = <0x40014000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C3_K>;
+				resets = <&rcc I2C3_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				st,syscfg-fmp = <&syscfg 0x4 0x4>;
+				wakeup-source;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 36>;
+				status = "disabled";
+			};
 
-			pwm {
-				compatible = "st,stm32-pwm";
-				#pwm-cells = <3>;
+			i2c5: i2c@40015000 {
+				compatible = "st,stm32mp15-i2c";
+				reg = <0x40015000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C5_K>;
+				resets = <&rcc I2C5_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				st,syscfg-fmp = <&syscfg 0x4 0x10>;
+				wakeup-source;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 37>;
 				status = "disabled";
 			};
 
-			timer@16 {
-				compatible = "st,stm32h7-timer-trigger";
-				reg = <16>;
+			cec: cec@40016000 {
+				compatible = "st,stm32-cec";
+				reg = <0x40016000 0x400>;
+				interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc CEC_K>, <&rcc CEC>;
+				clock-names = "cec", "hdmi-cec";
+				feature-domains = <&etzpc 38>;
 				status = "disabled";
 			};
-		};
 
-		spi5: spi@44009000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32h7-spi";
-			reg = <0x44009000 0x400>;
-			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI5_K>;
-			resets = <&rcc SPI5_R>;
-			dmas = <&dmamux1 85 0x400 0x05>,
-			       <&dmamux1 86 0x400 0x05>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
+			dac: dac@40017000 {
+				compatible = "st,stm32h7-dac-core";
+				reg = <0x40017000 0x400>;
+				clocks = <&rcc DAC12>;
+				clock-names = "pclk";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				feature-domains = <&etzpc 39>;
+				status = "disabled";
 
-		sai1: sai@4400a000 {
-			compatible = "st,stm32h7-sai";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0 0x4400a000 0x400>;
-			reg = <0x4400a000 0x4>, <0x4400a3f0 0x10>;
-			interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
-			resets = <&rcc SAI1_R>;
-			status = "disabled";
+				dac1: dac@1 {
+					compatible = "st,stm32-dac";
+					#io-channel-cells = <1>;
+					reg = <1>;
+					status = "disabled";
+				};
 
-			sai1a: audio-controller@4400a004 {
-				#sound-dai-cells = <0>;
+				dac2: dac@2 {
+					compatible = "st,stm32-dac";
+					#io-channel-cells = <1>;
+					reg = <2>;
+					status = "disabled";
+				};
+			};
 
-				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x20>;
-				clocks = <&rcc SAI1_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 87 0x400 0x01>;
+			uart7: serial@40018000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x40018000 0x400>;
+				interrupts-extended = <&exti 32 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc UART7_K>;
+				wakeup-source;
+				dmas = <&dmamux1 79 0x400 0x15>,
+				       <&dmamux1 80 0x400 0x11>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 40>;
 				status = "disabled";
 			};
 
-			sai1b: audio-controller@4400a024 {
-				#sound-dai-cells = <0>;
-				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x20>;
-				clocks = <&rcc SAI1_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 88 0x400 0x01>;
+			uart8: serial@40019000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x40019000 0x400>;
+				interrupts-extended = <&exti 33 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc UART8_K>;
+				wakeup-source;
+				dmas = <&dmamux1 81 0x400 0x15>,
+				       <&dmamux1 82 0x400 0x11>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 41>;
 				status = "disabled";
 			};
-		};
 
-		sai2: sai@4400b000 {
-			compatible = "st,stm32h7-sai";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0 0x4400b000 0x400>;
-			reg = <0x4400b000 0x4>, <0x4400b3f0 0x10>;
-			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
-			resets = <&rcc SAI2_R>;
-			status = "disabled";
+			timers1: timer@44000000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x44000000 0x400>;
+				interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "brk", "up", "trg-com", "cc";
+				clocks = <&rcc TIM1_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 11 0x400 0x1>,
+				       <&dmamux1 12 0x400 0x1>,
+				       <&dmamux1 13 0x400 0x1>,
+				       <&dmamux1 14 0x400 0x1>,
+				       <&dmamux1 15 0x400 0x1>,
+				       <&dmamux1 16 0x400 0x1>,
+				       <&dmamux1 17 0x400 0x1>;
+				dma-names = "ch1", "ch2", "ch3", "ch4",
+					    "up", "trig", "com";
+				feature-domains = <&etzpc 48>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-			sai2a: audio-controller@4400b004 {
-				#sound-dai-cells = <0>;
-				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x20>;
-				clocks = <&rcc SAI2_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 89 0x400 0x01>;
-				status = "disabled";
-			};
+				timer@0 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <0>;
+					status = "disabled";
+				};
 
-			sai2b: audio-controller@4400b024 {
-				#sound-dai-cells = <0>;
-				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x20>;
-				clocks = <&rcc SAI2_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 90 0x400 0x01>;
-				status = "disabled";
+				counter {
+					compatible = "st,stm32-timer-counter";
+					status = "disabled";
+				};
 			};
-		};
 
-		sai3: sai@4400c000 {
-			compatible = "st,stm32h7-sai";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0 0x4400c000 0x400>;
-			reg = <0x4400c000 0x4>, <0x4400c3f0 0x10>;
-			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
-			resets = <&rcc SAI3_R>;
-			status = "disabled";
+			timers8: timer@44001000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x44001000 0x400>;
+				interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "brk", "up", "trg-com", "cc";
+				clocks = <&rcc TIM8_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 47 0x400 0x1>,
+				       <&dmamux1 48 0x400 0x1>,
+				       <&dmamux1 49 0x400 0x1>,
+				       <&dmamux1 50 0x400 0x1>,
+				       <&dmamux1 51 0x400 0x1>,
+				       <&dmamux1 52 0x400 0x1>,
+				       <&dmamux1 53 0x400 0x1>;
+				dma-names = "ch1", "ch2", "ch3", "ch4",
+					    "up", "trig", "com";
+				feature-domains = <&etzpc 49>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-			sai3a: audio-controller@4400c004 {
-				#sound-dai-cells = <0>;
-				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x20>;
-				clocks = <&rcc SAI3_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 113 0x400 0x01>;
+				timer@7 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <7>;
+					status = "disabled";
+				};
+
+				counter {
+					compatible = "st,stm32-timer-counter";
+					status = "disabled";
+				};
+			};
+
+			usart6: serial@44003000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x44003000 0x400>;
+				interrupts-extended = <&exti 29 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc USART6_K>;
+				wakeup-source;
+				dmas = <&dmamux1 71 0x400 0x15>,
+				<&dmamux1 72 0x400 0x11>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 51>;
 				status = "disabled";
 			};
 
-			sai3b: audio-controller@4400c024 {
+			i2s1: audio-controller@44004000 {
+				compatible = "st,stm32h7-i2s";
 				#sound-dai-cells = <0>;
-				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x20>;
-				clocks = <&rcc SAI3_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 114 0x400 0x01>;
+				reg = <0x44004000 0x400>;
+				interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+				dmas = <&dmamux1 37 0x400 0x01>,
+				<&dmamux1 38 0x400 0x01>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 52>;
 				status = "disabled";
 			};
-		};
-
-		dfsdm: dfsdm@4400d000 {
-			compatible = "st,stm32mp1-dfsdm";
-			reg = <0x4400d000 0x800>;
-			clocks = <&rcc DFSDM_K>;
-			clock-names = "dfsdm";
-			#address-cells = <1>;
-			#size-cells = <0>;
-			status = "disabled";
 
-			dfsdm0: filter@0 {
-				compatible = "st,stm32-dfsdm-adc";
-				#io-channel-cells = <1>;
-				reg = <0>;
-				interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>;
-				dmas = <&dmamux1 101 0x400 0x01>;
-				dma-names = "rx";
+			spi1: spi@44004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32h7-spi";
+				reg = <0x44004000 0x400>;
+				interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI1_K>;
+				resets = <&rcc SPI1_R>;
+				dmas = <&dmamux1 37 0x400 0x05>,
+				<&dmamux1 38 0x400 0x05>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 52>;
 				status = "disabled";
 			};
 
-			dfsdm1: filter@1 {
-				compatible = "st,stm32-dfsdm-adc";
-				#io-channel-cells = <1>;
-				reg = <1>;
-				interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
-				dmas = <&dmamux1 102 0x400 0x01>;
-				dma-names = "rx";
+			spi4: spi@44005000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32h7-spi";
+				reg = <0x44005000 0x400>;
+				interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI4_K>;
+				resets = <&rcc SPI4_R>;
+				dmas = <&dmamux1 83 0x400 0x05>,
+				<&dmamux1 84 0x400 0x05>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 53>;
 				status = "disabled";
 			};
 
-			dfsdm2: filter@2 {
-				compatible = "st,stm32-dfsdm-adc";
-				#io-channel-cells = <1>;
-				reg = <2>;
-				interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
-				dmas = <&dmamux1 103 0x400 0x01>;
-				dma-names = "rx";
-				status = "disabled";
+			timers15: timer@44006000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x44006000 0x400>;
+				interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM15_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 105 0x400 0x1>,
+				       <&dmamux1 106 0x400 0x1>,
+				       <&dmamux1 107 0x400 0x1>,
+				       <&dmamux1 108 0x400 0x1>;
+				dma-names = "ch1", "up", "trig", "com";
+				feature-domains = <&etzpc 54>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
+
+				timer@14 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <14>;
+					status = "disabled";
+				};
 			};
 
-			dfsdm3: filter@3 {
-				compatible = "st,stm32-dfsdm-adc";
-				#io-channel-cells = <1>;
-				reg = <3>;
-				interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
-				dmas = <&dmamux1 104 0x400 0x01>;
-				dma-names = "rx";
-				status = "disabled";
+			timers16: timer@44007000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x44007000 0x400>;
+				interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM16_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 109 0x400 0x1>,
+				<&dmamux1 110 0x400 0x1>;
+				dma-names = "ch1", "up";
+				feature-domains = <&etzpc 55>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
+				timer@15 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <15>;
+					status = "disabled";
+				};
 			};
 
-			dfsdm4: filter@4 {
-				compatible = "st,stm32-dfsdm-adc";
-				#io-channel-cells = <1>;
-				reg = <4>;
-				interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
-				dmas = <&dmamux1 91 0x400 0x01>;
-				dma-names = "rx";
-				status = "disabled";
+			timers17: timer@44008000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-timers";
+				reg = <0x44008000 0x400>;
+				interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "global";
+				clocks = <&rcc TIM17_K>;
+				clock-names = "int";
+				dmas = <&dmamux1 111 0x400 0x1>,
+				<&dmamux1 112 0x400 0x1>;
+				dma-names = "ch1", "up";
+				feature-domains = <&etzpc 56>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
+
+				timer@16 {
+					compatible = "st,stm32h7-timer-trigger";
+					reg = <16>;
+					status = "disabled";
+				};
 			};
 
-			dfsdm5: filter@5 {
-				compatible = "st,stm32-dfsdm-adc";
-				#io-channel-cells = <1>;
-				reg = <5>;
-				interrupts = <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
-				dmas = <&dmamux1 92 0x400 0x01>;
-				dma-names = "rx";
+			spi5: spi@44009000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32h7-spi";
+				reg = <0x44009000 0x400>;
+				interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI5_K>;
+				resets = <&rcc SPI5_R>;
+				dmas = <&dmamux1 85 0x400 0x05>,
+				<&dmamux1 86 0x400 0x05>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 57>;
 				status = "disabled";
 			};
-		};
 
-		dma1: dma-controller@48000000 {
-			compatible = "st,stm32-dma";
-			reg = <0x48000000 0x400>;
-			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc DMA1>;
-			resets = <&rcc DMA1_R>;
-			#dma-cells = <4>;
-			st,mem2mem;
-			dma-requests = <8>;
-		};
+			sai1: sai@4400a000 {
+				compatible = "st,stm32h7-sai";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 0x4400a000 0x400>;
+				reg = <0x4400a000 0x4>, <0x4400a3f0 0x10>;
+				interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+				resets = <&rcc SAI1_R>;
+				feature-domains = <&etzpc 58>;
+				status = "disabled";
+
+				sai1a: audio-controller@4400a004 {
+					#sound-dai-cells = <0>;
+
+					compatible = "st,stm32-sai-sub-a";
+					reg = <0x4 0x20>;
+					clocks = <&rcc SAI1_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 87 0x400 0x01>;
+					status = "disabled";
+				};
 
-		dma2: dma-controller@48001000 {
-			compatible = "st,stm32-dma";
-			reg = <0x48001000 0x400>;
-			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc DMA2>;
-			resets = <&rcc DMA2_R>;
-			#dma-cells = <4>;
-			st,mem2mem;
-			dma-requests = <8>;
-		};
+				sai1b: audio-controller@4400a024 {
+					#sound-dai-cells = <0>;
+					compatible = "st,stm32-sai-sub-b";
+					reg = <0x24 0x20>;
+					clocks = <&rcc SAI1_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 88 0x400 0x01>;
+					status = "disabled";
+				};
+			};
 
-		dmamux1: dma-router@48002000 {
-			compatible = "st,stm32h7-dmamux";
-			reg = <0x48002000 0x40>;
-			#dma-cells = <3>;
-			dma-requests = <128>;
-			dma-masters = <&dma1 &dma2>;
-			dma-channels = <16>;
-			clocks = <&rcc DMAMUX>;
-			resets = <&rcc DMAMUX_R>;
-		};
+			sai2: sai@4400b000 {
+				compatible = "st,stm32h7-sai";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 0x4400b000 0x400>;
+				reg = <0x4400b000 0x4>, <0x4400b3f0 0x10>;
+				interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+				resets = <&rcc SAI2_R>;
+				feature-domains = <&etzpc 59>;
+				status = "disabled";
+
+				sai2a: audio-controller@4400b004 {
+					#sound-dai-cells = <0>;
+					compatible = "st,stm32-sai-sub-a";
+					reg = <0x4 0x20>;
+					clocks = <&rcc SAI2_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 89 0x400 0x01>;
+					status = "disabled";
+				};
 
-		adc: adc@48003000 {
-			compatible = "st,stm32mp1-adc-core";
-			reg = <0x48003000 0x400>;
-			interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc ADC12>, <&rcc ADC12_K>;
-			clock-names = "bus", "adc";
-			interrupt-controller;
-			st,syscfg = <&syscfg>;
-			#interrupt-cells = <1>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			status = "disabled";
+				sai2b: audio-controller@4400b024 {
+					#sound-dai-cells = <0>;
+					compatible = "st,stm32-sai-sub-b";
+					reg = <0x24 0x20>;
+					clocks = <&rcc SAI2_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 90 0x400 0x01>;
+					status = "disabled";
+				};
+			};
 
-			adc1: adc@0 {
-				compatible = "st,stm32mp1-adc";
-				#io-channel-cells = <1>;
-				reg = <0x0>;
-				interrupt-parent = <&adc>;
-				interrupts = <0>;
-				dmas = <&dmamux1 9 0x400 0x01>;
-				dma-names = "rx";
-				status = "disabled";
+			sai3: sai@4400c000 {
+				compatible = "st,stm32h7-sai";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 0x4400c000 0x400>;
+				reg = <0x4400c000 0x4>, <0x4400c3f0 0x10>;
+				interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+				resets = <&rcc SAI3_R>;
+				feature-domains = <&etzpc 60>;
+				status = "disabled";
+
+				sai3a: audio-controller@4400c004 {
+					#sound-dai-cells = <0>;
+					compatible = "st,stm32-sai-sub-a";
+					reg = <0x04 0x20>;
+					clocks = <&rcc SAI3_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 113 0x400 0x01>;
+					status = "disabled";
+				};
+
+				sai3b: audio-controller@4400c024 {
+					#sound-dai-cells = <0>;
+					compatible = "st,stm32-sai-sub-b";
+					reg = <0x24 0x20>;
+					clocks = <&rcc SAI3_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 114 0x400 0x01>;
+					status = "disabled";
+				};
 			};
 
-			adc2: adc@100 {
-				compatible = "st,stm32mp1-adc";
-				#io-channel-cells = <1>;
-				reg = <0x100>;
-				interrupt-parent = <&adc>;
-				interrupts = <1>;
-				dmas = <&dmamux1 10 0x400 0x01>;
-				dma-names = "rx";
+			dfsdm: dfsdm@4400d000 {
+				compatible = "st,stm32mp1-dfsdm";
+				reg = <0x4400d000 0x800>;
+				clocks = <&rcc DFSDM_K>;
+				clock-names = "dfsdm";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				feature-domains = <&etzpc 61>;
 				status = "disabled";
-			};
-		};
 
-		sdmmc3: mmc@48004000 {
-			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
-			arm,primecell-periphid = <0x00253180>;
-			reg = <0x48004000 0x400>;
-			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SDMMC3_K>;
-			clock-names = "apb_pclk";
-			resets = <&rcc SDMMC3_R>;
-			cap-sd-highspeed;
-			cap-mmc-highspeed;
-			max-frequency = <120000000>;
-			status = "disabled";
-		};
+				dfsdm0: filter@0 {
+					compatible = "st,stm32-dfsdm-adc";
+					#io-channel-cells = <1>;
+					reg = <0>;
+					interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>;
+					dmas = <&dmamux1 101 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 
-		usbotg_hs: usb-otg@49000000 {
-			compatible = "st,stm32mp15-hsotg", "snps,dwc2";
-			reg = <0x49000000 0x10000>;
-			clocks = <&rcc USBO_K>;
-			clock-names = "otg";
-			resets = <&rcc USBO_R>;
-			reset-names = "dwc2";
-			interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
-			g-rx-fifo-size = <512>;
-			g-np-tx-fifo-size = <32>;
-			g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
-			dr_mode = "otg";
-			otg-rev = <0x200>;
-			usb33d-supply = <&usb33>;
-			status = "disabled";
-		};
+				dfsdm1: filter@1 {
+					compatible = "st,stm32-dfsdm-adc";
+					#io-channel-cells = <1>;
+					reg = <1>;
+					interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
+					dmas = <&dmamux1 102 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 
-		ipcc: mailbox@4c001000 {
-			compatible = "st,stm32mp1-ipcc";
-			#mbox-cells = <1>;
-			reg = <0x4c001000 0x400>;
-			st,proc-id = <0>;
-			interrupts-extended =
-				<&exti 61 1>,
-				<&intc GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "rx", "tx";
-			clocks = <&rcc IPCC>;
-			wakeup-source;
-			status = "disabled";
-		};
-
-		dcmi: dcmi@4c006000 {
-			compatible = "st,stm32-dcmi";
-			reg = <0x4c006000 0x400>;
-			interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
-			resets = <&rcc CAMITF_R>;
-			clocks = <&rcc DCMI>;
-			clock-names = "mclk";
-			dmas = <&dmamux1 75 0x400 0x01>;
-			dma-names = "tx";
-			status = "disabled";
-		};
+				dfsdm2: filter@2 {
+					compatible = "st,stm32-dfsdm-adc";
+					#io-channel-cells = <1>;
+					reg = <2>;
+					interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
+					dmas = <&dmamux1 103 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 
-		rcc: rcc@50000000 {
-			compatible = "st,stm32mp1-rcc", "syscon";
-			reg = <0x50000000 0x1000>;
-			#clock-cells = <1>;
-			#reset-cells = <1>;
-		};
+				dfsdm3: filter@3 {
+					compatible = "st,stm32-dfsdm-adc";
+					#io-channel-cells = <1>;
+					reg = <3>;
+					interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+					dmas = <&dmamux1 104 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 
-		pwr_regulators: pwr@50001000 {
-			compatible = "st,stm32mp1,pwr-reg";
-			reg = <0x50001000 0x10>;
+				dfsdm4: filter@4 {
+					compatible = "st,stm32-dfsdm-adc";
+					#io-channel-cells = <1>;
+					reg = <4>;
+					interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
+					dmas = <&dmamux1 91 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 
-			reg11: reg11 {
-				regulator-name = "reg11";
-				regulator-min-microvolt = <1100000>;
-				regulator-max-microvolt = <1100000>;
+				dfsdm5: filter@5 {
+					compatible = "st,stm32-dfsdm-adc";
+					#io-channel-cells = <1>;
+					reg = <5>;
+					interrupts = <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
+					dmas = <&dmamux1 92 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 			};
 
-			reg18: reg18 {
-				regulator-name = "reg18";
-				regulator-min-microvolt = <1800000>;
-				regulator-max-microvolt = <1800000>;
-			};
+			dma1: dma-controller@48000000 {
+				compatible = "st,stm32-dma";
+				reg = <0x48000000 0x400>;
+				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc DMA1>;
+				resets = <&rcc DMA1_R>;
+				#dma-cells = <4>;
+				st,mem2mem;
+				dma-requests = <8>;
+				feature-domains = <&etzpc 88>;
+			};
+
+			dma2: dma-controller@48001000 {
+				compatible = "st,stm32-dma";
+				reg = <0x48001000 0x400>;
+				interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc DMA2>;
+				resets = <&rcc DMA2_R>;
+				#dma-cells = <4>;
+				st,mem2mem;
+				dma-requests = <8>;
+				feature-domains = <&etzpc 89>;
+			};
+
+			dmamux1: dma-router@48002000 {
+				compatible = "st,stm32h7-dmamux";
+				reg = <0x48002000 0x40>;
+				#dma-cells = <3>;
+				dma-requests = <128>;
+				dma-masters = <&dma1 &dma2>;
+				dma-channels = <16>;
+				clocks = <&rcc DMAMUX>;
+				resets = <&rcc DMAMUX_R>;
+				feature-domains = <&etzpc 90>;
+			};
+
+			adc: adc@48003000 {
+				compatible = "st,stm32mp1-adc-core";
+				reg = <0x48003000 0x400>;
+				interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc ADC12>, <&rcc ADC12_K>;
+				clock-names = "bus", "adc";
+				interrupt-controller;
+				st,syscfg = <&syscfg>;
+				#interrupt-cells = <1>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				feature-domains = <&etzpc 72>;
+				status = "disabled";
+
+				adc1: adc@0 {
+					compatible = "st,stm32mp1-adc";
+					#io-channel-cells = <1>;
+					reg = <0x0>;
+					interrupt-parent = <&adc>;
+					interrupts = <0>;
+					dmas = <&dmamux1 9 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 
-			usb33: usb33 {
-				regulator-name = "usb33";
-				regulator-min-microvolt = <3300000>;
-				regulator-max-microvolt = <3300000>;
+				adc2: adc@100 {
+					compatible = "st,stm32mp1-adc";
+					#io-channel-cells = <1>;
+					reg = <0x100>;
+					interrupt-parent = <&adc>;
+					interrupts = <1>;
+					dmas = <&dmamux1 10 0x400 0x01>;
+					dma-names = "rx";
+					status = "disabled";
+				};
 			};
-		};
 
-		pwr_mcu: pwr_mcu@50001014 {
-			compatible = "st,stm32mp151-pwr-mcu", "syscon";
-			reg = <0x50001014 0x4>;
-		};
+			sdmmc3: mmc@48004000 {
+				compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
+				arm,primecell-periphid = <0x00253180>;
+				reg = <0x48004000 0x400>;
+				interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SDMMC3_K>;
+				clock-names = "apb_pclk";
+				resets = <&rcc SDMMC3_R>;
+				cap-sd-highspeed;
+				cap-mmc-highspeed;
+				max-frequency = <120000000>;
+				feature-domains = <&etzpc 86>;
+				status = "disabled";
+			};
+
+			usbotg_hs: usb-otg@49000000 {
+				compatible = "st,stm32mp15-hsotg", "snps,dwc2";
+				reg = <0x49000000 0x10000>;
+				clocks = <&rcc USBO_K>;
+				clock-names = "otg";
+				resets = <&rcc USBO_R>;
+				reset-names = "dwc2";
+				interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+				g-rx-fifo-size = <512>;
+				g-np-tx-fifo-size = <32>;
+				g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
+				dr_mode = "otg";
+				otg-rev = <0x200>;
+				usb33d-supply = <&usb33>;
+				feature-domains = <&etzpc 85>;
+				status = "disabled";
+			};
+
+			dcmi: dcmi@4c006000 {
+				compatible = "st,stm32-dcmi";
+				reg = <0x4c006000 0x400>;
+				interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
+				resets = <&rcc CAMITF_R>;
+				clocks = <&rcc DCMI>;
+				clock-names = "mclk";
+				dmas = <&dmamux1 75 0x400 0x01>;
+				dma-names = "tx";
+				feature-domains = <&etzpc 70>;
+				status = "disabled";
+			};
+
+			lptimer2: timer@50021000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-lptimer";
+				reg = <0x50021000 0x400>;
+				interrupts-extended = <&exti 48 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc LPTIM2_K>;
+				clock-names = "mux";
+				wakeup-source;
+				feature-domains = <&etzpc 64>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm-lp";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-		exti: interrupt-controller@5000d000 {
-			compatible = "st,stm32mp1-exti", "syscon";
-			interrupt-controller;
-			#interrupt-cells = <2>;
-			reg = <0x5000d000 0x400>;
-		};
+				trigger@1 {
+					compatible = "st,stm32-lptimer-trigger";
+					reg = <1>;
+					status = "disabled";
+				};
 
-		syscfg: syscon@50020000 {
-			compatible = "st,stm32mp157-syscfg", "syscon";
-			reg = <0x50020000 0x400>;
-			clocks = <&rcc SYSCFG>;
-		};
+				counter {
+					compatible = "st,stm32-lptimer-counter";
+					status = "disabled";
+				};
+			};
 
-		lptimer2: timer@50021000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-lptimer";
-			reg = <0x50021000 0x400>;
-			interrupts-extended = <&exti 48 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc LPTIM2_K>;
-			clock-names = "mux";
-			wakeup-source;
-			status = "disabled";
+			lptimer3: timer@50022000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "st,stm32-lptimer";
+				reg = <0x50022000 0x400>;
+				interrupts-extended = <&exti 50 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc LPTIM3_K>;
+				clock-names = "mux";
+				wakeup-source;
+				feature-domains = <&etzpc 65>;
+				status = "disabled";
+
+				pwm {
+					compatible = "st,stm32-pwm-lp";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 
-			pwm {
-				compatible = "st,stm32-pwm-lp";
-				#pwm-cells = <3>;
-				status = "disabled";
+				trigger@2 {
+					compatible = "st,stm32-lptimer-trigger";
+					reg = <2>;
+					status = "disabled";
+				};
 			};
 
-			trigger@1 {
-				compatible = "st,stm32-lptimer-trigger";
-				reg = <1>;
+			lptimer4: timer@50023000 {
+				compatible = "st,stm32-lptimer";
+				reg = <0x50023000 0x400>;
+				interrupts-extended = <&exti 52 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc LPTIM4_K>;
+				clock-names = "mux";
+				wakeup-source;
+				feature-domains = <&etzpc 66>;
 				status = "disabled";
-			};
 
-			counter {
-				compatible = "st,stm32-lptimer-counter";
-				status = "disabled";
+				pwm {
+					compatible = "st,stm32-pwm-lp";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 			};
-		};
-
-		lptimer3: timer@50022000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32-lptimer";
-			reg = <0x50022000 0x400>;
-			interrupts-extended = <&exti 50 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc LPTIM3_K>;
-			clock-names = "mux";
-			wakeup-source;
-			status = "disabled";
 
-			pwm {
-				compatible = "st,stm32-pwm-lp";
-				#pwm-cells = <3>;
+			lptimer5: timer@50024000 {
+				compatible = "st,stm32-lptimer";
+				reg = <0x50024000 0x400>;
+				interrupts-extended = <&exti 53 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc LPTIM5_K>;
+				clock-names = "mux";
+				wakeup-source;
+				feature-domains = <&etzpc 67>;
 				status = "disabled";
-			};
 
-			trigger@2 {
-				compatible = "st,stm32-lptimer-trigger";
-				reg = <2>;
-				status = "disabled";
+				pwm {
+					compatible = "st,stm32-pwm-lp";
+					#pwm-cells = <3>;
+					status = "disabled";
+				};
 			};
-		};
 
-		lptimer4: timer@50023000 {
-			compatible = "st,stm32-lptimer";
-			reg = <0x50023000 0x400>;
-			interrupts-extended = <&exti 52 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc LPTIM4_K>;
-			clock-names = "mux";
-			wakeup-source;
-			status = "disabled";
-
-			pwm {
-				compatible = "st,stm32-pwm-lp";
-				#pwm-cells = <3>;
+			vrefbuf: vrefbuf@50025000 {
+				compatible = "st,stm32-vrefbuf";
+				reg = <0x50025000 0x8>;
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <2500000>;
+				clocks = <&rcc VREF>;
+				feature-domains = <&etzpc 69>;
 				status = "disabled";
 			};
-		};
 
-		lptimer5: timer@50024000 {
-			compatible = "st,stm32-lptimer";
-			reg = <0x50024000 0x400>;
-			interrupts-extended = <&exti 53 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc LPTIM5_K>;
-			clock-names = "mux";
-			wakeup-source;
-			status = "disabled";
+			sai4: sai@50027000 {
+				compatible = "st,stm32h7-sai";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 0x50027000 0x400>;
+				reg = <0x50027000 0x4>, <0x500273f0 0x10>;
+				interrupts = <GIC_SPI 146 IRQ_TYPE_LEVEL_HIGH>;
+				resets = <&rcc SAI4_R>;
+				feature-domains = <&etzpc 68>;
+				status = "disabled";
+
+				sai4a: audio-controller@50027004 {
+					#sound-dai-cells = <0>;
+					compatible = "st,stm32-sai-sub-a";
+					reg = <0x04 0x20>;
+					clocks = <&rcc SAI4_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 99 0x400 0x01>;
+					status = "disabled";
+				};
 
-			pwm {
-				compatible = "st,stm32-pwm-lp";
-				#pwm-cells = <3>;
-				status = "disabled";
+				sai4b: audio-controller@50027024 {
+					#sound-dai-cells = <0>;
+					compatible = "st,stm32-sai-sub-b";
+					reg = <0x24 0x20>;
+					clocks = <&rcc SAI4_K>;
+					clock-names = "sai_ck";
+					dmas = <&dmamux1 100 0x400 0x01>;
+					status = "disabled";
+				};
 			};
-		};
 
-		vrefbuf: vrefbuf@50025000 {
-			compatible = "st,stm32-vrefbuf";
-			reg = <0x50025000 0x8>;
-			regulator-min-microvolt = <1500000>;
-			regulator-max-microvolt = <2500000>;
-			clocks = <&rcc VREF>;
-			status = "disabled";
-		};
-
-		sai4: sai@50027000 {
-			compatible = "st,stm32h7-sai";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0 0x50027000 0x400>;
-			reg = <0x50027000 0x4>, <0x500273f0 0x10>;
-			interrupts = <GIC_SPI 146 IRQ_TYPE_LEVEL_HIGH>;
-			resets = <&rcc SAI4_R>;
-			status = "disabled";
+			hash1: hash@54002000 {
+				compatible = "st,stm32f756-hash";
+				reg = <0x54002000 0x400>;
+				interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc HASH1>;
+				resets = <&rcc HASH1_R>;
+				dmas = <&mdma1 31 0x2 0x1000A02 0x0 0x0>;
+				dma-names = "in";
+				dma-maxburst = <2>;
+				feature-domains = <&etzpc 8>;
+				status = "disabled";
+			};
+
+			rng1: rng@54003000 {
+				compatible = "st,stm32-rng";
+				reg = <0x54003000 0x400>;
+				clocks = <&rcc RNG1_K>;
+				resets = <&rcc RNG1_R>;
+				feature-domains = <&etzpc 7>;
+				status = "disabled";
+			};
+
+			fmc: memory-controller@58002000 {
+				#address-cells = <2>;
+				#size-cells = <1>;
+				compatible = "st,stm32mp1-fmc2-ebi";
+				reg = <0x58002000 0x1000>;
+				clocks = <&rcc FMC_K>;
+				resets = <&rcc FMC_R>;
+				feature-domains = <&etzpc 91>;
+				status = "disabled";
+
+				ranges = <0 0 0x60000000 0x04000000>, /* EBI CS 1 */
+					 <1 0 0x64000000 0x04000000>, /* EBI CS 2 */
+					 <2 0 0x68000000 0x04000000>, /* EBI CS 3 */
+					 <3 0 0x6c000000 0x04000000>, /* EBI CS 4 */
+					 <4 0 0x80000000 0x10000000>; /* NAND */
+
+				nand-controller@4,0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible = "st,stm32mp1-fmc2-nfc";
+					reg = <4 0x00000000 0x1000>,
+					      <4 0x08010000 0x1000>,
+					      <4 0x08020000 0x1000>,
+					      <4 0x01000000 0x1000>,
+					      <4 0x09010000 0x1000>,
+					      <4 0x09020000 0x1000>;
+					interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+					dmas = <&mdma1 20 0x2 0x12000a02 0x0 0x0>,
+					       <&mdma1 20 0x2 0x12000a08 0x0 0x0>,
+					       <&mdma1 21 0x2 0x12000a0a 0x0 0x0>;
+					dma-names = "tx", "rx", "ecc";
+					status = "disabled";
+				};
+			};
 
-			sai4a: audio-controller@50027004 {
-				#sound-dai-cells = <0>;
-				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x20>;
-				clocks = <&rcc SAI4_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 99 0x400 0x01>;
-				status = "disabled";
+			qspi: spi@58003000 {
+				compatible = "st,stm32f469-qspi";
+				reg = <0x58003000 0x1000>, <0x70000000 0x10000000>;
+				reg-names = "qspi", "qspi_mm";
+				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
+				dmas = <&mdma1 22 0x2 0x10100002 0x0 0x0>,
+				       <&mdma1 22 0x2 0x10100008 0x0 0x0>;
+				dma-names = "tx", "rx";
+				clocks = <&rcc QSPI_K>;
+				resets = <&rcc QSPI_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				feature-domains = <&etzpc 92>;
+				status = "disabled";
+			};
+
+			ethernet0: ethernet@5800a000 {
+				compatible = "st,stm32mp1-dwmac", "snps,dwmac-4.20a";
+				reg = <0x5800a000 0x2000>;
+				reg-names = "stmmaceth";
+				interrupts-extended = <&intc GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "macirq";
+				clock-names = "stmmaceth",
+					      "mac-clk-tx",
+					      "mac-clk-rx",
+					      "eth-ck",
+					      "ptp_ref",
+					      "ethstp";
+				clocks = <&rcc ETHMAC>,
+					 <&rcc ETHTX>,
+					 <&rcc ETHRX>,
+					 <&rcc ETHCK_K>,
+					 <&rcc ETHPTP_K>,
+					 <&rcc ETHSTP>;
+				st,syscon = <&syscfg 0x4>;
+				snps,mixed-burst;
+				snps,pbl = <2>;
+				snps,en-tx-lpi-clockgating;
+				snps,axi-config = <&stmmac_axi_config_0>;
+				snps,tso;
+				feature-domains = <&etzpc 94>;
+				status = "disabled";
+
+				stmmac_axi_config_0: stmmac-axi-config {
+					snps,wr_osr_lmt = <0x7>;
+					snps,rd_osr_lmt = <0x7>;
+					snps,blen = <0 0 0 0 16 8 4>;
+				};
 			};
 
-			sai4b: audio-controller@50027024 {
-				#sound-dai-cells = <0>;
-				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x20>;
-				clocks = <&rcc SAI4_K>;
-				clock-names = "sai_ck";
-				dmas = <&dmamux1 100 0x400 0x01>;
+			usart1: serial@5c000000 {
+				compatible = "st,stm32h7-uart";
+				reg = <0x5c000000 0x400>;
+				interrupts-extended = <&exti 26 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc USART1_K>;
+				wakeup-source;
+				feature-domains = <&etzpc 3>;
 				status = "disabled";
 			};
-		};
 
-		dts: thermal@50028000 {
-			compatible = "st,stm32-thermal";
-			reg = <0x50028000 0x100>;
-			interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc TMPSENS>;
-			clock-names = "pclk";
-			#thermal-sensor-cells = <0>;
-			status = "disabled";
-		};
-
-		hash1: hash@54002000 {
-			compatible = "st,stm32f756-hash";
-			reg = <0x54002000 0x400>;
-			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc HASH1>;
-			resets = <&rcc HASH1_R>;
-			dmas = <&mdma1 31 0x2 0x1000A02 0x0 0x0>;
-			dma-names = "in";
-			dma-maxburst = <2>;
-			status = "disabled";
-		};
-
-		rng1: rng@54003000 {
-			compatible = "st,stm32-rng";
-			reg = <0x54003000 0x400>;
-			clocks = <&rcc RNG1_K>;
-			resets = <&rcc RNG1_R>;
-			status = "disabled";
-		};
-
-		mdma1: dma-controller@58000000 {
-			compatible = "st,stm32h7-mdma";
-			reg = <0x58000000 0x1000>;
-			interrupts = <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc MDMA>;
-			resets = <&rcc MDMA_R>;
-			#dma-cells = <5>;
-			dma-channels = <32>;
-			dma-requests = <48>;
-		};
-
-		fmc: memory-controller@58002000 {
-			#address-cells = <2>;
-			#size-cells = <1>;
-			compatible = "st,stm32mp1-fmc2-ebi";
-			reg = <0x58002000 0x1000>;
-			clocks = <&rcc FMC_K>;
-			resets = <&rcc FMC_R>;
-			status = "disabled";
-
-			ranges = <0 0 0x60000000 0x04000000>, /* EBI CS 1 */
-				 <1 0 0x64000000 0x04000000>, /* EBI CS 2 */
-				 <2 0 0x68000000 0x04000000>, /* EBI CS 3 */
-				 <3 0 0x6c000000 0x04000000>, /* EBI CS 4 */
-				 <4 0 0x80000000 0x10000000>; /* NAND */
-
-			nand-controller@4,0 {
+			spi6: spi@5c001000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-				compatible = "st,stm32mp1-fmc2-nfc";
-				reg = <4 0x00000000 0x1000>,
-				      <4 0x08010000 0x1000>,
-				      <4 0x08020000 0x1000>,
-				      <4 0x01000000 0x1000>,
-				      <4 0x09010000 0x1000>,
-				      <4 0x09020000 0x1000>;
-				interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
-				dmas = <&mdma1 20 0x2 0x12000a02 0x0 0x0>,
-				       <&mdma1 20 0x2 0x12000a08 0x0 0x0>,
-				       <&mdma1 21 0x2 0x12000a0a 0x0 0x0>;
-				dma-names = "tx", "rx", "ecc";
+				compatible = "st,stm32h7-spi";
+				reg = <0x5c001000 0x400>;
+				interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI6_K>;
+				resets = <&rcc SPI6_R>;
+				dmas = <&mdma1 34 0x0 0x40008 0x0 0x0>,
+				       <&mdma1 35 0x0 0x40002 0x0 0x0>;
+				feature-domains = <&etzpc 4>;
+				dma-names = "rx", "tx";
+				status = "disabled";
+			};
+
+			i2c4: i2c@5c002000 {
+				compatible = "st,stm32mp15-i2c";
+				reg = <0x5c002000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C4_K>;
+				resets = <&rcc I2C4_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				st,syscfg-fmp = <&syscfg 0x4 0x8>;
+				wakeup-source;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 5>;
 				status = "disabled";
 			};
-		};
-
-		qspi: spi@58003000 {
-			compatible = "st,stm32f469-qspi";
-			reg = <0x58003000 0x1000>, <0x70000000 0x10000000>;
-			reg-names = "qspi", "qspi_mm";
-			interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&mdma1 22 0x2 0x10100002 0x0 0x0>,
-			       <&mdma1 22 0x2 0x10100008 0x0 0x0>;
-			dma-names = "tx", "rx";
-			clocks = <&rcc QSPI_K>;
-			resets = <&rcc QSPI_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			status = "disabled";
-		};
-
-		sdmmc1: mmc@58005000 {
-			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
-			arm,primecell-periphid = <0x00253180>;
-			reg = <0x58005000 0x1000>;
-			interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SDMMC1_K>;
-			clock-names = "apb_pclk";
-			resets = <&rcc SDMMC1_R>;
-			cap-sd-highspeed;
-			cap-mmc-highspeed;
-			max-frequency = <120000000>;
-			status = "disabled";
-		};
-
-		sdmmc2: mmc@58007000 {
-			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
-			arm,primecell-periphid = <0x00253180>;
-			reg = <0x58007000 0x1000>;
-			interrupts = <GIC_SPI 124 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SDMMC2_K>;
-			clock-names = "apb_pclk";
-			resets = <&rcc SDMMC2_R>;
-			cap-sd-highspeed;
-			cap-mmc-highspeed;
-			max-frequency = <120000000>;
-			status = "disabled";
-		};
-
-		crc1: crc@58009000 {
-			compatible = "st,stm32f7-crc";
-			reg = <0x58009000 0x400>;
-			clocks = <&rcc CRC1>;
-			status = "disabled";
-		};
-
-		ethernet0: ethernet@5800a000 {
-			compatible = "st,stm32mp1-dwmac", "snps,dwmac-4.20a";
-			reg = <0x5800a000 0x2000>;
-			reg-names = "stmmaceth";
-			interrupts-extended = <&intc GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "macirq";
-			clock-names = "stmmaceth",
-				      "mac-clk-tx",
-				      "mac-clk-rx",
-				      "eth-ck",
-				      "ptp_ref",
-				      "ethstp";
-			clocks = <&rcc ETHMAC>,
-				 <&rcc ETHTX>,
-				 <&rcc ETHRX>,
-				 <&rcc ETHCK_K>,
-				 <&rcc ETHPTP_K>,
-				 <&rcc ETHSTP>;
-			st,syscon = <&syscfg 0x4>;
-			snps,mixed-burst;
-			snps,pbl = <2>;
-			snps,en-tx-lpi-clockgating;
-			snps,axi-config = <&stmmac_axi_config_0>;
-			snps,tso;
-			status = "disabled";
-
-			stmmac_axi_config_0: stmmac-axi-config {
-				snps,wr_osr_lmt = <0x7>;
-				snps,rd_osr_lmt = <0x7>;
-				snps,blen = <0 0 0 0 16 8 4>;
-			};
-		};
 
-		usbh_ohci: usb@5800c000 {
-			compatible = "generic-ohci";
-			reg = <0x5800c000 0x1000>;
-			clocks = <&usbphyc>, <&rcc USBH>;
-			resets = <&rcc USBH_R>;
-			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
-			status = "disabled";
-		};
-
-		usbh_ehci: usb@5800d000 {
-			compatible = "generic-ehci";
-			reg = <0x5800d000 0x1000>;
-			clocks = <&usbphyc>, <&rcc USBH>;
-			resets = <&rcc USBH_R>;
-			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
-			companion = <&usbh_ohci>;
-			status = "disabled";
-		};
-
-		ltdc: display-controller@5a001000 {
-			compatible = "st,stm32-ltdc";
-			reg = <0x5a001000 0x400>;
-			interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc LTDC_PX>;
-			clock-names = "lcd";
-			resets = <&rcc LTDC_R>;
-			status = "disabled";
-
-			port {
+			i2c6: i2c@5c009000 {
+				compatible = "st,stm32mp15-i2c";
+				reg = <0x5c009000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C6_K>;
+				resets = <&rcc I2C6_R>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				st,syscfg-fmp = <&syscfg 0x4 0x20>;
+				wakeup-source;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 12>;
+				status = "disabled";
 			};
-		};
-
-		iwdg2: watchdog@5a002000 {
-			compatible = "st,stm32mp1-iwdg";
-			reg = <0x5a002000 0x400>;
-			clocks = <&rcc IWDG2>, <&rcc CK_LSI>;
-			clock-names = "pclk", "lsi";
-			status = "disabled";
-		};
-
-		usbphyc: usbphyc@5a006000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			#clock-cells = <0>;
-			compatible = "st,stm32mp1-usbphyc";
-			reg = <0x5a006000 0x1000>;
-			clocks = <&rcc USBPHY_K>;
-			resets = <&rcc USBPHY_R>;
-			vdda1v1-supply = <&reg11>;
-			vdda1v8-supply = <&reg18>;
-			status = "disabled";
-
-			usbphyc_port0: usb-phy@0 {
-				#phy-cells = <0>;
-				reg = <0>;
-			};
-
-			usbphyc_port1: usb-phy@1 {
-				#phy-cells = <1>;
-				reg = <1>;
-			};
-		};
-
-		usart1: serial@5c000000 {
-			compatible = "st,stm32h7-uart";
-			reg = <0x5c000000 0x400>;
-			interrupts-extended = <&exti 26 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc USART1_K>;
-			wakeup-source;
-			status = "disabled";
-		};
-
-		spi6: spi@5c001000 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "st,stm32h7-spi";
-			reg = <0x5c001000 0x400>;
-			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI6_K>;
-			resets = <&rcc SPI6_R>;
-			dmas = <&mdma1 34 0x0 0x40008 0x0 0x0>,
-			       <&mdma1 35 0x0 0x40002 0x0 0x0>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
-
-		i2c4: i2c@5c002000 {
-			compatible = "st,stm32mp15-i2c";
-			reg = <0x5c002000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C4_K>;
-			resets = <&rcc I2C4_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			st,syscfg-fmp = <&syscfg 0x4 0x8>;
-			wakeup-source;
-			i2c-analog-filter;
-			status = "disabled";
-		};
-
-		rtc: rtc@5c004000 {
-			compatible = "st,stm32mp1-rtc";
-			reg = <0x5c004000 0x400>;
-			clocks = <&rcc RTCAPB>, <&rcc RTC>;
-			clock-names = "pclk", "rtc_ck";
-			interrupts-extended = <&exti 19 IRQ_TYPE_LEVEL_HIGH>;
-			status = "disabled";
-		};
-
-		bsec: efuse@5c005000 {
-			compatible = "st,stm32mp15-bsec";
-			reg = <0x5c005000 0x400>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ts_cal1: calib@5c {
-				reg = <0x5c 0x2>;
-			};
-			ts_cal2: calib@5e {
-				reg = <0x5e 0x2>;
-			};
-		};
 
-		i2c6: i2c@5c009000 {
-			compatible = "st,stm32mp15-i2c";
-			reg = <0x5c009000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C6_K>;
-			resets = <&rcc I2C6_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			st,syscfg-fmp = <&syscfg 0x4 0x20>;
-			wakeup-source;
-			i2c-analog-filter;
-			status = "disabled";
 		};
 
 		tamp: tamp@5c00a000 {
diff --git a/arch/arm/boot/dts/stm32mp153.dtsi b/arch/arm/boot/dts/stm32mp153.dtsi
index 486084e0b80b..82073dd85f18 100644
--- a/arch/arm/boot/dts/stm32mp153.dtsi
+++ b/arch/arm/boot/dts/stm32mp153.dtsi
@@ -28,32 +28,34 @@ timer {
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>;
 	};
+};
 
-	soc {
-		m_can1: can@4400e000 {
-			compatible = "bosch,m_can";
-			reg = <0x4400e000 0x400>, <0x44011000 0x1400>;
-			reg-names = "m_can", "message_ram";
-			interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "int0", "int1";
-			clocks = <&rcc CK_HSE>, <&rcc FDCAN_K>;
-			clock-names = "hclk", "cclk";
-			bosch,mram-cfg = <0x0 0 0 32 0 0 2 2>;
-			status = "disabled";
-		};
+&etzpc {
+	m_can1: can@4400e000 {
+		compatible = "bosch,m_can";
+		reg = <0x4400e000 0x400>, <0x44011000 0x1400>;
+		reg-names = "m_can", "message_ram";
+		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "int0", "int1";
+		clocks = <&rcc CK_HSE>, <&rcc FDCAN_K>;
+		clock-names = "hclk", "cclk";
+		bosch,mram-cfg = <0x0 0 0 32 0 0 2 2>;
+		feature-domains = <&etzpc 62>;
+		status = "disabled";
+	};
 
-		m_can2: can@4400f000 {
-			compatible = "bosch,m_can";
-			reg = <0x4400f000 0x400>, <0x44011000 0x2800>;
-			reg-names = "m_can", "message_ram";
-			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "int0", "int1";
-			clocks = <&rcc CK_HSE>, <&rcc FDCAN_K>;
-			clock-names = "hclk", "cclk";
-			bosch,mram-cfg = <0x1400 0 0 32 0 0 2 2>;
-			status = "disabled";
-		};
+	m_can2: can@4400f000 {
+		compatible = "bosch,m_can";
+		reg = <0x4400f000 0x400>, <0x44011000 0x2800>;
+		reg-names = "m_can", "message_ram";
+		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "int0", "int1";
+		clocks = <&rcc CK_HSE>, <&rcc FDCAN_K>;
+		clock-names = "hclk", "cclk";
+		bosch,mram-cfg = <0x1400 0 0 32 0 0 2 2>;
+		feature-domains = <&etzpc 62>;
+		status = "disabled";
 	};
 };
diff --git a/arch/arm/boot/dts/stm32mp15xc.dtsi b/arch/arm/boot/dts/stm32mp15xc.dtsi
index b06a55a2fa18..55524a8d3093 100644
--- a/arch/arm/boot/dts/stm32mp15xc.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xc.dtsi
@@ -4,15 +4,14 @@
  * Author: Alexandre Torgue <alexandre.torgue@st.com> for STMicroelectronics.
  */
 
-/ {
-	soc {
-		cryp1: cryp@54001000 {
-			compatible = "st,stm32mp1-cryp";
-			reg = <0x54001000 0x400>;
-			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc CRYP1>;
-			resets = <&rcc CRYP1_R>;
-			status = "disabled";
-		};
+&etzpc {
+	cryp1: cryp@54001000 {
+		compatible = "st,stm32mp1-cryp";
+		reg = <0x54001000 0x400>;
+		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&rcc CRYP1>;
+		resets = <&rcc CRYP1_R>;
+		feature-domains = <&etzpc 9>;
+		status = "disabled";
 	};
 };
-- 
2.35.3

