Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A3464081F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbiLBOEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiLBOEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:04:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFF4D49E3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 06:04:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p16e1-0005zc-Aa; Fri, 02 Dec 2022 15:04:01 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CF4C91316D6;
        Fri,  2 Dec 2022 14:04:00 +0000 (UTC)
Date:   Fri, 2 Dec 2022 15:03:52 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221202140352.ncbgecrmkoa73mmz@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
 <20221201082521.3tqevaygz4nhw52u@blmsp>
 <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
 <20221201101220.r63fvussavailwh5@blmsp>
 <20221201110033.r7hnvpw6fp2fquni@pengutronix.de>
 <20221201165951.5a4srb7zjrsdr3vd@blmsp>
 <20221202092306.7p3r4yuauwjj5xaj@pengutronix.de>
 <20221202094346.u2nasxlcwh7llwe5@blmsp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="etkcec3iq27txtcv"
Content-Disposition: inline
In-Reply-To: <20221202094346.u2nasxlcwh7llwe5@blmsp>
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


--etkcec3iq27txtcv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.12.2022 10:43:46, Markus Schneider-Pargmann wrote:
> On Fri, Dec 02, 2022 at 10:23:06AM +0100, Marc Kleine-Budde wrote:
> ...
> > > > > > The configuration for the mcp251xfd looks like this:
> > > > > >=20
> > > > > > - First decide for classical CAN or CAN-FD mode
> > > > > > - configure RX and TX ring size
> > > > > >   9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime =
configurable RX/TX ring parameters")
> > > > > >   For TX only a single FIFO is used.
> > > > > >   For RX up to 3 FIFOs (up to a depth of 32 each).
> > > > > >   FIFO depth is limited to power of 2.
> > > > > >   On the mcan cores this is currently done with a DT property.
> > > > > >   Runtime configurable ring size is optional but gives more fle=
xibility
> > > > > >   for our use-cases due to limited RAM size.
> > > > > > - configure RX and TX coalescing via ethtools
> > > > > >   Set a timeout and the max CAN frames to coalesce.
> > > > > >   The max frames are limited to half or full FIFO.
> > > > >=20
> > > > > mcan can offer more options for the max frames limit fortunately.
> > > > >=20
> > > > > >=20
> > > > > > How does coalescing work?
> > > > > >=20
> > > > > > If coalescing is activated during reading of the RX'ed frames t=
he FIFO
> > > > > > not empty IRQ is disabled (the half or full IRQ stays enabled).=
 After
> > > > > > handling the RX'ed frames a hrtimer is started. In the hrtimer's
> > > > > > functions the FIFO not empty IRQ is enabled again.
> > > > >=20
> > > > > My rx path patches are working similarly though not 100% the same=
=2E I
> > > > > will adopt everything and add it to the next version of this seri=
es.
> > > > >=20
> > > > > >=20
> > > > > > I decided not to call the IRQ handler from the hrtimer to avoid
> > > > > > concurrency, but enable the FIFO not empty IRQ.
> > > > >=20
> > > > > mcan uses a threaded irq and I found this nice helper function I =
am
> > > > > currently using for the receive path.
> > > > > 	irq_wake_thread()
> > > > >=20
> > > > > It is not widely used so I hope this is fine. But this hopefully =
avoids
> > > > > the concurrency issue. Also I don't need to artificially create a=
n IRQ
> > > > > as you do.
> > > >=20
> > > > I think it's Ok to use the function. Which IRQs are enabled after y=
ou
> > > > leave the RX handler? The mcp251xfd driver enables only a high wate=
rmark
> > > > IRQ and sets up the hrtimer. Then we have 3 scenarios:
> > > > - high watermark IRQ triggers -> IRQ is handled,
> > > > - FIFO level between 0 and high water mark -> no IRQ triggered, but
> > > >   hrtimer will run, irq_wake_thread() is called, IRQ is handled
> > > > - FIFO level 0 -> no IRQ triggered, hrtimer will run. What do you d=
o in
> > > >   the IRQ handler? Check if FIFO is empty and enable the FIFO not e=
mpty
> > > >   IRQ?
> > >=20
> > > I am currently doing the normal IRQ handler run. It checks the
> > > "Interrupt Register" at the beginning. This register does not show the
> > > interrupts that fired, it shows the status. So even though the waterm=
ark
> > > interrupt didn't trigger when called by a timer, RF0N 'new message'
> > > status bit is still set if there is something new in the FIFO.
> >=20
> > That covers scenario 2 from above.
> >=20
> > > Of course it is the same for the transmit status bits.
> >=20
> > ACK - The TX complete event handling is a 95% copy/paste of the RX
> > handling.
> >=20
> > > So there is no need to read the FIFO fill levels directly, just the
> > > general status register.
> >=20
> > What do you do if the hrtimer fires and there's no CAN frame waiting in
> > the FIFO?
>=20
> Just enabling the 'new item' interrupt again and keep the hrtimer
> disabled.

Sounds good!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--etkcec3iq27txtcv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKBcUACgkQrX5LkNig
013bFwgAjGSBcuh+3Z40jY+SXlYNWGpoOmQ/P9qfi/oD4Z4qY70h8qg5SYu3AF+R
N7TDKnJ7qJWmjZP6l6wrCLzfN6GaFa9wqf6OX+/YkrR2LN9SXo53n10lQKXvujdb
0DivpJkhIyME8TnUUbMWkXDI4V1FVzu5Km4O9g0YneqF7QWhRcadXamHBtTl3uMe
HcFVzpEQSDxqhXMgZw6IqNng20Vhz6QZuW1TuLQPdhAELFW59Jk+rLmlHUsN6JSs
r7V/eXsZxjYHWQS4YNemykLBD8DiV2GHKldzhNAb5AVTfyo6aG39NalS+55IlRL/
6JHCvdbywX5VkwnmrC6ka4mIWk2b3A==
=6g/V
-----END PGP SIGNATURE-----

--etkcec3iq27txtcv--
