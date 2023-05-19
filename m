Return-Path: <netdev+bounces-3876-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F4A7095B2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7648C1C2105D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD9979CB;
	Fri, 19 May 2023 11:02:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF35F8821
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:02:25 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929231BD3;
	Fri, 19 May 2023 04:01:54 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2ac8d9399d5so35396641fa.1;
        Fri, 19 May 2023 04:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494112; x=1687086112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gkYB7W6EIjjzbGiSlqrEyzRmwdHttot0sA2nFcKs42o=;
        b=QkXBm0Yk/lsHk/RhV+I75xdBWJGHX+o1sOXTZd1AE9T2+qFXzhgjPZuQ7kli5NiBW5
         nTJExjZjzmJmqGJkckwbcM8IU3WXvjSPnCzecWe3JB1XkVfq1pep2IU9SXa8SzifXNbY
         oGq3UTLs/4lfkGk9Fwv5k71YZUZ+VmuHYiID1Mrd3mFW5Ipxs3Sb1LgDJazQL3eZWfzz
         XOZmPUYpITfLiamdhxXDdYy2RfIrP2gyI5WbftXnJD1wxG0M69saZfq8lhu6q6K26x69
         TXxXtmT4ilVB7/Dxb82w8EszbWQ4WMMlGmE5lArO3Ydrv26RbariaJTkKyeCkYwMxI1p
         Cikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494112; x=1687086112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gkYB7W6EIjjzbGiSlqrEyzRmwdHttot0sA2nFcKs42o=;
        b=YZ3M9zcx5mkian6KYcGUZsOxUNRs58zlna+mxHG55XrXU6AYpI5Acp7BvrfcfdaHCG
         fV0s+OUiuzTPEou8rIKIzvS3vZqu7BU7S/1FKHx3mQ0j8zkDs4vM9YqCPmpjoniYfBIz
         tEzF1+yHcXR2y3zdRCOZEnmmuVyYtrukGO2NHAxpobhCnxt0mL2D9Yu4zqBnc8Pf5l+6
         LgHbMYylavUSotcyAJc4eZOqL9SbG+YYw3HyB2xSsDYZy7PnAAKH4pLEGjGwjyUz5DZb
         5TBejGg3pqWVayANucdhMlzYtRX+Rwji4saaoF2Vup5wFcl1PqFOlHQzVaZbMRkwEffG
         nMZQ==
X-Gm-Message-State: AC+VfDwnL9YUN8E6gOzHV3VG0nRlAkVYALFfogvMomImXVDzgDVA10yZ
	3IsUnjWgbYylXDYyjnz7cJA=
X-Google-Smtp-Source: ACHHUZ5/q+zvMZ+zbg+FKIFk8D5PZvwdxgUr+VEmpWVeklatgBfB34pR/1qPtDrg7FlFnAHRjW/Flg==
X-Received: by 2002:ac2:4a84:0:b0:4f3:8507:d90d with SMTP id l4-20020ac24a84000000b004f38507d90dmr563473lfp.34.1684494112221;
        Fri, 19 May 2023 04:01:52 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id s11-20020ac25feb000000b004f122a378d4sm560346lfg.163.2023.05.19.04.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:01:51 -0700 (PDT)
Date: Fri, 19 May 2023 14:01:47 +0300
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
Subject: [PATCH v5 3/8] net-next: mvpp2: relax return value check for IRQ get
Message-ID: <7c7b1a123d6d5c15c8b37754f1f0c4bd1cad5a01.1684493615.git.mazziesaccount@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WBQKGbZd2PYv/hE2"
Content-Disposition: inline
In-Reply-To: <cover.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--WBQKGbZd2PYv/hE2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---
Revision history:
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

--WBQKGbZd2PYv/hE2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRnVxsACgkQeFA3/03a
ocUh5QgAuyIsek2+cAUTanr8jyVti5gJyYOJIB8THaZqjB7/+LuML3uHZE90Qcog
a2lCP7tFydSk0Iti02b5sWxptB7U2llblUvuGXjARczJtM+DI6Xf21ytO1v8MSp0
YdHlmCgFbCk4l7olXu2NnN790fp2H12jS4W632DpqUCjyCLzla6zPlK4jxs6d2jq
LBB0yyEo6HRmLbgeqixM7u7rtaUxlKKUwsZW3MYapm6f9WfaL/gANgrqPlLas+LV
roGZjniGV3fPCF09GGO8HiIAXYE5NonXqyfWG4+IxV2EDHEBhAl98DhtwfK5f6j4
VrvAFkdCtvHfeFh/7mKebeI0rwDutw==
=MXvA
-----END PGP SIGNATURE-----

--WBQKGbZd2PYv/hE2--

