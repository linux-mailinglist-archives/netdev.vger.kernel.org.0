Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DA256A855
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiGGQjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbiGGQiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:38:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7E6140DB
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:38:36 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eq6so23830970edb.6
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 09:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NP3TfXivDzPg8bQeGjHrAWUB1mJTjySus60GzDg+eos=;
        b=aY1eU7eh5VGYJMMV7kYcUpZPhcNUCB4Xo66u1UcF371ro2hh/DKUNUTPltyCDVJ4CP
         EQuXZTUo/NcUIVXkw+Saqp+oZ3Ie15ZsTuP9F4Kmtyqle4OS46ZNd3IHcgdSWCVdBOhY
         K9nm9Cc1D1o9B2ohPO0uVxdpnDbgphMgEKM/Ns21xpxWa0uYN4DDfM4QWAVWfxTysvgL
         dyuH82vSfbaQ4/+qHbHiwoomUMudko1BhQgu7WFRA7DtKhYI8lItHuOvznhTFqd2OVYa
         ECljs9pPAVErICSPpTbXYPjGEIc1aXJiWwoOoCPMcfm8mdOm9P8r/e1kudUs40FbOBSA
         VTOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NP3TfXivDzPg8bQeGjHrAWUB1mJTjySus60GzDg+eos=;
        b=EJOI5mCGO53UyVfeMGKL/3wF+La8aARs/mzyYwDXA8QyUjJkDd2dcVO78QuJyfsA+5
         rgrtEi3cYqcUXIGwY5AkCIqLKh70MqDFA/6mxrMDvBADJAOEAEzNf0OrH4bBOwdD/mDI
         8rP1NLcOH0Ym+eeYepEPNrrZe/IoRtAfUxg4VIKtIOoZifhVYZ9x6a4T4j/IvU8z6fFS
         KEQMbpXhDFbCQb3YYV/442JEk7Ke6Q/dRmeULtOdn+Wf2EBBUBIZh2+cZ4imWfS2J7qm
         5bj+f/1uamVsu0YZ2y2irxQNzpq+Il78WeCMQBTHp/6A1LI5Q+WwmMHZc9i60Hu/1VRi
         DP5w==
X-Gm-Message-State: AJIora9bWuWEH3xqUB5JAf9NMmAW/+N3mIdjHo/9VZM0cpeGtOeBjbkn
        wJKSpoV2DOt6jUlo+E+rYxc=
X-Google-Smtp-Source: AGRyM1vEb9oDaoNVrcyI2T+8spDg7aBx31ZYk8nGod2D881rK5sNRdQ35rcoAP1DFKu1Ipw2zgUvfQ==
X-Received: by 2002:a05:6402:3590:b0:43a:8156:e842 with SMTP id y16-20020a056402359000b0043a8156e842mr16654455edc.219.1657211915271;
        Thu, 07 Jul 2022 09:38:35 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id p19-20020aa7cc93000000b0042bdb6a3602sm27900357edt.69.2022.07.07.09.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 09:38:34 -0700 (PDT)
Date:   Thu, 7 Jul 2022 19:38:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <20220707163831.cjj54a6ys5bceb22@skbuf>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <YsW3KSeeQBiWQOz/@shell.armlinux.org.uk>
 <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
 <20220707152727.foxrd4gvqg3zb6il@skbuf>
 <YscAPP7mF3KEE1/p@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YscAPP7mF3KEE1/p@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 04:48:12PM +0100, Russell King (Oracle) wrote:
> On Thu, Jul 07, 2022 at 06:27:27PM +0300, Vladimir Oltean wrote:
> > On Thu, Jul 07, 2022 at 11:09:43AM +0100, Russell King (Oracle) wrote:
> > > On Wed, Jul 06, 2022 at 05:24:09PM +0100, Russell King (Oracle) wrote:
> > > > On Wed, Jul 06, 2022 at 01:26:21PM +0300, Vladimir Oltean wrote:
> > > > > Can we please limit phylink_set_max_link_speed() to just the CPU ports
> > > > > where a fixed-link property is also missing, not just a phy-handle?
> > > > > Although to be entirely correct, we can also have MLO_AN_INBAND, which
> > > > > wouldn't be covered by these 2 checks and would still represent a valid
> > > > > DT binding.
> > > > 
> > > > phylink_set_max_fixed_link() already excludes itself:
> > > > 
> > > >         if (pl->cfg_link_an_mode != MLO_AN_PHY || pl->phydev || pl->sfp_bus)
> >                                                       ~~~~~~~~~~
> > 
> > If not NULL, this is an SFP PHY, right? In other words, it's supposed to protect from
> > phylink_sfp_connect_phy() - code involuntarily triggered by phylink_create() ->
> > phylink_register_sfp() - and not from calls to phylink_{,fwnode_}connect_phy()
> > that were initiated by the phylink user between phylink_create() and
> > phylink_set_max_fixed_link(), correct? Those are specified as invalid in the
> > kerneldoc and that's about it - that's not what the checking is for, correct?
> 
> No, it's not to do with sfps at all, but to do with enforcing the
> pre-conditions for the function - that entire line is checking that
> (a) we are in a sane state to be called, and (b) there is no
> configuration initialisation beyond the default done by
> phylink_create() - in other words, there is no in-band or fixed-link
> specified.
> 
> Let's go through this step by step.
> 
> 1. pl->cfg_link_an_mode != MLO_AN_PHY
>    The default value for cfg_link_an_mode is MLO_AN_PHY. If it's
>    anything other than that, then a fixed-link or in-band mode has
>    been specified, and we don't want to override that. So this call
>    needs to fail.

Thanks for the explanation.

Yes, I noticed that phylink_set_max_fixed_link() relies on the fact that
pl->cfg_link_an_mode has the unset value of 0, which coincidentally is
MLO_AN_PHY.

> 2. pl->phydev
>    If a PHY has been attached, then the pre-condition for calling this
>    function immediately after phylink_create() has been violated,
>    because the only way it can be non-NULL is if someone's called one of
>    the phylink functions that connects a PHY. Note: SFPs will not set
>    their PHY here, because, for them to discover that there's a PHY, the
>    network interface needs to be up, and it will never be up here... but
>    in any case...

Ok, so this does check for a precondition that the caller did something
correctly. But it doesn't (and can't) check that all preconditions and
postconditions are satisfied. That's one of my irks, why bother checking
the easy to satisfy precondition (which depends on the code organization,
static information, easy to check), and give up on the hard one (which
depends on the device tree blob, dynamic information, not so easy).

> > So this is what I don't understand. If we've called phylink_set_max_fixed_link()
> > we've changed pl->cfg_link_an_mode to MLO_AN_FIXED and this will
> > silently break future calls to phylink_{,fwnode_}connect_phy(), so DSA
> > predicts if it's going to call either of those connect_phy() functions,
> > and calls phylink_set_max_fixed_link() only if it won't. Right?
> > 
> > You've structured the checks in this "distributed" way because phylink
> > can't really predict whether phylink_{,fwnode_}connect_phy() will be
> > called after phylink_set_max_fixed_link(), right? I mean, it can
> > probably predict the fwnode_ variant, but not phylink_connect_phy, and
> > this is why it is up to the caller to decide when to call and when not to.
> 
> phylink has no idea whether phylink_fwnode_connect_phy() will be called
> with the same fwnode as phylink_create(), so it really can't make any
> assumptions about whether there will be a PHY or not.

This is interesting. Is there a use case for passing a different
fwnode_handle to the 2 functions?

> > It should maybe also
> > say that this function shouldn't be called if phylink_{,fwnode_}connect_phy()
> > is going to be called later.
> 
> It's already a precondition that phylink_{,fwnode_}connect_phy() fail if
> we're in fixed-link mode (because PHYs have never been supported when in
> fixed-link mode - if one remembers, the old fixed-link code used to
> provide its own emulation of a PHY to make fixed-links work.) So PHYs
> and fixed-links have always been mutually exclusive before phylink, and
> continue to be so with phylink.

Define "fail" exactly, because if I look in phylink_fwnode_phy_connect(), I see:

	/* Fixed links and 802.3z are handled without needing a PHY */
	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
	     phy_interface_mode_is_8023z(pl->link_interface)))
		return 0; <- does this count as failure?

This is why dsa_port_phylink_register() calls phylink_of_phy_connect()
without checking whether it has a fixed-link or a PHY, because it
doesn't fail even if it doesn't do anything.

In fact I've wanted to make a correction to my previous phrasing that
"this function shouldn't be called if phylink_{,fwnode_}connect_phy() is
going to be called later". The correction is "... with a phy-handle".

> > Can phylink absorb all this logic, and automatically call phylink_set_max_fixed_link()
> > based on the following?
> > 
> > (1) struct phylink_config gets extended with a bool fallback_max_fixed_link.
> > (2) DSA CPU and DSA ports set this to true in dsa_port_phylink_register().
> > (3) phylink_set_max_fixed_link() is hooked into this -ENODEV error
> >     condition from phylink_fwnode_phy_connect():
> > 
> > 	phy_fwnode = fwnode_get_phy_node(fwnode);
> > 	if (IS_ERR(phy_fwnode)) {
> > 		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> > 			return -ENODEV; <- here
> > 		return 0;
> > 	}
> 
> My question in response would be - why should this DSA specific behaviour
> be handled completely internally within phylink, when it's a DSA
> specific behaviour? Why do we need boolean flags for this?

Because the end result will be simpler if we respect the separation of
concerns that continues to exist, and it's still phylink's business to
say what is and isn't valid. DSA still isn't aware of the bindings
required by phylink, it just passes its fwnode to it. Practically
speaking, I wouldn't be scratching my head as to why we're checking for
half the prerequisites of phylink_set_max_fixed_link() in one place and
for the other half in another.

True, through this patch set DSA is creating its own context specific
extension of phylink bindings, but arguably those existed before DSA was
even integrated with phylink, and we're just fixing something now we
didn't realize at the time we'd need to do.

I can reverse the question, why would phylink even want to be involved
in how the max fixed link parameters are deduced, and it doesn't just
require that a fixed-link software node is constructed somehow
(irrelevant to phylink how), and phylink is just modified to find and
work with that if it exists? Isn't it for the exact same reason,
separation of concerns, that it's easiest for phylink to figure out what
is the most appropriate maximum fixed-link configuration?
