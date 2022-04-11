Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2DE4FBBB9
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbiDKMJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238123AbiDKMJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:09:31 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A113CA66
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:07:18 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id x200so3344098ybe.13
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tKmspKMLUzsIdOKIQARSedJcNbc2hDS7hLYkOkGDWkY=;
        b=UdAbmvk1BBx7ie+DunaAUxWiUhqwXv+17Udk9eojdm2Ghg8ohoIwKBAXIQFnL07Ld/
         Gy+I7pATjcv/oCNCfX5oiGboHVrAxvBaOOf9mKfQjsSsQiOOuueyTohMyrF1FnmTbN82
         lX7erQrFuhL1uoaRdxZCSvLA6msB8VElqpZmyz0Vw6IInqBCwqQV1mds+/DgAjPY8kWE
         o+RzbCMYenjk0xtShyzHKHhwksoj3Fm3I7gnefYj9yUq/7nSOizvqJy3f4ZygBWuLdgl
         YQ6UqhReJ6xjGVZFFEuSur9GiPB0YhDDW4yelpK87ZrxHbwk37//1GUUD4ViACBZQ4RW
         dGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tKmspKMLUzsIdOKIQARSedJcNbc2hDS7hLYkOkGDWkY=;
        b=r+tUGGlKYjpL19ljLwaVgzjG5RZUf0otSxNh4x9v7EFtsUDK3L8oAAllcSLpWjaUaQ
         Ywsy+veBk6dlREYBixuqwBKDQ2Ssuxvy+tzEK2qQ4GmzG1akMJG1fTRu2XPujMckACO5
         gsI8VCXC6U8IcAx8XySC841MxO+DyUKbgmQLN18lbm2rkHPMNxkWP1BXJAW5WTAwfah+
         A1QhOA49HfgQUUZbDoOtGOzGxAyXPbQHTdaSdsfp69CTkNXgpxQe5UO+RkdOK/N+w5YF
         gTuOW+cIaHL1yUjrdqJDTA6SgcjP28yn2NLXZa2SYVFV8hHevh2B7/fqGhpwk2/v3V/G
         6wNQ==
X-Gm-Message-State: AOAM532NEezExrc9WMKcFC688vDB1D3ZclIwWpv0q/2vlCxa7tJxsneX
        JwMUwXAkto0yuC46ncd6r5ByAYTv5EFOGlOVoGQ4mA==
X-Google-Smtp-Source: ABdhPJwI9ziAF1onOtV/iKDIRLkJveY9XI1+6VwX026Z4TDZBG8WDcZqjAut5ei4vyetq5YXkXnxvwUmnWhXlUUO8ZM=
X-Received: by 2002:a25:544:0:b0:641:17ff:396d with SMTP id
 65-20020a250544000000b0064117ff396dmr8983004ybf.248.1649678837318; Mon, 11
 Apr 2022 05:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649528984.git.lorenzo@kernel.org> <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
In-Reply-To: <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 11 Apr 2022 15:06:41 +0300
Message-ID: <CAC_iWj+wGjx4uAmtkvP=kJsD1uBKsxUXPfy8YS8Abhz=ooLmkg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, jdamato@fastly.com, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

[...]

>
>         for_each_possible_cpu(cpu) {
>                 const struct page_pool_recycle_stats *pcpu =
> @@ -66,6 +87,47 @@ bool page_pool_get_stats(struct page_pool *pool,
>         return true;
>  }
>  EXPORT_SYMBOL(page_pool_get_stats);
> +
> +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
> +               memcpy(data, pp_stats[i], ETH_GSTRING_LEN);
> +               data += ETH_GSTRING_LEN;
> +       }
> +
> +       return data;

Is there a point returning data here or can we make this a void?

> +}
> +EXPORT_SYMBOL(page_pool_ethtool_stats_get_strings);
> +
> +int page_pool_ethtool_stats_get_count(void)
> +{
> +       return ARRAY_SIZE(pp_stats);
> +}
> +EXPORT_SYMBOL(page_pool_ethtool_stats_get_count);
> +
> +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
> +               *data++ = stats->alloc_stats.fast;
> +               *data++ = stats->alloc_stats.slow;
> +               *data++ = stats->alloc_stats.slow_high_order;
> +               *data++ = stats->alloc_stats.empty;
> +               *data++ = stats->alloc_stats.refill;
> +               *data++ = stats->alloc_stats.waive;
> +               *data++ = stats->recycle_stats.cached;
> +               *data++ = stats->recycle_stats.cache_full;
> +               *data++ = stats->recycle_stats.ring;
> +               *data++ = stats->recycle_stats.ring_full;
> +               *data++ = stats->recycle_stats.released_refcnt;
> +       }
> +
> +       return data;

Ditto

> +}
> +EXPORT_SYMBOL(page_pool_ethtool_stats_get);
>  #else
>  #define alloc_stat_inc(pool, __stat)
>  #define recycle_stat_inc(pool, __stat)
> --
> 2.35.1
>

Thanks
/Ilias
