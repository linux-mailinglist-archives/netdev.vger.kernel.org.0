Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A851664EDF
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjAJWjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjAJWjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:39:04 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1652E5AC52
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:39:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a30so10014182pfr.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fs3eF9VmWFLdfr/grASoEunC/hi5TU0cFqV2SCHbM3g=;
        b=EpK+hx+AZ4XVgOdvYnOwcN81x8LtnYMVSUJlDXYx+8c8ENRPKesgVcEBseBNr3XhZh
         s2ZpAVeaNdZ7Buw4S16X6CrfVEeXkBYMZ5T3+qAw8H19AUTagxuRxEqnbE1iYzcUTlxE
         INj/CW9pU30yAdRuAF37+ZPgrtrW2VNyephofX1O+OlQEikvWgI5yCRWcUjPOrsDGLOv
         3sMpdEf7uS6gmrcpezkspUGWcXIW8s5luUibtJ6jTgYHIJav/K2Lvq3g7g/azDlxsI7L
         NGFOBbw1oiZ8THUnBdorUULe+YDqdmKacDUjSmo+B/4z4PHE8iAhw2NxjdQasuficG6P
         6mUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fs3eF9VmWFLdfr/grASoEunC/hi5TU0cFqV2SCHbM3g=;
        b=l1HKggFUU16GBMh8kt42UqkbQl0Hivdd18LK51X9VS/uiaJAl0sVxZiwyAvrlM/aAE
         WNMkxyu15p7SG1zAeeag6IwqpYACuKz3Clu29nIpDoncnYVDf43reLntBnJHUsPgCkt6
         ILPoOrMAHcvBXVKTHbUtSMyE9jkt5JBydG2WkGH92YH1ou+JrivHCEVvUp5+5NNdf9zC
         FyUM/h1HPu1ysYCHpEijNo1+kQwGCJSg2TNbaEyvonh0+w5/h4dO5JLpEyj4ZZReAkTB
         HxPmh5NQicBfDJ+0O65TkMBVoTH0mQIncsqBnVdLhcyMfaWx69VDrAoFX1helx2qOv3a
         wN3A==
X-Gm-Message-State: AFqh2ko8OTumSQ7gzkqvzgYep2YZ9kAUahSJTh7Bv4C0otRn1ADR5Clj
        DRy+l5kpJD9/yIY4KN9MxAEJ+BqrzILNEUPiRE8=
X-Google-Smtp-Source: AMrXdXviIQ1Cf5NcdBU9JFQ3MG0NcuAxG8p3iPbT33f6WEEYLv+qt1H+wB/vD/BRvYQl84o67VTpuAQkqFrwld4XJ3E=
X-Received: by 2002:a63:dc0b:0:b0:47c:a2e0:483b with SMTP id
 s11-20020a63dc0b000000b0047ca2e0483bmr4185001pgg.354.1673390342445; Tue, 10
 Jan 2023 14:39:02 -0800 (PST)
MIME-Version: 1.0
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-6-gerhard@engleder-embedded.com> <f8b1b2afcdaef61c4adb8972e18cb40ad5a4787c.camel@gmail.com>
 <5b719373-beb0-ce8b-7789-b24c01a28eff@engleder-embedded.com>
In-Reply-To: <5b719373-beb0-ce8b-7789-b24c01a28eff@engleder-embedded.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Jan 2023 14:38:49 -0800
Message-ID: <CAKgT0UfFK+eE3MwU3ux1FRjQqpOyh2tNhADKKwsGcxK__t6a8g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 05/10] tsnep: Add XDP TX support
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 1:07 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> On 10.01.23 17:56, Alexander H Duyck wrote:
> > nOn Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> >> Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
> >> frames is included.
> >>
> >> Also some const, braces and logic clean ups are done in normal TX path
> >> to keep both TX paths in sync.
> >>
> >> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

<...>

> >>   struct tsnep_tx_entry {
> >>      struct tsnep_tx_desc *desc;
> >>      struct tsnep_tx_desc_wb *desc_wb;
> >> @@ -65,7 +71,11 @@ struct tsnep_tx_entry {
> >>
> >>      u32 properties;
> >>
> >> -    struct sk_buff *skb;
> >> +    enum tsnep_tx_type type;
> >> +    union {
> >> +            struct sk_buff *skb;
> >> +            struct xdp_frame *xdpf;
> >> +    };
> >>      size_t len;
> >>      DEFINE_DMA_UNMAP_ADDR(dma);xdp_return_frame_bulk
> >>   };
> >> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> >> index 943de5a09693..1ae73c706c9e 100644
> >> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> >> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> >> @@ -310,10 +310,12 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
> >>      struct tsnep_tx_entry *entry = &tx->entry[index];
> >>
> >>      entry->properties = 0;
> >> +    /* xdpf is union with skb */
> >>      if (entry->skb) {
> >>              entry->properties = length & TSNEP_DESC_LENGTH_MASK;
> >>              entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
> >> -            if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
> >> +            if (entry->type == Txdp_return_frame_bulkSNEP_TX_TYPE_SKB &&
> >> +                (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS))
> >>                      entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
> >>
> >>              /* toggle user flag to prevent false acknowledge
> >> @@ -370,7 +372,8 @@ static int tsnep_tx_desc_available(struct tsnep_tx *tx)
> >>              return tx->read - tx->write - 1;
> >>   }
> >>
> >> -static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
> >> +static int tsnep_tx_map(const struct sk_buff *skb, struct tsnep_tx *tx,
> >> +                    int count)
> >>   {
> >
> > This change to const doesn't add anything since this is a static
> > function. You could probably just skip making this change since the
> > function will likely be inlined anyway.
>
> const was requested for tsnep_xdp_tx_map() during last review round so I
> added it also here to keep both function similar.

As a general rule it doesn't add anything to make an argument to a
static function const unless the callers are also making it a const.
Otherwise what you end up doing is just adding useless modifiers that
will be thrown away to the code as the compiler can already take care
of whatever optimizations it can get out of it.

> >>      struct device *dmadev = tx->adapter->dmadev;
> >>      struct tsnep_tx_entry *entry;
> >> @@ -382,7 +385,7 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
> >>      for (i = 0; i < count; i++) {
> >>              entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
> >>
> >> -            if (i == 0) {
> >> +            if (!i) {
> >>                      len = skb_headlen(skb);
> >>                      dma = dma_map_single(dmadev, skb->data, len,
> >>                                           DMA_TO_DEVICE);
> >> @@ -400,6 +403,8 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
> >>
> >>              entry->desc->tx = __cpu_to_le64(dma);
> >>
> >> +            entry->type = TSNEP_TX_TYPE_SKB;
> >> +
> >>              map_len += len;
> >>      }
> >>
> >
> > I wonder if it wouldn't be better to change this so that you have a 4th
> > type for just "PAGE" or "FRAGMENT" since you only really need to
> > identify this as SKB or XDP on the first buffer, and then all the rest
> > are just going to be unmapped as page regardless of if it is XDP or
> > SKB.
>
> I will it try in combination with your bitmap suggestion.
>
> >> @@ -417,12 +422,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
> >>              entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
> >>
> >>              if (entry->len) {
> >> -                    if (i == 0)
> >> +                    if (!i && entry->type == TSNEP_TX_TYPE_SKB)
> >>                              dma_unmap_single(dmadev,
> >>                                               dma_unmap_addr(entry, dma),
> >>                                               dma_unmap_len(entry, len),
> >>                                               DMA_TO_DEVICE);
> >> -                    else
> >> +                    else if (entry->type == TSNEP_TX_TYPE_SKB ||
> >> +                             entry->type == TSNEP_TX_TYPE_XDP_NDO)
> >>                              dma_unmap_page(dmadev,
> >>                                             dma_unmap_addr(entry, dma),
> >>                                             dma_unmap_len(entry, len),
> >
> > Rather than perform 2 checks here you could just verify type !=
> > TYPE_XDP_TX which would save you a check.
>
> Will be improved with your bitmap suggestion.
>
> >> @@ -482,7 +488,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
> >>
> >>      for (i = 0; i < count; i++)
> >>              tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
> >> -                              i == (count - 1));
> >> +                              i == count - 1);
> >>      tx->write = (tx->write + count) % TSNEP_RING_SIZE;
> >>
> >>      skb_tx_timestamp(skb);
> >> @@ -502,12 +508,133 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
> >>      return NETDEV_TX_OK;
> >>   }
> >>
> >> +static int tsnep_xdp_tx_map(const struct xdp_frame *xdpf, struct tsnep_tx *tx,
> >> +                        const struct skb_shared_info *shinfo, int count,
> >> +                        enum tsnep_tx_type type)
> >
> > Again the const here isn't adding any value since this is a static
> > function and will likely be inlined into the function below which calls
> > it.
>
> const was requested here during last review round so I added it. It may
> add some value by detecting some problems at compile time.

I suppose, but really adding a const attribute here doesn't add much
here unless you are also going to enforce it at higher levels such as
the xmit_frame_ring function itself. Also keep in mind that all the
const would protect is the xdp frame structure itself. It does nothing
to keep us from modifying the data in the pages and such.

> >> +{
> >> +    struct device *dmadev = tx->adapter->dmadev;
> >> +    struct tsnep_tx_entry *entry;
> >> +    const skb_frag_t *frag;
> >> +    struct page *page;
> >> +    unsigned int len;
> >> +    int map_len = 0;
> >> +    dma_addr_t dma;
> >> +    void *data;
> >> +    int i;
> >> +
> >> +    frag = NULL;
> >> +    len = xdpf->len;
> >> +    for (i = 0; i < count; i++) {
> >> +            entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
> >> +            if (type == TSNEP_TX_TYPE_XDP_NDO) {
> >> +                    data = unlikely(frag) ? skb_frag_address(frag) :
> >> +                                            xdpf->data;
> >> +                    dma = dma_map_single(dmadev, data, len, DMA_TO_DEVICE);
> >> +                    if (dma_mapping_error(dmadev, dma))
> >> +                            return -ENOMEM;
> >> +
> >> +                    entry->type = TSNEP_TX_TYPE_XDP_NDO;
> >> +            } else {
> >> +                    page = unlikely(frag) ? skb_frag_page(frag) :
> >> +                                            virt_to_page(xdpf->data);
> >> +                    dma = page_pool_get_dma_addr(page);
> >> +                    if (unlikely(frag))
> >> +                            dma += skb_frag_off(frag);
> >> +                    else
> >> +                            dma += sizeof(*xdpf) + xdpf->headroom;
> >> +                    dma_sync_single_for_device(dmadev, dma, len,
> >> +                                               DMA_BIDIRECTIONAL);
> >> +
> >> +                    entry->type = TSNEP_TX_TYPE_XDP_TX;
> >> +            }
> >> +
> >> +            entry->len = len;
> >> +            dma_unmap_addr_set(entry, dma, dma);
> >> +
> >> +            entry->desc->tx = __cpu_to_le64(dma);
> >> +
> >> +            map_len += len;
> >> +
> >> +            if (i + 1 < count) {
> >> +                    frag = &shinfo->frags[i];
> >> +                    len = skb_frag_size(frag);
> >> +            }
> >> +    }
> >> +
> >> +    return map_len;
> >> +}
> >> +
> >> +/* This function requires __netif_tx_lock is held by the caller. */
> >> +static bool tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
> >> +                                  struct tsnep_tx *tx,
> >> +                                  enum tsnep_tx_type type)
> >> +{
> >> +    const struct skb_shared_info *shinfo =
> >> +            xdp_get_shared_info_from_frame(xdpf);
> >> +    struct tsnep_tx_entry *entry;
> >> +    int count, length, retval, i;
> >> +
> >> +    count = 1;
> >> +    if (unlikely(xdp_frame_has_frags(xdpf)))
> >> +            count += shinfo->nr_frags;
> >> +
> >> +    spin_lock_bh(&tx->lock);
> >> +
> >> +    /* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
> >> +     * will be available for normal TX path and queue is stopped there if
> >> +     * necessary
> >> +     */
> >> +    if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count)) {
> >> +            spin_unlock_bh(&tx->lock);
> >> +
> >> +            return false;
> >> +    }
> >> +
> >> +    entry = &tx->entry[tx->write];
> >> +    entry->xdpf = xdpf;
> >> +
> >> +    retval = tsnep_xdp_tx_map(xdpf, tx, shinfo, count, type);
> >> +    if (retval < 0) {
> >> +            tsnep_tx_unmap(tx, tx->write, count);
> >> +            entry->xdpf = NULL;
> >> +
> >> +            tx->dropped++;
> >> +
> >> +            spin_unlock_bh(&tx->lock);
> >> +
> >> +            return false;
> >> +    }
> >> +    length = retval;
> >> +
> >> +    for (i = 0; i < count; i++)
> >> +            tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
> >> +                              i == count - 1);
> >> +    tx->write = (tx->write + count) % TSNEP_RING_SIZE;
> >> +
> >> +    /* descriptor properties shall be valid before hardware is notified */
> >> +    dma_wmb();
> >> +
> >> +    spin_unlock_bh(&tx->lock);
> >> +
> >> +    return true;
> >> +}
> >> +
> >> +static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
> >> +{
> >> +    iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
> >> +}
> >> +
> >>   static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> >>   {
> >> -    int budget = 128;
> >>      struct tsnep_tx_entry *entry;
> >> -    int count;
> >> +    struct xdp_frame_bulk bq;
> >> +    int budget = 128;
> >>      int length;
> >> +    int count;
> >> +
> >> +    xdp_frame_bulk_init(&bq);
> >> +
> >> +    rcu_read_lock(); /* need for xdp_return_frame_bulk */
> >>
> >
> > You should be able to get rid of both of these. See comments below.
> >
> >>      spin_lock_bh(&tx->lock);
> >>
> >> @@ -527,12 +654,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> >>              dma_rmb();
> >>
> >>              count = 1;
> >> -            if (skb_shinfo(entry->skb)->nr_frags > 0)
> >> +            if (entry->type == TSNEP_TX_TYPE_SKB &&
> >> +                skb_shinfo(entry->skb)->nr_frags > 0)
> >>                      count += skb_shinfo(entry->skb)->nr_frags;
> >> +            else if (entry->type != TSNEP_TX_TYPE_SKB &&
> >> +                     xdp_frame_has_frags(entry->xdpf))
> >> +                    count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
> >>
> >>              length = tsnep_tx_unmap(tx, tx->read, count);
> >>
> >> -            if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> >> +            if (entry->type == TSNEP_TX_TYPE_SKB &&
> >> +                (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> >>                  (__le32_to_cpu(entry->desc_wb->properties) &
> >>                   TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
> >>                      struct skb_shared_hwtstamps hwtstamps;
> >> @@ -552,7 +684,18 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> >>                      skb_tstamp_tx(entry->skb, &hwtstamps);
> >>              }
> >>
> >> -            napi_consume_skb(entry->skb, napi_budget);
> >> +            switch (entry->type) {
> >> +            case TSNEP_TX_TYPE_SKB:
> >> +                    napi_consume_skb(entry->skb, napi_budget);
> >> +                    break;
> >> +            case TSNEP_TX_TYPE_XDP_TX:
> >> +                    xdp_return_frame_rx_napi(entry->xdpf);
> >> +                    break;
> >> +            case TSNEP_TX_TYPE_XDP_NDO:
> >> +                    xdp_return_frame_bulk(entry->xdpf, &bq);
> >> +                    break;
> >> +            }
> >> +            /* xdpf is union with skb */
> >>              entry->skb = NULL;
> >>
> >>              tx->read = (tx->read + count) % TSNEP_RING_SIZE;
> >
> > If I am not mistaken I think you can use xdp_return_frame_rx_napi for
> > both of these without having to resort to the bulk approach since the
> > tsnep_tx_poll is operating in the NAPI polling context.
> >
> > When you free the buffers outside of polling context you would then
> > want to use the xdp_return_frame_bulk. So for example if you have any
> > buffers that weren't transmitted when you get to the point of
> > tsnep_tx_ring_cleanup then you would want to unmap and free them there
> > using something like the xdp_return_frame or xdp_return_frame_bulk.
>
> This is done similar in other drivers, so I thought it is good practice.
> I will compare the performance of xdp_return_frame_rx_napi() and
> xdp_return_frame_bulk().

Okay, sounds good.
