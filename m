Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830F77CD7D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbfGaUAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:00:42 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:39563 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaUAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:00:41 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MCGag-1i2EAl44sU-009SDz; Wed, 31 Jul 2019 22:00:02 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] gpio: lpc32xx: allow building on non-lpc32xx targets
Date:   Wed, 31 Jul 2019 21:56:47 +0200
Message-Id: <20190731195713.3150463-6-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:nPvPw9YMOaGoeG2QbL6aN8onQhuRLs7PBsNyvS/8jeZPiB2gXYm
 WBvj7CT/LrcyNxXCQEKzNhWdVnnmj3/03xr+BhLaTsTY+gJMV1XVz9qEE2q+1RAjiL848GO
 3ROgAwuwkP7DloHoG9cMXG3IMfqi20QeI7miijXlSompfK6pMA5NdVHjCuVTSMVNKQMHBQv
 ET5ttUT9J8Urs8rYK1wFQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gPysoRTXsu8=:ez7tYz6ZrTKnZ1oPtqCtmg
 oO0Hqyg8T38hQ03POAmT8MiW64FttY5KCjqVWGK/r1ekR8Rv2ynx4MzliMVdJrRHNI4KWyMjH
 58M9y1TxWf6YLBq8BEahuS1+AkO6hBPCyNXc8UUYb1+rqmqr9YSDzkLPUESlyK7lBpcurBh9J
 hHqMfUfNzY3hFNZ5ch0KJxZP9fCAO3t/qtfY3fSt4OtHgvJY//yWKPe7O3yOXVaY2Rs7EQ26u
 Fjk26HKsrY9t20yCK9YW5SsiD807oDapqJmc8NzKN+q0oth4f2DriZ3zugda8R+T/Vm5ysFnW
 vAJiq6zL8PP6UtQWYCx7Vnsj0gJlh7nfUEi4d8Rq+5r6Diub/Y7LGV3W9woilHpbn1hlKMW7l
 M8UF/nbKRI5SdgwesfA1zlEfFHs5HoiCymGjNLxG0Qp2rFAy++lwaCGliUTNKa2QO3DQbUDkQ
 M5xZDxk/BIxWh1fADMHgsaWeMWW3nYEezVOtSfOS2h+skjoAkAO7HKrTop4tseWsyBY72IW7c
 KaE7LeRGXpW9BNTQkLAYmE9wgJmvz67/+9Kl5OfEGpNKsgaDPc6szjLnyGhW6jht3FTUTEMID
 X/kj42BN3RY/hzSlfv73raCU2Xq0vCJs7YCWr6mYHwiX2jYchEN5NJfoStqIqAx+PVxTyqAW+
 5AJcLpb1KfXvWO8455Tl3pH9h4gTVhLpZBF22a28PG6WIZLG06/Bc8r4f+7hEx/d3Nsb+93ma
 QUIcMpyzg34VAK/EUMiXn3T8xZlYH1Yfx8URtQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses hardwire MMIO addresses instead of the data
that is passed in device tree. Change it over to only
hardcode the register offset values and allow compile-testing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpio/Kconfig        |  8 +++++
 drivers/gpio/Makefile       |  2 +-
 drivers/gpio/gpio-lpc32xx.c | 63 ++++++++++++++++++++++++-------------
 3 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index bb13c266c329..ae86ee963eae 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -311,6 +311,14 @@ config GPIO_LPC18XX
 	  Select this option to enable GPIO driver for
 	  NXP LPC18XX/43XX devices.
 
+config GPIO_LPC32XX
+	tristate "NXP LPC32XX GPIO support"
+	default ARCH_LPC32XX
+	depends on OF_GPIO && (ARCH_LPC32XX || COMPILE_TEST)
+	help
+	  Select this option to enable GPIO driver for
+	  NXP LPC32XX devices.
+
 config GPIO_LYNXPOINT
 	tristate "Intel Lynxpoint GPIO support"
 	depends on ACPI && X86
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index a4e91175c708..87d659ae95eb 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -74,7 +74,7 @@ obj-$(CONFIG_GPIO_LP3943)		+= gpio-lp3943.o
 obj-$(CONFIG_GPIO_LP873X)		+= gpio-lp873x.o
 obj-$(CONFIG_GPIO_LP87565)		+= gpio-lp87565.o
 obj-$(CONFIG_GPIO_LPC18XX)		+= gpio-lpc18xx.o
-obj-$(CONFIG_ARCH_LPC32XX)		+= gpio-lpc32xx.o
+obj-$(CONFIG_GPIO_LPC32XX)		+= gpio-lpc32xx.o
 obj-$(CONFIG_GPIO_LYNXPOINT)		+= gpio-lynxpoint.o
 obj-$(CONFIG_GPIO_MADERA)		+= gpio-madera.o
 obj-$(CONFIG_GPIO_MAX3191X)		+= gpio-max3191x.o
diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 24885b3db3d5..548f7cb69386 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -16,8 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 
-#include <mach/hardware.h>
-#include <mach/platform.h>
+#define _GPREG(x)				(x)
 
 #define LPC32XX_GPIO_P3_INP_STATE		_GPREG(0x000)
 #define LPC32XX_GPIO_P3_OUTP_SET		_GPREG(0x004)
@@ -72,12 +71,12 @@
 #define LPC32XX_GPO_P3_GRP	(LPC32XX_GPI_P3_GRP + LPC32XX_GPI_P3_MAX)
 
 struct gpio_regs {
-	void __iomem *inp_state;
-	void __iomem *outp_state;
-	void __iomem *outp_set;
-	void __iomem *outp_clr;
-	void __iomem *dir_set;
-	void __iomem *dir_clr;
+	unsigned long inp_state;
+	unsigned long outp_state;
+	unsigned long outp_set;
+	unsigned long outp_clr;
+	unsigned long dir_set;
+	unsigned long dir_clr;
 };
 
 /*
@@ -167,14 +166,26 @@ struct lpc32xx_gpio_chip {
 	struct gpio_regs	*gpio_grp;
 };
 
+void __iomem *gpio_reg_base;
+
+static inline u32 gpreg_read(unsigned long offset)
+{
+	return __raw_readl(gpio_reg_base + offset);
+}
+
+static inline void gpreg_write(u32 val, unsigned long offset)
+{
+	__raw_writel(val, gpio_reg_base + offset);
+}
+
 static void __set_gpio_dir_p012(struct lpc32xx_gpio_chip *group,
 	unsigned pin, int input)
 {
 	if (input)
-		__raw_writel(GPIO012_PIN_TO_BIT(pin),
+		gpreg_write(GPIO012_PIN_TO_BIT(pin),
 			group->gpio_grp->dir_clr);
 	else
-		__raw_writel(GPIO012_PIN_TO_BIT(pin),
+		gpreg_write(GPIO012_PIN_TO_BIT(pin),
 			group->gpio_grp->dir_set);
 }
 
@@ -184,19 +195,19 @@ static void __set_gpio_dir_p3(struct lpc32xx_gpio_chip *group,
 	u32 u = GPIO3_PIN_TO_BIT(pin);
 
 	if (input)
-		__raw_writel(u, group->gpio_grp->dir_clr);
+		gpreg_write(u, group->gpio_grp->dir_clr);
 	else
-		__raw_writel(u, group->gpio_grp->dir_set);
+		gpreg_write(u, group->gpio_grp->dir_set);
 }
 
 static void __set_gpio_level_p012(struct lpc32xx_gpio_chip *group,
 	unsigned pin, int high)
 {
 	if (high)
-		__raw_writel(GPIO012_PIN_TO_BIT(pin),
+		gpreg_write(GPIO012_PIN_TO_BIT(pin),
 			group->gpio_grp->outp_set);
 	else
-		__raw_writel(GPIO012_PIN_TO_BIT(pin),
+		gpreg_write(GPIO012_PIN_TO_BIT(pin),
 			group->gpio_grp->outp_clr);
 }
 
@@ -206,31 +217,31 @@ static void __set_gpio_level_p3(struct lpc32xx_gpio_chip *group,
 	u32 u = GPIO3_PIN_TO_BIT(pin);
 
 	if (high)
-		__raw_writel(u, group->gpio_grp->outp_set);
+		gpreg_write(u, group->gpio_grp->outp_set);
 	else
-		__raw_writel(u, group->gpio_grp->outp_clr);
+		gpreg_write(u, group->gpio_grp->outp_clr);
 }
 
 static void __set_gpo_level_p3(struct lpc32xx_gpio_chip *group,
 	unsigned pin, int high)
 {
 	if (high)
-		__raw_writel(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_set);
+		gpreg_write(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_set);
 	else
-		__raw_writel(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_clr);
+		gpreg_write(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_clr);
 }
 
 static int __get_gpio_state_p012(struct lpc32xx_gpio_chip *group,
 	unsigned pin)
 {
-	return GPIO012_PIN_IN_SEL(__raw_readl(group->gpio_grp->inp_state),
+	return GPIO012_PIN_IN_SEL(gpreg_read(group->gpio_grp->inp_state),
 		pin);
 }
 
 static int __get_gpio_state_p3(struct lpc32xx_gpio_chip *group,
 	unsigned pin)
 {
-	int state = __raw_readl(group->gpio_grp->inp_state);
+	int state = gpreg_read(group->gpio_grp->inp_state);
 
 	/*
 	 * P3 GPIO pin input mapping is not contiguous, GPIOP3-0..4 is mapped
@@ -242,13 +253,13 @@ static int __get_gpio_state_p3(struct lpc32xx_gpio_chip *group,
 static int __get_gpi_state_p3(struct lpc32xx_gpio_chip *group,
 	unsigned pin)
 {
-	return GPI3_PIN_IN_SEL(__raw_readl(group->gpio_grp->inp_state), pin);
+	return GPI3_PIN_IN_SEL(gpreg_read(group->gpio_grp->inp_state), pin);
 }
 
 static int __get_gpo_state_p3(struct lpc32xx_gpio_chip *group,
 	unsigned pin)
 {
-	return GPO3_PIN_IN_SEL(__raw_readl(group->gpio_grp->outp_state), pin);
+	return GPO3_PIN_IN_SEL(gpreg_read(group->gpio_grp->outp_state), pin);
 }
 
 /*
@@ -498,6 +509,10 @@ static int lpc32xx_gpio_probe(struct platform_device *pdev)
 {
 	int i;
 
+	gpio_reg_base = devm_platform_ioremap_resource(pdev, 0);
+	if (gpio_reg_base)
+		return -ENXIO;
+
 	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++) {
 		if (pdev->dev.of_node) {
 			lpc32xx_gpiochip[i].chip.of_xlate = lpc32xx_of_xlate;
@@ -527,3 +542,7 @@ static struct platform_driver lpc32xx_gpio_driver = {
 };
 
 module_platform_driver(lpc32xx_gpio_driver);
+
+MODULE_AUTHOR("Kevin Wells <kevin.wells@nxp.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("GPIO driver for LPC32xx SoC");
-- 
2.20.0

