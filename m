Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEF267EB5A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjA0Qos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjA0Qop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:44:45 -0500
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F23CC0C;
        Fri, 27 Jan 2023 08:44:18 -0800 (PST)
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RFZpgU028393;
        Fri, 27 Jan 2023 17:42:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=selector1;
 bh=39CmuaRiQV2oMpqVUtJXqUnoKhKh39S3vJDPoAytyz4=;
 b=N9GLjDoylDKpUGnW6foL52SE9GH/h25Q6DapZS3xvxDVDsw5PMVVRz6CFHFVeh9TFhc/
 QX5msD8+e56VIM/OqSloLhE4CMUZHZ0peDIwmETgZkVUy3x82AmIkQoSui3G6vlIj89v
 CwQoOt+rtdUclV//xHRvW4UDRm97oipKWpWuHilRpOgVGMLfZLD6HJmpmfT2wOETW2FS
 l6b3iqwItltpTiShwOZl/L/SOfAwzKKsg8L0urVzH9rRhLt3cYC5Bk/5j5vpLjOk0dk0
 uXl/U4frdlKrl67eWJmNqgF2SdG885AYOtgG3gISeByPQcGbaP/ThIr6l8aQCs+41Tcx Cw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3n89chdbbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 17:42:37 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B6D3D10002A;
        Fri, 27 Jan 2023 17:42:36 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id AEC5721ED24;
        Fri, 27 Jan 2023 17:42:36 +0100 (CET)
Received: from localhost (10.201.21.177) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.13; Fri, 27 Jan
 2023 17:42:36 +0100
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
Subject: [PATCH v3 6/6] ARM: dts: stm32: add ETZPC as a system bus for STM32MP13x boards
Date:   Fri, 27 Jan 2023 17:40:40 +0100
Message-ID: <20230127164040.1047583-7-gatien.chevallier@foss.st.com>
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
the STM32MP13 reference manual.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---

No changes in V2.

Changes in V3:
	-Use appriopriate node name: bus

 arch/arm/boot/dts/stm32mp131.dtsi  | 407 +++++++++++++++--------------
 arch/arm/boot/dts/stm32mp133.dtsi  |  51 ++--
 arch/arm/boot/dts/stm32mp13xc.dtsi |  19 +-
 arch/arm/boot/dts/stm32mp13xf.dtsi |  18 +-
 4 files changed, 258 insertions(+), 237 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp131.dtsi b/arch/arm/boot/dts/stm32mp131.dtsi
index accc3824f7e9..24462a647101 100644
--- a/arch/arm/boot/dts/stm32mp131.dtsi
+++ b/arch/arm/boot/dts/stm32mp131.dtsi
@@ -253,148 +253,6 @@ dmamux1: dma-router@48002000 {
 			dma-channels = <16>;
 		};
 
-		adc_2: adc@48004000 {
-			compatible = "st,stm32mp13-adc-core";
-			reg = <0x48004000 0x400>;
-			interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc ADC2>, <&rcc ADC2_K>;
-			clock-names = "bus", "adc";
-			interrupt-controller;
-			#interrupt-cells = <1>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			status = "disabled";
-
-			adc2: adc@0 {
-				compatible = "st,stm32mp13-adc";
-				#io-channel-cells = <1>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-				reg = <0x0>;
-				interrupt-parent = <&adc_2>;
-				interrupts = <0>;
-				dmas = <&dmamux1 10 0x400 0x80000001>;
-				dma-names = "rx";
-				status = "disabled";
-
-				channel@13 {
-					reg = <13>;
-					label = "vrefint";
-				};
-				channel@14 {
-					reg = <14>;
-					label = "vddcore";
-				};
-				channel@16 {
-					reg = <16>;
-					label = "vddcpu";
-				};
-				channel@17 {
-					reg = <17>;
-					label = "vddq_ddr";
-				};
-			};
-		};
-
-		usbotg_hs: usb@49000000 {
-			compatible = "st,stm32mp15-hsotg", "snps,dwc2";
-			reg = <0x49000000 0x40000>;
-			clocks = <&rcc USBO_K>;
-			clock-names = "otg";
-			resets = <&rcc USBO_R>;
-			reset-names = "dwc2";
-			interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
-			g-rx-fifo-size = <512>;
-			g-np-tx-fifo-size = <32>;
-			g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
-			dr_mode = "otg";
-			otg-rev = <0x200>;
-			usb33d-supply = <&usb33>;
-			status = "disabled";
-		};
-
-		spi4: spi@4c002000 {
-			compatible = "st,stm32h7-spi";
-			reg = <0x4c002000 0x400>;
-			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI4_K>;
-			resets = <&rcc SPI4_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			dmas = <&dmamux1 83 0x400 0x01>,
-			       <&dmamux1 84 0x400 0x01>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
-
-		spi5: spi@4c003000 {
-			compatible = "st,stm32h7-spi";
-			reg = <0x4c003000 0x400>;
-			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SPI5_K>;
-			resets = <&rcc SPI5_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			dmas = <&dmamux1 85 0x400 0x01>,
-			       <&dmamux1 86 0x400 0x01>;
-			dma-names = "rx", "tx";
-			status = "disabled";
-		};
-
-		i2c3: i2c@4c004000 {
-			compatible = "st,stm32mp13-i2c";
-			reg = <0x4c004000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C3_K>;
-			resets = <&rcc I2C3_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			dmas = <&dmamux1 73 0x400 0x1>,
-			       <&dmamux1 74 0x400 0x1>;
-			dma-names = "rx", "tx";
-			st,syscfg-fmp = <&syscfg 0x4 0x4>;
-			i2c-analog-filter;
-			status = "disabled";
-		};
-
-		i2c4: i2c@4c005000 {
-			compatible = "st,stm32mp13-i2c";
-			reg = <0x4c005000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C4_K>;
-			resets = <&rcc I2C4_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			dmas = <&dmamux1 75 0x400 0x1>,
-			       <&dmamux1 76 0x400 0x1>;
-			dma-names = "rx", "tx";
-			st,syscfg-fmp = <&syscfg 0x4 0x8>;
-			i2c-analog-filter;
-			status = "disabled";
-		};
-
-		i2c5: i2c@4c006000 {
-			compatible = "st,stm32mp13-i2c";
-			reg = <0x4c006000 0x400>;
-			interrupt-names = "event", "error";
-			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc I2C5_K>;
-			resets = <&rcc I2C5_R>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			dmas = <&dmamux1 115 0x400 0x1>,
-			       <&dmamux1 116 0x400 0x1>;
-			dma-names = "rx", "tx";
-			st,syscfg-fmp = <&syscfg 0x4 0x10>;
-			i2c-analog-filter;
-			status = "disabled";
-		};
-
 		rcc: rcc@50000000 {
 			compatible = "st,stm32mp13-rcc", "syscon";
 			reg = <0x50000000 0x1000>;
@@ -431,34 +289,6 @@ mdma: dma-controller@58000000 {
 			dma-requests = <48>;
 		};
 
-		sdmmc1: mmc@58005000 {
-			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
-			arm,primecell-periphid = <0x20253180>;
-			reg = <0x58005000 0x1000>, <0x58006000 0x1000>;
-			interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SDMMC1_K>;
-			clock-names = "apb_pclk";
-			resets = <&rcc SDMMC1_R>;
-			cap-sd-highspeed;
-			cap-mmc-highspeed;
-			max-frequency = <130000000>;
-			status = "disabled";
-		};
-
-		sdmmc2: mmc@58007000 {
-			compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
-			arm,primecell-periphid = <0x20253180>;
-			reg = <0x58007000 0x1000>, <0x58008000 0x1000>;
-			interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc SDMMC2_K>;
-			clock-names = "apb_pclk";
-			resets = <&rcc SDMMC2_R>;
-			cap-sd-highspeed;
-			cap-mmc-highspeed;
-			max-frequency = <130000000>;
-			status = "disabled";
-		};
-
 		usbh_ohci: usb@5800c000 {
 			compatible = "generic-ohci";
 			reg = <0x5800c000 0x1000>;
@@ -486,29 +316,6 @@ iwdg2: watchdog@5a002000 {
 			status = "disabled";
 		};
 
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
 		rtc: rtc@5c004000 {
 			compatible = "st,stm32mp1-rtc";
 			reg = <0x5c004000 0x400>;
@@ -536,6 +343,220 @@ ts_cal2: calib@5e {
 			};
 		};
 
+		etzpc: bus@5c007000 {
+			compatible = "st,stm32mp13-sys-bus";
+			reg = <0x5c007000 0x400>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			feature-domain-controller;
+			#feature-domain-cells = <1>;
+			ranges;
+
+			adc_2: adc@48004000 {
+				compatible = "st,stm32mp13-adc-core";
+				reg = <0x48004000 0x400>;
+				interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc ADC2>, <&rcc ADC2_K>;
+				clock-names = "bus", "adc";
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				feature-domains = <&etzpc 33>;
+				status = "disabled";
+
+				adc2: adc@0 {
+					compatible = "st,stm32mp13-adc";
+					#io-channel-cells = <1>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					reg = <0x0>;
+					interrupt-parent = <&adc_2>;
+					interrupts = <0>;
+					dmas = <&dmamux1 10 0x400 0x80000001>;
+					dma-names = "rx";
+					status = "disabled";
+
+					channel@13 {
+						reg = <13>;
+						label = "vrefint";
+					};
+					channel@14 {
+						reg = <14>;
+						label = "vddcore";
+					};
+					channel@16 {
+						reg = <16>;
+						label = "vddcpu";
+					};
+					channel@17 {
+						reg = <17>;
+						label = "vddq_ddr";
+					};
+				};
+			};
+
+			usbotg_hs: usb@49000000 {
+				compatible = "st,stm32mp15-hsotg", "snps,dwc2";
+				reg = <0x49000000 0x40000>;
+				clocks = <&rcc USBO_K>;
+				clock-names = "otg";
+				resets = <&rcc USBO_R>;
+				reset-names = "dwc2";
+				interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+				g-rx-fifo-size = <512>;
+				g-np-tx-fifo-size = <32>;
+				g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
+				dr_mode = "otg";
+				otg-rev = <0x200>;
+				usb33d-supply = <&usb33>;
+				feature-domains = <&etzpc 34>;
+				status = "disabled";
+			};
+
+			spi4: spi@4c002000 {
+				compatible = "st,stm32h7-spi";
+				reg = <0x4c002000 0x400>;
+				interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI4_K>;
+				resets = <&rcc SPI4_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				dmas = <&dmamux1 83 0x400 0x01>,
+				       <&dmamux1 84 0x400 0x01>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 18>;
+				status = "disabled";
+			};
+
+			spi5: spi@4c003000 {
+				compatible = "st,stm32h7-spi";
+				reg = <0x4c003000 0x400>;
+				interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SPI5_K>;
+				resets = <&rcc SPI5_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				dmas = <&dmamux1 85 0x400 0x01>,
+				       <&dmamux1 86 0x400 0x01>;
+				dma-names = "rx", "tx";
+				feature-domains = <&etzpc 19>;
+				status = "disabled";
+			};
+
+			i2c3: i2c@4c004000 {
+				compatible = "st,stm32mp13-i2c";
+				reg = <0x4c004000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C3_K>;
+				resets = <&rcc I2C3_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				dmas = <&dmamux1 73 0x400 0x1>,
+				       <&dmamux1 74 0x400 0x1>;
+				dma-names = "rx", "tx";
+				st,syscfg-fmp = <&syscfg 0x4 0x4>;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 20>;
+				status = "disabled";
+			};
+
+			i2c4: i2c@4c005000 {
+				compatible = "st,stm32mp13-i2c";
+				reg = <0x4c005000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C4_K>;
+				resets = <&rcc I2C4_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				dmas = <&dmamux1 75 0x400 0x1>,
+				       <&dmamux1 76 0x400 0x1>;
+				dma-names = "rx", "tx";
+				st,syscfg-fmp = <&syscfg 0x4 0x8>;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 21>;
+				status = "disabled";
+			};
+
+			i2c5: i2c@4c006000 {
+				compatible = "st,stm32mp13-i2c";
+				reg = <0x4c006000 0x400>;
+				interrupt-names = "event", "error";
+				interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
+					     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc I2C5_K>;
+				resets = <&rcc I2C5_R>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				dmas = <&dmamux1 115 0x400 0x1>,
+				       <&dmamux1 116 0x400 0x1>;
+				dma-names = "rx", "tx";
+				st,syscfg-fmp = <&syscfg 0x4 0x10>;
+				i2c-analog-filter;
+				feature-domains = <&etzpc 22>;
+				status = "disabled";
+			};
+
+			sdmmc1: mmc@58005000 {
+				compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
+				arm,primecell-periphid = <0x20253180>;
+				reg = <0x58005000 0x1000>, <0x58006000 0x1000>;
+				interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SDMMC1_K>;
+				clock-names = "apb_pclk";
+				resets = <&rcc SDMMC1_R>;
+				cap-sd-highspeed;
+				cap-mmc-highspeed;
+				max-frequency = <130000000>;
+				feature-domains = <&etzpc 50>;
+				status = "disabled";
+			};
+
+			sdmmc2: mmc@58007000 {
+				compatible = "st,stm32-sdmmc2", "arm,pl18x", "arm,primecell";
+				arm,primecell-periphid = <0x20253180>;
+				reg = <0x58007000 0x1000>, <0x58008000 0x1000>;
+				interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&rcc SDMMC2_K>;
+				clock-names = "apb_pclk";
+				resets = <&rcc SDMMC2_R>;
+				cap-sd-highspeed;
+				cap-mmc-highspeed;
+				max-frequency = <130000000>;
+				feature-domains = <&etzpc 51>;
+				status = "disabled";
+			};
+
+			usbphyc: usbphyc@5a006000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				#clock-cells = <0>;
+				compatible = "st,stm32mp1-usbphyc";
+				reg = <0x5a006000 0x1000>;
+				clocks = <&rcc USBPHY_K>;
+				resets = <&rcc USBPHY_R>;
+				vdda1v1-supply = <&reg11>;
+				vdda1v8-supply = <&reg18>;
+				feature-domains = <&etzpc 5>;
+				status = "disabled";
+
+				usbphyc_port0: usb-phy@0 {
+					#phy-cells = <0>;
+					reg = <0>;
+				};
+
+				usbphyc_port1: usb-phy@1 {
+					#phy-cells = <1>;
+					reg = <1>;
+				};
+			};
+
+		};
+
 		/*
 		 * Break node order to solve dependency probe issue between
 		 * pinctrl and exti.
diff --git a/arch/arm/boot/dts/stm32mp133.dtsi b/arch/arm/boot/dts/stm32mp133.dtsi
index df451c3c2a26..be6061552683 100644
--- a/arch/arm/boot/dts/stm32mp133.dtsi
+++ b/arch/arm/boot/dts/stm32mp133.dtsi
@@ -33,35 +33,38 @@ m_can2: can@4400f000 {
 			bosch,mram-cfg = <0x1400 0 0 32 0 0 2 2>;
 			status = "disabled";
 		};
+	};
+};
 
-		adc_1: adc@48003000 {
-			compatible = "st,stm32mp13-adc-core";
-			reg = <0x48003000 0x400>;
-			interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc ADC1>, <&rcc ADC1_K>;
-			clock-names = "bus", "adc";
-			interrupt-controller;
-			#interrupt-cells = <1>;
+&etzpc {
+	adc_1: adc@48003000 {
+		compatible = "st,stm32mp13-adc-core";
+		reg = <0x48003000 0x400>;
+		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&rcc ADC1>, <&rcc ADC1_K>;
+		clock-names = "bus", "adc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		feature-domains = <&etzpc 32>;
+		status = "disabled";
+
+		adc1: adc@0 {
+			compatible = "st,stm32mp13-adc";
+			#io-channel-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			reg = <0x0>;
+			interrupt-parent = <&adc_1>;
+			interrupts = <0>;
+			dmas = <&dmamux1 9 0x400 0x80000001>;
+			dma-names = "rx";
 			status = "disabled";
 
-			adc1: adc@0 {
-				compatible = "st,stm32mp13-adc";
-				#io-channel-cells = <1>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-				reg = <0x0>;
-				interrupt-parent = <&adc_1>;
-				interrupts = <0>;
-				dmas = <&dmamux1 9 0x400 0x80000001>;
-				dma-names = "rx";
-				status = "disabled";
-
-				channel@18 {
-					reg = <18>;
-					label = "vrefint";
-				};
+			channel@18 {
+				reg = <18>;
+				label = "vrefint";
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/stm32mp13xc.dtsi b/arch/arm/boot/dts/stm32mp13xc.dtsi
index 4d00e7592882..a1a7a40c2a3e 100644
--- a/arch/arm/boot/dts/stm32mp13xc.dtsi
+++ b/arch/arm/boot/dts/stm32mp13xc.dtsi
@@ -4,15 +4,14 @@
  * Author: Alexandre Torgue <alexandre.torgue@foss.st.com> for STMicroelectronics.
  */
 
-/ {
-	soc {
-		cryp: crypto@54002000 {
-			compatible = "st,stm32mp1-cryp";
-			reg = <0x54002000 0x400>;
-			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc CRYP1>;
-			resets = <&rcc CRYP1_R>;
-			status = "disabled";
-		};
+&etzpc {
+	cryp: crypto@54002000 {
+		compatible = "st,stm32mp1-cryp";
+		reg = <0x54002000 0x400>;
+		interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&rcc CRYP1>;
+		resets = <&rcc CRYP1_R>;
+		feature-domains = <&etzpc 42>;
+		status = "disabled";
 	};
 };
diff --git a/arch/arm/boot/dts/stm32mp13xf.dtsi b/arch/arm/boot/dts/stm32mp13xf.dtsi
index 4d00e7592882..b9fb071a1471 100644
--- a/arch/arm/boot/dts/stm32mp13xf.dtsi
+++ b/arch/arm/boot/dts/stm32mp13xf.dtsi
@@ -4,15 +4,13 @@
  * Author: Alexandre Torgue <alexandre.torgue@foss.st.com> for STMicroelectronics.
  */
 
-/ {
-	soc {
-		cryp: crypto@54002000 {
-			compatible = "st,stm32mp1-cryp";
-			reg = <0x54002000 0x400>;
-			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc CRYP1>;
-			resets = <&rcc CRYP1_R>;
-			status = "disabled";
-		};
+&etzpc {
+	cryp: crypto@54002000 {
+		compatible = "st,stm32mp1-cryp";
+		reg = <0x54002000 0x400>;
+		interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&rcc CRYP1>;
+		resets = <&rcc CRYP1_R>;
+		status = "disabled";
 	};
 };
-- 
2.35.3

