Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93553DD87
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243817AbiFESGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 14:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbiFESGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 14:06:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDB14CD53
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 11:06:49 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxueB-00018P-KT; Sun, 05 Jun 2022 20:06:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2C6138C90E;
        Sun,  5 Jun 2022 18:06:42 +0000 (UTC)
Date:   Sun, 5 Jun 2022 20:06:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220605180641.tfqyxhkkauzoz2z4@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
 <20220605192347.518c4b3c.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uzvth7z5c2f7sh7z"
Content-Disposition: inline
In-Reply-To: <20220605192347.518c4b3c.max@enpas.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uzvth7z5c2f7sh7z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.06.2022 19:23:47, Max Staudt wrote:
> Thanks Vincent for this cleanup!
>=20
> Since I am upstreaming a driver that may (?) not fit the proposed
> structure, one question below.
>=20
>=20
> On Sun,  5 Jun 2022 01:29:53 +0900
> Vincent Mailhol <mailhol.vincent@wanadoo.fr> wrote:
>=20
> > * menu after this series *
> >=20
> > Network device support
> >   symbol: CONFIG_NETDEVICES
> >   |
> >   +-> CAN Device Drivers
> >       symbol: CONFIG_CAN_DEV
> >       |
> >       +-> software/virtual CAN device drivers
> >       |   (at time of writing: slcan, vcan, vxcan)
> >       |
> >       +-> CAN device drivers with Netlink support
> >           symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
> >           |
> >           +-> CAN bit-timing calculation (optional for all drivers)
> >           |   symbol: CONFIG_CAN_BITTIMING
> >           |
> >           +-> All other CAN devices not relying on RX offload
> >           |
> >           +-> CAN rx offload
> >               symbol: CONFIG_CAN_RX_OFFLOAD
> >               |
> >               +-> CAN devices relying on rx offload
> >                   (at time of writing: flexcan, m_can, mcp251xfd and
> > ti_hecc)
>=20
> This seemingly splits drivers into "things that speak to hardware" and
> "things that don't". Except... slcan really does speak to hardware. It
> just so happens to not use any of BITTIMING or RX_OFFLOAD. However, my
> can327 (formerly elmcan) driver, which is an ldisc just like slcan,
> *does* use RX_OFFLOAD, so where to I put it? Next to flexcan, m_can,
> mcp251xfd and ti_hecc?
>=20
> Is it really just a split by features used in drivers, and no longer a
> split by virtual/real?

We can move RX_OFFLOAD out of the "if CAN_NETLINK". Who wants to create
an incremental patch against can-next/master?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uzvth7z5c2f7sh7z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKc8K4ACgkQrX5LkNig
012CLwgArYkdw9iflio4maZcQK4hFlv7Ivz74f9VLG6EKcFAjUUUjPYCS8jGoL1/
B/WtwP9Oy+FrzAzrHUcFB+6GN2A7DB2DGlXQ62ifwY3Z3yVKUtLiZCaHn/NZFxbG
0KoCqIux1q/GOA94BMI3BoMMXa5XEwwVma75mbAHUcCxcGEDQ0VU89TBu2WBMkLR
Vwf4QoT6LixRPUGlsJugv/+zsyNJXeKr/vt82ubGdaT7Jm9+YyMKjWqFDU/004uq
G4BLohfyCGv82srT8XOxy5HMBbmMpQM7V1Xm0BeSyyFJ5xeU3yH4WGkS4qZ9X7Gc
yeZjEonu1yDGcS0MtQ3ljcsrfHgmmw==
=4/r5
-----END PGP SIGNATURE-----

--uzvth7z5c2f7sh7z--
