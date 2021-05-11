Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93EE37A8F2
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 16:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhEKOUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 10:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKOUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 10:20:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB87C061574;
        Tue, 11 May 2021 07:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vXY92xiVcSCoihG0TT6zFgFAzGF0aHK+j0EPAjfDpt4=; b=GMAgJT78CAXSRvHzqCyBh72c44
        yKnOTdDeHdG8MpUntZdbv433uwQHd5/RqHWIbL6HmnYEwz3QL2KB8QuTc1gEegMHPB22ANVAU1B1f
        flJ5JdHESdxoJTK+gdCHe0f8B65Y7XohT+lruo0VVuHPIo5JYEp2Pz7mMNCu6O4573R1j9grt5KNM
        0wnFsoyIDcNw+1betYYDi7JkSvSq7pqnIWz66UzWFXWnQrk3QIs0x6I3vCh0XDFvi0IvCoan7dwyt
        fEYmYsFekF+oqKr+5rANQZlGBFzvFBpd1tWHNl0S5rqeaAgumymOuP4ixa6eYpfV15tjeLh7R2HWo
        Wo6RbevA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgTDP-007LsX-8r; Tue, 11 May 2021 14:18:38 +0000
Date:   Tue, 11 May 2021 15:18:27 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
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
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
Message-ID: <YJqSM79sOk1PRFPT@casper.infradead.org>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com>
 <YJqKfNh6l3yY2daM@casper.infradead.org>
 <YJqQgYSWH2qan1GS@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJqQgYSWH2qan1GS@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 05:11:13PM +0300, Ilias Apalodimas wrote:
> Hi Matthew,
> 
> On Tue, May 11, 2021 at 02:45:32PM +0100, Matthew Wilcox wrote:
> > On Tue, May 11, 2021 at 03:31:15PM +0200, Matteo Croce wrote:
> > > @@ -101,6 +101,7 @@ struct page {
> > >  			 * 32-bit architectures.
> > >  			 */
> > >  			unsigned long dma_addr[2];
> > > +			unsigned long signature;
> > >  		};
> > >  		struct {	/* slab, slob and slub */
> > >  			union {
> > 
> > No.  Signature now aliases with page->mapping, which is going to go
> > badly wrong for drivers which map this page into userspace.
> > 
> > I had this as:
> > 
> > +                       unsigned long pp_magic;
> > +                       unsigned long xmi;
> > +                       unsigned long _pp_mapping_pad;
> >                         unsigned long dma_addr[2];
> > 
> > and pp_magic needs to be set to something with bits 0&1 clear and
> > clearly isn't a pointer.  I went with POISON_POINTER_DELTA + 0x40.
> 
> Regardless to the changes required, there's another thing we'd like your
> opinion on.
> There was a change wrt to the previous patchset. We used to store the
> struct xdp_mem_info into page->private.  On the new version we store the
> page_pool ptr address in page->private (there's an explanation why on the
> mail thread, but the tl;dr is that we can get some more speed and keeping
> xdp_mem_info is not that crucial). So since we can just store the page_pool
> address directly, should we keep using page->private or it's better to
> do: 
> 
> +                       unsigned long pp_magic;
> +                       unsigned long pp_ptr;
> +                       unsigned long _pp_mapping_pad;
>                         unsigned long dma_addr[2];
> and use pp_ptr?

I'd rather you didn't use page_private ... Any reason not to use:

			unsigned long pp_magic;
			struct page_pool *pp;
			unsigned long _pp_mapping_pad;
			unsigned long dma_addr[2];

?
