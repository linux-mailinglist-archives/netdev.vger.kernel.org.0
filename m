Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588D66EFBFD
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239930AbjDZU5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbjDZU5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:57:09 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882A52708
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:57:06 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-5562c93f140so48009947b3.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682542625; x=1685134625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PeyZTvE2qao9z3HUKls5t/zNMEefQNyhwIh3dGLQJIU=;
        b=MLeMyFt/BrAb2CUUJZ7KmQTqlKOdl+nyYZc7PmyjnwYQvm0Yf7UbAGXqUUW6bmw5G8
         d9v/M6N+1fVWgVUttzO6DbM8nQI6KJCXhAN7IozpaR9m8Bl7slG7VpsqTKwoquSQxGsD
         jxjSQ3saNVE9cXwcQLcGF1jRtKLT/eEwI8kJvMSzxcIq2cDfiKWjYhMONbeUEU8V5mkj
         6Wdd/04hTAUwScC/UEbqqr6+MnHBHQTixxYJ9LZKKkCtwlqFMN3MWW87ziN5fguiVzeh
         4csevZGxcMK5tYzjndfSfWqBNcCl6Mif+sgasTPGERCLKwqXoxv35oil0C7Hw7NrwoqG
         vwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682542625; x=1685134625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PeyZTvE2qao9z3HUKls5t/zNMEefQNyhwIh3dGLQJIU=;
        b=juI/0w2TCSseBizLjmENPaEiTH+35vSriAZG3HzvyeULDb/C88yNbBft/V2VcqA0+Z
         3spUXqeSqyx4dhiKap8BqdrYFKqg2ho34zlOQYsgPlWP0KAv609a9iocHkQV8AZ1ris3
         1J9yFhslUwwBa3jXq37DqjRHAwWDzBdjn0YbV0IPqQkk0zhxLK3UHObYHwCB2elaScXM
         2geRYZM0fRKkfW6eI5nROLatxqpXerBr8Ex2K0xcpV0s3s8OJBEitPh95vGD77blBA/z
         G5xkt6PRvgkyErok4l8cMThvEEPUAm6/TCAwwpOhDvXbLsYNDIzvgQGwoslVSW2nH4fO
         +izw==
X-Gm-Message-State: AAQBX9f/JOn7ZaqUa+/j+RkZlemw8u03f85eulgiCnSHOdmphW7RBj8Y
        7bqIVuoDBiQ1EMtTDdmjELe1jrUYSz1Iq/RM5ot8OQ==
X-Google-Smtp-Source: AKy350ajEJHyhyynqyOl0isjddMpiNdULElT/xAxUEM8cmGuE9kOk2QPH86dypmLR0gOJToVISGwrFvJLTDtak1EsDI=
X-Received: by 2002:a0d:ea0d:0:b0:552:a2e2:684e with SMTP id
 t13-20020a0dea0d000000b00552a2e2684emr13680157ywe.52.1682542625695; Wed, 26
 Apr 2023 13:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
In-Reply-To: <20230424123522.18302-1-nikita.shubin@maquefel.me>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 26 Apr 2023 22:56:53 +0200
Message-ID: <CACRpkdarANFQ7-p=-Pi_iuk6L=PfSLDsD3_w4dEVqarwXkEGMQ@mail.gmail.com>
Subject: Re: [PATCH 00/43] ep93xx device tree conversion
To:     Nikita Shubin <nikita.shubin@maquefel.me>
Cc:     Arnd Bergmann <arnd@kernel.org>, Linus Walleij <linusw@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Brian Norris <briannorris@chromium.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jean Delvare <jdelvare@suse.de>, Joel Stanley <joel@jms.id.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Le Moal <damien.lemoal@opensource.wdc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Liang Yang <liang.yang@amlogic.com>,
        Lukasz Majewski <lukma@denx.de>, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Qin Jian <qinjian@cqplus1.com>,
        Richard Weinberger <richard@nod.at>,
        Rob Herring <robh+dt@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Stephen Boyd <sboyd@kernel.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Sven Peter <sven@svenpeter.dev>, Takashi Iwai <tiwai@suse.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Walker Chen <walker.chen@starfivetech.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Yinbo Zhu <zhuyinbo@loongson.cn>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-watchdog@vger.kernel.org,
        netdev@vger.kernel.org, soc@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 11:35=E2=80=AFAM Nikita Shubin
<nikita.shubin@maquefel.me> wrote:

> This series aims to convert ep93xx from platform to full device tree supp=
ort.
>
> Tested on ts7250 64 RAM/128 MiB Nand flash, edb9302.

Neat, I'd say let's merge this for 6.5 once the final rough edges are
off. The DT bindings should be easy to fix.

This is a big patch set and the improvement to the ARM kernel it
brings is great, so I am a bit worried about over-review stalling the
merged. If there start to be nitpicky comments I would prefer that
we merge it and let minor comments and "nice-to-haves" be
addressed in-tree during the development cycle.

I encourage you to use b4 to manage the patch series if you
have time to learn it, it could help you:
https://people.kernel.org/monsieuricon/sending-a-kernel-patch-with-b4-part-=
1

Yours,
Linus Walleij
