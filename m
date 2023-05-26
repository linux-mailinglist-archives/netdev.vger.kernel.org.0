Return-Path: <netdev+bounces-5527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA01712015
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED53E281696
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4735248;
	Fri, 26 May 2023 06:36:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494832100
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:36:32 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466DF12E;
	Thu, 25 May 2023 23:36:29 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4eed764a10cso346745e87.0;
        Thu, 25 May 2023 23:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685082987; x=1687674987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibHKBwm98vUEtm+6oAfn7y9WF5igvmXGkvEzcD82yTg=;
        b=QFcrXmc1tI3PjA4ZyAn7pd37Ak2J3/PkBeGJ+U+ma2YDn79vzGar15Lb3UbTMSxX1s
         aCBXbzPS36K0IEeIQnz/j9SFAbivJHwCXdPpmB0WBmgl3JlwkVXPFPtzmDaY4FFM3LqU
         DxpNQEOwP8Gvg8zfdIRaB0tJd8YuCh+9Vhe7dsRGk8S2/Hg9szZuyY6EYH/1HYC8eiZV
         xlT1HcHnilEVAdxRSrazc7jlvPF8IuRraZbxvx11DZDH6kUUfNd00zNMCTPpD6fZXBXM
         cW3p1Eym2cSRuCVmXQ+pFdaaYCjQhbvWeB+vsGMYTtjM60b672wAHE6DVcZtyE6JGrgg
         yyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685082987; x=1687674987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibHKBwm98vUEtm+6oAfn7y9WF5igvmXGkvEzcD82yTg=;
        b=X9mD5KVcCGKBMOqdOXIbFdqBGF2Q7VFRihzRElfRcf+WOrEAIEdX2QTO60bHm+oFqD
         8X4dJVW2Vo8erSP/SVScG9Sbwztc4HK7NP45kD4u5LZIYCi9l6HO2r3LUY+4DQl1tkxV
         0NZkRYZGylOVJSEa1E60PTv+xSxsV+okidPOHOkLYGvqvSplJS0/LY1hYsVlZO4dugHe
         kHRZoTb0R6j97f0LMO5YPplIMpFZZqrIo7zC8Vjg35QcihMr3T1OaqcvhLbB6PaGHrzj
         if9pZc5wAEjWRVhpONJ785EIoFj4qgqjTNIwEwdBE9NMpYpAiGIVdCSQ03osKsWJCLd6
         lQtQ==
X-Gm-Message-State: AC+VfDztmhyRI6ggLxiV7I7rDrTY/ApaPV6l5oe1uT11NQwTBjAaLErY
	+63iEv3NL0EVwxePmXOSF1o=
X-Google-Smtp-Source: ACHHUZ6O+oj6UcceXRsZij+c0/OW154pLRpmpDX3QwmlOmJe/QhpMwKwIZUsm1H4wbSJBdNi05DZ4w==
X-Received: by 2002:ac2:54b2:0:b0:4f2:6817:2379 with SMTP id w18-20020ac254b2000000b004f268172379mr192487lfk.23.1685082987373;
        Thu, 25 May 2023 23:36:27 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id u22-20020ac243d6000000b004edc7f6ee44sm480279lfl.234.2023.05.25.23.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:36:26 -0700 (PDT)
Date: Fri, 26 May 2023 09:36:15 +0300
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
Subject: [PATCH v6 2/8] iio: mb1232: relax return value check for IRQ get
Message-ID: <fce954e3d427bc94be4c8b52a4fb55b6fa4d2e5d.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/+3qr3fLL7Q81NGw"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--/+3qr3fLL7Q81NGw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get() was changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

---
Revsion history:
v5 =3D>:
- No changes
v4 =3D> v5:
 - drop unnecessary data->irqnr =3D -1 assignment

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/iio/proximity/mb1232.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/proximity/mb1232.c b/drivers/iio/proximity/mb1232.c
index e70cac8240af..3ae226297a00 100644
--- a/drivers/iio/proximity/mb1232.c
+++ b/drivers/iio/proximity/mb1232.c
@@ -76,7 +76,7 @@ static s16 mb1232_read_distance(struct mb1232_data *data)
 		goto error_unlock;
 	}
=20
-	if (data->irqnr >=3D 0) {
+	if (data->irqnr > 0) {
 		/* it cannot take more than 100 ms */
 		ret =3D wait_for_completion_killable_timeout(&data->ranging,
 									HZ/10);
@@ -212,10 +212,7 @@ static int mb1232_probe(struct i2c_client *client)
 	init_completion(&data->ranging);
=20
 	data->irqnr =3D fwnode_irq_get(dev_fwnode(&client->dev), 0);
-	if (data->irqnr <=3D 0) {
-		/* usage of interrupt is optional */
-		data->irqnr =3D -1;
-	} else {
+	if (data->irqnr > 0) {
 		ret =3D devm_request_irq(dev, data->irqnr, mb1232_handle_irq,
 				IRQF_TRIGGER_FALLING, id->name, indio_dev);
 		if (ret < 0) {
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

--/+3qr3fLL7Q81NGw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwU18ACgkQeFA3/03a
ocVmyQf+NK1laLHO4rBaZyM3i1ZZWNS4IdGmlbloDvSboApdPxM/wPyyl/y7Xp4l
ZruWMZZbrNySOkEU6Y7dQP1zntVU4smH0XVuKjQ+H/bSZ+UXFe+/fOjHmMHXrbKv
uwO1C18ieVYZ49fHsEENkok4w38KacgDqR4IMy3RbWZiP2TKGuUi/8nyh23p8/dn
cTCpYi6a6/9//ql/fkqsei2kAWmgtjfCTx/owl6ax9AMo5IMZkdujBvygsfP55LZ
jAa6kggV848Kh1YJeDCk5nz0iZFMmgCtU0kDiMZZyq6XOuCv7nf1HTenRtBdJfHC
DODfTe29bDrbyXkbxBx+aHDKM/635Q==
=NT01
-----END PGP SIGNATURE-----

--/+3qr3fLL7Q81NGw--

