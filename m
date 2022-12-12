Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB198649D20
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiLLLIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiLLLHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:07:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8EC11A27
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:54:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4gSN-0002mj-Jm; Mon, 12 Dec 2022 11:54:47 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8EEEB13CAB7;
        Mon, 12 Dec 2022 10:54:45 +0000 (UTC)
Date:   Mon, 12 Dec 2022 11:54:44 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/11] can: tcan4x5x: Specify separate read/write
 ranges
Message-ID: <20221212105444.cdzzh2noebni4ibj@pengutronix.de>
References: <20221206115728.1056014-1-msp@baylibre.com>
 <20221206115728.1056014-12-msp@baylibre.com>
 <20221206162001.3cgtod46h5d5j7fx@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3rteq2xa2oylivtz"
Content-Disposition: inline
In-Reply-To: <20221206162001.3cgtod46h5d5j7fx@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3rteq2xa2oylivtz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.12.2022 17:20:01, Marc Kleine-Budde wrote:
> On 06.12.2022 12:57:28, Markus Schneider-Pargmann wrote:
> > Specify exactly which registers are read/writeable in the chip. This
> > is supposed to help detect any violations in the future.
> >=20
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > ---
> >  drivers/net/can/m_can/tcan4x5x-regmap.c | 43 +++++++++++++++++++++----
> >  1 file changed, 37 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/=
m_can/tcan4x5x-regmap.c
> > index 33aed989e42a..2b218ce04e9f 100644
> > --- a/drivers/net/can/m_can/tcan4x5x-regmap.c
> > +++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
> > @@ -90,16 +90,47 @@ static int tcan4x5x_regmap_read(void *context,
> >  	return 0;
> >  }
> > =20
> > -static const struct regmap_range tcan4x5x_reg_table_yes_range[] =3D {
> > +static const struct regmap_range tcan4x5x_reg_table_wr_range[] =3D {
> > +	/* Device ID and SPI Registers */
> > +	regmap_reg_range(0x000c, 0x0010),
>=20
> According to "Table 8-8" 0xc is RO, but in "8.6.1.4 Status (address =3D
> h000C) [reset =3D h0000000U]" it clearly says it has write 1 to clear bits
> :/.
>=20
> > +	/* Device configuration registers and Interrupt Flags*/
> > +	regmap_reg_range(0x0800, 0x080c),
> > +	regmap_reg_range(0x0814, 0x0814),
>=20
> 0x814 is marked as reserved in "SLLSEZ5D =E2=80=93 JANUARY 2018 =E2=80=93=
 REVISED JUNE
> 2022"?

I'll take the series as is, that can be fixed later.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3rteq2xa2oylivtz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOXCHIACgkQrX5LkNig
0120KggAkN4OUsrNTLFWq1jMkdTM8pWyFQL6+qMdyj6s/2w4twsnGswb1AuHDusQ
GOimVUVfHp8DEZyteY/wacTb81I+t4zsQPPE9msXmPBYxIXUaLO6dX8tS2r/OeN3
7reH0FvhL0yA90FVBvGkx7Cpb81l68HoYOEBGAy71gMlzRNC7dPf79ao1zou7jN1
QrzH1JWSOBBMQlaPDezGQ+TpmDOPC3e1l4anl5QuYequV4Zj+iqktsr1Ni74tdFa
+dkoBfHjiW5e56sHoy193CN93muxED3BXXD7pf7eW+WVEjBbQnrgTrrWLq59WtGO
MAezafgjNn1sd6O67Vc33A1RWyGEPQ==
=Jm6J
-----END PGP SIGNATURE-----

--3rteq2xa2oylivtz--
