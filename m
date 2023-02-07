Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C62168DB26
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjBGOaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjBGO3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:29:42 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EADF15CAE;
        Tue,  7 Feb 2023 06:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675780175; x=1707316175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/KblTEhL3YpOqTWHe101UZEkEjtX7tVjnWOHZilZZaw=;
  b=KcWgvhV5KNzMa1t9Y6gyOACgkXwOMjjhEz/PG8dxkZyFgqTErBnjCxNm
   4dU/ZZC7bz+p62kBGUdCyX86V3Zi2C7AG3mPHi1G5nf4CqYEXipbBYVd6
   RwfwKns/h69b7ady1xzCXjBUMagpaalP7XyehZ5KgP0zoPZBEH4V6T54B
   nnwqn2fKvxMYjFCn1NHk/UxuV/cp0MvSTCCW+VWw6VgfFPiqvJnjPqexl
   zOq4VoDzo7tjfo7XS+mGZEOLRCSxR/eEHELG5n0U109TXbc3JC4zOBF+3
   9NRfsfZtJax9dVGesWXEORBztc7ZmfUpWFQBKUdcDMES63eeuIhpFq0Su
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="391915608"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="391915608"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 06:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="912355032"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="912355032"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2023 06:29:30 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 528AA269; Tue,  7 Feb 2023 16:30:02 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Devarsh Thakkar <devarsht@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
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
        Li Yang <leoyang.li@nxp.com>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v3 03/12] gpiolib: remove asm-generic/gpio.h
Date:   Tue,  7 Feb 2023 16:29:43 +0200
Message-Id: <20230207142952.51844-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com>
References: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The asm-generic/gpio.h file is now always included when
using gpiolib, so just move its contents into linux/gpio.h
with a few minor simplifications.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 MAINTAINERS                     |   1 -
 arch/m68k/include/asm/mcfgpio.h |   2 +-
 drivers/gpio/gpio-davinci.c     |   2 -
 drivers/pinctrl/core.c          |   1 -
 include/asm-generic/gpio.h      | 147 --------------------------------
 include/linux/gpio.h            |  93 ++++++++++++++++++--
 6 files changed, 85 insertions(+), 161 deletions(-)
 delete mode 100644 include/asm-generic/gpio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d6aa8076868..0469de4e5000 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8730,7 +8730,6 @@ F:	Documentation/admin-guide/gpio/
 F:	Documentation/devicetree/bindings/gpio/
 F:	Documentation/driver-api/gpio/
 F:	drivers/gpio/
-F:	include/asm-generic/gpio.h
 F:	include/dt-bindings/gpio/
 F:	include/linux/gpio.h
 F:	include/linux/gpio/
diff --git a/arch/m68k/include/asm/mcfgpio.h b/arch/m68k/include/asm/mcfgpio.h
index 27f32cc81da6..2cefe8445980 100644
--- a/arch/m68k/include/asm/mcfgpio.h
+++ b/arch/m68k/include/asm/mcfgpio.h
@@ -9,7 +9,7 @@
 #define mcfgpio_h
 
 #ifdef CONFIG_GPIOLIB
-#include <asm-generic/gpio.h>
+#include <linux/gpio.h>
 #else
 
 int __mcfgpio_get_value(unsigned gpio);
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 26b1f7465e09..7fc83057990a 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -24,8 +24,6 @@
 #include <linux/spinlock.h>
 #include <linux/pm_runtime.h>
 
-#include <asm-generic/gpio.h>
-
 #define MAX_REGS_BANKS 5
 #define MAX_INT_PER_BANK 32
 
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index d6e6c751255f..401886c81344 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -30,7 +30,6 @@
 
 #ifdef CONFIG_GPIOLIB
 #include "../gpio/gpiolib.h"
-#include <asm-generic/gpio.h>
 #endif
 
 #include "core.h"
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
deleted file mode 100644
index 22cb8c9efc1d..000000000000
--- a/include/asm-generic/gpio.h
+++ /dev/null
@@ -1,147 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_GENERIC_GPIO_H
-#define _ASM_GENERIC_GPIO_H
-
-#include <linux/types.h>
-#include <linux/errno.h>
-
-#ifdef CONFIG_GPIOLIB
-
-#include <linux/compiler.h>
-#include <linux/gpio/driver.h>
-#include <linux/gpio/consumer.h>
-
-/*
- * Platforms may implement their GPIO interface with library code,
- * at a small performance cost for non-inlined operations and some
- * extra memory (for code and for per-GPIO table entries).
- */
-
-/*
- * At the end we want all GPIOs to be dynamically allocated from 0.
- * However, some legacy drivers still perform fixed allocation.
- * Until they are all fixed, leave 0-512 space for them.
- */
-#define GPIO_DYNAMIC_BASE	512
-
-struct device;
-struct gpio;
-struct seq_file;
-struct module;
-struct device_node;
-struct gpio_desc;
-
-/* Always use the library code for GPIO management calls,
- * or when sleeping may be involved.
- */
-extern int gpio_request(unsigned gpio, const char *label);
-extern void gpio_free(unsigned gpio);
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	return gpiod_direction_input(gpio_to_desc(gpio));
-}
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	return gpiod_direction_output_raw(gpio_to_desc(gpio), value);
-}
-
-static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
-{
-	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
-}
-
-static inline int gpio_get_value_cansleep(unsigned gpio)
-{
-	return gpiod_get_raw_value_cansleep(gpio_to_desc(gpio));
-}
-static inline void gpio_set_value_cansleep(unsigned gpio, int value)
-{
-	return gpiod_set_raw_value_cansleep(gpio_to_desc(gpio), value);
-}
-
-
-/* A platform's <asm/gpio.h> code may want to inline the I/O calls when
- * the GPIO is constant and refers to some always-present controller,
- * giving direct access to chip registers and tight bitbanging loops.
- */
-static inline int __gpio_get_value(unsigned gpio)
-{
-	return gpiod_get_raw_value(gpio_to_desc(gpio));
-}
-static inline void __gpio_set_value(unsigned gpio, int value)
-{
-	return gpiod_set_raw_value(gpio_to_desc(gpio), value);
-}
-
-static inline int __gpio_cansleep(unsigned gpio)
-{
-	return gpiod_cansleep(gpio_to_desc(gpio));
-}
-
-static inline int __gpio_to_irq(unsigned gpio)
-{
-	return gpiod_to_irq(gpio_to_desc(gpio));
-}
-
-extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-extern int gpio_request_array(const struct gpio *array, size_t num);
-extern void gpio_free_array(const struct gpio *array, size_t num);
-
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
-#else	/* !CONFIG_GPIOLIB */
-
-#include <linux/kernel.h>
-
-/* platforms that don't directly support access to GPIOs through I2C, SPI,
- * or other blocking infrastructure can use these wrappers.
- */
-
-static inline int gpio_cansleep(unsigned gpio)
-{
-	return 0;
-}
-
-static inline int gpio_get_value_cansleep(unsigned gpio)
-{
-	might_sleep();
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value_cansleep(unsigned gpio, int value)
-{
-	might_sleep();
-	__gpio_set_value(gpio, value);
-}
-
-#endif /* !CONFIG_GPIOLIB */
-
-/*
- * "valid" GPIO numbers are nonnegative and may be passed to
- * setup routines like gpio_request().  only some valid numbers
- * can successfully be requested and used.
- *
- * Invalid GPIO numbers are useful for indicating no-such-GPIO in
- * platform data and other tables.
- */
-
-static inline bool gpio_is_valid(int number)
-{
-	/* only non-negative numbers are valid */
-	return number >= 0;
-}
-
-#endif /* _ASM_GENERIC_GPIO_H */
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 2b75017b3aad..6719a82eeec5 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -54,26 +54,101 @@ struct gpio {
 };
 
 #ifdef CONFIG_GPIOLIB
-#include <asm-generic/gpio.h>
+#include <linux/compiler.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 
-static inline int gpio_get_value(unsigned int gpio)
+/*
+ * "valid" GPIO numbers are nonnegative and may be passed to
+ * setup routines like gpio_request().  Only some valid numbers
+ * can successfully be requested and used.
+ *
+ * Invalid GPIO numbers are useful for indicating no-such-GPIO in
+ * platform data and other tables.
+ */
+static inline bool gpio_is_valid(int number)
+{
+	/* only non-negative numbers are valid */
+	return number >= 0;
+}
+
+/*
+ * Platforms may implement their GPIO interface with library code,
+ * at a small performance cost for non-inlined operations and some
+ * extra memory (for code and for per-GPIO table entries).
+ */
+
+/*
+ * At the end we want all GPIOs to be dynamically allocated from 0.
+ * However, some legacy drivers still perform fixed allocation.
+ * Until they are all fixed, leave 0-512 space for them.
+ */
+#define GPIO_DYNAMIC_BASE	512
+
+/* Always use the library code for GPIO management calls,
+ * or when sleeping may be involved.
+ */
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return gpiod_direction_input(gpio_to_desc(gpio));
+}
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
-	return __gpio_get_value(gpio);
+	return gpiod_direction_output_raw(gpio_to_desc(gpio), value);
 }
 
-static inline void gpio_set_value(unsigned int gpio, int value)
+static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
 {
-	__gpio_set_value(gpio, value);
+	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
 }
 
-static inline int gpio_cansleep(unsigned int gpio)
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	return gpiod_get_raw_value_cansleep(gpio_to_desc(gpio));
+}
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 {
-	return __gpio_cansleep(gpio);
+	return gpiod_set_raw_value_cansleep(gpio_to_desc(gpio), value);
 }
 
-static inline int gpio_to_irq(unsigned int gpio)
+static inline int gpio_get_value(unsigned gpio)
+{
+	return gpiod_get_raw_value(gpio_to_desc(gpio));
+}
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	return gpiod_set_raw_value(gpio_to_desc(gpio), value);
+}
+
+static inline int gpio_cansleep(unsigned gpio)
+{
+	return gpiod_cansleep(gpio_to_desc(gpio));
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return gpiod_to_irq(gpio_to_desc(gpio));
+}
+
+int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+int gpio_request_array(const struct gpio *array, size_t num);
+void gpio_free_array(const struct gpio *array, size_t num);
+
+/*
+ * A sysfs interface can be exported by individual drivers if they want,
+ * but more typically is configured entirely from userspace.
+ */
+static inline int gpio_export(unsigned gpio, bool direction_may_change)
+{
+	return gpiod_export(gpio_to_desc(gpio), direction_may_change);
+}
+
+static inline void gpio_unexport(unsigned gpio)
 {
-	return __gpio_to_irq(gpio);
+	gpiod_unexport(gpio_to_desc(gpio));
 }
 
 /* CONFIG_GPIOLIB: bindings for managed devices that want to request gpios */
-- 
2.39.1

