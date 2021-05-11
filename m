Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D725937A92A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 16:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhEKO1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 10:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhEKO1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 10:27:19 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F31CC06174A
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:26:13 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id v39so26556935ybd.4
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CEaJC4cb5Y4A+8IsZZEeBM2QdsYN5Y7DFCllFllvi+8=;
        b=zHX1LMvKjHtyR4sV+y0aqvfoFcsp0EjIHx5Pt5zG+iVHvcxKYTo3vrUGTaAWwd8n54
         Sfqn8OV7GElBxhfBXlUssjujJWtAC4qSGRQRUdjhpxxfIF/QhMZuc4qpQhRqMR2wxO35
         PUJFZ124qF2EtUdMTmUBpVLFUQUtq2V0+5HEOB02MRwMRFtF2H0ypRhbY9hAsMcY5VaX
         NMWRowJcerYr/hEpfCDq56QNJVhvrpZzyFRgGaLU7Od2GT34GNf6kMsyWrhX+phrvlrk
         he7jEFsGAUZVNd7E0mAorNTJN4vbw3juF/pR8H2tEAQ/4MVq5x3yPsBcSeKS4v/uiUHB
         uX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CEaJC4cb5Y4A+8IsZZEeBM2QdsYN5Y7DFCllFllvi+8=;
        b=qPMVzx3kSN6OXv/a6vanRjPnQiLwoOXIPD4zroXAO56KY3UdREouwCojoAU/dmsJaM
         C4EQB+CA3YlWsqBaQWo3qsPRnyPQYaHP6AJpDiIo/OuGO57X1y/2oWVR+ezzhg9+RP09
         VcxlNqZdy2CKrPtBJO8V+vt/tEBCksPaC0LjimxM5IOVn4oHNr/yu/qWYwjtfaOie6SH
         O/RlQv9EnLwdE9I+Gx3G4kxmtJjW9JaJdqTi1IFQzVSZ+Fg4k8ucmHspR2EhShC29DsE
         EEtzcvXe4ueYKBtqs3UDzatClcblcCiniYOulZE5bxf88F95DS+hunJ9Z6zrCKinhiFJ
         rr1w==
X-Gm-Message-State: AOAM533eSuWhsftRKCG31WgioHwF1/XxGiCjgRp4icpa5uX07v2GD5P5
        r2T6BYV674K/xQKHm1AXO52XXz01cInVCkRlX6gLkBOHz/FwJA==
X-Google-Smtp-Source: ABdhPJzh4VjKqBeHWbxCHf0TChJFitLGXDaA/GUpbzyFXfVL/53v7XHycwNEzDPWQyzljYzsrL3I6khv5C0KKCJRTSQ=
X-Received: by 2002:a25:d0cb:: with SMTP id h194mr28426645ybg.408.1620743172546;
 Tue, 11 May 2021 07:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com> <YJqKfNh6l3yY2daM@casper.infradead.org>
 <YJqQgYSWH2qan1GS@apalos.home> <YJqSM79sOk1PRFPT@casper.infradead.org>
In-Reply-To: <YJqSM79sOk1PRFPT@casper.infradead.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 11 May 2021 17:25:36 +0300
Message-ID: <CAC_iWj+Tw9DzzzVj-F9AwzBN_OJV_HN2miJT4KTBH_Uei_V2ZA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
To:     Matthew Wilcox <willy@infradead.org>
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
        Michel Lespinasse <walken@google.com>,
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
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 May 2021 at 17:19, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, May 11, 2021 at 05:11:13PM +0300, Ilias Apalodimas wrote:
> > Hi Matthew,
> >
> > On Tue, May 11, 2021 at 02:45:32PM +0100, Matthew Wilcox wrote:
> > > On Tue, May 11, 2021 at 03:31:15PM +0200, Matteo Croce wrote:
> > > > @@ -101,6 +101,7 @@ struct page {
> > > >                    * 32-bit architectures.
> > > >                    */
> > > >                   unsigned long dma_addr[2];
> > > > +                 unsigned long signature;
> > > >           };
> > > >           struct {        /* slab, slob and slub */
> > > >                   union {
> > >
> > > No.  Signature now aliases with page->mapping, which is going to go
> > > badly wrong for drivers which map this page into userspace.
> > >
> > > I had this as:
> > >
> > > +                       unsigned long pp_magic;
> > > +                       unsigned long xmi;
> > > +                       unsigned long _pp_mapping_pad;
> > >                         unsigned long dma_addr[2];
> > >
> > > and pp_magic needs to be set to something with bits 0&1 clear and
> > > clearly isn't a pointer.  I went with POISON_POINTER_DELTA + 0x40.
> >
> > Regardless to the changes required, there's another thing we'd like your
> > opinion on.
> > There was a change wrt to the previous patchset. We used to store the
> > struct xdp_mem_info into page->private.  On the new version we store the
> > page_pool ptr address in page->private (there's an explanation why on the
> > mail thread, but the tl;dr is that we can get some more speed and keeping
> > xdp_mem_info is not that crucial). So since we can just store the page_pool
> > address directly, should we keep using page->private or it's better to
> > do:
> >
> > +                       unsigned long pp_magic;
> > +                       unsigned long pp_ptr;
> > +                       unsigned long _pp_mapping_pad;
> >                         unsigned long dma_addr[2];
> > and use pp_ptr?
>
> I'd rather you didn't use page_private ... Any reason not to use:
>
>                         unsigned long pp_magic;
>                         struct page_pool *pp;
>                         unsigned long _pp_mapping_pad;
>                         unsigned long dma_addr[2];
>
> ?

Nope not at all, either would work. we'll switch to that
