Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1354E62F7D8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239931AbiKROk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242391AbiKROkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:40:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D58E942E7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kwDOG37a3Gsci445Bw59Z+QTXrhYVEo2Kkn0RWwaYew=; b=awxDbdBbGdLfhbSQ+BmI0jJMu+
        cij8UgSJ8ElblUUnC2rMjzrjfnTbkAc0hVnuiM2vTztPhdl59DplQY8s0oEZMszZR7zMYg3o71kP6
        ML7vtqfQjldt6QN2qZ97TnDz2On4VmIPvsEYKrFEZaRYN9N+vhiQxtFNBp17gRfGx9ChJvMeCnWI5
        UoBTDtAW+XPQzkAMJBiNyDVPJ1SuOQsCa4x2+RrZ8b9BK1LxqCpvfXd5FA4T30v+gTwpXgOsbfLMW
        DzEnQdcKj7zXpBiO/dhhpGYrpMiCo5fYBDMwM0Eb+Q6DnDAONi+r/Dx3puE45N8tyt+9dKrMwVLDN
        YM/1Ijyg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35330)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ow2UT-0005os-9Q; Fri, 18 Nov 2022 14:37:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ow2UN-0007pg-KK; Fri, 18 Nov 2022 14:37:07 +0000
Date:   Fri, 18 Nov 2022 14:37:07 +0000
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
Subject: Re: [PATCH v4 net-next 5/8] net: phylink: explicitly configure
 in-band autoneg for on-board PHYs
Message-ID: <Y3eYk1TJnLN+r86a@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-6-vladimir.oltean@nxp.com>
 <Y3dZ35RBf3z83Ph9@shell.armlinux.org.uk>
 <20221118112520.d7x5uppz256o4djm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118112520.d7x5uppz256o4djm@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 01:25:20PM +0200, Vladimir Oltean wrote:
> On Fri, Nov 18, 2022 at 10:09:35AM +0000, Russell King (Oracle) wrote:
> > On Fri, Nov 18, 2022 at 02:01:21AM +0200, Vladimir Oltean wrote:
> > > +	if (pl->config->sync_an_inband && !phy_on_sfp(phy)) {
> > 
> > Hmm, this phy_on_sfp() is new to me, and looking at the git history, I
> > really don't think this does what it claims to do. This returns the
> > status of phydev->is_on_sfp_module, which is set by this code:
> > 
> >         phydev->phy_link_change = phy_link_change;
> >         if (dev) {
> >                 phydev->attached_dev = dev;
> >                 dev->phydev = phydev;
> > 
> >                 if (phydev->sfp_bus_attached)
> >                         dev->sfp_bus = phydev->sfp_bus;
> >                 else if (dev->sfp_bus)
> >                         phydev->is_on_sfp_module = true;
> >         }
> > 
> > ... which is very wrong. "dev" here is the net_device, and a net_device
> > will have its sfp_bus member set when there is a SFP cage present,
> > which may be behind a off-SFP PHY.
> > 
> > This means that when a PHY is attached by the network driver in their
> > ndo_open, if there is a SFP bus on the interface (such as on the
> > Macchiatobin board), the above will set is_on_sfp_module true for the
> > on-board PHY even though it is not in the SFP module.
> > 
> > Essentially, commit b834489bcecc is incorrect, and needs to be fixed
> > before use is made of phy_on_sfp() outside of the broadcom driver.
> 
> IIUC, you're saying that if there is an SFP cage after an on-board PHY
> X (presumably set using phy_sfp_attach()), then PHY X will be declared
> as having phydev->is_on_sfp_module = true despite being on-board?

Having looked more deeply, I don't think it's the problem I thought it
was, so you're all good with using phy_on_sfp(). Sorry for the noise.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
