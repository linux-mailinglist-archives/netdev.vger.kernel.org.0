Return-Path: <netdev+bounces-5526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5612D712010
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 760C51C20AF1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4855246;
	Fri, 26 May 2023 06:35:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4EC2100
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:35:47 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A5C12E;
	Thu, 25 May 2023 23:35:44 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f4b256a0c9so330023e87.2;
        Thu, 25 May 2023 23:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685082943; x=1687674943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cAIWAVxuFetjJrrCyLkzZqPv0PDDDlU03pSzLI8bStI=;
        b=KxLR7HhkToIa5w9ZUoeLebvrRtTscYrXQvjH51a6aqQQIv/U4/P/ll2ivg3KNhai0X
         se9u67YaW86IKQJnDnLFmqGwaErx/BTEjJdo88RyFnFrws85sWUGzqqG0lm5eBFSrULu
         PZEHZOYKQu4dPje9vjVBNo+aR8lbnwt2U71aH/rFRctXC3u0zt4JEaE9+wVoHCfzhc3R
         zFC/dAeGjOHnGLibwG86PXjg3zNRphwdezIN4fe/OZ0hQE3pByDjoVEGsKl4DgysA3Z4
         tPoXiylXe5c9da0pAGLohe3ay/eOY9nMk+0mOqDoApeHeHqJ0eiJfhuI5dydZkTHCMqO
         aQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685082943; x=1687674943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAIWAVxuFetjJrrCyLkzZqPv0PDDDlU03pSzLI8bStI=;
        b=hyMTh8sKnRICOqOQSk8Kpwqwtng9/OfkhwyekkExD7et646IXveReRwzXUqBbHx4Ox
         OCTABG03Rvm9ZzNcja7OSdB3lsNbToM5nYiRtITHIE2ObXtEC8I8WPqHhebGpflN1Qp5
         2Sa1HxGQwC0iU5Qz2tnlQiuHL3tp8LBdMmAGQpzT915xnnxCas7bh4Xyr2XGxrVgFinJ
         i8gRv+1ldOQ7eS4gx5mRUJen7WdpmB/giGuGbRWMtbfJkYeg+fNuQyNozEvWqTiBEJkp
         BP8gsL58r66UNwat2gFPdF+f47Ap15gogsgcgGtz0HAGqpoYOjjj8axW1QR8Q6MXawGU
         FBwQ==
X-Gm-Message-State: AC+VfDzYPz176MrwutALXBHpAVQoKW01P1nqIi1KGjWaEYswhHbfplRb
	DcAAmiaF73zt+t8c4nBV0/4=
X-Google-Smtp-Source: ACHHUZ6HZepBt7ammknEbdGsV8Qlb/uNlO/ttwYaQ9PJi60bot/xBl45aYSe7ERRZ/kwxZvicu9soQ==
X-Received: by 2002:ac2:46e5:0:b0:4f3:8143:765 with SMTP id q5-20020ac246e5000000b004f381430765mr240488lfo.27.1685082942778;
        Thu, 25 May 2023 23:35:42 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id w17-20020ac254b1000000b004f4b2aa6f66sm487671lfk.295.2023.05.25.23.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:35:42 -0700 (PDT)
Date: Fri, 26 May 2023 09:35:30 +0300
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
Subject: [PATCH v6 1/8] drivers: fwnode: fix fwnode_irq_get[_byname]()
Message-ID: <f457a106929e37638a87775d8d72adaff0f85cb6.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MpNVpml8SzZtmtjR"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--MpNVpml8SzZtmtjR
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

---
I dropped the existing reviewed-by tags because change to
fwnode_irq_get() was added.

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

--MpNVpml8SzZtmtjR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwUzIACgkQeFA3/03a
ocWl3Qf8CNu2jLOOzjzDhnSm2xnKHRAK7eRA54Otr1t/U8jJnk2gvcCavb7O8t7C
YnkPPeyB2ZbSfZF5rHXHVRT9rF6gPMaO1oCGUYOnio3ORsFQWmj8veEdR0H9yGsr
Enhdoe3n6ovgylnyoAfFezf/w46tUhYTlWbppxSkqaMjkpbVWfpIbxQvnkqBrIR+
9E+Nzjrx22zR6+uDNY1nq6LDy/0fNe2UTNPwrQSPrlDnh/8CToauRF5CsbQVK8jE
LEfRPOhSQm77o2ZSY7wFNJ0anULJWpZu28oqyy5Oy3YCtPPxcsXqbmuAN9GnQktj
1BlOfxKCVtxUKiGEOgcEkwFmzznJwQ==
=+cis
-----END PGP SIGNATURE-----

--MpNVpml8SzZtmtjR--

