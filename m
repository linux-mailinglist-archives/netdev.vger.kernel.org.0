Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994C652A162
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 14:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiEQMWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 08:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345869AbiEQMWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 08:22:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701D34553F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 05:22:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqwD5-0004h1-Nl; Tue, 17 May 2022 14:21:55 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 959A78055C;
        Tue, 17 May 2022 12:21:54 +0000 (UTC)
Date:   Tue, 17 May 2022 14:21:53 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
 <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6yob3xezug2i52qe"
Content-Disposition: inline
In-Reply-To: <20220517141404.578d188a.max@enpas.org>
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


--6yob3xezug2i52qe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.05.2022 14:14:04, Max Staudt wrote:
> > After looking through drivers/net/can/Kconfig I would probably phrase
> > it like this:
> >=20
> > Select CAN devices (hw/sw) -> we compile a can_dev module. E.g. to=20
> > handle the skb stuff for vcan's.
> >=20
> > Select hardware CAN devices -> we compile the netlink stuff into
> > can_dev and offer CAN_CALC_BITTIMING and CAN_LEDS to be compiled into
> > can_dev too.
> >=20
> > In the latter case: The selection of flexcan, ti_hecc and mcp251xfd=20
> > automatically selects CAN_RX_OFFLOAD which is then also compiled into=
=20
> > can_dev.
> >=20
> > Would that fit in terms of complexity?
>=20
> IMHO these should always be compiled into can-dev. Out of tree drivers
> are fairly common here, and having to determine which kind of can-dev
> (stripped or not) the user has on their system is a nightmare waiting to
> happen.

I personally don't care about out-of-tree drivers.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6yob3xezug2i52qe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKDk14ACgkQrX5LkNig
013nswf/crAeAo5zG26rSgyiO4+0Drl9nH1Ptc+d3qXd6HIClrOU2nT5hFOvM/K6
Woz8yqddAltpBRIccYjfYuDD02sR9U+PnhJOFohObcDr1nJiwUR1hKkZdoeKfc6B
BoMaKtUxX+a54BT3AyzK2hrTm+2SwGEcmzWDkYp6e2HDLlrE66/bP55WleFIGzru
hbkX387AAnKvUcEPLAb06eoYwOSyXD5I8qouMtHPVkxfRRxgN3Bl4dtvOAPs4m/M
PK4cTOV+p0mPDWJn9IK1rSr+/oySE+Ashr0YisONu14ayjLaCJ70ZnAPviTpf/p5
wa5dG4B4FxGhfz8GU7dnfruvfUg30w==
=gM/F
-----END PGP SIGNATURE-----

--6yob3xezug2i52qe--
