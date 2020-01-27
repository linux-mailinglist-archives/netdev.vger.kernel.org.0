Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2671214A0F5
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgA0Jhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:37:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48759 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727295AbgA0Jhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580117855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lyFJ3hhIHj41593IzLKePRY18TuVs0/LB1C1Q0ufU2g=;
        b=JWUBZkuAcaZ4gCZBPRohNF202Weuadx0VhnabmiGNfyl+pqsqkywr2Scf1/+lh6gfCCVCX
        UsX/sBvkzWfGQf0XTmVhMqNa8aOYnmD8wlj4Ugss379c+TM2OHPZUZsIGa8Yswh4G2Pube
        3pvyBmvqvkschnHJJ6XRa3PR4KkCGoI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-z6doUb3DNpSHg8lyOWfPVg-1; Mon, 27 Jan 2020 04:37:20 -0500
X-MC-Unique: z6doUb3DNpSHg8lyOWfPVg-1
Received: by mail-wm1-f70.google.com with SMTP id t17so1142726wmi.7
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:37:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lyFJ3hhIHj41593IzLKePRY18TuVs0/LB1C1Q0ufU2g=;
        b=pP//To/PPYi3b+YJQ2ReqiB9PnBfD/BWqIWguMRnIrcTOY9l+bt5HnoVuJ2ljkKNsa
         suazyCNBrkQtkOXi3pmtoyDTlER3pl8OMENLPUcgtcWxqTra8EfBsVfmTxaah4+9Q7On
         UGjnQE7x36x2vEeoePut+xwSm/revHR/HySrQdw7TzSsmu0kyJcKPLh2anYC1ULQrnsd
         71Ht05rmftVO3XYhiT4ystuFl8/hXqsQglegln5k3mz9KCyjvsEaOlTKO1vsvEmj6le3
         3nItL0AtcUnLdObhNBU/GOVLBa2C1Z9nekugsIjtnbboOusCQMvpsQi3F55Ub1mq6tLc
         Ihig==
X-Gm-Message-State: APjAAAUttP5n4X/TlHhsmi7nrcGEkPcRcCVRlRy9arZkZpm1T6KraAfS
        WXEi4MlvXLBVQE6jkgffJEJrf8qI+pe7jekH60jjoMs4jXTAZjG3lYP0U6v7ldQpxp2c/dhxViE
        Stplboh509e1Lhqqo
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr13597177wmc.168.1580117839474;
        Mon, 27 Jan 2020 01:37:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqzChKjUyKZ//68S3N3xvWRfbK4MTZi4+Iix1mbQZ8t35Nd48brfEBs/ZTqYLuqwcyNX77Nz/A==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr13597143wmc.168.1580117839121;
        Mon, 27 Jan 2020 01:37:19 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id f1sm17622263wmc.45.2020.01.27.01.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 01:37:18 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:37:15 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Sven Auhagen <sven.auhagen@voleatech.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] mvneta driver XDP fixes armhf
Message-ID: <20200127093715.GA2543@localhost.localdomain>
References: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
 <20200122225740.GA3384@localhost.localdomain>
 <20200124120344.y3avbjdiu6gtmhbr@SvensMacbookPro.hq.voleatech.com>
 <20200125111158.nge3qahnocq2obot@SvensMacBookAir.sven.lan>
 <20200125163016.GA13217@localhost.localdomain>
 <20200127090454.dmstvqgqltgdyzog@SvensMacbookPro.hq.voleatech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20200127090454.dmstvqgqltgdyzog@SvensMacbookPro.hq.voleatech.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, Jan 25, 2020 at 05:30:16PM +0100, Lorenzo Bianconi wrote:
> > > On Fri, Jan 24, 2020 at 12:03:46PM +0000, Sven Auhagen wrote:
> > > > On Wed, Jan 22, 2020 at 11:57:40PM +0100, lorenzo.bianconi@redhat.c=
om wrote:
> > > > > Hi Sven,
> > > > >
> >=20
> > [...]
> >=20
> > >=20

[...]

> >=20
> > Hi Sven,
> >=20
> > IIUC how the hw works, I guess we can reduce MVNETA_SKB_HEADROOM and le=
t the hw put the MH
> > header to align the IP header. Could you please try the following patch?
> >=20
> > Regards,
> > Lorenzo
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 67ad8b8b127d..c032cffa6ae8 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -324,8 +324,7 @@
> >  	      ETH_HLEN + ETH_FCS_LEN,			     \
> >  	      cache_line_size())
> > =20
> > -#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
> > -				 NET_IP_ALIGN)
> > +#define MVNETA_SKB_HEADROOM	max(XDP_PACKET_HEADROOM, NET_SKB_PAD)
> >  #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) =
+ \
> >  			 MVNETA_SKB_HEADROOM))
> >  #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
> > @@ -1167,6 +1166,7 @@ static void mvneta_bm_update_mtu(struct mvneta_po=
rt *pp, int mtu)
> >  	mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_short, 1 << pp->id);
> > =20
> >  	pp->bm_priv =3D NULL;
> > +	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> >  	mvreg_write(pp, MVNETA_ACC_MODE, MVNETA_ACC_MODE_EXT1);
> >  	netdev_info(pp->dev, "fail to update MTU, fall back to software BM\n"=
);
> >  }
> > @@ -4942,7 +4942,6 @@ static int mvneta_probe(struct platform_device *p=
dev)
> >  	SET_NETDEV_DEV(dev, &pdev->dev);
> > =20
> >  	pp->id =3D global_port_id++;
> > -	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> > =20
> >  	/* Obtain access to BM resources if enabled and already initialized */
> >  	bm_node =3D of_parse_phandle(dn, "buffer-manager", 0);
> > @@ -4967,6 +4966,10 @@ static int mvneta_probe(struct platform_device *=
pdev)
> >  	}
> >  	of_node_put(bm_node);
> > =20
> > +	/* sw buffer management */
> > +	if (!pp->bm_priv)
> > +		pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> > +
> >  	err =3D mvneta_init(&pdev->dev, pp);
> >  	if (err < 0)
> >  		goto err_netdev;
> > @@ -5124,6 +5127,7 @@ static int mvneta_resume(struct device *device)
> >  		err =3D mvneta_bm_port_init(pdev, pp);
> >  		if (err < 0) {
> >  			dev_info(&pdev->dev, "use SW buffer management\n");
> > +			pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
> >  			pp->bm_priv =3D NULL;
> >  		}
> >  	}
>=20
> This patch works on my armada 388 board, thanks.

cool, thx for testing it. Is XDP support working on your board
following back in sw bm?

> Are you going to send in the patch?

I will test it on my espressobin and then I will post it.
@Andrew: applying this patch, is WRT1900ac working in your configuration?

Regards,
Lorenzo

>=20
> Best
> Sven
>=20
> >=20
> > >=20
> > > Best
> > > Sven
> > >=20
> > > >
> > > > >
> > > > > >
> > > > > > Attached is a patch that fixes the problem on my armhf platform=
, as said I am not sure if this is a universal fix or armhf only.
> > > > > >
> > > > > > Any feedback is appreciated.
> > > > > >
> > > > > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > > > >
> > > > > > --- a/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:44:05.=
611395960 +0000
> > > > > > +++ b/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:59:27.=
053739433 +0000
> > > > > > @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port
> > > > > >  prefetch(data);
> > > > > >
> > > > > >  xdp->data_hard_start =3D data;
> > > > > > -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> > > > > > +xdp->data =3D data + pp->rx_offset_correction;
> > > > >
> > > > > This will break XDP support for 'real' sw buffer devices like Esp=
ressobin.
> > > >
> > > > The current code seems to break real hw buffer devices using sw buf=
fer on armhf though.
> > > >
> > > > Best
> > > > Sven
> > > >
> > > > >
> > > > > Regards,
> > > > > Lorenzo
> > > > >
> > > > > >  xdp->data_end =3D xdp->data + data_len;
> > > > > >  xdp_set_data_meta_invalid(xdp);
> > > > > >
> > > > > > @@ -4960,7 +4960,8 @@ static int mvneta_probe(struct platform_
> > > > > >   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
> > > > > >   * platforms and 0B for 32-bit ones.
> > > > > >   */
> > > > > > -pp->rx_offset_correction =3D max(0,
> > > > > > +if (pp->bm_priv)
> > > > > > +pp->rx_offset_correction =3D max(0,
> > > > > >         NET_SKB_PAD -
> > > > > >         MVNETA_RX_PKT_OFFSET_CORRECTION);
> > > > > >  }
> > > > > >
> > > > > >
> > > > > >
> > > > > >
> > > > > > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle =
5, Stand 521 +++
> > > > > >
> > > > > > Beste Gr=FC=DFe/Best regards
> > > > > >
> > > > > > Sven Auhagen
> > > > > > Dipl. Math. oec., M.Sc.
> > > > > > Voleatech GmbH
> > > > > > HRB: B 754643
> > > > > > USTID: DE303643180
> > > > > > Grathwohlstr. 5
> > > > > > 72762 Reutlingen
> > > > > > Tel: +49 7121539550
> > > > > > Fax: +49 7121539551
> > > > > > E-Mail: sven.auhagen@voleatech.de
> > > > > > https://eur03.safelinks.protection.outlook.com/?url=3Dwww.volea=
tech.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C16ecc6de7670473d=
7de108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C6371546437557=
59442&amp;sdata=3DPlhiaiQCqIc9Pmkux%2B8xLf%2FiwP3Nn3UsMRozhbX%2FR%2B0%3D&am=
p;reserved=3D0<https://eur03.safelinks.protection.outlook.com/?url=3Dhttps%=
3A%2F%2Fwww.voleatech.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7=
C16ecc6de7670473d7de108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C=
0%7C637154643755759442&amp;sdata=3DsSpe8NSqXN8dJOp%2Fb%2FaaHcEPTdtT4jE59ek9=
7VvTtlY%3D&amp;reserved=3D0>
> > > > > > Diese Information ist ausschlie=DFlich f=FCr den Adressaten bes=
timmt und kann vertraulich oder gesetzlich gesch=FCtzte Informationen entha=
lten. Wenn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten =
Sie bitte den Absender und vernichten Sie diese Mail. Anderen als dem besti=
mmungsgem=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu sp=
eichern, weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu ve=
rwenden. F=FCr den Adressaten sind die Informationen in dieser Mail nur zum=
 pers=F6nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mi=
t dem Absender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr=
 Sch=E4den, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Vir=
en befallene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
> > > >
> > > >
> > > >
> > >=20
> > > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, Sta=
nd 521 +++
> > >=20
> > > Beste Gr=FC=DFe/Best regards
> > >=20
> > > Sven Auhagen
> > > Dipl. Math. oec., M.Sc.
> > > Voleatech GmbH
> > > HRB: B 754643
> > > USTID: DE303643180
> > > Grathwohlstr. 5
> > > 72762 Reutlingen
> > > Tel: +49 7121539550
> > > Fax: +49 7121539551
> > > E-Mail: sven.auhagen@voleatech.de
> > > www.voleatech.de<https://www.voleatech.de>
> > > Diese Information ist ausschlie=DFlich f=FCr den Adressaten bestimmt =
und kann vertraulich oder gesetzlich gesch=FCtzte Informationen enthalten. =
Wenn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten Sie bi=
tte den Absender und vernichten Sie diese Mail. Anderen als dem bestimmungs=
gem=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu speicher=
n, weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu verwende=
n. F=FCr den Adressaten sind die Informationen in dieser Mail nur zum pers=
=F6nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mit dem=
 Absender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr Sch=
=E4den, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Viren b=
efallene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
> > >=20
>=20
>=20

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXi6vSQAKCRA6cBh0uS2t
rN8oAP0dGU0AImBtaAspKahKN2aChY9SVB41HmsNTNKr7PU0jwEAgz42UXmesixB
Cfp2nG768XcuWJ1Wt/GZYqft+Cx83Qs=
=hYZz
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

