Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAF664331
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjAJOYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbjAJOXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:23:53 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307B08D5D7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:23:49 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-4d13cb4bbffso35516217b3.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HB2hLwJqW5UDWovv4Gd4eZPuqd0dET7//GtCnEZG/RM=;
        b=mEpwJ61YmfDFRpy4EfhqamIVgoIRJNU3tvRR72ULXlBnnWCPXpCwAe43me0pcWn+ti
         85qrh/qO2wA+8DCR/ib7auwP1LXbsTkmLKsUbC8AZLVOjyQbkvYYorqQsM0MIT2/pM/V
         aM8Q4h+v/d6msRndXEe5mFdUxK13Jjidyk6EAWXFpmnj120wU2wooi8B8ElsuwCGH4YD
         izmn62oVKCglu1u+iuVd/Kftn6OXaCD07SpUIFLBWO3xxh4qDekK9/hPQokPmf/fCgrS
         MhQxm+sTShAWsK2+7bY6E/fGqmQEW4QQJjONN8QqgWmwrMwOvRG/dvv6QnOmufsMjwKc
         PotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HB2hLwJqW5UDWovv4Gd4eZPuqd0dET7//GtCnEZG/RM=;
        b=P59dFXcn3LcCSrcJXfTDxsJKNyStX7zcjjrSkNPrn5HKXI32KqdYtCYVc7AZFl/FqK
         UHck73ujssVYdC3INnCA7C9VjXmSHPEX+kIAuEL65cHhiTNp3By/snMBwUJ8Bb1ObDN6
         vOq3YacfNukP7/sl+QcMMkWCDfulE+fRXD0GqzlAlByOk2q0UutgkIMutu37pEq95i+N
         85n8TrpPP0nv8tINrG31hy3kxzEjIkn4qbPjQYFqLaVAAL8jKSqlYLc50WUW+UpN6iUZ
         EYl1yVQSIqir8IDXMuQY8AEKjQTtnPRUIS70p7tp/W2IFlHpR4Kh11PipwqsInLsnFAQ
         RRzg==
X-Gm-Message-State: AFqh2kqcNCmYTbSVmpTeLg8nZXuoqDl6ZRjIX6mw8spj0PG2///C/MSD
        /emUG3AW3EF8YnoZwY6Arht9GC0aR3YGNHMoJEQ=
X-Google-Smtp-Source: AMrXdXvUUMY62BA09HgLdQvozPbe+Apc+j5NxwYPt+KuE8m9E2UFLq4b8w+5/um9GvC0MgRBMUw/RQEmawpJ5TD1D+k=
X-Received: by 2002:a05:690c:c81:b0:48c:9ce1:9ac8 with SMTP id
 cm1-20020a05690c0c8100b0048c9ce19ac8mr4175699ywb.305.1673360628980; Tue, 10
 Jan 2023 06:23:48 -0800 (PST)
MIME-Version: 1.0
References: <20230108181826.88882-1-u9012063@gmail.com> <c73b3e16b113db00114ee566a8ecf0821aeacd96.camel@gmail.com>
In-Reply-To: <c73b3e16b113db00114ee566a8ecf0821aeacd96.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 10 Jan 2023 06:23:12 -0800
Message-ID: <CALDO+SagXG8n_3nGiPdoae=-Bx0NJY9cXp8RJ4jZ9ShN6bxRnQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v11] vmxnet3: Add XDP support.
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

On Mon, Jan 9, 2023 at 11:02 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Sun, 2023-01-08 at 10:18 -0800, William Tu wrote:
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> >
<...>

> >  char vmxnet3_driver_name[] = "vmxnet3";
> >  #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
> > @@ -322,44 +323,58 @@ static u32 get_bitfield32(const __le32 *bitfield, u32 pos, u32 size)
> >  #endif /* __BIG_ENDIAN_BITFIELD  */
> >
> >
> > -static void
> > -vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> > -                  struct pci_dev *pdev)
> > +static u32
> > +vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pdev,
> > +                  struct xdp_frame_bulk *bq)
>
> Is the bq value being used anywhere in here? We probably need to either
> drop it.
yes, my mistake.

>
> >  {
> > -     if (tbi->map_type == VMXNET3_MAP_SINGLE)
> > +     u32 map_type = tbi->map_type;
> > +
> > +     if (map_type & VMXNET3_MAP_SINGLE)
> >               dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
> >                                DMA_TO_DEVICE);
> > -     else if (tbi->map_type == VMXNET3_MAP_PAGE)
> > +     else if (map_type & VMXNET3_MAP_PAGE)
> >               dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
> >                              DMA_TO_DEVICE);
> > -     else
> > -             BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> > +     else if (map_type & ~(VMXNET3_MAP_SINGLE | VMXNET3_MAP_PAGE |
> > +                           VMXNET3_MAP_XDP))
> > +             BUG_ON(map_type != VMXNET3_MAP_NONE);
>
> What you might just do here is drop the "else if" in favor of an
> "else". Your bug on would basically just need to check for:
>         else
>                 BUG_ON((map_type & ~VMXNET_MAP_XDP));
Will do it, thanks!

>
> >       tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
> > +
> > +     return map_type;
> >  }
> >
> >
>
> In reality we only need to worry about the map_type of the eop buffer
> when we are dealing with any frame. You might actually pull the
> map_type out in vmxnet3_unmap_pkt below and just pass that to the end.
>
> >  static int
> >  vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> > -               struct pci_dev *pdev, struct vmxnet3_adapter *adapter)
> > +               struct pci_dev *pdev, struct vmxnet3_adapter *adapter,
> > +               struct xdp_frame_bulk *bq)
> >  {
> > -     struct sk_buff *skb;
> > +     struct vmxnet3_tx_buf_info *tbi;
> >       int entries = 0;
> > +     u32 map_type;
> >
> >       /* no out of order completion */
> >       BUG_ON(tq->buf_info[eop_idx].sop_idx != tq->tx_ring.next2comp);
> >       BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
> >
> > -     skb = tq->buf_info[eop_idx].skb;
> > -     BUG_ON(skb == NULL);
> > -     tq->buf_info[eop_idx].skb = NULL;
> > -
> > +     tbi = &tq->buf_info[eop_idx];
> >       VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
> >
>
> We may want to record the map_type here for the tbi that contains the
> skb or XDP frame. Then we don't need to record the map_type in the loop
> below and can save ourselves a few cycles.
>
> Also we may want to preserve the BUG_ON check, but here it would be:
>         BUG_ON(tbi->skb == NULL);
Got it, thanks!

>
> >       while (tq->tx_ring.next2comp != eop_idx) {
> > -             vmxnet3_unmap_tx_buf(tq->buf_info + tq->tx_ring.next2comp,
> > -                                  pdev);
> > -
> > +             map_type = vmxnet3_unmap_tx_buf(tq->buf_info +
> > +                                             tq->tx_ring.next2comp, pdev,
> > +                                             bq);
> > +             /* xdpf and skb are in an anonymous union, if set we need to
> > +              * free a buffer.
> > +              */
> > +             if (tbi->skb) {
> > +                     if (map_type & VMXNET3_MAP_XDP)
> > +                             xdp_return_frame_bulk(tbi->xdpf, bq);
> > +                     else
> > +                             dev_kfree_skb_any(tbi->skb);
> > +                     tbi->skb = NULL;
> > +             }
>
> So this code could probably be moved to the end of the function where
> the dev_kfree_skb_any originally was. Then you can drop the "if(tbi-
> >skb)" and instead just have the map_type dealt with there. This should
> save you from having to read and store map_type multiple times.
>
> >               /* update next2comp w/o tx_lock. Since we are marking more,
> >                * instead of less, tx ring entries avail, the worst case is
> >                * that the tx routine incorrectly re-queues a pkt due to
> > @@ -369,7 +384,6 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> >               entries++;
> >       }
> >
> > -     dev_kfree_skb_any(skb);
> >       return entries;
> >  }
> >
>
> No point moving this into the loop when it can always be processed at
> the end. Basically we just needc to pull the if statement you added
> above down to here.
right, will move out of the loop.

>
> > @@ -379,8 +393,10 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
> >                       struct vmxnet3_adapter *adapter)
> >  {
> >       int completed = 0;
> > +     struct xdp_frame_bulk bq;
> >       union Vmxnet3_GenericDesc *gdesc;
> >
> > +     xdp_frame_bulk_init(&bq);
> >       gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
> >       while (VMXNET3_TCD_GET_GEN(&gdesc->tcd) == tq->comp_ring.gen) {
> >               /* Prevent any &gdesc->tcd field from being (speculatively)
> > @@ -390,11 +406,12 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
> >
> >               completed += vmxnet3_unmap_pkt(VMXNET3_TCD_GET_TXIDX(
> >                                              &gdesc->tcd), tq, adapter->pdev,
> > -                                            adapter);
> > +                                            adapter, &bq);
> >
> >               vmxnet3_comp_ring_adv_next2proc(&tq->comp_ring);
> >               gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
> >       }
> > +     xdp_flush_frame_bulk(&bq);
> >
> >       if (completed) {
> >               spin_lock(&tq->tx_lock);
> > @@ -414,26 +431,33 @@ static void
> >  vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
> >                  struct vmxnet3_adapter *adapter)
> >  {
> > +     struct xdp_frame_bulk bq;
> > +     u32 map_type;
> >       int i;
> >
> > +     xdp_frame_bulk_init(&bq);
> > +
> >       while (tq->tx_ring.next2comp != tq->tx_ring.next2fill) {
> >               struct vmxnet3_tx_buf_info *tbi;
> >
> >               tbi = tq->buf_info + tq->tx_ring.next2comp;
> >
>
> Rather than have vmxnet3_unmap_tx_buf return the map_type you might
> just read it yourself here.
Will do it, thanks
William
