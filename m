Return-Path: <netdev+bounces-3884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C68C47095E7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:05:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81413280D7E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69528BE6;
	Fri, 19 May 2023 11:05:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3508821
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:05:40 +0000 (UTC)
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3EF1703;
	Fri, 19 May 2023 04:05:11 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f3a9ad31dbso1476735e87.0;
        Fri, 19 May 2023 04:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684494309; x=1687086309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P378hHq4N3JMZZ8BxEOLVTa4riUu6d9EihNhy7E+0is=;
        b=k+2XNk0HnwQQAxOVF60+teE75k+Oj1fbP4St1f+fNi9cPlQvvAa1J7TqhcjTWlzH/g
         XG9ZHc1K25RU1Z2jAthkQxW32TOA0r0VKqB1R89ErydtnGmfn1TwEiZmV84AHJ4K7DDc
         wDGeF2AbWDX48vdZX0bmD3m5F/rdbWLfNAsLwQIE56SwX6i0RFbx2zs+UZZz1SFuh38/
         fr+3saVisOrzNYmRaH3U0PKy2k77E7lSo8NzJDVVLlMroZh6e+45Kq3T8BGhgLV4Grqd
         unY54kOrYcw1BRKjB2RlBovdHKyduBMVCznG7mi6Qb+1J/v8m4Xh7uVYgo8PUBejE2FS
         VB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684494309; x=1687086309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P378hHq4N3JMZZ8BxEOLVTa4riUu6d9EihNhy7E+0is=;
        b=TtpmUWK+DSteo2P2n32nSQusc6dm0DzsQc/Zq+Aq0pLKw6bIsPfDTI9P5U78XHGOFo
         I7t8V7whfBZ5mg+S25SQaxzqiIGHFYEu3YMyvRYXVqnh+p7qRnmSKYr2fGMefpWOU6y0
         JluA2A4OxR0rJh/hhzAmWdMdxCo/xHlMKsZeOAmTODfn+F6BeU7EHLmfEwC5y9YgRUXZ
         u9SEpmDH5lf1IJO8y8rpRSoGrligczf9a9jEuFSAiFw6pJlhWTRVa0XPMfsucVw75tCi
         NUB2pkRmfFCwbjfgyGIrm7SSkx4uJTbe31S2wY8OTEt7LlYs2Gqg+HSAs1YZkT4ZifHe
         dx5Q==
X-Gm-Message-State: AC+VfDxqnvzhcKYursM4JGiUdFvLSx4RUNKqesDxKHNEbD2fIte5KBJa
	5tkf/R+gRGNlMBEXrkRoo7s=
X-Google-Smtp-Source: ACHHUZ6P69UimKvAR1WNjNClNfxFP7Z3tLtNF+uAexpUlXkKrWsld8MAHgH7DY6ZI/YaQFwkfC3AQA==
X-Received: by 2002:ac2:4f8a:0:b0:4ec:8853:136 with SMTP id z10-20020ac24f8a000000b004ec88530136mr648825lfs.12.1684494309113;
        Fri, 19 May 2023 04:05:09 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id y3-20020a2e7d03000000b002ad988efd73sm783732ljc.14.2023.05.19.04.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:05:08 -0700 (PDT)
Date: Fri, 19 May 2023 14:05:04 +0300
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
Subject: [PATCH v5 8/8] i2c: i2c-smbus: fwnode_irq_get_byname() return value
 fix
Message-ID: <d2749c8f5f2f3d99c2049d5652efc7c2318d8b09.1684493615.git.mazziesaccount@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cERw4jF3C6RL21eM"
Content-Disposition: inline
In-Reply-To: <cover.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--cERw4jF3C6RL21eM
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

--cERw4jF3C6RL21eM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRnV+AACgkQeFA3/03a
ocVUPwf8CgYpr8uh/bwuPx1q9qIB850v05IJYNTncQ0NjKUkuWfwkJD9ycWFIIqD
o+m2zsrcSf0nYdZczy6xJgWH0VrjZ1Klt7HW+NkNj7u6jsumWV9BdPAMOHHEQhKs
6sdm+Bvxms7xfTV7HgZRlDfOONfNo0KRXDneniek+OhrEstbHI1qy3XFVWbyo+ay
9xNgauhmaPbCVn+IX5hsgJIbvFDgYtF49TZBw9ZKOxAde21vYOGBn+cu4if/DAJv
Gb23EgmFnee/eEiMCPYU4CbAOpNChMTSLpw3oJb4kGk6vkOH/8MYerQtHZdVebMn
gTw43TKhczVIXtT/t2eUH2GUs/P9fg==
=vcE+
-----END PGP SIGNATURE-----

--cERw4jF3C6RL21eM--

