Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE9635B2F3
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 12:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbhDKKGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 06:06:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235366AbhDKKGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 06:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618135544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MhHr3Cd5ZDKM5bg6lUgtgpxP7s+VM/Oo10g+H6b6Os0=;
        b=O3Cr/gdGeDiQfLv6B6+jNHs7SFsa24+tbtXJLFL/VMXCVnDbyDStUUXL0JQBR0JWJCgyts
        4Mnor+U0VS1Xb2SlMyrcHDlEC1xKRfBWKzb/J7Xgm7qoidUSJ2clm0jYqdfHK6OuZ2h5IE
        EgG4QhZz3g+/q+kXfJSGbDijOG4Habo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-iUqQIEx5NBa4mkSJa5bIWw-1; Sun, 11 Apr 2021 06:05:42 -0400
X-MC-Unique: iUqQIEx5NBa4mkSJa5bIWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4135610053EA;
        Sun, 11 Apr 2021 10:05:41 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 957FD14106;
        Sun, 11 Apr 2021 10:05:18 +0000 (UTC)
Date:   Sun, 11 Apr 2021 12:05:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Shakeel Butt <shakeelb@google.com>,
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
Message-ID: <20210411120500.73c1cadb@carbon>
In-Reply-To: <20210410193955.GA2531743@casper.infradead.org>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
        <20210409223801.104657-3-mcroce@linux.microsoft.com>
        <20210410154824.GZ2531743@casper.infradead.org>
        <YHHPbQm2pn2ysth0@enceladus>
        <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
        <YHHuE7g73mZNrMV4@enceladus>
        <20210410193955.GA2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Apr 2021 20:39:55 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Sat, Apr 10, 2021 at 09:27:31PM +0300, Ilias Apalodimas wrote:
> > > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > > can not be used.  
> > 
> > Yes it can, since it's going to be used as your default allocator for
> > payloads, which might end up on an SKB.
> > So we have to keep the extra added field on struct page for our mark.
> > Matthew had an intersting idea.  He suggested keeping it, but changing the 
> > magic number, so it can't be a kernel address, but I'll let him follow 
> > up on the details.  
> 
> Sure!  So, given the misalignment problem I discovered yesterday [1],
> we probably want a page_pool page to look like:
> 
> unsigned long	flags;
> unsigned long	pp_magic;
> unsigned long	xmi;
> unsigned long	_pp_mapping_pad;
> dma_addr_t	dma_addr;	/* might be one or two words */
> 
> The only real restriction here is that pp_magic should not be a valid
> pointer, and it must have the bottom bit clear.  I'd recommend something
> like:
> 
> #define PP_MAGIC	(0x20 + POISON_POINTER_DELTA)
> 
> This leaves page->mapping as NULL, so you don't have to worry about
> clearing it before free.
>
> [1] https://lore.kernel.org/linux-mm/20210410024313.GX2531743@casper.infradead.org/

I didn't see this, before asking[2] for explaining your intent.
I still worry about page->index, see [2].

[2] https://lore.kernel.org/netdev/20210411114307.5087f958@carbon/

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

