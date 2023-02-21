Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC8769DC52
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 09:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbjBUInT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 03:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbjBUImt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 03:42:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38C6E87
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 00:42:46 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pUOE5-0003GS-Lg; Tue, 21 Feb 2023 09:42:17 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:27e2:f49:4c60:b961])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 816B117E52E;
        Tue, 21 Feb 2023 08:42:16 +0000 (UTC)
Date:   Tue, 21 Feb 2023 09:42:06 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, wg@grandegger.com,
        edumazet@google.com, pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] can: mscan: mpc5xxx: Use of_property_present()
 helper
Message-ID: <20230221084206.zxnyanfoox4gqghm@pengutronix.de>
References: <20230221024541.105199-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hrfcdqcbjtwwh3d5"
Content-Disposition: inline
In-Reply-To: <20230221024541.105199-1-yang.lee@linux.alibaba.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hrfcdqcbjtwwh3d5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.02.2023 10:45:41, Yang Li wrote:
> Use of_property_present() instead of of_get_property/of_find_property()
> in places where we just need to test presence of a property.
>=20
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

NAK!

Besides the things Pavan Chebbi says, this is not even compile:

| drivers/net/can/mscan/mpc5xxx_can.c: In function =E2=80=98mpc5xxx_can_pro=
be=E2=80=99:
| drivers/net/can/mscan/mpc5xxx_can.c:318:22: error: implicit declaration o=
f function =E2=80=98of_property_present=E2=80=99; did you mean =E2=80=98fwn=
ode_property_present=E2=80=99? [-Werror=3Dimplicit-function-declaration]
|   318 |         clock_name =3D of_property_present(np, "fsl,mscan-clock-s=
ource");
|       |                      ^~~~~~~~~~~~~~~~~~~
|       |                      fwnode_property_present
| drivers/net/can/mscan/mpc5xxx_can.c:318:20: error: assignment to =E2=80=
=98const char *=E2=80=99 from =E2=80=98int=E2=80=99 makes pointer from inte=
ger without a cast [-Werror=3Dint-conversion]
|   318 |         clock_name =3D of_property_present(np, "fsl,mscan-clock-s=
ource");
|       |                    ^
| cc1: all warnings being treated as errors

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hrfcdqcbjtwwh3d5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmP0g9oACgkQvlAcSiqK
BOhvUQf/awzwQM9W9569EDy3SCHweMikyRD4Gh2zYeaayAxKMr4y9Sd7P3XhLDy3
RpUPH1KiYHdhGKogTU0bQ6zIMt+l+pWe0HL1YQtb7EcIpyMOCl276QfDTOH+nE0W
X4OCmwQkZwtHDo09cKsw9YpZroqBMV0/fZhD0QO/71aiLqBYE/TLQ1gKndWwTI9T
gyl5v30P3BFIlLvKHMNQ7fGC31A1qiIjpJrz59AZydNj92pY89nyy0FXf6kewuRP
Es4dZZxnGF0OexUeEJJS2xeccBzxaE9z3OpKu7pRK/H1QdTcY59FbzuRUE5WPk2t
wXTPxV/51pr82Hr59Clrcg0lmPDNcA==
=yKkm
-----END PGP SIGNATURE-----

--hrfcdqcbjtwwh3d5--
