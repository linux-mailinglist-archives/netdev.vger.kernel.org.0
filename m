Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2781E6BA230
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCNWPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjCNWO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:14:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E7B1C5B3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 15:14:19 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcCtn-0007Gi-5o; Tue, 14 Mar 2023 23:13:39 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcCtk-004AGM-Qq; Tue, 14 Mar 2023 23:13:36 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pcCtk-004vFt-4a; Tue, 14 Mar 2023 23:13:36 +0100
Date:   Tue, 14 Mar 2023 23:13:34 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>, Wei Fang <wei.fang@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/9] net: fec: Don't return early on error in
 .remove()
Message-ID: <20230314221334.hvmkowycpyz4juqg@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
 <20230313103653.2753139-3-u.kleine-koenig@pengutronix.de>
 <e84585f2-e3d9-4a87-bfd4-a9ba458553b9@lunn.ch>
 <20230313162141.vkhyz77u44wxq4vn@pengutronix.de>
 <d16568e8-9ec8-4c4b-bbee-9d585c772c4b@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y3ecgobhcmvpfgvu"
Content-Disposition: inline
In-Reply-To: <d16568e8-9ec8-4c4b-bbee-9d585c772c4b@lunn.ch>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y3ecgobhcmvpfgvu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 14, 2023 at 01:30:35AM +0100, Andrew Lunn wrote:
> > > > -	ret =3D pm_runtime_resume_and_get(&pdev->dev);
> > > > -	if (ret < 0)
> > > > -		return ret;
> > > regulator_disable() probably does actually work because that is a
> > > different hardware block unaffected by the suspend.
> =20
> > fec_suspend() calls
> >=20
> >         if (fep->reg_phy && !(fep->wol_flag & FEC_WOL_FLAG_ENABLE))
> >                 regulator_disable(fep->reg_phy);
>=20
> There are two different types of suspend here.
>=20
> pm_runtime_resume_and_get() is about runtime suspend. It calls
> fec_runtime_suspend() which just turns some clocks off/on.

Oh indeed.

I won't resend this series in this cycle with this issue fixed.
Converting all other drivers to .remove_new() will take quite some time
I guess so there is no pressure. If you apply patches 1, 3, 5 - 9 anyhow
that would be great. (Patch 4 depends on this one.) I'll address the fec
driver at a later point in time.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--y3ecgobhcmvpfgvu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmQQ8YsACgkQwfwUeK3K
7AnjswgAivXSyICTINtMMoDLPh+nerdGkAe2AK2TA3wLX/PIiWaAsrP5AJdw9q7A
XJGEXImdeZLBcQtnLZeA4jHBIeuLGPY0sN9JpjI4WP2fkKGm3wP8Sfa4goNA34X9
QcrMU7gBV+Tz5DJCHhdYoPmszgVrJR8awPaz1emRlFdv6XZpKXNAv7TF6QQ0IiUh
5R7YS3lSWZN1+r4HClHRCKrVW7ExK4ulSR4aqXawRXLFn3ognPinuxRYxBna/gJU
MRU3Xwf56V6/zjfylBwAqUfM4kt9mbSWXB+W77kiyTHUujkWnkwx1JcO28eUStc8
yD9v4E0QCLp+COohptawts1tH7rADQ==
=H4cE
-----END PGP SIGNATURE-----

--y3ecgobhcmvpfgvu--
