Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237253C6260
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhGLSK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhGLSK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 14:10:57 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127AAC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 11:08:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d12so26215750wre.13
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 11:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i6hQVPx+EWsErV36SN8DcoM1K7uuDP9qwuJ95kliV9o=;
        b=Lw4n++onOoSV9FKzYyWsw0MLXqGOzg1r0P8KtwpssCbT+WVi0+v7xtjysRltf3FHOQ
         w/gk/KS/RULvIeAGu69CKBqJC+4tZRBcVBgkKjTtRmQ4WZhKOvU/5IJmecpcnRp/3d7R
         hddgIU6qcSSGu4p986kNsnHUq4aUmugE2ifhp5aRCcc+4Vo8FBNdeunHuf8FBJ6Rkfha
         h9HHTIWxON4CXzhBepf1D2nyh89wo97V9eWzX/QU4wWCIn99/AiLKt8qxZbv6V4MByWK
         dnsDc9eb1yPGLI7VhPuGcMhdbnjHgxpipyCICkSiKRBmkZ3c/B4shABsOCPpaV/lOl3L
         PFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i6hQVPx+EWsErV36SN8DcoM1K7uuDP9qwuJ95kliV9o=;
        b=hiLC3SN9ckrlFK+3LX7mXOhf/XeCNLLuriNuhk52JXweys1IdDGDRF57nvC4QFgiY1
         IoLjHeTmlwhnSFHFuVpMqNbDHoYpokJ7BOQbJ5rW/UchV1AW+Sj+tGXG5qseQrsc9ar4
         h9nXGgzl3y0XdTvPHRM6WM+s3BWhgNLTmEbkCwz9X4xoyhMgUtkiMGIdKw02oB1bg1sU
         Z5wRBcLglhC/9sSRnoGaZDv7VppIvuhVskNBNPBJalraJbAHz/y2p7sHOQ9/pQdkh4YQ
         ssfpCDBeKkodM4PEHvE8s1Rp4L5slVrrIeP96wKttxVaMtxEZL/gLhGdnuUpFC1fTKjP
         f2gQ==
X-Gm-Message-State: AOAM533QOce4qQrPEaKuqBa0Ot8cDNBOwMa7tar7l3svhOUBWJTMSQNg
        SaqbJrTcXpxALqrM3hr1UBJWgw==
X-Google-Smtp-Source: ABdhPJyPH98FymxmjebpmtQJ8yqxAa2EiK7GzTfVWNSBbPGYsXlw0+Y3Gyv5pP0tZ1prnKSZ7UTDnA==
X-Received: by 2002:a5d:5989:: with SMTP id n9mr329096wri.8.1626113287568;
        Mon, 12 Jul 2021 11:08:07 -0700 (PDT)
Received: from enceladus (athedsl-417902.home.otenet.gr. [79.131.184.108])
        by smtp.gmail.com with ESMTPSA id w22sm171693wmc.4.2021.07.12.11.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 11:08:07 -0700 (PDT)
Date:   Mon, 12 Jul 2021 21:08:02 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>, brouer@redhat.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH rfc v3 2/4] page_pool: add interface for getting and
 setting pagecnt_bias
Message-ID: <YOyFAkahxxMKNeGb@enceladus>
References: <1626092196-44697-1-git-send-email-linyunsheng@huawei.com>
 <1626092196-44697-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf1W1H_0jK+zTDHdQnpa-dFSfcAtANqhPTJyZ21VeGmjg@mail.gmail.com>
 <2d9a3d29-8e6b-8462-c410-6b7fd4518c9d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9a3d29-8e6b-8462-c410-6b7fd4518c9d@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> > > +static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> > >   {
> > > +       if (WARN_ON(addr & ~PAGE_MASK))
> > > +               return false;
> > > +
> > >          page->dma_addr[0] = addr;
> > >          if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > >                  page->dma_addr[1] = upper_32_bits(addr);
> > > +
> > > +       return true;
> > > +}
> > > +
> > 
> > Rather than making this a part of the check here it might make more
> > sense to pull this out and perform the WARN_ON after the check for
> > dma_mapping_error.
> 
> I need to point out that I don't like WARN_ON and BUG_ON code in fast-path
> code, because compiler adds 'ud2' assembler instructions that influences the
> instruction-cache fetching in the CPU.  Yes, I have seen a measuresable
> impact from this before.
> 
> 
> > Also it occurs to me that we only really have to do this in the case
> > where dma_addr_t is larger than the size of a long. Otherwise we could
> > just have the code split things so that dma_addr[0] is the dma_addr
> > and dma_addr[1] is our pagecnt_bias value in which case we could
> > probably just skip the check.
> 
> The dance to get 64-bit DMA addr on 32-bit systems is rather ugly and
> confusing, sadly.  We could take advantage of this, I just hope this will
> not make it uglier.

Note here that we can only use this because dma_addr is not aliased to
compound page anymore (after the initial page_pool recycling patchset). 
We must keep this in mind if we even restructure struct page.

Can we do something more radical for this? The 64/32 bit dance is only
there for 32 bit systems with 64 bit dma.  Since the last time we asked
about this no one seemed to care about these, and I really doubt we'll get
an ethernet driver for them (that needs recycling....), can we *only* support 
frag allocation and recycling for 'normal' systems? We could always just r
e-purpose dma_addr[1] for those.

Regards
/Ilias

> 
> 
> > > +static inline int page_pool_get_pagecnt_bias(struct page *page)
> > > +{
> > > +       return READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK;
> > > +}
> > > +
> > > +static inline unsigned long *page_pool_pagecnt_bias_ptr(struct page *page)
> > > +{
> > > +       return page->dma_addr;
> > > +}
> > > +
> > > +static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
> > > +{
> > > +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
> > > +
> > > +       dma_addr_0 &= PAGE_MASK;
> > > +       dma_addr_0 |= bias;
> > > +
> > > +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
> > >   }
> > > 
> > >   static inline bool is_page_pool_compiled_in(void)
> > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > index 78838c6..1abefc6 100644
> > > --- a/net/core/page_pool.c
> > > +++ b/net/core/page_pool.c
> > > @@ -198,7 +198,13 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
> > >          if (dma_mapping_error(pool->p.dev, dma))
> > >                  return false;
> > > 
> > 
> > So instead of adding to the function below you could just add your
> > WARN_ON check here with the unmapping call.
> > 
> > > -       page_pool_set_dma_addr(page, dma);
> > > +       if (unlikely(!page_pool_set_dma_addr(page, dma))) {
> > > +               dma_unmap_page_attrs(pool->p.dev, dma,
> > > +                                    PAGE_SIZE << pool->p.order,
> > > +                                    pool->p.dma_dir,
> > > +                                    DMA_ATTR_SKIP_CPU_SYNC);
> > > +               return false;
> > > +       }
> > > 
> > >          if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > >                  page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> > > --
> > > 2.7.4
> > > 
> > 
> 
