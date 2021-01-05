Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B07A2EACEA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbhAEOFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:05:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:57716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728968AbhAEOFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:05:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4388AEFE;
        Tue,  5 Jan 2021 14:03:47 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 10/10] ASoC: txx9: Remove driver
Date:   Tue,  5 Jan 2021 15:02:55 +0100
Message-Id: <20210105140305.141401-11-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPU support for TX49xx is getting removed, so remove sound support for it.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 sound/soc/Kconfig                 |   1 -
 sound/soc/Makefile                |   1 -
 sound/soc/txx9/Kconfig            |  30 ---
 sound/soc/txx9/Makefile           |  12 -
 sound/soc/txx9/txx9aclc-ac97.c    | 230 ----------------
 sound/soc/txx9/txx9aclc-generic.c |  88 -------
 sound/soc/txx9/txx9aclc.c         | 422 ------------------------------
 sound/soc/txx9/txx9aclc.h         |  71 -----
 8 files changed, 855 deletions(-)
 delete mode 100644 sound/soc/txx9/Kconfig
 delete mode 100644 sound/soc/txx9/Makefile
 delete mode 100644 sound/soc/txx9/txx9aclc-ac97.c
 delete mode 100644 sound/soc/txx9/txx9aclc-generic.c
 delete mode 100644 sound/soc/txx9/txx9aclc.c
 delete mode 100644 sound/soc/txx9/txx9aclc.h

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 71a6fe87d1a1..47da9ce17693 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -71,7 +71,6 @@ source "sound/soc/stm/Kconfig"
 source "sound/soc/sunxi/Kconfig"
 source "sound/soc/tegra/Kconfig"
 source "sound/soc/ti/Kconfig"
-source "sound/soc/txx9/Kconfig"
 source "sound/soc/uniphier/Kconfig"
 source "sound/soc/ux500/Kconfig"
 source "sound/soc/xilinx/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index ddbac3a2169f..508dbaa1814e 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -54,7 +54,6 @@ obj-$(CONFIG_SND_SOC)	+= stm/
 obj-$(CONFIG_SND_SOC)	+= sunxi/
 obj-$(CONFIG_SND_SOC)	+= tegra/
 obj-$(CONFIG_SND_SOC)	+= ti/
-obj-$(CONFIG_SND_SOC)	+= txx9/
 obj-$(CONFIG_SND_SOC)	+= uniphier/
 obj-$(CONFIG_SND_SOC)	+= ux500/
 obj-$(CONFIG_SND_SOC)	+= xilinx/
diff --git a/sound/soc/txx9/Kconfig b/sound/soc/txx9/Kconfig
deleted file mode 100644
index d928edf9f5a9..000000000000
--- a/sound/soc/txx9/Kconfig
+++ /dev/null
@@ -1,30 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-##
-## TXx9 ACLC
-##
-config SND_SOC_TXX9ACLC
-	tristate "SoC Audio for TXx9"
-	depends on HAS_TXX9_ACLC && TXX9_DMAC
-	help
-	  This option enables support for the AC Link Controllers in TXx9 SoC.
-
-config HAS_TXX9_ACLC
-	bool
-
-config SND_SOC_TXX9ACLC_AC97
-	tristate
-	select AC97_BUS
-	select SND_AC97_CODEC
-	select SND_SOC_AC97_BUS
-
-
-##
-## Boards
-##
-config SND_SOC_TXX9ACLC_GENERIC
-	tristate "Generic TXx9 ACLC sound machine"
-	depends on SND_SOC_TXX9ACLC
-	select SND_SOC_TXX9ACLC_AC97
-	select SND_SOC_AC97_CODEC
-	help
-	  This is a generic AC97 sound machine for use in TXx9 based systems.
diff --git a/sound/soc/txx9/Makefile b/sound/soc/txx9/Makefile
deleted file mode 100644
index 37ad833eb329..000000000000
--- a/sound/soc/txx9/Makefile
+++ /dev/null
@@ -1,12 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# Platform
-snd-soc-txx9aclc-objs := txx9aclc.o
-snd-soc-txx9aclc-ac97-objs := txx9aclc-ac97.o
-
-obj-$(CONFIG_SND_SOC_TXX9ACLC) += snd-soc-txx9aclc.o
-obj-$(CONFIG_SND_SOC_TXX9ACLC_AC97) += snd-soc-txx9aclc-ac97.o
-
-# Machine
-snd-soc-txx9aclc-generic-objs := txx9aclc-generic.o
-
-obj-$(CONFIG_SND_SOC_TXX9ACLC_GENERIC) += snd-soc-txx9aclc-generic.o
diff --git a/sound/soc/txx9/txx9aclc-ac97.c b/sound/soc/txx9/txx9aclc-ac97.c
deleted file mode 100644
index d9e348444bd0..000000000000
--- a/sound/soc/txx9/txx9aclc-ac97.c
+++ /dev/null
@@ -1,230 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * TXx9 ACLC AC97 driver
- *
- * Copyright (C) 2009 Atsushi Nemoto
- *
- * Based on RBTX49xx patch from CELF patch archive.
- * (C) Copyright TOSHIBA CORPORATION 2004-2006
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/gfp.h>
-#include <asm/mach-tx39xx/ioremap.h> /* for TXX9_DIRECTMAP_BASE */
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/soc.h>
-#include "txx9aclc.h"
-
-#define AC97_DIR	\
-	(SND_SOC_DAIDIR_PLAYBACK | SND_SOC_DAIDIR_CAPTURE)
-
-#define AC97_RATES	\
-	SNDRV_PCM_RATE_8000_48000
-
-#ifdef __BIG_ENDIAN
-#define AC97_FMTS	SNDRV_PCM_FMTBIT_S16_BE
-#else
-#define AC97_FMTS	SNDRV_PCM_FMTBIT_S16_LE
-#endif
-
-static DECLARE_WAIT_QUEUE_HEAD(ac97_waitq);
-
-/* REVISIT: How to find txx9aclc_drvdata from snd_ac97? */
-static struct txx9aclc_plat_drvdata *txx9aclc_drvdata;
-
-static int txx9aclc_regready(struct txx9aclc_plat_drvdata *drvdata)
-{
-	return __raw_readl(drvdata->base + ACINTSTS) & ACINT_REGACCRDY;
-}
-
-/* AC97 controller reads codec register */
-static unsigned short txx9aclc_ac97_read(struct snd_ac97 *ac97,
-					 unsigned short reg)
-{
-	struct txx9aclc_plat_drvdata *drvdata = txx9aclc_drvdata;
-	void __iomem *base = drvdata->base;
-	u32 dat;
-
-	if (!(__raw_readl(base + ACINTSTS) & ACINT_CODECRDY(ac97->num)))
-		return 0xffff;
-	reg |= ac97->num << 7;
-	dat = (reg << ACREGACC_REG_SHIFT) | ACREGACC_READ;
-	__raw_writel(dat, base + ACREGACC);
-	__raw_writel(ACINT_REGACCRDY, base + ACINTEN);
-	if (!wait_event_timeout(ac97_waitq, txx9aclc_regready(txx9aclc_drvdata), HZ)) {
-		__raw_writel(ACINT_REGACCRDY, base + ACINTDIS);
-		printk(KERN_ERR "ac97 read timeout (reg %#x)\n", reg);
-		dat = 0xffff;
-		goto done;
-	}
-	dat = __raw_readl(base + ACREGACC);
-	if (((dat >> ACREGACC_REG_SHIFT) & 0xff) != reg) {
-		printk(KERN_ERR "reg mismatch %x with %x\n",
-			dat, reg);
-		dat = 0xffff;
-		goto done;
-	}
-	dat = (dat >> ACREGACC_DAT_SHIFT) & 0xffff;
-done:
-	__raw_writel(ACINT_REGACCRDY, base + ACINTDIS);
-	return dat;
-}
-
-/* AC97 controller writes to codec register */
-static void txx9aclc_ac97_write(struct snd_ac97 *ac97, unsigned short reg,
-				unsigned short val)
-{
-	struct txx9aclc_plat_drvdata *drvdata = txx9aclc_drvdata;
-	void __iomem *base = drvdata->base;
-
-	__raw_writel(((reg | (ac97->num << 7)) << ACREGACC_REG_SHIFT) |
-		     (val << ACREGACC_DAT_SHIFT),
-		     base + ACREGACC);
-	__raw_writel(ACINT_REGACCRDY, base + ACINTEN);
-	if (!wait_event_timeout(ac97_waitq, txx9aclc_regready(txx9aclc_drvdata), HZ)) {
-		printk(KERN_ERR
-			"ac97 write timeout (reg %#x)\n", reg);
-	}
-	__raw_writel(ACINT_REGACCRDY, base + ACINTDIS);
-}
-
-static void txx9aclc_ac97_cold_reset(struct snd_ac97 *ac97)
-{
-	struct txx9aclc_plat_drvdata *drvdata = txx9aclc_drvdata;
-	void __iomem *base = drvdata->base;
-	u32 ready = ACINT_CODECRDY(ac97->num) | ACINT_REGACCRDY;
-
-	__raw_writel(ACCTL_ENLINK, base + ACCTLDIS);
-	udelay(1);
-	__raw_writel(ACCTL_ENLINK, base + ACCTLEN);
-	/* wait for primary codec ready status */
-	__raw_writel(ready, base + ACINTEN);
-	if (!wait_event_timeout(ac97_waitq,
-				(__raw_readl(base + ACINTSTS) & ready) == ready,
-				HZ)) {
-		dev_err(&ac97->dev, "primary codec is not ready "
-			"(status %#x)\n",
-			__raw_readl(base + ACINTSTS));
-	}
-	__raw_writel(ACINT_REGACCRDY, base + ACINTSTS);
-	__raw_writel(ready, base + ACINTDIS);
-}
-
-/* AC97 controller operations */
-static struct snd_ac97_bus_ops txx9aclc_ac97_ops = {
-	.read		= txx9aclc_ac97_read,
-	.write		= txx9aclc_ac97_write,
-	.reset		= txx9aclc_ac97_cold_reset,
-};
-
-static irqreturn_t txx9aclc_ac97_irq(int irq, void *dev_id)
-{
-	struct txx9aclc_plat_drvdata *drvdata = dev_id;
-	void __iomem *base = drvdata->base;
-
-	__raw_writel(__raw_readl(base + ACINTMSTS), base + ACINTDIS);
-	wake_up(&ac97_waitq);
-	return IRQ_HANDLED;
-}
-
-static int txx9aclc_ac97_probe(struct snd_soc_dai *dai)
-{
-	txx9aclc_drvdata = snd_soc_dai_get_drvdata(dai);
-	return 0;
-}
-
-static int txx9aclc_ac97_remove(struct snd_soc_dai *dai)
-{
-	struct txx9aclc_plat_drvdata *drvdata = snd_soc_dai_get_drvdata(dai);
-
-	/* disable AC-link */
-	__raw_writel(ACCTL_ENLINK, drvdata->base + ACCTLDIS);
-	txx9aclc_drvdata = NULL;
-	return 0;
-}
-
-static struct snd_soc_dai_driver txx9aclc_ac97_dai = {
-	.probe			= txx9aclc_ac97_probe,
-	.remove			= txx9aclc_ac97_remove,
-	.playback = {
-		.rates		= AC97_RATES,
-		.formats	= AC97_FMTS,
-		.channels_min	= 2,
-		.channels_max	= 2,
-	},
-	.capture = {
-		.rates		= AC97_RATES,
-		.formats	= AC97_FMTS,
-		.channels_min	= 2,
-		.channels_max	= 2,
-	},
-};
-
-static const struct snd_soc_component_driver txx9aclc_ac97_component = {
-	.name		= "txx9aclc-ac97",
-};
-
-static int txx9aclc_ac97_dev_probe(struct platform_device *pdev)
-{
-	struct txx9aclc_plat_drvdata *drvdata;
-	struct resource *r;
-	int err;
-	int irq;
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	drvdata->base = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(drvdata->base))
-		return PTR_ERR(drvdata->base);
-
-	platform_set_drvdata(pdev, drvdata);
-	drvdata->physbase = r->start;
-	if (sizeof(drvdata->physbase) > sizeof(r->start) &&
-	    r->start >= TXX9_DIRECTMAP_BASE &&
-	    r->start < TXX9_DIRECTMAP_BASE + 0x400000)
-		drvdata->physbase |= 0xf00000000ull;
-	err = devm_request_irq(&pdev->dev, irq, txx9aclc_ac97_irq,
-			       0, dev_name(&pdev->dev), drvdata);
-	if (err < 0)
-		return err;
-
-	err = snd_soc_set_ac97_ops(&txx9aclc_ac97_ops);
-	if (err < 0)
-		return err;
-
-	return devm_snd_soc_register_component(&pdev->dev, &txx9aclc_ac97_component,
-					  &txx9aclc_ac97_dai, 1);
-}
-
-static int txx9aclc_ac97_dev_remove(struct platform_device *pdev)
-{
-	snd_soc_set_ac97_ops(NULL);
-	return 0;
-}
-
-static struct platform_driver txx9aclc_ac97_driver = {
-	.probe		= txx9aclc_ac97_dev_probe,
-	.remove		= txx9aclc_ac97_dev_remove,
-	.driver		= {
-		.name	= "txx9aclc-ac97",
-	},
-};
-
-module_platform_driver(txx9aclc_ac97_driver);
-
-MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
-MODULE_DESCRIPTION("TXx9 ACLC AC97 driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:txx9aclc-ac97");
diff --git a/sound/soc/txx9/txx9aclc-generic.c b/sound/soc/txx9/txx9aclc-generic.c
deleted file mode 100644
index d6893721ba1d..000000000000
--- a/sound/soc/txx9/txx9aclc-generic.c
+++ /dev/null
@@ -1,88 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Generic TXx9 ACLC machine driver
- *
- * Copyright (C) 2009 Atsushi Nemoto
- *
- * Based on RBTX49xx patch from CELF patch archive.
- * (C) Copyright TOSHIBA CORPORATION 2004-2006
- *
- * This is a very generic AC97 sound machine driver for boards which
- * have (AC97) audio at ACLC (e.g. RBTX49XX boards).
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/soc.h>
-#include "txx9aclc.h"
-
-SND_SOC_DAILINK_DEFS(hifi,
-	DAILINK_COMP_ARRAY(COMP_CPU("txx9aclc-ac97")),
-	DAILINK_COMP_ARRAY(COMP_CODEC("ac97-codec", "ac97-hifi")),
-	DAILINK_COMP_ARRAY(COMP_PLATFORM("txx9aclc-pcm-audio")));
-
-static struct snd_soc_dai_link txx9aclc_generic_dai = {
-	.name = "AC97",
-	.stream_name = "AC97 HiFi",
-	SND_SOC_DAILINK_REG(hifi),
-};
-
-static struct snd_soc_card txx9aclc_generic_card = {
-	.name		= "Generic TXx9 ACLC Audio",
-	.owner		= THIS_MODULE,
-	.dai_link	= &txx9aclc_generic_dai,
-	.num_links	= 1,
-};
-
-static struct platform_device *soc_pdev;
-
-static int __init txx9aclc_generic_probe(struct platform_device *pdev)
-{
-	int ret;
-
-	soc_pdev = platform_device_alloc("soc-audio", -1);
-	if (!soc_pdev)
-		return -ENOMEM;
-	platform_set_drvdata(soc_pdev, &txx9aclc_generic_card);
-	ret = platform_device_add(soc_pdev);
-	if (ret) {
-		platform_device_put(soc_pdev);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int __exit txx9aclc_generic_remove(struct platform_device *pdev)
-{
-	platform_device_unregister(soc_pdev);
-	return 0;
-}
-
-static struct platform_driver txx9aclc_generic_driver = {
-	.remove = __exit_p(txx9aclc_generic_remove),
-	.driver = {
-		.name = "txx9aclc-generic",
-	},
-};
-
-static int __init txx9aclc_generic_init(void)
-{
-	return platform_driver_probe(&txx9aclc_generic_driver,
-				     txx9aclc_generic_probe);
-}
-
-static void __exit txx9aclc_generic_exit(void)
-{
-	platform_driver_unregister(&txx9aclc_generic_driver);
-}
-
-module_init(txx9aclc_generic_init);
-module_exit(txx9aclc_generic_exit);
-
-MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
-MODULE_DESCRIPTION("Generic TXx9 ACLC ALSA SoC audio driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:txx9aclc-generic");
diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
deleted file mode 100644
index 1d2d0d9b57b0..000000000000
--- a/sound/soc/txx9/txx9aclc.c
+++ /dev/null
@@ -1,422 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Generic TXx9 ACLC platform driver
- *
- * Copyright (C) 2009 Atsushi Nemoto
- *
- * Based on RBTX49xx patch from CELF patch archive.
- * (C) Copyright TOSHIBA CORPORATION 2004-2006
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/scatterlist.h>
-#include <linux/slab.h>
-#include <linux/dmaengine.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-#include <sound/soc.h>
-#include "txx9aclc.h"
-
-#define DRV_NAME "txx9aclc"
-
-static struct txx9aclc_soc_device {
-	struct txx9aclc_dmadata dmadata[2];
-} txx9aclc_soc_device;
-
-/* REVISIT: How to find txx9aclc_drvdata from snd_ac97? */
-static struct txx9aclc_plat_drvdata *txx9aclc_drvdata;
-
-static int txx9aclc_dma_init(struct txx9aclc_soc_device *dev,
-			     struct txx9aclc_dmadata *dmadata);
-
-static const struct snd_pcm_hardware txx9aclc_pcm_hardware = {
-	/*
-	 * REVISIT: SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_MMAP_VALID
-	 * needs more works for noncoherent MIPS.
-	 */
-	.info		  = SNDRV_PCM_INFO_INTERLEAVED |
-			    SNDRV_PCM_INFO_BATCH |
-			    SNDRV_PCM_INFO_PAUSE,
-	.period_bytes_min = 1024,
-	.period_bytes_max = 8 * 1024,
-	.periods_min	  = 2,
-	.periods_max	  = 4096,
-	.buffer_bytes_max = 32 * 1024,
-};
-
-static int txx9aclc_pcm_hw_params(struct snd_soc_component *component,
-				  struct snd_pcm_substream *substream,
-				  struct snd_pcm_hw_params *params)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct txx9aclc_dmadata *dmadata = runtime->private_data;
-
-	dev_dbg(component->dev,
-		"runtime->dma_area = %#lx dma_addr = %#lx dma_bytes = %zd "
-		"runtime->min_align %ld\n",
-		(unsigned long)runtime->dma_area,
-		(unsigned long)runtime->dma_addr, runtime->dma_bytes,
-		runtime->min_align);
-	dev_dbg(component->dev,
-		"periods %d period_bytes %d stream %d\n",
-		params_periods(params), params_period_bytes(params),
-		substream->stream);
-
-	dmadata->substream = substream;
-	dmadata->pos = 0;
-	return 0;
-}
-
-static int txx9aclc_pcm_prepare(struct snd_soc_component *component,
-				struct snd_pcm_substream *substream)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct txx9aclc_dmadata *dmadata = runtime->private_data;
-
-	dmadata->dma_addr = runtime->dma_addr;
-	dmadata->buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	dmadata->period_bytes = snd_pcm_lib_period_bytes(substream);
-
-	if (dmadata->buffer_bytes == dmadata->period_bytes) {
-		dmadata->frag_bytes = dmadata->period_bytes >> 1;
-		dmadata->frags = 2;
-	} else {
-		dmadata->frag_bytes = dmadata->period_bytes;
-		dmadata->frags = dmadata->buffer_bytes / dmadata->period_bytes;
-	}
-	dmadata->frag_count = 0;
-	dmadata->pos = 0;
-	return 0;
-}
-
-static void txx9aclc_dma_complete(void *arg)
-{
-	struct txx9aclc_dmadata *dmadata = arg;
-	unsigned long flags;
-
-	/* dma completion handler cannot submit new operations */
-	spin_lock_irqsave(&dmadata->dma_lock, flags);
-	if (dmadata->frag_count >= 0) {
-		dmadata->dmacount--;
-		if (!WARN_ON(dmadata->dmacount < 0))
-			queue_work(system_highpri_wq, &dmadata->work);
-	}
-	spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-}
-
-static struct dma_async_tx_descriptor *
-txx9aclc_dma_submit(struct txx9aclc_dmadata *dmadata, dma_addr_t buf_dma_addr)
-{
-	struct dma_chan *chan = dmadata->dma_chan;
-	struct dma_async_tx_descriptor *desc;
-	struct scatterlist sg;
-
-	sg_init_table(&sg, 1);
-	sg_set_page(&sg, pfn_to_page(PFN_DOWN(buf_dma_addr)),
-		    dmadata->frag_bytes, buf_dma_addr & (PAGE_SIZE - 1));
-	sg_dma_address(&sg) = buf_dma_addr;
-	desc = dmaengine_prep_slave_sg(chan, &sg, 1,
-		dmadata->substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-		DMA_MEM_TO_DEV : DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-	if (!desc) {
-		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
-		return NULL;
-	}
-	desc->callback = txx9aclc_dma_complete;
-	desc->callback_param = dmadata;
-	dmaengine_submit(desc);
-	return desc;
-}
-
-#define NR_DMA_CHAIN		2
-
-static void txx9aclc_dma_work(struct work_struct *work)
-{
-	struct txx9aclc_dmadata *dmadata =
-		container_of(work, struct txx9aclc_dmadata, work);
-	struct dma_chan *chan = dmadata->dma_chan;
-	struct dma_async_tx_descriptor *desc;
-	struct snd_pcm_substream *substream = dmadata->substream;
-	u32 ctlbit = substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-		ACCTL_AUDODMA : ACCTL_AUDIDMA;
-	int i;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dmadata->dma_lock, flags);
-	if (dmadata->frag_count < 0) {
-		struct txx9aclc_plat_drvdata *drvdata = txx9aclc_drvdata;
-		void __iomem *base = drvdata->base;
-
-		spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-		dmaengine_terminate_all(chan);
-		/* first time */
-		for (i = 0; i < NR_DMA_CHAIN; i++) {
-			desc = txx9aclc_dma_submit(dmadata,
-				dmadata->dma_addr + i * dmadata->frag_bytes);
-			if (!desc)
-				return;
-		}
-		dmadata->dmacount = NR_DMA_CHAIN;
-		dma_async_issue_pending(chan);
-		spin_lock_irqsave(&dmadata->dma_lock, flags);
-		__raw_writel(ctlbit, base + ACCTLEN);
-		dmadata->frag_count = NR_DMA_CHAIN % dmadata->frags;
-		spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-		return;
-	}
-	if (WARN_ON(dmadata->dmacount >= NR_DMA_CHAIN)) {
-		spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-		return;
-	}
-	while (dmadata->dmacount < NR_DMA_CHAIN) {
-		dmadata->dmacount++;
-		spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-		desc = txx9aclc_dma_submit(dmadata,
-			dmadata->dma_addr +
-			dmadata->frag_count * dmadata->frag_bytes);
-		if (!desc)
-			return;
-		dma_async_issue_pending(chan);
-
-		spin_lock_irqsave(&dmadata->dma_lock, flags);
-		dmadata->frag_count++;
-		dmadata->frag_count %= dmadata->frags;
-		dmadata->pos += dmadata->frag_bytes;
-		dmadata->pos %= dmadata->buffer_bytes;
-		if ((dmadata->frag_count * dmadata->frag_bytes) %
-		    dmadata->period_bytes == 0)
-			snd_pcm_period_elapsed(substream);
-	}
-	spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-}
-
-static int txx9aclc_pcm_trigger(struct snd_soc_component *component,
-				struct snd_pcm_substream *substream, int cmd)
-{
-	struct txx9aclc_dmadata *dmadata = substream->runtime->private_data;
-	struct txx9aclc_plat_drvdata *drvdata = txx9aclc_drvdata;
-	void __iomem *base = drvdata->base;
-	unsigned long flags;
-	int ret = 0;
-	u32 ctlbit = substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-		ACCTL_AUDODMA : ACCTL_AUDIDMA;
-
-	spin_lock_irqsave(&dmadata->dma_lock, flags);
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-		dmadata->frag_count = -1;
-		queue_work(system_highpri_wq, &dmadata->work);
-		break;
-	case SNDRV_PCM_TRIGGER_STOP:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-		__raw_writel(ctlbit, base + ACCTLDIS);
-		break;
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-	case SNDRV_PCM_TRIGGER_RESUME:
-		__raw_writel(ctlbit, base + ACCTLEN);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	spin_unlock_irqrestore(&dmadata->dma_lock, flags);
-	return ret;
-}
-
-static snd_pcm_uframes_t
-txx9aclc_pcm_pointer(struct snd_soc_component *component,
-		     struct snd_pcm_substream *substream)
-{
-	struct txx9aclc_dmadata *dmadata = substream->runtime->private_data;
-
-	return bytes_to_frames(substream->runtime, dmadata->pos);
-}
-
-static int txx9aclc_pcm_open(struct snd_soc_component *component,
-			     struct snd_pcm_substream *substream)
-{
-	struct txx9aclc_soc_device *dev = &txx9aclc_soc_device;
-	struct txx9aclc_dmadata *dmadata = &dev->dmadata[substream->stream];
-	int ret;
-
-	ret = snd_soc_set_runtime_hwparams(substream, &txx9aclc_pcm_hardware);
-	if (ret)
-		return ret;
-	/* ensure that buffer size is a multiple of period size */
-	ret = snd_pcm_hw_constraint_integer(substream->runtime,
-					    SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
-		return ret;
-	substream->runtime->private_data = dmadata;
-	return 0;
-}
-
-static int txx9aclc_pcm_close(struct snd_soc_component *component,
-			      struct snd_pcm_substream *substream)
-{
-	struct txx9aclc_dmadata *dmadata = substream->runtime->private_data;
-	struct dma_chan *chan = dmadata->dma_chan;
-
-	dmadata->frag_count = -1;
-	dmaengine_terminate_all(chan);
-	return 0;
-}
-
-static int txx9aclc_pcm_new(struct snd_soc_component *component,
-			    struct snd_soc_pcm_runtime *rtd)
-{
-	struct snd_card *card = rtd->card->snd_card;
-	struct snd_soc_dai *dai = asoc_rtd_to_cpu(rtd, 0);
-	struct snd_pcm *pcm = rtd->pcm;
-	struct platform_device *pdev = to_platform_device(component->dev);
-	struct txx9aclc_soc_device *dev;
-	struct resource *r;
-	int i;
-	int ret;
-
-	/* at this point onwards the AC97 component has probed and this will be valid */
-	dev = snd_soc_dai_get_drvdata(dai);
-
-	dev->dmadata[0].stream = SNDRV_PCM_STREAM_PLAYBACK;
-	dev->dmadata[1].stream = SNDRV_PCM_STREAM_CAPTURE;
-	for (i = 0; i < 2; i++) {
-		r = platform_get_resource(pdev, IORESOURCE_DMA, i);
-		if (!r) {
-			ret = -EBUSY;
-			goto exit;
-		}
-		dev->dmadata[i].dma_res = r;
-		ret = txx9aclc_dma_init(dev, &dev->dmadata[i]);
-		if (ret)
-			goto exit;
-	}
-
-	snd_pcm_set_managed_buffer_all(pcm, SNDRV_DMA_TYPE_DEV,
-		card->dev, 64 * 1024, 4 * 1024 * 1024);
-	return 0;
-
-exit:
-	for (i = 0; i < 2; i++) {
-		if (dev->dmadata[i].dma_chan)
-			dma_release_channel(dev->dmadata[i].dma_chan);
-		dev->dmadata[i].dma_chan = NULL;
-	}
-	return ret;
-}
-
-static bool filter(struct dma_chan *chan, void *param)
-{
-	struct txx9aclc_dmadata *dmadata = param;
-	char *devname;
-	bool found = false;
-
-	devname = kasprintf(GFP_KERNEL, "%s.%d", dmadata->dma_res->name,
-		(int)dmadata->dma_res->start);
-	if (strcmp(dev_name(chan->device->dev), devname) == 0) {
-		chan->private = &dmadata->dma_slave;
-		found = true;
-	}
-	kfree(devname);
-	return found;
-}
-
-static int txx9aclc_dma_init(struct txx9aclc_soc_device *dev,
-			     struct txx9aclc_dmadata *dmadata)
-{
-	struct txx9aclc_plat_drvdata *drvdata = txx9aclc_drvdata;
-	struct txx9dmac_slave *ds = &dmadata->dma_slave;
-	dma_cap_mask_t mask;
-
-	spin_lock_init(&dmadata->dma_lock);
-
-	ds->reg_width = sizeof(u32);
-	if (dmadata->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		ds->tx_reg = drvdata->physbase + ACAUDODAT;
-		ds->rx_reg = 0;
-	} else {
-		ds->tx_reg = 0;
-		ds->rx_reg = drvdata->physbase + ACAUDIDAT;
-	}
-
-	/* Try to grab a DMA channel */
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	dmadata->dma_chan = dma_request_channel(mask, filter, dmadata);
-	if (!dmadata->dma_chan) {
-		printk(KERN_ERR
-			"DMA channel for %s is not available\n",
-			dmadata->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-			"playback" : "capture");
-		return -EBUSY;
-	}
-	INIT_WORK(&dmadata->work, txx9aclc_dma_work);
-	return 0;
-}
-
-static int txx9aclc_pcm_probe(struct snd_soc_component *component)
-{
-	snd_soc_component_set_drvdata(component, &txx9aclc_soc_device);
-	return 0;
-}
-
-static void txx9aclc_pcm_remove(struct snd_soc_component *component)
-{
-	struct txx9aclc_soc_device *dev = snd_soc_component_get_drvdata(component);
-	struct txx9aclc_plat_drvdata *drvdata = txx9aclc_drvdata;
-	void __iomem *base = drvdata->base;
-	int i;
-
-	/* disable all FIFO DMAs */
-	__raw_writel(ACCTL_AUDODMA | ACCTL_AUDIDMA, base + ACCTLDIS);
-	/* dummy R/W to clear pending DMAREQ if any */
-	__raw_writel(__raw_readl(base + ACAUDIDAT), base + ACAUDODAT);
-
-	for (i = 0; i < 2; i++) {
-		struct txx9aclc_dmadata *dmadata = &dev->dmadata[i];
-		struct dma_chan *chan = dmadata->dma_chan;
-
-		if (chan) {
-			dmadata->frag_count = -1;
-			dmaengine_terminate_all(chan);
-			dma_release_channel(chan);
-		}
-		dev->dmadata[i].dma_chan = NULL;
-	}
-}
-
-static const struct snd_soc_component_driver txx9aclc_soc_component = {
-	.name		= DRV_NAME,
-	.probe		= txx9aclc_pcm_probe,
-	.remove		= txx9aclc_pcm_remove,
-	.open		= txx9aclc_pcm_open,
-	.close		= txx9aclc_pcm_close,
-	.hw_params	= txx9aclc_pcm_hw_params,
-	.prepare	= txx9aclc_pcm_prepare,
-	.trigger	= txx9aclc_pcm_trigger,
-	.pointer	= txx9aclc_pcm_pointer,
-	.pcm_construct	= txx9aclc_pcm_new,
-};
-
-static int txx9aclc_soc_platform_probe(struct platform_device *pdev)
-{
-	return devm_snd_soc_register_component(&pdev->dev,
-					&txx9aclc_soc_component, NULL, 0);
-}
-
-static struct platform_driver txx9aclc_pcm_driver = {
-	.driver = {
-			.name = "txx9aclc-pcm-audio",
-	},
-
-	.probe = txx9aclc_soc_platform_probe,
-};
-
-module_platform_driver(txx9aclc_pcm_driver);
-
-MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
-MODULE_DESCRIPTION("TXx9 ACLC Audio DMA driver");
-MODULE_LICENSE("GPL");
diff --git a/sound/soc/txx9/txx9aclc.h b/sound/soc/txx9/txx9aclc.h
deleted file mode 100644
index 37c691ba56ed..000000000000
--- a/sound/soc/txx9/txx9aclc.h
+++ /dev/null
@@ -1,71 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * TXx9 SoC AC Link Controller
- */
-
-#ifndef __TXX9ACLC_H
-#define __TXX9ACLC_H
-
-#include <linux/interrupt.h>
-#include <asm/txx9/dmac.h>
-
-#define ACCTLEN			0x00	/* control enable */
-#define ACCTLDIS		0x04	/* control disable */
-#define   ACCTL_ENLINK		0x00000001	/* enable/disable AC-link */
-#define   ACCTL_AUDODMA		0x00000100	/* AUDODMA enable/disable */
-#define   ACCTL_AUDIDMA		0x00001000	/* AUDIDMA enable/disable */
-#define   ACCTL_AUDOEHLT	0x00010000	/* AUDO error halt
-						   enable/disable */
-#define   ACCTL_AUDIEHLT	0x00100000	/* AUDI error halt
-						   enable/disable */
-#define ACREGACC		0x08	/* codec register access */
-#define   ACREGACC_DAT_SHIFT	0	/* data field */
-#define   ACREGACC_REG_SHIFT	16	/* address field */
-#define   ACREGACC_CODECID_SHIFT	24	/* CODEC ID field */
-#define   ACREGACC_READ		0x80000000	/* CODEC read */
-#define   ACREGACC_WRITE	0x00000000	/* CODEC write */
-#define ACINTSTS		0x10	/* interrupt status */
-#define ACINTMSTS		0x14	/* interrupt masked status */
-#define ACINTEN			0x18	/* interrupt enable */
-#define ACINTDIS		0x1c	/* interrupt disable */
-#define   ACINT_CODECRDY(n)	(0x00000001 << (n))	/* CODECn ready */
-#define   ACINT_REGACCRDY	0x00000010	/* ACREGACC ready */
-#define   ACINT_AUDOERR		0x00000100	/* AUDO underrun error */
-#define   ACINT_AUDIERR		0x00001000	/* AUDI overrun error */
-#define ACDMASTS		0x80	/* DMA request status */
-#define   ACDMA_AUDO		0x00000001	/* AUDODMA pending */
-#define   ACDMA_AUDI		0x00000010	/* AUDIDMA pending */
-#define ACAUDODAT		0xa0	/* audio out data */
-#define ACAUDIDAT		0xb0	/* audio in data */
-#define ACREVID			0xfc	/* revision ID */
-
-struct txx9aclc_dmadata {
-	struct resource *dma_res;
-	struct txx9dmac_slave dma_slave;
-	struct dma_chan *dma_chan;
-	struct work_struct work;
-	spinlock_t dma_lock;
-	int stream; /* SNDRV_PCM_STREAM_PLAYBACK or SNDRV_PCM_STREAM_CAPTURE */
-	struct snd_pcm_substream *substream;
-	unsigned long pos;
-	dma_addr_t dma_addr;
-	unsigned long buffer_bytes;
-	unsigned long period_bytes;
-	unsigned long frag_bytes;
-	int frags;
-	int frag_count;
-	int dmacount;
-};
-
-struct txx9aclc_plat_drvdata {
-	void __iomem *base;
-	u64 physbase;
-};
-
-static inline struct txx9aclc_plat_drvdata *txx9aclc_get_plat_drvdata(
-	struct snd_soc_dai *dai)
-{
-	return dev_get_drvdata(dai->dev);
-}
-
-#endif /* __TXX9ACLC_H */
-- 
2.29.2

