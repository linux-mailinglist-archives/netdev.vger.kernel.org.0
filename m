Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA2B1AE001
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgDQOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 10:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgDQOgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 10:36:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BC5C061A0C;
        Fri, 17 Apr 2020 07:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uMnJdWpE9LzyRGubp/PgdKoG61E4/TxkLFDF6tiVVHc=; b=XFtOT7H0GNouani+JQxPyj0PN
        RS3vdxi8pa/AcTzBYRSAFr2lQIQ0ni7nMSCWf4iS8YkBCoVGeWiCLtI5msD6gMDUD4RUn4bI6G11d
        3miqYCYxjNpO8XQOQ81iFcwURn0iAZ/jxZ6wqdw6zriwMwzo+mmcEaqhtY4CNHJ8DFUTa0fMOCJbd
        TVhHxtK3nrn5a8niMR1MrSJAJkqci0WSTxeFxPCTdROg2/Zgqv/z+IODmDs/gHYfifQ8MgQQKUABR
        1iCgFoWVO81bDyta4MO4KQJcnqOQpQwUstVZ+Iq+4FqQZJnJXCpKyaVgdhN8m2KI6HFBkdAMgMO+l
        Desha99pw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47184)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jPS5x-0002Zr-RM; Fri, 17 Apr 2020 15:35:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jPS5s-0002wx-JO; Fri, 17 Apr 2020 15:35:48 +0100
Date:   Fri, 17 Apr 2020 15:35:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mkl@pengutronix.de
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200417143548.GS25745@shell.armlinux.org.uk>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415215739.GI657811@lunn.ch>
 <20200417101145.GP25745@shell.armlinux.org.uk>
 <20200417143239.GH744226@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417143239.GH744226@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 04:32:39PM +0200, Andrew Lunn wrote:
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
> 
> O.K. So i assume you mean we should read from the PHY at probe time
> what it is doing, in order to initialise dev->master_slave?
> 
> I would be happy with that.

Yes, I think it's a good idea to preserve the current operating mode
of the PHY as that's essentially what we're doing today by not
currently touching the bit.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
