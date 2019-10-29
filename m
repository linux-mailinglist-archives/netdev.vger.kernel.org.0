Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CD7E7E85
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 03:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbfJ2CXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 22:23:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbfJ2CXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 22:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=weWtSFC8Dm8rRDFq7Ws7YUnkyjq/k0sSGCP9VGBKkyw=; b=fJVzoelD4VQgmU1U+f7c/xTlQ5
        sNvBmfgwFgZ1JPMBhPUlhZdvJCN3484WQZFbgDu/hxD5WOBoL1rKBHhHw7VXRoCgqM0cln5ylX5WF
        lnCX5riYaxwMGB21OgC97MCdQTdzWPkaGQ9c9zui7QlgA7bM7TgZ3MiOfStUM5RKTEvM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPHA1-0001NW-4d; Tue, 29 Oct 2019 03:23:05 +0100
Date:   Tue, 29 Oct 2019 03:23:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 05/12] dt-bindings: net: ti: add new cpsw
 switch driver bindings
Message-ID: <20191029022305.GK15259@lunn.ch>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-6-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024100914.16840-6-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +TI SoC Ethernet Switch Controller Device Tree Bindings (new)
> +------------------------------------------------------
> +
> +The 3-port switch gigabit ethernet subsystem provides ethernet packet
> +communication and can be configured as an ethernet switch.

Hi Grygorii

Maybe referring it to a 3-port switch will cause confusion, since in
this use case, it only has 2 ports, and you only list two ports in the
device tree.

> It provides the
> +gigabit media independent interface (GMII),reduced gigabit media
> +independent interface (RGMII), reduced media independent interface (RMII),
> +the management data input output (MDIO) for physical layer device (PHY)
> +management.
> +
> +Required properties:
> +- compatible : be one of the below:
> +	  "ti,cpsw-switch" for backward compatible
> +	  "ti,am335x-cpsw-switch" for AM335x controllers
> +	  "ti,am4372-cpsw-switch" for AM437x controllers
> +	  "ti,dra7-cpsw-switch" for DRA7x controllers
> +- reg : physical base address and size of the CPSW module IO range
> +- ranges : shall contain the CPSW module IO range available for child devices
> +- clocks : should contain the CPSW functional clock
> +- clock-names : should be "fck"
> +	See bindings/clock/clock-bindings.txt
> +- interrupts : should contain CPSW RX_THRESH, RX, TX, MISC interrupts
> +- interrupt-names : should contain "rx_thresh", "rx", "tx", "misc"
> +	See bindings/interrupt-controller/interrupts.txt
> +
> +Optional properties:
> +- syscon : phandle to the system control device node which provides access to
> +	efuse IO range with MAC addresses
> +
> +Required Sub-nodes:
> +- ethernet-ports : contains CPSW external ports descriptions
> +	Required properties:
> +	- #address-cells : Must be 1
> +	- #size-cells : Must be 0
> +	- reg : CPSW port number. Should be 1 or 2
> +	- phys : phandle on phy-gmii-sel PHY (see phy/ti-phy-gmii-sel.txt)
> +	- phy-mode : See [1]
> +	- phy-handle : See [1]
> +
> +	Optional properties:
> +	- label : Describes the label associated with this port
> +	- ti,dual-emac-pvid : Specifies default PORT VID to be used to segregate
> +		ports. Default value - CPSW port number.
> +	- mac-address : See [1]
> +	- local-mac-address : See [1]
> +
> +- mdio : CPSW MDIO bus block description
> +	- bus_freq : MDIO Bus frequency
> +	See bindings/net/mdio.txt and davinci-mdio.txt
> +
> +- cpts : The Common Platform Time Sync (CPTS) module description
> +	- clocks : should contain the CPTS reference clock
> +	- clock-names : should be "cpts"
> +	See bindings/clock/clock-bindings.txt
> +
> +	Optional properties - all ports:
> +	- cpts_clock_mult : Numerator to convert input clock ticks into ns
> +	- cpts_clock_shift : Denominator to convert input clock ticks into ns
> +			  Mult and shift will be calculated basing on CPTS
> +			  rftclk frequency if both cpts_clock_shift and
> +			  cpts_clock_mult properties are not provided.
> +
> +[1] See Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +
> +Examples:
> +
> +mac_sw: switch@0 {
> +	compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
> +	reg = <0x0 0x4000>;
> +	ranges = <0 0 0x4000>;
> +	clocks = <&gmac_main_clk>;
> +	clock-names = "fck";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	syscon = <&scm_conf>;
> +	status = "disabled";
> +
> +	interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
> +		     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
> +		     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
> +		     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
> +	interrupt-names = "rx_thresh", "rx", "tx", "misc"
> +
> +	ethernet-ports {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpsw_port1: port@1 {
> +			reg = <1>;
> +			label = "port1";
> +			/* Filled in by U-Boot */
> +			mac-address = [ 00 00 00 00 00 00 ];
> +			phys = <&phy_gmii_sel 1>;
> +		};
> +
> +		cpsw_port2: port@2 {
> +			reg = <2>;
> +			label = "wan";
> +			/* Filled in by U-Boot */
> +			mac-address = [ 00 00 00 00 00 00 ];
> +			phys = <&phy_gmii_sel 2>;
> +		};
> +	};
> +
> +	davinci_mdio_sw: mdio@1000 {
> +		compatible = "ti,cpsw-mdio","ti,davinci_mdio";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		ti,hwmods = "davinci_mdio";
> +		bus_freq = <1000000>;
> +		reg = <0x1000 0x100>;
> +	};
> +
> +	cpts {
> +		clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
> +		clock-names = "cpts";
> +	};
> +};
> +
> +&mac_sw {
> +	pinctrl-names = "default", "sleep";
> +	status = "okay";
> +};
> +
> +&cpsw_port1 {
> +	phy-handle = <&ethphy0_sw>;
> +	phy-mode = "rgmii";
> +	ti,dual_emac_pvid = <1>;
> +};
> +
> +&cpsw_port2 {
> +	phy-handle = <&ethphy1_sw>;
> +	phy-mode = "rgmii";
> +	ti,dual_emac_pvid = <2>;
> +};
> +
> +&davinci_mdio_sw {
> +	ethphy0_sw: ethernet-phy@0 {
> +		reg = <0>;
> +	};
> +
> +	ethphy1_sw: ethernet-phy@1 {
> +		reg = <1>;
> +	};
> +};

In an example, it is unusual to split things up like this. I
understand that parts of this will be in the dtsi file, and parts in
the .dts file, but examples generally keep it all as one. And when you
re-write this in YAML so it can be used to validated real DTs, you
will have to combine it.

     Andrew
