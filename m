Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D96A135F59
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgAIRaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:30:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30711 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725775AbgAIRaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578591003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WEbJMVoXKZc7Mcq0IlBQE0Aok1RVoeFXM59wAGcOfkI=;
        b=c5WGd5U6eKK7NbavhVebNztoKxLUJeRpFTpkqGhhVzAfhngIXJZssl1FtUzpJwGyewYGkW
        yyEvL13PitmYbO105SAcrBd7bpSlgayVV+uE4dZhZeSzBmF2TKHgtCk9RrFqnXIVU0qO8e
        ZUVhakVqwukuAtKjOp1icWzGUDldbp0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-UHfa0YhjPG-MVGqqkVtyIw-1; Thu, 09 Jan 2020 12:30:01 -0500
X-MC-Unique: UHfa0YhjPG-MVGqqkVtyIw-1
Received: by mail-wm1-f71.google.com with SMTP id t4so1198245wmf.2
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 09:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WEbJMVoXKZc7Mcq0IlBQE0Aok1RVoeFXM59wAGcOfkI=;
        b=VPjAOngCBwNczcb2uyKINh5oR6SbQaMEB6dEz7JMefNqc9Q0DSidw1F64GN78gFX+5
         QdtOYHtVzNTApHl5IF6kyh5+x1l5R0j5EHRLez0947uE7e8tVlkM9/+SyLUl1BK27pES
         tHN+bVkOGAzTvnp2L4gROaYbkjoaabiL1K6K9nx02a5TbIv8Oi/PnC8nH7797QY+uKbc
         cbXeGVGKcl5M3IUxyCKp1IRX022dAarbxar6pfanv8ZlJ3Y7wu6IUqm4S+kUIZM5xY1A
         jl9NpEXyjvrUkwYVngf39HzKwjyRTl/6iKBtj+pPV51v+2pLWrHxk4fyesYS8LKr0rkS
         3Eww==
X-Gm-Message-State: APjAAAXrJUJ8LWbsa4yrgvxVoXsIk5zIB9x7+6FAtb9bjz7YIRB9VT1a
        yRJ1NGrGL9CiRnehT6XHkB6+IC02c6T2Ox3Kg5ye50TCdaHO5vO1042SZNA6OmLK+guYIynu8xo
        92kxdMWEWycDgHJKp
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr6334183wma.159.1578591000129;
        Thu, 09 Jan 2020 09:30:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1BpP1PMD/hi6zn1BAihvdPSsBH2NbuRaz3Pm8k4ozDAvuoLzXW5PR6hbWraBQkPwKy790ow==
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr6334157wma.159.1578590999850;
        Thu, 09 Jan 2020 09:29:59 -0800 (PST)
Received: from localhost.localdomain (mob-176-246-50-46.net.vodafone.it. [176.246.50.46])
        by smtp.gmail.com with ESMTPSA id j2sm3585180wmk.23.2020.01.09.09.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 09:29:59 -0800 (PST)
Date:   Thu, 9 Jan 2020 18:29:56 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200109172956.GB2626@localhost.localdomain>
References: <5ed1bbf3e27f5b0105346838dfe405670183d723.1578410912.git.lorenzo@kernel.org>
 <20200108145322.GA2975@apalos.home>
 <20200109182038.3840b285@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <20200109182038.3840b285@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 8 Jan 2020 16:53:22 +0200
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
>=20
> > Hi Lorenzo,=20
> >=20
> > On Tue, Jan 07, 2020 at 04:30:32PM +0100, Lorenzo Bianconi wrote:

Hi Jesper and Ilias,

thx for the review :)

> > > Socionext driver can run on dma coherent and non-coherent devices.
> > > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data si=
nce
> > > now the driver can let page_pool API to managed needed DMA sync
> > >=20
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/ethernet/socionext/netsec.c | 45 +++++++++++++++--------=
--
> > >  1 file changed, 28 insertions(+), 17 deletions(-)
> > >=20
> > > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/et=
hernet/socionext/netsec.c
> > > index b5a9e947a4a8..00404fef17e8 100644
> > > --- a/drivers/net/ethernet/socionext/netsec.c
> > > +++ b/drivers/net/ethernet/socionext/netsec.c
>=20
> [...]
> > > @@ -734,9 +734,7 @@ static void *netsec_alloc_rx_data(struct netsec_p=
riv *priv,
> > >  	/* Make sure the incoming payload fits in the page for XDP and non-=
XDP
> > >  	 * cases and reserve enough space for headroom + skb_shared_info
> > >  	 */
> > > -	*desc_len =3D PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> > > -	dma_dir =3D page_pool_get_dma_dir(dring->page_pool);
> > > -	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_d=
ir);
> > > +	*desc_len =3D NETSEC_RX_BUF_SIZE;
> > > =20
> > >  	return page_address(page);
> > >  }
> > > @@ -883,6 +881,7 @@ static u32 netsec_xdp_xmit_back(struct netsec_pri=
v *priv, struct xdp_buff *xdp)
> > >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog =
*prog,
> > >  			  struct xdp_buff *xdp)
> > >  {
> > > +	struct netsec_desc_ring *dring =3D &priv->desc_ring[NETSEC_RING_RX];
> > >  	u32 ret =3D NETSEC_XDP_PASS;
> > >  	int err;
> > >  	u32 act;
> > > @@ -896,7 +895,10 @@ static u32 netsec_run_xdp(struct netsec_priv *pr=
iv, struct bpf_prog *prog,
> > >  	case XDP_TX:
> > >  		ret =3D netsec_xdp_xmit_back(priv, xdp);
> > >  		if (ret !=3D NETSEC_XDP_TX)
> > > -			xdp_return_buff(xdp);
> > > +			__page_pool_put_page(dring->page_pool,
> > > +				     virt_to_head_page(xdp->data),
> > > +				     xdp->data_end - xdp->data_hard_start, =20
> >=20
> > Do we have to include data_hard_start?
>=20
> That does look wrong.

ack, will fix it in v2

>=20
> > @Jesper i know bpf programs can modify the packet, but isn't it safe
> > to only sync for xdp->data_end - xdp->data in this case since the DMA t=
ransfer
> > in this driver will always start *after* the XDP headroom?
>=20
> I agree.
>=20
> For performance it is actually important that we avoid "cache-flushing"
> (which what happens on these non-coherent devices) the headroom.  As the
> headroom is used for e.g. storing xdp_frame.

IIRC on mvneta there is the same issue. I will post a patch to fix it.

Regards,
Lorenzo

>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXhdjEQAKCRA6cBh0uS2t
rCYZAQC+TAWtNtfCNZ4T8PLdwXizYHYlNuvdm1YA3owSRkibNAEAymRjKZe4mH64
SnsQcEQ5LwcdZgQwfqBtxZLwjwwjGAs=
=ChR5
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--

