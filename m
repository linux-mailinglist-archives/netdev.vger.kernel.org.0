Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45EE2DC293
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLPO6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:58:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgLPO6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:58:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608130618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o5k/sKzd3D17kAP46KXWKeDWWsM6hWmeSNLDHl/YUOI=;
        b=Zef7jRJw8Ts4KbJyu1PEH93ecCnFW2Codj5iwxI/QY1fKI/gRcdvdY+z8nzeYbDrDQ8jZ2
        WlgLcBy43VeX5oLKMnbOLLJHx/4czKK0Dfr4JTO+owFqLWiY2hfxYmaXexVRqVENKZ1j4Z
        P0U8u8mjvBEkAiA8WP0Dp9LKiwBw1hY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-YOLqOI-cM2yJZmZmlDY6JA-1; Wed, 16 Dec 2020 09:56:55 -0500
X-MC-Unique: YOLqOI-cM2yJZmZmlDY6JA-1
Received: by mail-ed1-f71.google.com with SMTP id h5so11892041edq.3
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 06:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o5k/sKzd3D17kAP46KXWKeDWWsM6hWmeSNLDHl/YUOI=;
        b=PWeFrtuC74UsnyN3tltH9jbNeGqwJeUqm+Ef2pIp2eHAO1tO2lMno9mHC+LgRoLdZ/
         A9tuyEXggwPapTB/75P7UyLwoIW0l5MYA6JVDMby1KVsOpBT19F5CVOjn1xPSqaeoKaC
         HUv8JNx8UcE4K3ky5QGqJd5617gvE6z2gAiTQNzbSmWxvUuP2ggkXXvbeT79R8YKjpJW
         5qVRqxS55D6y4iNeGB9/WfJqTfFRxW4VmWYbDEpwU/gph/11KnVdr3Pcc6gIXnQyBqUn
         12hZJa0hIRjgy4y6PgdX7GRIbswqKgSKfysQlD2APNMBux4c00YFpRlXFqCF4NyBCk58
         meBA==
X-Gm-Message-State: AOAM533X18ZKnySD03LiGnhj48t8rwHsJwuN28VqArdoUHjA7vA+ZnK4
        7RboSaA/smdZ7Mx/0FJIsY8aLJcwCZMC8zMlfS7LKEtmM7KFQQKMlq3ooGVZCYfMFjkzBBA121r
        sitzvlSTn7chd1LY0
X-Received: by 2002:a50:ac86:: with SMTP id x6mr33931425edc.197.1608130614020;
        Wed, 16 Dec 2020 06:56:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO13r9W/W3cUQw9bukEEjm2mRue39Hb5aemp59V48HVDADmBV4zfp6XAoR0UEZokrCaaDxBA==
X-Received: by 2002:a50:ac86:: with SMTP id x6mr33931409edc.197.1608130613805;
        Wed, 16 Dec 2020 06:56:53 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id l14sm21242976edq.35.2020.12.16.06.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 06:56:53 -0800 (PST)
Date:   Wed, 16 Dec 2020 15:56:50 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Subject: Re: [PATCH v3 bpf-next 1/2] net: xdp: introduce xdp_init_buff
 utility routine
Message-ID: <20201216145650.GC2036@lore-desk>
References: <cover.1607794551.git.lorenzo@kernel.org>
 <1125364c807a24e03cfdc1901913181fe1457d42.1607794552.git.lorenzo@kernel.org>
 <20201216093543.73836860@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <20201216093543.73836860@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 12 Dec 2020 18:41:48 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/ne=
t/ethernet/broadcom/bnxt/bnxt_xdp.c
> > index fcc262064766..b7942c3440c0 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > @@ -133,12 +133,11 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_=
ring_info *rxr, u16 cons,
> >  	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_di=
r);
> > =20
> >  	txr =3D rxr->bnapi->tx_ring;
> > +	xdp_init_buff(&xdp, PAGE_SIZE, &rxr->xdp_rxq);
> >  	xdp.data_hard_start =3D *data_ptr - offset;
> >  	xdp.data =3D *data_ptr;
> >  	xdp_set_data_meta_invalid(&xdp);
> >  	xdp.data_end =3D *data_ptr + *len;
> > -	xdp.rxq =3D &rxr->xdp_rxq;
> > -	xdp.frame_sz =3D PAGE_SIZE; /* BNXT_RX_PAGE_MODE(bp) when XDP enabled=
 */
> >  	orig_data =3D xdp.data;
>=20
> I don't like loosing the comment here.  Other developers reading this
> code might assume that size is always PAGE_SIZE, which is only the case
> when XDP is enabled.  Lets save them from making this mistake.

ack, I will add it back in v4.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX9ogLgAKCRA6cBh0uS2t
rIa1AP9+d9A92U1CR2bGh+AjPjTWCRccTiynTiPqw2A89MiidgD/dVDPX6nPivbS
E4wNHIijgcygrh3g+vyOZQVATikVzQQ=
=Ogy7
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--

