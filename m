Return-Path: <netdev+bounces-5990-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DA6714466
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 510DB280DEB
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB9F7FB;
	Mon, 29 May 2023 06:24:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED9F7E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:24:05 +0000 (UTC)
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40ADAF;
	Sun, 28 May 2023 23:23:29 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2af1c884b08so36191041fa.1;
        Sun, 28 May 2023 23:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341408; x=1687933408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qAYjfYPDkeseUEX3Qju/rMoDAuLOVXMDR9FoKi3lXW8=;
        b=LdGoCbTSxryOs8Qo3Ri/QyjATODUIwbB9X0bApaeks2mrJVyUWgpAbsz4csJjgqLVy
         r4MJ9L74W/bkS4zpCN14qkNvZDnhjUQHBzEUuPOj43+ZPbyHQ+YwU5VelRkeEwrRhgfV
         XAzUHoKVuRdP6rJ7MGfBNA8vLN7lvDl2ff4KWd7T6eIMMrFkeO4bV5rfr9XxWq+GzDZd
         R+0L28kyPVXPITJZUEXwl+2u+m9hKMH1Hs05+ubkfEv31dQ9YvN9EiOrQ309jxzSoYFm
         OEuGO7CgfEXSN5G30leLZMDnoXFoLcTnfj+hvBcLvVAujxOYK/2Yg6RJD30zSl+1sQyp
         1jLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341408; x=1687933408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAYjfYPDkeseUEX3Qju/rMoDAuLOVXMDR9FoKi3lXW8=;
        b=ZS3m84CicR9JqCn/1vdS5A/ngTe0qE6Be8gcxTKfJTqzVXPe5ZgroV0oeNamVgvMZb
         vWjBYaVkqcw1VwChq7jur0VUEsVEqA8/OAWanBs6NMQqMKs1sk/0yqtF9dSrVVQrabrb
         VDKkqKdX4LTy/873wLAZh4vxdET+I0GC8oDlAOmn8I8p3FktMXFyX3aCo8gQq8QtJ47r
         7F8rtWq/Ky+VBNb/3jUGdUYafA16sbz4Q0OkKgK1Zr5XhYRiRvdt9W1ZaSxUJIY5ey3+
         Y1pqlzYJq+nK+HWeBNNNYkYnmeO4ez5l9U3nmtpHrJB7rDPx6vcBBNstzU/Dtbu9VNG0
         57CA==
X-Gm-Message-State: AC+VfDyEYHsER5H2Z993HATrJGTapiTWiQ+Xe2TehTZvFQDIOmJbc9b+
	BDvzq9znoRj2iccPovMR5e0=
X-Google-Smtp-Source: ACHHUZ6Wzd8EORP/soOSqvLc1RQARXsD4vdEjqHtxoqGB6E7ai03uoQZNFPpavZeUpcBp1H64LhQUQ==
X-Received: by 2002:a05:651c:2044:b0:2af:222d:9695 with SMTP id t4-20020a05651c204400b002af222d9695mr2224914ljo.9.1685341407947;
        Sun, 28 May 2023 23:23:27 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id u3-20020a2e9b03000000b002aeee2a093csm2306817lji.59.2023.05.28.23.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:23:27 -0700 (PDT)
Date: Mon, 29 May 2023 09:23:23 +0300
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
Subject: [PATCH v7 4/9] pinctrl: wpcm450: relax return value check for IRQ get
Message-ID: <659ca38e756b724b4192ff2923e8fdf6970dcb8a.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tmsiDw0gNfKCbTvd"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--tmsiDw0gNfKCbTvd
Content-Type: text/plain; charset=iso-8859-1
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

Drop the special (no error, just skip the IRQ) handling for DT mapping
failures as these can no longer be separated from other errors at driver
side.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Jonathan Neusch=E4fer <j.neuschaefer@gmx.net>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

---
Revision history:
v5 =3D> :
 - No changes
v4 =3D> v5:
Fix typo in subject "elax" =3D> "relax"

Please note, I took Linus' reply to v4 cover-letter as ack && added the
tag. Please let me know if this was not Ok.

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/pinctrl/nuvoton/pinctrl-wpcm450.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c b/drivers/pinctrl/nu=
voton/pinctrl-wpcm450.c
index 2d1c1652cfd9..f9326210b5eb 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-wpcm450.c
@@ -1106,8 +1106,6 @@ static int wpcm450_gpio_register(struct platform_devi=
ce *pdev,
 			irq =3D fwnode_irq_get(child, i);
 			if (irq < 0)
 				break;
-			if (!irq)
-				continue;
=20
 			girq->parents[i] =3D irq;
 			girq->num_parents++;
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

--tmsiDw0gNfKCbTvd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0RNsACgkQeFA3/03a
ocXPgwf/Zi2Bv7qbgYULt7Nb+PqfNYF1ZToUT1Yd9YsuAEXhr3hg2j2ioY7GPKPb
mTY19pax+3TiNp1UMDzKEM56YSvoDnmH7W0LOfmY4TYwYW7HCIKUbOaxBdryIxxP
KlqB0v3GJFtJYZ6kXkYRmIpoim//c1tq0AeAyGItckYQD9K5WZwr/MtXFYSvagRb
KY8NfeW5zCV21dYUi5GwrJn4x0j6G9AKa+6q4MTYNVcA/jpbJLfa5nkyUI6TFoMF
a8C+tN3GCyfmTz72OgM/mnP6py9WojJgEYtfVkuNzFUztOK7N+tctbX27sNVe85W
1LJjc3gplowL57qhGAzvC9OCcawnUQ==
=hJsa
-----END PGP SIGNATURE-----

--tmsiDw0gNfKCbTvd--

