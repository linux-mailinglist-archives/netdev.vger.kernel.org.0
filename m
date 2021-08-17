Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593343EEA2A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhHQJns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbhHQJnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:43:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70530C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 02:43:14 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFvcj-0006iv-Rp; Tue, 17 Aug 2021 11:43:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:dc61:eeed:d4a6:acca])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C046B668D72;
        Tue, 17 Aug 2021 09:43:07 +0000 (UTC)
Date:   Tue, 17 Aug 2021 11:43:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Message-ID: <20210817094306.iyezzml6m7nlznri@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
 <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
 <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <CAMZ6RqK0vTtCkSM7Lim2TQCZyYTYvKYsFVwWDnyNaFghwqToXg@mail.gmail.com>
 <20210816143052.3brm6ny26jy3nbkq@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cq7vy33mil2ht6ci"
Content-Disposition: inline
In-Reply-To: <20210816143052.3brm6ny26jy3nbkq@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cq7vy33mil2ht6ci
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.08.2021 16:30:52, Marc Kleine-Budde wrote:
> > Finally, I did a bit of research and found that:
> > http://ww1.microchip.com/downloads/en/DeviceDoc/Section_56_Controller_A=
rea_Network_with_Flexible_Data_rate_DS60001549A.pdf

> > This is *not* the mcp25xxfd datasheet but it is still from
> > Microship and as you will see, it is mostly similar to the
> > mcp25xxfd except for, you guessed it, the TDCO.
> >=20
> > It reads:
> > | TDCMOD<1:0>: Transmitter Delay Compensation Mode bits
> > | Secondary Sample Point (SSP).
> > | 10 =3D Auto; measure delay and add CFDxDBTCFG.TSEG1; add TDCO
> > | 11 =3D Auto; measure delay and add CFDxDBTCFG.TSEG1; add TDCO
> > | 01 =3D Manual; Do not measure, use TDCV plus TDCO from the register
> > | 00 =3D Disable
> >=20
> > | TDCO<6:0>: Transmitter Delay Compensation Offset bits
> > | Secondary Sample Point (SSP). Two's complement; offset can be
> > positive, zero, or negative.
> > | 1111111 =3D -64 x SYSCLK
> > | .
> > | .
> > | .
> > | 0111111 =3D 63 x SYSCLK
> > | .
> > | .
> > | .
> > | 0000000 =3D 0 x SYSCLK
> >=20
> > Here, you can clearly see that the TDCO has the exact same range
> > as the one of the mcp25xxfd but the description of TDCMOD
> > changes, telling us that:
> >=20
> > | SSP =3D TDCV (measured delay) + CFDxDBTCFG.TSEG1 (sample point) + TDCO
> >=20
> > Which means this is a relative TDCO.

Good catch! Microchip is investigating this.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cq7vy33mil2ht6ci
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEbhKcACgkQqclaivrt
76mRUwf/WqgGXJS5FJYsgXeQ9DB2ao8JrxXEawnFdtnwp+LzoU6Xa8+NOrcwaDE/
74ZFUhUVOoA/gl06bwixPLrBuFt9XVCa7uJEU7fnUdKAFl99LN4F1l6dGIT1gQ3l
Iqtl/bOhwYGVRqyOH5sXTzF/kWrBny14xoGFUk+QtNwgaGGQ2vmvZ/Cx518xJnSd
sQNdxGK9z71oYf8lqUndIJO/zdQGRgJtABVCCanRRTtoeYf52U+pdMUmo/I/2CX9
AHP+hCR2yCDU+R93/SMwQH0RDFQvSUZ3YsP7ANO7ROzGLaeXhdM79gA1DiOClXK6
bLLjwDxvRhoJwmHMDc6DGrOWCfL+3g==
=DOw1
-----END PGP SIGNATURE-----

--cq7vy33mil2ht6ci--
