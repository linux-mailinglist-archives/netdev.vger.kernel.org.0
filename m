Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56538145EEA
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgAVXEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:04:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31265 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725884AbgAVXEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:04:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579734260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P+MJG+OZaVB0yjo1uw2mRwO7Fl5AZR6hRQgx7iWFyRM=;
        b=TV+1xhYuPGvdFmlfL3ERef5V2iDCAnCHelRG0w0VhGbfkBwFbZP2LYZi1AyE+Z3QDq5O+P
        i2VGraOn8ORVt0wv1drt65G+GFCGtwKpgnDiLyPr456LVht8iznN4M4rQXNjTMg16tOCyY
        LDLMSUBrSWxJyDOWNxvTwUuxvHAGsF4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-SjB-cQEUNaKmhNW8-rAHFA-1; Wed, 22 Jan 2020 18:04:19 -0500
X-MC-Unique: SjB-cQEUNaKmhNW8-rAHFA-1
Received: by mail-wr1-f69.google.com with SMTP id f10so793955wro.14
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:04:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P+MJG+OZaVB0yjo1uw2mRwO7Fl5AZR6hRQgx7iWFyRM=;
        b=EuVRoh7O0M42nMs7Ru4ULWZMsr9IvbefJr89W91Izl3u2sivVLQAUJUIvhgl3A0hCU
         3IbVilPiDoJpNc9CGl1SF9V6YUQ1RTRZX12KuH72rwfnxP8x+MkwjIV0P9vDAsy6cnOS
         nXCNcLsLmwb5LGOGmyNzjeDAvXQymiS/zllQyyzGTD51rUejj1I84uHR1vukQ3Z54Lj8
         hRf+/1jaQ0XcbTGSfF7RnImCUSFG2SVQOYXSurKv0oREduW252YIKMuqgr6bZu68AdSP
         Zr154weMETTXwXEgt3E+G56JGfHSlUxynQ4P7EK9tPcy6623OMAHmW2oX/p0ijSfmPpb
         ILHA==
X-Gm-Message-State: APjAAAXfdGz4NWtT1ibcJqdCWGJaaD3vhDpq0kOhJxWH3aGsXdha6TBR
        gd4/jxGEPeCiioeE3G0pFNcHzSt08KfLI+lf8dGnhjQ3tfefqjzm8994mbJ4cO0XApopkSFRDvv
        /mBIRnv504F2r0s8C
X-Received: by 2002:adf:f64b:: with SMTP id x11mr13475603wrp.355.1579734257078;
        Wed, 22 Jan 2020 15:04:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqyyTafVKoH0HcvD3HNJ3RWAGwn2z7XPqZTMXiFp6FtPobJWH3esDIM82sbMm8/igZZ8kHe3ig==
X-Received: by 2002:adf:f64b:: with SMTP id x11mr13475582wrp.355.1579734256808;
        Wed, 22 Jan 2020 15:04:16 -0800 (PST)
Received: from localhost.localdomain ([85.93.125.228])
        by smtp.gmail.com with ESMTPSA id p17sm432076wrx.20.2020.01.22.15.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 15:04:16 -0800 (PST)
Date:   Thu, 23 Jan 2020 00:04:15 +0100
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
Subject: Re: [PATCH] mvneta driver disallow XDP program on hardware buffer
 management
Message-ID: <20200122230415.GB3384@localhost.localdomain>
References: <581AE616-51FA-41F0-B4F1-E0CA761D68F2@voleatech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <581AE616-51FA-41F0-B4F1-E0CA761D68F2@voleatech.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Recently XDP Support was added to the mvneta driver for software buffer m=
anagement only.
> It is still possible to attach an XDP program if hardware buffer manageme=
nt is used.
> It is not doing anything at that point.
>=20
> The patch disallows attaching XDP programs to mvneta if hardware buffer m=
anagement is used.
>=20
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
>=20
> --- drivers/net/ethernet/marvell/mvneta.c            2020-01-22 08:44:05.=
611395960 +0000
> +++ drivers/net/ethernet/marvell/mvneta.c         2020-01-22 08:45:23.472=
263795 +0000
> @@ -4225,6 +4225,11 @@ static int mvneta_xdp_setup(struct net_d
>                                 return -EOPNOTSUPP;
>                 }
>=20
> +              if (pp->bm_priv) {
> +                              NL_SET_ERR_MSG_MOD(extack, "Hardware Buffe=
r Management not supported on XDP");
> +                              return -EOPNOTSUPP;
> +              }
> +

This patch is logically correct since we do not support XDP for hw buffer
devices for the moment. Could you please fix the errors reported by checkpa=
tch?

Regards,
Lorenzo

>                 need_update =3D !!pp->xdp_prog !=3D !!prog;
>                 if (running && need_update)
>                                 mvneta_stop(dev);
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

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXijU7AAKCRA6cBh0uS2t
rKtJAQCDZ5/UqfTSG2Kbh6gWrPelPJV5yGYO3cIfUFLN7A3VqQEAnvXNKxpZ8RZZ
u5QZPhEmOBv1Z02tSBUyZkWyhD/Khw4=
=ELlc
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--

