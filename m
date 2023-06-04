Return-Path: <netdev+bounces-7788-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5738C721853
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 17:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93735281153
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E21F9EF;
	Sun,  4 Jun 2023 15:54:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E8523A5
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 15:54:33 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1727BB;
	Sun,  4 Jun 2023 08:54:31 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5147e8972a1so5975198a12.0;
        Sun, 04 Jun 2023 08:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685894070; x=1688486070;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TsvcyukdSS1lKPeAFb0MO21Iif9mAo0wy8+BZHk6XCA=;
        b=r9RnHmU6Pa0FtsM/qHVFqFiCYlBYyvtIkLeKoNPRIk8smrMsqYFJGWCQjT7VU72eDe
         BlragftM9BcqClhhfhrjXu+KMSBuqSe+KNwPFU0KBNJlL713GE9o6QJnGFo2MVVjPP+P
         tQT4bqbQqIIjRH39Ls+d3YC1mLwWHW3tHKnUmfhzbMfPeeq5TIZAMtwSAuYi3ZYPbltW
         zBx3Pm7HZhbXZBrcB4iAF+MkhkDQusDxPerLMNjJ9M9evb0iQB/WGEScO2q3pwVkwkGJ
         xiks1hYnTowy+2gYSWDJ+qp4ig7OfRGINcmiTLnuJchPscxcbqDF/ro1Gt8cNoeiUHiy
         SK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685894070; x=1688486070;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TsvcyukdSS1lKPeAFb0MO21Iif9mAo0wy8+BZHk6XCA=;
        b=QdjS9YW+NB/nZfOXhs5NvVuHKMm+ZsgU88hN7z3SHbZX49pfaJOf/yYd7KX5+ZJjkq
         DXndWVuz2i+vSckuvlupYlCwVWUfOIJY/KXoHFUTjei9QO1nWUSs9Wgns+ZZ6Wx8ykLt
         RzmpHIX3ZDUAiADbVtpMJHT0jk0uy1l1aPvSyp4MaFLgqxUob21WxbDbGnJr9zSAS+VI
         mlWem+Cgp+TuWH1uflprDVuWcJeXnKFDYrwfvMcU9NdsA9QAn7hoDUJAuEvqa6zbow3u
         PpPQKQdV1E/hm0aqz9nr5m+71BH70okfp6MZ4HDoXnjNwkpX8fyHWsDrSt09KHzSKQK2
         O5Mg==
X-Gm-Message-State: AC+VfDytwp4pLZVnnfiRdfjebawSFrLgcsIOaK272Er3P5dwV1A3LPlH
	7s+jYlBF3kiOuaGQZZrxtwY=
X-Google-Smtp-Source: ACHHUZ6AHXuZcLeVYAiKN3Lakw7/5eyPw2g9gXmYKU2Z87ULJVZcNauonQPfi8yZtMpFNZvTXucpWg==
X-Received: by 2002:a17:907:6d08:b0:974:5e2c:8721 with SMTP id sa8-20020a1709076d0800b009745e2c8721mr4687955ejc.38.1685894070095;
        Sun, 04 Jun 2023 08:54:30 -0700 (PDT)
Received: from giga-mm.home ([2a02:1210:8629:800:82ee:73ff:feb8:99e3])
        by smtp.gmail.com with ESMTPSA id h21-20020a170906111500b00974530bd213sm3241020eja.143.2023.06.04.08.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 08:54:29 -0700 (PDT)
Message-ID: <1492a131cd474c47e2a2b14defd46284f695b0ef.camel@gmail.com>
Subject: Re: [PATCH v1 00/43] ep93xx device tree conversion
From: Alexander Sverdlin <alexander.sverdlin@gmail.com>
To: Nikita Shubin <nikita.shubin@maquefel.me>, Arnd Bergmann
 <arnd@arndb.de>,  Linus Walleij <linus.walleij@linaro.org>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Alexandre Belloni
 <alexandre.belloni@bootlin.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Bartosz Golaszewski <brgl@bgdev.pl>, 
 Christophe Kerello <christophe.kerello@foss.st.com>, Conor Dooley
 <conor.dooley@microchip.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Emil Renner Berthing <kernel@esmil.dk>, Florian Fainelli
 <f.fainelli@gmail.com>, Hartley Sweeten <hsweeten@visionengravers.com>,
 Heiko Stuebner <heiko@sntech.de>, Hitomi Hasegawa
 <hasegawa-hitomi@fujitsu.com>, Jean Delvare <jdelvare@suse.de>, Joel
 Stanley <joel@jms.id.au>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Jonathan =?ISO-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>, Krzysztof
 Kozlowski <krzysztof.kozlowski@linaro.org>,  Le Moal <dlemoal@kernel.org>,
 Liang Yang <liang.yang@amlogic.com>, Mark Brown <broonie@kernel.org>, 
 Masahiro Yamada <masahiroy@kernel.org>, Miquel Raynal
 <miquel.raynal@bootlin.com>, Nathan Chancellor <nathan@kernel.org>, Neil
 Armstrong <neil.armstrong@linaro.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Nicolas Ferre <nicolas.ferre@microchip.com>,
 Nicolas Saenz Julienne <nsaenz@kernel.org>, Richard Weinberger
 <richard@nod.at>, "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=
 <u.kleine-koenig@pengutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, Walker
 Chen <walker.chen@starfivetech.com>, Yinbo Zhu <zhuyinbo@loongson.cn>
Cc: Michael Peters <mpeters@embeddedTS.com>, Kris Bahnsen
 <kris@embeddedTS.com>,  alsa-devel@alsa-project.org,
 devicetree@vger.kernel.org,  dmaengine@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,  linux-clk@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-ide@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
 linux-spi@vger.kernel.org,  linux-watchdog@vger.kernel.org,
 netdev@vger.kernel.org
Date: Sun, 04 Jun 2023 17:54:27 +0200
In-Reply-To: <20230601053546.9574-1-nikita.shubin@maquefel.me>
References: <20230601053546.9574-1-nikita.shubin@maquefel.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.2 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Nikita,

On Thu, 2023-06-01 at 08:33 +0300, Nikita Shubin wrote:
> This series aims to convert ep93xx from platform to full device tree supp=
ort.
>=20
> Alexander, Kris - there are some significant changes in clk and pinctrl s=
o can i ask you to tests all once again.

I have quickly tested network and sound on EDB9302 and I neither have probl=
ems with
these functions, nor did I spot any new error messages, overall looks good =
to me,
thanks for your efforts!

--=20
Alexander Sverdlin.


