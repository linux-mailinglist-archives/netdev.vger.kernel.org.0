Return-Path: <netdev+bounces-3875-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6037095AB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5C6E281C0C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8756979CB;
	Fri, 19 May 2023 11:02:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74839568E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:02:03 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE0510E9;
	Fri, 19 May 2023 04:01:30 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f25d79f6bfso3623761e87.2;
        Fri, 19 May 2023 04:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494088; x=1687086088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3uZYfx3hyEjD6ZwDLsclbF5cJ3UWQoHkrfkUlHvER1Q=;
        b=Z6kLA7vTKbxFSDOMqZKgtyNJf/K2T5B6giEMZkKi7A4J0oLrNav4PeYS1WrKXy8SJK
         78XRFMmBmcI6AfiG4WmThsz/ljFdM3PcKHxxjEKWZD8WoeFyrIExnwp59JbxjgtPIWnx
         vbVdkQJibk+praCD00yW32Q76wblErU9g3SqL64WJjcQJbZQH7J5fgQJTAzU68jq+UwS
         YbueoxSZ5Adug0+7+tqsfTweR9LyvKnkh60sJnITM1oa3/kSyZoTgredrWBvVia/B2Mn
         Z60SuEbq0S+LB+86MtQHY7NjiK6X9T1+2ointvwW/tJvkM4SSz6gykNxIbyniPJPblge
         XEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494088; x=1687086088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3uZYfx3hyEjD6ZwDLsclbF5cJ3UWQoHkrfkUlHvER1Q=;
        b=AincygZoWEAIKdMxuN+WZYowsy3Md5AZSSHnBkSp5+258B6i9YmWMt+NBA32onbWHY
         X/sgrommy+MxzfzYHPAQilt3GrMfESHM1gQtb4FYMa6B2Pv97mBAGzT0AwerAgRuz0Aw
         /OKDBtapSF3Z9gdT6+4m8QSWXfWrhw4ivTfLeWSWJ9Bkw/1SGQrqcofT2hGScU4wgE/S
         pHN4xEKHxO4ozcM0r9LRzYxXRwf42aF+YgFJdOkKQp9kB4pgjFXfLFuK+KSH7KHLi96F
         Ey4KsHcbwX7WIbzlXk4C3Qd7bx5MBg/T5fKvBLI+hYWM8v7lU2kCXqXj/zaC2V9zK72B
         8Pqw==
X-Gm-Message-State: AC+VfDwhS1oVXiOscdMOe6d3SZ30ct4kAEwzqTGparxzmx+79JyCZxfc
	1seyO+UZ7AQus4oXv6v5QDQ=
X-Google-Smtp-Source: ACHHUZ6+keknVQA72YsdN5ExkPnf5lEpWalgfq0ryHX5h2KQYWZbvJIuX2pBx99C5haGKbUWtIfiqg==
X-Received: by 2002:ac2:484a:0:b0:4d5:a689:7f9d with SMTP id 10-20020ac2484a000000b004d5a6897f9dmr708885lfy.57.1684494088176;
        Fri, 19 May 2023 04:01:28 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id 12-20020ac2482c000000b004f1288434easm554827lft.292.2023.05.19.04.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:01:27 -0700 (PDT)
Date: Fri, 19 May 2023 14:01:23 +0300
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
Subject: [PATCH v5 2/8] iio: mb1232: relax return value check for IRQ get
Message-ID: <05636b651b9a3b13aa3a3b7d3faa00f2a8de6bca.1684493615.git.mazziesaccount@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yAqnyeIsXokB1xoj"
Content-Disposition: inline
In-Reply-To: <cover.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--yAqnyeIsXokB1xoj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get() was changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---
Revsion history:
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

--yAqnyeIsXokB1xoj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRnVwMACgkQeFA3/03a
ocWx8wf/SZhPLICGA2ctdRPjftLJaB0DYTxdKSrpiMt6wgeBNbAcmfkeLIm6QiWo
TejAiHYV1SDtSjcyuPb17gm/pCu0WHlS2Tmzp+t6oDEP8MN7QWB44GPm7DhCl+Ul
l78kuAlqLywHS0mGH1GnvuYdymy/dw2FA6YsSTXVwfuzTF0wP/VQWRPHZfevW/7R
Sc5eLe2kR/vTWy3DEfc5c8Gb71RrujlvQZcM198tt258BPDwyFa+V7sVy/FKPwMK
qhkWzXrwiUjEbWbV3BbmaOibSw+vuoKnMD3esBlKaVtuc/i6LtGvGdOCUNhhLzZS
kZwc3XvGRsUvPU054RVPj4OulqPILA==
=R0S3
-----END PGP SIGNATURE-----

--yAqnyeIsXokB1xoj--

