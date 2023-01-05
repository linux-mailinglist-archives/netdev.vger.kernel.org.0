Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C365F4E9
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 21:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbjAEUCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 15:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbjAEUBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 15:01:48 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1232199
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 12:01:46 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id l139so7082128ybl.12
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 12:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GoYFT/3kBPy0B6f1tJTv73sY0jX9cctFoKfClND0dUg=;
        b=JXeiteoKIk7eCVgXoFrzdq8cbOC8liHXg1UNotm38ysDRJN0YZ4TDTxpjJsTHWHOde
         nrsqhcE5pXlO2iZ8kUllf+WgS9EbRlJeobruEK6W59rw8Myc0Oj4fAzyZt+lhPQzU3oa
         bGWa6VTbGMfHGy5E7KbSw3l0jisUeIOKGJ3T2YwHpnbzC53GWrjj3IwOR7cZPKwYj1zo
         ptSv9mYwbq8N5NpYs98eESJ9lhh8l5wQnrZUvr6kh+L+Is2EALE3yH745vY9msxc0AFn
         x+cKJ53rqaoMJOmx5+u8/Lgg5KmeLU+5uMTAR3KkVscqyZeeCf+wvQvzwK6Lk0rdFP3o
         qtrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GoYFT/3kBPy0B6f1tJTv73sY0jX9cctFoKfClND0dUg=;
        b=u/9aW10oAK0ATHAZ3/kwWnj4932pxrpzLSPsVIj4XsIiF3C4v16E4dVFuibCBSZYmO
         58Pm1kX9awUOnlrZwx58oUuNseCZ/BMBndb7jEzeMEqRbcu1TLFVHDaxECRTYJxBmUiU
         7Dvl+xlbW6vew4LOyeHPkpyXYDsaMPzjggEe6/VIOYqFZVje3lAzDfVjXdaUM7axsXEp
         +CRoyuojIufwpBzzLJZos21Vt7AfugVBrtaxacHRUSKpnKeaYcs/c3yDxj1IdE4xsiWl
         gM+YQtiENz6pq9BQ5+Fqzj3larltyxFVUynUiZCwrcb+UuW0TL7bmZEZ3u3B/PtYyKuZ
         VXTg==
X-Gm-Message-State: AFqh2koz4MXHygQfBGT9c89IEbi1fNHnMqhfXisYuA9OTjfbllOE596c
        AxtEzLQa9HzZxaKq/HZJzpQ0PJFX7xDX1PdVKOw=
X-Google-Smtp-Source: AMrXdXtJb9nRLBDUSycWHbO3MmgtKJGxSkPrepu9wYaw0IVqxtpDsvQFB2m2j/3FI2K4t52yhrT2xlLfW0PG5mMLuhs=
X-Received: by 2002:a05:6902:3cb:b0:733:285d:88a3 with SMTP id
 g11-20020a05690203cb00b00733285d88a3mr5364089ybs.306.1672948905230; Thu, 05
 Jan 2023 12:01:45 -0800 (PST)
MIME-Version: 1.0
References: <20230104202251.45149-1-u9012063@gmail.com> <d6f089d37ca57f9fdf16193c5309ad3888da58a4.camel@gmail.com>
In-Reply-To: <d6f089d37ca57f9fdf16193c5309ad3888da58a4.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 5 Jan 2023 12:01:09 -0800
Message-ID: <CALDO+SYvbM=UVVJdHGgz_x01vo7jbr_u1ex2CTnkPNHJFQnQzg@mail.gmail.com>
Subject: Re: [PATCH v9] vmxnet3: Add XDP support.
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

On Thu, Jan 5, 2023 at 8:11 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, 2023-01-04 at 12:22 -0800, William Tu wrote:
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> >
> > Background:

> >  static void
> > -vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> > -                  struct pci_dev *pdev)
> > +vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pdev,
> > +                  struct xdp_frame_bulk *bq)
> >  {
> > -     if (tbi->map_type == VMXNET3_MAP_SINGLE)
> > +     switch (tbi->map_type) {
> > +     case VMXNET3_MAP_SINGLE:
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
> > +             xdp_return_frame_bulk(tbi->xdpf, bq);
> > +             break;
> > +     default:
> >               BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> > -
> > +     }
> >       tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
> >  }
>
> So this will end up leaking mappings if I am not mistaken as you will
> need to unmap XDP redirected frames before freeing them.
>
> You could look at masking this and doing the MAP_SINGLE | MAP_PAGE
> checks in a switch statement, and then freeing an xdp frame in a
> separate if statement after the switch statement.
Thanks!
you mentioned this in v8 review but I don't fully get it.
Now I understand why it's leaking dma mappings.

>
> >
> > @@ -343,22 +350,29 @@ static int
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
> > +     if (tbi->map_type != VMXNET3_MAP_XDP) {
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
> >
> >
>
> <...>
>
> > diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
> > index 3367db23aa13..72cbdad8aff7 100644
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
> > @@ -188,19 +191,21 @@ struct vmxnet3_tx_data_ring {
> >       dma_addr_t          basePA;
> >  };
> >
> > -enum vmxnet3_buf_map_type {
> > -     VMXNET3_MAP_INVALID = 0,
> > -     VMXNET3_MAP_NONE,
> > -     VMXNET3_MAP_SINGLE,
> > -     VMXNET3_MAP_PAGE,
> > -};
> > +#define VMXNET3_MAP_INVALID  BIT(0)
> > +#define VMXNET3_MAP_NONE     BIT(1)
> > +#define VMXNET3_MAP_SINGLE   BIT(2)
> > +#define VMXNET3_MAP_PAGE     BIT(3)
> > +#define VMXNET3_MAP_XDP              BIT(4)
>
> So I think I see two issues here. From what I can tell MAP_INVALID
> isn't used anywhere, so it can be dropped.
>
> Instead of being a bitmap MAP_NONE should probably just be 0 instead of
> being a bitmap value. Then you could use it as an overwrite to reset
> your mapping type and the MAP_NONE uses would still be valid
> throughout.
Good idea, will do it.

>
> So something more like:
> #define VMXNET3_MAP_NONE        0
> #define VMXNET3_MAP_SINGLE      BIT(0)
> #define VMXNET3_MAP_PAGE        BIT(1)
> #define VMXNET3_MAP_XDP         BIT(2)
>
> >  struct vmxnet3_tx_buf_info {
> >       u32      map_type;
> >       u16      len;
> >       u16      sop_idx;
> >       dma_addr_t  dma_addr;
> > -     struct sk_buff *skb;
> > +     union {
> > +             struct sk_buff *skb;
> > +             struct xdp_frame *xdpf;
> > +     };
> >  };
> >
> >  struct vmxnet3_tq_driver_stats {
> > @@ -217,6 +222,9 @@ struct vmxnet3_tq_driver_stats {
> >       u64 linearized;         /* # of pkts linearized */
> >       u64 copy_skb_header;    /* # of times we have to copy skb header */
> >       u64 oversized_hdr;
> > +
> > +     u64 xdp_xmit;
> > +     u64 xdp_xmit_err;
> >  };
> >
> >  struct vmxnet3_tx_ctx {
> > @@ -253,12 +261,13 @@ struct vmxnet3_tx_queue {
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
> > +     VMXNET3_RX_BUF_XDP = 3
> >  };
> >
> >  #define VMXNET3_RXD_COMP_PENDING        0
> > @@ -271,6 +280,7 @@ struct vmxnet3_rx_buf_info {
> >       union {
> >               struct sk_buff *skb;
> >               struct page    *page;
> > +             struct page    *pp_page; /* Page Pool for XDP frame */
> >       };
> >       dma_addr_t dma_addr;
> >  };
> > @@ -285,6 +295,12 @@ struct vmxnet3_rq_driver_stats {
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
> > @@ -307,7 +323,9 @@ struct vmxnet3_rx_queue {
> >       struct vmxnet3_rx_buf_info     *buf_info[2];
> >       struct Vmxnet3_RxQueueCtrl            *shared;
> >       struct vmxnet3_rq_driver_stats  stats;
> > -} __attribute__((__aligned__(SMP_CACHE_BYTES)));
> > +     struct page_pool *page_pool;
> > +     struct xdp_rxq_info xdp_rxq;
> > +} ____cacheline_aligned;
> >
> >  #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
> >  #define VMXNET3_DEVICE_MAX_RX_QUEUES 32   /* Keep this value as a power of 2 */
> > @@ -415,6 +433,7 @@ struct vmxnet3_adapter {
> >       u16    tx_prod_offset;
> >       u16    rx_prod_offset;
> >       u16    rx_prod2_offset;
> > +     struct bpf_prog __rcu *xdp_bpf_prog;
> >  };
> >
> >  #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
> > @@ -490,6 +509,12 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
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
> > index 000000000000..7a34dbf8eabc
> > --- /dev/null
> > +++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
> > @@ -0,0 +1,419 @@
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
> > +     }
> > +     err = vmxnet3_activate_dev(adapter);
> > +     if (err) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "failed to activate device for XDP.");
> > +             err = -EOPNOTSUPP;
> > +             return err;
> > +     }
> > +     clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> > +     return err;
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
>
> You should add some logic here to |= MAP_SINGLE into the map_type so
> that you know that you also need to unmap it later on.

Got it, will do.
Thank you
William
