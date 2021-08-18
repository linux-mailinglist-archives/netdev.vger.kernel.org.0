Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3465D3EFF69
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbhHRIn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238656AbhHRInx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:43:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDC6C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 01:43:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGHAI-0008Ur-Vx; Wed, 18 Aug 2021 10:43:15 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:ed04:8488:5061:54d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 98574669912;
        Wed, 18 Aug 2021 08:43:13 +0000 (UTC)
Date:   Wed, 18 Aug 2021 10:43:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/7] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210818084312.6i5buvdp7hsu4kmy@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-6-mailhol.vincent@wanadoo.fr>
 <20210817195551.wwgu7dnhb6qyvo7n@pengutronix.de>
 <CAMZ6RqLj94UU_b8dDAzinVsLaV6pBR-cWbHmjwGhx3vfWiKt_g@mail.gmail.com>
 <20210818081934.6f23ghoom2dkv53m@pengutronix.de>
 <CAMZ6Rq+PPH8mCayZg1ghftfoU8_y8rzAtO=Of2F5VZxcBKn4KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3r4tcmh4k4j2lcbt"
Content-Disposition: inline
In-Reply-To: <CAMZ6Rq+PPH8mCayZg1ghftfoU8_y8rzAtO=Of2F5VZxcBKn4KA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3r4tcmh4k4j2lcbt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.08.2021 17:37:17, Vincent MAILHOL wrote:
> > It's not a race. Consider this command:
> >
> > | ip up tdc-mode manual tdco 111 tdcv 33  # 111 is out of range, 33 is =
valid
> >
> > tdcv is checked first and valid, then it's assigned to the priv->tdc.
> > tdco is checked second and invalid, then can_tdc_changelink() returns -=
EINVAL.
> >
> > tdc ends up being half set :(
> >
> > So the setting of tdc is inconsistent and when you do a "ip down" "ip
> > up" then it results in a tdco=3D0 tdcv=3D33 mode=3Dmanual.
>=20
> My bad. Now I understand the issue.
> I was confused because tdco=3D111 is in the valid range of my driver...

:D

> I will squash your patch.
>=20
> Actually, I think that there is one more thing which needs to be
> fixed: If can_tdc_changelink() fails (e.g. value out of range),
> the CAN_CTRLMODE_TDC_AUTO or CAN_CTRLMODE_TDC_MANUAL would still
> be set, meaning that can_tdc_is_enabled() would return true. So I
> will add a "fail" branch to clear the flags.

Ok.

regard,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3r4tcmh4k4j2lcbt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEcyB0ACgkQqclaivrt
76kHAwgAm3PmoaSEpiGOXV7SOe2m3Km3x1QNacwkyJQNM15E7ciWzSbAzVwzS/bJ
YRVEp4iEF1Ez3mqt9YbtIA+YxhEoFihyVLeUtRLaEkdei0b/kOWq+fLkOM96K5Ne
g2LG5jhCBiVsbIOUOq992DI1bvfYsQmQK7k8hqoDwsQNPJ80lGz25vtCNBfbPA+y
GJH+waf5Y1QoX32rejo9oCFhObhn9nZxedwbRKCMR2Q/huShoLNFTtz7f0ItOIIk
Yjcsqca/CXMr8Sf/LZ+IjKa8jTZNOv/S76ZxiR9aMy3lx1XrMOUmAIWECeUHjayL
K0pFwH2G04ORKlTEa4NwrJdfvCWp9Q==
=SLOE
-----END PGP SIGNATURE-----

--3r4tcmh4k4j2lcbt--
