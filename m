Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A955969818A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBORDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjBORDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:03:37 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56E520056
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:03:12 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id n20so8375663edy.0
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r47mm+kSZlK8KaAkZDR5Goq9aZFJotncsoCh9jgiURE=;
        b=p+g3hLqpKig+rU/kcYUfyEippQKDKJaJumBHWj+rfQk/MMpDaBA7s5B9x/MUjF/Fb0
         xCOAlgT1sQZeuicwqxwHgclWIJJv6NkHB6ibDvrbyVcipK3g9BONQcNvR2wgJ/TLXHk7
         3xdXLl1drVyHMFbrZ5UD2CSVgdLxtFCXDQY6H+s0RjcXV/mK0mwO6IU1PQQ3KUBWBrfw
         jIUpiXSfAUYlsI65Jg0GTERslSC6XorSSwOJpPmHnNtXv9/XQF/OxSLXyIfk/Jprtzsf
         g0yrlg6xytbmfmpv2aQxM9AKfyUi2DP8jPcneViXuwQgYIGB3zba6nGTPI52uQfuD++t
         xkTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r47mm+kSZlK8KaAkZDR5Goq9aZFJotncsoCh9jgiURE=;
        b=DMgtITHzzT77revFupob1Poabo8pIFT0LfjN6IgXGpgDFiBh2obRN882qZwohqspzO
         68iE80qO7KLo7OQ+qnpUwsr/F4tVXlsj4NZcGH/AqJ7lm4VOlNfbRm5t289q/4Lc5yvU
         eZi+mNq228js89IhKu8dWKQZinC12SQ0yABRDF3+n0iEFrEG0H/8EwP3/BcJrAlsL0+/
         XGs0kzmXBfjUM+E/ON7eIj4HVmujAITeNBulZRljwtt4ZGYvaSc1auEe7zwc86bziysL
         IJDXDKm/t1FTcaPU3h0ENCFfoXPAquOqaRmL4YNX880+LxDmHyf7LTd3huQeaT4FM/Xa
         zddg==
X-Gm-Message-State: AO0yUKULl+Am/B+q+urR4PMlYmKU48NbLktEpsq3RZMXD2cDdQVlc8V0
        i5cvtXjeElbdd2I8bWlC8jX5YA==
X-Google-Smtp-Source: AK7set8QwFXRfM2QtDbKoIHJIUbZOTWXjP3Q2x7xdhhZTDMnB3/UKfV7wSU597lsrXIs22NWUf6Osg==
X-Received: by 2002:a17:906:a451:b0:86f:fbcf:f30a with SMTP id cb17-20020a170906a45100b0086ffbcff30amr2972930ejb.58.1676480591243;
        Wed, 15 Feb 2023 09:03:11 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s8-20020aa7cb08000000b004acd9a3afb3sm2917451edt.63.2023.02.15.09.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 09:03:10 -0800 (PST)
Date:   Wed, 15 Feb 2023 18:03:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de, saeedm@nvidia.com,
        leon@kernel.org, xiyou.wangcong@gmail.com, roid@nvidia.com,
        ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 3/3] net: create and use NAPI version of
 tc_skb_ext_alloc()
Message-ID: <Y+0QTUQUDG7Zo1xq@nanopsycho>
References: <20230215034355.481925-1-kuba@kernel.org>
 <20230215034355.481925-4-kuba@kernel.org>
 <CAM0EoMnkcvHpbJY-Tqo8CngN4Y_hnYoeaYCMW+OVXcNVAbwzug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMnkcvHpbJY-Tqo8CngN4Y_hnYoeaYCMW+OVXcNVAbwzug@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 15, 2023 at 05:50:55PM CET, jhs@mojatatu.com wrote:
>On Tue, Feb 14, 2023 at 10:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> Try to use the cached skb_ext in the drivers.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>> CC: saeedm@nvidia.com
>> CC: leon@kernel.org
>> CC: jhs@mojatatu.com
>> CC: xiyou.wangcong@gmail.com
>> CC: jiri@resnulli.us
>> CC: roid@nvidia.com
>> CC: ozsh@nvidia.com
>> CC: paulb@nvidia.com
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 +-
>>  include/net/pkt_cls.h                               | 9 +++++++++
>>  3 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> index 3b590cfe33b8..ffbed5a92eab 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> @@ -770,7 +770,7 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
>>                 struct mlx5_eswitch *esw;
>>                 u32 zone_restore_id;
>>
>> -               tc_skb_ext = tc_skb_ext_alloc(skb);
>> +               tc_skb_ext = tc_skb_ext_alloc_napi(skb);
>>                 if (!tc_skb_ext) {
>>                         WARN_ON(1);
>>                         return false;
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 2d06b4412762..3d9da4ccaf5d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -5643,7 +5643,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
>>
>>         if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
>>                 chain = mapped_obj.chain;
>> -               tc_skb_ext = tc_skb_ext_alloc(skb);
>> +               tc_skb_ext = tc_skb_ext_alloc_napi(skb);
>>                 if (WARN_ON(!tc_skb_ext))
>>                         return false;
>>
>> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
>> index ace437c6754b..82821a3f8a8b 100644
>> --- a/include/net/pkt_cls.h
>> +++ b/include/net/pkt_cls.h
>> @@ -764,6 +764,15 @@ static inline struct tc_skb_ext *tc_skb_ext_alloc(struct sk_buff *skb)
>>                 memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
>>         return tc_skb_ext;
>>  }
>> +
>> +static inline struct tc_skb_ext *tc_skb_ext_alloc_napi(struct sk_buff *skb)
>> +{
>> +       struct tc_skb_ext *tc_skb_ext = napi_skb_ext_add(skb, TC_SKB_EXT);
>> +
>> +       if (tc_skb_ext)
>> +               memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
>> +       return tc_skb_ext;
>> +}
>>  #endif
>>
>
>Dumb question: Would this work with a consumer of the metadata past
>RPS stage? didnt look closely but assumed per cpu skb_ext because of
>the napi context - which will require a per cpu pointer to fetch it
>later.
>In P4TC we make heavy use of skb_ext and found it to be very pricey,

Why don't you use skb->cb internally in p4tc? Or does the skb leave p4tc
and arrive back again? When?


>so we ended making it per cpu - but that's post RPS so we are safe.
>
>cheers,
>jamal
