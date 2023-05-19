Return-Path: <netdev+bounces-3873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 381D170959A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C823B281C20
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED33A7487;
	Fri, 19 May 2023 11:00:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF66D3D72
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:00:41 +0000 (UTC)
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411DA19AD;
	Fri, 19 May 2023 04:00:24 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2af2958db45so270611fa.1;
        Fri, 19 May 2023 04:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494022; x=1687086022;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8HzmV/EeDYZAd/CQ0iL4Qog48xkS+m0Ot11dMlnkfWk=;
        b=lq4mmsZwnHP6gVL70/70n3IEu+qRUZxV6CrqxoWmz+p3PqhmSGSiLkcmDwIz3p8nnA
         FxljhyLOZURY+0yRe8FiBn7NIqMkNDyTm25WLh8RyawQ/j2VvypfuxHLa1p/md6kLet/
         z6sM7XmgbwGKibzPPAGdnxUVDV293ikW2jkktcrK0rk8V8N3Gu0dr/eBLrLMBvY55vSQ
         T1Xy8PehhET0azvS5z0pK0hEjeICzIMUC+vnruC9BKZtP+Het7FdEBQdDT2iefB6B3yh
         0IQicLkvYo6PIMdy0Qp2Zw8c21AImgXBUcSDeQaLyOBKaiqLt8TuLFAV5Qtfs0SlN8gm
         +auA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494022; x=1687086022;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8HzmV/EeDYZAd/CQ0iL4Qog48xkS+m0Ot11dMlnkfWk=;
        b=aS7xSY1PKgHva/yoeqhrDXms0bQawoVumIKUFcSfXVO3iAuFBo1Togz4c4FNNA2p9j
         BWytI1jL8WukQ7HcQGsfkVOmekSv8bcJAiU9sYZosQVVTZ84cSBQwwFkoRk2inlHSWJV
         Q2/fR0RJuiyRXTA7oyIyWW0KnNdYcaiHMXvsGh6mkAUPk29sKucN/IsHGWDIkqBzPWWZ
         MFIIYGfFE2YBaFxX1am7DJzuIYrXmap2IvLVD3JZqFnQ4J5/2bNRgNVHP4ROTXll0p2H
         rmMBz72GJ0Tq03/D6OIEWPxvS5hYny5ZepFkRMizHApH7zSyJtHK3iBliV/soZGhMUgH
         Km5w==
X-Gm-Message-State: AC+VfDw8fjMcklna+3MvixFlm/Q/X0WnV+1QJkdQYDHFSV30nE59JKtA
	elXij+Jw8L4VZGd/MejUYpk=
X-Google-Smtp-Source: ACHHUZ7+pbJy3k9uH6C/3QKxyqqHfaOoWdXRDl+dyMEzF1Svz3USEJ6WBcHYU1FvyB6JAnaRftDLGg==
X-Received: by 2002:a2e:99ca:0:b0:2af:1adf:d2ce with SMTP id l10-20020a2e99ca000000b002af1adfd2cemr595260ljj.52.1684494022071;
        Fri, 19 May 2023 04:00:22 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id t4-20020a2e9c44000000b002ad90280503sm763254ljj.138.2023.05.19.04.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:00:21 -0700 (PDT)
Date: Fri, 19 May 2023 14:00:12 +0300
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
Subject: [PATCH v5 0/8] fix fwnode_irq_get[_byname()] returnvalue
Message-ID: <cover.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BxFZ2ncJS53EetEw"
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--BxFZ2ncJS53EetEw
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
  iio: cdc: ad7150: Functional change
  i2c: i2c-smbus: fwnode_irq_get_byname() return value fix

 drivers/base/property.c                         | 12 +++++++++---
 drivers/i2c/i2c-smbus.c                         |  2 +-
 drivers/iio/cdc/ad7150.c                        |  3 +--
 drivers/iio/proximity/mb1232.c                  |  7 ++-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  4 ++--
 drivers/pinctrl/nuvoton/pinctrl-wpcm450.c       |  2 --
 drivers/pinctrl/pinctrl-ingenic.c               |  2 --
 drivers/pinctrl/pinctrl-pistachio.c             |  6 ------
 8 files changed, 15 insertions(+), 23 deletions(-)


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

--BxFZ2ncJS53EetEw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRnVrgACgkQeFA3/03a
ocXKfQf9FR4vRNiIHHmlud3RjASI1JLVQDy/8HiKbQnvk3cqblRFPxJ+8X2315MU
zLjfDm8PR/J4ojfgRUDxeTpwLAOwj5rl06FRy2+5Oa9kSNiUGr2PRP8gbnzJMHv7
80pWnylW1oDJpIT6l3Grrp4gTCYxVUKrMiZWHWofmPvv2znGFrIK3LuC4T/Sxk17
IQpAia0hdIpiPX9CeObO90+yjU7XyAW1ReOHk1H9VCBU5KM3HMy3IX6mjdEDY6OT
DLKOx5Q5sDa7hdFr49VvjmpWGFxCtC2a0qLMfz1usGgFBxWzAXMxTWSdVp09HKBu
cODupD9ML9av8AwAtAQZZYxOrHtUlg==
=iCN4
-----END PGP SIGNATURE-----

--BxFZ2ncJS53EetEw--

