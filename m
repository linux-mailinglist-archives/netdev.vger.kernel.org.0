Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F70F698154
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBOQvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBOQvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:51:41 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4908137737
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:51:07 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-52f0001ff8eso185985137b3.4
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a4nDkz2BWLLXHEJS3xBfFkA+WcDjSe4J20RVIrctTHU=;
        b=U5qIQTnua67ECvHHkWcHez57/YvmXazWASyoG1erFaPfcV/PaWAz8pa/9TzUjCX93U
         qoTi5FzAR0GcgzAUq9Dfv0fcwYxyFfMvP0Uk53tb1L5wKPyg4XbF2BM9oHap7FXMJpOb
         F/bKS8ZVgnh+BrGRarCKnZ5DzECkYEGRqXNI94PznG5X4aHlY/XET3Ia6XIyM6YXB5J9
         eZdQYeLYnxy/nUpeeJbBOOUNuWO2KDpx/+Gc9afquEjnEiRHr/g1opOP1AkhG6DsRfLs
         YlwQYVyGWWN/pZw2ju+qCS7ccMvUlE0qTCgAJzlUbtcnHBGe+kCtEIjFmKE2Sz3jQTmH
         ic/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4nDkz2BWLLXHEJS3xBfFkA+WcDjSe4J20RVIrctTHU=;
        b=gI5BKZp7hgJvMKTz+APRg7Kckef1Cw1dm/JeUgvd3I7qFuAPbGnaTvRRbciSbGNc++
         bQMGrUr+8e068dqcmeVJewTP6PKvEtzC0iDv+8OpXVXjmCxAv2U9AWMaVkvAzomk6J+A
         vifnvNhDT9kLz82vZt7qYKmvyarV7aQbj2YOrEFZjoYo2/0rpgTtBzDj3OGpfLl80drA
         MgE0yicn0cfoa3nW+SV5kScisGZz6BLxKR3SlUKnB+L5mVP9PzwUTedwava7/f/eKyHj
         YEU9zDNLMm1BcJfPugoE21QP/k7kNX9z3JDgsCz7nOqs/otsOs+ImLfXuBoM8oiJswzZ
         hTwg==
X-Gm-Message-State: AO0yUKWel5+pXkHIoI/G81z1qM2kJNF6jjqjnW6hUH9tpgwyYyJpPTQg
        CL1THyy2p3n8RRVkswuEdM7+5tNjfE13r1aSRd+gIg==
X-Google-Smtp-Source: AK7set9LSJZJtuEW0oAPZBIOPQ66c0+jR5iWFrX1fblH1voxOnWY+M1CzUOtSl2jWJVi5eY6cixWlrvEcgb6zBJDgrY=
X-Received: by 2002:a5b:a8a:0:b0:920:3c42:4709 with SMTP id
 h10-20020a5b0a8a000000b009203c424709mr440488ybq.337.1676479866541; Wed, 15
 Feb 2023 08:51:06 -0800 (PST)
MIME-Version: 1.0
References: <20230215034355.481925-1-kuba@kernel.org> <20230215034355.481925-4-kuba@kernel.org>
In-Reply-To: <20230215034355.481925-4-kuba@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 15 Feb 2023 11:50:55 -0500
Message-ID: <CAM0EoMnkcvHpbJY-Tqo8CngN4Y_hnYoeaYCMW+OVXcNVAbwzug@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: create and use NAPI version of tc_skb_ext_alloc()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, fw@strlen.de,
        saeedm@nvidia.com, leon@kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, roid@nvidia.com, ozsh@nvidia.com,
        paulb@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 10:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Try to use the cached skb_ext in the drivers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: saeedm@nvidia.com
> CC: leon@kernel.org
> CC: jhs@mojatatu.com
> CC: xiyou.wangcong@gmail.com
> CC: jiri@resnulli.us
> CC: roid@nvidia.com
> CC: ozsh@nvidia.com
> CC: paulb@nvidia.com
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 +-
>  include/net/pkt_cls.h                               | 9 +++++++++
>  3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index 3b590cfe33b8..ffbed5a92eab 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -770,7 +770,7 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
>                 struct mlx5_eswitch *esw;
>                 u32 zone_restore_id;
>
> -               tc_skb_ext = tc_skb_ext_alloc(skb);
> +               tc_skb_ext = tc_skb_ext_alloc_napi(skb);
>                 if (!tc_skb_ext) {
>                         WARN_ON(1);
>                         return false;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 2d06b4412762..3d9da4ccaf5d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -5643,7 +5643,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
>
>         if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
>                 chain = mapped_obj.chain;
> -               tc_skb_ext = tc_skb_ext_alloc(skb);
> +               tc_skb_ext = tc_skb_ext_alloc_napi(skb);
>                 if (WARN_ON(!tc_skb_ext))
>                         return false;
>
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index ace437c6754b..82821a3f8a8b 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -764,6 +764,15 @@ static inline struct tc_skb_ext *tc_skb_ext_alloc(struct sk_buff *skb)
>                 memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
>         return tc_skb_ext;
>  }
> +
> +static inline struct tc_skb_ext *tc_skb_ext_alloc_napi(struct sk_buff *skb)
> +{
> +       struct tc_skb_ext *tc_skb_ext = napi_skb_ext_add(skb, TC_SKB_EXT);
> +
> +       if (tc_skb_ext)
> +               memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
> +       return tc_skb_ext;
> +}
>  #endif
>

Dumb question: Would this work with a consumer of the metadata past
RPS stage? didnt look closely but assumed per cpu skb_ext because of
the napi context - which will require a per cpu pointer to fetch it
later.
In P4TC we make heavy use of skb_ext and found it to be very pricey,
so we ended making it per cpu - but that's post RPS so we are safe.

cheers,
jamal
