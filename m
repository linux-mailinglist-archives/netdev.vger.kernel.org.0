Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C3B3F4AC9
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 14:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbhHWMiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 08:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbhHWMiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 08:38:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01825C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 05:37:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mI9Cb-0007g8-I4; Mon, 23 Aug 2021 14:37:21 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-5f1f-6edb-8f7f-ac9e.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:5f1f:6edb:8f7f:ac9e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D09D366D61D;
        Mon, 23 Aug 2021 12:37:16 +0000 (UTC)
Date:   Mon, 23 Aug 2021 14:37:15 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, wg@grandegger.com, kuba@kernel.org,
        kevinbrace@bracecomputerlab.com, romieu@fr.zoreil.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] can: mscan: mpc5xxx_can: Use
 of_device_get_match_data to simplify code
Message-ID: <20210823123715.j4khoyld5mfl6kdv@pengutronix.de>
References: <20210823113338.3568-1-tangbin@cmss.chinamobile.com>
 <20210823113338.3568-4-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tzba5ik5srkh4lwi"
Content-Disposition: inline
In-Reply-To: <20210823113338.3568-4-tangbin@cmss.chinamobile.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tzba5ik5srkh4lwi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.08.2021 19:33:38, Tang Bin wrote:
> Retrieve OF match data, it's better and cleaner to use
> 'of_device_get_match_data' over 'of_match_device'.
>=20
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Thanks for the patch!

LGTM, comment inside.

> ---
>  drivers/net/can/mscan/mpc5xxx_can.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/=
mpc5xxx_can.c
> index e254e04ae..3b7465acd 100644
> --- a/drivers/net/can/mscan/mpc5xxx_can.c
> +++ b/drivers/net/can/mscan/mpc5xxx_can.c
> @@ -279,7 +279,6 @@ static u32 mpc512x_can_get_clock(struct platform_devi=
ce *ofdev,
>  static const struct of_device_id mpc5xxx_can_table[];
>  static int mpc5xxx_can_probe(struct platform_device *ofdev)
>  {
> -	const struct of_device_id *match;
>  	const struct mpc5xxx_can_data *data;
>  	struct device_node *np =3D ofdev->dev.of_node;
>  	struct net_device *dev;
> @@ -289,10 +288,9 @@ static int mpc5xxx_can_probe(struct platform_device =
*ofdev)
>  	int irq, mscan_clksrc =3D 0;
>  	int err =3D -ENOMEM;
> =20
> -	match =3D of_match_device(mpc5xxx_can_table, &ofdev->dev);
> -	if (!match)
> +	data =3D of_device_get_match_data(&ofdev->dev);
> +	if (!data)
>  		return -EINVAL;

Please remove the "BUG_ON(!data)", which comes later.

> -	data =3D match->data;
> =20
>  	base =3D of_iomap(np, 0);
>  	if (!base) {
> --=20
> 2.20.1.windows.1
>=20
>=20
>=20
>=20

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tzba5ik5srkh4lwi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEjlnkACgkQqclaivrt
76lOCgf+KYF+o99Kg2iOCfI60mHHeBPkPjnzLl7AFALXMjkAiWjh9nL0c3mybPpU
XkVqIxlJ1OEXOLdHXNhsguxrPMLrampXYBgLajVcQQH1EWj0p9Ty2bqth6NptZXz
hOcKIltTJ04uOwsHcziYt54EsE7RlOcoAN+y1/aQCDd6GF+tC7Vm9g3QwukpLEcT
ZvaDPa+CwljvPznAjB77QSfJMPwcl8ggh4Y9wS2aQZkVKbuecgN7PGMIa2NxrlWH
g9XyFKWpXa1Gl7+fubXpgCLhcPqK1B8Hstjd3nonh2qJjA0GJYzvdaMvYc2FnWPz
O6WExKQvp89qzAGfKhyKL1tyoZdChw==
=Dg0F
-----END PGP SIGNATURE-----

--tzba5ik5srkh4lwi--
