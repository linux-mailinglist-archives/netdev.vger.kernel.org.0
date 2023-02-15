Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F140F698392
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjBOSif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBOSi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:38:28 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177933D0B7
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:37:36 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-52ec329dc01so273842057b3.10
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2exT8mCOe2U3JDYqIhB1SElAHQGqVX9U4HAksoqn65Q=;
        b=ui7tIIZTXwCrggBSTUUHQmcr3y1lCZS9ihFSL19kxuu0cT+IZyXAAHWFB6FASfGn3r
         q0tZAYB4JZDdNeBaMGX5to85fbrMjGzIE/mof4o/Og3hd8QPC6VKffPiN9l/euvRRb8D
         I5PjpUrbTovkoHqeZP7ClzrhAXOLVIp11uE9H/EmT/DUWxG4aw+9BRV46+Pmr3WcjLen
         8azso9OuK030Og6JMOlfWbeYJp63NOpawPH4vLEsKEDl3FV5IMc8DZrn3ittpGXi5IU5
         UqWUz2FmRO4aIsei4FxojaxV8hmjFdlAASkn0fs3CiYFLep6mT0Zg1bT/YKCO7YikbSw
         1Igw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2exT8mCOe2U3JDYqIhB1SElAHQGqVX9U4HAksoqn65Q=;
        b=7u8IhNN52RU67HUKUIscYzkvmjeOpbK4JljmsjZpnGIeZtgepnGVpTJ+DMw7KNbQky
         urBvWJup/oN3QBit2k+/RjEmaVKOzv9eUJE/f/oLarZV0TNygPtxqw1FK67lOiwG3Zwn
         AbGRX5S2b4IO+6xEkhJhCj1EnDR+8mEUhPpy4Ly2V+/OkyTqWJZEJJckFgC92jTeULOD
         n9F4MsmJGizhP+ZVvKv5AH/QE7yCJ+ac33V8BSLtYSHnRMgZ+Hdc968ALdTBYprQPX4x
         HZguzTtBFo38mox4LbgTMi/Yjx6h4IXq/hI1/YtvmIGyo/Va8dzgQZ6T9TLNSVUhVS+l
         /3RA==
X-Gm-Message-State: AO0yUKXtqaH6zjQFD/TAFnzJO6ZF/3+7rKl3oXK8VlnEeYQM9kbBUVae
        c+ltmkqHxFZYubGEEAKxK7hRQddL4MSOeLGwUch4yw==
X-Google-Smtp-Source: AK7set901+t883r7+vHlBMG/sHd5agENrILcE0lQRTabzYY4OaxIEQzahMjnT89TIls7pAoubAZQCmVcIkqeinajFqM=
X-Received: by 2002:a25:2fd4:0:b0:915:a25b:a4de with SMTP id
 v203-20020a252fd4000000b00915a25ba4demr362332ybv.195.1676486173589; Wed, 15
 Feb 2023 10:36:13 -0800 (PST)
MIME-Version: 1.0
References: <20230215034355.481925-1-kuba@kernel.org> <20230215034355.481925-4-kuba@kernel.org>
 <CAM0EoMnkcvHpbJY-Tqo8CngN4Y_hnYoeaYCMW+OVXcNVAbwzug@mail.gmail.com> <Y+0QTUQUDG7Zo1xq@nanopsycho>
In-Reply-To: <Y+0QTUQUDG7Zo1xq@nanopsycho>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 15 Feb 2023 13:36:02 -0500
Message-ID: <CAM0EoM=u0DBJmixxPK2heEvm13GZwF_jzXVoPUn=xVf6tVxU2A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: create and use NAPI version of tc_skb_ext_alloc()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de, saeedm@nvidia.com,
        leon@kernel.org, xiyou.wangcong@gmail.com, roid@nvidia.com,
        ozsh@nvidia.com, paulb@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 12:03 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Feb 15, 2023 at 05:50:55PM CET, jhs@mojatatu.com wrote:
> >On Tue, Feb 14, 2023 at 10:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> Try to use the cached skb_ext in the drivers.
> >>
> >> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >> ---
> >> CC: saeedm@nvidia.com
> >> CC: leon@kernel.org
> >> CC: jhs@mojatatu.com
> >> CC: xiyou.wangcong@gmail.com
> >> CC: jiri@resnulli.us
> >> CC: roid@nvidia.com
> >> CC: ozsh@nvidia.com
> >> CC: paulb@nvidia.com
> >> ---
> >>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
> >>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 +-
> >>  include/net/pkt_cls.h                               | 9 +++++++++
> >>  3 files changed, 11 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >> index 3b590cfe33b8..ffbed5a92eab 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >> @@ -770,7 +770,7 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
> >>                 struct mlx5_eswitch *esw;
> >>                 u32 zone_restore_id;
> >>
> >> -               tc_skb_ext = tc_skb_ext_alloc(skb);
> >> +               tc_skb_ext = tc_skb_ext_alloc_napi(skb);
> >>                 if (!tc_skb_ext) {
> >>                         WARN_ON(1);
> >>                         return false;
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >> index 2d06b4412762..3d9da4ccaf5d 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >> @@ -5643,7 +5643,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
> >>
> >>         if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
> >>                 chain = mapped_obj.chain;
> >> -               tc_skb_ext = tc_skb_ext_alloc(skb);
> >> +               tc_skb_ext = tc_skb_ext_alloc_napi(skb);
> >>                 if (WARN_ON(!tc_skb_ext))
> >>                         return false;
> >>
> >> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> >> index ace437c6754b..82821a3f8a8b 100644
> >> --- a/include/net/pkt_cls.h
> >> +++ b/include/net/pkt_cls.h
> >> @@ -764,6 +764,15 @@ static inline struct tc_skb_ext *tc_skb_ext_alloc(struct sk_buff *skb)
> >>                 memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
> >>         return tc_skb_ext;
> >>  }
> >> +
> >> +static inline struct tc_skb_ext *tc_skb_ext_alloc_napi(struct sk_buff *skb)
> >> +{
> >> +       struct tc_skb_ext *tc_skb_ext = napi_skb_ext_add(skb, TC_SKB_EXT);
> >> +
> >> +       if (tc_skb_ext)
> >> +               memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
> >> +       return tc_skb_ext;
> >> +}
> >>  #endif
> >>
> >
> >Dumb question: Would this work with a consumer of the metadata past
> >RPS stage? didnt look closely but assumed per cpu skb_ext because of
> >the napi context - which will require a per cpu pointer to fetch it
> >later.
> >In P4TC we make heavy use of skb_ext and found it to be very pricey,
>
> Why don't you use skb->cb internally in p4tc?

Just for space reasons since we have a lot of stuff we carry around
(headers, metadata, and table keys which could be each upto an imposed
512b in size).

> Or does the skb leave p4tc and arrive back again? When?

Only time it leaves is if we do a "recirculate" - which is essentially
a mirred redirect to ingress/egress of another port.
It still causes memory pressure in alloc/free - we are thinking of
getting rid of it altogether and replacing it with a statically
allocated per-cpu scratchpad; if it gets recirculated we start from
scratch.

cheers,
jamal
