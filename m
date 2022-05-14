Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97145273C5
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 21:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiENTg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 15:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiENTgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 15:36:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D241C118
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 12:36:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npxYi-0005RA-0z; Sat, 14 May 2022 21:36:12 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 081157E414;
        Sat, 14 May 2022 19:36:09 +0000 (UTC)
Date:   Sat, 14 May 2022 21:36:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        ondrej.ille@gmail.com, Jiri Novak <jnovak@fel.cvut.cz>,
        linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, martin.jerabek01@gmail.com
Subject: Re: [RFC PATCH 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220514193609.gfq7dbbmddlr5wa2@pengutronix.de>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
 <20220512232706.24575-2-matej.vasilevski@seznam.cz>
 <20220513114135.lgbda6armyiccj3o@pengutronix.de>
 <202205132102.58109.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7sqm2pgw2volmoot"
Content-Disposition: inline
In-Reply-To: <202205132102.58109.pisa@cmp.felk.cvut.cz>
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


--7sqm2pgw2volmoot
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.05.2022 21:02:58, Pavel Pisa wrote:
[...]
> > A property with "width"
>=20
> agree
>=20
> > in the name seems to be more common. You=20
> > probably have to add the "ctu" vendor prefix. BTW: the bindings document
> > update should come before changing the driver.
>=20
> this is RFC and not a final.
>=20
> In general and long term, I vote and prefer to have number of the most
> significant active timestamp bit to be encoded in some CTU CAN FD IP
> core info register same as for the number of the Tx buffers.

+1

> We will discuss that internally. The the solution is the same for
> platform as well as for PCI. But the possible second clock frequency
> same as the bitrate clock source should stay to be provided from
> platform and some table based on vendor and device ID in the PCI case.
> Or at least it is my feeling about the situation.

Ack, this is the most straight forward option. ACPI being more
complicated - tough I've never touched it.

> > > - add second clock phandle to 'clocks' property
> > > - create 'clock-names' property and name the second clock 'ts_clk'
> > >
> > > Alternatively, you can set property 'ts-frequency' directly with
> > > the timestamping frequency, instead of setting second clock.
> >
> > For now, please use a clock property only. If you need ACPI bindings add
> > them later.
>=20
> I would be happy if I would never need to think about ACPI... or if
> somebody else does it for us...

I see no reason for ACPI at the moment.

> > > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > > ---
> > >  drivers/net/can/ctucanfd/Kconfig              |  10 ++
> > >  drivers/net/can/ctucanfd/Makefile             |   2 +-
> > >  drivers/net/can/ctucanfd/ctucanfd.h           |  25 ++++
> > >  drivers/net/can/ctucanfd/ctucanfd_base.c      | 123 ++++++++++++++++=
+-
> > >  drivers/net/can/ctucanfd/ctucanfd_timestamp.c | 113 ++++++++++++++++
> > >  5 files changed, 267 insertions(+), 6 deletions(-)
> > >  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> > >
> > > diff --git a/drivers/net/can/ctucanfd/Kconfig
> > > b/drivers/net/can/ctucanfd/Kconfig index 48963efc7f19..d75931525ce7
> > > 100644
> > > --- a/drivers/net/can/ctucanfd/Kconfig
> > > +++ b/drivers/net/can/ctucanfd/Kconfig
> > > @@ -32,3 +32,13 @@ config CAN_CTUCANFD_PLATFORM
> > >  	  company. FPGA design
> > > https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top. The kit
> > > description at the Computer Architectures course pages
> > > https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mz_apo/start=
 . +
> > > +config CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS
> > > +	bool "CTU CAN-FD IP core platform device hardware timestamps"
> > > +	depends on CAN_CTUCANFD_PLATFORM
> > > +	default n
> > > +	help
> > > +	  Enables reading hardware timestamps from the IP core for platform
> > > +	  devices by default. You will have to provide ts-bit-size and
> > > +	  ts-frequency/timestaping clock in device tree for CTU CAN-FD IP
> > > cores, +	  see device tree bindings for more details.
> >
> > Please no Kconfig option, see above.
>=20
> It is only my feeling, but I would keep driver for one or two releases
> with timestamps code really disabled by default and make option
> visible only when CONFIG_EXPERIMENTAL is set. This would could allow
> possible incompatible changes and settle of the situation on IP core
> side... Other options is to keep feature for while out of the tree.
> But review by community is really important and I am open to
> suggestions...

The current Kconfig option only sets if timestamping is enabled by
default or not.

If we now add the TS support including the DT bits, we have to support
the DT bindings, even after the info registers have been added. Once you
have a HW with the info registers and boot a system with TS related DT
information you (or rather the driver) has to decide which information
to use.

> > > diff --git a/drivers/net/can/ctucanfd/Makefile
> > > b/drivers/net/can/ctucanfd/Makefile index 8078f1f2c30f..78b7d9830098
> > > 100644
> > > --- a/drivers/net/can/ctucanfd/Makefile
> > > +++ b/drivers/net/can/ctucanfd/Makefile
> > > --- /dev/null
> > > +++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> > > @@ -0,0 +1,113 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +/*******************************************************************=
****
> > >******** + *
> > > + * CTU CAN FD IP Core
> > > + *
> > > + * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> =
FEE
> > > CTU + *
> > > + * Project advisors:
> > > + *     Jiri Novak <jnovak@fel.cvut.cz>
> > > + *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > > + *
> > > + * Department of Measurement         (http://meas.fel.cvut.cz/)
> > > + * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
> > > + * Czech Technical University        (http://www.cvut.cz/)
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License
> > > + * as published by the Free Software Foundation; either version 2
> > > + * of the License, or (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> >
> > With the SPDX-License-Identifier you can skip this.
>=20
> OK, Matej Vasilevski started his work on out of the tree code.
>=20
> Please, model header according to actual net-next CTU CAN FD
> files header.
>=20
>=20
> > > +int ctucan_timestamp_init(struct ctucan_priv *priv)
> > > +{
> > > +	struct cyclecounter *cc =3D &priv->cc;
> > > +
> > > +	cc->read =3D ctucan_timestamp_read;
> > > +	cc->mask =3D CYCLECOUNTER_MASK(priv->timestamp_bit_size);
> > > +	cc->shift =3D 10;
> > > +	cc->mult =3D clocksource_hz2mult(priv->timestamp_freq, cc->shift);
> >
> > If you frequency and width is not known, it's probably better not to
> >
> > hard code the shift and use clocks_calc_mult_shift() instead:
> > | https://elixir.bootlin.com/linux/v5.17.7/source/kernel/time/clocksour=
ce.c#L47
>=20
> Thanks for the pointer. I have suggested dynamic shift approach used actu=
ally
> in calculate_and_set_work_delay. May it be it can be replaced by some=20
> cloksource function as well.

The function clocks_calc_mult_shift() actually calculated the mult and
shift values. It takes frequency and a maxsec argument:

| The @maxsec conversion range argument controls the time frame in
| seconds which must be covered by the runtime conversion with the
| calculated mult and shift factors. This guarantees that no 64bit
| overflow happens when the input value of the conversion is multiplied
| with the calculated mult factor. Larger ranges may reduce the
| conversion accuracy by choosing smaller mult and shift factors.

> Best wishes and thanks Matej Vasilevski for the great work and Marc
> for the help to get it into the shape,

You're welcome. I'm looking forward to use this IP core and driver some
day.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7sqm2pgw2volmoot
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKABKYACgkQrX5LkNig
011+Mwf9HtNZGyzCQVwYKJq5QkN+MGQIbT5FI7jDWG7FPGnVKICzFePvXeC0T/Yl
InijhZc5K+gMXpH/ZPIPUoblKTENEKMQJIQCf1Mv8ujIFQ3tyQvAEFGiBF1rneqT
ojYh5XV9yIek/GxT67rccVqP1QJRghYBZkUFaPQuos0MiM7k2VY8sLSY9QaAFRwt
C+w3YvcdjxxB+WlsoIkaD1oALRnlWMNRx7SKRwZO8dl2CLh/9SYmEZAZ5DV4yxwi
cYyKR2ZToA1iTaqHbqS3hAd+BPrmEahiUAGx/nA7sUkXSciaEwEMnAJlBkGA/pOg
0FvrCEbg1s6jZ+JWKKGbpQ4q1Qed1A==
=RbrB
-----END PGP SIGNATURE-----

--7sqm2pgw2volmoot--
