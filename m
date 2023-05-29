Return-Path: <netdev+bounces-5989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC6CE714460
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D2D21C20964
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12807FB;
	Mon, 29 May 2023 06:23:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBFF7E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:23:39 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C7F134;
	Sun, 28 May 2023 23:23:13 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f4d80bac38so3085033e87.2;
        Sun, 28 May 2023 23:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341392; x=1687933392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5OqPDAL2F4QbXTdxLABb43Nxq6BhvQH6mCnX6PKiQV0=;
        b=FbDQWAv/B8gGGeiI9XYgfZtuUTwRPawmowVgzsiILnKJxdjkygbCHLuFJeqeI1tqBr
         Id+hfBeeU/CnrNOxQ9ryAfsACFaTaJE4brEpPkJ4A9bX5bA563QEfxc3OwzfsXdIdK+b
         wgawaMDoZjtajPCqUW/xitf6H9mgUO24szOTRDakwCSIKjge+vRSQtzA8QYpAwjwSwvM
         1XLrMVsK/y4t2+Dq5T0MPCRhNEQILwwZxSV0+8E114azpYreE+14ugKumaDACaZSY352
         dfI6X6htSm+EXP5zKWJM/yjEAgZcNUOw9dODX+twIoIrHELPtkO9RdyU+kMdZymWoHiI
         c32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341392; x=1687933392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OqPDAL2F4QbXTdxLABb43Nxq6BhvQH6mCnX6PKiQV0=;
        b=d9fyu5gZG54cdu4/ESUFBiFii0j085hC7zHX/l8b0FnsmeyCjdoe+AFqr9+kZRGWXM
         SVJJk1Oo3JUaRs3C5G1W3e0i0hJr0gWdZalpAhC42Hd7bcFzsukcGpjuvi74aLYQzkV4
         59ZMC4YFNyYiPebsvnyh3raooriEVz+jT7lP/lSpP8qh15O4E8EkF4MK7tWtO4EzyvN6
         DWpfCCtzeOTrkqVR+5H+RUhRb2RkbGZ6Zl/1zqJ1UVU60zyFAdLyJ9g5i4UGlGs4ZUDS
         kdCgnCBG0oXTcLRSDw8KZcNcyiOlEx1n4UA7U/EqmHlGbM0S4TrZ4hZ15CDFsfS0lW6M
         xfWw==
X-Gm-Message-State: AC+VfDx+LcysKdkgJ0CaX/fQ/FD8sGNx0xgVYyyEpK5gWNn/Mbdx2+7M
	l1b8akzvlkfWUQUITYXcv4k=
X-Google-Smtp-Source: ACHHUZ7JcImE4kXr2D46Vq9JaL8Mo4Yl/T/FzxOTvbjvWHdBLI8O3eGN+4nzVTxjS3G8Qg2pD54CHw==
X-Received: by 2002:ac2:5306:0:b0:4f3:b97c:2d91 with SMTP id c6-20020ac25306000000b004f3b97c2d91mr3046276lfh.66.1685341391834;
        Sun, 28 May 2023 23:23:11 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id w10-20020ac2442a000000b004eb4357122bsm1844301lfl.259.2023.05.28.23.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:23:11 -0700 (PDT)
Date: Mon, 29 May 2023 09:23:07 +0300
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
Subject: [PATCH v7 3/9] iio: cdc: ad7150: relax return value check for IRQ get
Message-ID: <d080e384f9122349b86780b35496f69e5d995f9b.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="z7sJSqJhgMWGskkj"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--z7sJSqJhgMWGskkj
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
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

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

--z7sJSqJhgMWGskkj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RMsACgkQeFA3/03a
ocXVMAf+PO7mQARC7f4cPX7gu8m1IhF4z5OKFp6WT/canQyhdnxFTovoX7Lnai6N
KKZFS/EM0L3pwnMRejw2cmFXq0TeBA9u91pUR+U8UBF2yYHDBO7aVKmLz/n59KTd
0SLOyKkclmHNz5BlqVCRJAKOZkfUoY508twQDBQx0dQ50AUI6Bkb1i6FY1CvGIfg
UdRB2SkGtcHIyW2i1n9nb3fvZv2DEIEt6YZVKSI+PjI44D5gQSgfNVGsfI5PAeS9
aK9QEuDjaA4cwhoeVImrzA0jAa9q+ICzrb7vAlEJog483c46Q5KgH+YUGJR+AgMh
wQqOAugttWrf6TVsOi+g1Hqat4TCqA==
=OceY
-----END PGP SIGNATURE-----

--z7sJSqJhgMWGskkj--

