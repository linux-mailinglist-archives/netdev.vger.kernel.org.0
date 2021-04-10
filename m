Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8791535AEE9
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 17:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhDJPtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 11:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhDJPtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 11:49:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4D0C06138A;
        Sat, 10 Apr 2021 08:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=91B1rcP8cMJQqrbDXcQN0ARnzQOA1OqZMuSrhvn5KWM=; b=evTQPZqIi5C2RLsOo/Cnp8EvmB
        +uevWJugbBaSvzGC1a3HmfgpppZ6H1ka7pXORdatOgeVE3x3oXAbAseMJAUFRD7T4ieZ5i7iiKhlp
        s13tFWfw/Cw0h1OKIkHOpy0hV022PAiVzvvtxFLai9MMVguPFdLDq4j90+T/YAth83dSLczxTeuNW
        2WU9FO6QmMXdyNeytzYOZHDNDUKGMJaWbvPFUxIgPtJXRTCKU1gjDOL5ajONo2fvEa5FSsVZ0rf/K
        M0ZWL1F0jSmahwlmebzn8v0M9ft1X/XAyYHxO5+HYitLqCGcQCzcmbfBB0K9PsGLHRcbZ62eFStHJ
        5u/3GzcQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVFqS-001rFg-3o; Sat, 10 Apr 2021 15:48:28 +0000
Date:   Sat, 10 Apr 2021 16:48:24 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
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
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
Message-ID: <20210410154824.GZ2531743@casper.infradead.org>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409223801.104657-3-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 12:37:58AM +0200, Matteo Croce wrote:
> This is needed by the page_pool to avoid recycling a page not allocated
> via page_pool.

Is the PageType mechanism more appropriate to your needs?  It wouldn't
be if you use page->_mapcount (ie mapping it to userspace).

> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  include/linux/mm_types.h | 1 +
>  include/net/page_pool.h  | 2 ++
>  net/core/page_pool.c     | 4 ++++
>  3 files changed, 7 insertions(+)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6613b26a8894..ef2d0d5f62e4 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -101,6 +101,7 @@ struct page {
>  			 * 32-bit architectures.
>  			 */
>  			dma_addr_t dma_addr;
> +			unsigned long signature;
>  		};
>  		struct {	/* slab, slob and slub */
>  			union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index b5b195305346..b30405e84b5e 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -63,6 +63,8 @@
>   */
>  #define PP_ALLOC_CACHE_SIZE	128
>  #define PP_ALLOC_CACHE_REFILL	64
> +#define PP_SIGNATURE		0x20210303
> +
>  struct pp_alloc_cache {
>  	u32 count;
>  	void *cache[PP_ALLOC_CACHE_SIZE];
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ad8b0707af04..2ae9b554ef98 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -232,6 +232,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
>  
>  skip_dma_map:
> +	page->signature = PP_SIGNATURE;
> +
>  	/* Track how many pages are held 'in-flight' */
>  	pool->pages_state_hold_cnt++;
>  
> @@ -302,6 +304,8 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>  			     DMA_ATTR_SKIP_CPU_SYNC);
>  	page->dma_addr = 0;
>  skip_dma_unmap:
> +	page->signature = 0;
> +
>  	/* This may be the last page returned, releasing the pool, so
>  	 * it is not safe to reference pool afterwards.
>  	 */
> -- 
> 2.30.2
> 
