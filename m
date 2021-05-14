Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CF3380163
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 03:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhENBCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 21:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhENBCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 21:02:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E594C061574;
        Thu, 13 May 2021 18:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AewoeCdKzupjrAmmf0ZaCNC8yUlU7sjr3AelIO0F/XM=; b=aeMzHZzq2PEe+UoOqIrdKwzBHp
        SpD13pChgGsdAlUV5up3rlgtz61ceBqKB4YVlPxrnpfIlr7qixm35r1pzxJdKP5QLSEv8lpn96D0y
        XzkuZ5dWtc2OwZ5MLmRA63ZiRfVsiuzDjvNofa4ETRslxO8M2Jiy0ABimf/OQBBIBKNe6+XoAKHKm
        jnu6IBehlAN86e5u5i1YiDGMdh6HbEFpXvmqZfg0uWWZ0RgIYELAbrImjCvmT3Mj3MNXddpgvVD4Q
        wk2S0O02ZQlAvoJJaMqZAfsaJd5UMN1xmGhYemsBXOmYPilm+wJEFjNiGZw6xjlSivEfoga3pOTMt
        bF+rEfzQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lhMBp-009wQq-20; Fri, 14 May 2021 01:00:50 +0000
Date:   Fri, 14 May 2021 02:00:29 +0100
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
Subject: Re: [PATCH net-next v5 1/5] mm: add a signature in struct page
Message-ID: <YJ3Lrdx1oIm/MDV8@casper.infradead.org>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-2-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513165846.23722-2-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 06:58:42PM +0200, Matteo Croce wrote:
>  		struct {	/* page_pool used by netstack */
> +			/**
> +			 * @pp_magic: magic value to avoid recycling non
> +			 * page_pool allocated pages.
> +			 * It aliases with page->lru.next

I'm not really keen on documenting what aliases with what.
pp_magic also aliases with compound_head, 'next' (for slab),
and dev_pagemap.  This is an O(n^2) documentation problem ...

I feel like I want to document the pfmemalloc bit in mm_types.h,
but I don't have a concrete suggestion yet.

> +++ b/include/net/page_pool.h
> @@ -63,6 +63,8 @@
>   */
>  #define PP_ALLOC_CACHE_SIZE	128
>  #define PP_ALLOC_CACHE_REFILL	64
> +#define PP_SIGNATURE		(POISON_POINTER_DELTA + 0x40)

I wonder if this wouldn't be better in linux/poison.h?

