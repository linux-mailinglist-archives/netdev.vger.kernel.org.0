Return-Path: <netdev+bounces-5534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 092C9712050
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9ECC1C20F98
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A922539E;
	Fri, 26 May 2023 06:40:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7062100
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:40:11 +0000 (UTC)
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4F610D7;
	Thu, 25 May 2023 23:39:43 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so349122e87.2;
        Thu, 25 May 2023 23:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685083182; x=1687675182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r8WxArmJoZC8xqHylJdU5AGk+XIbCJbogTeDfs0y2fc=;
        b=kZlxofiucY8/Lfp0amC/THuRlzjVm4QfLqqW0v8XoWvGEazpIcKfv+6Y3Hkn28xoPU
         QfGXd7HkgrTwQ7CNDgIIxnupjEz612uEqGABVzbMzhsb3UBA2jm0mgt2VHWoKOAuXmsN
         VoFAX2icB6TKFkhF6SS3ZcDfsVrB95m4IDnEBZKQRCzUMgKrO3rab67HUeLHwPmnbOkk
         eU6j760c569VapRpeY/+vjs6apRsTp67TJowAAq0MNV7LVC9PoFNzE9UR+PZOD/CuW3p
         ChtTT4YO9tj+T6H6Cksspq3qsVrEGp/722KN9wUHFz63wiU2cDlaZyUWlHhxkheWZ0DC
         eYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083182; x=1687675182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8WxArmJoZC8xqHylJdU5AGk+XIbCJbogTeDfs0y2fc=;
        b=YFA9TIX8E2PH6upJmkKC6t4+seOzjNNIbI3lSIpSBBAaCUiwktzzRYaUtgTbZFXTZt
         sHYzTxwnJOd6dfysK4sx1/vHDDJR7WlZdmVUPkprG7FMUmbvSsEGmyYi3eHVoresdeMy
         jlyJFUThzZdYnKXiKY80/iF/q94osJEDAkbWOuBt3Px8xIzWKXTX3eoaWDf8fWNg3dgP
         f4/AR8toZDRDUcYxG1DyLHbL1VPQuVL64JB6mKQ/AB8zp8TGLFNVyLHX/EpbM5cAy3kD
         ksMxS/oQ56Q4X+zL5e2mKbSy4Yh7hWSP3xLwgCu/LK666xrjMQTZXvcN5JCmkTWjd/u1
         fXeQ==
X-Gm-Message-State: AC+VfDx9Sz/Tzh85iQLtm0Ye2fhRMzhx2T0gmaPsTQjjTMFBacU2Mk0A
	jZcBEOnIlHVpSi8FzGyd62Y=
X-Google-Smtp-Source: ACHHUZ7suqP34B7zhh7d+MVDHYwTRa3XCDJTVoRDJ3idVkc5oKu76GbAuL5+UGbLruSq7U8YqZfIpQ==
X-Received: by 2002:ac2:5deb:0:b0:4eb:1361:895c with SMTP id z11-20020ac25deb000000b004eb1361895cmr168335lfq.55.1685083181695;
        Thu, 25 May 2023 23:39:41 -0700 (PDT)
Received: from fedora ([213.255.186.46])
        by smtp.gmail.com with ESMTPSA id a22-20020a19f816000000b004f3789c8bd5sm488291lff.132.2023.05.25.23.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:39:41 -0700 (PDT)
Date: Fri, 26 May 2023 09:39:37 +0300
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
Subject: [PATCH v6 8/8] i2c: i2c-smbus: fwnode_irq_get_byname() return value
 fix
Message-ID: <1c77cca2bb4a61133ebfc6833516981c98fb48b4.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="H4EfgDTIilQ8R8lz"
Content-Disposition: inline
In-Reply-To: <cover.1685082026.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--H4EfgDTIilQ8R8lz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The fwnode_irq_get_byname() was changed to not return 0 upon failure so
return value check can be adjusted to reflect the change.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---
Revision history:
v5 =3D>:
 - No changes
v4 =3D> v5:
 - Added back after this was accidentally dropped at v4.

Depends on the mentioned return value change which is in patch 1/2. The
return value change does also cause a functional change here. Eg. when
IRQ mapping fails, the fwnode_irq_get_byname() no longer returns zero.
This will cause also the probe here to return nonzero failure. I guess
this is desired behaviour - but I would appreciate any confirmation.

Please, see also previous discussion here:
https://lore.kernel.org/all/fbd52f5f5253b382b8d7b3e8046134de29f965b8.166671=
0197.git.mazziesaccount@gmail.com/

Another suggestion has been to drop the check altogether. I am slightly
reluctant on doing that unless it gets confirmed that is the "right
thing to do".
---
 drivers/i2c/i2c-smbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 138c3f5e0093..893fe7cd3e41 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -129,7 +129,7 @@ static int smbalert_probe(struct i2c_client *ara)
 	} else {
 		irq =3D fwnode_irq_get_byname(dev_fwnode(adapter->dev.parent),
 					    "smbus_alert");
-		if (irq <=3D 0)
+		if (irq < 0)
 			return irq;
 	}
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

--H4EfgDTIilQ8R8lz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRwVCkACgkQeFA3/03a
ocXmFggA0lKFBzYI45TejrFqGuuYHu+8Jvkb5ZtRGtbzJr/G+YTwI3+Lr7UsBYWK
ExhoeK/JVn9hUHfktDxlb3ibqhvv0w8c/YIqlYpPjie1RoOnaibtvLSDdeZWImpx
J5P0HgPCcNmYzf7HB+EkBPbO3A97rjoEPRqQrDIKlbvXKeVJ9UOe5aozoTJ0Zbks
vS/xjtofsQFeG4HY2AQhdJxzeK6rN6icW268kNmOH3HVwmWLxhM95yGReoA5AIrR
eB9LBNORgHJgWdyGMuXS8DKHmLE+IRAYS0z3yPhojk9JHTuNfLS1AkycuMOfGKZM
nbpr1az2DNhdzKL/dPApFJ5Ee7Rxsg==
=nb3R
-----END PGP SIGNATURE-----

--H4EfgDTIilQ8R8lz--

