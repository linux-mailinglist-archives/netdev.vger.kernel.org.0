Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2E837D064
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbhELReQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 13:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245222AbhELQwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 12:52:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1053FC08C5E2;
        Wed, 12 May 2021 09:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RLyFJOnJjfJNfSNCl5gvlLTZNd55peOaxfXJb9HMmN4=; b=XD9fuf5NVBptzlMagMcg3fxYnG
        qid6hR1wjdfENmD7YKGyjj5dFHHDkTWxjEiXYcLJUFo/s+CfKw2OLm7DvkxBIjETY/CnKNCP9DHW8
        S7buSfwX0Fg6wI65TnM+GZwyUur8AiWKNSdwppV7LD4CpmdxlN2tLNNtO49QE1fsRzuawWRNl5QAn
        RwF5dzinb4/J3QF9zhCgKRqdfGEnUQjuf2rbnlchAVVw+MrKq1gV0QYmqTmeQIZcxnv97eLolN0Ly
        a3+i54K3len2+vEJreo5MzvaxgCZvmeMegoWJAhKUgzr3PJIPmCC1mJfNz9yY9ez7ZP0rOFBntcEE
        Hq+ANgow==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgrga-008W2Y-Nw; Wed, 12 May 2021 16:26:25 +0000
Date:   Wed, 12 May 2021 17:26:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Dumazet <edumazet@google.com>
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
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
Message-ID: <YJwBpBOxaZac7uSx@casper.infradead.org>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com>
 <YJqKfNh6l3yY2daM@casper.infradead.org>
 <YJqQgYSWH2qan1GS@apalos.home>
 <YJqSM79sOk1PRFPT@casper.infradead.org>
 <CAC_iWj+Tw9DzzzVj-F9AwzBN_OJV_HN2miJT4KTBH_Uei_V2ZA@mail.gmail.com>
 <YJv65eER2qgaP9Ib@casper.infradead.org>
 <CANn89iJ7j4-rm+i58RMcB8Fahe6yEao7jhDUe_M9U6L67nZ1gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ7j4-rm+i58RMcB8Fahe6yEao7jhDUe_M9U6L67nZ1gA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 06:09:21PM +0200, Eric Dumazet wrote:
> On Wed, May 12, 2021 at 6:03 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, May 11, 2021 at 05:25:36PM +0300, Ilias Apalodimas wrote:
> > > Nope not at all, either would work. we'll switch to that
> >
> > You'll need something like this because of the current use of
> > page->index to mean "pfmemalloc".
> >
> > From ecd6d912056a21bbe55d997c01f96b0b8b9fbc31 Mon Sep 17 00:00:00 2001
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > Date: Fri, 16 Apr 2021 18:12:33 -0400
> > Subject: [PATCH] mm: Indicate pfmemalloc pages in compound_head
> >
> > The net page_pool wants to use a magic value to identify page pool pages.
> > The best place to put it is in the first word where it can be clearly a
> > non-pointer value.  That means shifting dma_addr up to alias with ->index,
> > which means we need to find another way to indicate page_is_pfmemalloc().
> > Since page_pool doesn't want to set its magic value on pages which are
> > pfmemalloc, we can use bit 1 of compound_head to indicate that the page
> > came from the memory reserves.
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  include/linux/mm.h       | 12 +++++++-----
> >  include/linux/mm_types.h |  7 +++----
> >  2 files changed, 10 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index bd21864449bf..4f9b2007efad 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1670,10 +1670,12 @@ struct address_space *page_mapping(struct page *page);
> >  static inline bool page_is_pfmemalloc(const struct page *page)
> >  {
> >         /*
> > -        * Page index cannot be this large so this must be
> > -        * a pfmemalloc page.
> > +        * This is not a tail page; compound_head of a head page is unused
> > +        * at return from the page allocator, and will be overwritten
> > +        * by callers who do not care whether the page came from the
> > +        * reserves.
> >          */
> > -       return page->index == -1UL;
> > +       return page->compound_head & 2;
> >  }
> >
> >  /*
> > @@ -1682,12 +1684,12 @@ static inline bool page_is_pfmemalloc(const struct page *page)
> >   */
> >  static inline void set_page_pfmemalloc(struct page *page)
> >  {
> > -       page->index = -1UL;
> > +       page->compound_head = 2;
> >  }
> >
> >  static inline void clear_page_pfmemalloc(struct page *page)
> >  {
> > -       page->index = 0;
> > +       page->compound_head = 0;
> >  }
> >
> >  /*
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 5aacc1c10a45..1352e278939b 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -96,10 +96,9 @@ struct page {
> >                         unsigned long private;
> >                 };
> >                 struct {        /* page_pool used by netstack */
> > -                       /**
> > -                        * @dma_addr: might require a 64-bit value on
> > -                        * 32-bit architectures.
> > -                        */
> > +                       unsigned long pp_magic;
> > +                       struct page_pool *pp;
> > +                       unsigned long _pp_mapping_pad;
> >                         unsigned long dma_addr[2];
> >                 };
> >                 struct {        /* slab, slob and slub */
> 
> This would break compound_head() ?

No, compound_head() only checks bit 0.  If bit 0 is clear, then this is
not a tail page.
