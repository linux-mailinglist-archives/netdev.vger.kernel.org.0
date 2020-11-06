Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AC02A9E73
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgKFUL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbgKFULZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:11:25 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7E7C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 12:11:24 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 7so3636009ejm.0
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 12:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YDFZqpXEdgg/LnYYKasgHDLsJ1VHzwVZvGtXI67AvaQ=;
        b=G5k0u1nNzSFnUNqTsUFN+hfKOVjUzRCng2nUjIPSuQl+DoynzGsSi8S533jv0wkdMn
         MaUSbVb0Fw/bNAj6+9Llj5VRUQLcuVzRFI2gPrnhZrthdV5rbDdU2fwx90tv8/dGaoCN
         R3SMMQy6Q4kLLBaAsiOKlMFILfY7KMTm1LumW42aAtHWdPVeS4d/QOXN1Mle2BrmNNMH
         KYmuFARxud9K80GOA3M4G1olnxPzL2rfdO/E6SCw2SfXnbpVuQ84jQ+Vs7lAtjqpnvmq
         imWpmPcfbiAuWLQaehukOTAlLyYziIqdL9JnqRuaNBip5s4nT7S9+K6D/2FxZTywpP3+
         NACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YDFZqpXEdgg/LnYYKasgHDLsJ1VHzwVZvGtXI67AvaQ=;
        b=pUKxsJqh+PI5bc+aWfciYR0ijY759fHRikAafd0U/BMmUaKSyEeJB6D8qYBdtEu2ov
         fhy/rnej5Eh+nO4baaaQj+ZUDa5f8CXPkRwiTJrOS1/z02DfsUTFuDOyeYOR+pU9LOhx
         gUjBZ/fpCVKy7SEQEKDLmxmJXmFHKnSqDI+zMGWVIomdofBSkYmMURyK6yYDpv8kQ7JL
         61awVQeHnJ9oP5BY93r44UcUZV86NHRl/yZixje1X5NclwVkY91XoL4vSPZy8FhgasPw
         mfDpu8NxhSISF+LM/LakRhXX0PQu9amy475vMtbBbYMbcOZtXKBQ5VA7dLAnhkeMMab+
         JTdw==
X-Gm-Message-State: AOAM533jR33S7hmBAFEzl0iurHivjNuCbWQ4vbdxvHlfjPgP80M0K2t2
        d8GC8bkI4uv/9+gl8QKxIxoBL0BRRBCdzttUZamHsSOUjL8=
X-Google-Smtp-Source: ABdhPJy5Y7vJbnD1HfGnKvp18Fq/t1sRhl1v3rPDY5L0siGY0qEY8pvpXit80wmEXnuhJ4CJBHpd9plJil5bOPLTy5o=
X-Received: by 2002:a17:906:5fd0:: with SMTP id k16mr3862257ejv.133.1604693482621;
 Fri, 06 Nov 2020 12:11:22 -0800 (PST)
MIME-Version: 1.0
References: <20201103174651.590586-1-awogbemila@google.com>
 <20201103174651.590586-3-awogbemila@google.com> <5c28ff0dbee9895665082fc2cfb59c15dc905322.camel@kernel.org>
In-Reply-To: <5c28ff0dbee9895665082fc2cfb59c15dc905322.camel@kernel.org>
From:   David Awogbemila <awogbemila@google.com>
Date:   Fri, 6 Nov 2020 12:11:11 -0800
Message-ID: <CAL9ddJdhMET3AJJ16eEMbJcCwCWH1a6b7njmA8xnu=obx2tadQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] gve: Add support for raw addressing to the rx path
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 3:19 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> > From: Catherine Sullivan <csully@google.com>
> >
> > Add support to use raw dma addresses in the rx path. Due to this new
> > support we can alloc a new buffer instead of making a copy.
> >
> > RX buffers are handed to the networking stack and are
> > re-allocated as needed, avoiding the need to use
> > skb_copy_to_linear_data() as in "qpl" mode.
> >
> > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > Signed-off-by: Catherine Sullivan <csully@google.com>
> > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > ---
> >  drivers/net/ethernet/google/gve/gve.h        |   9 +-
> >  drivers/net/ethernet/google/gve/gve_adminq.c |  14 +-
> >  drivers/net/ethernet/google/gve/gve_desc.h   |  10 +-
> >  drivers/net/ethernet/google/gve/gve_main.c   |   3 +-
> >  drivers/net/ethernet/google/gve/gve_rx.c     | 220 +++++++++++++++
> > ----
> >  5 files changed, 203 insertions(+), 53 deletions(-)
> >
>
> ...
>
> >  static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
> >  {
> > -     return priv->rx_cfg.num_queues;
> > +     if (priv->raw_addressing)
> > +             return 0;
> > +     else
> > +             return priv->rx_cfg.num_queues;
>
> else statement is redundant.
Thanks, I'll take the else statement away.
>
>
> >
> >  static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
> >  {
> >       struct gve_priv *priv = rx->gve;
> >       u32 slots;
> > +     int err;
> >       int i;
> >
> >       /* Allocate one page per Rx queue slot. Each page is split into
> > two
> > @@ -71,12 +96,31 @@ static int gve_prefill_rx_pages(struct
> > gve_rx_ring *rx)
> >       if (!rx->data.page_info)
> >               return -ENOMEM;
> >
> > -     rx->data.qpl = gve_assign_rx_qpl(priv);
> > -
> > +     if (!rx->data.raw_addressing)
> > +             rx->data.qpl = gve_assign_rx_qpl(priv);
> >       for (i = 0; i < slots; i++) {
> > -             struct page *page = rx->data.qpl->pages[i];
> > -             dma_addr_t addr = i * PAGE_SIZE;
> > +             struct page *page;
> > +             dma_addr_t addr;
> > +
> > +             if (rx->data.raw_addressing) {
> > +                     err = gve_alloc_page(priv, &priv->pdev->dev,
> > &page,
> > +                                          &addr, DMA_FROM_DEVICE);
> > +                     if (err) {
> > +                             int j;
> >
>
> the code is skewed right, 5 level indentation is a lot.
> you can just goto alloc_err; and handle the rewind on the exit path of
> the function .
>
> BTW you could split this loop to two independent flows if you utilize
> gve_rx_alloc_buffer()
>
> if (!raw_Addressing) {
>         page = rx->data.qpl->pages[i];
>         addr = i * PAGE_SIZE;
>         gve_setup_rx_buffer(...);
>         continue;
> }
>
> /* raw addressing mode */
> err = gve_rx_alloc_buffer(...);
> if (err)
>       goto alloc_err;
>

Thanks, I'll eliminate the skew andI'll take the suggestion to
separate the independent flows.
