Return-Path: <netdev+bounces-2844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C91BB704413
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 773DA1C20B2E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 03:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592263C1E;
	Tue, 16 May 2023 03:47:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462BA3C15
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:47:22 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8593D4C22;
	Mon, 15 May 2023 20:47:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1aae46e62e9so97098635ad.2;
        Mon, 15 May 2023 20:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684208840; x=1686800840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PJkA0m3mLV3FScvH0VRdP/qwbPPh2FB8d0fW+TuWxR4=;
        b=ApPSFRvnOtBS+Z/iKlnWcxMj6EFTaNcebWTAxUNqbr2V59bdCsI1CCGa7BSHqaDeQo
         Y716hG4KkN0jkNJRqHDrjT+AwLp9OZhn4DGdlJ3osLyZeE9jrOxLkOIUjMJkvpo84CAq
         nUTDHKlEa12CbYtD834uGpkePWIxfOzVkSxhCNiXiFb0yo2dh6eXGqhzdTiT1iPqmM5o
         51Or2UyL9Qx+e5KfZ5LhYuXVvZSCPLsQ/mCaORrP9aCbUB2c2S/PnEh5FColWdomJPuP
         SPspvw61zWv9jTS1y0MWuWQpPc6Zc2rkMxuDBflIpnO2zr1wz5G588YCFmWLp553g2yw
         ki8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684208840; x=1686800840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJkA0m3mLV3FScvH0VRdP/qwbPPh2FB8d0fW+TuWxR4=;
        b=lHE2H5xgGA75v6QHR6fsJMhj+/NE14jwZY3j7T9HIPRVZ97/X55/R9CoqnA4Dl046j
         Y8cMKFcpEZYg/g1kR7y4EYBElg+qnIBcMptWd+fGN1+cylu4RB+SMC+sR8RWHQi/KFXe
         M3dBYvw4kyZ6/5Kh7XCy3rx1gxarNYpSzotIe7w5ASSSqpI4fFSmaS2GYKjRFBpFO6rj
         z9fyVYKWDZhQ7iuu3iOEh/4Q8Rwid6zKaDf1tZiF1ZA5bpdVWuhzHOzeZG86wowwPkdK
         YbtI1n0GgGz18a15Cv/HFOdtxAz6pL6WQeMrirUJoDyoVc14wi+GJNnxD3pC0M2UnUPx
         +JdQ==
X-Gm-Message-State: AC+VfDyq8O1WQNc6X8mxYtOGpmcI++e7UerQtZ5uHxX/1J+2SLz01mLB
	NKItuW386nSo5Q1BLzYjkjg=
X-Google-Smtp-Source: ACHHUZ7e1MfX6kyZu2E4WmLGOzMJRaaqKuW9yru0MqXdpKhkdM51h0LCt+6AtwA0+6KM5psbnkf95w==
X-Received: by 2002:a17:903:41cb:b0:1ad:f7d9:1ae0 with SMTP id u11-20020a17090341cb00b001adf7d91ae0mr12593543ple.38.1684208839868;
        Mon, 15 May 2023 20:47:19 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k3-20020a170902ba8300b001a245b49731sm9786807pls.128.2023.05.15.20.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 20:47:19 -0700 (PDT)
Message-ID: <1ff2333a-8f78-c066-0158-9c8a1a17684f@gmail.com>
Date: Mon, 15 May 2023 20:47:07 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 00/43] ep93xx device tree conversion
Content-Language: en-US
To: Nikita Shubin <nikita.shubin@maquefel.me>
Cc: Arnd Bergmann <arnd@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Alexander Sverdlin <alexander.sverdlin@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?= <j.neuschaefer@gmx.net>,
 "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
 Alessandro Zummo <a.zummo@towertech.it>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Arnd Bergmann <arnd@arndb.de>, Bartosz Golaszewski <brgl@bgdev.pl>,
 Brian Norris <briannorris@chromium.org>, Chuanhong Guo
 <gch981213@gmail.com>, Conor Dooley <conor.dooley@microchip.com>,
 Damien Le Moal <dlemoal@kernel.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Emil Renner Berthing <kernel@esmil.dk>, Eric Dumazet <edumazet@google.com>,
 Guenter Roeck <linux@roeck-us.net>,
 Hartley Sweeten <hsweeten@visionengravers.com>,
 Heiko Stuebner <heiko@sntech.de>,
 Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
 Jakub Kicinski <kuba@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
 Jean Delvare <jdelvare@suse.de>, Joel Stanley <joel@jms.id.au>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Le Moal <damien.lemoal@opensource.wdc.com>,
 Liam Girdwood <lgirdwood@gmail.com>, Liang Yang <liang.yang@amlogic.com>,
 Linus Walleij <linus.walleij@linaro.org>, Lukasz Majewski <lukma@denx.de>,
 Lv Ruyi <lv.ruyi@zte.com.cn>, Mark Brown <broonie@kernel.org>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Michael Turquette <mturquette@baylibre.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Nicolas Saenz Julienne <nsaenz@kernel.org>, Olof Johansson <olof@lixom.net>,
 Paolo Abeni <pabeni@redhat.com>, Qin Jian <qinjian@cqplus1.com>,
 Richard Weinberger <richard@nod.at>, Rob Herring <robh+dt@kernel.org>,
 Robert Jarzmik <robert.jarzmik@free.fr>, Russell King
 <linux@armlinux.org.uk>, Sebastian Reichel <sre@kernel.org>,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Stephen Boyd <sboyd@kernel.org>,
 Sumanth Korikkar <sumanthk@linux.ibm.com>, Sven Peter <sven@svenpeter.dev>,
 Takashi Iwai <tiwai@suse.com>, Thierry Reding <thierry.reding@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ulf Hansson <ulf.hansson@linaro.org>,
 Vasily Gorbik <gor@linux.ibm.com>, Vignesh Raghavendra <vigneshr@ti.com>,
 Vinod Koul <vkoul@kernel.org>, Walker Chen <walker.chen@starfivetech.com>,
 Wim Van Sebroeck <wim@linux-watchdog.org>, Yinbo Zhu <zhuyinbo@loongson.cn>,
 alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
 dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-input@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-pm@vger.kernel.org, linux-pwm@vger.kernel.org,
 linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-watchdog@vger.kernel.org, netdev@vger.kernel.org, soc@kernel.org
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230424123522.18302-1-nikita.shubin@maquefel.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 4/24/2023 5:34 AM, Nikita Shubin wrote:
> This series aims to convert ep93xx from platform to full device tree support.
> 
> Tested on ts7250 64 RAM/128 MiB Nand flash, edb9302.
> 
> Thank you Linus and Arnd for your support, review and comments, sorry if i missed something -
> these series are quite big for me.
> 
> Big thanks to Alexander Sverdlin for his testing, support, review, fixes and patches.

If anyone is interested I still have a TS-7300 board [1] that is fully 
functional and could be sent out to a new home.

https://www.embeddedts.com/products/TS-7300
-- 
Florian

