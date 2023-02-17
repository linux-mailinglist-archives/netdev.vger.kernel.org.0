Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE569AF2D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBQPMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBQPMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:12:22 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA2A268E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 07:12:21 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id h3so1342307ybi.5
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 07:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fpeRpbaGCa3Q4HYhsSUZDBeq1741/f9hzu/5pfwsLBs=;
        b=etpW0J9PuITmnnT2XvA358TA5Ec77cMTdtD9OHtvtQuekXJ2NdSq4Rjq21se44bA1J
         QYhIfqEHgfzkbiPFLW4RvMqhrCDOoHljritqSu0uzOvWhtIkwrMDHE+MSHjSkXMsdgwj
         zQnui4PBrdvl1kWnD4EZ6oClyXMT00f6Hl49RA8ezitLyAzoL5Y/WOlNYkREJpoXbHgf
         5yyR4ti2/eG6AP9oKGFBW5GTBoaIaMFRSZONt/1hwC0Pz4r6nynR1EAG+YrQxvxXESSM
         Mycl5dlJ7I8a4nftaxy/zaLE+YXnSAy5Xp0pI3E/O77w6LHnqa6ZSh9wYkVPKa03969F
         MEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fpeRpbaGCa3Q4HYhsSUZDBeq1741/f9hzu/5pfwsLBs=;
        b=pDDghM/IvscHzKaidvreShnTjKoQORaVa9FQFvtl9J012c90or/a685JmoQAX/wA3T
         XvRQ13NCVQKRqk0oNX+QLkKo7CaNQB3RAdzOkFcrP88XGtKEVPNtNFInhAbYbskXWB4t
         zM3cy/b8GC9Vd7zU8W6H5PeAAUfku5N9cMB0DpQuO9maG/1eu6wCTajERoQrqUGPkxzI
         lJ1J/wZImhuNbfhuwUl6V7JbdO2Vmet8M2adLNlOEU1/B8qxt1KwwdOPC5drsiBfDipz
         /2Uruqe8+9uijjTDoK/B9qImuIMnMbJOXf4zP33NyU51lAPR/Z/W/e3r31mk6wvYTfCy
         ttoA==
X-Gm-Message-State: AO0yUKXSMKveDLkvNjdZg6NnvctSZ4lkFwZk+dhbtVx/VDlpKvmRNhn2
        e/1P2pEP2sOTKakqg4wtAom7/9Sjt/r2tkSJ748=
X-Google-Smtp-Source: AK7set/eK8XnRwzQqFd7aWJvIseXN9BfN9WdjLFKKegu3XE/3x+k3DDT2HitjonkNhHfWhvpJ4xrnmoDdvK8z7PdHos=
X-Received: by 2002:a5b:94d:0:b0:903:6938:37c0 with SMTP id
 x13-20020a5b094d000000b00903693837c0mr1195887ybq.618.1676646740241; Fri, 17
 Feb 2023 07:12:20 -0800 (PST)
MIME-Version: 1.0
References: <20230205155904.2318-1-u9012063@gmail.com> <37577230-b6b8-641c-6b77-c28b8b6fcb8b@intel.com>
In-Reply-To: <37577230-b6b8-641c-6b77-c28b8b6fcb8b@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 17 Feb 2023 07:11:44 -0800
Message-ID: <CALDO+SYJdA370n+k3XS=-VzhPd9XaujhKb-RiBhuNGO9jWr+Aw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v16] vmxnet3: Add XDP support.
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        alexandr.lobakin@intel.com, bang@vmware.com,
        maciej.fijalkowski@intel.com, witu@nvidia.com,
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

Thanks for taking another look!

On Wed, Feb 15, 2023 at 7:56 AM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: William Tu <u9012063@gmail.com>
> Date: Sun,  5 Feb 2023 07:59:04 -0800
>
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> >
> > Background:
> > The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
>
> [...]
>
> > Signed-off-by: William Tu <u9012063@gmail.com>
> > Tested-by: Yifeng Sun <yifengs@vmware.com>
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>
> Hmmm, did I give it? Can't remember :D
Yes :)
https://lore.kernel.org/netdev/1e78d2df-2b9e-3e46-017e-5cc42807db03@intel.com/

>
> > @@ -326,14 +327,16 @@ static void
> >  vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> >                    struct pci_dev *pdev)
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
> >       else
> > -             BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> > +             BUG_ON((map_type & ~VMXNET3_MAP_XDP));
>
> Excesssive braces around the condition :s
Will fix it, thanks!

>
> >
> >       tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
> >  }
> > @@ -341,19 +344,20 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> >
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
> > +     BUG_ON(tbi->skb == NULL);
>
> Prefer `!ptr` over `ptr == NULL`.
Thanks, will do it.

>
> > +     map_type = tbi->map_type;
> >       VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
> >
> >       while (tq->tx_ring.next2comp != eop_idx) {
>
> [...]
>
> > @@ -1253,6 +1290,62 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
> >       return NETDEV_TX_OK;
> >  }
> >
> > +static int
> > +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
> > +               struct vmxnet3_rx_queue *rq, int size)
> > +{
> > +     const struct page_pool_params pp_params = {
> > +             .order = 0,
> > +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > +             .pool_size = size,
> > +             .nid = NUMA_NO_NODE,
> > +             .dev = &adapter->pdev->dev,
> > +             .offset = VMXNET3_XDP_RX_OFFSET,
> > +             .max_len = VMXNET3_XDP_MAX_FRSIZE,
> > +             .dma_dir = DMA_BIDIRECTIONAL,
>
> Don't you want to set the direction depending on whether you have XDP
> enabled? Bidir sync is slower than 1-dir on certain architectures
> without DMA coherence engines, as you need to not only drop the page
> from the cache, but also do a writeback.
thanks for the suggestion, I didn't know that.
I will do s.t like
         pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;

>
> > +     };
> > +     struct page_pool *pp;
> > +     int err;
> > +
> > +     pp = page_pool_create(&pp_params);
> > +     if (IS_ERR(pp))
> > +             return PTR_ERR(pp);
> > +
> > +     err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid,
> > +                            rq->napi.napi_id);
> > +     if (err < 0)
> > +             goto err_free_pp;
> > +
> > +     err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_POOL, pp);
> > +     if (err)
> > +             goto err_unregister_rxq;
> > +
> > +     rq->page_pool = pp;
> > +
> > +     return 0;
> > +
> > +err_unregister_rxq:
> > +     xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +err_free_pp:
> > +     page_pool_destroy(pp);
> > +
> > +     return err;
> > +}
>
> [...]
>
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
> > +                     need_flush |= (act == XDP_REDIRECT);
>
> Also excessive braces :D
ha, you're right, I feel that it looks better :)
I will fix it.

>
> > +
> > +                     goto rcd_done;
> > +             }
> > +skip_xdp:
> > +
> >               if (rcd->sop) { /* first buf of the pkt */
> >                       bool rxDataRingUsed;
> >                       u16 len;
>
> [...]
>
> > @@ -1470,6 +1591,25 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                       rxDataRingUsed =
> >                               VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
> >                       len = rxDataRingUsed ? rcd->len : rbi->len;
> > +
> > +                     if (rxDataRingUsed && vmxnet3_xdp_enabled(adapter)) {
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
> > +                             need_flush |= (act == XDP_REDIRECT);
>
> (same)
Thanks!

>
> > +
> > +                             goto rcd_done;
> > +                     }
> >                       new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
> >                                                           len);
> >                       if (new_skb == NULL) {
>
> [...]
>
> > @@ -1755,13 +1898,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
> >                               &rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
> >
> >                       if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> > -                                     rq->buf_info[ring_idx][i].skb) {
> > +                         rq->buf_info[ring_idx][i].page &&
> > +                         rq->buf_info[ring_idx][i].buf_type ==
> > +                         VMXNET3_RX_BUF_XDP) {
> > +                             page_pool_recycle_direct(rq->page_pool,
> > +                                                      rq->buf_info[ring_idx][i].page);
>
> Too long line. Maybe add a `struct page *` variable in this block to
> avoid this?
Good idea, will do.

>
> > +                             rq->buf_info[ring_idx][i].page = NULL;
> > +                     } else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> > +                                rq->buf_info[ring_idx][i].skb) {
> >                               dma_unmap_single(&adapter->pdev->dev, rxd->addr,
> >                                                rxd->len, DMA_FROM_DEVICE);
> >                               dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
> >                               rq->buf_info[ring_idx][i].skb = NULL;
> >                       } else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
> > -                                     rq->buf_info[ring_idx][i].page) {
> > +                                rq->buf_info[ring_idx][i].page) {
> >                               dma_unmap_page(&adapter->pdev->dev, rxd->addr,
> >                                              rxd->len, DMA_FROM_DEVICE);
> >                               put_page(rq->buf_info[ring_idx][i].page);
> [...]
>
> You also need to resubmit the series to add XDP features advertisement,
> which Lorenzo introduced recently.
Thanks! I didn't know that. Will do it.

> Other that those, looks fine to me, my Rev-by can stay I guess :D

Regards,
William
