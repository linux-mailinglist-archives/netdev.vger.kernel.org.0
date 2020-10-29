Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B152029EC94
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgJ2NQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:16:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgJ2NQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603977365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Muj7rfopJdT5GXxgbmz6MN0zN66mg2zfOlcoX4apg2U=;
        b=TdF0FxwfO9E2bKfdPyFKxmQ1eI9sugaV9GPkxq43pOuPz9WpZK7AOXfGccYvTDOAmyoiuF
        tuT0U2Q0mGjrlM0de95rBwwAYdO0IV7kyKsZoQUX5nd+kkOkFVZLsbVQRfeV1sSeNPKakg
        IdaSinMCfoFrJn5V39hGqeN20+bXcNk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-xydLpwc6PuqyM5LFjOoa7Q-1; Thu, 29 Oct 2020 09:16:02 -0400
X-MC-Unique: xydLpwc6PuqyM5LFjOoa7Q-1
Received: by mail-wm1-f69.google.com with SMTP id z62so624509wmb.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 06:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Muj7rfopJdT5GXxgbmz6MN0zN66mg2zfOlcoX4apg2U=;
        b=WjJObCZ2752HFuzCI1BPhcI0Ff0qllArw+SlxZ4XfwbYU8GUJB82zZcnndfOHPzguE
         87LtPPJf2/sI/E4938G1YJrhQ42c9zVcam+A5dEx3qFysr1fviVd0DjIFhtdbsI8o7tM
         XjdgrtGM8DNP6wu0ZL5Ftl3vuG4UkTKvOH+zw7M9tStSICG5ybhkCQbNqhbYCdchvDKF
         +2aiDQK17onRkivBdT8YcjHl0XlL17jGjJ+vwudj1sMTRLFeC4K+qVhOmR2vOJOgL0tV
         vHhC9QOyyO4po5/mSKgXGnzXQKAJMwquZ4YuccJ+B0b88qVzy74Jv6NRkqq4RhXw0ynd
         qwSQ==
X-Gm-Message-State: AOAM533z6twrTXsVt8FsfWRc7d8cRk5qAnfQFzVsdphHk336/ARW4+/m
        UMFS7DzQNp9n9sqm/P4Ql72bWFanrGk544X1/e1mJ0RmMrWSUOWzo6TUQlCssf7h8nUtnuyC6DM
        ISruFtuZRra6XV/SO
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr1119008wru.110.1603977361679;
        Thu, 29 Oct 2020 06:16:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLyOTtBflIRAtSHTw049p4CwhBZ4wv+1QG8wuAgURjOU43jVnWhEmmjPA63xJbrw09Hfa78A==
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr1118983wru.110.1603977361464;
        Thu, 29 Oct 2020 06:16:01 -0700 (PDT)
Received: from localhost ([151.66.29.159])
        by smtp.gmail.com with ESMTPSA id f7sm5402588wrx.64.2020.10.29.06.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:16:00 -0700 (PDT)
Date:   Thu, 29 Oct 2020 14:15:57 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next 4/4] net: mlx5: add xdp tx return bulking support
Message-ID: <20201029131557.GD15697@lore-desk>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <3fb334388ac7af755e1f03abb76a0a6335a90ff6.1603824486.git.lorenzo@kernel.org>
 <pj41zl5z6tl0ln.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
In-Reply-To: <pj41zl5z6tl0ln.fsf@u68c7b5b1d2d758.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > Convert mlx5 driver to xdp_return_frame_bulk APIs.
> >=20
> > XDP_REDIRECT (upstream codepath): 8.5Mpps
> > XDP_REDIRECT (upstream codepath + bulking APIs): 10.1Mpps
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > index ae90d533a350..5fdfbf390d5c 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > @@ -369,8 +369,10 @@ static void mlx5e_free_xdpsq_desc(struct
> > mlx5e_xdpsq *sq,
> >  				  bool recycle)
> >  {
> >  	struct mlx5e_xdp_info_fifo *xdpi_fifo =3D &sq->db.xdpi_fifo;
> > +	struct xdp_frame_bulk bq;
> >  	u16 i;
> > +	bq.xa =3D NULL;
> >  	for (i =3D 0; i < wi->num_pkts; i++) {
> >  		struct mlx5e_xdp_info xdpi =3D  mlx5e_xdpi_fifo_pop(xdpi_fifo);
> >   @@ -379,7 +381,7 @@ static void mlx5e_free_xdpsq_desc(struct
> > mlx5e_xdpsq *sq,
> >  			/* XDP_TX from the XSK RQ and XDP_REDIRECT  */
> >  			dma_unmap_single(sq->pdev,  xdpi.frame.dma_addr,
> >  					 xdpi.frame.xdpf->len,  DMA_TO_DEVICE);
> > -			xdp_return_frame(xdpi.frame.xdpf);
> > +			xdp_return_frame_bulk(xdpi.frame.xdpf, &bq);
> >  			break;
> >  		case MLX5E_XDP_XMIT_MODE_PAGE:
> >  			/* XDP_TX from the regular RQ */
> > @@ -393,6 +395,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq
> > *sq,
> >  			WARN_ON_ONCE(true);
> >  		}
> >  	}
> > +	xdp_flush_frame_bulk(&bq);
>=20
> While I understand the rational behind this patchset, using an intermedia=
te
> buffer
> 	void *q[XDP_BULK_QUEUE_SIZE];
> means more pressure on the data cache.
>=20
> At the time I ran performance tests on mlx5 to see whether batching skbs
> before passing them to GRO would improve performance. On some flows I got
> worse performance.
> This function seems to have less Dcache contention than RX flow, but maybe
> some performance testing are needed here.

Hi Shay,

this codepath is only activated for "redirected" frames (not for packets
forwarded to networking stack). We run performance comparisons with the
upstream code for this particular use-case and we reported a nice
improvements (8.5Mpps vs 10.1Mpps).
Do you have in mind other possible performance tests to run?

Regards,
Lorenzo

>=20
> >  }
> >  bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
>=20

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX5rAiwAKCRA6cBh0uS2t
rKpnAQDF5IDwaXJAWrR9t1aSM2K8nTSG08HxjOPov0dGtP22YQD/Zz/zJX4c1r1s
1PGjPLVPMiWUTc6q4awwJcjxotkXlQM=
=aXPB
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--

