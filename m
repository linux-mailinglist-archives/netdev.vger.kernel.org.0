Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7776E72EE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjDSGON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjDSGOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:14:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8A6E5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:14:10 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pp14k-000742-Qv; Wed, 19 Apr 2023 08:13:54 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D371B1B2AA2;
        Wed, 19 Apr 2023 06:13:53 +0000 (UTC)
Date:   Wed, 19 Apr 2023 08:13:52 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Mendez, Judith" <jm@ti.com>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
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
Message-ID: <20230419-trimmer-fasting-928868e8cb81-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
 <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
 <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
 <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
 <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
 <20230417-taking-relieving-f2c8532864c0-mkl@pengutronix.de>
 <25806ec7-64c5-3421-aea1-c0d431e3f27f@hartkopp.net>
 <20230417-unsafe-porridge-0b712d137530-mkl@pengutronix.de>
 <5ece3561-4690-a721-aa83-adf80d0be9f5@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cggld5pyystbuhs6"
Content-Disposition: inline
In-Reply-To: <5ece3561-4690-a721-aa83-adf80d0be9f5@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cggld5pyystbuhs6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.04.2023 15:59:57, Mendez, Judith wrote:
> > > > > > > The "shortest" 11 bit CAN ID CAN frame is a Classical CAN fra=
me with DLC =3D 0
> > > > > > > and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1=
Mbit =3D> ~50
> > > > > > > usecs
> > > > > > >=20
> > > > > > > So it should be something about
> > > > > > >=20
> > > > > > >        50 usecs * (FIFO queue len - 2)
> > > > > >=20
> > > > > > Where does the "2" come from?
> > > > >=20
> > > > > I thought about handling the FIFO earlier than it gets completely=
 "full".
> > > > >=20
> > > > > The fetching routine would need some time too and the hrtimer cou=
ld also
> > > > > jitter to some extend.
> > > >=20
> > > > I was assuming something like this.
> > > >=20
> > > > I would argue that the polling time should be:
> > > >=20
> > > >       50 =C2=B5s * FIFO length - IRQ overhead.
> > > >=20
> > > > The max IRQ overhead depends on your SoC and kernel configuration.
> > >=20
> > > I just tried an educated guess to prevent the FIFO to be filled up
> > > completely. How can you estimate the "IRQ overhead"? And how do you c=
atch
> > > the CAN frames that are received while the IRQ is handled?
> >=20
> > We're talking about polling, better call it "overhead" or "latency from
> > timer expiration until FIFO has at least one frame room". This value
> > depends on your system.
> >=20
> > It depends on many, many factors, SoC, Kernel configuration (preempt RT,
> > powersaving, frequency scaling, system load. In your example it's 100
> > =C2=B5s. I wanted to say there's an overhead (or latency) and we need e=
nough
> > space in the FIFO, to cover it.
> >=20
>=20
> I am not sure how to estimate IRQ overhead, but FIFO length should be 64
> elements.

Ok

> 50 us * 62 is about 3.1 ms and we are using 1 ms timer polling interval.

Sounds good.

> Running a few benchmarks showed that using 0.5 ms timer polling interval
> starts to take a toll on CPU load, that is why I chose 1 ms polling
> interval.

However in the code you use 5 ms.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--cggld5pyystbuhs6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ/hp0ACgkQvlAcSiqK
BOjeFwf/UaNEfsSOA9OPls69RXd4P4lR2cQibXWCABAg/B1OHkD9BdLDKqR+mS8S
G+PG//Ot9k8CwPoFFt+xZ0TrxIj/CakDJzawuMoJvSpToSX84V0eYZgh2oH0JBmd
m8ocOGnz3dPGaIH+UQ6sUZQN3JxE/oeDV8AgLyD86tE6NDc4BxPARTdiH3oJP1mj
Wn109juOs0zfj+BftxgtfvfTPcYcDxmR/8Skvy7lWi/6Oir5lpRcyVRuo6zd4wfh
KfsuBSJ0TgdVwntMN8R/P6UXAkvburMAZZj1p3Nv91DweeiJCX7T4K07B1tGWWpu
1iKTXZ4x3NzwMww5oizIjKx+Mjhkhg==
=CtTc
-----END PGP SIGNATURE-----

--cggld5pyystbuhs6--
