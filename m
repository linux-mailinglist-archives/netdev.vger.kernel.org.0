Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9938046C
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhENHhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbhENHhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:37:36 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DD3C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:36:25 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t3so1194094edc.7
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=S47bnTENAfz6udhQttejkJkRPmPHYthUy5L+Sbi1l+g=;
        b=Pozo8VEmGUmlZKt9niO8/JKRXDFrjRtmcu1ld/2/dJ9w7KeDp5EOJ2DlbmoPetEW5n
         /mTdLQE3RtyCRgWcMgCZnPa8f/4TTLm1UenFGJY9GewlhaiDUiFXz/7nV9MOH0srBwY8
         pHa0EJb5M1mnk7LdAFN6ukSOV+mQkKKkhq5kNM/B2zbO+OBwMcrP8BxGgC84lU1RG7t1
         5w2FP1K467aR4iMeGI5BpzBVgTmJq4ge6l05gtr18uyT/Eiy8A4klRLW0igwKbxEztp6
         hfPs5dxkU8pBRftlsfRU8kLsrr/MGe7XTw39l6YDzNFrRFjEov9J1hjgv992gQi7Oi8f
         TZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S47bnTENAfz6udhQttejkJkRPmPHYthUy5L+Sbi1l+g=;
        b=hisMIkpNue5IIkuzwhk36wL5LY3nTmSQ020nOyj/ZSpExW6mTwspfMH6xwEVqRB2vL
         mPRBDRB3JFMUIZ0JrbW3z9AOx6DS9hBFk1JNulQMFyT/UWjngi16Z8T1J3hL5dKVkJN4
         ltfpZAfgowF+85TpYAQ7A2NDA/08eE6ly6DwYm7q5hUqi38R3OCCU88bg0/RphCmAsDo
         gug+ji6X/TFnpU55rrw0QrgWntD9bBHp2piEQE09Vr7KFRO+L8MsCEYA05X0cRTMNaar
         q8e5nU2+L4pf8/6bWRrdHSwM+gm9VgtLHp3vxpNufhU1hrVhgSmRK0w6DKg+NeyYD+k/
         PL7Q==
X-Gm-Message-State: AOAM532W8TfWpmkP0vn6LTxmwhxU/kLtwH1mmXXzfVYdeS8j1hJ7/gcH
        mqfDYOxd888J57/9maLop2y57g==
X-Google-Smtp-Source: ABdhPJy6Zo4JHgaVaixpB+IZmKoXaAbTmSjnJttVn13YEvEcyewCues80W+Z2OjksFxyItJCWyNKBw==
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr2423019edu.221.1620977783937;
        Fri, 14 May 2021 00:36:23 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id k12sm3860693edo.50.2021.05.14.00.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 00:36:23 -0700 (PDT)
Date:   Fri, 14 May 2021 10:36:18 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v5 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <YJ4ocslvURa/H+6f@apalos.home>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-4-mcroce@linux.microsoft.com>
 <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> >  	 * using a single memcpy() in __copy_skb_header()
> >  	 */
> > @@ -3088,7 +3095,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
> >   */
> >  static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
> 
> Does it make sure to define a new function like recyclable_skb_frag_unref()
> instead of adding the recycle parameter? This way we may avoid checking
> skb->pp_recycle for head data and every frag?
> 

We'd still have to check when to run __skb_frag_unref or
recyclable_skb_frag_unref so I am not sure we can avoid that.
In any case I'll have a look 

> >  {
> > -	put_page(skb_frag_page(frag));
> > +	struct page *page = skb_frag_page(frag);
> > +
> > +#ifdef CONFIG_PAGE_POOL
> > +	if (recycle && page_pool_return_skb_page(page_address(page)))
> > +		return;
> > +#endif
> > +	put_page(page);
> >  }
> >  
> >  /**
> > @@ -3100,7 +3113,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
> >   */
> >  static inline void skb_frag_unref(struct sk_buff *skb, int f)
> >  {
> > -	__skb_frag_unref(&skb_shinfo(skb)->frags[f], false);
> > +	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
> >  }
> >  
> >  /**
> > @@ -4699,5 +4712,14 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
> >  #endif
> >  }
> >  
> > +#ifdef CONFIG_PAGE_POOL
> > +static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
> > +					struct page_pool *pp)
> > +{
> > +	skb->pp_recycle = 1;
> > +	page_pool_store_mem_info(page, pp);
> > +}
> > +#endif
> > +
> >  #endif	/* __KERNEL__ */
> >  #endif	/* _LINUX_SKBUFF_H */
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 24b3d42c62c0..ce75abeddb29 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -148,6 +148,8 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
> >  	return pool->p.dma_dir;
> >  }
> >  
> > +bool page_pool_return_skb_page(void *data);
> > +
> >  struct page_pool *page_pool_create(const struct page_pool_params *params);
> >  
> >  #ifdef CONFIG_PAGE_POOL
> > @@ -253,4 +255,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
> >  		spin_unlock_bh(&pool->ring.producer_lock);
> >  }
> >  
> > +/* Store mem_info on struct page and use it while recycling skb frags */
> > +static inline
> > +void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> > +{
> > +	page->pp = pp;
> > +}
> > +
> >  #endif /* _NET_PAGE_POOL_H */
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 9de5d8c08c17..fa9f17db7c48 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -626,3 +626,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
> >  	}
> >  }
> >  EXPORT_SYMBOL(page_pool_update_nid);
> > +
> > +bool page_pool_return_skb_page(void *data)
> > +{
> > +	struct page_pool *pp;
> > +	struct page *page;
> > +
> > +	page = virt_to_head_page(data);
> > +	if (unlikely(page->pp_magic != PP_SIGNATURE))
> 
> we have checked the skb->pp_recycle before checking the page->pp_magic,
> so the above seems like a likely() instead of unlikely()?
> 

The check here is ! = PP_SIGNATURE. So since we already checked for
pp_recycle, it's unlikely the signature won't match.

> > +		return false;
> > +
> > +	pp = (struct page_pool *)page->pp;
> > +
> > +	/* Driver set this to memory recycling info. Reset it on recycle.
> > +	 * This will *not* work for NIC using a split-page memory model.
> > +	 * The page will be returned to the pool here regardless of the
> > +	 * 'flipped' fragment being in use or not.
> > +	 */
> > +	page->pp = NULL;
> 
> Why not only clear the page->pp when the page can not be recycled
> by the page pool? so that we do not need to set and clear it every
> time the page is recycled。
> 

If the page cannot be recycled, page->pp will not probably be set to begin
with. Since we don't embed the feature in page_pool and we require the
driver to explicitly enable it, as part of the 'skb flow', I'd rather keep 
it as is.  When we set/clear the page->pp, the page is probably already in 
cache, so I doubt this will have any measurable impact.

> > +	page_pool_put_full_page(pp, virt_to_head_page(data), false);
> > +
> >  	C(end);

[...]

> > @@ -1725,6 +1734,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
> >  	skb->cloned   = 0;
> >  	skb->hdr_len  = 0;
> >  	skb->nohdr    = 0;
> > +	skb->pp_recycle = 0;
> 
> I am not sure why we clear the skb->pp_recycle here.
> As my understanding, the pskb_expand_head() only allocate new head
> data, the old frag page in skb_shinfo()->frags still could be from
> page pool， right?
> 

Ah correct! In that case we must not clear skb->pp_recycle.  The new head
will fail on the signature check and end up being freed, while the
remaining frags will be recycled. The *original* head will be
unmapped/recycled (based of the page refcnt)  on the pskb_expand_head()
itself.

> >  	atomic_set(&skb_shinfo(skb)->dataref, 1);
> >  
> >  	skb_metadata_clear(skb);
> > @@ -3495,7 +3505,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
> >  		fragto = &skb_shinfo(tgt)->frags[merge];
> >  
> >  		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
> > -		__skb_frag_unref(fragfrom, false);
> > +		__skb_frag_unref(fragfrom, skb->pp_recycle);
> >  	}
> >  
> >  	/* Reposition in the original skb */
> > @@ -5285,6 +5295,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
> >  	if (skb_cloned(to))
> >  		return false;
> >  
> > +	/* We can't coalesce skb that are allocated from slab and page_pool
> > +	 * The recycle mark is on the skb, so that might end up trying to
> > +	 * recycle slab allocated skb->head
> > +	 */
> > +	if (to->pp_recycle != from->pp_recycle)
> > +		return false;
> 
> Since we are also depending on page->pp_magic to decide whether to
> recycle a page, we could just set the to->pp_recycle according to
> from->pp_recycle and do the coalesce?

So I was think about this myself.  This check is a 'leftover' from my
initial version, were I only had the pp_recycle bit + struct page
meta-data (without the signature).  Since that version didn't have the
signature you could not coalesce 2 skb's coming from page_pool/slab. 
We could now do what you suggest, but honestly I can't think of many use
cases that this can happen to begin with.  I think I'd prefer leaving it as
is and adjusting the comment.  If we can somehow prove this happens
oftenly and has a performance impact, we can go ahead and remove it.

[...]

Thanks
/Ilias
