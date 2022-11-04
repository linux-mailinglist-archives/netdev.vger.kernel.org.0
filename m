Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9050E619A7C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiKDOsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiKDOsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:48:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07042AC68
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sw3B1qMBWh6mIdfa85clZs4lXC928i7LrwUgl5JsKyM=; b=ifZ5E70XJqlLKkxuq9xSfm4uZg
        sNkrDe6/64NmUGauEufGG1k0liXxXnR7ImSWL7F9vQQuM2OYtxyCmsA6f1cgGSNpOf3FyhhkndTqX
        Sdm9Crd2wwx4SYBkGY+bcs2dd13EZBGSeCot9fRNbvEoRVU1QItIfMG64eTESB3XYDy+mh0du5chG
        6fWicgJnllZNNE1lwvRr8Jf4nEqusCDJvQ0OvHq2wtEAq0XwHVJ2eu1WWYen8zYZk6Uhsvrk0id2A
        T3h6wSosnzLfDzWAVTo1jiJ2Ci785PGAO9sF6Mhps1PAvlNeBf91GPLf7d07sgUHMoRgwXiVIh7i3
        R9ge5xQg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35110)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oqxzS-0007jf-EB; Fri, 04 Nov 2022 14:48:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oqxzP-0000yp-K0; Fri, 04 Nov 2022 14:48:11 +0000
Date:   Fri, 4 Nov 2022 14:48:11 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Message-ID: <Y2UmK/z92VEUaMd9@shell.armlinux.org.uk>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
 <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
 <20221104133247.4cfzt4wcm6oei563@skbuf>
 <Y2UbK8/LLJwIZ3st@shell.armlinux.org.uk>
 <20221104142549.gdgolb6uljq3b7kc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104142549.gdgolb6uljq3b7kc@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 02:25:50PM +0000, Vladimir Oltean wrote:
> On Fri, Nov 04, 2022 at 02:01:15PM +0000, Russell King (Oracle) wrote:
> > On Fri, Nov 04, 2022 at 01:32:48PM +0000, Vladimir Oltean wrote:
> > > On Fri, Nov 04, 2022 at 11:35:08AM +0000, Russell King (Oracle) wrote:
> > > > On Fri, Nov 04, 2022 at 11:24:44AM +0000, Russell King (Oracle) wrote:
> > > > > There is one remaining issue that needs to be properly addressed,
> > > > > which is the bcm_sf2 driver, which is basically buggy. The recent
> > > > > kernel build bot reports reminded me of this.
> > > > > 
> > > > > I've tried talking to Florian about it, and didn't make much progress,
> > > > > so I'm carrying a patch in my tree which at least makes what is
> > > > > provided to phylink correct.
> > > > > 
> > > > > See
> > > > > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=63d77c1f9db167fd74994860a4a899df5c957aab
> > > > > and all the FIXME comments in there.
> > > > > 
> > > > > This driver really needs to be fixed before we kill DSA's
> > > > > phylink_validate method (although doing so doesn't change anything
> > > > > in mainline, but will remove my reminder that bcm_sf2 is still
> > > > > technically broken.)
> > > > 
> > > > Here's the corrected patch, along with a bit more commentry about the
> > > > problems that I had kicking around in another commit.
> > > 
> > > The inconsistencies in the sf2 driver seem valid - I don't know why/if
> > > the hardware doesn't support flow control on MoCA, internal ports and
> > > (some but not all?!) RGMII modes. I hope Florian can make some clarifications.
> > > 
> > > However, I don't exactly understand your choice of fixing this
> > > inconsistency (by providing a phylink_validate method). Why don't you
> > > simply set MAC_ASYM_PAUSE | MAC_SYM_PAUSE in config->mac_capabilities
> > > from within bcm_sf2_sw_get_caps(), only if we know this is an xMII port
> > > (and not for MoCA and internal PHYs)? Then, phylink_generic_validate()
> > > would know to exclude the "pause" link modes, right?
> > 
> > bcm_sf2_sw_get_caps() doesn't have visibility of which interface mode
> > will be used.
> 
> Update your tree, commit 4d2f6dde4daa ("net: dsa: bcm_sf2: Have PHYLINK
> configure CPU/IMP port(s)") has appeared in net-next and now the check
> in mac_link_up() is for phy_interface_is_rgmii().

Great, one less fixme. Still a couple remaining open.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
