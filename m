Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95E637F166
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 04:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhEMCir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 22:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhEMCio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 22:38:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C14C061574;
        Wed, 12 May 2021 19:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TenrWiIkYtVAh+YSG9ppJcEvQ+ICO0xNa6eESJHAhgA=; b=oY3n65PbfkVv41I70t6lqq9DW7
        Nc49YFeX1YsxjnKc0EHtgpu4GUOsOwCB4Bh/AhPUTFuUZe5ZZ23q++8CBxNxQ/SJwzyxVqsccpHxl
        Vss0GOdtaPNnC5HQvhuiBrMv/ZyXU1Cn1UCgS1RqKmE4JumRPEArf0t8OfD01+5KetSMt25D9C6So
        gkURYhk+BRL3RNHclDOJbCSiqhC6yp82vfs6onbn8EfZFgPcmpcpSnwSUPKfKZkQvS54ISzuWSkvP
        2nyFXSKgI+RE0q+lu9vHxXIzurzEOYVFSDhGIWg/1Ld4oWEChi48USDfO7D135gwPtJNdpOAO4tTK
        O1V2RKqg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lh1Bw-0097Bt-GN; Thu, 13 May 2021 02:35:24 +0000
Date:   Thu, 13 May 2021 03:35:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Networking <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
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
        linux-rdma@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
Message-ID: <YJyQYCj3UUk5Sp4Z@casper.infradead.org>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com>
 <YJqKfNh6l3yY2daM@casper.infradead.org>
 <YJqQgYSWH2qan1GS@apalos.home>
 <YJqSM79sOk1PRFPT@casper.infradead.org>
 <CAC_iWj+Tw9DzzzVj-F9AwzBN_OJV_HN2miJT4KTBH_Uei_V2ZA@mail.gmail.com>
 <YJv65eER2qgaP9Ib@casper.infradead.org>
 <3f9a0fb0-9cb9-686d-e89b-ea589d88ab58@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a0fb0-9cb9-686d-e89b-ea589d88ab58@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 10:15:26AM +0800, Yunsheng Lin wrote:
> On 2021/5/12 23:57, Matthew Wilcox wrote:
> > You'll need something like this because of the current use of
> > page->index to mean "pfmemalloc".
> >
> > @@ -1682,12 +1684,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
> >   */
> >  static inline void set_page_pfmemalloc(struct page *page)
> >  {
> > -	page->index = -1UL;
> > +	page->compound_head = 2;
> 
> Is there any reason why not use "page->compound_head |= 2"? as
> corresponding to the "page->compound_head & 2" in the above
> page_is_pfmemalloc()?
> 
> Also, this may mean we need to make sure to pass head page or
> base page to set_page_pfmemalloc() if using
> "page->compound_head = 2", because it clears the bit 0 and head
> page ptr for tail page too, right?

I think what you're missing here is that this page is freshly allocated.
This is information being passed from the page allocator to any user
who cares to look at it.  By definition, it's set on the head/base page, and
there is nothing else present in the page->compound_head.  Doing an OR
is more expensive than just setting it to 2.

I'm not really sure why set/clear page_pfmemalloc are defined in mm.h.
They should probably be in mm/page_alloc.c where nobody else would ever
think that they could or should be calling them.

> >  		struct {	/* page_pool used by netstack */
> > -			/**
> > -			 * @dma_addr: might require a 64-bit value on
> > -			 * 32-bit architectures.
> > -			 */
> > +			unsigned long pp_magic;
> > +			struct page_pool *pp;
> > +			unsigned long _pp_mapping_pad;
> >  			unsigned long dma_addr[2];
> 
> It seems the dma_addr[1] aliases with page->private, and
> page_private() is used in skb_copy_ubufs()?
> 
> It seems we can avoid using page_private() in skb_copy_ubufs()
> by using a dynamic allocated array to store the page ptr?

This is why I hate it when people use page_private() instead of
documenting what they're doing in struct page.  There is no way to know
(as an outsider to networking) whether the page in skb_copy_ubufs()
comes from page_pool.  I looked at it, and thought it didn't:

                page = alloc_page(gfp_mask);

but if you say those pages can come from page_pool, I believe you.
