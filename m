Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50735360835
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 13:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhDOLZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 07:25:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDOLZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 07:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618485893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qtyli+TcTqBo1+AtKSSB53e78WK+2Xfl6H+IvpWkujk=;
        b=IzJT08zsHa0fes3QtnQPU46NqM3qStnnp17VW4jrOHhpUM+JLcjxH4MH1MARoEH+lwe/fN
        +ltKP4ylMDBvIrsZ0jFylbY/rL6D5FPRv3eRrV7xzJB2Zj7yfutdrxF7iYs3NcXUll+fy1
        T60Z+LpS7f7pEyc0Xi5HsgfzxqWxThY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-qYPlqIdRMg6Ci1tnRcVwog-1; Thu, 15 Apr 2021 07:24:50 -0400
X-MC-Unique: qYPlqIdRMg6Ci1tnRcVwog-1
Received: by mail-ed1-f69.google.com with SMTP id v5-20020a0564023485b029037ff13253bcso5006273edc.3
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 04:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qtyli+TcTqBo1+AtKSSB53e78WK+2Xfl6H+IvpWkujk=;
        b=daeODa/riHWe3kZoxfzzgMKA9+yJqo4r4W+2uPe0+s4Yoj3fUycvX4WOv+cX9s6yqx
         ubD8Ev8Yy0UAQpxuRJtBgfAX6JvRu4ngwwCmYWa8KzMyRrNrfNlbgNuiMj6FJeukv/kK
         bkYqmbbGg7tNZNR1FRHtJ0zpDbYtH00/cZUvOANo9+PcKa83vwUHlcJZSl8QDagBkVfo
         Q0ccUWPL+SEr0Whc8NdRV7iukCWjeL5FaDg/+dbfPK56Sr7lcl2fhOZSNxU5QNyZeoVr
         b3Jtho6qXV3BMFnJgB1ZAiIWKsdLvpIU7vDzu3Ac8KgI0vOZ8XX5QQcDsYBnb04pFHmn
         zi0A==
X-Gm-Message-State: AOAM533HBQ0W+fOlZLH53pUL5Uw/Tzs9RoVl/vPJUxw1ujsf2zA3SAVm
        zcBS6xW5PeLqsQYMVFjMMG1wXOsi2WFrn1fA/ivLDNTuegXabXy04q6T+PGWvB04RPvc+xP2AyK
        kurUlTMAtXtDD+N4c
X-Received: by 2002:a05:6402:350b:: with SMTP id b11mr3472126edd.288.1618485889716;
        Thu, 15 Apr 2021 04:24:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytyOBJFIQYM0UbnPL9QUE+YYP0KWgVfB4dwFgVRmRiT0kz9PNM2cSazNbOQLO6e0ZEe5lwiw==
X-Received: by 2002:a05:6402:350b:: with SMTP id b11mr3472107edd.288.1618485889539;
        Thu, 15 Apr 2021 04:24:49 -0700 (PDT)
Received: from localhost ([151.66.38.94])
        by smtp.gmail.com with ESMTPSA id jw7sm1717368ejc.4.2021.04.15.04.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 04:24:48 -0700 (PDT)
Date:   Thu, 15 Apr 2021 13:24:45 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net] igb: Fix XDP with PTP enabled
Message-ID: <YHgiffS6A0sDzLGW@lore-desk>
References: <20210415092145.27322-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BSw18Pe0ja94wJ00"
Content-Disposition: inline
In-Reply-To: <20210415092145.27322-1-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BSw18Pe0ja94wJ00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> @@ -8683,7 +8676,10 @@ static int igb_clean_rx_irq(struct igb_q_vector *q=
_vector, const int budget)
>  	while (likely(total_packets < budget)) {
>  		union e1000_adv_rx_desc *rx_desc;
>  		struct igb_rx_buffer *rx_buffer;
> +		ktime_t timestamp =3D 0;
> +		int pkt_offset =3D 0;
>  		unsigned int size;
> +		void *pktbuf;
> =20
>  		/* return some buffers to hardware, one at a time is too slow */
>  		if (cleaned_count >=3D IGB_RX_BUFFER_WRITE) {
> @@ -8703,15 +8699,22 @@ static int igb_clean_rx_irq(struct igb_q_vector *=
q_vector, const int budget)
>  		dma_rmb();
> =20
>  		rx_buffer =3D igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
> +		pktbuf =3D page_address(rx_buffer->page) + rx_buffer->page_offset;
> +
> +		/* pull rx packet timestamp if available */
> +		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> +			timestamp =3D igb_ptp_rx_pktstamp(rx_ring->q_vector,
> +							pktbuf);
> +			pkt_offset +=3D IGB_TS_HDR_LEN;
> +			size -=3D IGB_TS_HDR_LEN;
> +		}
> =20
>  		/* retrieve a buffer from the ring */
>  		if (!skb) {
> -			unsigned int offset =3D igb_rx_offset(rx_ring);
> -			unsigned char *hard_start;
> -
> -			hard_start =3D page_address(rx_buffer->page) +
> -				     rx_buffer->page_offset - offset;
> -			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
> +			xdp.data =3D pktbuf + pkt_offset;
> +			xdp.data_end =3D xdp.data + size;
> +			xdp.data_meta =3D xdp.data;
> +			xdp.data_hard_start =3D pktbuf - igb_rx_offset(rx_ring);

in order to keep it aligned with other xdp drivers, I guess you can do some=
thing like:

			unsigned char *hard_start =3D pktbuf - igb_rx_offset(rx_ring);
			unsigned int offset =3D pkt_offset + igb_rx_offset(rx_ring);

			xdp_prepare_buff(&xdp, hard_start, offset, size, true);

Probably the compiler will optimize it.

Regards,
Lorenzo

> When using native XDP with the igb driver, the XDP frame data doesn't poi=
nt to
> the beginning of the packet. It's off by 16 bytes. Everything works as ex=
pected
> with XDP skb mode.
>=20
> Actually these 16 bytes are used to store the packet timestamps. Therefor=
e, pull
> the timestamp before executing any XDP operations and adjust all other co=
de
> accordingly. The igc driver does it like that as well.
>=20
> Tested with Intel i210 card and AF_XDP sockets.
>=20
> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>=20
> Changes since RFC:
>=20
>  * Removed unused return value definitions
>=20
> Previous versions:
>=20
>  * https://lkml.kernel.org/netdev/20210412101713.15161-1-kurt@linutronix.=
de/
>=20
> drivers/net/ethernet/intel/igb/igb.h      |  3 +-
>  drivers/net/ethernet/intel/igb/igb_main.c | 46 ++++++++++++-----------
>  drivers/net/ethernet/intel/igb/igb_ptp.c  | 21 ++++-------
>  3 files changed, 33 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/=
intel/igb/igb.h
> index 7bda8c5edea5..72cf967c1a00 100644
> --- a/drivers/net/ethernet/intel/igb/igb.h
> +++ b/drivers/net/ethernet/intel/igb/igb.h
> @@ -748,8 +748,7 @@ void igb_ptp_suspend(struct igb_adapter *adapter);
>  void igb_ptp_rx_hang(struct igb_adapter *adapter);
>  void igb_ptp_tx_hang(struct igb_adapter *adapter);
>  void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *=
skb);
> -int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
> -			struct sk_buff *skb);
> +ktime_t igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va);
>  int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
>  int igb_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
>  void igb_set_flag_queue_pairs(struct igb_adapter *, const u32);
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethe=
rnet/intel/igb/igb_main.c
> index a45cd2b416c8..4677b08d3270 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8281,7 +8281,7 @@ static void igb_add_rx_frag(struct igb_ring *rx_rin=
g,
>  static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
>  					 struct igb_rx_buffer *rx_buffer,
>  					 struct xdp_buff *xdp,
> -					 union e1000_adv_rx_desc *rx_desc)
> +					 ktime_t timestamp)
>  {
>  #if (PAGE_SIZE < 8192)
>  	unsigned int truesize =3D igb_rx_pg_size(rx_ring) / 2;
> @@ -8301,12 +8301,8 @@ static struct sk_buff *igb_construct_skb(struct ig=
b_ring *rx_ring,
>  	if (unlikely(!skb))
>  		return NULL;
> =20
> -	if (unlikely(igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))) {
> -		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb)) {
> -			xdp->data +=3D IGB_TS_HDR_LEN;
> -			size -=3D IGB_TS_HDR_LEN;
> -		}
> -	}
> +	if (timestamp)
> +		skb_hwtstamps(skb)->hwtstamp =3D timestamp;
> =20
>  	/* Determine available headroom for copy */
>  	headlen =3D size;
> @@ -8337,7 +8333,7 @@ static struct sk_buff *igb_construct_skb(struct igb=
_ring *rx_ring,
>  static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
>  				     struct igb_rx_buffer *rx_buffer,
>  				     struct xdp_buff *xdp,
> -				     union e1000_adv_rx_desc *rx_desc)
> +				     ktime_t timestamp)
>  {
>  #if (PAGE_SIZE < 8192)
>  	unsigned int truesize =3D igb_rx_pg_size(rx_ring) / 2;
> @@ -8364,11 +8360,8 @@ static struct sk_buff *igb_build_skb(struct igb_ri=
ng *rx_ring,
>  	if (metasize)
>  		skb_metadata_set(skb, metasize);
> =20
> -	/* pull timestamp out of packet data */
> -	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> -		if (!igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb))
> -			__skb_pull(skb, IGB_TS_HDR_LEN);
> -	}
> +	if (timestamp)
> +		skb_hwtstamps(skb)->hwtstamp =3D timestamp;
> =20
>  	/* update buffer offset */
>  #if (PAGE_SIZE < 8192)

>  #if (PAGE_SIZE > 4096)
>  			/* At larger PAGE_SIZE, frame_sz depend on len size */
>  			xdp.frame_sz =3D igb_rx_frame_truesize(rx_ring, size);
> @@ -8733,10 +8736,11 @@ static int igb_clean_rx_irq(struct igb_q_vector *=
q_vector, const int budget)
>  		} else if (skb)
>  			igb_add_rx_frag(rx_ring, rx_buffer, skb, size);
>  		else if (ring_uses_build_skb(rx_ring))
> -			skb =3D igb_build_skb(rx_ring, rx_buffer, &xdp, rx_desc);
> +			skb =3D igb_build_skb(rx_ring, rx_buffer, &xdp,
> +					    timestamp);
>  		else
>  			skb =3D igb_construct_skb(rx_ring, rx_buffer,
> -						&xdp, rx_desc);
> +						&xdp, timestamp);
> =20
>  		/* exit if we failed to retrieve a buffer */
>  		if (!skb) {
> diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ether=
net/intel/igb/igb_ptp.c
> index 86a576201f5f..8e23df7da641 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ptp.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
> @@ -856,30 +856,26 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter =
*adapter)
>  	dev_kfree_skb_any(skb);
>  }
> =20
> -#define IGB_RET_PTP_DISABLED 1
> -#define IGB_RET_PTP_INVALID 2
> -
>  /**
>   * igb_ptp_rx_pktstamp - retrieve Rx per packet timestamp
>   * @q_vector: Pointer to interrupt specific structure
>   * @va: Pointer to address containing Rx buffer
> - * @skb: Buffer containing timestamp and packet
>   *
>   * This function is meant to retrieve a timestamp from the first buffer =
of an
>   * incoming frame.  The value is stored in little endian format starting=
 on
>   * byte 8
>   *
> - * Returns: 0 if success, nonzero if failure
> + * Returns: 0 on failure, timestamp on success
>   **/
> -int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
> -			struct sk_buff *skb)
> +ktime_t igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va)
>  {
>  	struct igb_adapter *adapter =3D q_vector->adapter;
> +	struct skb_shared_hwtstamps ts;
>  	__le64 *regval =3D (__le64 *)va;
>  	int adjust =3D 0;
> =20
>  	if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
> -		return IGB_RET_PTP_DISABLED;
> +		return 0;
> =20
>  	/* The timestamp is recorded in little endian format.
>  	 * DWORD: 0        1        2        3
> @@ -888,10 +884,9 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vecto=
r, void *va,
> =20
>  	/* check reserved dwords are zero, be/le doesn't matter for zero */
>  	if (regval[0])
> -		return IGB_RET_PTP_INVALID;
> +		return 0;
> =20
> -	igb_ptp_systim_to_hwtstamp(adapter, skb_hwtstamps(skb),
> -				   le64_to_cpu(regval[1]));
> +	igb_ptp_systim_to_hwtstamp(adapter, &ts, le64_to_cpu(regval[1]));
> =20
>  	/* adjust timestamp for the RX latency based on link speed */
>  	if (adapter->hw.mac.type =3D=3D e1000_i210) {
> @@ -907,10 +902,8 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vecto=
r, void *va,
>  			break;
>  		}
>  	}
> -	skb_hwtstamps(skb)->hwtstamp =3D
> -		ktime_sub_ns(skb_hwtstamps(skb)->hwtstamp, adjust);
> =20
> -	return 0;
> +	return ktime_sub_ns(ts.hwtstamp, adjust);
>  }
> =20
>  /**
> --=20
> 2.20.1
>=20

--BSw18Pe0ja94wJ00
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHgiewAKCRA6cBh0uS2t
rGifAP41u3eYsesX4Vq3u4Y+ivd77mrhucZi5zn9gWM/uAlQcwD/TY6g3U062vJm
qHYmvOK3bm7d88EC/XsxM7oibFouYgY=
=DTze
-----END PGP SIGNATURE-----

--BSw18Pe0ja94wJ00--

