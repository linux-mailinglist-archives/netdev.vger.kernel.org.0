Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F82E35FC57
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhDNUKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhDNUKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:10:23 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7117AC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:10:00 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u4so24612645ljo.6
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MwY/uAWZw4+Qy6L6BtNeYzKjt04mgG0Fmf5rVKjnxzQ=;
        b=ap3ig7KYnUhag1Gtyu8ju+wZN22X7hJAeGqlif08J6E2FDFZMStFf0J+i5MbXtUumS
         IzvuAZFclh341ng8JxtdEr2qW9XrlIZXWpjDZb+qgeWbwxE6vWjjGEB/geNPjXxIQclW
         dFI4IOTCs3fPKR1aHOm/iysJwoR+8kqUtA8mHyxoGySRQcfS+VCb+rZZM7/xiyt/HPID
         YrSMrjX8rYbjzs5DbiCl29ZXCTZgvVac75YJkITMzGqfEU5saeopAsgC9TvzTPv5274g
         cWQSom8PzYIEavCa1VDFHlyvioElMYcPnc9kDFdKK4GiYGWLDyOfnxPxwWSmPE8IQGU+
         dUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MwY/uAWZw4+Qy6L6BtNeYzKjt04mgG0Fmf5rVKjnxzQ=;
        b=Bwo5rKWyEyrZ8qBUP7GAuoIolbCmQWC5jmGJbqy4dsgJnpwYK7g+vyqn9DHJ/j5u9Q
         F1+DNoKktNBualhnw4Hf+KWdyywDLt7Zg77a1D2BTb+qIB4LNcxZ+t/bdRrb1aPExngJ
         usyge5LmF9nZqcy/tErIG4proUxiBOTAklAc4/pXjVouzc7mnr53ld5NScJUEfPxiI5V
         qvfyzpWWwf5Mx/dXO6FcVtyokIEprGyDdfXPFoTI2guFvm9rU/qD5/Mf6TEMFewbInvW
         zv6lldWuoJsltz5UWawTDxsjiwS139LceDz4RBd2OP7DyUyPDqjvojlclA3MJL8U+sQA
         NxyA==
X-Gm-Message-State: AOAM5337jWY35P5ilh2tHtEloOd2ogvw6pCu420tTzlhPsH86k3hl3XO
        GsetwNi6MLhhORsGTFHVJTQOUhfokw7/tUosEgtK6g==
X-Google-Smtp-Source: ABdhPJyGzh1aNLsj+H9I9o7DUJdlV5HTtBeAeDM8vjbeZYpt4QAwg2dIXYbLUIkqdF+ZPGeN9DUBYbygk+wOkt8Am2g=
X-Received: by 2002:a2e:8084:: with SMTP id i4mr25644098ljg.122.1618430998695;
 Wed, 14 Apr 2021 13:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com> <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus> <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus> <20210414214132.74f721dd@carbon>
In-Reply-To: <20210414214132.74f721dd@carbon>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 14 Apr 2021 13:09:47 -0700
Message-ID: <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/5] mm: add a signature in struct page
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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

On Wed, Apr 14, 2021 at 12:42 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
[...]
> > >
> > > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > > can not be used.
> >
> > Yes it can, since it's going to be used as your default allocator for
> > payloads, which might end up on an SKB.
>
> I'm not sure we want or should "allow" page_pool be used for TCP RX
> zerocopy.
> For several reasons.
>
> (1) This implies mapping these pages page to userspace, which AFAIK
> means using page->mapping and page->index members (right?).
>

No, only page->_mapcount is used.

> (2) It feels wrong (security wise) to keep the DMA-mapping (for the
> device) and also map this page into userspace.
>

I think this is already the case i.e pages still DMA-mapped and also
mapped into userspace.

> (3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
> zerocopy will bump the refcnt, which means the page_pool will not
> recycle the page when it see the elevated refcnt (it will instead
> release its DMA-mapping).

Yes this is right but the userspace might have already consumed and
unmapped the page before the driver considers to recycle the page.

>
> (4) I remember vaguely that this code path for (TCP RX zerocopy) uses
> page->private for tricks.  And our patch [3/5] use page->private for
> storing xdp_mem_info.
>
> IMHO when the SKB travel into this TCP RX zerocopy code path, we should
> call page_pool_release_page() to release its DMA-mapping.
>

I will let TCP RX zerocopy experts respond to this but from my high
level code inspection, I didn't see page->private usage.
