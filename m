Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB84749B076
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574859AbiAYJgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573969AbiAYJa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:30:56 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B47C0613E5
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 01:30:54 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id m90so36322467uam.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 01:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1mm7+Qmz3LImo4aFwbhXIFkzVEgm/HAOzd6fbdAVMrg=;
        b=kCmCEgQ+xOVJqgvY6mIiDwGpng9RE64Ri/x5bVEJVgfKmrbder8yB0SJa9j3j/iO6u
         VSlwxJi1GtMfRaX9rz0Fi8V70QZmpTm/yg+yqKEhFTP/kvAigM6NlkG016BHxBuEGBud
         aKKG3vXyGKhkWECz7g02ij5pN8RBjRbfSAGJhF2s+s/E8Wzq61/RmUZzmkHINs6y38kj
         8W/C1tUsfkR71I5xYVxyEgRhxjIz/FmTGO/CwLqL3papla/+aWUpb3kyrOT/GpbDGqeC
         c1kCPdzAMoEjl9Ka3L/ozlubTR502/GpTZoRLS5kuqKqPkl9NQ2lJSPzTzJVIDppuhpp
         EfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1mm7+Qmz3LImo4aFwbhXIFkzVEgm/HAOzd6fbdAVMrg=;
        b=olqq8vEYhctI58CTONkccH0CZW8zCUbfThs3ED9Ngo1RUY+C7XkQ0UdArTnLAtEb43
         0AITKd+UKf/Hc642tPIOc0CPs+TZ+BbIgp6kzel/aRRD8wXqd5V4po5GBAz+7U5JU+2o
         FJhLAKrPotQZTFS66ap+GKBgaDBlYwHuRSvhJIqJWl/naPfx5RerxRJqlIOEStI91BeZ
         CqSdJNIeqeBy0tjvHQv5bmVBR3MM+ybdE3lVV2IfPAmYC0R98njebPpA4XWIPAURYhLv
         rgo877+ssvc+pdFOzaB3pLwBD/7AyWbpwtStJhacZGjpzynmklbOkhK8JzfyzOSbxmAT
         Y+3w==
X-Gm-Message-State: AOAM530BNg38+pQtmTdN2/QqqK9VR1zxjAvC5D8ljMrBVRQXSyEpzRzC
        CZv9cQ2LF0Cu/RKak58LCZYRwVzKADuM+Es6BMr7/A==
X-Google-Smtp-Source: ABdhPJwHGGkAwOnsd7qe0zHQAqHAUzi5PBqvJQ90yr1sdZ5zdG5wkLeKm2Z8HhNpFMDsTHL1nOGUCrWQS9pCXlyV9Y0=
X-Received: by 2002:a67:8c2:: with SMTP id 185mr712613vsi.19.1643103053912;
 Tue, 25 Jan 2022 01:30:53 -0800 (PST)
MIME-Version: 1.0
References: <20220123175201.34839-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220123175201.34839-1-u.kleine-koenig@pengutronix.de>
From:   Lee Jones <lee.jones@linaro.org>
Date:   Tue, 25 Jan 2022 09:30:43 +0000
Message-ID: <CAF2Aj3g0uxj7=m+USWz9QvmQ511DN83e9WsVDW-484aEdix4hg@mail.gmail.com>
Subject: Re: [PATCH 0/5] spi: make remove callback a void function
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Markuss Broks <markuss.broks@gmail.com>,
        Emma Anholt <emma@anholt.net>,
        David Lechner <david@lechnology.com>,
        Kamlesh Gurudasani <kamlesh.gurudasani@gmail.com>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dan Robertson <dan@dlrobertson.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Kent Gustavsson <kent@minoris.se>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Antti Palosaari <crope@iki.fi>,
        Support Opensource <support.opensource@diasemi.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Benson Leung <bleung@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>,
        Helge Deller <deller@gmx.de>,
        James Schulman <james.schulman@cirrus.com>,
        David Rhodes <david.rhodes@cirrus.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        =?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Gwendal Grignou <gwendal@chromium.org>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Antoniu Miclaus <antoniu.miclaus@analog.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        =?UTF-8?Q?Ronald_Tschal=C3=A4r?= <ronald@innovation.ch>,
        Marco Felsch <m.felsch@pengutronix.de>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Schocher <hs@denx.de>,
        Fabio Estevam <festevam@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Matt Kline <matt@bitbashing.io>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Yang Shen <shenyang39@huawei.com>,
        dingsenjie <dingsenjie@yulong.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Walle <michael@walle.cc>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Sidong Yang <realwakka@gmail.com>,
        Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Davidlohr Bueso <dbueso@suse.de>, Claudius Heine <ch@denx.de>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        kernel@pengutronix.de, Noralf Tronnes <notro@tronnes.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@google.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My usual mailer won't let me reply to this many people, so I'm using Gmail.

No idea what chaos this will cause, but here goes ...

> The value returned by an spi driver's remove function is mostly ignored.
> (Only an error message is printed if the value is non-zero that the
> error is ignored.)
>
> So change the prototype of the remove function to return no value. This
> way driver authors are not tempted to assume that passing an error to
> the upper layer is a good idea. All drivers are adapted accordingly.
> There is no intended change of behaviour, all callbacks were prepared to
> return 0 before.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---

[...]

>  drivers/mfd/arizona-spi.c                             |  4 +---
>  drivers/mfd/da9052-spi.c                             |  3 +--
>  drivers/mfd/ezx-pcap.c                                |  4 +---
>  drivers/mfd/madera-spi.c                             |  4 +---
>  drivers/mfd/mc13xxx-spi.c                           |  3 +--
>  drivers/mfd/rsmu_spi.c                                |  4 +---
>  drivers/mfd/stmpe-spi.c                               |  4 +---
>  drivers/mfd/tps65912-spi.c                          |  4 +---

>  drivers/video/backlight/ams369fg06.c         |  3 +--
>  drivers/video/backlight/corgi_lcd.c               |  3 +--
>  drivers/video/backlight/ili922x.c                    |  3 +--
>  drivers/video/backlight/l4f00242t03.c           |  3 +--
>  drivers/video/backlight/lms501kf03.c            |  3 +--
>  drivers/video/backlight/ltv350qv.c                 |  3 +--
>  drivers/video/backlight/tdo24m.c                  |  3 +--
>  drivers/video/backlight/tosa_lcd.c                |  4 +---
>  drivers/video/backlight/vgg2432a4.c            |  4 +---

If it's okay with Mark, it's okay with me.

Acked-by: Lee Jones <lee.jones@linaro.org>

--=20
Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
Linaro Services Principle Technical Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
