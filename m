Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489BE581D1C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 03:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbiG0B3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 21:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240088AbiG0B3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 21:29:36 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACC13AE61;
        Tue, 26 Jul 2022 18:29:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u12so14610722edd.5;
        Tue, 26 Jul 2022 18:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sNkEEbfxOKoG5t7LW8DamTowiN1UEHShsKbyg1fBxQo=;
        b=h9qQ8+o5mKMe8goCk6mW4j8/05B8Og9A+kLN1ae6W6vI4CxUuPqhoatqEuTvXkvtfo
         5lj2TcArNI51CmMCA1GShhCctHzzJhrGUR8Qo6oB/dnt9OLEz8pvd+ogAkGO+J6nKG5F
         Brc9Ndw8sXlzPftO9omI5PIaT7MkUaeqfUttBOrgsbJ9NP85sB86F5AINGpUhCffYtlW
         Ap39e/TUptli+CZ4nTyn1k2OhkEUM22ViUaBv91oMLPLu33cgGqMm9PU5dEObhEkO4Cp
         o/2f+dbFjQItEyQnjsJ7UTahb992e9eEWVbDbeSuk5bxGcEomYWv6zWNPeUqRTedWxHo
         pW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sNkEEbfxOKoG5t7LW8DamTowiN1UEHShsKbyg1fBxQo=;
        b=SGLSKoKOdUg+V8exDSGnxqELntz50N9MRViGD7LnljMpvgV+CLqLGcoqlaHH21N1Y/
         mboPwshAxr9EpSiNkt/GlPFRXM4IWWOeCJS+ULJW0db3Lk8R3oCRyUiF1wE5QCuMGaYI
         5YuWnukWpBmL4PyI9VuazLzwzlka3wUGOd+UMDKMogUR4c4en/RpR8pPVgFuA9mycUCs
         UrCKQUtFZIlASbfPeBQTTr/jrbMRuHgXPNYEOumTeQi5Wn+dGnQ+DUbq7XqNy+9/lVTy
         d6tMphwxqhwkDpUBdsynxj8I3lth75TLm7TlqLK0IwQVxRAlNU8TuZtqcmKerlkMXwLZ
         Uc9w==
X-Gm-Message-State: AJIora80vQyW7CW8azUDgcucyAlK7vIarGZy3HKB2owet7p2VW94j898
        DCX41DzBLkLX2Fl78rFkA7s=
X-Google-Smtp-Source: AGRyM1tccC+702TUsEw00h3iGJ4WbgK45KK608bhgLIaMnf9vLOh7vq8Bnne33mULiNjlNkk9wniOQ==
X-Received: by 2002:a05:6402:5518:b0:43a:9e32:b6fc with SMTP id fi24-20020a056402551800b0043a9e32b6fcmr21371830edb.252.1658885372927;
        Tue, 26 Jul 2022 18:29:32 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id en21-20020a17090728d500b0072b342ad997sm7083205ejc.199.2022.07.26.18.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 18:29:32 -0700 (PDT)
Date:   Wed, 27 Jul 2022 04:29:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all
 ports
Message-ID: <20220727012929.bcptskmb75kr7w6y@skbuf>
References: <20220725214942.97207-1-f.fainelli@gmail.com>
 <20220726112344.3ar7s7khiacqueus@skbuf>
 <174b5e64-a250-e1b2-43b9-474b915ddc22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174b5e64-a250-e1b2-43b9-474b915ddc22@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 09:14:17AM -0700, Florian Fainelli wrote:
> > This begs the natural question, is overriding the link status ever needed?
> 
> It was until we started to unconditionally reset the switch using the
> "external" reset method as opposed to the "internal" reset method
> which turned out not to be functional:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eee87e4377a4b86dc2eea0ade162b0dc33f40576

Ok, I see.

> At any rate (no pun intended), 4908 will want a 2GBit/sec IMP port to
> be set-up and we have no way to do that other than by forcing that
> setting, either through the bcm_sf2_imp_setup() method or via a hack
> to the mac_link_up() callback. This is kind of orthogonal in the sense
> that there is no "official" support for speed 2000 mbits/sec anyway in
> the emulated SW PHY, PHYLINK or anywhere in between but if we want to
> fully transition over to PHYLINK to configure all ports, which is
> absolutely the goal, we will need to find a solution one way or
> another.

So I made some tests with speed = <2000>; in the device tree and in a
way I'm more confused than when I started. I was expecting phylink_validate()
to somehow fail but this isn't at all what happened. Instead everything
seems to work just fine, minus some ergonomic details (some prints).

So in the case of a fixed-link, phylink_validate() is actually called
twice, once directly from phylink_create() and once almost immediately
afterwards from phylink_parse_fixedlink(). Both validations are of the
inquisitive kind rather than the confrontational kind, i.e. their return
value isn't checked, and "pl->supported"/"pl->link_config.advertising"
are initially filled by phylink with all ones, in order for the driver
to reduce this to all link mode bits that are supported.
Minor side note, this second validation done during fixed-link parsing
is redundant IMO, because nothing relevant inside the arguments that we
pass to pl->mac_ops->validate() will have changed in any way between the
calls.

Anyway, if phylink_validate() is never going to confront us about the
pl->supported link mode mask becoming zero, you might wonder why it
calls even inquisitively in the first place.

Essentially phylink_parse_fixedlink() just wants to print in case it's
using a link speed that isn't supported by the driver. To do that, it
calls phy_lookup_setting() where one of the arguments is pl->supported
itself. But in our case, there is no link mode for speed 2000, although
that shouldn't matter, since no Ethernet PHY sees or needs to advertise
this speed, so phy_lookup_setting() finds nothing. I suspect this is
largely due to historical reasons, where the link modes were the common
denominator at the level of the driver visible phylink_validate() API.
Today we may simply extend config->mac_capabilities and forgo adding
bogus link modes just for this to work.

Curiously, even if we go to the extra lengths of silencing phylink's
"fixed link not recognised" warning, nothing seems to be broken even if
we don't do that.

Immediately after pl->supported has been populated by the inquisitive
phylink_validate(), phylink clears it (which means that the pl->supported
variable used above could have very well been just a temporary on-stack
variable), and just populates some fields.
Namely the pause fields, and a *single* speed, corresponding to "s"
(what phy_lookup_setting() found).

	linkmode_zero(pl->supported);
	phylink_set(pl->supported, MII);
	phylink_set(pl->supported, Pause);
	phylink_set(pl->supported, Asym_Pause);
	phylink_set(pl->supported, Autoneg);
	if (s) {
		__set_bit(s->bit, pl->supported);
		__set_bit(s->bit, pl->link_config.lp_advertising);
	} else {
		phylink_warn(pl, "fixed link %s duplex %dMbps not recognised\n",
			     pl->link_config.duplex == DUPLEX_FULL ? "full" : "half",
			     pl->link_config.speed);
	}

Why phylink even bothers to keep the speed-related linkmode in
pl->supported, if it won't use it anywhere further, I can't answer.
I can even delete the "if (s) ... else ..." block altogether and nothing
seems to be adversely impacted.

In any case, the short version of the code walkthrough is that phylink
can apparently operate in fixed-link mode with a pl->supported and
pl->link_config.lp_advertising mask of link modes that doesn't contain
any speed, and this won't generate any error, although I'm not completely
sure it was intended either.

> I would prefer if also we sort of "transferred" the 'fixed-link'
> parameters from the DSA Ethernet controller attached to the CPU port
> onto the PHYLINK instance of the CPU port in the switch as they ought
> to be strictly identical otherwise it just won't work. This would
> ensure that we continue to force the link and it would make me sleep
> better a night to know that the IMP port is operating strictly the
> same way it was. My script compares register values before/after for
> the registers that are static and this was flagged as a difference.

There are several problems with transferring the parameters. Most
obvious derives from what we discussed about speed = <2000> just above:
the DSA master won't have it, either, because it's a non-standard speed.
Additionally, the DSA master may be missing the phy-mode too.

Second has to do with how we transfer the phy-mode assuming it isn't
missing on the master. RGMII modes are clearly problematic precisely
because we have so many driver interpretations of what they mean.
But "mii" and "rmii" aren't all that clear-cut either. Do we translate
into "mii" and "rmii" for DSA, or "rev-mii" and "rev-rmii"?
bcm_sf2 understands "rev-mii", but mv88e6xxx doesn't.
