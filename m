Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB13C353C
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 17:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhGJPo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 11:44:26 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35480 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhGJPo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 11:44:26 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by linux.microsoft.com (Postfix) with ESMTPSA id 953C420B7178;
        Sat, 10 Jul 2021 08:41:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 953C420B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1625931700;
        bh=KhF9I+Y91rxYPQlmhH47nudYd4aSbMl0azX4Aaq10yE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J3TN/kzDcpLltdM5dLTvzYscS5+4ibNr5/MjNHBx/0DdxPI4uKALRgGhYLjQMtJ+R
         XQFPyVFSvBU3tAfj6jTnXfy6PraPb1VNoI0pdCbGmTzRQq4xsGdy+CevZDR3HlWJLU
         RzYVJr4+HIJyoMsgYoTujLpj/US39oSqJnP4fS44=
Received: by mail-oi1-f171.google.com with SMTP id c145so1337604oib.2;
        Sat, 10 Jul 2021 08:41:40 -0700 (PDT)
X-Gm-Message-State: AOAM533wV/76MYn0FEx61k7EWOwBwmEK6YyjBKy59qCmWTjXs4ZIhe1Q
        w3HQg8ZS097KfjXn67CkAI3IqDEQFClRv/SUEZM=
X-Google-Smtp-Source: ABdhPJy/uy2dwsXHp5mBB6WF61ieJ7+JBRsl6NCE+f81Nd3pkshmqTHllqDLOxL6ZlRxSd1DHCUMmmE3JxUoNRKS4/o=
X-Received: by 2002:a17:90a:43c3:: with SMTP id r61mr4950050pjg.11.1625931689477;
 Sat, 10 Jul 2021 08:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 10 Jul 2021 17:40:53 +0200
X-Gmail-Original-Message-ID: <CAFnufp3RXwrJy24r50dHG6ouM2tsGY3JgPq9h1B5C0TOYCDHrQ@mail.gmail.com>
Message-ID: <CAFnufp3RXwrJy24r50dHG6ouM2tsGY3JgPq9h1B5C0TOYCDHrQ@mail.gmail.com>
Subject: Re: [PATCH rfc v2 0/5] add elevated refcnt support for page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, alexander.duyck@gmail.com,
        Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
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
        feng.tang@intel.com, Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 9:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> This patchset adds elevated refcnt support for page pool
> and enable skb's page frag recycling based on page pool
> in hns3 drvier.
>
> RFC v2:
> 1. Split patch 1 to more reviewable one.
> 2. Repurpose the lower 12 bits of the dma address to store the
>    pagecnt_bias as suggested by Alexander.
> 3. support recycling to pool->alloc for elevated refcnt case
>    too.
>
> Yunsheng Lin (5):
>   page_pool: keep pp info as long as page pool owns the page
>   page_pool: add interface for getting and setting pagecnt_bias
>   page_pool: add page recycling support based on elevated refcnt
>   page_pool: support page frag API for page pool
>   net: hns3: support skb's frag page recycling based on page pool
>
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  79 ++++++++++-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |   3 +
>  drivers/net/ethernet/marvell/mvneta.c           |   6 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   2 +-
>  drivers/net/ethernet/ti/cpsw.c                  |   2 +-
>  drivers/net/ethernet/ti/cpsw_new.c              |   2 +-
>  include/linux/skbuff.h                          |   4 +-
>  include/net/page_pool.h                         |  50 +++++--
>  net/core/page_pool.c                            | 172 ++++++++++++++++++++----
>  9 files changed, 266 insertions(+), 54 deletions(-)
>
> --
> 2.7.4
>

For mvpp2:

Tested-by: Matteo Croce <mcroce@microsoft.com>

-- 
per aspera ad upstream
