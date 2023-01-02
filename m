Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F39965B572
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbjABRC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 12:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjABRC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 12:02:27 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8BEBCB
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 09:02:25 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r18so18617660pgr.12
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 09:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nqeFeMwBzjAnh5ZxMbiDzHm4wGHUnKrb9n0cGjdJ7OE=;
        b=TcVMPpem2t5V0Y3C4ujQRG7VZzi2z596lDtm6C4YE6g5CJlDr45b2Rs1ZzbqDxrQrk
         AGDzifQaa816Nyd71mTUwc4np6vGTsuPur8Ap2WBWDRk1emDA0nA/htGPLamc+wSTii/
         TaqBI0GVVOfRF0F31iDtEAecKGMmeVKV0J6KUAN2V7Jy4m8hTNyVvW4xM+TJa0RyQCrJ
         V4FhuVcSncfzn/hYXrpm+HyYzGAjg9wPrawIp9woXSFLCGogO1kMmSb0fBafvyj05e0a
         F+5Hx12gwJQEOSVA5yggrFYRoKRhlN2a5vWLn+y+7hju7XTeWlyaWQejB0XwtQxpYCL4
         FH4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nqeFeMwBzjAnh5ZxMbiDzHm4wGHUnKrb9n0cGjdJ7OE=;
        b=wiDZDxZLIgU+LZMs3B/1wgqMSpNtrMQCm/byVoSRyefS5Yp1loTB+rzhLeqg2Nh2jY
         CAQaq+eNyBJjPd70X0cZtZ53u7zqgp7zA7q6bZYYLW1CaMLuHLFSCZGTBkI4m40wiZQC
         EHvvQo/qbI3BcEIrWvnTYWEa1+h1G/aTASOVU06kk3ri/ERrrHrJHyhfCFeL6Nzy6PKp
         08VRS0nu3Hem1DMNiqyutbUKE2Dirq8YMSsMt86MUiiv/N6xDxtnRU3ywdvLxZ850X9g
         4/i6sutBxfHjc97Erq869OcKX57aak8Q8+tD493bbw065TPu5WxsZewPoSaWAU/p4TQD
         E0Yg==
X-Gm-Message-State: AFqh2kquHAeNRjuzOn3uc78JljP7NamV4xQnwTTU2/Eg0518NNt51ZAV
        enBtQUccXJZN/870Qczr5K8=
X-Google-Smtp-Source: AMrXdXsrZ5jvyzbUhnki4n24zIEInIlfkqwVfB/QH2hXX6PFw94SHI+K5+BjA4YKaUS6btpOekDX+A==
X-Received: by 2002:a62:ed08:0:b0:577:272f:fdb with SMTP id u8-20020a62ed08000000b00577272f0fdbmr34724963pfh.29.1672678944445;
        Mon, 02 Jan 2023 09:02:24 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id y29-20020aa793dd000000b00575fbe1cf2esm9531844pff.109.2023.01.02.09.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 09:02:23 -0800 (PST)
Message-ID: <64fa6e0c14e15a13720e00211da82f56e2e94397.camel@gmail.com>
Subject: Re: [RFC PATCH v7] vmxnet3: Add XDP support.
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     tuc@vmware.com, gyang@vmware.com, doshir@vmware.com
Date:   Mon, 02 Jan 2023 09:02:20 -0800
In-Reply-To: <20221222154648.21497-1-u9012063@gmail.com>
References: <20221222154648.21497-1-u9012063@gmail.com>
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

On Thu, 2022-12-22 at 07:46 -0800, William Tu wrote:
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
> buffer allocation, as a result the XDP frame's headroom is zero.
>=20
> The receive side of XDP is implemented for case A and B, by invoking the
> bpf program at vmxnet3_rq_rx_complete and handle its returned action.
> The new vmxnet3_run_xdp function handles the difference of using dataring
> or ring0, and decides the next journey of the packet afterward.
>=20
> For TX, vmxnet3 has split header design. Outgoing packets are parsed
> first and protocol headers (L2/L3/L4) are copied to the backend. The
> rest of the payload are dma mapped. Since XDP_TX does not parse the
> packet protocol, the entire XDP frame is using dma mapped for the
> transmission. Because the actual TX is deferred until txThreshold, it's
> possible that an rx buffer is being overwritten by incoming burst of rx
> packets, before tx buffer being transmitted. As a result, we allocate new
> skb and introduce a copy.
>=20
> Performance:
> Tested using two VMs inside one ESXi machine, using single core on each
> vmxnet3 device, sender using DPDK testpmd tx-mode attached to vmxnet3
> device, sending 64B or 512B packet.
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
> $ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e <drop or pass>
>=20
> Single core performance comparison with skb-mode.
> 64B:      skb-mode -> native-mode (with this patch)
> XDP_DROP: 932Kpps -> 2.0Mpps
> XDP_PASS: 284Kpps -> 314Kpps
> XDP_TX:   591Kpps -> 1.8Mpps
> REDIRECT
> cpu-drop: 435Kpps -> 1.1Mpps
> cpu-pass: 387Kpps -> memory leak
>=20
> 512B:      skb-mode -> native-mode (with this patch)
> XDP_DROP: 890Kpps -> 1.3Mpps
> XDP_PASS: 284Kpps -> 314Kpps
> XDP_TX:   555Kpps -> 1.2Mpps
>=20
> Limitations:
> a. LRO will be disabled when users load XDP program
> b. MTU will be checked and limit to
>    VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
>    SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
>=20
> Signed-off-by: William Tu <u9012063@gmail.com>

So after looking over the patch it occurs to me that you may want to
lay some additional ground work before you start trying to natively
enable XDP.

Specifically you may want to look at not using sk_buff as your
structure you store in your Rx rings. Instead it would be better to
just store pages as those can easily be loaded into either an skb or an
xdp_frame without having to do conversion tricks such as taking a page
reference and then freeing the skb.

Likewise you may want to look at cleaning up your Tx path to make
similar changes where you can add a flag and either free an xdp_frame
or an sk_buff so that you don't have to resort to memory copies in
order to convert between types.

> ---
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
>=20
>=20

<...>

> +static int
> +vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
> +		       struct xdp_frame *xdpf,
> +		       struct vmxnet3_tx_queue *tq)
> +{
> +	struct vmxnet3_tx_buf_info *tbi =3D NULL;
> +	union Vmxnet3_GenericDesc *gdesc;
> +	struct vmxnet3_tx_ctx ctx;
> +	int tx_num_deferred;
> +	struct sk_buff *skb;
> +	u32 buf_size;
> +	int ret =3D 0;
> +	u32 dw2;
> +
> +	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) =3D=3D 0) {
> +		tq->stats.tx_ring_full++;
> +		ret =3D -ENOSPC;
> +		goto exit;
> +	}
> +
> +	skb =3D __netdev_alloc_skb(adapter->netdev, xdpf->len, GFP_KERNEL);
> +	if (unlikely(!skb)) {
> +		ret =3D -ENOMEM;
> +		goto exit;
> +	}
> +
> +	memcpy(skb->data, xdpf->data, xdpf->len);

Rather than adding all this overhead to copy the frame into an skb it
would be better to look at supporting the xdp_frame format natively in
your Tx path/cleanup.

This extra copy overhead will make things more expensive and kind of
defeat the whole purpose of the XDP code.

> +	dw2 =3D (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
> +	dw2 |=3D xdpf->len;
> +	ctx.sop_txd =3D tq->tx_ring.base + tq->tx_ring.next2fill;
> +	gdesc =3D ctx.sop_txd;
> +
> +	buf_size =3D xdpf->len;
> +	tbi =3D tq->buf_info + tq->tx_ring.next2fill;
> +	tbi->map_type =3D VMXNET3_MAP_SINGLE;
> +	tbi->dma_addr =3D dma_map_single(&adapter->pdev->dev,
> +				       skb->data, buf_size,
> +				       DMA_TO_DEVICE);
> +	if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr)) {
> +		dev_kfree_skb(skb);
> +		ret =3D -EFAULT;
> +		goto exit;
> +	}
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
> +	tq->shared->txNumDeferred +=3D 1;
> +	tx_num_deferred++;
> +
> +	vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
> +
> +	/* set the last buf_info for the pkt */
> +	tbi->skb =3D skb;
> +	tbi->sop_idx =3D ctx.sop_txd - tq->tx_ring.base;
> +
> +	dma_wmb();
> +	gdesc->dword[2] =3D cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
> +						  VMXNET3_TXD_GEN);
> +	if (tx_num_deferred >=3D le32_to_cpu(tq->shared->txThreshold)) {
> +		tq->shared->txNumDeferred =3D 0;
> +		VMXNET3_WRITE_BAR0_REG(adapter,
> +				       VMXNET3_REG_TXPROD + tq->qid * 8,
> +				       tq->tx_ring.next2fill);
> +	}
> +exit:
> +	return ret;
> +}
> +
> +static int
> +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> +		      struct xdp_frame *xdpf)
> +{
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int err =3D 0, cpu;
> +	int tq_number;
> +
> +	tq_number =3D adapter->num_tx_queues;
> +	cpu =3D smp_processor_id();
> +	tq =3D &adapter->tx_queue[cpu % tq_number];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq =3D netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	__netif_tx_lock(nq, cpu);
> +	err =3D vmxnet3_xdp_xmit_frame(adapter, xdpf, tq);
> +	if (err)
> +		goto exit;
> +
> +exit:
> +	__netif_tx_unlock(nq);
> +	return err;
> +}
> +
> +int
> +vmxnet3_xdp_xmit(struct net_device *dev,
> +		 int n, struct xdp_frame **frames, u32 flags)
> +{
> +	struct vmxnet3_adapter *adapter;
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int i, err, cpu;
> +	int nxmit =3D 0;
> +	int tq_number;
> +
> +	adapter =3D netdev_priv(dev);
> +
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> +		return -ENETDOWN;
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> +		return -EINVAL;
> +
> +	tq_number =3D adapter->num_tx_queues;
> +	cpu =3D smp_processor_id();
> +	tq =3D &adapter->tx_queue[cpu % tq_number];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq =3D netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	__netif_tx_lock(nq, cpu);
> +	for (i =3D 0; i < n; i++) {
> +		err =3D vmxnet3_xdp_xmit_frame(adapter, frames[i], tq);
> +		/* vmxnet3_xdp_xmit_frame has copied the data
> +		 * to skb, so we free xdp frame below.
> +		 */
> +		get_page(virt_to_page(frames[i]->data));

What is this get_page for? I thought your transmit path was doing a
copy out of the data. This is probably the source of your memory leak.

> +		xdp_return_frame(frames[i]);
> +		if (err) {
> +			tq->stats.xdp_xmit_err++;
> +			break;
> +		}
> +		nxmit++;
> +	}
> +
> +	tq->stats.xdp_xmit +=3D nxmit;
> +	__netif_tx_unlock(nq);
> +
> +	return nxmit;
> +}
> +
> +static int
> +__vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, void *data, int data_len,
> +		  int headroom, int frame_sz, bool *need_xdp_flush,
> +		  struct sk_buff *skb)
> +{
> +	struct xdp_frame *xdpf;
> +	void *buf_hard_start;
> +	struct xdp_buff xdp;
> +	void *orig_data;
> +	int err, delta;
> +	int delta_len;
> +	u32 act;
> +
> +	buf_hard_start =3D data;
> +	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, buf_hard_start, headroom, data_len, true);
> +	xdp_buff_clear_frags_flag(&xdp);
> +	orig_data =3D xdp.data;
> +
> +	act =3D bpf_prog_run_xdp(rq->xdp_bpf_prog, &xdp);
> +	rq->stats.xdp_packets++;
> +
> +	switch (act) {
> +	case XDP_DROP:
> +		rq->stats.xdp_drops++;
> +		break;
> +	case XDP_PASS:
> +		/* bpf prog might change len and data position.
> +		 * dataring does not use skb so not support this.
> +		 */
> +		delta =3D xdp.data - orig_data;
> +		delta_len =3D (xdp.data_end - xdp.data) - data_len;
> +		if (skb) {
> +			skb_reserve(skb, delta);
> +			skb_put(skb, delta_len);
> +		}
> +		break;
> +	case XDP_TX:
> +		xdpf =3D xdp_convert_buff_to_frame(&xdp);
> +		if (!xdpf ||
> +		    vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
> +			rq->stats.xdp_drops++;
> +		} else {
> +			rq->stats.xdp_tx++;
> +		}
> +		break;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rq->adapter->netdev, rq->xdp_bpf_prog,
> +				    act);
> +		rq->stats.xdp_aborted++;
> +		break;
> +	case XDP_REDIRECT:
> +		get_page(virt_to_page(data));

So if I am understanding correctly this get_page is needed because we
are converting the skb into an xdp_buff before you attempt to redirect
it right?

So this additional reference should be released when you free the skb?

Also you might want to add some logic to verify that skb->data is a
head_frag and not allocated from slab memory. Also I'm assuming the
size is a constant?

> +		xdp_buff_clear_frags_flag(&xdp);
> +		err =3D xdp_do_redirect(rq->adapter->netdev, &xdp,
> +				      rq->xdp_bpf_prog);
> +		if (!err) {
> +			rq->stats.xdp_redirects++;
> +		} else {
> +			rq->stats.xdp_drops++;
> +			trace_xdp_exception(rq->adapter->netdev,
> +					    rq->xdp_bpf_prog, act);
> +		}
> +		*need_xdp_flush =3D true;
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(rq->adapter->netdev,
> +					    rq->xdp_bpf_prog, act);
> +		break;
> +	}
> +	return act;
> +}
> +
> +static int
> +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct vmxnet3_rx_buf_info =
*rbi,
> +		struct Vmxnet3_RxCompDesc *rcd, bool *need_flush,
> +		bool rxDataRingUsed)
> +{
> +	struct vmxnet3_adapter *adapter;
> +	struct ethhdr *ehdr;
> +	int act =3D XDP_PASS;
> +	void *data;
> +	int sz;
> +
> +	adapter =3D rq->adapter;
> +	if (rxDataRingUsed) {
> +		sz =3D rcd->rxdIdx * rq->data_ring.desc_size;
> +		data =3D &rq->data_ring.base[sz];
> +		ehdr =3D data;
> +		netdev_dbg(adapter->netdev,
> +			   "XDP: rxDataRing packet size %d, eth proto 0x%x\n",
> +			   rcd->len, ntohs(ehdr->h_proto));
> +		act =3D __vmxnet3_run_xdp(rq, data, rcd->len, 0,
> +					rq->data_ring.desc_size, need_flush,
> +					NULL);
> +	} else {
> +		dma_unmap_single(&adapter->pdev->dev,
> +				 rbi->dma_addr,
> +				 rbi->len,
> +				 DMA_FROM_DEVICE);
> +		ehdr =3D (struct ethhdr *)rbi->skb->data;
> +		netdev_dbg(adapter->netdev,
> +			   "XDP: packet size %d, eth proto 0x%x\n",
> +			   rcd->len, ntohs(ehdr->h_proto));
> +		act =3D __vmxnet3_run_xdp(rq,
> +					rbi->skb->data - XDP_PACKET_HEADROOM,
> +					rcd->len, XDP_PACKET_HEADROOM,
> +					rbi->len, need_flush, rbi->skb);
> +	}
> +	return act;
> +}
> +
> +int
> +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +		    struct vmxnet3_rx_queue *rq,
> +		    struct Vmxnet3_RxCompDesc *rcd,
> +		    struct vmxnet3_rx_buf_info *rbi,
> +		    struct Vmxnet3_RxDesc *rxd,
> +		    bool *need_flush)
> +{
> +	struct bpf_prog *xdp_prog;
> +	dma_addr_t new_dma_addr;
> +	struct sk_buff *new_skb;
> +	bool reuse_buf =3D true;
> +	bool rxDataRingUsed;
> +	int ret, act;
> +	int len;
> +
> +	ret =3D VMXNET3_XDP_CONTINUE;
> +	if (unlikely(rcd->len =3D=3D 0))
> +		return VMXNET3_XDP_TAKEN;
> +
> +	rxDataRingUsed =3D VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
> +	rcu_read_lock();
> +	xdp_prog =3D rcu_dereference(rq->xdp_bpf_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		return VMXNET3_XDP_CONTINUE;
> +	}
> +	act =3D vmxnet3_run_xdp(rq, rbi, rcd, need_flush, rxDataRingUsed);
> +	rcu_read_unlock();
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		return VMXNET3_XDP_CONTINUE;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rq->adapter->netdev,
> +				    rq->xdp_bpf_prog, act);
> +		fallthrough;
> +	case XDP_DROP:
> +	case XDP_TX:
> +		ret =3D VMXNET3_XDP_TAKEN;
> +		reuse_buf =3D true;
> +		break;

Ideally the XDP_TX would also be freeing the page but you still have
the memcpy in your Tx path. If you could get rid of that and natively
handle xdp_buf structures it would likely improve the overall
throughput for all your XDP cases.

> +	case XDP_REDIRECT:
> +		ret =3D VMXNET3_XDP_TAKEN;
> +		/* redirect takes buf ownership, so need to refill. */
> +		reuse_buf =3D false;
> +		fallthrough;
> +	default:
> +		break;
> +	}
> +
> +	ret =3D VMXNET3_XDP_TAKEN;
> +	if (rxDataRingUsed)
> +		return ret;
> +
> +	if (reuse_buf) {
> +		/* reuse the existing buf on rx ring. */
> +		new_skb =3D rbi->skb;
> +	} else {
> +		/* xdp_do_redirect takes the buf, so need to refill. */
> +		new_skb =3D netdev_alloc_skb_ip_align(adapter->netdev,
> +						    rbi->len);
> +		if (!new_skb) {
> +			rq->stats.drop_total++;
> +			rq->stats.rx_buf_alloc_failure++;
> +			return ret;
> +		}
> +		skb_reserve(new_skb, XDP_PACKET_HEADROOM);
> +		dev_kfree_skb(rbi->skb);
> +	}
> +	rbi->skb =3D new_skb;
> +	new_dma_addr =3D
> +		dma_map_single(&adapter->pdev->dev,
> +			       new_skb->data, rbi->len,
> +			       DMA_FROM_DEVICE);
> +	if (dma_mapping_error(&adapter->pdev->dev,
> +			      new_dma_addr)) {
> +		dev_kfree_skb(new_skb);
> +		rq->stats.drop_total++;
> +		rq->stats.rx_buf_alloc_failure++;
> +		return ret;
> +	}
> +	rbi->dma_addr =3D new_dma_addr;
> +	rxd->addr =3D cpu_to_le64(rbi->dma_addr);
> +	rxd->len =3D rbi->len;
> +	return ret;
> +}
> diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.h b/drivers/net/vmxnet3/vmxn=
et3_xdp.h
> new file mode 100644
> index 000000000000..6a3c662a4464
> --- /dev/null
> +++ b/drivers/net/vmxnet3/vmxnet3_xdp.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * Linux driver for VMware's vmxnet3 ethernet NIC.
> + * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
> + * Maintained by: pv-drivers@vmware.com
> + *
> + */
> +
> +#ifndef _VMXNET3_XDP_H
> +#define _VMXNET3_XDP_H
> +
> +#include <linux/filter.h>
> +#include <linux/bpf_trace.h>
> +#include <linux/netlink.h>
> +#include <net/xdp.h>
> +
> +#include "vmxnet3_int.h"
> +
> +#define VMXNET3_XDP_ROOM (SKB_DATA_ALIGN(sizeof(struct skb_shared_info))=
 + \
> +				XDP_PACKET_HEADROOM)
> +#define VMXNET3_XDP_MAX_MTU (VMXNET3_MAX_SKB_BUF_SIZE - VMXNET3_XDP_ROOM=
)
> +
> +#define VMXNET3_XDP_CONTINUE 0	/* Pass to the stack, ex: XDP_PASS. */
> +#define VMXNET3_XDP_TAKEN 1	/* Skip the stack, ex: XDP_DROP/TX/REDIRECT =
*/
> +
> +int vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf);
> +void vmxnet3_unregister_xdp_rxq(struct vmxnet3_rx_queue *rq);
> +int vmxnet3_register_xdp_rxq(struct vmxnet3_rx_queue *rq,
> +			     struct vmxnet3_adapter *adapter);
> +int vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter);
> +int vmxnet3_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **f=
rames,
> +		     u32 flags);
> +int vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +			struct vmxnet3_rx_queue *rq,
> +			struct Vmxnet3_RxCompDesc *rcd,
> +			struct vmxnet3_rx_buf_info *rbi,
> +			struct Vmxnet3_RxDesc *rxd,
> +			bool *need_flush);
> +#endif

