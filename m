Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77D56A6DB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbiGGP1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiGGP1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:27:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAED2E69D
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 08:27:32 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id v12so10978721edc.10
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 08:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L+i2VKDCE1a0IVY2FYEleoaw7pLpG4up9Kj32QFKNUU=;
        b=imZ9ANuAa3a7nKrVOBBqe0V2bpJHfSjTkUz+CahjxlWI6osnO+cqvBX0vuAGRpAVwV
         iFCkDsEYyRSGcSOyyFcWt5h0BsduWYVW82w8/l59hfnC31fk9YilLFsdqFgMOr3P/aHs
         favxQISfH4ARGDeGFvun+Z7hXdlGSBYNYrDv2Z5jKDietGapf8YUNt3spDapLLYhzPNp
         rtkYgOx1pmkMqanv4uTwpVBGNz98WnZa/LyMnPoZJXSs6L3AjskftZfjMkO2Mvub4u+H
         MS/+GFFV/5vFtUOLbkRXfzVJdmWt87SKll888rx67Tjdp79km6SCyTlogUxTZbE60GFF
         RIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L+i2VKDCE1a0IVY2FYEleoaw7pLpG4up9Kj32QFKNUU=;
        b=Gkz4Fq72ihJX1DbogT09Z+s6+qD0unzkgN5JDSebQi+LXXEElM3QdLQtFhqtYwT9Qh
         Wv8hBgSxby+4iFLp/AkGCNskZjUMqzZPLC2npYa6WD+twAJKjrAkIc94dDdJHEYWqp/p
         ta314PtdVKSiYMAZPX4pC/IdggZL+b5T6qiIvpn8aDTS4x3oNXJRF44PT8w9HY6eeoJN
         HYnbNN/lTVCQR95mjs7l7Oc8uPuxwzWW8RprCY8/mufOWCQbS0efHLYbdRdBFrb6hcGu
         WBICwEelkeaFrpPRyuIEtNzCj6plCuFoSSOwx32ANNXRY5Eu0uIeUVU51o/lY6NFiTJO
         LEEw==
X-Gm-Message-State: AJIora+SJarJnSfVqXzBai0zkf0g2WbXDy9Bw4QQ44F+ApQzAIOk/ETO
        xghC1mnrv+3pLzB3omEeO+o=
X-Google-Smtp-Source: AGRyM1tt4zPclKXxrskJcAhd0l4cLyni1GDXPAelDG0Cead02xKNZE5V4PhtrG18Fbv3SVXuYD+PRg==
X-Received: by 2002:a05:6402:3307:b0:43a:826c:d8b4 with SMTP id e7-20020a056402330700b0043a826cd8b4mr16134904eda.32.1657207650767;
        Thu, 07 Jul 2022 08:27:30 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id kw24-20020a170907771800b0072a3216c23asm11915163ejc.154.2022.07.07.08.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 08:27:29 -0700 (PDT)
Date:   Thu, 7 Jul 2022 18:27:27 +0300
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
Message-ID: <20220707152727.foxrd4gvqg3zb6il@skbuf>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <YsW3KSeeQBiWQOz/@shell.armlinux.org.uk>
 <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 11:09:43AM +0100, Russell King (Oracle) wrote:
> On Wed, Jul 06, 2022 at 05:24:09PM +0100, Russell King (Oracle) wrote:
> > On Wed, Jul 06, 2022 at 01:26:21PM +0300, Vladimir Oltean wrote:
> > > Can we please limit phylink_set_max_link_speed() to just the CPU ports
> > > where a fixed-link property is also missing, not just a phy-handle?
> > > Although to be entirely correct, we can also have MLO_AN_INBAND, which
> > > wouldn't be covered by these 2 checks and would still represent a valid
> > > DT binding.
> > 
> > phylink_set_max_fixed_link() already excludes itself:
> > 
> >         if (pl->cfg_link_an_mode != MLO_AN_PHY || pl->phydev || pl->sfp_bus)
                                                      ~~~~~~~~~~

If not NULL, this is an SFP PHY, right? In other words, it's supposed to protect from
phylink_sfp_connect_phy() - code involuntarily triggered by phylink_create() ->
phylink_register_sfp() - and not from calls to phylink_{,fwnode_}connect_phy()
that were initiated by the phylink user between phylink_create() and
phylink_set_max_fixed_link(), correct? Those are specified as invalid in the
kerneldoc and that's about it - that's not what the checking is for, correct?

But if so, why even check for pl->phydev, if you check for pl->sfp_bus?

> >                 return -EBUSY;
> > 
> > intentionally so that if there is anything specified for the port, be
> > that a fixed link or in-band, then phylink_set_max_fixed_link() errors
> > out with -EBUSY.
> > 
> > The only case that it can't detect is if there is a PHY that may be
> > added to phylink at a later time, and that is what the check above
> > is for.

Here by "PHY added at a later time", you do mean calling phylink_{,fwnode_}connect_phy()
after phylink_set_max_fixed_link(), right?

So this is what I don't understand. If we've called phylink_set_max_fixed_link()
we've changed pl->cfg_link_an_mode to MLO_AN_FIXED and this will
silently break future calls to phylink_{,fwnode_}connect_phy(), so DSA
predicts if it's going to call either of those connect_phy() functions,
and calls phylink_set_max_fixed_link() only if it won't. Right?

You've structured the checks in this "distributed" way because phylink
can't really predict whether phylink_{,fwnode_}connect_phy() will be
called after phylink_set_max_fixed_link(), right? I mean, it can
probably predict the fwnode_ variant, but not phylink_connect_phy, and
this is why it is up to the caller to decide when to call and when not to.

> I've updated the function description to mention this detail:
> 
> +/**
> + * phylink_set_max_fixed_link() - set a fixed link configuration for phylink
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * Set a maximum speed fixed-link configuration for the chosen interface mode
> + * and MAC capabilities for the phylink instance if the instance has not
> + * already been configured with a SFP, fixed link, or in-band AN mode. If the
> + * interface mode is PHY_INTERFACE_MODE_NA, then search the supported
> + * interfaces bitmap for the first interface that gives the fastest supported
> + * speed.
> 
> Does this address your concern?
> 
> Thanks.

Not really, no, sorry, it just confuses me more. It should maybe also
say that this function shouldn't be called if phylink_{,fwnode_}connect_phy()
is going to be called later.

Can phylink absorb all this logic, and automatically call phylink_set_max_fixed_link()
based on the following?

(1) struct phylink_config gets extended with a bool fallback_max_fixed_link.
(2) DSA CPU and DSA ports set this to true in dsa_port_phylink_register().
(3) phylink_set_max_fixed_link() is hooked into this -ENODEV error
    condition from phylink_fwnode_phy_connect():

	phy_fwnode = fwnode_get_phy_node(fwnode);
	if (IS_ERR(phy_fwnode)) {
		if (pl->cfg_link_an_mode == MLO_AN_PHY)
			return -ENODEV; <- here
		return 0;
	}
