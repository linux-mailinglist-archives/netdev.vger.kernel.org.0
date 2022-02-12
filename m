Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB2D4B37E1
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 21:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiBLUY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 15:24:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiBLUYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 15:24:25 -0500
X-Greylist: delayed 458 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Feb 2022 12:24:19 PST
Received: from mxout04.lancloud.ru (mxout04.lancloud.ru [45.84.86.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46FD606E3;
        Sat, 12 Feb 2022 12:24:19 -0800 (PST)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 1A0F920A7A63
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Corey Minyard <minyard@acm.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "Lee Jones" <lee.jones@linaro.org>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        "Guenter Roeck" <groeck@chromium.org>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "Takashi Iwai" <tiwai@suse.com>,
        <openipmi-developer@lists.sourceforge.net>,
        <linux-iio@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-phy@lists.infradead.org>,
        <platform-driver-x86@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alsa-devel@alsa-project.org>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH v2 1/2] platform: make platform_get_irq_optional() optional
Date:   Sat, 12 Feb 2022 23:16:30 +0300
Message-ID: <20220212201631.12648-2-s.shtylyov@omp.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20220212201631.12648-1-s.shtylyov@omp.ru>
References: <20220212201631.12648-1-s.shtylyov@omp.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is based on the former Andy Shevchenko's patch:

https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@linux.intel.com/

Currently platform_get_irq_optional() returns an error code even if IRQ
resource simply has not been found.  It prevents the callers from being
error code agnostic in their error handling:

	ret = platform_get_irq_optional(...);
	if (ret < 0 && ret != -ENXIO)
		return ret; // respect deferred probe
	if (ret > 0)
		...we get an IRQ...

All other *_optional() APIs seem to return 0 or NULL in case an optional
resource is not available.  Let's follow this good example, so that the
callers would look like:

	ret = platform_get_irq_optional(...);
	if (ret < 0)
		return ret;
	if (ret > 0)
		...we get an IRQ...

Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
Changes in version 2:
- added the error check using dev_err_probe() to platform_get_irq_optional();
- fixed up the IRQ checks in 'drivers/char/ipmi/bt-bmc.c';
- fixed up the IRQ check in 'drivers/thermal/rcar_gen3_thermal.c';
- removed from the patch 'drivers/edac/xgene_edac.c and
  'drivers/power/supply/mp2629_charger.c' as they were switched to calling
  platform_get_irq();
- shortened the IRQ checking code in 'drivers/vfio/platform/vfio_platform.c';
- rebased atop of the recent platform_get_irq_byname() patch;
- reformatted the patch description.

 drivers/base/platform.c                  | 60 +++++++++++++++---------
 drivers/char/ipmi/bt-bmc.c               |  6 +--
 drivers/counter/interrupt-cnt.c          |  4 +-
 drivers/gpio/gpio-altera.c               |  3 +-
 drivers/gpio/gpio-mvebu.c                |  2 +-
 drivers/gpio/gpio-tqmx86.c               |  2 +-
 drivers/i2c/busses/i2c-brcmstb.c         |  8 ++--
 drivers/i2c/busses/i2c-ocores.c          |  4 +-
 drivers/mmc/host/sh_mmcif.c              |  4 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c |  4 +-
 drivers/net/ethernet/davicom/dm9000.c    |  2 +-
 drivers/net/ethernet/freescale/fec_ptp.c |  2 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c |  4 +-
 drivers/platform/chrome/cros_ec_lpc.c    |  2 +-
 drivers/platform/x86/intel/punit_ipc.c   |  2 +-
 drivers/spi/spi-hisi-sfc-v3xx.c          |  2 +-
 drivers/spi/spi-mtk-nor.c                |  3 +-
 drivers/thermal/rcar_gen3_thermal.c      |  2 +
 drivers/tty/serial/8250/8250_mtk.c       |  4 +-
 drivers/tty/serial/sh-sci.c              |  6 +--
 drivers/uio/uio_pdrv_genirq.c            |  2 +-
 drivers/vfio/platform/vfio_platform.c    |  3 +-
 sound/soc/dwc/dwc-i2s.c                  |  4 +-
 23 files changed, 76 insertions(+), 59 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 7d08cd8947be..52a8356f8261 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -148,25 +148,7 @@ devm_platform_ioremap_resource_byname(struct platform_device *pdev,
 EXPORT_SYMBOL_GPL(devm_platform_ioremap_resource_byname);
 #endif /* CONFIG_HAS_IOMEM */
 
-/**
- * platform_get_irq_optional - get an optional IRQ for a device
- * @dev: platform device
- * @num: IRQ number index
- *
- * Gets an IRQ for a platform device. Device drivers should check the return
- * value for errors so as to not pass a negative integer value to the
- * request_irq() APIs. This is the same as platform_get_irq(), except that it
- * does not print an error message if an IRQ can not be obtained.
- *
- * For example::
- *
- *		int irq = platform_get_irq_optional(pdev, 0);
- *		if (irq < 0)
- *			return irq;
- *
- * Return: non-zero IRQ number on success, negative error number on failure.
- */
-int platform_get_irq_optional(struct platform_device *dev, unsigned int num)
+static int __platform_get_irq(struct platform_device *dev, unsigned int num)
 {
 	int ret;
 #ifdef CONFIG_SPARC
@@ -235,6 +217,42 @@ int platform_get_irq_optional(struct platform_device *dev, unsigned int num)
 		return -EINVAL;
 	return ret;
 }
+
+/**
+ * platform_get_irq_optional - get an optional IRQ for a device
+ * @dev: platform device
+ * @num: IRQ number index
+ *
+ * Gets an IRQ for a platform device. Device drivers should check the return
+ * value for errors so as to not pass a negative integer value to the
+ * request_irq() APIs. This is the same as platform_get_irq(), except that it
+ * does not print an error message if an IRQ can not be obtained and returns
+ * 0 when IRQ resource has not been found.
+ *
+ * For example::
+ *
+ *		int irq = platform_get_irq_optional(pdev, 0);
+ *		if (irq < 0)
+ *			return irq;
+ *		if (irq > 0)
+ *			...we have IRQ line defined...
+ *
+ * Return: non-zero IRQ number on success, 0 if IRQ wasn't found, negative error
+ * number on failure.
+ */
+int platform_get_irq_optional(struct platform_device *dev, unsigned int num)
+{
+	int ret;
+
+	ret = __platform_get_irq(dev, num);
+	if (ret == -ENXIO)
+		return 0;
+	if (ret < 0)
+		return dev_err_probe(&dev->dev, ret,
+				     "IRQ index %u not found\n", num);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(platform_get_irq_optional);
 
 /**
@@ -258,7 +276,7 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
 {
 	int ret;
 
-	ret = platform_get_irq_optional(dev, num);
+	ret = __platform_get_irq(dev, num);
 	if (ret < 0)
 		return dev_err_probe(&dev->dev, ret,
 				     "IRQ index %u not found\n", num);
@@ -277,7 +295,7 @@ int platform_irq_count(struct platform_device *dev)
 {
 	int ret, nr = 0;
 
-	while ((ret = platform_get_irq_optional(dev, nr)) >= 0)
+	while ((ret = __platform_get_irq(dev, nr)) >= 0)
 		nr++;
 
 	if (ret == -EPROBE_DEFER)
diff --git a/drivers/char/ipmi/bt-bmc.c b/drivers/char/ipmi/bt-bmc.c
index 7450904e330a..289acaf4e720 100644
--- a/drivers/char/ipmi/bt-bmc.c
+++ b/drivers/char/ipmi/bt-bmc.c
@@ -380,7 +380,7 @@ static int bt_bmc_config_irq(struct bt_bmc *bt_bmc,
 	u32 reg;
 
 	bt_bmc->irq = platform_get_irq_optional(pdev, 0);
-	if (bt_bmc->irq < 0)
+	if (bt_bmc->irq <= 0)
 		return bt_bmc->irq;
 
 	rc = devm_request_irq(dev, bt_bmc->irq, bt_bmc_irq, IRQF_SHARED,
@@ -438,7 +438,7 @@ static int bt_bmc_probe(struct platform_device *pdev)
 
 	bt_bmc_config_irq(bt_bmc, pdev);
 
-	if (bt_bmc->irq >= 0) {
+	if (bt_bmc->irq > 0) {
 		dev_info(dev, "Using IRQ %d\n", bt_bmc->irq);
 	} else {
 		dev_info(dev, "No IRQ; using timer\n");
@@ -464,7 +464,7 @@ static int bt_bmc_remove(struct platform_device *pdev)
 	struct bt_bmc *bt_bmc = dev_get_drvdata(&pdev->dev);
 
 	misc_deregister(&bt_bmc->miscdev);
-	if (bt_bmc->irq < 0)
+	if (bt_bmc->irq <= 0)
 		del_timer_sync(&bt_bmc->poll_timer);
 	return 0;
 }
diff --git a/drivers/counter/interrupt-cnt.c b/drivers/counter/interrupt-cnt.c
index 9e99702470c2..a2443c66330b 100644
--- a/drivers/counter/interrupt-cnt.c
+++ b/drivers/counter/interrupt-cnt.c
@@ -157,9 +157,7 @@ static int interrupt_cnt_probe(struct platform_device *pdev)
 	priv = counter_priv(counter);
 
 	priv->irq = platform_get_irq_optional(pdev,  0);
-	if (priv->irq == -ENXIO)
-		priv->irq = 0;
-	else if (priv->irq < 0)
+	if (priv->irq < 0)
 		return dev_err_probe(dev, priv->irq, "failed to get IRQ\n");
 
 	priv->gpio = devm_gpiod_get_optional(dev, NULL, GPIOD_IN);
diff --git a/drivers/gpio/gpio-altera.c b/drivers/gpio/gpio-altera.c
index b59fae993626..02a2995aa368 100644
--- a/drivers/gpio/gpio-altera.c
+++ b/drivers/gpio/gpio-altera.c
@@ -267,8 +267,7 @@ static int altera_gpio_probe(struct platform_device *pdev)
 	altera_gc->mmchip.gc.parent		= &pdev->dev;
 
 	altera_gc->mapped_irq = platform_get_irq_optional(pdev, 0);
-
-	if (altera_gc->mapped_irq < 0)
+	if (altera_gc->mapped_irq <= 0)
 		goto skip_irq;
 
 	if (of_property_read_u32(node, "altr,interrupt-type", &reg)) {
diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 4c1f9e1091b7..d94594807697 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1293,7 +1293,7 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	for (i = 0; i < 4; i++) {
 		int irq = platform_get_irq_optional(pdev, i);
 
-		if (irq < 0)
+		if (irq <= 0)
 			continue;
 		irq_set_chained_handler_and_data(irq, mvebu_gpio_irq_handler,
 						 mvchip);
diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index 5b103221b58d..dc0f83236ce8 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -237,7 +237,7 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 	int ret, irq;
 
 	irq = platform_get_irq_optional(pdev, 0);
-	if (irq < 0 && irq != -ENXIO)
+	if (irq < 0)
 		return irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
diff --git a/drivers/i2c/busses/i2c-brcmstb.c b/drivers/i2c/busses/i2c-brcmstb.c
index 490ee3962645..69395ae27a1a 100644
--- a/drivers/i2c/busses/i2c-brcmstb.c
+++ b/drivers/i2c/busses/i2c-brcmstb.c
@@ -250,7 +250,7 @@ static int brcmstb_i2c_wait_for_completion(struct brcmstb_i2c_dev *dev)
 	int ret = 0;
 	unsigned long timeout = msecs_to_jiffies(I2C_TIMEOUT);
 
-	if (dev->irq >= 0) {
+	if (dev->irq > 0) {
 		if (!wait_for_completion_timeout(&dev->done, timeout))
 			ret = -ETIMEDOUT;
 	} else {
@@ -297,7 +297,7 @@ static int brcmstb_send_i2c_cmd(struct brcmstb_i2c_dev *dev,
 		return rc;
 
 	/* only if we are in interrupt mode */
-	if (dev->irq >= 0)
+	if (dev->irq > 0)
 		reinit_completion(&dev->done);
 
 	/* enable BSC CTL interrupt line */
@@ -652,7 +652,7 @@ static int brcmstb_i2c_probe(struct platform_device *pdev)
 	brcmstb_i2c_enable_disable_irq(dev, INT_DISABLE);
 
 	/* register the ISR handler */
-	if (dev->irq >= 0) {
+	if (dev->irq > 0) {
 		rc = devm_request_irq(&pdev->dev, dev->irq, brcmstb_i2c_isr,
 				      IRQF_SHARED,
 				      int_name ? int_name : pdev->name,
@@ -696,7 +696,7 @@ static int brcmstb_i2c_probe(struct platform_device *pdev)
 
 	dev_info(dev->device, "%s@%dhz registered in %s mode\n",
 		 int_name ? int_name : " ", dev->clk_freq_hz,
-		 (dev->irq >= 0) ? "interrupt" : "polling");
+		 (dev->irq > 0) ? "interrupt" : "polling");
 
 	return 0;
 
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index a0af027db04c..1f4d5e52ff42 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -691,10 +691,10 @@ static int ocores_i2c_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(pdev->dev.of_node,
 				    "sifive,fu540-c000-i2c")) {
 		i2c->flags |= OCORES_FLAG_BROKEN_IRQ;
-		irq = -ENXIO;
+		irq = 0;
 	}
 
-	if (irq == -ENXIO) {
+	if (!irq) {
 		ocores_algorithm.master_xfer = ocores_xfer_polling;
 	} else {
 		if (irq < 0)
diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index bcc595c70a9f..f558b9862032 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1465,14 +1465,14 @@ static int sh_mmcif_probe(struct platform_device *pdev)
 	sh_mmcif_sync_reset(host);
 	sh_mmcif_writel(host->addr, MMCIF_CE_INT_MASK, MASK_ALL);
 
-	name = irq[1] < 0 ? dev_name(dev) : "sh_mmc:error";
+	name = irq[1] <= 0 ? dev_name(dev) : "sh_mmc:error";
 	ret = devm_request_threaded_irq(dev, irq[0], sh_mmcif_intr,
 					sh_mmcif_irqt, 0, name, host);
 	if (ret) {
 		dev_err(dev, "request_irq error (%s)\n", name);
 		goto err_clk;
 	}
-	if (irq[1] >= 0) {
+	if (irq[1] > 0) {
 		ret = devm_request_threaded_irq(dev, irq[1],
 						sh_mmcif_intr, sh_mmcif_irqt,
 						0, "sh_mmc:int", host);
diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index f75929783b94..ac222985efde 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1521,7 +1521,7 @@ static irqreturn_t brcmnand_ctlrdy_irq(int irq, void *data)
 
 	/* check if you need to piggy back on the ctrlrdy irq */
 	if (ctrl->edu_pending) {
-		if (irq == ctrl->irq && ((int)ctrl->edu_irq >= 0))
+		if (irq == ctrl->irq && ((int)ctrl->edu_irq > 0))
 	/* Discard interrupts while using dedicated edu irq */
 			return IRQ_HANDLED;
 
@@ -2956,7 +2956,7 @@ static int brcmnand_edu_setup(struct platform_device *pdev)
 		brcmnand_edu_init(ctrl);
 
 		ctrl->edu_irq = platform_get_irq_optional(pdev, 1);
-		if (ctrl->edu_irq < 0) {
+		if (ctrl->edu_irq <= 0) {
 			dev_warn(dev,
 				 "FLASH EDU enabled, using ctlrdy irq\n");
 		} else {
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 0985ab216566..740c660a9411 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1509,7 +1509,7 @@ dm9000_probe(struct platform_device *pdev)
 	}
 
 	db->irq_wake = platform_get_irq_optional(pdev, 1);
-	if (db->irq_wake >= 0) {
+	if (db->irq_wake > 0) {
 		dev_dbg(db->dev, "wakeup irq %d\n", db->irq_wake);
 
 		ret = request_irq(db->irq_wake, dm9000_wol_interrupt,
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index af99017a5453..de1d23808b6c 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -616,7 +616,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	/* Failure to get an irq is not fatal,
 	 * only the PTP_CLOCK_PPS clock events should stop
 	 */
-	if (irq >= 0) {
+	if (irq > 0) {
 		ret = devm_request_irq(&pdev->dev, irq, fec_pps_interrupt,
 				       0, pdev->name, ndev);
 		if (ret < 0)
diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 9de617ca9daa..4914d6aca208 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -439,7 +439,7 @@ static int rcar_gen3_phy_usb2_init(struct phy *p)
 	u32 val;
 	int ret;
 
-	if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq >= 0) {
+	if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq > 0) {
 		INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
 		ret = request_irq(channel->irq, rcar_gen3_phy_usb2_irq,
 				  IRQF_SHARED, dev_name(channel->dev), channel);
@@ -486,7 +486,7 @@ static int rcar_gen3_phy_usb2_exit(struct phy *p)
 		val &= ~USB2_INT_ENABLE_UCOM_INTEN;
 	writel(val, usb2_base + USB2_INT_ENABLE);
 
-	if (channel->irq >= 0 && !rcar_gen3_is_any_rphy_initialized(channel))
+	if (channel->irq > 0 && !rcar_gen3_is_any_rphy_initialized(channel))
 		free_irq(channel->irq, channel);
 
 	return 0;
diff --git a/drivers/platform/chrome/cros_ec_lpc.c b/drivers/platform/chrome/cros_ec_lpc.c
index d6306d2a096f..91686d306534 100644
--- a/drivers/platform/chrome/cros_ec_lpc.c
+++ b/drivers/platform/chrome/cros_ec_lpc.c
@@ -400,7 +400,7 @@ static int cros_ec_lpc_probe(struct platform_device *pdev)
 	irq = platform_get_irq_optional(pdev, 0);
 	if (irq > 0)
 		ec_dev->irq = irq;
-	else if (irq != -ENXIO) {
+	else if (irq < 0) {
 		dev_err(dev, "couldn't retrieve IRQ number (%d)\n", irq);
 		return irq;
 	}
diff --git a/drivers/platform/x86/intel/punit_ipc.c b/drivers/platform/x86/intel/punit_ipc.c
index 66bb39fd0ef9..f3cf5ee1466f 100644
--- a/drivers/platform/x86/intel/punit_ipc.c
+++ b/drivers/platform/x86/intel/punit_ipc.c
@@ -278,7 +278,7 @@ static int intel_punit_ipc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, punit_ipcdev);
 
 	irq = platform_get_irq_optional(pdev, 0);
-	if (irq < 0) {
+	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Invalid IRQ, using polling mode\n");
 	} else {
 		ret = devm_request_irq(&pdev->dev, irq, intel_punit_ioc,
diff --git a/drivers/spi/spi-hisi-sfc-v3xx.c b/drivers/spi/spi-hisi-sfc-v3xx.c
index d3a23b1c2a4c..476ddc081c60 100644
--- a/drivers/spi/spi-hisi-sfc-v3xx.c
+++ b/drivers/spi/spi-hisi-sfc-v3xx.c
@@ -467,7 +467,7 @@ static int hisi_sfc_v3xx_probe(struct platform_device *pdev)
 			dev_err(dev, "failed to request irq%d, ret = %d\n", host->irq, ret);
 			host->irq = 0;
 		}
-	} else {
+	} else if (host->irq < 0) {
 		host->irq = 0;
 	}
 
diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 5c93730615f8..2422b0545936 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -829,8 +829,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	mtk_nor_init(sp);
 
 	irq = platform_get_irq_optional(pdev, 0);
-
-	if (irq < 0) {
+	if (irq <= 0) {
 		dev_warn(sp->dev, "IRQ not available.");
 	} else {
 		ret = devm_request_irq(sp->dev, irq, mtk_nor_irq_handler, 0,
diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 43eb25b167bc..359b9941c42b 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -432,6 +432,8 @@ static int rcar_gen3_thermal_request_irqs(struct rcar_gen3_thermal_priv *priv,
 		irq = platform_get_irq_optional(pdev, i);
 		if (irq < 0)
 			return irq;
+		if (!irq)
+			return -ENXIO;
 
 		irqname = devm_kasprintf(dev, GFP_KERNEL, "%s:ch%d",
 					 dev_name(dev), i);
diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index fb65dc601b23..328ab074fd89 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -621,7 +621,7 @@ static int __maybe_unused mtk8250_suspend(struct device *dev)
 	serial8250_suspend_port(data->line);
 
 	pinctrl_pm_select_sleep_state(dev);
-	if (irq >= 0) {
+	if (irq > 0) {
 		err = enable_irq_wake(irq);
 		if (err) {
 			dev_err(dev,
@@ -641,7 +641,7 @@ static int __maybe_unused mtk8250_resume(struct device *dev)
 	struct mtk8250_data *data = dev_get_drvdata(dev);
 	int irq = data->rx_wakeup_irq;
 
-	if (irq >= 0)
+	if (irq > 0)
 		disable_irq_wake(irq);
 	pinctrl_pm_select_default_state(dev);
 
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 968967d722d4..96c3146ff6a4 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1915,7 +1915,7 @@ static int sci_request_irq(struct sci_port *port)
 			 * Certain port types won't support all of the
 			 * available interrupt sources.
 			 */
-			if (unlikely(irq < 0))
+			if (unlikely(irq <= 0))
 				continue;
 		}
 
@@ -1963,7 +1963,7 @@ static void sci_free_irq(struct sci_port *port)
 		 * Certain port types won't support all of the available
 		 * interrupt sources.
 		 */
-		if (unlikely(irq < 0))
+		if (unlikely(irq <= 0))
 			continue;
 
 		/* Check if already freed (irq was muxed) */
@@ -2875,7 +2875,7 @@ static int sci_init_single(struct platform_device *dev,
 	if (sci_port->irqs[0] < 0)
 		return -ENXIO;
 
-	if (sci_port->irqs[1] < 0)
+	if (sci_port->irqs[1] <= 0)
 		for (i = 1; i < ARRAY_SIZE(sci_port->irqs); i++)
 			sci_port->irqs[i] = sci_port->irqs[0];
 
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 63258b6accc4..7fd275fc6ceb 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -162,7 +162,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	if (!uioinfo->irq) {
 		ret = platform_get_irq_optional(pdev, 0);
 		uioinfo->irq = ret;
-		if (ret == -ENXIO)
+		if (!ret)
 			uioinfo->irq = UIO_IRQ_NONE;
 		else if (ret == -EPROBE_DEFER)
 			return ret;
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 68a1c87066d7..f7423d10cefd 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -32,8 +32,9 @@ static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
 static int get_platform_irq(struct vfio_platform_device *vdev, int i)
 {
 	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
+	int ret = platform_get_irq_optional(pdev, i);
 
-	return platform_get_irq_optional(pdev, i);
+	return ret ? ret : -ENXIO;
 }
 
 static int vfio_platform_probe(struct platform_device *pdev)
diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index 5cb58929090d..ff19c5130459 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -643,7 +643,7 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	dev->dev = &pdev->dev;
 
 	irq = platform_get_irq_optional(pdev, 0);
-	if (irq >= 0) {
+	if (irq > 0) {
 		ret = devm_request_irq(&pdev->dev, irq, i2s_irq_handler, 0,
 				pdev->name, dev);
 		if (ret < 0) {
@@ -697,7 +697,7 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	}
 
 	if (!pdata) {
-		if (irq >= 0) {
+		if (irq > 0) {
 			ret = dw_pcm_register(pdev);
 			dev->use_pio = true;
 		} else {
-- 
2.26.3

