Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821E437637C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 12:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhEGKVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 06:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhEGKVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 06:21:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620382823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lIcQ3aWusFoyx+p+lHe/DqMeu83D/lp8hQ/FOvNZ4aQ=;
        b=hEPEL2bkb8h6kacuVeNWRW7J1V+By6LM+wTRSXVoJ45vpkEe8Wiz63ce7hsxLjJD4MPWbb
        ntSgUqUjTRWxyXng+AS5S7FfEFgg97tUljK92Ot1GtSoBMlBaunkDLd0nG15/XW1qFzLqC
        /2rY7Wqpr4A80KBaRu6aQcvApk2f/+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-scTlaJCDMwSh3AUfzNwXGw-1; Fri, 07 May 2021 06:20:19 -0400
X-MC-Unique: scTlaJCDMwSh3AUfzNwXGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB9C61800D50;
        Fri,  7 May 2021 10:20:18 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C736687C2;
        Fri,  7 May 2021 10:19:55 +0000 (UTC)
Date:   Fri, 7 May 2021 12:19:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "Vinay Kumar Yadav" <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
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
        Guillaume Nault <gnault@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <bpf@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
Message-ID: <20210507121953.59e22aa8@carbon>
In-Reply-To: <bdd97ac5-f932-beec-109e-ace9cd62f661@huawei.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
        <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
        <YIsAIzecktXXBlxn@apalos.home>
        <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
        <YIwvI5/ygBvZG5sy@apalos.home>
        <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
        <YJPn5t2mdZKC//dp@apalos.home>
        <75a332fa-74e4-7b7b-553e-3a1a6cb85dff@huawei.com>
        <YJTm4uhvqCy2lJH8@apalos.home>
        <bdd97ac5-f932-beec-109e-ace9cd62f661@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 May 2021 16:28:30 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> On 2021/5/7 15:06, Ilias Apalodimas wrote:
> > On Fri, May 07, 2021 at 11:23:28AM +0800, Yunsheng Lin wrote:  
> >> On 2021/5/6 20:58, Ilias Apalodimas wrote:  
> >>>>>>  
> >>>>>
> >>>>> Not really, the opposite is happening here. If the pp_recycle bit is set we
> >>>>> will always call page_pool_return_skb_page().  If the page signature matches
> >>>>> the 'magic' set by page pool we will always call xdp_return_skb_frame() will
> >>>>> end up calling __page_pool_put_page(). If the refcnt is 1 we'll try
> >>>>> to recycle the page.  If it's not we'll release it from page_pool (releasing
> >>>>> some internal references we keep) unmap the buffer and decrement the refcnt.  
> >>>>
> >>>> Yes, I understood the above is what the page pool do now.
> >>>>
> >>>> But the question is who is still holding an extral reference to the page when
> >>>> kfree_skb()? Perhaps a cloned and pskb_expand_head()'ed skb is holding an extral
> >>>> reference to the same page? So why not just do a page_ref_dec() if the orginal skb
> >>>> is freed first, and call __page_pool_put_page() when the cloned skb is freed later?
> >>>> So that we can always reuse the recyclable page from a recyclable skb. This may
> >>>> make the page_pool_destroy() process delays longer than before, I am supposed the
> >>>> page_pool_destroy() delaying for cloned skb case does not really matters here.
> >>>>
> >>>> If the above works, I think the samiliar handling can be added to RX zerocopy if
> >>>> the RX zerocopy also hold extral references to the recyclable page from a recyclable
> >>>> skb too?
> >>>>  
> >>>
> >>> Right, this sounds doable, but I'll have to go back code it and see if it
> >>> really makes sense.  However I'd still prefer the support to go in as-is
> >>> (including the struct xdp_mem_info in struct page, instead of a page_pool
> >>> pointer).
> >>>
> >>> There's a couple of reasons for that.  If we keep the struct xdp_mem_info we
> >>> can in the future recycle different kind of buffers using __xdp_return().
> >>> And this is a non intrusive change if we choose to store the page pool address
> >>> directly in the future.  It just affects the internal contract between the
> >>> page_pool code and struct page.  So it won't affect any drivers that already
> >>> use the feature.  
> >>
> >> This patchset has embeded a signature field in "struct page", and xdp_mem_info
> >> is stored in page_private(), which seems not considering the case for associating
> >> the page pool with "struct page" directly yet?   
> > 
> > Correct
> >   
> >> Is the page pool also stored in
> >> page_private() and a different signature is used to indicate that?  
> > 
> > No only struct xdp_mem_info as you mentioned before
> >   
> >>
> >> I am not saying we have to do it in this patchset, but we have to consider it
> >> while we are adding new signature field to "struct page", right?  
> > 
> > We won't need a new signature.  The signature in both cases is there to 
> > guarantee the page you are trying to recycle was indeed allocated by page_pool.
> > 
> > Basically we got two design choices here: 
> > - We store the page_pool ptr address directly in page->private and then,
> >   we call into page_pool APIs directly to do the recycling.
> >   That would eliminate the lookup through xdp_mem_info and the
> >   XDP helpers to locate page pool pointer (through __xdp_return).
> > - You store the xdp_mem_info on page_private.  In that case you need to go
> >   through __xdp_return()  to locate the page_pool pointer. Although we might
> >   loose some performance that would allow us to recycle additional memory types
> >   and not only MEM_TYPE_PAGE_POOL (in case we ever need it).  
>
> So the signature field  in "struct page" is used to only indicate a page is
> from a page pool, then how do we tell the content of page_private() if both of
> the above choices are needed, we might still need an extra indicator to tell
> page_private() is page_pool ptr or xdp_mem_info.

The signature field in "struct page" and "xdp_mem_info" is a double
construct that was introduced in this patchset.  AFAIK Matteo took the
idea from Jonathan's patchset.  I'm not convinced we need both, maybe
later we do (when someone introduce a new mem model ala NetGPU).

I think Jonathan's use-case was NetGPU[1] (which got shutdown due to
Nvidia[2] being involved which I think was unfair).  The general idea
behind NetGPU makes sense to me, to allow packet headers to live in
first page, and second page belongs to hardware.  This implies that an
SKB can can point to two different pages with different memory types,
which need to be handled correctly when freeing the SKB and the pages it
points to.  Thus, placing (xdp_)mem_info in SKB is wrong as it implies
all pages belong the same mem_info.type.

The point is, when designing this I want us to think about how our
design can handle other memory models than just page_pool.

In this patchset design, we use a single bit in SKB to indicate that
the pages pointed comes from another memory model, in this case
page_pool is the only user of this bit.  The remaining info about the
memory model (page_pool) is stored in struct-page, which we look at
when freeing the pages that the SKB points to (that is at the layer
above the MM-calls that would free the page for real).


[1] https://linuxplumbersconf.org/event/7/contributions/670/
[2] https://lwn.net/Articles/827596/

> It seems storing the page pool ptr in page_private() is clear for recyclable
> page from a recyclable skb use case, and the use case for storing xdp_mem_info
> in page_private() is unclear yet? As XDP seems to have the xdp_mem_info in the
> "struct xdp_frame", so it does not need the xdp_mem_info from page_private().
> 
> If the above is true, what does not really makes sense to me here is that:
> why do we first implement a unclear use case for storing xdp_mem_info in
> page_private(), why not implement the clear use case for storing page pool ptr
> in page_private() first?

I'm actually not against storing page_pool object ptr directly in
struct-page.  It is a nice optimization.  Perhaps we should implement
this optimization outside this patchset first, and let __xdp_return()
for XDP-redirected packets also take advantage to this optimization?

Then it would feel more natural to also used this optimization in this
patchset, right?

> > 
> > 
> > I think both choices are sane.  What I am trying to explain here, is
> > regardless of what we choose now, we can change it in the future without
> > affecting the API consumers at all.  What will change internally is the way we
> > lookup the page pool pointer we are trying to recycle.  
> 
> It seems the below API need changing?
> +static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
> +					struct xdp_mem_info *mem)

I don't think we need to change this API, to support future memory
models.  Notice that xdp_mem_info have a 'type' member.

Naming in Computer Science is a hard problem ;-). Something that seems
to confuse a lot of people is the naming of the struct "xdp_mem_info".  
Maybe we should have named it "mem_info" instead or "net_mem_info", as
it doesn't indicate that the device is running XDP.

I see XDP as the RX-layer before the network stack, that helps drivers
to support different memory models, also for handling normal packets
that doesn't get process by XDP, and the drivers doesn't even need to
support XDP to use the "xdp_mem_info" type.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

struct xdp_mem_info {
	u32 type; /* enum xdp_mem_type, but known size type */
	u32 id;
};

enum xdp_mem_type {
	MEM_TYPE_PAGE_SHARED = 0, /* Split-page refcnt based model */
	MEM_TYPE_PAGE_ORDER0,     /* Orig XDP full page model */
	MEM_TYPE_PAGE_POOL,
	MEM_TYPE_XSK_BUFF_POOL,
	MEM_TYPE_MAX,
};

