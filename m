Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5769149407
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 09:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgAYIsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 03:48:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25921 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbgAYIsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 03:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579942100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wp+JAl4vdkY5ZXedyqivW3ZncESlNKOB3ht1JdrmUlI=;
        b=ff1kWZbKDk9HRJpY7AvTC8gMMBC7VyGs1QbQgZ4Ic8mawKEwjYKr7PR9/BmgRDrGDtLB/x
        gM4pOKzYhJ0mT+Lcj41VCzIKmbG+hRovAUHcz27dAO7kad6HWiGbFzLcvQUAYeKX6ZPQSG
        /ohy4V6S9rjO28DgqzJbwaXKir9EGCM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-OCEQqeGlPE6E4GW0KLQwrg-1; Sat, 25 Jan 2020 03:48:18 -0500
X-MC-Unique: OCEQqeGlPE6E4GW0KLQwrg-1
Received: by mail-wr1-f72.google.com with SMTP id f17so2712469wrt.19
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 00:48:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wp+JAl4vdkY5ZXedyqivW3ZncESlNKOB3ht1JdrmUlI=;
        b=ULbPGzuCXnQwHPUTKusMPihxPUDrqshwnj8d4cPLVfBOJpTjvD29aX0mmWveI0Gvk0
         dXIPNHJEygILR4X5teg+baZexLZObHkgf/gGiWbRSRa05amR6amjUg7Ty2R/qCDUTcfQ
         zDf98ko77JZYJovuwPJIUMUerpPmrBGdPJ4obHcut2NPIL61+7QFjyN/rTPgqliJHpLU
         ZSTcnt9Ow02cUuItOSsIgaSCBjpdYz/eB+jhyrMykL+JhH8tOkjz1M6O+zMJoKV5Ldtk
         f2f8QO2GMgePF5CeDaxX2Lvo/paRmviD5tZ0wumztJ93HDMjq0zz+pfGch0CHMJeU92s
         ba9w==
X-Gm-Message-State: APjAAAWM9bpmNKNS9Ye5Q96LEutkAIORC02Rt31ceXR6hm5UY9l9k9ja
        12gQy74a0sBzniQ6tKSJT2Zj+QRmD4QSBhv3yBJcJDSWCTRzPnr9PljQh5t9X4F6x0V0RxVbXuJ
        yRkGbD2avtNDHizVs
X-Received: by 2002:a5d:6305:: with SMTP id i5mr9392887wru.399.1579942096517;
        Sat, 25 Jan 2020 00:48:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNLk3u5X2+XXOPEQUHfiWped9uudBiMrrRglDf+8wcxTWALoG0XBCBu4j7/ztGs0Bgs2mFjQ==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr9392863wru.399.1579942096232;
        Sat, 25 Jan 2020 00:48:16 -0800 (PST)
Received: from p977.fit.wifi.vutbr.cz ([147.229.117.36])
        by smtp.gmail.com with ESMTPSA id 60sm11336679wrn.86.2020.01.25.00.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 00:48:15 -0800 (PST)
Date:   Sat, 25 Jan 2020 09:48:12 +0100
From:   "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v5] mvneta driver disallow XDP program on hardware buffer
 management
Message-ID: <20200125084812.GA3398@p977.fit.wifi.vutbr.cz>
References: <20200125080702.81712-1-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20200125080702.81712-1-sven.auhagen@voleatech.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Recently XDP Support was added to the mvneta driver
> for software buffer management only.
> It is still possible to attach an XDP program if
> hardware buffer management is used.
> It is not doing anything at that point.
>=20

[...]

> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -4225,6 +4225,12 @@ static int mvneta_xdp_setup(struct net_device *dev=
, struct bpf_prog *prog,
>  return -EOPNOTSUPP;
>  }
>=20
> +if (pp->bm_priv) {
> +NL_SET_ERR_MSG_MOD(extack,
> +   "Hardware Buffer Management not supported on XDP");
> +return -EOPNOTSUPP;
> +}

Could you please fix the following checkpatch warnings?

$ <kernel_dir>/scripts/checkpatch.pl --strict file.patch

WARNING: suspect code indent for conditional statements (0, 0)
#53: FILE: drivers/net/ethernet/marvell/mvneta.c:4228:
+if (pp->bm_priv) {
+NL_SET_ERR_MSG_MOD(extack,

CHECK: Alignment should match open parenthesis
#55: FILE: drivers/net/ethernet/marvell/mvneta.c:4230:
+NL_SET_ERR_MSG_MOD(extack,
+   "Hardware Buffer Management not supported on XDP");

WARNING: please, no spaces at the start of a line
#55: FILE: drivers/net/ethernet/marvell/mvneta.c:4230:
+   "Hardware Buffer Management not supported on XDP");$

total: 0 errors, 2 warnings, 12 lines checked

Regards,
Lorenzo

> +
>  need_update =3D !!pp->xdp_prog !=3D !!prog;
>  if (running && need_update)
>  mvneta_stop(dev);
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

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXiwAyQAKCRA6cBh0uS2t
rO/EAP0c9sIWfsoZoMRmgt5DI/y10xIkj+mmbk9qujy91FaAwAD+Iclar9FzXggA
PrztQKNaFT94PiDoOukcva9tPiF/XwE=
=8xqd
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--

