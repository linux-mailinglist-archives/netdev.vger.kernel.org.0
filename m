Return-Path: <netdev+bounces-4174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E101470B77A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3A8A1C209D5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A278D79F4;
	Mon, 22 May 2023 08:20:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9293479EA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:20:00 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D24B6
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 01:19:59 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q10lk-0000SG-Ab; Mon, 22 May 2023 10:19:52 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 68B9D1C9699;
	Mon, 22 May 2023 08:13:07 +0000 (UTC)
Date: Mon, 22 May 2023 10:13:06 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc: Frank Jungclaus <frank.jungclaus@esd.eu>, linux-can@vger.kernel.org,
	Wolfgang Grandegger <wg@grandegger.com>,
	Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] can: esd_usb: Make use of existing kernel macros
Message-ID: <20230522-shine-attitude-09ec9aefce64-mkl@pengutronix.de>
References: <20230519195600.420644-1-frank.jungclaus@esd.eu>
 <20230519195600.420644-2-frank.jungclaus@esd.eu>
 <CAMZ6Rq+V4HRLa2bzADnsvaKHuCwi6O5jKo39mhon_+OnMDEJbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2cbxal2xzghzgpqi"
Content-Disposition: inline
In-Reply-To: <CAMZ6Rq+V4HRLa2bzADnsvaKHuCwi6O5jKo39mhon_+OnMDEJbQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--2cbxal2xzghzgpqi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.05.2023 18:16:13, Vincent MAILHOL wrote:
> Thanks for the patch.
>=20
> On Sat. 20 May 2023 at 04:57, Frank Jungclaus <frank.jungclaus@esd.eu> wr=
ote:
> > Make use of existing kernel macros:
> > - Use the unit suffixes from linux/units.h for the controller clock
> > frequencies
> > - Use the BIT() and the GENMASK() macro to set specific bits in some
> >   constants
> > - Use CAN_MAX_DLEN (instead of directly using the value 8) for the
> > maximum CAN payload length
> >
> > Additionally:
> > - Spend some commenting for the previously changed constants
> > - Add the current year to the copyright notice
> > - While adding the header linux/units.h to the list of include files
> > also sort that list alphabetically
> >
> > Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
> > Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVS=
DFmqpd++aBzZQg@mail.gmail.com/
> > Link: https://lore.kernel.org/all/CAMZ6RqKdg5YBufa0C+ttzJvoG=3D9yuti-8A=
mthCi4jBbd08JEtw@mail.gmail.com/
> > Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Link: https://lore.kernel.org/all/20230518-grower-film-ea8b5f853f3e-mkl=
@pengutronix.de/
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > ---
> >  drivers/net/can/usb/esd_usb.c | 40 ++++++++++++++++++-----------------
> >  1 file changed, 21 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index d33bac3a6c10..32354cfdf151 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -3,19 +3,20 @@
> >   * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
> >   *
> >   * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias=
 Fuchs <socketcan@esd.eu>
> > - * Copyright (C) 2022 esd electronics gmbh, Frank Jungclaus <frank.jun=
gclaus@esd.eu>
> > + * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <fran=
k.jungclaus@esd.eu>
> >   */
> > +#include <linux/can.h>
> > +#include <linux/can/dev.h>
> > +#include <linux/can/error.h>
> > +
> >  #include <linux/ethtool.h>
> > -#include <linux/signal.h>
> > -#include <linux/slab.h>
> >  #include <linux/module.h>
> >  #include <linux/netdevice.h>
> > +#include <linux/signal.h>
> > +#include <linux/slab.h>
> > +#include <linux/units.h>
> >  #include <linux/usb.h>
> >
> > -#include <linux/can.h>
> > -#include <linux/can/dev.h>
> > -#include <linux/can/error.h>
> > -
> >  MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
> >  MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
> >  MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and =
CAN-USB/Micro interfaces");
> > @@ -27,8 +28,8 @@ MODULE_LICENSE("GPL v2");
> >  #define USB_CANUSBM_PRODUCT_ID 0x0011
> >
> >  /* CAN controller clock frequencies */
> > -#define ESD_USB2_CAN_CLOCK     60000000
> > -#define ESD_USBM_CAN_CLOCK     36000000
> > +#define ESD_USB2_CAN_CLOCK     (60 * MEGA) /* Hz */
> > +#define ESD_USBM_CAN_CLOCK     (36 * MEGA) /* Hz */
> >
> >  /* Maximum number of CAN nets */
> >  #define ESD_USB_MAX_NETS       2
> > @@ -42,20 +43,21 @@ MODULE_LICENSE("GPL v2");
> >  #define CMD_IDADD              6 /* also used for IDADD_REPLY */
> >
> >  /* esd CAN message flags - dlc field */
> > -#define ESD_RTR                        0x10
> > +#define ESD_RTR        BIT(4)
> > +
> >
> >  /* esd CAN message flags - id field */
> > -#define ESD_EXTID              0x20000000
> > -#define ESD_EVENT              0x40000000
> > -#define ESD_IDMASK             0x1fffffff
> > +#define ESD_EXTID      BIT(29)
> > +#define ESD_EVENT      BIT(30)
> > +#define ESD_IDMASK     GENMASK(28, 0)
> >
> >  /* esd CAN event ids */
> >  #define ESD_EV_CAN_ERROR_EXT   2 /* CAN controller specific diagnostic=
 data */
> >
> >  /* baudrate message flags */
> > -#define ESD_USB_UBR            0x80000000
> > -#define ESD_USB_LOM            0x40000000
> > -#define ESD_USB_NO_BAUDRATE    0x7fffffff
> > +#define ESD_USB_LOM    BIT(30) /* 0x40000000, Listen Only Mode */
> > +#define ESD_USB_UBR    BIT(31) /* 0x80000000, User Bit Rate (controlle=
r BTR) in bits 0..27 */
>                                      ^^^^^^^^^^
>=20
> As pointented by Marc, no need for redundant comment with the hexadecimal=
 value.

Fixed while applying.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--2cbxal2xzghzgpqi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRrJBAACgkQvlAcSiqK
BOgE6wf9EQrIh6qzY5Yb9XkZa4oiqJ5fvfCG3f8pY/pJk2Jr5XqsJE7oC4eoANpG
zoHN/dQoKr7MzRCLJx4rXc47zPuOOF5BertZPX4Q/fnqDOJtLcdVQsbi5Nt0dVMO
m1PU2uf4Ts53L7RQZYV8eZSO5FvZx1HSrw8Dwn9zXtwFENwuqWZ1f1oDfw2DuRvb
ecDvfwvbmde8dxRlVuOS3XrBYN9FerOX19yn/o+yfjLrLjZSOoRtf7ZZ989JDxQP
Qtrti1U/0aUSZEG1uS7kPo59kR71rNPMtvqhrTwlpip2wxyXhkks6QAv18cMsLX5
/pe4a6NeYvS2os2En/JKtxM2+b0d7g==
=4YTh
-----END PGP SIGNATURE-----

--2cbxal2xzghzgpqi--

