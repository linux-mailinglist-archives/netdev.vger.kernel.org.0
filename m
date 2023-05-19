Return-Path: <netdev+bounces-3883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A207095E0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADE6B28123A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98EF883E;
	Fri, 19 May 2023 11:05:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5AB7487
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:05:12 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C471989;
	Fri, 19 May 2023 04:04:51 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f37b860173so3472773e87.2;
        Fri, 19 May 2023 04:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494288; x=1687086288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4GNHUsSQZ7XOoZjUlNt5CHQChxGAHRFnKC6pLJgQnQ0=;
        b=D0X5HOiVrJHBnxegjwyw/Nwh7o5gPNfAfErjqsfy5ahtnMEqu5oZqONT/g8kr/rQyJ
         rj3EWCKKu0TiHK2CKBLACXgC8HUnAeLSJfIt/E+mVJ1oelJAfkqzNRep/6Jfbo1+Of+g
         y3yTKfiYAe+KbwfvI/2B1kvH+QN6uIViVwUJ4crxuHrpf1Sz3l4rJZxtjysdLx721hr0
         IibNnCsGQfZ1NNYhdu+dg7tn2JAA0HCMzzXixZReXUhyEVge93GaEenwv22FszQPNdwJ
         F5exYECbCaxHwXFwQ3epapOAJzKJZBLsy2caGUMjrUfxDkojkLVl5rubkARn7tXGt7/e
         fYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494288; x=1687086288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4GNHUsSQZ7XOoZjUlNt5CHQChxGAHRFnKC6pLJgQnQ0=;
        b=feFUbsCKK9ubzjoWuu4rIJWB2BhN/jgKHauxoynLIwkYVhxSXyEImFwehvYQ0vOp1A
         q3l0TJwDHsoTH3wZuOWS/XFpaPtbd7nwPgJ/olXbCFcvcHFHQ6LGzJh3cjXleUBUbAoW
         K0BGLferdur6tGxUP1yKqcA60wailFJhJiniN7G+kzrzwULKLYUJ5+71OliLPq73zkIS
         k/outzQa28UQEQ5Na2HS4SEfHAN5eftUvjLXPcvDFbmGWmKLYb3zlBeSKfLbpS272j+B
         LgwgxcrqUO0Ofe3UsyZkgYKdkGO+SFow9lAh+UXb/l7OCurfLc4ylvIL1q6NnzvNXpSP
         1xIg==
X-Gm-Message-State: AC+VfDwn5JOE7ecbqJjZbU0Kiyvw8oac5aVIH3NMgeROMThclIhoFBcb
	5Selx/bo5h7lCEpe0mJ3wWI=
X-Google-Smtp-Source: ACHHUZ6UTSaftFeK3PA13GKVCxEp/y7Yw4bieoWTl+HfrNQijtyPdtc4WLzKvYG93aZ4rATGZFoGkw==
X-Received: by 2002:ac2:5dd7:0:b0:4ec:8245:3986 with SMTP id x23-20020ac25dd7000000b004ec82453986mr744208lfq.14.1684494288048;
        Fri, 19 May 2023 04:04:48 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id i13-20020a056512006d00b004ece331c830sm557641lfo.206.2023.05.19.04.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:04:47 -0700 (PDT)
Date: Fri, 19 May 2023 14:04:32 +0300
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
Subject: [PATCH v5 7/8] iio: cdc: ad7150: relax return value check for IRQ get
Message-ID: <73c633ccab80bdfaa1adf6ae099cfc9d365be6a2.1684493615.git.mazziesaccount@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p5zyaIGk3sdCqhT/"
Content-Disposition: inline
In-Reply-To: <cover.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--p5zyaIGk3sdCqhT/
Content-Type: text/plain; charset=us-ascii
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

Drop the special handling for DT mapping failures as these can no longer
be separated from other errors at driver side.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---

Please note that I don't have the hardware to test this change.
Furthermore, testing this type of device-tree error cases is not
trivial, as the question we probably dive in is "what happens with the
existing users who have errors in the device-tree". Answering to this
question is not simple.

I did this patch with minimal code changes - but a question is if we
should really jump into the else branch below on all IRQ getting errors?

        } else {
                indio_dev->info =3D &ad7150_info_no_irq;
                switch (id->driver_data) {
                case AD7150:
                        indio_dev->channels =3D ad7150_channels_no_irq;
                        indio_dev->num_channels =3D
                                ARRAY_SIZE(ad7150_channels_no_irq);
                        break;
                case AD7151:
                        indio_dev->channels =3D ad7151_channels_no_irq;
                        indio_dev->num_channels =3D
                                ARRAY_SIZE(ad7151_channels_no_irq);
                        break;
                default:
                        return -EINVAL;
                }

Why do we have special handling for !chip->interrupts[0] while other
errors on getting the fwnode_irq_get(dev_fwnode(&client->dev), 0); will
abort the probe?

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/iio/cdc/ad7150.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/cdc/ad7150.c b/drivers/iio/cdc/ad7150.c
index 79aeb0aaea67..d7ba50b9780d 100644
--- a/drivers/iio/cdc/ad7150.c
+++ b/drivers/iio/cdc/ad7150.c
@@ -567,8 +567,7 @@ static int ad7150_probe(struct i2c_client *client)
 		if (chip->interrupts[1] < 0)
 			return chip->interrupts[1];
 	}
-	if (chip->interrupts[0] &&
-	    (id->driver_data =3D=3D AD7151 || chip->interrupts[1])) {
+	if (id->driver_data =3D=3D AD7151 || chip->interrupts[1]) {
 		irq_set_status_flags(chip->interrupts[0], IRQ_NOAUTOEN);
 		ret =3D devm_request_threaded_irq(&client->dev,
 						chip->interrupts[0],
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

--p5zyaIGk3sdCqhT/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRnV8AACgkQeFA3/03a
ocVPpwf/XP0sm4HuZ7d5cvjP8rdyWeypk2b+1xPbvOfJ9rsWnxrGc0deNYJX/jnP
cCjNAkZZIDWMeg6DkhePPic7pVZxfHKiH6jeBwSpXDjtVoM+evWI4DfO6KIv18QU
fR4JB0p7RiWSej/gQsJDXcDZuWr9YiZHSj5XtQhqkwHvqxBWOOw70oSZ87F6oDFq
FHDn1hE7XPpmIlmOewyOP/LuCco8Lw9UMT4oJl+OiLLiafSmX73dxgnINQZdExoW
0jMphcQ156dADCQalMk/e7rolAn5yrla+8YcsT+hPzKJhCdz2v5nRPAa7eu7ivEJ
FkRDaHFKTig8h+4opoJefQhN6sxxuQ==
=mziF
-----END PGP SIGNATURE-----

--p5zyaIGk3sdCqhT/--

