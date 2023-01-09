Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BFD662FB8
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbjAITCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbjAITCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:02:15 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A53E392FA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:02:01 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y1so10564545plb.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 11:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6feXBU93o9kd2Seu0M+PtDmXY9PyjqZz0BP2ZiYK4Ac=;
        b=ToolXUbWan2F4UB0nYjnKWF7XQerpi+OHoMCFmrnWI/SLxf2pesQOwN/8kiQ3+J83r
         R2T3pwvJGjwWhqVx3oOB7bPS3Bs84OMS9NCjUOPBLSWxY1F5YwhVqSlvmqWmTUtLfoew
         2dvGf2AUHB+17UODl/I9AJJhl3/r83C9FaWXEN0mInY6xtZOFNdw7r+gddUPjay2zm/9
         lS1z8zC9YHA9zdHTSCHabwyoPYoWit7qv1hY/4FNkg+e7KMBP3dATgngk46VP/6mrkt+
         djCrhj6ixS42+vFFnKBvZhSznmVFlZaTPgHcoXzUiIRn5/fuj1YZ6qMA4QeNNR0tGhMo
         e5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6feXBU93o9kd2Seu0M+PtDmXY9PyjqZz0BP2ZiYK4Ac=;
        b=alMWerdaNr7I7aw4VcRoWhYGFSrGuYSSyY1nuA7HlDBDtViHVYIg2vhaTV7oAAPK/Q
         rpcm6gHJnjoU7DymLCQcTbwRVKMYoY9Pgg18UgciB+TF8Zn0Q30W+MnPyiVhElk4PvNM
         UG9sCB+826kYASfB7AsAYIJRhUwCRoRx2jGIv9AjN/5ecg4ECLx4ws8j6DiESlsVSYiM
         clxzXB2zC2o4aPi7HNNHCdU38ncwP9FD3TIt+Q8tR6FkNfOthmUKX20Mv6kN/a2QrEvb
         TKZ3F1Gpo7/XiLZol6CQGKtlRugCGf4tsVWoAIli6cp1sosEllkvMIAHz83+BvKopDtK
         gLXg==
X-Gm-Message-State: AFqh2krPKYiz1DwDGUarezU63yaD7eY9EwcA5VYHSMUfAmfaXMR+sgbp
        wl49ef64GgAQUQFxmHmaSog=
X-Google-Smtp-Source: AMrXdXt3LHXs6MY8Ib6PDITOy0NsrPLkEbzOqwjpjClToIbjX5nAbkzVLKfVk67/NoxUm+1xdX2P9Q==
X-Received: by 2002:a05:6a20:4d8a:b0:ad:d182:cd50 with SMTP id gj10-20020a056a204d8a00b000add182cd50mr71228038pzb.36.1673290920604;
        Mon, 09 Jan 2023 11:02:00 -0800 (PST)
Received: from [192.168.0.128] ([98.97.43.196])
        by smtp.googlemail.com with ESMTPSA id q2-20020a63cc42000000b004788780dd8esm5476975pgi.63.2023.01.09.11.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 11:01:59 -0800 (PST)
Message-ID: <c73b3e16b113db00114ee566a8ecf0821aeacd96.camel@gmail.com>
Subject: Re: [RFC PATCH net-next v11] vmxnet3: Add XDP support.
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     tuc@vmware.com, gyang@vmware.com, doshir@vmware.com,
        gerhard@engleder-embedded.com, alexandr.lobakin@intel.com,
        bang@vmware.com
Date:   Mon, 09 Jan 2023 11:01:58 -0800
In-Reply-To: <20230108181826.88882-1-u9012063@gmail.com>
References: <20230108181826.88882-1-u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-01-08 at 10:18 -0800, William Tu wrote:
> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
>=20
> Background:
> The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
> For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
> mapped to the ring's descriptor. If LRO is enabled and packet size larger
> than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> allocated using alloc_page. So for LRO packets, the payload will be in on=
e
> buffer from r0 and multiple from r1, for non-LRO packets, only one
> descriptor in r0 is used for packet size less than 3k.
>=20
> When receiving a packet, the first descriptor will have the sop (start of
> packet) bit set, and the last descriptor will have the eop (end of packet=
)
> bit set. Non-LRO packets will have only one descriptor with both sop and
> eop set.
>=20
> Other than r0 and r1, vmxnet3 dataring is specifically designed for
> handling packets with small size, usually 128 bytes, defined in
> VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the packet from the backe=
nd
> driver in ESXi to the ring's memory region at front-end vmxnet3 driver, i=
n
> order to avoid memory mapping/unmapping overhead. In summary, packet size=
:
>     A. < 128B: use dataring
>     B. 128B - 3K: use ring0 (VMXNET3_RX_BUF_SKB)
>     C. > 3K: use ring0 and ring1 (VMXNET3_RX_BUF_SKB + VMXNET3_RX_BUF_PAG=
E)
> As a result, the patch adds XDP support for packets using dataring
> and r0 (case A and B), not the large packet size when LRO is enabled.
>=20
> XDP Implementation:
> When user loads and XDP prog, vmxnet3 driver checks configurations, such
> as mtu, lro, and re-allocate the rx buffer size for reserving the extra
> headroom, XDP_PACKET_HEADROOM, for XDP frame. The XDP prog will then be
> associated with every rx queue of the device. Note that when using datari=
ng
> for small packet size, vmxnet3 (front-end driver) doesn't control the
> buffer allocation, as a result we allocate a new page and copy packet
> from the dataring to XDP frame.
>=20
> The receive side of XDP is implemented for case A and B, by invoking the
> bpf program at vmxnet3_rq_rx_complete and handle its returned action.
> The vmxnet3_process_xdp(), vmxnet3_process_xdp_small() function handles
> the ring0 and dataring case separately, and decides the next journey of
> the packet afterward.
>=20
> For TX, vmxnet3 has split header design. Outgoing packets are parsed
> first and protocol headers (L2/L3/L4) are copied to the backend. The
> rest of the payload are dma mapped. Since XDP_TX does not parse the
> packet protocol, the entire XDP frame is dma mapped for transmission
> and transmitted in a batch. Later on, the frame is freed and recycled
> back to the memory pool.
>=20
> Performance:
> Tested using two VMs inside one ESXi vSphere 7.0 machine, using single
> core on each vmxnet3 device, sender using DPDK testpmd tx-mode attached
> to vmxnet3 device, sending 64B or 512B UDP packet.
>=20
> VM1 txgen:
> $ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3D3 \
> --forward-mode=3Dtxonly --eth-peer=3D0,<mac addr of vm2>
> option: add "--txonly-multi-flow"
> option: use --txpkts=3D512 or 64 byte
>=20
> VM2 running XDP:
> $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
> $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
> options: XDP_DROP, XDP_PASS, XDP_TX
>=20
> To test REDIRECT to cpu 0, use
> $ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
>=20
> Single core performance comparison with skb-mode.
> 64B:      skb-mode -> native-mode
> XDP_DROP: 1.6Mpps -> 2.4Mpps
> XDP_PASS: 338Kpps -> 367Kpps
> XDP_TX:   1.1Mpps -> 2.3Mpps
> REDIRECT-drop: 1.3Mpps -> 2.3Mpps
>=20
> 512B:     skb-mode -> native-mode
> XDP_DROP: 863Kpps -> 1.3Mpps
> XDP_PASS: 275Kpps -> 376Kpps
> XDP_TX:   554Kpps -> 1.2Mpps
> REDIRECT-drop: 659Kpps -> 1.2Mpps
>=20
> Limitations:
> a. LRO will be disabled when users load XDP program
> b. MTU will be checked and limit to
>    VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
>    SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
>=20
> Signed-off-by: William Tu <u9012063@gmail.com>
> ---
> v10 -> v11:
> work on feedbacks from Alexander Duyck
> internal feedback from Guolin and Ronak
> - fix the issue of xdp_return_frame_bulk, move to up level
>   of vmxnet3_unmap_tx_buf and some refactoring
> - refactor and simplify vmxnet3_tq_cleanup
> - disable XDP when LRO is enabled, suggested by Ronak
> - diff of v10..v11
> https://github.com/williamtu/net-next/compare/e46f2cf5c18f..162e8849903b
>=20
> v9 -> v10:
> - Mark as RFC as we're waiting for internal review
> Feedback from Alexander Duyck
> - fix dma mapping leak of ndo_xdp_xmit case
> - remove unused MAP_INVALID and adjist bitfield
>=20
> v8 -> v9:
> new
> - add rxdataring support (need extra copy but still fast)
> - update performance number (much better than v8!)
>   https://youtu.be/4lm1CSCi78Q
>=20
> - work on feedbacks from Alexander Duyck and Alexander Lobakin
> Alexander Lobakin
> - use xdp_return_frame_bulk and see some performance improvement
> - use xdp_do_flush not xdp_do_flush_map
> - fix several alignment issues, formatting issues, minor code
>   restructure, remove 2 dead functions, unrelated add/del of
>   new lines, add braces when logical ops nearby, endianness
>   conversion
> - remove several oneliner goto label
> - anonymous union of skb and xdpf
> - remove xdp_enabled and use xdp prog directly to check
> - use bitsfields macro --> I decide to do it later as
>   there are many unrelated places needed to change.
>=20
> Alexander Duyck
> - use bitfield for tbi map type
> - anonymous union of skb and xdpf
> - remove use of modulus ops, cpu % tq_number
>=20
> others
> - fix issue reported from kernel test robot using sparse
>=20
> v7 -> v8:
> - work on feedbacks from Gerhard Engleder and Alexander
> - change memory model to use page pool API, rewrite some of the
>   XDP processing code
> - attach bpf xdp prog to adapter, not per rx queue
> - I reference some of the XDP implementation from
>   drivers/net/ethernet/mediatek and
>   drivers/net/ethernet/stmicro/stmmac/
> - drop support for rxdataring for this version
> - redo performance evaluation and demo here
>   https://youtu.be/T7_0yrCXCe0
> - check using /sys/kernel/debug/kmemleak
>=20
> I tested the patch using below script:
> while [ true ]; do
> timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP --skb-mode
> timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP
> timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_PASS --skb-mode
> timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_PASS
> timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_TX --skb-mode
> timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_TX
> timeout 20 ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
> timeout 20 ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e pass
> done
> ---
>  drivers/net/Kconfig                   |   1 +
>  drivers/net/vmxnet3/Makefile          |   2 +-
>  drivers/net/vmxnet3/vmxnet3_drv.c     | 239 ++++++++++++---
>  drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
>  drivers/net/vmxnet3/vmxnet3_int.h     |  44 ++-
>  drivers/net/vmxnet3/vmxnet3_xdp.c     | 425 ++++++++++++++++++++++++++
>  drivers/net/vmxnet3/vmxnet3_xdp.h     |  41 +++
>  7 files changed, 717 insertions(+), 49 deletions(-)
>  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.c
>  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.h
>=20
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 9e63b8c43f3e..a4419d661bdd 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -571,6 +571,7 @@ config VMXNET3
>  	tristate "VMware VMXNET3 ethernet driver"
>  	depends on PCI && INET
>  	depends on PAGE_SIZE_LESS_THAN_64KB
> +	select PAGE_POOL
>  	help
>  	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
>  	  To compile this driver as a module, choose M here: the
> diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
> index a666a88ac1ff..f82870c10205 100644
> --- a/drivers/net/vmxnet3/Makefile
> +++ b/drivers/net/vmxnet3/Makefile
> @@ -32,4 +32,4 @@
> =20
>  obj-$(CONFIG_VMXNET3) +=3D vmxnet3.o
> =20
> -vmxnet3-objs :=3D vmxnet3_drv.o vmxnet3_ethtool.o
> +vmxnet3-objs :=3D vmxnet3_drv.o vmxnet3_ethtool.o vmxnet3_xdp.o
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxn=
et3_drv.c
> index d3e7b27eb933..6e40e40c9329 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -28,6 +28,7 @@
>  #include <net/ip6_checksum.h>
> =20
>  #include "vmxnet3_int.h"
> +#include "vmxnet3_xdp.h"
> =20
>  char vmxnet3_driver_name[] =3D "vmxnet3";
>  #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
> @@ -322,44 +323,58 @@ static u32 get_bitfield32(const __le32 *bitfield, u=
32 pos, u32 size)
>  #endif /* __BIG_ENDIAN_BITFIELD  */
> =20
> =20
> -static void
> -vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> -		     struct pci_dev *pdev)
> +static u32
> +vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pd=
ev,
> +		     struct xdp_frame_bulk *bq)

Is the bq value being used anywhere in here? We probably need to either
drop it.

>  {
> -	if (tbi->map_type =3D=3D VMXNET3_MAP_SINGLE)
> +	u32 map_type =3D tbi->map_type;
> +
> +	if (map_type & VMXNET3_MAP_SINGLE)
>  		dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
>  				 DMA_TO_DEVICE);
> -	else if (tbi->map_type =3D=3D VMXNET3_MAP_PAGE)
> +	else if (map_type & VMXNET3_MAP_PAGE)
>  		dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
>  			       DMA_TO_DEVICE);
> -	else
> -		BUG_ON(tbi->map_type !=3D VMXNET3_MAP_NONE);
> +	else if (map_type & ~(VMXNET3_MAP_SINGLE | VMXNET3_MAP_PAGE |
> +			      VMXNET3_MAP_XDP))
> +		BUG_ON(map_type !=3D VMXNET3_MAP_NONE);

What you might just do here is drop the "else if" in favor of an
"else". Your bug on would basically just need to check for:
	else
		BUG_ON((map_type & ~VMXNET_MAP_XDP));

>  	tbi->map_type =3D VMXNET3_MAP_NONE; /* to help debugging */
> +
> +	return map_type;
>  }
> =20
> =20

In reality we only need to worry about the map_type of the eop buffer
when we are dealing with any frame. You might actually pull the
map_type out in vmxnet3_unmap_pkt below and just pass that to the end.

>  static int
>  vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> -		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter)
> +		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter,
> +		  struct xdp_frame_bulk *bq)
>  {
> -	struct sk_buff *skb;
> +	struct vmxnet3_tx_buf_info *tbi;
>  	int entries =3D 0;
> +	u32 map_type;
> =20
>  	/* no out of order completion */
>  	BUG_ON(tq->buf_info[eop_idx].sop_idx !=3D tq->tx_ring.next2comp);
>  	BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) !=3D 1)=
;
> =20
> -	skb =3D tq->buf_info[eop_idx].skb;
> -	BUG_ON(skb =3D=3D NULL);
> -	tq->buf_info[eop_idx].skb =3D NULL;
> -
> +	tbi =3D &tq->buf_info[eop_idx];
>  	VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
>=20

We may want to record the map_type here for the tbi that contains the
skb or XDP frame. Then we don't need to record the map_type in the loop
below and can save ourselves a few cycles.

Also we may want to preserve the BUG_ON check, but here it would be:
	BUG_ON(tbi->skb =3D=3D NULL);

>  	while (tq->tx_ring.next2comp !=3D eop_idx) {
> -		vmxnet3_unmap_tx_buf(tq->buf_info + tq->tx_ring.next2comp,
> -				     pdev);
> -
> +		map_type =3D vmxnet3_unmap_tx_buf(tq->buf_info +
> +						tq->tx_ring.next2comp, pdev,
> +						bq);
> +		/* xdpf and skb are in an anonymous union, if set we need to
> +		 * free a buffer.
> +		 */
> +		if (tbi->skb) {
> +			if (map_type & VMXNET3_MAP_XDP)
> +				xdp_return_frame_bulk(tbi->xdpf, bq);
> +			else
> +				dev_kfree_skb_any(tbi->skb);
> +			tbi->skb =3D NULL;
> +		}

So this code could probably be moved to the end of the function where
the dev_kfree_skb_any originally was. Then you can drop the "if(tbi-
>skb)" and instead just have the map_type dealt with there. This should
save you from having to read and store map_type multiple times.

>  		/* update next2comp w/o tx_lock. Since we are marking more,
>  		 * instead of less, tx ring entries avail, the worst case is
>  		 * that the tx routine incorrectly re-queues a pkt due to
> @@ -369,7 +384,6 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queu=
e *tq,
>  		entries++;
>  	}
> =20
> -	dev_kfree_skb_any(skb);
>  	return entries;
>  }
> =20

No point moving this into the loop when it can always be processed at
the end. Basically we just needc to pull the if statement you added
above down to here.

> @@ -379,8 +393,10 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
>  			struct vmxnet3_adapter *adapter)
>  {
>  	int completed =3D 0;
> +	struct xdp_frame_bulk bq;
>  	union Vmxnet3_GenericDesc *gdesc;
> =20
> +	xdp_frame_bulk_init(&bq);
>  	gdesc =3D tq->comp_ring.base + tq->comp_ring.next2proc;
>  	while (VMXNET3_TCD_GET_GEN(&gdesc->tcd) =3D=3D tq->comp_ring.gen) {
>  		/* Prevent any &gdesc->tcd field from being (speculatively)
> @@ -390,11 +406,12 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
> =20
>  		completed +=3D vmxnet3_unmap_pkt(VMXNET3_TCD_GET_TXIDX(
>  					       &gdesc->tcd), tq, adapter->pdev,
> -					       adapter);
> +					       adapter, &bq);
> =20
>  		vmxnet3_comp_ring_adv_next2proc(&tq->comp_ring);
>  		gdesc =3D tq->comp_ring.base + tq->comp_ring.next2proc;
>  	}
> +	xdp_flush_frame_bulk(&bq);
> =20
>  	if (completed) {
>  		spin_lock(&tq->tx_lock);
> @@ -414,26 +431,33 @@ static void
>  vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
>  		   struct vmxnet3_adapter *adapter)
>  {
> +	struct xdp_frame_bulk bq;
> +	u32 map_type;
>  	int i;
> =20
> +	xdp_frame_bulk_init(&bq);
> +
>  	while (tq->tx_ring.next2comp !=3D tq->tx_ring.next2fill) {
>  		struct vmxnet3_tx_buf_info *tbi;
> =20
>  		tbi =3D tq->buf_info + tq->tx_ring.next2comp;
> =20

Rather than have vmxnet3_unmap_tx_buf return the map_type you might
just read it yourself here.

> -		vmxnet3_unmap_tx_buf(tbi, adapter->pdev);
> +		map_type =3D vmxnet3_unmap_tx_buf(tbi, adapter->pdev, &bq);
>  		if (tbi->skb) {
> -			dev_kfree_skb_any(tbi->skb);
> +			if (map_type & VMXNET3_MAP_XDP)
> +				xdp_return_frame_bulk(tbi->xdpf, &bq);
> +			else
> +				dev_kfree_skb_any(tbi->skb);
>  			tbi->skb =3D NULL;
>  		}
>  		vmxnet3_cmd_ring_adv_next2comp(&tq->tx_ring);
>  	}
> =20
> -	/* sanity check, verify all buffers are indeed unmapped and freed */
> -	for (i =3D 0; i < tq->tx_ring.size; i++) {
> -		BUG_ON(tq->buf_info[i].skb !=3D NULL ||
> -		       tq->buf_info[i].map_type !=3D VMXNET3_MAP_NONE);
> -	}
> +	xdp_flush_frame_bulk(&bq);
> +
> +	/* sanity check, verify all buffers are indeed unmapped */
> +	for (i =3D 0; i < tq->tx_ring.size; i++)
> +		BUG_ON(tq->buf_info[i].map_type !=3D VMXNET3_MAP_NONE);
> =20
>  	tq->tx_ring.gen =3D VMXNET3_INIT_GEN;
>  	tq->tx_ring.next2fill =3D tq->tx_ring.next2comp =3D 0;

