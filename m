Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6B35AF05
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 18:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhDJQRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 12:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhDJQRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 12:17:08 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB06C06138C
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 09:16:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k128so4415958wmk.4
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 09:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZtZHBLTCs7MZ+oNP0mY9TjGEU/md/IA3GJQkuj80sew=;
        b=Bp3G7rXdj30nXahmCb0DX42/GpQq1NqVzRF3U8dpNmLoLFw08YqVW0WmTFlQz+n48O
         M2zywKwO2O5xxvb1z3UGKVFtAEDcrkDu8fWhD3WoVLSrFWHESGd3gWEfXxADH05sAM7O
         wGaMz+7TbhLVVvc8C90tpPkoqpXDs0nzasfuK/ZtQfCl+zxDbsrTM93E9yzxqn2iXTco
         YX2lZWxg+TldvU18p6YAWW/e3bw7NAvlwm3SHKK367vEwZzH9gKvwPrTcsdXyWMDg6qr
         de5eOntFj7fjAPKLWzRfU+Z9V+yxdliPGzjBwyEc/fmcBy+1nxuTJ0czZ3m4q/pHEgr9
         KwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZtZHBLTCs7MZ+oNP0mY9TjGEU/md/IA3GJQkuj80sew=;
        b=d+qDde73Nz+TXYeqr1OQ8FfXTdx72mIPt6ZzcE+nuVB1gksfa5W+Q8zoOHcO0+bEGA
         EhKEO+v+oNs9pVywNk4Gacfthze6hOjKG85gM/UMGQDAD3saW7d1+a3ytyiDejoBKSGw
         Xy6WPB6o9DP9jKno4mVmNSbzGw0L5o8iGR320Sqw0d9UNtVTeyCVi2JCVA1lOk7z0r26
         nkciwZGJ/MFcwcHRzrZZjjYYoEqNI8AF08JP4eAnkMSpGlQl/ebD+btlDJCquGxNtOOE
         cziF2MGT8F//CNTR11NxB5eCCgq81vaTmbqH+88hgk4Hd/bbPtafhED3PaFBGSihXNxp
         G7Zw==
X-Gm-Message-State: AOAM531IbwapOh0SSCQ/1kycGrQIzBGA0HXQ69zHESCiIKynBjj7f3hQ
        u5tP0HXZUccZUkXQuQC0L/3dlw==
X-Google-Smtp-Source: ABdhPJzfo2oPB457fWxv/FRl0ytj31GVMTNjfB58hqzRB9Zc1TPw+2J3WRF+a+hA0AXzUFSSRq9MXw==
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr13991903wmq.65.1618071411457;
        Sat, 10 Apr 2021 09:16:51 -0700 (PDT)
Received: from enceladus (ppp-94-65-225-75.home.otenet.gr. [94.65.225.75])
        by smtp.gmail.com with ESMTPSA id m26sm8126680wmg.17.2021.04.10.09.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 09:16:50 -0700 (PDT)
Date:   Sat, 10 Apr 2021 19:16:45 +0300
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
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/5] mm: add a signature in struct page
Message-ID: <YHHPbQm2pn2ysth0@enceladus>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com>
 <20210410154824.GZ2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410154824.GZ2531743@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew 

On Sat, Apr 10, 2021 at 04:48:24PM +0100, Matthew Wilcox wrote:
> On Sat, Apr 10, 2021 at 12:37:58AM +0200, Matteo Croce wrote:
> > This is needed by the page_pool to avoid recycling a page not allocated
> > via page_pool.
> 
> Is the PageType mechanism more appropriate to your needs?  It wouldn't
> be if you use page->_mapcount (ie mapping it to userspace).

Interesting!
Please keep in mind this was written ~2018 and was stale on my branches for
quite some time.  So back then I did try to use PageType, but had not free
bits.  Looking at it again though, it's cleaned up.  So yes I think this can
be much much cleaner.  Should we go and define a new PG_pagepool?


Thanks!
/Ilias
> 
> > Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> > ---
> >  include/linux/mm_types.h | 1 +
> >  include/net/page_pool.h  | 2 ++
> >  net/core/page_pool.c     | 4 ++++
> >  3 files changed, 7 insertions(+)
> > 
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 6613b26a8894..ef2d0d5f62e4 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -101,6 +101,7 @@ struct page {
> >  			 * 32-bit architectures.
> >  			 */
> >  			dma_addr_t dma_addr;
> > +			unsigned long signature;
> >  		};
> >  		struct {	/* slab, slob and slub */
> >  			union {
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index b5b195305346..b30405e84b5e 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -63,6 +63,8 @@
> >   */
> >  #define PP_ALLOC_CACHE_SIZE	128
> >  #define PP_ALLOC_CACHE_REFILL	64
> > +#define PP_SIGNATURE		0x20210303
> > +
> >  struct pp_alloc_cache {
> >  	u32 count;
> >  	void *cache[PP_ALLOC_CACHE_SIZE];
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index ad8b0707af04..2ae9b554ef98 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -232,6 +232,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> >  		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> >  
> >  skip_dma_map:
> > +	page->signature = PP_SIGNATURE;
> > +
> >  	/* Track how many pages are held 'in-flight' */
> >  	pool->pages_state_hold_cnt++;
> >  
> > @@ -302,6 +304,8 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
> >  			     DMA_ATTR_SKIP_CPU_SYNC);
> >  	page->dma_addr = 0;
> >  skip_dma_unmap:
> > +	page->signature = 0;
> > +
> >  	/* This may be the last page returned, releasing the pool, so
> >  	 * it is not safe to reference pool afterwards.
> >  	 */
> > -- 
> > 2.30.2
> > 
