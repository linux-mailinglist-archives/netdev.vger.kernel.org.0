Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE6D68AC43
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 21:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjBDU0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 15:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjBDU0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 15:26:32 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF05E28D32
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 12:26:27 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id x8so1808262ybt.13
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 12:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xGFvbnxWJxUblkNdhVf2kiYAF1YSZiHd9nhD6p7GYgI=;
        b=UZnj7h+Wp4+cM7zzaEHXDV7amthGPddQA75vvB+gzpHQNAXcxkc9EvuKjNapIN/3Yp
         FRhLxzKJg9KL23kbQWbiHiXLWYC7ChvXn5YMkzQkJq02TcZa3FMCd2raAt+ZIKJzKnPA
         0se95jSmzhMD9A4m8PhTIrAnypYakhcbAwEY60AifZysPCJ97fnhP9kxJpR3eoYTb3UD
         Jox9F96InnhTzJgycgYMfVdk0TeJuo6rXV4Lc70psYWHNOLqUmPM8MahnhpyEecutzNg
         wPO+/ZRqqA83kRjlqK/vE2c7owdM6Bj5U89sTuDA5G0jS9TjFTowu9PKrh1Hor/rO7G7
         KJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xGFvbnxWJxUblkNdhVf2kiYAF1YSZiHd9nhD6p7GYgI=;
        b=q+llzHKRxtVRngXY6/CaCFqi9Ga5v1+5vqkU6bxIFYy7/p8jyUbyrZUYo3Itl9W5i8
         IMc29qfSMuX8fTuwJ7+34371AMJPZzRb9eju0T5+Hme+Yrh0ryPaevzCWZWtLKaO5+Y7
         B4K7nNpZ42ee2Phr5kt7SIrsDjcigSR1I/z2F8xZZ5fEC8z6oAYSUxii9wII4K1TwnDa
         DWk8EXeAnrL3aEXgBjdgZF+/j57NBr3wrOfv822ApcZsgaEJbxuYRplzRFotlhgLQGbG
         m7mgrfnNpNmubpZr6tp/tR4ibe0/X0rl4BhwqD9Tyu3wvNMaeZf5JtC1lDJKKOasasXI
         fgKA==
X-Gm-Message-State: AO0yUKVcyx9BMM2WMPQHvVLQ6yczez6E2jAm0+StX8mBiaNre1DNcISj
        2tcpxiHOlQCQ0vsl0tehk/Xk7iT1aTTNnCrADeM=
X-Google-Smtp-Source: AK7set8LN4SMGJlAC7AHa9MBOISiG1bh0GXy7a4a/gnEiAvXy/TBxnhX4pWCUXM4qHcIm+VsayHhKSqa4d/XYeQmriE=
X-Received: by 2002:a25:720b:0:b0:7fe:75bb:d85f with SMTP id
 n11-20020a25720b000000b007fe75bbd85fmr2066972ybc.539.1675542386505; Sat, 04
 Feb 2023 12:26:26 -0800 (PST)
MIME-Version: 1.0
References: <20230127163027.60672-1-u9012063@gmail.com> <Y95myr/XdkvQzWcm@boxer>
In-Reply-To: <Y95myr/XdkvQzWcm@boxer>
From:   William Tu <u9012063@gmail.com>
Date:   Sat, 4 Feb 2023 12:25:50 -0800
Message-ID: <CALDO+SZ2UMBmDpm2kDL3MwLN1=+oJomSAQfpv9H+ehHWbThZ+w@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v15] vmxnet3: Add XDP support.
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        alexandr.lobakin@intel.com, bang@vmware.com,
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

Hi Maciej,

Thanks for reviewing the patch!

On Sat, Feb 4, 2023 at 6:08 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Fri, Jan 27, 2023 at 08:30:27AM -0800, William Tu wrote:
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
> >
> > When receiving a packet, the first descriptor will have the sop (start of
> > packet) bit set, and the last descriptor will have the eop (end of packet)
> > bit set. Non-LRO packets will have only one descriptor with both sop and
> > eop set.
> >
> > Other than r0 and r1, vmxnet3 dataring is specifically designed for
> > handling packets with small size, usually 128 bytes, defined in
> > VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the packet from the backend
> > driver in ESXi to the ring's memory region at front-end vmxnet3 driver, in
> > order to avoid memory mapping/unmapping overhead. In summary, packet size:
> >     A. < 128B: use dataring
> >     B. 128B - 3K: use ring0 (VMXNET3_RX_BUF_SKB)
> >     C. > 3K: use ring0 and ring1 (VMXNET3_RX_BUF_SKB + VMXNET3_RX_BUF_PAGE)
> > As a result, the patch adds XDP support for packets using dataring
> > and r0 (case A and B), not the large packet size when LRO is enabled.
> >
> > XDP Implementation:
> > When user loads and XDP prog, vmxnet3 driver checks configurations, such
> > as mtu, lro, and re-allocate the rx buffer size for reserving the extra
> > headroom, XDP_PACKET_HEADROOM, for XDP frame. The XDP prog will then be
> > associated with every rx queue of the device. Note that when using dataring
> > for small packet size, vmxnet3 (front-end driver) doesn't control the
> > buffer allocation, as a result we allocate a new page and copy packet
> > from the dataring to XDP frame.
> >
> > The receive side of XDP is implemented for case A and B, by invoking the
> > bpf program at vmxnet3_rq_rx_complete and handle its returned action.
> > The vmxnet3_process_xdp(), vmxnet3_process_xdp_small() function handles
> > the ring0 and dataring case separately, and decides the next journey of
> > the packet afterward.
> >
> > For TX, vmxnet3 has split header design. Outgoing packets are parsed
> > first and protocol headers (L2/L3/L4) are copied to the backend. The
> > rest of the payload are dma mapped. Since XDP_TX does not parse the
> > packet protocol, the entire XDP frame is dma mapped for transmission
> > and transmitted in a batch. Later on, the frame is freed and recycled
> > back to the memory pool.
> >
> > Performance:
> > Tested using two VMs inside one ESXi vSphere 7.0 machine, using single
> > core on each vmxnet3 device, sender using DPDK testpmd tx-mode attached
> > to vmxnet3 device, sending 64B or 512B UDP packet.
> >
> > VM1 txgen:
> > $ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3 \
> > --forward-mode=txonly --eth-peer=0,<mac addr of vm2>
> > option: add "--txonly-multi-flow"
> > option: use --txpkts=512 or 64 byte
> >
> > VM2 running XDP:
> > $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
> > $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
> > options: XDP_DROP, XDP_PASS, XDP_TX
> >
> > To test REDIRECT to cpu 0, use
> > $ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
> >
> > Single core performance comparison with skb-mode.
> > 64B:      skb-mode -> native-mode
> > XDP_DROP: 1.6Mpps -> 2.4Mpps
> > XDP_PASS: 338Kpps -> 367Kpps
> > XDP_TX:   1.1Mpps -> 2.3Mpps
> > REDIRECT-drop: 1.3Mpps -> 2.3Mpps
> >
> > 512B:     skb-mode -> native-mode
> > XDP_DROP: 863Kpps -> 1.3Mpps
> > XDP_PASS: 275Kpps -> 376Kpps
> > XDP_TX:   554Kpps -> 1.2Mpps
> > REDIRECT-drop: 659Kpps -> 1.2Mpps
> >
> > Demo: https://youtu.be/4lm1CSCi78Q
> >
> > Future work:
> > - XDP frag support
> > - use napi_consume_skb() instead of dev_kfree_skb_any at unmap
> >
> > Signed-off-by: William Tu <u9012063@gmail.com>
> > Tested-by: Yifeng Sun <yifengs@vmware.com>
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> > v14 -> v15:
> > feedbacks from Alexander Lobakin
> > - add rcu_read_lock unlock around xdp_frame_bulk_init
> > - define correct VMXNET3_XDP_MAX_MTU
> > - add comment explaining tx deferred and threshold in backend driver
> > - minor code refactoring and style fixes
> > - fix one bug in process_xdp when !xdp_prog
> > https://github.com/williamtu/net-next/compare/v14..v15
>
> good stuff with this way of showing the diff to reviewers (y)
Thanks! It's also for me to double check whether I address all the
reviewer's comments.

>
> below some nits/questions from me. i was not following previous
> reviews/revisions, sorry.
>
> >
> > v13 -> v14:
> > feedbacks from Alexander Lobakin
> > - fix several new lines, unrelated changes, unlikely, RCT style,
> >   coding style, etc.
> > - add NET_IP_ALIGN and create VMXNET3_XDP_HEADROOM, instead of
> >   using XDP_PACKET_HEADROOM
> > - remove %pp_page and use %page in rx_buf_int
> > - fix the %VMXNET3_XDP_MAX_MTU, mtu doesn't include eth, vlan, and fcs
> > - use NL_SET instead of netdev_err when detecting LRP
> > - remove two global function, vmxnet3{_xdp_headroom, xdp_enabled}
> > make the vmxnet3_xdp_enabled static inline function, and remove
> > vmxnet3_xdp_headroom.
> > - rename the VMXNET3_XDP_MAX_MTU to VMXNET3_XDP_MAX_FRSIZE
> >
> > - add Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > - add yifeng sun for testing on ESXi and XDP
> > compare v13..v14
> > https://github.com/williamtu/net-next/compare/v13..v14
> >
> > v12 -> v13:
> > - feedbacks from Guolin:
> >   Instead of return -ENOTSUPP, disable the LRO in
> >   netdev->features, and print err msg
> >
> > v11 -> v12:
> > work on feedbacks from Alexander Duyck
> > - fix issues and refactor the vmxnet3_unmap_tx_buf and
> >   unmap_pkt
> >
> > v10 -> v11:
> > work on feedbacks from Alexander Duyck
> > internal feedback from Guolin and Ronak
> > - fix the issue of xdp_return_frame_bulk, move to up level
> >   of vmxnet3_unmap_tx_buf and some refactoring
> > - refactor and simplify vmxnet3_tq_cleanup
> > - disable XDP when LRO is enabled, suggested by Ronak
> > ---
> >  drivers/net/Kconfig                   |   1 +
> >  drivers/net/vmxnet3/Makefile          |   2 +-
> >  drivers/net/vmxnet3/vmxnet3_drv.c     | 224 ++++++++++++--
> >  drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
> >  drivers/net/vmxnet3/vmxnet3_int.h     |  43 ++-
> >  drivers/net/vmxnet3/vmxnet3_xdp.c     | 419 ++++++++++++++++++++++++++
> >  drivers/net/vmxnet3/vmxnet3_xdp.h     |  49 +++
> >  7 files changed, 712 insertions(+), 40 deletions(-)
> >  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.c
> >  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.h
> >
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index 9e63b8c43f3e..a4419d661bdd 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -571,6 +571,7 @@ config VMXNET3
> >       tristate "VMware VMXNET3 ethernet driver"
> >       depends on PCI && INET
> >       depends on PAGE_SIZE_LESS_THAN_64KB
> > +     select PAGE_POOL
> >       help
> >         This driver supports VMware's vmxnet3 virtual ethernet NIC.
> >         To compile this driver as a module, choose M here: the
> > diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
> > index a666a88ac1ff..f82870c10205 100644
> > --- a/drivers/net/vmxnet3/Makefile
> > +++ b/drivers/net/vmxnet3/Makefile
> > @@ -32,4 +32,4 @@
> >
> >  obj-$(CONFIG_VMXNET3) += vmxnet3.o
> >
> > -vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o
> > +vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o vmxnet3_xdp.o
> > diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> > index d3e7b27eb933..eb3b9688299b 100644
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
> > @@ -323,17 +324,18 @@ static u32 get_bitfield32(const __le32 *bitfield, u32 pos, u32 size)
> >
> >
> >  static void
> > -vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> > -                  struct pci_dev *pdev)
> > +vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pdev)
>
> nit: unneeded code churn
right, this is not necessary changed.

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
> >       else
> > -             BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> > +             BUG_ON((map_type & ~VMXNET3_MAP_XDP));
> >
> >       tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
> >  }
> > @@ -341,19 +343,20 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> >
>
> (...)
>
> > @@ -1858,14 +2014,16 @@ static int
> >  vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
> >               struct vmxnet3_adapter  *adapter)
> >  {
> > -     int i;
> > +     int i, err;
> >
> >       /* initialize buf_info */
> >       for (i = 0; i < rq->rx_ring[0].size; i++) {
> >
> > -             /* 1st buf for a pkt is skbuff */
> > +             /* 1st buf for a pkt is skbuff or xdp page */
> >               if (i % adapter->rx_buf_per_pkt == 0) {
> > -                     rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_SKB;
> > +                     rq->buf_info[0][i].buf_type = vmxnet3_xdp_enabled(adapter) ?
> > +                                                   VMXNET3_RX_BUF_XDP :
> > +                                                   VMXNET3_RX_BUF_SKB;
> >                       rq->buf_info[0][i].len = adapter->skb_buf_size;
> >               } else { /* subsequent bufs for a pkt is frag */
> >                       rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_PAGE;
> > @@ -1886,6 +2044,12 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
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
>
> Probably for completeness, if above fails then you should destroy pp
> resources that got successfully allocd in vmxnet3_create_pp
Good catch, will fix it.

>
> >               /* at least has 1 rx buffer for the 1st ring */
> > @@ -1989,7 +2153,7 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
> >  }
> >
> >
> > -static int
> > +int
> >  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
> >  {
> >       int i, err = 0;
> > @@ -3026,7 +3190,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
> >  }
> >
> >
>
> (...)
>
> > diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
> > new file mode 100644
> > index 000000000000..c698fb6213b2
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
> > +     int err;
> > +
> > +     if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if (adapter->netdev->features & NETIF_F_LRO) {
> > +             NL_SET_ERR_MSG_MOD(extack, "LRO is not supported with XDP");
> > +             adapter->netdev->features &= ~NETIF_F_LRO;
>
> don't you need to reflect clearing this flag in some way?
right, probably I should print s.t like
"LRO is not supported with XDP, disable it"
and it takes effect later on when we call vmxnet3_activate_dev()

> Also what if someone tries to set it when xdp prog is loaded?
I checked the vmxnet3_set_features, and looks like enabling/disabling LRO
won't trigger NIC reset.
In this case, we will have xdp program remains loaded, but LRO becomes enabled.
Then our XDP prog won't be trigger due to the check of both sop and eop.

I will add a warning in vmxnet3_fix_features, checking that if
if (vmxnet3_xdp_enabled(adapter) && (features & NETIF_F_LRO))
        netdev_err(netdev, "Can not enable LRO when XDP program is loaded");

Or another way is to unload the XDP prog, and allow users to enable LRO.

>
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
> > +             return -EOPNOTSUPP;
> > +     }
> > +     err = vmxnet3_activate_dev(adapter);
> > +     if (err) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "failed to activate device for XDP.");
> > +             return -EOPNOTSUPP;
> > +     }
> > +     clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> > +
> > +     return 0;
> > +}
> > +
>
> (...)
>
> > +static int
> > +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> > +                   struct xdp_frame *xdpf)
> > +{
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int tq_number;
> > +     int err, cpu;
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
> > +     __netif_tx_lock(nq, cpu);
> > +     err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq, false);
> > +     __netif_tx_unlock(nq);
> > +
> > +     return err;
> > +}
> > +
> > +/* ndo_xdp_xmit */
> > +int
> > +vmxnet3_xdp_xmit(struct net_device *dev,
> > +              int n, struct xdp_frame **frames, u32 flags)
> > +{
> > +     struct vmxnet3_adapter *adapter = netdev_priv(dev);
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int i, err, cpu;
> > +     int tq_number;
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
>
> getting the txq logic is repeated in vmxnet3_xdp_xmit_back(), maybe a
> helper?
>
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
> > +     struct page *page;
> > +     int err;
> > +     u32 act;
> > +
> > +     prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> > +     act = bpf_prog_run_xdp(prog, xdp);
> > +     rq->stats.xdp_packets++;
> > +     page = virt_to_head_page(xdp->data_hard_start);
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
> > +             if (unlikely(!xdpf ||
> > +                          vmxnet3_xdp_xmit_back(rq->adapter, xdpf))) {
> > +                     rq->stats.xdp_drops++;
> > +                     page_pool_recycle_direct(rq->page_pool, page);
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
> > +     page_pool_recycle_direct(rq->page_pool, page);
> > +
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
> > +     if (unlikely(!page)) {
> > +             rq->stats.rx_buf_alloc_failure++;
> > +             return XDP_DROP;
> > +     }
> > +
> > +     xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, page_address(page), rq->page_pool->p.offset,
> > +                      len, false);
> > +     xdp_buff_clear_frags_flag(&xdp);
> > +
> > +     /* Must copy the data because it's at dataring. */
> > +     memcpy(xdp.data, data, len);
> > +
> > +     rcu_read_lock();
>
> https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/
Got it, I read through the discussion.
Look like the rcu_read_lock is not needed anymore here.

>
> > +     xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> > +     if (!xdp_prog) {
> > +             rcu_read_unlock();
> > +             page_pool_recycle_direct(rq->page_pool, page);
>
> recycling the page that is going to be used for build_skb()?
> am i missing something?

you're right... that's another mistake. Will fix it.

>
> > +             act = XDP_PASS;
> > +             goto out_skb;
> > +     }
> > +     act = vmxnet3_run_xdp(rq, &xdp);
>
> pass the xdp_prog, no reason to deref this again inside vmxnet3_run_xdp()
OK! will do it

>
> > +     rcu_read_unlock();
> > +
> > +     if (act == XDP_PASS) {
> > +out_skb:
> > +             *skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> > +             if (!skb_xdp_pass)
> > +                     return XDP_DROP;
> > +     }
> > +
> > +     /* No need to refill. */
> > +     return act;
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
> > +     struct xdp_buff xdp;
> > +     struct page *page;
> > +     void *new_data;
> > +     int act;
> > +
> > +     page = rbi->page;
> > +     dma_sync_single_for_cpu(&adapter->pdev->dev,
> > +                             page_pool_get_dma_addr(page) +
> > +                             rq->page_pool->p.offset, rcd->len,
> > +                             page_pool_get_dma_dir(rq->page_pool));
> > +
> > +     xdp_init_buff(&xdp, rbi->len, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, page_address(page), rq->page_pool->p.offset,
> > +                      rcd->len, false);
> > +     xdp_buff_clear_frags_flag(&xdp);
> > +
> > +     rcu_read_lock();
> > +     xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> > +     if (!xdp_prog) {
> > +             rcu_read_unlock();
> > +             act = XDP_PASS;
> > +             goto out_skb;
> > +     }
> > +     act = vmxnet3_run_xdp(rq, &xdp);
> > +     rcu_read_unlock();
> > +
> > +     if (act == XDP_PASS) {
> > +out_skb:
> > +             *skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> > +             if (!skb_xdp_pass)
> > +                     act = XDP_DROP;
> > +     }
> > +
> > +     new_data = vmxnet3_pp_get_buff(rq->page_pool, &new_dma_addr,
> > +                                    GFP_ATOMIC);
>
> are you refilling per each processed buf?
yes, I process one packet, and refill immediately with another one.
Maybe there is a better way to do batch refill?

Thanks again for taking another check of this patch and found more issues!
I will work on next version
William
