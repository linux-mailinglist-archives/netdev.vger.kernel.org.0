Return-Path: <netdev+bounces-5993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B2E714482
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42034280DF9
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCB47FC;
	Mon, 29 May 2023 06:24:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516EF7E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:24:51 +0000 (UTC)
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEF3EC;
	Sun, 28 May 2023 23:24:22 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f4f89f71b8so1195419e87.3;
        Sun, 28 May 2023 23:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341457; x=1687933457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gMGKMQ5heIZqIPqdt41yF6tIdWNRsHLiOnUodPGYbyg=;
        b=pxhc4f3yCvamPD7Ifu2P05204ThyP/GqLYqkRq9erG7F4i888mn2SRGiMB4/jXDDJs
         mMtR2pdV5Iu319rSLAotcbz3Nvl0JZDSH9LA+kB30vDyQTsSsuUGMtPj93W4q87S+4pC
         E0HrnmuZEbxpo0J4V/nCB2I+BjSfaQ9S4zbdQlgkdbbUF3KQQcncex3ETuLc/wWposG+
         xhgTCu7pFYi+LN6Zp2K5n36EDGKluVAMhJZMA1G/xxf9Ex2gyz9uUQJXb7neWn0VuMMC
         QaGVz6c4ONzIPiPLnG2o/OIiJ6GBbu/YiHLN6UjmAohe0ekLfI5qAwIqWdiWc1XuABIc
         eCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341457; x=1687933457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMGKMQ5heIZqIPqdt41yF6tIdWNRsHLiOnUodPGYbyg=;
        b=RTVL6ZcX8FQ0Nf+AIYVa2OKO0v3QDJUVkj2GxFOnVjhu4JeS1LuGEjFNs/Pj8qRwFR
         YVH7qVfSR/z1O0/92bDJBxLu3Aw9bB6ZFzO+UltzUJIJ38Ye7ADjbqKXSz502EvRlOXE
         hIiuYHr/WmE8iqw3SCBwrt3Mhr2NuU60hxRtp+U8UkV3hh/2YXNtkTpHUYNfPMaBTFQC
         PSFKQJ1SSDvGfA50x0MQVgAabjdW/v/apufpOJH5NtTTHZpzHcG1ccX8XvOFWJorccV9
         MHVA5+Cosh+ab7X0l+Y2YioimPLt/VBgnh0lREAEeVdxirQCeWXJABdxxmEbKfe5EyAl
         SgYg==
X-Gm-Message-State: AC+VfDzsl0zjX3MYspWHszLPt7CmpUFW79sSHUDfBQxntWG6TaOK3y3y
	PiUPRHASyTlLSqqd0ZIZq7c=
X-Google-Smtp-Source: ACHHUZ7Zh6z2ke5UbYWZOvOrsExI7SxqLEdFdCNeOv4MdD+rb76OPi6JznRKt4oahaSfgpjTXZ1yTw==
X-Received: by 2002:ac2:4855:0:b0:4f3:b6b8:dabb with SMTP id 21-20020ac24855000000b004f3b6b8dabbmr3311641lfy.13.1685341456877;
        Sun, 28 May 2023 23:24:16 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id w9-20020ac24429000000b004f4ce1d4df6sm1844987lfl.47.2023.05.28.23.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:24:16 -0700 (PDT)
Date: Mon, 29 May 2023 09:24:12 +0300
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
Subject: [PATCH v7 7/9] i2c: i2c-smbus: fwnode_irq_get_byname() return value
 fix
Message-ID: <73a0af48bffe99a9d4b94b1f986258021eea6182.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="I7qKH4leGOxrES6S"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--I7qKH4leGOxrES6S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The fwnode_irq_get_byname() was changed to not return 0 upon failure so
return value check can be adjusted to reflect the change.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
Revision history:
v5 =3D>:
 - No changes
v4 =3D> v5:
 - Added back after this was accidentally dropped at v4.

Depends on the mentioned return value change which is in patch 1/N. The
return value change does also cause a functional change here. Eg. when
IRQ mapping fails, the fwnode_irq_get_byname() no longer returns zero.
This will cause also the probe here to return nonzero failure. I guess
this is desired behaviour - but I would appreciate any confirmation.

Please, see also previous discussion here:
https://lore.kernel.org/all/fbd52f5f5253b382b8d7b3e8046134de29f965b8.166671=
0197.git.mazziesaccount@gmail.com/

Another suggestion has been to drop the check altogether. I am slightly
reluctant on doing that unless it gets confirmed that is the "right
thing to do".
---
 drivers/i2c/i2c-smbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 138c3f5e0093..893fe7cd3e41 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -129,7 +129,7 @@ static int smbalert_probe(struct i2c_client *ara)
 	} else {
 		irq =3D fwnode_irq_get_byname(dev_fwnode(adapter->dev.parent),
 					    "smbus_alert");
-		if (irq <=3D 0)
+		if (irq < 0)
 			return irq;
 	}
=20
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

--I7qKH4leGOxrES6S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RQwACgkQeFA3/03a
ocW6cAgAkc2IQ4oT3YwVX8CdTPI4OMUX/+qJD/12QGLgIlLmpI7lTZvNlcxHq4Y6
1dB05vHijMtOdx5sM/m8HEC2kKnGihOH8yphwjfzjY6tDll9TAlERxBqdRv+R4QD
hwMfMnuThrWSHdapSRT66awvr664s7RNzwrO4F6aOn5ZpHxhwXiS9zhDN7ZFOht2
ahl9F1+ddkNs1GpitdycHV6H3m1f+XQEqrKXwnngtD+0qszeCiiR2KgzCH8Z1Fk4
84Y9g0p39Te9UcE7ey52/eIvV4M/xeI5hPITY4B6hSb+1ctK71pqITUDmxgaFvqV
XV00SLsoGzTqK7m8Kt5j8cFYAkoMMQ==
=+h1W
-----END PGP SIGNATURE-----

--I7qKH4leGOxrES6S--

