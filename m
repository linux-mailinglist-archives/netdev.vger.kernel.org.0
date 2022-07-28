Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DE8583AE4
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbiG1JCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbiG1JCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:02:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D896865664
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:02:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGzPc-0004ja-6B; Thu, 28 Jul 2022 11:02:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C4EBBBCB24;
        Thu, 28 Jul 2022 09:02:29 +0000 (UTC)
Date:   Thu, 28 Jul 2022 11:02:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     Max Staudt <max@enpas.org>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
 <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
 <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5tukwidie4thhway"
Content-Disposition: inline
In-Reply-To: <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
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


--5tukwidie4thhway
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.07.2022 09:36:21, Dario Binacchi wrote:
> > Most of the other CAN drivers write the BTR values into the register of
> > the hardware. How are these BTR values transported into the driver?
> >
> > There are 2 ways:
> >
> > 1) - user space configures a bitrate
> >    - the kernel calculates with the "struct can_bittiming_const" [1] gi=
ven
> >      by driver and the CAN clock rate the low level timing parameters.
> >
> >      [1] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/lin=
ux/can/netlink.h#L47
> >
> > 2) - user space configures low level bit timing parameter
> >      (Sample point in one-tenth of a percent, Time quanta (TQ) in
> >       nanoseconds, Propagation segment in TQs, Phase buffer segment 1 in
> >       TQs, Phase buffer segment 2 in TQs, Synchronisation jump width in
> >       TQs)
> >     - the kernel calculates the Bit-rate prescaler from the given TQ and
> >       CAN clock rate
> >
> > Both ways result in a fully calculated "struct can_bittiming" [2]. The
> > driver translates this into the hardware specific BTR values and writes
> > the into the registers.
> >
> > If you know the CAN clock and the bit timing const parameters of the
> > slcan's BTR register you can make use of the automatic BTR calculation,
> > too. Maybe the framework needs some tweaking if the driver supports both
> > fixed CAN bit rate _and_ "struct can_bittiming_const".
>=20
> Does it make sense to use the device tree

The driver doesn't support DT and DT only works for static serial
interfaces.

> to provide the driver with those
> parameters required for the automatic calculation of the BTR (clock rate,
> struct can_bittiming_const, ...) that depend on the connected
> controller?

The device tree usually says it's a CAN controller compatible to X and
the following clock(s) are connected. The driver for CAN controller X
knows the bit timing const. Some USB CAN drivers query the bit timing
const from the USB device.

> In this way the solution should be generic and therefore scalable. I
> think we should also add some properties to map the calculated BTR
> value on the physical register of the controller.

The driver knows how to map the "struct can_bittiming" to the BTR
register values of the hardware.

What does the serial protocol say to the BTR values? Are these standard
SJA1000 layout with 8 MHz CAN clock or are those adapter specific?

> Or, use the device tree to extend the bittates supported by the controller
> to the fixed ones (struct can_priv::bitrate_const)?

The serial protocol defines fixed bit rates, no need to describe them in
the DT:

|           0            10 Kbit/s
|           1            20 Kbit/s
|           2            50 Kbit/s
|           3           100 Kbit/s
|           4           125 Kbit/s
|           5           250 Kbit/s
|           6           500 Kbit/s
|           7           800 Kbit/s
|           8          1000 Kbit/s

Are there more bit rates?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5tukwidie4thhway
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLiUKEACgkQrX5LkNig
0117QggAjrRUz25+oJjtGLVN5SEFPDVNMFeaVARhoxHZX/v7IfAyQpAT/HjiT/Sx
5YyBaN98+KS86zMu5qjHrdlhjqbIH+uOYdN/y42hEhiRXGkOSnC2l8cKuuYowOgO
U9QfZrOIFv4pfstQ+yRRSNG30wGUezJtISk1U+TkYaxwFcihU1SIMm9p1hhofjQJ
iIPc41SbKRzgTtzyAjBS0d2Ti6gXKv4k7vCVfjgEM5ai/jRcIvlqf5xvEmhxfP2I
tqabd4hSh8rDZe1I9eaNrpOslOVx1bWW6Vycycoq8oN1QcNkng1BHvF/xFctmfoN
MKZ/u90EzFCwX/H2Ndc/dsrm2RnN6g==
=+ALT
-----END PGP SIGNATURE-----

--5tukwidie4thhway--
