Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169043B1518
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 09:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhFWHvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 03:51:09 -0400
Received: from phobos.denx.de ([85.214.62.61]:37512 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWHvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 03:51:08 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4BDF580082;
        Wed, 23 Jun 2021 09:48:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624434529;
        bh=yT4ZmsheDrzflNLYEnptapHjyIcqPcx1/TgV4RPFfYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A/sEWLA2kbM9R0p1bJdCs8XKTue7dLtR9zbfBufZB/S8zEDH0q1VeueXWRtcsmVtn
         CAdX/6gLQ6miW5wFV//wvVAAukBSpZollU/OSYLk1M7RRKbRcoV0edB40fXWLFByE1
         S5S7pMMOHbAaD0ux9RAXWWvwHmyFF4qvRHihhiwJZ1Lr1OgbXL18pArTXF2EE5wkKt
         OO7KwWYPXrYKwl6txBgdVJghEw9Y7tg3aDKKh3xDWKY1hEZ7iZYlO58xLcsOTNDLdA
         D2Ox1EnNk2vQp+1rPKq8WLZi7b5cAylERufHvTU6rp4NNMFIkQGtEAzcAgga0jLbdu
         JHVlpkZdrawoA==
Date:   Wed, 23 Jun 2021 09:48:41 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/3] net: imx: Adjust fec_main.c to provide support for L2
 switch
Message-ID: <20210623094841.4ea531bc@ktm>
In-Reply-To: <YNH9YvjqbcHMaUFw@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-4-lukma@denx.de>
        <YNH9YvjqbcHMaUFw@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/GFIlbTP2B=sNE2jdlzTnphK"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/GFIlbTP2B=sNE2jdlzTnphK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > index 0602d5d5d2ee..dc2d31321cbd 100644
> > --- a/drivers/net/ethernet/freescale/fec.h
> > +++ b/drivers/net/ethernet/freescale/fec.h
> > @@ -29,6 +29,10 @@
> >   */
> >  #define FEC_IEVENT		0x004 /* Interrupt event reg */
> >  #define FEC_IMASK		0x008 /* Interrupt mask reg */
> > +#ifdef CONFIG_FEC_MTIP_L2SW
> > +#define FEC_MTIP_R_DES_ACTIVE_0	0x018 /* L2 switch Receive
> > descriptor reg */ +#define FEC_MTIP_X_DES_ACTIVE_0	0x01C /*
> > L2 switch Transmit descriptor reg */ +#endif =20
>=20
> Please don't scatter #ifdef everywhere.
>=20
> In this case, the register exists, even if the switch it not being
> used, so there is no need to have it conditional.

+1

>=20
> >  #include <asm/cacheflush.h>
> > =20
> >  #include "fec.h"
> > +#ifdef CONFIG_FEC_MTIP_L2SW
> > +#include "./mtipsw/fec_mtip.h"
> > +#endif =20
>=20
> Why not just include it all the time?

Ok.

>=20
>     Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/GFIlbTP2B=sNE2jdlzTnphK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDS51kACgkQAR8vZIA0
zr3+awf9ERCiE8gx/0jjYs1Hf/KTgAnemjWwYWqiLUlEcK/rXJFwUN2eQgJ93gUJ
F8wrhAt4JZ8P158XUm8qpflU0e4F/PjVG2ndbIYJDPwWLppFz0wHesqJNf6rBW3l
WZ/Myg7Cahems0W8g0yqtppR5+er0rl5PPNZlRjAwbXqsaSCnZlCmCxDzA7waxAu
hGJoPJj7huDdO2KRKIUwfsX+TtoYUq93eAqMw4ldTV7gW9P3wi6BBYzUmjIsDrDA
957tAHMF7Kb0KDQJp/P0CkYzgvHf7oJOn5HQbFFqzy8WuW4dvoaLGwS4p2od+FN4
fCcwgsSI15Bl12Ivh7P8zvlvbzMC6Q==
=w6o7
-----END PGP SIGNATURE-----

--Sig_/GFIlbTP2B=sNE2jdlzTnphK--
