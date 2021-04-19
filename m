Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347C73649F6
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 20:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbhDSSln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 14:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbhDSSlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 14:41:40 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E602C06138A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 11:41:10 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id u17so54521363ejk.2
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 11:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3TXXauaxjaFJkryZmKe4pKXsqt2c2W4efv7xXXt6kDg=;
        b=K9U3Wsn/ZMp1qcVYmH8K49eGtKmxmMFJSG/7TwpdB++O51Bvwx+tGQzCMd2HWtCCCj
         XkCNqHebmllrUDYH703DvaCBFIWgSQv6LE4Cbcf2HP99jSESzpqew5uPUVaK2069tqYj
         tZYbGjtxJ2VsQp+eM/Xqdg32vwrRUqYHp41rtvTo2tv49YUNJF97ZV4gpkqaEDa1JKZL
         Z6YVtkJSH7bYpmUle6fdm8FVq4JLc6chNiBFVgFpOGNZ+D9JgQikxIFy4njTKnuu92mH
         pS/DzlQqFeg0jYG6YLidrAmH1WKQgCm7dvMcSnuxGhhjUn59EuYG3vW+H+LmrqEFQqyA
         83cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3TXXauaxjaFJkryZmKe4pKXsqt2c2W4efv7xXXt6kDg=;
        b=Q2DGTeztNl9L1xCanrhzbxsC6rkK96K1aroJFpb1lCwtI5rkj5JTMGiWPWazxItgnS
         lpa1MpqOcyZt3EI5W22tamPnUsnMndRHQ24j3kCQ6LoUCVBytrPJkj/sO/dbqZJomaqQ
         KFmivRg7sIXPDnxfQ1nMF2SQfag2A5j+Kz4lFaNamMgYQADuXZe0F0g3dx+Q7B9QsdST
         XbtZiWmMbvaSYCOhQ/9Odh6LrQxGeH1DKW0Qsb7RpPPm14msXT0POZsqNGXIR5MlHtpW
         OA0SNO95aQCBI+4dSUJMGu0vaiF4lm2QT5Di67j603dVTZ/y8gd3wQduL8fR0Az4iaIV
         /Eow==
X-Gm-Message-State: AOAM5330YNZEprUE+cH+20vWuymCkzlMh18BLzWH90D0szMt6Q5Nn9KZ
        LymfeNVfD58oXmOj2l3Y5sb5Rw==
X-Google-Smtp-Source: ABdhPJycOdUR+CwuNkAlnUJFFot68MXH4HjBcF7ZhZklGQLGYR6WexKascVTMUkGkR7LHMZEQK+/Ig==
X-Received: by 2002:a17:906:6896:: with SMTP id n22mr23676314ejr.316.1618857669049;
        Mon, 19 Apr 2021 11:41:09 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-88.home.otenet.gr. [94.65.92.88])
        by smtp.gmail.com with ESMTPSA id l6sm5233811ejc.92.2021.04.19.11.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 11:41:08 -0700 (PDT)
Date:   Mon, 19 Apr 2021 21:41:02 +0300
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
Message-ID: <YH3OvqpYQ0WeFpxy@apalos.home>
References: <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus>
 <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus>
 <20210414214132.74f721dd@carbon>
 <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
 <YH0RMV7+56gVOzJe@apalos.home>
 <CALvZod7oa4q6pMUyDi4FMW4WKY7AjOZ7P2=02GoxjpwrQpA-OQ@mail.gmail.com>
 <YH2lFYbj3d8nC+hF@apalos.home>
 <CALvZod7oZ+7CNwSjqHs5XaLH9o_6+YYwEUeii5ETqeUwUTG6+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod7oZ+7CNwSjqHs5XaLH9o_6+YYwEUeii5ETqeUwUTG6+Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 09:21:55AM -0700, Shakeel Butt wrote:
> On Mon, Apr 19, 2021 at 8:43 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> [...]
> > > Pages mapped into the userspace have their refcnt elevated, so the
> > > page_ref_count() check by the drivers indicates to not reuse such
> > > pages.
> > >
> >
> > When tcp_zerocopy_receive() is invoked it will call tcp_zerocopy_vm_insert_batch()
> > which will end up doing a get_page().
> > What you are saying is that once the zerocopy is done though, skb_release_data()
> > won't be called, but instead put_page() will be? If that's the case then we are
> > indeed leaking DMA mappings and memory. That sounds weird though, since the
> > refcnt will be one in that case (zerocopy will do +1/-1 once it's done), so who
> > eventually frees the page?
> > If kfree_skb() (or any wrapper that calls skb_release_data()) is called
> > eventually, we'll end up properly recycling the page into our pool.
> >
> 
> From what I understand (Eric, please correct me if I'm wrong) for
> simple cases there are 3 page references taken. One by the driver,
> second by skb and third by page table.
> 
> In tcp_zerocopy_receive(), tcp_zerocopy_vm_insert_batch() gets one
> page ref through insert_page_into_pte_locked(). However before
> returning from tcp_zerocopy_receive(), the skb references are dropped
> through tcp_recv_skb(). So, whenever the user unmaps the page and
> drops the page ref only then that page can be reused by the driver.
> 
> In my understanding, for zerocopy rx the skb_release_data() is called
> on the pages while they are still mapped into the userspace. So,
> skb_release_data() might not be the right place to recycle the page
> for zerocopy. The email chain at [1] has some discussion on how to
> bundle the recycling of pages with their lifetime.
> 
> [1] https://lore.kernel.org/linux-mm/20210316013003.25271-1-arjunroy.kdev@gmail.com/

Ah right, you mentioned the same email before and I completely forgot about
it! In the past we had thoughts of 'stealing' the page on put_page instead of 
skb_release_data().  We were afraid that this would cause a measurable 
performance hit, so we tried to limit it within the skb lifecycle.

However I don't think this will be a problem.  Assuming we are right here and 
skb_release_data() is called while the userspace holds an extra reference from
the mapping here's what will happen:

skb_release_data() -> skb_free_head() -> page_pool_return_skb_page() ->
set_page_private() -> xdp_return_skb_frame() -> __xdp_return() -> 
page_pool_put_full_page() -> page_pool_put_page() -> __page_pool_put_page()

When we call __page_pool_put_page(), the refcnt will be != 1 (because a user
mapping is still active), so we won't try to recycle it. Instead we'll remove 
the DMA mappings and decrease the refcnt.

So although the recycling won't 'work', nothing bad will happen (famous last
words).

In any case, I'll double check with the test you pointed out before v4.

Thanks!
/Ilias
