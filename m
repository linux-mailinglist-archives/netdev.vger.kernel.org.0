Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7490956A93A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbiGGRQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbiGGRQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:16:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AA95A47D
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 10:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U98DsMJrp9V9Xsv6e0KzL3H3dc3snXiiKZfAaSGYqZc=; b=lh2uPKUSARX5UrfXRH9nkiKEKN
        uLz64EoEaBZ94vKg1Gxta/01zw95gS8JX12EMLKxzUY2ENWYr6mpNpWQdFo4ZtQd75jvyKRrzPpC+
        GPkQNrblVBtJldOkTxCs5ARHGTpl6WUXpyghoLB3DOka+18z7Gdo7fglsCIADBDYX18qRj9Nfb+jT
        15P/tmqBaUX22I4xCs7GNN81nUR9MhYhq0Gf1Dw7CODiar2bX90cBHg5euzlIDSSC70TaF38rbml9
        C8tlC8Nsl6jRe3ycdeYbrM+Y1Ciz2N6tQ5mMcmg1Lyfgli0FYbmL7O1qRjZNU8pJlbBWwNe4LQ0LC
        p6meKMLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33234)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o9V6X-0004B5-Td; Thu, 07 Jul 2022 18:15:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o9V6Q-0005RN-A0; Thu, 07 Jul 2022 18:15:46 +0100
Date:   Thu, 7 Jul 2022 18:15:46 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <YscUwrPnBZ3dzpQ/@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <YsW3KSeeQBiWQOz/@shell.armlinux.org.uk>
 <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
 <20220707152727.foxrd4gvqg3zb6il@skbuf>
 <YscAPP7mF3KEE1/p@shell.armlinux.org.uk>
 <20220707163831.cjj54a6ys5bceb22@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707163831.cjj54a6ys5bceb22@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 07:38:31PM +0300, Vladimir Oltean wrote:
> On Thu, Jul 07, 2022 at 04:48:12PM +0100, Russell King (Oracle) wrote:
> > Let's go through this step by step.
> > 
> > 1. pl->cfg_link_an_mode != MLO_AN_PHY
> >    The default value for cfg_link_an_mode is MLO_AN_PHY. If it's
> >    anything other than that, then a fixed-link or in-band mode has
> >    been specified, and we don't want to override that. So this call
> >    needs to fail.
> 
> Thanks for the explanation.
> 
> Yes, I noticed that phylink_set_max_fixed_link() relies on the fact that
> pl->cfg_link_an_mode has the unset value of 0, which coincidentally is
> MLO_AN_PHY.
> 
> > 2. pl->phydev
> >    If a PHY has been attached, then the pre-condition for calling this
> >    function immediately after phylink_create() has been violated,
> >    because the only way it can be non-NULL is if someone's called one of
> >    the phylink functions that connects a PHY. Note: SFPs will not set
> >    their PHY here, because, for them to discover that there's a PHY, the
> >    network interface needs to be up, and it will never be up here... but
> >    in any case...
> 
> Ok, so this does check for a precondition that the caller did something
> correctly. But it doesn't (and can't) check that all preconditions and
> postconditions are satisfied. That's one of my irks, why bother checking
> the easy to satisfy precondition (which depends on the code organization,
> static information, easy to check), and give up on the hard one (which
> depends on the device tree blob, dynamic information, not so easy).

So what you're asking is: why bother doing any checks if you can't do
all of them?

My response would be: isn't best effort better than doing nothing?

In my mind, it is best effort, because:

a) if you've called it when the preconditions (with the exception of a
future PHY) are not satisfied, then it fails with -EBUSY.
b) if this call succeeds, then it locks out the future ability to bind
a PHY.

So, if one forgets to check whether there'll be a future PHY, and call
this anyway, then a future attempt to bind a PHY to phylink fails and
you get a failure.

Considering that we are only talking about DSA making use of this (no
other network driver has this behaviour) and this is being handled by
core DSA code, we could label this up as "this is for DSA use only."

> > > So this is what I don't understand. If we've called phylink_set_max_fixed_link()
> > > we've changed pl->cfg_link_an_mode to MLO_AN_FIXED and this will
> > > silently break future calls to phylink_{,fwnode_}connect_phy(), so DSA
> > > predicts if it's going to call either of those connect_phy() functions,
> > > and calls phylink_set_max_fixed_link() only if it won't. Right?
> > > 
> > > You've structured the checks in this "distributed" way because phylink
> > > can't really predict whether phylink_{,fwnode_}connect_phy() will be
> > > called after phylink_set_max_fixed_link(), right? I mean, it can
> > > probably predict the fwnode_ variant, but not phylink_connect_phy, and
> > > this is why it is up to the caller to decide when to call and when not to.
> > 
> > phylink has no idea whether phylink_fwnode_connect_phy() will be called
> > with the same fwnode as phylink_create(), so it really can't make any
> > assumptions about whether there will be a PHY or not.
> 
> This is interesting. Is there a use case for passing a different
> fwnode_handle to the 2 functions?

That depends on the driver. It looks like
drivers/net/ethernet/ti/am65-cpsw-nuss.c may well pass in different nodes
in the firmware tree.

> > > It should maybe also
> > > say that this function shouldn't be called if phylink_{,fwnode_}connect_phy()
> > > is going to be called later.
> > 
> > It's already a precondition that phylink_{,fwnode_}connect_phy() fail if
> > we're in fixed-link mode (because PHYs have never been supported when in
> > fixed-link mode - if one remembers, the old fixed-link code used to
> > provide its own emulation of a PHY to make fixed-links work.) So PHYs
> > and fixed-links have always been mutually exclusive before phylink, and
> > continue to be so with phylink.
> 
> Define "fail" exactly, because if I look in phylink_fwnode_phy_connect(), I see:
> 
> 	/* Fixed links and 802.3z are handled without needing a PHY */
> 	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
> 	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> 	     phy_interface_mode_is_8023z(pl->link_interface)))
> 		return 0; <- does this count as failure?

Sorry, yes, that is correct - it ignores the attempt (so drivers don't
have to conditionalise the call for this everywhere.)

> This is why dsa_port_phylink_register() calls phylink_of_phy_connect()
> without checking whether it has a fixed-link or a PHY, because it
> doesn't fail even if it doesn't do anything.
> 
> In fact I've wanted to make a correction to my previous phrasing that
> "this function shouldn't be called if phylink_{,fwnode_}connect_phy() is
> going to be called later". The correction is "... with a phy-handle".

I'm not sure that clarification makes sense when talking about
phylink_connect_phy(), so I think if you're clarifying it with a
firmware property, you're only talking about
phylink_fwnode_connect_phy() now?

> > > Can phylink absorb all this logic, and automatically call phylink_set_max_fixed_link()
> > > based on the following?
> > > 
> > > (1) struct phylink_config gets extended with a bool fallback_max_fixed_link.
> > > (2) DSA CPU and DSA ports set this to true in dsa_port_phylink_register().
> > > (3) phylink_set_max_fixed_link() is hooked into this -ENODEV error
> > >     condition from phylink_fwnode_phy_connect():
> > > 
> > > 	phy_fwnode = fwnode_get_phy_node(fwnode);
> > > 	if (IS_ERR(phy_fwnode)) {
> > > 		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> > > 			return -ENODEV; <- here
> > > 		return 0;
> > > 	}
> > 
> > My question in response would be - why should this DSA specific behaviour
> > be handled completely internally within phylink, when it's a DSA
> > specific behaviour? Why do we need boolean flags for this?
> 
> Because the end result will be simpler if we respect the separation of
> concerns that continues to exist, and it's still phylink's business to
> say what is and isn't valid. DSA still isn't aware of the bindings
> required by phylink, it just passes its fwnode to it. Practically
> speaking, I wouldn't be scratching my head as to why we're checking for
> half the prerequisites of phylink_set_max_fixed_link() in one place and
> for the other half in another.
> 
> True, through this patch set DSA is creating its own context specific
> extension of phylink bindings, but arguably those existed before DSA was
> even integrated with phylink, and we're just fixing something now we
> didn't realize at the time we'd need to do.
> 
> I can reverse the question, why would phylink even want to be involved
> in how the max fixed link parameters are deduced, and it doesn't just
> require that a fixed-link software node is constructed somehow
> (irrelevant to phylink how), and phylink is just modified to find and
> work with that if it exists? Isn't it for the exact same reason,
> separation of concerns, that it's easiest for phylink to figure out what
> is the most appropriate maximum fixed-link configuration?

If that could be done, I'd love it, because then we don't have this in
phylink at all, and it can all be a DSA problem to solve. It also means
that others won't be tempted to use the interface incorrectly.

I'm not sure how practical that is when we have both DT and ACPI to deal
with, and ACPI is certainly out of my knowledge area to be able to
construct a software node to specify a fixed-link. Maybe it can be done
at the fwnode layer? I don't know.

Do you have a handy example of what you're suggesting?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
