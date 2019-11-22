Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F371107575
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfKVQJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:09:34 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47476 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKVQJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 11:09:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=Bs4ZPwZcobeGLjW3wndnSsxdLL7o7ARhgnyTo8K24X4=; b=MdQ3M5JTERYv
        SWTEpvWMQkKMc/8B3n6+qrZpXb08J4xlIR2ROvNdOFxUnUPHb/6cJctbc1eiR1PlP5LzrbR2GNiFt
        glntheq/LkkJkntrVHVl2uCXcwBdofiVWlFDD60QOsyz7z0YzYV86pH53v3kxb7Ps+aXmhcY10Ecl
        puGT/fs4MFQv9rfBQOFAcbGh7sQzrRYPRNYweRreGsycM8LT8QF7zs3bolNiJlZT3DJ4qJzbOk7RP
        JYZ9DcXEm8iRZmhxN9HFOC8cGeJ4nhVenAs0WYb49R+RWjsMWbVCwASU8TBNV/W47E9GyaPg7Do9T
        Mnvq2s92ktTuyDbVv99uzw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59766)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iYBUx-00069C-8M
        for netdev@vger.kernel.org; Fri, 22 Nov 2019 16:09:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iYBUv-0003tH-L8
        for netdev@vger.kernel.org; Fri, 22 Nov 2019 16:09:29 +0000
Date:   Fri, 22 Nov 2019 16:09:29 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org
Subject: Fwd: Re: [PATCH net-next] net: phy: initialise phydev speed and
 duplex sanely
Message-ID: <20191122160929.GN1344@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iYAmJ-0005gz-Hc@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, Andrew dropped the 'g' from the netdev email address,
and Zach's email address doesn't seem to work.

Forwarding this to netdev (with appropriate threading) for archival
purposes.

----- Forwarded message from Russell King - ARM Linux admin <linux@armlinux.org.uk> -----

Date: Fri, 22 Nov 2019 16:03:23 +0000
From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: zach.brown@ni.com, Florian Fainelli <f.fainelli@gmail.com>, Heiner Kallweit
	<hkallweit1@gmail.com>, "David S. Miller" <davem@davemloft.net>,
	netdev@vger.kernel.or
Subject: Re: [PATCH net-next] net: phy: initialise phydev speed and duplex
	sanely

On Fri, Nov 22, 2019 at 04:02:01PM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Nov 22, 2019 at 04:51:24PM +0100, Andrew Lunn wrote:
> > On Fri, Nov 22, 2019 at 03:23:23PM +0000, Russell King wrote:
> > > When a phydev is created, the speed and duplex are set to zero and
> > > -1 respectively, rather than using the predefined SPEED_UNKNOWN and
> > > DUPLEX_UNKNOWN constants.
> > > 
> > > There is a window at initialisation time where we may report link
> > > down using the 0/-1 values.  Tidy this up and use the predefined
> > > constants, so debug doesn't complain with:
> > > 
> > > "Unsupported (update phy-core.c)/Unsupported (update phy-core.c)"
> > > 
> > > when the speed and duplex settings are printed.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/net/phy/phy_device.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index 232ad33b1159..8186aad4ef90 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -597,8 +597,8 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
> > >  	mdiodev->device_free = phy_mdio_device_free;
> > >  	mdiodev->device_remove = phy_mdio_device_remove;
> > >  
> > > -	dev->speed = 0;
> > > -	dev->duplex = -1;
> > > +	dev->speed = SPEED_UNKNOWN;
> > > +	dev->duplex = DUPLEX_UNKNOWN;
> > >  	dev->pause = 0;
> > >  	dev->asym_pause = 0;
> > >  	dev->link = 0;
> > 
> > Hi Russell, Zach
> > 
> > Does phy_led_trigger_change_speed() need to change? It has
> > 
> >         if (phy->speed == 0)
> >                 return;
> 
> I'm not sure what that's trying to achieve.
> 
> From what I can see, phy_speed_to_led_trigger() looks up the speed in
> the table of triggers, which is populated from the PHYs supported
> speeds, which will never contain zero or SPEED_UNKNOWN.
> 
> Note that genphy will return SPEED_UNKNOWN if autoneg_complete is
> false (see genphy_read_status()).  However, in that case, ->link
> will be false, just like it is at initialisation time, and hence
> we won't reach that statement (we'll go off to
> phy_led_trigger_no_link()).
> 
> So I think the test is entirely unnecessary.

... unless there's a buggy phylib driver, in which case we shouldn't
be working around it in this code (as it would affect network drivers
as well) but should be fixing the broken phylib driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

----- End forwarded message -----

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
