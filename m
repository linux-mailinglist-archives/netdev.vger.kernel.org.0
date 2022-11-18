Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E2962FABE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbiKRQtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiKRQtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:49:20 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B968810B52;
        Fri, 18 Nov 2022 08:49:18 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id t25so14404143ejb.8;
        Fri, 18 Nov 2022 08:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ISq3CC3wQQoH9QZGauiQqCQOpxu3L8pBDT4KpuCruk=;
        b=UoRHeVlmQxb12jSRsPoXtHs9FO+NdTRv3weDmoPQn+v5WqAYqEpPd09jKbHMXf5yLN
         M1LP2eMqJGqndro/5BCCfBb/EmUZrNH99Wy9jnJ0EEcXlyHe6S5oEtZojQHWT1jv42j2
         TH5cBKjv+nfHTlNEV2U9X3hh962LQkIWxgSefetcOO/V1VZwgqyvOgeFoyKV2TZx0Ayi
         AmDYtr18go6lLs8te0j5f4nnwOjwVzRYwaPyGi0xfUCBZ1xOTJosHxMF0E48+3kxVxBF
         Ot8/PDYRg9E97ZH8D2EXzP3um+wzvOkmOkaVMxijClMjHAsoy5FpTeqNWST01ICDJJsM
         DgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ISq3CC3wQQoH9QZGauiQqCQOpxu3L8pBDT4KpuCruk=;
        b=ok4Pcg7grce34kAmYvzQzOILu4EeereeY0F2AtICWC5/J+w1Ur8NdYGObTYnzX3r3G
         XUzYoFvcueTQu1PB2tHNe3JzW79g1FWotkRZFi5rEwQ/HkpqcEOCI6ZHq9wRpb3VfcpX
         1+x6tDV19QtziblP7SR7zKSxvKDa9t2mMeCN3QSZM46BYeAovAWFwW3ptK32n+vxnEs4
         tisWR4kPJ1qZie8QK8ibQ/fMmneVdLHxG6erlQSFV3nPMPjz2Izd9NJADs+AfwRytq3v
         tXWdn7/0QZV6xzHr78gPp+9LtZtcdi8Rr29cFhw5/0gNFzC/5655KOCy428wLFX757uK
         ZL1g==
X-Gm-Message-State: ANoB5pn//QkZLN37CmoYkOLbvXdv6IXfyxfWZidlGGRyFYhXYtcrqxw1
        W8d7a5+2CzUXWERTLyoG4ms=
X-Google-Smtp-Source: AA0mqf7rPZO2ztC9aPlixHNN/gqYG6ZoOOJoIct1C7n0qVYan2n63dUFchn6RYToPXCqHr9wgWotkw==
X-Received: by 2002:a17:906:95c3:b0:78e:975:5e8 with SMTP id n3-20020a17090695c300b0078e097505e8mr6730438ejy.82.1668790157050;
        Fri, 18 Nov 2022 08:49:17 -0800 (PST)
Received: from skbuf ([188.27.185.168])
        by smtp.gmail.com with ESMTPSA id s19-20020aa7cb13000000b0045cf4f72b04sm1984317edt.94.2022.11.18.08.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 08:49:16 -0800 (PST)
Date:   Fri, 18 Nov 2022 18:49:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Message-ID: <20221118164914.6k3gofemf5tu2gfn@skbuf>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
 <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 06:40:02PM -0500, Sean Anderson wrote:
> > Even if the change works, why would it be a good idea to overwrite some
> > random registers which are supposed to be configured correctly by the
> > firmware provided for the board?
> 
> They're not random registers. They happen to be exactly the same registers
> we use to determine if rate adaptation is enabled.

As far as I'm concerned, this is just poking in places where there is no
guarantee that the end result will be a known state.

FWIW, for internal testing of multiple SERDES modes all with the same
Aquantia firmware, the NXP SDK also has a quick-and-dirty patch to
change the SERDES protocol on the Aquantia PHY based on device tree:
https://source.codeaurora.org/external/qoriq/qoriq-components/linux/tree/drivers/net/phy/aquantia_main.c?h=lf-5.15.y#n288

but we decided to not upstream such a thing, specifically because
it might react in exotic ways with firmware images shipped by Aquantia
to some of their other customers. I don't work for Aquantia, I am not a
fan of their model of customizing firmware for everyone, and I don't
want to have to support the ensuing breakage, I wouldn't have time for
basically anything else. If you do, I'm not going to stop you. Just be
prepared to help me too ;)

> > If the Linux fixup works for one board
> > with one firmware, how do we know it also works for another board with
> > the same PHY, but different firmware?
> 
> How do we know if a fix on one board for any hardware works on another board?

If both boards start from the same state X and make the same transition
T, they end in the same state Y, no? Aquantia PHYs don't all start from
the same state. Not sure what you'd like me to say.

> Well, part of my goal in sending out this patch is to get some feedback
> on the right thing to do here. As I see it, there are three ways of
> configuring this phy:
> 
> - Always rate adapt to whatever the initial phy interface mode is
> - Switch phy interfaces depending on the link speed
> - Do whatever the firmware sets up

"Do whatever the firmware sets up", which means either bullet 1, or
bullet 2, or a combination of both (unlikely but AFAIU possible).

> 
> On my system, the last option happens to be the same as the first.
> However, on Tim's system it's not. I had originally considered doing
> this kind of configuration in my initial rate adaptation patch. However,
> I deferred it since nothing needed to be configured for me.
> 
> The problem here is that if we advertise like we are in the first mode,
> but we are not actually, then we can end up negotiating a link mode
> which we don't support.

I didn't quite understand in your patch set why there exists a
phydev->rate_matching as well as a phy_get_rate_matching() procedure.
It seems like that's at the root of all issues here? Couldn't
phy_get_rate_matching() be made to look at the hardware registers for
the given interface?

> I think there are a few ways to address this:
> 
> - Always enable rate adaptation, since that's what we tell phylink we
>   do. This is what this patch does. It's a bit risky (since it departs
>   from "do whatever the firmware does"). It's also a bit rigid (what if 

I think the mistake is that we tell phylink we support rate matching
when the firmware provisioning doesn't agree.

> - We can check all the registers to ensure we are actually going to rate
>   adapt. If we aren't, we tell phylink we don't support it. This is the
>   least risky, but we can end up not bringing up the link even in
>   circumstances where we could if we configured things properly. And we
>   generally know the right way to configure things.

Like when?

> - Add a configuration option (devicetree? ethtool?) on which option
>   above to pick. This is probably what we will want to do in the long
>   term, but I feel like we have enough information to determine the
>   right thing to do most of the time (without needing manual
>   intervention).

Not sure I see the need, when long-term there is no volunteer to make
the Linux driver bring Aquantia PHYs to a known state regardless of
vendor provisioning. Until then, there is just no reason to even attempt
this.

> > As long as the Aquantia PHY driver doesn't contain all the necessary
> > steps for bringing the PHY up from a clean slate, but works on top of
> > what the firmware has done, changes like this make me very uncomfortable
> > to add any PHY ID to the Aquantia driver. I'd rather leave them with the
> > Generic C45 driver, even if that means I'll lose interrupt support, rate
> > matching and things like that.
> 
> I think these registers should be viewed as configuration for the phy as
> a whole, rather than as guts which should be configure by firmware. At
> least for the fields we're working with, it seems clear to me what's
> going on.

Until you look at the procedure in the NXP SDK and see that things are a
bit more complicated to get right, like put the PHY in low power mode,
sleep for a while. I think a large part of that was determined experimentally,
out of laziness to change PHY firmware on some riser cards more than anything.
We still expect the production boards to have a good firmware, and Linux
to read what that does and adapt accordingly.
