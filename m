Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E079765F0E2
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbjAEQLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjAEQLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:11:14 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0BC6406
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 08:11:12 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id cl14so3863336pjb.2
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 08:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kXay177gRQSxd6uBFgwyrfMmRY0yvOUxKReTIFTfLUk=;
        b=hNVczZLzqe5DxlJNS7uvYiFXRpE5z73kdX3p7yV8L3JnfnZEw2Cgj28C4qcjYbcwPP
         J6/eRDyU8ErkECX4naLVnKbqPp3XDT4KbyaRuXlcQLxcrPkaVPIJGyqoszfyc+o69BDa
         GkEa4ZuG0s88Nhg70kp1aRx09o7KpfgOg0qheU4yw3+B1NLwA9uy1qpM9ToAtNJjlqwq
         ++Z7CNsB5xVhyLGRJ+994jFavvE8GfnC5Z6y9dGzBrvv1UsyLDsIRa/ng55vsrlJbXuH
         /VPWWt80vjLzaF0t6qi3lLn7gKiAC+oVv3rR2PzhiMNjmOm3uCH9d/qYnf7E2q0s36ho
         omkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kXay177gRQSxd6uBFgwyrfMmRY0yvOUxKReTIFTfLUk=;
        b=JQpaR/5i+Euew+kFYKgeXjLHxi09KUcFoX9ZUlIJWk25bTseFwhKyGJS+qQsQLoYGP
         0PlIKTVGpc8eBCa5dq6txoa7zMH+qAuYAfFX3tQqMXadx0A2MJrz7/IYF676qdQX8hpL
         txrVeUfqbwSdTZjF+pQ1avTwH72/+62Dw08/o7naswxCsaYVgYypzCkFJpgHuPDhubmS
         nzxwT7fObSxT8jEkGQL5qGBxpqraIEA0CAW9hUfZHf1J+zXnPJVhV1+xHCwRZ90p0ahZ
         8Zc9zAbJeMCOirjy4JqtUb7zlC2ds9uTdeATXF3t0gzZJrmS2MritOEPnu8wwgSem6vy
         ByuQ==
X-Gm-Message-State: AFqh2koGmUFwbIQRcHNJiTGL4mtiAEgNs274Ke8KZnn+YNI6RHrgYWbI
        x69Jn8oGEtKNBfrZ4RhnFEeJEXtKqqk=
X-Google-Smtp-Source: AMrXdXsxKE2ZVFf8LO+fvQ5CS5hKf89CWoS3JtP6f76LYB8qu1s+w52jtiPJv7BPhUQo/+VJPBWNNg==
X-Received: by 2002:a05:6a20:d398:b0:ac:1265:d5bb with SMTP id iq24-20020a056a20d39800b000ac1265d5bbmr66165934pzb.49.1672935071644;
        Thu, 05 Jan 2023 08:11:11 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.231])
        by smtp.googlemail.com with ESMTPSA id e22-20020a63f556000000b00499a90cce5bsm17216420pgk.50.2023.01.05.08.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 08:11:11 -0800 (PST)
Message-ID: <d6f089d37ca57f9fdf16193c5309ad3888da58a4.camel@gmail.com>
Subject: Re: [PATCH v9] vmxnet3: Add XDP support.
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     tuc@vmware.com, gyang@vmware.com, doshir@vmware.com,
        gerhard@engleder-embedded.com, alexandr.lobakin@intel.com,
        bang@vmware.com
Date:   Thu, 05 Jan 2023 08:11:09 -0800
In-Reply-To: <20230104202251.45149-1-u9012063@gmail.com>
References: <20230104202251.45149-1-u9012063@gmail.com>
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

On Wed, 2023-01-04 at 12:22 -0800, William Tu wrote:
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
> v8 -> v9:
> New
> - add rxdataring support (need extra copy but still fast)
> - update performance number (much better than v8!)
>   https://youtu.be/4lm1CSCi78Q
>=20
> Feedbacks from Alexander Duyck and Alexander Lobakin
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
>  drivers/net/vmxnet3/vmxnet3_drv.c     | 233 ++++++++++++--
>  drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
>  drivers/net/vmxnet3/vmxnet3_int.h     |  45 ++-
>  drivers/net/vmxnet3/vmxnet3_xdp.c     | 419 ++++++++++++++++++++++++++
>  drivers/net/vmxnet3/vmxnet3_xdp.h     |  41 +++
>  7 files changed, 712 insertions(+), 43 deletions(-)
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
> index d3e7b27eb933..2172d29360fc 100644
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
> @@ -323,18 +324,24 @@ static u32 get_bitfield32(const __le32 *bitfield, u=
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
> +		xdp_return_frame_bulk(tbi->xdpf, bq);
> +		break;
> +	default:
>  		BUG_ON(tbi->map_type !=3D VMXNET3_MAP_NONE);
> -
> +	}
>  	tbi->map_type =3D VMXNET3_MAP_NONE; /* to help debugging */
>  }

So this will end up leaking mappings if I am not mistaken as you will
need to unmap XDP redirected frames before freeing them.

You could look at masking this and doing the MAP_SINGLE | MAP_PAGE
checks in a switch statement, and then freeing an xdp frame in a
separate if statement after the switch statement.

> =20
> @@ -343,22 +350,29 @@ static int
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
> +	if (tbi->map_type !=3D VMXNET3_MAP_XDP) {
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
>=20
>=20

<...>

> diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxn=
et3_int.h
> index 3367db23aa13..72cbdad8aff7 100644
> --- a/drivers/net/vmxnet3/vmxnet3_int.h
> +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> @@ -56,6 +56,9 @@
>  #include <linux/if_arp.h>
>  #include <linux/inetdevice.h>
>  #include <linux/log2.h>
> +#include <linux/bpf.h>
> +#include <linux/skbuff.h>
> +#include <net/page_pool.h>
> =20
>  #include "vmxnet3_defs.h"
> =20
> @@ -188,19 +191,21 @@ struct vmxnet3_tx_data_ring {
>  	dma_addr_t          basePA;
>  };
> =20
> -enum vmxnet3_buf_map_type {
> -	VMXNET3_MAP_INVALID =3D 0,
> -	VMXNET3_MAP_NONE,
> -	VMXNET3_MAP_SINGLE,
> -	VMXNET3_MAP_PAGE,
> -};
> +#define VMXNET3_MAP_INVALID	BIT(0)
> +#define VMXNET3_MAP_NONE	BIT(1)
> +#define VMXNET3_MAP_SINGLE	BIT(2)
> +#define VMXNET3_MAP_PAGE	BIT(3)
> +#define VMXNET3_MAP_XDP		BIT(4)

So I think I see two issues here. From what I can tell MAP_INVALID
isn't used anywhere, so it can be dropped.

Instead of being a bitmap MAP_NONE should probably just be 0 instead of
being a bitmap value. Then you could use it as an overwrite to reset
your mapping type and the MAP_NONE uses would still be valid
throughout.

So something more like:
#define VMXNET3_MAP_NONE	0
#define VMXNET3_MAP_SINGLE	BIT(0)
#define VMXNET3_MAP_PAGE	BIT(1)
#define VMXNET3_MAP_XDP		BIT(2)

>  struct vmxnet3_tx_buf_info {
>  	u32      map_type;
>  	u16      len;
>  	u16      sop_idx;
>  	dma_addr_t  dma_addr;
> -	struct sk_buff *skb;
> +	union {
> +		struct sk_buff *skb;
> +		struct xdp_frame *xdpf;
> +	};
>  };
> =20
>  struct vmxnet3_tq_driver_stats {
> @@ -217,6 +222,9 @@ struct vmxnet3_tq_driver_stats {
>  	u64 linearized;         /* # of pkts linearized */
>  	u64 copy_skb_header;    /* # of times we have to copy skb header */
>  	u64 oversized_hdr;
> +
> +	u64 xdp_xmit;
> +	u64 xdp_xmit_err;
>  };
> =20
>  struct vmxnet3_tx_ctx {
> @@ -253,12 +261,13 @@ struct vmxnet3_tx_queue {
>  						    * stopped */
>  	int				qid;
>  	u16				txdata_desc_size;
> -} __attribute__((__aligned__(SMP_CACHE_BYTES)));
> +} ____cacheline_aligned;
> =20
>  enum vmxnet3_rx_buf_type {
>  	VMXNET3_RX_BUF_NONE =3D 0,
>  	VMXNET3_RX_BUF_SKB =3D 1,
> -	VMXNET3_RX_BUF_PAGE =3D 2
> +	VMXNET3_RX_BUF_PAGE =3D 2,
> +	VMXNET3_RX_BUF_XDP =3D 3
>  };
> =20
>  #define VMXNET3_RXD_COMP_PENDING        0
> @@ -271,6 +280,7 @@ struct vmxnet3_rx_buf_info {
>  	union {
>  		struct sk_buff *skb;
>  		struct page    *page;
> +		struct page    *pp_page; /* Page Pool for XDP frame */
>  	};
>  	dma_addr_t dma_addr;
>  };
> @@ -285,6 +295,12 @@ struct vmxnet3_rq_driver_stats {
>  	u64 drop_err;
>  	u64 drop_fcs;
>  	u64 rx_buf_alloc_failure;
> +
> +	u64 xdp_packets;	/* Total packets processed by XDP. */
> +	u64 xdp_tx;
> +	u64 xdp_redirects;
> +	u64 xdp_drops;
> +	u64 xdp_aborted;
>  };
> =20
>  struct vmxnet3_rx_data_ring {
> @@ -307,7 +323,9 @@ struct vmxnet3_rx_queue {
>  	struct vmxnet3_rx_buf_info     *buf_info[2];
>  	struct Vmxnet3_RxQueueCtrl            *shared;
>  	struct vmxnet3_rq_driver_stats  stats;
> -} __attribute__((__aligned__(SMP_CACHE_BYTES)));
> +	struct page_pool *page_pool;
> +	struct xdp_rxq_info xdp_rxq;
> +} ____cacheline_aligned;
> =20
>  #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
>  #define VMXNET3_DEVICE_MAX_RX_QUEUES 32   /* Keep this value as a power =
of 2 */
> @@ -415,6 +433,7 @@ struct vmxnet3_adapter {
>  	u16    tx_prod_offset;
>  	u16    rx_prod_offset;
>  	u16    rx_prod2_offset;
> +	struct bpf_prog __rcu *xdp_bpf_prog;
>  };
> =20
>  #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
> @@ -490,6 +509,12 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapt=
er);
>  void
>  vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
> =20
> +int
> +vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter);
> +
> +void
> +vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter);
> +
>  netdev_features_t
>  vmxnet3_fix_features(struct net_device *netdev, netdev_features_t featur=
es);
> =20
> diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxn=
et3_xdp.c
> new file mode 100644
> index 000000000000..7a34dbf8eabc
> --- /dev/null
> +++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
> @@ -0,0 +1,419 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Linux driver for VMware's vmxnet3 ethernet NIC.
> + * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
> + * Maintained by: pv-drivers@vmware.com
> + *
> + */
> +
> +#include "vmxnet3_int.h"
> +#include "vmxnet3_xdp.h"
> +
> +static void
> +vmxnet3_xdp_exchange_program(struct vmxnet3_adapter *adapter,
> +			     struct bpf_prog *prog)
> +{
> +	rcu_assign_pointer(adapter->xdp_bpf_prog, prog);
> +}
> +
> +static int
> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> +		struct netlink_ext_ack *extack)
> +{
> +	struct vmxnet3_adapter *adapter =3D netdev_priv(netdev);
> +	struct bpf_prog *new_bpf_prog =3D bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	bool need_update;
> +	bool running;
> +	int err =3D 0;
> +
> +	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	old_bpf_prog =3D rcu_dereference(adapter->xdp_bpf_prog);
> +	if (!new_bpf_prog && !old_bpf_prog)
> +		return 0;
> +
> +	running =3D netif_running(netdev);
> +	need_update =3D !!old_bpf_prog !=3D !!new_bpf_prog;
> +
> +	if (running && need_update)
> +		vmxnet3_quiesce_dev(adapter);
> +
> +	vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
> +	if (old_bpf_prog)
> +		bpf_prog_put(old_bpf_prog);
> +
> +	if (!running || !need_update)
> +		return 0;
> +
> +	vmxnet3_reset_dev(adapter);
> +	vmxnet3_rq_destroy_all(adapter);
> +	vmxnet3_adjust_rx_ring_size(adapter);
> +	err =3D vmxnet3_rq_create_all(adapter);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "failed to re-create rx queues for XDP.");
> +		err =3D -EOPNOTSUPP;
> +		return err;
> +	}
> +	err =3D vmxnet3_activate_dev(adapter);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "failed to activate device for XDP.");
> +		err =3D -EOPNOTSUPP;
> +		return err;
> +	}
> +	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> +	return err;
> +}
> +
> +/* This is the main xdp call used by kernel to set/unset eBPF program. *=
/
> +int
> +vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +bool
> +vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter)
> +{
> +	return !!rcu_access_pointer(adapter->xdp_bpf_prog);
> +}
> +
> +int
> +vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter)
> +{
> +	return vmxnet3_xdp_enabled(adapter) ? VMXNET3_XDP_PAD : 0;
> +}
> +
> +static int
> +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> +		       struct xdp_frame *xdpf,
> +		       struct vmxnet3_tx_queue *tq, bool dma_map)
> +{
> +	struct vmxnet3_tx_buf_info *tbi =3D NULL;
> +	union Vmxnet3_GenericDesc *gdesc;
> +	struct vmxnet3_tx_ctx ctx;
> +	int tx_num_deferred;
> +	struct page *page;
> +	u32 buf_size;
> +	int ret =3D 0;
> +	u32 dw2;
> +
> +	dw2 =3D (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> +	dw2 |=3D xdpf->len;
> +	ctx.sop_txd =3D tq->tx_ring.base + tq->tx_ring.next2fill;
> +	gdesc =3D ctx.sop_txd;
> +
> +	buf_size =3D xdpf->len;
> +	tbi =3D tq->buf_info + tq->tx_ring.next2fill;
> +
> +	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) =3D=3D 0) {
> +		tq->stats.tx_ring_full++;
> +		return -ENOSPC;
> +	}
> +
> +	tbi->map_type =3D VMXNET3_MAP_XDP;
> +	if (dma_map) { /* ndo_xdp_xmit */
> +		tbi->dma_addr =3D dma_map_single(&adapter->pdev->dev,
> +					       xdpf->data, buf_size,
> +					       DMA_TO_DEVICE);
> +		if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr))
> +			return -EFAULT;

You should add some logic here to |=3D MAP_SINGLE into the map_type so
that you know that you also need to unmap it later on.

> +	} else { /* XDP buffer from page pool */
> +		page =3D virt_to_head_page(xdpf->data);
> +		tbi->dma_addr =3D page_pool_get_dma_addr(page) +
> +				XDP_PACKET_HEADROOM;
> +		dma_sync_single_for_device(&adapter->pdev->dev,
> +					   tbi->dma_addr, buf_size,
> +					   DMA_BIDIRECTIONAL);
> +	}
> +	tbi->xdpf =3D xdpf;
> +	tbi->len =3D buf_size;
> +
> +	gdesc =3D tq->tx_ring.base + tq->tx_ring.next2fill;
> +	WARN_ON_ONCE(gdesc->txd.gen =3D=3D tq->tx_ring.gen);
> +
> +	gdesc->txd.addr =3D cpu_to_le64(tbi->dma_addr);
> +	gdesc->dword[2] =3D cpu_to_le32(dw2);
> +
> +	/* Setup the EOP desc */
> +	gdesc->dword[3] =3D cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
> +
> +	gdesc->txd.om =3D 0;
> +	gdesc->txd.msscof =3D 0;
> +	gdesc->txd.hlen =3D 0;
> +	gdesc->txd.ti =3D 0;
> +
> +	tx_num_deferred =3D le32_to_cpu(tq->shared->txNumDeferred);
> +	le32_add_cpu(&tq->shared->txNumDeferred, 1);
> +	tx_num_deferred++;
> +
> +	vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
> +
> +	/* set the last buf_info for the pkt */
> +	tbi->sop_idx =3D ctx.sop_txd - tq->tx_ring.base;
> +
> +	dma_wmb();
> +	gdesc->dword[2] =3D cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> +						  VMXNET3_TXD_GEN);
> +
> +	if (tx_num_deferred >=3D le32_to_cpu(tq->shared->txThreshold)) {
> +		tq->shared->txNumDeferred =3D 0;
> +		VMXNET3_WRITE_BAR0_REG(adapter,
> +				       VMXNET3_REG_TXPROD + tq->qid * 8,
> +				       tq->tx_ring.next2fill);
> +	}
> +	return ret;
> +}
> +
