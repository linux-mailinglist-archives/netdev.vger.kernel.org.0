Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0458F55FD95
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiF2KlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiF2KlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:41:04 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED143E0C1;
        Wed, 29 Jun 2022 03:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656499262; x=1688035262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=R8VB6/tjMDgTxKnue93AU4hdI5XOBKB8dDAwO/qOwjg=;
  b=nP2egLQDaZ77vNECafRiIqybpfmzq1pYkQkHVEh6iAAp1AxjadNoy9bB
   SVE6KOcWsaRjv9e5kEkFZ87jNtglU/EG954OwOOW51Bw6JWA338QuQl7S
   PK9hbVoS6mKOnjusCl/DMBbjb5PfJ9OOqYagz0YuTJCSIwd37xv5T6huS
   Wt16jeMF4EP5RlJy3rtZGnZ9O3T54idMQvOghmaBrvAyhnXYLAipwWyW0
   in6NH4H2ybwXyCpESrMq3NOz7EsETkcfWNNn0vvCEnXlE3HMF8ev4k27u
   RjeggAU12ucW+9JpjvAeXGjnzQ7//gERLtS1g/4mQ5faeLu0iX6Q1315p
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343686249"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="343686249"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 03:40:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="617536648"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 03:40:46 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o6V7i-000xcv-MD;
        Wed, 29 Jun 2022 13:40:42 +0300
Date:   Wed, 29 Jun 2022 13:40:42 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        openipmi-developer@lists.sourceforge.net,
        linux-integrity@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
        dri-devel@lists.freedesktop.org, chrome-platform@lists.linux.dev,
        linux-rpi-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net, linux-pm@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 6/6] i2c: Make remove callback return void
Message-ID: <YrwsKnRZqksuTCVe@smile.fi.intel.com>
References: <20220628140313.74984-1-u.kleine-koenig@pengutronix.de>
 <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 04:03:12PM +0200, Uwe Kleine-König wrote:
> From: Uwe Kleine-König <uwe@kleine-koenig.org>
> 
> The value returned by an i2c driver's remove function is mostly ignored.
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
>  Documentation/i2c/writing-clients.rst                     | 2 +-
>  arch/arm/mach-davinci/board-dm644x-evm.c                  | 3 +--
>  arch/arm/mach-davinci/board-dm646x-evm.c                  | 3 +--
>  arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c            | 3 +--
>  drivers/auxdisplay/ht16k33.c                              | 4 +---
>  drivers/auxdisplay/lcd2s.c                                | 3 +--
>  drivers/char/ipmi/ipmb_dev_int.c                          | 4 +---
>  drivers/char/ipmi/ipmi_ipmb.c                             | 4 +---
>  drivers/char/ipmi/ipmi_ssif.c                             | 6 ++----
>  drivers/char/tpm/st33zp24/i2c.c                           | 4 +---
>  drivers/char/tpm/tpm_i2c_atmel.c                          | 3 +--
>  drivers/char/tpm/tpm_i2c_infineon.c                       | 4 +---
>  drivers/char/tpm/tpm_i2c_nuvoton.c                        | 3 +--
>  drivers/char/tpm/tpm_tis_i2c_cr50.c                       | 6 ++----
>  drivers/clk/clk-cdce706.c                                 | 3 +--
>  drivers/clk/clk-cs2000-cp.c                               | 4 +---
>  drivers/clk/clk-si514.c                                   | 3 +--
>  drivers/clk/clk-si5341.c                                  | 4 +---
>  drivers/clk/clk-si5351.c                                  | 4 +---
>  drivers/clk/clk-si570.c                                   | 3 +--
>  drivers/clk/clk-versaclock5.c                             | 4 +---
>  drivers/crypto/atmel-ecc.c                                | 6 ++----
>  drivers/crypto/atmel-sha204a.c                            | 6 ++----
>  drivers/extcon/extcon-rt8973a.c                           | 4 +---
>  drivers/gpio/gpio-adp5588.c                               | 4 +---
>  drivers/gpio/gpio-max7300.c                               | 4 +---
>  drivers/gpio/gpio-pca953x.c                               | 4 +---
>  drivers/gpio/gpio-pcf857x.c                               | 4 +---
>  drivers/gpio/gpio-tpic2810.c                              | 4 +---
>  drivers/gpu/drm/bridge/adv7511/adv7511_drv.c              | 4 +---
>  drivers/gpu/drm/bridge/analogix/analogix-anx6345.c        | 4 +---
>  drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c        | 4 +---
>  drivers/gpu/drm/bridge/analogix/anx7625.c                 | 4 +---
>  drivers/gpu/drm/bridge/chrontel-ch7033.c                  | 4 +---
>  drivers/gpu/drm/bridge/cros-ec-anx7688.c                  | 4 +---
>  drivers/gpu/drm/bridge/ite-it6505.c                       | 4 +---
>  drivers/gpu/drm/bridge/ite-it66121.c                      | 4 +---
>  drivers/gpu/drm/bridge/lontium-lt8912b.c                  | 3 +--
>  drivers/gpu/drm/bridge/lontium-lt9211.c                   | 4 +---
>  drivers/gpu/drm/bridge/lontium-lt9611.c                   | 4 +---
>  drivers/gpu/drm/bridge/lontium-lt9611uxc.c                | 4 +---
>  drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c  | 8 ++------
>  drivers/gpu/drm/bridge/nxp-ptn3460.c                      | 4 +---
>  drivers/gpu/drm/bridge/parade-ps8622.c                    | 4 +---
>  drivers/gpu/drm/bridge/parade-ps8640.c                    | 4 +---
>  drivers/gpu/drm/bridge/sii902x.c                          | 4 +---
>  drivers/gpu/drm/bridge/sii9234.c                          | 4 +---
>  drivers/gpu/drm/bridge/sil-sii8620.c                      | 4 +---
>  drivers/gpu/drm/bridge/tc358767.c                         | 4 +---
>  drivers/gpu/drm/bridge/tc358768.c                         | 4 +---
>  drivers/gpu/drm/bridge/tc358775.c                         | 4 +---
>  drivers/gpu/drm/bridge/ti-sn65dsi83.c                     | 4 +---
>  drivers/gpu/drm/bridge/ti-tfp410.c                        | 4 +---
>  drivers/gpu/drm/i2c/ch7006_drv.c                          | 4 +---
>  drivers/gpu/drm/i2c/tda9950.c                             | 4 +---
>  drivers/gpu/drm/i2c/tda998x_drv.c                         | 3 +--
>  drivers/gpu/drm/panel/panel-olimex-lcd-olinuxino.c        | 4 +---
>  drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c     | 4 +---
>  drivers/gpu/drm/solomon/ssd130x-i2c.c                     | 4 +---
>  drivers/hid/i2c-hid/i2c-hid-core.c                        | 4 +---
>  drivers/hid/i2c-hid/i2c-hid.h                             | 2 +-
>  drivers/hwmon/adc128d818.c                                | 4 +---
>  drivers/hwmon/adt7470.c                                   | 3 +--
>  drivers/hwmon/asb100.c                                    | 6 ++----
>  drivers/hwmon/asc7621.c                                   | 4 +---
>  drivers/hwmon/dme1737.c                                   | 4 +---
>  drivers/hwmon/f75375s.c                                   | 5 ++---
>  drivers/hwmon/fschmd.c                                    | 6 ++----
>  drivers/hwmon/ftsteutates.c                               | 3 +--
>  drivers/hwmon/ina209.c                                    | 4 +---
>  drivers/hwmon/ina3221.c                                   | 4 +---
>  drivers/hwmon/jc42.c                                      | 3 +--
>  drivers/hwmon/mcp3021.c                                   | 4 +---
>  drivers/hwmon/occ/p8_i2c.c                                | 4 +---
>  drivers/hwmon/pcf8591.c                                   | 3 +--
>  drivers/hwmon/smm665.c                                    | 3 +--
>  drivers/hwmon/tps23861.c                                  | 4 +---
>  drivers/hwmon/w83781d.c                                   | 4 +---
>  drivers/hwmon/w83791d.c                                   | 6 ++----
>  drivers/hwmon/w83792d.c                                   | 6 ++----
>  drivers/hwmon/w83793.c                                    | 6 ++----
>  drivers/hwmon/w83795.c                                    | 4 +---
>  drivers/hwmon/w83l785ts.c                                 | 6 ++----
>  drivers/i2c/i2c-core-base.c                               | 6 +-----
>  drivers/i2c/i2c-slave-eeprom.c                            | 4 +---
>  drivers/i2c/i2c-slave-testunit.c                          | 3 +--
>  drivers/i2c/i2c-smbus.c                                   | 3 +--
>  drivers/i2c/muxes/i2c-mux-ltc4306.c                       | 4 +---
>  drivers/i2c/muxes/i2c-mux-pca9541.c                       | 3 +--
>  drivers/i2c/muxes/i2c-mux-pca954x.c                       | 3 +--
>  drivers/iio/accel/bma180.c                                | 4 +---
>  drivers/iio/accel/bma400_i2c.c                            | 4 +---
>  drivers/iio/accel/bmc150-accel-i2c.c                      | 4 +---
>  drivers/iio/accel/kxcjk-1013.c                            | 4 +---
>  drivers/iio/accel/kxsd9-i2c.c                             | 4 +---
>  drivers/iio/accel/mc3230.c                                | 4 +---
>  drivers/iio/accel/mma7455_i2c.c                           | 4 +---
>  drivers/iio/accel/mma7660.c                               | 4 +---
>  drivers/iio/accel/mma8452.c                               | 4 +---
>  drivers/iio/accel/mma9551.c                               | 4 +---
>  drivers/iio/accel/mma9553.c                               | 4 +---
>  drivers/iio/accel/stk8312.c                               | 4 +---
>  drivers/iio/accel/stk8ba50.c                              | 4 +---
>  drivers/iio/adc/ad799x.c                                  | 4 +---
>  drivers/iio/adc/ina2xx-adc.c                              | 4 +---
>  drivers/iio/adc/ltc2497.c                                 | 4 +---
>  drivers/iio/adc/ti-ads1015.c                              | 4 +---
>  drivers/iio/chemical/atlas-sensor.c                       | 4 +---
>  drivers/iio/chemical/ccs811.c                             | 4 +---
>  drivers/iio/chemical/sgp30.c                              | 4 +---
>  drivers/iio/dac/ad5380.c                                  | 4 +---
>  drivers/iio/dac/ad5446.c                                  | 4 +---
>  drivers/iio/dac/ad5593r.c                                 | 4 +---
>  drivers/iio/dac/ad5696-i2c.c                              | 4 +---
>  drivers/iio/dac/ds4424.c                                  | 4 +---
>  drivers/iio/dac/m62332.c                                  | 4 +---
>  drivers/iio/dac/mcp4725.c                                 | 4 +---
>  drivers/iio/dac/ti-dac5571.c                              | 4 +---
>  drivers/iio/gyro/bmg160_i2c.c                             | 4 +---
>  drivers/iio/gyro/fxas21002c_i2c.c                         | 4 +---
>  drivers/iio/gyro/itg3200_core.c                           | 4 +---
>  drivers/iio/gyro/mpu3050-i2c.c                            | 4 +---
>  drivers/iio/health/afe4404.c                              | 4 +---
>  drivers/iio/health/max30100.c                             | 4 +---
>  drivers/iio/health/max30102.c                             | 4 +---
>  drivers/iio/humidity/hdc2010.c                            | 4 +---
>  drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c                 | 4 +---
>  drivers/iio/imu/kmx61.c                                   | 4 +---
>  drivers/iio/light/apds9300.c                              | 4 +---
>  drivers/iio/light/apds9960.c                              | 4 +---
>  drivers/iio/light/bh1750.c                                | 4 +---
>  drivers/iio/light/bh1780.c                                | 4 +---
>  drivers/iio/light/cm3232.c                                | 4 +---
>  drivers/iio/light/cm36651.c                               | 4 +---
>  drivers/iio/light/gp2ap002.c                              | 4 +---
>  drivers/iio/light/gp2ap020a00f.c                          | 4 +---
>  drivers/iio/light/isl29028.c                              | 4 +---
>  drivers/iio/light/isl29125.c                              | 4 +---
>  drivers/iio/light/jsa1212.c                               | 4 +---
>  drivers/iio/light/ltr501.c                                | 4 +---
>  drivers/iio/light/opt3001.c                               | 6 ++----
>  drivers/iio/light/pa12203001.c                            | 4 +---
>  drivers/iio/light/rpr0521.c                               | 4 +---
>  drivers/iio/light/stk3310.c                               | 4 +---
>  drivers/iio/light/tcs3472.c                               | 4 +---
>  drivers/iio/light/tsl2563.c                               | 4 +---
>  drivers/iio/light/tsl2583.c                               | 4 +---
>  drivers/iio/light/tsl4531.c                               | 4 +---
>  drivers/iio/light/us5182d.c                               | 4 +---
>  drivers/iio/light/vcnl4000.c                              | 4 +---
>  drivers/iio/light/vcnl4035.c                              | 4 +---
>  drivers/iio/light/veml6070.c                              | 4 +---
>  drivers/iio/magnetometer/ak8974.c                         | 4 +---
>  drivers/iio/magnetometer/ak8975.c                         | 4 +---
>  drivers/iio/magnetometer/bmc150_magn_i2c.c                | 4 +---
>  drivers/iio/magnetometer/hmc5843_i2c.c                    | 4 +---
>  drivers/iio/magnetometer/mag3110.c                        | 4 +---
>  drivers/iio/magnetometer/yamaha-yas530.c                  | 4 +---
>  drivers/iio/potentiostat/lmp91000.c                       | 4 +---
>  drivers/iio/pressure/mpl3115.c                            | 4 +---
>  drivers/iio/pressure/ms5611_i2c.c                         | 4 +---
>  drivers/iio/pressure/zpa2326_i2c.c                        | 4 +---
>  drivers/iio/proximity/pulsedlight-lidar-lite-v2.c         | 4 +---
>  drivers/iio/proximity/sx9500.c                            | 4 +---
>  drivers/iio/temperature/mlx90614.c                        | 4 +---
>  drivers/iio/temperature/mlx90632.c                        | 4 +---
>  drivers/input/joystick/as5011.c                           | 4 +---
>  drivers/input/keyboard/adp5588-keys.c                     | 4 +---
>  drivers/input/keyboard/lm8323.c                           | 4 +---
>  drivers/input/keyboard/lm8333.c                           | 4 +---
>  drivers/input/keyboard/mcs_touchkey.c                     | 4 +---
>  drivers/input/keyboard/qt1070.c                           | 4 +---
>  drivers/input/keyboard/qt2160.c                           | 4 +---
>  drivers/input/keyboard/tca6416-keypad.c                   | 4 +---
>  drivers/input/misc/adxl34x-i2c.c                          | 4 +---
>  drivers/input/misc/bma150.c                               | 4 +---
>  drivers/input/misc/cma3000_d0x_i2c.c                      | 4 +---
>  drivers/input/misc/pcf8574_keypad.c                       | 4 +---
>  drivers/input/mouse/synaptics_i2c.c                       | 4 +---
>  drivers/input/rmi4/rmi_smbus.c                            | 4 +---
>  drivers/input/touchscreen/atmel_mxt_ts.c                  | 4 +---
>  drivers/input/touchscreen/bu21013_ts.c                    | 4 +---
>  drivers/input/touchscreen/cyttsp4_i2c.c                   | 4 +---
>  drivers/input/touchscreen/edt-ft5x06.c                    | 4 +---
>  drivers/input/touchscreen/goodix.c                        | 4 +---
>  drivers/input/touchscreen/migor_ts.c                      | 4 +---
>  drivers/input/touchscreen/s6sy761.c                       | 4 +---
>  drivers/input/touchscreen/stmfts.c                        | 4 +---
>  drivers/input/touchscreen/tsc2004.c                       | 4 +---
>  drivers/leds/flash/leds-as3645a.c                         | 4 +---
>  drivers/leds/flash/leds-lm3601x.c                         | 4 +---
>  drivers/leds/flash/leds-rt4505.c                          | 3 +--
>  drivers/leds/leds-an30259a.c                              | 4 +---
>  drivers/leds/leds-aw2013.c                                | 4 +---
>  drivers/leds/leds-bd2802.c                                | 4 +---
>  drivers/leds/leds-blinkm.c                                | 3 +--
>  drivers/leds/leds-is31fl319x.c                            | 3 +--
>  drivers/leds/leds-is31fl32xx.c                            | 4 +---
>  drivers/leds/leds-lm3530.c                                | 3 +--
>  drivers/leds/leds-lm3532.c                                | 4 +---
>  drivers/leds/leds-lm355x.c                                | 4 +---
>  drivers/leds/leds-lm3642.c                                | 3 +--
>  drivers/leds/leds-lm3692x.c                               | 4 +---
>  drivers/leds/leds-lm3697.c                                | 4 +---
>  drivers/leds/leds-lp3944.c                                | 4 +---
>  drivers/leds/leds-lp3952.c                                | 4 +---
>  drivers/leds/leds-lp50xx.c                                | 4 +---
>  drivers/leds/leds-lp5521.c                                | 4 +---
>  drivers/leds/leds-lp5523.c                                | 4 +---
>  drivers/leds/leds-lp5562.c                                | 4 +---
>  drivers/leds/leds-lp8501.c                                | 4 +---
>  drivers/leds/leds-lp8860.c                                | 4 +---
>  drivers/leds/leds-pca9532.c                               | 6 ++----
>  drivers/leds/leds-tca6507.c                               | 4 +---
>  drivers/leds/leds-turris-omnia.c                          | 4 +---
>  drivers/macintosh/ams/ams-i2c.c                           | 4 +---
>  drivers/macintosh/therm_adt746x.c                         | 4 +---
>  drivers/macintosh/therm_windtunnel.c                      | 4 +---
>  drivers/macintosh/windfarm_ad7417_sensor.c                | 4 +---
>  drivers/macintosh/windfarm_fcu_controls.c                 | 3 +--
>  drivers/macintosh/windfarm_lm75_sensor.c                  | 4 +---
>  drivers/macintosh/windfarm_lm87_sensor.c                  | 4 +---
>  drivers/macintosh/windfarm_max6690_sensor.c               | 4 +---
>  drivers/macintosh/windfarm_smu_sat.c                      | 4 +---
>  drivers/media/cec/i2c/ch7322.c                            | 4 +---
>  drivers/media/dvb-frontends/a8293.c                       | 3 +--
>  drivers/media/dvb-frontends/af9013.c                      | 4 +---
>  drivers/media/dvb-frontends/af9033.c                      | 4 +---
>  drivers/media/dvb-frontends/au8522_decoder.c              | 3 +--
>  drivers/media/dvb-frontends/cxd2099.c                     | 4 +---
>  drivers/media/dvb-frontends/cxd2820r_core.c               | 4 +---
>  drivers/media/dvb-frontends/dvb-pll.c                     | 3 +--
>  drivers/media/dvb-frontends/lgdt3306a.c                   | 4 +---
>  drivers/media/dvb-frontends/lgdt330x.c                    | 4 +---
>  drivers/media/dvb-frontends/m88ds3103.c                   | 3 +--
>  drivers/media/dvb-frontends/mn88443x.c                    | 4 +---
>  drivers/media/dvb-frontends/mn88472.c                     | 4 +---
>  drivers/media/dvb-frontends/mn88473.c                     | 4 +---
>  drivers/media/dvb-frontends/mxl692.c                      | 4 +---
>  drivers/media/dvb-frontends/rtl2830.c                     | 4 +---
>  drivers/media/dvb-frontends/rtl2832.c                     | 4 +---
>  drivers/media/dvb-frontends/si2165.c                      | 3 +--
>  drivers/media/dvb-frontends/si2168.c                      | 4 +---
>  drivers/media/dvb-frontends/sp2.c                         | 3 +--
>  drivers/media/dvb-frontends/stv090x.c                     | 3 +--
>  drivers/media/dvb-frontends/stv6110x.c                    | 3 +--
>  drivers/media/dvb-frontends/tc90522.c                     | 3 +--
>  drivers/media/dvb-frontends/tda10071.c                    | 3 +--
>  drivers/media/dvb-frontends/ts2020.c                      | 3 +--
>  drivers/media/i2c/ad5820.c                                | 3 +--
>  drivers/media/i2c/ad9389b.c                               | 3 +--
>  drivers/media/i2c/adp1653.c                               | 4 +---
>  drivers/media/i2c/adv7170.c                               | 3 +--
>  drivers/media/i2c/adv7175.c                               | 3 +--
>  drivers/media/i2c/adv7180.c                               | 4 +---
>  drivers/media/i2c/adv7183.c                               | 3 +--
>  drivers/media/i2c/adv7343.c                               | 4 +---
>  drivers/media/i2c/adv7393.c                               | 4 +---
>  drivers/media/i2c/adv748x/adv748x-core.c                  | 4 +---
>  drivers/media/i2c/adv7511-v4l2.c                          | 3 +--
>  drivers/media/i2c/adv7604.c                               | 3 +--
>  drivers/media/i2c/adv7842.c                               | 3 +--
>  drivers/media/i2c/ak7375.c                                | 4 +---
>  drivers/media/i2c/ak881x.c                                | 4 +---
>  drivers/media/i2c/bt819.c                                 | 3 +--
>  drivers/media/i2c/bt856.c                                 | 3 +--
>  drivers/media/i2c/bt866.c                                 | 3 +--
>  drivers/media/i2c/ccs/ccs-core.c                          | 4 +---
>  drivers/media/i2c/cs3308.c                                | 3 +--
>  drivers/media/i2c/cs5345.c                                | 3 +--
>  drivers/media/i2c/cs53l32a.c                              | 3 +--
>  drivers/media/i2c/cx25840/cx25840-core.c                  | 3 +--
>  drivers/media/i2c/dw9714.c                                | 4 +---
>  drivers/media/i2c/dw9768.c                                | 4 +---
>  drivers/media/i2c/dw9807-vcm.c                            | 4 +---
>  drivers/media/i2c/et8ek8/et8ek8_driver.c                  | 4 +---
>  drivers/media/i2c/hi556.c                                 | 4 +---
>  drivers/media/i2c/hi846.c                                 | 4 +---
>  drivers/media/i2c/hi847.c                                 | 4 +---
>  drivers/media/i2c/imx208.c                                | 4 +---
>  drivers/media/i2c/imx214.c                                | 4 +---
>  drivers/media/i2c/imx219.c                                | 4 +---
>  drivers/media/i2c/imx258.c                                | 4 +---
>  drivers/media/i2c/imx274.c                                | 3 +--
>  drivers/media/i2c/imx290.c                                | 4 +---
>  drivers/media/i2c/imx319.c                                | 4 +---
>  drivers/media/i2c/imx334.c                                | 4 +---
>  drivers/media/i2c/imx335.c                                | 4 +---
>  drivers/media/i2c/imx355.c                                | 4 +---
>  drivers/media/i2c/imx412.c                                | 4 +---
>  drivers/media/i2c/ir-kbd-i2c.c                            | 4 +---
>  drivers/media/i2c/isl7998x.c                              | 4 +---
>  drivers/media/i2c/ks0127.c                                | 3 +--
>  drivers/media/i2c/lm3560.c                                | 4 +---
>  drivers/media/i2c/lm3646.c                                | 4 +---
>  drivers/media/i2c/m52790.c                                | 3 +--
>  drivers/media/i2c/m5mols/m5mols_core.c                    | 4 +---
>  drivers/media/i2c/max2175.c                               | 4 +---
>  drivers/media/i2c/max9286.c                               | 4 +---
>  drivers/media/i2c/ml86v7667.c                             | 4 +---
>  drivers/media/i2c/msp3400-driver.c                        | 3 +--
>  drivers/media/i2c/mt9m001.c                               | 4 +---
>  drivers/media/i2c/mt9m032.c                               | 3 +--
>  drivers/media/i2c/mt9m111.c                               | 4 +---
>  drivers/media/i2c/mt9p031.c                               | 4 +---
>  drivers/media/i2c/mt9t001.c                               | 3 +--
>  drivers/media/i2c/mt9t112.c                               | 4 +---
>  drivers/media/i2c/mt9v011.c                               | 4 +---
>  drivers/media/i2c/mt9v032.c                               | 4 +---
>  drivers/media/i2c/mt9v111.c                               | 4 +---
>  drivers/media/i2c/noon010pc30.c                           | 4 +---
>  drivers/media/i2c/og01a1b.c                               | 4 +---
>  drivers/media/i2c/ov02a10.c                               | 4 +---
>  drivers/media/i2c/ov08d10.c                               | 4 +---
>  drivers/media/i2c/ov13858.c                               | 4 +---
>  drivers/media/i2c/ov13b10.c                               | 4 +---
>  drivers/media/i2c/ov2640.c                                | 3 +--
>  drivers/media/i2c/ov2659.c                                | 4 +---
>  drivers/media/i2c/ov2680.c                                | 4 +---
>  drivers/media/i2c/ov2685.c                                | 4 +---
>  drivers/media/i2c/ov2740.c                                | 4 +---
>  drivers/media/i2c/ov5640.c                                | 4 +---
>  drivers/media/i2c/ov5645.c                                | 4 +---
>  drivers/media/i2c/ov5647.c                                | 4 +---
>  drivers/media/i2c/ov5648.c                                | 4 +---
>  drivers/media/i2c/ov5670.c                                | 4 +---
>  drivers/media/i2c/ov5675.c                                | 4 +---
>  drivers/media/i2c/ov5693.c                                | 4 +---
>  drivers/media/i2c/ov5695.c                                | 4 +---
>  drivers/media/i2c/ov6650.c                                | 3 +--
>  drivers/media/i2c/ov7251.c                                | 4 +---
>  drivers/media/i2c/ov7640.c                                | 4 +---
>  drivers/media/i2c/ov7670.c                                | 3 +--
>  drivers/media/i2c/ov772x.c                                | 4 +---
>  drivers/media/i2c/ov7740.c                                | 3 +--
>  drivers/media/i2c/ov8856.c                                | 4 +---
>  drivers/media/i2c/ov8865.c                                | 4 +---
>  drivers/media/i2c/ov9282.c                                | 4 +---
>  drivers/media/i2c/ov9640.c                                | 4 +---
>  drivers/media/i2c/ov9650.c                                | 4 +---
>  drivers/media/i2c/ov9734.c                                | 4 +---
>  drivers/media/i2c/rdacm20.c                               | 4 +---
>  drivers/media/i2c/rdacm21.c                               | 4 +---
>  drivers/media/i2c/rj54n1cb0c.c                            | 4 +---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c                  | 4 +---
>  drivers/media/i2c/s5k4ecgx.c                              | 4 +---
>  drivers/media/i2c/s5k5baf.c                               | 4 +---
>  drivers/media/i2c/s5k6a3.c                                | 3 +--
>  drivers/media/i2c/s5k6aa.c                                | 4 +---
>  drivers/media/i2c/saa6588.c                               | 4 +---
>  drivers/media/i2c/saa6752hs.c                             | 3 +--
>  drivers/media/i2c/saa7110.c                               | 3 +--
>  drivers/media/i2c/saa7115.c                               | 3 +--
>  drivers/media/i2c/saa7127.c                               | 3 +--
>  drivers/media/i2c/saa717x.c                               | 3 +--
>  drivers/media/i2c/saa7185.c                               | 3 +--
>  drivers/media/i2c/sony-btf-mpx.c                          | 4 +---
>  drivers/media/i2c/sr030pc30.c                             | 3 +--
>  drivers/media/i2c/st-mipid02.c                            | 4 +---
>  drivers/media/i2c/tc358743.c                              | 4 +---
>  drivers/media/i2c/tda1997x.c                              | 4 +---
>  drivers/media/i2c/tda7432.c                               | 3 +--
>  drivers/media/i2c/tda9840.c                               | 3 +--
>  drivers/media/i2c/tea6415c.c                              | 3 +--
>  drivers/media/i2c/tea6420.c                               | 3 +--
>  drivers/media/i2c/ths7303.c                               | 4 +---
>  drivers/media/i2c/ths8200.c                               | 4 +---
>  drivers/media/i2c/tlv320aic23b.c                          | 3 +--
>  drivers/media/i2c/tvaudio.c                               | 3 +--
>  drivers/media/i2c/tvp514x.c                               | 3 +--
>  drivers/media/i2c/tvp5150.c                               | 4 +---
>  drivers/media/i2c/tvp7002.c                               | 3 +--
>  drivers/media/i2c/tw2804.c                                | 3 +--
>  drivers/media/i2c/tw9903.c                                | 3 +--
>  drivers/media/i2c/tw9906.c                                | 3 +--
>  drivers/media/i2c/tw9910.c                                | 4 +---
>  drivers/media/i2c/uda1342.c                               | 3 +--
>  drivers/media/i2c/upd64031a.c                             | 3 +--
>  drivers/media/i2c/upd64083.c                              | 3 +--
>  drivers/media/i2c/video-i2c.c                             | 4 +---
>  drivers/media/i2c/vp27smpx.c                              | 3 +--
>  drivers/media/i2c/vpx3220.c                               | 4 +---
>  drivers/media/i2c/vs6624.c                                | 3 +--
>  drivers/media/i2c/wm8739.c                                | 3 +--
>  drivers/media/i2c/wm8775.c                                | 3 +--
>  drivers/media/radio/radio-tea5764.c                       | 3 +--
>  drivers/media/radio/saa7706h.c                            | 3 +--
>  drivers/media/radio/si470x/radio-si470x-i2c.c             | 3 +--
>  drivers/media/radio/si4713/si4713.c                       | 4 +---
>  drivers/media/radio/tef6862.c                             | 3 +--
>  drivers/media/test-drivers/vidtv/vidtv_demod.c            | 4 +---
>  drivers/media/test-drivers/vidtv/vidtv_tuner.c            | 4 +---
>  drivers/media/tuners/e4000.c                              | 4 +---
>  drivers/media/tuners/fc2580.c                             | 3 +--
>  drivers/media/tuners/m88rs6000t.c                         | 4 +---
>  drivers/media/tuners/mt2060.c                             | 4 +---
>  drivers/media/tuners/mxl301rf.c                           | 3 +--
>  drivers/media/tuners/qm1d1b0004.c                         | 3 +--
>  drivers/media/tuners/qm1d1c0042.c                         | 3 +--
>  drivers/media/tuners/si2157.c                             | 4 +---
>  drivers/media/tuners/tda18212.c                           | 4 +---
>  drivers/media/tuners/tda18250.c                           | 4 +---
>  drivers/media/tuners/tua9001.c                            | 3 +--
>  drivers/media/usb/go7007/s2250-board.c                    | 3 +--
>  drivers/media/v4l2-core/tuner-core.c                      | 3 +--
>  drivers/mfd/88pm800.c                                     | 4 +---
>  drivers/mfd/88pm805.c                                     | 4 +---
>  drivers/mfd/88pm860x-core.c                               | 3 +--
>  drivers/mfd/acer-ec-a500.c                                | 4 +---
>  drivers/mfd/arizona-i2c.c                                 | 4 +---
>  drivers/mfd/axp20x-i2c.c                                  | 4 +---
>  drivers/mfd/da903x.c                                      | 3 +--
>  drivers/mfd/da9052-i2c.c                                  | 3 +--
>  drivers/mfd/da9055-i2c.c                                  | 4 +---
>  drivers/mfd/da9062-core.c                                 | 4 +---
>  drivers/mfd/da9150-core.c                                 | 4 +---
>  drivers/mfd/dm355evm_msp.c                                | 3 +--
>  drivers/mfd/ene-kb3930.c                                  | 4 +---
>  drivers/mfd/gateworks-gsc.c                               | 4 +---
>  drivers/mfd/intel_soc_pmic_core.c                         | 4 +---
>  drivers/mfd/iqs62x.c                                      | 4 +---
>  drivers/mfd/lm3533-core.c                                 | 4 +---
>  drivers/mfd/lp8788.c                                      | 3 +--
>  drivers/mfd/madera-i2c.c                                  | 4 +---
>  drivers/mfd/max14577.c                                    | 4 +---
>  drivers/mfd/max77693.c                                    | 4 +---
>  drivers/mfd/max8907.c                                     | 4 +---
>  drivers/mfd/max8925-i2c.c                                 | 3 +--
>  drivers/mfd/mc13xxx-i2c.c                                 | 3 +--
>  drivers/mfd/menelaus.c                                    | 3 +--
>  drivers/mfd/ntxec.c                                       | 4 +---
>  drivers/mfd/palmas.c                                      | 4 +---
>  drivers/mfd/pcf50633-core.c                               | 4 +---
>  drivers/mfd/retu-mfd.c                                    | 4 +---
>  drivers/mfd/rk808.c                                       | 4 +---
>  drivers/mfd/rn5t618.c                                     | 4 +---
>  drivers/mfd/rsmu_i2c.c                                    | 4 +---
>  drivers/mfd/rt4831.c                                      | 4 +---
>  drivers/mfd/si476x-i2c.c                                  | 4 +---
>  drivers/mfd/stmfx.c                                       | 4 +---
>  drivers/mfd/stmpe-i2c.c                                   | 4 +---
>  drivers/mfd/tc3589x.c                                     | 4 +---
>  drivers/mfd/tps6105x.c                                    | 4 +---
>  drivers/mfd/tps65010.c                                    | 3 +--
>  drivers/mfd/tps65086.c                                    | 4 +---
>  drivers/mfd/tps65217.c                                    | 4 +---
>  drivers/mfd/tps6586x.c                                    | 3 +--
>  drivers/mfd/tps65912-i2c.c                                | 4 +---
>  drivers/mfd/twl-core.c                                    | 3 +--
>  drivers/mfd/twl6040.c                                     | 4 +---
>  drivers/mfd/wm8994-core.c                                 | 4 +---
>  drivers/misc/ad525x_dpot-i2c.c                            | 3 +--
>  drivers/misc/apds9802als.c                                | 3 +--
>  drivers/misc/apds990x.c                                   | 3 +--
>  drivers/misc/bh1770glc.c                                  | 4 +---
>  drivers/misc/ds1682.c                                     | 3 +--
>  drivers/misc/eeprom/at24.c                                | 4 +---
>  drivers/misc/eeprom/ee1004.c                              | 4 +---
>  drivers/misc/eeprom/eeprom.c                              | 4 +---
>  drivers/misc/eeprom/idt_89hpesx.c                         | 4 +---
>  drivers/misc/eeprom/max6875.c                             | 4 +---
>  drivers/misc/hmc6352.c                                    | 3 +--
>  drivers/misc/ics932s401.c                                 | 5 ++---
>  drivers/misc/isl29003.c                                   | 3 +--
>  drivers/misc/isl29020.c                                   | 3 +--
>  drivers/misc/lis3lv02d/lis3lv02d_i2c.c                    | 3 +--
>  drivers/misc/tsl2550.c                                    | 4 +---
>  drivers/mtd/maps/pismo.c                                  | 4 +---
>  drivers/net/dsa/lan9303_i2c.c                             | 6 ++----
>  drivers/net/dsa/microchip/ksz9477_i2c.c                   | 4 +---
>  drivers/net/dsa/xrs700x/xrs700x_i2c.c                     | 6 ++----
>  drivers/net/ethernet/mellanox/mlxsw/i2c.c                 | 4 +---
>  drivers/net/mctp/mctp-i2c.c                               | 3 +--
>  drivers/nfc/fdp/i2c.c                                     | 4 +---
>  drivers/nfc/microread/i2c.c                               | 4 +---
>  drivers/nfc/nfcmrvl/i2c.c                                 | 4 +---
>  drivers/nfc/nxp-nci/i2c.c                                 | 4 +---
>  drivers/nfc/pn533/i2c.c                                   | 4 +---
>  drivers/nfc/pn544/i2c.c                                   | 4 +---
>  drivers/nfc/s3fwrn5/i2c.c                                 | 4 +---
>  drivers/nfc/st-nci/i2c.c                                  | 4 +---
>  drivers/nfc/st21nfca/i2c.c                                | 4 +---
>  drivers/of/unittest.c                                     | 6 ++----
>  drivers/platform/chrome/cros_ec_i2c.c                     | 4 +---
>  drivers/platform/surface/surface3_power.c                 | 4 +---
>  drivers/platform/x86/asus-tf103c-dock.c                   | 4 +---
>  drivers/platform/x86/intel/int3472/tps68470.c             | 4 +---
>  drivers/power/supply/bq2415x_charger.c                    | 4 +---
>  drivers/power/supply/bq24190_charger.c                    | 4 +---
>  drivers/power/supply/bq24257_charger.c                    | 4 +---
>  drivers/power/supply/bq25890_charger.c                    | 4 +---
>  drivers/power/supply/bq27xxx_battery_i2c.c                | 4 +---
>  drivers/power/supply/cw2015_battery.c                     | 3 +--
>  drivers/power/supply/ds2782_battery.c                     | 4 +---
>  drivers/power/supply/lp8727_charger.c                     | 3 +--
>  drivers/power/supply/rt5033_battery.c                     | 4 +---
>  drivers/power/supply/rt9455_charger.c                     | 4 +---
>  drivers/power/supply/smb347-charger.c                     | 4 +---
>  drivers/power/supply/z2_battery.c                         | 4 +---
>  drivers/pwm/pwm-pca9685.c                                 | 4 +---
>  drivers/regulator/da9121-regulator.c                      | 3 +--
>  drivers/regulator/lp8755.c                                | 4 +---
>  drivers/regulator/rpi-panel-attiny-regulator.c            | 4 +---
>  drivers/rtc/rtc-bq32k.c                                   | 4 +---
>  drivers/rtc/rtc-ds1374.c                                  | 4 +---
>  drivers/rtc/rtc-isl12026.c                                | 3 +--
>  drivers/rtc/rtc-m41t80.c                                  | 4 +---
>  drivers/rtc/rtc-rs5c372.c                                 | 3 +--
>  drivers/rtc/rtc-x1205.c                                   | 3 +--
>  drivers/staging/media/atomisp/i2c/atomisp-gc0310.c        | 4 +---
>  drivers/staging/media/atomisp/i2c/atomisp-gc2235.c        | 4 +---
>  drivers/staging/media/atomisp/i2c/atomisp-lm3554.c        | 4 +---
>  drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c       | 3 +--
>  drivers/staging/media/atomisp/i2c/atomisp-ov2680.c        | 4 +---
>  drivers/staging/media/atomisp/i2c/atomisp-ov2722.c        | 4 +---
>  drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c | 4 +---
>  drivers/staging/media/max96712/max96712.c                 | 4 +---
>  drivers/staging/most/i2c/i2c.c                            | 4 +---
>  drivers/staging/olpc_dcon/olpc_dcon.c                     | 4 +---
>  drivers/tty/serial/sc16is7xx.c                            | 4 +---
>  drivers/usb/misc/usb3503.c                                | 4 +---
>  drivers/usb/phy/phy-isp1301-omap.c                        | 4 +---
>  drivers/usb/phy/phy-isp1301.c                             | 4 +---
>  drivers/usb/typec/hd3ss3220.c                             | 4 +---
>  drivers/usb/typec/mux/fsa4480.c                           | 4 +---
>  drivers/usb/typec/mux/pi3usb30532.c                       | 3 +--
>  drivers/usb/typec/rt1719.c                                | 4 +---
>  drivers/usb/typec/stusb160x.c                             | 4 +---
>  drivers/usb/typec/tcpm/fusb302.c                          | 4 +---
>  drivers/usb/typec/tcpm/tcpci.c                            | 4 +---
>  drivers/usb/typec/tcpm/tcpci_maxim.c                      | 4 +---
>  drivers/usb/typec/tcpm/tcpci_rt1711h.c                    | 3 +--
>  drivers/usb/typec/tipd/core.c                             | 4 +---
>  drivers/usb/typec/ucsi/ucsi_ccg.c                         | 4 +---
>  drivers/usb/typec/wusb3801.c                              | 4 +---
>  drivers/video/backlight/adp8860_bl.c                      | 4 +---
>  drivers/video/backlight/adp8870_bl.c                      | 4 +---
>  drivers/video/backlight/arcxcnn_bl.c                      | 4 +---
>  drivers/video/backlight/bd6107.c                          | 4 +---
>  drivers/video/backlight/lm3630a_bl.c                      | 3 +--
>  drivers/video/backlight/lm3639_bl.c                       | 3 +--
>  drivers/video/backlight/lp855x_bl.c                       | 4 +---
>  drivers/video/backlight/lv5207lp.c                        | 4 +---
>  drivers/video/backlight/tosa_bl.c                         | 3 +--
>  drivers/video/fbdev/matrox/matroxfb_maven.c               | 3 +--
>  drivers/video/fbdev/ssd1307fb.c                           | 4 +---
>  drivers/w1/masters/ds2482.c                               | 3 +--
>  drivers/watchdog/ziirave_wdt.c                            | 4 +---
>  include/linux/i2c.h                                       | 2 +-
>  lib/Kconfig.kasan                                         | 1 +
>  sound/aoa/codecs/onyx.c                                   | 3 +--
>  sound/aoa/codecs/tas.c                                    | 3 +--
>  sound/pci/hda/cs35l41_hda_i2c.c                           | 4 +---
>  sound/ppc/keywest.c                                       | 6 ++----
>  sound/soc/codecs/adau1761-i2c.c                           | 3 +--
>  sound/soc/codecs/adau1781-i2c.c                           | 3 +--
>  sound/soc/codecs/ak4375.c                                 | 4 +---
>  sound/soc/codecs/ak4458.c                                 | 4 +---
>  sound/soc/codecs/ak4641.c                                 | 4 +---
>  sound/soc/codecs/ak5558.c                                 | 4 +---
>  sound/soc/codecs/cs35l32.c                                | 4 +---
>  sound/soc/codecs/cs35l33.c                                | 4 +---
>  sound/soc/codecs/cs35l34.c                                | 4 +---
>  sound/soc/codecs/cs35l35.c                                | 4 +---
>  sound/soc/codecs/cs35l36.c                                | 4 +---
>  sound/soc/codecs/cs35l41-i2c.c                            | 4 +---
>  sound/soc/codecs/cs35l45-i2c.c                            | 4 +---
>  sound/soc/codecs/cs4234.c                                 | 4 +---
>  sound/soc/codecs/cs4265.c                                 | 4 +---
>  sound/soc/codecs/cs4270.c                                 | 4 +---
>  sound/soc/codecs/cs42l42.c                                | 4 +---
>  sound/soc/codecs/cs42l51-i2c.c                            | 4 +---
>  sound/soc/codecs/cs42l56.c                                | 3 +--
>  sound/soc/codecs/cs42xx8-i2c.c                            | 4 +---
>  sound/soc/codecs/cs43130.c                                | 4 +---
>  sound/soc/codecs/cs4349.c                                 | 4 +---
>  sound/soc/codecs/cs53l30.c                                | 4 +---
>  sound/soc/codecs/cx2072x.c                                | 3 +--
>  sound/soc/codecs/max98090.c                               | 4 +---
>  sound/soc/codecs/max9860.c                                | 3 +--
>  sound/soc/codecs/max98927.c                               | 4 +---
>  sound/soc/codecs/mt6660.c                                 | 3 +--
>  sound/soc/codecs/nau8821.c                                | 4 +---
>  sound/soc/codecs/nau8825.c                                | 6 ++----
>  sound/soc/codecs/pcm1789-i2c.c                            | 4 +---
>  sound/soc/codecs/pcm3168a-i2c.c                           | 4 +---
>  sound/soc/codecs/pcm512x-i2c.c                            | 3 +--
>  sound/soc/codecs/rt274.c                                  | 4 +---
>  sound/soc/codecs/rt286.c                                  | 4 +---
>  sound/soc/codecs/rt298.c                                  | 4 +---
>  sound/soc/codecs/rt5616.c                                 | 6 ++----
>  sound/soc/codecs/rt5631.c                                 | 6 ++----
>  sound/soc/codecs/rt5645.c                                 | 4 +---
>  sound/soc/codecs/rt5663.c                                 | 4 +---
>  sound/soc/codecs/rt5670.c                                 | 4 +---
>  sound/soc/codecs/rt5677.c                                 | 4 +---
>  sound/soc/codecs/rt5682-i2c.c                             | 4 +---
>  sound/soc/codecs/rt5682s.c                                | 4 +---
>  sound/soc/codecs/rt9120.c                                 | 3 +--
>  sound/soc/codecs/sgtl5000.c                               | 4 +---
>  sound/soc/codecs/sta350.c                                 | 6 ++----
>  sound/soc/codecs/tas2552.c                                | 3 +--
>  sound/soc/codecs/tas5086.c                                | 6 ++----
>  sound/soc/codecs/tas571x.c                                | 4 +---
>  sound/soc/codecs/tas5805m.c                               | 3 +--
>  sound/soc/codecs/tas6424.c                                | 4 +---
>  sound/soc/codecs/tlv320adc3xxx.c                          | 3 +--
>  sound/soc/codecs/tlv320aic32x4-i2c.c                      | 4 +---
>  sound/soc/codecs/tlv320aic3x-i2c.c                        | 4 +---
>  sound/soc/codecs/tlv320dac33.c                            | 4 +---
>  sound/soc/codecs/wm1250-ev1.c                             | 4 +---
>  sound/soc/codecs/wm2200.c                                 | 4 +---
>  sound/soc/codecs/wm5100.c                                 | 4 +---
>  sound/soc/codecs/wm8804-i2c.c                             | 3 +--
>  sound/soc/codecs/wm8900.c                                 | 6 ++----
>  sound/soc/codecs/wm8903.c                                 | 4 +---
>  sound/soc/codecs/wm8960.c                                 | 6 ++----
>  sound/soc/codecs/wm8962.c                                 | 3 +--
>  sound/soc/codecs/wm8993.c                                 | 4 +---
>  sound/soc/codecs/wm8996.c                                 | 4 +---
>  sound/soc/codecs/wm9081.c                                 | 6 ++----

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

for the drivers I'm involved in development of.

-- 
With Best Regards,
Andy Shevchenko


