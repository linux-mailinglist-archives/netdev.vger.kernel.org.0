Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D410554802B
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 09:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbiFMHLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 03:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiFMHLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 03:11:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73D46324
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 00:11:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o0eE0-0002iA-Tp; Mon, 13 Jun 2022 09:11:00 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D00E4938AD;
        Mon, 13 Jun 2022 07:10:58 +0000 (UTC)
Date:   Mon, 13 Jun 2022 09:10:58 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 05/13] can: netlink: dump bitrate 0 if
 can_priv::bittiming.bitrate is -1U
Message-ID: <20220613071058.h6bmy6emswh76q5s@pengutronix.de>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
 <20220612213927.3004444-6-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wqlpeg65xesvx6zf"
Content-Disposition: inline
In-Reply-To: <20220612213927.3004444-6-dario.binacchi@amarulasolutions.com>
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


--wqlpeg65xesvx6zf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.06.2022 23:39:19, Dario Binacchi wrote:
> Adding Netlink support to the slcan driver made it necessary to set the
> bitrate to a fake value (-1U) to prevent open_candev() from failing. In
> this case the command `ip --details -s -s link show' would print
> 4294967295 as the bitrate value. The patch change this value in 0.
>=20
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
>=20
> (no changes since v1)
>=20
>  drivers/net/can/dev/netlink.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
> index 7633d98e3912..788a6752fcc7 100644
> --- a/drivers/net/can/dev/netlink.c
> +++ b/drivers/net/can/dev/netlink.c
> @@ -505,11 +505,16 @@ static int can_fill_info(struct sk_buff *skb, const=
 struct net_device *dev)
>  	struct can_ctrlmode cm =3D {.flags =3D priv->ctrlmode};
>  	struct can_berr_counter bec =3D { };
>  	enum can_state state =3D priv->state;
> +	__u32 bitrate =3D priv->bittiming.bitrate;
> +	int ret =3D 0;
> =20
>  	if (priv->do_get_state)
>  		priv->do_get_state(dev, &state);
> =20
> -	if ((priv->bittiming.bitrate &&

What about changing this line to:

        if ((priv->bittiming.bitrate && priv->bittiming.bitrate !=3D -1 &&

This would make the code a lot cleaner. Can you think of a nice macro
name for the -1?

0 could be CAN_BITRATE_UNCONFIGURED or _UNSET. For -1 I cannot find a
catchy name, something like CAN_BITRATE_CONFIGURED_UNKOWN or
SET_UNKNOWN.

The macros can be added to bittiming.h and be part of this patch. Ofq
course the above code (and slcan.c) would make use of the macros instead
of using 0 and -1.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wqlpeg65xesvx6zf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKm4v8ACgkQrX5LkNig
012N+AgAufc0XxLRDeCmzKBduVV9FwFJOYJbL8GeEu0Z+ieKqhu1JFmtYUlhdz2P
Nyp+PAa6MktIkhdtqdn4hTSP6WvLIJzh6q6e5t1oD6iQ2qZHx8OjGYcPG+30sX4h
QU12t6LQeuczbgnwckZ88ISrrYk23SAfiIqC0Wqg9ub33Mftw1IFZokg7Jm9rfZm
8VZ9upwndUGMMCCnXiPkoCPvzM+kYLOR8E906bbU/xrnF2ZTaY0fGx81Zd7p45Fq
gFr3muZW/bhbRRzZ/RV5w2yiCuHWIo6n3sUpk3B8afZSYgR28zBtYacN9EUtB/jG
erc+pALb0wCES8YFwoy2qTMF+CPkqQ==
=nP2n
-----END PGP SIGNATURE-----

--wqlpeg65xesvx6zf--
