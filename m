Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB2968A7C8
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 03:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjBDC0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 21:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBDC0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 21:26:49 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642124955A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 18:26:48 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-523e3a0300eso69214437b3.4
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 18:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F12P2Eo0jOiOA+bKN1M10wX8yHYxbvbY2tuxlMqbfXs=;
        b=mqdEf2Uy2djm9ja6iU7RHqGvICKlbyyM5xYiSZmDwi3f5qrf5VG9u05Pb8Uq3BMwYm
         UmyU2laCpjrawIvH75lvOU7QwFx098DWiOaG7/LHqr6qJtUf8Ee3Uq9nX5ekx4Tz0Qed
         VyI4H4ThSMCE8SV/6lGDMUhCYHQU/R+IpEe3z1xhbaW4QVOPkuKzec1FMheskAMwYT+k
         XwsUPCzYW9O+Tr/sRqhkshK0Ty2yr2Unleg0sjJe8dmwgq1+IUcvyVyYByN7LLo/P/4B
         AVWDJsuqLnd2h0JcUzVqQBO4tEIGjoY7AKoFZfk8DnXT1fGQgrAD4O7o7cM8ZdKKyByc
         6naA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F12P2Eo0jOiOA+bKN1M10wX8yHYxbvbY2tuxlMqbfXs=;
        b=1ooTXP9mL8PxozdvF6BrecmcuVhcN3RJbUm2LjZGVROPWD8GEfyLgofsqgSLpfGhLl
         X5AnnoTn/IojnbVXRaRSGJE4TZBqS5lXuHWSXwaXbuCxPV5Oa6uCaGNESjBvgnH8e94k
         /B4mRRXgccpCuwRksLkgJR9mhj0ddSXw1TFRHeA8lsqarko8idbX2gO/7lhG5M9eqJIc
         +PskNWaY0lg0qYr+8oAR7AYLXP6NPxJPs3BU2tmboRLGfPt/lNwHReCMFI7O+NIWy6rN
         xiUOymXB2QhAatdFxEYS+JmVFYelV8Vaxr7J7QOcpdmsy6QKeC6xOVfDLPmmKE3e0hyo
         yuwg==
X-Gm-Message-State: AO0yUKV4NKuvRQvcLDBuGpxlpZUDWi6qb9MCkleXBG+uZGTIjSuCVzV1
        Utv1RvmhfIy1uHjyvjBh56YS6iWsid5doEE3eKc=
X-Google-Smtp-Source: AK7set9b8cZoeUGepklll/NFRl0h37ZIH4Ehrlwy7BPixYR+eC9tdIo7VFArxc6uonz2boNR3dP/v7MuUF6Rm2Yq7O4=
X-Received: by 2002:a81:8309:0:b0:526:188f:7e23 with SMTP id
 t9-20020a818309000000b00526188f7e23mr430878ywf.455.1675477607392; Fri, 03 Feb
 2023 18:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20230127163027.60672-1-u9012063@gmail.com> <1e78d2df-2b9e-3e46-017e-5cc42807db03@intel.com>
In-Reply-To: <1e78d2df-2b9e-3e46-017e-5cc42807db03@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 3 Feb 2023 18:26:11 -0800
Message-ID: <CALDO+Sa329VM6vL8s7dJeAkhMcKQCQYy-42XVtUN_Q8_NTYixQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v15] vmxnet3: Add XDP support.
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com, bang@vmware.com,
        Yifeng Sun <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
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
Thanks again for your review!

On Mon, Jan 30, 2023 at 4:26 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: William Tu <u9012063@gmail.com>
> Date: Fri, 27 Jan 2023 08:30:27 -0800
>
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> >
> > Background:
> > The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
> > For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
> > mapped to the ring's descriptor. If LRO is enabled and packet size larger
> > than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> > the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> > allocated using alloc_page. So for LRO packets, the payload will be in one
> > buffer from r0 and multiple from r1, for non-LRO packets, only one
> > descriptor in r0 is used for packet size less than 3k.
>
> [...]
>
> > @@ -1404,6 +1496,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >       struct Vmxnet3_RxDesc rxCmdDesc;
> >       struct Vmxnet3_RxCompDesc rxComp;
> >  #endif
> > +     bool need_flush = false;
> > +
> >       vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
> >                         &rxComp);
> >       while (rcd->gen == rq->comp_ring.gen) {
> > @@ -1444,6 +1538,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                       goto rcd_done;
> >               }
> >
> > +             if (rcd->sop && rcd->eop && vmxnet3_xdp_enabled(adapter)) {
>
> Hmm, it's a relatively big block of code for one `if`. I mean, could we
> do it like that?
>
>                 if (!rcd->sop || !vmxnet3_xdp_enabled(adapter))
>                         goto skip_xdp;
>
>                 if (VMXNET3_RX_DATA_RING(adapter, rcd->rqID)) {
>                         ...
>
> This way you would save 1 indent level and make code a little bit more
> readable.
> But it might be a matter of personal tastes :) Just noticed you have
> this `skip_xdp` label anyway, why not reuse it here.

Good idea, this function has high indent level and this is a good idea.
I will do it.

>
> > +                     struct sk_buff *skb_xdp_pass;
> > +                     int act;
> > +
> > +                     if (VMXNET3_RX_DATA_RING(adapter, rcd->rqID)) {
> > +                             ctx->skb = NULL;
> > +                             goto skip_xdp; /* Handle it later. */
> > +                     }
> > +
> > +                     if (rbi->buf_type != VMXNET3_RX_BUF_XDP)
> > +                             goto rcd_done;
> > +
> > +                     act = vmxnet3_process_xdp(adapter, rq, rcd, rbi, rxd,
> > +                                               &skb_xdp_pass);
> > +                     if (act == XDP_PASS) {
> > +                             ctx->skb = skb_xdp_pass;
> > +                             goto sop_done;
> > +                     }
> > +                     ctx->skb = NULL;
> > +                     if (act == XDP_REDIRECT)
> > +                             need_flush = true;
>
>                         need_flush |= act == XDP_REDIRECT;
>
> But this looks a big ugly to be honest, I just wrote it to show off a
> bit :D Your `if` is perfectly fine, not even sure the line I wrote above
> produces more optimized object code.
ha, ok. Good to know there is another option.

>
> > +                     goto rcd_done;
> > +             }
> > +skip_xdp:
> > +
> >               if (rcd->sop) { /* first buf of the pkt */
> >                       bool rxDataRingUsed;
> >                       u16 len;
> > @@ -1452,7 +1571,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                              (rcd->rqID != rq->qid &&
> >                               rcd->rqID != rq->dataRingQid));
> >
> > -                     BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB);
> > +                     BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB &&
> > +                            rbi->buf_type != VMXNET3_RX_BUF_XDP);
> >                       BUG_ON(ctx->skb != NULL || rbi->skb == NULL);
> >
> >                       if (unlikely(rcd->len == 0)) {
> > @@ -1470,6 +1590,26 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                       rxDataRingUsed =
> >                               VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
> >                       len = rxDataRingUsed ? rcd->len : rbi->len;
> > +
> > +                     if (rxDataRingUsed && vmxnet3_xdp_enabled(adapter)) {
>
> Maybe save 1 level here as well:
cool, will do it.

>
>                         if (!rxDataRingUsed || !vmxnet3_xdp_enabled(ad))
>                                 goto alloc_skb;
>
>                         sz = rcd->rxdIdx * ...
>
> > +                             struct sk_buff *skb_xdp_pass;
> > +                             size_t sz;
> > +                             int act;
> > +
> > +                             sz = rcd->rxdIdx * rq->data_ring.desc_size;
> > +                             act = vmxnet3_process_xdp_small(adapter, rq,
> > +                                                             &rq->data_ring.base[sz],
> > +                                                             rcd->len,
> > +                                                             &skb_xdp_pass);
> > +                             if (act == XDP_PASS) {
> > +                                     ctx->skb = skb_xdp_pass;
> > +                                     goto sop_done;
> > +                             }
> > +                             if (act == XDP_REDIRECT)
> > +                                     need_flush = true;
> > +
> > +                             goto rcd_done;
> > +                     }
>
> alloc_skb:
>
> >                       new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
> >                                                           len);
> >                       if (new_skb == NULL) {
>
> [...]
>
> > @@ -217,6 +221,9 @@ struct vmxnet3_tq_driver_stats {
> >       u64 linearized;         /* # of pkts linearized */
> >       u64 copy_skb_header;    /* # of times we have to copy skb header */
> >       u64 oversized_hdr;
> > +
> > +     u64 xdp_xmit;
> > +     u64 xdp_xmit_err;
>
> Sorry for missing this earlier... You use u64 here for stats and
> previously we were using it for the stats, but then u64_stat_t was
> introduced to exclude partial updates and tearing. I know there are
> stats already in u64 above, but maybe right now is the best time to use
> u64_stat_t for the new fields? :)
thanks for the suggestion, I read through the u64_stats_t.
if I replace with u64_stats_t, then there are several places
to replace using u64_stats_init, update, ....
I will keep this as future work or separate patch.

>
> >  };
> >
> >  struct vmxnet3_tx_ctx {
> > @@ -253,12 +260,13 @@ struct vmxnet3_tx_queue {
> >                                                   * stopped */
> >       int                             qid;
> >       u16                             txdata_desc_size;
> > -} __attribute__((__aligned__(SMP_CACHE_BYTES)));
> > +} ____cacheline_aligned;
> >
> >  enum vmxnet3_rx_buf_type {
> >       VMXNET3_RX_BUF_NONE = 0,
> >       VMXNET3_RX_BUF_SKB = 1,
> > -     VMXNET3_RX_BUF_PAGE = 2
> > +     VMXNET3_RX_BUF_PAGE = 2,
> > +     VMXNET3_RX_BUF_XDP = 3,
> >  };
> >
> >  #define VMXNET3_RXD_COMP_PENDING        0
> > @@ -285,6 +293,12 @@ struct vmxnet3_rq_driver_stats {
> >       u64 drop_err;
> >       u64 drop_fcs;
> >       u64 rx_buf_alloc_failure;
> > +
> > +     u64 xdp_packets;        /* Total packets processed by XDP. */
> > +     u64 xdp_tx;
> > +     u64 xdp_redirects;
> > +     u64 xdp_drops;
> > +     u64 xdp_aborted;
>
> (same)
thanks! Will be future work or separate patch.

>
> >  };
> >
> >  struct vmxnet3_rx_data_ring {
>
> [...]
>
> > +static int
> > +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> > +                    struct xdp_frame *xdpf,
> > +                    struct vmxnet3_tx_queue *tq, bool dma_map)
> > +{
> > +     struct vmxnet3_tx_buf_info *tbi = NULL;
> > +     union Vmxnet3_GenericDesc *gdesc;
> > +     struct vmxnet3_tx_ctx ctx;
> > +     int tx_num_deferred;
> > +     struct page *page;
> > +     u32 buf_size;
> > +     int ret = 0;
> > +     u32 dw2;
> > +
> > +     dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> > +     dw2 |= xdpf->len;
> > +     ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
> > +     gdesc = ctx.sop_txd;
> > +
> > +     buf_size = xdpf->len;
> > +     tbi = tq->buf_info + tq->tx_ring.next2fill;
> > +
> > +     if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
> > +             tq->stats.tx_ring_full++;
> > +             return -ENOSPC;
> > +     }
> > +
> > +     tbi->map_type = VMXNET3_MAP_XDP;
> > +     if (dma_map) { /* ndo_xdp_xmit */
> > +             tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
> > +                                            xdpf->data, buf_size,
> > +                                            DMA_TO_DEVICE);
> > +             if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr))
> > +                     return -EFAULT;
> > +             tbi->map_type |= VMXNET3_MAP_SINGLE;
> > +     } else { /* XDP buffer from page pool */
> > +             page = virt_to_head_page(xdpf->data);
>
> Nit: your page pools are always order-0, thus you could shortcut those
> virt_to_head_page() throughout the drivers to just virt_to_page() and
> save at least 1 unlikely() condition check this way (it will always be
> false for the pages coming from your page pools). I remember we had huge
> CPU load point on this compound_head() check inside virt_to_head_page()...

good point! this avoids the _compound_head call
Will do it in next version

>
> > +             tbi->dma_addr = page_pool_get_dma_addr(page) +
> > +                             XDP_PACKET_HEADROOM;
> > +             dma_sync_single_for_device(&adapter->pdev->dev,
> > +                                        tbi->dma_addr, buf_size,
> > +                                        DMA_BIDIRECTIONAL);
> > +     }
>
> [...]
>
> Those are some minors/propositions, up to you whether to address the
> rest was addressed perfectly by you, thanks!
>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Thanks again for your time to review the patch. Working on next version now.
William
