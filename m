Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E2739C090
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFDToR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhFDToQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 15:44:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D2EC061766;
        Fri,  4 Jun 2021 12:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bb1jA4KJJMvI5FjBqhzon96/oQku4pcdDpeVipG1x4o=; b=BowMt2rxf6wlCAcaDzFLvRL9vk
        lu/SlDa8a1E1AUMg39AIg/J6ubklu/VeSWYyra362BJmNu884vvuCzBXgUYLrv6641nMHd9vp/ZuB
        VgBnT5f4fO9e/LAeEd56w3Os8gbADQ/cJTfPYMXQKTchbkAkOhcDhkykbz99W+EixtD4KR1F5tYW6
        3pt6yFc7hZRKPaho4ImmTq6eUTYbAgVr8oJJ6kwfQgkjMtSPhmKf/OWIV3oYdEAmvMVeV3zladMIB
        V4fka3/qThGS3JCHKyhezmeapa2+QMq52cUIP2WIvCBXZTCInAsqQJ5z2h4HkuPMVolnOyyUCH+CY
        H7vFInew==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lpFhY-00DWac-2k; Fri, 04 Jun 2021 19:42:02 +0000
Date:   Fri, 4 Jun 2021 20:41:52 +0100
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
Message-ID: <YLqCAEVG+aLNGlIi@casper.infradead.org>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-4-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604183349.30040-4-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 08:33:47PM +0200, Matteo Croce wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 7fcfea7e7b21..057b40ad29bd 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -40,6 +40,9 @@
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #endif
> +#ifdef CONFIG_PAGE_POOL
> +#include <net/page_pool.h>
> +#endif

I'm not a huge fan of conditional includes ... any reason to not include
it always?

> @@ -3088,7 +3095,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
>   */
>  static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>  {
> -	put_page(skb_frag_page(frag));
> +	struct page *page = skb_frag_page(frag);
> +
> +#ifdef CONFIG_PAGE_POOL
> +	if (recycle && page_pool_return_skb_page(page_address(page)))
> +		return;

It feels weird to have a page here, convert it back to an address,
then convert it back to a head page in page_pool_return_skb_page().
How about passing 'page' here, calling compound_head() in
page_pool_return_skb_page() and calling virt_to_page() in skb_free_head()?

> @@ -251,4 +253,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
>  		spin_unlock_bh(&pool->ring.producer_lock);
>  }
>  
> +/* Store mem_info on struct page and use it while recycling skb frags */
> +static inline
> +void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> +{
> +	page->pp = pp;

I'm not sure this wrapper needs to exist.

> +}
> +
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e1321bc9d316..a03f48f45696 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -628,3 +628,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  	}
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
> +
> +bool page_pool_return_skb_page(void *data)
> +{
> +	struct page_pool *pp;
> +	struct page *page;
> +
> +	page = virt_to_head_page(data);
> +	if (unlikely(page->pp_magic != PP_SIGNATURE))
> +		return false;
> +
> +	pp = (struct page_pool *)page->pp;

You don't need the cast any more.

> +	/* Driver set this to memory recycling info. Reset it on recycle.
> +	 * This will *not* work for NIC using a split-page memory model.
> +	 * The page will be returned to the pool here regardless of the
> +	 * 'flipped' fragment being in use or not.
> +	 */
> +	page->pp = NULL;
> +	page_pool_put_full_page(pp, page, false);
> +
> +	return true;
> +}
> +EXPORT_SYMBOL(page_pool_return_skb_page);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 12b7e90dd2b5..f769f08e7b32 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -70,6 +70,9 @@
>  #include <net/xfrm.h>
>  #include <net/mpls.h>
>  #include <net/mptcp.h>
> +#ifdef CONFIG_PAGE_POOL
> +#include <net/page_pool.h>
> +#endif
>  
>  #include <linux/uaccess.h>
>  #include <trace/events/skb.h>
> @@ -645,10 +648,15 @@ static void skb_free_head(struct sk_buff *skb)
>  {
>  	unsigned char *head = skb->head;
>  
> -	if (skb->head_frag)
> +	if (skb->head_frag) {
> +#ifdef CONFIG_PAGE_POOL
> +		if (skb->pp_recycle && page_pool_return_skb_page(head))
> +			return;
> +#endif

put this in a header file:

static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
{
	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
		return false;
	return page_pool_return_skb_page(virt_to_page(data));
}

then this becomes:

	if (skb->head_frag) {
		if (skb_pp_recycle(skb, head))
			return;
>  		skb_free_frag(head);
> -	else
> +	} else {
>  		kfree(head);
> +	}
>  }
>  
>  static void skb_release_data(struct sk_buff *skb)
