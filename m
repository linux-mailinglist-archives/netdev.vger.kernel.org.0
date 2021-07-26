Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BEE3D5952
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 14:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhGZLi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 07:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbhGZLi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 07:38:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD140C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 05:18:55 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m7zZN-0004Av-So; Mon, 26 Jul 2021 14:18:53 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m7zZL-0006RE-Nm; Mon, 26 Jul 2021 14:18:51 +0200
Date:   Mon, 26 Jul 2021 14:18:51 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Dan Murphy <dmurphy@ti.com>, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: phy: dp83td510: Add basic support
 for the DP83TD510 Ethernet PHY
Message-ID: <20210726121851.u3flif2opshwgz5e@pengutronix.de>
References: <20210723104218.25361-1-o.rempel@pengutronix.de>
 <YPrCiIz7baU26kLU@lunn.ch>
 <20210723170848.lh3l62l7spcyphly@pengutronix.de>
 <YPsGddTXtk/Hinmp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YPsGddTXtk/Hinmp@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:57:42 up 233 days,  9:04, 26 users,  load average: 0.04, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Jul 23, 2021 at 08:12:05PM +0200, Andrew Lunn wrote:
> On Fri, Jul 23, 2021 at 07:08:49PM +0200, Oleksij Rempel wrote:
> > Hi Andrew,
> > 
> > On Fri, Jul 23, 2021 at 03:22:16PM +0200, Andrew Lunn wrote:
> > > On Fri, Jul 23, 2021 at 12:42:18PM +0200, Oleksij Rempel wrote:
> > > > The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> > > > that supports 10M single pair cable.
> > > > 
> > > > This driver provides basic support for this chip:
> > > > - link status
> > > > - autoneg can be turned off
> > > > - master/slave can be configured to be able to work without autoneg
> > > > 
> > > > This driver and PHY was tested with ASIX AX88772B USB Ethernet controller.
> > > 
> > > Hi Oleksij
> > > 
> > > There were patches flying around recently for another T1L PHY which
> > > added new link modes. Please could you work together with that patch
> > > to set the phydev features correctly to indicate this PHY is also a
> > > T1L, and if it support 2.4v etc.
> > 
> > ACK, thx. I was not able to spend enough time to investigate all needed
> > caps, so I decided to go mainline with limited functionality first.
> 
> Limited functionality is fine, but what is implemented should be
> correct. And from what i see in the patch, it is hard to know if the
> PHYs basic features are correctly determined. What does ethtool show?
> Is 100BaseT being offered? Half duplex?

With current driver ethtool with show this information:
Settings for eth1:
	Supported ports: [ TP	 MII ]
	Supported link modes:   Not reported
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: 10Mb/s
	Duplex: Full
	Auto-negotiation: on
	master-slave cfg: unknown
	master-slave status: unknown
	Port: Twisted Pair
	PHYAD: 1
	Transceiver: external
	MDI-X: Unknown
	Supports Wake-on: pg
	Wake-on: p
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes

> > voltage depends on the end application: cable length, safety requirements. I do
> > not see how this can be chosen only on auto negotiation. We would need proper
> > user space interface to let user/integrator set the limits.
> 
> I think we are talking at cross purposes here. As far as i understand
> T1L supports the data signals to be 2.4Vpp as well as the usual
> 1Vpp. This is something which can be negotiated in the same way as
> master/slave, duplex etc.
> 
> I suspect you are talking about the PoE aspects. That is outside the
> scope for phylib. PoE in general is not really supported in the Linux
> kernel, and probably needs a subsystem of its own.

No, no. I'm talking about data signals configuration (2.4Vpp/1Vpp), which
depends on application and cable length. 1Vpp should not be used with
cable over 200 meter and 2.4Vpp should not be used on safety critical
applications. 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
