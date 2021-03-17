Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA76833EB44
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCQISx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhCQISl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 04:18:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD60C06175F
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 01:18:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lMRNy-00086C-7B; Wed, 17 Mar 2021 09:18:34 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:31e3:6e40:b1cd:40a8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 244F65F736C;
        Wed, 17 Mar 2021 08:18:32 +0000 (UTC)
Date:   Wed, 17 Mar 2021 09:18:31 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-can@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        davem@davemloft.net
Subject: Re: [BUG] Re: [net 3/6] can: flexcan: invoke flexcan_chip_freeze()
 to enter freeze mode
Message-ID: <20210317081831.osalrszbje4oofoh@pengutronix.de>
References: <20210301112100.197939-1-mkl@pengutronix.de>
 <20210301112100.197939-4-mkl@pengutronix.de>
 <65137c60-4fbe-6772-6d48-ac360930f62b@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="of2tyaqxqtda5bhf"
Content-Disposition: inline
In-Reply-To: <65137c60-4fbe-6772-6d48-ac360930f62b@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--of2tyaqxqtda5bhf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.03.2021 17:00:25, Ahmad Fatoum wrote:
> > --- a/drivers/net/can/flexcan.c
> > +++ b/drivers/net/can/flexcan.c
> > @@ -1480,10 +1480,13 @@ static int flexcan_chip_start(struct net_device=
 *dev)
> > =20
> >  	flexcan_set_bittiming(dev);
> > =20
> > +	/* set freeze, halt */
> > +	err =3D flexcan_chip_freeze(priv);
> > +	if (err)
> > +		goto out_chip_disable;
>=20
> With v5.12-rc3, both my FlexCAN controllers on an i.MX6Q now divide by ze=
ro
> on probe because priv->can.bittiming.bitrate =3D=3D 0 inside of flexcan_c=
hip_freeze.
>=20
> Reverting this patch fixes it.

A fix for this in on its way to net/master:

https://lore.kernel.org/linux-can/20210316082104.4027260-6-mkl@pengutronix.=
de/

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--of2tyaqxqtda5bhf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBRu1QACgkQqclaivrt
76nzJQgAlqMdzIBp25Sj4mIOKbe6LSUNo3yG/72y7Syx+amxcN4pSvok6ROfVA1k
fXaqw873lEPWa4jYHKNtGG7ClCEx3ZBxN+XoJ6fDH98IeUnYK0Mhl/0/yLaiLo59
FzWS9Tx2HuT+G6R4Lc58oeQtoWTQXutCJRqdmQmBG3IpTkgCXr8HQH+OttTl+kq7
PWTqF87dGqasNWDJjzOCDxltSPqSaQVx4UtjkP3rgJCY8dZPIIM+Fo3UUOtB6LoR
wcoEQ4pW1dzWBhKv/uWhY/XIB+MWTfnj7VPbSEQMxZHFon6mxZqh70ds8owXHbIW
ZjOyozFQWFviyQCyXHm1klFk6tHQBA==
=SR11
-----END PGP SIGNATURE-----

--of2tyaqxqtda5bhf--
