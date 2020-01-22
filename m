Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D3C145ED7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAVW5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:57:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54208 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726004AbgAVW5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579733868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rOkckFcpFb1bcW8olGzhMYk6qGzunLJZqMKBCFHa9zQ=;
        b=Q3AcxTESgkYJZR0O1N5vW7Hn2+nFz45NTbjrNUShvoWy5ZXjW1xWM9pgkoJcmJKYHDrWMM
        xNqvKs6M/IsvqtkiGUkacPo3mrjXPB+BrfBLRqVUvQHRo4KiYbWQaWDoF4VP4fXd7DlIGn
        KJGBdYglHiCBaaRJgk0Ar28hDGFrL4A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-ZDphd9HQMnaKcO5w0ZRxgw-1; Wed, 22 Jan 2020 17:57:44 -0500
X-MC-Unique: ZDphd9HQMnaKcO5w0ZRxgw-1
Received: by mail-wm1-f72.google.com with SMTP id b133so216183wmb.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 14:57:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rOkckFcpFb1bcW8olGzhMYk6qGzunLJZqMKBCFHa9zQ=;
        b=U6gaa6IJNDYQp4J9I6u8VS/sRqUG59wISSiskHj5eSlFxse1UGNZlnKlkHbvDQIRHn
         IEMr8+pMuPXhsVSgFr7okzj2fk9Jpjb+Yr/eVRSSvQsKjx//vA/x7GvI2Q4bU0u6fy3s
         QEhc6f6O9nJwsK/3TOHpK136LW9iSR6KT0btPieplXHydiC1mCLZghrbK8/2fDHDdZeA
         vjwt2x2c4TL50p6bJdZnWqVw2mWwCmwc8/fn40gUtQItpSo//yM13/bou0LMNb4ysmuV
         2w0Wex6eLvLinbz9cdzwsaksMDYnaGVCDQrdhFu8Bn1o/VlVlQgKMvAholRMPVLsjb4U
         bj5w==
X-Gm-Message-State: APjAAAVhCY9uz4Ni4LICLWdMFY3izEyrE6+gHyqwuvx32XzH4tM8YHT+
        grW4sYZSceagtLDUwe2BFBtE64k7XkUMNYTArwyNJRhAt4hc25N+paItCl+E/mTRUKxCH4DJGhc
        QL7ONd3wuAH/BuY2P
X-Received: by 2002:a7b:c392:: with SMTP id s18mr430665wmj.169.1579733862875;
        Wed, 22 Jan 2020 14:57:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqx73Gw6ZbvB5+TKQw0ehPXCg/UsG4BZNMYHpP2g5VAPCNJfovX6S9STtV1G/qJoKI95b2ZSqA==
X-Received: by 2002:a7b:c392:: with SMTP id s18mr430654wmj.169.1579733862571;
        Wed, 22 Jan 2020 14:57:42 -0800 (PST)
Received: from localhost.localdomain ([85.93.125.228])
        by smtp.gmail.com with ESMTPSA id d23sm420230wra.30.2020.01.22.14.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 14:57:41 -0800 (PST)
Date:   Wed, 22 Jan 2020 23:57:40 +0100
From:   "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>
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
Message-ID: <20200122225740.GA3384@localhost.localdomain>
References: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sven,

> Recently XDP Support was added to the mvneta driver for software buffer m=
anagement.
> I tested XDP with my armada 388 board. It has hardware buffer management =
defined in the device tree file.
> I disabled the mvneta_bm module to test XDP.
>=20
> I found multiple problems.
>=20
> 1. With hardware buffer management enabled and mvneta_bm disabled the rx_=
offset was set to 0 with armhf (32 bit) which leads to no headroom in XDP a=
nd therefore the XDP Redirect did not work.
> 2. Removing the hardware buffer management from the device tree file comp=
letely made the mvneta driver unusable as it did not work anymore.

Do you mean removing 'buffer-manager' property from the device tree?

>=20
> After some debugging I found out that xdp->data =3D data + pp->rx_offset_=
correction + MVNETA_MH_SIZE;  has to be xdp->data =3D data + pp->rx_offset_=
correction; if pp->rx_offset_correction > 0.
> I am not sure why and I am looking for help if someone is seeing the same=
 on an arm64 board.

Are you sure the hw does not insert the mvneta header before the data? It s=
eems
to me that it is added even for hw buffer devices (according to the code).

>=20
> Attached is a patch that fixes the problem on my armhf platform, as said =
I am not sure if this is a universal fix or armhf only.
>=20
> Any feedback is appreciated.
>=20
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
>=20
> --- a/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:44:05.611395960 =
+0000
> +++ b/drivers/net/ethernet/marvell/mvneta.c2020-01-22 08:59:27.053739433 =
+0000
> @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port
>  prefetch(data);
>=20
>  xdp->data_hard_start =3D data;
> -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> +xdp->data =3D data + pp->rx_offset_correction;

This will break XDP support for 'real' sw buffer devices like Espressobin.

Regards,
Lorenzo

>  xdp->data_end =3D xdp->data + data_len;
>  xdp_set_data_meta_invalid(xdp);
>=20
> @@ -4960,7 +4960,8 @@ static int mvneta_probe(struct platform_
>   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
>   * platforms and 0B for 32-bit ones.
>   */
> -pp->rx_offset_correction =3D max(0,
> +if (pp->bm_priv)
> +pp->rx_offset_correction =3D max(0,
>         NET_SKB_PAD -
>         MVNETA_RX_PKT_OFFSET_CORRECTION);
>  }
>=20
>=20
>=20
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

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXijTYAAKCRA6cBh0uS2t
rCMFAQDR37AL08IlHMHKDiAW44mKb4ylySXMJVro6+j5msOHGgEA8yuXSR5a8sCL
SmTsXxqoG7DEUYr4Q+RnJLEZ83lodgg=
=laec
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--

