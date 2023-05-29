Return-Path: <netdev+bounces-5994-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B887A71448F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 619551C20992
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6608E7FB;
	Mon, 29 May 2023 06:25:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D277E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:25:17 +0000 (UTC)
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F11B6;
	Sun, 28 May 2023 23:24:44 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2af20198f20so29804651fa.0;
        Sun, 28 May 2023 23:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341475; x=1687933475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OZRQfz643dmJHeeo+jkhXyvA3F1dCaDB2UQgCJF1mJ8=;
        b=Vv79P5w9D8h+XFDM95DLNQIVFZ5ylVvfzphxGNnUlDerYoJDaJkY43xI3mAuUfZm0z
         C4fob+gOq8w3UMfh0SSQGKfk9tcsd9Nk/OcAaL2OXUJNrFrebQM6K/eZWFdiBNwewpMR
         ovK7SpJ8g7eS+u0DK1IbINs6g9baH4okHVEj/GiQforgbnEHTgIE12hpV6YazIkqllSY
         LN/xGaiY7b4Cb9RDIHHhQvA2vOKR6tslRfXB3vrOwvH/5FBRTamlbXDwtkHwLP8ou34u
         SLC6CErI3ZG4MJp2VmVs5FKOOe3lIV+ztG5v6vJvTEU5wq/IXgWRfOm9ngHFexvhvY6L
         wIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341475; x=1687933475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZRQfz643dmJHeeo+jkhXyvA3F1dCaDB2UQgCJF1mJ8=;
        b=erMNR6RsSMn6Ry8blTEAuiUoXjJbiJSLpPJ6sW7QkDNGSHI5xpc4fXkTswcN40Iqgv
         Utn8Txt8t+EQoOfVZ3YgNOiO+qxTt9W9ApETWasTgIBlGLTlFfmpDbOjI1Tc5+XVskUV
         QDksmm5isMDUtd+O0ZujEQRQdGlsjwmkiQrpy3t5G8dJC+UBgEesKwaEx4lHmK40D6lC
         B70tKQ/Vhji7buvS/bW7Gll1jtSiLWJmXwTTE+QkYPAmvabotALGMOOBRDVu/3g7O8M0
         jbM2QCSO9Vp9kpcaEevYCQapIzkMzpZrNKLLiUuGxktHuYG+yLDob+IFo8+d0Uhy4VWt
         a7IA==
X-Gm-Message-State: AC+VfDzvpSX97rz8ISpSiozLQbTXkNs+43GZhgcTD/a4tOK75SPQfo1H
	Mc2gBmyvA9r+vKt4ipbKnXs=
X-Google-Smtp-Source: ACHHUZ7FtmSMOib8Ov0ArZ3oVpwS2pIyq4LIkauz+GxfTaYPkIg0JToW3ToziUlQWKilosw5qbF0cA==
X-Received: by 2002:a2e:3e0e:0:b0:2ac:82c1:5a3d with SMTP id l14-20020a2e3e0e000000b002ac82c15a3dmr3693931lja.23.1685341475524;
        Sun, 28 May 2023 23:24:35 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id s10-20020a2e98ca000000b002aa4713b925sm2305506ljj.21.2023.05.28.23.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:24:34 -0700 (PDT)
Date: Mon, 29 May 2023 09:24:30 +0300
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
Subject: [PATCH v7 8/9] net-next: mvpp2: relax return value check for IRQ get
Message-ID: <b458502919c7144882e745d6e936d1e01aef62ea.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/5RWSa/LMvuLUu/P"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--/5RWSa/LMvuLUu/P
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

--/5RWSa/LMvuLUu/P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RR0ACgkQeFA3/03a
ocV19AgAxqaFRBUT6btb94P25gicQllwWLpd2KMLhCnrMsb3cTiR+wCDcQjQIY7y
qpu2Dabi1L0v82mxPr4cPu9SjdK3NGBEyZ/VqHguFgjzC1grKOd6FFB/VQFBzsIV
digNYfuLcFZYgjBTnKXeXoGypbgCUF8gbQI0rthkOwnTTDgq4TMaFuEgf1fWMxd3
GZk954Ge8cUETjmZK1K26Y0EtrihBkIh1oN61T3I1Qcvpu7GKGcYnjHtm1h/NSrm
tywl1uNfAF7q4WbbLfKr+wZUtIGa/eTfFwyeJ5aXZSadF/2Zj2r6cz0QwY7mM1In
VnYJlZ4Va4M4CbCxPDcoIZid+xjAqg==
=bDpI
-----END PGP SIGNATURE-----

--/5RWSa/LMvuLUu/P--

