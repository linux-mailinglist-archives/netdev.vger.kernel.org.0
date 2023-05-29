Return-Path: <netdev+bounces-5986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1381C714443
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 336B0280DD7
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505327FB;
	Mon, 29 May 2023 06:22:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4CD7E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:22:27 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CD9B1;
	Sun, 28 May 2023 23:22:24 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2af24ee004dso28985001fa.0;
        Sun, 28 May 2023 23:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341343; x=1687933343;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vOdzodRAM2H1nmvYMP9+2ZlCwspQLwnxmVWQ2MZpYPM=;
        b=hxzRRdX8heyI8wsSG3Y9gXKRDUBm+h6aiIzm2U4NbVJcF0PPnKUQd2BPlNJbZfVPc7
         rj9jYgzdEmjyhEmKiceZCYihYV2JUGLyKo5N/UwXjDxetguifQkcS1k7MiexOh4cb3Wm
         rVLzLGHpDbLhEjmwktDrHIljuSpGXt95JWP0djP/clnDnFvsqNWg8eLw9tVeB8WHTYFm
         uZ6rlZw91nPB5a3SdtsNW/19gS6JCeVgkpzd9vfV9bRk2XX1z4yzfst3M3DznMCPQMYj
         21jL4XTQfD/HyQB8TYRGy2QOYOyx5Iln/oXIrqJ/YIRqdreMXEIPA6oxUS+R8Sgvm7bs
         feag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341343; x=1687933343;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vOdzodRAM2H1nmvYMP9+2ZlCwspQLwnxmVWQ2MZpYPM=;
        b=YHFbanjSGF226sn1X/ZhY0M1X0pMuLr4Nq1aYRk9V+I6dcow81Vs2GpQ8Z4OXSbkAz
         sBqAllKaF3Nn06GBzvNbKOQbI+zaZ0t7ov+yrI8LWjjzGMK7Pw8JVQX/tjmnk4JShdlh
         7ZCQKNDyuKt33OO7DSGSh5J4vlOmngC4yyTtXOG8L9f+36l5yjzikvQMZ5/foqDy8FwS
         btN1Zz5BZguGS6c5ZHq9OMycDfEq8WcmlYRLDnBCDf00eScCpda1xoHPSZBzl7lJg4ru
         VIt5Ya7Lh59N8igDj+1ho0dvrSZxmLAyYrDdRn7VJJ/nY15hqo5ooX5ov7f4E2GFFLPP
         2EoQ==
X-Gm-Message-State: AC+VfDx0MgNv2JfLH/NgSA4wCBXhviU0IxwMU6tFlVMlytRvRA6n8W9E
	3xbuWNAYLH0+ws8Y+Ye0yGE=
X-Google-Smtp-Source: ACHHUZ6z/suHetYnUAr6zG+ImfzBn9sW+n3lS/7H9NuTh8pRvMhTDM6QOBiCNx7BcByzLFd44sKzWA==
X-Received: by 2002:a2e:8848:0:b0:2af:22a0:81ec with SMTP id z8-20020a2e8848000000b002af22a081ecmr3663644ljj.27.1685341342325;
        Sun, 28 May 2023 23:22:22 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id l19-20020a2e99d3000000b002a777ec77dcsm2303433ljj.34.2023.05.28.23.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:22:21 -0700 (PDT)
Date: Mon, 29 May 2023 09:22:15 +0300
From: Matti Vaittinen <mazziesaccount@gmail.com>
To: Matti Vaittinen <mazziesaccount@gmail.com>,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Wolfram Sang <wsa@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-iio@vger.kernel.org, netdev@vger.kernel.org,
	openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: [PATCH v7 0/9] fix fwnode_irq_get[_byname()] returnvalue
Message-ID: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ApeyYNQ5RiUDsQjW"
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--ApeyYNQ5RiUDsQjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The fwnode_irq_get() and the fwnode_irq_get_byname() may have returned
zero if mapping the IRQ fails. This contradicts the
fwnode_irq_get_byname() documentation. Furthermore, returning zero or
errno on error is unepected and can easily lead to problems
like:

int probe(foo)
{
=2E..
	ret =3D fwnode_irq_get_byname(...);
	if (ret < 0)
		return ret;
=2E..
}

or

int probe(foo)
{
=2E..
	ret =3D fwnode_irq_get_byname(...);
	if (ret <=3D 0)
		return ret;
=2E..
}

which are both likely to be wrong. First treats zero as successful call and
misses the IRQ mapping failure. Second returns zero from probe even though
it detects the IRQ mapping failure correvtly.

Here we change the fwnode_irq_get() and the fwnode_irq_get_byname() to
always return a negative errno upon failure.

I have audited following callers (v6.4-rc2):

fwnode_irq_get_byname():
drivers/i2c/i2c-smbus.c
drivers/iio/accel/adxl355_core.c
drivers/iio/accel/kionix-kx022a.c
drivers/iio/adc/ad4130.c
drivers/iio/adc/max11410.c
drivers/iio/addac/ad74115.c
drivers/iio/gyro/fxas21002c_core.c
drivers/iio/imu/adis16480.c
drivers/iio/imu/bmi160/bmi160_core.c
drivers/iio/imu/bmi160/bmi160_core.c

fwnode_irq_get():
drivers/gpio/gpio-dwapb.c
drivers/iio/chemical/scd30_serial.c
drivers/iio/proximity/mb1232.c
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
drivers/net/mdio/fwnode_mdio.c
drivers/pinctrl/pinctrl-ingenic.c
drivers/pinctrl/pinctrl-microchip-sgpio.c
drivers/pinctrl/pinctrl-pistachio.c

and it seems to me these calls will be Ok after the change. The
i2c-smbus.c and kionix-kx022a.c will gain a functional change (bugfix?) as
after this patch the probe will return -EINVAL should the IRQ mapping fail.
The series will also adjust the return value check for zero to be omitted.

NOTES:

Changes are compile-tested only.

drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
will also gain a functional change. The pinctrl-wpcm450.c change is easy
to see - after this series the device-tree mapping failures will be
handled as any other errors - probe will be aborted with -EINVAL. Other
feasible option could be treating other errors in IRQ getting same way
as the DT mapping failures - just silently skip the IRQ. Please see
comment in the respective patch.

drivers/iio/cdc/ad7150.c
Changed logic so that all the IRQ getting errors jump to the same
'no-IRQ' branch as the DT mapping error did.

Revision history:
v6 =3D> v7:
 - re-ordered patches per subsystem
 - mvpp2 - added a patch for not shadowing the return value
v5 =3D> v6:
 - iio: cdc: ad7150 - never abort probe if IRQ getting fails
v4 =3D> v5:
 - Fix subject lines for mvpp2 and wpcm450
 - drop unnecessary irqno assignment from mb1232
 - add back the drivers/i2c/i2c-smbus.c change which was accidentally
   dropped during v3 =3D> v4 work
v3 =3D> v4:
 - Change also the fwnode_irq_get() as was suggested by Jonathan.
Changelog v2 =3D> v3:
 - rebase/resend/add kx022a fix.
Changelog v1 =3D> v2:
 - minor styling

---

Matti Vaittinen (9):
  drivers: fwnode: fix fwnode_irq_get[_byname]()
  iio: mb1232: relax return value check for IRQ get
  iio: cdc: ad7150: relax return value check for IRQ get
  pinctrl: wpcm450: relax return value check for IRQ get
  pinctrl: ingenic: relax return value check for IRQ get
  pinctrl: pistachio: relax return value check for IRQ get
  i2c: i2c-smbus: fwnode_irq_get_byname() return value fix
  net-next: mvpp2: relax return value check for IRQ get
  net-next: mvpp2: don't shadow error

 drivers/base/property.c                         | 12 +++++++++---
 drivers/i2c/i2c-smbus.c                         |  2 +-
 drivers/iio/cdc/ad7150.c                        | 10 +++++-----
 drivers/iio/proximity/mb1232.c                  |  7 ++-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 12 ++++++------
 drivers/pinctrl/nuvoton/pinctrl-wpcm450.c       |  2 --
 drivers/pinctrl/pinctrl-ingenic.c               |  2 --
 drivers/pinctrl/pinctrl-pistachio.c             |  6 ------
 8 files changed, 23 insertions(+), 30 deletions(-)


base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
--=20
2.40.1


--=20
Matti Vaittinen, Linux device drivers
ROHM Semiconductors, Finland SWDC
Kiviharjunlenkki 1E
90220 OULU
FINLAND

~~~ "I don't think so," said Rene Descartes. Just then he vanished ~~~
Simon says - in Latin please.
~~~ "non cogito me" dixit Rene Descarte, deinde evanescavit ~~~
Thanks to Simon Glass for the translation =3D]=20

--ApeyYNQ5RiUDsQjW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RJMACgkQeFA3/03a
ocWMgggAnc9af0RzQuL4f2RCAa2y50+OtDNzSl89ig9U7EQvWU57mrBl/mDP9oVv
xL9/XLDRx1EWnl7fW+YM5Ju8ghuxOd9ydu5OQSFSdJ97yAJgZUTNMzyv8bBIjAcR
EdmkQg4UsPJTRoYd5QLTdy5p/Jo2y4rhcwcmX2qxxvXG6OLKwbHSII28be+ripkc
/Tdy33thGZ9uD3bkWELWD1suiTpcqRbqQAUpRMlEFBMwbKXAf0l9oqkMQHGfCNAD
xQp5tnVfOs6dziwhYA51scaRtMTh6eqkZiXmq47c3o03fmLTmiapo16NKPjpOdg+
3ege5LvaWKy6DhpZ7ckP5l2B5YMrpg==
=2yur
-----END PGP SIGNATURE-----

--ApeyYNQ5RiUDsQjW--

