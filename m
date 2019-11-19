Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC0A102420
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKSMTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:19:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbfKSMTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 07:19:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574165957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=syIFrCweVPKotrafFRVGpIIVfr/0LKsKBr33xTyiMl8=;
        b=h9Vft88UvdB/JRz/fSrsasv8i39VViMwiJeltyZKa1nSGs1ru+XJdbKVRe9nwbesasGiAK
        rsE/ZvGqZyTFgrk5NsFP5dZYcKCxJm1aa6c4JUTvp7v31f/14vg4n9k2sSE6cIhasT48tK
        OIkDxFrfEvO1DS/VEvouO/OPMvNs+NY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-ut16LL7mM7KwPODmYVDFGw-1; Tue, 19 Nov 2019 07:19:16 -0500
X-MC-Unique: ut16LL7mM7KwPODmYVDFGw-1
Received: by mail-wr1-f69.google.com with SMTP id p4so18090175wrw.15
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 04:19:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YGB2v/RpibQ6nPoYxIiN6Ia7qpx7EJh7xTUzNT3GhK4=;
        b=EeGor0NOcNLoRTyVYRHKWiQeqvyVa9z7M3+XD/zNKy4wa9HnW3NdNQGNx++ahtM/BG
         nAbV9SP9wR7XBjlEn8iju7VaCgG9rFp9GvKZs18lfE+yrcqcKEmR8QRjxkwDLW4nkl4p
         SO+Emvo18mw6lHBGCcY4qUnVLf8sdjLiEkbdLegwiPCHsiGiGW4PFT9NAgHFB9OHGA8/
         vSp7BTDTnhbIm6ACZh5QC5tVVV4nbFA0fTib12T5RlYcaWIpH00XEwjj0Bq2I23tWypF
         KlIL3n/rwke2gKWNH3dbW4dX15djucFoiIGedJ1F3cmTQcCrS9jdPbN3I14XMUJw7Q/U
         qymw==
X-Gm-Message-State: APjAAAULf+SAcAM29oqh4OB2mVMaO0Y3bX4YpFTknjLaVfn7DHyHxnVE
        9vF87Lgv344HRTGfGM96eLxz/IOMGZqWDGztBDt9kZJr/YGfdzoy4NeAaP/515UO2sg8FlzBB3u
        ptbfhh8DNWaUwbJzj
X-Received: by 2002:adf:94a6:: with SMTP id 35mr35685274wrr.108.1574165955412;
        Tue, 19 Nov 2019 04:19:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/dHIezMQ/SNY2cTlQITaFZIbchY1xlp3In7qrT5VFSDm6A5lemYnr/fvM/Wtzjz+dHckNqA==
X-Received: by 2002:adf:94a6:: with SMTP id 35mr35685242wrr.108.1574165955168;
        Tue, 19 Nov 2019 04:19:15 -0800 (PST)
Received: from localhost.localdomain ([77.139.212.74])
        by smtp.gmail.com with ESMTPSA id l13sm2835802wmh.12.2019.11.19.04.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 04:19:14 -0800 (PST)
Date:   Tue, 19 Nov 2019 14:19:11 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v4 net-next 3/3] net: mvneta: get rid of huge dma sync in
 mvneta_rx_refill
Message-ID: <20191119121911.GC3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <7bd772e5376af0c55e7319b7974439d4981aa167.1574083275.git.lorenzo@kernel.org>
 <20191119123850.5cd60c0e@carbon>
MIME-Version: 1.0
In-Reply-To: <20191119123850.5cd60c0e@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 18 Nov 2019 15:33:46 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index f7713c2c68e1..a06d109c9e80 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> [...]
> > @@ -2097,8 +2093,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mv=
neta_rx_queue *rxq,
> >  =09=09err =3D xdp_do_redirect(pp->dev, xdp, prog);
> >  =09=09if (err) {
> >  =09=09=09ret =3D MVNETA_XDP_DROPPED;
> > -=09=09=09page_pool_recycle_direct(rxq->page_pool,
> > -=09=09=09=09=09=09 virt_to_head_page(xdp->data));
> > +=09=09=09__page_pool_put_page(rxq->page_pool,
> > +=09=09=09=09=09virt_to_head_page(xdp->data),
> > +=09=09=09=09=09xdp->data_end - xdp->data_hard_start,
> > +=09=09=09=09=09true);
> >  =09=09} else {
> >  =09=09=09ret =3D MVNETA_XDP_REDIR;
> >  =09=09}
> > @@ -2107,8 +2105,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mv=
neta_rx_queue *rxq,
> >  =09case XDP_TX:
> >  =09=09ret =3D mvneta_xdp_xmit_back(pp, xdp);
> >  =09=09if (ret !=3D MVNETA_XDP_TX)
> > -=09=09=09page_pool_recycle_direct(rxq->page_pool,
> > -=09=09=09=09=09=09 virt_to_head_page(xdp->data));
> > +=09=09=09__page_pool_put_page(rxq->page_pool,
> > +=09=09=09=09=09virt_to_head_page(xdp->data),
> > +=09=09=09=09=09xdp->data_end - xdp->data_hard_start,
> > +=09=09=09=09=09true);
> >  =09=09break;
> >  =09default:
> >  =09=09bpf_warn_invalid_xdp_action(act);
> > @@ -2117,8 +2117,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mv=
neta_rx_queue *rxq,
> >  =09=09trace_xdp_exception(pp->dev, prog, act);
> >  =09=09/* fall through */
> >  =09case XDP_DROP:
> > -=09=09page_pool_recycle_direct(rxq->page_pool,
> > -=09=09=09=09=09 virt_to_head_page(xdp->data));
> > +=09=09__page_pool_put_page(rxq->page_pool,
> > +=09=09=09=09     virt_to_head_page(xdp->data),
> > +=09=09=09=09     xdp->data_end - xdp->data_hard_start,
> > +=09=09=09=09     true);
>=20
> This does beg for the question: Should we create an API wrapper for
> this in the header file?
>=20
> But what to name it?
>=20
> I know Jonathan doesn't like the "direct" part of the  previous function
> name page_pool_recycle_direct.  (I do considered calling this 'napi'
> instead, as it would be inline with networking use-cases, but it seemed
> limited if other subsystem end-up using this).
>=20
> Does is 'page_pool_put_page_len' sound better?
>=20
> But I want also want hide the bool 'allow_direct' in the API name.
> (As it makes it easier to identify users that uses this from softirq)
>=20
> Going for 'page_pool_put_page_len_napi' starts to be come rather long.

What about removing the second 'page'? Something like:
- page_pool_put_len_napi()

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXdPdvAAKCRA6cBh0uS2t
rMv8AQC2402qgPIBXHW7sck0xwTfy1EXHE38UyO5R3rzRL9yDQD+Owzh71pb9www
e3AkLWGbWX6HuxIz+k45n1EK+wfS6wU=
=hJZ+
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--

