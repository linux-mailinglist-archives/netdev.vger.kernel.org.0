Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7770264F449
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 23:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLPWxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 17:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLPWxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 17:53:46 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDAFBF5B
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 14:53:43 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v126so3983535ybv.2
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 14:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qOU5Bujf0mw2C8qDH88p4GorWMeCSWzaNlHc6vxliYg=;
        b=o9fCgL3G+Eux+Wukk4rQaAFRwWxdpb8DzrYq0ToM9Lr/cypJOrADssHg7aWhgUxs1w
         S/wdJtY7ilaSnHkRxclc9wxXSvBLjHLQLksnEwYTOQAB2sg4jmkktaz9lK8jNDO5lEfG
         W/ToEq/SlALiyYO3fhUoCTizYKJlmjidROIa4lIAVThpfKni4/FpgOXnOPhsBKhI/WgQ
         bF/xzGCIVZ9XU4QUs+Pmlim2G6pH2dp+mkblnpuYy7xS8oJCffxGeQ01a4RLf3D6Tv5r
         nXh60ts9ksPh93FC5BPo7ZxsK6lx3kiaIC5s91SKEXIVng0QsOfXVFU1ptj81TYxv4qP
         euAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOU5Bujf0mw2C8qDH88p4GorWMeCSWzaNlHc6vxliYg=;
        b=6myppEW862ZYQiHvvjei1BEEMHU+hiDIqG8vgvZ0JYSfkp/p302P1tIdMwMrX8gqca
         EvQ1R2hBp63Fc30yTf7VSr9WkgyYBhvsFqViYiCMFTbyWWHAAmLkaqXOQj5s5rqv68n3
         Q+gwEysovuE4z4uVNv1vqqrtWnZWkfJcBTcCbblGWYqUXsPUBX5SiWUYu5PGE+xwwNi/
         j/11doKuDKCapKhj3x/ZkEk8hy0EaJXV2LOWPvORa2rwqbEAmSSZ8sEbqDHrPcphqCjk
         M7d+L19zfCEoMyL+xmypoJFGj7SatnP3nEcKqzdCMQZ3f2Fyg/9Dm1UrdJczxa+al8te
         C0sg==
X-Gm-Message-State: ANoB5pkktPeMcuVq371PGnjewHy5QT1nju6gi9nlC6ujzt8krsUbGQoP
        8K8eJJErCotrAtXFqTNMrr9ywQIUhiqSh3HuKMs=
X-Google-Smtp-Source: AA0mqf6XM/XJad++8yQXL5NlkVKPiT/SxoI8h1d3q4IwioqIkLba/+gr8sCHqaL6y+MlZyB7Cz81dT8UAx/oSagft+g=
X-Received: by 2002:a25:33c4:0:b0:6fb:8683:e095 with SMTP id
 z187-20020a2533c4000000b006fb8683e095mr39166168ybz.213.1671231222320; Fri, 16
 Dec 2022 14:53:42 -0800 (PST)
MIME-Version: 1.0
References: <20221216144118.10868-1-u9012063@gmail.com> <c4c62a4563d6669ca3c5d5efee0e54bc8742f27d.camel@gmail.com>
In-Reply-To: <c4c62a4563d6669ca3c5d5efee0e54bc8742f27d.camel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 16 Dec 2022 14:53:05 -0800
Message-ID: <CALDO+SaKd74n_PDB+kN0KQWt_Zh9NjzPAm-kWfie4Vd+jOeCZw@mail.gmail.com>
Subject: Re: [PATCH v6] vmxnet3: Add XDP support.
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com
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
Thanks for taking a look at this patch!

On Fri, Dec 16, 2022 at 9:14 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, 2022-12-16 at 06:41 -0800, William Tu wrote:
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
> > buffer allocation, as a result the XDP frame's headroom is zero.
> >
> > The receive side of XDP is implemented for case A and B, by invoking the
> > bpf program at vmxnet3_rq_rx_complete and handle its returned action.
> > The new vmxnet3_run_xdp function handles the difference of using dataring
> > or ring0, and decides the next journey of the packet afterward.
> >
> > For TX, vmxnet3 has split header design. Outgoing packets are parsed
> > first and protocol headers (L2/L3/L4) are copied to the backend. The
> > rest of the payload are dma mapped. Since XDP_TX does not parse the
> > packet protocol, the entire XDP frame is using dma mapped for the
> > transmission. Because the actual TX is deferred until txThreshold, it's
> > possible that an rx buffer is being overwritten by incoming burst of rx
> > packets, before tx buffer being transmitted. As a result, we allocate new
> > skb and introduce a copy.
> >
> > Performance:
> > Tested using two VMs inside one ESXi machine, using single core on each
> > vmxnet3 device, sender using DPDK testpmd tx-mode attached to vmxnet3
> > device, sending 64B or 512B packet.
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
> > 64B:      skb-mode -> native-mode (with this patch)
> > XDP_DROP: 932Kpps -> 2.0Mpps
> > XDP_PASS: 284Kpps -> 314Kpps
> > XDP_TX:   591Kpps -> 1.8Mpps
> > REDIRECT: 453Kpps -> 501Kpps
> >
> > 512B:      skb-mode -> native-mode (with this patch)
> > XDP_DROP: 890Kpps -> 1.3Mpps
> > XDP_PASS: 284Kpps -> 314Kpps
> > XDP_TX:   555Kpps -> 1.2Mpps
> > REDIRECT: 670Kpps -> 430Kpps
> >
>
> I hadn't noticed it before. Based on this it looks like native mode is
> performing worse then skb-mode for redirect w/ 512B packets? Have you
> looked into why that might be?

yes, I noticed it but don't know why, maybe it's due to extra copy and page
allocation like you said below. I will dig deeper.

>
> My main concern would be that you are optimizing for recyling in the Tx
> and Redirect paths, when you might be better off just releasing the
> buffers and batch allocating new pages in your Rx path.

right, are you talking about using the page pool allocator, ex: slide 8 below
https://legacy.netdevconf.info/0x14/pub/slides/10/add-xdp-on-driver.pdf
I tried it before but then I found I have to replace lots of existing vmxnet3
code, basically replacing all the rx/tx buffer allocation code with new
page pool api, even without XDP.  I'd love to give it a try, do you think it's
worth doing it?

>
> > Limitations:
> > a. LRO will be disabled when users load XDP program
> > b. MTU will be checked and limit to
> >    VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
> >    SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
> >
> > Signed-off-by: William Tu <u9012063@gmail.com>
> > ---
> > v5 -> v6:
> > work on feedbacks from Alexander Duyck
> > - remove unused skb parameter at vmxnet3_xdp_xmit
> > - add trace point for XDP_ABORTED
> > - avoid TX packet buffer being overwritten by allocatin
> >   new skb and memcpy (TX performance drop from 2.3 to 1.8Mpps)
> > - update some of the performance number and a demo video
> >   https://youtu.be/I3nx5wQDTXw
> > - pass VMware internal regression test using non-ENS: vmxnet3v2,
> >   vmxnet3v3, vmxnet3v4, so remove RFC tag.
> >
> > v4 -> v5:
> > - move XDP code to separate file: vmxnet3_xdp.{c, h},
> >   suggested by Guolin
> > - expose vmxnet3_rq_create_all and vmxnet3_adjust_rx_ring_size
> > - more test using samples/bpf/{xdp1, xdp2, xdp_adjust_tail}
> > - add debug print
> > - rebase on commit 65e6af6cebe
> >
> > v3 -> v4:
> > - code refactoring and improved commit message
> > - make dataring and non-dataring case clear
> > - in XDP_PASS, handle xdp.data and xdp.data_end change after
> >   bpf program executed
> > - now still working on internal testing
> > - v4 applied on net-next commit 65e6af6cebef
> >
> > v2 -> v3:
> > - code refactoring: move the XDP processing to the front
> >   of the vmxnet3_rq_rx_complete, and minimize the places
> >   of changes to existing code.
> > - Performance improvement over BUF_SKB (512B) due to skipping
> >   skb allocation when DROP and TX.
> >
> > v1 -> v2:
> > - Avoid skb allocation for small packet size (when dataring is used)
> > - Use rcu_read_lock unlock instead of READ_ONCE
> > - Peroformance improvement over v1
> > - Merge xdp drop, tx, pass, and redirect into 1 patch
> >
> > I tested the patch using below script:
> > while [ true ]; do
> > timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP --skb-mode
> > timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP
> > timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_PASS --skb-mode
> > timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_PASS
> > timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_TX --skb-mode
> > timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_TX
> > timeout 20 ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
> > timeout 20 ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e pass
> > done
> > ---
> >  drivers/net/vmxnet3/Makefile          |   2 +-
> >  drivers/net/vmxnet3/vmxnet3_drv.c     |  48 ++-
> >  drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
> >  drivers/net/vmxnet3/vmxnet3_int.h     |  20 ++
> >  drivers/net/vmxnet3/vmxnet3_xdp.c     | 458 ++++++++++++++++++++++++++
> >  drivers/net/vmxnet3/vmxnet3_xdp.h     |  39 +++
> >  6 files changed, 573 insertions(+), 8 deletions(-)
> >  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.c
> >  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.h
> >
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
> > index d3e7b27eb933..b55fec2ac2bf 100644
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
> > @@ -351,7 +352,6 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> >       BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
> >
> >       skb = tq->buf_info[eop_idx].skb;
> > -     BUG_ON(skb == NULL);
> >       tq->buf_info[eop_idx].skb = NULL;
> >
> >       VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
> > @@ -592,6 +592,9 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
> >                               rbi->skb = __netdev_alloc_skb_ip_align(adapter->netdev,
> >                                                                      rbi->len,
> >                                                                      GFP_KERNEL);
> > +                             if (adapter->xdp_enabled)
> > +                                     skb_reserve(rbi->skb, XDP_PACKET_HEADROOM);
> > +
> >                               if (unlikely(rbi->skb == NULL)) {
> >                                       rq->stats.rx_buf_alloc_failure++;
> >                                       break;
> > @@ -1404,6 +1407,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >       struct Vmxnet3_RxDesc rxCmdDesc;
> >       struct Vmxnet3_RxCompDesc rxComp;
> >  #endif
> > +     bool need_flush = 0;
> > +
> >       vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
> >                         &rxComp);
> >       while (rcd->gen == rq->comp_ring.gen) {
> > @@ -1444,6 +1449,19 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                       goto rcd_done;
> >               }
> >
> > +             if (unlikely(rcd->sop && rcd->eop && adapter->xdp_enabled)) {
> > +                     int act = vmxnet3_process_xdp(adapter, rq, rcd, rbi,
> > +                                                   rxd, &need_flush);
> > +                     ctx->skb = NULL;
> > +                     switch (act) {
> > +                     case VMXNET3_XDP_TAKEN:
> > +                             goto rcd_done;
> > +                     case VMXNET3_XDP_CONTINUE:
> > +                     default:
> > +                             break;
> > +                     }
> > +             }
> > +
> >               if (rcd->sop) { /* first buf of the pkt */
> >                       bool rxDataRingUsed;
> >                       u16 len;
> > @@ -1483,6 +1501,10 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >                               goto rcd_done;
> >                       }
> >
> > +                     if (adapter->xdp_enabled && !rxDataRingUsed)
> > +                             skb_reserve(new_skb,
> > +                                         XDP_PACKET_HEADROOM);
> > +
> >                       if (rxDataRingUsed) {
> >                               size_t sz;
> >
> > @@ -1730,6 +1752,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >               vmxnet3_getRxComp(rcd,
> >                                 &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
> >       }
> > +     if (need_flush)
> > +             xdp_do_flush_map();
> >
> >       return num_pkts;
> >  }
> > @@ -1776,6 +1800,7 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
> >
> >       rq->comp_ring.gen = VMXNET3_INIT_GEN;
> >       rq->comp_ring.next2proc = 0;
> > +     rq->xdp_bpf_prog = NULL;
> >  }
> >
> >
> > @@ -1788,7 +1813,6 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
> >               vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
> >  }
> >
> > -
> >  static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >                              struct vmxnet3_adapter *adapter)
> >  {
> > @@ -1832,6 +1856,8 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >       kfree(rq->buf_info[0]);
> >       rq->buf_info[0] = NULL;
> >       rq->buf_info[1] = NULL;
> > +
> > +     vmxnet3_unregister_xdp_rxq(rq);
> >  }
> >
> >  static void
> > @@ -1893,6 +1919,10 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
> >       }
> >       vmxnet3_rq_alloc_rx_buf(rq, 1, rq->rx_ring[1].size - 1, adapter);
> >
> > +     /* always register, even if no XDP prog used */
> > +     if (vmxnet3_register_xdp_rxq(rq, adapter))
> > +             return -EINVAL;
> > +
> >       /* reset the comp ring */
> >       rq->comp_ring.next2proc = 0;
> >       memset(rq->comp_ring.base, 0, rq->comp_ring.size *
> > @@ -1989,7 +2019,7 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
> >  }
> >
> >
> > -static int
> > +int
> >  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
> >  {
> >       int i, err = 0;
> > @@ -2585,7 +2615,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
> >       if (adapter->netdev->features & NETIF_F_RXCSUM)
> >               devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
> >
> > -     if (adapter->netdev->features & NETIF_F_LRO) {
> > +     if (adapter->netdev->features & NETIF_F_LRO &&
> > +         !adapter->xdp_enabled) {
> >               devRead->misc.uptFeatures |= UPT1_F_LRO;
> >               devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
> >       }
> > @@ -3026,7 +3057,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
> >  }
> >
> >
> > -static void
> > +void
> >  vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >  {
> >       size_t sz, i, ring0_size, ring1_size, comp_size;
> > @@ -3035,7 +3066,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >               if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
> >                                           VMXNET3_MAX_ETH_HDR_SIZE) {
> >                       adapter->skb_buf_size = adapter->netdev->mtu +
> > -                                             VMXNET3_MAX_ETH_HDR_SIZE;
> > +                                             VMXNET3_MAX_ETH_HDR_SIZE +
> > +                                             vmxnet3_xdp_headroom(adapter);
> >                       if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
> >                               adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
> >
> > @@ -3563,7 +3595,6 @@ vmxnet3_reset_work(struct work_struct *data)
> >       clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> >  }
> >
> > -
> >  static int
> >  vmxnet3_probe_device(struct pci_dev *pdev,
> >                    const struct pci_device_id *id)
> > @@ -3585,6 +3616,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
> >  #ifdef CONFIG_NET_POLL_CONTROLLER
> >               .ndo_poll_controller = vmxnet3_netpoll,
> >  #endif
> > +             .ndo_bpf = vmxnet3_xdp,
> > +             .ndo_xdp_xmit = vmxnet3_xdp_xmit,
> >       };
> >       int err;
> >       u32 ver;
> > @@ -3900,6 +3933,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
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
> > index 3367db23aa13..5cf4033930d8 100644
> > --- a/drivers/net/vmxnet3/vmxnet3_int.h
> > +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> > @@ -56,6 +56,8 @@
> >  #include <linux/if_arp.h>
> >  #include <linux/inetdevice.h>
> >  #include <linux/log2.h>
> > +#include <linux/bpf.h>
> > +#include <linux/skbuff.h>
> >
> >  #include "vmxnet3_defs.h"
> >
> > @@ -217,6 +219,9 @@ struct vmxnet3_tq_driver_stats {
> >       u64 linearized;         /* # of pkts linearized */
> >       u64 copy_skb_header;    /* # of times we have to copy skb header */
> >       u64 oversized_hdr;
> > +
> > +     u64 xdp_xmit;
> > +     u64 xdp_xmit_err;
> >  };
> >
> >  struct vmxnet3_tx_ctx {
> > @@ -285,6 +290,12 @@ struct vmxnet3_rq_driver_stats {
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
> > @@ -307,6 +318,8 @@ struct vmxnet3_rx_queue {
> >       struct vmxnet3_rx_buf_info     *buf_info[2];
> >       struct Vmxnet3_RxQueueCtrl            *shared;
> >       struct vmxnet3_rq_driver_stats  stats;
> > +     struct bpf_prog __rcu *xdp_bpf_prog;
> > +     struct xdp_rxq_info xdp_rxq;
> >  } __attribute__((__aligned__(SMP_CACHE_BYTES)));
> >
> >  #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
> > @@ -415,6 +428,7 @@ struct vmxnet3_adapter {
> >       u16    tx_prod_offset;
> >       u16    rx_prod_offset;
> >       u16    rx_prod2_offset;
> > +     bool   xdp_enabled;
> >  };
> >
> >  #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
> > @@ -490,6 +504,12 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
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
> > index 000000000000..afb2d43b5464
> > --- /dev/null
> > +++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
> > @@ -0,0 +1,458 @@
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
> > +     struct vmxnet3_rx_queue *rq;
> > +     int i;
> > +
> > +     for (i = 0; i < adapter->num_rx_queues; i++) {
> > +             rq = &adapter->rx_queue[i];
> > +             rcu_assign_pointer(rq->xdp_bpf_prog, prog);
> > +     }
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
> > +     old_bpf_prog = READ_ONCE(adapter->rx_queue[0].xdp_bpf_prog);
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
> > +                    struct vmxnet3_tx_queue *tq)
> > +{
> > +     struct vmxnet3_tx_buf_info *tbi = NULL;
> > +     union Vmxnet3_GenericDesc *gdesc;
> > +     struct vmxnet3_tx_ctx ctx;
> > +     int tx_num_deferred;
> > +     struct sk_buff *skb;
> > +     u32 buf_size;
> > +     int ret = 0;
> > +     u32 dw2;
> > +
> > +     if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
> > +             tq->stats.tx_ring_full++;
> > +             ret = -ENOMEM;
> > +             goto exit;
> > +     }
> > +
> > +     skb = __netdev_alloc_skb(adapter->netdev, xdpf->len, GFP_KERNEL);
> > +     if (unlikely(!skb))
> > +             goto exit;
> > +
>
> Any reason for this not to return an error. Seems like this might be
> better off being the ENOMEM w/ the no descriptor case being something
> like ENOSPC.

my mistake, will fix it, thanks!

>
> Also at some point you may want to look at supporting handling page
> fragments or XDP frames as allocating an skb for an XDP transmit can be
> expensive.

OK! I haven't thought about that yet, will keep it in mind.

>
> > +     memcpy(skb->data, xdpf->data, xdpf->len);
> > +     dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> > +     dw2 |= xdpf->len;
> > +     ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
> > +     gdesc = ctx.sop_txd;
> > +
> > +     buf_size = xdpf->len;
> > +     tbi = tq->buf_info + tq->tx_ring.next2fill;
> > +     tbi->map_type = VMXNET3_MAP_SINGLE;
> > +     tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
> > +                                    skb->data, buf_size,
> > +                                    DMA_TO_DEVICE);
> > +     if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr)) {
> > +             ret = -EFAULT;
> > +             goto exit;
> > +     }
>
> Don't you need to free the skb here?

Yes, will fix it.
>
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
> > +     tbi->skb = skb;
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
> > +     err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq);
> > +     if (err)
> > +             goto exit;
> > +
> > +exit:
>
> What is the point of the label/goto? I don't see another spot that
> references it.
Thanks, will fix it!

>
> > +     __netif_tx_unlock(nq);
> > +     return err;
> > +}
> > +
> > +int
> > +vmxnet3_xdp_xmit(struct net_device *dev,
> > +              int n, struct xdp_frame **frames, u32 flags)
> > +{
> > +     struct vmxnet3_adapter *adapter;
> > +     struct vmxnet3_tx_queue *tq;
> > +     struct netdev_queue *nq;
> > +     int i, err, cpu;
> > +     int nxmit = 0;
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
> > +     if (tq->stopped)
> > +             return -ENETDOWN;
> > +
> > +     nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> > +
> > +     __netif_tx_lock(nq, cpu);
> > +     for (i = 0; i < n; i++) {
> > +             err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq);
> > +             if (err) {
> > +                     tq->stats.xdp_xmit_err++;
> > +                     break;
> > +             }
> > +             nxmit++;
> > +     }
> > +
> > +     tq->stats.xdp_xmit += nxmit;
> > +     __netif_tx_unlock(nq);
> > +
>
> Are you doing anything to free the frames after you transmit them? If I
> am not mistaken you are just copying them over into skbs aren't you, so
> what is freeing the frames after that?

The frames will be free at vmxnet3_tq_cleanup() at dev_kfree_skb_any(tbi->skb);
Because at the vmxnet3_xdp_xmit_frame the allocated skb is saved at tbi->skb,
so it can be freed at tq cleanup.

>
> > +     return nxmit;
> > +}
> > +
> > +static int
> > +__vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, void *data, int data_len,
> > +               int headroom, int frame_sz, bool *need_xdp_flush,
> > +               struct sk_buff *skb)
> > +{
> > +     struct xdp_frame *xdpf;
> > +     void *buf_hard_start;
> > +     struct xdp_buff xdp;
> > +     struct page *page;
> > +     void *orig_data;
> > +     int err, delta;
> > +     int delta_len;
> > +     u32 act;
> > +
> > +     buf_hard_start = data;
> > +     xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, buf_hard_start, headroom, data_len, true);
> > +     orig_data = xdp.data;
> > +
> > +     act = bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
> > +     rq->stats.xdp_packets++;
> > +
> > +     switch (act) {
> > +     case XDP_DROP:
> > +             rq->stats.xdp_drops++;
> > +             break;
> > +     case XDP_PASS:
> > +             /* bpf prog might change len and data position.
> > +              * dataring does not use skb so not support this.
> > +              */
> > +             delta = xdp.data - orig_data;
> > +             delta_len = (xdp.data_end - xdp.data) - data_len;
> > +             if (skb) {
> > +                     skb_reserve(skb, delta);
> > +                     skb_put(skb, delta_len);
> > +             }
> > +             break;
> > +     case XDP_TX:
> > +             xdpf = xdp_convert_buff_to_frame(&xdp);
> > +             if (!xdpf ||
> > +                 vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> > +                     rq->stats.xdp_drops++;
> > +             } else {
> > +                     rq->stats.xdp_tx++;
> > +             }
> > +             break;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
> > +                                 act);
> > +             rq->stats.xdp_aborted++;
> > +             break;
> > +     case XDP_REDIRECT:
> > +             page = alloc_page(GFP_ATOMIC);
> > +             if (!page) {
> > +                     rq->stats.rx_buf_alloc_failure++;
> > +                     return XDP_DROP;
> > +             }
>
> So I think I see the problem I had questions about here. If I am not
> mistaken you are copying the buffer to this page, and then copying this
> page to an skb right? I think you might be better off just writing off
> the Tx/Redirect pages and letting them go through their respective
> paths and just allocating new pages instead assuming these pages were
> consumed.

I'm not sure I understand, can you elaborate?

For XDP_TX, I'm doing 1 extra copy, copying to the newly allocated skb
in vmxnet3_xdp_xmit_back.
For XDP_REDIREC, I allocate a page and copy to the page and call
xdp_do_redirect, there is no copying to skb again. If I don't allocate a
new page, it always crashes at
[62020.425932] BUG: Bad page state in process cpumap/0/map:29  pfn:107548
[62020.440905] kernel BUG at include/linux/mm.h:757!
 VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);

Thanks!
William
