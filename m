Return-Path: <netdev+bounces-5988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A86714453
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F332F1C20955
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8956D7FB;
	Mon, 29 May 2023 06:23:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789A57E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:23:06 +0000 (UTC)
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59385D8;
	Sun, 28 May 2023 23:22:56 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2af1a7d2f6aso30906891fa.1;
        Sun, 28 May 2023 23:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341374; x=1687933374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yfyg6NKftjZO/4gz0JHhtsokbfeyGcV0luSB2BRlKAo=;
        b=E9Tt+BNoXN5iXTWmvKUwKPWj/9MUIlJIXaC4DqH1e+JKbC3NNBssryaMJPRq0qDybI
         ro6d141wA0yjh4trX4LPM9h67u5Nzbu1VeAcgEwAIDfhfy/yy1e0kzMjzow2dhcC0Ayn
         Tl8g1G29hXksD+SsHttxqNaVeYgPn495ARpMZe8iDgyEk4p3MMYQkiI2EBxCJj0Kcmh1
         ygk6hUmmBElyaEfrBU7tD0Od3qk07vsqqUEczGJA185E43VL1xawyj9aqMuLRt4IzUMh
         yfa00g595ramofRyoOOXgehsarvLE6z3F0ILA1FeqHT/n1iIBEusMQulVyo9StgzWuau
         n70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341374; x=1687933374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yfyg6NKftjZO/4gz0JHhtsokbfeyGcV0luSB2BRlKAo=;
        b=ANTIV1I+3Mo2VFjpDUkn14z67JY86Fx0vb7VXu6XhQLLqHmamqHiLuo3DURc89BtC1
         aBssDqmPA2HsSU9K37cMCAMnekpvilA4LCy2pEcQpYVfXlivsTy0y37IPNtQP6D8hHbW
         g3FLYFnkvXJc2A6/lpjvbjs9NLmzl6UtenoT4I1PZg9oy0jEmPoKuBiFuroyq50+lT2n
         F1hjQVujOaUg2pM34UF83DJRffFlY7WeLnSQwxAcIG/5kAb6oHB23YBsZgHHR2Mak/TB
         QPbJ4FI/c82+NyhS/+blzqyx5z670Gm9bk+ahNbK1OwyQEKw6KSeFJu7ehcpJPXGbtp1
         O8cA==
X-Gm-Message-State: AC+VfDx++MzFa7hRJ27pFp5jomzmmM5ZQTpMlYno3YpYgWchEuHc/Gq5
	RM+MWO+XLj9KpHHATvbu8Wk=
X-Google-Smtp-Source: ACHHUZ4eQuwS42uy0fymxkMMy4zn7woNyo0QvtaUdMk9NpK0WPd51A1m/jmdH76EIq9T5blchR5vIQ==
X-Received: by 2002:a2e:988a:0:b0:2af:19dd:ecda with SMTP id b10-20020a2e988a000000b002af19ddecdamr3195700ljj.45.1685341374404;
        Sun, 28 May 2023 23:22:54 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id f1-20020a2e3801000000b002ac7a715585sm2310218lja.30.2023.05.28.23.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:22:53 -0700 (PDT)
Date: Mon, 29 May 2023 09:22:49 +0300
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
Subject: [PATCH v7 2/9] iio: mb1232: relax return value check for IRQ get
Message-ID: <f7770a4b88bc131e0723a4f1d8fe187655f032bf.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SUg0b+R4T2ARSOgb"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--SUg0b+R4T2ARSOgb
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

--SUg0b+R4T2ARSOgb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RLkACgkQeFA3/03a
ocV0bQf+OTEY0XaXJ1D31hHtkeAGsNM/0aYam0ogId5Z3BsXf3xM4sagtj/U6Ek5
3lXwibkyWjvyh8ia29na69GPdZBF/Nba2wcML55WLK+MXlGgPLek/6GRCtNpRnTl
KOYItK8YEOoGeYcLedFHGNL0f45Sf9yraVVAkFsg5x8XNVKfgbNCQlZ3UOL/JlZp
WfzVqY43J5ezdvtRo2jdkfyQ8a2kDev05ElHcv2riJidjV7R7cO65e62pYBIGIlz
nnRNQypLhJISxrhxMdKY72xM1WLKhmnCe8AM1Abl+zhi5zJ1eS/LRr4YeW0/DPvQ
7XFmYNpWVRUb8ZAMO8qd0uk5YiOAAw==
=W3BL
-----END PGP SIGNATURE-----

--SUg0b+R4T2ARSOgb--

