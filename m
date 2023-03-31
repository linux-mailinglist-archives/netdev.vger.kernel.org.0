Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C256D1A42
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjCaIgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjCaIft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:35:49 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7801A95C
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:58 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h17so21570829wrt.8
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251696;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9eQd2PRUPObC6vfAXbvz2kWSZ1cGqD24tBtlBu7v0Zk=;
        b=XT9ECtwlsdWe3o0vMYrNBu+D7NzgbJ564psuhOE+dKhbWFyvXWCZ00wOvDhdwcBTWF
         48LltN5EjnWWF42U7csY7RNAs8Ln0eounrZktVi46AEN4uvQxMPcnyLlh+rJG9zu8UVq
         RFkvH1r1JNJn6j6X9lfiDt1vZdo6/1p9ErMChTKM8ftSVmo8G4S5oDlSKT8HzNor2okP
         GqvO3HCM6OlTOIdQSaa4MigH+oRQil/CqTe9wHVYb+aXYKYiNp/P1tpIS+E8WL8fFrBS
         ZglAstYH00wmOFh71enLs7n5Hl3l3W/kfLupedHWDuJrVXxjKW29WddmG2mOrnUlLgAH
         ea1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251696;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9eQd2PRUPObC6vfAXbvz2kWSZ1cGqD24tBtlBu7v0Zk=;
        b=uSMu65fyPYr14Diy3udcj8gpyyv+LVWSlN0DM/WABcV2Vm1Ko+USRXlR6wXmSAR229
         KMZOo2ODHJt1kMj/t0D/iClF+BYA1dFTu7nC+cipmqK5rPnuXJyLRlaBJuTtCBFeHoes
         pi/+ZYh8MfIRoCwSTJllDG7hXvzZAMGEAzTqbOIGEVX0h4DoMHlLDGzn/x8sCBoQMSaC
         Aa4dNotOSYEOSkJqDcmZ0ehFKpwG027Yhr+dvAypnTIc5V/AJauONPKT3P2yd2HyAx4g
         8BpKnsKK0ggm28ppP3CmeVnjfZOXo9E31+Gpj7zp5l+1LS3zPUb6YcvmEJOGlcvJfhjz
         enww==
X-Gm-Message-State: AAQBX9etmqzYzUIq/NuWiPRxGOxak7VX6DR5KJYzAqcTpTTCNRoPBRuo
        6XNYuNYCYLhUilSg+QVreWOWuA==
X-Google-Smtp-Source: AKy350Yu6u8o68jpMb5+fsfClqUxdCINEEq3588tJZY02FrQB56K1YJR0rbP/jzTvZA6NeFeaYgt9g==
X-Received: by 2002:a5d:5410:0:b0:2cf:e336:cb14 with SMTP id g16-20020a5d5410000000b002cfe336cb14mr6612840wrv.10.1680251696577;
        Fri, 31 Mar 2023 01:34:56 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:56 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:47 +0200
Subject: [PATCH RFC 09/20] nand: oxnas_nand: remove obsolete raw nand
 driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-9-5bd58fd1dd1f@linaro.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to lack of maintainance and stall of development for a few years now,
and since no new features will ever be added upstream, remove support
for OX810 and OX820 nand.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/mtd/nand/raw/Kconfig      |   7 --
 drivers/mtd/nand/raw/Makefile     |   1 -
 drivers/mtd/nand/raw/oxnas_nand.c | 211 --------------------------------------
 3 files changed, 219 deletions(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 170f1185ddc4..aae4c56fe1db 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -204,13 +204,6 @@ config MTD_NAND_BCM47XXNFLASH
 	  registered by bcma as platform devices. This enables driver for
 	  NAND flash memories. For now only BCM4706 is supported.
 
-config MTD_NAND_OXNAS
-	tristate "Oxford Semiconductor NAND controller"
-	depends on ARCH_OXNAS || COMPILE_TEST
-	depends on HAS_IOMEM
-	help
-	  This enables the NAND flash controller on Oxford Semiconductor SoCs.
-
 config MTD_NAND_MPC5121_NFC
 	tristate "MPC5121 NAND controller"
 	depends on PPC_MPC512x
diff --git a/drivers/mtd/nand/raw/Makefile b/drivers/mtd/nand/raw/Makefile
index 917cdfb815b9..53cb380122a5 100644
--- a/drivers/mtd/nand/raw/Makefile
+++ b/drivers/mtd/nand/raw/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_MTD_NAND_MARVELL)		+= marvell_nand.o
 obj-$(CONFIG_MTD_NAND_PLATFORM)		+= plat_nand.o
 obj-$(CONFIG_MTD_NAND_PASEMI)		+= pasemi_nand.o
 obj-$(CONFIG_MTD_NAND_ORION)		+= orion_nand.o
-obj-$(CONFIG_MTD_NAND_OXNAS)		+= oxnas_nand.o
 obj-$(CONFIG_MTD_NAND_FSL_ELBC)		+= fsl_elbc_nand.o
 obj-$(CONFIG_MTD_NAND_FSL_IFC)		+= fsl_ifc_nand.o
 obj-$(CONFIG_MTD_NAND_FSL_UPM)		+= fsl_upm.o
diff --git a/drivers/mtd/nand/raw/oxnas_nand.c b/drivers/mtd/nand/raw/oxnas_nand.c
deleted file mode 100644
index cd112d45e0b5..000000000000
--- a/drivers/mtd/nand/raw/oxnas_nand.c
+++ /dev/null
@@ -1,211 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Oxford Semiconductor OXNAS NAND driver
-
- * Copyright (C) 2016 Neil Armstrong <narmstrong@baylibre.com>
- * Heavily based on plat_nand.c :
- * Author: Vitaly Wool <vitalywool@gmail.com>
- * Copyright (C) 2013 Ma Haijun <mahaijuns@gmail.com>
- * Copyright (C) 2012 John Crispin <blogic@openwrt.org>
- */
-
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/clk.h>
-#include <linux/reset.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/rawnand.h>
-#include <linux/mtd/partitions.h>
-#include <linux/of.h>
-
-/* Nand commands */
-#define OXNAS_NAND_CMD_ALE		BIT(18)
-#define OXNAS_NAND_CMD_CLE		BIT(19)
-
-#define OXNAS_NAND_MAX_CHIPS	1
-
-struct oxnas_nand_ctrl {
-	struct nand_controller base;
-	void __iomem *io_base;
-	struct clk *clk;
-	struct nand_chip *chips[OXNAS_NAND_MAX_CHIPS];
-	unsigned int nchips;
-};
-
-static uint8_t oxnas_nand_read_byte(struct nand_chip *chip)
-{
-	struct oxnas_nand_ctrl *oxnas = nand_get_controller_data(chip);
-
-	return readb(oxnas->io_base);
-}
-
-static void oxnas_nand_read_buf(struct nand_chip *chip, u8 *buf, int len)
-{
-	struct oxnas_nand_ctrl *oxnas = nand_get_controller_data(chip);
-
-	ioread8_rep(oxnas->io_base, buf, len);
-}
-
-static void oxnas_nand_write_buf(struct nand_chip *chip, const u8 *buf,
-				 int len)
-{
-	struct oxnas_nand_ctrl *oxnas = nand_get_controller_data(chip);
-
-	iowrite8_rep(oxnas->io_base, buf, len);
-}
-
-/* Single CS command control */
-static void oxnas_nand_cmd_ctrl(struct nand_chip *chip, int cmd,
-				unsigned int ctrl)
-{
-	struct oxnas_nand_ctrl *oxnas = nand_get_controller_data(chip);
-
-	if (ctrl & NAND_CLE)
-		writeb(cmd, oxnas->io_base + OXNAS_NAND_CMD_CLE);
-	else if (ctrl & NAND_ALE)
-		writeb(cmd, oxnas->io_base + OXNAS_NAND_CMD_ALE);
-}
-
-/*
- * Probe for the NAND device.
- */
-static int oxnas_nand_probe(struct platform_device *pdev)
-{
-	struct device_node *np = pdev->dev.of_node;
-	struct device_node *nand_np;
-	struct oxnas_nand_ctrl *oxnas;
-	struct nand_chip *chip;
-	struct mtd_info *mtd;
-	int count = 0;
-	int err = 0;
-	int i;
-
-	/* Allocate memory for the device structure (and zero it) */
-	oxnas = devm_kzalloc(&pdev->dev, sizeof(*oxnas),
-			     GFP_KERNEL);
-	if (!oxnas)
-		return -ENOMEM;
-
-	nand_controller_init(&oxnas->base);
-
-	oxnas->io_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(oxnas->io_base))
-		return PTR_ERR(oxnas->io_base);
-
-	oxnas->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(oxnas->clk))
-		oxnas->clk = NULL;
-
-	/* Only a single chip node is supported */
-	count = of_get_child_count(np);
-	if (count > 1)
-		return -EINVAL;
-
-	err = clk_prepare_enable(oxnas->clk);
-	if (err)
-		return err;
-
-	device_reset_optional(&pdev->dev);
-
-	for_each_child_of_node(np, nand_np) {
-		chip = devm_kzalloc(&pdev->dev, sizeof(struct nand_chip),
-				    GFP_KERNEL);
-		if (!chip) {
-			err = -ENOMEM;
-			goto err_release_child;
-		}
-
-		chip->controller = &oxnas->base;
-
-		nand_set_flash_node(chip, nand_np);
-		nand_set_controller_data(chip, oxnas);
-
-		mtd = nand_to_mtd(chip);
-		mtd->dev.parent = &pdev->dev;
-		mtd->priv = chip;
-
-		chip->legacy.cmd_ctrl = oxnas_nand_cmd_ctrl;
-		chip->legacy.read_buf = oxnas_nand_read_buf;
-		chip->legacy.read_byte = oxnas_nand_read_byte;
-		chip->legacy.write_buf = oxnas_nand_write_buf;
-		chip->legacy.chip_delay = 30;
-
-		/* Scan to find existence of the device */
-		err = nand_scan(chip, 1);
-		if (err)
-			goto err_release_child;
-
-		err = mtd_device_register(mtd, NULL, 0);
-		if (err)
-			goto err_cleanup_nand;
-
-		oxnas->chips[oxnas->nchips++] = chip;
-	}
-
-	/* Exit if no chips found */
-	if (!oxnas->nchips) {
-		err = -ENODEV;
-		goto err_clk_unprepare;
-	}
-
-	platform_set_drvdata(pdev, oxnas);
-
-	return 0;
-
-err_cleanup_nand:
-	nand_cleanup(chip);
-err_release_child:
-	of_node_put(nand_np);
-
-	for (i = 0; i < oxnas->nchips; i++) {
-		chip = oxnas->chips[i];
-		WARN_ON(mtd_device_unregister(nand_to_mtd(chip)));
-		nand_cleanup(chip);
-	}
-
-err_clk_unprepare:
-	clk_disable_unprepare(oxnas->clk);
-	return err;
-}
-
-static int oxnas_nand_remove(struct platform_device *pdev)
-{
-	struct oxnas_nand_ctrl *oxnas = platform_get_drvdata(pdev);
-	struct nand_chip *chip;
-	int i;
-
-	for (i = 0; i < oxnas->nchips; i++) {
-		chip = oxnas->chips[i];
-		WARN_ON(mtd_device_unregister(nand_to_mtd(chip)));
-		nand_cleanup(chip);
-	}
-
-	clk_disable_unprepare(oxnas->clk);
-
-	return 0;
-}
-
-static const struct of_device_id oxnas_nand_match[] = {
-	{ .compatible = "oxsemi,ox820-nand" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, oxnas_nand_match);
-
-static struct platform_driver oxnas_nand_driver = {
-	.probe	= oxnas_nand_probe,
-	.remove	= oxnas_nand_remove,
-	.driver	= {
-		.name		= "oxnas_nand",
-		.of_match_table = oxnas_nand_match,
-	},
-};
-
-module_platform_driver(oxnas_nand_driver);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Neil Armstrong <narmstrong@baylibre.com>");
-MODULE_DESCRIPTION("Oxnas NAND driver");
-MODULE_ALIAS("platform:oxnas_nand");

-- 
2.34.1

