Return-Path: <netdev+bounces-2874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A652E704600
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A69B61C20D6C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C066917AC8;
	Tue, 16 May 2023 07:13:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BF8101EC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:13:57 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EF146A2;
	Tue, 16 May 2023 00:13:38 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f1fe1208a4so12907383e87.2;
        Tue, 16 May 2023 00:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221217; x=1686813217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q84i2H2s0iKoSUbGo2nOM5QzhVg2YGGG+qJiK8DxGzU=;
        b=LKQGxdUUyHhjZqUUxJBsN/HPYW7jSKRkZBQj+iHOApcRlxNZBtaPmkOW2agWLD/xKK
         pbwhx1xEMlP7mmRl4HmoMcNwl4YeQ84y8I3h0u5OyXOQPRC4EvXU9mLPNK9Qh68X/l+k
         lALMwNrBVPjZMurTddrdccvIpl3aT+vu8/w3Oly1QufkC+JLYWjis+n1RJwXon0xkIxW
         n7OLGnj3P5J6YGK0h56ff3GaNwCMjt+vK4rSGv2BjLT9dcjbZK0qY0mPMYMI4MpicXAa
         3k5VECX0KJo8ApCtCG0CcyyXiyxNJK770yTIhjLGDfcXjTG/+2P2Lkn7ooQz9gRlEzlu
         n30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221217; x=1686813217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q84i2H2s0iKoSUbGo2nOM5QzhVg2YGGG+qJiK8DxGzU=;
        b=l+9gQD3dp33bKydoiJ+7jAgyxXYuf3GH3KOjFGqH4j8eusRiHOI6eBOpCmXsNLzlrq
         XJk0TdUlDQI9GtNcFkYJoF3tkgks3bJV8GqLOWN67PCl/XxGbxAhSMrxb+qcGflqSH6/
         fS1EwuV7CiUHiiEdTh4BOneoCkmvdb34yH8JBA7attomEGmUvybyPJOgof4Ps3aAi1Wq
         uJZCwF1sss5u3QteFClD0nCQNDv8R+LzdTskwqzeXJrY/z6oZTZAHJcEhYZo1V/KMuH1
         DwZkuQqIyKyR8cdx4Xyt7FoiD99M8YkybgoUxHZKCQw8gkHoLu67kjDmsj61ejMMohx9
         SfzQ==
X-Gm-Message-State: AC+VfDxZNzPIhEmVRL3Iv1SIB5YaVk5AQdK3NY6GyQCPqqUWy8Npyajp
	UkdVW5WQyQZAZm+1qXGAZgk=
X-Google-Smtp-Source: ACHHUZ7fIJMrkIh0IZ97adzWW9Rxn5SvLMT6faWlFwiAf9tq/V47SXiAfpEoQl7fpqXqpx8xg17QJQ==
X-Received: by 2002:ac2:446b:0:b0:4ef:b18c:89b2 with SMTP id y11-20020ac2446b000000b004efb18c89b2mr8583772lfl.56.1684221216672;
        Tue, 16 May 2023 00:13:36 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id n7-20020ac24907000000b004f389c98aedsm164151lfi.201.2023.05.16.00.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:13:36 -0700 (PDT)
Date: Tue, 16 May 2023 10:13:32 +0300
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
Subject: [PATCH v4 5/7] pinctrl: ingenic: relax return value check for IRQ get
Message-ID: <17d04e9b7d76fbc0804dde8e1c4a429d7f19de80.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oZ11J20o9Px503h9"
Content-Disposition: inline
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--oZ11J20o9Px503h9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fwnode_irq_get[_byname]() were changed to not return 0 anymore.

Drop check for return value 0.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---

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

--oZ11J20o9Px503h9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLRwACgkQeFA3/03a
ocXPaAf/dygTTCBKWb9BlQ6Z98e87PCCNuOAmUTiehu9/jb29Si1BTK9id/6JNBJ
+WmJD+kgIFqMomCvVaguoDgi2ATWdAt4HM2hsDaN5b6jfoPp8qm95ZtIpGbhu9m/
C4b/sikbRV5Qx+Of6ieabEPuVRJPaPT9v/erxuZ/pREaP6Q6c+JTVaAXgnknoto+
jpolb3Vp5kCVmKGANY/0OuqOhRBbCFkNXimeAVfCPE9lN0wfXo82IWm1pVe1FreT
s6Mc19Ol59QyrAvFoEFhYuqMXJQ+nXHuK1STrPVoMLH80vlDW4yr1orb9N+pXkOR
0hdd17aj+KVcXbnUXoUVSOVN43SN7Q==
=L/Jv
-----END PGP SIGNATURE-----

--oZ11J20o9Px503h9--

