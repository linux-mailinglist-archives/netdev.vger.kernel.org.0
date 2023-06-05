Return-Path: <netdev+bounces-7866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 277E3721E4A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0D4828118E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEC45251;
	Mon,  5 Jun 2023 06:40:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FE9523C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:40:34 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DCDE58
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:40:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51492ae66a4so6365138a12.1
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 23:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685947198; x=1688539198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FXHVHrdnhMEbfWrm3tLBKKiNRn9gVxjnaREvLTdi7TU=;
        b=dqK3Ce9LNeUgw/UwiHERKTBZiHwFA/xgakPq22QkcI0rrbcmKriuJfK9lSdbOwsEdR
         qeGr0NTJDJnr+snzJF2ZFeC5UTBCnAvGY2N/NigrboTBV+y8UwRTG07i3dZApToSGTUC
         3loNyh8DLg/LB3kTU9rIgBV+s2wApAogHO9jVczUaGJNPVxWvyUsAgJgkyG1uYTB78vj
         9hUAcC2NoM/q0qu2QtOOGJrLIhSoRQcBBQwOBqgTLg3hOJMYeZSrkDfEH4/RjXE8aK9e
         XzCTSGivhFgwj2JRPN3SqCeDSWnQk49B5F4urpHsAW3QMUKA9upkr+N1Q0wsh2Va4YkH
         kjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685947198; x=1688539198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXHVHrdnhMEbfWrm3tLBKKiNRn9gVxjnaREvLTdi7TU=;
        b=VRKbRUG7HxE3qqbFCAnFtaAW5Of61t2YE0QJFDmTiAmA2JZg5j68UhOgYRYHsY2vb9
         Ra7zETlkOBoGUQBeriPFy99TyDm8NUIv/SK+OwBO3YGsC+Qs0FAVyyrUMC5CC+wYq0a6
         QT6VFTtPbR3X1EngrruQpGAS/NVG6adb2QrnPL6VfMX5lvaPEXc3OgucdjE+vIQTpwca
         WKrnufrNI6gSsQUos6+TZXYThlk5A+jcYtPxPq+HSNtsj2t732WNeP2UL7RPF1dvTBwe
         FRq8T7Pn/tdcTdJ5WRkax0lo9ZiuYolgF6PArELw+aQsCQD3unzWF8Ke7NMu00dYEYeH
         Bg+w==
X-Gm-Message-State: AC+VfDzwl5OCtFJh9K9eI2HbEJR3FKmC1Qh3eil8i6kl2xfEyHaqNJv1
	89n9Z+xy2l1U6dk+Oafd56EkTw==
X-Google-Smtp-Source: ACHHUZ7fp7C0NWj7qg7r+T9Clo8b1dg/Pu19e2QMO6IFkk5g1zr+oaoIUx2tOwnaRygvYt/mxax3nQ==
X-Received: by 2002:aa7:c543:0:b0:514:a452:3f5 with SMTP id s3-20020aa7c543000000b00514a45203f5mr6102706edr.32.1685947198432;
        Sun, 04 Jun 2023 23:39:58 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id b17-20020aa7cd11000000b005083bc605f9sm3533133edw.72.2023.06.04.23.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 23:39:58 -0700 (PDT)
Message-ID: <939efed2-521b-baef-2776-7bf937efe3ff@linaro.org>
Date: Mon, 5 Jun 2023 08:39:54 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 04/21] ARM: dts: at91: sam9x7: add device tree for soc
Content-Language: en-US
To: Varshini Rajendran <varshini.rajendran@microchip.com>,
 tglx@linutronix.de, maz@kernel.org, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.beznea@microchip.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, gregkh@linuxfoundation.org,
 linux@armlinux.org.uk, mturquette@baylibre.com, sboyd@kernel.org,
 sre@kernel.org, broonie@kernel.org, arnd@arndb.de,
 gregory.clement@bootlin.com, sudeep.holla@arm.com,
 balamanikandan.gunasundar@microchip.com, mihai.sain@microchip.com,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
 durai.manickamkr@microchip.com, manikandan.m@microchip.com,
 dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
 balakrishnan.s@microchip.com
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-5-varshini.rajendran@microchip.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230603200243.243878-5-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03/06/2023 22:02, Varshini Rajendran wrote:
> Add device tree file for SAM9X7 SoC family
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> [nicolas.ferre@microchip.com: add support for gmac to sam9x7]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> [balamanikandan.gunasundar@microchip.com: Add device node csi2host and isc]
> Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
> ---
>  arch/arm/boot/dts/sam9x7.dtsi | 1333 +++++++++++++++++++++++++++++++++
>  1 file changed, 1333 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sam9x7.dtsi
> 
> diff --git a/arch/arm/boot/dts/sam9x7.dtsi b/arch/arm/boot/dts/sam9x7.dtsi
> new file mode 100644
> index 000000000000..f98160182fe6
> --- /dev/null
> +++ b/arch/arm/boot/dts/sam9x7.dtsi
> @@ -0,0 +1,1333 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * sam9x7.dtsi - Device Tree Include file for Microchip SAM9X7 SoC family
> + *
> + * Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries
> + *
> + * Author: Varshini Rajendran <varshini.rajendran@microchip.com>
> + */
> +
> +#include <dt-bindings/clock/at91.h>
> +#include <dt-bindings/dma/at91.h>
> +#include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/mfd/atmel-flexcom.h>
> +#include <dt-bindings/pinctrl/at91.h>
> +
> +/ {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	model = "Microchip SAM9X7 SoC";
> +	compatible = "microchip,sam9x7";
> +	interrupt-parent = <&aic>;
> +
> +	aliases {
> +		serial0 = &dbgu;
> +		gpio0 = &pioA;
> +		gpio1 = &pioB;
> +		gpio2 = &pioC;
> +		gpio3 = &pioD;
> +	};
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			compatible = "arm,arm926ej-s";
> +			device_type = "cpu";
> +			reg = <0>;
> +		};
> +	};
> +
> +	clocks {
> +		slow_xtal: slow_xtal {

No underscores in node names. Use some common prefix or suffix, e.g. clock-

> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +		};
> +
> +		main_xtal: main_xtal {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +		};
> +	};
> +
> +	sram: sram@300000 {
> +		compatible = "mmio-sram";
> +		reg = <0x300000 0x10000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0x300000 0x10000>;
> +	};
> +
> +	ahb {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		usb0: gadget@500000 {
> +			compatible = "microchip,sam9x60-udc";

Aren't you missing specific compatible? This applies everywhere.

> +			reg = <0x500000 0x100000>,
> +			      <0xf803c000 0x400>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			interrupts = <23 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 23>, <&pmc PMC_TYPE_CORE PMC_UTMI>;
> +			clock-names = "pclk", "hclk";
> +			assigned-clocks = <&pmc PMC_TYPE_CORE PMC_UTMI>;
> +			assigned-clock-rates = <480000000>;
> +			status = "disabled";
> +		};
> +
> +		ohci0: usb@600000 {
> +			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
> +			reg = <0x600000 0x100000>;
> +			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 22>, <&pmc PMC_TYPE_PERIPHERAL 22>, <&pmc PMC_TYPE_SYSTEM 6>;
> +			clock-names = "ohci_clk", "hclk", "uhpck";
> +			status = "disabled";
> +		};
> +
> +		ehci0: usb@700000 {
> +			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
> +			reg = <0x700000 0x100000>;
> +			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&pmc PMC_TYPE_CORE PMC_UTMI>, <&pmc PMC_TYPE_PERIPHERAL 22>;
> +			clock-names = "usb_clk", "ehci_clk";
> +			assigned-clocks = <&pmc PMC_TYPE_CORE PMC_UTMI>;
> +			assigned-clock-rates = <480000000>;
> +			status = "disabled";
> +		};
> +
> +		sdmmc0: sdio-host@80000000 {

Are you sure you have no dtbs_check warnings for this?

> +			compatible = "microchip,sam9x60-sdhci";
> +			reg = <0x80000000 0x300>;
> +			interrupts = <12 IRQ_TYPE_LEVEL_HIGH 0>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 12>, <&pmc PMC_TYPE_GCK 12>;
> +			clock-names = "hclock", "multclk";
> +			assigned-clocks = <&pmc PMC_TYPE_GCK 12>;
> +			assigned-clock-rates = <100000000>;
> +			status = "disabled";
> +		};
> +
> +		sdmmc1: sdio-host@90000000 {
> +			compatible = "microchip,sam9x60-sdhci";
> +			reg = <0x90000000 0x300>;
> +			interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 26>, <&pmc PMC_TYPE_GCK 26>;
> +			clock-names = "hclock", "multclk";
> +			assigned-clocks = <&pmc PMC_TYPE_GCK 26>;
> +			assigned-clock-rates = <100000000>;
> +			status = "disabled";
> +		};
> +	};
> +
> +	apb {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		flx4: flexcom@f0000000 {
> +			compatible = "atmel,sama5d2-flexcom";
> +			reg = <0xf0000000 0x200>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 13>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0x0 0xf0000000 0x800>;
> +			status = "disabled";
> +
> +			uart4: serial@200 {
> +				compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
> +				reg = <0x200 0x200>;
> +				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 7>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(8))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(9))>;
> +				dma-names = "tx", "rx";
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 13>;
> +				clock-names = "usart";
> +				atmel,use-dma-rx;
> +				atmel,use-dma-tx;
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +
> +			spi4: spi@400 {
> +				compatible = "microchip,sam9x60-spi", "atmel,at91rm9200-spi";
> +				reg = <0x400 0x200>;
> +				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 13>;
> +				clock-names = "spi_clk";
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(8))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(9))>;
> +				dma-names = "tx", "rx";
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +
> +			i2c4: i2c@600 {
> +				compatible = "microchip,sam9x60-i2c";
> +				reg = <0x600 0x200>;
> +				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 13>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(8))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(9))>;
> +				dma-names = "tx", "rx";
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		flx5: flexcom@f0004000 {
> +			compatible = "atmel,sama5d2-flexcom";
> +			reg = <0xf0004000 0x200>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 14>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0x0 0xf0004000 0x800>;
> +			status = "disabled";
> +
> +			uart5: serial@200 {
> +				compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
> +				reg = <0x200 0x200>;
> +				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 7>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(10))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(11))>;
> +				dma-names = "tx", "rx";
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 14>;
> +				clock-names = "usart";
> +				atmel,use-dma-rx;
> +				atmel,use-dma-tx;
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +
> +			spi5: spi@400 {
> +				compatible = "microchip,sam9x60-spi", "atmel,at91rm9200-spi";
> +				reg = <0x400 0x200>;
> +				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 14>;
> +				clock-names = "spi_clk";
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(10))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(11))>;
> +				dma-names = "tx", "rx";
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +
> +			i2c5: i2c@600 {
> +				compatible = "microchip,sam9x60-i2c";
> +				reg = <0x600 0x200>;
> +				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 14>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(10))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(11))>;
> +				dma-names = "tx", "rx";
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		dma0: dma-controller@f0008000 {
> +			compatible = "microchip,sam9x60-dma", "atmel,sama5d4-dma";
> +			reg = <0xf0008000 0x1000>;
> +			interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
> +			#dma-cells = <1>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 20>;
> +			clock-names = "dma_clk";
> +			status = "disabled";
> +		};
> +
> +		ssc: ssc@f0010000 {
> +			compatible = "atmel,at91sam9g45-ssc";
> +			reg = <0xf0010000 0x4000>;
> +			interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
> +			dmas = <&dma0
> +				(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
> +				 AT91_XDMAC_DT_PERID(38))>,
> +			       <&dma0
> +				(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
> +				 AT91_XDMAC_DT_PERID(39))>;
> +			dma-names = "tx", "rx";
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 28>;
> +			clock-names = "pclk";
> +		};
> +
> +		gpu: gfx2d@f0018000 {
> +			compatible = "microchip,sam9x60-gfx2d";
> +			reg = <0xf0018000 0x4000>;
> +			interrupts = <36 IRQ_TYPE_LEVEL_HIGH 0>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 36>;
> +			clock-names = "periph_clk";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			status = "disabled";
> +		};
> +
> +		i2s: i2s@f001c000 {
> +			compatible = "microchip,sam9x60-i2smcc";
> +			reg = <0xf001c000 0x100>;
> +			interrupts = <34 IRQ_TYPE_LEVEL_HIGH 7>;
> +			dmas = <&dma0
> +				(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
> +				 AT91_XDMAC_DT_PERID(36))>,
> +			       <&dma0
> +				(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
> +				 AT91_XDMAC_DT_PERID(37))>;
> +			dma-names = "tx", "rx";
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 34>, <&pmc PMC_TYPE_GCK 34>;
> +			clock-names = "pclk", "gclk";
> +			status = "disabled";
> +		};
> +
> +		flx11: flexcom@f0020000 {
> +			compatible = "atmel,sama5d2-flexcom";
> +			reg = <0xf0020000 0x200>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 32>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0x0 0xf0020000 0x800>;
> +			status = "disabled";
> +
> +			uart11: serial@200 {
> +				compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
> +				reg = <0x200 0x200>;
> +				interrupts = <32 IRQ_TYPE_LEVEL_HIGH 7>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(22))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(23))>;
> +				dma-names = "tx", "rx";
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 32>;
> +				clock-names = "usart";
> +				atmel,use-dma-rx;
> +				atmel,use-dma-tx;
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +
> +			i2c11: i2c@600 {
> +				compatible = "microchip,sam9x60-i2c";
> +				reg = <0x600 0x200>;
> +				interrupts = <32 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 32>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(22))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(23))>;
> +				dma-names = "tx", "rx";
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		flx12: flexcom@f0024000 {
> +			compatible = "atmel,sama5d2-flexcom";
> +			reg = <0xf0024000 0x200>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 33>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0x0 0xf0024000 0x800>;
> +			status = "disabled";
> +
> +			uart12: serial@200 {
> +				compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
> +				reg = <0x200 0x200>;
> +				interrupts = <33 IRQ_TYPE_LEVEL_HIGH 7>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(24))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(25))>;
> +				dma-names = "tx", "rx";
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 33>;
> +				clock-names = "usart";
> +				atmel,use-dma-rx;
> +				atmel,use-dma-tx;
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +
> +			i2c12: i2c@600 {
> +				compatible = "microchip,sam9x60-i2c";
> +				reg = <0x600 0x200>;
> +				interrupts = <33 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&pmc PMC_TYPE_PERIPHERAL 33>;
> +				dmas = <&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(24))>,
> +					<&dma0
> +					(AT91_XDMAC_DT_MEM_IF(0) |
> +					 AT91_XDMAC_DT_PER_IF(1) |
> +					 AT91_XDMAC_DT_PERID(25))>;
> +				dma-names = "tx", "rx";
> +				atmel,fifo-size = <16>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		pit64b0: timer@f0028000 {
> +			compatible = "microchip,sam9x60-pit64b";
> +			reg = <0xf0028000 0x100>;
> +			interrupts = <37 IRQ_TYPE_LEVEL_HIGH 7>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 37>, <&pmc PMC_TYPE_GCK 37>;
> +			clock-names = "pclk", "gclk";
> +		};
> +
> +		sha: sha@f002c000 {
> +			compatible = "atmel,at91sam9g46-sha";
> +			reg = <0xf002c000 0x100>;
> +			interrupts = <41 IRQ_TYPE_LEVEL_HIGH 0>;
> +			dmas = <&dma0
> +				(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
> +				 AT91_XDMAC_DT_PERID(34))>;
> +			dma-names = "tx";
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 41>;
> +			clock-names = "sha_clk";
> +		};
> +
> +		trng: trng@f0030000 {

rng@

> +			compatible = "microchip,sam9x60-trng";
> +			reg = <0xf0030000 0x100>;
> +			interrupts = <38 IRQ_TYPE_LEVEL_HIGH 0>;
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 38>;
> +			status = "disabled";
> +		};
> +
> +		aes: aes@f0034000 {

crypto@

> +			compatible = "atmel,at91sam9g46-aes";
> +			reg = <0xf0034000 0x100>;
> +			interrupts = <39 IRQ_TYPE_LEVEL_HIGH 0>;
> +			dmas = <&dma0
> +				(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
> +				 AT91_XDMAC_DT_PERID(32))>,
> +			       <&dma0
> +				(AT91_XDMAC_DT_MEM_IF(0) | AT91_XDMAC_DT_PER_IF(1) |
> +				 AT91_XDMAC_DT_PERID(33))>;
> +			dma-names = "tx", "rx";
> +			clocks = <&pmc PMC_TYPE_PERIPHERAL 39>;
> +			clock-names = "aes_clk";
> +		};
> +
> +		tdes: tdes@f0038000 {

crypto@


Best regards,
Krzysztof


