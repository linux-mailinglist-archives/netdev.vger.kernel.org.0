Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E041036FE6E
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhD3QZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 12:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhD3QZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 12:25:00 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8254C06138D
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 09:24:11 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id zg3so24527324ejb.8
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 09:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mwqVO5O2e4qn+C8cpBOkq45JASNi1JFNeTKlRI/lCs4=;
        b=NvA9j/ifwfKe59vNTwP+Wxi7INrk55tqbmSXrwUdiE2feP2djVkfgDi2PZQy+/usvp
         qe8KaWzUqxZDGZGPa4ob+8n8YsKFwDSVPWQP9z3as54hGW2Lu2JgbSglkaAHEHwhpbVk
         GMR3rqcuOAD/hCq/HjWtr70jlWyOMzlvuD7gZtzn6N5pNVOyn7V7ZRLwoGr+X7kRQNtJ
         kLP3N6UV4TTZtyRC7mHd7FFtBC1GVa1Ia7hnMq4hRDbz3GWnYzWY8CbJT5j8QUdSQ03T
         QZRf3h+UITj/Uok7p2TgGYXgkK3HlKi+MCUf0WYbW3OzdMJ14qGF16W4JU3VPaRzinhE
         VEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mwqVO5O2e4qn+C8cpBOkq45JASNi1JFNeTKlRI/lCs4=;
        b=pdK55qD/ShnMra2klkExb1+FgneRcU5mRyy1+YM3kDBVhG0uHhg/TydbtbrIoMUOs2
         hVfp4XsaPOF7RNW1fFaRkIeVVtT2fbgfwhwTahRs0tvtbByWthYCI50IbPtROXn7d6lC
         W1qvb97gy562kSqcFJbYUICAEYLmMjRbSaUoebjdAThL2CLzPMx5sh3XWjDx63nyglix
         h8fRGNm+4gCsbaVhq8oiF7TnqyE67w1SnLTxc/irrzQPpom9MTZeY7FnY3mIS8jE5waE
         14fz6LlYq+OnDQIbqr6GruwZXezoq8ANMGc0kLt9PVmIpa8e3n+2YzpqYrB1dACiAV0W
         nRiA==
X-Gm-Message-State: AOAM530UjvBY7R9WY88swMMM0MrKFnEO7ZsDgb4g1W79dTSiu7NUiLVl
        CnWlAr+YrTw5n7ABdymjG1UTgOWfi0OAS8rw
X-Google-Smtp-Source: ABdhPJwspeacau4Mf51sMUSHNfeG3QTA2QyRAmxBCgydY0y8kwjc7b8xW2eyjbVUMfvvgt64UssD8w==
X-Received: by 2002:a17:907:724d:: with SMTP id ds13mr5319581ejc.442.1619799850275;
        Fri, 30 Apr 2021 09:24:10 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id z17sm2305695ejc.69.2021.04.30.09.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 09:24:09 -0700 (PDT)
Date:   Fri, 30 Apr 2021 19:24:03 +0300
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
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
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
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
Message-ID: <YIwvI5/ygBvZG5sy@apalos.home>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
 <YIsAIzecktXXBlxn@apalos.home>
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> >>
> >> 1. skb frag page recycling do not need "struct xdp_rxq_info" or
> >>    "struct xdp_mem_info" to bond the relation between "struct page" and
> >>    "struct page_pool", which seems uncessary at this point if bonding
> >>    a "struct page_pool" pointer directly in "struct page" does not cause
> >>    space increasing.
> > 
> > We can't do that. The reason we need those structs is that we rely on the
> > existing XDP code, which already recycles it's buffers, to enable
> > recycling.  Since we allocate a page per packet when using page_pool for a
> > driver , the same ideas apply to an SKB and XDP frame. We just recycle the
> 
> I am not really familar with XDP here, but a packet from hw is either a
> "struct xdp_frame/xdp_buff" for XDP or a "struct sk_buff" for TCP/IP stack,
> a packet can not be both "struct xdp_frame/xdp_buff" and "struct sk_buff" at
> the same time, right?
> 

Yes, but the payload is irrelevant in both cases and that's what we use
page_pool for.  You can't use this patchset unless your driver usues
build_skb().  So in both cases you just allocate memory for the payload and
decide what the wrap the buffer with (XDP or SKB) later.

> What does not really make sense to me is that the page has to be from page
> pool when a skb's frag page can be recycled, right? If it is ture, the switch
> case in __xdp_return() does not really make sense for skb recycling, why go
> all the trouble of checking the mem->type and mem->id to find the page_pool
> pointer when recyclable page for skb can only be from page pool?

In any case you need to find in which pool the buffer you try to recycle
belongs.  In order to make the whole idea generic and be able to recycle skb 
fragments instead of just the skb head you need to store some information on 
struct page.  That's the fundamental difference of this patchset compared to 
the RFC we sent a few years back [1] which was just storing information on the 
skb.  The way this is done on the current patchset is that we store the 
struct xdp_mem_info in page->private and then look it up on xdp_return().

Now that being said Matthew recently reworked struct page, so we could see if
we can store the page pool pointer directly instead of the struct
xdp_mem_info. That would allow us to call into page pool functions directly.
But we'll have to agree if that makes sense to go into struct page to begin
with and make sure the pointer is still valid when we take the recycling path.

> > payload and we don't really care what's in that.  We could rename the functions
> > to something more generic in the future though ?
> > 
> >>
> >> 2. it would be good to do the page reference count updating batching
> >>    in page pool instead of specific driver.
> >>
> >>
> >> page_pool_atomic_sub_if_positive() is added to decide who can call
> >> page_pool_put_full_page(), because the driver and stack may hold
> >> reference to the same page, only if last one which hold complete
> >> reference to a page can call page_pool_put_full_page() to decide if
> >> recycling is possible, if not, the page is released, so I am wondering
> >> if a similar page_pool_atomic_sub_if_positive() can added to specific
> >> user space address unmapping path to allow skb recycling for RX zerocopy
> >> too?
> >>
> > 
> > I would prefer a different page pool type if we wanted to support the split
> > page model.  The changes as is are quite intrusive, since they change the 
> > entire skb return path.  So I would prefer introducing the changes one at a 
> > time. 
> 
> I understand there may be fundamental semantic change when split page model
> is supported by page pool, but the split page support change mainly affect the
> skb recycling path and the driver that uses page pool(XDP too) if we are careful
> enough, not the entire skb return path as my understanding.

It affects those drivers only, but in order to do so is intercepts the
packet in skb_free_head(), which pretty much affects the entire network path.

> 
> Anyway, one changes at a time is always prefered if supporting split page is
> proved to be non-trivel and intrusive.
> 
> > 
> > The fundamental difference between having the recycling in the driver vs
> > having it in a generic API is pretty straightforward.  When a driver holds
> > the extra page references he is free to decide what to reuse, when he is about
> > to refill his Rx descriptors.  So TCP zerocopy might work even if the
> > userspace applications hold the buffers for an X amount of time.
> > On this proposal though we *need* to decide what to do with the buffer when we
> > are about to free the skb.
> 
> I am not sure I understand what you meant by "free the skb", does it mean
> that kfree_skb() is called to free the skb.

Yes

> 
> As my understanding, if the skb completely own the page(which means page_count()
> == 1) when kfree_skb() is called, __page_pool_put_page() is called, otherwise
> page_ref_dec() is called, which is exactly what page_pool_atomic_sub_if_positive()
> try to handle it atomically.
> 

Not really, the opposite is happening here. If the pp_recycle bit is set we
will always call page_pool_return_skb_page().  If the page signature matches
the 'magic' set by page pool we will always call xdp_return_skb_frame() will
end up calling __page_pool_put_page(). If the refcnt is 1 we'll try
to recycle the page.  If it's not we'll release it from page_pool (releasing
some internal references we keep) unmap the buffer and decrement the refcnt.

[1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/

Cheers
/Ilias
