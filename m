Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA05D63439E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiKVS2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiKVS2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:28:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4C77ECB7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=t8JDH+3AbfADrh7/Opz3TChPLWbOr2PQbLNo8EnjFSU=; b=iUJ9Z2sm8xqdtkHaIbwRW7dusM
        6jcHOyNSIjZIrC1eJDMgww14xI7TJ9TalrYeirm5PHoPbh0kH9AHtg2sZQuifVpCLSZ9x+AgskUBT
        M2OaxBODoZzfJ1+g8qJzE0ubNdObId4bPZrvoGYiWn8QRzTnikDXypx+81BIfN1H0gLHfK83nnFZ4
        3lV8WATRXZ2ra9qp7I3OFQ1E2E4EE99NZk4Z8N3x698Uyeu5f4txbMUasbC/sxojUUehS2UlAy7VX
        6wkoIPLEYXlkGuYEM92kXmupI7TgDvNk47TSoTrF8HWrBF7SOddRWgPDk9xJTgYAYNncy9pE4mHzr
        6H99iFlw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35388)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxY0g-0001tN-1u; Tue, 22 Nov 2022 18:28:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxY0c-0003Vs-7S; Tue, 22 Nov 2022 18:28:38 +0000
Date:   Tue, 22 Nov 2022 18:28:38 +0000
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
Message-ID: <Y30U1tHqLw0SWwo1@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <Y3yvd0uyG2tNeED3@shell.armlinux.org.uk>
 <20221122121122.klqkw4onjxabyi22@skbuf>
 <Y3z/xcbYMQFM5SN4@shell.armlinux.org.uk>
 <20221122175603.soux2q2cxs2wfsun@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122175603.soux2q2cxs2wfsun@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 07:56:25PM +0200, Vladimir Oltean wrote:
> The problem is not phy_config_an_inband() but phy_validate_an_inband().
> We call that earlier than phy_attach_direct(), so if the PHY driver is
> going to read a register from HW which hasn't yet been written, we get
> an incorrect report of the current capabilities.

Why would it be "incorrect" ?

What the code I'm proposing correctly reports back what inband mode(s)
will be in use should we select the proposed interface mode. Let's
ignore whether we report the TIMEOUT or not for that statement, because
I think that's confusing the discussion.

If we _do_ want to report whether the TIMEOUT mode is going to be used
or not, the code I proposed is what will be necessary, because it
depends on (a) how the PHY is strapped and (b) how firmware or external
EEPROM has setup the device. If we want a single bit, then we would
report just _ON_TIMEOUT if bypass is enabled - but we still need to
read registers to come to a conclusion about whether it's enabled or
not. As I say, we can't blindly say "if interface is X, then bypass
will be enabled" for any X - and what may be correct for one board will
not be correct for another.

Moreover, in the 88e1111 case on a SFP, what's right for one SFP is not
right for another - there are SFPs where the 88e1111 registers are
preloaded from an EEPROM, so whether bypass is enabled or not in SGMII
mode is up to the contents of the EEPROM - the marvell PHY driver does
not interfere with that setting for SGMII.

Hence, to report how the PHY will behave in SGMII mode, with lack of
explicit configuration, we _have_ to read registers and use them to
determine the outcome.

> > > If you implement just validate(), you should report just one
> > > bit, corresponding to what the hardware is configured for (so either
> > > PHY_AN_INBAND_ON, *or* PHY_AN_INBAND_TIMEOUT). This is because you'd
> > > otherwise tell phylink that 2 modes are supported, but provide no way to
> > > choose between them, and you don't make it clear which one is in use
> > > either. This will force phylink to adapt to MLO_AN_PHY or MLO_AN_INBAND,
> > > depending on what has a chance of working.
> > 
> > Don't we have the same problem with PHY_AN_INBAND_TIMEOUT? If a PHY
> > reports that, do we use MLO_AN_INBAND or MLO_AN_PHY?
> 
> Well, I haven't yet written any logic for it.
> 
> To your question: "PHY_AN_INBAND_ON_TIMEOUT => MLO_AN_PHY or MLO_AN_INBAND"?
> I'd say either depending on situation, since my expectation is that it's
> compatible with both.

Yes, it would be compatible with both.

> Always give preference to what's in the device tree if it can work
> somehow. If it can work in fully compatible modes (MLO_AN_PHY with
> PHY_AN_INBAND_OFF; MLO_AN_INBAND with PHY_AN_INBAND_ON), perfect.
> If not, but what's in the device tree can work with PHY_AN_INBAND_ON_TIMEOUT,
> also good => use ON_TIMEOUT.

What do we do for a SFP module with a Marvell PHY on - we need to cover
that in this thought process, especially as 88e1111 is one of the most
popular PHYs on Gigabit copper SFPs. We can't really say "whatever
DT/ACPI firmware says" because that's not relevant to SFPs (we always
override firmware for SFPs.)

> If what's in the device tree needs to be changed, it pretty much means
> that ON_TIMEOUT isn't supported by the PHY.
> 
> Concretely, I would propose something like this (a modification of the
> function added by the patch set, notice the extra "an_inband" argument,
> as well as the new checks for PHY_AN_INBAND_ON_TIMEOUT):
> 
> static void phylink_sync_an_inband(struct phylink *pl, struct phy_device *phy,
> 				   enum phy_an_inband *an_inband)
> {
> 	unsigned int mode = pl->cfg_link_an_mode;
> 	int ret;
> 
> 	if (!pl->config->sync_an_inband)
> 		return;
> 
> 	ret = phy_validate_an_inband(phy, pl->link_config.interface);
> 	if (ret == PHY_AN_INBAND_UNKNOWN) {
> 		phylink_dbg(pl,
> 			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
> 			    phylink_autoneg_inband(mode) ? "true" : "false");
> 
> 		*an_inband = PHY_AN_INBAND_UNKNOWN;
> 	} else if (phylink_autoneg_inband(mode) &&
> 		   !(ret & PHY_AN_INBAND_ON) &&
> 		   !(ret & PHY_AN_INBAND_ON_TIMEOUT)) {
> 		phylink_err(pl,
> 			    "Requested in-band autoneg but driver does not support this, disabling it.\n");
> 
> 		mode = MLO_AN_PHY;
> 		*an_inband = PHY_AN_INBAND_OFF;
> 	} else if (!phylink_autoneg_inband(mode) &&
> 		   !(ret & PHY_AN_INBAND_OFF) &&
> 		   !(ret & PHY_AN_INBAND_ON_TIMEOUT)) {
> 		phylink_dbg(pl,
> 			    "PHY driver requests in-band autoneg, force-enabling it.\n");
> 
> 		mode = MLO_AN_INBAND;
> 		*an_inband = PHY_AN_INBAND_ON;
> 	} else {
> 		/* For the checks below, we've found a common operating
> 		 * mode with the PHY, just need to figure out if we
> 		 * agree fully or if we have to rely on the PHY's
> 		 * timeout ability
> 		 */
> 		if (phylink_autoneg_inband(mode)) {
> 			*an_inband = !!(ret & PHY_AN_INBAND_ON) ? PHY_AN_INBAND_ON :
> 					PHY_AN_INBAND_ON_TIMEOUT;
> 		} else {
> 			*an_inband = !!(ret & PHY_AN_INBAND_OFF) ? PHY_AN_INBAND_OFF :
> 					PHY_AN_INBAND_ON_TIMEOUT;
> 		}
> 	}
> 
> 	pl->cur_link_an_mode = mode;
> }
> 
> then call phy_config_an_inband() with "an_inband" as the mode to use.
> 
> As per Sean's feedback, we force the PHY to report at least one valid
> capability, otherwise, 0 is PHY_AN_INBAND_UNKNOWN and it's also treated
> correctly.
> 
> > > If you implement config_an_inband() too, then the validate procedure
> > > becomes a simple report of what can be configured for that PHY
> > > (OFF | ON | ON_TIMEOUT for 88E151x, and ON | ON_TIMEOUT for 88E1111).
> > > It's then the config_an_inband() procedure that applies to hardware the
> > > mode that is selected by phylink. From config_an_inband() you can return
> > > a negative error code on PHY I/O failure.
> > 
> > So it sounds like the decision about which mode to use needs to be
> > coupled with "does the PHY driver implement config_an_inband()"
> 
> So do you recommend that I should put a WARN_ON() somewhere, which
> asserts something like this?
> 
> "if the weight (number of bits set) in the return code of
> phy_validate_an_inband() is larger than 1, then phydev->drv->phy_config_an_inband()
> must be a non-NULL pointer, to allow selecting between them"

I think that would be a good idea, otherwise we are going to have to
rely on reviewers spotting this error, which given the way patches are
picked up on netdev, is prone to being missed. So, I think the more we
can encourage people to do it correctly first time, the better.

> > > If you can prepare some more formal patches for these PHYs for which I
> > > don't have documentation, I think I have a copper SFP module which uses
> > > SGMII and 88E1111, and I can plug it into the Honeycomb and see what
> > > happens.
> > 
> > I'm away from home at the moment, which means I don't have a way to
> > do any in-depth tests other than with the SFPs that are plugged into
> > my Honeycomb - which does include some copper SFPs but they're not
> > connected to anything. So I can't test to see if data passes until
> > I'm back home next week.
> 
> I actually meant that I can test on a Solidrun Honeycomb board that I
> happen to have access to, if you have some Marvell PHY code, even untested,
> that I could try out. I'm pretty much in the dark when it comes to their
> hardware documentation.

If we can agree on the reading-registers approach I suggested (with
the multi-bit return values corrected), then I can turn that into a
patch, but I think we need to come to agreement on that first.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
