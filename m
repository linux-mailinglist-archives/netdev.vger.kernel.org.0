Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFFE3B1463
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 09:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFWHI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 03:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhFWHI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 03:08:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC42C06175F
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 00:06:39 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lvwxq-0002I8-3K; Wed, 23 Jun 2021 09:06:22 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lvwxm-0001DJ-K9; Wed, 23 Jun 2021 09:06:18 +0200
Date:   Wed, 23 Jun 2021 09:06:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
Message-ID: <20210623070618.nfv4yizuijbrv575@pengutronix.de>
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
 <20210607082727.26045-5-o.rempel@pengutronix.de>
 <CGME20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9@eucas1p2.samsung.com>
 <15e1bb24-7d67-9d45-54c1-c1c1a0fe444a@samsung.com>
 <20210618101317.55fr5vl5akmtgcf6@pengutronix.de>
 <b1c48fa1-d406-766e-f8d7-54f76d3acb7c@gmail.com>
 <e868450d-c623-bea9-6325-aca4e8367ad5@samsung.com>
 <20210618132035.6vg53gjwuyildlry@pengutronix.de>
 <2d0bdf2e-49bc-60c0-789e-b909cf1e2667@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2d0bdf2e-49bc-60c0-789e-b909cf1e2667@samsung.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:56:17 up 202 days, 21:02, 38 users,  load average: 0.10, 0.06,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Mon, Jun 21, 2021 at 08:05:49AM +0200, Marek Szyprowski wrote:
> Hi Oleksij,
> 
> On 18.06.2021 15:20, Oleksij Rempel wrote:
> > On Fri, Jun 18, 2021 at 01:11:41PM +0200, Marek Szyprowski wrote:
> >> On 18.06.2021 13:04, Heiner Kallweit wrote:
> >>> On 18.06.2021 12:13, Oleksij Rempel wrote:
> >>>> thank you for your feedback.
> >>>>
> >>>> On Fri, Jun 18, 2021 at 10:39:12AM +0200, Marek Szyprowski wrote:
> >>>>> On 07.06.2021 10:27, Oleksij Rempel wrote:
> >>>>>> To be able to use ax88772 with external PHYs and use advantage of
> >>>>>> existing PHY drivers, we need to port at least ax88772 part of asix
> >>>>>> driver to the phylib framework.
> >>>>>>
> >>>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >>>>> I found one more issue with this patch. On one of my test boards
> >>>>> (Samsung Exynos5250 SoC based Arndale) system fails to establish network
> >>>>> connection just after starting the kernel when the driver is build-in.
> >>>>>
> >>> If you build in the MAC driver, do you also build in the PHY driver?
> >>> If the PHY driver is still a module this could explain why genphy
> >>> driver is used.
> >>> And your dmesg filtering suppresses the phy_attached_info() output
> >>> that would tell us the truth.
> >> Here is a bit more complete log:
> >>
> >> # dmesg | grep -i Asix
> >> [    2.412966] usbcore: registered new interface driver asix
> >> [    4.620094] usb 1-3.2.4: Manufacturer: ASIX Elec. Corp.
> >> [    4.641797] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
> >> invalid hw address, using random
> >> [    5.657009] libphy: Asix MDIO Bus: probed
> >> [    5.750584] Asix Electronics AX88772A usb-001:004:10: attached PHY
> >> driver (mii_bus:phy_addr=usb-001:004:10, irq=POLL)
> >> [    5.763908] asix 1-3.2.4:1.0 eth0: register 'asix' at
> >> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, fe:a5:29:e2:97:3e
> >> [    9.090270] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
> >> control off
> >>
> >> This seems to be something different than missing PHY driver.
> > Can you please test it:
> >
> > diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> > index aec97b021a73..7897108a1a42 100644
> > --- a/drivers/net/usb/asix_devices.c
> > +++ b/drivers/net/usb/asix_devices.c
> > @@ -453,6 +453,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
> >   	u16 rx_ctl, phy14h, phy15h, phy16h;
> >   	u8 chipcode = 0;
> >   
> > +	netdev_info(dev->net, "ax88772a_hw_reset\n");
> >   	ret = asix_write_gpio(dev, AX_GPIO_RSE, 5, in_pm);
> >   	if (ret < 0)
> >   		goto out;
> > @@ -509,31 +510,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
> >   			goto out;
> >   		}
> >   	} else if ((chipcode & AX_CHIPCODE_MASK) == AX_AX88772A_CHIPCODE) {
> > -		/* Check if the PHY registers have default settings */
> > -		phy14h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
> > -					     AX88772A_PHY14H);
> > -		phy15h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
> > -					     AX88772A_PHY15H);
> > -		phy16h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
> > -					     AX88772A_PHY16H);
> > -
> > -		netdev_dbg(dev->net,
> > -			   "772a_hw_reset: MR20=0x%x MR21=0x%x MR22=0x%x\n",
> > -			   phy14h, phy15h, phy16h);
> > -
> > -		/* Restore PHY registers default setting if not */
> > -		if (phy14h != AX88772A_PHY14H_DEFAULT)
> > -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
> > -					     AX88772A_PHY14H,
> > -					     AX88772A_PHY14H_DEFAULT);
> > -		if (phy15h != AX88772A_PHY15H_DEFAULT)
> > -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
> > -					     AX88772A_PHY15H,
> > -					     AX88772A_PHY15H_DEFAULT);
> > -		if (phy16h != AX88772A_PHY16H_DEFAULT)
> > -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
> > -					     AX88772A_PHY16H,
> > -					     AX88772A_PHY16H_DEFAULT);
> > +		netdev_info(dev->net, "do not touch PHY regs\n");
> >   	}
> >   
> >   	ret = asix_write_cmd(dev, AX_CMD_WRITE_IPG0,
> 
> This doesn't help for this issue.

Ok.
So far I was not able to see obvious differences between:
probe -> ip link set dev eth1 up

and

probe -> ip link set dev eth1 up;
	 ip link set dev eth1 down;
	 ip link set dev eth1 up


Except of PHY sate. By default the PHY is in resumed state after probe
and is able to negotiate the link even if the MAC is down.
After ip link set dev eth1 down, the PHY is in suspend state, as
expected.

Can you please test this change?

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index aec97b021a73..2c115216420a 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -701,6 +701,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return ret;
 	}
 
+	phy_suspend(priv->phydev);
 	priv->phydev->mac_managed_pm = 1;
 
 	phy_attached_info(priv->phydev);

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
