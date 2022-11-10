Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2920A6247D1
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiKJRBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiKJRBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:01:02 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB33615D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:01:01 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id DC73C84D70;
        Thu, 10 Nov 2022 18:00:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668099660;
        bh=VMB9xrWrGcrhlA26ub/1RPeEdCUNgeJRsRdhoV2Cz6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DxGuy+kiQ7oyR8JbIMfU61NLUfJT/ZEWc/fB7s0Cv/XqBQ0zi1NpHN/4QUu4JZv4z
         RbC5FAykuGGSh2HSNxM6JGYbsf3W18s9XAzucugdrQ78S2370m4JyyP6A7ggR7ZcUq
         ieeIs3Yvyws5y9EQEg06rD1XPvRsrSIIGI7moSjIkK3fi+dK1kSryYmY93Qov1T5J6
         KinUJZx+kjhKTC6Hi7uD/NFYy9Hwupf+UPGQplmaOK8VDo5rQgbWNbKVR0Odi7mq/n
         Fw4gS1csqSUDPRAEXGzeAt4MkJYjpcOWbz2rtAB+GT4xcur6p2YEjnyvd9BA4zFM4Q
         ktj3ET4wihJxQ==
Date:   Thu, 10 Nov 2022 18:00:53 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 3/9] net: dsa: mv88e6xxx: implement get_phy_address
Message-ID: <20221110180053.0cb8045d@wsk>
In-Reply-To: <Y2pbc90XD5IvZZC0@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-4-lukma@denx.de>
        <20221108091220.zpxsduscpvgr3zna@skbuf>
        <Y2pbc90XD5IvZZC0@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EFBSBuE/9d_3Im+j2torTMw";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EFBSBuE/9d_3Im+j2torTMw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > Would it be possible to do like armada-3720-turris-mox.dts does,
> > and put the phy-handle in the device tree, avoiding the need for so
> > many PHY address translation quirks?
> >=20
> > If you're going to have U-Boot support for this switch as well, the
> > phy-handle mechanism is the only thing that U-Boot supports,

Maybe in the generic case of PHY, yes (via Driver Model).

However, when you delve into the mv88e6xxx driver [1] - you would find
that this is not supporting it yet ...

> > so
> > device trees written in this way will work for both (and can be
> > passed by U-Boot to Linux): =20
>=20
> This is how i expect any board using the MV88E6141 and MV88E6341 work.
> It has the same issue that it is not a 1:1 mapping.

Please be aware that there is also majority of DTS entries, which use
the "old" switch description ...

>=20
> Portability with U-boot is an interesting argument. Maybe there are
> patches to u-boot to add the same sort of quirks?

As fair as I know - for the driver [1] - there was no ongoing effort
recently.

>=20
> 	Andrew

Links:
[1] -
https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/net/phy/mv88e61x=
x.c

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/EFBSBuE/9d_3Im+j2torTMw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNtLkUACgkQAR8vZIA0
zr2XVwgA3EFCIH196wFn3nknX6FzEv/XIvnJvI21gnTZLgQBit6YSB3I1RUbQoCH
dGOxXmmT89rrxcG5TATN4ljHQB72MciInmZ3dR4gOmfpq0ABe82YWnqRipcgFxTg
6k/YJMnfZ6ZM2+0XfUkdWApiXCJukpu/uVSzUYtW45JUfxvYMfwqrcasyQD8ul6q
GsO95TZ0nUVHvizkY2HxRRsSFS67CpsxNYc8mICdmWhHNFM8lBbMl3Q4i8AtqXQ0
TAOB1FTkJn/VACnbCvBkGboaAQ/S6es1+eNDSQfrwhLRceD6AbvCryWbZ5Uqrt4A
0tY53HdO1+jAstfrPpk0ccoMk57MCA==
=Zgrq
-----END PGP SIGNATURE-----

--Sig_/EFBSBuE/9d_3Im+j2torTMw--
