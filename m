Return-Path: <netdev+bounces-3874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B45877095A5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A76131C2124B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1012E7499;
	Fri, 19 May 2023 11:01:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FCC568E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:01:46 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3616D1BE2;
	Fri, 19 May 2023 04:01:12 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2ad9f2926adso34391261fa.1;
        Fri, 19 May 2023 04:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494060; x=1687086060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oY1HYSQizqf++ddJ9pIAfIcp1VHkJcel6jxA5ixO9Ds=;
        b=IDpkDXNP+kZGUOjDbquAIu8yEdEqWAlhJ7BycF2yRZK0PX+d1qr9Z/GhnVwsxqGoVb
         nT4fuXwMGtQLMGkczH4zGgyQHbw4t0ABMJR9gLLF9DaHv9j9huaLkHkE3Ha2oIMY/KIv
         4RqFwJ1cDMjVv6uppJLKmCOn8XaCzufgu64VGOlW5j8UM1niBuZ6oHk9JCuCOXOS/vrE
         BtA0u7mgRzltM8XiVpvFbg+dOZCAjVDrtQ/XEgVKII8GYwW01/PfkmjCNWBZxAUHQCyi
         u9vKF5eIUHdVu5K5nvKmNpoNpHT7C8ub4tWDFbSD/xWQDdoLP7swIolp4H6h9tPYFb92
         PDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494060; x=1687086060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oY1HYSQizqf++ddJ9pIAfIcp1VHkJcel6jxA5ixO9Ds=;
        b=CedA2cBco53eUQNfVhQlLA0lhJT2eszU5wQZsF9M2TZIDBN/18WTgmykbiUvdPqzaE
         CXf9ts5z3W9sCYIqVr1kZMBMzQTy7Dj4hurQT70PebRN20q6ZOx/KFF9OOPUB3Na3MDD
         O6wTDvgE1r/EZCldcS8QC5IkR8RgZCiRUsuEaDUeZHW6b8R8qZRspILNRh7mkN7lHbUi
         Ut1vOdlcuSylRYj3MQhxWfpL5oaBQxogXhiiYCaPyfayeTXP8N8i9lFDJNR4UYggKd7Y
         6pxLQialGCGpwR241aBOHMLnUsunxzfK+7Iy3egj1CLAFgMz8oy06iyT+EzSxfAWHhRU
         uGXQ==
X-Gm-Message-State: AC+VfDyryOtf1tWLooEG/+VrTQtQHbiqjc5uSE8ngn36/v1eKyFZ7qIQ
	b6FMq5t30mkI0vwPd3OLaWY/nIN0iVo=
X-Google-Smtp-Source: ACHHUZ4Yb8yh3iwvBtOkG3lkvyDjcH3Ey0hvO6TIGUNMT5QvdUafoy8WA1B2PrgGV5c4duioNIo9nQ==
X-Received: by 2002:ac2:547c:0:b0:4f0:1e7d:f897 with SMTP id e28-20020ac2547c000000b004f01e7df897mr768560lfn.17.1684494060124;
        Fri, 19 May 2023 04:01:00 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id o6-20020ac24346000000b004f251cf3d31sm558454lfl.153.2023.05.19.04.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:00:59 -0700 (PDT)
Date: Fri, 19 May 2023 14:00:54 +0300
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
Subject: [PATCH v5 1/8] drivers: fwnode: fix fwnode_irq_get[_byname]()
Message-ID: <339cc23ccae4580d5551cc2b6b9b4afdde48f25e.1684493615.git.mazziesaccount@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tU6wD8GYZKI8Boni"
Content-Disposition: inline
In-Reply-To: <cover.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--tU6wD8GYZKI8Boni
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The fwnode_irq_get() and the fwnode_irq_get_byname() return 0 upon
device-tree IRQ mapping failure. This is contradicting the
fwnode_irq_get_byname() function documentation and can potentially be a
source of errors like:

int probe(...) {
	...

	irq =3D fwnode_irq_get_byname();
	if (irq <=3D 0)
		return irq;

	...
}

Here we do correctly check the return value from fwnode_irq_get_byname()
but the driver probe will now return success. (There was already one
such user in-tree).

Change the fwnode_irq_get_byname() to work as documented and make also the
fwnode_irq_get() follow same common convention returning a negative errno
upon failure.

Fixes: ca0acb511c21 ("device property: Add fwnode_irq_get_byname")
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---
I dropped the existing reviewed-by tags because change to
fwnode_irq_get() was added.

Revision history:
v3 =3D> v4:
 - Change also the fwnode_irq_get()
---
 drivers/base/property.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index f6117ec9805c..8c40abed7852 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -987,12 +987,18 @@ EXPORT_SYMBOL(fwnode_iomap);
  * @fwnode:	Pointer to the firmware node
  * @index:	Zero-based index of the IRQ
  *
- * Return: Linux IRQ number on success. Other values are determined
- * according to acpi_irq_get() or of_irq_get() operation.
+ * Return: Linux IRQ number on success. Negative errno on failure.
  */
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index)
 {
-	return fwnode_call_int_op(fwnode, irq_get, index);
+	int ret;
+
+	ret =3D fwnode_call_int_op(fwnode, irq_get, index);
+	/* We treat mapping errors as invalid case */
+	if (ret =3D=3D 0)
+		return -EINVAL;
+
+	return ret;
 }
 EXPORT_SYMBOL(fwnode_irq_get);
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

--tU6wD8GYZKI8Boni
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRnVuUACgkQeFA3/03a
ocV6bQgAkFMOjbtyS4zrLbCiAlRh+q00AnzwI0kFgMmRl9l6W/Ms88Tcyl11kXZ+
ZyBzt9f2l2InccBaq76yul41ha3XIpAxz3vArpvRqEI5MxFDYoVz/2wwvs7eSltk
xNTVEsxhm+1+tY7MtITToS/rGCieMvwWRTSp/reRDtgI0m7/zYrpd5cWGtN7saDb
ELRlcfoeZQmxQSW9i7xpVcgDgeQEyD24DLKMSMhpZuYI32hrOrTsfxqZEg6cYJxm
Pw+5Pq+lQrGGbvqABzvmGA8GPwR8cciSiHT1gOmpzWCr1HDDa0Nv0Vb7lEt1s9DY
mmGcznUSTBxJXb/2UHzgLie14q3Qzw==
=mfwf
-----END PGP SIGNATURE-----

--tU6wD8GYZKI8Boni--

