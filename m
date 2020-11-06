Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5062AA061
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgKFW1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgKFW1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:27:41 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8F0C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 14:27:41 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so4019717ejb.7
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 14:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cFbgjaGadII/SCJwwy078EPUvDRfBzWGG48hgwPqT98=;
        b=cuFpcSjNU3j0kuvKZzdsjw+JoL10DMGQU0MRlfjOFgTCmNtCINeSU4itPUV0j+3r7y
         Sdr5PhP3iMaGM0yAxArJJJts/Dvv1bNWQH7HpIZXpijOSz8KGpNYPU+7Gen36dteXW/3
         dvUuye010iqDjkKcGoQt9Iss0rVoVT17/apqeA6GKe3w7XDISzYNdXa2f0Hwax4K/8Fh
         czRpLs0Nz5500sOmlxmlXDkLfanX+tg/qt4Ahs01MMClG6ULZ6l3KjEBgW4hb3BKNLTr
         jKZ8Z+8Csds840horJWRZ/SYFZsRXChY1TarKWoEaen1cOxNcvJ98g4jupnXr87eGAS8
         xDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFbgjaGadII/SCJwwy078EPUvDRfBzWGG48hgwPqT98=;
        b=GWqJdpsVA6bE/9PJpKACFOBJZfbsAZNLDdz2uQpjaaeVMpK+rwL+6jSWFi5TC5XdiE
         ei8qE12lCgcWBGZZxdeNemN6TzeZFPvXipe3HsuNqe3h2v7FSSgttwVErZbeOJrEiFXn
         SxAaod70mLwE9S0t2U18YxvpRPzbvR3Y6N8PA+R8rEkZWxiqgWn/NdCPNajpNu+Tpzh6
         OrV0yta8j4v8dI/TWPY1gbQDS/iy0QDTaBWTZJey/8DN4EWk2V6z0yQSmcnSKTSGGaUM
         PZHE7XZnAgXocQq73wWYNxiEULMOVdgjvO5ns43WYWlB+YE+WTfic9KSXqBYu4k7yS4S
         SMpw==
X-Gm-Message-State: AOAM533SdYtB/J9AP7VfkSmc4T8j18cxlj/7aKrgZJ3dUWpicKeqUJ9E
        TnirVhRE0pgDutr0ZJYSGh0QVc3X+KMhbhUsCXMdwg==
X-Google-Smtp-Source: ABdhPJziDjbR38sVJ52h23wHSRE4zAshD+KkkIExoeu79CUQNNs02sfoCRhU4LmqQFQgjCKWdHmlunnqfU5nspg5GoA=
X-Received: by 2002:a17:906:70cf:: with SMTP id g15mr4153915ejk.323.1604701659753;
 Fri, 06 Nov 2020 14:27:39 -0800 (PST)
MIME-Version: 1.0
References: <20201103174651.590586-1-awogbemila@google.com>
 <20201103174651.590586-5-awogbemila@google.com> <62b6f6ffc874938072b914fbc9969dd437a9745e.camel@kernel.org>
In-Reply-To: <62b6f6ffc874938072b914fbc9969dd437a9745e.camel@kernel.org>
From:   David Awogbemila <awogbemila@google.com>
Date:   Fri, 6 Nov 2020 14:27:28 -0800
Message-ID: <CAL9ddJcdS1mUx2DW-T5Sje=JGFfJceHdoDnLKgpaHotRpgJQcg@mail.gmail.com>
Subject: Re: [PATCH 4/4] gve: Add support for raw addressing in the tx path
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 4:35 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> > From: Catherine Sullivan <csully@google.com>
> >
> > During TX, skbs' data addresses are dma_map'ed and passed to the NIC.
> > This means that the device can perform DMA directly from these
> > addresses
> > and the driver does not have to copy the buffer content into
> > pre-allocated buffers/qpls (as in qpl mode).
> >
> > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > Signed-off-by: Catherine Sullivan <csully@google.com>
> > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > ---
> >  drivers/net/ethernet/google/gve/gve.h        |  18 +-
> >  drivers/net/ethernet/google/gve/gve_adminq.c |   4 +-
> >  drivers/net/ethernet/google/gve/gve_desc.h   |   8 +-
> >  drivers/net/ethernet/google/gve/gve_tx.c     | 207 +++++++++++++++
> > ----
> >  4 files changed, 194 insertions(+), 43 deletions(-)
> >
>
> >  static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
> >  {
> > -     return priv->tx_cfg.num_queues;
> > +     if (priv->raw_addressing)
> > +             return 0;
> > +     else
> > +             return priv->tx_cfg.num_queues;
>
> redundant else statement.
Ok, I'll remove the else.

>
> >
> > -static void gve_dma_sync_for_device(struct device *dev, dma_addr_t
> > *page_buses,
> > +static void gve_dma_sync_for_device(struct gve_priv *priv,
> > +                                 dma_addr_t *page_buses,
> >                                   u64 iov_offset, u64 iov_len)
> >  {
> >       u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
> >       u64 first_page = iov_offset / PAGE_SIZE;
> > -     dma_addr_t dma;
> >       u64 page;
> >
> >       for (page = first_page; page <= last_page; page++) {
> > -             dma = page_buses[page];
> > -             dma_sync_single_for_device(dev, dma, PAGE_SIZE,
> > DMA_TO_DEVICE);
> > +             dma_addr_t dma = page_buses[page];
> > +
> > +             dma_sync_single_for_device(&priv->pdev->dev, dma,
> > PAGE_SIZE, DMA_TO_DEVICE);
>
> Why did you change the function params to pass priv here ?
> I don't see any valid reason.
Good point, I will revert this.

>
> ...
>
> >
> > -     gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
> > +     gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
> >                               info->iov[hdr_nfrags - 1].iov_offset,
> >                               info->iov[hdr_nfrags - 1].iov_len);
> >
> ...
>
> > -             gve_dma_sync_for_device(dev, tx->tx_fifo.qpl-
> > >page_buses,
> > +             gve_dma_sync_for_device(priv, tx->tx_fifo.qpl-
> > >page_buses,
> >                                       info->iov[i].iov_offset,
> >                                       info->iov[i].iov_len);
> >               copy_offset += info->iov[i].iov_len;
> > @@ -472,6 +499,98 @@ static int gve_tx_add_skb(struct gve_tx_ring
> > *tx, struct sk_buff *skb,
> >       return 1 + payload_nfrags;
> >  }
> >
> > +static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct
> > gve_tx_ring *tx,
> > +                               struct sk_buff *skb)
> > +{
> > +     const struct skb_shared_info *shinfo = skb_shinfo(skb);
> > +     int hlen, payload_nfrags, l4_hdr_offset, seg_idx_bias;
> > +     union gve_tx_desc *pkt_desc, *seg_desc;
> > +     struct gve_tx_buffer_state *info;
> > +     bool is_gso = skb_is_gso(skb);
> > +     u32 idx = tx->req & tx->mask;
> > +     struct gve_tx_dma_buf *buf;
> > +     int last_mapped = 0;
> > +     u64 addr;
> > +     u32 len;
> > +     int i;
> > +
> > +     info = &tx->info[idx];
> > +     pkt_desc = &tx->desc[idx];
> > +
> > +     l4_hdr_offset = skb_checksum_start_offset(skb);
> > +     /* If the skb is gso, then we want only up to the tcp header in
> > the first segment
> > +      * to efficiently replicate on each segment otherwise we want
> > the linear portion
> > +      * of the skb (which will contain the checksum because skb-
> > >csum_start and
> > +      * skb->csum_offset are given relative to skb->head) in the
> > first segment.
> > +      */
> > +     hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
> > +                     skb_headlen(skb);
> > +     len = skb_headlen(skb);
> > +
> > +     info->skb =  skb;
> > +
> > +     addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
> > +     if (unlikely(dma_mapping_error(tx->dev, addr))) {
> > +             priv->dma_mapping_error++;
> > +             goto drop;
> > +     }
> > +     buf = &info->buf;
> > +     dma_unmap_len_set(buf, len, len);
> > +     dma_unmap_addr_set(buf, dma, addr);
> > +
> > +     payload_nfrags = shinfo->nr_frags;
> > +     if (hlen < len) {
> > +             /* For gso the rest of the linear portion of the skb
> > needs to
> > +              * be in its own descriptor.
> > +              */
> > +             payload_nfrags++;
> > +             gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso,
> > l4_hdr_offset,
> > +                                  1 + payload_nfrags, hlen, addr);
> > +
> > +             len -= hlen;
> > +             addr += hlen;
> > +             seg_desc = &tx->desc[(tx->req + 1) & tx->mask];
> > +             seg_idx_bias = 2;
> > +             gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> > +     } else {
> > +             seg_idx_bias = 1;
> > +             gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso,
> > l4_hdr_offset,
> > +                                  1 + payload_nfrags, hlen, addr);
> > +     }
> > +     idx = (tx->req + seg_idx_bias) & tx->mask;
> > +
> > +     for (i = 0; i < payload_nfrags - (seg_idx_bias - 1); i++) {
> > +             const skb_frag_t *frag = &shinfo->frags[i];
> > +
> > +             seg_desc = &tx->desc[idx];
> > +             len = skb_frag_size(frag);
> > +             addr = skb_frag_dma_map(tx->dev, frag, 0, len,
> > DMA_TO_DEVICE);
> > +             if (unlikely(dma_mapping_error(tx->dev, addr))) {
> > +                     priv->dma_mapping_error++;
>
> don't you need to protect this from parallel access ?
I think you're right. I'll protect it with rtnl_lock/unlock/end.



> > +                     goto unmap_drop;
> > +             }
> > +             buf = &tx->info[idx].buf;
> > +             tx->info[idx].skb = NULL;
> > +             dma_unmap_len_set(buf, len, len);
> > +             dma_unmap_addr_set(buf, dma, addr);
> > +
> > +             gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> > +             idx = (idx + 1) & tx->mask;
> > +     }
> > +
> > +     return 1 + payload_nfrags;
> > +
> > +unmap_drop:
> > +     i--;
> > +     for (last_mapped = i + seg_idx_bias; last_mapped >= 0;
> > last_mapped--) {
> > +             idx = (tx->req + last_mapped) & tx->mask;
> > +             gve_tx_unmap_buf(tx->dev, &tx->info[idx]);
> > +     }
> > +drop:
> > +     tx->dropped_pkt++;
> > +     return 0;
> > +}
> > +
> ...
>
>
