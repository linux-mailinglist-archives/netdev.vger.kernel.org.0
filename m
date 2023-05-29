Return-Path: <netdev+bounces-5995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 545FF714496
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05000280DF4
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F457FB;
	Mon, 29 May 2023 06:26:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E167E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:26:02 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C9819C;
	Sun, 28 May 2023 23:25:29 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4eed764a10cso3043213e87.0;
        Sun, 28 May 2023 23:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341520; x=1687933520;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8+bnKjskXykSg/iKyM4tx22OBuA1gQnjvmBSIg+LQg=;
        b=fFliZVkMY6bLJAuYH+zFK4+JAx6PcjcFknIiq781O2oY3I435SWATGl1m+BLfl752X
         9VF5qvU7gxfrJcCYmb0eAg3X65C+BMJ3nFUxTBQ0/y7jHU9eQ+9tbfJbLNrfDTBwom73
         tQ00BJhN236S6OG3HE2gbGrJqlo6ls+rTxX7WUcgwmL/An/DgfvtOswQbaWmjbRxgJJd
         dr0+1qJ+ZTSsgElhFGpPQ/0V+7uEz9iu9rxuT0m81vFZzJ9NcoAa0ZItX4q4fvbwHX4O
         SCCYEQsoM0lVFBLlzpYs2CaibCeIqOOYaOj2PJPNS1znR8dAxIHFdobqPTvcE3rtDhDr
         7eYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341520; x=1687933520;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8+bnKjskXykSg/iKyM4tx22OBuA1gQnjvmBSIg+LQg=;
        b=I9yhLMOZUDVehKqgErP+HKR9ptEVmAEmfJarvkBbpi9y3Kcb4FyLXGnAVq7sNp/a/w
         M1489/diKS6uSZO71GtDWVBsjVbbZNYm/dpQ9dtbRPt/Gc0TNTXRrqmgH4HVtjcdiXwP
         zwF5xV+yLzoq3fbflTVGpDxb8CMtCDb1u/OF04EzvaYpfQPCt/ne6wBQJnXKB5cgCVpw
         /BfsHx0DmebcOs20+y6kX1myZMcqK7gJKiVM51pQQuSfXz4txMCszTYFRomA4Mhfr2yp
         XPYYl4QnZGb5+2xps2atHjtzqzboibqGJ6XHz3GXcJNiDBUgRSWycuJD6PmWG1WOoMPd
         87pg==
X-Gm-Message-State: AC+VfDztJ4/tdjG2aPPeZWt3LJacl3tWD1Xh5JDEMj58Q2I1d/+sKhpe
	i6Cct/TCnnM1G5VhCiMZo5s=
X-Google-Smtp-Source: ACHHUZ6Xj6UKjjPlJgrfE9uMHkKDWTfWA5sR45BQylbXf8Ay6rkSnz/XTqU+Q3yir0vd0i1zrhMoUw==
X-Received: by 2002:ac2:4477:0:b0:4f5:76a:2033 with SMTP id y23-20020ac24477000000b004f5076a2033mr46640lfl.25.1685341520423;
        Sun, 28 May 2023 23:25:20 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id c18-20020a197612000000b004efd3c2b746sm1857330lff.162.2023.05.28.23.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:25:19 -0700 (PDT)
Date: Mon, 29 May 2023 09:25:15 +0300
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
Subject: [PATCH v7 9/9] net-next: mvpp2: don't shadow error
Message-ID: <16d2b244566d4993c8fb26e1e2fbd178f46587f4.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SctzMwS3S5m1hcfy"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--SctzMwS3S5m1hcfy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Do not overwrite error from lower layers but return the actual error to
user if obtaining an IRQ fails.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
---
Revision history:
v7: New patch

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 5b987af306a5..57cacdcd49ea 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5830,13 +5830,13 @@ static int mvpp2_multi_queue_vectors_init(struct mv=
pp2_port *port,
 		}
=20
 		if (port_node)
-			v->irq =3D of_irq_get_byname(port_node, irqname);
+			ret =3D of_irq_get_byname(port_node, irqname);
 		else
-			v->irq =3D fwnode_irq_get(port->fwnode, i);
-		if (v->irq < 0) {
-			ret =3D -EINVAL;
+			ret =3D fwnode_irq_get(port->fwnode, i);
+		if (ret < 0)
 			goto err;
-		}
+
+		v->irq =3D ret;
=20
 		netif_napi_add(port->dev, &v->napi, mvpp2_poll);
 	}
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

--SctzMwS3S5m1hcfy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RUsACgkQeFA3/03a
ocU54Qf8CkaOG5QvcsAv7Y80ZCZ2KrWN3VVw6ajXQPGUsVHkPHKy+YRDzxzHjWlG
vZqTFYYV+31mM2MrbjtkgoP6VKIncoMH4ZqK9iFnGFEiNmtLJRz3a7GNQVZFe9xP
xLQMMxprxtwBUpwDarlyovyuRMyKjJ00i/efaFU9o6n4vAXfwovRy9L+gbuH+vpf
GwIOUJcNG/UaGvr2+y6msRA4zOLzyef6p+Mr7MK0645A1jPhPkyfqAhfbiYlJ2b5
S36vWFgRHfjDwU/XZH4s6uT7wdPGl/CRbFeo6f5lCKc4RwWJO3PFNKofNgnV08CI
RNifxhTc8Pz30LxHLbcQQD7swjI1jg==
=xQ21
-----END PGP SIGNATURE-----

--SctzMwS3S5m1hcfy--

