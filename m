Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF9D588908
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 11:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbiHCJE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 05:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiHCJEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 05:04:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F4C286F3
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 02:04:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJAIx-0006Tj-DE; Wed, 03 Aug 2022 11:04:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4F37EC1EEC;
        Wed,  3 Aug 2022 09:04:37 +0000 (UTC)
Date:   Wed, 3 Aug 2022 11:04:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Vincent Mailhol <vincent.mailhol@gmail.com>,
        Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Jiri Novak <jnovak@fel.cvut.cz>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220803090436.o3c7khieckxwmj5y@pengutronix.de>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <CAMZ6RqJEBV=1iUN3dH-ZZVujOFEoJ-U1FaJ5OOJzw+aM_mkUvA@mail.gmail.com>
 <202208020937.54675.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lnyqk3jichuhl7n6"
Content-Disposition: inline
In-Reply-To: <202208020937.54675.pisa@cmp.felk.cvut.cz>
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


--lnyqk3jichuhl7n6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.08.2022 09:37:54, Pavel Pisa wrote:
> > Hardware TX timestamps are now supported (c.f. supra).
> >
> > > +       info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE) |
> > > +                          BIT(HWTSTAMP_FILTER_ALL);
>=20
> I am not sure if it is good idea to report support for hardware
> TX timestamps by all drivers. Precise hardware Tx timestamps
> are important for some CAN applications but they require to be
> exactly/properly aligned with Rx timestamps.
>=20
> Only some CAN (FD) controllers really support that feature.
> For M-CAN and some others it is realized as another event
> FIFO in addition to Tx and Rx FIFOs.

The mcp251xfd uses the event FIFO to signal TX completion. Timestamps
are optional, but always enabled in the mcp251xfd driver.

> For CTU CAN FD, we have decided that we do not complicate design
> and driver by separate events channel. We have configurable
> and possibly large Rx FIFO depth which is logical to use for
> analyzer mode and we can use loopback to receive own messages
> timestamped same way as external received ones.
>=20
> See 2.14.1 Loopback mode
> SETTINGS[ILBP]=3D1.
>=20
> in the datasheet
>=20
>   http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf

BTW: the datasheet says:

| 3.1.36 RX_DATA
|=20
| ... this register must be read by 32 bit access.

While there is a section that uses 8-bit accessed on that register:

| 2.10.10 Sample code 2 - Frame reception in manual mode (8-bit access)

> There is still missing information which frames are received
> locally and from which buffer they are in the Rx message format,
> but we plan to add that into VHDL design.
>=20
> In such case, we can switch driver mode and release Tx buffers
> only after corresponding message is read from Rx FIFO and
> fill exact finegrain (10 ns in our current design) timestamps
> to the echo skb. The order of received messages will be seen
> exactly mathing the wire order for both transmitted and received
> messages then. Which I consider as proper solution for the
> most applications including CAN bus analyzers.
>=20
> So I consider to report HW Tx timestamps for cases where exact,
> precise timestamping is not available for loopback messages
> as problematic because you cannot distinguish if you talk
> with driver and HW with real/precise timestamps support
> or only dummy implementation to make some tools happy.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lnyqk3jichuhl7n6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLqOiIACgkQrX5LkNig
011p9Af/Y1I6EmIJ8ta7aYBYf5wBk6gtXgZHszI7ySl1DuoM24QUgtK2U0VDZWtJ
77uNsHBypWE8WaycCIFd6+k/x0ivFbaOFp/gzP7FDadpQy25uc6tR8vVZxTmBnWv
edPN7Rjs2sBF3CInbjS1bUNZtBMfIHiiXAsXjtK8JojeGnt/h6TC/6uA1BKSwiMw
PQaO+f6X2pqRy9P/ZGygdn+9IasCSYdMCu4I1WkPlTFba2zTudPTYxxv79A4wUia
1AEVu5lmpxbzitOSPWASteYtwYWr/qVZ7qDTuPss6ywOZNXD/jvUmhf5VAZfZ8u1
k1BHIq0iUCGl91bfvjiFo+yGR6+u3w==
=WcbP
-----END PGP SIGNATURE-----

--lnyqk3jichuhl7n6--
