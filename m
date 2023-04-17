Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549636E40D2
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjDQH0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjDQH0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:26:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B3844A6
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 00:26:35 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1poJFh-0006hA-8x; Mon, 17 Apr 2023 09:26:17 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0A8271B04D6;
        Mon, 17 Apr 2023 07:26:14 +0000 (UTC)
Date:   Mon, 17 Apr 2023 09:26:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230417-taking-relieving-f2c8532864c0-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
 <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
 <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
 <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
 <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="f6bxkwneko5oxwq5"
Content-Disposition: inline
In-Reply-To: <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--f6bxkwneko5oxwq5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.04.2023 21:46:40, Oliver Hartkopp wrote:
> > I had the 5ms that are actually used in the code in mind. But this is a
> > good calculation.
>=20
> @Judith: Can you acknowledge the value calculation?
>=20
> > > The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame with =
DLC =3D 0
> > > and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit =3D=
> ~50
> > > usecs
> > >=20
> > > So it should be something about
> > >=20
> > >      50 usecs * (FIFO queue len - 2)
> >=20
> > Where does the "2" come from?
>=20
> I thought about handling the FIFO earlier than it gets completely "full".
>=20
> The fetching routine would need some time too and the hrtimer could also
> jitter to some extend.

I was assuming something like this.

I would argue that the polling time should be:

    50 =C2=B5s * FIFO length - IRQ overhead.

The max IRQ overhead depends on your SoC and kernel configuration.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--f6bxkwneko5oxwq5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ89JIACgkQvlAcSiqK
BOj1QAf8C3XM8k07BC2j8JyiAa7udtivyxZJ8HO2LKeVF312gm8khfUIMOo06Sqp
jW+3LndAnjaby9ahmfPCWHwPPdF6X1xWJhH+JUCFTeM6C7JBdtKjSkFcVx2o69ot
ZgMQnqOaxunKcnm2EOTOSsP9P2PLNzjm0MD0Nf+soV9PYgMdLfl/oKjZRMqQFbG/
yMMZ40JaMt9kzwZSE9d6YE/EfygUmHmYQERz3OXGMhKVLMEe0CrOOKV+goEXvJfP
SOg+kCqU14RzDC8fzJMk8Ju1bgICmQksIvHAH05hbuCctWjhePYHINx3kF8JZut+
yJP8lWEBWlsf+uGi7oINsvn6ZTY4WA==
=3slR
-----END PGP SIGNATURE-----

--f6bxkwneko5oxwq5--
