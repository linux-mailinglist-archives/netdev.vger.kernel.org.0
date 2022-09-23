Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120915E7508
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 09:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIWHlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 03:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIWHlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 03:41:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545FA1288A5
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 00:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663918897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aki3z1wt0mIsAmo9GeIB05yOPeRqwZYVExEuKL4Tjrs=;
        b=hGyJcNNWryAEd/MBmpTR/2+ArFcgLK78x5i9K/KaSqvKWPCcSNFLb0VwwKfQN50Ej1x4rQ
        34qQFp18HMwlODUIKrJLj+004zTzY1OzZyEfWydN0MmOFiGe0x1ChorUvUSCGDCqUY8E9p
        DDBo5jkfXdwiqGTjdYcRT9bmItrV0Q8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-MdIxHBipO5mRmuplsT-YxA-1; Fri, 23 Sep 2022 03:41:34 -0400
X-MC-Unique: MdIxHBipO5mRmuplsT-YxA-1
Received: by mail-qv1-f71.google.com with SMTP id m7-20020a0ce6e7000000b004ad69308f01so5894039qvn.9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 00:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=aki3z1wt0mIsAmo9GeIB05yOPeRqwZYVExEuKL4Tjrs=;
        b=Mp9OT5hp09dIGMkaLAE5v61G8xkC1R6SYRIjkSWFoaoIBWUb1r65qPa2lSMcYZjqdm
         NLfeg+cq38jwB2TFfKvRsLBaHC1AtajYX1qfGtRGKivkiCa3JqSPDxlAhFAr/xKIfB7J
         TQzOCVl4DHcSlLGdUggMkyTHeulh6UDwZq7q1jlBY16wIkLCQ2pyLkEFAaQc/XrTBQr6
         7rlsLmJUH/VelP5KHq2E3YCn5c7HGS+ws4UlepdPjrlRcV1i+qwNb230MbFpDkh9UY8L
         Fi4cdbCTElheCrE5l1PP6DmohtWQpF6vLj7qnHp27BDcj8WcFbwFqlb1wdrrgjFDk0HK
         pQzw==
X-Gm-Message-State: ACrzQf0Y6/Mqu+scLz3MIOO4hVtsyGdWA/bPNxpfzAnYub6qXlYWJrzd
        NRqyzh3nmz/RG9LiLAsPBuvaqJ2o8h2/oKQyZq7f3kJRbIY/6C4fG824TouB2oMZHNGCRL54Ggs
        x7vlmmK50dzzHv7ye
X-Received: by 2002:a05:622a:509:b0:35d:55c:be0 with SMTP id l9-20020a05622a050900b0035d055c0be0mr6183562qtx.249.1663918893618;
        Fri, 23 Sep 2022 00:41:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7G9TJewDGt3/3sW3hCRlhOSlD8T+IwGX3NM0GTHDBUfgmjeSfy44Lrx+AqvnjD9Cp87idx2w==
X-Received: by 2002:a05:622a:509:b0:35d:55c:be0 with SMTP id l9-20020a05622a050900b0035d055c0be0mr6183548qtx.249.1663918893326;
        Fri, 23 Sep 2022 00:41:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id i7-20020ac84887000000b003434d3b5938sm4977165qtq.2.2022.09.23.00.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 00:41:32 -0700 (PDT)
Message-ID: <efa64c44b1e53510f972954e4670b2d8ecde97eb.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net: skb: introduce and use a single page
 frag cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 23 Sep 2022 09:41:29 +0200
In-Reply-To: <CAKgT0Uc2qmKTeZMCTR3ZkibioxEwKHjKqLrnz-=cfSt+5TAv=g@mail.gmail.com>
References: <162fe40c387cd395d633729fa4f2b5245531514a.1663879752.git.pabeni@redhat.com>
         <CAKgT0Uc2qmKTeZMCTR3ZkibioxEwKHjKqLrnz-=cfSt+5TAv=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-09-22 at 14:17 -0700, Alexander Duyck wrote:
[...]
> My suggestion earlier was to just make the 1k cache a page_frag_cache.
> It will allow you to reuse the same structure members and a single
> pointer to track them. Waste would be minimal since the only real
> difference between the structures is about 8B for the structure, and
> odds are the napi_alloc_cache allocation is being rounded up anyway.
> 
> >         unsigned int skb_count;
> >         void *skb_cache[NAPI_SKB_CACHE_SIZE];
> >  };
> > @@ -143,6 +202,23 @@ struct napi_alloc_cache {
> >  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
> >  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
> > 
> > +/* Double check that napi_get_frags() allocates skbs with
> > + * skb->head being backed by slab, not a page fragment.
> > + * This is to make sure bug fixed in 3226b158e67c
> > + * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > + * does not accidentally come back.
> > + */
> > +void napi_get_frags_check(struct napi_struct *napi)
> > +{
> > +       struct sk_buff *skb;
> > +
> > +       local_bh_disable();
> > +       skb = napi_get_frags(napi);
> > +       WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
> > +       napi_free_frags(napi);
> > +       local_bh_enable();
> > +}
> > +
> >  void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
> >  {
> >         struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> > @@ -561,6 +637,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> >  {
> >         struct napi_alloc_cache *nc;
> >         struct sk_buff *skb;
> > +       bool pfmemalloc;
> 
> Rather than adding this I think you would be better off adding a
> struct page_frag_cache pointer. I will reference it here as "pfc".
> 
> >         void *data;
> > 
> >         DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> > @@ -568,8 +645,10 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > 
> >         /* If requested length is either too small or too big,
> >          * we use kmalloc() for skb->head allocation.
> > +        * When the small frag allocator is available, prefer it over kmalloc
> > +        * for small fragments
> >          */
> > -       if (len <= SKB_WITH_OVERHEAD(1024) ||
> > +       if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
> >             len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> >             (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> >                 skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
> > @@ -580,13 +659,30 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> >         }
> > 
> >         nc = this_cpu_ptr(&napi_alloc_cache);
> > -       len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > -       len = SKB_DATA_ALIGN(len);
> > 
> >         if (sk_memalloc_socks())
> >                 gfp_mask |= __GFP_MEMALLOC;
> > 
> > -       data = page_frag_alloc(&nc->page, len, gfp_mask);
> > +       if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
> 
> Then here you would add a line that would be:
> pfc = &nc->page_small;
> 
> > +               /* we are artificially inflating the allocation size, but
> > +                * that is not as bad as it may look like, as:
> > +                * - 'len' less then GRO_MAX_HEAD makes little sense
> > +                * - larger 'len' values lead to fragment size above 512 bytes
> > +                *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
> > +                * - kmalloc would use the kmalloc-1k slab for such values
> > +                */
> > +               len = SZ_1K;
> > +
> > +               data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
> > +               pfmemalloc = nc->page_small.pfmemalloc;
> 
> Instead of setting pfmemalloc you could just update the line below. In
> addition you would just be passing pfc as the parameter.
> 
> > +       } else {
> 
> Likewise here you would have the line:
> pfc = &nc->page;

Probaly I was not clear in my previois email, sorry: before posting
this version I tried locally exactly all the above, and the generated
code with gcc 11.3.1 is a little bigger (a couple of instructions) than
what this version produces (with gcc 11.3.1-2). It has the same number
of conditionals and a slightly larger napi_alloc_cache.

Additionally the suggested alternative needs more pre-processor
conditionals to handle the !NAPI_HAS_SMALL_PAGE_FRAG case - avoiding
adding a 2nd, unused in that case, page_frag_cache.

[...]
> 
> > @@ -596,7 +692,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> >                 return NULL;
> >         }
> > 
> > -       if (nc->page.pfmemalloc)
> > +       if (pfmemalloc)
> 
> Instead of passing pfmemalloc you could just check pfc->pfmemalloc.
> Alternatively I wonder if it wouldn't be faster to just set the value
> directly based on frag_cache->pfmemalloc and avoid the conditional
> heck entirely.

Note that:

	skb->pfmemalloc = pfmemalloc;

avoids a branch but requires more instructions than the current code
(verified with gcc). The gain looks doubtful?!? Additionally we have
statement alike:

	if (<pfmemalloc>)
		skb->pfmemalloc = 1;

in other functions in skbuff.c - still fast-path - and would be better
updating all the places together for consistency - if that is really
considered an improvement. IMHO it should at least land in a different
patch.
	
I'll post a v3 with your updated email address, but I think the current
code is the better option.

Cheers,

Paolo

