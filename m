Return-Path: <netdev+bounces-2869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E887045DA
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96F6C1C20B27
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C0511CB8;
	Tue, 16 May 2023 07:12:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC47C17AC8
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:12:33 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1D935AD;
	Tue, 16 May 2023 00:12:28 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f1fe1208a4so12906237e87.2;
        Tue, 16 May 2023 00:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221147; x=1686813147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nIQsLaHssKkl6pMh4izl/5JY75K4E7vPiAyWjhDInUQ=;
        b=kVyZEfq6Q5jbhZ2IenNtfFHWP9ROgSqyZjUzcQyz17v9aApeHKzTAiCKMRPPt8Cz+U
         sO1aikJBvml29mD0dna23tcxwWy8iHg0X56CibVfXurzDAHBQtvy3SPRBkQD9BUmzSRK
         UWGib1T+IESAZ5lTgswFoUp48FFp3s7chTAeep0cf2bZw5QodQ3QQVMiATwuiLdfSeqx
         8bvDST1CyN0vGgJFpxQNPn9RUEOeyQGRQBxtrynZzueM9HkG9B5sPKXdhwlOqikCnhmx
         j3hmIizOF/ix81U+k34v3TwnOPw5iu3mcbo/QwSHusrF9rI9a7AGDinMrTOB9bxl6DxC
         yjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221147; x=1686813147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIQsLaHssKkl6pMh4izl/5JY75K4E7vPiAyWjhDInUQ=;
        b=VqqZT1yZgoVMCjRDxsTnz/cs0Us6ZIyk3E728W8wr0Q93hrTZwVmYndt1WKwmNpM0Z
         x60bjYm3kDUla42gGLoFqogqR1VRi+I66X4JUpHgJlS5Jxe3r1phbs/lBPkvvWsqCyb/
         +lYiqRE/XGxFdEQrb2NfmvgLi7GiyiTd2BSavBB/uUNLAiSPSOtgKaUy4JK8kzSSyh+2
         q8pbGnTTVK6YF/TL4//LpcxgZS42f3dZQctbuAxb5SEFckhED2w04DputPYd59ZfB5xX
         SVSuLvvvi2X1KdrZh9fDp6qq7cb8H6nt+KMoc9Uy6iETbitbztcsI2X1Et7MASTz/6N/
         RyMg==
X-Gm-Message-State: AC+VfDysQ7KlMsmFR/Y0grRkGP/UWVU0NdiI6BMHLDxcuQMzMJJSwZRQ
	Dk9MOzWOGY03VwbhahS3hjU=
X-Google-Smtp-Source: ACHHUZ6JEHZtYC7O57uCCGGCuU8NkL8W8zXPnQeRN4Mi+ogX1rDd1FtJEtvrACaEgE9PUk2Ib2pPaQ==
X-Received: by 2002:ac2:48a1:0:b0:4f3:8823:ebe9 with SMTP id u1-20020ac248a1000000b004f38823ebe9mr715145lfg.22.1684221146822;
        Tue, 16 May 2023 00:12:26 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id g14-20020a19ee0e000000b004f25c29f64esm2700143lfb.176.2023.05.16.00.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:12:26 -0700 (PDT)
Date: Tue, 16 May 2023 10:12:21 +0300
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
Subject: [PATCH v4 1/7] drivers: fwnode: fix fwnode_irq_get[_byname]()
Message-ID: <339cc23ccae4580d5551cc2b6b9b4afdde48f25e.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fzqZWu+mtDdK0Jc5"
Content-Disposition: inline
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--fzqZWu+mtDdK0Jc5
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

--fzqZWu+mtDdK0Jc5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLNUACgkQeFA3/03a
ocXWBwgAoTg2gyrbSegZNG72m8qgJFB4ijYPCs2RyJCcx8WVs0X8/B10OZjD3x3H
B6+4ZYtlNLDhwBkP3H/p1F6P0g7uhRVPNR3HeLlr6VTXXnO4o2KxkbeOVIEcidf0
eR0hR6PtI7qKbYZvqKLOJetWefDRVlaARk8xy6G0Q+6VNShxm+TDBzJ1SklJnrSw
sIeyeK41XqMbQ2PFZzWW1REd0ai0wyYCKTQj3h/oawsZDS0AT0JxIAlsW1W6RAfo
F/4Z2f1fsrHX2+/7AX3h7YWzUNVgjaPIHf1qV+GlulWzUNY81k6PAdH9b+rbHnP/
wAxUsuKyRch+fUgLBJWNfIk670GzUg==
=9vGc
-----END PGP SIGNATURE-----

--fzqZWu+mtDdK0Jc5--

