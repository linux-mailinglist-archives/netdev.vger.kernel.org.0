Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EAB118FF6
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfLJSqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:46:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55744 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfLJSqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:46:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LC5ZIQF4aMAdhy0msRUf40fzfdlJt+bjYc9pWJEM/pY=; b=n9sb8OUoph1x4WTdTvU+BmBCC
        sg3GwKOcUqk9572tmCOW9/z3SqXJuW4QKqsqrH6Fw3fPsWeBvxq2arzHfg6iV41n5xN+wBsE8SIwe
        WIdlcTwftGk9aE8EGZ+bznBF1P12dv2NCK4SBburQVb2JDz9OuuWA7oiBUZmani5Or6fvehsrsh5g
        Eo43BeT1gcohHFQE/oyn2is0HbXh7Y1fReIsONDT7UMUejatRaMMeTdAscbQTCJZdPeFE/tvLNBg4
        ENE180uRDqiWMsUMa/F/bLezhMYnqkUzQhuYiqxL7dZMHwGyEQpqusX+CQikGYGiT4xKjqHBqeG3G
        RtAzvfRwA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47050)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iekWx-0003ES-2a; Tue, 10 Dec 2019 18:46:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iekWu-0004sA-O2; Tue, 10 Dec 2019 18:46:40 +0000
Date:   Tue, 10 Dec 2019 18:46:40 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 13/14] net: phy: add Broadcom BCM84881 PHY
 driver
Message-ID: <20191210184640.GU1344@shell.armlinux.org.uk>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKov-0004vw-Dk@rmk-PC.armlinux.org.uk>
 <557220a9-bdf4-868a-d9cd-a382ae80d288@gmail.com>
 <20191210175837.GY25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210175837.GY25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 05:58:37PM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Dec 10, 2019 at 09:34:16AM -0800, Florian Fainelli wrote:
> > On 12/9/19 7:19 AM, Russell King wrote:
> > > Add a rudimentary Clause 45 driver for the BCM84881 PHY, found on
> > > Methode DM7052 SFPs.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > 
> > > ---
> > >  drivers/net/phy/Kconfig    |   6 +
> > >  drivers/net/phy/Makefile   |   1 +
> > >  drivers/net/phy/bcm84881.c | 269 +++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 276 insertions(+)
> > >  create mode 100644 drivers/net/phy/bcm84881.c
> > > 
> > > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > > index fe602648b99f..41272106dea9 100644
> > > --- a/drivers/net/phy/Kconfig
> > > +++ b/drivers/net/phy/Kconfig
> > > @@ -329,6 +329,12 @@ config BROADCOM_PHY
> > >  	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
> > >  	  BCM5481, BCM54810 and BCM5482 PHYs.
> > >  
> > > +config BCM84881_PHY
> > > +	bool "Broadcom BCM84881 PHY"
> > > +	depends on PHYLIB=y
> > > +	---help---
> > > +	  Support the Broadcom BCM84881 PHY.
> > 
> > Cannot we make this tristate, I believe we cannot until there are more
> > fundamental issues (that you just reported) to be fixed, correct?
> 
> Indeed.  The problem I saw was that although the bcm84881 has the
> PHY correctly described, for whatever reason, the module was not
> loaded.
> 
> What I think is going in is that with modern udev userspace,
> request_module() is not functional, and we do not publish the
> module IDs for Clause 45 PHYs via uevent.  Consequently, there
> exists no mechanism to load a Clause 45 PHY driver from the
> filesystem.

I just attempted booting with sfp as a module, bcm84881 as a module.
sfp has to be loaded for the SFP cage to be recognised, so module
loading is availble prior to the PHY being known to the kernel.

The SFP is probed, and the PHY identified (via my debug):

[    7.209549] sfp sfp: phy PMA devid: 0xae02 0x5151

The PHY is not bound to its driver at this point.

We then try to connect to the PHY, but the support mask is zero,
so we know nothing about what modes this PHY supports:

[    7.215985] mvneta f1034000.ethernet eno2: phylink_sfp_connect_phy: s=00,00000000,00000000 a=00,00000000,00000000
[    7.215997] mvneta f1034000.ethernet eno2: validation with support 00,00000000,00000000 failed: -22
[    7.226343] sfp sfp: sfp_add_phy failed: -22

and we fail - because we are unable to identify what mode we should
configure the MAC side for, because we have no idea what the
capabilities of the PHY are at this stage.

We can't wait until we've called phylink_attach_phy(), because that
configures the PHY for the phy interface mode that was passed in.

There is no sign of the bcm84881 module being loaded.

This is the opposite problem to the one I recently posted about
regarding the 88e1111 issue, as here we rely on knowing something
about the PHY capabilities.

I think this is showing that phylink has a very difficult job trying
to match the capabilities of the SFP module with the capabilities of
the host MAC - we have no real idea what phy interface modes the
host MAC supports, or how the PHY is going to behave (which of the
many modes the PHY is going to choose for particular speeds.)
Plus the problem that the phylib support mask no longer reflects
the PHYs abilities after phy_attach_direct() has been called.

I thought I had something sorted, but only if the PHY driver is
built-in.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
