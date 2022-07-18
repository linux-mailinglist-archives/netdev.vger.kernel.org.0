Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2243577F8B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiGRKW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbiGRKWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:22:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111201CB0E
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 03:22:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oDNt8-0005wx-Nk; Mon, 18 Jul 2022 12:22:06 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 393DBB2FA4;
        Mon, 18 Jul 2022 10:22:04 +0000 (UTC)
Date:   Mon, 18 Jul 2022 12:22:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] can: slcan: send the listen-only command to the
 adapter
Message-ID: <20220718102203.66y6glwwphptl2tu@pengutronix.de>
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
 <20220716170007.2020037-6-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4nsvjzfaopo7e7xv"
Content-Disposition: inline
In-Reply-To: <20220716170007.2020037-6-dario.binacchi@amarulasolutions.com>
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


--4nsvjzfaopo7e7xv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The subject can be enhanced, as the listen-only command ist not send
unconditionally. What about: "add support for listen-only mode"?

On 16.07.2022 19:00:07, Dario Binacchi wrote:
> In case the bitrate has been set via ip tool, this patch changes the
> driver to send the listen-only ("L\r") command to the adapter.

=2E..but only of CAN_CTRLMODE_LISTENONLY is requested.

What about:

For non-legacy, i.e. ip based configuration, add support for listen-only
mode. If listen-only is requested send a listen-only ("L\r") command
instead of an open ("O\r") command to the adapter..

>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>=20
> ---
>=20
>  drivers/net/can/slcan/slcan-core.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/s=
lcan-core.c
> index 7a1540507ecd..d97dfeccbf9c 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c
> @@ -711,10 +711,21 @@ static int slcan_netdev_open(struct net_device *dev)
>  			}
>  		}
> =20
> -		err =3D slcan_transmit_cmd(sl, "O\r");
> -		if (err) {
> -			netdev_err(dev, "failed to send open command 'O\\r'\n");
> -			goto cmd_transmit_failed;
> +		/* listen-only command overrides open command */

I think this comment can be removed.

> +		if (sl->can.ctrlmode & CAN_CTRLMODE_LISTENONLY) {
> +			err =3D slcan_transmit_cmd(sl, "L\r");
> +			if (err) {
> +				netdev_err(dev,
> +					   "failed to send listen-only command 'L\\r'\n");
> +				goto cmd_transmit_failed;
> +			}
> +		} else {
> +			err =3D slcan_transmit_cmd(sl, "O\r");
> +			if (err) {
> +				netdev_err(dev,
> +					   "failed to send open command 'O\\r'\n");
> +				goto cmd_transmit_failed;
> +			}
>  		}
>  	}
> =20
> @@ -801,6 +812,7 @@ static int slcan_open(struct tty_struct *tty)
>  	/* Configure CAN metadata */
>  	sl->can.bitrate_const =3D slcan_bitrate_const;
>  	sl->can.bitrate_const_cnt =3D ARRAY_SIZE(slcan_bitrate_const);
> +	sl->can.ctrlmode_supported =3D CAN_CTRLMODE_LISTENONLY;
> =20
>  	/* Configure netdev interface */
>  	sl->dev	=3D dev;

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4nsvjzfaopo7e7xv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLVNEkACgkQrX5LkNig
012yiAf/dGen9psExLJTBHVKRd8PVYM/EWn+11BslLLEHxOLS9C1m3B4aNBF1HsP
9B6YEnuijYPU+Kze6CgDdEI36vLBP/Pn61fVx307mI5kqkTbnS9+uDZjeDRe8t6+
cBlzqSzT/1qsWTIwIaZ5dtxq/alB+OQIws5WvOXWdMYBTniAdp8M/INTjuL5qkmf
5+JD4he5R1lDC749qIHFsvHGlLirj+PtaIZXBTnzUjnwpWilemo291BOt3auI7ZF
XX/yZqrxTNfbUAfxxuuDu+Jg7NHn2rywVGzbIsfPtKqY1d/9+soymY0IpYoWIR1O
T4ioad3fmnIALPn0BzUm3yeQBgm03w==
=f4B2
-----END PGP SIGNATURE-----

--4nsvjzfaopo7e7xv--
