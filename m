Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F03F1ADC82
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 13:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgDQLvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 07:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730410AbgDQLvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 07:51:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24374C061A0C;
        Fri, 17 Apr 2020 04:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EZwk3YNdpAvImVdK4L3azX5Qt33CYEFB35G3F0YU5uo=; b=UKCam/Lge/kk5P1KuIr04G1eW
        tyJlVCcrfaSMYfQLrRP3gyonUiFikD8ZH9HGitQFUdMWvBK9WXic5XmaNJ5W1OnYT12+r9Rb9SF7Q
        Y3wWuhUbuM3/5LSlwYIBmQEBXvp0Oj/dYvRm8Ql82e5aG0k9ogncNPiwZJfhv2F5Yq4I/knLTaFCg
        AbjfFBs9loskOZVPfLn5cWD8zjKgMzxg83AiCWEVvCAGKMTEEBMrD8Fpeg6UyyIf2LhGA56Q+/lAu
        fa4+Ufq2jCRC5F+RQi4vLd11ipk9aUnLC4k+eNx4n6jwJ6ymjPVeYTtpyBdhbPZPJIoYj5Zmhkf1h
        3bpC0bCUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51278)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jPPWg-0001ri-Ft; Fri, 17 Apr 2020 12:51:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jPPWb-0002rY-FC; Fri, 17 Apr 2020 12:51:13 +0100
Date:   Fri, 17 Apr 2020 12:51:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200417115113.GR25745@shell.armlinux.org.uk>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415215739.GI657811@lunn.ch>
 <20200417101145.GP25745@shell.armlinux.org.uk>
 <20200417112830.mhevvmnyxpve6xvk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417112830.mhevvmnyxpve6xvk@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 01:28:30PM +0200, Oleksij Rempel wrote:
> On Fri, Apr 17, 2020 at 11:11:45AM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Apr 15, 2020 at 11:57:39PM +0200, Andrew Lunn wrote:
> > > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > > index c8b0c34030d32..d5edf2bc40e43 100644
> > > > --- a/drivers/net/phy/phy_device.c
> > > > +++ b/drivers/net/phy/phy_device.c
> > > > @@ -604,6 +604,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
> > > >  	dev->asym_pause = 0;
> > > >  	dev->link = 0;
> > > >  	dev->interface = PHY_INTERFACE_MODE_GMII;
> > > > +	dev->master_slave = PORT_MODE_UNKNOWN;
> > > 
> > > phydev->master_slave is how we want the PHY to be configured. I don't
> > > think PORT_MODE_UNKNOWN makes any sense in that contest. 802.3 gives
> > > some defaults. 9.12 should be 0, meaning manual master/slave
> > > configuration is disabled. The majority of linux devices are end
> > > systems. So we should default to a single point device. So i would
> > > initialise PORT_MODE_SLAVE, or whatever we end up calling that.
> > 
> > I'm not sure that is a good idea given that we use phylib to drive
> > the built-in PHYs in DSA switches, which ought to prefer master mode
> > via the "is a multiport device" bit.
> > 
> > Just to be clear, there are three bits that configure 1G PHYs, which
> > I've framed in briefer terminology:
> > 
> > - 9.12: auto/manual configuration (1= manual 0= slave)
> > - 9.11: manual master/slave configuration (1= master, 0 = slave)
> > - 9.10: auto master/slave preference (1= multiport / master)
> > 
> > It is recommended that multiport devices (such as DSA switches) set
> > 9.10 so they prefer to be master.
> > 
> > It's likely that the reason is to reduce cross-talk interference
> > between neighbouring ports both inside the PHY, magnetics and the
> > board itself. I would suspect that this becomes critical when
> > operating at towards the maximum cable length.
> > 
> > I've checked some of my DSA switches, and 9.10 appears to default to
> > one, as expected given what's in the specs.
> 
> Hm..
> I've checked one of my DSA devices and 9.10 is by default 0 (proffered
> slave). It get slave even if it is preferred master and it is
> connected to a workstation (not multiport device) with a e1000e NIC.
> The e1000e is configured by default as preferred master.
> 
> Grepping over current linux kernel I see following attempts to
> configure master/slave modes:
> drivers/net/ethernet/intel/e1000e/phy.c:597
>   e1000_set_master_slave_mode()
> 
> all intel NICs have similar code code and do not touch preferred bit
> 9.10. Only force master/slave modes. So the preferred master is probably
> PHY defaults, bootstrap or eeprom.
> 
> drivers/net/ethernet/broadcom/tg3.c
> this driver seems to always force master mode
> 
> drivers/net/phy/broadcom.c:39
> if ethernet controller is BCMA_CHIP_ID_BCM53573 and the PHY is PHY_ID_BCM54210E
> then force master mode.
> 
> drivers/net/phy/micrel.c:637
> Force master mode if devicetree property is set: micrel,force-master
> 
> drivers/net/phy/realtek.c:173
> 	/* RTL8211C has an issue when operating in Gigabit slave mode * 
> 	return phy_set_bits(phydev, MII_CTRL1000,
> 		CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER)

Short of working around hardware issues, I wonder whether some of the
above is due to not reading or understanding the 802.3 recommendation.
However, it is just a recommendation, not a requirement.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
