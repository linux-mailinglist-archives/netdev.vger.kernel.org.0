Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A93B620D5C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiKHKer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiKHKep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:34:45 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8850E201A5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:34:44 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id C564D84C17;
        Tue,  8 Nov 2022 11:34:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667903682;
        bh=AepQr7Z/zwtiNgoc7cBfGY6ILOvZWC5YxRR4gb0j2mk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jpYOmSqpVNKy9WkO46WjhdyuFpvO7pE9x7USQkMHOLn2ZtLqLWRBPgCXCIj3KEduD
         KjGQNkpFOQwpeWEj1ahNtUegyy7Z0cXdMosS2NMKmG3kbd+Ev8i1Q3tgP794cE78Mp
         GlM249EzozU4fqK+yafrOiT60h7DTXlPGRIA5JBnOQTSYB//O+tm4Md5zxjWnw3i8/
         n6DtaO4bwS8+d5vlilD7PVjV0rcZjh/5ku42Kr6qhOo+EcT0HgTjhfudpdPwgyURWT
         SgVSnnqtvCzNVQm2q0T8gac/dlY9srZf+P/Vz/RhX5FM9rg+coxY+fL9c1EjBm8g3e
         3pb73RVCr4bSw==
Date:   Tue, 8 Nov 2022 11:34:35 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 1/9] net: dsa: allow switch drivers to override default
 slave PHY addresses
Message-ID: <20221108113435.66b15fb2@wsk>
In-Reply-To: <20221108091258.iaea3dhkjcuandvb@skbuf>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-2-lukma@denx.de>
        <20221108082330.2086671-2-lukma@denx.de>
        <20221108091258.iaea3dhkjcuandvb@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2xWxpLyrfqqx65kU1YNajj1";
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

--Sig_/2xWxpLyrfqqx65kU1YNajj1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> Hi Lukasz,
>=20
> On Tue, Nov 08, 2022 at 09:23:22AM +0100, Lukasz Majewski wrote:
> > From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> >=20
> > Avoid having to define a PHY for every physical port when PHY
> > addresses are fixed, but port index !=3D PHY address.
> >=20
> > Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > [Adjustments for newest kernel upstreaming] =20
>=20
> (I got reminded by the message)
> How are things going with the imx28 MTIP L2 switch? Upstreaming went
> silent on that.

Yes, this task has been postponed as:

- Customer decided to use Linux 4.19 CIP for which I've forward ported
  the original NXP patches [1][2]

- Considering the above - I would need to change the structure of the
  switch driver (which up till now is based on old - i.e. 2.6.3x - FEC
  driver) and modify the current FEC to add acceleration in similar way
  to TI's driver.

  This is IMHO quite time consuming task ...

  (The attempt to add it as DSA [2] was a bit less intrusive, but is
  conceptually wrong).

Links:
[1] - https://github.com/lmajewski/linux-imx28-l2switch/tree/master

[2] -
https://github.com/lmajewski/linux-imx28-l2switch/tree/imx28-v5.12-L2-upstr=
eam-RFC_v1

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/2xWxpLyrfqqx65kU1YNajj1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNqMLsACgkQAR8vZIA0
zr0zUggAuk6CTSUvyACYyah/Rn7sscqLuPGggq1/NL1QpVagyYkcrar5sN3LF4Jp
Ujg4ItYJPjIExBwu9R3jhphRReBNC/4DjFoed0DLUmRZQn7H7AVEkn/r+fFKRIwV
L+s4hNE/Zw/ed4yWIQolAv4WGSqCJExbVYcRXVWAJifJjfWG3vDWHIXw0WISVMG/
94BCUtRQzG5W63ak5xT2kke6dD6tbntVupduByVvznPG+UpZcgLs95n+rPezkYrj
CSkOxnXHGDtVj/f/nRzqV+3qK3cPVAMI2yREWYKN4YW+1DjAo+DjPwSFV89S5dMX
RR8fKcIiWinFDh02d0ssBAjBjAaGYg==
=Hu/0
-----END PGP SIGNATURE-----

--Sig_/2xWxpLyrfqqx65kU1YNajj1--
