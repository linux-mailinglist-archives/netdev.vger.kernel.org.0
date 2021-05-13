Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2D137F134
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 04:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhEMCQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 22:16:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2305 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhEMCQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 22:16:42 -0400
Received: from dggeml718-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FgZrx48RSz19PSm;
        Thu, 13 May 2021 10:11:13 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml718-chm.china.huawei.com (10.3.17.129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 13 May 2021 10:15:27 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 13 May
 2021 10:15:27 +0800
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
To:     Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Matteo Croce <mcroce@linux.microsoft.com>,
        Networking <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        "Rohit Maheshwari" <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
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
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com>
 <YJqKfNh6l3yY2daM@casper.infradead.org> <YJqQgYSWH2qan1GS@apalos.home>
 <YJqSM79sOk1PRFPT@casper.infradead.org>
 <CAC_iWj+Tw9DzzzVj-F9AwzBN_OJV_HN2miJT4KTBH_Uei_V2ZA@mail.gmail.com>
 <YJv65eER2qgaP9Ib@casper.infradead.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3f9a0fb0-9cb9-686d-e89b-ea589d88ab58@huawei.com>
Date:   Thu, 13 May 2021 10:15:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YJv65eER2qgaP9Ib@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/12 23:57, Matthew Wilcox wrote:
> On Tue, May 11, 2021 at 05:25:36PM +0300, Ilias Apalodimas wrote:
>> Nope not at all, either would work. we'll switch to that
> 
> You'll need something like this because of the current use of
> page->index to mean "pfmemalloc".
> 
>>From ecd6d912056a21bbe55d997c01f96b0b8b9fbc31 Mon Sep 17 00:00:00 2001
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Fri, 16 Apr 2021 18:12:33 -0400
> Subject: [PATCH] mm: Indicate pfmemalloc pages in compound_head
> 
> The net page_pool wants to use a magic value to identify page pool pages.
> The best place to put it is in the first word where it can be clearly a
> non-pointer value.  That means shifting dma_addr up to alias with ->index,
> which means we need to find another way to indicate page_is_pfmemalloc().
> Since page_pool doesn't want to set its magic value on pages which are
> pfmemalloc, we can use bit 1 of compound_head to indicate that the page
> came from the memory reserves.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h       | 12 +++++++-----
>  include/linux/mm_types.h |  7 +++----
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bd21864449bf..4f9b2007efad 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1670,10 +1670,12 @@ struct address_space *page_mapping(struct page *page);
>  static inline bool page_is_pfmemalloc(const struct page *page)
>  {
>  	/*
> -	 * Page index cannot be this large so this must be
> -	 * a pfmemalloc page.
> +	 * This is not a tail page; compound_head of a head page is unused
> +	 * at return from the page allocator, and will be overwritten
> +	 * by callers who do not care whether the page came from the
> +	 * reserves.
>  	 */
> -	return page->index == -1UL;
> +	return page->compound_head & 2;
>  }
>  
>  /*
> @@ -1682,12 +1684,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
>   */
>  static inline void set_page_pfmemalloc(struct page *page)
>  {
> -	page->index = -1UL;
> +	page->compound_head = 2;

Is there any reason why not use "page->compound_head |= 2"? as
corresponding to the "page->compound_head & 2" in the above
page_is_pfmemalloc()?

Also, this may mean we need to make sure to pass head page or
base page to set_page_pfmemalloc() if using
"page->compound_head = 2", because it clears the bit 0 and head
page ptr for tail page too, right?

>  }
>  
>  static inline void clear_page_pfmemalloc(struct page *page)
>  {
> -	page->index = 0;
> +	page->compound_head = 0;
>  }
>  
>  /*
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 5aacc1c10a45..1352e278939b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -96,10 +96,9 @@ struct page {
>  			unsigned long private;
>  		};
>  		struct {	/* page_pool used by netstack */
> -			/**
> -			 * @dma_addr: might require a 64-bit value on
> -			 * 32-bit architectures.
> -			 */
> +			unsigned long pp_magic;
> +			struct page_pool *pp;
> +			unsigned long _pp_mapping_pad;
>  			unsigned long dma_addr[2];

It seems the dma_addr[1] aliases with page->private, and
page_private() is used in skb_copy_ubufs()?

It seems we can avoid using page_private() in skb_copy_ubufs()
by using a dynamic allocated array to store the page ptr?

>  		};
>  		struct {	/* slab, slob and slub */
> 

