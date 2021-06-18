Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731233ACBC6
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhFRNMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbhFRNMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:12:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5F5C061760
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:10:27 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1luEGG-0003tf-PE; Fri, 18 Jun 2021 15:10:16 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1luEGB-000582-VG; Fri, 18 Jun 2021 15:10:11 +0200
Date:   Fri, 18 Jun 2021 15:10:11 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
Message-ID: <20210618131011.puodgt4niemsabno@pengutronix.de>
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
 <20210607082727.26045-5-o.rempel@pengutronix.de>
 <CGME20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9@eucas1p2.samsung.com>
 <15e1bb24-7d67-9d45-54c1-c1c1a0fe444a@samsung.com>
 <20210618101317.55fr5vl5akmtgcf6@pengutronix.de>
 <460f971e-fbae-8d3d-ae8e-ed90bbebda4d@samsung.com>
 <b3b990b5-d2f6-3e93-effd-44e10c5dfb5e@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3b990b5-d2f6-3e93-effd-44e10c5dfb5e@samsung.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:08:33 up 198 days,  3:14, 50 users,  load average: 0.07, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 12:57:13PM +0200, Marek Szyprowski wrote:
> On 18.06.2021 12:45, Marek Szyprowski wrote:
> > On 18.06.2021 12:13, Oleksij Rempel wrote:
> >> thank you for your feedback.
> >>
> >> On Fri, Jun 18, 2021 at 10:39:12AM +0200, Marek Szyprowski wrote:
> >>> On 07.06.2021 10:27, Oleksij Rempel wrote:
> >>>> To be able to use ax88772 with external PHYs and use advantage of
> >>>> existing PHY drivers, we need to port at least ax88772 part of asix
> >>>> driver to the phylib framework.
> >>>>
> >>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >>> I found one more issue with this patch. On one of my test boards
> >>> (Samsung Exynos5250 SoC based Arndale) system fails to establish 
> >>> network
> >>> connection just after starting the kernel when the driver is build-in.
> >>>
> >>> --->8---
> >>> # dmesg | grep asix
> >>> [    2.761928] usbcore: registered new interface driver asix
> >>> [    5.003110] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
> >>> invalid hw address, using random
> >>> [    6.065400] asix 1-3.2.4:1.0 eth0: register 'asix' at
> >>> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, 
> >>> 7a:9b:9a:f2:94:8e
> >>> [   14.043868] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
> >>> control off
> >>> # ping -c2  host
> >>> PING host (192.168.100.1) 56(84) bytes of data.
> >>>   From 192.168.100.20 icmp_seq=1 Destination Host Unreachable
> >>>   From 192.168.100.20 icmp_seq=2 Destination Host Unreachable
> >>>
> >>> --- host ping statistics ---
> >>> 2 packets transmitted, 0 received, +2 errors, 100% packet loss, time 
> >>> 59ms
> >>> --->8---
> >> Hm... it looks like different chip variant. My is registered as
> >> "ASIX AX88772B USB", yours is "ASIX AX88772 USB 2.0" - "B" is the
> >> difference. Can you please tell me more about this adapter and if 
> >> possible open
> >> tell the real part name.
> > Well, currently I have only remote access to that board. The network 
> > chip is soldered on board. Maybe you can read something from the photo 
> > on the wiki page: https://en.wikipedia.org/wiki/Arndale_Board
> >> I can imagine that this adapter may using generic PHY driver.
> >> Can you please confirm it by dmesg | grep PHY?
> >> In my case i'll get:
> >> Asix Electronics AX88772C usb-001:003:10: attached PHY driver 
> >> (mii_bus:phy_addr=usb-001:003:10, irq=POLL)
> > # dmesg | grep PHY
> > [    5.700274] Asix Electronics AX88772A usb-001:004:10: attached PHY 
> > driver (mii_bus:phy_addr=usb-001:004:10, irq=POLL)
> >> If you have a different PHY, can you please send me the PHY id:
> >> cat /sys/bus/mdio_bus/devices/usb-001\:003\:10/phy_id
> >>
> >> Your usb path will probably be different.
> >
> > # cat /sys/bus/mdio_bus/devices/usb-001\:004\:10/phy_id
> > 0x003b1861
> >
> > > ...
> 
> Just for the record, I also have a board with external USB Ethernet 
> dongle based on ASIX chip, which works fine with this patch, both when 
> driver is built-in or as a module. Here is the log:
> 
> # dmesg | grep -i Asix
> [    1.718349] usbcore: registered new interface driver asix
> [    2.608596] usb 3-1: Manufacturer: ASIX Elec. Corp.
> [    3.876279] libphy: Asix MDIO Bus: probed
> [    3.958105] Asix Electronics AX88772C usb-003:002:10: attached PHY 
> driver (mii_bus:phy_addr=usb-003:002:10, irq=POLL)
> [    3.962728] asix 3-1:1.0 eth0: register 'asix' at 
> usb-xhci-hcd.6.auto-1, ASIX AX88772B USB 2.0 Ethernet, 00:50:b6:18:92:f0
> [   17.488532] asix 3-1:1.0 eth0: Link is Down
> [   19.557233] asix 3-1:1.0 eth0: Link is Up - 100Mbps/Full - flow 
> control off
> 
> # cat /sys/bus/mdio_bus/devices/usb-003\:002\:10/phy_id
> 0x003b1881

Ok, this one is different. It is AX88772C variant.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
