Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D488864083B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiLBOSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiLBOSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:18:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BE28658E
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 06:18:09 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p16rc-0007hV-3u; Fri, 02 Dec 2022 15:18:04 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 60B521316F4;
        Fri,  2 Dec 2022 14:18:02 +0000 (UTC)
Date:   Fri, 2 Dec 2022 15:17:56 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] can: tcan4x5x: Remove invalid write in
 clear_interrupts
Message-ID: <20221202141756.tmgn2brrzfxz3wio@pengutronix.de>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-13-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tjjtkhgzls42vba2"
Content-Disposition: inline
In-Reply-To: <20221116205308.2996556-13-msp@baylibre.com>
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


--tjjtkhgzls42vba2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.11.2022 21:53:05, Markus Schneider-Pargmann wrote:
> Register 0x824 TCAN4X5X_MCAN_INT_REG is a read-only register. Any writes
> to this register do not have any effect.
>=20
> Remove this write. The m_can driver aldready clears the interrupts in
> m_can_isr() by writing to M_CAN_IR which is translated to register
> 0x1050 which is a writable version of this register.
>=20
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Please add a fixes tag.

Marc

> ---
>  drivers/net/can/m_can/tcan4x5x-core.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_ca=
n/tcan4x5x-core.c
> index 41645a24384c..1fec394b3517 100644
> --- a/drivers/net/can/m_can/tcan4x5x-core.c
> +++ b/drivers/net/can/m_can/tcan4x5x-core.c
> @@ -204,11 +204,6 @@ static int tcan4x5x_clear_interrupts(struct m_can_cl=
assdev *cdev)
>  	if (ret)
>  		return ret;
> =20
> -	ret =3D tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_MCAN_INT_REG,
> -				      TCAN4X5X_ENABLE_MCAN_INT);
> -	if (ret)
> -		return ret;
> -
>  	ret =3D tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_INT_FLAGS,
>  				      TCAN4X5X_CLEAR_ALL_INT);
>  	if (ret)
> --=20
> 2.38.1
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tjjtkhgzls42vba2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKCRIACgkQrX5LkNig
010QRQgAlebC0+TGnpSKg603pRTk0d9B/O8c7/5XdIPh/LwjCzsvTEMqrf5htK+q
vtfGcWjxwYXXGpntx6xVfBR5gYrcfDMLeT90Xno6BoigsMdajRN7YAcJ0MjNY4EW
jZNhyotXhs+fU2eJv48+Z6y31qTyDLIMkmbu1EOjyzX5/qJbRdJ6wq5gFgBYkNFF
YaJnXWlWq3utr/FwXENNp5H3z6FwUmgb1i21tpLZabWxJijGFnf4ZXtqJXmP1iN6
k0jsjqD+uvIUdkFSPRU69CfUjBpnTi07Zfmx6S0x19RJp9F4P3ZKIPq7XfSgvKTF
GYFHmf1dGNiVKOUZvoGePApB/+T7lQ==
=Nb9w
-----END PGP SIGNATURE-----

--tjjtkhgzls42vba2--
