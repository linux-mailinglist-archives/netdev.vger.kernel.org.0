Return-Path: <netdev+bounces-2870-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBE37045E1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE1031C20D91
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3911156D1;
	Tue, 16 May 2023 07:12:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1330101EC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:12:52 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF6E1BD3;
	Tue, 16 May 2023 00:12:47 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f24cfb8539so12372134e87.3;
        Tue, 16 May 2023 00:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221166; x=1686813166;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xlM3eYv1IZ/hNqJzORarcpDSgFBeHnRSgoVNeCMN0OI=;
        b=CYF2awqA3QBPqECdXTLxEG95LOlfTJWtn1YpWmrDv19exiCwfnk9p+iVSfFFn4sOEN
         2epPa0KICye73idQTg1vSX0IDvHfHxyx1qK7Gnatc1njwlqOiI5Vw+UKeEcC7QM6Fh0d
         3G75lwc1QLsBXbqKnxk2kL6NoVMxEPKxFNUGn1QXglTN9H9+ZdAZYLOJ2dBWwX9S+ztv
         phu2u2xg9TKcDe3Nm9UYDQzeUzhUEc8ycuLElK8kObvyPT4+1qqDJ3IoHzahBoPXz7HG
         kuhAPHG0q0JrfDl2wCuZK7eHjQ3q/gN3uwIfGBbe1keuI9V3sKdf1bM3QA65rBTsx/52
         7Fzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221166; x=1686813166;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlM3eYv1IZ/hNqJzORarcpDSgFBeHnRSgoVNeCMN0OI=;
        b=RT2PMqGOg0utdShm7E4zXAA5kAqM17w2g52k9fD0KUR4stLg+zC1WtyFqRyQdqEvbh
         /FXNVQbj7KCfUCKHIxmXXXMGU/2T5a499bqQVg2WEUkey2Yjuog9KxVDiZ2prJXSFVyZ
         k35e+W5DSN/R1H3tA33j5kNmeY4v2Tr3VIPAmPDpFXClESk93V6r/h41oIsGAN3VGwJf
         00PG8oYAp9Sf7lUVDXBk7wQV/J6qDj1H2izYc1X3aQ3i6IuoeXPT2eOg1hwBEKwgbMOS
         ydkLRts//op3+kaO4vqRm3bKgkIlz6OcGxLHEz48TfpNO6lFz4IpMRiXPKdBXLmOJPq7
         +JYQ==
X-Gm-Message-State: AC+VfDwYkK3UQyE54aelkILwn1deY6sdFicxWAMtioeloyLc+DqfAdga
	nB3wQm/tVsLmZEwHOmqvMJ8=
X-Google-Smtp-Source: ACHHUZ6RkS7rF6edZ0apiKlbjHNVf9bjjMPUhnGDVprjZtw3VwTQSpDENb2BPjKT4vQkvJQpY1XtNw==
X-Received: by 2002:ac2:5197:0:b0:4f1:43b9:a600 with SMTP id u23-20020ac25197000000b004f143b9a600mr7658465lfi.60.1684221165779;
        Tue, 16 May 2023 00:12:45 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id u25-20020ac243d9000000b004f3892d21a5sm198196lfl.69.2023.05.16.00.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:12:45 -0700 (PDT)
Date: Tue, 16 May 2023 10:12:41 +0300
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
Subject: [PATCH v4 2/7] iio: mb1232: relax return value check for IRQ get
Message-ID: <429804dac3b1ea55dd233d1e2fdf94240e2f2b93.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="YZ9e9PLl/tEtytF1"
Content-Disposition: inline
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--YZ9e9PLl/tEtytF1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get() was changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/iio/proximity/mb1232.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/proximity/mb1232.c b/drivers/iio/proximity/mb1232.c
index e70cac8240af..2ab3e3fb2bae 100644
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
@@ -212,7 +212,7 @@ static int mb1232_probe(struct i2c_client *client)
 	init_completion(&data->ranging);
=20
 	data->irqnr =3D fwnode_irq_get(dev_fwnode(&client->dev), 0);
-	if (data->irqnr <=3D 0) {
+	if (data->irqnr < 0) {
 		/* usage of interrupt is optional */
 		data->irqnr =3D -1;
 	} else {
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

--YZ9e9PLl/tEtytF1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLOkACgkQeFA3/03a
ocVexAf/ZLicwkXRv1fFHlX8vmi3zS+r5H5aAR1qR57lTAdsuB532T3J6K5aYef2
8Dz0CcvPPLTs0fYf6dRgkakqyyQIEc7tbh/VAFORSTjQ6tgF+ri0nbWRSoDI+9We
GSbtRRVRfE0Ly4POgzAFkhoVflM7Iu7pMVFM5ydk4BtrrZjbqRufZf1YmRU7xLSD
JvrE7TNgyCHe5FD55le/38L1ykZ2D2l6OgVUjTs9Ggdg/on1YCHvMiFwGbHWjdze
vpp2UXsxv+FVv1wUvDtRTt/AfYUM+hz/zna09SApsy1tNysG8NfazKlYg8s+lTDu
Fo8Ar1amCpD8jYycIBJiDQUgKrhgUQ==
=YyGW
-----END PGP SIGNATURE-----

--YZ9e9PLl/tEtytF1--

