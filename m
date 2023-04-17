Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119256E50D4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjDQT0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjDQT0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:26:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2866E99
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:26:24 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1poUUJ-0004Fg-PX; Mon, 17 Apr 2023 21:26:07 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BC3631B175F;
        Mon, 17 Apr 2023 19:26:04 +0000 (UTC)
Date:   Mon, 17 Apr 2023 21:26:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230417-unsafe-porridge-0b712d137530-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
 <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
 <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
 <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
 <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
 <20230417-taking-relieving-f2c8532864c0-mkl@pengutronix.de>
 <25806ec7-64c5-3421-aea1-c0d431e3f27f@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="clk4ct7erfqsly7j"
Content-Disposition: inline
In-Reply-To: <25806ec7-64c5-3421-aea1-c0d431e3f27f@hartkopp.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--clk4ct7erfqsly7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.04.2023 19:34:03, Oliver Hartkopp wrote:
> On 17.04.23 09:26, Marc Kleine-Budde wrote:
> > On 16.04.2023 21:46:40, Oliver Hartkopp wrote:
> > > > I had the 5ms that are actually used in the code in mind. But this =
is a
> > > > good calculation.
> > >=20
> > > @Judith: Can you acknowledge the value calculation?
> > >=20
> > > > > The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame w=
ith DLC =3D 0
> > > > > and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit=
 =3D> ~50
> > > > > usecs
> > > > >=20
> > > > > So it should be something about
> > > > >=20
> > > > >       50 usecs * (FIFO queue len - 2)
> > > >=20
> > > > Where does the "2" come from?
> > >=20
> > > I thought about handling the FIFO earlier than it gets completely "fu=
ll".
> > >=20
> > > The fetching routine would need some time too and the hrtimer could a=
lso
> > > jitter to some extend.
> >=20
> > I was assuming something like this.
> >=20
> > I would argue that the polling time should be:
> >=20
> >      50 =C2=B5s * FIFO length - IRQ overhead.
> >=20
> > The max IRQ overhead depends on your SoC and kernel configuration.
>=20
> I just tried an educated guess to prevent the FIFO to be filled up
> completely. How can you estimate the "IRQ overhead"? And how do you catch
> the CAN frames that are received while the IRQ is handled?

We're talking about polling, better call it "overhead" or "latency from
timer expiration until FIFO has at least one frame room". This value
depends on your system.

It depends on many, many factors, SoC, Kernel configuration (preempt RT,
powersaving, frequency scaling, system load. In your example it's 100
=C2=B5s. I wanted to say there's an overhead (or latency) and we need enough
space in the FIFO, to cover it.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--clk4ct7erfqsly7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ9nUkACgkQvlAcSiqK
BOixwwf/S6gpZAbZI0gDLqq59QAhT0OVgjq9E8jQRb6b3SM430nhVX/oOlfIXRCJ
mz76H1v+b1fURaOi+VZC5zoVb5MF8WhJtBEAWa2IbLNGA1A/6UMtQ466nbNCXPYP
dFBo+MfWZrkcSayCEYuWdwiPPHJSkOtNeZnjRDwMm2uPF1CeSrQlS5Fbi0GNJy//
7hVBMN7Jm4qlCQxCC3jHRm0Gtc8qWz5n1v2DyxokjtT4jMo9Iwni6wnPB9ni5JHT
SldeHxtqHDcc4i83eUxhZzsYD6WDV+J7VAkARfnJBcDnFX8qCznvU5eOjBMU3qgr
IIraJi0ns1cH/zWAc/yyMoaL+/vn9A==
=PGh8
-----END PGP SIGNATURE-----

--clk4ct7erfqsly7j--
