Return-Path: <netdev+bounces-3878-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA8B7095C0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:03:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28E4F281C1A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009A579DB;
	Fri, 19 May 2023 11:02:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BEC7499
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:02:52 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607ED19A2;
	Fri, 19 May 2023 04:02:24 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f380cd1019so3693982e87.1;
        Fri, 19 May 2023 04:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494141; x=1687086141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HD7sDwjeUOhS/tu28skRBlZAs5C/+PALR8fkv0T+X84=;
        b=eijdIr5oXQZZmSbxyQ5q0NXx2PiSz0Y09n80SbfjV6RR0BJjjGnX9dwRUoI9cGDv/S
         orxI5273zbZm7bxK8XZsIYq+OE2D6VvfnWy5gWdoK260mX9rBg3jVliyZGFA1yugDcPc
         GRTRDwTBpUTLw659W1HUwZFgbOo+cQM30qgDnjWpRSMXN/5Alsf9p9DR32gimXgBn495
         /t4ojKTj1N7EmvnIcR9GaL0Rd6DUtrRkX7+mIGnGL0Px4JJqWRCGWiL6QDhQrpo0UQH6
         vHxJ+OMbjN8ONP92A0pNoVP4oa5ljVr4nJbm5A6B0R/nJg/r8z0n6Rasb55WSewYob/L
         Oixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494141; x=1687086141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HD7sDwjeUOhS/tu28skRBlZAs5C/+PALR8fkv0T+X84=;
        b=Zmz4n5cTJGAeqp3DcsxMusso3EMvXRqsbET1Hq9pdu5FZacZSGmHLVv5+9KosDWhxf
         HIArvJM18WbbsJEycMObEoZM9AuDUYoks88TMCuWo1qNQQSnyHRk3e+YDUth43o3B/DY
         JvBkDQ4HhgsAbB/BRe5nc0BcMY44e0ialOwMT566RAsIF4g1RqKj0JhCSlwiuEIMMclE
         1cwNcYb0rURw+YRYLj4GfbEmE16PzLZy8hilqJDQbSgx7KBT7/EbeI57+Onnk0tMMA1G
         OdcrOQ+2eSoXRZbo+BLO5nnWh5czoMOw84E+1ovGYJbgns/vmTnN1A66vJRR4BEIK8pX
         8pcA==
X-Gm-Message-State: AC+VfDz0IJF80vuGBzf5JyoBTWtYiiMXw1kuDrx9RvaOc/rALYYPzhHg
	hEB5GmdA4mgWJdKiEjgqhcw=
X-Google-Smtp-Source: ACHHUZ6u5g5R8jfey5qLxBfEbsi2trlh8URnopv6VaDE/U0+UiFkYXbLz0B5+gbKR7EvGEJQp57gEQ==
X-Received: by 2002:ac2:4949:0:b0:4ec:8e7e:46f1 with SMTP id o9-20020ac24949000000b004ec8e7e46f1mr685248lfi.66.1684494141204;
        Fri, 19 May 2023 04:02:21 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id c12-20020ac2530c000000b004f387d97dafsm565093lfh.147.2023.05.19.04.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:02:20 -0700 (PDT)
Date: Fri, 19 May 2023 14:02:16 +0300
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
Subject: [PATCH v5 4/8] pinctrl: wpcm450: relax return value check for IRQ get
Message-ID: <42264f1b12a91e415ffa47ff9adb53f02a6aa3ea.1684493615.git.mazziesaccount@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tTeOBa3AOzkey5Y+"
Content-Disposition: inline
In-Reply-To: <cover.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--tTeOBa3AOzkey5Y+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore. The
special error case where device-tree based IRQ mapping fails can't no
longer be reliably detected from this return value. This yields a
functional change in the driver where the mapping failure is treated as
an error.

The mapping failure can occur for example when the device-tree IRQ
information translation call-back(s) (xlate) fail, IRQ domain is not
found, IRQ type conflicts, etc. In most cases this indicates an error in
the device-tree and special handling is not really required.

One more thing to note is that ACPI APIs do not return zero for any
failures so this special handling did only apply on device-tree based
systems.

Drop the special (no error, just skip the IRQ) handling for DT mapping
failures as these can no longer be separated from other errors at driver
side.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Jonathan Neusch=E4fer <j.neuschaefer@gmx.net>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

---
Revision history:
v4 =3D> v5:
Fix typo in subject "elax" =3D> "relax"

Please note, I took Linus' reply to v4 cover-letter as ack && added the
tag. Please let me know if this was not Ok.

The special handling in this driver was added when fixing a problem
where returning zero from fwnode_irq_get[_byname]() was treated as
succes yielding zero being used as a valid IRQ by the driver.
f4a31facfa80 ("pinctrl: wpcm450: Correct the fwnode_irq_get() return value =
check")
The commit message does not mention if choosing not to abort the probe
on device-tree mapping failure (as is done on other errors) was chosen
because: a) Abort would have broken some existing setup. b) Because skipping
an IRQ on failure is "the right thing to do", or c) because it sounded like
a way to minimize risk of breaking something.

If the reason is a) - then I'd appreciate receiving some more
information and a suggestion how to proceed (if possible). If the reason
is b), then it might be best to just skip the IRQ instead of aborting
the probe for all errors on IRQ getting. Finally, in case of c), well,
by acking this change you will now accept the risk :)

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/pinctrl/nuvoton/pinctrl-wpcm450.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c b/drivers/pinctrl/nu=
voton/pinctrl-wpcm450.c
index 2d1c1652cfd9..f9326210b5eb 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
@@ -1106,8 +1106,6 @@ static int wpcm450_gpio_register(struct platform_devi=
ce *pdev,
 			irq =3D fwnode_irq_get(child, i);
 			if (irq < 0)
 				break;
-			if (!irq)
-				continue;
=20
 			girq->parents[i] =3D irq;
 			girq->num_parents++;
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

--tTeOBa3AOzkey5Y+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRnVzgACgkQeFA3/03a
ocUI7wgAykmnnbCV0d+6hECVJlXeaJz6qc/U6yb8DIOeP3Mx2BjegGSsJ0vtVlcZ
romo+yYHwqEg3VAjhggn4+lHZ/41mV3a+tYvDeMZ83fZMRHSflurOOcOIItTD11D
tnUqcJ39ryflGSv05EJ/o9sPCrUQNeoFX4skwZqYvcUA8Ihp6LQ/vPfV9RFMtg1K
1v3PqNiQFdvOCEX8WgfUHwDtY9vI2d4M6OYS1hV4iPh20LRUfsOn046RH0slxcGw
nShvwbSpTKgxOkb+XBZFuvbyttKEzSmKT7d/CN2OZvlA3tIEAB559mbbYtldka+c
SYDdN84zqMRFL894m6uBEBrLsIpveg==
=ND3t
-----END PGP SIGNATURE-----

--tTeOBa3AOzkey5Y+--

