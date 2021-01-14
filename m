Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542B92F6147
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 13:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbhANMwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 07:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbhANMwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 07:52:42 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A12CC061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 04:51:56 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id p14so7480462qke.6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 04:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0xwzUQ09tQNNwHy+qgRNeihhGrvkVw2IceHHCVee2s=;
        b=rVpL7l0BbhnTd+dgj69NKSfaqOPMz1TQEKO/BxztQi257jHhLSVhhnMCAJMIzbe8gQ
         l2ExqJb3dT6JIOD2FvhWiH8GhokBKkpFSGi5Jtwc9pb4cON15WjNzSImVliRBDZZgmsm
         Hy/vE0rW9VsT49cQZeLRMrSBKg8NX+4UDa4Sa6uzRKCLVqNozo3cuP7elccVeBnnkMVU
         rnUlQvNpuh7UI56kwO8JpuRRvfuW46SVkqixs95bgpyqWNa8OayAzQsslSxit1aiEjMn
         gA1aldEqQbaEFNDFbCypRMVdCsttM4VsCxXI7pE4kz102YZNtOjk6sjvIPZg9AA2Tjf1
         3bzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0xwzUQ09tQNNwHy+qgRNeihhGrvkVw2IceHHCVee2s=;
        b=pa7G8ZBlETO73M+rg2EWZCvOgzsMDheUwCJFYN+fDMKSNLBS2swPzfuOs7YK1x6bs6
         DqFQ10VgtuScAI56KYhT930Cu6k7z0mRJ9RIKbT3KtHsTaHYNqRUSKjj/msrI6Yay9bT
         VJFLBdWAadQYWJ4Q8I74K31CVFyfH3mVi43x0wiF86A5DifcaF9tDAXB9eJb0GcPRPQu
         NVwjY8r2My8uL4Y/MYz3ragqq/keG58+7w3TPwMVm/+hyUCa32CnWTmboea4uXxa4b8E
         Usk0mbDhwaqzPlUmsLNlrioGumauq75lAPbNYH8IC6k2j1AAhnFFyao6Y7oJWQ1WLKyt
         WOIQ==
X-Gm-Message-State: AOAM5307s7BtzUf7SuRVbKWkkJCrdeWSTtvGELi1pTJzWnM0L8+Ghd5Q
        Tm2Mj9sfMhFog5VZ6+JultrFS29OWXzPzGw77d6wWw==
X-Google-Smtp-Source: ABdhPJx4sjovkawAsnpLFh1+NJnbj+8WF6kWyKSTayfll58A+yzIphC6v80dijrA63uft2t1RSpuCliMHoN9j5GkyVU=
X-Received: by 2002:a37:9a97:: with SMTP id c145mr6769847qke.350.1610628715515;
 Thu, 14 Jan 2021 04:51:55 -0800 (PST)
MIME-Version: 1.0
References: <20210113133523.39205-1-alobakin@pm.me> <20210113133635.39402-1-alobakin@pm.me>
 <20210113133635.39402-2-alobakin@pm.me> <CANn89i+azKGzpt4LrVVVCQdf82TLOC=dwUjA4NK3ziQHSKvtFw@mail.gmail.com>
 <20210114114046.7272-1-alobakin@pm.me> <CACT4Y+adbmvvbzFnzRZzmpdTipg7ye53uR6OrnU9_K030sfzzA@mail.gmail.com>
 <20210114124406.9049-1-alobakin@pm.me> <CACT4Y+bcj_jBkUJhRMvo8kjB78WyoBtCH8+-L0tGkxuRpaO66Q@mail.gmail.com>
In-Reply-To: <CACT4Y+bcj_jBkUJhRMvo8kjB78WyoBtCH8+-L0tGkxuRpaO66Q@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 14 Jan 2021 13:51:44 +0100
Message-ID: <CACT4Y+Z2Nr_iRDeQArtdihtKOLE3Z4Cyz6h5rEbuQCZ6vihe3w@mail.gmail.com>
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

On Thu, Jan 14, 2021 at 1:50 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Thu, Jan 14, 2021 at 1:44 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > From: Dmitry Vyukov <dvyukov@google.com>
> > Date: Thu, 14 Jan 2021 12:47:31 +0100
> >
> > > On Thu, Jan 14, 2021 at 12:41 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > >>
> > >> From: Eric Dumazet <edumazet@google.com>
> > >> Date: Wed, 13 Jan 2021 15:36:05 +0100
> > >>
> > >>> On Wed, Jan 13, 2021 at 2:37 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > >>>>
> > >>>> Instead of calling kmem_cache_alloc() every time when building a NAPI
> > >>>> skb, (re)use skbuff_heads from napi_alloc_cache.skb_cache. Previously
> > >>>> this cache was only used for bulk-freeing skbuff_heads consumed via
> > >>>> napi_consume_skb() or __kfree_skb_defer().
> > >>>>
> > >>>> Typical path is:
> > >>>>  - skb is queued for freeing from driver or stack, its skbuff_head
> > >>>>    goes into the cache instead of immediate freeing;
> > >>>>  - driver or stack requests NAPI skb allocation, an skbuff_head is
> > >>>>    taken from the cache instead of allocation.
> > >>>>
> > >>>> Corner cases:
> > >>>>  - if it's empty on skb allocation, bulk-allocate the first half;
> > >>>>  - if it's full on skb consuming, bulk-wipe the second half.
> > >>>>
> > >>>> Also try to balance its size after completing network softirqs
> > >>>> (__kfree_skb_flush()).
> > >>>
> > >>> I do not see the point of doing this rebalance (especially if we do not change
> > >>> its name describing its purpose more accurately).
> > >>>
> > >>> For moderate load, we will have a reduced bulk size (typically one or two).
> > >>> Number of skbs in the cache is in [0, 64[ , there is really no risk of
> > >>> letting skbs there for a long period of time.
> > >>> (32 * sizeof(sk_buff) = 8192)
> > >>> I would personally get rid of this function completely.
> > >>
> > >> When I had a cache of 128 entries, I had worse results without this
> > >> function. But seems like I forgot to retest when I switched to the
> > >> original size of 64.
> > >> I also thought about removing this function entirely, will test.
> > >>
> > >>> Also it seems you missed my KASAN support request ?
> > >>  I guess this is a matter of using kasan_unpoison_range(), we can ask for help.
> > >>
> > >> I saw your request, but don't see a reason for doing this.
> > >> We are not caching already freed skbuff_heads. They don't get
> > >> kmem_cache_freed before getting into local cache. KASAN poisons
> > >> them no earlier than at kmem_cache_free() (or did I miss someting?).
> > >> heads being cached just get rid of all references and at the moment
> > >> of dropping to the cache they are pretty the same as if they were
> > >> allocated.
> > >
> > > KASAN should not report false positives in this case.
> > > But I think Eric meant preventing false negatives. If we kmalloc 17
> > > bytes, KASAN will detect out-of-bounds accesses beyond these 17 bytes.
> > > But we put that data into 128-byte blocks, KASAN will miss
> > > out-of-bounds accesses beyond 17 bytes up to 128 bytes.
> > > The same holds for "logical" use-after-frees when object is free, but
> > > not freed into slab.
> > >
> > > An important custom cache should use annotations like
> > > kasan_poison_object_data/kasan_unpoison_range.
> >
> > As I understand, I should
> > kasan_poison_object_data(skbuff_head_cache, skb) and then
> > kasan_unpoison_range(skb, sizeof(*skb)) when putting it into the
> > cache?
>
> I think it's the other way around. It should be _un_poisoned when used.
> If it's fixed size, then unpoison_object_data should be a better fit:
> https://elixir.bootlin.com/linux/v5.11-rc3/source/mm/kasan/common.c#L253

Variable-size poisoning/unpoisoning would be needed for the skb data itself:
https://bugzilla.kernel.org/show_bug.cgi?id=199055
