Return-Path: <netdev+bounces-5987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4434F71444D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E77C4280DEF
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5240E7FB;
	Mon, 29 May 2023 06:22:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409D37E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:22:42 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B10C2;
	Sun, 28 May 2023 23:22:39 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f3b5881734so3268562e87.0;
        Sun, 28 May 2023 23:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341358; x=1687933358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JRZkhSfNi/CahwvYTKjgmeTw6RKVKTnQbqpayNzly3w=;
        b=NgR/fbJPAxlA6ez4qMq0Ef7YeLvwdGjfoAR11dyQrwOqRT3j5c5e3HOaCb7pOtnDWO
         xHoYdgZIg7kLKjsza+J0mrXKaFWuH74btl0Y/4OFE9xhyn6yppFKZtCO7WwDzLR9SWiq
         v+zK4NTRcstq4UOtSjQ5OyG/bsgXK11Eq20CMlIBJEhRSn3ROKcu3A0ijeUqmCWj4rq7
         M+ScwPFEoLcV7G8Ylh3Z8HQsaXK82shh4Oj95VzQLO893tA/3VL/epny988lwT7cyTED
         U2TBpUQXCuBaISPLj7a0T++zoH2qn7WZfIotXwPNNYoJFEDPjzAB+y5CvdSp0xNe14bn
         gLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341358; x=1687933358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRZkhSfNi/CahwvYTKjgmeTw6RKVKTnQbqpayNzly3w=;
        b=CRguAAEK8C1khJO4d0uAJlQyn24mbUn50ejSgeritJ1m8brqAY9q/iODcdFY7sCpty
         /jhgL8YrKcZTw2ccReEIMqaEKpmArGyvVDLuaECZN5ONRLfIVUY7V7rg1/plNpzsLwIT
         7PyJeJN5d7C5/Yxm6ewEMVzHgZ0AuTm4eYNe3fCDZaq0OM2gD+NEeNim7Xb1sMNRAGOq
         5HELW01h6/Vc7R598nTql/wCYI8JoCO07HiqnzlvEJUfEew4bTSP0tWnA9AcnnKh3yg5
         WbP44B5oM/nNxRBTbY5Lwp7aRXK9K4Q2AEzj+v/zrq9/CIyzoe9DOnFYVt1X00tPa4wr
         QxJw==
X-Gm-Message-State: AC+VfDyvAJ6Yihnej3sauXvhDBAwsh7eVVVOSvnJcd52da/UWbYG9mkh
	rjbgjRdd3tkJEFu4rTFHTe4=
X-Google-Smtp-Source: ACHHUZ6wvKe9g6Qbup/bwc9NSfP1EJvYN8Xsp6qQDhosGVkK5RzPW6tDvpf3J5FhHk0AlCPih7BAVg==
X-Received: by 2002:ac2:5298:0:b0:4f1:5010:4b34 with SMTP id q24-20020ac25298000000b004f150104b34mr3954548lfm.18.1685341357703;
        Sun, 28 May 2023 23:22:37 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id z3-20020a19f703000000b004f11eb32f20sm1870130lfe.13.2023.05.28.23.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:22:37 -0700 (PDT)
Date: Mon, 29 May 2023 09:22:33 +0300
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
Subject: [PATCH v7 1/9] drivers: fwnode: fix fwnode_irq_get[_byname]()
Message-ID: <3e64fe592dc99e27ef9a0b247fc49fa26b6b8a58.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="d0SdDmkUrqipDMDe"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--d0SdDmkUrqipDMDe
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
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
Revision history:
v4 =3D>:
 - No Changes
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

--d0SdDmkUrqipDMDe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RKkACgkQeFA3/03a
ocW/sggAtiSReQyO+hEipTMoCjONOi3/T6FwbXBn6NUUakrhTIMT5IfrfgA1LXCH
aYaMi5lPZVBGdIks7DuFqctgt9Ccnfk8dRFWZJlGm2aThQmB5pX0+BS0OOlWmlmp
pV80t6WGKpEgyubqn7nOqYeXoKHBFKBTChf52E5HgppGKHm3lU3Gsg+ZvCcJ3jQh
53k8my/bwrKEjdcBfZ9KPYCwX1xN57iwELuO6ANTIZqIX2W0RqjNKGnc4R94pKvt
EqUme6tQgscHvndmEiY+hq5i3clwxUuo4/PF7mH6SATxxFHD4X6EFDa3T4+3vvRO
OkNUYblbeisq4XXpXnbh16wSk10gGA==
=sM2l
-----END PGP SIGNATURE-----

--d0SdDmkUrqipDMDe--

