Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68E71A229A
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgDHNJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 09:09:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47621 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727993AbgDHNJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 09:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586351374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XZbQFA2D8jpcYd53d+si3LGCED4GujO47ufGYI//79E=;
        b=RvjBSiZNy5XWHWEJM3nXdyeaQhavxFGXfP0BVKqlYTDpW+Aq/NCg88T5dma4BtMbYWlrf+
        hMK3+06p3rUBSXWLCKOxbv4ECNEA6IpKBzlP5ZWGdjLM+ERouYR0dHOzOllrI1c10aT6Wd
        QG4JFI+EXGK98C2s2NiTzlvVkNghhNI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-TrFcRtnXMq6YEnKGPakBnQ-1; Wed, 08 Apr 2020 09:09:29 -0400
X-MC-Unique: TrFcRtnXMq6YEnKGPakBnQ-1
Received: by mail-wr1-f69.google.com with SMTP id y1so3957673wrp.5
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 06:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XZbQFA2D8jpcYd53d+si3LGCED4GujO47ufGYI//79E=;
        b=QZyDY/xI4iSXHXtv8AXOfLCnhNqt9+dExNfQEMaGcSqmWyql24pYlXfkt6e+HyopKu
         PUaFrfcIPRGHx5oAjCBSHZwRlEBd5uDWjG9vTaNAt1zz+pylJL4OH2MhuPgW+QUsS00U
         hbWSBC2XKjGrhJOs/bnJ1540Tz+56q8EneVZYN/UsR1x4ojEnf7GxjpNEwXPKYMT1cKh
         HFmu1GNTDGerwFuIHpw4ujGUwOAyLsnA3Q7szYFbzjKBuEZ8zhhCiYOjTkLgYL1gKIYH
         3Hw3nhR2P//0qmRg4WGLVWoCri8ZvwgGJliLpklQSfr2MBz207tZZSzJ4VVK1lx1X2wY
         UKjA==
X-Gm-Message-State: AGi0PuZ5UITqbxBgzOP5bsErFChgjUDpuVtnlv5NwHmiOK976wig9xfN
        dafJQQYi9gHYCXS3So1bAqabt6a9uZ6qOsxkICFDpCiRO4dS/G+s2VjXfpoVNrwhfyps6T+3Dpe
        qzHBCbYk7lL+7GagW
X-Received: by 2002:a5d:61ca:: with SMTP id q10mr8238627wrv.348.1586351368544;
        Wed, 08 Apr 2020 06:09:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypK7YzRW6g3Gx8dS+PhbpTtWO6AQHIGhZ5y66OwgmauvrHCSkg2yiA2BqczlD960VkbRLIHQdA==
X-Received: by 2002:a5d:61ca:: with SMTP id q10mr8238592wrv.348.1586351368292;
        Wed, 08 Apr 2020 06:09:28 -0700 (PDT)
Received: from lore-desk-wlan ([151.48.151.50])
        by smtp.gmail.com with ESMTPSA id h13sm10717701wru.64.2020.04.08.06.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 06:09:27 -0700 (PDT)
Date:   Wed, 8 Apr 2020 15:09:23 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH RFC v2 05/33] net: netsec: Add support for XDP frame size
Message-ID: <20200408130923.GA9157@lore-desk-wlan>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634665970.707275.15490233569929847990.stgit@firesoul>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <158634665970.707275.15490233569929847990.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

>=20
> This driver takes advantage of page_pool PP_FLAG_DMA_SYNC_DEV that
> can help reduce the number of cache-lines that need to be flushed
> when doing DMA sync for_device. Due to xdp_adjust_tail can grow the
> area accessible to the by the CPU (can possibly write into), then max
> sync length *after* bpf_prog_run_xdp() needs to be taken into account.
>=20
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/socionext/netsec.c |   30 ++++++++++++++++++-------=
-----
>  1 file changed, 18 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethern=
et/socionext/netsec.c
> index a5a0fb60193a..e1f4be4b3d69 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -884,23 +884,28 @@ static u32 netsec_run_xdp(struct netsec_priv *priv,=
 struct bpf_prog *prog,
>  			  struct xdp_buff *xdp)
>  {
>  	struct netsec_desc_ring *dring =3D &priv->desc_ring[NETSEC_RING_RX];
> -	unsigned int len =3D xdp->data_end - xdp->data;
> +	unsigned int sync, len =3D xdp->data_end - xdp->data;
>  	u32 ret =3D NETSEC_XDP_PASS;
> +	struct page *page;
>  	int err;
>  	u32 act;
> =20
>  	act =3D bpf_prog_run_xdp(prog, xdp);
> =20
> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> +	sync =3D xdp->data_end - xdp->data_hard_start - NETSEC_RXBUF_HEADROOM;
> +	sync =3D max(sync, len);
> +
>  	switch (act) {
>  	case XDP_PASS:
>  		ret =3D NETSEC_XDP_PASS;
>  		break;
>  	case XDP_TX:
>  		ret =3D netsec_xdp_xmit_back(priv, xdp);
> -		if (ret !=3D NETSEC_XDP_TX)
> -			page_pool_put_page(dring->page_pool,
> -					   virt_to_head_page(xdp->data), len,
> -					   true);
> +		if (ret !=3D NETSEC_XDP_TX) {
> +			page =3D virt_to_head_page(xdp->data);
> +			page_pool_put_page(dring->page_pool, page, sync, true);
> +		}
>  		break;
>  	case XDP_REDIRECT:
>  		err =3D xdp_do_redirect(priv->ndev, xdp, prog);
> @@ -908,9 +913,8 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, s=
truct bpf_prog *prog,
>  			ret =3D NETSEC_XDP_REDIR;
>  		} else {
>  			ret =3D NETSEC_XDP_CONSUMED;
> -			page_pool_put_page(dring->page_pool,
> -					   virt_to_head_page(xdp->data), len,
> -					   true);
> +			page =3D virt_to_head_page(xdp->data);
> +			page_pool_put_page(dring->page_pool, page, sync, true);
>  		}
>  		break;
>  	default:
> @@ -921,8 +925,8 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, s=
truct bpf_prog *prog,
>  		/* fall through -- handle aborts by dropping packet */
>  	case XDP_DROP:
>  		ret =3D NETSEC_XDP_CONSUMED;
> -		page_pool_put_page(dring->page_pool,
> -				   virt_to_head_page(xdp->data), len, true);
> +		page =3D virt_to_head_page(xdp->data);
> +		page_pool_put_page(dring->page_pool, page, sync, true);
>  		break;
>  	}
> =20
> @@ -936,10 +940,14 @@ static int netsec_process_rx(struct netsec_priv *pr=
iv, int budget)
>  	struct netsec_rx_pkt_info rx_info;
>  	enum dma_data_direction dma_dir;
>  	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
>  	u16 xdp_xmit =3D 0;
>  	u32 xdp_act =3D 0;
>  	int done =3D 0;
> =20
> +	xdp.rxq =3D &dring->xdp_rxq;
> +	xdp.frame_sz =3D PAGE_SIZE;
> +
>  	rcu_read_lock();
>  	xdp_prog =3D READ_ONCE(priv->xdp_prog);
>  	dma_dir =3D page_pool_get_dma_dir(dring->page_pool);
> @@ -953,7 +961,6 @@ static int netsec_process_rx(struct netsec_priv *priv=
, int budget)
>  		struct sk_buff *skb =3D NULL;
>  		u16 pkt_len, desc_len;
>  		dma_addr_t dma_handle;
> -		struct xdp_buff xdp;
>  		void *buf_addr;
> =20
>  		if (de->attr & (1U << NETSEC_RX_PKT_OWN_FIELD)) {
> @@ -1002,7 +1009,6 @@ static int netsec_process_rx(struct netsec_priv *pr=
iv, int budget)
>  		xdp.data =3D desc->addr + NETSEC_RXBUF_HEADROOM;
>  		xdp_set_data_meta_invalid(&xdp);
>  		xdp.data_end =3D xdp.data + pkt_len;
> -		xdp.rxq =3D &dring->xdp_rxq;
> =20
>  		if (xdp_prog) {
>  			xdp_result =3D netsec_run_xdp(priv, xdp_prog, &xdp);
>=20
>=20

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXo3NAQAKCRA6cBh0uS2t
rDl7APoD2SBpSP768xvL4g6PkdSEwigyyltlMEU4RTP+dXu8fgD7BsrK1X4hM58O
afaiIsVcdx//u5LiLpryY03/U8S1Pgc=
=SjoV
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--

