Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBFF531AAC
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiEWUMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiEWUM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:12:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66BE996BF
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 13:12:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ntEPY-0003cB-VL; Mon, 23 May 2022 22:12:17 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 860FC848F3;
        Mon, 23 May 2022 20:12:15 +0000 (UTC)
Date:   Mon, 23 May 2022 22:12:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, wg@grandegger.com, linux-can@vger.kernel.org
Subject: Re: [PATCH net-next] can: kvaser_usb: silence a GCC 12
 -Warray-bounds warning
Message-ID: <20220523201214.b5lhtarbi47my725@pengutronix.de>
References: <20220520194659.2356903-1-kuba@kernel.org>
 <20220523121425.y5ca3ok5r2hxgh7j@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mlw57ziusiqrvcbj"
Content-Disposition: inline
In-Reply-To: <20220523121425.y5ca3ok5r2hxgh7j@pengutronix.de>
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


--mlw57ziusiqrvcbj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.05.2022 14:14:25, Marc Kleine-Budde wrote:
> On 20.05.2022 12:46:59, Jakub Kicinski wrote:
> > This driver does a lot of casting of smaller buffers to
> > struct kvaser_cmd_ext, GCC 12 does not like that:
> >=20
> > drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:489:65: warning: arra=
y subscript =E2=80=98struct kvaser_cmd_ext[0]=E2=80=99 is partly outside ar=
ray bounds of =E2=80=98unsigned char[32]=E2=80=99 [-Warray-bounds]
> > drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:489:23: note: in expa=
nsion of macro =E2=80=98le16_to_cpu=E2=80=99
> >   489 |                 ret =3D le16_to_cpu(((struct kvaser_cmd_ext *)c=
md)->len);
> >       |                       ^~~~~~~~~~~
> >=20
> > Temporarily silence this warning (move it to W=3D1 builds).
> >=20
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > Hi Marc, are you planning another -next PR? Can we take this
> > directly?
>=20
> Thanks, applied and I'll send a -next PR soonish.

Available here:

https://lore.kernel.org/all/20220523201045.1708855-1-mkl@pengutronix.de/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mlw57ziusiqrvcbj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKL6pwACgkQrX5LkNig
0115agf/UCbc4ykniN1rstVdPQRfqBMqgjz1QyIQRHdeug/RQbp4Misr7gasmV5n
18Wx9rvwVKQzJ4o9rZWmAzTZ0FPkItPCmtOh1gXJqGUVqSI15Kbo/gZ4K5PaEzA4
5sOxYtDIxG9x06r5zCG9pwQpUeAYVbMkdK1v3NYEaHnarRTyXmQRkRce9OBodGki
lEgQhk0FIptnfGcP52QGO72xGDDrR2iky7l0j8nzYwU6b408otbI144P+IH3IQI6
n8nUyC0MTwkFihFqC1By7UcmUE6wXIogPdnoW+oQaNzq1Wa1O/N233ZX3LvpZneX
cvCqonfbJtGux7joEf/PRVNUJgWU6w==
=4sxA
-----END PGP SIGNATURE-----

--mlw57ziusiqrvcbj--
