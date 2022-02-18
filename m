Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988614BB955
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbiBRMio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:38:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiBRMij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:38:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49441738F2;
        Fri, 18 Feb 2022 04:38:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D27EB8261C;
        Fri, 18 Feb 2022 12:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38114C340E9;
        Fri, 18 Feb 2022 12:37:52 +0000 (UTC)
Message-ID: <c70113dc-d017-b5bc-1466-02530f4707e2@xs4all.nl>
Date:   Fri, 18 Feb 2022 13:37:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 5/5] spi: make remove callback a void function
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
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
        =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dan Robertson <dan@dlrobertson.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Kent Gustavsson <kent@minoris.se>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Antti Palosaari <crope@iki.fi>,
        Lee Jones <lee.jones@linaro.org>,
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
        =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
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
        Claudiu Beznea <claudiu.beznea@microchip.com>,
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
        =?UTF-8?Q?Nuno_S=c3=a1?= <nuno.sa@analog.com>,
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
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?Q?Ronald_Tschal=c3=a4r?= <ronald@innovation.ch>,
        Marco Felsch <m.felsch@pengutronix.de>,
        =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?= <j.neuschaefer@gmx.net>,
        Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Schocher <hs@denx.de>,
        Fabio Estevam <festevam@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Matt Kline <matt@bitbashing.io>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?Q?Stefan_M=c3=a4tje?= <stefan.maetje@esd.eu>,
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
        kernel@pengutronix.de
References: <20220123175201.34839-1-u.kleine-koenig@pengutronix.de>
 <20220123175201.34839-6-u.kleine-koenig@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <20220123175201.34839-6-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/2022 18:52, Uwe Kleine-König wrote:
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
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/bus/moxtet.c                                  |  4 +---
>  drivers/char/tpm/st33zp24/spi.c                       |  4 +---
>  drivers/char/tpm/tpm_tis_spi_main.c                   |  3 +--
>  drivers/clk/clk-lmk04832.c                            |  4 +---
>  drivers/gpio/gpio-74x164.c                            |  4 +---
>  drivers/gpio/gpio-max3191x.c                          |  4 +---
>  drivers/gpio/gpio-max7301.c                           |  4 +---
>  drivers/gpio/gpio-mc33880.c                           |  4 +---
>  drivers/gpio/gpio-pisosr.c                            |  4 +---
>  drivers/gpu/drm/panel/panel-abt-y030xx067a.c          |  4 +---
>  drivers/gpu/drm/panel/panel-ilitek-ili9322.c          |  4 +---
>  drivers/gpu/drm/panel/panel-ilitek-ili9341.c          |  3 +--
>  drivers/gpu/drm/panel/panel-innolux-ej030na.c         |  4 +---
>  drivers/gpu/drm/panel/panel-lg-lb035q02.c             |  4 +---
>  drivers/gpu/drm/panel/panel-lg-lg4573.c               |  4 +---
>  drivers/gpu/drm/panel/panel-nec-nl8048hl11.c          |  4 +---
>  drivers/gpu/drm/panel/panel-novatek-nt39016.c         |  4 +---
>  drivers/gpu/drm/panel/panel-samsung-db7430.c          |  3 +--
>  drivers/gpu/drm/panel/panel-samsung-ld9040.c          |  4 +---
>  drivers/gpu/drm/panel/panel-samsung-s6d27a1.c         |  3 +--
>  drivers/gpu/drm/panel/panel-samsung-s6e63m0-spi.c     |  3 +--
>  drivers/gpu/drm/panel/panel-sitronix-st7789v.c        |  4 +---
>  drivers/gpu/drm/panel/panel-sony-acx565akm.c          |  4 +---
>  drivers/gpu/drm/panel/panel-tpo-td028ttec1.c          |  4 +---
>  drivers/gpu/drm/panel/panel-tpo-td043mtea1.c          |  4 +---
>  drivers/gpu/drm/panel/panel-tpo-tpg110.c              |  3 +--
>  drivers/gpu/drm/panel/panel-widechips-ws2401.c        |  3 +--
>  drivers/gpu/drm/tiny/hx8357d.c                        |  4 +---
>  drivers/gpu/drm/tiny/ili9163.c                        |  4 +---
>  drivers/gpu/drm/tiny/ili9225.c                        |  4 +---
>  drivers/gpu/drm/tiny/ili9341.c                        |  4 +---
>  drivers/gpu/drm/tiny/ili9486.c                        |  4 +---
>  drivers/gpu/drm/tiny/mi0283qt.c                       |  4 +---
>  drivers/gpu/drm/tiny/repaper.c                        |  4 +---
>  drivers/gpu/drm/tiny/st7586.c                         |  4 +---
>  drivers/gpu/drm/tiny/st7735r.c                        |  4 +---
>  drivers/hwmon/adcxx.c                                 |  4 +---
>  drivers/hwmon/adt7310.c                               |  3 +--
>  drivers/hwmon/max1111.c                               |  3 +--
>  drivers/hwmon/max31722.c                              |  4 +---
>  drivers/iio/accel/bma400_spi.c                        |  4 +---
>  drivers/iio/accel/bmc150-accel-spi.c                  |  4 +---
>  drivers/iio/accel/bmi088-accel-spi.c                  |  4 +---
>  drivers/iio/accel/kxsd9-spi.c                         |  4 +---
>  drivers/iio/accel/mma7455_spi.c                       |  4 +---
>  drivers/iio/accel/sca3000.c                           |  4 +---
>  drivers/iio/adc/ad7266.c                              |  4 +---
>  drivers/iio/adc/ltc2496.c                             |  4 +---
>  drivers/iio/adc/mcp320x.c                             |  4 +---
>  drivers/iio/adc/mcp3911.c                             |  4 +---
>  drivers/iio/adc/ti-adc12138.c                         |  4 +---
>  drivers/iio/adc/ti-ads7950.c                          |  4 +---
>  drivers/iio/adc/ti-ads8688.c                          |  4 +---
>  drivers/iio/adc/ti-tlc4541.c                          |  4 +---
>  drivers/iio/amplifiers/ad8366.c                       |  4 +---
>  drivers/iio/common/ssp_sensors/ssp_dev.c              |  4 +---
>  drivers/iio/dac/ad5360.c                              |  4 +---
>  drivers/iio/dac/ad5380.c                              |  4 +---
>  drivers/iio/dac/ad5446.c                              |  4 +---
>  drivers/iio/dac/ad5449.c                              |  4 +---
>  drivers/iio/dac/ad5504.c                              |  4 +---
>  drivers/iio/dac/ad5592r.c                             |  4 +---
>  drivers/iio/dac/ad5624r_spi.c                         |  4 +---
>  drivers/iio/dac/ad5686-spi.c                          |  4 +---
>  drivers/iio/dac/ad5761.c                              |  4 +---
>  drivers/iio/dac/ad5764.c                              |  4 +---
>  drivers/iio/dac/ad5791.c                              |  4 +---
>  drivers/iio/dac/ad8801.c                              |  4 +---
>  drivers/iio/dac/ltc1660.c                             |  4 +---
>  drivers/iio/dac/ltc2632.c                             |  4 +---
>  drivers/iio/dac/mcp4922.c                             |  4 +---
>  drivers/iio/dac/ti-dac082s085.c                       |  4 +---
>  drivers/iio/dac/ti-dac7311.c                          |  3 +--
>  drivers/iio/frequency/adf4350.c                       |  4 +---
>  drivers/iio/gyro/bmg160_spi.c                         |  4 +---
>  drivers/iio/gyro/fxas21002c_spi.c                     |  4 +---
>  drivers/iio/health/afe4403.c                          |  4 +---
>  drivers/iio/magnetometer/bmc150_magn_spi.c            |  4 +---
>  drivers/iio/magnetometer/hmc5843_spi.c                |  4 +---
>  drivers/iio/potentiometer/max5487.c                   |  4 +---
>  drivers/iio/pressure/ms5611_spi.c                     |  4 +---
>  drivers/iio/pressure/zpa2326_spi.c                    |  4 +---
>  drivers/input/keyboard/applespi.c                     |  4 +---
>  drivers/input/misc/adxl34x-spi.c                      |  4 +---
>  drivers/input/touchscreen/ads7846.c                   |  4 +---
>  drivers/input/touchscreen/cyttsp4_spi.c               |  4 +---
>  drivers/input/touchscreen/tsc2005.c                   |  4 +---
>  drivers/leds/leds-cr0014114.c                         |  4 +---
>  drivers/leds/leds-dac124s085.c                        |  4 +---
>  drivers/leds/leds-el15203000.c                        |  4 +---
>  drivers/leds/leds-spi-byte.c                          |  4 +---
>  drivers/media/spi/cxd2880-spi.c                       |  4 +---
>  drivers/media/spi/gs1662.c                            |  4 +---
>  drivers/media/tuners/msi001.c                         |  3 +--

A bit late, but for drivers/media:

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans
