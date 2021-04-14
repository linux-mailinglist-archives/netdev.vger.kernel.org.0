Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AA935FBC1
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhDNTmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:42:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233374AbhDNTmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618429320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yabYzh4cj6LIMrN9G97xSgLjHLEzr2USN5EFIehOUuc=;
        b=EPnDEt6T5vwnnp0MTYBcak9GPrGKZ8pPtRWkJwXVmV59IWh9CPnmPIXNGykU0ODUtnnO1X
        Jj62f4eTrO/tvwbse2faXiWUmYxJIgdterwckPpCyqIGkSkkejHSoeG/bQmmTdSacMnCMy
        WSDlF7rf3HH9lS1etiOZ3CA8NpUEFzo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-gtn7VxdAOr-GRAwHGUoGbg-1; Wed, 14 Apr 2021 15:41:55 -0400
X-MC-Unique: gtn7VxdAOr-GRAwHGUoGbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5382DF8A3;
        Wed, 14 Apr 2021 19:41:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21B355D6BA;
        Wed, 14 Apr 2021 19:41:33 +0000 (UTC)
Date:   Wed, 14 Apr 2021 21:41:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, Shakeel Butt <shakeelb@google.com>,
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
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/5] mm: add a signature in struct page
Message-ID: <20210414214132.74f721dd@carbon>
In-Reply-To: <YHHuE7g73mZNrMV4@enceladus>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
        <20210409223801.104657-3-mcroce@linux.microsoft.com>
        <20210410154824.GZ2531743@casper.infradead.org>
        <YHHPbQm2pn2ysth0@enceladus>
        <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
        <YHHuE7g73mZNrMV4@enceladus>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Apr 2021 21:27:31 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Sat, Apr 10, 2021 at 10:42:30AM -0700, Shakeel Butt wrote:
>
> > On Sat, Apr 10, 2021 at 9:16 AM Ilias Apalodimas
> > <ilias.apalodimas@linaro.org> wrote:  
> > >
> > > Hi Matthew
> > >
> > > On Sat, Apr 10, 2021 at 04:48:24PM +0100, Matthew Wilcox wrote:  
> > > > On Sat, Apr 10, 2021 at 12:37:58AM +0200, Matteo Croce wrote:  
> > > > > This is needed by the page_pool to avoid recycling a page not allocated
> > > > > via page_pool.  
> > > >
> > > > Is the PageType mechanism more appropriate to your needs?  It wouldn't
> > > > be if you use page->_mapcount (ie mapping it to userspace).  
> > >
> > > Interesting!
> > > Please keep in mind this was written ~2018 and was stale on my branches for
> > > quite some time.  So back then I did try to use PageType, but had not free
> > > bits.  Looking at it again though, it's cleaned up.  So yes I think this can
> > > be much much cleaner.  Should we go and define a new PG_pagepool?
> > >
> > 
> > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > can not be used.  
> 
> Yes it can, since it's going to be used as your default allocator for
> payloads, which might end up on an SKB.

I'm not sure we want or should "allow" page_pool be used for TCP RX
zerocopy.
For several reasons.

(1) This implies mapping these pages page to userspace, which AFAIK
means using page->mapping and page->index members (right?).

(2) It feels wrong (security wise) to keep the DMA-mapping (for the
device) and also map this page into userspace.

(3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
zerocopy will bump the refcnt, which means the page_pool will not
recycle the page when it see the elevated refcnt (it will instead
release its DMA-mapping).

(4) I remember vaguely that this code path for (TCP RX zerocopy) uses
page->private for tricks.  And our patch [3/5] use page->private for
storing xdp_mem_info.

IMHO when the SKB travel into this TCP RX zerocopy code path, we should
call page_pool_release_page() to release its DMA-mapping.


> > [1] https://lore.kernel.org/linux-mm/20210316013003.25271-1-arjunroy.kdev@gmail.com/  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

