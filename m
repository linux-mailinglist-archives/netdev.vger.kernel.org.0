Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA435B021
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhDJTkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 15:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJTkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 15:40:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDF1C06138A;
        Sat, 10 Apr 2021 12:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=99tw4rU1bA7MagbzMJxSzuFi8jXoglqEVx3rS3aCE60=; b=UGDCSJOiJywTxRKlV+QWUUkYP7
        kHAPe+brHhCRWvTl8X0RQzmmsptTNBASWc4j9OilorC2V0moXMOenrd66GalMZDuksOyQBFG7sFY1
        1jLeCodMt4E0psSQ7+VC0cCIB4Xzgu2R8jxbO4PUlnN76xoO30oeD5CgPk5fzBEQzyihDvOiN26Lo
        12Pdio68QTCIU89I+zOINcuLobkzYiXQTdLKdO5+/R9uyi2j0Xk93sPyWtmnr6bYL3LR3yx7oY7/H
        d9DYi1uymvbbmI2fSLCtHv4aPx2dEN7oqaKQBU/Sg9s6Z+Az2JgzxmDEIeClT51aqbma6dXWGBGn5
        RICJ642g==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVJSV-0023YN-DW; Sat, 10 Apr 2021 19:40:02 +0000
Date:   Sat, 10 Apr 2021 20:39:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
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
Message-ID: <20210410193955.GA2531743@casper.infradead.org>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com>
 <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus>
 <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHHuE7g73mZNrMV4@enceladus>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 09:27:31PM +0300, Ilias Apalodimas wrote:
> > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > can not be used.
> 
> Yes it can, since it's going to be used as your default allocator for
> payloads, which might end up on an SKB.
> So we have to keep the extra added field on struct page for our mark.
> Matthew had an intersting idea.  He suggested keeping it, but changing the 
> magic number, so it can't be a kernel address, but I'll let him follow 
> up on the details.

Sure!  So, given the misalignment problem I discovered yesterday [1],
we probably want a page_pool page to look like:

unsigned long	flags;
unsigned long	pp_magic;
unsigned long	xmi;
unsigned long	_pp_mapping_pad;
dma_addr_t	dma_addr;	/* might be one or two words */

The only real restriction here is that pp_magic should not be a valid
pointer, and it must have the bottom bit clear.  I'd recommend something
like:

#define PP_MAGIC	(0x20 + POISON_POINTER_DELTA)

This leaves page->mapping as NULL, so you don't have to worry about
clearing it before free.

[1] https://lore.kernel.org/linux-mm/20210410024313.GX2531743@casper.infradead.org/

