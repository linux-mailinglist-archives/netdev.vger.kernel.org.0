Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650195F37F9
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 23:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJCVkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 17:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiJCVku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 17:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B222819036
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 14:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664833249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWhoKM+H2Y+t0IwuaIMsy0KjZ3YQ1ER6tesLuC+gH90=;
        b=INPX+IAtCvFYogQC4C9FTfsJW9iVFpFymjyeL6qRlcs2941vz7ITaP00oC0rKSkytBX7At
        oIw87q+H6L1Q4M1IUwrUg+EoI9/7mdWNB1jrY1Thfcuch5pMaFUS5k0Rgg9sOJmpX7761X
        prVlVsJ5Ab4kLeYXwT/WscN24LbQleE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-203-u6oPM6HTNBWNPEhufmlgKg-1; Mon, 03 Oct 2022 17:40:48 -0400
X-MC-Unique: u6oPM6HTNBWNPEhufmlgKg-1
Received: by mail-wr1-f69.google.com with SMTP id u20-20020adfc654000000b0022cc05e9119so3403241wrg.16
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 14:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=tWhoKM+H2Y+t0IwuaIMsy0KjZ3YQ1ER6tesLuC+gH90=;
        b=WWndetsAUjpqRjSJoGAz92KS8+lyglZ2zPlOvayqMCMCXoCzM3GkJRZEJyP1Auysa9
         tMb7xlcJCV4acEJNQJoiFuuAk1clZGjbOiOyCvXVd/fqHvRODlDTiwz0z8FimykxpKqy
         EWTywF515g0mTZOCF9Dmsaof+8NJfbk3EAykwUhefbQV+CoUjNCjSb5mxfbvM/2bpPsI
         HTETFVEj9fYvuY5p6AH13IUqJ8DAa2DTFYq8jpuHHdepSAI33JtFxJYJc4Ddo2fmDj8/
         v1ZMhh3kNH097u6ZEaqsWq2meyuCzFzCnJYlHcsnfaBXR9gNLBonJev3vWuJ47zzwf4u
         vJHw==
X-Gm-Message-State: ACrzQf3q0a/nAN1rKod8Pl6dLlTScEttjy/uKfUuyKqPnLKeq2vPj9jA
        bisAr4PEtkI4ZH8I8/Jw+sl2iATECnZ3KRHK2VOMEr6DIMaBPF4Gvre5JSiIlgIGZ6Ef8CT6jDB
        5Wfz2L3a3Lr8zAKg5
X-Received: by 2002:a05:600c:3c8e:b0:3b4:d224:addf with SMTP id bg14-20020a05600c3c8e00b003b4d224addfmr8101918wmb.132.1664833245815;
        Mon, 03 Oct 2022 14:40:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4tMvpS2pbc4ABHxDMSqGi5kObWokuq/+y2N9UmvF+jH6Jw7hvnrZR9gZwhDPe0oJOScMCRpg==
X-Received: by 2002:a05:600c:3c8e:b0:3b4:d224:addf with SMTP id bg14-20020a05600c3c8e00b003b4d224addfmr8101908wmb.132.1664833245574;
        Mon, 03 Oct 2022 14:40:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id i7-20020a05600011c700b0021e51c039c5sm5721136wrx.80.2022.10.03.14.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 14:40:44 -0700 (PDT)
Message-ID: <d15aab527c1979e0bf539e8e1609f0770b4170fc.camel@redhat.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Mon, 03 Oct 2022 23:40:43 +0200
In-Reply-To: <06a1cdb330980e3df051c95ae089fd77afee839b.camel@redhat.com>
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
         <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
         <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com>
         <cdbfe4615ffec2bcfde94268dbc77dfa98143f39.camel@redhat.com>
         <CANn89i+SjRtpG9e3gJjh7sNELUYETSkOi86Qk_eC2sQOV39UGg@mail.gmail.com>
         <06a1cdb330980e3df051c95ae089fd77afee839b.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-10-02 at 16:55 +0200, Paolo Abeni wrote:
> On Fri, 2022-09-30 at 10:45 -0700, Eric Dumazet wrote:
> > On Fri, Sep 30, 2022 at 10:30 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Fri, 2022-09-30 at 09:43 -0700, Eric Dumazet wrote:
> > > > Paolo, this patch adds a regression for TCP RPC workloads (aka TCP_RR)
> > > > 
> > > > Before the patch, cpus servicing NIC interrupts were allocating
> > > > SLAB/SLUB objects for incoming packets,
> > > > but they were also freeing skbs from TCP rtx queues when ACK packets
> > > > were processed. SLAB/SLUB caches
> > > > were efficient (hit ratio close to 100%)
> > > 
> > > Thank you for the report. Is that reproducible with netperf TCP_RR and
> > > CONFIG_DEBUG_SLAB, I guess? Do I need specific request/response sizes?
> > 
> > No CONFIG_DEBUG_SLAB, simply standard SLAB, and tcp_rr tests on an AMD
> > host with 256 cpus...
> 
> The most similar host I can easily grab is a 2 numa nodes AMD with 16
> cores/32 threads each.
> 
> I tried tcp_rr with different number of flows in (1-2048) range with
> both slub (I tried first that because is the default allocator in my
> builds) and slab but so far I can't reproduce it: results differences
> between pre-patch and post-patch kernel are within noise and numastat
> never show misses.
> 
> I'm likely missing some incredient to the recipe. I'll try next to pin
> the netperf/netserver processes on a numa node different from the NIC's
> one and to increase the number of concurrent flows.

I'm still stuck trying to reproduce the issue. I tried pinning and
increasing the flows numbers, but I could not find a scenario with a
clear regression. I see some contention, but it's related to the timer
wheel spinlock, and independent from my patch.

Which kind of delta should I observe? Could you please share any
additional setup hints?

> I'm also wondering, after commit 68822bdf76f10 ("net: generalize skb
> freeing deferral to per-cpu lists") the CPUs servicing the NIC
> interrupts both allocate and (defer) free the memory for the incoming
> packets,  so they should not have to access remote caches ?!? Or at
> least isn't the allocator behavior always asymmetric, with rx alloc, rx
> free, tx free on the same core and tx alloc possibly on a different
> one?
> 
> > 
> > We could first try in tcp_stream_alloc_skb()
> 
> I'll try to test something alike the following - after reproducing the
> issue.
> ---
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index f15d5b62539b..d5e9be98e8bd 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1308,6 +1308,30 @@ static inline struct sk_buff *alloc_skb_fclone(unsigned int size,
>  	return __alloc_skb(size, priority, SKB_ALLOC_FCLONE, NUMA_NO_NODE);
>  }
>  
> +#if PAGE_SIZE == SZ_4K
> +
> +#define NAPI_HAS_SMALL_PAGE_FRAG	1
> +
> +struct sk_buff *__alloc_skb_fclone_frag(unsigned int size, gfp_t priority);
> +
> +static inline struct sk_buff *alloc_skb_fclone_frag(unsigned int size, gfp_t priority)
> +{
> +	if (size <= SKB_WITH_OVERHEAD(1024))
> +		return __alloc_skb_fclone_frag(size, priority);
> +
> +	return alloc_skb_fclone(size, priority);
> +}
> +
> +#else
> +#define NAPI_HAS_SMALL_PAGE_FRAG	0
> +
> +static inline struct sk_buff *alloc_skb_fclone_frag(unsigned int size, gfp_t priority)
> +{
> +	return alloc_skb_fclone(size, priority);
> +}
> +
> +#endif
> +
>  struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src);
>  void skb_headers_offset_update(struct sk_buff *skb, int off);
>  int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 81d63f95e865..0c63653c9951 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -134,9 +134,8 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
>  #define NAPI_SKB_CACHE_BULK	16
>  #define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
>  
> -#if PAGE_SIZE == SZ_4K
> +#if NAPI_HAS_SMALL_PAGE_FRAG
>  
> -#define NAPI_HAS_SMALL_PAGE_FRAG	1
>  #define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	((nc).pfmemalloc)
>  
>  /* specialized page frag allocator using a single order 0 page
> @@ -173,12 +172,12 @@ static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
>  	nc->offset = offset;
>  	return nc->va + offset;
>  }
> +
>  #else
>  
>  /* the small page is actually unused in this build; add dummy helpers
>   * to please the compiler and avoid later preprocessor's conditionals
>   */
> -#define NAPI_HAS_SMALL_PAGE_FRAG	0
>  #define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	false
>  
>  struct page_frag_1k {
> @@ -543,6 +542,52 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  }
>  EXPORT_SYMBOL(__alloc_skb);
>  
> +#if NAPI_HAS_SMALL_PAGE_FRAG
> +/* optimized skb fast-clone allocation variant, using the small
> + * page frag cache
> + */
> +struct sk_buff *__alloc_skb_fclone_frag(unsigned int size, gfp_t gfp_mask)
> +{
> +	struct sk_buff_fclones *fclones;
> +	struct napi_alloc_cache *nc;
> +	struct sk_buff *skb;
> +	bool pfmemalloc;
> +	void *data;
> +
> +	/* Get the HEAD */
> +	skb = kmem_cache_alloc_node(skbuff_fclone_cache, gfp_mask & ~GFP_DMA, NUMA_NO_NODE);
> +	if (unlikely(!skb))
> +		return NULL;
> +	prefetchw(skb);
> +
> +	/* We can access the napi cache only in BH context */
> +	nc = this_cpu_ptr(&napi_alloc_cache);
> +	local_bh_disable();

For the record, the above is wrong, this_cpu_ptr must be after the
local_bh_disable() call.


Thanks,

Paolo

