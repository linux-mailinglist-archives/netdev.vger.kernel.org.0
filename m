Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21C0364748
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhDSPnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241324AbhDSPny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:43:54 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C52C06138A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 08:43:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id k17so1791849edr.7
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 08:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wf0QWwNwYK6Jhss3gCic3ehYYejoO/XLDc6PTFbc/rU=;
        b=AcV8eFNybarUUIKChCGLHFNWKTXeCXUS2RwBuMjj5z9IPjcJJzr+bKeR2lL61o4jJJ
         sRwQo3IzAcvyzF4JFtxWbtvpUxNLNtl+iUWDSbH8GdI2gQSryXkcPO2EgjqBsZxNL/Dp
         oEVDryNxsWLjXMkNbGCx5oX+lFL+nn6Okl0BYTH1LHz5mYShDONiNnVrbqfgCiPz4xQG
         h+xu8ewH/NOn5+DsVldXLFK4y0RknlSRIbJpnzFt+Me2/3yAJBF8qKjo7Wwfn1w/uHs6
         mb2HggcdKRRt97ivNvwAFF9kD37O4OBBnD8HNyLoFsDdEp6+/21qeeklsXWgJzvdIn5X
         hmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wf0QWwNwYK6Jhss3gCic3ehYYejoO/XLDc6PTFbc/rU=;
        b=DoHiv3UZz2Pvjye4kX2S7adpQChWiUAcZX6ciLchUR9uIRp944Z6JIL3RDsaysfHW+
         +o821sShBQrlwhwt5nhAga0g+cG//5JwILAtXl05FknOU91HfZIHizIb6WUb18rTgiuI
         3853HpieZzNQ3wMOi2o2f8if4yvu79m7hBcXUrdELauAkMyOHipduC6TPqWhqXU6ofGV
         33CNQUxdRLH4Ya9EF1AbY3nxB8dONOtY5fq9kVzA0jrClc8AsPPeNHMIe3pDFF3zp/vX
         2nmmp8Vcop0XLgEkPX2z779NvdRWeK4myawaHhVkX9UG0QSRbl/8CidH9OcqDnclRK+v
         hbTA==
X-Gm-Message-State: AOAM533wKGXvvrauU+G9AwfOGetXZLuSPiZ3aXfyNaWTNNs7U4jEQayn
        aIillrdDrKiIdT9vnQdFZ3HefA==
X-Google-Smtp-Source: ABdhPJwF0JLAYSLI4B5eBDz2Xkr4BA5xRzg20NOS5BQtJee0K4m+lYUS7uBNOMRCPGktz319AfgEZw==
X-Received: by 2002:aa7:d3c6:: with SMTP id o6mr19000389edr.359.1618847003325;
        Mon, 19 Apr 2021 08:43:23 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-88.home.otenet.gr. [94.65.92.88])
        by smtp.gmail.com with ESMTPSA id s11sm13468946edt.27.2021.04.19.08.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:43:22 -0700 (PDT)
Date:   Mon, 19 Apr 2021 18:43:17 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
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
Message-ID: <YH2lFYbj3d8nC+hF@apalos.home>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com>
 <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus>
 <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus>
 <20210414214132.74f721dd@carbon>
 <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
 <YH0RMV7+56gVOzJe@apalos.home>
 <CALvZod7oa4q6pMUyDi4FMW4WKY7AjOZ7P2=02GoxjpwrQpA-OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod7oa4q6pMUyDi4FMW4WKY7AjOZ7P2=02GoxjpwrQpA-OQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shakeel,
On Mon, Apr 19, 2021 at 07:57:03AM -0700, Shakeel Butt wrote:
> On Sun, Apr 18, 2021 at 10:12 PM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > On Wed, Apr 14, 2021 at 01:09:47PM -0700, Shakeel Butt wrote:
> > > On Wed, Apr 14, 2021 at 12:42 PM Jesper Dangaard Brouer
> > > <brouer@redhat.com> wrote:
> > > >
> > > [...]
> > > > > >
> > > > > > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > > > > > can not be used.
> > > > >
> > > > > Yes it can, since it's going to be used as your default allocator for
> > > > > payloads, which might end up on an SKB.
> > > >
> > > > I'm not sure we want or should "allow" page_pool be used for TCP RX
> > > > zerocopy.
> > > > For several reasons.
> > > >
> > > > (1) This implies mapping these pages page to userspace, which AFAIK
> > > > means using page->mapping and page->index members (right?).
> > > >
> > >
> > > No, only page->_mapcount is used.
> > >
> >
> > I am not sure I like leaving out TCP RX zerocopy. Since we want driver to
> > adopt the recycling mechanism we should try preserving the current
> > functionality of the network stack.
> >
> > The question is how does it work with the current drivers that already have an
> > internal page recycling mechanism.
> >
> 
> I think the current drivers check page_ref_count(page) to decide to
> reuse (or not) the already allocated pages.
> 
> Some examples from the drivers:
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:ixgbe_can_reuse_rx_page()
> drivers/net/ethernet/intel/igb/igb_main.c:igb_can_reuse_rx_page()
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:mlx5e_rx_cache_get()
> 

Yes, that's how internal recycling is done in drivers. As Jesper mentioned the
refcnt of the page is 1 for the page_pool owned pages and that's how we decide 
what to do with the page.

> > > > (2) It feels wrong (security wise) to keep the DMA-mapping (for the
> > > > device) and also map this page into userspace.
> > > >
> > >
> > > I think this is already the case i.e pages still DMA-mapped and also
> > > mapped into userspace.
> > >
> > > > (3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
> > > > zerocopy will bump the refcnt, which means the page_pool will not
> > > > recycle the page when it see the elevated refcnt (it will instead
> > > > release its DMA-mapping).
> > >
> > > Yes this is right but the userspace might have already consumed and
> > > unmapped the page before the driver considers to recycle the page.
> >
> > Same question here. I'll have a closer look in a few days and make sure we are
> > not breaking anything wrt zerocopy.
> >
> 
> Pages mapped into the userspace have their refcnt elevated, so the
> page_ref_count() check by the drivers indicates to not reuse such
> pages.
> 

When tcp_zerocopy_receive() is invoked it will call tcp_zerocopy_vm_insert_batch() 
which will end up doing a get_page().
What you are saying is that once the zerocopy is done though, skb_release_data() 
won't be called, but instead put_page() will be? If that's the case then we are 
indeed leaking DMA mappings and memory. That sounds weird though, since the
refcnt will be one in that case (zerocopy will do +1/-1 once it's done), so who
eventually frees the page? 
If kfree_skb() (or any wrapper that calls skb_release_data()) is called 
eventually, we'll end up properly recycling the page into our pool.

> > >
> > > >
> > > > (4) I remember vaguely that this code path for (TCP RX zerocopy) uses
> > > > page->private for tricks.  And our patch [3/5] use page->private for
> > > > storing xdp_mem_info.
> > > >
> > > > IMHO when the SKB travel into this TCP RX zerocopy code path, we should
> > > > call page_pool_release_page() to release its DMA-mapping.
> > > >
> > >
> > > I will let TCP RX zerocopy experts respond to this but from my high
> > > level code inspection, I didn't see page->private usage.
> >
> > Shakeel are you aware of any 'easy' way I can have rx zerocopy running?
> >
> 
> I would recommend tools/testing/selftests/net/tcp_mmap.c.

Ok, thanks I'll have a look.

Cheers
/Ilias
