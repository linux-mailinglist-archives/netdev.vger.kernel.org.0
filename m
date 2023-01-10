Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD2666478F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbjAJRkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbjAJRkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:40:47 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B832050F69
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:40:46 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso14286074pjo.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zDfgM88C15kKyc65k4zA5bm8TNZtGPWYUj1+vyPD3oI=;
        b=Zn4qX+F18ydOkCqBO1DdHh3m2skVtIjh1MmlyXWA0ZCYJA6q6UGAVUlHrOhNln4iXD
         XaOA9Zt0wCIiD8sKGtxULXYnQoiBC0x5y45b1ymwyhtq9lYyB33yS0Ir3hQZNFUtxKiG
         g4gY96C9JuHNez7HNIF4k+1nPLOkLA8Fh0GwWbCsfx7oH5rdY5c+V2RcBTQ1ONETYoaF
         04qdJ89ZC1c8kQJjC8DzLilois2xWa+J6YN6thu6oq1AcNdu+mchzj2HC24BZ/sr5pih
         FUQvnGeDNvEnsbdOvRijfC5yMlYBMhSsS18DQh2CPZVlWZ5GcZ2xNu42xi7OrDNrxlJ8
         1n2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zDfgM88C15kKyc65k4zA5bm8TNZtGPWYUj1+vyPD3oI=;
        b=56kOBq9RoxWAZbQAMmtV6wkDZ7CqTRTvvJpGH2eFqF5TEL6/FNobKNqgfBDPIq8iGd
         /1IscZTzZSmA8nw7s2LV/ON+1t1EKLvGIpDraqRt5mheOFolZLy0kjdxuTQzyDMQdNqu
         JvyQOj31Yg6E4tQivnmHjRfY6EydZ4REDIP0G0xgK0FWjgdKJdihiZlejq6P2EjiArSL
         i9YGynevM+fqAfhdcRrpnpSHw3ONrah+DAY4DSYjpT6N9hDOFrY8VQ6RByoE5R+avqyP
         SpFqm97KiyGutRMZ8xb57UAKgCio9jS+na2zLLYRzD04QD4YS4sbtlet9j9vuIoInFtt
         mynQ==
X-Gm-Message-State: AFqh2kozCGWV7DLzQo4EUz39sS54+CXyXqpDUVFnUjVm+ftcFsRcGw92
        j/zgClnUP3VCSrzDyS5obyg=
X-Google-Smtp-Source: AMrXdXutEwoz44c3LWYGLXY1wyr2u8Sy3bhFOlJX9th/Cw1JFp9VGbookjvm/J8szFbEoANJiG4Ung==
X-Received: by 2002:a17:90a:2d7:b0:226:711d:6e4a with SMTP id d23-20020a17090a02d700b00226711d6e4amr31534847pjd.6.1673372446144;
        Tue, 10 Jan 2023 09:40:46 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id k13-20020a17090a3ccd00b00219025945dcsm9208001pjd.19.2023.01.10.09.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 09:40:45 -0800 (PST)
Message-ID: <c5e39384f185fcb8788e7723498702b0235e367e.camel@gmail.com>
Subject: Re: [PATCH net-next v4 09/10] tsnep: Add XDP RX support
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 09:40:44 -0800
In-Reply-To: <20230109191523.12070-10-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-10-gerhard@engleder-embedded.com>
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

On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> If BPF program is set up, then run BPF program for every received frame
> and execute the selected action.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 122 ++++++++++++++++++++-
>  1 file changed, 120 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/eth=
ernet/engleder/tsnep_main.c
> index 451ad1849b9d..002c879639db 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -27,6 +27,7 @@
>  #include <linux/phy.h>
>  #include <linux/iopoll.h>
>  #include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
> =20
>  #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
>  #define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
> @@ -44,6 +45,9 @@
>  #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DEL=
AY_SHIFT) * \
>  				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
> =20
> +#define TSNEP_XDP_TX		BIT(0)
> +#define TSNEP_XDP_REDIRECT	BIT(1)
> +
>  enum {
>  	__TSNEP_DOWN,
>  };
> @@ -625,6 +629,28 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx=
)
>  	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
>  }
> =20
> +static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
> +				struct xdp_buff *xdp,
> +				struct netdev_queue *tx_nq, struct tsnep_tx *tx)
> +{
> +	struct xdp_frame *xdpf =3D xdp_convert_buff_to_frame(xdp);
> +	bool xmit;
> +
> +	if (unlikely(!xdpf))
> +		return false;
> +
> +	__netif_tx_lock(tx_nq, smp_processor_id());
> +
> +	/* Avoid transmit queue timeout since we share it with the slow path */
> +	txq_trans_cond_update(tx_nq);
> +
> +	xmit =3D tsnep_xdp_xmit_frame_ring(xdpf, tx, TSNEP_TX_TYPE_XDP_TX);
> +

Again the trans_cond_update should be after the xmit and only if it is
not indicating it completed the transmit.

> +	__netif_tx_unlock(tx_nq);
> +
> +	return xmit;
> +}
> +
>  static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  {
>  	struct tsnep_tx_entry *entry;
> @@ -983,6 +1009,62 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int=
 count, bool reuse)
>  	return i;
>  }
> =20
> +static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *pro=
g,
> +			       struct xdp_buff *xdp, int *status,
> +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
> +{
> +	unsigned int length;
> +	unsigned int sync;
> +	u32 act;
> +
> +	length =3D xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
> +
> +	act =3D bpf_prog_run_xdp(prog, xdp);
> +
> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> +	sync =3D xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
> +	sync =3D max(sync, length);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		return false;
> +	case XDP_TX:
> +		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
> +			goto out_failure;
> +		*status |=3D TSNEP_XDP_TX;
> +		return true;
> +	case XDP_REDIRECT:
> +		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
> +			goto out_failure;
> +		*status |=3D TSNEP_XDP_REDIRECT;
> +		return true;
> +	default:
> +		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +out_failure:
> +		trace_xdp_exception(rx->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_DROP:
> +		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
> +				   sync, true);
> +		return true;
> +	}
> +}
> +
> +static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status=
,
> +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
> +{
> +	if (status & TSNEP_XDP_TX) {
> +		__netif_tx_lock(tx_nq, smp_processor_id());
> +		tsnep_xdp_xmit_flush(tx);
> +		__netif_tx_unlock(tx_nq);
> +	}
> +
> +	if (status & TSNEP_XDP_REDIRECT)
> +		xdp_do_flush();
> +}
> +
>  static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page =
*page,
>  				       int length)
>  {
> @@ -1018,15 +1100,29 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, str=
uct napi_struct *napi,
>  			 int budget)
>  {
>  	struct device *dmadev =3D rx->adapter->dmadev;
> -	int desc_available;
> -	int done =3D 0;
>  	enum dma_data_direction dma_dir;
>  	struct tsnep_rx_entry *entry;
> +	struct netdev_queue *tx_nq;
> +	struct bpf_prog *prog;
> +	struct xdp_buff xdp;
>  	struct sk_buff *skb;
> +	struct tsnep_tx *tx;
> +	int desc_available;
> +	int xdp_status =3D 0;
> +	int done =3D 0;
>  	int length;
> =20
>  	desc_available =3D tsnep_rx_desc_available(rx);
>  	dma_dir =3D page_pool_get_dma_dir(rx->page_pool);
> +	prog =3D READ_ONCE(rx->adapter->xdp_prog);
> +	if (prog) {
> +		int queue =3D smp_processor_id() % rx->adapter->num_tx_queues;
> +

As I mentioned before. Take a look at how this was addressed in
skb_tx_hash. The modulus division is really expensive.

Also does this make sense. I am assuming you have a 1:1 Tx to Rx
mapping for your queues don't you? If so it might make more sense to
use the Tx queue that you clean in this queue pair.

> +		tx_nq =3D netdev_get_tx_queue(rx->adapter->netdev, queue);
> +		tx =3D &rx->adapter->tx[queue];
> +
> +		xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
> +	}
> =20
>  	while (likely(done < budget) && (rx->read !=3D rx->write)) {
>  		entry =3D &rx->entry[rx->read];
> @@ -1076,6 +1172,25 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, stru=
ct napi_struct *napi,
>  		rx->read =3D (rx->read + 1) % TSNEP_RING_SIZE;
>  		desc_available++;
> =20
> +		if (prog) {
> +			bool consume;
> +
> +			xdp_prepare_buff(&xdp, page_address(entry->page),
> +					 XDP_PACKET_HEADROOM + TSNEP_RX_INLINE_METADATA_SIZE,
> +					 length, false);
> +
> +			consume =3D tsnep_xdp_run_prog(rx, prog, &xdp,
> +						     &xdp_status, tx_nq, tx);
> +			if (consume) {
> +				rx->packets++;
> +				rx->bytes +=3D length;
> +
> +				entry->page =3D NULL;
> +
> +				continue;
> +			}
> +		}
> +
>  		skb =3D tsnep_build_skb(rx, entry->page, length);
>  		if (skb) {
>  			page_pool_release_page(rx->page_pool, entry->page);
> @@ -1094,6 +1209,9 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struc=
t napi_struct *napi,
>  		entry->page =3D NULL;
>  	}
> =20
> +	if (xdp_status)
> +		tsnep_finalize_xdp(rx->adapter, xdp_status, tx_nq, tx);
> +
>  	if (desc_available)
>  		tsnep_rx_refill(rx, desc_available, false);
> =20

