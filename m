Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF8268F50D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjBHRei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjBHRd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:33:59 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58393251B;
        Wed,  8 Feb 2023 09:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675877635; x=1707413635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O8wgtjnDDH6goWjAVZmuil9qOihxRC2fM6d0IEYsaVE=;
  b=aWfLANu8ZRVdMHEUwbT1v02po+ZbSlWksBg6tmsLW7mj63pJymfVGW4o
   Pi70loo/yzMQ2KiIjqFEQD45Gtc9DDbgvjbKAUvz+cwF54iyY0ozDG9yv
   IRwvVu0OPJVYuACHMS57hOOkdtCvHfiWKBqu9gPXIwZ9EMneRWRwc8eOM
   BQIEJ/O0ci342PJ5ZeCgjOojx6G8lwTUCR4SCwErgaXJGG1qjIssjZCYa
   AsQSWNIB9/Q6p4Cdg7nY4HQyGFlKdBvJd3VVmHwtjqNqRP4C3CRHlu1vI
   FWfRlvq0wNOn0qHWxi7e2INbcNuDK8qFYYwoqiOZuGspMm7WZ8oT8XrgW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="331153826"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="331153826"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 09:33:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="669265866"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="669265866"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 08 Feb 2023 09:33:26 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0F0D3380; Wed,  8 Feb 2023 19:33:48 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Devarsh Thakkar <devarsht@ti.com>,
        Michael Walle <michael@walle.cc>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Lee Jones <lee@kernel.org>, linux-gpio@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v4 09/18] gpiolib: remove legacy gpio_export()
Date:   Wed,  8 Feb 2023 19:33:34 +0200
Message-Id: <20230208173343.37582-10-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com>
References: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are only a handful of users of gpio_export() and
related functions.

As these are just wrappers around the modern gpiod_export()
helper, remove the wrappers and open-code the gpio_to_desc
in all callers to shrink the legacy API.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/admin-guide/gpio/sysfs.rst      |  2 +-
 Documentation/driver-api/gpio/legacy.rst      | 21 ---------------
 .../zh_CN/driver-api/gpio/legacy.rst          | 19 -------------
 Documentation/translations/zh_TW/gpio.txt     | 18 -------------
 arch/arm/mach-omap2/pdata-quirks.c            |  9 ++++---
 arch/sh/boards/mach-ap325rxa/setup.c          |  7 ++---
 drivers/gpio/gpiolib-sysfs.c                  |  4 +--
 drivers/media/pci/sta2x11/sta2x11_vip.c       | 10 ++++---
 drivers/net/ieee802154/ca8210.c               |  3 ++-
 include/linux/gpio.h                          | 27 -------------------
 10 files changed, 21 insertions(+), 99 deletions(-)

diff --git a/Documentation/admin-guide/gpio/sysfs.rst b/Documentation/admin-guide/gpio/sysfs.rst
index ec09ffd983e7..35171d15f78d 100644
--- a/Documentation/admin-guide/gpio/sysfs.rst
+++ b/Documentation/admin-guide/gpio/sysfs.rst
@@ -145,7 +145,7 @@ requested using gpio_request()::
 	/* export the GPIO to userspace */
 	int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
 
-	/* reverse gpio_export() */
+	/* reverse gpiod_export() */
 	void gpiod_unexport(struct gpio_desc *desc);
 
 	/* create a sysfs link to an exported GPIO node */
diff --git a/Documentation/driver-api/gpio/legacy.rst b/Documentation/driver-api/gpio/legacy.rst
index e0306e78e34b..78372853c6d4 100644
--- a/Documentation/driver-api/gpio/legacy.rst
+++ b/Documentation/driver-api/gpio/legacy.rst
@@ -714,27 +714,6 @@ gpiochip nodes (possibly in conjunction with schematics) to determine
 the correct GPIO number to use for a given signal.
 
 
-Exporting from Kernel code
---------------------------
-Kernel code can explicitly manage exports of GPIOs which have already been
-requested using gpio_request()::
-
-	/* export the GPIO to userspace */
-	int gpio_export(unsigned gpio, bool direction_may_change);
-
-	/* reverse gpio_export() */
-	void gpio_unexport();
-
-After a kernel driver requests a GPIO, it may only be made available in
-the sysfs interface by gpio_export().  The driver can control whether the
-signal direction may change.  This helps drivers prevent userspace code
-from accidentally clobbering important system state.
-
-This explicit exporting can help with debugging (by making some kinds
-of experiments easier), or can provide an always-there interface that's
-suitable for documenting as part of a board support package.
-
-
 API Reference
 =============
 
diff --git a/Documentation/translations/zh_CN/driver-api/gpio/legacy.rst b/Documentation/translations/zh_CN/driver-api/gpio/legacy.rst
index dee2a0517c1c..84ce2322fdba 100644
--- a/Documentation/translations/zh_CN/driver-api/gpio/legacy.rst
+++ b/Documentation/translations/zh_CN/driver-api/gpio/legacy.rst
@@ -653,25 +653,6 @@ GPIO 控制器的路径类似 /sys/class/gpio/gpiochip42/ (对于从#42 GPIO
 确定给定信号所用的 GPIO 编号。
 
 
-从内核代码中导出
-----------------
-
-内核代码可以明确地管理那些已通过 gpio_request()申请的 GPIO 的导出::
-
-	/* 导出 GPIO 到用户空间 */
-	int gpio_export(unsigned gpio, bool direction_may_change);
-
-	/* gpio_export()的逆操作 */
-	void gpio_unexport();
-
-在一个内核驱动申请一个 GPIO 之后，它可以通过 gpio_export()使其在 sysfs
-接口中可见。该驱动可以控制信号方向是否可修改。这有助于防止用户空间代码无意间
-破坏重要的系统状态。
-
-这个明确的导出有助于(通过使某些实验更容易来)调试，也可以提供一个始终存在的接口，
-与文档配合作为板级支持包的一部分。
-
-
 API参考
 =======
 
diff --git a/Documentation/translations/zh_TW/gpio.txt b/Documentation/translations/zh_TW/gpio.txt
index dc608358d90a..62e560ffe628 100644
--- a/Documentation/translations/zh_TW/gpio.txt
+++ b/Documentation/translations/zh_TW/gpio.txt
@@ -614,21 +614,3 @@ GPIO 控制器的路徑類似 /sys/class/gpio/gpiochip42/ (對於從#42 GPIO
 固定的,例如在擴展卡上的 GPIO會根據所使用的主板或所在堆疊架構中其他的板子而
 有所不同。在這種情況下,你可能需要使用 gpiochip 節點(儘可能地結合電路圖)來
 確定給定信號所用的 GPIO 編號。
-
-
-從內核代碼中導出
--------------
-內核代碼可以明確地管理那些已通過 gpio_request()申請的 GPIO 的導出:
-
-	/* 導出 GPIO 到用戶空間 */
-	int gpio_export(unsigned gpio, bool direction_may_change);
-
-	/* gpio_export()的逆操作 */
-	void gpio_unexport();
-
-在一個內核驅動申請一個 GPIO 之後，它可以通過 gpio_export()使其在 sysfs
-接口中可見。該驅動可以控制信號方向是否可修改。這有助於防止用戶空間代碼無意間
-破壞重要的系統狀態。
-
-這個明確的導出有助於(通過使某些實驗更容易來)調試，也可以提供一個始終存在的接口，
-與文檔配合作爲板級支持包的一部分。
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index baba73fd6f11..04208cc52784 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -6,6 +6,7 @@
  */
 #include <linux/clk.h>
 #include <linux/davinci_emac.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -108,7 +109,7 @@ static int omap3_sbc_t3730_twl_callback(struct device *dev,
 	if (res)
 		return res;
 
-	gpio_export(gpio, 0);
+	gpiod_export(gpio_to_desc(gpio), 0);
 
 	return 0;
 }
@@ -123,7 +124,7 @@ static void __init omap3_sbc_t3x_usb_hub_init(int gpio, char *hub_name)
 		return;
 	}
 
-	gpio_export(gpio, 0);
+	gpiod_export(gpio_to_desc(gpio), 0);
 
 	udelay(10);
 	gpio_set_value(gpio, 1);
@@ -200,8 +201,8 @@ static void __init omap3_sbc_t3517_wifi_init(void)
 		return;
 	}
 
-	gpio_export(cm_t3517_wlan_gpios[0].gpio, 0);
-	gpio_export(cm_t3517_wlan_gpios[1].gpio, 0);
+	gpiod_export(gpio_to_desc(cm_t3517_wlan_gpios[0].gpio), 0);
+	gpiod_export(gpio_to_desc(cm_t3517_wlan_gpios[1].gpio), 0);
 
 	msleep(100);
 	gpio_set_value(cm_t3517_wlan_gpios[1].gpio, 0);
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index c77b5f00a66a..151792162152 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
@@ -411,16 +412,16 @@ static int __init ap325rxa_devices_setup(void)
 	/* LD3 and LD4 LEDs */
 	gpio_request(GPIO_PTX5, NULL); /* RUN */
 	gpio_direction_output(GPIO_PTX5, 1);
-	gpio_export(GPIO_PTX5, 0);
+	gpiod_export(gpio_to_desc(GPIO_PTX5), 0);
 
 	gpio_request(GPIO_PTX4, NULL); /* INDICATOR */
 	gpio_direction_output(GPIO_PTX4, 0);
-	gpio_export(GPIO_PTX4, 0);
+	gpiod_export(gpio_to_desc(GPIO_PTX4), 0);
 
 	/* SW1 input */
 	gpio_request(GPIO_PTF7, NULL); /* MODE */
 	gpio_direction_input(GPIO_PTF7);
-	gpio_export(GPIO_PTF7, 0);
+	gpiod_export(gpio_to_desc(GPIO_PTF7), 0);
 
 	/* LCDC */
 	gpio_request(GPIO_FN_LCDD15, NULL);
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index cd27bf173dec..6e4267944f80 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -491,7 +491,7 @@ static ssize_t unexport_store(struct class *class,
 		goto done;
 
 	desc = gpio_to_desc(gpio);
-	/* reject bogus commands (gpio_unexport ignores them) */
+	/* reject bogus commands (gpiod_unexport() ignores them) */
 	if (!desc) {
 		pr_warn("%s: invalid GPIO %ld\n", __func__, gpio);
 		return -EINVAL;
@@ -790,7 +790,7 @@ static int __init gpiolib_sysfs_init(void)
 	 * early (e.g. before the class_register above was called).
 	 *
 	 * We run before arch_initcall() so chip->dev nodes can have
-	 * registered, and so arch_initcall() can always gpio_export().
+	 * registered, and so arch_initcall() can always gpiod_export().
 	 */
 	spin_lock_irqsave(&gpio_lock, flags);
 	list_for_each_entry(gdev, &gpio_devices, list) {
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 8535e49a4c4f..e4cf9d63e926 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -18,6 +18,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
@@ -889,6 +890,7 @@ static int sta2x11_vip_init_controls(struct sta2x11_vip *vip)
 static int vip_gpio_reserve(struct device *dev, int pin, int dir,
 			    const char *name)
 {
+	struct gpio_desc *desc = gpio_to_desc(pin);
 	int ret = -ENODEV;
 
 	if (!gpio_is_valid(pin))
@@ -900,7 +902,7 @@ static int vip_gpio_reserve(struct device *dev, int pin, int dir,
 		return ret;
 	}
 
-	ret = gpio_direction_output(pin, dir);
+	ret = gpiod_direction_output(desc, dir);
 	if (ret) {
 		dev_err(dev, "Failed to set direction for pin %d (%s)\n",
 			pin, name);
@@ -908,7 +910,7 @@ static int vip_gpio_reserve(struct device *dev, int pin, int dir,
 		return ret;
 	}
 
-	ret = gpio_export(pin, false);
+	ret = gpiod_export(desc, false);
 	if (ret) {
 		dev_err(dev, "Failed to export pin %d (%s)\n", pin, name);
 		gpio_free(pin);
@@ -928,8 +930,10 @@ static int vip_gpio_reserve(struct device *dev, int pin, int dir,
 static void vip_gpio_release(struct device *dev, int pin, const char *name)
 {
 	if (gpio_is_valid(pin)) {
+		struct gpio_desc *desc = gpio_to_desc(pin);
+
 		dev_dbg(dev, "releasing pin %d (%s)\n",	pin, name);
-		gpio_unexport(pin);
+		gpiod_unexport(desc);
 		gpio_free(pin);
 	}
 }
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index e1a569b99e4a..5c0be6a3ec5e 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -51,6 +51,7 @@
 #include <linux/clk-provider.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio.h>
 #include <linux/ieee802154.h>
 #include <linux/io.h>
@@ -2853,7 +2854,7 @@ static int ca8210_interrupt_init(struct spi_device *spi)
 	);
 	if (ret) {
 		dev_crit(&spi->dev, "request_irq %d failed\n", pdata->irq_id);
-		gpio_unexport(pdata->gpio_irq);
+		gpiod_unexport(gpio_to_desc(pdata->gpio_irq));
 		gpio_free(pdata->gpio_irq);
 	}
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index fc56733e8514..a86953696e47 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -132,20 +132,6 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
 int gpio_request_array(const struct gpio *array, size_t num);
 void gpio_free_array(const struct gpio *array, size_t num);
 
-/*
- * A sysfs interface can be exported by individual drivers if they want,
- * but more typically is configured entirely from userspace.
- */
-static inline int gpio_export(unsigned gpio, bool direction_may_change)
-{
-	return gpiod_export(gpio_to_desc(gpio), direction_may_change);
-}
-
-static inline void gpio_unexport(unsigned gpio)
-{
-	gpiod_unexport(gpio_to_desc(gpio));
-}
-
 /* CONFIG_GPIOLIB: bindings for managed devices that want to request gpios */
 
 struct device;
@@ -242,19 +228,6 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 	WARN_ON(1);
 }
 
-static inline int gpio_export(unsigned gpio, bool direction_may_change)
-{
-	/* GPIO can never have been requested or set as {in,out}put */
-	WARN_ON(1);
-	return -EINVAL;
-}
-
-static inline void gpio_unexport(unsigned gpio)
-{
-	/* GPIO can never have been exported */
-	WARN_ON(1);
-}
-
 static inline int gpio_to_irq(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as input */
-- 
2.39.1

