Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CCB2DAE42
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 14:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgLONss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 08:48:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbgLONss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 08:48:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608040040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJfRN+Htas4Rql/0F3bTNeq3MUu09JFdvkceTzAvMGA=;
        b=fwtJV/mECxSNmHe2X1ffMM3xJU0P/sgvFB6WLKJIsNIIbWAyl1kedk8+3RgmirncNOWp78
        I0lfGKoVz6CTI82uzAGuV/6Z3RPdlwWwTe/SOGGYwzQ8fdVA4GfZ15o2PfWKlstcwRB2dG
        qA02zZxw/HrYU94F/HN5MuXzMmh6Pdc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-1Be6o1jeMJiFQeDmmD_lZA-1; Tue, 15 Dec 2020 08:47:16 -0500
X-MC-Unique: 1Be6o1jeMJiFQeDmmD_lZA-1
Received: by mail-ej1-f70.google.com with SMTP id gs3so3640144ejb.5
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 05:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mJfRN+Htas4Rql/0F3bTNeq3MUu09JFdvkceTzAvMGA=;
        b=GcA+EN4HTik1CJhl1vJ3gOBGor05q83vhDm4HjYH5/dlGTysU/W2NrP4ow34RQfFDe
         iwUdZuPJJi9WxE4vidJDY8npfPOprCWsXGBY69Et9Mci213wlq0qx6yXMTJuLfrBuLHd
         KMHuKujV4guk6OBnZ06epinawOvVD+htF1OrGthvhn6HH/rXrYhFODmghxJtLvO+m3nm
         MxsH/JvTFUlSSPO83n2Ya1Y0tAVZv8epoX7tclhH9CfXQM7PUwXad58aOKcJGOAGxQAK
         InvxCfoMLJb1PQ0k9nM5NI21YiOP27pY7OzpOX2CXJurdg64qCLtUL+Kyq3TewJwIxxz
         oLoQ==
X-Gm-Message-State: AOAM533DnuElZfmuiftkz3WF2x5qwqGLH0zMupsCURictzKsL3qrJcSV
        m2yrBzCYEIr7kT/dRUQmZY7SSaBBWjLraABQ441P3KwP8mSfiAe3EcpfLbvRQ99xMVnz2BHbGFg
        tdkXpyaXHyqcHIu34
X-Received: by 2002:aa7:c1c6:: with SMTP id d6mr15965149edp.275.1608040034756;
        Tue, 15 Dec 2020 05:47:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNYBdOJJwm7LNRONgtfnYKCAE+jRonEWX+UGSTU/bYlGtU61fI44pHoUQ4copIXDirqIl0yA==
X-Received: by 2002:aa7:c1c6:: with SMTP id d6mr15965120edp.275.1608040034391;
        Tue, 15 Dec 2020 05:47:14 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id v9sm1453848ejk.48.2020.12.15.05.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 05:47:13 -0800 (PST)
Date:   Tue, 15 Dec 2020 14:47:10 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201215134710.GB5477@lore-desk>
References: <cover.1607794551.git.lorenzo@kernel.org>
 <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
 <20201215123643.GA23785@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20201215123643.GA23785@ranger.igk.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/=
ethernet/intel/i40e/i40e_txrx.c
> > index 4dbbbd49c389..fcd1ca3343fb 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -2393,12 +2393,12 @@ static int i40e_clean_rx_irq(struct i40e_ring *=
rx_ring, int budget)
> > =20
> >  		/* retrieve a buffer from the ring */
> >  		if (!skb) {
> > -			xdp.data =3D page_address(rx_buffer->page) +
> > -				   rx_buffer->page_offset;
> > -			xdp.data_meta =3D xdp.data;
> > -			xdp.data_hard_start =3D xdp.data -
> > -					      i40e_rx_offset(rx_ring);
> > -			xdp.data_end =3D xdp.data + size;
> > +			unsigned int offset =3D i40e_rx_offset(rx_ring);
>=20
> I now see that we could call the i40e_rx_offset() once per napi, so can
> you pull this variable out and have it initialized a single time? Applies
> to other intel drivers as well.

ack, fine. I will fix in v4.

Regards,
Lorenzo

>=20
> I also feel like it's sub-optimal for drivers that are calculating the
> data_hard_start out of data (intel, bnxt, sfc and mlx4 have this approach)
> due to additional add, but I don't have a solution for that. Would be
> weird to have another helper. Not sure what other people think, but I have
> in mind a "death by 1000 cuts" phrase :)
>=20
> > +			unsigned char *hard_start;
> > +
> > +			hard_start =3D page_address(rx_buffer->page) +
> > +				     rx_buffer->page_offset - offset;
> > +			xdp_prepare_buff(&xdp, hard_start, offset, size);
> >  #if (PAGE_SIZE > 4096)
> >  			/* At larger PAGE_SIZE, frame_sz depend on len size */
> >  			xdp.frame_sz =3D i40e_rx_frame_truesize(rx_ring, size);
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/et=
hernet/intel/ice/ice_txrx.c
> > index d52d98d56367..a7a00060f520 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > @@ -1094,8 +1094,9 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, in=
t budget)
> >  	while (likely(total_rx_pkts < (unsigned int)budget)) {
> >  		union ice_32b_rx_flex_desc *rx_desc;
> >  		struct ice_rx_buf *rx_buf;
> > +		unsigned int size, offset;
> > +		unsigned char *hard_start;
> >  		struct sk_buff *skb;
> > -		unsigned int size;
> >  		u16 stat_err_bits;
> >  		u16 vlan_tag =3D 0;
> >  		u8 rx_ptype;
> > @@ -1138,10 +1139,10 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, =
int budget)
> >  			goto construct_skb;
> >  		}
> > =20
> > -		xdp.data =3D page_address(rx_buf->page) + rx_buf->page_offset;
> > -		xdp.data_hard_start =3D xdp.data - ice_rx_offset(rx_ring);
> > -		xdp.data_meta =3D xdp.data;
> > -		xdp.data_end =3D xdp.data + size;
> > +		offset =3D ice_rx_offset(rx_ring);
> > +		hard_start =3D page_address(rx_buf->page) + rx_buf->page_offset -
> > +			     offset;
> > +		xdp_prepare_buff(&xdp, hard_start, offset, size);
> >  #if (PAGE_SIZE > 4096)
> >  		/* At larger PAGE_SIZE, frame_sz depend on len size */
> >  		xdp.frame_sz =3D ice_rx_frame_truesize(rx_ring, size);
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/et=
hernet/intel/igb/igb_main.c
> > index 365dfc0e3b65..070b2bb4e9ca 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -8700,12 +8700,12 @@ static int igb_clean_rx_irq(struct igb_q_vector=
 *q_vector, const int budget)
> > =20
> >  		/* retrieve a buffer from the ring */
> >  		if (!skb) {
> > -			xdp.data =3D page_address(rx_buffer->page) +
> > -				   rx_buffer->page_offset;
> > -			xdp.data_meta =3D xdp.data;
> > -			xdp.data_hard_start =3D xdp.data -
> > -					      igb_rx_offset(rx_ring);
> > -			xdp.data_end =3D xdp.data + size;
> > +			unsigned int offset =3D igb_rx_offset(rx_ring);
> > +			unsigned char *hard_start;
> > +
> > +			hard_start =3D page_address(rx_buffer->page) +
> > +				     rx_buffer->page_offset - offset;
> > +			xdp_prepare_buff(&xdp, hard_start, offset, size);
> >  #if (PAGE_SIZE > 4096)
> >  			/* At larger PAGE_SIZE, frame_sz depend on len size */
> >  			xdp.frame_sz =3D igb_rx_frame_truesize(rx_ring, size);
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/ne=
t/ethernet/intel/ixgbe/ixgbe_main.c
> > index dcd49cfa36f7..e34054433c7a 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -2325,12 +2325,12 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_ve=
ctor *q_vector,
> > =20
> >  		/* retrieve a buffer from the ring */
> >  		if (!skb) {
> > -			xdp.data =3D page_address(rx_buffer->page) +
> > -				   rx_buffer->page_offset;
> > -			xdp.data_meta =3D xdp.data;
> > -			xdp.data_hard_start =3D xdp.data -
> > -					      ixgbe_rx_offset(rx_ring);
> > -			xdp.data_end =3D xdp.data + size;
> > +			unsigned int offset =3D ixgbe_rx_offset(rx_ring);
> > +			unsigned char *hard_start;
> > +
> > +			hard_start =3D page_address(rx_buffer->page) +
> > +				     rx_buffer->page_offset - offset;
> > +			xdp_prepare_buff(&xdp, hard_start, offset, size);
> >  #if (PAGE_SIZE > 4096)
> >  			/* At larger PAGE_SIZE, frame_sz depend on len size */
> >  			xdp.frame_sz =3D ixgbe_rx_frame_truesize(rx_ring, size);
> > diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/driver=
s/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> > index 624efcd71569..51df79005ccb 100644
> > --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> > @@ -1160,12 +1160,12 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_=
q_vector *q_vector,
> > =20
> >  		/* retrieve a buffer from the ring */
> >  		if (!skb) {
> > -			xdp.data =3D page_address(rx_buffer->page) +
> > -				   rx_buffer->page_offset;
> > -			xdp.data_meta =3D xdp.data;
> > -			xdp.data_hard_start =3D xdp.data -
> > -					      ixgbevf_rx_offset(rx_ring);
> > -			xdp.data_end =3D xdp.data + size;
> > +			unsigned int offset =3D ixgbevf_rx_offset(rx_ring);
> > +			unsigned char *hard_start;
> > +
> > +			hard_start =3D page_address(rx_buffer->page) +
> > +				     rx_buffer->page_offset - offset;
> > +			xdp_prepare_buff(&xdp, hard_start, offset, size);
> >  #if (PAGE_SIZE > 4096)
> >  			/* At larger PAGE_SIZE, frame_sz depend on len size */
> >  			xdp.frame_sz =3D ixgbevf_rx_frame_truesize(rx_ring, size);
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index acbb9cb85ada..af6c9cf59809 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2263,10 +2263,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> > =20
> >  	/* Prefetch header */
> >  	prefetch(data);
> > -
> > -	xdp->data_hard_start =3D data;
> > -	xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> > -	xdp->data_end =3D xdp->data + data_len;
> > +	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
> > +			 data_len);
> >  	xdp_set_data_meta_invalid(xdp);
> > =20
> >  	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/=
net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index ca05dfc05058..8c2197b96515 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -3564,16 +3564,15 @@ static int mvpp2_rx(struct mvpp2_port *port, st=
ruct napi_struct *napi,
> >  		if (xdp_prog) {
> >  			struct xdp_rxq_info *xdp_rxq;
> > =20
> > -			xdp.data_hard_start =3D data;
> > -			xdp.data =3D data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> > -			xdp.data_end =3D xdp.data + rx_bytes;
> > -
> >  			if (bm_pool->pkt_size =3D=3D MVPP2_BM_SHORT_PKT_SIZE)
> >  				xdp_rxq =3D &rxq->xdp_rxq_short;
> >  			else
> >  				xdp_rxq =3D &rxq->xdp_rxq_long;
> > =20
> >  			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
> > +			xdp_prepare_buff(&xdp, data,
> > +					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
> > +					 rx_bytes);
> >  			xdp_set_data_meta_invalid(&xdp);
> > =20
> >  			ret =3D mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/e=
thernet/mellanox/mlx4/en_rx.c
> > index 815381b484ca..86c63dedc689 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > @@ -776,10 +776,9 @@ int mlx4_en_process_rx_cq(struct net_device *dev, =
struct mlx4_en_cq *cq, int bud
> >  						priv->frag_info[0].frag_size,
> >  						DMA_FROM_DEVICE);
> > =20
> > -			xdp.data_hard_start =3D va - frags[0].page_offset;
> > -			xdp.data =3D va;
> > +			xdp_prepare_buff(&xdp, va - frags[0].page_offset,
> > +					 frags[0].page_offset, length);
> >  			xdp_set_data_meta_invalid(&xdp);
> > -			xdp.data_end =3D xdp.data + length;
> >  			orig_data =3D xdp.data;
> > =20
> >  			act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_rx.c
> > index c68628b1f30b..a2f4f0ce427f 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > @@ -1128,10 +1128,8 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq =
*rq, void *va, u16 headroom,
> >  				u32 len, struct xdp_buff *xdp)
> >  {
> >  	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
> > -	xdp->data_hard_start =3D va;
> > -	xdp->data =3D va + headroom;
> > +	xdp_prepare_buff(xdp, va, headroom, len);
> >  	xdp_set_data_meta_invalid(xdp);
> > -	xdp->data_end =3D xdp->data + len;
> >  }
> > =20
> >  static struct sk_buff *
> > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/driv=
ers/net/ethernet/netronome/nfp/nfp_net_common.c
> > index 68e03e8257f2..5d0046c24b8c 100644
> > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > @@ -1914,10 +1914,10 @@ static int nfp_net_rx(struct nfp_net_rx_ring *r=
x_ring, int budget)
> >  			unsigned int dma_off;
> >  			int act;
> > =20
> > -			xdp.data_hard_start =3D rxbuf->frag + NFP_NET_RX_BUF_HEADROOM;
> > -			xdp.data =3D orig_data;
> > -			xdp.data_meta =3D orig_data;
> > -			xdp.data_end =3D orig_data + pkt_len;
> > +			xdp_prepare_buff(&xdp,
> > +					 rxbuf->frag + NFP_NET_RX_BUF_HEADROOM,
> > +					 pkt_off - NFP_NET_RX_BUF_HEADROOM,
> > +					 pkt_len);
> > =20
> >  			act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > =20
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/e=
thernet/qlogic/qede/qede_fp.c
> > index d40220043883..9c50df499046 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > @@ -1091,10 +1091,8 @@ static bool qede_rx_xdp(struct qede_dev *edev,
> >  	enum xdp_action act;
> > =20
> >  	xdp_init_buff(&xdp, rxq->rx_buf_seg_size, &rxq->xdp_rxq);
> > -	xdp.data_hard_start =3D page_address(bd->data);
> > -	xdp.data =3D xdp.data_hard_start + *data_offset;
> > +	xdp_prepare_buff(&xdp, page_address(bd->data), *data_offset, *len);
> >  	xdp_set_data_meta_invalid(&xdp);
> > -	xdp.data_end =3D xdp.data + *len;
> > =20
> >  	/* Queues always have a full reset currently, so for the time
> >  	 * being until there's atomic program replace just mark read
> > diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/r=
x.c
> > index eaa6650955d1..9015a1639234 100644
> > --- a/drivers/net/ethernet/sfc/rx.c
> > +++ b/drivers/net/ethernet/sfc/rx.c
> > @@ -294,12 +294,10 @@ static bool efx_do_xdp(struct efx_nic *efx, struc=
t efx_channel *channel,
> >  	       efx->rx_prefix_size);
> > =20
> >  	xdp_init_buff(&xdp, efx->rx_page_buf_step, &rx_queue->xdp_rxq_info);
> > -	xdp.data =3D *ehp;
> > -	xdp.data_hard_start =3D xdp.data - EFX_XDP_HEADROOM;
> > -
> > +	xdp_prepare_buff(&xdp, *ehp - EFX_XDP_HEADROOM, EFX_XDP_HEADROOM,
> > +			 rx_buf->len);
> >  	/* No support yet for XDP metadata */
> >  	xdp_set_data_meta_invalid(&xdp);
> > -	xdp.data_end =3D xdp.data + rx_buf->len;
> > =20
> >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> >  	rcu_read_unlock();
> > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethe=
rnet/socionext/netsec.c
> > index 945ca9517bf9..80bb1a6612b1 100644
> > --- a/drivers/net/ethernet/socionext/netsec.c
> > +++ b/drivers/net/ethernet/socionext/netsec.c
> > @@ -1015,10 +1015,9 @@ static int netsec_process_rx(struct netsec_priv =
*priv, int budget)
> >  					dma_dir);
> >  		prefetch(desc->addr);
> > =20
> > -		xdp.data_hard_start =3D desc->addr;
> > -		xdp.data =3D desc->addr + NETSEC_RXBUF_HEADROOM;
> > +		xdp_prepare_buff(&xdp, desc->addr, NETSEC_RXBUF_HEADROOM,
> > +				 pkt_len);
> >  		xdp_set_data_meta_invalid(&xdp);
> > -		xdp.data_end =3D xdp.data + pkt_len;
> > =20
> >  		if (xdp_prog) {
> >  			xdp_result =3D netsec_run_xdp(priv, xdp_prog, &xdp);
> > diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/c=
psw.c
> > index 78a923391828..c08fd6a6be9b 100644
> > --- a/drivers/net/ethernet/ti/cpsw.c
> > +++ b/drivers/net/ethernet/ti/cpsw.c
> > @@ -392,22 +392,17 @@ static void cpsw_rx_handler(void *token, int len,=
 int status)
> >  	}
> > =20
> >  	if (priv->xdp_prog) {
> > -		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
> > +		int headroom =3D CPSW_HEADROOM, size =3D len;
> > =20
> > +		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
> >  		if (status & CPDMA_RX_VLAN_ENCAP) {
> > -			xdp.data =3D pa + CPSW_HEADROOM +
> > -				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > -			xdp.data_end =3D xdp.data + len -
> > -				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > -		} else {
> > -			xdp.data =3D pa + CPSW_HEADROOM;
> > -			xdp.data_end =3D xdp.data + len;
> > +			headroom +=3D CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > +			size -=3D CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> >  		}
> > =20
> > +		xdp_prepare_buff(&xdp, pa, headroom, size);
> >  		xdp_set_data_meta_invalid(&xdp);
> > =20
> > -		xdp.data_hard_start =3D pa;
> > -
> >  		port =3D priv->emac_port + cpsw->data.dual_emac;
> >  		ret =3D cpsw_run_xdp(priv, ch, &xdp, page, port);
> >  		if (ret !=3D CPSW_XDP_PASS)
> > diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/=
ti/cpsw_new.c
> > index 1b3385ec9645..c74c997d1cf2 100644
> > --- a/drivers/net/ethernet/ti/cpsw_new.c
> > +++ b/drivers/net/ethernet/ti/cpsw_new.c
> > @@ -335,22 +335,17 @@ static void cpsw_rx_handler(void *token, int len,=
 int status)
> >  	}
> > =20
> >  	if (priv->xdp_prog) {
> > -		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
> > +		int headroom =3D CPSW_HEADROOM, size =3D len;
> > =20
> > +		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
> >  		if (status & CPDMA_RX_VLAN_ENCAP) {
> > -			xdp.data =3D pa + CPSW_HEADROOM +
> > -				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > -			xdp.data_end =3D xdp.data + len -
> > -				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > -		} else {
> > -			xdp.data =3D pa + CPSW_HEADROOM;
> > -			xdp.data_end =3D xdp.data + len;
> > +			headroom +=3D CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> > +			size -=3D CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> >  		}
> > =20
> > +		xdp_prepare_buff(&xdp, pa, headroom, size);
> >  		xdp_set_data_meta_invalid(&xdp);
> > =20
> > -		xdp.data_hard_start =3D pa;
> > -
> >  		ret =3D cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
> >  		if (ret !=3D CPSW_XDP_PASS)
> >  			goto requeue;
> > diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvs=
c_bpf.c
> > index 14a7ee4c6899..93c202d6aff5 100644
> > --- a/drivers/net/hyperv/netvsc_bpf.c
> > +++ b/drivers/net/hyperv/netvsc_bpf.c
> > @@ -45,10 +45,8 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct n=
etvsc_channel *nvchan,
> >  	}
> > =20
> >  	xdp_init_buff(xdp, PAGE_SIZE, &nvchan->xdp_rxq);
> > -	xdp->data_hard_start =3D page_address(page);
> > -	xdp->data =3D xdp->data_hard_start + NETVSC_XDP_HDRM;
> > +	xdp_prepare_buff(xdp, page_address(page), NETVSC_XDP_HDRM, len);
> >  	xdp_set_data_meta_invalid(xdp);
> > -	xdp->data_end =3D xdp->data + len;
> > =20
> >  	memcpy(xdp->data, data, len);
> > =20
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index a82f7823d428..c7cbd058b345 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -1600,10 +1600,8 @@ static struct sk_buff *tun_build_skb(struct tun_=
struct *tun,
> >  		u32 act;
> > =20
> >  		xdp_init_buff(&xdp, buflen, &tfile->xdp_rxq);
> > -		xdp.data_hard_start =3D buf;
> > -		xdp.data =3D buf + pad;
> > +		xdp_prepare_buff(&xdp, buf, pad, len);
> >  		xdp_set_data_meta_invalid(&xdp);
> > -		xdp.data_end =3D xdp.data + len;
> > =20
> >  		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> >  		if (act =3D=3D XDP_REDIRECT || act =3D=3D XDP_TX) {
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 25f3601fb6dd..30a7f2ad39c3 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -710,11 +710,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct vet=
h_rq *rq,
> >  		skb =3D nskb;
> >  	}
> > =20
> > -	xdp.data_hard_start =3D skb->head;
> > -	xdp.data =3D skb_mac_header(skb);
> > -	xdp.data_end =3D xdp.data + pktlen;
> > -	xdp.data_meta =3D xdp.data;
> > -
> > +	xdp_prepare_buff(&xdp, skb->head, skb->mac_header, pktlen);
> >  	/* SKB "head" area always have tailroom for skb_shared_info */
> >  	frame_sz =3D (void *)skb_end_pointer(skb) - xdp.data_hard_start;
> >  	frame_sz +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index a22ce87bcd9c..e57b2d452cbc 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -690,10 +690,8 @@ static struct sk_buff *receive_small(struct net_de=
vice *dev,
> >  		}
> > =20
> >  		xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> > -		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD + vi->hdr_len;
> > -		xdp.data =3D xdp.data_hard_start + xdp_headroom;
> > -		xdp.data_end =3D xdp.data + len;
> > -		xdp.data_meta =3D xdp.data;
> > +		xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
> > +				 xdp_headroom, len);
> >  		orig_data =3D xdp.data;
> >  		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> >  		stats->xdp_packets++;
> > @@ -859,10 +857,8 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
> >  		 */
> >  		data =3D page_address(xdp_page) + offset;
> >  		xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
> > -		xdp.data_hard_start =3D data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
> > -		xdp.data =3D data + vi->hdr_len;
> > -		xdp.data_end =3D xdp.data + (len - vi->hdr_len);
> > -		xdp.data_meta =3D xdp.data;
> > +		xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + vi->hdr_len,
> > +				 VIRTIO_XDP_HEADROOM, len - vi->hdr_len);
> > =20
> >  		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> >  		stats->xdp_packets++;
> > diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> > index 329397c60d84..61d3f5f8b7f3 100644
> > --- a/drivers/net/xen-netfront.c
> > +++ b/drivers/net/xen-netfront.c
> > @@ -866,10 +866,8 @@ static u32 xennet_run_xdp(struct netfront_queue *q=
ueue, struct page *pdata,
> > =20
> >  	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
> >  		      &queue->xdp_rxq);
> > -	xdp->data_hard_start =3D page_address(pdata);
> > -	xdp->data =3D xdp->data_hard_start + XDP_PACKET_HEADROOM;
> > +	xdp_prepare_buff(xdp, page_address(pdata), XDP_PACKET_HEADROOM, len);
> >  	xdp_set_data_meta_invalid(xdp);
> > -	xdp->data_end =3D xdp->data + len;
> > =20
> >  	act =3D bpf_prog_run_xdp(prog, xdp);
> >  	switch (act) {
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 3fb3a9aa1b71..66d8a4b317a3 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -83,6 +83,18 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, st=
ruct xdp_rxq_info *rxq)
> >  	xdp->rxq =3D rxq;
> >  }
> > =20
> > +static inline void
> > +xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > +		 int headroom, int data_len)
> > +{
> > +	unsigned char *data =3D hard_start + headroom;
> > +
> > +	xdp->data_hard_start =3D hard_start;
> > +	xdp->data =3D data;
> > +	xdp->data_end =3D data + data_len;
> > +	xdp->data_meta =3D data;
> > +}
> > +
> >  /* Reserve memory area at end-of data area.
> >   *
> >   * This macro reserves tailroom in the XDP buffer by limiting the
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index a8fa5a9e4137..fe5a80d396e3 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -636,10 +636,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, c=
onst union bpf_attr *kattr,
> >  	if (IS_ERR(data))
> >  		return PTR_ERR(data);
> > =20
> > -	xdp.data_hard_start =3D data;
> > -	xdp.data =3D data + headroom;
> > -	xdp.data_meta =3D xdp.data;
> > -	xdp.data_end =3D xdp.data + size;
> > +	xdp_prepare_buff(&xdp, data, headroom, size);
> > =20
> >  	rxqueue =3D __netif_get_rx_queue(current->nsproxy->net_ns->loopback_d=
ev, 0);
> >  	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index bac56afcf6bc..2997177876cc 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4592,7 +4592,7 @@ static u32 netif_receive_generic_xdp(struct sk_bu=
ff *skb,
> >  	__be16 orig_eth_type;
> >  	struct ethhdr *eth;
> >  	bool orig_bcast;
> > -	int hlen, off;
> > +	int off;
> > =20
> >  	/* Reinjected packets coming from act_mirred or similar should
> >  	 * not get XDP generic processing.
> > @@ -4624,11 +4624,9 @@ static u32 netif_receive_generic_xdp(struct sk_b=
uff *skb,
> >  	 * header.
> >  	 */
> >  	mac_len =3D skb->data - skb_mac_header(skb);
> > -	hlen =3D skb_headlen(skb) + mac_len;
> > -	xdp->data =3D skb->data - mac_len;
> > -	xdp->data_meta =3D xdp->data;
> > -	xdp->data_end =3D xdp->data + hlen;
> > -	xdp->data_hard_start =3D skb->data - skb_headroom(skb);
> > +	xdp_prepare_buff(xdp, skb->data - skb_headroom(skb),
> > +			 skb_headroom(skb) - mac_len,
> > +			 skb_headlen(skb) + mac_len);
> > =20
> >  	/* SKB "head" area always have tailroom for skb_shared_info */
> >  	frame_sz =3D (void *)skb_end_pointer(skb) - xdp->data_hard_start;
> > --=20
> > 2.29.2
> >=20
>=20

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX9i+XAAKCRA6cBh0uS2t
rDqDAP9FfmgiF3NkT4Mbm+ECSza6I7g0XB/nCid/AZ81cdf/rAD/b0uz6g4N/gs4
XCgMP2dukoNzsvLpRaGCabdHcRNW7gM=
=QfDt
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--

