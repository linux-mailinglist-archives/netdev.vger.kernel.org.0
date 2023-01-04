Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EED165CAB2
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 01:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjADAVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 19:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjADAVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 19:21:00 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638635F4D
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 16:20:58 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id c124so34898865ybb.13
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 16:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWLq2MWCSa6sSMr4r1cr6ubWVb0qsjLf5+eAW+2B1AM=;
        b=B9HUyI/PMJqsqr7gr9lTV+sH2mlxUf9x/gDIl/Op7uih0qxTo74JHSEvAt+W4yqsMi
         v8iraTTolYs97BWMirPq9tnOHWGSirl11qMXvs5uIoDfG978VXK73BBqYaQ9dveY7gpD
         S1WSSK27TETzrpKoc+U9sp0LHXgXqPUiOXExs9nG6aNHzfJHcdkjAW4hnuGgVAcasS37
         FlLT6vKBxtBO7XtTW8PJVg2vb7YIDa1atIF/OYvC2mvQXP7GRaqaOI3IbpmKnKP/8C4B
         5bHkpc79oL91zw0NTAcqQ3ik9XOFgAk7eInAN9Tu/BBqTES0LexA77vOiF1LTznc+bI8
         SIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWLq2MWCSa6sSMr4r1cr6ubWVb0qsjLf5+eAW+2B1AM=;
        b=KOHAMJBjgNHZtySBUyHWOJk4LxtthI7TWiCe/biSG/jf44EeWK5jSA1wQHEK4WPfTs
         gVd0WeR7WbQ/ieSvdNbSQwa0p++dLZZtZxYhx5gOXbwBP48HQneILpJtxlihQ1zQfAJk
         nqu26Jb3DWP6yCjq6iVRQtwl55zSxKhpAlhbi5fxFhQQEqAQ6Ba9ji4vlQ2+usOYHfbw
         2b06RTyAbHMhPDiYXygtKP3l1j6SkGHxnQ/qx+3I11G3D4tFlA6wP8MHfbcdtBBS3jbx
         OLaCcWWjU3wCQ3yu8A6cjlfCrbtE5c/PKKc/zdulxkY4Awx6ZXs/twD2POHHfpQprpe4
         YkEQ==
X-Gm-Message-State: AFqh2kpsvsCTcDagQBW19EhVIqQ0WghqTBMnEjGeMKDuMmvsUBaj32nd
        QNMsg2AdqZx9xgSBsvGqoJ0ljL1G7XwP7wEVzp4+iBQm
X-Google-Smtp-Source: AMrXdXu4pCdfzxKMfRn1s5+tH3vD5PL1Z9G77JhO+Gatgj1R4iCsKfrhK3Dlq7B71CmVZ2ajjOEUCmVZxkhfMT5+3co=
X-Received: by 2002:a25:d496:0:b0:70c:4fa3:2cce with SMTP id
 m144-20020a25d496000000b0070c4fa32ccemr6510644ybf.539.1672791657259; Tue, 03
 Jan 2023 16:20:57 -0800 (PST)
MIME-Version: 1.0
References: <20230103022232.52412-1-u9012063@gmail.com> <7f936709fb2e61fcf18a0c709dbe5ef7898881f7.camel@gmail.com>
In-Reply-To: <7f936709fb2e61fcf18a0c709dbe5ef7898881f7.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 3 Jan 2023 16:20:20 -0800
Message-ID: <CALDO+SZNA1PX7r0fMUugm0Ewh=JajDAen6uoDffR8UWq8g4B-A@mail.gmail.com>
Subject: Re: [PATCH v8] vmxnet3: Add XDP support.
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com, gerhard@engleder-embedded.com
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

On Tue, Jan 3, 2023 at 8:23 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, 2023-01-02 at 18:22 -0800, William Tu wrote:
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> >
<...>
> > diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> > index d3e7b27eb933..5ce5603542e7 100644
> > --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> > +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> > @@ -28,6 +28,7 @@
> >  #include <net/ip6_checksum.h>
> >
> >  #include "vmxnet3_int.h"
> > +#include "vmxnet3_xdp.h"
> >
> >  char vmxnet3_driver_name[] = "vmxnet3";
> >  #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
> > @@ -332,9 +333,12 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> >       else if (tbi->map_type == VMXNET3_MAP_PAGE)
> >               dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
> >                              DMA_TO_DEVICE);
> > +     else if (tbi->map_type == VMXNET3_MAP_PP_PAGE && tbi->xdpf)
> > +             xdp_return_frame(tbi->xdpf);
> > +     else if (tbi->map_type == VMXNET3_MAP_XDP_NDO && tbi->xdpf)
> > +             xdp_return_frame(tbi->xdpf);
> >       else
> >               BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> > -
> >       tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
> >  }
> >
>
> It looks like you forgot to unmap the buffer in the XDP_NDO case.
>
> See my comment below, it might be worth while to use a bitmap for
> map_type instead of just an enum.
>
> > @@ -351,7 +355,6 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> >       BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
> >
> >       skb = tq->buf_info[eop_idx].skb;
> > -     BUG_ON(skb == NULL);
> >       tq->buf_info[eop_idx].skb = NULL;
> >
> >       VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
> > @@ -587,7 +590,17 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
> >               gd = ring->base + ring->next2fill;
> >               rbi->comp_state = VMXNET3_RXD_COMP_PENDING;
> >
> > -             if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
> > +             if (rbi->buf_type == VMXNET3_RX_BUF_XDP) {
> > +                     void *data = vmxnet3_pp_get_buff(rq->page_pool,
> > +                                                      &rbi->dma_addr,
> > +                                                      GFP_KERNEL);
> > +                     if (!data) {
> > +                             rq->stats.rx_buf_alloc_failure++;
> > +                             break;
> > +                     }
> > +                     rbi->pp_page = virt_to_head_page(data);
> > +                     val = VMXNET3_RXD_BTYPE_HEAD << VMXNET3_RXD_BTYPE_SHIFT;
> > +             } else if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
> >                       if (rbi->skb == NULL) {
> >                               rbi->skb = __netdev_alloc_skb_ip_align(adapter->netdev,
> >                                                                      rbi->len,
> > @@ -1253,6 +1266,46 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
> >       return NETDEV_TX_OK;
> >  }
> >
> > +static int
> > +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
> > +               struct vmxnet3_rx_queue *rq, int size)
> > +{
> > +     struct page_pool_params pp_params = {
> > +             .order = 0,
> > +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > +             .pool_size = size,
> > +             .nid = NUMA_NO_NODE,
> > +             .dev = &adapter->pdev->dev,
> > +             .offset = XDP_PACKET_HEADROOM,
> > +             .max_len = VMXNET3_XDP_MAX_MTU,
> > +             .dma_dir = DMA_BIDIRECTIONAL,
> > +     };
> > +     struct page_pool *pp;
> > +     int err;
> > +
>
> You mentioned a memcpy up above for XDP_TX in the patch description and
> you are using DMA_BIDIRECTIONAL here. Looking at the code it looks like
> you are transmitting the original frame now so you probably need to
> update the patch description.

Right, thanks for reminding that. I will update the commit message.

>
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
> > +     return 0;
> > +
> > +err_unregister_rxq:
> > +     xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +err_free_pp:
> > +     page_pool_destroy(pp);
> > +
> > +     return err;
> > +}
> >
> >  static netdev_tx_t
> >  vmxnet3_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
> > @@ -1265,6 +1318,27 @@ vmxnet3_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
> >                              adapter, netdev);
> >  }
> >
> > +void *
> > +vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
> > +                 gfp_t gfp_mask)
> > +{
> > +     struct page *page;
> > +
> > +     page = page_pool_alloc_pages(pp, gfp_mask | __GFP_NOWARN);
> > +     if (!page)
> > +             return NULL;
> > +
> > +     *dma_addr = page_pool_get_dma_addr(page) + XDP_PACKET_HEADROOM;
> > +     return page_address(page);
> > +}
> > +
> > +static void
> > +vmxnet3_pp_put_buff(struct vmxnet3_rx_queue *rq, struct page *page)
> > +{
> > +     if (rq->page_pool)
> > +             page_pool_put_full_page(rq->page_pool, page,
> > +                                     rq->napi.napi_id);
> > +}
> >
> >  static void
> >  vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
> > @@ -1404,6 +1478,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >       struct Vmxnet3_RxDesc rxCmdDesc;
> >       struct Vmxnet3_RxCompDesc rxComp;
> >  #endif
> > +     bool need_flush = 0;
> > +
> >       vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
> >                         &rxComp);
> >       while (rcd->gen == rq->comp_ring.gen) {
> > @@ -1444,6 +1520,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                       goto rcd_done;
> >               }
> >
> > +             if (rcd->sop && rcd->eop && adapter->xdp_enabled) {
> > +                     struct sk_buff *skb_xdp_pass;
> > +                     int act;
> > +
> > +                     if (rbi->buf_type != VMXNET3_RX_BUF_XDP)
> > +                             goto rcd_done;
> > +
> > +                     if (VMXNET3_RX_DATA_RING(adapter, rcd->rqID)) {
> > +                             netdev_warn(adapter->netdev,
> > +                                         "Rx data ring not support XDP\n");
> > +                             break;
> > +                     }
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
> > +                     goto rcd_done;
> > +             }
> > +
> >               if (rcd->sop) { /* first buf of the pkt */
> >                       bool rxDataRingUsed;
> >                       u16 len;
> > @@ -1485,9 +1586,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >
> >                       if (rxDataRingUsed) {
> >                               size_t sz;
> > -
> >                               BUG_ON(rcd->len > rq->data_ring.desc_size);
> > -
> >                               ctx->skb = new_skb;
> >                               sz = rcd->rxdIdx * rq->data_ring.desc_size;
> >                               memcpy(new_skb->data,
>
> You should keep the space between the variable declaration and the
> BUG_ON.

my mistake, will fix it.

>
> > @@ -1621,7 +1720,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                       }
> >               }
> >
> > -
> > +sop_done:
> >               skb = ctx->skb;
> >               if (rcd->eop) {
> >                       u32 mtu = adapter->netdev->mtu;
> > @@ -1730,6 +1829,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >               vmxnet3_getRxComp(rcd,
> >                                 &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
> >       }
> > +     if (need_flush)
> > +             xdp_do_flush_map();
> >
> >       return num_pkts;
> >  }
> > @@ -1753,8 +1854,14 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
> >  #endif
> >                       vmxnet3_getRxDesc(rxd,
> >                               &rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
> > -
> >                       if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> > +                         rq->buf_info[ring_idx][i].pp_page &&
> > +                         rq->buf_info[ring_idx][i].buf_type ==
> > +                                                     VMXNET3_RX_BUF_XDP) {
> > +                             vmxnet3_pp_put_buff(rq,
> > +                                                 rq->buf_info[ring_idx][i].pp_page);
> > +                             rq->buf_info[ring_idx][i].pp_page = NULL;
> > +                     } else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> >                                       rq->buf_info[ring_idx][i].skb) {
> >                               dma_unmap_single(&adapter->pdev->dev, rxd->addr,
> >                                                rxd->len, DMA_FROM_DEVICE);
> > @@ -1786,9 +1893,9 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
> >
> >       for (i = 0; i < adapter->num_rx_queues; i++)
> >               vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
> > +     adapter->xdp_bpf_prog = NULL;
> >  }
> >
> > -
> >  static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >                              struct vmxnet3_adapter *adapter)
> >  {
> > @@ -1815,6 +1922,13 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >               }
> >       }
> >
> > +     if (rq->page_pool) {
> > +             if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
> > +                     xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +             page_pool_destroy(rq->page_pool);
> > +             rq->page_pool = NULL;
> > +     }
> > +
> >       if (rq->data_ring.base) {
> >               dma_free_coherent(&adapter->pdev->dev,
> >                                 rq->rx_ring[0].size * rq->data_ring.desc_size,
> > @@ -1858,14 +1972,15 @@ static int
> >  vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
> >               struct vmxnet3_adapter  *adapter)
> >  {
> > -     int i;
> > +     int i, err = 0;
> >
> >       /* initialize buf_info */
> >       for (i = 0; i < rq->rx_ring[0].size; i++) {
> >
> >               /* 1st buf for a pkt is skbuff */
> >               if (i % adapter->rx_buf_per_pkt == 0) {
> > -                     rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_SKB;
> > +                     rq->buf_info[0][i].buf_type = adapter->xdp_enabled ?
> > +                             VMXNET3_RX_BUF_XDP : VMXNET3_RX_BUF_SKB;
> >                       rq->buf_info[0][i].len = adapter->skb_buf_size;
> >               } else { /* subsequent bufs for a pkt is frag */
> >                       rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_PAGE;
> > @@ -1886,11 +2001,18 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
> >               rq->rx_ring[i].gen = VMXNET3_INIT_GEN;
> >               rq->rx_ring[i].isOutOfOrder = 0;
> >       }
> > +
> > +     err = vmxnet3_create_pp(adapter, rq,
> > +                             rq->rx_ring[0].size + rq->rx_ring[1].size);
> > +     if (err)
> > +             return err;
> > +
> >       if (vmxnet3_rq_alloc_rx_buf(rq, 0, rq->rx_ring[0].size - 1,
> >                                   adapter) == 0) {
> >               /* at least has 1 rx buffer for the 1st ring */
> >               return -ENOMEM;
> >       }
> > +
> >       vmxnet3_rq_alloc_rx_buf(rq, 1, rq->rx_ring[1].size - 1, adapter);
> >
> >       /* reset the comp ring */
> > @@ -1989,7 +2111,7 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
> >  }
> >
> >
> > -static int
> > +int
> >  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
> >  {
> >       int i, err = 0;
> > @@ -2585,7 +2707,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
> >       if (adapter->netdev->features & NETIF_F_RXCSUM)
> >               devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
> >
> > -     if (adapter->netdev->features & NETIF_F_LRO) {
> > +     if (adapter->netdev->features & NETIF_F_LRO &&
> > +         !adapter->xdp_enabled) {
> >               devRead->misc.uptFeatures |= UPT1_F_LRO;
> >               devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
> >       }
> > @@ -3026,7 +3149,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
> >  }
> >
> >
> > -static void
> > +void
> >  vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >  {
> >       size_t sz, i, ring0_size, ring1_size, comp_size;
> > @@ -3035,7 +3158,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >               if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
> >                                           VMXNET3_MAX_ETH_HDR_SIZE) {
> >                       adapter->skb_buf_size = adapter->netdev->mtu +
> > -                                             VMXNET3_MAX_ETH_HDR_SIZE;
> > +                                             VMXNET3_MAX_ETH_HDR_SIZE +
> > +                                             vmxnet3_xdp_headroom(adapter);
> >                       if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
> >                               adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
> >
> > @@ -3563,7 +3687,6 @@ vmxnet3_reset_work(struct work_struct *data)
> >       clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> >  }
> >
> > -
> >  static int
> >  vmxnet3_probe_device(struct pci_dev *pdev,
> >                    const struct pci_device_id *id)
> > @@ -3585,6 +3708,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
> >  #ifdef CONFIG_NET_POLL_CONTROLLER
> >               .ndo_poll_controller = vmxnet3_netpoll,
> >  #endif
> > +             .ndo_bpf = vmxnet3_xdp,
> > +             .ndo_xdp_xmit = vmxnet3_xdp_xmit,
> >       };
> >       int err;
> >       u32 ver;
> > @@ -3900,6 +4025,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
> >               goto err_register;
> >       }
> >
> > +     adapter->xdp_enabled = false;
> >       vmxnet3_check_link(adapter, false);
> >       return 0;
> >
> > diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> > index 18cf7c723201..6f542236b26e 100644
> > --- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
> > +++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> > @@ -76,6 +76,10 @@ vmxnet3_tq_driver_stats[] = {
> >                                        copy_skb_header) },
> >       { "  giant hdr",        offsetof(struct vmxnet3_tq_driver_stats,
> >                                        oversized_hdr) },
> > +     { "  xdp xmit",         offsetof(struct vmxnet3_tq_driver_stats,
> > +                                      xdp_xmit) },
> > +     { "  xdp xmit err",     offsetof(struct vmxnet3_tq_driver_stats,
> > +                                      xdp_xmit_err) },
> >  };
> >
> >  /* per rq stats maintained by the device */
> > @@ -106,6 +110,16 @@ vmxnet3_rq_driver_stats[] = {
> >                                        drop_fcs) },
> >       { "  rx buf alloc fail", offsetof(struct vmxnet3_rq_driver_stats,
> >                                         rx_buf_alloc_failure) },
> > +     { "     xdp packets", offsetof(struct vmxnet3_rq_driver_stats,
> > +                                    xdp_packets) },
> > +     { "     xdp tx", offsetof(struct vmxnet3_rq_driver_stats,
> > +                               xdp_tx) },
> > +     { "     xdp redirects", offsetof(struct vmxnet3_rq_driver_stats,
> > +                                      xdp_redirects) },
> > +     { "     xdp drops", offsetof(struct vmxnet3_rq_driver_stats,
> > +                                  xdp_drops) },
> > +     { "     xdp aborted", offsetof(struct vmxnet3_rq_driver_stats,
> > +                                    xdp_aborted) },
> >  };
> >
> >  /* global stats maintained by the driver */
> > diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
> > index 3367db23aa13..4c41ceecf785 100644
> > --- a/drivers/net/vmxnet3/vmxnet3_int.h
> > +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> > @@ -56,6 +56,9 @@
> >  #include <linux/if_arp.h>
> >  #include <linux/inetdevice.h>
> >  #include <linux/log2.h>
> > +#include <linux/bpf.h>
> > +#include <linux/skbuff.h>
> > +#include <net/page_pool.h>
> >
> >  #include "vmxnet3_defs.h"
> >
> > @@ -193,6 +196,8 @@ enum vmxnet3_buf_map_type {
> >       VMXNET3_MAP_NONE,
> >       VMXNET3_MAP_SINGLE,
> >       VMXNET3_MAP_PAGE,
> > +     VMXNET3_MAP_PP_PAGE, /* Page pool */
> > +     VMXNET3_MAP_XDP_NDO,
> >  };
> >
>
> One thing you might look at doing here would be to consider making this
> a bitfield rather than just using integer types. You could then do
> something to the effect of:
> Bit     Value
> 0       MAP_SINGLE
> 1       MAP_PAGE
> 2       XDP
>
> Then you won't need as many if statements as you can quickly identify
> if you are dealing with an sk_buff or an xdp_frame and the unmapping
> could be streamlined as it becomes more of a decision tree rather than
> having to hammer through each value sequentially.

Thanks, will do it.

>
> >  struct vmxnet3_tx_buf_info {
> > @@ -201,6 +206,7 @@ struct vmxnet3_tx_buf_info {
> >       u16      sop_idx;
> >       dma_addr_t  dma_addr;
> >       struct sk_buff *skb;
> > +     struct xdp_frame *xdpf;
> >  };
> >
>
> To save yourself space you might want to make this an anonymous union
> with skb, assuming you are triggering on MAP_TYPE and not just the
> pointers themselves.

OK, I will try to make it a union.

>
> >  struct vmxnet3_tq_driver_stats {
> > @@ -217,6 +223,9 @@ struct vmxnet3_tq_driver_stats {
> >       u64 linearized;         /* # of pkts linearized */
> >       u64 copy_skb_header;    /* # of times we have to copy skb header */
> >       u64 oversized_hdr;
> > +
> > +     u64 xdp_xmit;
> > +     u64 xdp_xmit_err;
> >  };
> >
> >  struct vmxnet3_tx_ctx {
> > @@ -258,7 +267,8 @@ struct vmxnet3_tx_queue {
> >  enum vmxnet3_rx_buf_type {
> >       VMXNET3_RX_BUF_NONE = 0,
> >       VMXNET3_RX_BUF_SKB = 1,
> > -     VMXNET3_RX_BUF_PAGE = 2
> > +     VMXNET3_RX_BUF_PAGE = 2,
> > +     VMXNET3_RX_BUF_XDP = 3
> >  };
> >
> >  #define VMXNET3_RXD_COMP_PENDING        0
> > @@ -271,6 +281,7 @@ struct vmxnet3_rx_buf_info {
> >       union {
> >               struct sk_buff *skb;
> >               struct page    *page;
> > +             struct page    *pp_page;
> >       };
> >       dma_addr_t dma_addr;
> >  };
> > @@ -285,6 +296,12 @@ struct vmxnet3_rq_driver_stats {
> >       u64 drop_err;
> >       u64 drop_fcs;
> >       u64 rx_buf_alloc_failure;
> > +
> > +     u64 xdp_packets;        /* Total packets processed by XDP. */
> > +     u64 xdp_tx;
> > +     u64 xdp_redirects;
> > +     u64 xdp_drops;
> > +     u64 xdp_aborted;
> >  };
> >
> >  struct vmxnet3_rx_data_ring {
> > @@ -307,6 +324,8 @@ struct vmxnet3_rx_queue {
> >       struct vmxnet3_rx_buf_info     *buf_info[2];
> >       struct Vmxnet3_RxQueueCtrl            *shared;
> >       struct vmxnet3_rq_driver_stats  stats;
> > +     struct xdp_rxq_info xdp_rxq;
> > +     struct page_pool *page_pool;
> >  } __attribute__((__aligned__(SMP_CACHE_BYTES)));
> >
> >  #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
> > @@ -415,6 +434,8 @@ struct vmxnet3_adapter {
> >       u16    tx_prod_offset;
> >       u16    rx_prod_offset;
> >       u16    rx_prod2_offset;
> > +     bool   xdp_enabled;
> > +     struct bpf_prog __rcu *xdp_bpf_prog;
> >  };
> >
> >  #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
> > @@ -490,6 +511,12 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
> >  void
> >  vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
> >
> > +int
> > +vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter);
> > +
> > +void
> > +vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter);
> > +
> >  netdev_features_t
> >  vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
> >
> > diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
> > new file mode 100644
> > index 000000000000..d38394ffd98a
> > --- /dev/null
> > +++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
> > @@ -0,0 +1,415 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Linux driver for VMware's vmxnet3 ethernet NIC.
> > + * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
> > + * Maintained by: pv-drivers@vmware.com
> > + *
> > + */
> > +
> > +#include "vmxnet3_int.h"
> > +#include "vmxnet3_xdp.h"
> > +
> > +static void
> > +vmxnet3_xdp_exchange_program(struct vmxnet3_adapter *adapter,
> > +                          struct bpf_prog *prog)
> > +{
> > +     rcu_assign_pointer(adapter->xdp_bpf_prog, prog);
> > +     if (prog)
> > +             adapter->xdp_enabled = true;
> > +     else
> > +             adapter->xdp_enabled = false;
> > +}
> > +
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
> > +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     old_bpf_prog = READ_ONCE(adapter->rx_queue[0].adapter->xdp_bpf_prog);
> > +     if (!new_bpf_prog && !old_bpf_prog) {
> > +             adapter->xdp_enabled = false;
> > +             return 0;
> > +     }
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
> > +     if (running && need_update) {
> > +             vmxnet3_reset_dev(adapter);
> > +             vmxnet3_rq_destroy_all(adapter);
> > +             vmxnet3_adjust_rx_ring_size(adapter);
> > +             err = vmxnet3_rq_create_all(adapter);
> > +             if (err) {
> > +                     NL_SET_ERR_MSG_MOD(extack,
> > +                             "failed to re-create rx queues for XDP.");
> > +                     err = -EOPNOTSUPP;
> > +                     goto out;
> > +             }
> > +             err = vmxnet3_activate_dev(adapter);
> > +             if (err) {
> > +                     NL_SET_ERR_MSG_MOD(extack,
> > +                             "failed to activate device for XDP.");
> > +                     err = -EOPNOTSUPP;
> > +                     goto out;
> > +             }
> > +             clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> > +     }
> > +out:
> > +     return err;
> > +}
> > +
> > +/* This is the main xdp call used by kernel to set/unset eBPF program. */
> > +int
> > +vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> > +{
> > +     switch (bpf->command) {
> > +     case XDP_SETUP_PROG:
> > +             netdev_dbg(netdev, "XDP: set program to ");
> > +             return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +     return 0;
> > +}
> > +
> > +int
> > +vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter)
> > +{
> > +     if (adapter->xdp_enabled)
> > +             return VMXNET3_XDP_ROOM;
> > +     else
> > +             return 0;
> > +}
> > +
> > +void
> > +vmxnet3_unregister_xdp_rxq(struct vmxnet3_rx_queue *rq)
> > +{
> > +     xdp_rxq_info_unreg_mem_model(&rq->xdp_rxq);
> > +     xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +}
> > +
> > +int
> > +vmxnet3_register_xdp_rxq(struct vmxnet3_rx_queue *rq,
> > +                      struct vmxnet3_adapter *adapter)
> > +{
> > +     int err;
> > +
> > +     err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid, 0);
> > +     if (err < 0)
> > +             return err;
> > +
> > +     err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_SHARED,
> > +                                      NULL);
> > +     if (err < 0) {
> > +             xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +             return err;
> > +     }
> > +     return 0;
> > +}
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
> > +             ret = -ENOSPC;
> > +             goto exit;
> > +     }
> > +
> > +     if (dma_map) { /* ndo_xdp_xmit */
> > +             tbi->map_type = VMXNET3_MAP_XDP_NDO;
> > +             tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
> > +                                    xdpf->data, buf_size,
> > +                                    DMA_TO_DEVICE);
> > +             if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr)) {
> > +                     ret = -EFAULT;
> > +                     goto exit;
> > +             }
> > +             tbi->xdpf = xdpf;
> > +     } else { /* XDP buffer from page pool */
> > +             tbi->map_type = VMXNET3_MAP_PP_PAGE;
> > +             page = virt_to_head_page(xdpf->data);
> > +             tbi->dma_addr = page_pool_get_dma_addr(page) +
> > +                             XDP_PACKET_HEADROOM;
> > +             dma_sync_single_for_device(&adapter->pdev->dev,
> > +                                        tbi->dma_addr, buf_size,
> > +                                        DMA_BIDIRECTIONAL);
> > +             tbi->skb = NULL;
> > +             tbi->xdpf = xdpf;
> > +     }
> > +     tbi->len = buf_size;
> > +
> > +     gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
> > +     WARN_ON_ONCE(gdesc->txd.gen == tq->tx_ring.gen);
> > +
> > +     gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
> > +     gdesc->dword[2] = cpu_to_le32(dw2);
> > +
> > +     /* Setup the EOP desc */
> > +     gdesc->dword[3] = cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
> > +
> > +     gdesc->txd.om = 0;
> > +     gdesc->txd.msscof = 0;
> > +     gdesc->txd.hlen = 0;
> > +     gdesc->txd.ti = 0;
> > +
> > +     tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
> > +     tq->shared->txNumDeferred += 1;
> > +     tx_num_deferred++;
> > +
> > +     vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
> > +
> > +     /* set the last buf_info for the pkt */
> > +     tbi->sop_idx = ctx.sop_txd - tq->tx_ring.base;
> > +
> > +     dma_wmb();
> > +     gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> > +                                               VMXNET3_TXD_GEN);
> > +     if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
> > +             tq->shared->txNumDeferred = 0;
> > +             VMXNET3_WRITE_BAR0_REG(adapter,
> > +                                    VMXNET3_REG_TXPROD + tq->qid * 8,
> > +                                    tq->tx_ring.next2fill);
> > +     }
> > +exit:
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
> > +     tq = &adapter->tx_queue[cpu % tq_number];
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
> > +
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> > +             return -ENETDOWN;
> > +     if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> > +             return -EINVAL;
> > +
> > +     tq_number = adapter->num_tx_queues;
> > +     cpu = smp_processor_id();
> > +     tq = &adapter->tx_queue[cpu % tq_number];
>
> If possible you may want to avoid the modulus operation as it costs a
> signficant number of cycles. You may be better off either doing it
> conditionally if you normally expect tq_number > cpu or using
> reciprocal_scale like we do in skb_tx_hash if you expect it to occur
> more often.
Good point. I will fix it.

>
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
> > +     int err;
> > +     u32 act;
> > +
> > +     act = bpf_prog_run_xdp(rq->adapter->xdp_bpf_prog, xdp);
> > +     rq->stats.xdp_packets++;
> > +
> > +     switch (act) {
> > +     case XDP_PASS:
> > +             goto out;
> > +     case XDP_REDIRECT:
> > +             err = xdp_do_redirect(rq->adapter->netdev, xdp,
> > +                                   rq->adapter->xdp_bpf_prog);
> > +             if (!err)
> > +                     rq->stats.xdp_redirects++;
> > +             else
> > +                     rq->stats.xdp_drops++;
> > +             goto out;
> > +     case XDP_TX:
> > +             xdpf = xdp_convert_buff_to_frame(xdp);
> > +             if (!xdpf || vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> > +                     rq->stats.xdp_drops++;
> > +                     goto out_recycle;
> > +             }
> > +             rq->stats.xdp_tx++;
> > +             goto out;
> > +     default:
> > +             bpf_warn_invalid_xdp_action(rq->adapter->netdev,
> > +                                         rq->adapter->xdp_bpf_prog, act);
> > +             fallthrough;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev,
> > +                                 rq->adapter->xdp_bpf_prog, act);
> > +             rq->stats.xdp_aborted++;
> > +             break;
> > +     case XDP_DROP:
> > +             rq->stats.xdp_drops++;
> > +             break;
> > +     }
> > +
> > +out_recycle:
> > +     page_pool_recycle_direct(rq->page_pool,
> > +                              virt_to_head_page(xdp->data_hard_start));
> > +out:
> > +     return act;
> > +}
> > +
> > +static struct sk_buff *
> > +vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page)
> > +{
> > +     struct sk_buff *skb;
> > +
> > +     if (!page)
> > +             return NULL;
> > +
> > +     skb = build_skb(page_address(page), PAGE_SIZE);
> > +     if (unlikely(!skb)) {
> > +             page_pool_put_full_page(rq->page_pool, page, true);
> > +             rq->stats.rx_buf_alloc_failure++;
> > +             return NULL;
> > +     }
> > +     return skb;
> > +}
> > +
> > +int
> > +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> > +                 struct vmxnet3_rx_queue *rq,
> > +                 struct Vmxnet3_RxCompDesc *rcd,
> > +                 struct vmxnet3_rx_buf_info *rbi,
> > +                 struct Vmxnet3_RxDesc *rxd,
> > +                 struct sk_buff **skb_xdp_pass)
> > +{
> > +     struct bpf_prog *xdp_prog;
> > +     dma_addr_t new_dma_addr;
> > +     struct sk_buff *skb;
> > +     struct xdp_buff xdp;
> > +     struct page *page;
> > +     void *new_data;
> > +     int act;
> > +
> > +     act = XDP_DROP;
> > +     if (unlikely(rcd->len == 0))
> > +             goto refill;
> > +
> > +     page = rbi->pp_page;
> > +     if (!page)
> > +             goto refill;
>
> This should be some sort of bug shouldn't it? I would think you
> shouldn't be processing a buffer if there isn't a page on it already.
> If I am not mistaken at this point the hardware has already set sop/eop
> on the RCD so that means there was a page there doesn't it?

Yes, this shouldn't happen and if it is, then it's a bug.
I will remove this check or add BUG_ON()

Thanks for taking another round of review.
Will start working on next version.
William
