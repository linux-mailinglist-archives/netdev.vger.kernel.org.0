Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076C368DB00
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjBGO3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBGO3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:29:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6905B1258C;
        Tue,  7 Feb 2023 06:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675780173; x=1707316173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Dq4mU58s7wFVOS4xMQ0zOI9I/hT6Ikw0b7RarExmhA=;
  b=k4wRtOqYylZ0jOf6D5Q3iqoaQx3coK3u4oGxbPZjA6Gngmnz80FH7zrK
   TLDmYhlGIKb8l0wvrTxnEcesRvtV9qCQnqEHHX5kPM+M7IYjaujIc5/bQ
   l7AImczCNaoXb+tFkdvnY8sRhgkCoIMY+WShmvXTx0JxipnxW37tDYIuB
   fu1E7BGzmUZoLo/j4DZNrq/O48VzhJKOe9+1digKvwiUk8qxgT6cXlIrS
   VPWKM+HV+XCol1o2SwFFF1XYK/kRw7af65wCrz4e4UOjJljeeo7zrDBAD
   Qmox7V1HaaH9E18Ubsj8oIALDtl9QRemN5z6u7Aovqt1sQYHbFXmjkuah
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="329537345"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="329537345"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 06:29:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="790811317"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="790811317"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 07 Feb 2023 06:29:28 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4035E252; Tue,  7 Feb 2023 16:30:02 +0200 (EET)
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
Subject: [PATCH v3 02/12] gpiolib: coldfire: remove custom asm/gpio.h
Date:   Tue,  7 Feb 2023 16:29:42 +0200
Message-Id: <20230207142952.51844-3-andriy.shevchenko@linux.intel.com>
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

Now that coldfire is the only user of a custom asm/gpio.h, it seems
better to remove this as well, and have the same interface everywhere.

For the gpio_get_value()/gpio_set_value()/gpio_to_irq(), gpio_cansleep()
functions, the custom version is only a micro-optimization to inline the
function for constant GPIO numbers. However, in the coldfire defconfigs,
I was unable to find a single instance where this micro-optimization
was even used, and according to Geert the only user appears to be the
QSPI chip that is disabled everywhere.

The custom gpio_request_one() function is even less useful, as it is
guarded by an #ifdef that is never true.

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/m68k/Kconfig.cpu        |  1 -
 arch/m68k/include/asm/gpio.h | 95 ------------------------------------
 drivers/gpio/Kconfig         |  8 ---
 include/linux/gpio.h         |  7 ---
 4 files changed, 111 deletions(-)
 delete mode 100644 arch/m68k/include/asm/gpio.h

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 9380f6e3bb66..96a0fb4f1af5 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -24,7 +24,6 @@ config M68KCLASSIC
 
 config COLDFIRE
 	bool "Coldfire CPU family support"
-	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
 	select CPU_HAS_NO_CAS
 	select CPU_HAS_NO_MULDIV64
diff --git a/arch/m68k/include/asm/gpio.h b/arch/m68k/include/asm/gpio.h
deleted file mode 100644
index 5cfc0996ba94..000000000000
--- a/arch/m68k/include/asm/gpio.h
+++ /dev/null
@@ -1,95 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Coldfire generic GPIO support
- *
- * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
-*/
-
-#ifndef coldfire_gpio_h
-#define coldfire_gpio_h
-
-#include <linux/io.h>
-#include <asm/coldfire.h>
-#include <asm/mcfsim.h>
-#include <asm/mcfgpio.h>
-/*
- * The Generic GPIO functions
- *
- * If the gpio is a compile time constant and is one of the Coldfire gpios,
- * use the inline version, otherwise dispatch thru gpiolib.
- */
-
-static inline int gpio_get_value(unsigned gpio)
-{
-	if (__builtin_constant_p(gpio) && gpio < MCFGPIO_PIN_MAX)
-		return mcfgpio_read(__mcfgpio_ppdr(gpio)) & mcfgpio_bit(gpio);
-	else
-		return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	if (__builtin_constant_p(gpio) && gpio < MCFGPIO_PIN_MAX) {
-		if (gpio < MCFGPIO_SCR_START) {
-			unsigned long flags;
-			MCFGPIO_PORTTYPE data;
-
-			local_irq_save(flags);
-			data = mcfgpio_read(__mcfgpio_podr(gpio));
-			if (value)
-				data |= mcfgpio_bit(gpio);
-			else
-				data &= ~mcfgpio_bit(gpio);
-			mcfgpio_write(data, __mcfgpio_podr(gpio));
-			local_irq_restore(flags);
-		} else {
-			if (value)
-				mcfgpio_write(mcfgpio_bit(gpio),
-						MCFGPIO_SETR_PORT(gpio));
-			else
-				mcfgpio_write(~mcfgpio_bit(gpio),
-						MCFGPIO_CLRR_PORT(gpio));
-		}
-	} else
-		__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_to_irq(unsigned gpio)
-{
-#if defined(MCFGPIO_IRQ_MIN)
-	if ((gpio >= MCFGPIO_IRQ_MIN) && (gpio < MCFGPIO_IRQ_MAX))
-#else
-	if (gpio < MCFGPIO_IRQ_MAX)
-#endif
-		return gpio + MCFGPIO_IRQ_VECBASE;
-	else
-		return __gpio_to_irq(gpio);
-}
-
-static inline int gpio_cansleep(unsigned gpio)
-{
-	return gpio < MCFGPIO_PIN_MAX ? 0 : __gpio_cansleep(gpio);
-}
-
-#ifndef CONFIG_GPIOLIB
-static inline int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
-{
-	int err;
-
-	err = gpio_request(gpio, label);
-	if (err)
-		return err;
-
-	if (flags & GPIOF_DIR_IN)
-		err = gpio_direction_input(gpio);
-	else
-		err = gpio_direction_output(gpio,
-			(flags & GPIOF_INIT_HIGH) ? 1 : 0);
-
-	if (err)
-		gpio_free(gpio);
-
-	return err;
-}
-#endif /* !CONFIG_GPIOLIB */
-#endif
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 218d7e4c27ff..06a268d56800 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -3,14 +3,6 @@
 # GPIO infrastructure and drivers
 #
 
-config ARCH_HAVE_CUSTOM_GPIO_H
-	bool
-	help
-	  Selecting this config option from the architecture Kconfig allows
-	  the architecture to provide a custom asm/gpio.h implementation
-	  overriding the default implementations.  New uses of this are
-	  strongly discouraged.
-
 menuconfig GPIOLIB
 	bool "GPIO Support"
 	help
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 85beb236c925..2b75017b3aad 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -54,11 +54,6 @@ struct gpio {
 };
 
 #ifdef CONFIG_GPIOLIB
-
-#ifdef CONFIG_ARCH_HAVE_CUSTOM_GPIO_H
-#include <asm/gpio.h>
-#else
-
 #include <asm-generic/gpio.h>
 
 static inline int gpio_get_value(unsigned int gpio)
@@ -81,8 +76,6 @@ static inline int gpio_to_irq(unsigned int gpio)
 	return __gpio_to_irq(gpio);
 }
 
-#endif /* ! CONFIG_ARCH_HAVE_CUSTOM_GPIO_H */
-
 /* CONFIG_GPIOLIB: bindings for managed devices that want to request gpios */
 
 struct device;
-- 
2.39.1

