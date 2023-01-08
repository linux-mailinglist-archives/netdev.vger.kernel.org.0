Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068D56615D1
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 15:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjAHO2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 09:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjAHO2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 09:28:19 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EA2FAEC
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 06:28:18 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4b718cab0e4so82321247b3.9
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 06:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hl8rv16Vi9yO1zD4Tw+vHLF8DFTsp+prcVm/z5ugrGg=;
        b=CLvc2v5gTueRCCIKy5bVYaeRLLySVl4hWryeBd/OHoIdtUGLVIGMTVkjD0ocuK0k27
         4e2PwDbJjD3q3tiHOZiculMlVU6szXXI1pqIf0Ob8X7ylXE8nk6RpY9W3svzXkawIWeJ
         6JjdgiXdaJK+XEpRrDYUzam0gv8/jFgR8XDiT79lh56I4ptHJO69s70TmaQfAm6OTwMG
         QdzPNQ1gqe/DhJwvjTJDtuA2CXmabFGkz+j+aoxHG2UiqO5tkQhMuDuOretPa6mKbzbe
         bRAypKrADRznDEuJmgeGKN1Lyall7CGv+uwQ6W0+gVu9WtmxcxKSjPvyc0lFn1UcfKGe
         /Lig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hl8rv16Vi9yO1zD4Tw+vHLF8DFTsp+prcVm/z5ugrGg=;
        b=n61H5SNMxSxtbITO0YAuLQParx4uNBL7011aHASG692N/ylbJ5K4btI9LmjWbUAJIw
         xjulDcq3za/WgX6ALXTsdnbvMfYqfukErNtelGjPP7EDpisFuaoaGATSIdOL0EulHNPE
         eYHV26emzrtFl4A02h3YhLCYupnI4yFy8U4hoRCTRmD19DrrRlD2h2lYPWbL3sHP7ekt
         rjcJ3X65juvnZxbv5+JOegKAW/2gihirkXa2d3nsdvLBDoPxqH7AH26Ooy1YstmA9zbO
         JQz6hDlpXkElUXy16gsZYI/aoJRA4e4rkS/tcj+x3Y5DR5xA4aCpuPi8qQpfnbLfkdwH
         jLNg==
X-Gm-Message-State: AFqh2kreoMZIqHB4wkny+62FIYO6Gz1l6LQ4o4gfjEysgzTHTFafDS8V
        mQQtu/1MFIQ/RG01/dsuHn0IJNEqnVdklXcEt1o=
X-Google-Smtp-Source: AMrXdXt2uryEhRsA2hVIuBn01do+TR+zfE6Vfi2jOqkcdMhpYnQ/hcGmgLQ+PiX07PbS7eyRZllkM3tfASIwpqM6yl4=
X-Received: by 2002:a81:e16:0:b0:3f6:6e73:e606 with SMTP id
 22-20020a810e16000000b003f66e73e606mr587206ywo.475.1673188097070; Sun, 08 Jan
 2023 06:28:17 -0800 (PST)
MIME-Version: 1.0
References: <20230105223120.16231-1-u9012063@gmail.com> <35c08589266c69e25f50e1f1572a0364d32abd08.camel@gmail.com>
In-Reply-To: <35c08589266c69e25f50e1f1572a0364d32abd08.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sun, 8 Jan 2023 06:27:40 -0800
Message-ID: <CALDO+Sbjweh5RS5Oqce3cqBhhyL1RbG7z40fe=mjNYXvhbFhqg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v10] vmxnet3: Add XDP support.
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com, gerhard@engleder-embedded.com,
        alexandr.lobakin@intel.com, bang@vmware.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,
Thanks for your review!

On Fri, Jan 6, 2023 at 9:21 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, 2023-01-05 at 14:31 -0800, William Tu wrote:
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.

<...>

> >  static void
> > -vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> > -                  struct pci_dev *pdev)
> > +vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pdev,
> > +                  struct xdp_frame_bulk *bq)
> >  {
> > -     if (tbi->map_type == VMXNET3_MAP_SINGLE)
> > +     switch (tbi->map_type) {
> > +     case VMXNET3_MAP_SINGLE:
> > +     case VMXNET3_MAP_SINGLE | VMXNET3_MAP_XDP:
> >               dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
> >                                DMA_TO_DEVICE);
> > -     else if (tbi->map_type == VMXNET3_MAP_PAGE)
> > +             break;
> > +     case VMXNET3_MAP_PAGE:
> >               dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
> >                              DMA_TO_DEVICE);
> > -     else
> > +             break;
> > +     case VMXNET3_MAP_XDP:
> > +             break;
> > +     default:
> >               BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> > +     }
> > +
> > +     if (tbi->map_type & VMXNET3_MAP_XDP)
> > +             xdp_return_frame_bulk(tbi->xdpf, bq);
> >
> >       tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
> >  }
>
> This may not be right place to be returning the XDP frame. More on that
> below. If that is the case it might be better to look at just replacing
> the == with an & check to see if the bit is set rather then use the
> switch statement. The else/BUG_ON might need to be tweaked to exclude
> MAP_XDP from the map_type via a "(& ~)".
>
> > @@ -343,22 +354,29 @@ static int
> >  vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> >                 struct pci_dev *pdev, struct vmxnet3_adapter *adapter)
> >  {
> > -     struct sk_buff *skb;
> > +     struct vmxnet3_tx_buf_info *tbi;
> > +     struct sk_buff *skb = NULL;
> > +     struct xdp_frame_bulk bq;
> >       int entries = 0;
> >
> >       /* no out of order completion */
> >       BUG_ON(tq->buf_info[eop_idx].sop_idx != tq->tx_ring.next2comp);
> >       BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
> >
> > -     skb = tq->buf_info[eop_idx].skb;
> > -     BUG_ON(skb == NULL);
> > -     tq->buf_info[eop_idx].skb = NULL;
> > +     tbi = &tq->buf_info[eop_idx];
> > +     if (!(tbi->map_type & VMXNET3_MAP_XDP)) {
> > +             skb = tq->buf_info[eop_idx].skb;
> > +             BUG_ON(!skb);
> > +             tq->buf_info[eop_idx].skb = NULL;
> > +     }
> >
> >       VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
> >
> > +     xdp_frame_bulk_init(&bq);
> > +
> >       while (tq->tx_ring.next2comp != eop_idx) {
> >               vmxnet3_unmap_tx_buf(tq->buf_info + tq->tx_ring.next2comp,
> > -                                  pdev);
> > +                                  pdev, &bq);
> >
> >               /* update next2comp w/o tx_lock. Since we are marking more,
> >                * instead of less, tx ring entries avail, the worst case is
> > @@ -369,7 +387,11 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> >               entries++;
> >       }
> >
> > -     dev_kfree_skb_any(skb);
> > +     xdp_flush_frame_bulk(&bq);
> > +
> > +     if (skb)
> > +             dev_kfree_skb_any(skb);
> > +
> >       return entries;
> >  }
> >
>
> Based on the naming I am assuming vmxnet3_unmap_pkt is a per packet
> call? If so we are defeating the bulk freeing doing this here. I can't
> help but wonder if we have this operating at the correct level. It
> might make more sense to do the bulk_init and flush_frame_bulk in
> vmxnet3_tq_tx_complete and pass the bulk queue down to this function.

Yes, vmxnet3_unmap_pkt is per-packet, and I got your point.
The current code indeed doesn't free in batch.
I should move the bulk init and flush to up level, vmxnet3_tq_tx_complete.

>
> Specifically XDP frames are now capable of being multi-buffer. So it
> might make sense to have vmnet3_unmap_tx_buf stick to just doing the
> dma unmapping and instead have the freeing of the buffer XDP frame
> handled here where you would have handled dev_kfree_skb_any. You could
> then push the bulk_init and flush up one level to the caller you
> actually get some bulking.
Got it! thanks!

>
>
> > @@ -414,26 +436,37 @@ static void
> >  vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
> >                  struct vmxnet3_adapter *adapter)
> >  {
> > +     struct xdp_frame_bulk bq;
> >       int i;
> >
> > +     xdp_frame_bulk_init(&bq);
> > +
> >       while (tq->tx_ring.next2comp != tq->tx_ring.next2fill) {
> >               struct vmxnet3_tx_buf_info *tbi;
> >
> >               tbi = tq->buf_info + tq->tx_ring.next2comp;
> >
> > -             vmxnet3_unmap_tx_buf(tbi, adapter->pdev);
> > -             if (tbi->skb) {
> > +             vmxnet3_unmap_tx_buf(tbi, adapter->pdev, &bq);
> > +             switch (tbi->map_type) {
> > +             case VMXNET3_MAP_SINGLE:
> > +             case VMXNET3_MAP_PAGE:
> > +                     if (!tbi->skb)
> > +                             break;
> >                       dev_kfree_skb_any(tbi->skb);
> >                       tbi->skb = NULL;
> > +                     break;
> > +             case VMXNET3_MAP_XDP:
> > +             default:
> > +                     break;
> >               }
>
> This can probably be simplified. Basically if tbi->skb && !(map_type &
> VMXNET3_MAP_XDP) then you have an skb to free. No need for the switch
> statement.
>
> This too could benefit from keeping the buffer freeing out of
> vmxnet3_unmap_tx_buf since we could just do something like:
>         vmxnet3_unmap_tx_buf()
>         /* xdpf and skb are in an anonymous union, if set we need to
>          * free a buffer.
>          */
>         if (tbi->skb) {
>                 if (tbi->map_type & VMXNET3_MAP_XDP)
>                         xdp_return_frame_bulk(tbi->xdpf, bq);
>                 else
>                         dev_kfree_skb_any(tbi->skb);
>                 tbi->skb = NULL;
>         }
thanks, will do it.
William
