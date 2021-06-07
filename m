Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE339DE19
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFGNyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGNyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:54:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684E1C061766;
        Mon,  7 Jun 2021 06:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UxlTIzPnHvNXvpvNY8WXGYTkZQTDM1BOIfqbe2VK5Js=; b=CetJfXmyZyFXZxc0ZDB2x+X1sn
        BndDqR/iA2xddJOq735dsFYR6NNIW4H0oZtDRH3Lvl65DkNtV48y2wYQJxi00epZy1226mMZqo9+8
        uTuSnoaPfw/xJxIA+t6dKmij2+saw0Z85Fkr6z7cpchvBSenrOhKDTuuEdahF+h7C/Y0T7DM3KvU5
        piiz78iI7X5BnRk74yOD51w4gIb6aBSfiDmsriaMGUYvwsp4cUQvZiw2Kiz9j5lQ0ENS2QGB+xq7q
        2tNboIvbRKReTQHf5DeLpsFLpHKAvQx97M6YLSCEZbr8rCv8yE1nh9lkAQZPDGqlnTmweOrHE13Fy
        /L/uNugw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqFgE-00FrLN-9D; Mon, 07 Jun 2021 13:52:40 +0000
Date:   Mon, 7 Jun 2021 14:52:38 +0100
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
Subject: Re: [PATCH net-next v7 1/5] mm: add a signature in struct page
Message-ID: <YL4kpntfzMBXGSfV@casper.infradead.org>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-2-mcroce@linux.microsoft.com>
 <YLp6D7mEh85vL+pY@casper.infradead.org>
 <CAFnufp2jGRsr9jexBLFRZfJu9AwGO0ghzExT1R4bJdscwHqSnQ@mail.gmail.com>
 <YLuK9P+loeKwUUK3@casper.infradead.org>
 <CAFnufp1e893Yz+KTjDvX4tyA8ngqmnMVudf1v0cBPdi9d_2zLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFnufp1e893Yz+KTjDvX4tyA8ngqmnMVudf1v0cBPdi9d_2zLw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 03:50:54AM +0200, Matteo Croce wrote:
> And change all the *_pfmemalloc functions to use page->lru.next like this?
> 
> @@ -1668,10 +1668,12 @@ struct address_space *page_mapping(struct page *page);
> static inline bool page_is_pfmemalloc(const struct page *page)
> {
>        /*
> -        * Page index cannot be this large so this must be
> -        * a pfmemalloc page.
> +        * This is not a tail page; compound_head of a head page is unused
> +        * at return from the page allocator, and will be overwritten
> +        * by callers who do not care whether the page came from the
> +        * reserves.
>         */

The comment doesn't make a lot of sense if we're switching to use
lru.next.  How about:

	/*
	 * lru.next has bit 1 set if the page is allocated from the
	 * pfmemalloc reserves.  Callers may simply overwrite it if
	 * they do not need to preserve that information.
	 */
