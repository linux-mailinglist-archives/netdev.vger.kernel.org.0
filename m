Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE63B676805
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 19:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjAUSaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 13:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjAUSaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 13:30:09 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64121D917
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 10:30:05 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-4ff1fa82bbbso71261217b3.10
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 10:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+opH0Q90CNNs+kiXS+/lTdXhE/TYFxQcj/jSt1I0iwM=;
        b=Cvk5pWcmIFzoXz6/etjZLwYrMJkUws9hCW57CtscrmO6G+CqbJW44sipdSf5d4f2jv
         yehW3hMF/TEDPa9QPPNmZin8BP1VSncslHlDmganxaJhUTxJs9riKaoKN1PzS5ZO2mhF
         B54cCmXexI3wW5nPZmzlH5a7NYBhSJmpYJv1LWr/16IQligOiNjIFpz9iiWqnvgjcwuo
         9en1hAQJeHJuxRJzG/qHFzNoE5FCpM1jjcFAiey3u9Y1V+jg6iArr4IezcvNAqTj6Bh3
         X1Pi29FkpC5GbRRFBlGhSA4c094MXQ5cEWSj81FwxzlpGoVBw5BSomCz/X7WilZPSOTH
         Ikaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+opH0Q90CNNs+kiXS+/lTdXhE/TYFxQcj/jSt1I0iwM=;
        b=ZgFmgqcCFEKsTVqpxKgByNPI0PHSFGALTjVb1ixSb1pNM9cNWDQIvhYmBP1odV96Ll
         olG+/a5YPZ3xv5bC0hCngflKd3/G0j6VSh/+BHZrUWdkp6/JpxMRcapT2aGDIvY3huRH
         lsDvTetDu3NfgVHxLQDbjUCZYrsdVi3LwLX3rwjZZBCs1KLqQJUz1qPBOXVagSuWsN2L
         CTCBj7e/+kJ7Hv8+qxEezqmPJpX60Ms6seMRMM72MmERDamBKc0Z3dXWseT3Hbp9dHKv
         0fFkLGWPNqXtEdXR46Uua2ZbdEOTKyqePo46agAF2Dqici3BTR7wd5YX/nQ1+kJ0BG8u
         ygxw==
X-Gm-Message-State: AFqh2kpvzqWAM/WOkcV/crkxszQxD2MfsDbrj7TgB2d/iTdGK0aC2ydY
        m7d5x3wLcpeR+ggNKouyAYlat8W/Sn2PHg5+feadt8pvue+XwQ==
X-Google-Smtp-Source: AMrXdXteAWgS9VXz/cImpY8vi/nCw4V//e4PVEMxod+Nc//r6O11SWNoAIW9MpOUOxWuUi46Gh2pLeLWyFkiSz6PWjo=
X-Received: by 2002:a81:99c8:0:b0:4fd:c7b4:a9cf with SMTP id
 q191-20020a8199c8000000b004fdc7b4a9cfmr1095913ywg.36.1674325804711; Sat, 21
 Jan 2023 10:30:04 -0800 (PST)
MIME-Version: 1.0
References: <20230112140743.7438-1-u9012063@gmail.com> <450e40d1-cec6-ba81-90c3-276eeddd1dd1@intel.com>
In-Reply-To: <450e40d1-cec6-ba81-90c3-276eeddd1dd1@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sat, 21 Jan 2023 10:29:28 -0800
Message-ID: <CALDO+SYoQ5OaEdxFGh8Xr5Y-kDzGB679F+fSKQGsk-4=i4vOaA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v13] vmxnet3: Add XDP support.
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        gerhard@engleder-embedded.com, bang@vmware.com
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

On Wed, Jan 18, 2023 at 6:17 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: William Tu <u9012063@gmail.com>
> Date: Thu, 12 Jan 2023 06:07:43 -0800
>
> First of all, sorry for the huge delay. I have a couple ten thousand
> lines of code to review this week, not counting LKML submissions >_<
>
Hi Alexander,

I totally understand, and thanks again for taking another review of this patch.
Your feedback is very much appreciated.


> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
>
> [...]
>
> > -     skb = tq->buf_info[eop_idx].skb;
> > -     BUG_ON(skb == NULL);
> > -     tq->buf_info[eop_idx].skb = NULL;
> > -
> > +     tbi = &tq->buf_info[eop_idx];
> > +     BUG_ON(tbi->skb == NULL);
> > +     map_type = tbi->map_type;
> >       VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
> >
> >       while (tq->tx_ring.next2comp != eop_idx) {
> >               vmxnet3_unmap_tx_buf(tq->buf_info + tq->tx_ring.next2comp,
> >                                    pdev);
> > -
>
> Nit: please try to avoid such unrelated changes. Moreover, I feel like
> it's better for readability to have a newline here, so see no reason to
> remove it.

Thanks! There are many mistakes like this below (either missing or
need space, RCT style, adding unlikely, Unneeded change),
I will fix them in next version.

>
> >               /* update next2comp w/o tx_lock. Since we are marking more,
> >                * instead of less, tx ring entries avail, the worst case is
> >                * that the tx routine incorrectly re-queues a pkt due to
> > @@ -369,7 +371,14 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> >               entries++;
> >       }
> >
> > -     dev_kfree_skb_any(skb);
> > +     if (map_type & VMXNET3_MAP_XDP)
> > +             xdp_return_frame_bulk(tbi->xdpf, bq);
> > +     else
> > +             dev_kfree_skb_any(tbi->skb);
>
> Not really related to XDP, but maybe for some future improvements: this
> function is to be called inside the BH context only, so using
> napi_consume_skb() would give you some nice perf improvement.

Sure, thanks for pointing this. I will keep this in future work list in
the commit message.

>
> > +
> > +     /* xdpf and skb are in an anonymous union. */
> > +     tbi->skb = NULL;
> > +
> >       return entries;
> >  }
> >
> > @@ -379,8 +388,10 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
> >                       struct vmxnet3_adapter *adapter)
> >  {
> >       int completed = 0;
> > +     struct xdp_frame_bulk bq;
> >       union Vmxnet3_GenericDesc *gdesc;
>
> RCT style of declarations?
>
> >
> > +     xdp_frame_bulk_init(&bq);
> >       gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
> >       while (VMXNET3_TCD_GET_GEN(&gdesc->tcd) == tq->comp_ring.gen) {
> >               /* Prevent any &gdesc->tcd field from being (speculatively)
>
> [...]
>
> > @@ -1253,6 +1283,60 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
> >       return NETDEV_TX_OK;
> >  }
> >
> > +static int
> > +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
> > +               struct vmxnet3_rx_queue *rq, int size)
> > +{
> > +     const struct page_pool_params pp_params = {
> > +             .order = 0,
>
> Nit: it will be zeroed implicitly, so can be omitted. OTOH if you want
> to explicitly say that you always use order-0 pages only, you can leave
> it here.
I will leave it here as it's more clear.

>
> > +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > +             .pool_size = size,
> > +             .nid = NUMA_NO_NODE,
> > +             .dev = &adapter->pdev->dev,
> > +             .offset = XDP_PACKET_HEADROOM,
>
> Curious, on which architectures does this driver work in the real world?
> Is it x86 only or maybe 64-bit systems only? Because not having
> %NET_IP_ALIGN here will significantly slow down Rx on the systems where
> it's defined as 2, not 0 (those systems can't stand unaligned access).

Interesting, and I don't know that after I research a little.
I tested only on x86 and 64bit. But in reality vmxnet3 works in other
architectures.
I will define s.t like below
   #define VMXNET3_XDP_HEADROOM       (XDP_PACKET_HEADROOM + NET_IP_ALIGN)

>
> > +             .max_len = VMXNET3_XDP_MAX_MTU,
> > +             .dma_dir = DMA_BIDIRECTIONAL,
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
>
> Nit: newline here?
>
> > +     return 0;
> > +
> > +err_unregister_rxq:
> > +     xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +err_free_pp:
> > +     page_pool_destroy(pp);
> > +
> > +     return err;
> > +}
> > +
> > +void *
> > +vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
> > +                 gfp_t gfp_mask)
> > +{
> > +     struct page *page;
> > +
> > +     page = page_pool_alloc_pages(pp, gfp_mask | __GFP_NOWARN);
> > +     if (!page)
>
> unlikely()? It's error/exception path, you will never hit this branch
> under normal conditions.
>
> > +             return NULL;
> > +
> > +     *dma_addr = page_pool_get_dma_addr(page) + XDP_PACKET_HEADROOM;
>
> Hmm, I'd rather say:
>
>         *dma_addr = page_pool_get_dma_addr(page) + pp->p.offset;
>
> Then you'd need to adujst offset only once in the function where you
> create Page Pool if/when you need to change the Rx offset.
> With the current code, it's easy to forget you need to change it in two
> places.
> Alternatively, you could define something like
>
> #define VMXNET3_RX_OFFSET       XDP_PACKET_HEADROOM
got it, thanks.
Also consider the NET_IP_ALIGN suggestion, I will do
#define VMXNET3_RX_OFFSET       (XDP_PACKET_HEADROOM + NET_IP_ALIGN)

>
> and use it here and on Page Pool creation. Then, if you need to change
> the Rx offset one day, you will adjust only that definition.
>
> (also nit re newline before return?)
>
> > +     return page_address(page);
> > +}
> >
> >  static netdev_tx_t
> >  vmxnet3_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
> > @@ -1404,6 +1488,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >       struct Vmxnet3_RxDesc rxCmdDesc;
> >       struct Vmxnet3_RxCompDesc rxComp;
> >  #endif
> > +     bool need_flush = 0;
>
> = false, it's boolean, not int.
>
> > +
> >       vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
> >                         &rxComp);
> >       while (rcd->gen == rq->comp_ring.gen) {
>
> [...]
>
> > @@ -1622,6 +1754,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >               }
> >
> >
> > +sop_done:
> >               skb = ctx->skb;
> >               if (rcd->eop) {
> >                       u32 mtu = adapter->netdev->mtu;
> > @@ -1730,6 +1863,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >               vmxnet3_getRxComp(rcd,
> >                                 &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
> >       }
> > +     if (need_flush)
> > +             xdp_do_flush();
>
> What about %XDP_TX? On each %XDP_TX we usually only place the frame to a
> Tx ring and hit the doorbell to kick Tx only here, before xdp_do_flush().

I think it's ok here. For XDP_TX, we place the frame to tx ring and wait until
a threshold (%tq->shared->txThreshold), then hit the doorbell.

>
> >
> >       return num_pkts;
> >  }
> > @@ -1755,13 +1890,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
> >                               &rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
> >
> >                       if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> > -                                     rq->buf_info[ring_idx][i].skb) {
> > +                         rq->buf_info[ring_idx][i].pp_page &&
> > +                         rq->buf_info[ring_idx][i].buf_type ==
> > +                         VMXNET3_RX_BUF_XDP) {
> > +                             page_pool_recycle_direct(rq->page_pool,
> > +                                                      rq->buf_info[ring_idx][i].pp_page);
> > +                             rq->buf_info[ring_idx][i].pp_page = NULL;
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
> > @@ -1786,9 +1928,9 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
> >
> >       for (i = 0; i < adapter->num_rx_queues; i++)
> >               vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
> > +     rcu_assign_pointer(adapter->xdp_bpf_prog, NULL);
> >  }
> >
> > -
>
> (nit: also unrelated)
>
> >  static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >                              struct vmxnet3_adapter *adapter)
> >  {
> > @@ -1815,6 +1957,13 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >               }
> >       }
> >
> > +     if (rq->page_pool) {
>
> Isn't it always true? You always create a Page Pool per each RQ IIUC?
good catch, will remove the check.

>
> > +             if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
> > +                     xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +             page_pool_destroy(rq->page_pool);
> > +             rq->page_pool = NULL;
> > +     }
> > +
> >       if (rq->data_ring.base) {
> >               dma_free_coherent(&adapter->pdev->dev,
> >                                 rq->rx_ring[0].size * rq->data_ring.desc_size,
>
> [...]
>
> > -static int
> > +int
> >  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
> >  {
> >       int i, err = 0;
> > @@ -2585,7 +2742,7 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
> >       if (adapter->netdev->features & NETIF_F_RXCSUM)
> >               devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
> >
> > -     if (adapter->netdev->features & NETIF_F_LRO) {
> > +     if ((adapter->netdev->features & NETIF_F_LRO)) {
>
> Unneeded change (moreover, Clang sometimes triggers on such on W=1+)
>
> >               devRead->misc.uptFeatures |= UPT1_F_LRO;
> >               devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
> >       }
> > @@ -3026,7 +3183,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
> >  }
> >
> >
> > -static void
> > +void
> >  vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >  {
> >       size_t sz, i, ring0_size, ring1_size, comp_size;
> > @@ -3035,7 +3192,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >               if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
> >                                           VMXNET3_MAX_ETH_HDR_SIZE) {
> >                       adapter->skb_buf_size = adapter->netdev->mtu +
> > -                                             VMXNET3_MAX_ETH_HDR_SIZE;
> > +                                             VMXNET3_MAX_ETH_HDR_SIZE +
> > +                                             vmxnet3_xdp_headroom(adapter);
> >                       if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
> >                               adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
> >
> > @@ -3563,7 +3721,6 @@ vmxnet3_reset_work(struct work_struct *data)
> >       clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> >  }
> >
> > -
>
> (unrelated)
>
> >  static int
> >  vmxnet3_probe_device(struct pci_dev *pdev,
> >                    const struct pci_device_id *id)
>
> [...]
>
> >  enum vmxnet3_rx_buf_type {
> >       VMXNET3_RX_BUF_NONE = 0,
> >       VMXNET3_RX_BUF_SKB = 1,
> > -     VMXNET3_RX_BUF_PAGE = 2
> > +     VMXNET3_RX_BUF_PAGE = 2,
> > +     VMXNET3_RX_BUF_XDP = 3
>
> I'd always leave a ',' after the last entry. As you can see, if you
> don't do that, you have to introduce 2 lines of changes instead of just
> 1 when you add a new entry.
thanks, that's good point. Will do it, thanks!

>
> >  };
> >
> >  #define VMXNET3_RXD_COMP_PENDING        0
> > @@ -271,6 +279,7 @@ struct vmxnet3_rx_buf_info {
> >       union {
> >               struct sk_buff *skb;
> >               struct page    *page;
> > +             struct page    *pp_page; /* Page Pool for XDP frame */
>
> Why not just use the already existing field if they're of the same type?

I guess in the beginning I want to avoid mixing the two cases/rings.
I will use just %page as you suggest.

>
> >       };
> >       dma_addr_t dma_addr;
> >  };
>
> [...]
>
> > +static int
> > +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> > +             struct netlink_ext_ack *extack)
> > +{
> > +     struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> > +     struct bpf_prog *new_bpf_prog = bpf->prog;
> > +     struct bpf_prog *old_bpf_prog;
> > +     bool need_update;
> > +     bool running;
> > +     int err = 0;
> > +
> > +     if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
>
> Mismatch: as I said before, %VMXNET3_XDP_MAX_MTU is not MTU, rather max
> frame len. At the same time, netdev->mtu is real MTU, which doesn't
> include Eth, VLAN and FCS.

Thanks!
So I should include the hardware header length, define s.t like
#define VMXNET3_RX_OFFSET       (XDP_PACKET_HEADROOM + NET_IP_ALIGN)
#define VMXNET3_XDP_MAX_MTU    PAGE_SIZE - VMXNET3_RX_OFFSET -
dev->hard_header_len

>
> > +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
>
> Any plans to add XDP multi-buffer support?
>
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if ((adapter->netdev->features & NETIF_F_LRO)) {
>
> (redundant braces)
>
> > +             netdev_err(adapter->netdev, "LRO is not supported with XDP");
>
> Why is this error printed via netdev_err(), not NL_SET()?

I want to show the error message in dmesg, which I didn't see it
printed when using NL_SET
is it better to use NL_SET?

>
> > +             adapter->netdev->features &= ~NETIF_F_LRO;
> > +     }
> > +
> > +     old_bpf_prog = rcu_dereference(adapter->xdp_bpf_prog);
> > +     if (!new_bpf_prog && !old_bpf_prog)
> > +             return 0;
> > +
> > +     running = netif_running(netdev);
> > +     need_update = !!old_bpf_prog != !!new_bpf_prog;
> > +
> > +     if (running && need_update)
> > +             vmxnet3_quiesce_dev(adapter);
> > +
> > +     vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
> > +     if (old_bpf_prog)
> > +             bpf_prog_put(old_bpf_prog);
> > +
> > +     if (!running || !need_update)
> > +             return 0;
> > +
> > +     vmxnet3_reset_dev(adapter);
> > +     vmxnet3_rq_destroy_all(adapter);
> > +     vmxnet3_adjust_rx_ring_size(adapter);
> > +     err = vmxnet3_rq_create_all(adapter);
> > +     if (err) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "failed to re-create rx queues for XDP.");
> > +             err = -EOPNOTSUPP;
> > +             return err;
>
> return -OPNOTSUPP? Why doing it in two steps?
>
> > +     }
> > +     err = vmxnet3_activate_dev(adapter);
> > +     if (err) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "failed to activate device for XDP.");
> > +             err = -EOPNOTSUPP;
> > +             return err;
>
> (same)
>
> > +     }
> > +     clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
>
> (classic newline nit)
>
> > +     return err;
>
> @err will be 0 at this point, return it directly.
>
> > +}
> > +
> > +/* This is the main xdp call used by kernel to set/unset eBPF program. */
> > +int
> > +vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> > +{
> > +     switch (bpf->command) {
> > +     case XDP_SETUP_PROG:
> > +             return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +     return 0;
> > +}
> > +
> > +bool
> > +vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter)
> > +{
> > +     return !!rcu_access_pointer(adapter->xdp_bpf_prog);
> > +}
> > +
> > +int
> > +vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter)
> > +{
> > +     return vmxnet3_xdp_enabled(adapter) ? VMXNET3_XDP_PAD : 0;
>
> Uhm, the function is called '_headroom', but in fact it returns skb
> overhead (headroom + tailroom).
> Also, I don't feel like it's incorrect to return 0 as skb overhead, as
> you unconditionally set PP offset to %XDP_PACKET_HEADROOM, plus skb
> tailroom is always `SKB_DATA_ALIGN(sizeof(skb_shared_info))` regardless
> of XDP prog presence. So I'd rather always return _XDP_PAD (or just
> embed this definition into the single call site).
>
> > +}
>
> Making these 2 functions global are overkill and doesn't affect
> performance positively. They can easily be static inlines.

right, I realize vmxnet3_xdp_headroom is used only at one place.
I will embed into the code.
and I will make the vmxnet3_xdp_enable static inline
thanks!

>
> > +
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
>
> [...]
>
> > +     dma_wmb();
> > +     gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> > +                                               VMXNET3_TXD_GEN);
> > +
> > +     if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
> > +             tq->shared->txNumDeferred = 0;
> > +             VMXNET3_WRITE_BAR0_REG(adapter,
> > +                                    VMXNET3_REG_TXPROD + tq->qid * 8,
> > +                                    tq->tx_ring.next2fill);
> > +     }
>
> (NL))
>
> > +     return ret;
> > +}
> > +
> > +static int
> > +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> > +                   struct xdp_frame *xdpf)
> > +{
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int err = 0, cpu;
> > +     int tq_number;
> > +
> > +     tq_number = adapter->num_tx_queues;
> > +     cpu = smp_processor_id();
> > +     if (likely(cpu < tq_number))
> > +             tq = &adapter->tx_queue[cpu];
> > +     else
> > +             tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
>
> Interesting solution, the first time I see such. Usually we do just
> `smp_processor_id() % num_tx_queues`. I don't say yours is worse, just a
> sidenote :)

ha, yes, I learned from Alexander Duyck's feedback

>
> > +     if (tq->stopped)
> > +             return -ENETDOWN;
> > +
> > +     nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> > +
> > +     __netif_tx_lock(nq, cpu);
> > +     err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq, false);
> > +     __netif_tx_unlock(nq);
> > +     return err;
> > +}
> > +
> > +/* ndo_xdp_xmit */
> > +int
> > +vmxnet3_xdp_xmit(struct net_device *dev,
> > +              int n, struct xdp_frame **frames, u32 flags)
> > +{
> > +     struct vmxnet3_adapter *adapter;
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int i, err, cpu;
> > +     int tq_number;
> > +
> > +     adapter = netdev_priv(dev);
>
> Nit: embed into the declaration?
>
> > +
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> > +             return -ENETDOWN;
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> > +             return -EINVAL;
> > +
> > +     tq_number = adapter->num_tx_queues;
> > +     cpu = smp_processor_id();
> > +     if (likely(cpu < tq_number))
> > +             tq = &adapter->tx_queue[cpu];
> > +     else
> > +             tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
> > +     if (tq->stopped)
> > +             return -ENETDOWN;
> > +
> > +     nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> > +
> > +     for (i = 0; i < n; i++) {
> > +             err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true);
> > +             if (err) {
> > +                     tq->stats.xdp_xmit_err++;
> > +                     break;
> > +             }
> > +     }
> > +     tq->stats.xdp_xmit += i;
> > +
> > +     return i;
> > +}
> > +
> > +static int
> > +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp)
> > +{
> > +     struct xdp_frame *xdpf;
> > +     struct bpf_prog *prog;
> > +     int err;
> > +     u32 act;
> > +
> > +     prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> > +     act = bpf_prog_run_xdp(prog, xdp);
> > +     rq->stats.xdp_packets++;
> > +
> > +     switch (act) {
> > +     case XDP_PASS:
> > +             return act;
> > +     case XDP_REDIRECT:
> > +             err = xdp_do_redirect(rq->adapter->netdev, xdp, prog);
> > +             if (!err)
> > +                     rq->stats.xdp_redirects++;
> > +             else
> > +                     rq->stats.xdp_drops++;
> > +             return act;
> > +     case XDP_TX:
> > +             xdpf = xdp_convert_buff_to_frame(xdp);
> > +             if (!xdpf || vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
>
> I think this also could be unlikely()?
>
> > +                     rq->stats.xdp_drops++;
> > +                     page_pool_recycle_direct(rq->page_pool,
> > +                              virt_to_head_page(xdp->data_hard_start));
>
> Uff, I don't like this line break. Maybe grab the page into a local var
> at first and then pass it to the function?
OK!

>
> > +             } else {
> > +                     rq->stats.xdp_tx++;
> > +             }
> > +             return act;
> > +     default:
> > +             bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
> > +             fallthrough;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev, prog, act);
> > +             rq->stats.xdp_aborted++;
> > +             break;
> > +     case XDP_DROP:
> > +             rq->stats.xdp_drops++;
> > +             break;
> > +     }
> > +
> > +     page_pool_recycle_direct(rq->page_pool,
> > +                              virt_to_head_page(xdp->data_hard_start));
> > +     return act;
> > +}
> > +
> > +static struct sk_buff *
> > +vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
> > +               const struct xdp_buff *xdp)
> > +{
> > +     struct sk_buff *skb;
> > +
> > +     skb = build_skb(page_address(page), PAGE_SIZE);
> > +     if (unlikely(!skb)) {
> > +             page_pool_recycle_direct(rq->page_pool, page);
> > +             rq->stats.rx_buf_alloc_failure++;
> > +             return NULL;
> > +     }
> > +
> > +     /* bpf prog might change len and data position. */
> > +     skb_reserve(skb, xdp->data - xdp->data_hard_start);
> > +     skb_put(skb, xdp->data_end - xdp->data);
> > +     skb_mark_for_recycle(skb);
> > +
> > +     return skb;
> > +}
> > +
> > +/* Handle packets from DataRing. */
> > +int
> > +vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
> > +                       struct vmxnet3_rx_queue *rq,
> > +                       void *data, int len,
> > +                       struct sk_buff **skb_xdp_pass)
> > +{
> > +     struct bpf_prog *xdp_prog;
> > +     struct xdp_buff xdp;
> > +     struct page *page;
> > +     int act;
> > +
> > +     page = page_pool_alloc_pages(rq->page_pool, GFP_ATOMIC);
> > +     if (!page) {
>
> (unlikely nit)
>
> > +             rq->stats.rx_buf_alloc_failure++;
> > +             return XDP_DROP;
> > +     }
> > +
> > +     xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
> > +                      len, false);
> > +     xdp_buff_clear_frags_flag(&xdp);
> > +
> > +     /* Must copy the data because it's at dataring. */
> > +     memcpy(xdp.data, data, len);
>
> Wanted to write "oh, too bad we have to copy the data" and only then
> noticed your explanation that dataring is used for frames < 128 bytes
> only :D

:D

>
> > +
> > +     rcu_read_lock();
> > +     xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> > +     if (!xdp_prog) {
> > +             rcu_read_unlock();
> > +             page_pool_recycle_direct(rq->page_pool, page);
> > +             act = XDP_PASS;
> > +             goto out_skb;
> > +     }
> > +     act = vmxnet3_run_xdp(rq, &xdp);
> > +     rcu_read_unlock();
> > +
> > +out_skb:
>
> Nit: you can move this label one line below and skip always-true branch
> when !xdp_prog.
>
> > +     if (act == XDP_PASS) {
> > +             *skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> > +             if (!skb_xdp_pass)
> > +                     return XDP_DROP;
> > +     }
>
> [...]
>
> > +#include "vmxnet3_int.h"
> > +
> > +#define VMXNET3_XDP_PAD (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
> > +                      XDP_PACKET_HEADROOM)
> > +#define VMXNET3_XDP_MAX_MTU (PAGE_SIZE - VMXNET3_XDP_PAD)
>
> Uhm, couldn't say it's valid to name it as "MTU", it's rather max frame
> size. MTU doesn't include Ethernet, VLAN headers and FCS.
Got it, will rename it.

Working on next version now...
Thanks
William
