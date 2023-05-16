Return-Path: <netdev+bounces-2890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD9C7046E6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C9A81C20D66
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB9519518;
	Tue, 16 May 2023 07:50:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5A41E536
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:50:07 +0000 (UTC)
Received: from aposti.net (aposti.net [89.234.176.197])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAC13581;
	Tue, 16 May 2023 00:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
	s=mail; t=1684223401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qKHuxejJ0gYscGISO/Lzq18vk4+b4iOzo6srIsttI8Q=;
	b=DPG9ROIGCjLeyrplpljQ4YAX1l0ZnPhORRJ6fpBTYqXuRjfrN8DM4fxvjte0yqxnczjIre
	2UoUOZOUT6GyFMCi49aKlcljzWX7TgGQh9b8fIVGaCwOA5NJG/CI+PCaI8981caXsONPm/
	TkmO2iMhrGoY8qk+QXngBmMa2AAuLu0=
Message-ID: <ba2c8adf84ed0ae7036873064871b7a17494f2e1.camel@crapouillou.net>
Subject: Re: [PATCH v4 5/7] pinctrl: ingenic: relax return value check for
 IRQ get
From: Paul Cercueil <paul@crapouillou.net>
To: Matti Vaittinen <mazziesaccount@gmail.com>, Matti Vaittinen
	 <matti.vaittinen@fi.rohmeurope.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Scally
 <djrscally@gmail.com>, Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
 Sakari Ailus <sakari.ailus@linux.intel.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Lars-Peter Clausen <lars@metafoo.de>, Michael Hennerich
 <Michael.Hennerich@analog.com>, Jonathan Cameron <jic23@kernel.org>,
 Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
 Russell King <linux@armlinux.org.uk>,  "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 =?ISO-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,  Linus Walleij
 <linus.walleij@linaro.org>, Wolfram Sang <wsa@kernel.org>, Akhil R
 <akhilrajeev@nvidia.com>,  linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org, 
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Date: Tue, 16 May 2023 09:49:58 +0200
In-Reply-To: <17d04e9b7d76fbc0804dde8e1c4a429d7f19de80.1684220962.git.mazziesaccount@gmail.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
	 <17d04e9b7d76fbc0804dde8e1c4a429d7f19de80.1684220962.git.mazziesaccount@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Matti,

Le mardi 16 mai 2023 =C3=A0 10:13 +0300, Matti Vaittinen a =C3=A9crit=C2=A0=
:
> fwnode_irq_get[_byname]() were changed to not return 0 anymore.
>=20
> Drop check for return value 0.
>=20
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

Reviewed-by: Paul Cercueil <paul@crapouillou.net>

Cheers,
-Paul

>=20
> ---
>=20
> The first patch of the series changes the fwnode_irq_get() so this
> depends
> on the first patch of the series and should not be applied alone.
> ---
> =C2=A0drivers/pinctrl/pinctrl-ingenic.c | 2 --
> =C2=A01 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/pinctrl/pinctrl-ingenic.c
> b/drivers/pinctrl/pinctrl-ingenic.c
> index 2f220a47b749..86e71ad703a5 100644
> --- a/drivers/pinctrl/pinctrl-ingenic.c
> +++ b/drivers/pinctrl/pinctrl-ingenic.c
> @@ -4201,8 +4201,6 @@ static int __init ingenic_gpio_probe(struct
> ingenic_pinctrl *jzpc,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0err =3D fwnode_irq_get(fw=
node, 0);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (err < 0)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return err;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!err)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0jzgc->irq =3D err;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0girq =3D &jzgc->gc.irq;
> --=20
> 2.40.1
>=20
>=20


