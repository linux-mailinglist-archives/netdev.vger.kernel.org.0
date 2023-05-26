Return-Path: <netdev+bounces-5524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBD5712007
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 733681C20FB9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E7820E6;
	Fri, 26 May 2023 06:35:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355D17E
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:35:05 +0000 (UTC)
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789809C;
	Thu, 25 May 2023 23:35:02 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2af225e5b4bso3554111fa.3;
        Thu, 25 May 2023 23:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685082901; x=1687674901;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WcJOZerpXi8ObNNdTOUnt4O1FT4NXUTLaczmvwBX9kY=;
        b=HVYhbWH5FxmTZOP2RMUrEJwk3Y0kEqphdgwS15BCu42Lky/My2LAi4wwia4SLV8YcJ
         mdm81Bz2O0IXaDRhXxvnveeisdQWSHMWIX2pegSlrMwAZj1IpscNMYGbEPqVXdZZ/fXL
         8rdyrYgZN7YL3+N1o8IgtpYUapJ0HQB0WJRmODtuK4x3Il7MJffIj/8VyVHNzPbLebqS
         CoIECfRgwC+AB6cAjht7/Be+xBIUDU0WWvIVt6z2xCJvQpc0JFlES13g7UH0jBOvc+KT
         7ckzmE2I90dOYJe3tJ5lCxUlol1anJgnsohxJXS17JLGgWg0xNhUCeNcm4hXx1PbLRSQ
         d28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685082901; x=1687674901;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcJOZerpXi8ObNNdTOUnt4O1FT4NXUTLaczmvwBX9kY=;
        b=e6MeaPydNNk6WrKAsT17x1tm4qCcVutjg7lKIjJDywBZV8RyvPm9GmYJGkh4VYGmwm
         rJHpix17v+li4IoB2ZyDYflnGQ0wz+E8ZcVyEz1wfhh4HUht6hEEA/L2U4niGCOw+n2/
         sSbJt7uNaVOJF3tL7WIPTCurH3P0h/zndZTPivAOOjpwGjzj/Vjuard2rrTTaMdB94EL
         utKlsTunK9DLrAVlH9Iq0mxsCzlH0Cg8zrfi3WAQNxXK6M83S67S1sUYQv1XusVCrNcB
         9eRXI+HJw+kWWSFuXlAMmJd4nDEf3+tJliH22dGMtMmw69fIlzX0eXwsnWeoEEGjf2s7
         WM6A==
X-Gm-Message-State: AC+VfDxbTigxdnoI7cFeJBdrlkZ+LNg2XX89q4Mf+eeMj9m8GWZc1mAK
	NYaNmGef20Eg6JfpTJlnICEoNB/5GpY=
X-Google-Smtp-Source: ACHHUZ4DJBxQQEa/1VeMXLnR0qOMEbRktLB7HCgdxnCUjBh/7NEMEMVin+iGP9WqpmCOXNgp3rHlCg==
X-Received: by 2002:a2e:8e88:0:b0:2ac:7a77:1d4e with SMTP id z8-20020a2e8e88000000b002ac7a771d4emr387558ljk.24.1685082900374;
        Thu, 25 May 2023 23:35:00 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id f19-20020a2ea0d3000000b002a8bc2fb3cesm562896ljm.115.2023.05.25.23.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:34:59 -0700 (PDT)
Date: Fri, 26 May 2023 09:34:48 +0300
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
Subject: [PATCH v6 0/8] fix fwnode_irq_get[_byname()] returnvalue
Message-ID: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BIdqUJjNRoUB+WL6"
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--BIdqUJjNRoUB+WL6
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

Matti Vaittinen (8):
  drivers: fwnode: fix fwnode_irq_get[_byname]()
  iio: mb1232: relax return value check for IRQ get
  net-next: mvpp2: relax return value check for IRQ get
  pinctrl: wpcm450: relax return value check for IRQ get
  pinctrl: ingenic: relax return value check for IRQ get
  pinctrl: pistachio: relax return value check for IRQ get
  iio: cdc: ad7150: relax return value check for IRQ get
  i2c: i2c-smbus: fwnode_irq_get_byname() return value fix

 drivers/base/property.c                         | 12 +++++++++---
 drivers/i2c/i2c-smbus.c                         |  2 +-
 drivers/iio/cdc/ad7150.c                        | 10 +++++-----
 drivers/iio/proximity/mb1232.c                  |  7 ++-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  4 ++--
 drivers/pinctrl/nuvoton/pinctrl-wpcm450.c       |  2 --
 drivers/pinctrl/pinctrl-ingenic.c               |  2 --
 drivers/pinctrl/pinctrl-pistachio.c             |  6 ------
 8 files changed, 19 insertions(+), 26 deletions(-)


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

--BIdqUJjNRoUB+WL6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwUwQACgkQeFA3/03a
ocXAagf/SATcFgxl0jKSBaNOTF/+28Pno+TjHp9Sdo/8Ymwrg9L9edhW7FpovyWA
5ErMPmzMs7zSKg6b9ThVlNqVX0ApH/9sVsrZZ5+xh3TapswoYLPPngUxSV2JC6cF
+Dq5A7qKkcHV5nQVQgW3tI/e7E0xybH3LNit2KaF3xgVFjfrJZ00Wx2R+j0N0JrG
WjRQ12FUGQ7fa5W52qG9/P3aFDC1L9kQL0peEAhA6PLuIdiX86tMkp0eh7n2Ni90
O28ZvVRC1lL+xeTxhW3QvtrxiT4EgxfbGiDgHGJ+nAJdGblViNXYFbqJXGcI+n70
R9znRQPe0WUgM2XzsU9mp/1w9qdxFg==
=GMUh
-----END PGP SIGNATURE-----

--BIdqUJjNRoUB+WL6--

