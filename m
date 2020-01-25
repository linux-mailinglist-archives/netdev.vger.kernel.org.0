Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 523BA1496A0
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgAYQaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:30:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43507 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgAYQaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 11:30:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579969823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vtx46kpXWrkd0IwcDGbLX2hljO2KKPKgKL6trZL77eg=;
        b=e97Qey7L7uM55tseX7osE5AFFzz9e63CCKIZRJ+xQaxtZbRbnyKk1bTPH8BYIJLP7EzfaU
        jUgYwAWB6ZsYTwk0bbgWZf+h11Jt9iDJgxrmgcbmO0/MzLpl/wngmwJWxomVleMvzVz5w2
        DOgbalnTdB0LUG48LQGvSh1yNcji/3U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-avjbbVVUPtK2m_y1-6eEcQ-1; Sat, 25 Jan 2020 11:30:21 -0500
X-MC-Unique: avjbbVVUPtK2m_y1-6eEcQ-1
Received: by mail-wr1-f70.google.com with SMTP id u12so3181922wrt.15
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 08:30:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vtx46kpXWrkd0IwcDGbLX2hljO2KKPKgKL6trZL77eg=;
        b=rq3+uqsIvI+iUFn0TfZPUnfp0SLnXEWi3/8+v9ufraIGdqQfnF+w7KtEYBCQBNtxS5
         dJbGL6aK5i8e7sZmRL6FcPjYKNo7+bxPMQi3BKqOy0x4g8hpeMXHZqPAjJXkLepjBSuC
         Fwr1qCNKVJXxo9iboX/LrhBMyzWM5pIeqcT1zjMZIUTERRs8EGMjSu3izD0u+kdYtTSF
         YrBTqPY5d0uZ08H4f5uHM3vVZRNTENy2k72QhruV1AygomMfJfr/bwpt+g6dDjwVkbZs
         ZDtwDtHy/FPa7nNZTItcMW0SIebLmmcbjWKkZGCzow+3XXhI/SXL8ysMrQl6WEHrfLRc
         wuqQ==
X-Gm-Message-State: APjAAAUdWDJwUWiV6DyFO3sDXH69XX4p02llG1BZAwJlsD2wc8khOImS
        LYiAjRcuBtUtG9tOLx7POR/MZB069dXEgvNS9ggSTK2HG900TRHZKC44J9kJkynb1STyE0ZCN0e
        bMIMGj1VSmqQibtUL
X-Received: by 2002:a1c:a382:: with SMTP id m124mr4898876wme.90.1579969819214;
        Sat, 25 Jan 2020 08:30:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqzk5cfrS1gzm9y3RtGOrosdaSqFUGEgRFoXhLI7hswrd2FaRpyFFnTcJG22m7H3yR7VFQgTTg==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr4898858wme.90.1579969818735;
        Sat, 25 Jan 2020 08:30:18 -0800 (PST)
Received: from localhost.localdomain ([85.93.125.228])
        by smtp.gmail.com with ESMTPSA id c5sm11670878wmb.9.2020.01.25.08.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 08:30:17 -0800 (PST)
Date:   Sat, 25 Jan 2020 17:30:16 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] mvneta driver XDP fixes armhf
Message-ID: <20200125163016.GA13217@localhost.localdomain>
References: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
 <20200122225740.GA3384@localhost.localdomain>
 <20200124120344.y3avbjdiu6gtmhbr@SvensMacbookPro.hq.voleatech.com>
 <20200125111158.nge3qahnocq2obot@SvensMacBookAir.sven.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20200125111158.nge3qahnocq2obot@SvensMacBookAir.sven.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Jan 24, 2020 at 12:03:46PM +0000, Sven Auhagen wrote:
> > On Wed, Jan 22, 2020 at 11:57:40PM +0100, lorenzo.bianconi@redhat.com w=
rote:
> > > Hi Sven,
> > >

[...]

>=20
> I think I found the problem. I found the documentation finally and it sta=
tes:
>=20
> The physical buffer pointer must be 64-bit aligned; therefore, bits[2:0] =
of the pointers are considered as zeros.
>=20
> rx_offset is defined as MVNETA_SKB_HEADROOM which in turn is:
>=20
> #define MVNETA_SKB_HEADROOM(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
>  NET_IP_ALIGN)
>=20
> this leads to an offset on armhf of 258 which is not 64 bit aligned and t=
herefore
> shortened to 256 hence the MH header is actually at 256.
>=20
> This would explain my problem.
>=20
> Any thoughts?

Hi Sven,

IIUC how the hw works, I guess we can reduce MVNETA_SKB_HEADROOM and let th=
e hw put the MH
header to align the IP header. Could you please try the following patch?

Regards,
Lorenzo

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 67ad8b8b127d..c032cffa6ae8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -324,8 +324,7 @@
 	      ETH_HLEN + ETH_FCS_LEN,			     \
 	      cache_line_size())
=20
-#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
-				 NET_IP_ALIGN)
+#define MVNETA_SKB_HEADROOM	max(XDP_PACKET_HEADROOM, NET_SKB_PAD)
 #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
 			 MVNETA_SKB_HEADROOM))
 #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
@@ -1167,6 +1166,7 @@ static void mvneta_bm_update_mtu(struct mvneta_port *=
pp, int mtu)
 	mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_short, 1 << pp->id);
=20
 	pp->bm_priv =3D NULL;
+	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
 	mvreg_write(pp, MVNETA_ACC_MODE, MVNETA_ACC_MODE_EXT1);
 	netdev_info(pp->dev, "fail to update MTU, fall back to software BM\n");
 }
@@ -4942,7 +4942,6 @@ static int mvneta_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
=20
 	pp->id =3D global_port_id++;
-	pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
=20
 	/* Obtain access to BM resources if enabled and already initialized */
 	bm_node =3D of_parse_phandle(dn, "buffer-manager", 0);
@@ -4967,6 +4966,10 @@ static int mvneta_probe(struct platform_device *pdev)
 	}
 	of_node_put(bm_node);
=20
+	/* sw buffer management */
+	if (!pp->bm_priv)
+		pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
+
 	err =3D mvneta_init(&pdev->dev, pp);
 	if (err < 0)
 		goto err_netdev;
@@ -5124,6 +5127,7 @@ static int mvneta_resume(struct device *device)
 		err =3D mvneta_bm_port_init(pdev, pp);
 		if (err < 0) {
 			dev_info(&pdev->dev, "use SW buffer management\n");
+			pp->rx_offset_correction =3D MVNETA_SKB_HEADROOM;
 			pp->bm_priv =3D NULL;
 		}
 	}

>=20
> Best
> Sven
>=20
> >
> > >
> > > >
> > > > Attached is a patch that fixes the problem on my armhf platform, as=
 said I am not sure if this is a universal fix or armhf only.
> > > >
> > > > Any feedback is appreciated.
> > > >
> > > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > >
> > > > --- a/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:44:05.6113=
95960 +0000
> > > > +++ b/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:59:27.0537=
39433 +0000
> > > > @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port
> > > >  prefetch(data);
> > > >
> > > >  xdp->data_hard_start =3D data;
> > > > -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> > > > +xdp->data =3D data + pp->rx_offset_correction;
> > >
> > > This will break XDP support for 'real' sw buffer devices like Espress=
obin.
> >
> > The current code seems to break real hw buffer devices using sw buffer =
on armhf though.
> >
> > Best
> > Sven
> >
> > >
> > > Regards,
> > > Lorenzo
> > >
> > > >  xdp->data_end =3D xdp->data + data_len;
> > > >  xdp_set_data_meta_invalid(xdp);
> > > >
> > > > @@ -4960,7 +4960,8 @@ static int mvneta_probe(struct platform_
> > > >   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
> > > >   * platforms and 0B for 32-bit ones.
> > > >   */
> > > > -pp->rx_offset_correction =3D max(0,
> > > > +if (pp->bm_priv)
> > > > +pp->rx_offset_correction =3D max(0,
> > > >         NET_SKB_PAD -
> > > >         MVNETA_RX_PKT_OFFSET_CORRECTION);
> > > >  }
> > > >
> > > >
> > > >
> > > >
> > > > +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, S=
tand 521 +++
> > > >
> > > > Beste Gr=FC=DFe/Best regards
> > > >
> > > > Sven Auhagen
> > > > Dipl. Math. oec., M.Sc.
> > > > Voleatech GmbH
> > > > HRB: B 754643
> > > > USTID: DE303643180
> > > > Grathwohlstr. 5
> > > > 72762 Reutlingen
> > > > Tel: +49 7121539550
> > > > Fax: +49 7121539551
> > > > E-Mail: sven.auhagen@voleatech.de
> > > > https://eur03.safelinks.protection.outlook.com/?url=3Dwww.voleatech=
=2Ede&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C16ecc6de7670473d7d=
e108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637154643755759=
442&amp;sdata=3DPlhiaiQCqIc9Pmkux%2B8xLf%2FiwP3Nn3UsMRozhbX%2FR%2B0%3D&amp;=
reserved=3D0<https://eur03.safelinks.protection.outlook.com/?url=3Dhttps%3A=
%2F%2Fwww.voleatech.de&amp;data=3D02%7C01%7Csven.auhagen%40voleatech.de%7C1=
6ecc6de7670473d7de108d7a0c5cf85%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%=
7C637154643755759442&amp;sdata=3DsSpe8NSqXN8dJOp%2Fb%2FaaHcEPTdtT4jE59ek97V=
vTtlY%3D&amp;reserved=3D0>
> > > > Diese Information ist ausschlie=DFlich f=FCr den Adressaten bestimm=
t und kann vertraulich oder gesetzlich gesch=FCtzte Informationen enthalten=
=2E Wenn Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten Si=
e bitte den Absender und vernichten Sie diese Mail. Anderen als dem bestimm=
ungsgem=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu spei=
chern, weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu verw=
enden. F=FCr den Adressaten sind die Informationen in dieser Mail nur zum p=
ers=F6nlichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mit =
dem Absender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr S=
ch=E4den, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Viren=
 befallene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
> >
> >
> >
>=20
> +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, Stand 5=
21 +++
>=20
> Beste Gr=FC=DFe/Best regards
>=20
> Sven Auhagen
> Dipl. Math. oec., M.Sc.
> Voleatech GmbH
> HRB: B 754643
> USTID: DE303643180
> Grathwohlstr. 5
> 72762 Reutlingen
> Tel: +49 7121539550
> Fax: +49 7121539551
> E-Mail: sven.auhagen@voleatech.de
> www.voleatech.de<https://www.voleatech.de>
> Diese Information ist ausschlie=DFlich f=FCr den Adressaten bestimmt und =
kann vertraulich oder gesetzlich gesch=FCtzte Informationen enthalten. Wenn=
 Sie nicht der bestimmungsgem=E4=DFe Adressat sind, unterrichten Sie bitte =
den Absender und vernichten Sie diese Mail. Anderen als dem bestimmungsgem=
=E4=DFen Adressaten ist es untersagt, diese E-Mail zu lesen, zu speichern, =
weiterzuleiten oder ihren Inhalt auf welche Weise auch immer zu verwenden. =
F=FCr den Adressaten sind die Informationen in dieser Mail nur zum pers=F6n=
lichen Gebrauch. Eine Weiterleitung darf nur nach R=FCcksprache mit dem Abs=
ender erfolgen. Wir verwenden aktuelle Virenschutzprogramme. F=FCr Sch=E4de=
n, die dem Empf=E4nger gleichwohl durch von uns zugesandte mit Viren befall=
ene E-Mails entstehen, schlie=DFen wir jede Haftung aus.
>=20

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXixtDgAKCRA6cBh0uS2t
rDzbAQDwRbPgnZ9VWfJkGCxoIU6GViRpkTvFCA/9KqRJT3rW9wEA6Fow/Ny7op4A
Ju8dizGePZsd06AW5jIReqVMYI3T/AY=
=PIMy
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--

