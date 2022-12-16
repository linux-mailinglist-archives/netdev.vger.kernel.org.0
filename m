Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716F964F05A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 18:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiLPRYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 12:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLPRYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 12:24:48 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF446678;
        Fri, 16 Dec 2022 09:24:47 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h33so2206190pgm.9;
        Fri, 16 Dec 2022 09:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dIv2+6FrFvBFHioHuEmEwHJpKVRq8KjJBhuXE7RUxYg=;
        b=d23NYspAyVCmJO/zLT5jUZkbABjOrhjDGEzpNwHN1Y2X2M09aMzthCbgw60KJU8JYr
         mDeOETQwEcv8QNPHZ3DNdBTzIR2uU5LS8H2SxytYrOPyNDTYFdOOnrIpNVzZrlFFfsfj
         OaTKbOYW6n+g9wdS+++mbG42F9yXnVmrmq5Ku1B8WFLJ0iLUW8I5nS27k+WDeHaMLdZN
         a9SkLT4irKpsOD7zwS/co/tM2fN3erGuRPalXhhs2mtLuaXjp45gkpcvVHYXpF7BuSGm
         BYwBNltViQ6EwYgq2eyB+De3v6eDqLBqvJLU+sBbxHiL+vVVC5W4M1Ud08KMiLkhWxP3
         5ALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dIv2+6FrFvBFHioHuEmEwHJpKVRq8KjJBhuXE7RUxYg=;
        b=H11ZNUJb8f8tJmaMMAAgjv/KVxaMPJ4FGGceETWN4uh/RLsTLy77ANfb8ltcffk0Qi
         9NzHnwa06mCPNrc+sa9OnIf1vJqlZ1O2ILfMqbv8kw8lkQCvRBxGToGbaQOA7hse8KOY
         fUYfhRAElI1HwRF8b4JXwP9RqNvlZvkdb3zqyRp/Y2JjSCrkoWVPcIEAeijf5XKa5rac
         oA05Fb14a+ECDSYdFW4Q6ag136wuMvDlRcTDOT//46VXFWIdCuEK5ebGLoySMdU04GNV
         th13BKjd3nEc2ZtoepPuQs63svKsqu/h8YKtFAPgzI8EmOQ0jq72hiAGmOd4HDJyjHNP
         UDGw==
X-Gm-Message-State: ANoB5pkXcuRC2BoJXBjm6HLu99bRcwkBhhEtXjFq7tpqNV/I4p6CwSL6
        eWW/YcYxfFiYZl9gzd+V+LLBpyw0Qp/14pDGnCg=
X-Google-Smtp-Source: AA0mqf5zNz6hV345CKNDdoPTSuEkHoCJNoHnCBMh3KCI82g843EREfkdqfeolue/dViCeefQLDeIVCNCf/G7gNTZHqo=
X-Received: by 2002:a63:f241:0:b0:46f:da0:f093 with SMTP id
 d1-20020a63f241000000b0046f0da0f093mr70601384pgk.441.1671211486851; Fri, 16
 Dec 2022 09:24:46 -0800 (PST)
MIME-Version: 1.0
References: <20221215144536.3810578-1-lukma@denx.de> <4d16ffd327d193f8c1f7c40f968fda90a267348e.camel@gmail.com>
 <20221216140526.799bd82f@wsk>
In-Reply-To: <20221216140526.799bd82f@wsk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 16 Dec 2022 09:24:35 -0800
Message-ID: <CAKgT0Udm6s8Wib1dFp6f4yVhdMm62-4kjetYSucLr-Ruyg7-yg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dsa: marvell: Provide per device information about
 max frame size
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 5:05 AM Lukasz Majewski <lukma@denx.de> wrote:
>
> Hi Alexander,
>
> > On Thu, 2022-12-15 at 15:45 +0100, Lukasz Majewski wrote:
> > > Different Marvell DSA switches support different size of max frame
> > > bytes to be sent.
> > >
> > > For example mv88e6185 supports max 1632 bytes, which is now
> > > in-driver standard value. On the other hand - mv88e6250 supports
> > > 2048 bytes.
> > >
> > > As this value is internal and may be different for each switch IC,
> > > new entry in struct mv88e6xxx_info has been added to store it.
> > >
> > > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > > ---
> > > Changes for v2:
> > > - Define max_frame_size with default value of 1632 bytes,
> > > - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> > > ---
> > >  drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
> > >  drivers/net/dsa/mv88e6xxx/chip.h |  1 +
> > >  2 files changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> > > b/drivers/net/dsa/mv88e6xxx/chip.c index 2ca3cbba5764..7ae4c389ce50
> > > 100644 --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > > @@ -3093,7 +3093,9 @@ static int mv88e6xxx_get_max_mtu(struct
> > > dsa_switch *ds, int port) if (chip->info->ops->port_set_jumbo_size)
> > >             return 10240 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > ETH_FCS_LEN; else if (chip->info->ops->set_max_frame_size)
> > > -           return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > ETH_FCS_LEN;
> > > +           return (chip->info->max_frame_size  - VLAN_ETH_HLEN
> > > +                   - EDSA_HLEN - ETH_FCS_LEN);
> > > +
> > >     return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > >  }
> > >
> > >
> >
> > Is there any specific reason for triggering this based on the
> > existance of the function call?
>
> This was the original code in this driver.
>
> This value (1632 or 2048 bytes) is SoC (family) specific.
>
> By checking which device defines set_max_frame_size callback, I could
> fill the chip->info->max_frame_size with 1632 value.
>
> > Why not just replace:
> >       else if (chip->info->ops->set_max_frame_size)
> > with:
> >       else if (chip->info->max_frame_size)
> >
>
> I think that the callback check is a bit "defensive" approach -> 1522B
> is the default value and 1632 (or 10240 - jumbo) can be set only when
> proper callback is defined.
>
> > Otherwise my concern is one gets defined without the other leading to
> > a future issue as 0 - extra headers will likely wrap and while the
> > return value may be a signed int, it is usually stored in an unsigned
> > int so it would effectively uncap the MTU.
>
> Please correct me if I misunderstood something:
>
> The problem is with new mv88eXXXX devices, which will not provide
> max_frame_size information to their chip->info struct?
>
> Or is there any other issue?

That was mostly my concern. I was adding a bit of my own defensive
programming in the event that somebody forgot to fill out the
chip->info. If nothing else it might make sense to add a check to
verify that the max_frame_size is populated before blindly using it.
So perhaps you could do something similar to the max_t approach I had
called out earlier but instead of applying it on the last case you
could apply it for the "set_max_frame_size" case with 1632 being the
minimum and being overwritten by 2048 if it is set in max_frame_size.
