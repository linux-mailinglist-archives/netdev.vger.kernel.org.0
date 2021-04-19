Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9B236467F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238850AbhDSO5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbhDSO5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 10:57:48 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106C9C061761
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 07:57:17 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x19so26024300lfa.2
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 07:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bOY9m1eIVASQIMnSbwflGhIUTyPWYD03S/dD7MA55Qc=;
        b=rgKpT44z5gZPH7IcDqEdCS5YbgmApA+chMspbQ+JZGvC+YpgKwQzzX5A4jzxNEjvmG
         MLlDYm4e7iCaE5IHqjOyN/ifzjPweOwwRpEg2SJB0fXvLMt8562VpY9TMa7hc7yb2lA1
         2PVEZpoklcaU3AfYgP9KRx34WMyKtu4e/QsEtsbYZgOl6h8Xq+0WvD0oBFTfJC4iVd4L
         6j0H/BV7sKihqk2a+lubMh5VtlxaVk/jrOh+titVm4bmXsc3XMgR5O5X+2oCsdriqvyU
         BMBRSMvjklWjnZ9g9t6FGjScAawV2e+WWEzp+KcGRgjhYZ/E3Qe13rckj3cpUlBiF3sb
         St4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bOY9m1eIVASQIMnSbwflGhIUTyPWYD03S/dD7MA55Qc=;
        b=KANHuO45d1v4B2/uOGF8hQ8EsITHXKpohcMnxvKSfhF6BPaEB19akyEprprf/I7ngw
         5GyrXN3mGBSaQYHMGznpfARzaLFAJfzPloT8UFf2fc7rvhbii5XicRflpXdlQCMM/4rk
         agRndnfgGDBvjJRV+wcIkt2qqHYj8CBa+09rzM9jZnBhnzD2x/0r4bvHpyWGHAP40L51
         FYRSx5t0QvODSOjzfqcKjPf0z8saBYU1DRCU1soOC74GkuP1DTb+UBZwTLrPANMyIaP2
         qPX6eBcKdUagw7okQGxrkbsCOuDrERb8OH26NP5PsIXMiqk0gYPdHPF8RvRP150i3NEY
         r+Gg==
X-Gm-Message-State: AOAM533MTBnrqPa0YAXbx2FkQL+fzb9q5KmXOnWcrP1KLrgWCL4cLFN0
        WfGg7gmi1S+bF1gmzmmRw6bdbSUAykkG6wBzx9WrS0p/zmTVMQ==
X-Google-Smtp-Source: ABdhPJzVe3naebLuz81mJv7oonUIqkV5Z3LAXE1HEtaRfd+15ET0ZRont6UfxMYDrQHny8LYwtQzYeplG9JZRH79Gdo=
X-Received: by 2002:a05:6512:92e:: with SMTP id f14mr6712386lft.347.1618844235220;
 Mon, 19 Apr 2021 07:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com> <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus> <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus> <20210414214132.74f721dd@carbon>
 <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com> <YH0RMV7+56gVOzJe@apalos.home>
In-Reply-To: <YH0RMV7+56gVOzJe@apalos.home>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 19 Apr 2021 07:57:03 -0700
Message-ID: <CALvZod7oa4q6pMUyDi4FMW4WKY7AjOZ7P2=02GoxjpwrQpA-OQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/5] mm: add a signature in struct page
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 10:12 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Wed, Apr 14, 2021 at 01:09:47PM -0700, Shakeel Butt wrote:
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
> >
>
> I am not sure I like leaving out TCP RX zerocopy. Since we want driver to
> adopt the recycling mechanism we should try preserving the current
> functionality of the network stack.
>
> The question is how does it work with the current drivers that already have an
> internal page recycling mechanism.
>

I think the current drivers check page_ref_count(page) to decide to
reuse (or not) the already allocated pages.

Some examples from the drivers:
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:ixgbe_can_reuse_rx_page()
drivers/net/ethernet/intel/igb/igb_main.c:igb_can_reuse_rx_page()
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:mlx5e_rx_cache_get()

> > > (2) It feels wrong (security wise) to keep the DMA-mapping (for the
> > > device) and also map this page into userspace.
> > >
> >
> > I think this is already the case i.e pages still DMA-mapped and also
> > mapped into userspace.
> >
> > > (3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
> > > zerocopy will bump the refcnt, which means the page_pool will not
> > > recycle the page when it see the elevated refcnt (it will instead
> > > release its DMA-mapping).
> >
> > Yes this is right but the userspace might have already consumed and
> > unmapped the page before the driver considers to recycle the page.
>
> Same question here. I'll have a closer look in a few days and make sure we are
> not breaking anything wrt zerocopy.
>

Pages mapped into the userspace have their refcnt elevated, so the
page_ref_count() check by the drivers indicates to not reuse such
pages.

> >
> > >
> > > (4) I remember vaguely that this code path for (TCP RX zerocopy) uses
> > > page->private for tricks.  And our patch [3/5] use page->private for
> > > storing xdp_mem_info.
> > >
> > > IMHO when the SKB travel into this TCP RX zerocopy code path, we should
> > > call page_pool_release_page() to release its DMA-mapping.
> > >
> >
> > I will let TCP RX zerocopy experts respond to this but from my high
> > level code inspection, I didn't see page->private usage.
>
> Shakeel are you aware of any 'easy' way I can have rx zerocopy running?
>

I would recommend tools/testing/selftests/net/tcp_mmap.c.
