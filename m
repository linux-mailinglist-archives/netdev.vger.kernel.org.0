Return-Path: <netdev+bounces-2873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2977B7045FB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51F5728102E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F9017727;
	Tue, 16 May 2023 07:13:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB5D101EC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:13:37 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464601BE1;
	Tue, 16 May 2023 00:13:21 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2ac836f4447so140644821fa.2;
        Tue, 16 May 2023 00:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221199; x=1686813199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5yQG+L+sWAMbAKI7nwRV3Mk7EmEihKSJv4LlESWu6Rc=;
        b=EJMubyT2VJWX1+LZ4bUsldilZtFa74Xup//IE1hI4TlZKIQfXllceGaKcK0QLVkBIL
         Y7qxewfxN44AeMrltk4wayz71pVgLc0+e753neV4npsln1uMXL38S0AZT+kDtTYj9qP8
         5PIpqb7293xJpKlAEN0Ew/fWXEj94qECrNBK0QKsA8QGmPCJ/4G5PwFk+gvK1duKSHZO
         mz/+dVg0Zlm0a1ZWDbbEl+EximPAP3Op3iQOYImkKl3PWIyKPc5QrRfsjPdiG0hRQWmN
         ip2mV35sPoJTj9/NFRK99pq5bV4QfIgMM3Wj7+0fEe86D20GRLqSaVuheN4VpW3lgFvQ
         5mDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221199; x=1686813199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yQG+L+sWAMbAKI7nwRV3Mk7EmEihKSJv4LlESWu6Rc=;
        b=BvHLQLPnqyqZIOGR7pK9374MFWsVktmiWgsXbSHUP9Xn1VjfDa6gHzecgVqSlAkuPW
         /uOlktWAIqDSI3JBNAvaq8yT8dsMYVWTFcqXkM/MRESk/J9Q/SUqPxp8ginTDbUC7xcE
         sIAOMqJMFF/6CAnM1LhVMXomqYVaAPnh/137mFdWtTe42orQECsqocdYbTfx3c5djZ5l
         2xw2loxGVD/u2fIQLamSrLE7mN3svP5l6DSt65oXGKo8+h49AHMIfDYAOV1PqrUPdUnQ
         QlxcX8wHYIoG1Pub/61geXAfaQMMPl/OC8vEQGwK1QXkOHaMk+UXr0sDj/3dHg0ksxMy
         5Waw==
X-Gm-Message-State: AC+VfDwy9WMSStC55tASEC5kKP1p5xo42RYcuMO4bGpYGONI2r4krMOK
	LYXQG3pH9WGyOhCx5RMaO5U=
X-Google-Smtp-Source: ACHHUZ5TiNy3bPlF9s9syDX3x/nLlKnam1O4n3XDWwbGWRbrFC9CpZ/d33KhANYPsXPIuMpFPrSOVA==
X-Received: by 2002:a2e:3511:0:b0:2ad:661b:ac44 with SMTP id z17-20020a2e3511000000b002ad661bac44mr7934095ljz.39.1684221199254;
        Tue, 16 May 2023 00:13:19 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id w9-20020ac25989000000b004db3900da02sm2881066lfn.73.2023.05.16.00.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:13:18 -0700 (PDT)
Date: Tue, 16 May 2023 10:13:14 +0300
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
Subject: [PATCH v4 4/7] pinctrl: wpcm450: elax return value check for IRQ get
Message-ID: <2d89de999a1d142efbd5eb10ff31cca12309e66d.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FETL4FejpREbPA/L"
Content-Disposition: inline
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--FETL4FejpREbPA/L
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

Drop the special (no error, just skip the IRQ) handling for DT mapping
failures as these can no longer be separated from other errors at driver
side.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---

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

--FETL4FejpREbPA/L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLQoACgkQeFA3/03a
ocWrpgf9Es5uS3oPPJiMPB5j728uVfLR1V5MMPKmq/eWa0H356kurmwVmaVf/TCi
gy5E++bF0ZkmF3CbbHd+w1LbJyx8KcbVNs7UNR8+Gu4uqsFHTCLejVEendE0k1c7
WnbOj0NbjkXfG98GwOWCeRVA+7cZqksBsfoTzgUFC0BS3WgPZTsvDdQdZ3zujIS4
oC4EsMMh7LY505DoT0ulxa6KWhsVVlWZUjsxwH775Av8tJkRBSyzBtSqBupUc8Yj
ZOXcXI5DB9QXJRpcdGtG9mvMVeh1nZh+hzENjzTw7z1jXtyCb0Gb6EZ1bGEZUbNx
iStCbUdPds7aucV4grPrFMY7cxh6FQ==
=T/JD
-----END PGP SIGNATURE-----

--FETL4FejpREbPA/L--

