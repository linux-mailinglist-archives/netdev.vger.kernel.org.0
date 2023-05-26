Return-Path: <netdev+bounces-5531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D03ED71203C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B0552816AC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190545255;
	Fri, 26 May 2023 06:39:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F383A538D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:39:05 +0000 (UTC)
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7418E12F;
	Thu, 25 May 2023 23:39:04 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f4db9987f8so1285550e87.1;
        Thu, 25 May 2023 23:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685083143; x=1687675143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ekbpAMbogTlMCWxkxFZ/eQBJQS9KZeZKKkgzxsIBTZY=;
        b=swo3Sx3G1UOBDNaL7TLrRZ5pQB/6afRbf8eQBpp9b1OaBl7qkV9Yxk0SqRq0yePA18
         ZKv1bPnEl7wMGTPLzvoaZtjDHe8nkwbU5pybFPwKDNauvtpgVcg/O+tw5mTdjHSjStBG
         yyP3YnlUR51SJ2O95YR7Sp3Ji9z1kAInjJVXtbFGs5Adtb48Zyh7ttRnntgEvp+hF88q
         v2G+jHWagwpjRk3ZrlNpgM08lGmFRHBp5VCx/SEBP+MX32Hxmjg133eGpcr5PaK5BKel
         L88+H53RnL1ZExbKN0NwzYroA481IHdtNGLAfDr9xx1sTeo4kYglbNM3i6Jj3uVmhfjz
         5p7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083143; x=1687675143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekbpAMbogTlMCWxkxFZ/eQBJQS9KZeZKKkgzxsIBTZY=;
        b=FB6TpBrt4hbM+ybDODTgSU4zJRIK5Jwn8LkOHknM5L3sEqnFEImuvHY8jMFOHkepxp
         Pg4cJrV6gcZtxRzvyDstQj/W3XumAe/ayhxIFYGeR2mnyW8Ey522nG3/VfWPyfbjmPf+
         AAErGi55HjeqLg+/db5w7OLuVABYxrqZBV177gK+kufFq+HTGk7bQ/AfGrvoXdx7uZIQ
         5Qumy1dzXUOSNyM85QgUsgR/DJcEDr1ygaydt+8Xyldy4JK+PUMzesDDoV2vnXNtfZoK
         CJKaLdMkiTlVxZwDpZp+H5Cfvg4Vge0CwHx+fIsr7KCCL0mnCzqpjQu4qf38WBYAEV/I
         PMRg==
X-Gm-Message-State: AC+VfDxI3tvNR+SNr7/JU7F+CbJN08cz1WbikS/kevx+7W9CEYj1QRRY
	iAyC8dd9hO9XFaXB/Dqo1s8=
X-Google-Smtp-Source: ACHHUZ7knF9sTUOLQBiCcAr+wHS3578rbREvAyWpopCpkBaInOiXDERlRe36k4kgZYkg7rsGnuWrZQ==
X-Received: by 2002:a05:6512:3d90:b0:4f3:a55c:ebdc with SMTP id k16-20020a0565123d9000b004f3a55cebdcmr1440553lfv.17.1685083142646;
        Thu, 25 May 2023 23:39:02 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id p11-20020a05651211eb00b004f13ca69dc8sm486674lfs.72.2023.05.25.23.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:39:01 -0700 (PDT)
Date: Fri, 26 May 2023 09:38:58 +0300
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
Subject: [PATCH v6 6/8] pinctrl: pistachio: relax return value check for IRQ
 get
Message-ID: <9db9653eb33d345d305e918215216348a8f193da.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="o9c5bgYMrd+9nbej"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--o9c5bgYMrd+9nbej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

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

--o9c5bgYMrd+9nbej
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwVAIACgkQeFA3/03a
ocW3CAgAm3wqiIWku6MbT4ThESmZlC+pfXUFhQB6EBKkUF0/X2kvjLfjx4fHP9Y9
QOzu4Ig2tfYZ6BcRpsmNY595Z8MCKjFoX6MNft0DKYrft2ntlIOiuYNnYn22dcKa
OF+bia+59rOF3ZxeHEaAIuG92QK4UjAPx+uGicOFBsYqdtJlX2NYyfDS3OZoq0dc
F2VHzAJ/HFX7Qyyw/eFr4+ykXG5taDycA5YmRMqSgycgG/crg5z9e9J1GmPOfTK1
htTdV2qURTz4WFefotfm4mZaE2oTwgn4W7yiz6Lcz6Zw79V5Oz/Z4aRyAUfYK1mW
p9IsxXeeTscvpnAuNIBf+wY9XAx1fA==
=tTx4
-----END PGP SIGNATURE-----

--o9c5bgYMrd+9nbej--

