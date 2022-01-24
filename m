Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E94497F7D
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbiAXM1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:27:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:10688 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239166AbiAXM1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 07:27:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643027229; x=1674563229;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=55/6mCmofXS56Zqfw3PGTWezxP1aCIChyIThIh38aWg=;
  b=RSz9UDDqP5RMGWZdHCHv40cKz6Cqh5opqW4NgPjaY39+T5U2OI2G7YBI
   sABGUTUlv+RJjnHfXR8pJnIkxFFGX9q5xEFGQ8VEVOvwyCvuSy1OWnBy9
   bnAEoLx6YtT5uv1S7frwUY8NVn+2sgPLnGJVSurpboV0wlwY15IDTWDBo
   PnGVNofIa/Vp0z+tUB/AgWq0hrLFudez6dgwY+D4iEiSjNEwIoLb1RTJh
   KnZL4IxjKbQRrqQnaXoV9p8BuitHbAhb9YFWxZWTnPk5monxFVXP3Uodh
   /4T9QRjnKddCIbTYHCgH1cDoypRkV/vc/XerYCIqRb+gQDhMRFBYL/dpn
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="244867551"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="244867551"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 04:27:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="596774315"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 04:26:49 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nByNX-00DsuC-68;
        Mon, 24 Jan 2022 14:23:23 +0200
Date:   Mon, 24 Jan 2022 14:23:22 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Mark Brown <broonie@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
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
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
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
        =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
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
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
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
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Gwendal Grignou <gwendal@chromium.org>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Antoniu Miclaus <antoniu.miclaus@analog.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Ronald =?iso-8859-1?Q?Tschal=E4r?= <ronald@innovation.ch>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
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
        Stefan =?iso-8859-1?Q?M=E4tje?= <stefan.maetje@esd.eu>,
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
Subject: Re: [PATCH 5/5] spi: make remove callback a void function
Message-ID: <Ye6aOqmVxuopdlim@smile.fi.intel.com>
References: <20220123175201.34839-1-u.kleine-koenig@pengutronix.de>
 <20220123175201.34839-6-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220123175201.34839-6-u.kleine-koenig@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 06:52:01PM +0100, Uwe Kleine-König wrote:
> The value returned by an spi driver's remove function is mostly ignored.
> (Only an error message is printed if the value is non-zero that the
> error is ignored.)
> 
> So change the prototype of the remove function to return no value. This
> way driver authors are not tempted to assume that passing an error to
> the upper layer is a good idea. All drivers are adapted accordingly.
> There is no intended change of behaviour, all callbacks were prepared to
> return 0 before.

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

for whatever I have involved in as a maintainer, reviewer, or
valuable developer :).

Thanks for doing this!

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
>  drivers/mfd/arizona-spi.c                             |  4 +---
>  drivers/mfd/da9052-spi.c                              |  3 +--
>  drivers/mfd/ezx-pcap.c                                |  4 +---
>  drivers/mfd/madera-spi.c                              |  4 +---
>  drivers/mfd/mc13xxx-spi.c                             |  3 +--
>  drivers/mfd/rsmu_spi.c                                |  4 +---
>  drivers/mfd/stmpe-spi.c                               |  4 +---
>  drivers/mfd/tps65912-spi.c                            |  4 +---
>  drivers/misc/ad525x_dpot-spi.c                        |  3 +--
>  drivers/misc/eeprom/eeprom_93xx46.c                   |  4 +---
>  drivers/misc/lattice-ecp3-config.c                    |  4 +---
>  drivers/misc/lis3lv02d/lis3lv02d_spi.c                |  4 +---
>  drivers/mmc/host/mmc_spi.c                            |  3 +--
>  drivers/mtd/devices/mchp23k256.c                      |  4 +---
>  drivers/mtd/devices/mchp48l640.c                      |  4 +---
>  drivers/mtd/devices/mtd_dataflash.c                   |  4 +---
>  drivers/mtd/devices/sst25l.c                          |  4 +---
>  drivers/net/can/m_can/tcan4x5x-core.c                 |  4 +---
>  drivers/net/can/spi/hi311x.c                          |  4 +---
>  drivers/net/can/spi/mcp251x.c                         |  4 +---
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c        |  4 +---
>  drivers/net/dsa/b53/b53_spi.c                         |  4 +---
>  drivers/net/dsa/microchip/ksz8795_spi.c               |  4 +---
>  drivers/net/dsa/microchip/ksz9477_spi.c               |  4 +---
>  drivers/net/dsa/sja1105/sja1105_main.c                |  6 ++----
>  drivers/net/dsa/vitesse-vsc73xx-spi.c                 |  6 ++----
>  drivers/net/ethernet/asix/ax88796c_main.c             |  4 +---
>  drivers/net/ethernet/micrel/ks8851_spi.c              |  4 +---
>  drivers/net/ethernet/microchip/enc28j60.c             |  4 +---
>  drivers/net/ethernet/microchip/encx24j600.c           |  4 +---
>  drivers/net/ethernet/qualcomm/qca_spi.c               |  4 +---
>  drivers/net/ethernet/vertexcom/mse102x.c              |  4 +---
>  drivers/net/ethernet/wiznet/w5100-spi.c               |  4 +---
>  drivers/net/ieee802154/adf7242.c                      |  4 +---
>  drivers/net/ieee802154/at86rf230.c                    |  4 +---
>  drivers/net/ieee802154/ca8210.c                       |  6 ++----
>  drivers/net/ieee802154/cc2520.c                       |  4 +---
>  drivers/net/ieee802154/mcr20a.c                       |  4 +---
>  drivers/net/ieee802154/mrf24j40.c                     |  4 +---
>  drivers/net/phy/spi_ks8995.c                          |  4 +---
>  drivers/net/wan/slic_ds26522.c                        |  3 +--
>  drivers/net/wireless/intersil/p54/p54spi.c            |  4 +---
>  drivers/net/wireless/marvell/libertas/if_spi.c        |  4 +---
>  drivers/net/wireless/microchip/wilc1000/spi.c         |  4 +---
>  drivers/net/wireless/st/cw1200/cw1200_spi.c           |  4 +---
>  drivers/net/wireless/ti/wl1251/spi.c                  |  4 +---
>  drivers/net/wireless/ti/wlcore/spi.c                  |  4 +---
>  drivers/nfc/nfcmrvl/spi.c                             |  3 +--
>  drivers/nfc/st-nci/spi.c                              |  4 +---
>  drivers/nfc/st95hf/core.c                             |  4 +---
>  drivers/nfc/trf7970a.c                                |  4 +---
>  drivers/platform/chrome/cros_ec_spi.c                 |  4 +---
>  drivers/platform/olpc/olpc-xo175-ec.c                 |  4 +---
>  drivers/rtc/rtc-ds1302.c                              |  3 +--
>  drivers/rtc/rtc-ds1305.c                              |  4 +---
>  drivers/rtc/rtc-ds1343.c                              |  4 +---
>  drivers/spi/spi-mem.c                                 |  6 ++----
>  drivers/spi/spi-slave-system-control.c                |  3 +--
>  drivers/spi/spi-slave-time.c                          |  3 +--
>  drivers/spi/spi-tle62x0.c                             |  3 +--
>  drivers/spi/spi.c                                     | 11 ++---------
>  drivers/spi/spidev.c                                  |  4 +---
>  drivers/staging/fbtft/fbtft.h                         |  3 +--
>  drivers/staging/pi433/pi433_if.c                      |  4 +---
>  drivers/staging/wfx/bus_spi.c                         |  3 +--
>  drivers/tty/serial/max3100.c                          |  5 ++---
>  drivers/tty/serial/max310x.c                          |  3 +--
>  drivers/tty/serial/sc16is7xx.c                        |  4 +---
>  drivers/usb/gadget/udc/max3420_udc.c                  |  4 +---
>  drivers/usb/host/max3421-hcd.c                        |  3 +--
>  drivers/video/backlight/ams369fg06.c                  |  3 +--
>  drivers/video/backlight/corgi_lcd.c                   |  3 +--
>  drivers/video/backlight/ili922x.c                     |  3 +--
>  drivers/video/backlight/l4f00242t03.c                 |  3 +--
>  drivers/video/backlight/lms501kf03.c                  |  3 +--
>  drivers/video/backlight/ltv350qv.c                    |  3 +--
>  drivers/video/backlight/tdo24m.c                      |  3 +--
>  drivers/video/backlight/tosa_lcd.c                    |  4 +---
>  drivers/video/backlight/vgg2432a4.c                   |  4 +---
>  drivers/video/fbdev/omap/lcd_mipid.c                  |  4 +---
>  .../omap2/omapfb/displays/panel-lgphilips-lb035q02.c  |  4 +---
>  .../omap2/omapfb/displays/panel-nec-nl8048hl11.c      |  4 +---
>  .../omap2/omapfb/displays/panel-sony-acx565akm.c      |  4 +---
>  .../omap2/omapfb/displays/panel-tpo-td028ttec1.c      |  4 +---
>  .../omap2/omapfb/displays/panel-tpo-td043mtea1.c      |  4 +---
>  include/linux/spi/spi.h                               |  2 +-
>  sound/pci/hda/cs35l41_hda_spi.c                       |  4 +---
>  sound/soc/codecs/adau1761-spi.c                       |  3 +--
>  sound/soc/codecs/adau1781-spi.c                       |  3 +--
>  sound/soc/codecs/cs35l41-spi.c                        |  4 +---
>  sound/soc/codecs/pcm3168a-spi.c                       |  4 +---
>  sound/soc/codecs/pcm512x-spi.c                        |  3 +--
>  sound/soc/codecs/tlv320aic32x4-spi.c                  |  4 +---
>  sound/soc/codecs/tlv320aic3x-spi.c                    |  4 +---
>  sound/soc/codecs/wm0010.c                             |  4 +---
>  sound/soc/codecs/wm8804-spi.c                         |  3 +--
>  sound/spi/at73c213.c                                  |  4 +---
>  191 files changed, 197 insertions(+), 545 deletions(-)
> 
> diff --git a/drivers/bus/moxtet.c b/drivers/bus/moxtet.c
> index fd87a59837fa..5eb0fe73ddc4 100644
> --- a/drivers/bus/moxtet.c
> +++ b/drivers/bus/moxtet.c
> @@ -815,7 +815,7 @@ static int moxtet_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int moxtet_remove(struct spi_device *spi)
> +static void moxtet_remove(struct spi_device *spi)
>  {
>  	struct moxtet *moxtet = spi_get_drvdata(spi);
>  
> @@ -828,8 +828,6 @@ static int moxtet_remove(struct spi_device *spi)
>  	device_for_each_child(moxtet->dev, NULL, __unregister);
>  
>  	mutex_destroy(&moxtet->lock);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id moxtet_dt_ids[] = {
> diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
> index ccd9e42b8eab..22d184884694 100644
> --- a/drivers/char/tpm/st33zp24/spi.c
> +++ b/drivers/char/tpm/st33zp24/spi.c
> @@ -381,13 +381,11 @@ static int st33zp24_spi_probe(struct spi_device *dev)
>   * @param: client, the spi_device description (TPM SPI description).
>   * @return: 0 in case of success.
>   */
> -static int st33zp24_spi_remove(struct spi_device *dev)
> +static void st33zp24_spi_remove(struct spi_device *dev)
>  {
>  	struct tpm_chip *chip = spi_get_drvdata(dev);
>  
>  	st33zp24_remove(chip);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id st33zp24_spi_id[] = {
> diff --git a/drivers/char/tpm/tpm_tis_spi_main.c b/drivers/char/tpm/tpm_tis_spi_main.c
> index aaa59a00eeae..184396b3af50 100644
> --- a/drivers/char/tpm/tpm_tis_spi_main.c
> +++ b/drivers/char/tpm/tpm_tis_spi_main.c
> @@ -254,13 +254,12 @@ static int tpm_tis_spi_driver_probe(struct spi_device *spi)
>  
>  static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_spi_resume);
>  
> -static int tpm_tis_spi_remove(struct spi_device *dev)
> +static void tpm_tis_spi_remove(struct spi_device *dev)
>  {
>  	struct tpm_chip *chip = spi_get_drvdata(dev);
>  
>  	tpm_chip_unregister(chip);
>  	tpm_tis_remove(chip);
> -	return 0;
>  }
>  
>  static const struct spi_device_id tpm_tis_spi_id[] = {
> diff --git a/drivers/clk/clk-lmk04832.c b/drivers/clk/clk-lmk04832.c
> index 8f02c0b88000..f416f8bc2898 100644
> --- a/drivers/clk/clk-lmk04832.c
> +++ b/drivers/clk/clk-lmk04832.c
> @@ -1544,14 +1544,12 @@ static int lmk04832_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int lmk04832_remove(struct spi_device *spi)
> +static void lmk04832_remove(struct spi_device *spi)
>  {
>  	struct lmk04832 *lmk = spi_get_drvdata(spi);
>  
>  	clk_disable_unprepare(lmk->oscin);
>  	of_clk_del_provider(spi->dev.of_node);
> -
> -	return 0;
>  }
>  static const struct spi_device_id lmk04832_id[] = {
>  	{ "lmk04832", LMK04832 },
> diff --git a/drivers/gpio/gpio-74x164.c b/drivers/gpio/gpio-74x164.c
> index 4a55cdf089d6..e00c33310517 100644
> --- a/drivers/gpio/gpio-74x164.c
> +++ b/drivers/gpio/gpio-74x164.c
> @@ -163,15 +163,13 @@ static int gen_74x164_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int gen_74x164_remove(struct spi_device *spi)
> +static void gen_74x164_remove(struct spi_device *spi)
>  {
>  	struct gen_74x164_chip *chip = spi_get_drvdata(spi);
>  
>  	gpiod_set_value_cansleep(chip->gpiod_oe, 0);
>  	gpiochip_remove(&chip->gpio_chip);
>  	mutex_destroy(&chip->lock);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id gen_74x164_spi_ids[] = {
> diff --git a/drivers/gpio/gpio-max3191x.c b/drivers/gpio/gpio-max3191x.c
> index 51cd6f98d1c7..161c4751c5f7 100644
> --- a/drivers/gpio/gpio-max3191x.c
> +++ b/drivers/gpio/gpio-max3191x.c
> @@ -443,14 +443,12 @@ static int max3191x_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int max3191x_remove(struct spi_device *spi)
> +static void max3191x_remove(struct spi_device *spi)
>  {
>  	struct max3191x_chip *max3191x = spi_get_drvdata(spi);
>  
>  	gpiochip_remove(&max3191x->gpio);
>  	mutex_destroy(&max3191x->lock);
> -
> -	return 0;
>  }
>  
>  static int __init max3191x_register_driver(struct spi_driver *sdrv)
> diff --git a/drivers/gpio/gpio-max7301.c b/drivers/gpio/gpio-max7301.c
> index 5862d73bf325..11813f41d460 100644
> --- a/drivers/gpio/gpio-max7301.c
> +++ b/drivers/gpio/gpio-max7301.c
> @@ -64,11 +64,9 @@ static int max7301_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int max7301_remove(struct spi_device *spi)
> +static void max7301_remove(struct spi_device *spi)
>  {
>  	__max730x_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id max7301_id[] = {
> diff --git a/drivers/gpio/gpio-mc33880.c b/drivers/gpio/gpio-mc33880.c
> index 31d2be1bebc8..cd9b16dbe1a9 100644
> --- a/drivers/gpio/gpio-mc33880.c
> +++ b/drivers/gpio/gpio-mc33880.c
> @@ -134,7 +134,7 @@ static int mc33880_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int mc33880_remove(struct spi_device *spi)
> +static void mc33880_remove(struct spi_device *spi)
>  {
>  	struct mc33880 *mc;
>  
> @@ -142,8 +142,6 @@ static int mc33880_remove(struct spi_device *spi)
>  
>  	gpiochip_remove(&mc->chip);
>  	mutex_destroy(&mc->lock);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver mc33880_driver = {
> diff --git a/drivers/gpio/gpio-pisosr.c b/drivers/gpio/gpio-pisosr.c
> index 8e04054cf07e..81a47ae09ff8 100644
> --- a/drivers/gpio/gpio-pisosr.c
> +++ b/drivers/gpio/gpio-pisosr.c
> @@ -163,15 +163,13 @@ static int pisosr_gpio_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int pisosr_gpio_remove(struct spi_device *spi)
> +static void pisosr_gpio_remove(struct spi_device *spi)
>  {
>  	struct pisosr_gpio *gpio = spi_get_drvdata(spi);
>  
>  	gpiochip_remove(&gpio->chip);
>  
>  	mutex_destroy(&gpio->lock);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id pisosr_gpio_id_table[] = {
> diff --git a/drivers/gpu/drm/panel/panel-abt-y030xx067a.c b/drivers/gpu/drm/panel/panel-abt-y030xx067a.c
> index f043b484055b..ed626fdc08e8 100644
> --- a/drivers/gpu/drm/panel/panel-abt-y030xx067a.c
> +++ b/drivers/gpu/drm/panel/panel-abt-y030xx067a.c
> @@ -293,15 +293,13 @@ static int y030xx067a_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int y030xx067a_remove(struct spi_device *spi)
> +static void y030xx067a_remove(struct spi_device *spi)
>  {
>  	struct y030xx067a *priv = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&priv->panel);
>  	drm_panel_disable(&priv->panel);
>  	drm_panel_unprepare(&priv->panel);
> -
> -	return 0;
>  }
>  
>  static const struct drm_display_mode y030xx067a_modes[] = {
> diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9322.c b/drivers/gpu/drm/panel/panel-ilitek-ili9322.c
> index 8e84df9a0033..3dfafa585127 100644
> --- a/drivers/gpu/drm/panel/panel-ilitek-ili9322.c
> +++ b/drivers/gpu/drm/panel/panel-ilitek-ili9322.c
> @@ -896,14 +896,12 @@ static int ili9322_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ili9322_remove(struct spi_device *spi)
> +static void ili9322_remove(struct spi_device *spi)
>  {
>  	struct ili9322 *ili = spi_get_drvdata(spi);
>  
>  	ili9322_power_off(ili);
>  	drm_panel_remove(&ili->panel);
> -
> -	return 0;
>  }
>  
>  /*
> diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
> index 2c3378a259b1..a07ef26234e5 100644
> --- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
> +++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
> @@ -728,7 +728,7 @@ static int ili9341_probe(struct spi_device *spi)
>  	return -1;
>  }
>  
> -static int ili9341_remove(struct spi_device *spi)
> +static void ili9341_remove(struct spi_device *spi)
>  {
>  	const struct spi_device_id *id = spi_get_device_id(spi);
>  	struct ili9341 *ili = spi_get_drvdata(spi);
> @@ -741,7 +741,6 @@ static int ili9341_remove(struct spi_device *spi)
>  		drm_dev_unplug(drm);
>  		drm_atomic_helper_shutdown(drm);
>  	}
> -	return 0;
>  }
>  
>  static void ili9341_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/panel/panel-innolux-ej030na.c b/drivers/gpu/drm/panel/panel-innolux-ej030na.c
> index c558de3f99be..e3b1daa0cb72 100644
> --- a/drivers/gpu/drm/panel/panel-innolux-ej030na.c
> +++ b/drivers/gpu/drm/panel/panel-innolux-ej030na.c
> @@ -219,15 +219,13 @@ static int ej030na_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ej030na_remove(struct spi_device *spi)
> +static void ej030na_remove(struct spi_device *spi)
>  {
>  	struct ej030na *priv = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&priv->panel);
>  	drm_panel_disable(&priv->panel);
>  	drm_panel_unprepare(&priv->panel);
> -
> -	return 0;
>  }
>  
>  static const struct drm_display_mode ej030na_modes[] = {
> diff --git a/drivers/gpu/drm/panel/panel-lg-lb035q02.c b/drivers/gpu/drm/panel/panel-lg-lb035q02.c
> index f3183b68704f..9d0d4faa3f58 100644
> --- a/drivers/gpu/drm/panel/panel-lg-lb035q02.c
> +++ b/drivers/gpu/drm/panel/panel-lg-lb035q02.c
> @@ -203,14 +203,12 @@ static int lb035q02_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int lb035q02_remove(struct spi_device *spi)
> +static void lb035q02_remove(struct spi_device *spi)
>  {
>  	struct lb035q02_device *lcd = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&lcd->panel);
>  	drm_panel_disable(&lcd->panel);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id lb035q02_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-lg-lg4573.c b/drivers/gpu/drm/panel/panel-lg-lg4573.c
> index 8e5160af1de5..cf246d15b7b6 100644
> --- a/drivers/gpu/drm/panel/panel-lg-lg4573.c
> +++ b/drivers/gpu/drm/panel/panel-lg-lg4573.c
> @@ -266,14 +266,12 @@ static int lg4573_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int lg4573_remove(struct spi_device *spi)
> +static void lg4573_remove(struct spi_device *spi)
>  {
>  	struct lg4573 *ctx = spi_get_drvdata(spi);
>  
>  	lg4573_display_off(ctx);
>  	drm_panel_remove(&ctx->panel);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id lg4573_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-nec-nl8048hl11.c b/drivers/gpu/drm/panel/panel-nec-nl8048hl11.c
> index 6e5ab1debc8b..81c5c541a351 100644
> --- a/drivers/gpu/drm/panel/panel-nec-nl8048hl11.c
> +++ b/drivers/gpu/drm/panel/panel-nec-nl8048hl11.c
> @@ -212,15 +212,13 @@ static int nl8048_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int nl8048_remove(struct spi_device *spi)
> +static void nl8048_remove(struct spi_device *spi)
>  {
>  	struct nl8048_panel *lcd = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&lcd->panel);
>  	drm_panel_disable(&lcd->panel);
>  	drm_panel_unprepare(&lcd->panel);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id nl8048_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-novatek-nt39016.c b/drivers/gpu/drm/panel/panel-novatek-nt39016.c
> index d036853db865..f58cfb10b58a 100644
> --- a/drivers/gpu/drm/panel/panel-novatek-nt39016.c
> +++ b/drivers/gpu/drm/panel/panel-novatek-nt39016.c
> @@ -292,7 +292,7 @@ static int nt39016_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int nt39016_remove(struct spi_device *spi)
> +static void nt39016_remove(struct spi_device *spi)
>  {
>  	struct nt39016 *panel = spi_get_drvdata(spi);
>  
> @@ -300,8 +300,6 @@ static int nt39016_remove(struct spi_device *spi)
>  
>  	nt39016_disable(&panel->drm_panel);
>  	nt39016_unprepare(&panel->drm_panel);
> -
> -	return 0;
>  }
>  
>  static const struct drm_display_mode kd035g6_display_modes[] = {
> diff --git a/drivers/gpu/drm/panel/panel-samsung-db7430.c b/drivers/gpu/drm/panel/panel-samsung-db7430.c
> index ead479719f00..04640c5256a8 100644
> --- a/drivers/gpu/drm/panel/panel-samsung-db7430.c
> +++ b/drivers/gpu/drm/panel/panel-samsung-db7430.c
> @@ -314,12 +314,11 @@ static int db7430_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int db7430_remove(struct spi_device *spi)
> +static void db7430_remove(struct spi_device *spi)
>  {
>  	struct db7430 *db = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&db->panel);
> -	return 0;
>  }
>  
>  /*
> diff --git a/drivers/gpu/drm/panel/panel-samsung-ld9040.c b/drivers/gpu/drm/panel/panel-samsung-ld9040.c
> index c4b388850a13..01eb211f32f7 100644
> --- a/drivers/gpu/drm/panel/panel-samsung-ld9040.c
> +++ b/drivers/gpu/drm/panel/panel-samsung-ld9040.c
> @@ -358,14 +358,12 @@ static int ld9040_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ld9040_remove(struct spi_device *spi)
> +static void ld9040_remove(struct spi_device *spi)
>  {
>  	struct ld9040 *ctx = spi_get_drvdata(spi);
>  
>  	ld9040_power_off(ctx);
>  	drm_panel_remove(&ctx->panel);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id ld9040_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-samsung-s6d27a1.c b/drivers/gpu/drm/panel/panel-samsung-s6d27a1.c
> index 1696ceb36aa0..2adb223a895c 100644
> --- a/drivers/gpu/drm/panel/panel-samsung-s6d27a1.c
> +++ b/drivers/gpu/drm/panel/panel-samsung-s6d27a1.c
> @@ -291,12 +291,11 @@ static int s6d27a1_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int s6d27a1_remove(struct spi_device *spi)
> +static void s6d27a1_remove(struct spi_device *spi)
>  {
>  	struct s6d27a1 *ctx = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&ctx->panel);
> -	return 0;
>  }
>  
>  static const struct of_device_id s6d27a1_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e63m0-spi.c b/drivers/gpu/drm/panel/panel-samsung-s6e63m0-spi.c
> index c178d962b0d5..d99afcc672ca 100644
> --- a/drivers/gpu/drm/panel/panel-samsung-s6e63m0-spi.c
> +++ b/drivers/gpu/drm/panel/panel-samsung-s6e63m0-spi.c
> @@ -62,10 +62,9 @@ static int s6e63m0_spi_probe(struct spi_device *spi)
>  			     s6e63m0_spi_dcs_write, false);
>  }
>  
> -static int s6e63m0_spi_remove(struct spi_device *spi)
> +static void s6e63m0_spi_remove(struct spi_device *spi)
>  {
>  	s6e63m0_remove(&spi->dev);
> -	return 0;
>  }
>  
>  static const struct of_device_id s6e63m0_spi_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
> index 61e565524542..bbc4569cbcdc 100644
> --- a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
> +++ b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
> @@ -387,13 +387,11 @@ static int st7789v_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int st7789v_remove(struct spi_device *spi)
> +static void st7789v_remove(struct spi_device *spi)
>  {
>  	struct st7789v *ctx = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&ctx->panel);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id st7789v_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-sony-acx565akm.c b/drivers/gpu/drm/panel/panel-sony-acx565akm.c
> index ba0b3ead150f..0d7541a33f87 100644
> --- a/drivers/gpu/drm/panel/panel-sony-acx565akm.c
> +++ b/drivers/gpu/drm/panel/panel-sony-acx565akm.c
> @@ -655,7 +655,7 @@ static int acx565akm_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int acx565akm_remove(struct spi_device *spi)
> +static void acx565akm_remove(struct spi_device *spi)
>  {
>  	struct acx565akm_panel *lcd = spi_get_drvdata(spi);
>  
> @@ -666,8 +666,6 @@ static int acx565akm_remove(struct spi_device *spi)
>  
>  	drm_panel_disable(&lcd->panel);
>  	drm_panel_unprepare(&lcd->panel);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id acx565akm_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-tpo-td028ttec1.c b/drivers/gpu/drm/panel/panel-tpo-td028ttec1.c
> index ba0c00d1a001..4dbf8b88f264 100644
> --- a/drivers/gpu/drm/panel/panel-tpo-td028ttec1.c
> +++ b/drivers/gpu/drm/panel/panel-tpo-td028ttec1.c
> @@ -350,15 +350,13 @@ static int td028ttec1_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int td028ttec1_remove(struct spi_device *spi)
> +static void td028ttec1_remove(struct spi_device *spi)
>  {
>  	struct td028ttec1_panel *lcd = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&lcd->panel);
>  	drm_panel_disable(&lcd->panel);
>  	drm_panel_unprepare(&lcd->panel);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id td028ttec1_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-tpo-td043mtea1.c b/drivers/gpu/drm/panel/panel-tpo-td043mtea1.c
> index 1866cdb8f9c1..cf4609bb9b1d 100644
> --- a/drivers/gpu/drm/panel/panel-tpo-td043mtea1.c
> +++ b/drivers/gpu/drm/panel/panel-tpo-td043mtea1.c
> @@ -463,7 +463,7 @@ static int td043mtea1_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int td043mtea1_remove(struct spi_device *spi)
> +static void td043mtea1_remove(struct spi_device *spi)
>  {
>  	struct td043mtea1_panel *lcd = spi_get_drvdata(spi);
>  
> @@ -472,8 +472,6 @@ static int td043mtea1_remove(struct spi_device *spi)
>  	drm_panel_unprepare(&lcd->panel);
>  
>  	sysfs_remove_group(&spi->dev.kobj, &td043mtea1_attr_group);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id td043mtea1_of_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-tpo-tpg110.c b/drivers/gpu/drm/panel/panel-tpo-tpg110.c
> index e3791dad6830..0b1f5a11a055 100644
> --- a/drivers/gpu/drm/panel/panel-tpo-tpg110.c
> +++ b/drivers/gpu/drm/panel/panel-tpo-tpg110.c
> @@ -450,12 +450,11 @@ static int tpg110_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int tpg110_remove(struct spi_device *spi)
> +static void tpg110_remove(struct spi_device *spi)
>  {
>  	struct tpg110 *tpg = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&tpg->panel);
> -	return 0;
>  }
>  
>  static const struct of_device_id tpg110_match[] = {
> diff --git a/drivers/gpu/drm/panel/panel-widechips-ws2401.c b/drivers/gpu/drm/panel/panel-widechips-ws2401.c
> index 8bc976f54b80..236f3cb2b594 100644
> --- a/drivers/gpu/drm/panel/panel-widechips-ws2401.c
> +++ b/drivers/gpu/drm/panel/panel-widechips-ws2401.c
> @@ -407,12 +407,11 @@ static int ws2401_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ws2401_remove(struct spi_device *spi)
> +static void ws2401_remove(struct spi_device *spi)
>  {
>  	struct ws2401 *ws = spi_get_drvdata(spi);
>  
>  	drm_panel_remove(&ws->panel);
> -	return 0;
>  }
>  
>  /*
> diff --git a/drivers/gpu/drm/tiny/hx8357d.c b/drivers/gpu/drm/tiny/hx8357d.c
> index 9b33c05732aa..ebb025543f8d 100644
> --- a/drivers/gpu/drm/tiny/hx8357d.c
> +++ b/drivers/gpu/drm/tiny/hx8357d.c
> @@ -263,14 +263,12 @@ static int hx8357d_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int hx8357d_remove(struct spi_device *spi)
> +static void hx8357d_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void hx8357d_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/ili9163.c b/drivers/gpu/drm/tiny/ili9163.c
> index bcc181351236..fc8ed245b0bc 100644
> --- a/drivers/gpu/drm/tiny/ili9163.c
> +++ b/drivers/gpu/drm/tiny/ili9163.c
> @@ -193,14 +193,12 @@ static int ili9163_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ili9163_remove(struct spi_device *spi)
> +static void ili9163_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void ili9163_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/ili9225.c b/drivers/gpu/drm/tiny/ili9225.c
> index 976d3209f164..cc92eb9f2a07 100644
> --- a/drivers/gpu/drm/tiny/ili9225.c
> +++ b/drivers/gpu/drm/tiny/ili9225.c
> @@ -411,14 +411,12 @@ static int ili9225_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ili9225_remove(struct spi_device *spi)
> +static void ili9225_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void ili9225_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/ili9341.c b/drivers/gpu/drm/tiny/ili9341.c
> index 37e0c33399c8..5b8cc770ee7b 100644
> --- a/drivers/gpu/drm/tiny/ili9341.c
> +++ b/drivers/gpu/drm/tiny/ili9341.c
> @@ -225,14 +225,12 @@ static int ili9341_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ili9341_remove(struct spi_device *spi)
> +static void ili9341_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void ili9341_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/ili9486.c b/drivers/gpu/drm/tiny/ili9486.c
> index e9a63f4b2993..6d655e18e0aa 100644
> --- a/drivers/gpu/drm/tiny/ili9486.c
> +++ b/drivers/gpu/drm/tiny/ili9486.c
> @@ -243,14 +243,12 @@ static int ili9486_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ili9486_remove(struct spi_device *spi)
> +static void ili9486_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void ili9486_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/mi0283qt.c b/drivers/gpu/drm/tiny/mi0283qt.c
> index 023de49e7a8e..5e060f6910bb 100644
> --- a/drivers/gpu/drm/tiny/mi0283qt.c
> +++ b/drivers/gpu/drm/tiny/mi0283qt.c
> @@ -233,14 +233,12 @@ static int mi0283qt_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int mi0283qt_remove(struct spi_device *spi)
> +static void mi0283qt_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void mi0283qt_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/repaper.c b/drivers/gpu/drm/tiny/repaper.c
> index 97a775c48cea..beeeb170d0b1 100644
> --- a/drivers/gpu/drm/tiny/repaper.c
> +++ b/drivers/gpu/drm/tiny/repaper.c
> @@ -1140,14 +1140,12 @@ static int repaper_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int repaper_remove(struct spi_device *spi)
> +static void repaper_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void repaper_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/st7586.c b/drivers/gpu/drm/tiny/st7586.c
> index 51b9b9fb3ead..3f38faa1cd8c 100644
> --- a/drivers/gpu/drm/tiny/st7586.c
> +++ b/drivers/gpu/drm/tiny/st7586.c
> @@ -360,14 +360,12 @@ static int st7586_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int st7586_remove(struct spi_device *spi)
> +static void st7586_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void st7586_shutdown(struct spi_device *spi)
> diff --git a/drivers/gpu/drm/tiny/st7735r.c b/drivers/gpu/drm/tiny/st7735r.c
> index fc40dd10efa8..29d618093e94 100644
> --- a/drivers/gpu/drm/tiny/st7735r.c
> +++ b/drivers/gpu/drm/tiny/st7735r.c
> @@ -247,14 +247,12 @@ static int st7735r_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int st7735r_remove(struct spi_device *spi)
> +static void st7735r_remove(struct spi_device *spi)
>  {
>  	struct drm_device *drm = spi_get_drvdata(spi);
>  
>  	drm_dev_unplug(drm);
>  	drm_atomic_helper_shutdown(drm);
> -
> -	return 0;
>  }
>  
>  static void st7735r_shutdown(struct spi_device *spi)
> diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
> index e5bc5ce09f4e..de37bce24fa6 100644
> --- a/drivers/hwmon/adcxx.c
> +++ b/drivers/hwmon/adcxx.c
> @@ -194,7 +194,7 @@ static int adcxx_probe(struct spi_device *spi)
>  	return status;
>  }
>  
> -static int adcxx_remove(struct spi_device *spi)
> +static void adcxx_remove(struct spi_device *spi)
>  {
>  	struct adcxx *adc = spi_get_drvdata(spi);
>  	int i;
> @@ -205,8 +205,6 @@ static int adcxx_remove(struct spi_device *spi)
>  		device_remove_file(&spi->dev, &ad_input[i].dev_attr);
>  
>  	mutex_unlock(&adc->lock);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id adcxx_ids[] = {
> diff --git a/drivers/hwmon/adt7310.c b/drivers/hwmon/adt7310.c
> index c40cac16af68..832d9ec64934 100644
> --- a/drivers/hwmon/adt7310.c
> +++ b/drivers/hwmon/adt7310.c
> @@ -88,10 +88,9 @@ static int adt7310_spi_probe(struct spi_device *spi)
>  			&adt7310_spi_ops);
>  }
>  
> -static int adt7310_spi_remove(struct spi_device *spi)
> +static void adt7310_spi_remove(struct spi_device *spi)
>  {
>  	adt7x10_remove(&spi->dev, spi->irq);
> -	return 0;
>  }
>  
>  static const struct spi_device_id adt7310_id[] = {
> diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
> index 5fcfd57df61e..4c5487aeb3cf 100644
> --- a/drivers/hwmon/max1111.c
> +++ b/drivers/hwmon/max1111.c
> @@ -254,7 +254,7 @@ static int max1111_probe(struct spi_device *spi)
>  	return err;
>  }
>  
> -static int max1111_remove(struct spi_device *spi)
> +static void max1111_remove(struct spi_device *spi)
>  {
>  	struct max1111_data *data = spi_get_drvdata(spi);
>  
> @@ -265,7 +265,6 @@ static int max1111_remove(struct spi_device *spi)
>  	sysfs_remove_group(&spi->dev.kobj, &max1110_attr_group);
>  	sysfs_remove_group(&spi->dev.kobj, &max1111_attr_group);
>  	mutex_destroy(&data->drvdata_lock);
> -	return 0;
>  }
>  
>  static const struct spi_device_id max1111_ids[] = {
> diff --git a/drivers/hwmon/max31722.c b/drivers/hwmon/max31722.c
> index 4cf4fe6809a3..93e048ee4955 100644
> --- a/drivers/hwmon/max31722.c
> +++ b/drivers/hwmon/max31722.c
> @@ -100,7 +100,7 @@ static int max31722_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int max31722_remove(struct spi_device *spi)
> +static void max31722_remove(struct spi_device *spi)
>  {
>  	struct max31722_data *data = spi_get_drvdata(spi);
>  	int ret;
> @@ -111,8 +111,6 @@ static int max31722_remove(struct spi_device *spi)
>  	if (ret)
>  		/* There is nothing we can do about this ... */
>  		dev_warn(&spi->dev, "Failed to put device in stand-by mode\n");
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused max31722_suspend(struct device *dev)
> diff --git a/drivers/iio/accel/bma400_spi.c b/drivers/iio/accel/bma400_spi.c
> index 9f622e37477b..9040a717b247 100644
> --- a/drivers/iio/accel/bma400_spi.c
> +++ b/drivers/iio/accel/bma400_spi.c
> @@ -87,11 +87,9 @@ static int bma400_spi_probe(struct spi_device *spi)
>  	return bma400_probe(&spi->dev, regmap, id->name);
>  }
>  
> -static int bma400_spi_remove(struct spi_device *spi)
> +static void bma400_spi_remove(struct spi_device *spi)
>  {
>  	bma400_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id bma400_spi_ids[] = {
> diff --git a/drivers/iio/accel/bmc150-accel-spi.c b/drivers/iio/accel/bmc150-accel-spi.c
> index 11559567cb39..80007cc2d044 100644
> --- a/drivers/iio/accel/bmc150-accel-spi.c
> +++ b/drivers/iio/accel/bmc150-accel-spi.c
> @@ -35,11 +35,9 @@ static int bmc150_accel_probe(struct spi_device *spi)
>  				       true);
>  }
>  
> -static int bmc150_accel_remove(struct spi_device *spi)
> +static void bmc150_accel_remove(struct spi_device *spi)
>  {
>  	bmc150_accel_core_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct acpi_device_id bmc150_accel_acpi_match[] = {
> diff --git a/drivers/iio/accel/bmi088-accel-spi.c b/drivers/iio/accel/bmi088-accel-spi.c
> index 758ad2f12896..06d99d9949f3 100644
> --- a/drivers/iio/accel/bmi088-accel-spi.c
> +++ b/drivers/iio/accel/bmi088-accel-spi.c
> @@ -56,11 +56,9 @@ static int bmi088_accel_probe(struct spi_device *spi)
>  				       true);
>  }
>  
> -static int bmi088_accel_remove(struct spi_device *spi)
> +static void bmi088_accel_remove(struct spi_device *spi)
>  {
>  	bmi088_accel_core_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id bmi088_accel_id[] = {
> diff --git a/drivers/iio/accel/kxsd9-spi.c b/drivers/iio/accel/kxsd9-spi.c
> index 441e6b764281..57c451cfb9e5 100644
> --- a/drivers/iio/accel/kxsd9-spi.c
> +++ b/drivers/iio/accel/kxsd9-spi.c
> @@ -32,11 +32,9 @@ static int kxsd9_spi_probe(struct spi_device *spi)
>  				  spi_get_device_id(spi)->name);
>  }
>  
> -static int kxsd9_spi_remove(struct spi_device *spi)
> +static void kxsd9_spi_remove(struct spi_device *spi)
>  {
>  	kxsd9_common_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id kxsd9_spi_id[] = {
> diff --git a/drivers/iio/accel/mma7455_spi.c b/drivers/iio/accel/mma7455_spi.c
> index ecf690692dcc..b746031551a3 100644
> --- a/drivers/iio/accel/mma7455_spi.c
> +++ b/drivers/iio/accel/mma7455_spi.c
> @@ -22,11 +22,9 @@ static int mma7455_spi_probe(struct spi_device *spi)
>  	return mma7455_core_probe(&spi->dev, regmap, id->name);
>  }
>  
> -static int mma7455_spi_remove(struct spi_device *spi)
> +static void mma7455_spi_remove(struct spi_device *spi)
>  {
>  	mma7455_core_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id mma7455_spi_ids[] = {
> diff --git a/drivers/iio/accel/sca3000.c b/drivers/iio/accel/sca3000.c
> index 43ecacbdc95a..83c81072511e 100644
> --- a/drivers/iio/accel/sca3000.c
> +++ b/drivers/iio/accel/sca3000.c
> @@ -1524,7 +1524,7 @@ static int sca3000_stop_all_interrupts(struct sca3000_state *st)
>  	return ret;
>  }
>  
> -static int sca3000_remove(struct spi_device *spi)
> +static void sca3000_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct sca3000_state *st = iio_priv(indio_dev);
> @@ -1535,8 +1535,6 @@ static int sca3000_remove(struct spi_device *spi)
>  	sca3000_stop_all_interrupts(st);
>  	if (spi->irq)
>  		free_irq(spi->irq, indio_dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id sca3000_id[] = {
> diff --git a/drivers/iio/adc/ad7266.c b/drivers/iio/adc/ad7266.c
> index 1d345d66742d..c17d9b5fbaf6 100644
> --- a/drivers/iio/adc/ad7266.c
> +++ b/drivers/iio/adc/ad7266.c
> @@ -479,7 +479,7 @@ static int ad7266_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad7266_remove(struct spi_device *spi)
> +static void ad7266_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad7266_state *st = iio_priv(indio_dev);
> @@ -488,8 +488,6 @@ static int ad7266_remove(struct spi_device *spi)
>  	iio_triggered_buffer_cleanup(indio_dev);
>  	if (!IS_ERR(st->reg))
>  		regulator_disable(st->reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad7266_id[] = {
> diff --git a/drivers/iio/adc/ltc2496.c b/drivers/iio/adc/ltc2496.c
> index dd956a7c216e..5a55f79f2574 100644
> --- a/drivers/iio/adc/ltc2496.c
> +++ b/drivers/iio/adc/ltc2496.c
> @@ -78,13 +78,11 @@ static int ltc2496_probe(struct spi_device *spi)
>  	return ltc2497core_probe(dev, indio_dev);
>  }
>  
> -static int ltc2496_remove(struct spi_device *spi)
> +static void ltc2496_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  
>  	ltc2497core_remove(indio_dev);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id ltc2496_of_match[] = {
> diff --git a/drivers/iio/adc/mcp320x.c b/drivers/iio/adc/mcp320x.c
> index 8d1cff28cae0..b4c69acb33e3 100644
> --- a/drivers/iio/adc/mcp320x.c
> +++ b/drivers/iio/adc/mcp320x.c
> @@ -459,15 +459,13 @@ static int mcp320x_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int mcp320x_remove(struct spi_device *spi)
> +static void mcp320x_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct mcp320x *adc = iio_priv(indio_dev);
>  
>  	iio_device_unregister(indio_dev);
>  	regulator_disable(adc->reg);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id mcp320x_dt_ids[] = {
> diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
> index 13535f148c4c..1cb4590fe412 100644
> --- a/drivers/iio/adc/mcp3911.c
> +++ b/drivers/iio/adc/mcp3911.c
> @@ -321,7 +321,7 @@ static int mcp3911_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int mcp3911_remove(struct spi_device *spi)
> +static void mcp3911_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct mcp3911 *adc = iio_priv(indio_dev);
> @@ -331,8 +331,6 @@ static int mcp3911_remove(struct spi_device *spi)
>  	clk_disable_unprepare(adc->clki);
>  	if (adc->vref)
>  		regulator_disable(adc->vref);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id mcp3911_dt_ids[] = {
> diff --git a/drivers/iio/adc/ti-adc12138.c b/drivers/iio/adc/ti-adc12138.c
> index 6eb62b564dae..59d75d09604f 100644
> --- a/drivers/iio/adc/ti-adc12138.c
> +++ b/drivers/iio/adc/ti-adc12138.c
> @@ -503,7 +503,7 @@ static int adc12138_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int adc12138_remove(struct spi_device *spi)
> +static void adc12138_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct adc12138 *adc = iio_priv(indio_dev);
> @@ -514,8 +514,6 @@ static int adc12138_remove(struct spi_device *spi)
>  		regulator_disable(adc->vref_n);
>  	regulator_disable(adc->vref_p);
>  	clk_disable_unprepare(adc->cclk);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id adc12138_dt_ids[] = {
> diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
> index a7efa3eada2c..e3658b969c5b 100644
> --- a/drivers/iio/adc/ti-ads7950.c
> +++ b/drivers/iio/adc/ti-ads7950.c
> @@ -662,7 +662,7 @@ static int ti_ads7950_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ti_ads7950_remove(struct spi_device *spi)
> +static void ti_ads7950_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ti_ads7950_state *st = iio_priv(indio_dev);
> @@ -672,8 +672,6 @@ static int ti_ads7950_remove(struct spi_device *spi)
>  	iio_triggered_buffer_cleanup(indio_dev);
>  	regulator_disable(st->reg);
>  	mutex_destroy(&st->slock);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ti_ads7950_id[] = {
> diff --git a/drivers/iio/adc/ti-ads8688.c b/drivers/iio/adc/ti-ads8688.c
> index 2e24717d7f55..22c2583eedd0 100644
> --- a/drivers/iio/adc/ti-ads8688.c
> +++ b/drivers/iio/adc/ti-ads8688.c
> @@ -479,7 +479,7 @@ static int ads8688_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ads8688_remove(struct spi_device *spi)
> +static void ads8688_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ads8688_state *st = iio_priv(indio_dev);
> @@ -489,8 +489,6 @@ static int ads8688_remove(struct spi_device *spi)
>  
>  	if (!IS_ERR(st->reg))
>  		regulator_disable(st->reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ads8688_id[] = {
> diff --git a/drivers/iio/adc/ti-tlc4541.c b/drivers/iio/adc/ti-tlc4541.c
> index 403b787f9f7e..2406eda9dfc6 100644
> --- a/drivers/iio/adc/ti-tlc4541.c
> +++ b/drivers/iio/adc/ti-tlc4541.c
> @@ -224,7 +224,7 @@ static int tlc4541_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int tlc4541_remove(struct spi_device *spi)
> +static void tlc4541_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct tlc4541_state *st = iio_priv(indio_dev);
> @@ -232,8 +232,6 @@ static int tlc4541_remove(struct spi_device *spi)
>  	iio_device_unregister(indio_dev);
>  	iio_triggered_buffer_cleanup(indio_dev);
>  	regulator_disable(st->reg);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id tlc4541_dt_ids[] = {
> diff --git a/drivers/iio/amplifiers/ad8366.c b/drivers/iio/amplifiers/ad8366.c
> index cfcf18a0bce8..1134ae12e531 100644
> --- a/drivers/iio/amplifiers/ad8366.c
> +++ b/drivers/iio/amplifiers/ad8366.c
> @@ -298,7 +298,7 @@ static int ad8366_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad8366_remove(struct spi_device *spi)
> +static void ad8366_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad8366_state *st = iio_priv(indio_dev);
> @@ -308,8 +308,6 @@ static int ad8366_remove(struct spi_device *spi)
>  
>  	if (!IS_ERR(reg))
>  		regulator_disable(reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad8366_id[] = {
> diff --git a/drivers/iio/common/ssp_sensors/ssp_dev.c b/drivers/iio/common/ssp_sensors/ssp_dev.c
> index 1aee87100038..eafaf4529df5 100644
> --- a/drivers/iio/common/ssp_sensors/ssp_dev.c
> +++ b/drivers/iio/common/ssp_sensors/ssp_dev.c
> @@ -586,7 +586,7 @@ static int ssp_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ssp_remove(struct spi_device *spi)
> +static void ssp_remove(struct spi_device *spi)
>  {
>  	struct ssp_data *data = spi_get_drvdata(spi);
>  
> @@ -608,8 +608,6 @@ static int ssp_remove(struct spi_device *spi)
>  	mutex_destroy(&data->pending_lock);
>  
>  	mfd_remove_devices(&spi->dev);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/iio/dac/ad5360.c b/drivers/iio/dac/ad5360.c
> index 2d3b14c407d8..ecbc6a51d60f 100644
> --- a/drivers/iio/dac/ad5360.c
> +++ b/drivers/iio/dac/ad5360.c
> @@ -521,7 +521,7 @@ static int ad5360_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad5360_remove(struct spi_device *spi)
> +static void ad5360_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad5360_state *st = iio_priv(indio_dev);
> @@ -531,8 +531,6 @@ static int ad5360_remove(struct spi_device *spi)
>  	kfree(indio_dev->channels);
>  
>  	regulator_bulk_disable(st->chip_info->num_vrefs, st->vref_reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5360_ids[] = {
> diff --git a/drivers/iio/dac/ad5380.c b/drivers/iio/dac/ad5380.c
> index e38860a6a9f3..82e1d9bd773e 100644
> --- a/drivers/iio/dac/ad5380.c
> +++ b/drivers/iio/dac/ad5380.c
> @@ -488,11 +488,9 @@ static int ad5380_spi_probe(struct spi_device *spi)
>  	return ad5380_probe(&spi->dev, regmap, id->driver_data, id->name);
>  }
>  
> -static int ad5380_spi_remove(struct spi_device *spi)
> +static void ad5380_spi_remove(struct spi_device *spi)
>  {
>  	ad5380_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5380_spi_ids[] = {
> diff --git a/drivers/iio/dac/ad5446.c b/drivers/iio/dac/ad5446.c
> index 1c9b54c012a7..14cfabacbea5 100644
> --- a/drivers/iio/dac/ad5446.c
> +++ b/drivers/iio/dac/ad5446.c
> @@ -491,11 +491,9 @@ static int ad5446_spi_probe(struct spi_device *spi)
>  		&ad5446_spi_chip_info[id->driver_data]);
>  }
>  
> -static int ad5446_spi_remove(struct spi_device *spi)
> +static void ad5446_spi_remove(struct spi_device *spi)
>  {
>  	ad5446_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver ad5446_spi_driver = {
> diff --git a/drivers/iio/dac/ad5449.c b/drivers/iio/dac/ad5449.c
> index f5e93c6acc9d..bad9bdaafa94 100644
> --- a/drivers/iio/dac/ad5449.c
> +++ b/drivers/iio/dac/ad5449.c
> @@ -330,7 +330,7 @@ static int ad5449_spi_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad5449_spi_remove(struct spi_device *spi)
> +static void ad5449_spi_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad5449 *st = iio_priv(indio_dev);
> @@ -338,8 +338,6 @@ static int ad5449_spi_remove(struct spi_device *spi)
>  	iio_device_unregister(indio_dev);
>  
>  	regulator_bulk_disable(st->chip_info->num_channels, st->vref_reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5449_spi_ids[] = {
> diff --git a/drivers/iio/dac/ad5504.c b/drivers/iio/dac/ad5504.c
> index b631261efa97..8507573aa13e 100644
> --- a/drivers/iio/dac/ad5504.c
> +++ b/drivers/iio/dac/ad5504.c
> @@ -336,7 +336,7 @@ static int ad5504_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad5504_remove(struct spi_device *spi)
> +static void ad5504_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad5504_state *st = iio_priv(indio_dev);
> @@ -345,8 +345,6 @@ static int ad5504_remove(struct spi_device *spi)
>  
>  	if (!IS_ERR(st->reg))
>  		regulator_disable(st->reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5504_id[] = {
> diff --git a/drivers/iio/dac/ad5592r.c b/drivers/iio/dac/ad5592r.c
> index 6bfd7951e18c..0f7abfa75bec 100644
> --- a/drivers/iio/dac/ad5592r.c
> +++ b/drivers/iio/dac/ad5592r.c
> @@ -130,11 +130,9 @@ static int ad5592r_spi_probe(struct spi_device *spi)
>  	return ad5592r_probe(&spi->dev, id->name, &ad5592r_rw_ops);
>  }
>  
> -static int ad5592r_spi_remove(struct spi_device *spi)
> +static void ad5592r_spi_remove(struct spi_device *spi)
>  {
>  	ad5592r_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5592r_spi_ids[] = {
> diff --git a/drivers/iio/dac/ad5624r_spi.c b/drivers/iio/dac/ad5624r_spi.c
> index 3c98941b9f99..371e812850eb 100644
> --- a/drivers/iio/dac/ad5624r_spi.c
> +++ b/drivers/iio/dac/ad5624r_spi.c
> @@ -293,7 +293,7 @@ static int ad5624r_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad5624r_remove(struct spi_device *spi)
> +static void ad5624r_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad5624r_state *st = iio_priv(indio_dev);
> @@ -301,8 +301,6 @@ static int ad5624r_remove(struct spi_device *spi)
>  	iio_device_unregister(indio_dev);
>  	if (!IS_ERR(st->reg))
>  		regulator_disable(st->reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5624r_id[] = {
> diff --git a/drivers/iio/dac/ad5686-spi.c b/drivers/iio/dac/ad5686-spi.c
> index 2628810fdbb1..d26fb29b6b04 100644
> --- a/drivers/iio/dac/ad5686-spi.c
> +++ b/drivers/iio/dac/ad5686-spi.c
> @@ -95,11 +95,9 @@ static int ad5686_spi_probe(struct spi_device *spi)
>  			    ad5686_spi_write, ad5686_spi_read);
>  }
>  
> -static int ad5686_spi_remove(struct spi_device *spi)
> +static void ad5686_spi_remove(struct spi_device *spi)
>  {
>  	ad5686_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5686_spi_id[] = {
> diff --git a/drivers/iio/dac/ad5761.c b/drivers/iio/dac/ad5761.c
> index e37e095e94fc..4cb8471db81e 100644
> --- a/drivers/iio/dac/ad5761.c
> +++ b/drivers/iio/dac/ad5761.c
> @@ -394,7 +394,7 @@ static int ad5761_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad5761_remove(struct spi_device *spi)
> +static void ad5761_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *iio_dev = spi_get_drvdata(spi);
>  	struct ad5761_state *st = iio_priv(iio_dev);
> @@ -403,8 +403,6 @@ static int ad5761_remove(struct spi_device *spi)
>  
>  	if (!IS_ERR_OR_NULL(st->vref_reg))
>  		regulator_disable(st->vref_reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5761_id[] = {
> diff --git a/drivers/iio/dac/ad5764.c b/drivers/iio/dac/ad5764.c
> index ae089b9145cb..d235a8047ba0 100644
> --- a/drivers/iio/dac/ad5764.c
> +++ b/drivers/iio/dac/ad5764.c
> @@ -332,7 +332,7 @@ static int ad5764_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad5764_remove(struct spi_device *spi)
> +static void ad5764_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad5764_state *st = iio_priv(indio_dev);
> @@ -341,8 +341,6 @@ static int ad5764_remove(struct spi_device *spi)
>  
>  	if (st->chip_info->int_vref == 0)
>  		regulator_bulk_disable(ARRAY_SIZE(st->vref_reg), st->vref_reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5764_ids[] = {
> diff --git a/drivers/iio/dac/ad5791.c b/drivers/iio/dac/ad5791.c
> index 7b4579d73d18..2b14914b4050 100644
> --- a/drivers/iio/dac/ad5791.c
> +++ b/drivers/iio/dac/ad5791.c
> @@ -428,7 +428,7 @@ static int ad5791_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad5791_remove(struct spi_device *spi)
> +static void ad5791_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad5791_state *st = iio_priv(indio_dev);
> @@ -439,8 +439,6 @@ static int ad5791_remove(struct spi_device *spi)
>  
>  	if (!IS_ERR(st->reg_vss))
>  		regulator_disable(st->reg_vss);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad5791_id[] = {
> diff --git a/drivers/iio/dac/ad8801.c b/drivers/iio/dac/ad8801.c
> index 5ecfdad54dec..6be35c92d435 100644
> --- a/drivers/iio/dac/ad8801.c
> +++ b/drivers/iio/dac/ad8801.c
> @@ -193,7 +193,7 @@ static int ad8801_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ad8801_remove(struct spi_device *spi)
> +static void ad8801_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ad8801_state *state = iio_priv(indio_dev);
> @@ -202,8 +202,6 @@ static int ad8801_remove(struct spi_device *spi)
>  	if (state->vrefl_reg)
>  		regulator_disable(state->vrefl_reg);
>  	regulator_disable(state->vrefh_reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad8801_ids[] = {
> diff --git a/drivers/iio/dac/ltc1660.c b/drivers/iio/dac/ltc1660.c
> index f6ec9bf5815e..c76233c9bb72 100644
> --- a/drivers/iio/dac/ltc1660.c
> +++ b/drivers/iio/dac/ltc1660.c
> @@ -206,15 +206,13 @@ static int ltc1660_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ltc1660_remove(struct spi_device *spi)
> +static void ltc1660_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ltc1660_priv *priv = iio_priv(indio_dev);
>  
>  	iio_device_unregister(indio_dev);
>  	regulator_disable(priv->vref_reg);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id ltc1660_dt_ids[] = {
> diff --git a/drivers/iio/dac/ltc2632.c b/drivers/iio/dac/ltc2632.c
> index 53e4b887d372..aed46c80757e 100644
> --- a/drivers/iio/dac/ltc2632.c
> +++ b/drivers/iio/dac/ltc2632.c
> @@ -372,7 +372,7 @@ static int ltc2632_probe(struct spi_device *spi)
>  	return iio_device_register(indio_dev);
>  }
>  
> -static int ltc2632_remove(struct spi_device *spi)
> +static void ltc2632_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ltc2632_state *st = iio_priv(indio_dev);
> @@ -381,8 +381,6 @@ static int ltc2632_remove(struct spi_device *spi)
>  
>  	if (st->vref_reg)
>  		regulator_disable(st->vref_reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id ltc2632_id[] = {
> diff --git a/drivers/iio/dac/mcp4922.c b/drivers/iio/dac/mcp4922.c
> index 0ae414ee1716..cb9e60e71b91 100644
> --- a/drivers/iio/dac/mcp4922.c
> +++ b/drivers/iio/dac/mcp4922.c
> @@ -172,7 +172,7 @@ static int mcp4922_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int mcp4922_remove(struct spi_device *spi)
> +static void mcp4922_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct mcp4922_state *state;
> @@ -180,8 +180,6 @@ static int mcp4922_remove(struct spi_device *spi)
>  	iio_device_unregister(indio_dev);
>  	state = iio_priv(indio_dev);
>  	regulator_disable(state->vref_reg);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id mcp4922_id[] = {
> diff --git a/drivers/iio/dac/ti-dac082s085.c b/drivers/iio/dac/ti-dac082s085.c
> index 6beda2193683..4e1156e6deb2 100644
> --- a/drivers/iio/dac/ti-dac082s085.c
> +++ b/drivers/iio/dac/ti-dac082s085.c
> @@ -313,7 +313,7 @@ static int ti_dac_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ti_dac_remove(struct spi_device *spi)
> +static void ti_dac_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ti_dac_chip *ti_dac = iio_priv(indio_dev);
> @@ -321,8 +321,6 @@ static int ti_dac_remove(struct spi_device *spi)
>  	iio_device_unregister(indio_dev);
>  	mutex_destroy(&ti_dac->lock);
>  	regulator_disable(ti_dac->vref);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id ti_dac_of_id[] = {
> diff --git a/drivers/iio/dac/ti-dac7311.c b/drivers/iio/dac/ti-dac7311.c
> index 99f275829ec2..e10d17e60ed3 100644
> --- a/drivers/iio/dac/ti-dac7311.c
> +++ b/drivers/iio/dac/ti-dac7311.c
> @@ -292,7 +292,7 @@ static int ti_dac_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ti_dac_remove(struct spi_device *spi)
> +static void ti_dac_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct ti_dac_chip *ti_dac = iio_priv(indio_dev);
> @@ -300,7 +300,6 @@ static int ti_dac_remove(struct spi_device *spi)
>  	iio_device_unregister(indio_dev);
>  	mutex_destroy(&ti_dac->lock);
>  	regulator_disable(ti_dac->vref);
> -	return 0;
>  }
>  
>  static const struct of_device_id ti_dac_of_id[] = {
> diff --git a/drivers/iio/frequency/adf4350.c b/drivers/iio/frequency/adf4350.c
> index 3d9eba716b69..f3521330f6fb 100644
> --- a/drivers/iio/frequency/adf4350.c
> +++ b/drivers/iio/frequency/adf4350.c
> @@ -589,7 +589,7 @@ static int adf4350_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int adf4350_remove(struct spi_device *spi)
> +static void adf4350_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct adf4350_state *st = iio_priv(indio_dev);
> @@ -604,8 +604,6 @@ static int adf4350_remove(struct spi_device *spi)
>  
>  	if (!IS_ERR(reg))
>  		regulator_disable(reg);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id adf4350_of_match[] = {
> diff --git a/drivers/iio/gyro/bmg160_spi.c b/drivers/iio/gyro/bmg160_spi.c
> index 745962e1e423..fc2e453527b9 100644
> --- a/drivers/iio/gyro/bmg160_spi.c
> +++ b/drivers/iio/gyro/bmg160_spi.c
> @@ -27,11 +27,9 @@ static int bmg160_spi_probe(struct spi_device *spi)
>  	return bmg160_core_probe(&spi->dev, regmap, spi->irq, id->name);
>  }
>  
> -static int bmg160_spi_remove(struct spi_device *spi)
> +static void bmg160_spi_remove(struct spi_device *spi)
>  {
>  	bmg160_core_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id bmg160_spi_id[] = {
> diff --git a/drivers/iio/gyro/fxas21002c_spi.c b/drivers/iio/gyro/fxas21002c_spi.c
> index 77ceebef4e34..c3ac169facf9 100644
> --- a/drivers/iio/gyro/fxas21002c_spi.c
> +++ b/drivers/iio/gyro/fxas21002c_spi.c
> @@ -34,11 +34,9 @@ static int fxas21002c_spi_probe(struct spi_device *spi)
>  	return fxas21002c_core_probe(&spi->dev, regmap, spi->irq, id->name);
>  }
>  
> -static int fxas21002c_spi_remove(struct spi_device *spi)
> +static void fxas21002c_spi_remove(struct spi_device *spi)
>  {
>  	fxas21002c_core_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id fxas21002c_spi_id[] = {
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> index 273f16dcaff8..856ec901b091 100644
> --- a/drivers/iio/health/afe4403.c
> +++ b/drivers/iio/health/afe4403.c
> @@ -570,7 +570,7 @@ static int afe4403_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int afe4403_remove(struct spi_device *spi)
> +static void afe4403_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	struct afe4403_data *afe = iio_priv(indio_dev);
> @@ -586,8 +586,6 @@ static int afe4403_remove(struct spi_device *spi)
>  	ret = regulator_disable(afe->regulator);
>  	if (ret)
>  		dev_warn(afe->dev, "Unable to disable regulator\n");
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id afe4403_ids[] = {
> diff --git a/drivers/iio/magnetometer/bmc150_magn_spi.c b/drivers/iio/magnetometer/bmc150_magn_spi.c
> index c6ed3ea8460a..4c570412d65c 100644
> --- a/drivers/iio/magnetometer/bmc150_magn_spi.c
> +++ b/drivers/iio/magnetometer/bmc150_magn_spi.c
> @@ -29,11 +29,9 @@ static int bmc150_magn_spi_probe(struct spi_device *spi)
>  	return bmc150_magn_probe(&spi->dev, regmap, spi->irq, id->name);
>  }
>  
> -static int bmc150_magn_spi_remove(struct spi_device *spi)
> +static void bmc150_magn_spi_remove(struct spi_device *spi)
>  {
>  	bmc150_magn_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id bmc150_magn_spi_id[] = {
> diff --git a/drivers/iio/magnetometer/hmc5843_spi.c b/drivers/iio/magnetometer/hmc5843_spi.c
> index 89cf59a62c28..a99dd9b33e95 100644
> --- a/drivers/iio/magnetometer/hmc5843_spi.c
> +++ b/drivers/iio/magnetometer/hmc5843_spi.c
> @@ -74,11 +74,9 @@ static int hmc5843_spi_probe(struct spi_device *spi)
>  			id->driver_data, id->name);
>  }
>  
> -static int hmc5843_spi_remove(struct spi_device *spi)
> +static void hmc5843_spi_remove(struct spi_device *spi)
>  {
>  	hmc5843_common_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id hmc5843_id[] = {
> diff --git a/drivers/iio/potentiometer/max5487.c b/drivers/iio/potentiometer/max5487.c
> index 007c2bd324cb..42723c996c9f 100644
> --- a/drivers/iio/potentiometer/max5487.c
> +++ b/drivers/iio/potentiometer/max5487.c
> @@ -112,7 +112,7 @@ static int max5487_spi_probe(struct spi_device *spi)
>  	return iio_device_register(indio_dev);
>  }
>  
> -static int max5487_spi_remove(struct spi_device *spi)
> +static void max5487_spi_remove(struct spi_device *spi)
>  {
>  	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>  	int ret;
> @@ -123,8 +123,6 @@ static int max5487_spi_remove(struct spi_device *spi)
>  	ret = max5487_write_cmd(spi, MAX5487_COPY_AB_TO_NV);
>  	if (ret)
>  		dev_warn(&spi->dev, "Failed to save wiper regs to NV regs\n");
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id max5487_id[] = {
> diff --git a/drivers/iio/pressure/ms5611_spi.c b/drivers/iio/pressure/ms5611_spi.c
> index 9fa2dcd71760..7ccd960ced5d 100644
> --- a/drivers/iio/pressure/ms5611_spi.c
> +++ b/drivers/iio/pressure/ms5611_spi.c
> @@ -107,11 +107,9 @@ static int ms5611_spi_probe(struct spi_device *spi)
>  			    spi_get_device_id(spi)->driver_data);
>  }
>  
> -static int ms5611_spi_remove(struct spi_device *spi)
> +static void ms5611_spi_remove(struct spi_device *spi)
>  {
>  	ms5611_remove(spi_get_drvdata(spi));
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id ms5611_spi_matches[] = {
> diff --git a/drivers/iio/pressure/zpa2326_spi.c b/drivers/iio/pressure/zpa2326_spi.c
> index 85201a4bae44..ee8ed77536ca 100644
> --- a/drivers/iio/pressure/zpa2326_spi.c
> +++ b/drivers/iio/pressure/zpa2326_spi.c
> @@ -57,11 +57,9 @@ static int zpa2326_probe_spi(struct spi_device *spi)
>  			     spi->irq, ZPA2326_DEVICE_ID, regmap);
>  }
>  
> -static int zpa2326_remove_spi(struct spi_device *spi)
> +static void zpa2326_remove_spi(struct spi_device *spi)
>  {
>  	zpa2326_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id zpa2326_spi_ids[] = {
> diff --git a/drivers/input/keyboard/applespi.c b/drivers/input/keyboard/applespi.c
> index eda1b23002b5..d1f5354d5ea2 100644
> --- a/drivers/input/keyboard/applespi.c
> +++ b/drivers/input/keyboard/applespi.c
> @@ -1858,7 +1858,7 @@ static void applespi_drain_reads(struct applespi_data *applespi)
>  	spin_unlock_irqrestore(&applespi->cmd_msg_lock, flags);
>  }
>  
> -static int applespi_remove(struct spi_device *spi)
> +static void applespi_remove(struct spi_device *spi)
>  {
>  	struct applespi_data *applespi = spi_get_drvdata(spi);
>  
> @@ -1871,8 +1871,6 @@ static int applespi_remove(struct spi_device *spi)
>  	applespi_drain_reads(applespi);
>  
>  	debugfs_remove_recursive(applespi->debugfs_root);
> -
> -	return 0;
>  }
>  
>  static void applespi_shutdown(struct spi_device *spi)
> diff --git a/drivers/input/misc/adxl34x-spi.c b/drivers/input/misc/adxl34x-spi.c
> index 6e51c9bc619f..91e44d4c66f7 100644
> --- a/drivers/input/misc/adxl34x-spi.c
> +++ b/drivers/input/misc/adxl34x-spi.c
> @@ -87,13 +87,11 @@ static int adxl34x_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int adxl34x_spi_remove(struct spi_device *spi)
> +static void adxl34x_spi_remove(struct spi_device *spi)
>  {
>  	struct adxl34x *ac = spi_get_drvdata(spi);
>  
>  	adxl34x_remove(ac);
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused adxl34x_spi_suspend(struct device *dev)
> diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
> index a25a77dd9a32..bed68a68f330 100644
> --- a/drivers/input/touchscreen/ads7846.c
> +++ b/drivers/input/touchscreen/ads7846.c
> @@ -1411,13 +1411,11 @@ static int ads7846_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ads7846_remove(struct spi_device *spi)
> +static void ads7846_remove(struct spi_device *spi)
>  {
>  	struct ads7846 *ts = spi_get_drvdata(spi);
>  
>  	ads7846_stop(ts);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver ads7846_driver = {
> diff --git a/drivers/input/touchscreen/cyttsp4_spi.c b/drivers/input/touchscreen/cyttsp4_spi.c
> index 2aec41eb76b7..5d7db84f2749 100644
> --- a/drivers/input/touchscreen/cyttsp4_spi.c
> +++ b/drivers/input/touchscreen/cyttsp4_spi.c
> @@ -164,12 +164,10 @@ static int cyttsp4_spi_probe(struct spi_device *spi)
>  	return PTR_ERR_OR_ZERO(ts);
>  }
>  
> -static int cyttsp4_spi_remove(struct spi_device *spi)
> +static void cyttsp4_spi_remove(struct spi_device *spi)
>  {
>  	struct cyttsp4 *ts = spi_get_drvdata(spi);
>  	cyttsp4_remove(ts);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver cyttsp4_spi_driver = {
> diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
> index a2f55920b9b2..555dfe98b3c4 100644
> --- a/drivers/input/touchscreen/tsc2005.c
> +++ b/drivers/input/touchscreen/tsc2005.c
> @@ -64,11 +64,9 @@ static int tsc2005_probe(struct spi_device *spi)
>  			     tsc2005_cmd);
>  }
>  
> -static int tsc2005_remove(struct spi_device *spi)
> +static void tsc2005_remove(struct spi_device *spi)
>  {
>  	tsc200x_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_OF
> diff --git a/drivers/leds/leds-cr0014114.c b/drivers/leds/leds-cr0014114.c
> index d03cfd3c0bfb..c87686bd7c18 100644
> --- a/drivers/leds/leds-cr0014114.c
> +++ b/drivers/leds/leds-cr0014114.c
> @@ -266,14 +266,12 @@ static int cr0014114_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int cr0014114_remove(struct spi_device *spi)
> +static void cr0014114_remove(struct spi_device *spi)
>  {
>  	struct cr0014114 *priv = spi_get_drvdata(spi);
>  
>  	cancel_delayed_work_sync(&priv->work);
>  	mutex_destroy(&priv->lock);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id cr0014114_dt_ids[] = {
> diff --git a/drivers/leds/leds-dac124s085.c b/drivers/leds/leds-dac124s085.c
> index 20dc9b9d7dea..cf5fb1195f87 100644
> --- a/drivers/leds/leds-dac124s085.c
> +++ b/drivers/leds/leds-dac124s085.c
> @@ -85,15 +85,13 @@ static int dac124s085_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int dac124s085_remove(struct spi_device *spi)
> +static void dac124s085_remove(struct spi_device *spi)
>  {
>  	struct dac124s085	*dac = spi_get_drvdata(spi);
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(dac->leds); i++)
>  		led_classdev_unregister(&dac->leds[i].ldev);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver dac124s085_driver = {
> diff --git a/drivers/leds/leds-el15203000.c b/drivers/leds/leds-el15203000.c
> index f9eb59a25570..7e7b617bcd56 100644
> --- a/drivers/leds/leds-el15203000.c
> +++ b/drivers/leds/leds-el15203000.c
> @@ -315,13 +315,11 @@ static int el15203000_probe(struct spi_device *spi)
>  	return el15203000_probe_dt(priv);
>  }
>  
> -static int el15203000_remove(struct spi_device *spi)
> +static void el15203000_remove(struct spi_device *spi)
>  {
>  	struct el15203000 *priv = spi_get_drvdata(spi);
>  
>  	mutex_destroy(&priv->lock);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id el15203000_dt_ids[] = {
> diff --git a/drivers/leds/leds-spi-byte.c b/drivers/leds/leds-spi-byte.c
> index f1964c96fb15..2bc5c99daf51 100644
> --- a/drivers/leds/leds-spi-byte.c
> +++ b/drivers/leds/leds-spi-byte.c
> @@ -130,13 +130,11 @@ static int spi_byte_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int spi_byte_remove(struct spi_device *spi)
> +static void spi_byte_remove(struct spi_device *spi)
>  {
>  	struct spi_byte_led	*led = spi_get_drvdata(spi);
>  
>  	mutex_destroy(&led->mutex);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver spi_byte_driver = {
> diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
> index 6f2a66bc87fb..6be4e5528879 100644
> --- a/drivers/media/spi/cxd2880-spi.c
> +++ b/drivers/media/spi/cxd2880-spi.c
> @@ -625,7 +625,7 @@ cxd2880_spi_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int
> +static void
>  cxd2880_spi_remove(struct spi_device *spi)
>  {
>  	struct cxd2880_dvb_spi *dvb_spi = spi_get_drvdata(spi);
> @@ -643,8 +643,6 @@ cxd2880_spi_remove(struct spi_device *spi)
>  
>  	kfree(dvb_spi);
>  	pr_info("cxd2880_spi remove ok.\n");
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id cxd2880_spi_id[] = {
> diff --git a/drivers/media/spi/gs1662.c b/drivers/media/spi/gs1662.c
> index f86ef1ca1288..75c21a93e6d0 100644
> --- a/drivers/media/spi/gs1662.c
> +++ b/drivers/media/spi/gs1662.c
> @@ -458,13 +458,11 @@ static int gs_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int gs_remove(struct spi_device *spi)
> +static void gs_remove(struct spi_device *spi)
>  {
>  	struct v4l2_subdev *sd = spi_get_drvdata(spi);
>  
>  	v4l2_device_unregister_subdev(sd);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver gs_driver = {
> diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
> index 44247049a319..ad6c72c1ed04 100644
> --- a/drivers/media/tuners/msi001.c
> +++ b/drivers/media/tuners/msi001.c
> @@ -472,7 +472,7 @@ static int msi001_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int msi001_remove(struct spi_device *spi)
> +static void msi001_remove(struct spi_device *spi)
>  {
>  	struct v4l2_subdev *sd = spi_get_drvdata(spi);
>  	struct msi001_dev *dev = sd_to_msi001_dev(sd);
> @@ -486,7 +486,6 @@ static int msi001_remove(struct spi_device *spi)
>  	v4l2_device_unregister_subdev(&dev->sd);
>  	v4l2_ctrl_handler_free(&dev->hdl);
>  	kfree(dev);
> -	return 0;
>  }
>  
>  static const struct spi_device_id msi001_id_table[] = {
> diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
> index 9fe06dda3782..03620c8efe34 100644
> --- a/drivers/mfd/arizona-spi.c
> +++ b/drivers/mfd/arizona-spi.c
> @@ -206,13 +206,11 @@ static int arizona_spi_probe(struct spi_device *spi)
>  	return arizona_dev_init(arizona);
>  }
>  
> -static int arizona_spi_remove(struct spi_device *spi)
> +static void arizona_spi_remove(struct spi_device *spi)
>  {
>  	struct arizona *arizona = spi_get_drvdata(spi);
>  
>  	arizona_dev_exit(arizona);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id arizona_spi_ids[] = {
> diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
> index 5faf3766a5e2..b79a57b45c1e 100644
> --- a/drivers/mfd/da9052-spi.c
> +++ b/drivers/mfd/da9052-spi.c
> @@ -55,12 +55,11 @@ static int da9052_spi_probe(struct spi_device *spi)
>  	return da9052_device_init(da9052, id->driver_data);
>  }
>  
> -static int da9052_spi_remove(struct spi_device *spi)
> +static void da9052_spi_remove(struct spi_device *spi)
>  {
>  	struct da9052 *da9052 = spi_get_drvdata(spi);
>  
>  	da9052_device_exit(da9052);
> -	return 0;
>  }
>  
>  static const struct spi_device_id da9052_spi_id[] = {
> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> index 70fa18b04ad2..2280f756f422 100644
> --- a/drivers/mfd/ezx-pcap.c
> +++ b/drivers/mfd/ezx-pcap.c
> @@ -392,7 +392,7 @@ static int pcap_add_subdev(struct pcap_chip *pcap,
>  	return ret;
>  }
>  
> -static int ezx_pcap_remove(struct spi_device *spi)
> +static void ezx_pcap_remove(struct spi_device *spi)
>  {
>  	struct pcap_chip *pcap = spi_get_drvdata(spi);
>  	unsigned long flags;
> @@ -412,8 +412,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
>  		irq_set_chip_and_handler(i, NULL, NULL);
>  
>  	destroy_workqueue(pcap->workqueue);
> -
> -	return 0;
>  }
>  
>  static int ezx_pcap_probe(struct spi_device *spi)
> diff --git a/drivers/mfd/madera-spi.c b/drivers/mfd/madera-spi.c
> index e860f5ff0933..da84eb50e53a 100644
> --- a/drivers/mfd/madera-spi.c
> +++ b/drivers/mfd/madera-spi.c
> @@ -112,13 +112,11 @@ static int madera_spi_probe(struct spi_device *spi)
>  	return madera_dev_init(madera);
>  }
>  
> -static int madera_spi_remove(struct spi_device *spi)
> +static void madera_spi_remove(struct spi_device *spi)
>  {
>  	struct madera *madera = spi_get_drvdata(spi);
>  
>  	madera_dev_exit(madera);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id madera_spi_ids[] = {
> diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
> index 4d8913d647e6..f803527e5819 100644
> --- a/drivers/mfd/mc13xxx-spi.c
> +++ b/drivers/mfd/mc13xxx-spi.c
> @@ -166,10 +166,9 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
>  	return mc13xxx_common_init(&spi->dev);
>  }
>  
> -static int mc13xxx_spi_remove(struct spi_device *spi)
> +static void mc13xxx_spi_remove(struct spi_device *spi)
>  {
>  	mc13xxx_common_exit(&spi->dev);
> -	return 0;
>  }
>  
>  static struct spi_driver mc13xxx_spi_driver = {
> diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
> index fec2b4ec477c..d2f3d8f1e05a 100644
> --- a/drivers/mfd/rsmu_spi.c
> +++ b/drivers/mfd/rsmu_spi.c
> @@ -220,13 +220,11 @@ static int rsmu_spi_probe(struct spi_device *client)
>  	return rsmu_core_init(rsmu);
>  }
>  
> -static int rsmu_spi_remove(struct spi_device *client)
> +static void rsmu_spi_remove(struct spi_device *client)
>  {
>  	struct rsmu_ddata *rsmu = spi_get_drvdata(client);
>  
>  	rsmu_core_exit(rsmu);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id rsmu_spi_id[] = {
> diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
> index 6c5915016be5..ad8055a0e286 100644
> --- a/drivers/mfd/stmpe-spi.c
> +++ b/drivers/mfd/stmpe-spi.c
> @@ -102,13 +102,11 @@ stmpe_spi_probe(struct spi_device *spi)
>  	return stmpe_probe(&spi_ci, id->driver_data);
>  }
>  
> -static int stmpe_spi_remove(struct spi_device *spi)
> +static void stmpe_spi_remove(struct spi_device *spi)
>  {
>  	struct stmpe *stmpe = spi_get_drvdata(spi);
>  
>  	stmpe_remove(stmpe);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id stmpe_spi_of_match[] = {
> diff --git a/drivers/mfd/tps65912-spi.c b/drivers/mfd/tps65912-spi.c
> index d701926aa46e..bba38fbc781d 100644
> --- a/drivers/mfd/tps65912-spi.c
> +++ b/drivers/mfd/tps65912-spi.c
> @@ -50,13 +50,11 @@ static int tps65912_spi_probe(struct spi_device *spi)
>  	return tps65912_device_init(tps);
>  }
>  
> -static int tps65912_spi_remove(struct spi_device *spi)
> +static void tps65912_spi_remove(struct spi_device *spi)
>  {
>  	struct tps65912 *tps = spi_get_drvdata(spi);
>  
>  	tps65912_device_exit(tps);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id tps65912_spi_id_table[] = {
> diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
> index a9e75d80ad36..263055bda48b 100644
> --- a/drivers/misc/ad525x_dpot-spi.c
> +++ b/drivers/misc/ad525x_dpot-spi.c
> @@ -90,10 +90,9 @@ static int ad_dpot_spi_probe(struct spi_device *spi)
>  			     spi_get_device_id(spi)->name);
>  }
>  
> -static int ad_dpot_spi_remove(struct spi_device *spi)
> +static void ad_dpot_spi_remove(struct spi_device *spi)
>  {
>  	ad_dpot_remove(&spi->dev);
> -	return 0;
>  }
>  
>  static const struct spi_device_id ad_dpot_spi_id[] = {
> diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
> index 1f15399e5cb4..b630625b3024 100644
> --- a/drivers/misc/eeprom/eeprom_93xx46.c
> +++ b/drivers/misc/eeprom/eeprom_93xx46.c
> @@ -555,14 +555,12 @@ static int eeprom_93xx46_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int eeprom_93xx46_remove(struct spi_device *spi)
> +static void eeprom_93xx46_remove(struct spi_device *spi)
>  {
>  	struct eeprom_93xx46_dev *edev = spi_get_drvdata(spi);
>  
>  	if (!(edev->pdata->flags & EE_READONLY))
>  		device_remove_file(&spi->dev, &dev_attr_erase);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver eeprom_93xx46_driver = {
> diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
> index 98828030b5a4..bac4df2e5231 100644
> --- a/drivers/misc/lattice-ecp3-config.c
> +++ b/drivers/misc/lattice-ecp3-config.c
> @@ -211,13 +211,11 @@ static int lattice_ecp3_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int lattice_ecp3_remove(struct spi_device *spi)
> +static void lattice_ecp3_remove(struct spi_device *spi)
>  {
>  	struct fpga_data *data = spi_get_drvdata(spi);
>  
>  	wait_for_completion(&data->fw_loaded);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id lattice_ecp3_id[] = {
> diff --git a/drivers/misc/lis3lv02d/lis3lv02d_spi.c b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
> index 9e40dfb60742..203a108b8883 100644
> --- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
> +++ b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
> @@ -96,15 +96,13 @@ static int lis302dl_spi_probe(struct spi_device *spi)
>  	return lis3lv02d_init_device(&lis3_dev);
>  }
>  
> -static int lis302dl_spi_remove(struct spi_device *spi)
> +static void lis302dl_spi_remove(struct spi_device *spi)
>  {
>  	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
>  	lis3lv02d_joystick_disable(lis3);
>  	lis3lv02d_poweroff(lis3);
>  
>  	lis3lv02d_remove_fs(&lis3_dev);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index a576181e9db0..106dd204b1a7 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -1489,7 +1489,7 @@ static int mmc_spi_probe(struct spi_device *spi)
>  }
>  
>  
> -static int mmc_spi_remove(struct spi_device *spi)
> +static void mmc_spi_remove(struct spi_device *spi)
>  {
>  	struct mmc_host		*mmc = dev_get_drvdata(&spi->dev);
>  	struct mmc_spi_host	*host = mmc_priv(mmc);
> @@ -1507,7 +1507,6 @@ static int mmc_spi_remove(struct spi_device *spi)
>  	spi->max_speed_hz = mmc->f_max;
>  	mmc_spi_put_pdata(spi);
>  	mmc_free_host(mmc);
> -	return 0;
>  }
>  
>  static const struct spi_device_id mmc_spi_dev_ids[] = {
> diff --git a/drivers/mtd/devices/mchp23k256.c b/drivers/mtd/devices/mchp23k256.c
> index a8b31bddf14b..008df9d8898d 100644
> --- a/drivers/mtd/devices/mchp23k256.c
> +++ b/drivers/mtd/devices/mchp23k256.c
> @@ -209,13 +209,11 @@ static int mchp23k256_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int mchp23k256_remove(struct spi_device *spi)
> +static void mchp23k256_remove(struct spi_device *spi)
>  {
>  	struct mchp23k256_flash *flash = spi_get_drvdata(spi);
>  
>  	WARN_ON(mtd_device_unregister(&flash->mtd));
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id mchp23k256_of_table[] = {
> diff --git a/drivers/mtd/devices/mchp48l640.c b/drivers/mtd/devices/mchp48l640.c
> index 231a10790196..a3fd426df74b 100644
> --- a/drivers/mtd/devices/mchp48l640.c
> +++ b/drivers/mtd/devices/mchp48l640.c
> @@ -341,13 +341,11 @@ static int mchp48l640_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int mchp48l640_remove(struct spi_device *spi)
> +static void mchp48l640_remove(struct spi_device *spi)
>  {
>  	struct mchp48l640_flash *flash = spi_get_drvdata(spi);
>  
>  	WARN_ON(mtd_device_unregister(&flash->mtd));
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id mchp48l640_of_table[] = {
> diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
> index 734878abaa23..134e27328597 100644
> --- a/drivers/mtd/devices/mtd_dataflash.c
> +++ b/drivers/mtd/devices/mtd_dataflash.c
> @@ -916,7 +916,7 @@ static int dataflash_probe(struct spi_device *spi)
>  	return status;
>  }
>  
> -static int dataflash_remove(struct spi_device *spi)
> +static void dataflash_remove(struct spi_device *spi)
>  {
>  	struct dataflash	*flash = spi_get_drvdata(spi);
>  
> @@ -925,8 +925,6 @@ static int dataflash_remove(struct spi_device *spi)
>  	WARN_ON(mtd_device_unregister(&flash->mtd));
>  
>  	kfree(flash);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver dataflash_driver = {
> diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
> index 7f124c1bfa40..8813994ce9f4 100644
> --- a/drivers/mtd/devices/sst25l.c
> +++ b/drivers/mtd/devices/sst25l.c
> @@ -398,13 +398,11 @@ static int sst25l_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int sst25l_remove(struct spi_device *spi)
> +static void sst25l_remove(struct spi_device *spi)
>  {
>  	struct sst25l_flash *flash = spi_get_drvdata(spi);
>  
>  	WARN_ON(mtd_device_unregister(&flash->mtd));
> -
> -	return 0;
>  }
>  
>  static struct spi_driver sst25l_driver = {
> diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
> index 04687b15b250..41645a24384c 100644
> --- a/drivers/net/can/m_can/tcan4x5x-core.c
> +++ b/drivers/net/can/m_can/tcan4x5x-core.c
> @@ -388,7 +388,7 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int tcan4x5x_can_remove(struct spi_device *spi)
> +static void tcan4x5x_can_remove(struct spi_device *spi)
>  {
>  	struct tcan4x5x_priv *priv = spi_get_drvdata(spi);
>  
> @@ -397,8 +397,6 @@ static int tcan4x5x_can_remove(struct spi_device *spi)
>  	tcan4x5x_power_enable(priv->power, 0);
>  
>  	m_can_class_free_dev(priv->cdev.net);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id tcan4x5x_of_match[] = {
> diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
> index cfcc14fe3e42..664b8f14d7b0 100644
> --- a/drivers/net/can/spi/hi311x.c
> +++ b/drivers/net/can/spi/hi311x.c
> @@ -948,7 +948,7 @@ static int hi3110_can_probe(struct spi_device *spi)
>  	return dev_err_probe(dev, ret, "Probe failed\n");
>  }
>  
> -static int hi3110_can_remove(struct spi_device *spi)
> +static void hi3110_can_remove(struct spi_device *spi)
>  {
>  	struct hi3110_priv *priv = spi_get_drvdata(spi);
>  	struct net_device *net = priv->net;
> @@ -960,8 +960,6 @@ static int hi3110_can_remove(struct spi_device *spi)
>  	clk_disable_unprepare(priv->clk);
>  
>  	free_candev(net);
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused hi3110_can_suspend(struct device *dev)
> diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
> index 025e07cb7439..d23edaf22420 100644
> --- a/drivers/net/can/spi/mcp251x.c
> +++ b/drivers/net/can/spi/mcp251x.c
> @@ -1427,7 +1427,7 @@ static int mcp251x_can_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int mcp251x_can_remove(struct spi_device *spi)
> +static void mcp251x_can_remove(struct spi_device *spi)
>  {
>  	struct mcp251x_priv *priv = spi_get_drvdata(spi);
>  	struct net_device *net = priv->net;
> @@ -1442,8 +1442,6 @@ static int mcp251x_can_remove(struct spi_device *spi)
>  	clk_disable_unprepare(priv->clk);
>  
>  	free_candev(net);
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused mcp251x_can_suspend(struct device *dev)
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> index b5986df6eca0..65c9b31666a6 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -1966,7 +1966,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
>  	return err;
>  }
>  
> -static int mcp251xfd_remove(struct spi_device *spi)
> +static void mcp251xfd_remove(struct spi_device *spi)
>  {
>  	struct mcp251xfd_priv *priv = spi_get_drvdata(spi);
>  	struct net_device *ndev = priv->ndev;
> @@ -1975,8 +1975,6 @@ static int mcp251xfd_remove(struct spi_device *spi)
>  	mcp251xfd_unregister(priv);
>  	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
>  	free_candev(ndev);
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused mcp251xfd_runtime_suspend(struct device *device)
> diff --git a/drivers/net/dsa/b53/b53_spi.c b/drivers/net/dsa/b53/b53_spi.c
> index 2b88f03e5252..0e54b2a0c211 100644
> --- a/drivers/net/dsa/b53/b53_spi.c
> +++ b/drivers/net/dsa/b53/b53_spi.c
> @@ -314,7 +314,7 @@ static int b53_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int b53_spi_remove(struct spi_device *spi)
> +static void b53_spi_remove(struct spi_device *spi)
>  {
>  	struct b53_device *dev = spi_get_drvdata(spi);
>  
> @@ -322,8 +322,6 @@ static int b53_spi_remove(struct spi_device *spi)
>  		b53_switch_remove(dev);
>  
>  	spi_set_drvdata(spi, NULL);
> -
> -	return 0;
>  }
>  
>  static void b53_spi_shutdown(struct spi_device *spi)
> diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
> index 866767b70d65..673589dc88ab 100644
> --- a/drivers/net/dsa/microchip/ksz8795_spi.c
> +++ b/drivers/net/dsa/microchip/ksz8795_spi.c
> @@ -87,7 +87,7 @@ static int ksz8795_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ksz8795_spi_remove(struct spi_device *spi)
> +static void ksz8795_spi_remove(struct spi_device *spi)
>  {
>  	struct ksz_device *dev = spi_get_drvdata(spi);
>  
> @@ -95,8 +95,6 @@ static int ksz8795_spi_remove(struct spi_device *spi)
>  		ksz_switch_remove(dev);
>  
>  	spi_set_drvdata(spi, NULL);
> -
> -	return 0;
>  }
>  
>  static void ksz8795_spi_shutdown(struct spi_device *spi)
> diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
> index e3cb0e6c9f6f..940bb9665f15 100644
> --- a/drivers/net/dsa/microchip/ksz9477_spi.c
> +++ b/drivers/net/dsa/microchip/ksz9477_spi.c
> @@ -65,7 +65,7 @@ static int ksz9477_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ksz9477_spi_remove(struct spi_device *spi)
> +static void ksz9477_spi_remove(struct spi_device *spi)
>  {
>  	struct ksz_device *dev = spi_get_drvdata(spi);
>  
> @@ -73,8 +73,6 @@ static int ksz9477_spi_remove(struct spi_device *spi)
>  		ksz_switch_remove(dev);
>  
>  	spi_set_drvdata(spi, NULL);
> -
> -	return 0;
>  }
>  
>  static void ksz9477_spi_shutdown(struct spi_device *spi)
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index b513713be610..c2a47c6693b8 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -3346,18 +3346,16 @@ static int sja1105_probe(struct spi_device *spi)
>  	return dsa_register_switch(priv->ds);
>  }
>  
> -static int sja1105_remove(struct spi_device *spi)
> +static void sja1105_remove(struct spi_device *spi)
>  {
>  	struct sja1105_private *priv = spi_get_drvdata(spi);
>  
>  	if (!priv)
> -		return 0;
> +		return;
>  
>  	dsa_unregister_switch(priv->ds);
>  
>  	spi_set_drvdata(spi, NULL);
> -
> -	return 0;
>  }
>  
>  static void sja1105_shutdown(struct spi_device *spi)
> diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
> index 645398901e05..3110895358d8 100644
> --- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
> +++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
> @@ -159,18 +159,16 @@ static int vsc73xx_spi_probe(struct spi_device *spi)
>  	return vsc73xx_probe(&vsc_spi->vsc);
>  }
>  
> -static int vsc73xx_spi_remove(struct spi_device *spi)
> +static void vsc73xx_spi_remove(struct spi_device *spi)
>  {
>  	struct vsc73xx_spi *vsc_spi = spi_get_drvdata(spi);
>  
>  	if (!vsc_spi)
> -		return 0;
> +		return;
>  
>  	vsc73xx_remove(&vsc_spi->vsc);
>  
>  	spi_set_drvdata(spi, NULL);
> -
> -	return 0;
>  }
>  
>  static void vsc73xx_spi_shutdown(struct spi_device *spi)
> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
> index e7a9f9863258..bf70481bb1ca 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -1102,7 +1102,7 @@ static int ax88796c_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int ax88796c_remove(struct spi_device *spi)
> +static void ax88796c_remove(struct spi_device *spi)
>  {
>  	struct ax88796c_device *ax_local = dev_get_drvdata(&spi->dev);
>  	struct net_device *ndev = ax_local->ndev;
> @@ -1112,8 +1112,6 @@ static int ax88796c_remove(struct spi_device *spi)
>  	netif_info(ax_local, probe, ndev, "removing network device %s %s\n",
>  		   dev_driver_string(&spi->dev),
>  		   dev_name(&spi->dev));
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_OF
> diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
> index 0303e727e99f..d167d93e4c12 100644
> --- a/drivers/net/ethernet/micrel/ks8851_spi.c
> +++ b/drivers/net/ethernet/micrel/ks8851_spi.c
> @@ -452,11 +452,9 @@ static int ks8851_probe_spi(struct spi_device *spi)
>  	return ks8851_probe_common(netdev, dev, msg_enable);
>  }
>  
> -static int ks8851_remove_spi(struct spi_device *spi)
> +static void ks8851_remove_spi(struct spi_device *spi)
>  {
>  	ks8851_remove_common(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id ks8851_match_table[] = {
> diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
> index 634ac7649c43..db5a3edb4c3c 100644
> --- a/drivers/net/ethernet/microchip/enc28j60.c
> +++ b/drivers/net/ethernet/microchip/enc28j60.c
> @@ -1612,15 +1612,13 @@ static int enc28j60_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int enc28j60_remove(struct spi_device *spi)
> +static void enc28j60_remove(struct spi_device *spi)
>  {
>  	struct enc28j60_net *priv = spi_get_drvdata(spi);
>  
>  	unregister_netdev(priv->netdev);
>  	free_irq(spi->irq, priv);
>  	free_netdev(priv->netdev);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id enc28j60_dt_ids[] = {
> diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
> index b90efc80fb59..dc1840cb5b10 100644
> --- a/drivers/net/ethernet/microchip/encx24j600.c
> +++ b/drivers/net/ethernet/microchip/encx24j600.c
> @@ -1093,7 +1093,7 @@ static int encx24j600_spi_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int encx24j600_spi_remove(struct spi_device *spi)
> +static void encx24j600_spi_remove(struct spi_device *spi)
>  {
>  	struct encx24j600_priv *priv = dev_get_drvdata(&spi->dev);
>  
> @@ -1101,8 +1101,6 @@ static int encx24j600_spi_remove(struct spi_device *spi)
>  	kthread_stop(priv->kworker_task);
>  
>  	free_netdev(priv->ndev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id encx24j600_spi_id_table[] = {
> diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
> index 955cce644392..3c5494afd3c0 100644
> --- a/drivers/net/ethernet/qualcomm/qca_spi.c
> +++ b/drivers/net/ethernet/qualcomm/qca_spi.c
> @@ -1001,7 +1001,7 @@ qca_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int
> +static void
>  qca_spi_remove(struct spi_device *spi)
>  {
>  	struct net_device *qcaspi_devs = spi_get_drvdata(spi);
> @@ -1011,8 +1011,6 @@ qca_spi_remove(struct spi_device *spi)
>  
>  	unregister_netdev(qcaspi_devs);
>  	free_netdev(qcaspi_devs);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id qca_spi_id[] = {
> diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
> index 89a31783fbb4..25739b182ac7 100644
> --- a/drivers/net/ethernet/vertexcom/mse102x.c
> +++ b/drivers/net/ethernet/vertexcom/mse102x.c
> @@ -731,7 +731,7 @@ static int mse102x_probe_spi(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int mse102x_remove_spi(struct spi_device *spi)
> +static void mse102x_remove_spi(struct spi_device *spi)
>  {
>  	struct mse102x_net *mse = dev_get_drvdata(&spi->dev);
>  	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
> @@ -741,8 +741,6 @@ static int mse102x_remove_spi(struct spi_device *spi)
>  
>  	mse102x_remove_device_debugfs(mses);
>  	unregister_netdev(mse->ndev);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id mse102x_match_table[] = {
> diff --git a/drivers/net/ethernet/wiznet/w5100-spi.c b/drivers/net/ethernet/wiznet/w5100-spi.c
> index 7779a36da3c8..7c52796273a4 100644
> --- a/drivers/net/ethernet/wiznet/w5100-spi.c
> +++ b/drivers/net/ethernet/wiznet/w5100-spi.c
> @@ -461,11 +461,9 @@ static int w5100_spi_probe(struct spi_device *spi)
>  	return w5100_probe(&spi->dev, ops, priv_size, mac, spi->irq, -EINVAL);
>  }
>  
> -static int w5100_spi_remove(struct spi_device *spi)
> +static void w5100_spi_remove(struct spi_device *spi)
>  {
>  	w5100_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id w5100_spi_ids[] = {
> diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
> index 7db9cbd0f5de..6afdf1622944 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1304,7 +1304,7 @@ static int adf7242_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int adf7242_remove(struct spi_device *spi)
> +static void adf7242_remove(struct spi_device *spi)
>  {
>  	struct adf7242_local *lp = spi_get_drvdata(spi);
>  
> @@ -1316,8 +1316,6 @@ static int adf7242_remove(struct spi_device *spi)
>  	ieee802154_unregister_hw(lp->hw);
>  	mutex_destroy(&lp->bmux);
>  	ieee802154_free_hw(lp->hw);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id adf7242_of_match[] = {
> diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> index 7d67f41387f5..a4734323dc29 100644
> --- a/drivers/net/ieee802154/at86rf230.c
> +++ b/drivers/net/ieee802154/at86rf230.c
> @@ -1759,7 +1759,7 @@ static int at86rf230_probe(struct spi_device *spi)
>  	return rc;
>  }
>  
> -static int at86rf230_remove(struct spi_device *spi)
> +static void at86rf230_remove(struct spi_device *spi)
>  {
>  	struct at86rf230_local *lp = spi_get_drvdata(spi);
>  
> @@ -1769,8 +1769,6 @@ static int at86rf230_remove(struct spi_device *spi)
>  	ieee802154_free_hw(lp->hw);
>  	at86rf230_debugfs_remove();
>  	dev_dbg(&spi->dev, "unregistered at86rf230\n");
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id at86rf230_of_match[] = {
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index ece6ff6049f6..b499bbe4d48f 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -831,7 +831,7 @@ static void ca8210_rx_done(struct cas_control *cas_ctl)
>  finish:;
>  }
>  
> -static int ca8210_remove(struct spi_device *spi_device);
> +static void ca8210_remove(struct spi_device *spi_device);
>  
>  /**
>   * ca8210_spi_transfer_complete() - Called when a single spi transfer has
> @@ -3048,7 +3048,7 @@ static void ca8210_test_interface_clear(struct ca8210_priv *priv)
>   *
>   * Return: 0 or linux error code
>   */
> -static int ca8210_remove(struct spi_device *spi_device)
> +static void ca8210_remove(struct spi_device *spi_device)
>  {
>  	struct ca8210_priv *priv;
>  	struct ca8210_platform_data *pdata;
> @@ -3088,8 +3088,6 @@ static int ca8210_remove(struct spi_device *spi_device)
>  		if (IS_ENABLED(CONFIG_IEEE802154_CA8210_DEBUGFS))
>  			ca8210_test_interface_clear(priv);
>  	}
> -
> -	return 0;
>  }
>  
>  /**
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index 89c046b204e0..1e1f40f628a0 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -1213,7 +1213,7 @@ static int cc2520_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int cc2520_remove(struct spi_device *spi)
> +static void cc2520_remove(struct spi_device *spi)
>  {
>  	struct cc2520_private *priv = spi_get_drvdata(spi);
>  
> @@ -1222,8 +1222,6 @@ static int cc2520_remove(struct spi_device *spi)
>  
>  	ieee802154_unregister_hw(priv->hw);
>  	ieee802154_free_hw(priv->hw);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id cc2520_ids[] = {
> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> index 8dc04e2590b1..a3af52a8e6dd 100644
> --- a/drivers/net/ieee802154/mcr20a.c
> +++ b/drivers/net/ieee802154/mcr20a.c
> @@ -1335,7 +1335,7 @@ mcr20a_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int mcr20a_remove(struct spi_device *spi)
> +static void mcr20a_remove(struct spi_device *spi)
>  {
>  	struct mcr20a_local *lp = spi_get_drvdata(spi);
>  
> @@ -1343,8 +1343,6 @@ static int mcr20a_remove(struct spi_device *spi)
>  
>  	ieee802154_unregister_hw(lp->hw);
>  	ieee802154_free_hw(lp->hw);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id mcr20a_of_match[] = {
> diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
> index ff83e00b77af..ee4cfbf2c5cc 100644
> --- a/drivers/net/ieee802154/mrf24j40.c
> +++ b/drivers/net/ieee802154/mrf24j40.c
> @@ -1356,7 +1356,7 @@ static int mrf24j40_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int mrf24j40_remove(struct spi_device *spi)
> +static void mrf24j40_remove(struct spi_device *spi)
>  {
>  	struct mrf24j40 *devrec = spi_get_drvdata(spi);
>  
> @@ -1366,8 +1366,6 @@ static int mrf24j40_remove(struct spi_device *spi)
>  	ieee802154_free_hw(devrec->hw);
>  	/* TODO: Will ieee802154_free_device() wait until ->xmit() is
>  	 * complete? */
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id mrf24j40_of_match[] = {
> diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
> index 8b5445a724ce..ff37f8ba6758 100644
> --- a/drivers/net/phy/spi_ks8995.c
> +++ b/drivers/net/phy/spi_ks8995.c
> @@ -517,7 +517,7 @@ static int ks8995_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ks8995_remove(struct spi_device *spi)
> +static void ks8995_remove(struct spi_device *spi)
>  {
>  	struct ks8995_switch *ks = spi_get_drvdata(spi);
>  
> @@ -526,8 +526,6 @@ static int ks8995_remove(struct spi_device *spi)
>  	/* assert reset */
>  	if (ks->pdata && gpio_is_valid(ks->pdata->reset_gpio))
>  		gpiod_set_value(gpio_to_desc(ks->pdata->reset_gpio), 1);
> -
> -	return 0;
>  }
>  
>  /* ------------------------------------------------------------------------ */
> diff --git a/drivers/net/wan/slic_ds26522.c b/drivers/net/wan/slic_ds26522.c
> index 8e3b1c717c10..6063552cea9b 100644
> --- a/drivers/net/wan/slic_ds26522.c
> +++ b/drivers/net/wan/slic_ds26522.c
> @@ -194,10 +194,9 @@ static int slic_ds26522_init_configure(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int slic_ds26522_remove(struct spi_device *spi)
> +static void slic_ds26522_remove(struct spi_device *spi)
>  {
>  	pr_info("DS26522 module uninstalled\n");
> -	return 0;
>  }
>  
>  static int slic_ds26522_probe(struct spi_device *spi)
> diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
> index ab0fe8565851..f99b7ba69fc3 100644
> --- a/drivers/net/wireless/intersil/p54/p54spi.c
> +++ b/drivers/net/wireless/intersil/p54/p54spi.c
> @@ -669,7 +669,7 @@ static int p54spi_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int p54spi_remove(struct spi_device *spi)
> +static void p54spi_remove(struct spi_device *spi)
>  {
>  	struct p54s_priv *priv = spi_get_drvdata(spi);
>  
> @@ -684,8 +684,6 @@ static int p54spi_remove(struct spi_device *spi)
>  	mutex_destroy(&priv->mutex);
>  
>  	p54_free_common(priv->hw);
> -
> -	return 0;
>  }
>  
>  
> diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c b/drivers/net/wireless/marvell/libertas/if_spi.c
> index cd9f8ecf171f..ff1c7ec8c450 100644
> --- a/drivers/net/wireless/marvell/libertas/if_spi.c
> +++ b/drivers/net/wireless/marvell/libertas/if_spi.c
> @@ -1195,7 +1195,7 @@ static int if_spi_probe(struct spi_device *spi)
>  	return err;
>  }
>  
> -static int libertas_spi_remove(struct spi_device *spi)
> +static void libertas_spi_remove(struct spi_device *spi)
>  {
>  	struct if_spi_card *card = spi_get_drvdata(spi);
>  	struct lbs_private *priv = card->priv;
> @@ -1212,8 +1212,6 @@ static int libertas_spi_remove(struct spi_device *spi)
>  	if (card->pdata->teardown)
>  		card->pdata->teardown(spi);
>  	free_if_spi_card(card);
> -
> -	return 0;
>  }
>  
>  static int if_spi_suspend(struct device *dev)
> diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
> index 2c2ed4b09efd..d2db52289399 100644
> --- a/drivers/net/wireless/microchip/wilc1000/spi.c
> +++ b/drivers/net/wireless/microchip/wilc1000/spi.c
> @@ -240,7 +240,7 @@ static int wilc_bus_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int wilc_bus_remove(struct spi_device *spi)
> +static void wilc_bus_remove(struct spi_device *spi)
>  {
>  	struct wilc *wilc = spi_get_drvdata(spi);
>  	struct wilc_spi *spi_priv = wilc->bus_data;
> @@ -248,8 +248,6 @@ static int wilc_bus_remove(struct spi_device *spi)
>  	clk_disable_unprepare(wilc->rtc_clk);
>  	wilc_netdev_cleanup(wilc);
>  	kfree(spi_priv);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id wilc_of_match[] = {
> diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wireless/st/cw1200/cw1200_spi.c
> index 271ed2ce2d7f..fe0d220da44d 100644
> --- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
> +++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
> @@ -423,7 +423,7 @@ static int cw1200_spi_probe(struct spi_device *func)
>  }
>  
>  /* Disconnect Function to be called by SPI stack when device is disconnected */
> -static int cw1200_spi_disconnect(struct spi_device *func)
> +static void cw1200_spi_disconnect(struct spi_device *func)
>  {
>  	struct hwbus_priv *self = spi_get_drvdata(func);
>  
> @@ -435,8 +435,6 @@ static int cw1200_spi_disconnect(struct spi_device *func)
>  		}
>  	}
>  	cw1200_spi_off(dev_get_platdata(&func->dev));
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused cw1200_spi_suspend(struct device *dev)
> diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
> index 5b894bd6237e..9df38726e8b0 100644
> --- a/drivers/net/wireless/ti/wl1251/spi.c
> +++ b/drivers/net/wireless/ti/wl1251/spi.c
> @@ -327,14 +327,12 @@ static int wl1251_spi_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int wl1251_spi_remove(struct spi_device *spi)
> +static void wl1251_spi_remove(struct spi_device *spi)
>  {
>  	struct wl1251 *wl = spi_get_drvdata(spi);
>  
>  	wl1251_free_hw(wl);
>  	regulator_disable(wl->vio);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver wl1251_spi_driver = {
> diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
> index 354a7e1c3315..7eae1ec2eb2b 100644
> --- a/drivers/net/wireless/ti/wlcore/spi.c
> +++ b/drivers/net/wireless/ti/wlcore/spi.c
> @@ -546,13 +546,11 @@ static int wl1271_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int wl1271_remove(struct spi_device *spi)
> +static void wl1271_remove(struct spi_device *spi)
>  {
>  	struct wl12xx_spi_glue *glue = spi_get_drvdata(spi);
>  
>  	platform_device_unregister(glue->core);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver wl1271_spi_driver = {
> diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
> index 5b833a9a83f8..a38e2fcdfd39 100644
> --- a/drivers/nfc/nfcmrvl/spi.c
> +++ b/drivers/nfc/nfcmrvl/spi.c
> @@ -174,12 +174,11 @@ static int nfcmrvl_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int nfcmrvl_spi_remove(struct spi_device *spi)
> +static void nfcmrvl_spi_remove(struct spi_device *spi)
>  {
>  	struct nfcmrvl_spi_drv_data *drv_data = spi_get_drvdata(spi);
>  
>  	nfcmrvl_nci_unregister_dev(drv_data->priv);
> -	return 0;
>  }
>  
>  static const struct of_device_id of_nfcmrvl_spi_match[] __maybe_unused = {
> diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
> index 4e723992e74c..169eacc0a32a 100644
> --- a/drivers/nfc/st-nci/spi.c
> +++ b/drivers/nfc/st-nci/spi.c
> @@ -263,13 +263,11 @@ static int st_nci_spi_probe(struct spi_device *dev)
>  	return r;
>  }
>  
> -static int st_nci_spi_remove(struct spi_device *dev)
> +static void st_nci_spi_remove(struct spi_device *dev)
>  {
>  	struct st_nci_spi_phy *phy = spi_get_drvdata(dev);
>  
>  	ndlc_remove(phy->ndlc);
> -
> -	return 0;
>  }
>  
>  static struct spi_device_id st_nci_spi_id_table[] = {
> diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
> index b23f47936473..ed704bb77226 100644
> --- a/drivers/nfc/st95hf/core.c
> +++ b/drivers/nfc/st95hf/core.c
> @@ -1198,7 +1198,7 @@ static int st95hf_probe(struct spi_device *nfc_spi_dev)
>  	return ret;
>  }
>  
> -static int st95hf_remove(struct spi_device *nfc_spi_dev)
> +static void st95hf_remove(struct spi_device *nfc_spi_dev)
>  {
>  	int result = 0;
>  	unsigned char reset_cmd = ST95HF_COMMAND_RESET;
> @@ -1236,8 +1236,6 @@ static int st95hf_remove(struct spi_device *nfc_spi_dev)
>  	/* disable regulator */
>  	if (stcontext->st95hf_supply)
>  		regulator_disable(stcontext->st95hf_supply);
> -
> -	return 0;
>  }
>  
>  /* Register as SPI protocol driver */
> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 29ca9c328df2..21d68664fe08 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c
> @@ -2144,7 +2144,7 @@ static int trf7970a_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int trf7970a_remove(struct spi_device *spi)
> +static void trf7970a_remove(struct spi_device *spi)
>  {
>  	struct trf7970a *trf = spi_get_drvdata(spi);
>  
> @@ -2160,8 +2160,6 @@ static int trf7970a_remove(struct spi_device *spi)
>  	regulator_disable(trf->regulator);
>  
>  	mutex_destroy(&trf->lock);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/platform/chrome/cros_ec_spi.c b/drivers/platform/chrome/cros_ec_spi.c
> index 713c58687721..8493af0f680e 100644
> --- a/drivers/platform/chrome/cros_ec_spi.c
> +++ b/drivers/platform/chrome/cros_ec_spi.c
> @@ -786,13 +786,11 @@ static int cros_ec_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int cros_ec_spi_remove(struct spi_device *spi)
> +static void cros_ec_spi_remove(struct spi_device *spi)
>  {
>  	struct cros_ec_device *ec_dev = spi_get_drvdata(spi);
>  
>  	cros_ec_unregister(ec_dev);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/platform/olpc/olpc-xo175-ec.c b/drivers/platform/olpc/olpc-xo175-ec.c
> index 0d46706afd2d..4823bd2819f6 100644
> --- a/drivers/platform/olpc/olpc-xo175-ec.c
> +++ b/drivers/platform/olpc/olpc-xo175-ec.c
> @@ -648,7 +648,7 @@ static struct olpc_ec_driver olpc_xo175_ec_driver = {
>  	.ec_cmd = olpc_xo175_ec_cmd,
>  };
>  
> -static int olpc_xo175_ec_remove(struct spi_device *spi)
> +static void olpc_xo175_ec_remove(struct spi_device *spi)
>  {
>  	if (pm_power_off == olpc_xo175_ec_power_off)
>  		pm_power_off = NULL;
> @@ -657,8 +657,6 @@ static int olpc_xo175_ec_remove(struct spi_device *spi)
>  
>  	platform_device_unregister(olpc_ec);
>  	olpc_ec = NULL;
> -
> -	return 0;
>  }
>  
>  static int olpc_xo175_ec_probe(struct spi_device *spi)
> diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
> index 2f83adef966e..6d66ab5a8b17 100644
> --- a/drivers/rtc/rtc-ds1302.c
> +++ b/drivers/rtc/rtc-ds1302.c
> @@ -185,10 +185,9 @@ static int ds1302_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ds1302_remove(struct spi_device *spi)
> +static void ds1302_remove(struct spi_device *spi)
>  {
>  	spi_set_drvdata(spi, NULL);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_OF
> diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
> index 9ef107b99b65..ed9360486953 100644
> --- a/drivers/rtc/rtc-ds1305.c
> +++ b/drivers/rtc/rtc-ds1305.c
> @@ -720,7 +720,7 @@ static int ds1305_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ds1305_remove(struct spi_device *spi)
> +static void ds1305_remove(struct spi_device *spi)
>  {
>  	struct ds1305 *ds1305 = spi_get_drvdata(spi);
>  
> @@ -730,8 +730,6 @@ static int ds1305_remove(struct spi_device *spi)
>  		devm_free_irq(&spi->dev, spi->irq, ds1305);
>  		cancel_work_sync(&ds1305->work);
>  	}
> -
> -	return 0;
>  }
>  
>  static struct spi_driver ds1305_driver = {
> diff --git a/drivers/rtc/rtc-ds1343.c b/drivers/rtc/rtc-ds1343.c
> index f14ed6c96437..ed5a6ba89a3e 100644
> --- a/drivers/rtc/rtc-ds1343.c
> +++ b/drivers/rtc/rtc-ds1343.c
> @@ -434,11 +434,9 @@ static int ds1343_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ds1343_remove(struct spi_device *spi)
> +static void ds1343_remove(struct spi_device *spi)
>  {
>  	dev_pm_clear_wake_irq(&spi->dev);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
> index 37f4443ce9a0..e9d83d65873b 100644
> --- a/drivers/spi/spi-mem.c
> +++ b/drivers/spi/spi-mem.c
> @@ -854,15 +854,13 @@ static int spi_mem_probe(struct spi_device *spi)
>  	return memdrv->probe(mem);
>  }
>  
> -static int spi_mem_remove(struct spi_device *spi)
> +static void spi_mem_remove(struct spi_device *spi)
>  {
>  	struct spi_mem_driver *memdrv = to_spi_mem_drv(spi->dev.driver);
>  	struct spi_mem *mem = spi_get_drvdata(spi);
>  
>  	if (memdrv->remove)
> -		return memdrv->remove(mem);
> -
> -	return 0;
> +		memdrv->remove(mem);
>  }
>  
>  static void spi_mem_shutdown(struct spi_device *spi)
> diff --git a/drivers/spi/spi-slave-system-control.c b/drivers/spi/spi-slave-system-control.c
> index 169f3d595f60..d37cfe995a63 100644
> --- a/drivers/spi/spi-slave-system-control.c
> +++ b/drivers/spi/spi-slave-system-control.c
> @@ -132,13 +132,12 @@ static int spi_slave_system_control_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int spi_slave_system_control_remove(struct spi_device *spi)
> +static void spi_slave_system_control_remove(struct spi_device *spi)
>  {
>  	struct spi_slave_system_control_priv *priv = spi_get_drvdata(spi);
>  
>  	spi_slave_abort(spi);
>  	wait_for_completion(&priv->finished);
> -	return 0;
>  }
>  
>  static struct spi_driver spi_slave_system_control_driver = {
> diff --git a/drivers/spi/spi-slave-time.c b/drivers/spi/spi-slave-time.c
> index f2e07a392d68..f56c1afb8534 100644
> --- a/drivers/spi/spi-slave-time.c
> +++ b/drivers/spi/spi-slave-time.c
> @@ -106,13 +106,12 @@ static int spi_slave_time_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int spi_slave_time_remove(struct spi_device *spi)
> +static void spi_slave_time_remove(struct spi_device *spi)
>  {
>  	struct spi_slave_time_priv *priv = spi_get_drvdata(spi);
>  
>  	spi_slave_abort(spi);
>  	wait_for_completion(&priv->finished);
> -	return 0;
>  }
>  
>  static struct spi_driver spi_slave_time_driver = {
> diff --git a/drivers/spi/spi-tle62x0.c b/drivers/spi/spi-tle62x0.c
> index f8ad0709d015..a565352f6381 100644
> --- a/drivers/spi/spi-tle62x0.c
> +++ b/drivers/spi/spi-tle62x0.c
> @@ -288,7 +288,7 @@ static int tle62x0_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int tle62x0_remove(struct spi_device *spi)
> +static void tle62x0_remove(struct spi_device *spi)
>  {
>  	struct tle62x0_state *st = spi_get_drvdata(spi);
>  	int ptr;
> @@ -298,7 +298,6 @@ static int tle62x0_remove(struct spi_device *spi)
>  
>  	device_remove_file(&spi->dev, &dev_attr_status_show);
>  	kfree(st);
> -	return 0;
>  }
>  
>  static struct spi_driver tle62x0_driver = {
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 4599b121d744..ead9a132dcb9 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -404,15 +404,8 @@ static void spi_remove(struct device *dev)
>  {
>  	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
>  
> -	if (sdrv->remove) {
> -		int ret;
> -
> -		ret = sdrv->remove(to_spi_device(dev));
> -		if (ret)
> -			dev_warn(dev,
> -				 "Failed to unbind driver (%pe), ignoring\n",
> -				 ERR_PTR(ret));
> -	}
> +	if (sdrv->remove)
> +		sdrv->remove(to_spi_device(dev));
>  
>  	dev_pm_domain_detach(dev, true);
>  }
> diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
> index a5cceca8b82b..9468f74308bd 100644
> --- a/drivers/spi/spidev.c
> +++ b/drivers/spi/spidev.c
> @@ -803,7 +803,7 @@ static int spidev_probe(struct spi_device *spi)
>  	return status;
>  }
>  
> -static int spidev_remove(struct spi_device *spi)
> +static void spidev_remove(struct spi_device *spi)
>  {
>  	struct spidev_data	*spidev = spi_get_drvdata(spi);
>  
> @@ -820,8 +820,6 @@ static int spidev_remove(struct spi_device *spi)
>  	if (spidev->users == 0)
>  		kfree(spidev);
>  	mutex_unlock(&device_list_lock);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver spidev_spi_driver = {
> diff --git a/drivers/staging/fbtft/fbtft.h b/drivers/staging/fbtft/fbtft.h
> index 6a7545b5bcd2..b68f5f9b7c78 100644
> --- a/drivers/staging/fbtft/fbtft.h
> +++ b/drivers/staging/fbtft/fbtft.h
> @@ -286,12 +286,11 @@ static int fbtft_driver_probe_spi(struct spi_device *spi)			\
>  	return fbtft_probe_common(_display, spi, NULL);				\
>  }										\
>  										\
> -static int fbtft_driver_remove_spi(struct spi_device *spi)			\
> +static void fbtft_driver_remove_spi(struct spi_device *spi)			\
>  {										\
>  	struct fb_info *info = spi_get_drvdata(spi);				\
>  										\
>  	fbtft_remove_common(&spi->dev, info);					\
> -	return 0;								\
>  }										\
>  										\
>  static struct spi_driver fbtft_driver_spi_driver = {				\
> diff --git a/drivers/staging/pi433/pi433_if.c b/drivers/staging/pi433/pi433_if.c
> index 68c09fa016ed..1d31c35875e3 100644
> --- a/drivers/staging/pi433/pi433_if.c
> +++ b/drivers/staging/pi433/pi433_if.c
> @@ -1264,7 +1264,7 @@ static int pi433_probe(struct spi_device *spi)
>  	return retval;
>  }
>  
> -static int pi433_remove(struct spi_device *spi)
> +static void pi433_remove(struct spi_device *spi)
>  {
>  	struct pi433_device	*device = spi_get_drvdata(spi);
>  
> @@ -1284,8 +1284,6 @@ static int pi433_remove(struct spi_device *spi)
>  
>  	kfree(device->rx_buffer);
>  	kfree(device);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id pi433_dt_ids[] = {
> diff --git a/drivers/staging/wfx/bus_spi.c b/drivers/staging/wfx/bus_spi.c
> index 55ffcd7c42e2..fa0ff66a457d 100644
> --- a/drivers/staging/wfx/bus_spi.c
> +++ b/drivers/staging/wfx/bus_spi.c
> @@ -232,12 +232,11 @@ static int wfx_spi_probe(struct spi_device *func)
>  	return wfx_probe(bus->core);
>  }
>  
> -static int wfx_spi_remove(struct spi_device *func)
> +static void wfx_spi_remove(struct spi_device *func)
>  {
>  	struct wfx_spi_priv *bus = spi_get_drvdata(func);
>  
>  	wfx_release(bus->core);
> -	return 0;
>  }
>  
>  /* For dynamic driver binding, kernel does not use OF to match driver. It only
> diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
> index 3c92d4e01488..516cff362434 100644
> --- a/drivers/tty/serial/max3100.c
> +++ b/drivers/tty/serial/max3100.c
> @@ -805,7 +805,7 @@ static int max3100_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int max3100_remove(struct spi_device *spi)
> +static void max3100_remove(struct spi_device *spi)
>  {
>  	struct max3100_port *s = spi_get_drvdata(spi);
>  	int i;
> @@ -828,13 +828,12 @@ static int max3100_remove(struct spi_device *spi)
>  	for (i = 0; i < MAX_MAX3100; i++)
>  		if (max3100s[i]) {
>  			mutex_unlock(&max3100s_lock);
> -			return 0;
> +			return;
>  		}
>  	pr_debug("removing max3100 driver\n");
>  	uart_unregister_driver(&max3100_uart_driver);
>  
>  	mutex_unlock(&max3100s_lock);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
> index dde0824b2fa5..3112b4a05448 100644
> --- a/drivers/tty/serial/max310x.c
> +++ b/drivers/tty/serial/max310x.c
> @@ -1487,10 +1487,9 @@ static int max310x_spi_probe(struct spi_device *spi)
>  	return max310x_probe(&spi->dev, devtype, regmap, spi->irq);
>  }
>  
> -static int max310x_spi_remove(struct spi_device *spi)
> +static void max310x_spi_remove(struct spi_device *spi)
>  {
>  	max310x_remove(&spi->dev);
> -	return 0;
>  }
>  
>  static const struct spi_device_id max310x_id_table[] = {
> diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> index 64e7e6c8145f..25d67b8c4db7 100644
> --- a/drivers/tty/serial/sc16is7xx.c
> +++ b/drivers/tty/serial/sc16is7xx.c
> @@ -1440,11 +1440,9 @@ static int sc16is7xx_spi_probe(struct spi_device *spi)
>  	return sc16is7xx_probe(&spi->dev, devtype, regmap, spi->irq);
>  }
>  
> -static int sc16is7xx_spi_remove(struct spi_device *spi)
> +static void sc16is7xx_spi_remove(struct spi_device *spi)
>  {
>  	sc16is7xx_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id sc16is7xx_spi_id_table[] = {
> diff --git a/drivers/usb/gadget/udc/max3420_udc.c b/drivers/usb/gadget/udc/max3420_udc.c
> index d2a2b20cc1ad..7d9bd16190c0 100644
> --- a/drivers/usb/gadget/udc/max3420_udc.c
> +++ b/drivers/usb/gadget/udc/max3420_udc.c
> @@ -1292,7 +1292,7 @@ static int max3420_probe(struct spi_device *spi)
>  	return err;
>  }
>  
> -static int max3420_remove(struct spi_device *spi)
> +static void max3420_remove(struct spi_device *spi)
>  {
>  	struct max3420_udc *udc = spi_get_drvdata(spi);
>  	unsigned long flags;
> @@ -1304,8 +1304,6 @@ static int max3420_remove(struct spi_device *spi)
>  	kthread_stop(udc->thread_task);
>  
>  	spin_unlock_irqrestore(&udc->lock, flags);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id max3420_udc_of_match[] = {
> diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
> index 30de85a707fe..99a5523a79fb 100644
> --- a/drivers/usb/host/max3421-hcd.c
> +++ b/drivers/usb/host/max3421-hcd.c
> @@ -1926,7 +1926,7 @@ max3421_probe(struct spi_device *spi)
>  	return retval;
>  }
>  
> -static int
> +static void
>  max3421_remove(struct spi_device *spi)
>  {
>  	struct max3421_hcd *max3421_hcd;
> @@ -1947,7 +1947,6 @@ max3421_remove(struct spi_device *spi)
>  	free_irq(spi->irq, hcd);
>  
>  	usb_put_hcd(hcd);
> -	return 0;
>  }
>  
>  static const struct of_device_id max3421_of_match_table[] = {
> diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
> index 8a4361e95a11..522dd81110b8 100644
> --- a/drivers/video/backlight/ams369fg06.c
> +++ b/drivers/video/backlight/ams369fg06.c
> @@ -506,12 +506,11 @@ static int ams369fg06_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ams369fg06_remove(struct spi_device *spi)
> +static void ams369fg06_remove(struct spi_device *spi)
>  {
>  	struct ams369fg06 *lcd = spi_get_drvdata(spi);
>  
>  	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
> index 33f5d80495e6..0a57033ae31d 100644
> --- a/drivers/video/backlight/corgi_lcd.c
> +++ b/drivers/video/backlight/corgi_lcd.c
> @@ -542,7 +542,7 @@ static int corgi_lcd_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int corgi_lcd_remove(struct spi_device *spi)
> +static void corgi_lcd_remove(struct spi_device *spi)
>  {
>  	struct corgi_lcd *lcd = spi_get_drvdata(spi);
>  
> @@ -550,7 +550,6 @@ static int corgi_lcd_remove(struct spi_device *spi)
>  	lcd->bl_dev->props.brightness = 0;
>  	backlight_update_status(lcd->bl_dev);
>  	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_POWERDOWN);
> -	return 0;
>  }
>  
>  static struct spi_driver corgi_lcd_driver = {
> diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> index 328aba9cddad..e7b6bd827986 100644
> --- a/drivers/video/backlight/ili922x.c
> +++ b/drivers/video/backlight/ili922x.c
> @@ -526,10 +526,9 @@ static int ili922x_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ili922x_remove(struct spi_device *spi)
> +static void ili922x_remove(struct spi_device *spi)
>  {
>  	ili922x_poweroff(spi);
> -	return 0;
>  }
>  
>  static struct spi_driver ili922x_driver = {
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index 46f97d1c3d21..cc763cf15f53 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -223,12 +223,11 @@ static int l4f00242t03_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int l4f00242t03_remove(struct spi_device *spi)
> +static void l4f00242t03_remove(struct spi_device *spi)
>  {
>  	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
>  
>  	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
> -	return 0;
>  }
>  
>  static void l4f00242t03_shutdown(struct spi_device *spi)
> diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
> index f949b66dce1b..5c46df8022bf 100644
> --- a/drivers/video/backlight/lms501kf03.c
> +++ b/drivers/video/backlight/lms501kf03.c
> @@ -364,12 +364,11 @@ static int lms501kf03_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int lms501kf03_remove(struct spi_device *spi)
> +static void lms501kf03_remove(struct spi_device *spi)
>  {
>  	struct lms501kf03 *lcd = spi_get_drvdata(spi);
>  
>  	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
> index 5cbf621e48bd..b6d373af6e3f 100644
> --- a/drivers/video/backlight/ltv350qv.c
> +++ b/drivers/video/backlight/ltv350qv.c
> @@ -255,12 +255,11 @@ static int ltv350qv_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ltv350qv_remove(struct spi_device *spi)
> +static void ltv350qv_remove(struct spi_device *spi)
>  {
>  	struct ltv350qv *lcd = spi_get_drvdata(spi);
>  
>  	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
> index 0de044dcafd5..fc6fbaf85594 100644
> --- a/drivers/video/backlight/tdo24m.c
> +++ b/drivers/video/backlight/tdo24m.c
> @@ -397,12 +397,11 @@ static int tdo24m_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int tdo24m_remove(struct spi_device *spi)
> +static void tdo24m_remove(struct spi_device *spi)
>  {
>  	struct tdo24m *lcd = spi_get_drvdata(spi);
>  
>  	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
> index 38765544345b..23d6c6bf0f54 100644
> --- a/drivers/video/backlight/tosa_lcd.c
> +++ b/drivers/video/backlight/tosa_lcd.c
> @@ -232,15 +232,13 @@ static int tosa_lcd_probe(struct spi_device *spi)
>  	return ret;
>  }
>  
> -static int tosa_lcd_remove(struct spi_device *spi)
> +static void tosa_lcd_remove(struct spi_device *spi)
>  {
>  	struct tosa_lcd_data *data = spi_get_drvdata(spi);
>  
>  	i2c_unregister_device(data->i2c);
>  
>  	tosa_lcd_tg_off(data);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
> index 3567b45f9ba9..bfc1913e8b55 100644
> --- a/drivers/video/backlight/vgg2432a4.c
> +++ b/drivers/video/backlight/vgg2432a4.c
> @@ -233,11 +233,9 @@ static int vgg2432a4_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int vgg2432a4_remove(struct spi_device *spi)
> +static void vgg2432a4_remove(struct spi_device *spi)
>  {
>  	ili9320_remove(spi_get_drvdata(spi));
> -
> -	return 0;
>  }
>  
>  static void vgg2432a4_shutdown(struct spi_device *spi)
> diff --git a/drivers/video/fbdev/omap/lcd_mipid.c b/drivers/video/fbdev/omap/lcd_mipid.c
> index a75ae0c9b14c..03cff39d392d 100644
> --- a/drivers/video/fbdev/omap/lcd_mipid.c
> +++ b/drivers/video/fbdev/omap/lcd_mipid.c
> @@ -570,14 +570,12 @@ static int mipid_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int mipid_spi_remove(struct spi_device *spi)
> +static void mipid_spi_remove(struct spi_device *spi)
>  {
>  	struct mipid_device *md = dev_get_drvdata(&spi->dev);
>  
>  	mipid_disable(&md->panel);
>  	kfree(md);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver mipid_spi_driver = {
> diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c
> index 1bec7a4422e8..aab67721263d 100644
> --- a/drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c
> +++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c
> @@ -316,7 +316,7 @@ static int lb035q02_panel_spi_probe(struct spi_device *spi)
>  	return r;
>  }
>  
> -static int lb035q02_panel_spi_remove(struct spi_device *spi)
> +static void lb035q02_panel_spi_remove(struct spi_device *spi)
>  {
>  	struct panel_drv_data *ddata = spi_get_drvdata(spi);
>  	struct omap_dss_device *dssdev = &ddata->dssdev;
> @@ -328,8 +328,6 @@ static int lb035q02_panel_spi_remove(struct spi_device *spi)
>  	lb035q02_disconnect(dssdev);
>  
>  	omap_dss_put_device(in);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id lb035q02_of_match[] = {
> diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c
> index dff9ebbadfc0..be9910ff6e62 100644
> --- a/drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c
> +++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c
> @@ -327,7 +327,7 @@ static int nec_8048_probe(struct spi_device *spi)
>  	return r;
>  }
>  
> -static int nec_8048_remove(struct spi_device *spi)
> +static void nec_8048_remove(struct spi_device *spi)
>  {
>  	struct panel_drv_data *ddata = dev_get_drvdata(&spi->dev);
>  	struct omap_dss_device *dssdev = &ddata->dssdev;
> @@ -341,8 +341,6 @@ static int nec_8048_remove(struct spi_device *spi)
>  	nec_8048_disconnect(dssdev);
>  
>  	omap_dss_put_device(in);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
> index 8d8b5ff7d43c..a909b5385ca5 100644
> --- a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
> +++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
> @@ -857,7 +857,7 @@ static int acx565akm_probe(struct spi_device *spi)
>  	return r;
>  }
>  
> -static int acx565akm_remove(struct spi_device *spi)
> +static void acx565akm_remove(struct spi_device *spi)
>  {
>  	struct panel_drv_data *ddata = dev_get_drvdata(&spi->dev);
>  	struct omap_dss_device *dssdev = &ddata->dssdev;
> @@ -874,8 +874,6 @@ static int acx565akm_remove(struct spi_device *spi)
>  	acx565akm_disconnect(dssdev);
>  
>  	omap_dss_put_device(in);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id acx565akm_of_match[] = {
> diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c
> index 595ebd8bd5dc..3c0f887d3092 100644
> --- a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c
> +++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c
> @@ -425,7 +425,7 @@ static int td028ttec1_panel_probe(struct spi_device *spi)
>  	return r;
>  }
>  
> -static int td028ttec1_panel_remove(struct spi_device *spi)
> +static void td028ttec1_panel_remove(struct spi_device *spi)
>  {
>  	struct panel_drv_data *ddata = dev_get_drvdata(&spi->dev);
>  	struct omap_dss_device *dssdev = &ddata->dssdev;
> @@ -439,8 +439,6 @@ static int td028ttec1_panel_remove(struct spi_device *spi)
>  	td028ttec1_panel_disconnect(dssdev);
>  
>  	omap_dss_put_device(in);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id td028ttec1_of_match[] = {
> diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
> index afac1d9445aa..58bbba7c037f 100644
> --- a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
> +++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
> @@ -564,7 +564,7 @@ static int tpo_td043_probe(struct spi_device *spi)
>  	return r;
>  }
>  
> -static int tpo_td043_remove(struct spi_device *spi)
> +static void tpo_td043_remove(struct spi_device *spi)
>  {
>  	struct panel_drv_data *ddata = dev_get_drvdata(&spi->dev);
>  	struct omap_dss_device *dssdev = &ddata->dssdev;
> @@ -580,8 +580,6 @@ static int tpo_td043_remove(struct spi_device *spi)
>  	omap_dss_put_device(in);
>  
>  	sysfs_remove_group(&spi->dev.kobj, &tpo_td043_attr_group);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index 7ab3fed7b804..c84e61b99c7b 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -280,7 +280,7 @@ struct spi_message;
>  struct spi_driver {
>  	const struct spi_device_id *id_table;
>  	int			(*probe)(struct spi_device *spi);
> -	int			(*remove)(struct spi_device *spi);
> +	void			(*remove)(struct spi_device *spi);
>  	void			(*shutdown)(struct spi_device *spi);
>  	struct device_driver	driver;
>  };
> diff --git a/sound/pci/hda/cs35l41_hda_spi.c b/sound/pci/hda/cs35l41_hda_spi.c
> index 9f8123893cc8..50eb6c0e6658 100644
> --- a/sound/pci/hda/cs35l41_hda_spi.c
> +++ b/sound/pci/hda/cs35l41_hda_spi.c
> @@ -28,11 +28,9 @@ static int cs35l41_hda_spi_probe(struct spi_device *spi)
>  				 devm_regmap_init_spi(spi, &cs35l41_regmap_spi));
>  }
>  
> -static int cs35l41_hda_spi_remove(struct spi_device *spi)
> +static void cs35l41_hda_spi_remove(struct spi_device *spi)
>  {
>  	cs35l41_hda_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id cs35l41_hda_spi_id[] = {
> diff --git a/sound/soc/codecs/adau1761-spi.c b/sound/soc/codecs/adau1761-spi.c
> index 655689c9778a..7c9242c2ff94 100644
> --- a/sound/soc/codecs/adau1761-spi.c
> +++ b/sound/soc/codecs/adau1761-spi.c
> @@ -45,10 +45,9 @@ static int adau1761_spi_probe(struct spi_device *spi)
>  		id->driver_data, adau1761_spi_switch_mode);
>  }
>  
> -static int adau1761_spi_remove(struct spi_device *spi)
> +static void adau1761_spi_remove(struct spi_device *spi)
>  {
>  	adau17x1_remove(&spi->dev);
> -	return 0;
>  }
>  
>  static const struct spi_device_id adau1761_spi_id[] = {
> diff --git a/sound/soc/codecs/adau1781-spi.c b/sound/soc/codecs/adau1781-spi.c
> index bb5613574786..1a09633d5a88 100644
> --- a/sound/soc/codecs/adau1781-spi.c
> +++ b/sound/soc/codecs/adau1781-spi.c
> @@ -45,10 +45,9 @@ static int adau1781_spi_probe(struct spi_device *spi)
>  		id->driver_data, adau1781_spi_switch_mode);
>  }
>  
> -static int adau1781_spi_remove(struct spi_device *spi)
> +static void adau1781_spi_remove(struct spi_device *spi)
>  {
>  	adau17x1_remove(&spi->dev);
> -	return 0;
>  }
>  
>  static const struct spi_device_id adau1781_spi_id[] = {
> diff --git a/sound/soc/codecs/cs35l41-spi.c b/sound/soc/codecs/cs35l41-spi.c
> index 6dfd5459aa20..169221a5b09f 100644
> --- a/sound/soc/codecs/cs35l41-spi.c
> +++ b/sound/soc/codecs/cs35l41-spi.c
> @@ -55,13 +55,11 @@ static int cs35l41_spi_probe(struct spi_device *spi)
>  	return cs35l41_probe(cs35l41, pdata);
>  }
>  
> -static int cs35l41_spi_remove(struct spi_device *spi)
> +static void cs35l41_spi_remove(struct spi_device *spi)
>  {
>  	struct cs35l41_private *cs35l41 = spi_get_drvdata(spi);
>  
>  	cs35l41_remove(cs35l41);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_OF
> diff --git a/sound/soc/codecs/pcm3168a-spi.c b/sound/soc/codecs/pcm3168a-spi.c
> index ecd379f308e6..b5b08046f545 100644
> --- a/sound/soc/codecs/pcm3168a-spi.c
> +++ b/sound/soc/codecs/pcm3168a-spi.c
> @@ -26,11 +26,9 @@ static int pcm3168a_spi_probe(struct spi_device *spi)
>  	return pcm3168a_probe(&spi->dev, regmap);
>  }
>  
> -static int pcm3168a_spi_remove(struct spi_device *spi)
> +static void pcm3168a_spi_remove(struct spi_device *spi)
>  {
>  	pcm3168a_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id pcm3168a_spi_id[] = {
> diff --git a/sound/soc/codecs/pcm512x-spi.c b/sound/soc/codecs/pcm512x-spi.c
> index 7cf559b47e1c..4d29e7196380 100644
> --- a/sound/soc/codecs/pcm512x-spi.c
> +++ b/sound/soc/codecs/pcm512x-spi.c
> @@ -26,10 +26,9 @@ static int pcm512x_spi_probe(struct spi_device *spi)
>  	return pcm512x_probe(&spi->dev, regmap);
>  }
>  
> -static int pcm512x_spi_remove(struct spi_device *spi)
> +static void pcm512x_spi_remove(struct spi_device *spi)
>  {
>  	pcm512x_remove(&spi->dev);
> -	return 0;
>  }
>  
>  static const struct spi_device_id pcm512x_spi_id[] = {
> diff --git a/sound/soc/codecs/tlv320aic32x4-spi.c b/sound/soc/codecs/tlv320aic32x4-spi.c
> index a8958cd1c692..03cce8d6404f 100644
> --- a/sound/soc/codecs/tlv320aic32x4-spi.c
> +++ b/sound/soc/codecs/tlv320aic32x4-spi.c
> @@ -46,11 +46,9 @@ static int aic32x4_spi_probe(struct spi_device *spi)
>  	return aic32x4_probe(&spi->dev, regmap);
>  }
>  
> -static int aic32x4_spi_remove(struct spi_device *spi)
> +static void aic32x4_spi_remove(struct spi_device *spi)
>  {
>  	aic32x4_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id aic32x4_spi_id[] = {
> diff --git a/sound/soc/codecs/tlv320aic3x-spi.c b/sound/soc/codecs/tlv320aic3x-spi.c
> index 494e84402232..deed6ec7e081 100644
> --- a/sound/soc/codecs/tlv320aic3x-spi.c
> +++ b/sound/soc/codecs/tlv320aic3x-spi.c
> @@ -35,11 +35,9 @@ static int aic3x_spi_probe(struct spi_device *spi)
>  	return aic3x_probe(&spi->dev, regmap, id->driver_data);
>  }
>  
> -static int aic3x_spi_remove(struct spi_device *spi)
> +static void aic3x_spi_remove(struct spi_device *spi)
>  {
>  	aic3x_remove(&spi->dev);
> -
> -	return 0;
>  }
>  
>  static const struct spi_device_id aic3x_spi_id[] = {
> diff --git a/sound/soc/codecs/wm0010.c b/sound/soc/codecs/wm0010.c
> index 28b4656c4e14..1bef1c500c8e 100644
> --- a/sound/soc/codecs/wm0010.c
> +++ b/sound/soc/codecs/wm0010.c
> @@ -969,7 +969,7 @@ static int wm0010_spi_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int wm0010_spi_remove(struct spi_device *spi)
> +static void wm0010_spi_remove(struct spi_device *spi)
>  {
>  	struct wm0010_priv *wm0010 = spi_get_drvdata(spi);
>  
> @@ -980,8 +980,6 @@ static int wm0010_spi_remove(struct spi_device *spi)
>  
>  	if (wm0010->irq)
>  		free_irq(wm0010->irq, wm0010);
> -
> -	return 0;
>  }
>  
>  static struct spi_driver wm0010_spi_driver = {
> diff --git a/sound/soc/codecs/wm8804-spi.c b/sound/soc/codecs/wm8804-spi.c
> index 9a8da1511c34..628568724c20 100644
> --- a/sound/soc/codecs/wm8804-spi.c
> +++ b/sound/soc/codecs/wm8804-spi.c
> @@ -24,10 +24,9 @@ static int wm8804_spi_probe(struct spi_device *spi)
>  	return wm8804_probe(&spi->dev, regmap);
>  }
>  
> -static int wm8804_spi_remove(struct spi_device *spi)
> +static void wm8804_spi_remove(struct spi_device *spi)
>  {
>  	wm8804_remove(&spi->dev);
> -	return 0;
>  }
>  
>  static const struct of_device_id wm8804_of_match[] = {
> diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
> index 76c0e37a838c..56d2c712e257 100644
> --- a/sound/spi/at73c213.c
> +++ b/sound/spi/at73c213.c
> @@ -1001,7 +1001,7 @@ static int snd_at73c213_probe(struct spi_device *spi)
>  	return retval;
>  }
>  
> -static int snd_at73c213_remove(struct spi_device *spi)
> +static void snd_at73c213_remove(struct spi_device *spi)
>  {
>  	struct snd_card *card = dev_get_drvdata(&spi->dev);
>  	struct snd_at73c213 *chip = card->private_data;
> @@ -1066,8 +1066,6 @@ static int snd_at73c213_remove(struct spi_device *spi)
>  
>  	ssc_free(chip->ssc);
>  	snd_card_free(card);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> -- 
> 2.34.1
> 

-- 
With Best Regards,
Andy Shevchenko


