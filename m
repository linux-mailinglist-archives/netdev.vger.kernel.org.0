Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE3D3F7B81
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbhHYRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhHYRZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:25:32 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6D2C0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:24:46 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id a93so420055ybi.1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hxzd8O3VlCz6kAL/KkQZYZdKqB4hI56gVYyGD+e43I=;
        b=qfIar4g3sZ36toPxiA2u9pWqR1Z+yBhgQWLbZAD7jiEoGrFXST+WnZ5iiZKuKaDmXX
         qC8sgxtAde0Q7/n/eBAxZ7sTeZvHsf3qxx+o0SWD7KXWgi/XGOhjIBGj2e9q0kr3eyij
         ZN3Q8QeSPDmvi8FYdecJh1FkJoIA2AHILSIZat87h4EeI/uPpK258s/3d64/wtydBu9B
         NrrWM/3G2XA9fkB62qrhCK19es2DDQoDE8euOvh8gukl890eBZPEBj9bmLLldfoPWZOd
         arpVK1EpOgYeWhIao+qA8L5PTMeeIaDCP4NwLaYfliQ67BBI4rcaKOclpdYN7yW3kv04
         ZOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hxzd8O3VlCz6kAL/KkQZYZdKqB4hI56gVYyGD+e43I=;
        b=A/Pt2v+ja3FLaK604eRdNCMA9oSTeQvbjh2cWWoc1K37QxPufLQEK63nNkLfByYl/i
         gMypP5OXwBahI4zZ5jAEuR2EMosA63oyhcwhZH5dXsM9Ljz6EaS6vLbc2kMXgdWmQHeX
         99zCFy4vdm4YirXedQ4iYfAZtmqlZ7obUxZWa+ejgz1G/BBDLIqqxqa5Lju6lThHDzEM
         DVwfDbuLL4LHHCzfacIoeNcYcYvX/B6lTOX/AjTAI1QSo+UE68KH3M2vDSnsnpwYpbNy
         TubSlnJ/Y08JrR55iP0b+93Jit/iefeWZiGnGiJLYZaI99CmdKjiP+mOMp9Oq68rjgDa
         mUXg==
X-Gm-Message-State: AOAM532q4gx8cDkUFyU1/5KIEl9ER/hteYYOKLr7O65HB93RvPM7ETQ/
        ROQ5Ky35Sl7LJLgMTGOLySZK56GMCaHofa75As58eg==
X-Google-Smtp-Source: ABdhPJzti3UMwG6MIVQx6Dc6zModS9Z/b3mfM9EsFhReXQhsE1W3U6jgcpmRgBZucvhDLyRoz0xBuESLDlxVuOQeSaU=
X-Received: by 2002:a25:2cd5:: with SMTP id s204mr11111254ybs.452.1629912285606;
 Wed, 25 Aug 2021 10:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <CANn89iJDf9uzSdqLEBeTeGB1uAxvmruKfK5HbeZWp+Cdc+qggQ@mail.gmail.com>
 <2cf4b672-d7dc-db3d-ce90-15b4e91c4005@huawei.com> <4b2ad6d4-8e3f-fea9-766e-2e7330750f84@huawei.com>
 <CANn89iK0nMG3qq226aL-urrtPF5jBN6UQCV=ckTmAFqWgy5kiA@mail.gmail.com>
 <5fdc5223-7d67-fed7-f691-185dcb2e3d80@gmail.com> <CANn89iKqijGU_0dQMeyMJ2h2MJE3=fLm8qb456G3ZD_7TrLt_A@mail.gmail.com>
 <2d2154f4-c735-a9b3-7940-f8830fee6229@gmail.com>
In-Reply-To: <2d2154f4-c735-a9b3-7940-f8830fee6229@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Aug 2021 10:24:34 -0700
Message-ID: <CANn89iLa4QnA-hOJVVrAZLZs-pLr66-K+fRjB9vTjqgz_aAmnA@mail.gmail.com>
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

On Wed, Aug 25, 2021 at 9:39 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/25/21 9:32 AM, Eric Dumazet wrote:

> >
>
> thanks for the pointer. I need to revisit my past attempt to get iperf3
> working with hugepages.

ANother pointer, just in case this helps.

commit 72653ae5303c626ca29fcbcbb8165a894a104adf
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Aug 20 10:11:17 2020 -0700

    selftests: net: tcp_mmap: Use huge pages in send path
