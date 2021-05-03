Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87953711FE
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 09:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhECHbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 03:31:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37701 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231605AbhECHbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 03:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620027009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBqDie/EmaAjrhH4oH0oAYawtCNkHwB6gsCC/PU7Wy0=;
        b=h17cw6RMirD6TELLB8/khHMj2FroHQlRqxPG31TuoQexvb0Nv5jkj8tEOc9LqFQa9qOYZw
        gK0fr1dBcbb6wcMxKzhebkSfzK9fb5Pg65kPP1/FDzS5C7RvCDjc/wJ7prAmlZHhTAU7qc
        rJbbcIn+GU7H820PQhH1Y8HpXj7XuBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-EzkpyYkoNWyE-8nvZc86AQ-1; Mon, 03 May 2021 03:30:05 -0400
X-MC-Unique: EzkpyYkoNWyE-8nvZc86AQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D6FB800D62;
        Mon,  3 May 2021 07:29:59 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A36E70592;
        Mon,  3 May 2021 07:29:38 +0000 (UTC)
Date:   Mon, 3 May 2021 09:29:37 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, Yunsheng Lin <linyunsheng@huawei.com>,
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
        Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
Message-ID: <20210503092937.78a1eb05@carbon>
In-Reply-To: <CAC_iWj+wkjcGjwbVqEFXFyUi_zgn4-uYhQKKHKk84jkgo1sxRw@mail.gmail.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
        <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
        <YIsAIzecktXXBlxn@apalos.home>
        <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
        <YIwvI5/ygBvZG5sy@apalos.home>
        <CAC_iWj+wkjcGjwbVqEFXFyUi_zgn4-uYhQKKHKk84jkgo1sxRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Apr 2021 20:32:07 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> (-cc invalid emails)
> Replying to my self here but....
> 
> [...]
> > > >
> > > > We can't do that. The reason we need those structs is that we rely on the
> > > > existing XDP code, which already recycles it's buffers, to enable
> > > > recycling.  Since we allocate a page per packet when using page_pool for a
> > > > driver , the same ideas apply to an SKB and XDP frame. We just recycle the  
> > >
> > > I am not really familar with XDP here, but a packet from hw is either a
> > > "struct xdp_frame/xdp_buff" for XDP or a "struct sk_buff" for TCP/IP stack,
> > > a packet can not be both "struct xdp_frame/xdp_buff" and "struct sk_buff" at
> > > the same time, right?
> > >  
> >
> > Yes, but the payload is irrelevant in both cases and that's what we use
> > page_pool for.  You can't use this patchset unless your driver usues
> > build_skb().  So in both cases you just allocate memory for the payload and
> > decide what the wrap the buffer with (XDP or SKB) later.
> >  
> > > What does not really make sense to me is that the page has to be from page
> > > pool when a skb's frag page can be recycled, right? If it is ture, the switch
> > > case in __xdp_return() does not really make sense for skb recycling, why go
> > > all the trouble of checking the mem->type and mem->id to find the page_pool
> > > pointer when recyclable page for skb can only be from page pool?  
> >
> > In any case you need to find in which pool the buffer you try to recycle
> > belongs.  In order to make the whole idea generic and be able to recycle skb
> > fragments instead of just the skb head you need to store some information on
> > struct page.  That's the fundamental difference of this patchset compared to
> > the RFC we sent a few years back [1] which was just storing information on the
> > skb.  The way this is done on the current patchset is that we store the
> > struct xdp_mem_info in page->private and then look it up on xdp_return().
> >
> > Now that being said Matthew recently reworked struct page, so we could see if
> > we can store the page pool pointer directly instead of the struct
> > xdp_mem_info. That would allow us to call into page pool functions directly.
> > But we'll have to agree if that makes sense to go into struct page to begin
> > with and make sure the pointer is still valid when we take the recycling path.
> >  
> 
> Thinking more about it the reason that prevented us from storing a
> page pool pointer directly is not there anymore. Jesper fixed that
> already a while back. So we might as well store the page_pool ptr in
> page->private and call into the functions directly.  I'll have a look
> before v4.

I want to give credit to Jonathan Lemon whom came up with the idea of
storing the page_pool object that "owns" the page directly in struct
page.  I see this as an optimization that we can add later, so it
doesn't block this patchset.  As Ilias mention, it required some
work/changes[1]+[2] to guarantee that the page_pool object life-time
were longer than all the outstanding in-flight page-objects, but that
have been stable for some/many kernel releases now.  This is already
need/used for making sure the DMA-mappings can be safely released[1],
but I on-purpose enabled the same in-flight tracking for page_pool
users that doesn't use the DMA-mapping feature (making sure the code is
exercised).


[1] 99c07c43c4ea ("xdp: tracking page_pool resources and safe removal")
[2] c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

