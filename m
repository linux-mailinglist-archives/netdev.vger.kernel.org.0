Return-Path: <netdev+bounces-5992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C59714477
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D32B1C20967
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6E47FC;
	Mon, 29 May 2023 06:24:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD677E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:24:34 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69974110;
	Sun, 28 May 2023 23:24:02 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f3a611b3ddso5089703e87.0;
        Sun, 28 May 2023 23:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341440; x=1687933440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uEmuOv7fyHRZPnJixXOmvNLBHdAL/mnG87N9Mya3BSM=;
        b=UHxHMFKCeb7EfKc/IxtN6IKsRrbAG5vpabv6bNlDzNSqbjDn2rb5+AfDSAgs5f1jlB
         +UmvYBtFCAdHHId0KdRpSh5MjkZ1U2bkl5ux58LRQC1iA3YbDcfyKg3cN5A/SNxXf0Vz
         q7lRK4l6pdWvBe0WoZc3S2fukzneaipQ9dZ865TPKIPdQgNX7jAcwNq6e80MjYS8lf6r
         aY/5CcHejY4Gn4VDmVBLKcBBP0h8eR8EL6qxknsm9ZT+Nvyk69C00g0FlBiMpsZDnYWq
         T9yrkOsI7GuAYaPPG49vyYz3HVdZ5duXDZdCKwVtGC5mQJhYxMXkY9Gtg5x7sxrTmHn4
         8JbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341440; x=1687933440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEmuOv7fyHRZPnJixXOmvNLBHdAL/mnG87N9Mya3BSM=;
        b=PloHy1eIcIgm7lUrOMf/1lHKTia9Avhg8mmIXgqgSVlNROyB1bXb8Uo+YlskcR+6dN
         jvvYRN+IHaBB6xsg2oDmz4reTyRGzk2v0eIIhK9YmCl1SHeKowAiqaoFCvC0QnTpmrZm
         q67uPj+guc7IQfGThuaQDWg+vJ7C9fI0yL3FAKS+ULceRxbi6AkhHLqhnvgkJ59X9+dZ
         iJ4JT3uJm2bnzPofuNN9cOkuJojk1ojuZu4MRB9wNq3T4sfhUu6gbok6Iqb1SgTBkt4p
         UBatfvu2bl1VaxU9k9nKDdxz/FG1++tkT2zZNQtR3b9A9KRPcBRAc9dXPuZYYK+9icw1
         V4mw==
X-Gm-Message-State: AC+VfDxHRD/erezCNvOsk3La7YHlGF9ZJU2eczgVdNVXvVieLe8yNVzz
	3S2q2CSkWxQhNP9VaVFY4wVDHo2NHG4=
X-Google-Smtp-Source: ACHHUZ4A4w5AYq5DZKR8KECg7aiQfo1vTJZS23CTUj+cq12URjvIZ6YO33hOKPbIS9EDo9zLBGoTtA==
X-Received: by 2002:a05:6512:3d25:b0:4ef:edb4:2c77 with SMTP id d37-20020a0565123d2500b004efedb42c77mr2688210lfv.11.1685341440377;
        Sun, 28 May 2023 23:24:00 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id f2-20020a19ae02000000b004f3a90b195esm1859534lfc.51.2023.05.28.23.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:23:59 -0700 (PDT)
Date: Mon, 29 May 2023 09:23:55 +0300
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
Subject: [PATCH v7 6/9] pinctrl: pistachio: relax return value check for IRQ
 get
Message-ID: <08188d9dd325f1f8b13f9173af00c03d0c27c2e0.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ghTxwxrKVJCkx8O0"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--ghTxwxrKVJCkx8O0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
Revision history:
 - No changes

Please note, I took Linus' reply to v4 cover-letter as ack && added the
tag. Please let me know if this was not Ok.

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/pinctrl/pinctrl-pistachio.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-pistachio.c b/drivers/pinctrl/pinctrl-=
pistachio.c
index 53408344927a..8c50e0091b32 100644
--- a/drivers/pinctrl/pinctrl-pistachio.c
+++ b/drivers/pinctrl/pinctrl-pistachio.c
@@ -1393,12 +1393,6 @@ static int pistachio_gpio_register(struct pistachio_=
pinctrl *pctl)
 			dev_err(pctl->dev, "Failed to retrieve IRQ for bank %u\n", i);
 			goto err;
 		}
-		if (!ret) {
-			fwnode_handle_put(child);
-			dev_err(pctl->dev, "No IRQ for bank %u\n", i);
-			ret =3D -EINVAL;
-			goto err;
-		}
 		irq =3D ret;
=20
 		bank =3D &pctl->gpio_banks[i];
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

--ghTxwxrKVJCkx8O0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RPsACgkQeFA3/03a
ocVYqwf8D7VOgeWSjImpUGoUcaAvu5XsMeByrw2K7Q2RluG/8FZ7VKFHA8v8rbvC
K1/yxFYmSUVDGf0Qkhl/L1VsgJvdUwdCRpz9d3eXMFxl9iGxhByH+E5HValg5gr+
fBUvr26tze7GkwgXHvT/edu8oJXBUMphtdDmRlbtB446+IIYZ/5fdjZ7sXirFzHh
pzIWeF7QKKNqCYlIOLz40lrVTbNqKk3Sah753GYxfWrk9s/VeuRjZ7c2NZu0RvBH
GTeqVpnRtCfhC5JmnbGFB4HaNcowp+LlkSa6dNhWuE0Btlswb8xQef35WouGGlh7
fC0l1jcqp4oUBJ+OjdIXFdH3Y3kvww==
=5e+h
-----END PGP SIGNATURE-----

--ghTxwxrKVJCkx8O0--

