Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0598319A561
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 08:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbgDAGdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 02:33:31 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50025 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731735AbgDAGdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 02:33:31 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jJWwJ-0004Mk-Ei; Wed, 01 Apr 2020 08:33:27 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jJWw5-00053m-3n; Wed, 01 Apr 2020 08:33:13 +0200
Date:   Wed, 1 Apr 2020 08:33:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200401063313.5e5r7jm6fjzdqpdg@pengutronix.de>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <5ae5c0de-f05c-5e3f-86e1-a9afdd3e1ef1@pengutronix.de>
 <20200331075457.GJ25745@shell.armlinux.org.uk>
 <f1352a82-be3a-cd0a-7cba-6f338f205098@pengutronix.de>
 <20200331081918.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200331081918.GK25745@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:28:42 up 137 days, 21:47, 155 users,  load average: 0.00, 0.03,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 09:19:18AM +0100, Russell King - ARM Linux admin wrote:
> On Tue, Mar 31, 2020 at 10:00:12AM +0200, Marc Kleine-Budde wrote:
> > On 3/31/20 9:54 AM, Russell King - ARM Linux admin wrote:
> > > On Tue, Mar 31, 2020 at 09:47:19AM +0200, Marc Kleine-Budde wrote:
> > >> On 3/30/20 7:41 PM, Russell King - ARM Linux admin wrote:
> > >>>>> arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> > >>>>> arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> > >>>>> arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> > >>>>> arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
> > >>>
> > >>> As far as I'm concerned, the AR8035 fixup is there with good reason.
> > >>> It's not just "random" but is required to make the AR8035 usable with
> > >>> the iMX6 SoCs.  Not because of a board level thing, but because it's
> > >>> required for the AR8035 to be usable with an iMX6 SoC.
> > >>
> > >> Is this still ture, if the AR8035 is attached to a switch behind an iMX6?
> > > 
> > > Do you know of such a setup, or are you talking about theoretical
> > > situations?
> > 
> > Granted, not for the AR8035, but for one of the KSZ Phys. This is why
> > Oleksij started looking into this issue in the first place.
> 
> Maybe there's an easy solution to this - check whether the PHY being
> fixed up is connected to the iMX6 SoC:
> 
> static bool phy_connected_to(struct phy_device *phydev,
> 			     const struct of_device_id *matches)
> {
> 	struct device_node *np, *phy_np;
> 
> 	for_each_matching_node(np, matches) {
> 		phy_np = of_parse_phandle(np, "phy-handle", 0);
> 		if (!phy_np)
> 			phy_np = of_parse_phandle(np, "phy", 0);
> 		if (!phy_np)
> 			phy_np = of_parse_phandle(np, "phy-device", 0);
> 		if (phy_np && phydev->mdio.dev.of_node == phy_np) {
> 			of_node_put(phy_np);
> 			of_node_put(np);
> 			return true;
> 		}
> 		of_node_put(phy_np);
> 	}
> 	return false;
> }
> 
> static struct of_device_id imx_fec_ids[] = {
> 	{ .compatible = "fsl,imx6q-fec", },
> 	...
> 	{ },
> };
> 
> static bool phy_connected_to_fec(struct phy_device *phydev)
> {
> 	return phy_connected_to(phydev, imx_fec_ids);
> }
> 
> and then in the fixups:
> 
> 	if (!phy_connected_to_fec(phydev))
> 		return 0;
> 

Ok, i see. We will limit fixup impact to some specific devicetree nodes.
And if we wont to disable fixup completely, some special devicetree binding will
be needed. Correct? Is this acceptable mainline way?
For the usb ethernet fixups we will need some thing similar.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
