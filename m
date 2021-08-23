Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A223F4D06
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 17:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhHWPFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 11:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhHWPFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 11:05:12 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C05C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 08:04:29 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z5so34737078ybj.2
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 08:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=brllRPBO8PdBfH3Jzs8CaAHdDlba7cjyGUD8zEZHXyY=;
        b=Vc94pMZYpc3ZyvKJNLJR7EvkvNVw9GhNOAOpAliq6KWt3zPz4+eWlN7s8oacbHvPfG
         T1ZWXFUTqWUQtDMntCHNe0df98oepr+UqMcrx2l794bCcdeL/YKATj+g0ZWPKkKXiR8l
         LlZJD4r4V7HVVKltZj68itYQapxgFlrJZnFruvhzqzbhkJu8+kn8Guu/TfuVUOv5Ama5
         xrVG+YDIkOLNVTDTNWfu6bvxYhRpKndPVxk3EYlxYDq5r4VCQ1rpU8gBNoeTdimT40wO
         El539AasUnjmndFEkMIO2V90KHJBrz7CizfpLVCNaZfqxfSWbyZ2zA8ziexXSACy7EVZ
         cvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=brllRPBO8PdBfH3Jzs8CaAHdDlba7cjyGUD8zEZHXyY=;
        b=RJ+gJz3560j0uTXisp/5jtogzxNn7fKSecMgrsOlL0KpH/IVUD4R4RgaSBiCJ3StOu
         6jktf5xUBWr8Gk8ZE4d/arLOluSiKw3SjVf1TJP21itAtRivCIj16roKSgNsdGE4ldxu
         1UYf0kE7h/O5hyeuPlvdgksQx43s72y9oZKY7+00egR/umIzCS2JjFMNfVizez7C6nRr
         t6wDvGgCtmbGs8oRmy6Enc1HNtcU6aJmV6nLXCWQ7fJW5HznovatJHnVf6sHU5OkB6yB
         JI50EeaaPhBU/Il/fy3IxirvppwH1n25EMM20kAQO4eLbJ5HiDiMjKy7P/owv3nhjyfF
         kmRw==
X-Gm-Message-State: AOAM530cyRkQt28a+zZC7asC89knvnPKH0TehF16DiRjMAigWKOGTvAg
        8jlxS2YaukQrYvdK+Swv6GoAUsGixHyrte/4UlizvQ==
X-Google-Smtp-Source: ABdhPJzACN5iW03c/RkSTXbYC3XXHzI70EbUZdt3h+laFXezA37uunrWvdyn9XuQcY7UyBk5h7i/rsROdE5kjXMoX3o=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr42895820ybj.504.1629731067656;
 Mon, 23 Aug 2021 08:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
 <2cf4b672-d7dc-db3d-ce90-15b4e91c4005@huawei.com> <4b2ad6d4-8e3f-fea9-766e-2e7330750f84@huawei.com>
In-Reply-To: <4b2ad6d4-8e3f-fea9-766e-2e7330750f84@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Aug 2021 08:04:16 -0700
Message-ID: <CANn89iK0nMG3qq226aL-urrtPF5jBN6UQCV=ckTmAFqWgy5kiA@mail.gmail.com>
Subject: Re: [Linuxarm] Re: [PATCH RFC 0/7] add socket to netdev page frag
 recycling support
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        "Tang, Feng" <feng.tang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        mcroce@microsoft.com, Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        chenhao288@hisilicon.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, memxor@gmail.com,
        linux@rempel-privat.de, Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        aahringo@redhat.com, ceggers@arri.de, yangbo.lu@nxp.com,
        Florian Westphal <fw@strlen.de>, xiangxia.m.yue@gmail.com,
        linmiaohe <linmiaohe@huawei.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 2:25 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/8/18 17:36, Yunsheng Lin wrote:
> > On 2021/8/18 16:57, Eric Dumazet wrote:
> >> On Wed, Aug 18, 2021 at 5:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>
> >>> This patchset adds the socket to netdev page frag recycling
> >>> support based on the busy polling and page pool infrastructure.
> >>
> >> I really do not see how this can scale to thousands of sockets.
> >>
> >> tcp_mem[] defaults to ~ 9 % of physical memory.
> >>
> >> If you now run tests with thousands of sockets, their skbs will
> >> consume Gigabytes
> >> of memory on typical servers, now backed by order-0 pages (instead of
> >> current order-3 pages)
> >> So IOMMU costs will actually be much bigger.
> >
> > As the page allocator support bulk allocating now, see:
> > https://elixir.bootlin.com/linux/latest/source/net/core/page_pool.c#L252
> >
> > if the DMA also support batch mapping/unmapping, maybe having a
> > small-sized page pool for thousands of sockets may not be a problem?
> > Christoph Hellwig mentioned the batch DMA operation support in below
> > thread:
> > https://www.spinics.net/lists/netdev/msg666715.html
> >
> > if the batched DMA operation is supported, maybe having the
> > page pool is mainly benefit the case of small number of socket?
> >
> >>
> >> Are we planning to use Gigabyte sized page pools for NIC ?
> >>
> >> Have you tried instead to make TCP frags twice bigger ?
> >
> > Not yet.
> >
> >> This would require less IOMMU mappings.
> >> (Note: This could require some mm help, since PAGE_ALLOC_COSTLY_ORDER
> >> is currently 3, not 4)
> >
> > I am not familiar with mm yet, but I will take a look about that:)
>
>
> It seems PAGE_ALLOC_COSTLY_ORDER is mostly related to pcp page, OOM, memory
> compact and memory isolation, as the test system has a lot of memory installed
> (about 500G, only 3-4G is used), so I used the below patch to test the max
> possible performance improvement when making TCP frags twice bigger, and
> the performance improvement went from about 30Gbit to 32Gbit for one thread
> iperf tcp flow in IOMMU strict mode,

This is encouraging, and means we can do much better.

Even with SKB_FRAG_PAGE_ORDER  set to 4, typical skbs will need 3 mappings

1) One for the headers (in skb->head)
2) Two page frags, because one TSO packet payload is not a nice power-of-two.

The first issue can be addressed using a piece of coherent memory (128
or 256 bytes per entry in TX ring).
Copying the headers can avoid one IOMMU mapping, and improve IOTLB
hits, because all
slots of the TX ring buffer will use one single IOTLB slot.

The second issue can be solved by tweaking a bit
skb_page_frag_refill() to accept an additional parameter
so that the whole skb payload fits in a single order-4 page.


 and using the pfrag pool, the improvement
> went from about 30Gbit to 40Gbit for the same testing configuation:

Yes, but you have not provided performance number when 200 (or 1000+)
concurrent flows are running.

Optimizing singe flow TCP performance while killing performance for
the more common case is not an option.


>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index fcb5355..dda20f9 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -37,7 +37,7 @@
>   * coalesce naturally under reasonable reclaim pressure and those which
>   * will not.
>   */
> -#define PAGE_ALLOC_COSTLY_ORDER 3
> +#define PAGE_ALLOC_COSTLY_ORDER 4
>
>  enum migratetype {
>         MIGRATE_UNMOVABLE,
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 870a3b7..b1e0dfc 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2580,7 +2580,7 @@ static void sk_leave_memory_pressure(struct sock *sk)
>         }
>  }
>
> -#define SKB_FRAG_PAGE_ORDER    get_order(32768)
> +#define SKB_FRAG_PAGE_ORDER    get_order(65536)
>  DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
>
>  /**
>
> >
> >>
> >> diff --git a/net/core/sock.c b/net/core/sock.c
> >> index a3eea6e0b30a7d43793f567ffa526092c03e3546..6b66b51b61be9f198f6f1c4a3d81b57fa327986a
> >> 100644
> >> --- a/net/core/sock.c
> >> +++ b/net/core/sock.c
> >> @@ -2560,7 +2560,7 @@ static void sk_leave_memory_pressure(struct sock *sk)
> >>         }
> >>  }
> >>
> >> -#define SKB_FRAG_PAGE_ORDER    get_order(32768)
> >> +#define SKB_FRAG_PAGE_ORDER    get_order(65536)
> >>  DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
> >>
> >>  /**
> >>
> >>
> >>
> >>>
> > _______________________________________________
> > Linuxarm mailing list -- linuxarm@openeuler.org
> > To unsubscribe send an email to linuxarm-leave@openeuler.org
> >
