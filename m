Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCD139D437
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 06:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhFGEzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 00:55:09 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:45018 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhFGEzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 00:55:08 -0400
Received: by mail-wr1-f47.google.com with SMTP id f2so15933830wri.11
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 21:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GSrkzkz7xM597OmtYCnt2HUmLY0/0lkG7FOWLrVNAms=;
        b=FHl4f2ZMNz83wbOOximW+hD3upYQGy1AuGocMMiFVdvqnDQaqr0v5s4QckDZNIRw+G
         fXR/saqHsOXCJX/B+NJqEvCwCHsZUFAQa5eTqGBit32iZWBABoWo9dW9UGuHlucHyYEn
         Hv/YFYR54d5IddJbd2vEnZ28MlHEQG6/RAJpJgohGxMDsGtPLO6DPPu3sBlJqBszMErr
         tSpH4uoPeh5eTTm1tOJPWyRY/0yc9Ls3NRMfQDSUJqd0qrFQ8SZ6S88tIO44S4HPIaoh
         RZmcqSUQpMJ+YHXuDmOVZ8XvROg5CDwAO3rVuqJ1a/LEtaMI8DY45It6NF9hG71vJu0h
         F3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GSrkzkz7xM597OmtYCnt2HUmLY0/0lkG7FOWLrVNAms=;
        b=XrVJHSfJKk7AaN5h2/FRjVSl6wLLws+82jqbGOnqsm/y62u5NDHAY4X+95O9WSS44l
         MlU9DRx+COd3Zo1YP66+fAQx07jQ9E8IJkMAyDt4TeuqiizI6BUG9vuuR63Tkf/boTQy
         VwVzqgreun/kx5ByxDSAjKUJkLbewsLPsJoOqfpda5aG6nXHX5QuBNOaaqz+Y6E9ufte
         CyvlpxRY1ktpBiAtRMc20FiaSQFWU4Uay/q0AVMmyuCQBc+z5612MP+ecuJVGhXFbq3k
         0DuQTv22PszpAX+d0vY4Dl4ts9L48dv+GrU9TLhttt28cMSv3lvdA0xbXrdxQ/D65tVN
         /Ujg==
X-Gm-Message-State: AOAM5326mcuGcMz71aiRVQHrDxVYrB2/yehRQyWo5hLt2wLawGI57+NC
        HMn01gA5duMYgi1efjq/jxi9AA==
X-Google-Smtp-Source: ABdhPJyH2kD08IkD4rO54NrYaJ6NqrZO0rrFvYt+XutsC9lnfAjdURf0mdSoSNbTp3YUeEf2+VNTpg==
X-Received: by 2002:a5d:6b09:: with SMTP id v9mr15195054wrw.297.1623041521972;
        Sun, 06 Jun 2021 21:52:01 -0700 (PDT)
Received: from Iliass-MBP (ppp-94-66-57-185.home.otenet.gr. [94.66.57.185])
        by smtp.gmail.com with ESMTPSA id n2sm15303342wmb.32.2021.06.06.21.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 21:52:01 -0700 (PDT)
Date:   Mon, 7 Jun 2021 07:51:56 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
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
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v7 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <YL2l7OxN4m7+d303@Iliass-MBP>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-4-mcroce@linux.microsoft.com>
 <YLqCAEVG+aLNGlIi@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLqCAEVG+aLNGlIi@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 08:41:52PM +0100, Matthew Wilcox wrote:
> On Fri, Jun 04, 2021 at 08:33:47PM +0200, Matteo Croce wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 7fcfea7e7b21..057b40ad29bd 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -40,6 +40,9 @@
> >  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> >  #include <linux/netfilter/nf_conntrack_common.h>
> >  #endif
> > +#ifdef CONFIG_PAGE_POOL
> > +#include <net/page_pool.h>
> > +#endif
> 
> I'm not a huge fan of conditional includes ... any reason to not include
> it always?

I think we can. I'll check and change it. 

> 
> > @@ -3088,7 +3095,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
> >   */
> >  static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
> >  {
> > -	put_page(skb_frag_page(frag));
> > +	struct page *page = skb_frag_page(frag);
> > +
> > +#ifdef CONFIG_PAGE_POOL
> > +	if (recycle && page_pool_return_skb_page(page_address(page)))
> > +		return;
> 
> It feels weird to have a page here, convert it back to an address,
> then convert it back to a head page in page_pool_return_skb_page().
> How about passing 'page' here, calling compound_head() in
> page_pool_return_skb_page() and calling virt_to_page() in skb_free_head()?
> 

Sure, sounds reasonable. 

> > @@ -251,4 +253,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
> >  		spin_unlock_bh(&pool->ring.producer_lock);
> >  }
> >  
> > +/* Store mem_info on struct page and use it while recycling skb frags */
> > +static inline
> > +void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> > +{
> > +	page->pp = pp;
> 
> I'm not sure this wrapper needs to exist.
> 
> > +}
> > +
> >  #endif /* _NET_PAGE_POOL_H */
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index e1321bc9d316..a03f48f45696 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -628,3 +628,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
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
> > +		return false;
> > +
> > +	pp = (struct page_pool *)page->pp;
> 
> You don't need the cast any more.
> 

True

> > +	/* Driver set this to memory recycling info. Reset it on recycle.
> > +	 * This will *not* work for NIC using a split-page memory model.
> > +	 * The page will be returned to the pool here regardless of the
> > +	 * 'flipped' fragment being in use or not.
> > +	 */
> > +	page->pp = NULL;
> > +	page_pool_put_full_page(pp, page, false);
> > +
> > +	return true;
> > +}
> > +EXPORT_SYMBOL(page_pool_return_skb_page);
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 12b7e90dd2b5..f769f08e7b32 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -70,6 +70,9 @@
> >  #include <net/xfrm.h>
> >  #include <net/mpls.h>
> >  #include <net/mptcp.h>
> > +#ifdef CONFIG_PAGE_POOL
> > +#include <net/page_pool.h>
> > +#endif
> >  
> >  #include <linux/uaccess.h>
> >  #include <trace/events/skb.h>
> > @@ -645,10 +648,15 @@ static void skb_free_head(struct sk_buff *skb)
> >  {
> >  	unsigned char *head = skb->head;
> >  
> > -	if (skb->head_frag)
> > +	if (skb->head_frag) {
> > +#ifdef CONFIG_PAGE_POOL
> > +		if (skb->pp_recycle && page_pool_return_skb_page(head))
> > +			return;
> > +#endif
> 
> put this in a header file:
> 
> static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
> {
> 	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
> 		return false;
> 	return page_pool_return_skb_page(virt_to_page(data));
> }
> 
> then this becomes:
> 
> 	if (skb->head_frag) {
> 		if (skb_pp_recycle(skb, head))
> 			return;
> >  		skb_free_frag(head);
> > -	else
> > +	} else {
> >  		kfree(head);
> > +	}
> >  }
> >  

ok


Thanks for having a look

Cheers
/Ilias
