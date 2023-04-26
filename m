Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172C06EFC22
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 23:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbjDZVGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 17:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjDZVGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 17:06:50 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A913582
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 14:06:47 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-54fc1824f0bso87609337b3.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 14:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682543207; x=1685135207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8C6tKrbT51GaZnl8zer1AnBo8yNRgpprgLkj0av5l+E=;
        b=Kh7TmG3JlHQoPDgJrxEspZSpUN+36yUdamiO43UnPnWU5WHRHExsZuq1crpHQPMIXw
         zzWzXMlOi38Xx4my+77mCqHvk7/X81J/7WthQKZt0CHx/5a1ohrap/HzGWEDQbQACJTb
         YhsFcjssiyz48P8HUQnvmRDVNrO8n5ZicePPH1S7Zj9YadbExO7GDrfEmhV8+JMdHi44
         dS/U1Lzmekv6Z1Px+wN/pWN5LwOrRpCZPrnqoQccfnfTFROZXP698w5QlH4NBcZahcI9
         Av/WtFSCGNW/WXdsMcqPPizaCNJVu9G6mBZV0Jx9mGGkKSo+tGaTmr2RPFnSQVsLEyzh
         SKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682543207; x=1685135207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8C6tKrbT51GaZnl8zer1AnBo8yNRgpprgLkj0av5l+E=;
        b=kGBb5J3BZQOvhQFn/3436++vF4Sb4RYk2GwhB11ANzucz3as5rjGPHbByYyHTnDGyj
         qMGv1mx7vOKOIKv2uSoWIfuxcTDq2RKi0Cm8EP4TfwgVYcp77ttMb06dwI+sBfx4oasS
         ceemzN2uWOF2F9WtMLBKtjjORItqiJRfLVyfZhzUlGjTazTXD0PShsaLUr5oRgoK2EvO
         qZls6dihdhwqBBYebs8Iteu4TlutiO1cKub12AqS7lewV8iQuAawvKdJR+n9G2G3dTrv
         d4Y9GR8vEvqchFATMPjQu3dM3y0+2m5KrkxahVat/gu9OhyOHw9lEzneVM46188DybdR
         EekQ==
X-Gm-Message-State: AAQBX9dfweF8rqCAhIsWYKHSjLczn58HdGn/dWqbG6BvNpm7uThSH759
        TYExS0Zr/SiSnc26AKKonHJZWBjr0r1x/2t7TJI5gw==
X-Google-Smtp-Source: AKy350bnHkFKck7ScHLySUohS3TGug3PuU6k1b4WHzFwKnH0/14BD/IU48R1JEuMfUGu5baNdUtxQXCsghQML3QSaV8=
X-Received: by 2002:a81:5d02:0:b0:54f:8b56:bb3 with SMTP id
 r2-20020a815d02000000b0054f8b560bb3mr13933284ywb.5.1682543207061; Wed, 26 Apr
 2023 14:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
 <CACRpkdarANFQ7-p=-Pi_iuk6L=PfSLDsD3_w4dEVqarwXkEGMQ@mail.gmail.com> <b5396ef5-3fed-4e98-8f37-a9cd4473bddc@sirena.org.uk>
In-Reply-To: <b5396ef5-3fed-4e98-8f37-a9cd4473bddc@sirena.org.uk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 26 Apr 2023 23:06:35 +0200
Message-ID: <CACRpkdaZvKoFuDHP0Cd1MuayKtnBjCG5wmWPjwq3pccCrb-P9A@mail.gmail.com>
Subject: Re: [PATCH 00/43] ep93xx device tree conversion
To:     Mark Brown <broonie@kernel.org>
Cc:     Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@kernel.org>,
        Linus Walleij <linusw@kernel.org>,
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

On Wed, Apr 26, 2023 at 11:02=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:
> On Wed, Apr 26, 2023 at 10:56:53PM +0200, Linus Walleij wrote:
>
> > This is a big patch set and the improvement to the ARM kernel it
> > brings is great, so I am a bit worried about over-review stalling the
> > merged. If there start to be nitpicky comments I would prefer that
> > we merge it and let minor comments and "nice-to-haves" be
> > addressed in-tree during the development cycle.
>
> I'm really not enthusiastic about the SPI bindings being merged as-is.

Agree, the bindings are more important than the code IMO,
they tend to get written in stone.

Yours,
Linus Walleij
