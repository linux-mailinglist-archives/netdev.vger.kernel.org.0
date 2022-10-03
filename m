Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676AA5F3911
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 00:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiJCWbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 18:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiJCWbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 18:31:10 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E9056BAF
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 15:31:09 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 69so3045850ybl.6
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bIP4GIPSujgPUiNMDgbXr6dE6GIFzIUlmaEW40Ki80o=;
        b=SxNGMZOOFmjA9owP1htaEzBggIHq20wjyh/W2XJjHUR4/CwH4rpsNlYBm0iYTPMM/q
         muXkiUiBqk0CBH3JpS7OVvTabeo3jOpmf2oHgX3Iu3SYG9pqWT7+DpO0kln/vWHIGUVt
         MXvlmLLuBVvjsoE5cwhQqLV58/8M1tHFF8UKPwHi57HdIqqiNkM8Phr3R2pKbP2voQWp
         tafAKaLimuUWKypPSX6CI9xDe5IE/k8LSAfrbiiBK0juKp08OgfDCqplYIrgZzAwndD3
         1M9fpOJoW74nf2Q4rvzw+vzCiqn7gLl7VxR92rWpj7GkVpGCNdHd4854pWUBnS/s/PIk
         5M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bIP4GIPSujgPUiNMDgbXr6dE6GIFzIUlmaEW40Ki80o=;
        b=ff6IZKpp/aziYXT/spqN40nkTr+3Z/a7vDgkvZ0vLHnjH7YJCKp0id9BCufaXUwwGu
         gGtz4CEWuEFQtQZUhg3H/ay/3R6p1+smhcKkDpnew9kVgYknyAoLQKCJWb5XBI9hWq5d
         2lszCHHIQJqMUyva9sW8MJiPWUxk2f+FfiBRUJOj0XsbuU85WnvS9sLWgpuLiKwMVQ3q
         DdEh8lTThqJoPdEkpiwAvOOFAgh3tazdFu3FYtwonBjXL0145UygcgFD3Ze1xS4+CFLr
         GihKd5i+i78/44yWyos90Rw1EfVhrLnetmIh35s5uPJNF3pk/QHKOFyllnWsdxQNLCEF
         TGeg==
X-Gm-Message-State: ACrzQf1wmLY5mDQ0c1TFJFUnQiMLpwi70OJ/gM7PL1vsBZG0wzGZLI5l
        6LWae1h5rwXVRqMBTrp4l5h/jzfTQGR0RMWzyzUgYTVQ8F84bA==
X-Google-Smtp-Source: AMsMyM42Nmkbgp8fg6ofhp0X+C6sFpTWdMhMghl5frE5gOxHrhv0Ifjf32L6sj1HwG8ayHkbXwLtYJwGuhxxB1rZbCA=
X-Received: by 2002:a25:bc8f:0:b0:6bd:ab73:111 with SMTP id
 e15-20020a25bc8f000000b006bdab730111mr7377067ybk.36.1664836268238; Mon, 03
 Oct 2022 15:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
 <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
 <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com>
 <cdbfe4615ffec2bcfde94268dbc77dfa98143f39.camel@redhat.com>
 <CANn89i+SjRtpG9e3gJjh7sNELUYETSkOi86Qk_eC2sQOV39UGg@mail.gmail.com>
 <06a1cdb330980e3df051c95ae089fd77afee839b.camel@redhat.com> <d15aab527c1979e0bf539e8e1609f0770b4170fc.camel@redhat.com>
In-Reply-To: <d15aab527c1979e0bf539e8e1609f0770b4170fc.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 3 Oct 2022 15:30:57 -0700
Message-ID: <CANn89iKXcagXP=QkYtrsk5jFXiyvhNL=bdXJZLc5T3e3=+jSiA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 3, 2022 at 2:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Sun, 2022-10-02 at 16:55 +0200, Paolo Abeni wrote:
> > On Fri, 2022-09-30 at 10:45 -0700, Eric Dumazet wrote:
> > > On Fri, Sep 30, 2022 at 10:30 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > On Fri, 2022-09-30 at 09:43 -0700, Eric Dumazet wrote:
> > > > > Paolo, this patch adds a regression for TCP RPC workloads (aka TCP_RR)
> > > > >
> > > > > Before the patch, cpus servicing NIC interrupts were allocating
> > > > > SLAB/SLUB objects for incoming packets,
> > > > > but they were also freeing skbs from TCP rtx queues when ACK packets
> > > > > were processed. SLAB/SLUB caches
> > > > > were efficient (hit ratio close to 100%)
> > > >
> > > > Thank you for the report. Is that reproducible with netperf TCP_RR and
> > > > CONFIG_DEBUG_SLAB, I guess? Do I need specific request/response sizes?
> > >
> > > No CONFIG_DEBUG_SLAB, simply standard SLAB, and tcp_rr tests on an AMD
> > > host with 256 cpus...
> >
> > The most similar host I can easily grab is a 2 numa nodes AMD with 16
> > cores/32 threads each.
> >
> > I tried tcp_rr with different number of flows in (1-2048) range with
> > both slub (I tried first that because is the default allocator in my
> > builds) and slab but so far I can't reproduce it: results differences
> > between pre-patch and post-patch kernel are within noise and numastat
> > never show misses.
> >
> > I'm likely missing some incredient to the recipe. I'll try next to pin
> > the netperf/netserver processes on a numa node different from the NIC's
> > one and to increase the number of concurrent flows.
>
> I'm still stuck trying to reproduce the issue. I tried pinning and
> increasing the flows numbers, but I could not find a scenario with a
> clear regression. I see some contention, but it's related to the timer
> wheel spinlock, and independent from my patch.

I was using neper ( https://github.com/google/neper ), with 100
threads and 4000 flows.

I suspect contention is hard to see unless you use a host with at
least 128 cores.
Also you need a lot of NIC receive queues (or use RPS to spread
incoming packets to many cores)


>
> Which kind of delta should I observe? Could you please share any
> additional setup hints?
>
> > I'm also wondering, after commit 68822bdf76f10 ("net: generalize skb
> > freeing deferral to per-cpu lists") the CPUs servicing the NIC
> > interrupts both allocate and (defer) free the memory for the incoming
> > packets,  so they should not have to access remote caches ?!? Or at
> > least isn't the allocator behavior always asymmetric, with rx alloc, rx
> > free, tx free on the same core and tx alloc possibly on a different
> > one?
> >
> > >
> > > We could first try in tcp_stream_alloc_skb()
> >
> > I'll try to test something alike the following - after reproducing the
> > issue.
> > ---
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index f15d5b62539b..d5e9be98e8bd 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1308,6 +1308,30 @@ static inline struct sk_buff *alloc_skb_fclone(unsigned int size,
> >       return __alloc_skb(size, priority, SKB_ALLOC_FCLONE, NUMA_NO_NODE);
> >  }
> >
> > +#if PAGE_SIZE == SZ_4K
> > +
> > +#define NAPI_HAS_SMALL_PAGE_FRAG     1
> > +
> > +struct sk_buff *__alloc_skb_fclone_frag(unsigned int size, gfp_t priority);
> > +
> > +static inline struct sk_buff *alloc_skb_fclone_frag(unsigned int size, gfp_t priority)
> > +{
> > +     if (size <= SKB_WITH_OVERHEAD(1024))
> > +             return __alloc_skb_fclone_frag(size, priority);
> > +
> > +     return alloc_skb_fclone(size, priority);
> > +}
> > +
> > +#else
> > +#define NAPI_HAS_SMALL_PAGE_FRAG     0
> > +
> > +static inline struct sk_buff *alloc_skb_fclone_frag(unsigned int size, gfp_t priority)
> > +{
> > +     return alloc_skb_fclone(size, priority);
> > +}
> > +
> > +#endif
> > +
> >  struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src);
> >  void skb_headers_offset_update(struct sk_buff *skb, int off);
> >  int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask);
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 81d63f95e865..0c63653c9951 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -134,9 +134,8 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
> >  #define NAPI_SKB_CACHE_BULK  16
> >  #define NAPI_SKB_CACHE_HALF  (NAPI_SKB_CACHE_SIZE / 2)
> >
> > -#if PAGE_SIZE == SZ_4K
> > +#if NAPI_HAS_SMALL_PAGE_FRAG
> >
> > -#define NAPI_HAS_SMALL_PAGE_FRAG     1
> >  #define NAPI_SMALL_PAGE_PFMEMALLOC(nc)       ((nc).pfmemalloc)
> >
> >  /* specialized page frag allocator using a single order 0 page
> > @@ -173,12 +172,12 @@ static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
> >       nc->offset = offset;
> >       return nc->va + offset;
> >  }
> > +
> >  #else
> >
> >  /* the small page is actually unused in this build; add dummy helpers
> >   * to please the compiler and avoid later preprocessor's conditionals
> >   */
> > -#define NAPI_HAS_SMALL_PAGE_FRAG     0
> >  #define NAPI_SMALL_PAGE_PFMEMALLOC(nc)       false
> >
> >  struct page_frag_1k {
> > @@ -543,6 +542,52 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >  }
> >  EXPORT_SYMBOL(__alloc_skb);
> >
> > +#if NAPI_HAS_SMALL_PAGE_FRAG
> > +/* optimized skb fast-clone allocation variant, using the small
> > + * page frag cache
> > + */
> > +struct sk_buff *__alloc_skb_fclone_frag(unsigned int size, gfp_t gfp_mask)
> > +{
> > +     struct sk_buff_fclones *fclones;
> > +     struct napi_alloc_cache *nc;
> > +     struct sk_buff *skb;
> > +     bool pfmemalloc;
> > +     void *data;
> > +
> > +     /* Get the HEAD */
> > +     skb = kmem_cache_alloc_node(skbuff_fclone_cache, gfp_mask & ~GFP_DMA, NUMA_NO_NODE);
> > +     if (unlikely(!skb))
> > +             return NULL;
> > +     prefetchw(skb);
> > +
> > +     /* We can access the napi cache only in BH context */
> > +     nc = this_cpu_ptr(&napi_alloc_cache);
> > +     local_bh_disable();
>
> For the record, the above is wrong, this_cpu_ptr must be after the
> local_bh_disable() call.

Can you send me (privately maybe) an updated patch ?
Thanks.
