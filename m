Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2905336405F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 13:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbhDSLXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 07:23:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235872AbhDSLXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 07:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618831351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqJ+FOS6XVGlmbD09GMCCte4Tn5COUmCLJ4wF14ufSc=;
        b=ZkGIUXUvbqZ3d5+iYXWw53U/h8W5YdtPPcO+ASzLemFeTTLOZUolGFTuXAe35rsLd1kbM4
        PFVIPICbOPoQQwK+HRnlNYjDsZoYoDkmArYDSwW1hNF7sSBiplrbigS+RarmRY4zvGxbCO
        MjRP5p8ZwDtBKAuVxNkKyrLRTSKU6Bs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-C0_4cIrkNwOVXj_piPsSSg-1; Mon, 19 Apr 2021 07:22:28 -0400
X-MC-Unique: C0_4cIrkNwOVXj_piPsSSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1E541006CAF;
        Mon, 19 Apr 2021 11:22:27 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD7B55D9CD;
        Mon, 19 Apr 2021 11:22:05 +0000 (UTC)
Date:   Mon, 19 Apr 2021 13:22:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matthew Wilcox <willy@infradead.org>,
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
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH net-next v3 2/5] mm: add a signature in struct page
Message-ID: <20210419132204.1e07d5b9@carbon>
In-Reply-To: <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
        <20210409223801.104657-3-mcroce@linux.microsoft.com>
        <20210410154824.GZ2531743@casper.infradead.org>
        <YHHPbQm2pn2ysth0@enceladus>
        <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
        <YHHuE7g73mZNrMV4@enceladus>
        <20210414214132.74f721dd@carbon>
        <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 13:09:47 -0700
Shakeel Butt <shakeelb@google.com> wrote:

> On Wed, Apr 14, 2021 at 12:42 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >  
> [...]
> > > >
> > > > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > > > can not be used.  
> > >
> > > Yes it can, since it's going to be used as your default allocator for
> > > payloads, which might end up on an SKB.  
> >
> > I'm not sure we want or should "allow" page_pool be used for TCP RX
> > zerocopy.
> > For several reasons.
> >
> > (1) This implies mapping these pages page to userspace, which AFAIK
> > means using page->mapping and page->index members (right?).
> >  
> 
> No, only page->_mapcount is used.

Good to know.
I will admit that I don't fully understand the usage of page->mapping
and page->index members.

> > (2) It feels wrong (security wise) to keep the DMA-mapping (for the
> > device) and also map this page into userspace.
> >  
> 
> I think this is already the case i.e pages still DMA-mapped and also
> mapped into userspace.

True, other drivers are doing the same.

> > (3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
> > zerocopy will bump the refcnt, which means the page_pool will not
> > recycle the page when it see the elevated refcnt (it will instead
> > release its DMA-mapping).  
> 
> Yes this is right but the userspace might have already consumed and
> unmapped the page before the driver considers to recycle the page.

That is a good point.  So, there is a race window where it is possible
to gain recycling.

It seems my page_pool co-maintainer Ilias is interested in taking up the
challenge to get this working with TCP RX zerocopy.  So, lets see how
this is doable.

 
> >
> > (4) I remember vaguely that this code path for (TCP RX zerocopy) uses
> > page->private for tricks.  And our patch [3/5] use page->private for
> > storing xdp_mem_info.
> >
> > IMHO when the SKB travel into this TCP RX zerocopy code path, we should
> > call page_pool_release_page() to release its DMA-mapping.
> >  
> 
> I will let TCP RX zerocopy experts respond to this but from my high
> level code inspection, I didn't see page->private usage.

I trust when Eric says page->private isn't used in this code path.
So, it might actually be possible :-)

I will challenge Ilias and Matteo to pull this off. (But I know that
both of them are busy for personal reasons, so be patient with them).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

