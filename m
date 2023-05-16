Return-Path: <netdev+bounces-2876-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7263270460A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71EBC1C20D87
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A8A19530;
	Tue, 16 May 2023 07:14:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911AA101EC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:14:40 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854B23C3D;
	Tue, 16 May 2023 00:14:17 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f1fe1208a4so12908068e87.2;
        Tue, 16 May 2023 00:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684221256; x=1686813256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bBg0Mv9yvZiy6gYM1yujQ0ayIWUjiANXlVQil+oRP9Y=;
        b=E6/E0+MEEZ1V/BLo6RWxpKoRFfZ5rkKw7MEVSwmdLGV2YtTugh6RLL2JwsEvv33dM5
         ClAwf7nx4vMYQFP/7MhVwN9krtGpdVcMhlTzD+WxhCtwj4QgM/F3GcoPnQWSxi8LWGbx
         9cEwrV0sKZVvM0yg/DTClauC7F3/0jP+g4f7wBC+rpg7g6I5e4sPzoCkkE0QlkS5dfv7
         ZGw+aT4+k3lFWsFGifek2Og/IMTTArPni0CoftZbKkHMOh9COZoT6OmsJiqqSQxZDBjd
         xOIGwnaMbePP50iMnTkjUVJX2eQC6AecG2TcFE5OH+yANztuBHPh6mOS4mCqriOj+ldE
         wHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221256; x=1686813256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBg0Mv9yvZiy6gYM1yujQ0ayIWUjiANXlVQil+oRP9Y=;
        b=DgrmR/cLOZlZZyZaR9cF7Hso+8eeo3+NxIPdA58qdE28z79JM6AqXnawXiSt0ZAttz
         +o+WPvC6EmqX2bC9u4XeIlJuVq9/BYb/1Tr4j2X/GMOzp9y7Y0XLMXq+bRoViCwjii4X
         GQFXGZGPEYW2RtIR34wzk/Saz7Mzqs5WIXDJvnFMQfsPk9GGTx2r71KBStc0cePnDY4T
         +RXenlNltEgvsp/9U2qu4hdgm3xp5gW3WvsYxqf0hxuIA/E5YA03L/3ExiPsf6jFEfas
         K/zx4rW0kgkejzy6cXZhrhpmLsifU1mSGBnuMywVzLzFZIE9d3TFdujoVEGbK6gzL+9u
         IHEw==
X-Gm-Message-State: AC+VfDycPlYR9KGwbIsufNml8+3jrG7hIdUwtojqtQruupJgRm1Gt1rp
	TFqzqyL7fozhZZo99TAx9Z8=
X-Google-Smtp-Source: ACHHUZ49uNR3NJnq5Gt3aNGxblrfIAs3JelfkYNAqlgvXUmiEjle/AtjF7IeH2JaJf2x8K0OPFI9rQ==
X-Received: by 2002:ac2:446b:0:b0:4ef:b18c:89b2 with SMTP id y11-20020ac2446b000000b004efb18c89b2mr8584496lfl.56.1684221255593;
        Tue, 16 May 2023 00:14:15 -0700 (PDT)
Received: from fedora (62-78-225-252.bb.dnainternet.fi. [62.78.225.252])
        by smtp.gmail.com with ESMTPSA id o4-20020ac24944000000b004eeda2caa3fsm2864092lfi.55.2023.05.16.00.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:14:14 -0700 (PDT)
Date: Tue, 16 May 2023 10:14:10 +0300
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
Subject: [PATCH v4 7/7] iio: cdc: ad7150: Functional change
Message-ID: <b0a95bbc8258bf527e1c011591e22320452174fe.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mCCjHAg4ND0FvBry"
Content-Disposition: inline
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--mCCjHAg4ND0FvBry
Content-Type: text/plain; charset=us-ascii
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

Drop the special handling for DT mapping failures as these can no longer
be separated from other errors at driver side.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

---

Please note that I don't have the hardware to test this change.
Furthermore, testing this type of device-tree error cases is not
trivial, as the question we probably dive in is "what happens with the
existing users who have errors in the device-tree". Answering to this
question is not simple.

I did this patch with minimal code changes - but a question is if we
should really jump into the else branch below on all IRQ getting errors?

        } else {
                indio_dev->info =3D &ad7150_info_no_irq;
                switch (id->driver_data) {
                case AD7150:
                        indio_dev->channels =3D ad7150_channels_no_irq;
                        indio_dev->num_channels =3D
                                ARRAY_SIZE(ad7150_channels_no_irq);
                        break;
                case AD7151:
                        indio_dev->channels =3D ad7151_channels_no_irq;
                        indio_dev->num_channels =3D
                                ARRAY_SIZE(ad7151_channels_no_irq);
                        break;
                default:
                        return -EINVAL;
                }

Why do we have special handling for !chip->interrupts[0] while other
errors on getting the fwnode_irq_get(dev_fwnode(&client->dev), 0); will
abort the probe?

The first patch of the series changes the fwnode_irq_get() so this depends
on the first patch of the series and should not be applied alone.
---
 drivers/iio/cdc/ad7150.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/cdc/ad7150.c b/drivers/iio/cdc/ad7150.c
index 79aeb0aaea67..d7ba50b9780d 100644
--- a/drivers/iio/cdc/ad7150.c
+++ b/drivers/iio/cdc/ad7150.c
@@ -567,8 +567,7 @@ static int ad7150_probe(struct i2c_client *client)
 		if (chip->interrupts[1] < 0)
 			return chip->interrupts[1];
 	}
-	if (chip->interrupts[0] &&
-	    (id->driver_data =3D=3D AD7151 || chip->interrupts[1])) {
+	if (id->driver_data =3D=3D AD7151 || chip->interrupts[1]) {
 		irq_set_status_flags(chip->interrupts[0], IRQ_NOAUTOEN);
 		ret =3D devm_request_threaded_irq(&client->dev,
 						chip->interrupts[0],
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

--mCCjHAg4ND0FvBry
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEIx+f8wZb28fLKEhTeFA3/03aocUFAmRjLUIACgkQeFA3/03a
ocXXRwgAyWtKk7U/XUD4vC4F6ITQAv3XsHVWi9FrVtLWK4UHNU/lOkniW+1bLnA5
NzuhGLHcFpARG5z/ZCTFJqvrDCATo6O29MgbNqgdMBTLESv50iKDAxhkgv9VLbF1
fhYmADOJNfEmuoIrhs9VpJaDImDAjX1dc4qsYaA+cbl5ZBYN+HspXopD5Vr+Qicn
ihTdRHJSqMPLf8dw1xSbgtnGKB78ul0IXP0fgsYIb2cgezYo1iuiASfujEChBFkP
3gKcxCvDwDmhnf6Z/ukA4t9rfg6Ctbbv5VYmT5LGCR1cTnkYwxJ5hzrrE5RCTTsG
bOdSiSW0u1uogrOdzEP629A3rwNeDg==
=4CGL
-----END PGP SIGNATURE-----

--mCCjHAg4ND0FvBry--

