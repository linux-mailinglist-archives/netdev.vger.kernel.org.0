Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD5341DAEC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351125AbhI3NXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351075AbhI3NXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:23:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F89C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 06:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oFwAU/be7FnrDk5WMdo0awQ0AkVS5+f+nc0V+RMrgfs=; b=UK2GOXe06FocpMr7u0F1tC9Etn
        o/hkbkQahudQPIBCO4V6Y2Q0QpN8EOPMI99WjHQqGoz4y2rUaYO8nIm4rQ8wLF2gC3rESR6qQ079H
        a/xQwVx/0lJZ2i4jGsu5aMoEFJ46x28LuD3HjTYVRXNKAxZ10+/lB1ioehvQcIQKdsG2TYGmdyLG0
        6CqKaD/LYy3Vq2Cv7IPLZDJffNU8gsbtE25EAsq4v/vUrnRUgKTvjLU94UsOURRNjr7IRiS2yjuFV
        e9a7hI6r2X4bmrniI1/UoQi/dQfCzGqyDwXDhwdjBrh50Mvgepe/GlGmVxrW1M/7rUJOH5zi41CGH
        NrGzYDsA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54872)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVw0c-0003Vv-D7; Thu, 30 Sep 2021 14:21:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVw0b-0003gk-M4; Thu, 30 Sep 2021 14:21:57 +0100
Date:   Thu, 30 Sep 2021 14:21:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
Message-ID: <YVW59e2iItl5S4Qh@shell.armlinux.org.uk>
References: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
 <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
 <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
 <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
 <1e4e40ba-23b8-65b4-0b53-1c8393d9a834@gmail.com>
 <YVWjEQzJisT0HgHB@shell.armlinux.org.uk>
 <f51658fb-0844-93fc-46d0-6b3a7ef36123@gmail.com>
 <YVWt2B7c9YKLlmgT@shell.armlinux.org.uk>
 <955416fe-4da4-b1ec-aadb-9b816f02d7f2@gmail.com>
 <YVW2oN3vBoP3tNNn@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVW2oN3vBoP3tNNn@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 02:07:44PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 30, 2021 at 02:51:40PM +0200, Rafał Miłecki wrote:
> > On 30.09.2021 14:30, Russell King (Oracle) wrote:
> > > > It's actually OpenWrt's downstream swconfig-based b53 driver that
> > > > matches this device.
> > > > 
> > > > I'm confused as downstream b53_mdio.c calls phy_driver_register(). Why
> > > > does it match MDIO device then? I thought MDIO devices should be
> > > > matches only with drivers using mdio_driver_register().
> > > 
> > > Note that I've no idea what he swconfig-based b53 driver looks like,
> > > I don't have the source for that to hand.
> > > 
> > > If it calls phy_driver_register(), then it is registering a driver for
> > > a MDIO device wrapped in a struct phy_device. If this driver has a
> > > .of_match_table member set, then this is wrong - the basic rule is
> > > 
> > > 	PHY drivers must never match using DT compatibles.
> > > 
> > > because this is exactly what will occur - it bypasses the check that
> > > the mdio_device being matched is in fact wrapped by a struct phy_device,
> > > and we will access members of the non-existent phy_device, including
> > > the "uninitialised" mutex.
> > > 
> > > If the swconfig-based b53 driver does want to bind to a phy_device based
> > > DT node, then it needs to match using either a custom .match_phy_device
> > > method in the PHY driver, or it needs to match using the PHY IDs.
> > 
> > Sorry, I should have linked downstream b53_mdio.c . It's:
> > https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/generic/files/drivers/net/phy/b53/b53_mdio.c;h=98cdbffe73c7354f4401389dfcc96014bff62588;hb=HEAD
> 
> Yes, I just found a version of the driver
> 
> > You can see that is *uses* of_match_table.
> > 
> > What about refusing bugged drivers like above b53 with something like:
> 
> That will break all the MDIO based DSA and other non-PHY drivers,
> sorry.
> 
> I suppose we could detect if the driver has the MDIO_DEVICE_IS_PHY flag
> set, and reject any device that does not have MDIO_DEVICE_IS_PHY set:
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..7bc06126ce10 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -939,6 +939,12 @@ EXPORT_SYMBOL_GPL(mdiobus_modify);
>  static int mdio_bus_match(struct device *dev, struct device_driver *drv)
>  {
>  	struct mdio_device *mdio = to_mdio_device(dev);
> +	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
> +
> +	/* Both the driver and device must type-match */
> +	if (!(mdiodrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY) ==
> +	    !(mdio->flags & MDIO_DEVICE_FLAG_PHY))
> +		return 0;
>  
>  	if (of_driver_match_device(dev, drv))
>  		return 1;
> 
> In other words, the driver's state of the MDIO_DEVICE_IS_PHY flag
> must match the device's MDIO_DEVICE_FLAG_PHY flag before we attempt
> any matches.
> 
> If that's not possible, then we need to prevent phylib drivers from
> using .of_match_table:
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index e62f7a232307..dacf0b31b167 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2501,6 +2501,16 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
>  		return -EINVAL;
>  	}
>  
> +	/* PHYLIB device drivers must not match using a DT compatible table
> +	 * as this bypasses our checks that the mdiodev that is being matched
> +	 * is backed by a struct phy_device. If such a case happens, we will
> +	 * make out-of-bounds accesses and lockup in phydev->lock.
> +	 */
> +	if (WARN(new_driver->mdiodrv.driver.of_match_table,
> +		 "%s: driver must not provide a DT match table\n",
> +		 new_driver->name))
> +		return -EINVAL;
> +
>  	new_driver->mdiodrv.flags |= MDIO_DEVICE_IS_PHY;
>  	new_driver->mdiodrv.driver.name = new_driver->name;
>  	new_driver->mdiodrv.driver.bus = &mdio_bus_type;

I should also point out that as this b53 driver that is causing the
problem only exists in OpenWRT, this is really a matter for OpenWRT
developers rather than mainline which does not suffer this problem.
I suspect that OpenWRT developers will not be happy with either of
the two patches I've posted above - I suspect they are trying to
support both DSA and swconfig approaches with a single DT. That can
be made to work, but not with a PHYLIB driver being a wrapper around
the swconfig stuff (precisely because there's no phy_device in this
scenario.)

The only reason to patch mainline kernels would be to make them more
robust, and maybe to also make an explicit statement about what isn't
supported (having a phy_driver with its of_match_table member set.)

I probably should've made that clearer in my email with the patches.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
