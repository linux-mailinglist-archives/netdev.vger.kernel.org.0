Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EF3D90B1
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392951AbfJPMWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:22:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387581AbfJPMWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 08:22:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dxyt+ZOiCiHKtL/UeQs81zIxekX5q0wpGSVddf2x5d8=; b=fosF19Oy801w1a4Ztm9zgHINtT
        S281NvrHjvUVd/K6p+PV/3v12HcPstTEIZDXwqBifAivm5nvtVd34RAQeNPGfDPUlvANwSetLsOEW
        DCo8UpWRW94TXRzURLaTvXuvxuBH1nv/B95XpGYsRVucfGHIaZXx7DWtGKqV9+cO3JOY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKiJM-0007Hy-Ba; Wed, 16 Oct 2019 14:21:52 +0200
Date:   Wed, 16 Oct 2019 14:21:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 2/4] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191016122152.GE4780@lunn.ch>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014061549.3669-3-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 08:15:47AM +0200, Oleksij Rempel wrote:
> Atheros AR9331 has built-in 5 port switch. The switch can be configured
> to use all 5 or 4 ports. One of built-in PHYs can be used by first built-in
> ethernet controller or to be used directly by the switch over second ethernet
> controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/dsa/ar9331.txt    | 155 ++++++++++++++++++
>  1 file changed, 155 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/ar9331.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ar9331.txt b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
> new file mode 100644
> index 000000000000..b0f95fd19584
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
> @@ -0,0 +1,155 @@
> +Atheros AR9331 built-in switch
> +=============================
> +
> +It is a switch built-in to Atheros AR9331 WiSoC and addressable over internal
> +MDIO bus. All PHYs are build-in as well. 
> +
> +Required properties:
> +
> + - compatible: should be: "qca,ar9331-switch" 
> + - reg: Address on the MII bus for the switch.
> + - resets : Must contain an entry for each entry in reset-names.
> + - reset-names : Must include the following entries: "switch"
> + - interrupt-parent: Phandle to the parent interrupt controller
> + - interrupts: IRQ line for the switch
> + - interrupt-controller: Indicates the switch is itself an interrupt
> +   controller. This is used for the PHY interrupts.
> + - #interrupt-cells: must be 1
> + - mdio: Container of PHY and devices on the switches MDIO bus.
> +
> +See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
> +required and optional properties.
> +Examples:
> +
> +eth0: ethernet@19000000 {
> +	compatible = "qca,ar9330-eth";
> +	reg = <0x19000000 0x200>;
> +	interrupts = <4>;
> +
> +	resets = <&rst 9>, <&rst 22>;
> +	reset-names = "mac", "mdio";
> +	clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_AHB>;
> +	clock-names = "eth", "mdio";
> +
> +	phy-mode = "mii";
> +	phy-handle = <&phy_port4>;

This does not seem like a valid example. If phy_port4 is listed here,
i would expect switch_port 5 to be totally missing?

> +};
> +
> +eth1: ethernet@1a000000 {
> +	compatible = "qca,ar9330-eth";
> +	reg = <0x1a000000 0x200>;
> +	interrupts = <5>;
> +	resets = <&rst 13>, <&rst 23>;
> +	reset-names = "mac", "mdio";
> +	clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_AHB>;
> +	clock-names = "eth", "mdio";
> +
> +	phy-mode = "gmii";
> +	phy-handle = <&switch_port0>;
> +
> +	fixed-link {
> +		speed = <1000>;
> +		full-duplex;
> +	};

You also cannot have both a fixed-link and a phy-handle.

> +
> +	mdio {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		switch10: switch@10 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			compatible = "qca,ar9331-switch";
> +			reg = <16>;

Maybe don't mix up hex and decimal? switch16: switch@16.

      Andrew
