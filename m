Return-Path: <netdev+bounces-2872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1739D7045F3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6D7A28154D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C5A1B903;
	Tue, 16 May 2023 07:13:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8ED1D2B4
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:13:14 +0000 (UTC)
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B3126A3;
	Tue, 16 May 2023 00:13:04 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2ac89e6a5a1so136197161fa.0;
        Tue, 16 May 2023 00:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221183; x=1686813183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AhRTMZbB5GyfBpUyVEuRkkcYJv3zIi1DEzh81ls/BK8=;
        b=TYX7wKXxpI58eb565F00MA7mXwa1D1rr1TUaKLo0x4WFyBqEZB1lhQPEBlEMN/f3ga
         96KR13Ur9kw4oAySC50FCJLbCWkAtJv6yi/1TpbS1Tf3X6ntWSvJNLGJCJ2n1ABJva6G
         bYhNEUFTfyEDQ2Sx6YkppdBUoUqlIPAS6fb38GzIexU7oSYjF3zU5pvzdTNqV84W/NMH
         JAURk+Qf3QMT9HE+nRUKib1BFnsUtNa3dLoTANtSdXVhugpn7uDsW1r6AjNX27fU5tMm
         DR1S5pmmSG/ny1851YrPMRJzWLcfNK/+btOlvdapOm/vm+aSkDVOegWmxjNPb9yPztRa
         rpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221183; x=1686813183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhRTMZbB5GyfBpUyVEuRkkcYJv3zIi1DEzh81ls/BK8=;
        b=j3jMWNjWABnF41mZWNRzw6e1GL5L2wA64Anf1VwkLRmdP1r7JADRJA1aumNWYLzAv8
         uLG3OHENPiQLHN/ZdCPaFGJVZ8yhmehxu4FRZSSSC+Xgh4T+osIdPZeiMW6vZNtfqZMp
         9D4g0qyiw+bSMEqbiNHjBwFiZlRl4qivdqEESIGJR1kyIhS6pGObKaUovb4SQzWpeL7m
         doYEaXhe404D7v4rk004BlkJIggsUg3W7oq95wQDKORsCTYQsuJY0EOSmXqzXq2DIdBZ
         bZyRD2zqRYMnvEuP5PIjbtFNcNPGi6Ssb9RopYUO0hYxPaEU+L9XKjG0+DFWKta+v7Mh
         pyYQ==
X-Gm-Message-State: AC+VfDzoOdKPM25HoD/NDob43LgjMcebyu8QfQf161m5PGzFs713EIfu
	78u/cbwyXVEtqBq7hzlz/js+pq/DPkg=
X-Google-Smtp-Source: ACHHUZ41Hf6/H2CoNXoSC/fNvlaQD+g8ZCd1rgZOZqoqvRJsrUfXQ8NdcA/kHiIHwFZbHvdlHL2PsQ==
X-Received: by 2002:a2e:4949:0:b0:2ad:9c36:d4aa with SMTP id b9-20020a2e4949000000b002ad9c36d4aamr8163965ljd.17.1684221182519;
        Tue, 16 May 2023 00:13:02 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id r3-20020a2eb603000000b002a8c1462ecbsm4005891ljn.137.2023.05.16.00.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:13:01 -0700 (PDT)
Date: Tue, 16 May 2023 10:12:57 +0300
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
Subject: [PATCH v4 3/7] net-next: mb1232: relax return value check for IRQ get
Message-ID: <221edfd9824a93f0a775b9588b171d6dae0ef986.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pVibjUptFx3Xpr7F"
Content-Disposition: inline
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--pVibjUptFx3Xpr7F
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

--pVibjUptFx3Xpr7F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLPkACgkQeFA3/03a
ocVLOwgArFHdi2Y0srFLucDV5jllLDZsxf+rv6WMgnBAP3ij6vmcR39SmePtoPAZ
CXIg0NWpqEgG8LbWpB8qGoep/Z95LqKuTErM4PGnB3JMNkQg9HiQze6gC9UomWJ5
4PaLBrz8OkBmesxhUBfr1cWed5sm5MmcGN/Yj0jkfg6VrKL/8YMv86MY/rxbrgp6
kUC7E7sZtkYaibcoFTxVFcxk0PPoZnHyukomscVGUIN4iAzi120Xa9tIVJqDIE7p
vsaFra6CcUig4KQhTFXrFbD/XwwT+Z8yww+T2x9A8u4YqrWZ7SSNP/jaJW8hZzs7
vP/UVCTCFhJxwdgwkQL2wCA3XCaeqQ==
=lyHM
-----END PGP SIGNATURE-----

--pVibjUptFx3Xpr7F--

