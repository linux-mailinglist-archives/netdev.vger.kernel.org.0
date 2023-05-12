Return-Path: <netdev+bounces-2030-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 537AD70002C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1894B1C21011
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4568137E;
	Fri, 12 May 2023 06:17:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5B3A54
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:17:16 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98D135B6
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:17:11 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-966400ee79aso1279559566b.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683872230; x=1686464230;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oriS0DN+i/XkrLJU3BOOHCPTaT1RtyvyROOw8SiZ0TU=;
        b=aUu0yyjhkogXFRswX7PMhcm9AeHjlrcZbCoLkqWPLMk1+8uA5rWk2AJir/phIGoScR
         rdf99eiqerApmAni7Oq201Y/qMXGXCvRvxyOP5mHn38Kzi/zG/vwFFUA2dKiv3gxCEGs
         RieWNt3uvI9alcZoaD1JIGdF+ElWNbSnYfKiJ/JqInzua5Q5Z+jBKnzKQiPtSFXY8z6S
         S8pIE0ioAG+PaGKhnxhNqPiWQRopDbhZ8P1yNDVUMoVmBKPovOo+SmmGmHvK8l7ljslb
         9KZFfvZ1FGGfphVpnyjoVn8VvQiAU6SwwiFhUY8spgeirF646jWOpglre5aVyYJKIrhM
         8h3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683872230; x=1686464230;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oriS0DN+i/XkrLJU3BOOHCPTaT1RtyvyROOw8SiZ0TU=;
        b=Of/cooq5UmfJV2dF8R3sOJB4DNzqMtkU+VGGXhYUHBhJJZ7pspNvIz9dHb4O1Zwcd9
         p/SvzYZEVTdJKJsnTrNHN6GRUw0NPs6OOAtX0X0T51ksRmmdZCS4mRWS3pPPynw6Szvn
         TccCHhJtREYQCZxX5DLeZbryirNy4q5K3tZI6MtSXUGvRGgjXePXU615tPRSHoRI/ZSx
         T1ibxlHblu4GJGKwfFWQbgjbbh+eBwr6AkTjc+3u58XXqTZj+399Eyyt8NROvTrHSGtK
         deTzk/2RDsHBp6lbSdLYWgxCAj9whhwQYCClJmBatWsrZr0D+Z261VYlg/qGGMkPuTym
         rE4A==
X-Gm-Message-State: AC+VfDwqNFef7OqE9ymfWPDtkIBsub8TXtf0Kv5MkNT6WWy3hAEdLLSA
	r/BM9JMBLVxSbMKM5NMmU0pDyg==
X-Google-Smtp-Source: ACHHUZ6KXpOMSXIZVaIH5T2NkcdP3dvF6wo5arZl4pvUWW/Oe5yjwEfcPx2MMaPLi7XfMAGL8nOHeg==
X-Received: by 2002:a17:907:d91:b0:933:4d37:82b2 with SMTP id go17-20020a1709070d9100b009334d3782b2mr21560958ejc.57.1683872229872;
        Thu, 11 May 2023 23:17:09 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:1a6d:ae16:f7ca:fbfc? ([2a02:810d:15c0:828:1a6d:ae16:f7ca:fbfc])
        by smtp.gmail.com with ESMTPSA id gc9-20020a1709072b0900b0094f49f58019sm4951463ejc.27.2023.05.11.23.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 23:17:09 -0700 (PDT)
Message-ID: <e24e877e-4065-35b4-bbd2-edbbc694edf6@linaro.org>
Date: Fri, 12 May 2023 08:17:08 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] arm64: dts: imx8mm: add support for compulab iot gateway
Content-Language: en-US
To: Parthiban Nallathambi <parthiban@linumiz.com>, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
 s.hauer@pengutronix.de
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
References: <20230512055230.811421-1-parthiban@linumiz.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230512055230.811421-1-parthiban@linumiz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/05/2023 07:52, Parthiban Nallathambi wrote:
> Add support for compulab for imx8mm IoT gateway with
> UCM-iMX8M-Mini SoM. IoT gateway comes with dual ethernet,
> USB and IO expansion.
> 
> WLAN, Bluetooth can be part of SoM or extended over PCIE.
> 
> Signed-off-by: Parthiban Nallathambi <parthiban@linumiz.com>
> ---
>  .../devicetree/bindings/arm/fsl.yaml          |   2 +
>  .../bindings/net/microchip,lan95xx.yaml       |   1 +
>  arch/arm64/boot/dts/freescale/Makefile        |   1 +
>  .../freescale/imx8mm-compulab-iot-gate.dts    | 315 +++++++++++
>  .../dts/freescale/imx8mm-compulab-ucm.dtsi    | 532 ++++++++++++++++++
>  5 files changed, 851 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi
> 
> diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
> index 15d411084065..d2425c5ed4b7 100644
> --- a/Documentation/devicetree/bindings/arm/fsl.yaml
> +++ b/Documentation/devicetree/bindings/arm/fsl.yaml
> @@ -895,6 +895,8 @@ properties:
>        - description: i.MX8MM based Boards
>          items:
>            - enum:
> +              - compulab,imx8mm-ucm-som   # UCM-iMX8M-Mini Compulab SoM
> +              - compulab,iot-gate-imx8    # iMX8M IoT Compulab Gateway with UCM-iMX8M-Mini

Bindings are always separate patches.

Please run scripts/checkpatch.pl and fix reported warnings. Checkpatch
tells you this, so you apparently did not run it.


>                - beacon,imx8mm-beacon-kit  # i.MX8MM Beacon Development Kit
>                - boundary,imx8mm-nitrogen8mm  # i.MX8MM Nitrogen Board
>                - dmo,imx8mm-data-modul-edm-sbc # i.MX8MM eDM SBC
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> index 0b97e14d947f..86279724695e 100644
> --- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> +++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> @@ -22,6 +22,7 @@ properties:
>        - enum:
>            - usb424,9500   # SMSC9500 USB Ethernet Device
>            - usb424,9505   # SMSC9505 USB Ethernet Device
> +          - usb424,9514   # SMSC9514 USB Ethernet Device

No, really, I could understand squashing board bindings here but
changing drivers in the same patch is clearly too much.

>            - usb424,9530   # SMSC LAN9530 USB Ethernet Device
>            - usb424,9730   # SMSC LAN9730 USB Ethernet Device
>            - usb424,9900   # SMSC9500 USB Ethernet Device (SAL10)
> diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
> index ef7d17aef58f..2a613c576d29 100644
> --- a/arch/arm64/boot/dts/freescale/Makefile
> +++ b/arch/arm64/boot/dts/freescale/Makefile
> @@ -51,6 +51,7 @@ dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-qds-9999.dtb
>  
>  dtb-$(CONFIG_ARCH_MXC) += imx8dxl-evk.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8mm-beacon-kit.dtb
> +dtb-$(CONFIG_ARCH_MXC) += imx8mm-compulab-iot-gate.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8mm-data-modul-edm-sbc.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8mm-ddr4-evk.dtb
>  dtb-$(CONFIG_ARCH_MXC) += imx8mm-emcon-avari.dtb
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts b/arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts
> new file mode 100644
> index 000000000000..678a9022549f
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-compulab-iot-gate.dts
> @@ -0,0 +1,315 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * Copyright 2018 Compulab
> + */
> +
> +/dts-v1/;
> +
> +#include "imx8mm-compulab-ucm.dtsi"
> +
> +/ {
> +	model = "CompuLab IOT-GATE-iMX8 board";
> +	compatible = "compulab,iot-gate-imx8", "compulab,imx8mm-ucm-som", "fsl,imx8mm";
> +
> +	regulator-usbhub-ena {
> +		compatible = "regulator-fixed";
> +		regulator-name = "usbhub_ena";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio4 28 GPIO_ACTIVE_HIGH>;
> +		regulator-always-on;
> +		enable-active-high;
> +	};
> +
> +	regulator-usbhub-rst {
> +		compatible = "regulator-fixed";
> +		regulator-name = "usbhub_rst";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio3 24 GPIO_ACTIVE_HIGH>;
> +		regulator-always-on;
> +		enable-active-high;
> +	};
> +
> +	regulator-uart1-mode {
> +		compatible = "regulator-fixed";
> +		regulator-name = "uart1_mode";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio4 26 GPIO_ACTIVE_HIGH>;
> +		enable-active-high;
> +		regulator-always-on;
> +	};
> +
> +	regulator-uart1-duplex {
> +		compatible = "regulator-fixed";
> +		regulator-name = "uart1_duplex";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio4 27 GPIO_ACTIVE_HIGH>;
> +		regulator-always-on;
> +		enable-active-high;
> +	};
> +
> +	regulator-uart1-shdn {
> +		compatible = "regulator-fixed";
> +		regulator-name = "uart1_shdn";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio5 5 GPIO_ACTIVE_HIGH>;
> +		regulator-always-on;
> +		enable-active-high;
> +	};
> +
> +	regulator-uart1-trmen {
> +		compatible = "regulator-fixed";
> +		regulator-name = "uart1_trmen";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio4 25 GPIO_ACTIVE_LOW>;
> +		regulator-always-on;
> +		enable-active-low;
> +	};
> +
> +	regulator-usdhc2_v {

No underscores in node names. Fix it everywhere.

> +		compatible = "regulator-fixed";
> +		regulator-name = "usdhc2_v";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio1 4 GPIO_ACTIVE_HIGH>;
> +		regulator-always-on;
> +		enable-active-high;
> +	};
> +
> +	reg_usdhc2_rst: regulator-usdhc2_rst {
> +		compatible = "regulator-fixed";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_reg_usdhc2_rst>;
> +		regulator-name = "usdhc2_rst";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio2 19 GPIO_ACTIVE_HIGH>;
> +		startup-delay-us = <100>;
> +		off-on-delay-us = <12000>;
> +		enable-active-high;
> +	};
> +
> +	regulator-mpcie2_rst {
> +		compatible = "regulator-fixed";
> +		regulator-name = "mpcie2_rst";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio3 22 GPIO_ACTIVE_HIGH>;
> +		regulator-always-on;
> +		enable-active-high;
> +	};
> +
> +	regulator-mpcie2lora_dis {
> +		compatible = "regulator-fixed";
> +		regulator-name = "mpcie2lora_dis";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio3 21 GPIO_ACTIVE_HIGH>;
> +		regulator-always-on;
> +		enable-active-high;
> +	};
> +
> +	pcie0_refclk: pcie0-refclk {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <100000000>;
> +	};
> +};
> +
> +&ethphy0 {
> +	status = "okay";
> +};
> +
> +&fec1 {
> +	status = "okay";
> +};
> +
> +&uart1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_uart1 &pinctrl_uart1_gpio>;
> +	assigned-clocks = <&clk IMX8MM_CLK_UART1>;
> +	assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
> +	linux,rs485-enabled-at-boot-time;
> +	rts-gpios = <&gpio4 24 GPIO_ACTIVE_LOW>;
> +	status = "okay";
> +};
> +
> +&uart4 {
> +	status = "disabled";
> +};
> +
> +&i2c1 {
> +	clock-frequency = <100000>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_i2c1>;
> +	status = "okay";
> +
> +	eeprom@54 {
> +		compatible = "atmel,24c08";
> +		reg = <0x54>;
> +		pagesize = <16>;
> +	};
> +};
> +
> +&ecspi1 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	fsl,spi-num-chipselects = <1>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_ecspi1 &pinctrl_ecspi1_cs>;
> +	cs-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
> +	status = "okay";
> +};
> +
> +&usbotg1 {
> +	dr_mode = "host";
> +	disable-over-current;
> +	status = "okay";
> +};
> +
> +&usbotg2 {
> +	dr_mode = "host";
> +	disable-over-current;
> +	status = "okay";
> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	usb9514@1 {

Node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation

> +		compatible = "usb424,9514";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_usb9514>;
> +		reg = <1>;

reg is always after compatible.

> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		ethernet: usbether@1 {
> +			compatible = "usb424,ec00";
> +			reg = <1>;
> +		};
> +	};
> +};
> +
> +&usdhc1 {
> +	status = "disabled";
> +};
> +
> +&usdhc2 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_usdhc2>;
> +	bus-width = <4>;
> +	mmc-ddr-1_8v;
> +	non-removable;
> +	vmmc-supply = <&reg_usdhc2_rst>;
> +	status = "okay";
> +};
> +
> +&pcie0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_pcie0>;
> +	reset-gpio = <&gpio3 20 GPIO_ACTIVE_LOW>;
> +	clocks = <&clk IMX8MM_CLK_PCIE1_ROOT>,
> +		 <&clk IMX8MM_CLK_PCIE1_AUX>,
> +		 <&clk IMX8MM_CLK_PCIE1_PHY>,
> +		 <&pcie0_refclk>;
> +	clock-names = "pcie", "pcie_aux", "pcie_phy", "pcie_bus";
> +	assigned-clocks = <&clk IMX8MM_CLK_PCIE1_AUX>,
> +			  <&clk IMX8MM_CLK_PCIE1_PHY>,
> +			  <&clk IMX8MM_CLK_PCIE1_CTRL>;
> +	assigned-clock-rates = <10000000>, <100000000>, <250000000>;
> +	assigned-clock-parents = <&clk IMX8MM_SYS_PLL2_50M>,
> +				 <&clk IMX8MM_SYS_PLL2_100M>,
> +				 <&clk IMX8MM_SYS_PLL2_250M>;
> +	ext_osc = <1>;
> +	status = "disabled";
> +};
> +
> +&iomuxc {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_hog_sb_iotgimx8>;
> +
> +	sb-iotgimx8 {
> +		pinctrl_hog_sb_iotgimx8: hoggrp_sb-iotgimx8 {

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).

> +			fsl,pins = <
> +				/* mPCIe2 */
> +				MX8MM_IOMUXC_SAI5_RXD0_GPIO3_IO21	0x140 /* LORA_DISABLE */
> +				MX8MM_IOMUXC_SAI5_RXD1_GPIO3_IO22	0x140 /* PERSTn */
> +			>;
> +		};
> +
> +		pinctrl_uart1: uart1grp {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_SAI2_RXC_UART1_DCE_RX	0x140
> +				MX8MM_IOMUXC_SAI2_RXFS_UART1_DCE_TX	0x140
> +				MX8MM_IOMUXC_SAI2_TXFS_GPIO4_IO24	0x140 /* RTS */
> +				MX8MM_IOMUXC_SAI2_RXD0_UART1_DCE_RTS_B	0x140 /* CTS */
> +			>;
> +		};
> +
> +		pinctrl_uart1_gpio: uart1gpiogrp {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_SAI2_TXD0_GPIO4_IO26	0x000 /* RS_485_232_SEL */
> +				MX8MM_IOMUXC_SAI2_MCLK_GPIO4_IO27	0x140 /* RS_485_H/F_SEL */
> +				MX8MM_IOMUXC_SPDIF_EXT_CLK_GPIO5_IO5	0x140 /* SHDN */
> +				MX8MM_IOMUXC_SAI2_TXC_GPIO4_IO25	0x140 /* RS_485_TRMEN */
> +			>;
> +		};
> +
> +		pinctrl_i2c1: i2c1grp {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_I2C1_SCL_I2C1_SCL		0x400001c3
> +				MX8MM_IOMUXC_I2C1_SDA_I2C1_SDA		0x400001c3
> +			>;
> +		};
> +
> +		pinctrl_ecspi1: ecspi1grp {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_ECSPI1_SCLK_ECSPI1_SCLK	0x82
> +				MX8MM_IOMUXC_ECSPI1_MOSI_ECSPI1_MOSI	0x82
> +				MX8MM_IOMUXC_ECSPI1_MISO_ECSPI1_MISO	0x82
> +			>;
> +		};
> +
> +		pinctrl_ecspi1_cs: ecspi1cs {

Does not look like you tested the DTS against bindings. Please run `make
dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
for instructions).

I guess you did not test it at all.

> +			fsl,pins = <
> +				MX8MM_IOMUXC_ECSPI1_SS0_GPIO5_IO9	0x40000
> +			>;
> +		};
> +
> +		pinctrl_usb9514: usb9514grp {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_SAI3_RXFS_GPIO4_IO28	0x140 /* USB_PS_EN */
> +				MX8MM_IOMUXC_SAI5_RXD3_GPIO3_IO24	0x140 /* HUB_RSTn */
> +			>;
> +		};
> +
> +		pinctrl_usdhc2: usdhc2grp {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x190
> +				MX8MM_IOMUXC_SD2_CMD_USDHC2_CMD		0x1d0
> +				MX8MM_IOMUXC_SD2_DATA0_USDHC2_DATA0	0x1d0
> +				MX8MM_IOMUXC_SD2_DATA1_USDHC2_DATA1	0x1d0
> +				MX8MM_IOMUXC_SD2_DATA2_USDHC2_DATA2	0x1d0
> +				MX8MM_IOMUXC_SD2_DATA3_USDHC2_DATA3	0x1d0
> +				MX8MM_IOMUXC_GPIO1_IO04_GPIO1_IO4	0x1d0 /* SD2_VSEL */
> +			>;
> +		};
> +
> +		pinctrl_reg_usdhc2_rst: usdhc2rst {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_SD2_RESET_B_GPIO2_IO19	0x41  /* EMMC_RST */
> +			>;
> +		};
> +
> +		pinctrl_pcie0: pcie0grp {
> +			fsl,pins = <
> +				MX8MM_IOMUXC_SAI5_RXC_GPIO3_IO20	0x140
> +			>;
> +		};
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi
> new file mode 100644
> index 000000000000..d6cdf833744e
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-compulab-ucm.dtsi
> @@ -0,0 +1,532 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * Copyright 2018 Compulab
> + */
> +
> +#include "imx8mm.dtsi"
> +
> +/ {
> +	model = "Compulab i.MX8M-Mini UCM SoM";
> +	compatible = "compulab,imx8mm-ucm-som", "fsl,imx8mm";
> +
> +	aliases {
> +		rtc0 = &rtc0;
> +		rtc1 = &snvs_rtc;
> +	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_gpio_led>;
> +
> +		heartbeat-led {
> +			label = "Heartbeat";
> +			gpios = <&gpio1 12 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "heartbeat";
> +		};
> +	};
> +
> +	pmic_osc: clock-pmic {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <32768>;
> +		clock-output-names = "pmic_osc";
> +	};
> +
> +	reg_ethphy: regulator-ethphy {
> +		compatible = "regulator-fixed";
> +		enable-active-high;
> +		gpio = <&gpio1 10 GPIO_ACTIVE_HIGH>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_reg_eth>;
> +		regulator-always-on;
> +		regulator-boot-on;
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		regulator-name = "On-module +V3.3_ETH";
> +		startup-delay-us = <500>;
> +	};
> +
> +	reg_usdhc3_vmmc: regulator-usdhc3-vmmc {
> +		compatible = "regulator-fixed";
> +		enable-active-high;
> +		gpio = <&gpio3 16 GPIO_ACTIVE_HIGH>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_reg_usdhc3>;
> +		regulator-always-on;
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		regulator-name = "On-module +V3.3_USDHC";
> +	};
> +
> +	usdhc1_pwrseq: usdhc1_pwrseq {
> +		compatible = "mmc-pwrseq-simple";
> +		reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
> +	};
> +};
> +
> +&fec1 {
> +	fsl,magic-packet;
> +	fsl,rgmii_rxc_dly;
> +	phy-handle = <&ethphy0>;
> +	phy-mode = "rgmii-id";
> +	phy-supply = <&reg_ethphy>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_fec1>;
> +
> +	mdio {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		ethphy0: ethernet-phy@0 {
> +			compatible = "ethernet-phy-ieee802.3-c22";
> +			micrel,led-mode = <0>;
> +			reg = <0>;
> +		};
> +	};
> +};
> +
> +&i2c2 {
> +	clock-frequency = <400000>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_i2c2>;
> +	status = "okay";
> +
> +	rtc0: rtc@69 {
> +		compatible = "abracon,ab1805";
> +		reg = <0x69>;
> +	};
> +
> +	pmic: bd71837@4b {

Node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation



Best regards,
Krzysztof


