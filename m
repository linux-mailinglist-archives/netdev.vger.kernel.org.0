Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C8B363AEA
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 07:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhDSFM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 01:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDSFMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 01:12:55 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DF2C061761
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 22:12:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w23so35063600ejb.9
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 22:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ofWC35j+mTbhSxNhXaJK905wQN1NLDPBGPqQMOa3eQ=;
        b=IrctopW6n++Uebb9it23T0FZjRjZrOUlcZCKLPSu29QZNIiTLFO6vbTVHcjm67FoxX
         +XryZ6v1nnko8Qadw0FIa9a8U7bNDBNxOgjNi7XSRhViae4kcZDZhYqcDWBmd7Zf2t8I
         w+rz1dqBOXDSUqJCOi2L1S5u0gQFYtt3XFmat8ud+6GGdDXPJaPHYE2FE8KpFg4Tzba/
         Y0rkksO8F/XkcMzyoqV2nJc2yT8dMRprLgJTK2weOql8Fwr+RM0WbsvbNi/LtbE8coA5
         MgeifV8B/ubDmAKV2xxhqdCCVOfYkDQVe+cicPvl4Z5zW+Nq/51LGZ79wC4JwaAI+WP3
         cLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8ofWC35j+mTbhSxNhXaJK905wQN1NLDPBGPqQMOa3eQ=;
        b=VLZSISBCnUvZ688zBJudyMCaRNxCkJQCuGv+TtXqZcnKpevc7npzlWUDZBYWX12v8F
         FY9CoQ9vKZB0LGX6xZgJdJEW1dmByQNLVXOTzlqkM4ypK4kj/RsR3EXstbMGB5r2xfls
         9WqneteR2iCJUl1r8sjjDtG9meoZxEPYBu6XgoZpObObhbHJxFm7UhZDlvo00hdJJFoR
         2NrtS1U4yUMOPAffFclRhMzUS+5Z/G48b4jnvgCkXAqH/Y9wcKj0HxIn7P1aLdBgY94k
         o8dLr7TDk8S2bzBRjJmh9JTMF7h8Q0y2bfLFcailChE0/8kZgZ6bzUBsLDEki9v1o9zV
         w1pg==
X-Gm-Message-State: AOAM530dQftop/N3p/8VLk2fD1AGfJx4oag6H5NqGSfJK6XZpsXDydMh
        kaoHdq1gMUqYi4zMfJtTPYxQGA==
X-Google-Smtp-Source: ABdhPJw+oqRM110gHJFTVOQMCmNMJ31CDRgfffttfgzjSIimvIlDuXQkKo0zADVumPLs30SmZ9O6bQ==
X-Received: by 2002:a17:906:cb11:: with SMTP id lk17mr20356893ejb.517.1618809143641;
        Sun, 18 Apr 2021 22:12:23 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-88.home.otenet.gr. [94.65.92.88])
        by smtp.gmail.com with ESMTPSA id s5sm9541238ejq.52.2021.04.18.22.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 22:12:23 -0700 (PDT)
Date:   Mon, 19 Apr 2021 08:12:17 +0300
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
Message-ID: <YH0RMV7+56gVOzJe@apalos.home>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com>
 <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus>
 <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus>
 <20210414214132.74f721dd@carbon>
 <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 01:09:47PM -0700, Shakeel Butt wrote:
> On Wed, Apr 14, 2021 at 12:42 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> [...]
> > > >
> > > > Can this page_pool be used for TCP RX zerocopy? If yes then PageType
> > > > can not be used.
> > >
> > > Yes it can, since it's going to be used as your default allocator for
> > > payloads, which might end up on an SKB.
> >
> > I'm not sure we want or should "allow" page_pool be used for TCP RX
> > zerocopy.
> > For several reasons.
> >
> > (1) This implies mapping these pages page to userspace, which AFAIK
> > means using page->mapping and page->index members (right?).
> >
> 
> No, only page->_mapcount is used.
> 

I am not sure I like leaving out TCP RX zerocopy. Since we want driver to
adopt the recycling mechanism we should try preserving the current
functionality of the network stack.

The question is how does it work with the current drivers that already have an
internal page recycling mechanism.

> > (2) It feels wrong (security wise) to keep the DMA-mapping (for the
> > device) and also map this page into userspace.
> >
> 
> I think this is already the case i.e pages still DMA-mapped and also
> mapped into userspace.
> 
> > (3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
> > zerocopy will bump the refcnt, which means the page_pool will not
> > recycle the page when it see the elevated refcnt (it will instead
> > release its DMA-mapping).
> 
> Yes this is right but the userspace might have already consumed and
> unmapped the page before the driver considers to recycle the page.

Same question here. I'll have a closer look in a few days and make sure we are
not breaking anything wrt zerocopy.

> 
> >
> > (4) I remember vaguely that this code path for (TCP RX zerocopy) uses
> > page->private for tricks.  And our patch [3/5] use page->private for
> > storing xdp_mem_info.
> >
> > IMHO when the SKB travel into this TCP RX zerocopy code path, we should
> > call page_pool_release_page() to release its DMA-mapping.
> >
> 
> I will let TCP RX zerocopy experts respond to this but from my high
> level code inspection, I didn't see page->private usage.

Shakeel are you aware of any 'easy' way I can have rx zerocopy running?


Thanks!
/Ilias
