Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA89839C90F
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 16:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhFEOe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 10:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhFEOe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 10:34:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45187C061766;
        Sat,  5 Jun 2021 07:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ysSoi5gpx3YeFtFoqCR9odJnpVrSzapVJNhGgAq3Zo=; b=Zh95QZ+oAmIGkHWHQAEFl6vDTO
        GmvBEgb4eLNge3M/1YZWLQSUlr3gr6cZIATaXD6kJjhc0l9JRxx+XGMlKyGnYHX7XdUbOmZ+0bQxM
        xnfQFPtWmEkTjgNAOXyn43QONLJt6HaOnASbfUu/UIQTsHNpDR4jaQTOHi+RR3kr8vbfVUmf2ptSh
        bVmZJOnROEtX7cZlHgNDUk07U9pA40FzDKCXEOXn3pDIHzqz9+9xSTGc0NoHcRLgIrRKh0JHVCOiD
        idtvZvVVbSllHCR8Mx+3Pdtug5xMAXlRJIJiDHozuLGZZlf4gFMz5ziEFQKnxHZsE8twc0ZRTl1S5
        1Itzs3yQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lpXLY-00E9xR-Ev; Sat, 05 Jun 2021 14:32:21 +0000
Date:   Sat, 5 Jun 2021 15:32:20 +0100
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
Message-ID: <YLuK9P+loeKwUUK3@casper.infradead.org>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-2-mcroce@linux.microsoft.com>
 <YLp6D7mEh85vL+pY@casper.infradead.org>
 <CAFnufp2jGRsr9jexBLFRZfJu9AwGO0ghzExT1R4bJdscwHqSnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFnufp2jGRsr9jexBLFRZfJu9AwGO0ghzExT1R4bJdscwHqSnQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 12:59:50AM +0200, Matteo Croce wrote:
> On Fri, Jun 4, 2021 at 9:08 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Jun 04, 2021 at 08:33:45PM +0200, Matteo Croce wrote:
> > > @@ -130,7 +137,10 @@ struct page {
> > >                       };
> > >               };
> > >               struct {        /* Tail pages of compound page */
> > > -                     unsigned long compound_head;    /* Bit zero is set */
> > > +                     /* Bit zero is set
> > > +                      * Bit one if pfmemalloc page
> > > +                      */
> > > +                     unsigned long compound_head;
> >
> > I would drop this hunk.  Bit 1 is not used for this purpose in tail
> > pages; it's used for that purpose in head and base pages.
> >
> > I suppose we could do something like ...
> >
> >  static inline void set_page_pfmemalloc(struct page *page)
> >  {
> > -       page->index = -1UL;
> > +       page->lru.next = (void *)2;
> >  }
> >
> > if it's causing confusion.
> >
> 
> If you prefer, ok for me.
> Why not "(void *)BIT(1)"? Just to remark that it's a single bit and
> not a magic like value?

I don't have a strong preference.  I'd use '2', but I wouldn't ask
BIT(1) to be changed.
