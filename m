Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49B664CDC4
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbiLNQPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbiLNQPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:15:03 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B08240B5
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:15:00 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id s196so2306885pgs.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nvzAuLmPinnEJr6RPqHDwprUfHMEGHjLiILKHeCyxBM=;
        b=g6eEu8EJYCXBMTBIXSTHAZkdzg6hB7EF4rn3hEpfkvDiI6pIBBvBKC4ShojqVB9Gml
         ifGXe/rkUS+CZszoSNfz8sfDQ5IKr6dxaOFFZmMjLzDzpOrA+EGf6gA/eYzPZYCZ1njn
         MD/2azLgXYPitYrCTbEJcE1VmYY8DwRSBmwTEjqqHxZCDcWAnSOeO5+/00edflv7SIQY
         bBV5SUGrbrCTfWBW/Jy6nqfXk0B5sQwD8/GKwdj3k84RWhuLmM138LXncKpwSq79coOs
         E2O/C1zjC0YJLFkZI7CemaJK29JT/mSVPMMsNCR9Oh5wQq28lR9BWskTlTnqxUcYz7gU
         CVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nvzAuLmPinnEJr6RPqHDwprUfHMEGHjLiILKHeCyxBM=;
        b=dqJZy7eEi9miLuttEytZGQ4YJAmSi2Wtv4/49NkmGmKw2gzmxjxwb6ufgr0lAy10TG
         gRYS9KtDnsqg4nZcwejOMWlY+dJLbFE1J6Grh7ChJYjINcImToa68pRX4jlrfoPYSD7B
         HXjryJR+0E+54txyE9iYTpy9B6OpQSLbJVjMWXs6kyT89GXm+EFemSDTDLZgubFQnUKC
         E9eA3iOk9FHal36GsyvusCVM2OZs9kbgyLUoPfZt09GJiizkIuhGXmsVQNnNkw1OgzFz
         FT3sNNw+Ok5YSIwxreyc+mmgOqT4scPFHUneKuBQtBg+07Uw9kjBVKQBMxJDyRRcAxhV
         YPwQ==
X-Gm-Message-State: ANoB5pnEDG8CkVhwa1d4Ad08vLDf/n85oXXsmWdXjphaBedQSWm4SuVM
        xzfHa/V5py3tWD2/I/POis0=
X-Google-Smtp-Source: AA0mqf497W1TpdItOm2Et1KHyWAPfCrh3UWCEv7AG+eDOI3ZdeihEJk14+KA/UX4NCHUIbm2V5N9+A==
X-Received: by 2002:a05:6a00:1711:b0:576:c2f0:d6a1 with SMTP id h17-20020a056a00171100b00576c2f0d6a1mr24745431pfc.8.1671034499642;
        Wed, 14 Dec 2022 08:14:59 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id x23-20020aa79ad7000000b005781f4577e0sm69008pfp.108.2022.12.14.08.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:14:59 -0800 (PST)
Message-ID: <935e24d6f6b51b5aaee4cf086ad08474e75410b8.camel@gmail.com>
Subject: Re: [RFC PATCH v5] vmxnet3: Add XDP support.
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     tuc@vmware.com, gyang@vmware.com, doshir@vmware.com
Date:   Wed, 14 Dec 2022 08:14:58 -0800
In-Reply-To: <20221214000555.22785-1-u9012063@gmail.com>
References: <20221214000555.22785-1-u9012063@gmail.com>
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

On Tue, 2022-12-13 at 16:05 -0800, William Tu wrote:
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
>     B. 128B - 3K: use ring0
>     C. > 3K: use ring0 and ring1
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
> transmission.
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
> $ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
>=20
> Single core performance comparison with skb-mode.
> 64B:      skb-mode -> native-mode (with this patch)
> XDP_DROP: 960Kpps -> 2.4Mpps
> XDP_PASS: 240Kpps -> 499Kpps
> XDP_TX:   683Kpps -> 2.3Mpps
> REDIRECT: 389Kpps -> 449Kpps
> Same performance compared to v2.
>=20
> 512B:      skb-mode -> native-mode (with this patch)
>                       v2      v3
> XDP_DROP: 640Kpps -> 914Kpps -> 1.3Mpps
> XDP_PASS: 220Kpps -> 240Kpps -> 280Kpps
> XDP_TX:   483Kpps -> 886Kpps -> 1.3Mpps
> REDIRECT: 365Kpps -> 1.2Mpps(?) -> 261Kpps
>=20
> Good performance improvement over v2, due to skip
> skb allocation.
>=20
> Limitations:
> a. LRO will be disabled when users load XDP program
> b. MTU will be checked and limit to
>    VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
>    SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
>=20
> Signed-off-by: William Tu <u9012063@gmail.com>
> ---
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
>  drivers/net/vmxnet3/Makefile          |   2 +-
>  drivers/net/vmxnet3/vmxnet3_drv.c     |  48 ++-
>  drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
>  drivers/net/vmxnet3/vmxnet3_int.h     |  20 ++
>  drivers/net/vmxnet3/vmxnet3_xdp.c     | 454 ++++++++++++++++++++++++++
>  drivers/net/vmxnet3/vmxnet3_xdp.h     |  39 +++
>  6 files changed, 569 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.c
>  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.h
>=20
>=20

<...>

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
> +	bool rxDataRingUsed;
> +	int ret, act;
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
> +		ret =3D VMXNET3_XDP_CONTINUE;
> +		break;
> +	case XDP_DROP:
> +	case XDP_TX:
> +	case XDP_REDIRECT:
> +	case XDP_ABORTED:
> +	default:
> +		/* Reuse and remap the existing buffer. */
> +		ret =3D VMXNET3_XDP_TAKEN;
> +		if (rxDataRingUsed)
> +			return ret;
> +
> +		new_skb =3D rbi->skb;
> +		new_dma_addr =3D
> +			dma_map_single(&adapter->pdev->dev,
> +				       new_skb->data, rbi->len,
> +				       DMA_FROM_DEVICE);
> +		if (dma_mapping_error(&adapter->pdev->dev,
> +				      new_dma_addr)) {
> +			dev_kfree_skb(new_skb);
> +			rq->stats.drop_total++;
> +			return ret;
> +		}
> +		rbi->dma_addr =3D new_dma_addr;
> +		rxd->addr =3D cpu_to_le64(rbi->dma_addr);
> +		rxd->len =3D rbi->len;
> +	}
> +	return ret;
> +}

FOr XDP_DROP and XDP_ABORTED this makes sense. You might want to add a
trace point in the case of aborted just so you can catch such cases for
debug.

However for XDP_TX and XDP_REDIRECT shouldn't both of those be calling
out to seperate functions to either place the frame on a Tx ring or to
hand it off to xdp_do_redirect so that the frame gets routed where it
needs to go? Also don't you run a risk with overwriting frames that
might be waiting on transmit?

