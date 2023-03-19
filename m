Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCBB6C036E
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 18:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjCSRVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 13:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCSRU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 13:20:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D539972AB
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 10:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679246456; x=1710782456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dmIafOXCTcLqwEvUFLGW3L3ZU7QaNUkhudhb4HFKYxU=;
  b=QMdKO5ztQHdSH7iYZzJxyQNMP5r2Q8CHkkqM46wgZNqGebyTVPlAB5bW
   l9BTkuR0jWByeW8FvykBjEURks3y0YsvO4IQLt0al4R6MS9UBUkLXnQbr
   oX2LFD4wW1rOrRLfEivaoEasjtUOVzxCYhSm4skn0xFc+SuHZgC6IWKFq
   88UDoDXujrBEXPPYuzwAyvvBjxI87hPyaKA5qTUL3AfO7H40kNhqQtVV6
   x8SVZaJCUnfrfNs1ZqgMD+sNvmKcfGTA1TLP+RCWNnZgCo4hWXqo8ctvj
   kSIHOay0B/FSPsv84uMFG3mDVXV/YHGaYECgWj6SZ2eyi5j06XOEOATJE
   w==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="scan'208";a="205414549"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Mar 2023 10:20:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 19 Mar 2023 10:20:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Sun, 19 Mar 2023 10:20:53 -0700
Date:   Sun, 19 Mar 2023 18:20:52 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <alexandr.lobakin@intel.com>,
        <bang@vmware.com>, <maciej.fijalkowski@intel.com>,
        <witu@nvidia.com>, Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH RFC v18 net-next] vmxnet3: Add XDP support.
Message-ID: <20230319172052.gkzu7h227ulkog6o@soft-dev3-1>
References: <20230318214953.36834-1-u9012063@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230318214953.36834-1-u9012063@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/18/2023 14:49, William Tu wrote:

Hi William,

...

> +
> +static int
> +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> +                      struct xdp_frame *xdpf,
> +                      struct vmxnet3_tx_queue *tq, bool dma_map)
> +{
> +       struct vmxnet3_tx_buf_info *tbi = NULL;
> +       union Vmxnet3_GenericDesc *gdesc;
> +       struct vmxnet3_tx_ctx ctx;
> +       int tx_num_deferred;
> +       struct page *page;
> +       u32 buf_size;
> +       int ret = 0;

This doesn't seem to be used anywhere, so it can be removed.

> +       u32 dw2;
> +
> +       dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> +       dw2 |= xdpf->len;
> +       ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
> +       gdesc = ctx.sop_txd;
> +
> +       buf_size = xdpf->len;
> +       tbi = tq->buf_info + tq->tx_ring.next2fill;
> +
> +       if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
> +               tq->stats.tx_ring_full++;
> +               return -ENOSPC;
> +       }
> +
> +       tbi->map_type = VMXNET3_MAP_XDP;
> +       if (dma_map) { /* ndo_xdp_xmit */
> +               tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
> +                                              xdpf->data, buf_size,
> +                                              DMA_TO_DEVICE);
> +               if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr))
> +                       return -EFAULT;
> +               tbi->map_type |= VMXNET3_MAP_SINGLE;
> +       } else { /* XDP buffer from page pool */
> +               page = virt_to_page(xdpf->data);
> +               tbi->dma_addr = page_pool_get_dma_addr(page) +
> +                               XDP_PACKET_HEADROOM;

Shouldn't this be VMXNET3_XDP_HEADROOM?

> +               dma_sync_single_for_device(&adapter->pdev->dev,
> +                                          tbi->dma_addr, buf_size,
> +                                          DMA_BIDIRECTIONAL);

Shouldn't this be DMA_TO_DEVICE instead of DMA_BIDERECTIONAL?

> +       }
> +       tbi->xdpf = xdpf;
> +       tbi->len = buf_size;
> +
> +       gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
> +       WARN_ON_ONCE(gdesc->txd.gen == tq->tx_ring.gen);
> +
> +       gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
> +       gdesc->dword[2] = cpu_to_le32(dw2);
> +
> +       /* Setup the EOP desc */
> +       gdesc->dword[3] = cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
> +
> +       gdesc->txd.om = 0;
> +       gdesc->txd.msscof = 0;
> +       gdesc->txd.hlen = 0;
> +       gdesc->txd.ti = 0;
> +
> +       tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
> +       le32_add_cpu(&tq->shared->txNumDeferred, 1);
> +       tx_num_deferred++;
> +
> +       vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
> +
> +       /* set the last buf_info for the pkt */
> +       tbi->sop_idx = ctx.sop_txd - tq->tx_ring.base;
> +
> +       dma_wmb();
> +       gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> +                                                 VMXNET3_TXD_GEN);
> +
> +       /* No need to handle the case when tx_num_deferred doesn't reach
> +        * threshold. Backend driver at hypervisor side will poll and reset
> +        * tq->shared->txNumDeferred to 0.
> +        */
> +       if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
> +               tq->shared->txNumDeferred = 0;
> +               VMXNET3_WRITE_BAR0_REG(adapter,
> +                                      VMXNET3_REG_TXPROD + tq->qid * 8,
> +                                      tq->tx_ring.next2fill);
> +       }
> +
> +       return ret;
> +}

...

> +static int
> +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp,
> +               struct bpf_prog *prog)
> +{
> +       struct xdp_frame *xdpf;
> +       struct page *page;
> +       int err;
> +       u32 act;
> +
> +       act = bpf_prog_run_xdp(prog, xdp);
> +       rq->stats.xdp_packets++;
> +       page = virt_to_page(xdp->data_hard_start);
> +
> +       switch (act) {
> +       case XDP_PASS:
> +               return act;
> +       case XDP_REDIRECT:
> +               err = xdp_do_redirect(rq->adapter->netdev, xdp, prog);
> +               if (!err)
> +                       rq->stats.xdp_redirects++;
> +               else
> +                       rq->stats.xdp_drops++;
> +               return act;
> +       case XDP_TX:
> +               xdpf = xdp_convert_buff_to_frame(xdp);

If you want, I think you can drop xdp_convert_buff_to_frame() and pass
directly the page. And then inside vmxnet3_unmap_pkt() you can use
page_pool_recycle_direct().
Of course this requires few other changes (I think you need a new
map_type) but in the end you might save some CPU usage.

> +               if (unlikely(!xdpf ||
> +                            vmxnet3_xdp_xmit_back(rq->adapter, xdpf))) {
> +                       rq->stats.xdp_drops++;
> +                       page_pool_recycle_direct(rq->page_pool, page);
> +               } else {
> +                       rq->stats.xdp_tx++;
> +               }
> +               return act;
> +       default:
> +               bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
> +               fallthrough;
> +       case XDP_ABORTED:
> +               trace_xdp_exception(rq->adapter->netdev, prog, act);
> +               rq->stats.xdp_aborted++;
> +               break;
> +       case XDP_DROP:
> +               rq->stats.xdp_drops++;
> +               break;
> +       }
> +
> +       page_pool_recycle_direct(rq->page_pool, page);
> +
> +       return act;
> +}
> +

-- 
/Horatiu
