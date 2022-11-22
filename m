Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA57634207
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiKVQ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbiKVQ7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:59:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A1A77224
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=69nH0RI3iuA5enQC27WDsYtIbPWuoNXd8dSZAEzsLgA=; b=Qg0XwflVi5E5rlIc0/JIuzNWhp
        TLzCqwFU82ordjzSy8IRNUUHMd7RddH7/4YP+zaYeapSmfx2xd2cxZzdrzIdfafZgd/ycNIlmjmRe
        2+maMn6uyz2myYoUn/NSsZTFr5vRNUR/mXONZKnN/a3ztfkZalDswD4GqhB0cRnHm1YtUFpmvESsH
        SmELGNrPnWv3hwM8BRLBBlm3FGdusi9IaQBo2mxvNhOShvbD+hqbwP7LYLkeuAKoZ5j168C4T1xS1
        gZCWq97cjWCnFKKo4KioKGf0iwpFvqkr9Q2TpPMArgWhfZSG+FCX4a+pia9XYfVgWaggLXPHwUN3c
        W7Xumxvw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35382)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxWbk-0001ly-7H; Tue, 22 Nov 2022 16:58:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxWbd-0003Sa-JP; Tue, 22 Nov 2022 16:58:45 +0000
Date:   Tue, 22 Nov 2022 16:58:45 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122121122.klqkw4onjxabyi22@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:11:22PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 22, 2022 at 11:16:07AM +0000, Russell King (Oracle) wrote:
> > On Tue, Nov 22, 2022 at 09:38:43AM +0000, Russell King (Oracle) wrote:
> > > Also, if we get the Marvell driver implementing validate_an_inband()
> > > then I believe we can get rid of other parts of this patch - 88E1111 is
> > > the commonly used accessible PHY on gigabit SFPs, as this PHY implements
> > > I2C access natively. As I mentioned, Marvell PHYs can be set to no
> > > inband, requiring inband, or inband with bypass mode enabled. So we
> > > need to decide how we deal with that - especially if we're going to be
> > > changing the mode from 1000base-X to SGMII (which we do on some SFP
> > > modules so they work at 10/100/1000.)
> > 
> > For the Marvell 88E1111:
> > 
> > - If switching into 1000base-X mode, then bypass mode is enabled by
> > m88e1111_config_init_1000basex(). However, if AN is disabled in the
> > fibre page BMCR (e.g. by firmware), then AN won't be used.
> > 
> > - If switching into SGMII mode, then bypass mode is left however it was
> > originally set by m88e1111_config_init_sgmii() - so it may be allowed
> > or it may be disallowed, which means it's whatever the hardware
> > defaulted to or firmware set it as.
> > 
> > For the 88e151x (x=0,2,8) it looks like bypass mode defaults to being
> > allowed on hardware reset, but firmware may change that.
> > 
> > I don't think we make much of an effort to configure other Marvell
> > PHYs, relying on their hardware reset defaults or firmware to set
> > them appropriately.
> > 
> > So, I think for 88e151x, we should implement something like:
> > 
> > 	int mode, bmcr, fscr2;
> > 
> > 	/* RGMII too? I believe RGMII can signal inband as well, so we
> > 	 * may need to handle that as well.
> > 	 */
> > 	if (interface != PHY_INTERFACE_MODE_SGMII &&
> > 	    interface != PHY_INTERFACE_MODE_1000BASE_X)
> > 		return PHY_AN_INBAND_UNKNOWN;
> > 
> > 	bmcr = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR);
> > 	if (bmcr < 0)
> > 		return SOME_ERROR?
> 
> There's a limitation in the API presented here, you can't return
> SOME_ERROR, you have to return PHY_AN_INBAND_UNKNOWN and maybe log the
> error to the console. If the error persists, other PHY methods will
> eventually catch it.

Right.

> > 
> > 	mode = PHY_AN_INBAND_OFF;
> > 
> > 	if (bmcr & BMCR_ANENABLE) {
> > 		mode = PHY_AN_INBAND_ON;
> > 
> > 		fscr2 = phy_read_paged(phydev, MII_MARVELL_FIBER_PAGE,
> > 				       0x1a);
> > 		if (fscr2 & BIT(6))
> > 			mode |= PHY_AN_INBAND_TIMEOUT;
> > 	}
> > 
> > 	return mode;
> > 
> > Obviously adding register definitions for BIT(6) and 01a.
> > 
> > For the 88E1111:
> > 
> > 	int mode, hwcfg;
> > 
> > 	/* If operating in 1000base-X mode, we always turn on inband
> > 	 * and allow bypass.
> > 	 */
> > 	if (interface == PHY_INTERFACE_MODE_1000BASEX)
> > 		return PHY_AN_INBAND_ON | PHY_AN_INBAND_TIMEOUT;
> > 
> > 	if (interface == PHY_INTERFACE_MODE_SGMII) {
> > 		hwcfg = phy_read(phydev, MII_M1111_PHY_EXT_SR);
> > 		if (hwcfg < 0)
> > 			return SOME_ERROR?
> > 
> > 		mode = PHY_AN_INBAND_ON;
> > 		if (hwcfg & MII_M1111_HWCFG_SERIAL_AN_BYPASS)
> > 			mode |= PHY_AN_INBAND_TIMEOUT;
> > 
> > 		return mode;
> > 	}
> > 
> > 	return PHY_AN_INBAND_UNKNOWN;
> > 
> > Maybe?
> 
> Hmm, not quite (neither for 88E151x not 88E1111). The intention with the
> validate()/config() split is that you either implement just validate(),
> or both.

The intention of the above is to report how the PHY is going to behave
with the current code when the PHY is in operation, which I believe to
be the intention of the validate callback. I'm not proposing at the
moment to add the config() part, although that can be done later.

As I stated, with the 88e1111, if we are asked to operate in 1000base-X
mode, when we configure the PHY we will allow bypass mode and I believe
in-band will be enabled, because this is what config_init() does today
when operating in 1000base-X mode. If we add support for your config()
method, then we will need a way to prevent a later config_init()
changing that configuration.

For SGMII, things are a lot more complicated, the result depends on how
the PHY has been setup by firmware or possibly reset pin strapping, so
we need to read registers to work out how it's going to behave. So,
unless we do that, we just can't report anything with certainty. We
probably ought to be reading a register to check that in-band is indeed
enabled.

Note that a soft-reset doesn't change any of this - it won't enable
in-band if it was disabled, and it won't disable it if it was previously
set to be enabled.

> If you implement just validate(), you should report just one
> bit, corresponding to what the hardware is configured for (so either
> PHY_AN_INBAND_ON, *or* PHY_AN_INBAND_TIMEOUT). This is because you'd
> otherwise tell phylink that 2 modes are supported, but provide no way to
> choose between them, and you don't make it clear which one is in use
> either. This will force phylink to adapt to MLO_AN_PHY or MLO_AN_INBAND,
> depending on what has a chance of working.

Don't we have the same problem with PHY_AN_INBAND_TIMEOUT? If a PHY
reports that, do we use MLO_AN_INBAND or MLO_AN_PHY?

> If you implement config_an_inband() too, then the validate procedure
> becomes a simple report of what can be configured for that PHY
> (OFF | ON | ON_TIMEOUT for 88E151x, and ON | ON_TIMEOUT for 88E1111).
> It's then the config_an_inband() procedure that applies to hardware the
> mode that is selected by phylink. From config_an_inband() you can return
> a negative error code on PHY I/O failure.

So it sounds like the decision about which mode to use needs to be
coupled with "does the PHY driver implement config_an_inband()"

> If you can prepare some more formal patches for these PHYs for which I
> don't have documentation, I think I have a copper SFP module which uses
> SGMII and 88E1111, and I can plug it into the Honeycomb and see what
> happens.

I'm away from home at the moment, which means I don't have a way to
do any in-depth tests other than with the SFPs that are plugged into
my Honeycomb - which does include some copper SFPs but they're not
connected to anything. So I can't test to see if data passes until
I'm back home next week.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
