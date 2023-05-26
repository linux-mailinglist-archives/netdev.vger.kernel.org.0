Return-Path: <netdev+bounces-5528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB73571201E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8883D1C20FB4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EB6524E;
	Fri, 26 May 2023 06:37:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122843FFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:37:16 +0000 (UTC)
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A606D125;
	Thu, 25 May 2023 23:37:14 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2af177f12d1so3929931fa.0;
        Thu, 25 May 2023 23:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685083033; x=1687675033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTHyx8ul0jeYvSGVcy/ig3hWeMVLe8/m2Xy5fo29+U4=;
        b=q3SYsF3JaBt51X/Hhcb3nNtQDRFZCI3Ml+CK3KMqC6/scLDfG0QtiFCnjmmep9zzqw
         cNk+nEmE8FQwm3mMAwOr2/Yxjh5A/HPK5dWDA8tSTlNON/MlMNDjLkJDFimJnmSXwuiK
         UOj/QzuNQ10zVJ/wNuZkuu679wLeO7OW87jRLMRS4UBKcTzd7iZm207k8ybqy+VsXiVw
         Jzrv3P+jOcmAWUGeqmr6c7Va3G7A70Jj7b3wH/3cxknmcYf3LJ73uNUo3V/SNLr3W0kM
         KJZ+2wG7iYyC2+H++h97wgt+Gtkz3ZeWgmpsKPRT1yOg/x6mV+n+g7ttjYVUsOInfzPf
         uiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083033; x=1687675033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTHyx8ul0jeYvSGVcy/ig3hWeMVLe8/m2Xy5fo29+U4=;
        b=O7Bl6WldQCMaQ9g9kYh2b8Mlj/y/oHm5Dx1vf728dVehPskCi6256q0kuX5kYEWMrJ
         vPL7ewS66RO5Lv2JUFHtfrA01ZXHwCFgTG3RR/NJp6Eu/0XbyxMEU1FCdRU+Bvn0GewA
         vo8ucatAvlQUo/my7QFKMhycTVHrbj1I2oBxz/I4t5NHO7qLZ7ycHXU67FsFQAlRKhKa
         aRe+lUw4L5i0Ky0Vz0G7EK+HyvW3EGzq2GxfG0t2lyO+A96h9fzlr5EBg4Z0OuJBXUog
         6EqBLorpeA4GNxMa6/vtx9o0vjCUKHssvq8rf5GcV42hUHIoHGNjwc83++ldbbMjAr+F
         8j5w==
X-Gm-Message-State: AC+VfDzVqidvVTMbaFhW6XJrWDSAlTRigqO2GuG3eDneUqzRJwZatgxC
	3914mh0nxksG24cX+/0AGCc=
X-Google-Smtp-Source: ACHHUZ4X9pgC0XVmR+d+Ksrb8LTh0cKOkPQu76crhybPdfb5o9R68exID8yXSG4urcQPdyWB19IhCw==
X-Received: by 2002:a2e:87d6:0:b0:2af:22a0:81f6 with SMTP id v22-20020a2e87d6000000b002af22a081f6mr247122ljj.34.1685083032639;
        Thu, 25 May 2023 23:37:12 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id s9-20020a19ad49000000b004edc55d3900sm499848lfd.0.2023.05.25.23.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:37:11 -0700 (PDT)
Date: Fri, 26 May 2023 09:36:57 +0300
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
Subject: [PATCH v6 3/8] net-next: mvpp2: relax return value check for IRQ get
Message-ID: <a9dfab391fbaa7492e69729ab1396c41c8ad4991.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iD9IthrIHGq1a4Jl"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--iD9IthrIHGq1a4Jl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---
Revision history:
v5 =3D>:
 - No changes
v4 =3D v5:
Fix the subject, mb1232 =3D> mvpp2

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index adc953611913..5b987af306a5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5833,7 +5833,7 @@ static int mvpp2_multi_queue_vectors_init(struct mvpp=
2_port *port,
 			v->irq =3D of_irq_get_byname(port_node, irqname);
 		else
 			v->irq =3D fwnode_irq_get(port->fwnode, i);
-		if (v->irq <=3D 0) {
+		if (v->irq < 0) {
 			ret =3D -EINVAL;
 			goto err;
 		}
@@ -6764,7 +6764,7 @@ static int mvpp2_port_probe(struct platform_device *p=
dev,
 		err =3D -EPROBE_DEFER;
 		goto err_deinit_qvecs;
 	}
-	if (port->port_irq <=3D 0)
+	if (port->port_irq < 0)
 		/* the link irq is optional */
 		port->port_irq =3D 0;
=20
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

--iD9IthrIHGq1a4Jl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwU4kACgkQeFA3/03a
ocXjjggApSuGSCHoSYz7ejpBxDnk2sZt3jJJWi1Nnhg6PNvHJyGsYiuXq3Ryke8K
zPTfYmHyNdsY2RzPvxP9/NglgWEjDB7McLb6Xg7J2EZBIhNebwkTiLMXn1GQ8nqn
EszudBOm2izfZFWWlxKG++10V0oTVVtFe+VL+YmfvwVgr5/8293Onc8OvnsrELQY
K9LUpG/rRw1w9pOsLQiCParlP582+liULSCnl8JaAf2qPyZNVrA2pKabtONXEo5S
+DoM6e7KKao+WVpmTb3U84UYzXA+4I280RJy54ylLHsQmGRS/UknbxCz52jMHzh0
lCx1hwSPDjgB8cpk3rCXB94x2RC01A==
=RjLg
-----END PGP SIGNATURE-----

--iD9IthrIHGq1a4Jl--

