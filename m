Return-Path: <netdev+bounces-2868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C96767045D5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C50951C20D56
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F227E11CB8;
	Tue, 16 May 2023 07:12:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C55234
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:12:14 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212D41AE;
	Tue, 16 May 2023 00:12:13 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f13bfe257aso15778066e87.3;
        Tue, 16 May 2023 00:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221131; x=1686813131;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GPjYHqvh0wAbW7+EmboW//QApPov+nEWDCvpi+IrMFE=;
        b=lvBWM/nKFobeJG+7xSVWzJCNApstZM0n0FmuI9OAwm5iB3uF/deR6kLocGUk3v+Roa
         g4Qsq6FgZ1ukQXoAbVUE98vR4OWxQbWdENeCPPiEUOTqbNUGrWJf72DRgh1Qcisn7GL+
         19ja10CoEgneWavU+4eXIYkAln2KsqBq7uD8PJHN7exfiiFncb/TvTMqQ+D30CkwQkCf
         Bn4dLQsdCKjrjIKaRBXcFwtUSvFBnlsa4w5MZkWxP6y+NbeIYm7W2t5MwitO5eVqGcV3
         CQXKlCiQRWpt+7VK/hon+ocVc6ClOSG00MJe0gcCrsZVNMUC3Ng+d+0dZ8jpfQdkueNQ
         Vyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221131; x=1686813131;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GPjYHqvh0wAbW7+EmboW//QApPov+nEWDCvpi+IrMFE=;
        b=Ddz40gnLiDUZsgnAUZQWTZYcReRLzn/dXvtdiaVAQPecgK1Kb+q3jSrk+u940f+UqP
         kofB8cgs/nanQX8/iVU/WEjZm+A2q30jidKt3lv+phdY/75cK+etg5m19+NL/cz2VwGi
         sBqTHna8gVfR10t4Lh83dat9CimNjZ+Ye71b6PT8oUn8ltyRtipMlLmiTXmmMNYppqus
         AdMJ40ZmsYKiuMILYPJIYXi3QLBthXPRHUGm8k0R0m9XrpuyGeQUNPXHBi7cMeWaXk/F
         TzrKR1gJUtPrupomsSgLP2kcIhljGayDrsl6FRkHH6KofkS42HsIlVb0BJ/brTdQCaK6
         TmAQ==
X-Gm-Message-State: AC+VfDwX9sRS6GxH1Ru5LfrvSrkG5WRaQ34l6opl9M8L02hu4PqwXsW0
	ungNqi11+jNMUccqfnVY8mM=
X-Google-Smtp-Source: ACHHUZ7E2RcDHhJ+/RI1O+0KKgNoTKtjrh7XnzYgDLitGQcQE1DPRlD/HktRWxggPXxFAWORRbIdww==
X-Received: by 2002:ac2:4156:0:b0:4eb:1294:983d with SMTP id c22-20020ac24156000000b004eb1294983dmr6992358lfi.7.1684221131041;
        Tue, 16 May 2023 00:12:11 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id o4-20020ac24944000000b004eeda2caa3fsm2863433lfi.55.2023.05.16.00.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:12:10 -0700 (PDT)
Date: Tue, 16 May 2023 10:12:03 +0300
From: Matti Vaittinen <mazziesaccount@gmail.com>
To: Matti Vaittinen <mazziesaccount@gmail.com>,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
	linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Subject: [PATCH v4 0/7] fix fwnode_irq_get[_byname()] returnvalue
Message-ID: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WelOJ0Zn8BeyKL7K"
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--WelOJ0Zn8BeyKL7K
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
will gain functional change as well. Here the logic is less
straightforward but boils down to the same question as with the
pinctrl-wpcm450.c. Should all the IRQ getting errors jump to same
'no-IRQ' branch as the DT mapping error, or should the DT mapping error
abort the probe with error same way as other IRQ getting failures do?

Revision history:
v3 =3D> v4:
 - Change also the fwnode_irq_get() as was suggested by Jonathan.
Changelog v2 =3D> v3:
 - rebase/resend/add kx022a fix.
Changelog v1 =3D> v2:
 - minor styling

---


Matti Vaittinen (7):
  drivers: fwnode: fix fwnode_irq_get[_byname]()
  iio: mb1232: relax return value check for IRQ get
  net-next: mb1232: relax return value check for IRQ get
  pinctrl: wpcm450: elax return value check for IRQ get
  pinctrl: ingenic: relax return value check for IRQ get
  pinctrl: pistachio: relax return value check for IRQ get
  iio: cdc: ad7150: Functional change

 drivers/base/property.c                         | 12 +++++++++---
 drivers/iio/cdc/ad7150.c                        |  3 +--
 drivers/iio/proximity/mb1232.c                  |  4 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  4 ++--
 drivers/pinctrl/nuvoton/pinctrl-wpcm450.c       |  2 --
 drivers/pinctrl/pinctrl-ingenic.c               |  2 --
 drivers/pinctrl/pinctrl-pistachio.c             |  6 ------
 7 files changed, 14 insertions(+), 19 deletions(-)


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

--WelOJ0Zn8BeyKL7K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLL8ACgkQeFA3/03a
ocW+eAf/eAorxcixdqdH6BPQNoS+5HpacF913piG5+0o3MHumPFHIGlWj1+KvBbg
ztw8jdSk2HV3DRNaXkbhxAoKFuuyvY2c5qdWWiHgfMFqBA/Bzhcu4sqAZMPXrRCC
XqZbVwQsvipUvCJI9MV2yr49vcHtm1Cvqb6Lrltt8S8myw/XCWVL8d4/TTH97xEp
E0Udc+Xa93MVanQ0VznV2tWaKN2FTuSfRWFs1jGcryqGHuJyk5EkttPFBp70x/Gb
kxLc/BWy4Q2fque6JFRCgCpo0B9RwwLuOyHMqX3kd1XTWV7XlZeO7hD/V5x7gCOA
CFaxXr0pUx/mCJ/QjYW6/gHnRMarQQ==
=o9VC
-----END PGP SIGNATURE-----

--WelOJ0Zn8BeyKL7K--

