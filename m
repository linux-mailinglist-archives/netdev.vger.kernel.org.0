Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AD82F6170
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbhANNCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbhANNCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 08:02:52 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04919C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:02:12 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id p14so7533109qke.6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKtBSmXo7yoSlrgbicG5OfxMQrgHn93Uxhjn4Wm/1aM=;
        b=AjSaufPSwp+El9q+7geJZwAW7K2q9BI4y8JfoYL+O+M28M6hRAttbQTmvMi4EjMK58
         GdtI/Mvxe1A8Qvg+7wGP2ca1dfeJ6DZIYZEo1PnseuRWJzy8kzF+F7A1hvaPS6GXTUSh
         qxIKEUVxb1Db/FccCUCGEPTdj9zbYR/n9d3BYsyuHaw/t8Gy4P2XtJUZNP567eqeKcir
         xqGuW6JDFTAdhHo1urzIrlBWsu6CTNkAmZySh/zLZFK5YHQ+izR7Pxpxt0fCqLlIrUAu
         Zg1Eb7Zmv955kP1x0yAR1qL4n74Ps2kPigt4BEMiD05GSNcqngmWJphiyUA7qnEc/aCC
         ovjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKtBSmXo7yoSlrgbicG5OfxMQrgHn93Uxhjn4Wm/1aM=;
        b=Mx70up9hfwJLSOcf3MQ2VrNE0fxI2vDMR6kXC4rvOXomHKsUP5FN2Jk3jNOgbbl6Ep
         xmrRq086XV5HRP54F2gJCV7hdTuXGuUYWInOnZM+zbBituKE4ml+eZ/qHfdjQe2Mz6YI
         Xj3uCPRcwZcX/NoOckm2V5vTr7xUJYrIXt/1q6AFXsxiA0WZDdwfrolBmRHaDF9hJhxt
         WDQPROlNt6lubpPuDeTrbWLDK3L27P6/pKBTnUQo1Jk5+KQSsdN1Jjggxa58kKxxk74M
         j45DlXZEQdoTJtDvvm1kN575JOa2Fk7OxAcdA9w3am8E/yYmiOugFGIqXyEZrI8gaBbB
         1DBA==
X-Gm-Message-State: AOAM530qsgpYT69l/Q9VpQN3sdl+XIijV264WWmdtEjkLOg9Ft0U6kHq
        ClkYi5PPQiyFGmiLfwlJxhlM3ya9h+6DrsBmlIoDaQ==
X-Google-Smtp-Source: ABdhPJz4uv8Rl2EC4V0BacdcjeQ5cfW01qGPtaACAxhScTQzJGNUuSOqSCetziUqvBgah7DHYMfWSm1PM2+c1aoNQHg=
X-Received: by 2002:a05:620a:713:: with SMTP id 19mr7084459qkc.424.1610629330999;
 Thu, 14 Jan 2021 05:02:10 -0800 (PST)
MIME-Version: 1.0
References: <20210113133523.39205-1-alobakin@pm.me> <20210113133635.39402-1-alobakin@pm.me>
 <20210113133635.39402-2-alobakin@pm.me> <CANn89i+azKGzpt4LrVVVCQdf82TLOC=dwUjA4NK3ziQHSKvtFw@mail.gmail.com>
 <20210114114046.7272-1-alobakin@pm.me> <CACT4Y+adbmvvbzFnzRZzmpdTipg7ye53uR6OrnU9_K030sfzzA@mail.gmail.com>
 <20210114124406.9049-1-alobakin@pm.me> <CACT4Y+bcj_jBkUJhRMvo8kjB78WyoBtCH8+-L0tGkxuRpaO66Q@mail.gmail.com>
 <20210114125932.9594-1-alobakin@pm.me>
In-Reply-To: <20210114125932.9594-1-alobakin@pm.me>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 14 Jan 2021 14:01:59 +0100
Message-ID: <CACT4Y+YrBS-NQpKNb=nuUDXEEuqhK+hM4qLQnUiYawBVZpb82Q@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/3] skbuff: (re)use NAPI skb cache on
 allocation path
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 2:00 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >>>>>> Instead of calling kmem_cache_alloc() every time when building a NAPI
> >>>>>> skb, (re)use skbuff_heads from napi_alloc_cache.skb_cache. Previously
> >>>>>> this cache was only used for bulk-freeing skbuff_heads consumed via
> >>>>>> napi_consume_skb() or __kfree_skb_defer().
> >>>>>>
> >>>>>> Typical path is:
> >>>>>>  - skb is queued for freeing from driver or stack, its skbuff_head
> >>>>>>    goes into the cache instead of immediate freeing;
> >>>>>>  - driver or stack requests NAPI skb allocation, an skbuff_head is
> >>>>>>    taken from the cache instead of allocation.
> >>>>>>
> >>>>>> Corner cases:
> >>>>>>  - if it's empty on skb allocation, bulk-allocate the first half;
> >>>>>>  - if it's full on skb consuming, bulk-wipe the second half.
> >>>>>>
> >>>>>> Also try to balance its size after completing network softirqs
> >>>>>> (__kfree_skb_flush()).
> >>>>>
> >>>>> I do not see the point of doing this rebalance (especially if we do not change
> >>>>> its name describing its purpose more accurately).
> >>>>>
> >>>>> For moderate load, we will have a reduced bulk size (typically one or two).
> >>>>> Number of skbs in the cache is in [0, 64[ , there is really no risk of
> >>>>> letting skbs there for a long period of time.
> >>>>> (32 * sizeof(sk_buff) = 8192)
> >>>>> I would personally get rid of this function completely.
> >>>>
> >>>> When I had a cache of 128 entries, I had worse results without this
> >>>> function. But seems like I forgot to retest when I switched to the
> >>>> original size of 64.
> >>>> I also thought about removing this function entirely, will test.
> >>>>
> >>>>> Also it seems you missed my KASAN support request ?
> >>>>  I guess this is a matter of using kasan_unpoison_range(), we can ask for help.
> >>>>
> >>>> I saw your request, but don't see a reason for doing this.
> >>>> We are not caching already freed skbuff_heads. They don't get
> >>>> kmem_cache_freed before getting into local cache. KASAN poisons
> >>>> them no earlier than at kmem_cache_free() (or did I miss someting?).
> >>>> heads being cached just get rid of all references and at the moment
> >>>> of dropping to the cache they are pretty the same as if they were
> >>>> allocated.
> >>>
> >>> KASAN should not report false positives in this case.
> >>> But I think Eric meant preventing false negatives. If we kmalloc 17
> >>> bytes, KASAN will detect out-of-bounds accesses beyond these 17 bytes.
> >>> But we put that data into 128-byte blocks, KASAN will miss
> >>> out-of-bounds accesses beyond 17 bytes up to 128 bytes.
> >>> The same holds for "logical" use-after-frees when object is free, but
> >>> not freed into slab.
> >>>
> >>> An important custom cache should use annotations like
> >>> kasan_poison_object_data/kasan_unpoison_range.
> >>
> >> As I understand, I should
> >> kasan_poison_object_data(skbuff_head_cache, skb) and then
> >> kasan_unpoison_range(skb, sizeof(*skb)) when putting it into the
> >> cache?
> >
> > I think it's the other way around. It should be _un_poisoned when used.
> > If it's fixed size, then unpoison_object_data should be a better fit:
> > https://elixir.bootlin.com/linux/v5.11-rc3/source/mm/kasan/common.c#L253
>
> Ah, I though of this too. But wouldn't there be a false-positive if
> a poisoned skb hits kmem_cache_free_bulk(), not the allocation path?
> We plan to use skb_cache for both reusing and bulk-freeing, and SLUB,
> for example, might do writes into objects before freeing.
> If it also should get unpoisoned before kmem_cache_free_bulk(), we'll
> lose bulking as unpoisoning is performed per-object.

Yes, it needs to be unpoisoned before free.
Unpoison one-by-one, free in bulk. Unpoisoningin is debug-only code anyway.
