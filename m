Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51502D9125
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393141AbfJPMkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:40:25 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35479 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfJPMkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:40:24 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iKibB-00066E-DR; Wed, 16 Oct 2019 14:40:17 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iKib9-0006aS-8m; Wed, 16 Oct 2019 14:40:15 +0200
Date:   Wed, 16 Oct 2019 14:40:15 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20191016124015.joawodelm23xkzga@pengutronix.de>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-3-o.rempel@pengutronix.de>
 <20191016122152.GE4780@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191016122152.GE4780@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:34:15 up 151 days, 18:52, 100 users,  load average: 0.13, 0.06,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 02:21:52PM +0200, Andrew Lunn wrote:
> On Mon, Oct 14, 2019 at 08:15:47AM +0200, Oleksij Rempel wrote:
> > Atheros AR9331 has built-in 5 port switch. The switch can be configured
> > to use all 5 or 4 ports. One of built-in PHYs can be used by first built-in
> > ethernet controller or to be used directly by the switch over second ethernet
> > controller.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  .../devicetree/bindings/net/dsa/ar9331.txt    | 155 ++++++++++++++++++
> >  1 file changed, 155 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/dsa/ar9331.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/ar9331.txt b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
> > new file mode 100644
> > index 000000000000..b0f95fd19584
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
> > @@ -0,0 +1,155 @@
> > +Atheros AR9331 built-in switch
> > +=============================
> > +
> > +It is a switch built-in to Atheros AR9331 WiSoC and addressable over internal
> > +MDIO bus. All PHYs are build-in as well. 
> > +
> > +Required properties:
> > +
> > + - compatible: should be: "qca,ar9331-switch" 
> > + - reg: Address on the MII bus for the switch.
> > + - resets : Must contain an entry for each entry in reset-names.
> > + - reset-names : Must include the following entries: "switch"
> > + - interrupt-parent: Phandle to the parent interrupt controller
> > + - interrupts: IRQ line for the switch
> > + - interrupt-controller: Indicates the switch is itself an interrupt
> > +   controller. This is used for the PHY interrupts.
> > + - #interrupt-cells: must be 1
> > + - mdio: Container of PHY and devices on the switches MDIO bus.
> > +
> > +See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
> > +required and optional properties.
> > +Examples:
> > +
> > +eth0: ethernet@19000000 {
> > +	compatible = "qca,ar9330-eth";
> > +	reg = <0x19000000 0x200>;
> > +	interrupts = <4>;
> > +
> > +	resets = <&rst 9>, <&rst 22>;
> > +	reset-names = "mac", "mdio";
> > +	clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_AHB>;
> > +	clock-names = "eth", "mdio";
> > +
> > +	phy-mode = "mii";
> > +	phy-handle = <&phy_port4>;
> 
> This does not seem like a valid example. If phy_port4 is listed here,
> i would expect switch_port 5 to be totally missing?

hm... right.
phy4 can be used with switch_port 5 or eth0. Should i remove completely
switch_port 5 node or it is enough to "disable" it.

> > +};
> > +
> > +eth1: ethernet@1a000000 {
> > +	compatible = "qca,ar9330-eth";
> > +	reg = <0x1a000000 0x200>;
> > +	interrupts = <5>;
> > +	resets = <&rst 13>, <&rst 23>;
> > +	reset-names = "mac", "mdio";
> > +	clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_AHB>;
> > +	clock-names = "eth", "mdio";
> > +
> > +	phy-mode = "gmii";
> > +	phy-handle = <&switch_port0>;
> > +
> > +	fixed-link {
> > +		speed = <1000>;
> > +		full-duplex;
> > +	};
> 
> You also cannot have both a fixed-link and a phy-handle.

ok.

> 
> > +
> > +	mdio {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +
> > +		switch10: switch@10 {
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +
> > +			compatible = "qca,ar9331-switch";
> > +			reg = <16>;
> 
> Maybe don't mix up hex and decimal? switch16: switch@16.

ok. will fix it. What is actually proper way to set the reg of switch?
This switch is responding on range of phy addresses: any of two high bits of 5
bit phy address.

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
