Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C204B646C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 08:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiBOHe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 02:34:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiBOHe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 02:34:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA949119434
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 23:34:18 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJsLZ-0005U6-Cc; Tue, 15 Feb 2022 08:34:01 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJsLW-00GhvR-Dz; Tue, 15 Feb 2022 08:33:57 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nJsLV-003I02-1a; Tue, 15 Feb 2022 08:33:57 +0100
Date:   Tue, 15 Feb 2022 08:33:48 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Mark Brown <broonie@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Joseph CHAMG <josright123@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the spi tree
Message-ID: <20220215073348.i5lkvd4ny46ecnzh@pengutronix.de>
References: <20220215130858.2b821de7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u4m62lh54wtt4to2"
Content-Disposition: inline
In-Reply-To: <20220215130858.2b821de7@canb.auug.org.au>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u4m62lh54wtt4to2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Feb 15, 2022 at 01:08:58PM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> drivers/net/ethernet/davicom/dm9051.c:1253:19: error: initialization of '=
void (*)(struct spi_device *)' from incompatible pointer type 'int (*)(stru=
ct spi_device *)' [-Werror=3Dincompatible-pointer-types]
>  1253 |         .remove =3D dm9051_drv_remove,
>       |                   ^~~~~~~~~~~~~~~~~
> drivers/net/ethernet/davicom/dm9051.c:1253:19: note: (near initialization=
 for 'dm9051_driver.remove')
>=20
> Caused by commit
>=20
>   a0386bba7093 ("spi: make remove callback a void function")
>=20
> interacting with commit
>=20
>   2dc95a4d30ed ("net: Add dm9051 driver")
>=20
> from the net-next tree.
>=20
> I applied the following merge resolution and can carry it until the
> trees are merged.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 15 Feb 2022 13:05:41 +1100
> Subject: [PATCH] fix up for "pi: make remove callback a void function"

s/"p/"sp/

> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/davicom/dm9051.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet=
/davicom/dm9051.c
> index cee3ff499fd4..d2513c97f83e 100644
> --- a/drivers/net/ethernet/davicom/dm9051.c
> +++ b/drivers/net/ethernet/davicom/dm9051.c
> @@ -1223,15 +1223,13 @@ static int dm9051_probe(struct spi_device *spi)
>  	return 0;
>  }
> =20
> -static int dm9051_drv_remove(struct spi_device *spi)
> +static void dm9051_drv_remove(struct spi_device *spi)
>  {
>  	struct device *dev =3D &spi->dev;
>  	struct net_device *ndev =3D dev_get_drvdata(dev);
>  	struct board_info *db =3D to_dm9051_board(ndev);
> =20
>  	phy_disconnect(db->phydev);
> -
> -	return 0;
>  }
> =20
>  static const struct of_device_id dm9051_match_table[] =3D {

The patch looks right, thanks.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--u4m62lh54wtt4to2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmILV1kACgkQwfwUeK3K
7AkEpAf+Pmr//MLYtKY++zlkbzlGqWAxEK1/8EYe0liDe9XWk4EB0d2VEyJTSzb9
dcYjnq9s7lCZVDEhbcKtiD2kA6AeVQpuvTqyKXuP5dFzR6FyEAlA6dbo4q13pZ8R
jW0M2+AT789xrXMPg45hUxDcq8rW8spp6xEGODIJA+0MANi9lZksbh8NwCMNBomg
hBMuPAhDMaUP+EkOqbIFYLz/Md59k9ezDsytnvVNWWkfeezTl2XDcZEz4hOW8MEM
3rD9/97Y1zA7mJsJ6XMxkaM01wGkiVshtoGP16vuDLUZF1InbAMfgfx16svjBvw3
uBSGSn5nVUvZwkz7MsjH5hXhUIzyUg==
=h7Il
-----END PGP SIGNATURE-----

--u4m62lh54wtt4to2--
