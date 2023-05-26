Return-Path: <netdev+bounces-5529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9EBD71202E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EA2F1C2084E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD889524F;
	Fri, 26 May 2023 06:38:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E102100
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:38:21 +0000 (UTC)
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3430D12E;
	Thu, 25 May 2023 23:38:20 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2af318fa2b8so3735701fa.0;
        Thu, 25 May 2023 23:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685083098; x=1687675098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mILjjqW3e0J19x6hS+N8rbpkhGpdI9PUFEHSMRI8loY=;
        b=QqXMhxrLSOQ7nywZmaV7FI8ymMNakypk/Dj49sU/2sDG0/483oULyJT6EobYi7rVba
         8z9sE1Pprf0DjsFyPhYBCeJ5hj2PEc1OjxdGBMdpH3pb86B9hxgJTGVDp2nPZD7SOxsj
         mhmPeXbd3LP5fqRLmSSLu5MbCZbUVbq81BHynri16/t8nwtTH06TyXpz5z30VuH5vizN
         27bRI/gVnmIY8LM6JfAiuCvsJl57gdSWfiwwHb4W+qXG1vKqPI9oFS56Ta+NPvU501Wr
         y9Sux0yIWvW9kkenQIowZeI7gvmimXrzszuOvcahFTAA6lpvw0YLtKKCP+dRbq4cXkdA
         pE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083098; x=1687675098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mILjjqW3e0J19x6hS+N8rbpkhGpdI9PUFEHSMRI8loY=;
        b=P39P+AdThQjdw3yHzg9grSz8usuTVt6o6+3gIsBDSYH9iVV1L83gZdFMkeq3MrkxlW
         VBs+ZTuWay+VH3aXtobjpQzZT3q8t5GvRQfdnedANF54h/ydPDZA2/ZP5UUngEXDe3nz
         /7lxjVSt/lwB1TS51dCpH7G86jhwZ38BGg/nmQoHJ46FoctkratwGsQEhgKtfU5MaXhO
         /pdR09S/gJ9SnvbjFNeCBeMMP3bMU/hhUmTPk4cSHxWYKgSxc+mcQmxxJ71gqFeN/OFd
         sUwr0RTtQdWPV8F1KcrcCDI2EjsQuT09WWR4rQiQhMUhcLEoYZzBPcBFF3yWxGt2Pdoz
         K+lg==
X-Gm-Message-State: AC+VfDz2C/Q/jiQNYSONyQ58c/qxaIi5MXnxFJPWW2eId8EAhcYqHIi8
	IfJDKscwyjQGaeMQdj+SPNs=
X-Google-Smtp-Source: ACHHUZ6Gc496SV+lTjAWiPVY8wzrusV4Eabc166ebvaSq0fDx5nusWGt7ItFbzXWNBcCDtsqQ7WOfg==
X-Received: by 2002:a2e:9ed9:0:b0:2ad:d949:dd39 with SMTP id h25-20020a2e9ed9000000b002add949dd39mr516174ljk.29.1685083098283;
        Thu, 25 May 2023 23:38:18 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id q16-20020a2e84d0000000b002ad1ba6ee36sm557453ljh.140.2023.05.25.23.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:38:17 -0700 (PDT)
Date: Fri, 26 May 2023 09:38:05 +0300
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
Subject: [PATCH v6 4/8] pinctrl: wpcm450: relax return value check for IRQ get
Message-ID: <830e6e61cf51d43cb7a99b846ab4676823e4e78a.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6vvqQD2xKOBSWZLp"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--6vvqQD2xKOBSWZLp
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
v5 =3D> :
 - No changes
v4 =3D> v5:
Fix typo in subject "elax" =3D> "relax"

Please note, I took Linus' reply to v4 cover-letter as ack && added the
tag. Please let me know if this was not Ok.

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

--6vvqQD2xKOBSWZLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwU80ACgkQeFA3/03a
ocXxUgf/SLySIkEMcLaMMaSXHiOnRCzYeYtYFaSw1z06LJxEARFu14wrAxfuj1TQ
6BuIjSdrQVWNMgIVG3UEcj8X+MW1RFdb26IF4FgPNK5fcxfWpkwvala+rQESbgcM
R2RqVTeKGQHJs1RGiX7wEGPBW/0hW8LGWmChnaRZlHvxtd3SBovbFWFs0/Vx6rNP
3R4o5+xvoDTHn5f5V1xwZKmxvxuTvXmLe7D6AE384B2FVhuvsaWeYSgYGec6XdzS
u/gTk1ccUgimpsuyTRnTPqLCJz3doPWjCRuxtTrBrGF+jZQgUEM0dbRtjniW6vhW
f8zRyM0n2uPN0n5Rtu4kSuKjlUDbwg==
=SI+v
-----END PGP SIGNATURE-----

--6vvqQD2xKOBSWZLp--

