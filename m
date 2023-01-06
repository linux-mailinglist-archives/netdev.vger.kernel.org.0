Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5737C66058E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbjAFRVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjAFRVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:21:33 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCCC7D9CA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 09:21:31 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v23so2092336pju.3
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 09:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VSWwjY7iuE/8rNrTejbhZeFEn/1AxPpUty2jPzXKlTE=;
        b=Ne9zg1IVmZd7tNGg9hv8i46VsKtJoo6osNzFD3NahVELXxoAodVzuiLKlrvlZIWvdI
         xiI7qW6td7Ugl+s76bBhyNUPgU/iH8NtIOHOLS9yi6PVN9+K6dGE77ICTjD58QIjtzG/
         ohk9ILs8GnA+xJ31WJq7JzjQ2ax5L1jgWjHyhICzizGuawbliPiLp6FWAwpN6piWQ7Pp
         pbIZfrd9m83rMdjfjfZ4udGcRm8Dox4yz0e4l7myB1bOC5P8EKnDJTrwHW29BHiKQ/vJ
         7BpU2QkZbe1EXGrlD4irGXLPAZqjV41trhgvYlzS7v4REn9gQ+fs491a+2rW0ly+5y3H
         A0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VSWwjY7iuE/8rNrTejbhZeFEn/1AxPpUty2jPzXKlTE=;
        b=HeTxUNOz5HSzBjN4PBCVyUFairgzTxls86ceBONizMQnajWjAg3Cdvi9ctTiUJiTze
         qUjw3Y6UnsXnfTUQPXjoB7XrJ7T0HvlOKPb2u7QMmyzpOGChlhkkcsY4NwIwj8CfLXL/
         emJrCXPuW7uNbqnZDKqdTauhyd/yl1rDDhqZKfmP1bW/a/wIeyP4lGDmoDQ0Bg5cHpKa
         9dZSXWRGcenUIRdf/PeEWlg/4Q+62p0q/maCf+psvKS+qfLXmm0u/wRIdONNUbQrCyam
         K2/MNA1NwFRrCSfbmAgFEa/w5WjK44lp2MeldmLB/U8JkWT/5EJnezNk1V5ry+CZPX9C
         LyFg==
X-Gm-Message-State: AFqh2kptprdZNlamxjSc1YLQk2srekNlMPFbDimkdaoqCCvsatBzoMNk
        i16cjdFayrEEBzOKRgRb7l8=
X-Google-Smtp-Source: AMrXdXsrjlD+0pIlftWtodpiAazryGc4hmP3tzi1vnA6PvKhdAaoWMFlQ49ml+n/UgbAQpjRZ4Xeng==
X-Received: by 2002:a17:902:7c95:b0:190:ee85:b25f with SMTP id y21-20020a1709027c9500b00190ee85b25fmr53869314pll.48.1673025691262;
        Fri, 06 Jan 2023 09:21:31 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.231])
        by smtp.googlemail.com with ESMTPSA id o9-20020a170902d4c900b00192cf87ed25sm1249685plg.35.2023.01.06.09.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 09:21:30 -0800 (PST)
Message-ID: <35c08589266c69e25f50e1f1572a0364d32abd08.camel@gmail.com>
Subject: Re: [RFC PATCH net-next v10] vmxnet3: Add XDP support.
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     tuc@vmware.com, gyang@vmware.com, doshir@vmware.com,
        gerhard@engleder-embedded.com, alexandr.lobakin@intel.com,
        bang@vmware.com
Date:   Fri, 06 Jan 2023 09:21:29 -0800
In-Reply-To: <20230105223120.16231-1-u9012063@gmail.com>
References: <20230105223120.16231-1-u9012063@gmail.com>
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

On Thu, 2023-01-05 at 14:31 -0800, William Tu wrote:
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
> v6 -> v7:
> work on feedbacks from Alexander Duyck on XDP_TX and XDP_REDIRECT
> - fix memleak of xdp frame when doing ndo_xdp_xmit (vmxnet3_xdp_xmit)
> - at vmxnet3_xdp_xmit_frame, fix return value, -NOSPC and ENOMEM,
>   and free skb when dma map fails
> - add xdp_buff_clean_frags_flag since we don't support frag
> - update experiements of XDP_TX and XDP_REDIRECT
> - for XDP_REDIRECT, I assume calling xdp_do_redirect will take
> the buffer and free it, so I need to allocate a new buffer to
> refill the rx ring. However, I hit some OOM when testing using
> ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e <drop or pass>
> - I couldn't find the reason so mark this patch as RFC
>=20
> v5 -> v6:
> work on feedbacks from Alexander Duyck
> - remove unused skb parameter at vmxnet3_xdp_xmit
> - add trace point for XDP_ABORTED
> - avoid TX packet buffer being overwritten by allocatin
>   new skb and memcpy (TX performance drop from 2.3 to 1.8Mpps)
> - update some of the performance number and a demo video
>   https://youtu.be/I3nx5wQDTXw
> - pass VMware internal regression test using non-ENS: vmxnet3v2,
>   vmxnet3v3, vmxnet3v4, so remove RFC tag.
>=20
> v4 -> v5:
> - move XDP code to separate file: vmxnet3_xdp.{c, h},
>   suggested by Guolin
> - expose vmxnet3_rq_create_all and vmxnet3_adjust_rx_ring_size
> - more test using samples/bpf/{xdp1, xdp2, xdp_adjust_tail}
> - add debug print
> - rebase on commit 65e6af6cebe
>=20
> v3 -> v4:
> - code refactoring and improved commit message
> - make dataring and non-dataring case clear
> - in XDP_PASS, handle xdp.data and xdp.data_end change after
>   bpf program executed
> - now still working on internal testing
> - v4 applied on net-next commit 65e6af6cebef
>=20
> v2 -> v3:
> - code refactoring: move the XDP processing to the front
>   of the vmxnet3_rq_rx_complete, and minimize the places
>   of changes to existing code.
> - Performance improvement over BUF_SKB (512B) due to skipping
>   skb allocation when DROP and TX.
>=20
> v1 -> v2:
> - Avoid skb allocation for small packet size (when dataring is used)
> - Use rcu_read_lock unlock instead of READ_ONCE
> - Peroformance improvement over v1
> - Merge xdp drop, tx, pass, and redirect into 1 patch
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
>  drivers/net/vmxnet3/vmxnet3_drv.c     | 235 ++++++++++++--
>  drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
>  drivers/net/vmxnet3/vmxnet3_int.h     |  44 ++-
>  drivers/net/vmxnet3/vmxnet3_xdp.c     | 420 ++++++++++++++++++++++++++
>  drivers/net/vmxnet3/vmxnet3_xdp.h     |  41 +++
>  7 files changed, 715 insertions(+), 42 deletions(-)
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
> index d3e7b27eb933..b759c666b586 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -28,6 +28,7 @@
>  #include <net/ip6_checksum.h>
> =20
>  #include "vmxnet3_int.h"
> +#include "vmxnet3_xdp.h"
> =20
>  har vmxnet3_driver_name[] =3D "vmxnet3";
>  #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
> @@ -323,17 +324,27 @@ static u32 get_bitfield32(const __le32 *bitfield, u=
32 pos, u32 size)
> =20
> =20
>  static void
> -vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> -		     struct pci_dev *pdev)
> +vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pd=
ev,
> +		     struct xdp_frame_bulk *bq)
>  {
> -	if (tbi->map_type =3D=3D VMXNET3_MAP_SINGLE)
> +	switch (tbi->map_type) {
> +	case VMXNET3_MAP_SINGLE:
> +	case VMXNET3_MAP_SINGLE | VMXNET3_MAP_XDP:
>  		dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
>  				 DMA_TO_DEVICE);
> -	else if (tbi->map_type =3D=3D VMXNET3_MAP_PAGE)
> +		break;
> +	case VMXNET3_MAP_PAGE:
>  		dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
>  			       DMA_TO_DEVICE);
> -	else
> +		break;
> +	case VMXNET3_MAP_XDP:
> +		break;
> +	default:
>  		BUG_ON(tbi->map_type !=3D VMXNET3_MAP_NONE);
> +	}
> +
> +	if (tbi->map_type & VMXNET3_MAP_XDP)
> +		xdp_return_frame_bulk(tbi->xdpf, bq);
> =20
>  	tbi->map_type =3D VMXNET3_MAP_NONE; /* to help debugging */
>  }

This may not be right place to be returning the XDP frame. More on that
below. If that is the case it might be better to look at just replacing
the =3D=3D with an & check to see if the bit is set rather then use the
switch statement. The else/BUG_ON might need to be tweaked to exclude
MAP_XDP from the map_type via a "(& ~)".

> @@ -343,22 +354,29 @@ static int
>  vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
>  		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter)
>  {
> -	struct sk_buff *skb;
> +	struct vmxnet3_tx_buf_info *tbi;
> +	struct sk_buff *skb =3D NULL;
> +	struct xdp_frame_bulk bq;
>  	int entries =3D 0;
> =20
>  	/* no out of order completion */
>  	BUG_ON(tq->buf_info[eop_idx].sop_idx !=3D tq->tx_ring.next2comp);
>  	BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) !=3D 1)=
;
> =20
> -	skb =3D tq->buf_info[eop_idx].skb;
> -	BUG_ON(skb =3D=3D NULL);
> -	tq->buf_info[eop_idx].skb =3D NULL;
> +	tbi =3D &tq->buf_info[eop_idx];
> +	if (!(tbi->map_type & VMXNET3_MAP_XDP)) {
> +		skb =3D tq->buf_info[eop_idx].skb;
> +		BUG_ON(!skb);
> +		tq->buf_info[eop_idx].skb =3D NULL;
> +	}
> =20
>  	VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
> =20
> +	xdp_frame_bulk_init(&bq);
> +
>  	while (tq->tx_ring.next2comp !=3D eop_idx) {
>  		vmxnet3_unmap_tx_buf(tq->buf_info + tq->tx_ring.next2comp,
> -				     pdev);
> +				     pdev, &bq);
> =20
>  		/* update next2comp w/o tx_lock. Since we are marking more,
>  		 * instead of less, tx ring entries avail, the worst case is
> @@ -369,7 +387,11 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_que=
ue *tq,
>  		entries++;
>  	}
> =20
> -	dev_kfree_skb_any(skb);
> +	xdp_flush_frame_bulk(&bq);
> +
> +	if (skb)
> +		dev_kfree_skb_any(skb);
> +
>  	return entries;
>  }
> =20

Based on the naming I am assuming vmxnet3_unmap_pkt is a per packet
call? If so we are defeating the bulk freeing doing this here. I can't
help but wonder if we have this operating at the correct level. It
might make more sense to do the bulk_init and flush_frame_bulk in
vmxnet3_tq_tx_complete and pass the bulk queue down to this function.

Specifically XDP frames are now capable of being multi-buffer. So it
might make sense to have vmnet3_unmap_tx_buf stick to just doing the
dma unmapping and instead have the freeing of the buffer XDP frame
handled here where you would have handled dev_kfree_skb_any. You could
then push the bulk_init and flush up one level to the caller you
actually get some bulking.


> @@ -414,26 +436,37 @@ static void
>  vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
>  		   struct vmxnet3_adapter *adapter)
>  {
> +	struct xdp_frame_bulk bq;
>  	int i;
> =20
> +	xdp_frame_bulk_init(&bq);
> +
>  	while (tq->tx_ring.next2comp !=3D tq->tx_ring.next2fill) {
>  		struct vmxnet3_tx_buf_info *tbi;
> =20
>  		tbi =3D tq->buf_info + tq->tx_ring.next2comp;
> =20
> -		vmxnet3_unmap_tx_buf(tbi, adapter->pdev);
> -		if (tbi->skb) {
> +		vmxnet3_unmap_tx_buf(tbi, adapter->pdev, &bq);
> +		switch (tbi->map_type) {
> +		case VMXNET3_MAP_SINGLE:
> +		case VMXNET3_MAP_PAGE:
> +			if (!tbi->skb)
> +				break;
>  			dev_kfree_skb_any(tbi->skb);
>  			tbi->skb =3D NULL;
> +			break;
> +		case VMXNET3_MAP_XDP:
> +		default:
> +			break;
>  		}

This can probably be simplified. Basically if tbi->skb && !(map_type &
VMXNET3_MAP_XDP) then you have an skb to free. No need for the switch
statement.

This too could benefit from keeping the buffer freeing out of
vmxnet3_unmap_tx_buf since we could just do something like:
	vmxnet3_unmap_tx_buf()
	/* xdpf and skb are in an anonymous union, if set we need to=C2=A0
	 * free a buffer.
	 */
	if (tbi->skb) {
		if (tbi->map_type & VMXNET3_MAP_XDP)
			xdp_return_frame_bulk(tbi->xdpf, bq);
		else
			dev_kfree_skb_any(tbi->skb);
		tbi->skb =3D NULL;
	}
	=09

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

