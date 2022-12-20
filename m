Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54AD651CD3
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLTJHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiLTJHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:07:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905431836A
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:07:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p7YZ4-0002Et-EN; Tue, 20 Dec 2022 10:05:34 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:8d35:355:a4c0:ddb8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 760C2143A12;
        Tue, 20 Dec 2022 09:05:33 +0000 (UTC)
Date:   Tue, 20 Dec 2022 10:05:25 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Frank Jungclaus <frank.jungclaus@esd.eu>,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
Message-ID: <20221220090525.tvmgmtffmy7ruyi3@pengutronix.de>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
 <20221219212717.1298282-2-frank.jungclaus@esd.eu>
 <CAMZ6RqKMSGpxBbgfD6Q4DB9V0EWmzXknUW6btWudtjDu=uF4iQ@mail.gmail.com>
 <CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l2o3hyqitwoctluq"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com>
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


--l2o3hyqitwoctluq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.12.2022 17:53:28, Vincent MAILHOL wrote:
> > >  struct tx_msg {
> > > @@ -229,10 +237,10 @@ static void esd_usb_rx_event(struct esd_usb_net=
_priv *priv,
> > >         u32 id =3D le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
> > >
> > >         if (id =3D=3D ESD_EV_CAN_ERROR_EXT) {
> > > -               u8 state =3D msg->msg.rx.data[0];
> > > -               u8 ecc =3D msg->msg.rx.data[1];
> > > -               u8 rxerr =3D msg->msg.rx.data[2];
> > > -               u8 txerr =3D msg->msg.rx.data[3];
> > > +               u8 state =3D msg->msg.rx.ev_can_err_ext.status;
> > > +               u8 ecc =3D msg->msg.rx.ev_can_err_ext.ecc;
> > > +               u8 rxerr =3D msg->msg.rx.ev_can_err_ext.rec;
> > > +               u8 txerr =3D msg->msg.rx.ev_can_err_ext.tec;
> >
> > I do not like how you have to write msg->msg.rx.something. I think it
> > would be better to make the union within struct esd_usb_msg anonymous:
> >
> >   https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/es=
d_usb.c#L169
>=20
> Or maybe just declare esd_usb_msg as an union instead of a struct:

+1

>   union esd_usb_msg {
>           struct header_msg hdr;
>           struct version_msg version;
>           struct version_reply_msg version_reply;
>           struct rx_msg rx;
>           struct tx_msg tx;
>           struct tx_done_msg txdone;
>           struct set_baudrate_msg setbaud;
>           struct id_filter_msg filter;
>   };

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--l2o3hyqitwoctluq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOhetIACgkQrX5LkNig
012WuQf+IkVianuuTf4emi0PthBoG9enYth6Nfh6yWTLf0lV3jR5vcMvxG8yumAm
zx1cOZCy5lJmn+TWdEAuqGl7Pe4jC+JNsoZSDMe/2psnH9EVwMonpQFkC5LLi1vt
7+6zDZRHV6xxbAvu4m3cZaGFrWpYFSmUubbXZdnrrvw2TNbX7vMAC5oRXOv6Bio5
3yAX5F7Ax6sKiG/YmkrzaqxlvFWwhu2VT4L4qInKAW0D7ePx7V+IWZ1muKaNUV+j
LqFUqQlAaHJ3CFTkbXaSfw2Y+wGonZ+9mmuPz7j9hUM9PUIATlUAfDrAsbv5y+NZ
c1g2LnpW73YZndeI7oPwqfCf/Tb+Eg==
=9Pzh
-----END PGP SIGNATURE-----

--l2o3hyqitwoctluq--
