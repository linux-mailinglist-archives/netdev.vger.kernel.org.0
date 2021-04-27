Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E989736BFEB
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhD0HQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhD0HQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:16:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91377C061574
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 00:15:18 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHwA-0002PF-Gi; Tue, 27 Apr 2021 09:15:14 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHw8-0007nc-NG; Tue, 27 Apr 2021 09:15:12 +0200
Date:   Tue, 27 Apr 2021 09:15:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v3 0/6] provide generic net selftest support
Message-ID: <20210427071512.vprrsajwwhmmb3ch@pengutronix.de>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210423043729.tup7nntmmyv6vurm@pengutronix.de>
 <DB8PR04MB6795479FBF086751D16080E2E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB6795479FBF086751D16080E2E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:10:33 up 145 days, 21:16, 42 users,  load average: 0.30, 0.09,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On Tue, Apr 27, 2021 at 04:48:42AM +0000, Joakim Zhang wrote:
> > Hi Joakim,
> > 
> > On Fri, Apr 23, 2021 at 03:18:32AM +0000, Joakim Zhang wrote:
> > >
> > > Hi Oleksij,
> > >
> > > I look both stmmac selftest code and this patch set. For stmmac, if PHY
> > doesn't support loopback, it will fallthrough to MAC loopback.
> > > You provide this generic net selftest support based on PHY loopback, I have a
> > question, is it possible to extend it also support MAC loopback later?
> > 
> > Yes. If you have interest and time to implement it, please do.
> > It should be some kind of generic callback as phy_loopback() and if PHY and
> > MAC loopbacks are supported we need to tests both variants.
> Hi Oleksij,
> 
> Yes, I can try to implement it when I am free, but I still have some questions:
> 1. Where we place the generic function? Such as mac_loopback().
> 2. MAC is different from PHY, need program different registers to enable loopback on different SoCs, that means we need get MAC private data from "struct net_device".

ACK

> So we need a callback for MAC drivers, where we extend this callback? Could be "struct net_device_ops"? Such as ndo_set_loopback?

yes. Sounds good for me. ndo_set_loopback could be implemented for
ethernet controllers, DSA and even CAN. 

Regards,
Oleksij

> > > > -----Original Message-----
> > > > From: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > Sent: 2021年4月19日 21:01
> > > > To: Shawn Guo <shawnguo@kernel.org>; Sascha Hauer
> > > > <s.hauer@pengutronix.de>; Andrew Lunn <andrew@lunn.ch>; Florian
> > > > Fainelli <f.fainelli@gmail.com>; Heiner Kallweit
> > > > <hkallweit1@gmail.com>; Fugang Duan <fugang.duan@nxp.com>
> > > > Cc: Oleksij Rempel <o.rempel@pengutronix.de>; kernel@pengutronix.de;
> > > > netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > > > linux-kernel@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>;
> > > > Fabio Estevam <festevam@gmail.com>; David Jander
> > > > <david@protonic.nl>; Russell King <linux@armlinux.org.uk>; Philippe
> > > > Schenker <philippe.schenker@toradex.com>
> > > > Subject: [PATCH net-next v3 0/6] provide generic net selftest
> > > > support
> > > >
> > > > changes v3:
> > > > - make more granular tests
> > > > - enable loopback for all PHYs by default
> > > > - fix allmodconfig build errors
> > > > - poll for link status update after switching to the loopback mode
> > > >
> > > > changes v2:
> > > > - make generic selftests available for all networking devices.
> > > > - make use of net_selftest* on FEC, ag71xx and all DSA switches.
> > > > - add loopback support on more PHYs.
> > > >
> > > > This patch set provides diagnostic capabilities for some iMX, ag71xx
> > > > or any DSA based devices. For proper functionality, PHY loopback support is
> > needed.
> > > > So far there is only initial infrastructure with basic tests.
> > > >
> > > > Oleksij Rempel (6):
> > > >   net: phy: execute genphy_loopback() per default on all PHYs
> > > >   net: phy: genphy_loopback: add link speed configuration
> > > >   net: add generic selftest support
> > > >   net: fec: make use of generic NET_SELFTESTS library
> > > >   net: ag71xx: make use of generic NET_SELFTESTS library
> > > >   net: dsa: enable selftest support for all switches by default
> > > >
> > > >  drivers/net/ethernet/atheros/Kconfig      |   1 +
> > > >  drivers/net/ethernet/atheros/ag71xx.c     |  20 +-
> > > >  drivers/net/ethernet/freescale/Kconfig    |   1 +
> > > >  drivers/net/ethernet/freescale/fec_main.c |   7 +
> > > >  drivers/net/phy/phy.c                     |   3 +-
> > > >  drivers/net/phy/phy_device.c              |  35 +-
> > > >  include/linux/phy.h                       |   1 +
> > > >  include/net/dsa.h                         |   2 +
> > > >  include/net/selftests.h                   |  12 +
> > > >  net/Kconfig                               |   4 +
> > > >  net/core/Makefile                         |   1 +
> > > >  net/core/selftests.c                      | 400
> > > > ++++++++++++++++++++++
> > > >  net/dsa/Kconfig                           |   1 +
> > > >  net/dsa/slave.c                           |  21 ++
> > > >  14 files changed, 500 insertions(+), 9 deletions(-)  create mode
> > > > 100644 include/net/selftests.h  create mode 100644
> > > > net/core/selftests.c
> > > >
> > > > --
> > > > 2.29.2
> > >
> > > _______________________________________________
> > > linux-arm-kernel mailing list
> > > linux-arm-kernel@lists.infradead.org
> > > https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Flists
> > > .infradead.org%2Fmailman%2Flistinfo%2Flinux-arm-kernel&amp;data=04%7
> > C0
> > >
> > 1%7Cqiangqing.zhang%40nxp.com%7C8796bf53e46b4b1be92b08d9061186f9
> > %7C686
> > >
> > ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637547494614753358%7CU
> > nknown%7
> > >
> > CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiL
> > CJXV
> > >
> > CI6Mn0%3D%7C1000&amp;sdata=x%2BUFB%2B1Xp0zbR1mG5HDGvqBUvKhX
> > VJn337T%2BB
> > > D7cO6g%3D&amp;reserved=0
> > 
> > --
> > Pengutronix e.K.                           |
> > |
> > Steuerwalder Str. 21                       |
> > https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.pe
> > ngutronix.de%2F&amp;data=04%7C01%7Cqiangqing.zhang%40nxp.com%7C87
> > 96bf53e46b4b1be92b08d9061186f9%7C686ea1d3bc2b4c6fa92cd99c5c301635
> > %7C0%7C0%7C637547494614753358%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> > oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C10
> > 00&amp;sdata=K2dsGVxEXv%2FtC7p0l4TFlLlaqzzTa6ktrbSdcCJ10J0%3D&amp;
> > reserved=0  |
> > 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0
> > |
> > Amtsgericht Hildesheim, HRA 2686           | Fax:
> > +49-5121-206917-5555 |

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
