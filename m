Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFF836424F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbhDSNEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbhDSNEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:04:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E76FC061760;
        Mon, 19 Apr 2021 06:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8Y0pwAVt5liDDolwhxFKvBOLg1az19k+Kyl8s6P7Mkw=; b=qh+osCLCYoBzdKk4OeJfdc7J9J
        shl+bJI6rxfcBQSyUHfvACIIxpBednLK2EubX+7seel0bFOvQcQK+jZoQeITc+v2PI2mb2vCfurG4
        Iz1Jx+evxKF0mxbN3hGOTdmKkw/Big46+gSRFjS7Bcm1zy1oyWgzxp5sakrTLJBWnvbYovFe8a2Tj
        6drEwpV5y+w6FDXtd5amPm+3usP0JSTm7fxq2CdQjbgRmW6fOEF7HDFoUma/fp6LsDiBYcgbUg3lU
        xOWtgX+S7Y2kwtviMj2NHv0xDQhr/xFfW5udlCZV7yiQvRTBIOJ4bdLWiNP47NQMfxvezra9yhVN1
        F7lE216g==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYTXA-00DlIj-GW; Mon, 19 Apr 2021 13:02:10 +0000
Date:   Mon, 19 Apr 2021 14:01:48 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
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
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/5] mm: add a signature in struct page
Message-ID: <20210419130148.GA2531743@casper.infradead.org>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com>
 <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus>
 <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus>
 <20210414214132.74f721dd@carbon>
 <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
 <20210419132204.1e07d5b9@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419132204.1e07d5b9@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 01:22:04PM +0200, Jesper Dangaard Brouer wrote:
> On Wed, 14 Apr 2021 13:09:47 -0700
> Shakeel Butt <shakeelb@google.com> wrote:
> 
> > On Wed, Apr 14, 2021 at 12:42 PM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >  
> > [...]
> > > > >
> > > > > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > > > > can not be used.  
> > > >
> > > > Yes it can, since it's going to be used as your default allocator for
> > > > payloads, which might end up on an SKB.  
> > >
> > > I'm not sure we want or should "allow" page_pool be used for TCP RX
> > > zerocopy.
> > > For several reasons.
> > >
> > > (1) This implies mapping these pages page to userspace, which AFAIK
> > > means using page->mapping and page->index members (right?).
> > >  
> > 
> > No, only page->_mapcount is used.
> 
> Good to know.
> I will admit that I don't fully understand the usage of page->mapping
> and page->index members.

That's fair.  It's not well-documented, and it's complicated.

For a page mapped into userspace, page->mapping is one of:
 - NULL
 - A pointer to a file's address_space
 - A pointer to an anonymous page's anon_vma
If a page isn't mapped into userspace, you can use the space in page->mapping
for anything you like (eg slab uses it)

page->index is only used for indicating pfmemalloc today (and I want to
move that indicator).  I think it can also be used to merge VMAs (if
some other conditions are also true), but failing to merge VMAs isn't
a big deal for this kind of situation.

> > > (2) It feels wrong (security wise) to keep the DMA-mapping (for the
> > > device) and also map this page into userspace.
> > 
> > I think this is already the case i.e pages still DMA-mapped and also
> > mapped into userspace.
> 
> True, other drivers are doing the same.

And the contents of this page already came from that device ... if it
wanted to write bad data, it could already have done so.

> > > (3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
> > > zerocopy will bump the refcnt, which means the page_pool will not
> > > recycle the page when it see the elevated refcnt (it will instead
> > > release its DMA-mapping).  
> > 
> > Yes this is right but the userspace might have already consumed and
> > unmapped the page before the driver considers to recycle the page.
> 
> That is a good point.  So, there is a race window where it is possible
> to gain recycling.
> 
> It seems my page_pool co-maintainer Ilias is interested in taking up the
> challenge to get this working with TCP RX zerocopy.  So, lets see how
> this is doable.

You could also check page_ref_count() - page_mapcount() instead of
just checking page_ref_count().  Assuming mapping/unmapping can't
race with recycling?

