Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80D8382877
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhEQJiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbhEQJiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:38:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D17C06138C
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:36:46 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k10so8177243ejj.8
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oBONMSeVk3mkFLoo1iBeMpsZIq60WjLRCr3CPYmB9hw=;
        b=ayS0SjvZNbHk5n5ghskIINknXhtZycIw5XVWXgfvy//i8fpJsxvt/HVxPLhEYJYIxf
         0O39/j7n9Y7MZuatuZvATJ2Paal0H5hMY6/o/Az5CBvNMZGUtnDsmQSoTruGq3vGmNj2
         Azko/u2r/sYuDXCa6HJzuTICMwNv2F6tmT3hQ8vOkY8cxwUS8Bgojk+1w8pMY16VUCcA
         6+xS3h6hRXhrJ4JCaH9dic4L2KHXWZHqNnDViYb0i6dJl+4ewN3ismm+A248w9YlDrkC
         uwtigYTt4Hk8TZMJ1FzssxqwK5cvTrYBqejU9zOcF6Lpau0oTk10l0zrehPOaufe611n
         gNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oBONMSeVk3mkFLoo1iBeMpsZIq60WjLRCr3CPYmB9hw=;
        b=BaINu+/zp549mE1+3osMMpXvDA9XgT0e5BNdmzm1tiVNDv0ER5axIly0UyvXmfz7tV
         fs82s232SE9/hP0i1dIP4GUz0AepMyu+aDCKxAgWZR5rhLVzdLeN6mCgsmsDJlKERarr
         Z+5cV3RuJWXIcxzoK9KTi+rDBN+56EUhvFx9i4VbdHEI2Y9UCQujEqjqcZIvKE3QxUmS
         OcC9mzgPzBJKYv5+UAP7LFjZzDAHP9Vt3/UFctVnlDJYd/cGvdhMLCiCWR9Ilejm69jY
         QLuSZGMa7m27tQ9VRAbXV0ilRTFta9u2eQU+ze3zr5Af2lcsbASC/+thCa7y/LPuZ/pn
         q+3w==
X-Gm-Message-State: AOAM532OO5sy41BBeWVfqI1b1I/ZgoGOfCerLv5qMe1C8M8erCRLZSyQ
        dDmGxvhAAeoMnFyyQo7/IPJIMQ==
X-Google-Smtp-Source: ABdhPJzxfIGgl7ar1vm83gi2iU9HO7hLUc61oQG+m8QtupK7WFoN9a/7Kz8tU9OUCMZCwSA/rcW8vw==
X-Received: by 2002:a17:906:ae10:: with SMTP id le16mr5494911ejb.296.1621244205548;
        Mon, 17 May 2021 02:36:45 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id f20sm3606918edu.24.2021.05.17.02.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:36:45 -0700 (PDT)
Date:   Mon, 17 May 2021 12:36:39 +0300
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
Message-ID: <YKI5JxG2rw2y6C1P@apalos.home>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-4-mcroce@linux.microsoft.com>
 <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
 <YJ4ocslvURa/H+6f@apalos.home>
 <212498cf-376b-2dac-e1cd-12c7cc7910c6@huawei.com>
 <YJ5APhzabmAKIKCE@apalos.home>
 <cd0c0a2b-986e-a672-de7e-798ab2843d76@huawei.com>
 <YKIPcF9ACNmFtksz@enceladus>
 <fade4bc7-c1c7-517e-a775-0a5bb2e66be6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fade4bc7-c1c7-517e-a775-0a5bb2e66be6@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>

[...]

> >> In that case, the skb_mark_for_recycle() could only set the skb->pp_recycle,
> >> but not the pool->p.
> >>
> >>>
> >>>>
> >>>> Another thing accured to me is that if the driver use page from the
> >>>> page pool to form a skb, and it does not call skb_mark_for_recycle(),
> >>>> then there will be resource leaking, right? if yes, it seems the
> >>>> skb_mark_for_recycle() call does not seems to add any value?
> >>>>
> >>>
> >>> Not really, the driver has 2 choices:
> >>> - call page_pool_release_page() once it receives the payload. That will
> >>>   clean up dma mappings (if page pool is responsible for them) and free the
> >>>   buffer
> >>
> >> The is only needed before SKB recycling is supported or the driver does not
> >> want the SKB recycling support explicitly, right?
> >>
> > 
> > This is needed in general even before recycling.  It's used to unmap the
> > buffer, so once you free the SKB you don't leave any stale DMA mappings.  So
> > that's what all the drivers that use page_pool call today.
> 
> As my understanding:
> 1. If the driver is using page allocated from page allocator directly to
>    form a skb, let's say the page is owned by skb(or not owned by anyone:)),
>    when a skb is freed, the put_page() should be called.
> 
> 2. If the driver is using page allocated from page pool to form a skb, let's
>    say the page is owned by page pool, when a skb is freed, page_pool_put_page()
>    should be called.
> 
> What page_pool_release_page() mainly do is to make page in case 2 return back
> to case 1.

Yea but this is done deliberately.  Let me try to explain the reasoning a
bit.  I don't think mixing the SKB path with page_pool is the right idea. 
page_pool allocates the memory you want to build an SKB and imho it must be 
kept completely disjoint with the generic SKB code.  So once you free an SKB,
I don't like having page_pool_put_page() in the release code explicitly.  
What we do instead is call page_pool_release_page() from the driver.  So the 
page is disconnected from page pool and the skb release path works as it used 
to.

> 
> And page_pool_release_page() is replaced with skb_mark_for_recycle() in patch
> 4/5 to avoid the above "case 2" -> "case 1" changing, so that the page is still
> owned by page pool, right?
> 
> So the point is that skb_mark_for_recycle() does not really do anything about
> the owner of the page, it is still owned by page pool, so it makes more sense
> to keep the page pool ptr instead of setting it every time when
> skb_mark_for_recycle() is called?

Yes it doesn't do anything wrt to ownership.  The page must always come
from page pool if you want to recycle it. But as I tried to explain above,
it felt more intuitive to keep the driver flow as-is as well as  the
release path.  On a driver right now when you are done with the skb creation, 
you unmap the skb->head + fragments.  So if you want to recycle it it instead, 
you mark the skb and fragments.

> 
> > 
> >>> - call skb_mark_for_recycle(). Which will end up recycling the buffer.
> >>
> >> If the driver need to add extra flag to enable recycling based on skb
> >> instead of page pool, then adding skb_mark_for_recycle() makes sense to
> >> me too, otherwise it seems adding a field in pool->p to recycling based
> >> on skb makes more sense?
> >>
> > 
> > The recycling is essentially an SKB feature though isn't it?  You achieve the
> > SKB recycling with the help of page_pool API, not the other way around.  So I
> > think this should remain on the SKB and maybe in the future find ways to turn
> > in on/off?
> 
> As above, does it not make more sense to call page_pool_release_page() if the
> driver does not need the SKB recycling?

Call it were? As i tried to explain it makes no sense to me having it in
generic SKB code (unless recycling is enabled).

That's what's happening right now when recycling is enabled.
Basically the call path is:
if (skb bit is set) {
	if (page signature matches)
		page_pool_put_full_page() 
}
page_pool_put_full_page() will either:
1. recycle the page in the 'fast cache' of page pool
2. recycle the page in the ptr ring of page pool
3. Release it calling page_pool_release_page()

If you don't want to enable it you just call page_pool_release_page() on
your driver and the generic path will free the allocated page.

> 
> Even if when skb->pp_recycle is 1, pages allocated from page allocator directly
> or page pool are both supported, so it seems page->signature need to be reliable
> to indicate a page is indeed owned by a page pool, which means the skb->pp_recycle
> is used mainly to short cut the code path for skb->pp_recycle is 0 case, so that
> the page->signature does not need checking?

Yes, the idea for the recycling bit, is that you don't have to fetch the page
in cache do do more processing (since freeing is asynchronous and we
can't have any guarantees on what the cache will have at that point).  So we
are trying to affect the existing release path a less as possible. However it's
that new skb bit that triggers the whole path.

What you propose could still be doable though.  As you said we can add the
page pointer to struct page when we allocate a page_pool page and never
reset it when we recycle the buffer. But I don't think there will be any
performance impact whatsoever. So I prefer the 'visible' approach, at least for
the first iteration.

Thanks
/Ilias
 
