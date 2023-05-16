Return-Path: <netdev+bounces-2875-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DABC9704603
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:14:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96FDD28159F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0F5182B2;
	Tue, 16 May 2023 07:14:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFBC156FF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:14:15 +0000 (UTC)
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4E744AB;
	Tue, 16 May 2023 00:13:57 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f1fe1208a4so12907697e87.2;
        Tue, 16 May 2023 00:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221236; x=1686813236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7iB2tT1FxzgZOFKdB6YdWc9HUsfJ2gQmhK2D8CH7ls=;
        b=F2Ois8vAySQr2U0tMK8uXNP/3vsb8HWxhd6w6T0u9tyJsJpG2pIF8ViQo9DfDpnfH+
         ud43j7l2z7rT6LClB56VEbDxtWMpj0tcryVQkZ5bW3jPDZ9XtjLm2zMJKzgSRXehqADn
         ZnEgO9Z+BM4QphonC175O9hzG6X7T9769/kCCc/a3/EKDaSroyAYfT7VEsbgljBN/bf7
         hbxb8Gn+FzJlB1r/Zc34QqxR4IKfKRwlZguJ6CWaoCayKTOhwxDHOIWrNuukamJVUny3
         D3GG72MhfJvJV0OCp3SKi4vMdk1qI3SqJ9EiF8vNLYStQoXy8OtLLBqv2lH9MpU1wRVD
         U7HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221236; x=1686813236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7iB2tT1FxzgZOFKdB6YdWc9HUsfJ2gQmhK2D8CH7ls=;
        b=fAlhPHwhRZHoo0Fjtxqhg4G5CR4+1F9vyR2x4PU6KVQez7B0lIrpZ129YKDjtrGAHm
         5UMV6sx5wX+tMB9vpltvR+lCghWApvC0xhrTYJh51wUUIlAmVlDNxzvWWlqBUCDBXNv5
         8QnycWiIR3y3hEUciCuZyn4FCSXYs8QSzV8ALOrOQ33d+Q+qlrTWCWSlkJsqkFETuKyl
         GcSPu7+LzmEUBxjWvPYBxAqqr3agZ6ShJM3RmInOdr+HAUliuR2Vo3e0+j34yxM+KznM
         OAg8sLYJpDHdkwv/L83QczksgpN28cleDTNoM2VamfAG9oQpI8AJRPnAr/DWhsLAi1C2
         3bSg==
X-Gm-Message-State: AC+VfDzY3njR/aQYBtt8IweGEXbCy587EkFWd3mw+kNH9DNlbOnXngOz
	qWnk4BWdoX249kKKkIHsBJE=
X-Google-Smtp-Source: ACHHUZ7mcAh05jssI9gTt04ul3aPVER3NAMZdK2vv5y3BfBFTtQFfWIVyeOwl11u37jMcbM3dX4Rrw==
X-Received: by 2002:a05:6512:20e:b0:4f2:7b65:baf1 with SMTP id a14-20020a056512020e00b004f27b65baf1mr3635981lfo.23.1684221235879;
        Tue, 16 May 2023 00:13:55 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id c17-20020ac244b1000000b004f13eff5375sm2847608lfm.45.2023.05.16.00.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:13:55 -0700 (PDT)
Date: Tue, 16 May 2023 10:13:50 +0300
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
Subject: [PATCH v4 6/7] pinctrl: pistachio: relax return value check for IRQ
 get
Message-ID: <d311f71335639239f07fca0ca99f286717ecd81b.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QO1INaFvm5ku70AP"
Content-Disposition: inline
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--QO1INaFvm5ku70AP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---

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

--QO1INaFvm5ku70AP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLS4ACgkQeFA3/03a
ocUknAf8CDPxskRn/21aeRCh2QWEP8GThIfsY08YYUkaMIBNyK7WCUw5ecla4MXb
KX3ugg/OBIvBDjUZVYQqRnrJeM8STw874hhvhKP4SBrVU7NQGtfVjaHbvDfaeSA9
tz+pwO1wyzCwcpl5sLdSa1yL/oGyN7FYdtn+QvCXjMg6EEWSdQlmh+CmTreCIdPx
/FarMuyx3IXZ6kJMOz+E5SNQ03ZsHBt2WS7/TvuYixkoi1Kyb4a7Qsv2jiFutrWG
ds9dO9cOUpAbAj1my4EVHfNymcVbSDTcmHOyBZnHonWmTFdXAlxab7wABVTfrfaC
1+fRL6XU/lfL2u1LY/I1ztrR4hoXww==
=RbLa
-----END PGP SIGNATURE-----

--QO1INaFvm5ku70AP--

