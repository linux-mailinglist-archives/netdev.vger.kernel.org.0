Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4809E100F80
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKRXnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:43:45 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:35142 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfKRXno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 18:43:44 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so17801191ilp.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 15:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zRnfBdTfE/nfuvT6GB9rlhOdKHQ1++zdEQ1/d8fVARU=;
        b=c+33XjF53D2q4hNgD4/VhBmj+SSMcIrlCaxPhXFL+XZpXcjhc751XQVJ3TjiZpFifa
         KWIFyoWC1cmIXpeXN2Bdo4B04CauNnULLwkloRQaMF5bQDcqztB9F1vOj6ehgoEpTGGV
         oBEqaG1cUwHgzKtbIce/t/k2jKO2TIShxyoIAb4JzlbuPYBHXFlaMjrmszvJDSERyKHT
         CUEhBGC9BSRPXStH6hx/pu8pWnKTDrfIlRh585Lh0ODobG0yVvJiB/W9jdw9Y9Wk6f9n
         kfBWQVAzhPgj/AO1wJftDQVF4eSjXwi3H3Uxv/831accaVjkKsI1m3r7b4hy5e0ttM6M
         o6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zRnfBdTfE/nfuvT6GB9rlhOdKHQ1++zdEQ1/d8fVARU=;
        b=MlUk9/X3V1eRVVxUxjm0yGzL1QW0VmfPJl4730y30CrmcxqLYowpsAmCxABUptw9V7
         PO2/iFlsVO6G4fsJyEy1DQI7P1KfUcMokDqoOqyJbMhyl27EoV2aOzmozRXT+fb79A2F
         g/cWoOFtweHevAZZ6dMbVRNFM4ctT7///F7geS/Gxw3z1lRWCmkYA6RHNiLknyqcdyLm
         TbY3QGOQaIw9m/xLFewgMcwEVDZgOD8B2qYqRN2YcMeZ+h97Wrofc2GjCkuSoMcvdCFf
         6rhdgyEnSGddsLZSqcdaaKYMZ4asAgKHBoGU+oBGSAI8RJBjfABSjenS3DGzxwki5t75
         fzTA==
X-Gm-Message-State: APjAAAUPxIwzJOaMj0APc/ewMesRWfZLcpe7WKyUCwIZSuni97bDI1x6
        BrNb9Oxpx2qUBWj59oDHRn9MOfemYDgvdFKAfF+MqYxOODo=
X-Google-Smtp-Source: APXvYqyAGPrt+aiOf9v8W9j5qClDUFtmxJS0tclMvoTgC59BFe1ME+3zm5keWwPcwGhmqUdCksl6GQ5g97ToZ5/PQ54=
X-Received: by 2002:a92:902:: with SMTP id y2mr17020428ilg.284.1574120623518;
 Mon, 18 Nov 2019 15:43:43 -0800 (PST)
MIME-Version: 1.0
References: <20191118223630.7468-1-adisuresh@google.com> <20191118151927.14b103b0@cakuba.netronome.com>
In-Reply-To: <20191118151927.14b103b0@cakuba.netronome.com>
From:   Adi Suresh <adisuresh@google.com>
Date:   Mon, 18 Nov 2019 15:43:32 -0800
Message-ID: <CAHOA=qyWOz+2FK3F7W_eL2geALXo8s49Zjq9z6O+dwheq8jf5g@mail.gmail.com>
Subject: Re: [PATCH net] gve: fix dma sync bug where not all pages synced
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 3:19 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 18 Nov 2019 14:36:30 -0800, Adi Suresh wrote:
> > The previous commit "Fixes DMA synchronization" had a bug where the
>
> Please use the standard way of quoting commits.
>
> > last page in the memory range could not be synced. This change fixes
> > the behavior so that all the required pages are synced.
> >
>
> Please add a Fixes tag.
>
> > Signed-off-by: Adi Suresh <adisuresh@google.com>
> > Reviewed-by: Catherine Sullivan <csully@google.com>
> > ---
> >  drivers/net/ethernet/google/gve/gve_tx.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> > index 0a9a7ee2a866..89271380bbfd 100644
> > --- a/drivers/net/ethernet/google/gve/gve_tx.c
> > +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> > @@ -393,12 +393,12 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
> >  static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
> >                                   u64 iov_offset, u64 iov_len)
> >  {
> > -     dma_addr_t dma;
> > -     u64 addr;
> > +     u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
> > +     u64 first_page = iov_offset / PAGE_SIZE;
> > +     u64 page;
> >
> > -     for (addr = iov_offset; addr < iov_offset + iov_len;
> > -          addr += PAGE_SIZE) {
> > -             dma = page_buses[addr / PAGE_SIZE];
> > +     for (page = first_page; page <= last_page; page++) {
> > +             dma_addr_t dma = page_buses[page];
>
> Empty line after variable declaration. Perhaps keep the dma declaration
> outside the loop, since this is a fix the smaller the better.
>
> >               dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
> >       }
> >  }
>

Comments Addressed in v2
