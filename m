Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785B9692364
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 17:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjBJQem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 11:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbjBJQel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 11:34:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ED672DCB
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 08:34:41 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pQWM8-000739-GD; Fri, 10 Feb 2023 17:34:36 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:46c4:4a2c:1d53:628e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C24F21759C1;
        Fri, 10 Feb 2023 16:34:35 +0000 (UTC)
Date:   Fri, 10 Feb 2023 17:34:27 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: error: too many arguments to function =?utf-8?B?4oCYY2FuX2Nh?=
 =?utf-8?B?bGNfYml0dGltaW5n4oCZ?=
Message-ID: <20230210163427.icau6xcqefx6boni@pengutronix.de>
References: <42ffb65d-31da-fc5e-0e47-5f24fa1e4f88@infradead.org>
 <63c3edef-35c6-867a-0ea7-06ed03ac74b9@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3ov3mzutprghk5le"
Content-Disposition: inline
In-Reply-To: <63c3edef-35c6-867a-0ea7-06ed03ac74b9@infradead.org>
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


--3ov3mzutprghk5le
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.02.2023 18:05:06, Randy Dunlap wrote:
> > It's possible to have a kernel .config (randconfig) file with
> > # CONFIG_CAN_CALC_BITTIMING is not set
> >=20
> > which ends up with different number of arguments to can_calc_bittiming(=
).
> >=20
> > Full compiler error listing is:
> >=20
> > ../drivers/net/can/dev/bittiming.c: In function =E2=80=98can_get_bittim=
ing=E2=80=99:
> > ../drivers/net/can/dev/bittiming.c:145:24: error: too many arguments to=
 function =E2=80=98can_calc_bittiming=E2=80=99
> >   145 |                 return can_calc_bittiming(dev, bt, btc, extack);
> >       |                        ^~~~~~~~~~~~~~~~~~
> > In file included from ../include/linux/can/dev.h:18,
> >                  from ../drivers/net/can/dev/bittiming.c:7:
> > ../include/linux/can/bittiming.h:126:1: note: declared here
> >   126 | can_calc_bittiming(const struct net_device *dev, struct can_bit=
timing *bt,
> >       | ^~~~~~~~~~~~~~~~~~
> >=20
> >=20
> > A failing i386 .config file is attached.
> >=20
> > Do you have any suggestions for resolving this error?

The problem is already fixed in current net-next/main:

| 65db3d8b5231 ("can: bittiming: can_calc_bittiming(): add missing paramete=
r to no-op function")

sorry for the mess,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3ov3mzutprghk5le
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPmchAACgkQvlAcSiqK
BOgQXQf/ahtKScqaQeOPRH0PnchOf1FNCrVRGqhF3A8akeAWohV6EiB34QvgeFfP
4KynPtGrmpcXbU2QbccxUnCsqOu29FeOTMM2PsmyZMdLLxE0ZpzA3od+LNdkEuCk
H/7vDohUZ2wbuwci1ZkEAKnawVbB2hPVe1Ri1yHnjLlG4Q1LNuZZYNDN9HxWqzVQ
+qP+FKhpC7bkOXP9MQmA5FtZxgo8PeNWyU3WqhEt5RH86IacvCEiUJaMgsnGT4MC
HogfGa4XnvcIt7+xnBr7jw7f0yt5BOMaPLqVzt65VseGPQrqMAMp4tk67+hn7mR1
MugBJ50zK8XHUkgs8ovZ7rAVVw6cYQ==
=cXnC
-----END PGP SIGNATURE-----

--3ov3mzutprghk5le--
