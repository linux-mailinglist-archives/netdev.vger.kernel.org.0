Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6583C1522
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhGHO1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhGHO1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 10:27:53 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3DBC061574;
        Thu,  8 Jul 2021 07:25:09 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id o5so9975128ejy.7;
        Thu, 08 Jul 2021 07:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVcN0wM8xi5hqe86WHfBCgjLM4Jp5TwV0EbNkATkMaY=;
        b=b3CwmjIGZBugzq9AGvSe2gt2J5LWLT9DNiAiOoU6vzMq2srVo+KfSOC9ITWqNgEQlh
         JuJuAE5UQXurnmgXjml/MPBKbikpcVZdK/jXeYjzuwfNi9H5fcjzYZIsLZhOexiKYqGB
         jDM8uB/O1Zwz/IjRrOSZkMgB8tgIRAe7e5GZ7fWzaYw1YsrVbcfj5WX7A1MqpcRFKwwf
         gF0hsEzlcOEgPfTH0KKxdQyT8rUBrrL5g1v85Z+XR2/YpAaq39Cw5XZP36cibkoiFz+9
         uRbzk9cBmRKWcdAKeca/1hWju2eTgnKViGlDnq8QRWZ2YBc/xR3ll4lXQzb0ruGVhf4Z
         4zpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVcN0wM8xi5hqe86WHfBCgjLM4Jp5TwV0EbNkATkMaY=;
        b=XdiQY2N/NUBz8au/c7XFGrJ7kKQp/dJ74KwaUPJGA/hc4VQVeXBvTaUHNj7U3VPRYJ
         DUPGqFJyZCbiHiuV87XHzIhQw7R//DqL0+jKBTbq3aNTvq5tONQ/llksVZx8RvoPjLXZ
         eGuPV0IhPD/jotT7P1h0sqVto9u60GEigNpAV5tBHbRIsozVNH1iGtlW7gizW8a3n7Tw
         WCA5CCSJlHeBjXoUnxbLw3og400d+KT93FyZlW4I89BJ9PctB5Vhc8DSGC0EJWDKw/rW
         OuRb4BfRQ8IobiRasStZ/k1QgbdsBgbLT128cpHYK6dzfPArQgiDIkgvpAzeU647MH+N
         7prg==
X-Gm-Message-State: AOAM530hFgDfNQp5Nlw7HU9pmFvw68cDhc3NvNqXuMU/ABq4wsIYuB4X
        YDwMF8H/68tFK6slVkLEXFHeiA8HgYsUxXrcSj8=
X-Google-Smtp-Source: ABdhPJzlA3nczm6KL9AMDKdtTeYaAAtptBrRppGf6lMgPFa0v0xxe9HQwajsEmpZbMKwVnEGx4KphMHR2aOi5an5vrc=
X-Received: by 2002:a17:907:97c3:: with SMTP id js3mr31981518ejc.114.1625754308378;
 Thu, 08 Jul 2021 07:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com> <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus> <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
 <YOcKASZ9Bp0/cz1d@enceladus>
In-Reply-To: <YOcKASZ9Bp0/cz1d@enceladus>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 8 Jul 2021 07:24:57 -0700
Message-ID: <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        hawk@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, mcroce@microsoft.com,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        cong.wang@bytedance.com, Kevin Hao <haokexin@gmail.com>,
        nogikh@google.com, Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 7:21 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> > > > >
>
> [...]
>
> > > > > The above expectation is based on that the last user will always
> > > > > call page_pool_put_full_page() in order to do the recycling or do
> > > > > the resource cleanup(dma unmaping..etc).
> > > > >
> > > > > As the skb_free_head() and skb_release_data() have both checked the
> > > > > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > > > > think we are safe for most case, the one case I am not so sure above
> > > > > is the rx zero copy, which seems to also bump up the refcnt before
> > > > > mapping the page to user space, we might need to ensure rx zero copy
> > > > > is not the last user of the page or if it is the last user, make sure
> > > > > it calls page_pool_put_full_page() too.
> > > >
> > > > Yes, but the skb->pp_recycle value is per skb, not per page. So my
> > > > concern is that carrying around that value can be problematic as there
> > > > are a number of possible cases where the pages might be
> > > > unintentionally recycled. All it would take is for a packet to get
> > > > cloned a few times and then somebody starts using pskb_expand_head and
> > > > you would have multiple cases, possibly simultaneously, of entities
> > > > trying to free the page. I just worry it opens us up to a number of
> > > > possible races.
> > >
> > > Maybe I missde something, but I thought the cloned SKBs would never trigger
> > > the recycling path, since they are protected by the atomic dataref check in
> > > skb_release_data(). What am I missing?
> >
> > Are you talking about the head frag? So normally a clone wouldn't
> > cause an issue because the head isn't changed. In the case of the
> > head_frag we should be safe since pskb_expand_head will just kmalloc
> > the new head and clears head_frag so it won't trigger
> > page_pool_return_skb_page on the head_frag since the dataref just goes
> > from 2 to 1.
> >
> > The problem is that pskb_expand_head memcopies the page frags over and
> > takes a reference on the pages. At that point you would have two skbs
> > both pointing to the same set of pages and each one ready to call
> > page_pool_return_skb_page on the pages at any time and possibly racing
> > with the other.
>
> Ok let me make sure I get the idea properly.
> When pskb_expand_head is called, the new dataref will be 1, but the
> head_frag will be set to 0, in which case the recycling code won't be
> called for that skb.
> So you are mostly worried about a race within the context of
> pskb_expand_skb() between copying the frags, releasing the previous head
> and preparing the new one (on a cloned skb)?

The race is between freeing the two skbs. So the original and the
clone w/ the expanded head will have separate instances of the page. I
am pretty certain there is a race if the two of them start trying to
free the page frags at the same time.

Thanks,

- Alex
