Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4466A36481F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhDSQWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbhDSQWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 12:22:39 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810DEC06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 09:22:09 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id j4so17386751lfp.0
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 09:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O961I/6SpeSlE/psbTVuCjUHNPMleqN4PCYNj9U2q7A=;
        b=QyCXioim+uvs6ZsZ5HXYH8805X6eZVpFOsRXDPDu0FhkLM2j9m+7VBhsbXtQ60iw90
         VG4CzcSNws5VKEnnaLwaE+Mla8FPUF4Ifo/aduTqVEEsqkEIHDsv7++Nb8PAs+zX9RJs
         l4FvqPnoAc6U8fzSYX23GNIlLVFESDEdeZw4ASgibwICAnAA31uQArRchuzLd7XpCmqY
         MplUe6zFqDWDRPswRq04ECp9Kdz+N7Fihf5+eX9D+hxKcWBqFD4iHE/tYp91Yr2laL1W
         4GCuRoeQb17je7gyDNL69BxZQAhg2z1g3kNu32/o4rF6quRGBe/h8EnLEcbHG1UhK1rf
         DaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O961I/6SpeSlE/psbTVuCjUHNPMleqN4PCYNj9U2q7A=;
        b=jBF5kRB7wSlktcbpt8cmB/qmcSW1pN4VhFIwWYmaeaqICnPxYBIkfjcOGrJAjC+hft
         98Zp3hQImqdzLXcgFp39A2YJzoTCNdYVzNKIoZu7XPrlt9MIVhWHOvCOqlXTpeBfBQzl
         DKQP3y8UI5IJr1TZhM7sz3Qjn+QTxq6J+iQ4STT136n7OKfBeEpVq+t32H+fjZsMha9K
         HwkehyAoORnz0pRpYqPrrGSH7gJm1fDkGow3CAAesNIgKwgvXBu7bRRBz018S6Uo4Wu5
         LB8qkuIKH9sfHE0Qu1EZNDOW2LHBqbXhel7uyh808jwDgx52scD+E/ESShxdxiPF+GbT
         HKsA==
X-Gm-Message-State: AOAM533J9Y/iq0bwgn67Wo5CmQGLn+9rfWNR8tWkk5K6TTbdJrTW4lSm
        eoLw6krcqP3WoXxpGWZ2KFSa2FsY8+++SaETVzvNnA==
X-Google-Smtp-Source: ABdhPJyPLPorxRBakMjIU9mAt+YhIT0rjnyA4Jhv/b2TF9PoyD81mokL98bTTyiEHaEb8stXptpRF/697s3tntJvUOQ=
X-Received: by 2002:ac2:58d9:: with SMTP id u25mr3133485lfo.117.1618849327780;
 Mon, 19 Apr 2021 09:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com> <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus> <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus> <20210414214132.74f721dd@carbon>
 <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
 <YH0RMV7+56gVOzJe@apalos.home> <CALvZod7oa4q6pMUyDi4FMW4WKY7AjOZ7P2=02GoxjpwrQpA-OQ@mail.gmail.com>
 <YH2lFYbj3d8nC+hF@apalos.home>
In-Reply-To: <YH2lFYbj3d8nC+hF@apalos.home>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 19 Apr 2021 09:21:55 -0700
Message-ID: <CALvZod7oZ+7CNwSjqHs5XaLH9o_6+YYwEUeii5ETqeUwUTG6+Q@mail.gmail.com>
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

On Mon, Apr 19, 2021 at 8:43 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
[...]
> > Pages mapped into the userspace have their refcnt elevated, so the
> > page_ref_count() check by the drivers indicates to not reuse such
> > pages.
> >
>
> When tcp_zerocopy_receive() is invoked it will call tcp_zerocopy_vm_insert_batch()
> which will end up doing a get_page().
> What you are saying is that once the zerocopy is done though, skb_release_data()
> won't be called, but instead put_page() will be? If that's the case then we are
> indeed leaking DMA mappings and memory. That sounds weird though, since the
> refcnt will be one in that case (zerocopy will do +1/-1 once it's done), so who
> eventually frees the page?
> If kfree_skb() (or any wrapper that calls skb_release_data()) is called
> eventually, we'll end up properly recycling the page into our pool.
>

From what I understand (Eric, please correct me if I'm wrong) for
simple cases there are 3 page references taken. One by the driver,
second by skb and third by page table.

In tcp_zerocopy_receive(), tcp_zerocopy_vm_insert_batch() gets one
page ref through insert_page_into_pte_locked(). However before
returning from tcp_zerocopy_receive(), the skb references are dropped
through tcp_recv_skb(). So, whenever the user unmaps the page and
drops the page ref only then that page can be reused by the driver.

In my understanding, for zerocopy rx the skb_release_data() is called
on the pages while they are still mapped into the userspace. So,
skb_release_data() might not be the right place to recycle the page
for zerocopy. The email chain at [1] has some discussion on how to
bundle the recycling of pages with their lifetime.

[1] https://lore.kernel.org/linux-mm/20210316013003.25271-1-arjunroy.kdev@gmail.com/
