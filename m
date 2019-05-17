Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26CA2118B
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 03:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfEQBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 21:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfEQBFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 21:05:34 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1990E206BF;
        Fri, 17 May 2019 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558055133;
        bh=Eg4Xg+bGB5hNj+YaIcs4eXthYP4ERQYZLl2oaJ2INLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iq3jbFIO4S3np4qR1FlYgagpviIHVuHePQYyx+86DPxdzq6wC70GXoxPcOAYKC0jf
         hutlRCJUO5w0KY1R0ovk0Bg8DbDLTqqIX+Pvyp6JFeIWpbLgnI3a+kvHKqTLalmwVg
         y89JKD6iKYXfZe9OYoAhrgBg8snEv+WPdybguyEU=
Date:   Fri, 17 May 2019 09:04:52 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Introduce the NXP LS1021A-TSN board
Message-ID: <20190517010450.GT15856@dragon>
References: <20190506010800.2433-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506010800.2433-1-olteanv@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 04:08:00AM +0300, Vladimir Oltean wrote:
> The LS1021A-TSN is a development board built by VVDN/Argonboards in
> partnership with NXP.
> 
> It features the LS1021A SoC and the first-generation SJA1105T Ethernet
> switch for prototyping implementations of a subset of IEEE 802.1 TSN
> standards.
> 
> It has two regular Ethernet ports and four switched, TSN-capable ports.
> 
> It also features:
> - One Arduino header
> - One expansion header
> - Two USB 3.0 ports
> - One mini PCIe slot
> - One SATA interface
> - Accelerometer, gyroscope, temperature sensors
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  arch/arm/boot/dts/Makefile        |   3 +-
>  arch/arm/boot/dts/ls1021a-tsn.dts | 238 ++++++++++++++++++++++++++++++
>  2 files changed, 240 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/ls1021a-tsn.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index f4f5aeaf3298..529f0150f6b4 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -593,7 +593,8 @@ dtb-$(CONFIG_SOC_IMX7ULP) += \
>  dtb-$(CONFIG_SOC_LS1021A) += \
>  	ls1021a-moxa-uc-8410a.dtb \
>  	ls1021a-qds.dtb \
> -	ls1021a-twr.dtb
> +	ls1021a-twr.dtb \
> +	ls1021a-tsn.dtb

Please keep the list alphabetically sorted.  That said, ls1021a-tsn.dtb
should go prior to ls1021a-twr.dtb.

>  dtb-$(CONFIG_SOC_VF610) += \
>  	vf500-colibri-eval-v3.dtb \
>  	vf610-bk4.dtb \
> diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
> new file mode 100644
> index 000000000000..5269486699bd
> --- /dev/null
> +++ b/arch/arm/boot/dts/ls1021a-tsn.dts
> @@ -0,0 +1,238 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright 2016-2018 NXP Semiconductors
> + * Copyright 2019 Vladimir Oltean <olteanv@gmail.com>
> + */
> +
> +/dts-v1/;
> +#include "ls1021a.dtsi"
> +
> +/ {
> +	model = "NXP LS1021A-TSN Board";
> +
> +	sys_mclk: clock-mclk {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <24576000>;
> +	};
> +
> +	regulators {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <0>;

This is the old style of organizing fixed regulators, which has been
complained by device tree maintainers.  Drop this container node and put
the regulator nodes directly under root, using name schema below.

	reg_xxx: regulator-xxx {
		...
	};

And thus, 'reg' property in regulator node should be dropped.

> +
> +		reg_3p3v: regulator@0 {
> +			compatible = "regulator-fixed";
> +			reg = <0>;
> +			regulator-name = "3P3V";
> +			regulator-min-microvolt = <3300000>;
> +			regulator-max-microvolt = <3300000>;
> +			regulator-always-on;
> +		};
> +		reg_2p5v: regulator@1 {
> +			compatible = "regulator-fixed";
> +			reg = <1>;
> +			regulator-name = "2P5V";
> +			regulator-min-microvolt = <2500000>;
> +			regulator-max-microvolt = <2500000>;
> +			regulator-always-on;
> +		};
> +	};
> +};
> +
> +&enet0 {
> +	tbi-handle = <&tbi0>;
> +	phy-handle = <&sgmii_phy2>;
> +	phy-mode = "sgmii";
> +	status = "ok";

For sake of consistency, we prefer to use "okay".

> +};
> +
> +&enet1 {
> +	tbi-handle = <&tbi1>;
> +	phy-handle = <&sgmii_phy1>;
> +	phy-mode = "sgmii";
> +	status = "ok";
> +};
> +
> +/* RGMII delays added via PCB traces */
> +&enet2 {
> +	phy-mode = "rgmii";
> +	status = "ok";

Please have a newline between property list and child node.

> +	fixed-link {
> +		speed = <1000>;
> +		full-duplex;
> +	};
> +};
> +
> +&dspi0 {

Please sort these labeled nodes alphabetically.

> +	bus-num = <0>;
> +	status = "ok";
> +
> +	/* ADG704BRMZ 1:4 mux/demux */
> +	tsn_switch: sja1105@1 {

Use a generic node name, while label name can be specific.

> +		reg = <0x1>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "nxp,sja1105t";

Undocumented compatible?

> +		/* 12 MHz */
> +		spi-max-frequency = <12000000>;
> +		/* Sample data on trailing clock edge */
> +		spi-cpha;
> +		fsl,spi-cs-sck-delay = <1000>;
> +		fsl,spi-sck-cs-delay = <1000>;

Have a newline.

> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;

Ditto

> +			port@0 {
> +				/* ETH5 written on chassis */
> +				label = "swp5";
> +				phy-handle = <&rgmii_phy6>;
> +				phy-mode = "rgmii-id";
> +				reg = <0>;
> +			};

Please have a newline between nodes as well.

> +			port@1 {
> +				/* ETH2 written on chassis */
> +				label = "swp2";
> +				phy-handle = <&rgmii_phy3>;
> +				phy-mode = "rgmii-id";
> +				reg = <1>;
> +			};
> +			port@2 {
> +				/* ETH3 written on chassis */
> +				label = "swp3";
> +				phy-handle = <&rgmii_phy4>;
> +				phy-mode = "rgmii-id";
> +				reg = <2>;
> +			};
> +			port@3 {
> +				/* ETH4 written on chassis */
> +				phy-handle = <&rgmii_phy5>;
> +				label = "swp4";
> +				phy-mode = "rgmii-id";
> +				reg = <3>;
> +			};
> +			port@4 {
> +				/* Internal port connected to eth2 */
> +				ethernet = <&enet2>;
> +				phy-mode = "rgmii";
> +				reg = <4>;
> +				fixed-link {
> +					speed = <1000>;
> +					full-duplex;
> +				};
> +			};
> +		};
> +	};
> +};
> +
> +&mdio0 {
> +	/* AR8031 */
> +	sgmii_phy1: ethernet-phy@1 {
> +		reg = <0x1>;
> +	};
> +	/* AR8031 */
> +	sgmii_phy2: ethernet-phy@2 {
> +		reg = <0x2>;
> +	};
> +	/* BCM5464 */
> +	rgmii_phy3: ethernet-phy@3 {
> +		reg = <0x3>;
> +	};
> +	rgmii_phy4: ethernet-phy@4 {
> +		reg = <0x4>;
> +	};
> +	rgmii_phy5: ethernet-phy@5 {
> +		reg = <0x5>;
> +	};
> +	rgmii_phy6: ethernet-phy@6 {
> +		reg = <0x6>;
> +	};
> +	/* SGMII PCS for enet0 */
> +	tbi0: tbi-phy@1f {
> +		reg = <0x1f>;
> +		device_type = "tbi-phy";
> +	};
> +};
> +
> +&mdio1 {
> +	/* SGMII PCS for enet1 */
> +	tbi1: tbi-phy@1f {
> +		reg = <0x1f>;
> +		device_type = "tbi-phy";
> +	};
> +};
> +
> +&i2c0 {
> +	status = "ok";
> +
> +	/* 3 axis accelerometer */
> +	accelerometer@1e {
> +		compatible = "fsl,fxls8471";
> +		reg = <0x1e>;
> +		position = <0>;
> +	};
> +	/* Gyroscope is at 0x20 but not supported */
> +	/* Audio codec (SAI2) */
> +	codec@2a {

audio-codec

> +		#sound-dai-cells = <0>;

We usually start properties with 'compatible', so please move it behind.

> +		compatible = "fsl,sgtl5000";
> +		reg = <0x2a>;
> +		VDDA-supply = <&reg_3p3v>;
> +		VDDIO-supply = <&reg_2p5v>;
> +		clocks = <&sys_mclk>;
> +	};
> +	/* Current sensing circuit for 1V VDDCORE PMIC rail */
> +	current-sensor@44 {
> +		compatible = "ti,ina220";
> +		reg = <0x44>;
> +		shunt-resistor = <1000>;
> +	};
> +	/* Current sensing circuit for 12V VCC rail */
> +	current-sensor@45 {
> +		compatible = "ti,ina220";
> +		reg = <0x45>;
> +		shunt-resistor = <1000>;
> +	};
> +	/* Thermal monitor - case */
> +	temperature-sensor@48 {
> +		compatible = "national,lm75";
> +		reg = <0x48>;
> +	};
> +	/* Thermal monitor - chip */
> +	temperature-sensor@4c {
> +		compatible = "ti,tmp451";
> +		reg = <0x4c>;
> +	};
> +	/* 4-channel ADC */
> +	adc@49 {
> +		compatible = "ad7924";

Undocumented.

Shawn

> +		reg = <0x49>;
> +	};
> +};
> +
> +&ifc {
> +	status = "disabled";
> +};
> +
> +&esdhc {
> +	status = "ok";
> +};
> +
> +&uart0 {
> +	status = "ok";
> +};
> +
> +&lpuart0 {
> +	status = "ok";
> +};
> +
> +&lpuart3 {
> +	status = "ok";
> +};
> +
> +&sai2 {
> +	status = "ok";
> +};
> +
> +&sata {
> +	status = "ok";
> +};
> -- 
> 2.17.1
> 
