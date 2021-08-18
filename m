Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649BE3EFFB3
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhHRI5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhHRI5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:57:53 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CCFC0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 01:57:19 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a93so3905380ybi.1
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 01:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YTLMiHhkiL4q3jiK9pt4YDrvktzE393XGs6AJ7TzC8Q=;
        b=I6kyAYLAi/5ZODW7wt6QJbXbDvsHP7w+wgDYfsI9r0WrXnLIOL6x9SX+oTGZt2MtHL
         1c7P6go5VFqsUuq53wUjUoUKTprlG1Th4tey6QyS0hU6YC1q8xQWAuuACjr/b8aHL8Od
         ygWUVKvp3pmjMLay2722OExM1GZtyq9rU7kS3IptT7DOB6b1U/JCLU/elvfNkt0dUgDW
         D68MoMMMhGyarXKuBDTRYHEEk/BT2LdVTObaZxoP8QXZjnRnb1DBaZTUw1U0djh7mGxy
         ANvzU50AEt9CCJsTBZMXFibsDsapAXORN2rA+9Gs1o7YNz1j6YW3n0RIdySVgY8TkyHo
         D/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YTLMiHhkiL4q3jiK9pt4YDrvktzE393XGs6AJ7TzC8Q=;
        b=Z2phHlS1VfsYXKAeL+w2Td2q6mNoYrb2rRsA1Wp7l4FmAshfkeIKFZ/HDgD9ZhAcPZ
         isvYdlTVJb8JyDLfnyrUlHJMw/Pn8Wy4NXAwV3v4GFX6iAhURcvxyJWy8grM4KECL+V5
         t7Uj+9m+i99VAuometjKNQNHMA99+bg6yp8HcRJyGYFEFr0MVJjC1GDycYQ2A8DiV1vn
         KhsLOUhceABt/5Tm9/EytRZTusXSjJD5fM+x5Ix0fb58kSOJMxtwbYUuaWE2oP227AOQ
         8izzAIxK23ORPU3Ii/gdUik54hBMXseOFTEsbl52cqm+9KA+SeWdkeQxS6sYFMNA+Fh1
         P5kA==
X-Gm-Message-State: AOAM533L7EDUKB5LARpx0OwYcU8IDy9p4Am5x0d8B7UuSyaXK39EaydG
        SAEtTtHZ0vIUUlLKVYCTFXq579gEjR6Kvl+PsNVjQg==
X-Google-Smtp-Source: ABdhPJyr//c5nET8Z+mQvISb2NuJCd3AYTwGtAcJ75E4Y1uMidK+37ZjnYYMRwdrb7U9vOsDNUCsMMdMc8v5xECDm0Q=
X-Received: by 2002:a25:7806:: with SMTP id t6mr10195954ybc.132.1629277037785;
 Wed, 18 Aug 2021 01:57:17 -0700 (PDT)
MIME-Version: 1.0
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 18 Aug 2021 10:57:06 +0200
Message-ID: <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/7] add socket to netdev page frag recycling support
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
        linmiaohe <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 5:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> This patchset adds the socket to netdev page frag recycling
> support based on the busy polling and page pool infrastructure.

I really do not see how this can scale to thousands of sockets.

tcp_mem[] defaults to ~ 9 % of physical memory.

If you now run tests with thousands of sockets, their skbs will
consume Gigabytes
of memory on typical servers, now backed by order-0 pages (instead of
current order-3 pages)
So IOMMU costs will actually be much bigger.

Are we planning to use Gigabyte sized page pools for NIC ?

Have you tried instead to make TCP frags twice bigger ?
This would require less IOMMU mappings.
(Note: This could require some mm help, since PAGE_ALLOC_COSTLY_ORDER
is currently 3, not 4)

diff --git a/net/core/sock.c b/net/core/sock.c
index a3eea6e0b30a7d43793f567ffa526092c03e3546..6b66b51b61be9f198f6f1c4a3d81b57fa327986a
100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2560,7 +2560,7 @@ static void sk_leave_memory_pressure(struct sock *sk)
        }
 }

-#define SKB_FRAG_PAGE_ORDER    get_order(32768)
+#define SKB_FRAG_PAGE_ORDER    get_order(65536)
 DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);

 /**



>
> The profermance improve from 30Gbit to 41Gbit for one thread iperf
> tcp flow, and the CPU usages decreases about 20% for four threads
> iperf flow with 100Gb line speed in IOMMU strict mode.
>
> The profermance improve about 2.5% for one thread iperf tcp flow
> in IOMMU passthrough mode.
>
> Yunsheng Lin (7):
>   page_pool: refactor the page pool to support multi alloc context
>   skbuff: add interface to manipulate frag count for tx recycling
>   net: add NAPI api to register and retrieve the page pool ptr
>   net: pfrag_pool: add pfrag pool support based on page pool
>   sock: support refilling pfrag from pfrag_pool
>   net: hns3: support tx recycling in the hns3 driver
>   sysctl_tcp_use_pfrag_pool
>
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 32 +++++----
>  include/linux/netdevice.h                       |  9 +++
>  include/linux/skbuff.h                          | 43 +++++++++++-
>  include/net/netns/ipv4.h                        |  1 +
>  include/net/page_pool.h                         | 15 ++++
>  include/net/pfrag_pool.h                        | 24 +++++++
>  include/net/sock.h                              |  1 +
>  net/core/Makefile                               |  1 +
>  net/core/dev.c                                  | 34 ++++++++-
>  net/core/page_pool.c                            | 86 ++++++++++++-----------
>  net/core/pfrag_pool.c                           | 92 +++++++++++++++++++++++++
>  net/core/sock.c                                 | 12 ++++
>  net/ipv4/sysctl_net_ipv4.c                      |  7 ++
>  net/ipv4/tcp.c                                  | 34 ++++++---
>  14 files changed, 325 insertions(+), 66 deletions(-)
>  create mode 100644 include/net/pfrag_pool.h
>  create mode 100644 net/core/pfrag_pool.c
>
> --
> 2.7.4
>
