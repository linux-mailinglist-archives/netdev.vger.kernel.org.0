Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C35576A21
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiGOWqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiGOWq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:46:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDC01F8
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 15:46:27 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oCU4n-0005MP-Bh; Sat, 16 Jul 2022 00:46:25 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oCU4l-001CJG-G1; Sat, 16 Jul 2022 00:46:23 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oCU4k-005R1b-HB; Sat, 16 Jul 2022 00:46:22 +0200
Date:   Sat, 16 Jul 2022 00:46:19 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] wlcore/wl12xx: Drop if with an always false condition
Message-ID: <20220715224619.ht7bbzzrmysielm7@pengutronix.de>
References: <20220715103026.82224-1-u.kleine-koenig@pengutronix.de>
 <0c91388e-17a5-5304-d554-effb4bc4479a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4oso5kxt3yvpjyzq"
Content-Disposition: inline
In-Reply-To: <0c91388e-17a5-5304-d554-effb4bc4479a@gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4oso5kxt3yvpjyzq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The remove callback is only called after probe completed successfully.
In this case platform_set_drvdata() was called with a non-NULL argument
(in wlcore_probe()) and so wl is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
---
On Fri, Jul 15, 2022 at 09:00:42AM -0700, Florian Fainelli wrote:
> On 7/15/22 03:30, Uwe Kleine-K=F6nig wrote:
> > The remove callback is only called after probe completed successfully.
> > In this case platform_set_drvdata() was called with a non-NULL argument
> > (in wlcore_probe()) and so wl is never NULL.
> >=20
> > This is a preparation for making platform remove callbacks return void.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> The subject appears to have been borrowed from another file/subsystem.

Damn! Fixed here. Thanks for your feedback.

Best regards
Uwe

 drivers/net/wireless/ti/wl12xx/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/t=
i/wl12xx/main.c
index c6da0cfb4afb..d06a2c419447 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1924,13 +1924,10 @@ static int wl12xx_remove(struct platform_device *pd=
ev)
 	struct wl1271 *wl =3D platform_get_drvdata(pdev);
 	struct wl12xx_priv *priv;
=20
-	if (!wl)
-		goto out;
 	priv =3D wl->priv;
=20
 	kfree(priv->rx_mem_addr);
=20
-out:
 	return wlcore_remove(pdev);
 }
=20

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
--=20
2.36.1


--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--4oso5kxt3yvpjyzq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmLR7jgACgkQwfwUeK3K
7AlAYQf9E12hVBk3rLJgFei4XfZneUQtpiF0XmAOl6XwxnwOLIMDGG6k2V2TkFjP
fDUXc+itoEYACFOEr8IRIWxd5q90Ase2rlrm03U4rXqA8DxHq/6xwAuzqxVa1d1P
5RN71+6Hg0oskV8nO4BIe2ufN4FC+U+adQvUqcMuo9uXUGikLyT29OvngT6TZX26
DAQC42I44/DR+DJzJiNMcvTHos7PQ4ES+YbbLeJUEGS+OUYh07cj4oEy2CS/2yoU
CZJWCItLqRA5qjHepuGmeNkMprCvWVXDB+43TFb5iij4xPHmL7bjmYLu2i7fnYhp
j34DgNjRKbBWRs6i5nUsxasNR8MHjw==
=HJFt
-----END PGP SIGNATURE-----

--4oso5kxt3yvpjyzq--
