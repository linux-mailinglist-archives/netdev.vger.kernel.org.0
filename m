Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E0836BFF5
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhD0HQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhD0HQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:16:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF899C061574
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 00:16:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lbHx0-0002Yq-DQ; Tue, 27 Apr 2021 09:16:06 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3096:2dba:77f2:d86d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CB116617B7D;
        Tue, 27 Apr 2021 07:16:04 +0000 (UTC)
Date:   Tue, 27 Apr 2021 09:16:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Patrick Menschel <menschel.p@posteo.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] can-isotp: Add error message if txqueuelen is too
 small
Message-ID: <20210427071603.gkq27ogz6ocgroov@pengutronix.de>
References: <20210427052150.2308-1-menschel.p@posteo.de>
 <20210427052150.2308-4-menschel.p@posteo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="go3puuwkybw3wygt"
Content-Disposition: inline
In-Reply-To: <20210427052150.2308-4-menschel.p@posteo.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--go3puuwkybw3wygt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.04.2021 05:21:49, Patrick Menschel wrote:
> This patch adds an additional error message in
> case that txqueuelen is set too small and
> advices the user to increase txqueuelen.
>=20
> This is likely to happen even with small transfers if
> txqueuelen is at default value 10 frames.
>=20
> Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
> ---
>  net/can/isotp.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 2075d8d9e..d08f95bfd 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -797,10 +797,12 @@ static enum hrtimer_restart isotp_tx_timer_handler(=
struct hrtimer *hrtimer)
>  		can_skb_set_owner(skb, sk);
> =20
>  		can_send_ret =3D can_send(skb, 1);
> -		if (can_send_ret)
> +		if (can_send_ret) {
>  			pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
>  				       __func__, ERR_PTR(can_send_ret));
> -
> +			if (can_send_ret =3D=3D -ENOBUFS)
> +				pr_notice_once("can-isotp: tx queue is full, increasing txqueuelen m=
ay prevent this error");

I've added the missing "\n" at the end while applying the patch to
linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--go3puuwkybw3wygt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCHujEACgkQqclaivrt
76mr8wf9EVENJ78T4lguUJ71dKwE6aqZrnqn++Ox6wQ0YDrR4H3lvUIYUI+pMdPj
iHiDFR24o7GCavl8IlYSn3kWerJde2Eu83fKbGTcPYmm8fwnz5rb4Faov6788+AP
POoDWA/xWy9jrv9hH/qKJzDThIYPO5F0h2SG6onKxd8DqH9fXgt7Kd/MPZvky8XO
2PAvunpoe4L+puALGd89lGruX4riudiYa4KhVqrAuq/bmpbunSqRndKvhkEjKu6K
JpimtWnrhXwuSYWZw5pSpVl51H0mxLZPUUeOnNNHyoLbe0zyR3mxXoYPdltVB/aS
foCp+x8x+qouMFD2hmW8kDtgYee/4Q==
=Y6Hk
-----END PGP SIGNATURE-----

--go3puuwkybw3wygt--
