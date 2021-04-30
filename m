Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDCD36FF8D
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhD3Rdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3Rdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 13:33:32 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3880CC06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:32:44 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id g38so84106307ybi.12
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w28WRBH0pxau981XEZacM0SFQfgpPmWMOWl6GXZOO88=;
        b=kfJ5pYSRxCrK5Nv1bBw8qk3WW1/R6t3ZWXvwh2SCPInbHVO+J37aD4srPrqba1setk
         Cc61N7btKFWPhmutzj9hF8aspJhNZ7b8b54leYMnAN4XxlPdQ1XniKMMdMHrDbI0Ru1f
         37v6DU4S18qC8KiOVRJEMtO3wsYgc+KtADjBjo53d50pPRkIRp7Zy6yhQAvvOaj8RaGd
         xMsMvjv3ybgm3J5Z1XHt5EAb8hMqTzjUXuHk8332nfpk0IEGTcyfVHaOZDYuhRFxukhl
         C4F6fAi4lAnJyRbK3wBs57fY4cQjLNui2hOEyA6whg2dQv6lpl23OJLFh5iItymg3ks5
         PA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w28WRBH0pxau981XEZacM0SFQfgpPmWMOWl6GXZOO88=;
        b=AvdtQ/VmkfUZaaQcK8R9RsWCBlsl4YktqdUPvbgUcYOpVJrXOqSw83fEF6J6Xy/zuP
         MYeC8d1/xcW8uuqIhRZ7LcADKyishnp/GostiCsikU7HhTpl+4ZqCjL79JVKwvxRsxYG
         NS6lmunjFfgXZxIdaO2BXEvXgB+L9bsnTCJE+SLxBx5Yb2Yk4mbLJnI9azxLntJqf/Lh
         1n3xI/aT0iZVm+IRNJMRFTmn5MogQ062cTZMr+racCWhKzs3qyE6PlOM9+1YfJ8OyG1T
         t+EbJHbm0D4JUeaDSlBQbakd7nISUA9Y72zl55l1kbP/FzfmVpVK+i+fwnXozsE0+N6m
         TLFw==
X-Gm-Message-State: AOAM533WLejtVNJeymGWLOkpi43BC5huAtDQb0EbZZCice/csx7fO30B
        A0bmashEO4fgAw5rfRqA9KoBRW4uPytsPrIitG1oaiPVzaxKIg==
X-Google-Smtp-Source: ABdhPJwf0ba4S4CAR8YlNz7JkqPcbsCFRtXCKlAg7b5ghE/jYJhnWaG4CkTeyEP02aqCI06O8itXJGcSbVdNnpOLHlI=
X-Received: by 2002:a25:3c3:: with SMTP id 186mr8860593ybd.408.1619803963458;
 Fri, 30 Apr 2021 10:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com> <YIsAIzecktXXBlxn@apalos.home>
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com> <YIwvI5/ygBvZG5sy@apalos.home>
In-Reply-To: <YIwvI5/ygBvZG5sy@apalos.home>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 30 Apr 2021 20:32:07 +0300
Message-ID: <CAC_iWj+wkjcGjwbVqEFXFyUi_zgn4-uYhQKKHKk84jkgo1sxRw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        Networking <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
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
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(-cc invalid emails)
Replying to my self here but....

[...]
> > >
> > > We can't do that. The reason we need those structs is that we rely on the
> > > existing XDP code, which already recycles it's buffers, to enable
> > > recycling.  Since we allocate a page per packet when using page_pool for a
> > > driver , the same ideas apply to an SKB and XDP frame. We just recycle the
> >
> > I am not really familar with XDP here, but a packet from hw is either a
> > "struct xdp_frame/xdp_buff" for XDP or a "struct sk_buff" for TCP/IP stack,
> > a packet can not be both "struct xdp_frame/xdp_buff" and "struct sk_buff" at
> > the same time, right?
> >
>
> Yes, but the payload is irrelevant in both cases and that's what we use
> page_pool for.  You can't use this patchset unless your driver usues
> build_skb().  So in both cases you just allocate memory for the payload and
> decide what the wrap the buffer with (XDP or SKB) later.
>
> > What does not really make sense to me is that the page has to be from page
> > pool when a skb's frag page can be recycled, right? If it is ture, the switch
> > case in __xdp_return() does not really make sense for skb recycling, why go
> > all the trouble of checking the mem->type and mem->id to find the page_pool
> > pointer when recyclable page for skb can only be from page pool?
>
> In any case you need to find in which pool the buffer you try to recycle
> belongs.  In order to make the whole idea generic and be able to recycle skb
> fragments instead of just the skb head you need to store some information on
> struct page.  That's the fundamental difference of this patchset compared to
> the RFC we sent a few years back [1] which was just storing information on the
> skb.  The way this is done on the current patchset is that we store the
> struct xdp_mem_info in page->private and then look it up on xdp_return().
>
> Now that being said Matthew recently reworked struct page, so we could see if
> we can store the page pool pointer directly instead of the struct
> xdp_mem_info. That would allow us to call into page pool functions directly.
> But we'll have to agree if that makes sense to go into struct page to begin
> with and make sure the pointer is still valid when we take the recycling path.
>

Thinking more about it the reason that prevented us from storing a
page pool pointer directly is not there anymore. Jesper fixed that
already a while back. So we might as well store the page_pool ptr in
page->private and call into the functions directly.  I'll have a look
before v4.

[...]

Thanks
/Ilias
