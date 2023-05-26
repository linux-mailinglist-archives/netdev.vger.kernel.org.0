Return-Path: <netdev+bounces-5533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67AE4712047
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 233B91C2084E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E23539E;
	Fri, 26 May 2023 06:39:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB8E3FFB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:39:28 +0000 (UTC)
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B724E52;
	Thu, 25 May 2023 23:39:21 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2af29e51722so3925781fa.1;
        Thu, 25 May 2023 23:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685083159; x=1687675159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BgKQ1vkNDdmfxW3QiIXw+RFuGncJHJss+SZB9+fpCHg=;
        b=P8UL9cC2o5Qk8TUJXg/qLPy+TuwqH+ZvSpcZBHL9GWxnX5YEM87KW56drkj82BecGs
         byUAKqOt/qo1Ly3/1RJbu3JiXAuhOpnfRt77hUNxjMcNaoXNf91K0i7twqChQiWc2per
         VR+HrcNfzUkfdc33lJKxSb9LK4SGIqkoX7vAKAl/XNYLIZb6edNz6zbVK3O2fEzHYvVX
         DNpGrJJh0bhI1ylVLhs3R/o99zwBm/bTHZ7rHjWD898nRHRdn288q03HJ20fri7X5vBk
         Vb/gHNEQeiOyTXB8tMjttLb8vx4R0+Cjp3sb0wl7mMtrVHh0g1z/x6P2wa1Evl7fDCVA
         Qkjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083159; x=1687675159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgKQ1vkNDdmfxW3QiIXw+RFuGncJHJss+SZB9+fpCHg=;
        b=g0uZzN+oloaOjKlVhafkfnJTqwxRm+LeKChrGpYlyztKHBXwqgh5AdAB2v2r81vtOp
         asL/80MOWKhY13mdw3VL1xQY1y4hKm3fSpJ+JGbWfqxFpvqERUS53fz90yJqxpdL4BWi
         vviB2DEcHF0S00TycvlxDQToQE2Wv/AbMY4cQDIcxx1DfOMpbrHOiVTa4FbwED4EbmF5
         +levPxPK8YgZPCdHBJYxRsUABAsK5GE5xSI0Kx5sjdmnytqLQBG0e44kFrxLgNEF0qNq
         UES2Q43XEq2J39XNHcdv06fAzDrgC9euDkQa31LIfXjVUqwcfwqUzd9jvwbsIkYQtvnc
         T3DA==
X-Gm-Message-State: AC+VfDxvXEwIna6MwBF+/bSqiKlOmH4lpQtewvOaf5uRoNJBTrOx82kr
	sDpxEoewS12S+ZDDhC/C2Ns=
X-Google-Smtp-Source: ACHHUZ7OYUbMoIrvh5Zlr9sId1vCeetF/jq9fHwu9OnRVkf0weT+x2amMADdAAhh+v70yB2h57C39A==
X-Received: by 2002:a2e:8185:0:b0:2ac:7137:5f13 with SMTP id e5-20020a2e8185000000b002ac71375f13mr353634ljg.9.1685083159451;
        Thu, 25 May 2023 23:39:19 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id x7-20020a2e8807000000b002aa40d705a5sm575524ljh.11.2023.05.25.23.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:39:18 -0700 (PDT)
Date: Fri, 26 May 2023 09:39:14 +0300
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
Subject: [PATCH v6 7/8] iio: cdc: ad7150: relax return value check for IRQ get
Message-ID: <6de4448e9fe46d706bdeddb71ba6923d89ea8f4d.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="83Y2Ls1wqgtzo6bb"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--83Y2Ls1wqgtzo6bb
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

Drop the special handling for DT mapping failures as these can no longer
be separated from other errors at driver side. Change all failures in
IRQ getting to be handled by continuing without the events instead of
aborting the probe upon certain errors.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---
Revision history:
v5 =3D> v6:
 - Never abort the probe when IRQ getting fails but continue without
   events.

Please note that I don't have the hardware to test this change.
Furthermore, testing this type of device-tree error cases is not
trivial, as the question we probably dive in is "what happens with the
existing users who have errors in the device-tree". Answering to this
question is not simple.

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/iio/cdc/ad7150.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/cdc/ad7150.c b/drivers/iio/cdc/ad7150.c
index 79aeb0aaea67..c05e078bba16 100644
--- a/drivers/iio/cdc/ad7150.c
+++ b/drivers/iio/cdc/ad7150.c
@@ -541,6 +541,7 @@ static int ad7150_probe(struct i2c_client *client)
 	const struct i2c_device_id *id =3D i2c_client_get_device_id(client);
 	struct ad7150_chip_info *chip;
 	struct iio_dev *indio_dev;
+	bool use_irq =3D true;
 	int ret;
=20
 	indio_dev =3D devm_iio_device_alloc(&client->dev, sizeof(*chip));
@@ -561,14 +562,13 @@ static int ad7150_probe(struct i2c_client *client)
=20
 	chip->interrupts[0] =3D fwnode_irq_get(dev_fwnode(&client->dev), 0);
 	if (chip->interrupts[0] < 0)
-		return chip->interrupts[0];
-	if (id->driver_data =3D=3D AD7150) {
+		use_irq =3D false;
+	else if (id->driver_data =3D=3D AD7150) {
 		chip->interrupts[1] =3D fwnode_irq_get(dev_fwnode(&client->dev), 1);
 		if (chip->interrupts[1] < 0)
-			return chip->interrupts[1];
+			use_irq =3D false;
 	}
-	if (chip->interrupts[0] &&
-	    (id->driver_data =3D=3D AD7151 || chip->interrupts[1])) {
+	if (use_irq) {
 		irq_set_status_flags(chip->interrupts[0], IRQ_NOAUTOEN);
 		ret =3D devm_request_threaded_irq(&client->dev,
 						chip->interrupts[0],
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

--83Y2Ls1wqgtzo6bb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwVBIACgkQeFA3/03a
ocXMSgf/WD/SGSKZFIWdaidnDyG5PTZIgrGOZN4YfvYbIN6cu9xPICRgK0+xjBut
HsriRa5YAop+A2dkoWSLsF5t+t407ff2o1dXW37NmamNtKORvvW2G7ppC+I6jizX
LHm8tN0pNbBl94S3uv/2g17+EDsl0PZlGQEsJeeyfGKePTil+KFzo2mFIpc9w31A
TyrAjLBEjGQwwT+RAxBlR1tgFmqeZ4E3OBW/81YcULfBPi2huIenTzhtVdYKbVLF
fkUbwZghNRiVz7CsEtSmk/PLwRcL0APAGEN68rHOLKtJ9a+SULGAyWqpqHXAzqWQ
NTVk5VT6bnhwgyRgwkFVn94tveOGxQ==
=Hu5A
-----END PGP SIGNATURE-----

--83Y2Ls1wqgtzo6bb--

