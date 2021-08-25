Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0123F7AA3
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241872AbhHYQdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241877AbhHYQdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:33:39 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C1AC0613C1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:32:53 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k65so59306yba.13
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L2AFAbGFTPnA/RAdM2ZFaFkRP5a2X/wBdXmNjJ5mbxQ=;
        b=EFyH5gQ1TyJQ0E/ipGx4TjWbQoJdvjNdek6wygsodqgXmWXthWUMYK9134wQX76vjd
         pjZyjX4x6YcGYOgnKumYuYYtVgnqbYaVCtAXBfYjPAh//H8JEXyKRCsVnaXdDAasu9/O
         zPhwt8cHWwLvKcKavTKt7NJ6x2JpU1DM3B8BRVw6TFys4+mM+pxgy3Y0M8xp2ddwyUlW
         eXO0m9iYrH/mcG71cp9eDjDeOU3pjHqlzJBpIJWz66SM+2FKzsAYULoFZLc5rT9dpmiE
         RgDFxCUdcZzYcQbR9eYrYDgiVhhaYI9Ra0hngSaLblFJSYXuEC9MGDdvXfT2d0cYL3QB
         TVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L2AFAbGFTPnA/RAdM2ZFaFkRP5a2X/wBdXmNjJ5mbxQ=;
        b=Q+Nb4fUi1HmmonwNppN6r9ckTIx5sM0jd1ZcxH/9qyogRnT2PbpAA/asOXJGNQ7IMk
         IekGuMzngQHzVy35hoU4/ZgFJD0WcRGswsTjLWznb/Agme4+1CMp0/ZdHQoHThlxV44v
         YTygeOc6YXZGf6AYp0kwa7Pb3KsDE1/3WgjUeUSSagn6bvo9e/beXE21mfp2UWD4d5vm
         eQrCBlJss1kX+ubkgpvmMz6awutzaBxW0vQCrAnA8RVu/7TXEviPuCVELejMjibIAeJ0
         L7w3tWoAx5OeyIPJqJgaWRQQZ+1bbGhhc3CijzUNauMJ3oq7lM/fkU7wkXKXgcypOoqK
         TXBA==
X-Gm-Message-State: AOAM533SOlnTksCOaUhTp9y6A4Q1SkTz52CjFJAGLqm4nD+V1U516QRi
        d0WrJ2FDe0QzjncAKIQM+bWQ4P/ZD+cq1dWSD7Y0+A==
X-Google-Smtp-Source: ABdhPJyjMEw3MAy8Rswny0jBRnbt29d64qJjNPqBZ4cVCxfjKryRONVrGN9Sy8zNpFb12YVfZl773NDJUeXFJ54fBTo=
X-Received: by 2002:a25:d6d8:: with SMTP id n207mr20857216ybg.518.1629909172492;
 Wed, 25 Aug 2021 09:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
 <2cf4b672-d7dc-db3d-ce90-15b4e91c4005@huawei.com> <4b2ad6d4-8e3f-fea9-766e-2e7330750f84@huawei.com>
 <CANn89iK0nMG3qq226aL-urrtPF5jBN6UQCV=ckTmAFqWgy5kiA@mail.gmail.com> <5fdc5223-7d67-fed7-f691-185dcb2e3d80@gmail.com>
In-Reply-To: <5fdc5223-7d67-fed7-f691-185dcb2e3d80@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Aug 2021 09:32:41 -0700
Message-ID: <CANn89iKqijGU_0dQMeyMJ2h2MJE3=fLm8qb456G3ZD_7TrLt_A@mail.gmail.com>
Subject: Re: [Linuxarm] Re: [PATCH RFC 0/7] add socket to netdev page frag
 recycling support
To:     David Ahern <dsahern@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
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

On Wed, Aug 25, 2021 at 9:29 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/23/21 8:04 AM, Eric Dumazet wrote:
> >>
> >>
> >> It seems PAGE_ALLOC_COSTLY_ORDER is mostly related to pcp page, OOM, memory
> >> compact and memory isolation, as the test system has a lot of memory installed
> >> (about 500G, only 3-4G is used), so I used the below patch to test the max
> >> possible performance improvement when making TCP frags twice bigger, and
> >> the performance improvement went from about 30Gbit to 32Gbit for one thread
> >> iperf tcp flow in IOMMU strict mode,
> >
> > This is encouraging, and means we can do much better.
> >
> > Even with SKB_FRAG_PAGE_ORDER  set to 4, typical skbs will need 3 mappings
> >
> > 1) One for the headers (in skb->head)
> > 2) Two page frags, because one TSO packet payload is not a nice power-of-two.
>
> interesting observation. I have noticed 17 with the ZC API. That might
> explain the less than expected performance bump with iommu strict mode.

Note that if application is using huge pages, things get better after

commit 394fcd8a813456b3306c423ec4227ed874dfc08b
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Aug 20 08:43:59 2020 -0700

    net: zerocopy: combine pages in zerocopy_sg_from_iter()

    Currently, tcp sendmsg(MSG_ZEROCOPY) is building skbs with order-0
fragments.
    Compared to standard sendmsg(), these skbs usually contain up to
16 fragments
    on arches with 4KB page sizes, instead of two.

    This adds considerable costs on various ndo_start_xmit() handlers,
    especially when IOMMU is in the picture.

    As high performance applications are often using huge pages,
    we can try to combine adjacent pages belonging to same
    compound page.

    Tested on AMD Rome platform, with IOMMU, nominal single TCP flow speed
    is roughly doubled (~55Gbit -> ~100Gbit), when user application
    is using hugepages.

    For reference, nominal single TCP flow speed on this platform
    without MSG_ZEROCOPY is ~65Gbit.

    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Willem de Bruijn <willemb@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Ideally the gup stuff should really directly deal with hugepages, so
that we avoid
all these crazy refcounting games on the per-huge-page central refcount.

>
> >
> > The first issue can be addressed using a piece of coherent memory (128
> > or 256 bytes per entry in TX ring).
> > Copying the headers can avoid one IOMMU mapping, and improve IOTLB
> > hits, because all
> > slots of the TX ring buffer will use one single IOTLB slot.
> >
> > The second issue can be solved by tweaking a bit
> > skb_page_frag_refill() to accept an additional parameter
> > so that the whole skb payload fits in a single order-4 page.
> >
> >
