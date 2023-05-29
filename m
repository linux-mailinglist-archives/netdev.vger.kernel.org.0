Return-Path: <netdev+bounces-5991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC8B71446E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 628A228061A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 546677FB;
	Mon, 29 May 2023 06:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E637E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:24:12 +0000 (UTC)
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B270B120;
	Sun, 28 May 2023 23:23:45 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2af189d323fso45624371fa.1;
        Sun, 28 May 2023 23:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685341424; x=1687933424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w2htrHoUb05zFmZyVZPES7QukPQYRc3jomIeB/klZj4=;
        b=IxHCLBEQHZEy3VFtdTPnx9aH/KeZUSVVV6J2ZxIGnbc6vzCFZcXnJRaiNvV9bp87IR
         zPdIC7pG2Has+iX4gz80yNYcIrsYEkyozPgr13tiiEdLJrXVqkgfgyWW/OPQhzawhhPk
         PDS2T7BMLVOup6Qy3jduIa7Vkxg2OIusXmz9zzSJCDP7enxn9lPJ0EdZ+FQTqaER86Gg
         nIcVREeVCpEmUL3H330jO9BSlBUdDtFL9zE7gu+ZWhHgglTA1g2wdxxSVlWnDO6vn1QO
         UglBZjC0xm17V+cKrFTP6Vi0XFSEPvBxGy30o/IGNL9ET8y8mVDX/7F3XJUXbrYspHmH
         uMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685341424; x=1687933424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2htrHoUb05zFmZyVZPES7QukPQYRc3jomIeB/klZj4=;
        b=BX5k2U9SKMCqUw9vNIn8AdG+MYuPjQvXSPV6k52yS2DE376XomO+EjaFZaPyeyjr7M
         hMMzlJ9yeMhUCPIJq5E3EcC2H32az6nEJKnjZMXTD6TL82znKi6epe91cyDitX6BcwTD
         hZqEnL//TyTxsg/B77kIbCNJ2iyyOPi1KkygbRB4+VkVnUhCneVEoyu+InZIGWNi0Mnz
         9SbxmKuTkQwUp0JSiOVotROuMSLcpeXoe/HLVdhYRKtHY8NtfTUQX9lVcTmMJq++G7Sc
         KqVEKakzj7ya0a+aVp4jqFlDAhXchAQQ1URnP64cy566onp04eWhw/ghw6g5YMk4cAf2
         F2MQ==
X-Gm-Message-State: AC+VfDzm/5gW1xM6Et83hAv2SzqRlXxi30x2urYXeOa3TSzSZJJ+/ZiB
	YDRMTVig22aMTroT1V8GpUA=
X-Google-Smtp-Source: ACHHUZ5EsZDMvzcaTCxKwN7I1InRz+1d3odGsFjAUNoMY0h8dmEoco0VfBem50IfM5IWIoLSRPDWqg==
X-Received: by 2002:a05:6512:2302:b0:4ed:c64a:4aa8 with SMTP id o2-20020a056512230200b004edc64a4aa8mr2821216lfu.6.1685341423888;
        Sun, 28 May 2023 23:23:43 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id v3-20020a056512048300b004eb0c18efc2sm1833053lfq.221.2023.05.28.23.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 23:23:43 -0700 (PDT)
Date: Mon, 29 May 2023 09:23:39 +0300
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
Subject: [PATCH v7 5/9] pinctrl: ingenic: relax return value check for IRQ get
Message-ID: <2b52e5dcdcc50e2f932184b5816e5f7ce678210a.1685340157.git.mazziesaccount@gmail.com>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="RQYH1ecUNFtPH4cO"
Content-Disposition: inline
In-Reply-To: <cover.1685340157.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--RQYH1ecUNFtPH4cO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

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

--RQYH1ecUNFtPH4cO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmR0ROsACgkQeFA3/03a
ocU8vAgAvYKAgRXg4MbPgzQs85PpQLmD3+uJCoxGK0n/DgiV9a4WIzyFLx1gLVmL
1ThzJ9G/Bd6DKF2GK4la1Jwevx9WTi/VwOzwyUZS/9D/3XuXP2YJ8xSME1DWO7mc
SglYisrGyU7Z7xpkdMF8RYQPOEYAo0AboMKpvLnQrUNqONt76pZTsfgwqd12F7nc
kBWaaShy8GycuttI69xWwYbmNym38lRicAXq5Tsvl+R/Kw5J5teLREbpg/8olt7I
W4kr8VlLBWD+ISAFmsLhxZFRtm0c9NjhXNU4SC0ryIjSN0Sxdu7YHo9BhPdnQd0h
w7xGT/p55vZWXAZ0SPKP5Qb/nI0JZw==
=oXpg
-----END PGP SIGNATURE-----

--RQYH1ecUNFtPH4cO--

