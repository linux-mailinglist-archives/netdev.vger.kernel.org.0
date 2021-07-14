Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B64B3C8BB3
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 21:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGNTfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhGNTfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 15:35:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5324C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 12:32:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m3kc9-00037Y-BM; Wed, 14 Jul 2021 21:32:13 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1d5a:f852:d9c2:1ad3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 753FC64F576;
        Wed, 14 Jul 2021 19:32:06 +0000 (UTC)
Date:   Wed, 14 Jul 2021 21:32:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     dev.kurt@vandijck-laurijssen.be, wg@grandegger.com,
        Xiaochen Zou <xzou017@ucr.edu>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH v1] can: j1939: j1939_session_deactivate(): clarify
 lifetime of session object
Message-ID: <20210714193205.jsygqqnimcqarety@pengutronix.de>
References: <20210714111602.24021-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dz7anhbgfjbiwfae"
Content-Disposition: inline
In-Reply-To: <20210714111602.24021-1-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dz7anhbgfjbiwfae
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.07.2021 13:16:02, Oleksij Rempel wrote:
> The j1939_session_deactivate() is decrementing the session ref-count and
> potentially can free() the session. This would cause use-after-free
> situation.
>=20
> However, the code calling j1939_session_deactivate() does always hold
> another reference to the session, so that it would not be free()ed in
> this code path.
>=20
> This patch adds a comment to make this clear and a WARN_ON, to ensure
> that future changes will not violate this requirement. Further this
> patch avoids dereferencing the session pointer as a precaution to avoid
> use-after-free if the session is actually free()ed.
>=20
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Reported-by: Xiaochen Zou <xzou017@ucr.edu>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Added to linux-can/testing

regards,
Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dz7anhbgfjbiwfae
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDvO7MACgkQqclaivrt
76mGSAgAsLSRfsllRRbGlDGyUpGnatoujGqN/9WIUXnFcrLCnYIobnxirDez9DzY
Cb/vyUZ/qFESv8GCMOOTllg30+gGRW6FA0jusEO45CBklTR2CiqT6XrWG3n1hbA+
mf+RXareY5+M2SG1fNMvtsrGOWLatYDkxuIL6mC9F8MYXTwmHYWwnUh1ctxHnQqV
nryZ6cF/9/tbHpEEV567+r1hGTVjlOSOUu3eLfzPYMnE2TeU2Jg3KuP09z2G/Gl2
sf2n03rsjfDTMeUWXpvZzcV+nt6eWD7evTieYGHrO9bMx9QO2rEX4Ko/xForYEEg
nVVskpTBqmFjGUPZe0/LjeF5HL1kNw==
=YbdO
-----END PGP SIGNATURE-----

--dz7anhbgfjbiwfae--
