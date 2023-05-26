Return-Path: <netdev+bounces-5530-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9FA712036
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB83E1C20A32
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C08C5255;
	Fri, 26 May 2023 06:38:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716B73C00
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:38:51 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5F31B3;
	Thu, 25 May 2023 23:38:45 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f380cd1019so350480e87.1;
        Thu, 25 May 2023 23:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685083124; x=1687675124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fnb9dxQpabXcqKFtwXirNw4zge4/PVN/rpFJ7Cz83LM=;
        b=LpwqhHvGK5SSL6RTCR97kfc10ze/o9Lp0eR/armCRpwC617whkVt6uHhF7PgghMYcy
         0lhZtU5P0joOmyI/SZgmyKYFhVUOdM1EkEBn/TMuS9byx9JJoQzNoph+LieI5/CJtVMY
         D8e4n6D79v6TpC/NRc4CswPdqexkUSeiu8WgGfLmEgezX1s/01sJ8GO1G2WKjK8jfXfA
         LdeF0nD6U746okKqTlF0DeQ9wMeVkaJdSg89JEBz3r4YrvCnOl3lzEOjTmrzm3hl7CTE
         139VB0WpuF5OR/MYna20UhJTqwRUY1i9QZmkMP8nqUnr0TY/U4SLqRpD/cXfzjJK2uHl
         CgSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083124; x=1687675124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fnb9dxQpabXcqKFtwXirNw4zge4/PVN/rpFJ7Cz83LM=;
        b=UjfBUg+e40XnTAB+0I6U3GhFFxK1bEKShEu7lQG9UVYqZz6EUZCpnJwPBKFs6fTENn
         XRZgy6HLSlQATsmjx3Ud6daGkcIB3bCt3Y8/kK0ONF/zQqRwhEDcEOqDaL2/OEpfSDrj
         4JunbjJ/KvjYm49AjSXlQv2WJa5utOKh6ViRml87lvyF/yPN+biV1Bi3Nj/ks2xHguiM
         JafCPAJT8u8Uw97shL/bhNV7tEQpK7hin8cijB/MkX8MpH2eZ3T5SZrj3MYFZqEkFjmf
         hPKP2NNntUZ9Kwe28/OUtg/uNyFXsjv0KjxbLm+5i0yMHy6h/iQYZYZr2bfkJAcngerU
         DSqQ==
X-Gm-Message-State: AC+VfDyyPPqWlq5cPhbxIUi46Yxgi2Lnto4rDVrx2hdl9KHfrzR0+tLk
	YqtRDaQB3+52CM05fD5rZYs=
X-Google-Smtp-Source: ACHHUZ5ImTEa7PavhV91maK0eLFhL+AAsBWGbqmK/QJoUj0CaHVhJETZEcyMg3v8zsbdo+Gbw3HjUg==
X-Received: by 2002:a05:6512:49e:b0:4f4:cacb:4b4b with SMTP id v30-20020a056512049e00b004f4cacb4b4bmr204448lfq.18.1685083123710;
        Thu, 25 May 2023 23:38:43 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id c18-20020a197612000000b004f122a378d4sm483847lff.163.2023.05.25.23.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:38:43 -0700 (PDT)
Date: Fri, 26 May 2023 09:38:39 +0300
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
Subject: [PATCH v6 5/8] pinctrl: ingenic: relax return value check for IRQ get
Message-ID: <c4d877dd94cb528a39dd9c7403159a036934d3b1.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+4Ol/5oJ1HP2706K"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--+4Ol/5oJ1HP2706K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

---
Revision history:
 - No changes

Please note, I took Linus' reply to v4 cover-letter as ack && added the
tag. Please let me know if this was not Ok.

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/pinctrl/pinctrl-ingenic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-in=
genic.c
index 2f220a47b749..86e71ad703a5 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -4201,8 +4201,6 @@ static int __init ingenic_gpio_probe(struct ingenic_p=
inctrl *jzpc,
 	err =3D fwnode_irq_get(fwnode, 0);
 	if (err < 0)
 		return err;
-	if (!err)
-		return -EINVAL;
 	jzgc->irq =3D err;
=20
 	girq =3D &jzgc->gc.irq;
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

--+4Ol/5oJ1HP2706K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwU+8ACgkQeFA3/03a
ocVKFQf9Fzo+YL9A0466zLL5jgGlSHVE02sJ5WI378VoK/fGi2vG1UpG6toFO3jN
/WsHsJhcbOmrAlH+7gTHLdGQ82zcUi7LzoxjriJhNQ6dZetmA3D65WohrWOYc3gR
dxHSGBCB7nEvOwae64sV+zVCKwy5C5PEZhNcghZKjqaBjyLtS7KY5NJ2O2coNaEO
mFddumon2TjWhcztM00lP/E8ziSoTCRDMeje0//4bu1BBZNwjztyhg+pduNh7zNf
QlecO+VQ2Qkee7j+pIK2bN1jo7cJptMdLfmWD/MukKnI9hYa/unmWGSTWZgRQyTs
n9hYMjJTXQc/wM58qJvy8mkTOsfUmg==
=5aQX
-----END PGP SIGNATURE-----

--+4Ol/5oJ1HP2706K--

