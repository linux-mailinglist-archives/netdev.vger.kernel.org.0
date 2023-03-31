Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63BE6D1A6E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjCaIhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjCaIgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:36:49 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39341CBA0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:23 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j24so21631800wrd.0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251706;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sR14Pzk1ZWPhY5OD69Rj27prrk3LKbGiHay2FBxMcv4=;
        b=Fty/aJcYkFZEKr2metM5EqkEKq17l5gJGQix+tZCxMOlAKB1AMO/oIkTZt9URAowwf
         RWICJqsjkouqcMT9vmE8IfKQP/DHvv9UkXQRhxf1Q+mimQtH5cxG/PhbPnk9w1TLrlYA
         AT8hUgqpZZAhjexFXTVWXk7iDen88KQTq1xUn9G6YnJTv4noraV6PymxxUwt1fBqooou
         HQcSuX+pCi41nBC6SYZ0CEIxhTt/9F6IwxjYEtO3fybv47zKTSc43Sy/DwIzgnv6/5km
         N5ydK4H27c9gO2NPO/42s0zygtKswLo05pSB9tKxjIogSH3waXuYQbnc4SyFxThsFPss
         UMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251706;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sR14Pzk1ZWPhY5OD69Rj27prrk3LKbGiHay2FBxMcv4=;
        b=YvN8IHpIlJN7RDnRpGOZOofLlcVLm6fkuX4ouUk+hGP4uJ0Ds5N5ps4qN1j7NdVHS1
         0x2fqX1+sjBo5JXOhKoLQYnBbMQEYhEoYS0f3QKYvVKec+Tu3OtxEDlOhcp4ZbmmwgRX
         ZQY1YJOoUMTKntYEdVKC7zXjtFcMqeDm9OeS2WpckwTQb3yRPvom+ajUO8iHjWwqMHMm
         Ydyaq0Oj6OkL8+JTspuEsX3Tg89sqWUKOg70V+zvoVLoEiva5kJ0010BC+IejS77sAuu
         ELcmbTRNCdz487KORMUz6qTdCEn6G8KOzB6Fg/XzSH6bvjQ8RM2nTmz2GDWP6pqB5NxB
         klOg==
X-Gm-Message-State: AAQBX9fSYEZd7mPEpLZbnY/1RQpTHNRmWW0NqNnjJ5/tPRjAQDvxjffM
        B1/ZuWqS5tOuXNXEPkaVGJxLvw==
X-Google-Smtp-Source: AKy350YkNKUXMSjTTKKpy6c26g6vAz/W5xiVHdg7Pfywz18Z1jB2OllrAaU4jJjzL55BSkouJUd0zA==
X-Received: by 2002:adf:ed8c:0:b0:2cf:e868:f781 with SMTP id c12-20020adfed8c000000b002cfe868f781mr18949949wro.42.1680251706543;
        Fri, 31 Mar 2023 01:35:06 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:35:06 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:54 +0200
Subject: [PATCH RFC 16/20] power: reset: oxnas-restart: remove obsolete
 restart driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-16-5bd58fd1dd1f@linaro.org>
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
for OX810 and OX820 restart feature.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/power/reset/Kconfig         |   7 --
 drivers/power/reset/Makefile        |   1 -
 drivers/power/reset/oxnas-restart.c | 233 ------------------------------------
 3 files changed, 241 deletions(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 8c87eeda0fec..cc734c1fe4c0 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -148,13 +148,6 @@ config POWER_RESET_ODROID_GO_ULTRA_POWEROFF
 	help
 	  This driver supports Power off for Odroid Go Ultra device.
 
-config POWER_RESET_OXNAS
-	bool "OXNAS SoC restart driver"
-	depends on ARCH_OXNAS
-	default MACH_OX820
-	help
-	  Restart support for OXNAS/PLXTECH OX820 SoC.
-
 config POWER_RESET_PIIX4_POWEROFF
 	tristate "Intel PIIX4 power-off driver"
 	depends on PCI
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index d763e6735ee3..a95d1bd275d1 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_POWER_RESET_HISI) += hisi-reboot.o
 obj-$(CONFIG_POWER_RESET_LINKSTATION) += linkstation-poweroff.o
 obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_MT6323) += mt6323-poweroff.o
-obj-$(CONFIG_POWER_RESET_OXNAS) += oxnas-restart.o
 obj-$(CONFIG_POWER_RESET_QCOM_PON) += qcom-pon.o
 obj-$(CONFIG_POWER_RESET_OCELOT_RESET) += ocelot-reset.o
 obj-$(CONFIG_POWER_RESET_ODROID_GO_ULTRA_POWEROFF) += odroid-go-ultra-poweroff.o
diff --git a/drivers/power/reset/oxnas-restart.c b/drivers/power/reset/oxnas-restart.c
deleted file mode 100644
index 13090bec058a..000000000000
--- a/drivers/power/reset/oxnas-restart.c
+++ /dev/null
@@ -1,233 +0,0 @@
-// SPDX-License-Identifier: (GPL-2.0)
-/*
- * oxnas SoC reset driver
- * based on:
- * Microsemi MIPS SoC reset driver
- * and ox820_assert_system_reset() written by Ma Hajun <mahaijuns@gmail.com>
- *
- * Copyright (c) 2013 Ma Hajun <mahaijuns@gmail.com>
- * Copyright (c) 2017 Microsemi Corporation
- * Copyright (c) 2020 Daniel Golle <daniel@makrotopia.org>
- */
-#include <linux/delay.h>
-#include <linux/io.h>
-#include <linux/notifier.h>
-#include <linux/mfd/syscon.h>
-#include <linux/of_address.h>
-#include <linux/of_device.h>
-#include <linux/platform_device.h>
-#include <linux/reboot.h>
-#include <linux/regmap.h>
-
-/* bit numbers of reset control register */
-#define OX820_SYS_CTRL_RST_SCU                0
-#define OX820_SYS_CTRL_RST_COPRO              1
-#define OX820_SYS_CTRL_RST_ARM0               2
-#define OX820_SYS_CTRL_RST_ARM1               3
-#define OX820_SYS_CTRL_RST_USBHS              4
-#define OX820_SYS_CTRL_RST_USBHSPHYA          5
-#define OX820_SYS_CTRL_RST_MACA               6
-#define OX820_SYS_CTRL_RST_MAC                OX820_SYS_CTRL_RST_MACA
-#define OX820_SYS_CTRL_RST_PCIEA              7
-#define OX820_SYS_CTRL_RST_SGDMA              8
-#define OX820_SYS_CTRL_RST_CIPHER             9
-#define OX820_SYS_CTRL_RST_DDR                10
-#define OX820_SYS_CTRL_RST_SATA               11
-#define OX820_SYS_CTRL_RST_SATA_LINK          12
-#define OX820_SYS_CTRL_RST_SATA_PHY           13
-#define OX820_SYS_CTRL_RST_PCIEPHY            14
-#define OX820_SYS_CTRL_RST_STATIC             15
-#define OX820_SYS_CTRL_RST_GPIO               16
-#define OX820_SYS_CTRL_RST_UART1              17
-#define OX820_SYS_CTRL_RST_UART2              18
-#define OX820_SYS_CTRL_RST_MISC               19
-#define OX820_SYS_CTRL_RST_I2S                20
-#define OX820_SYS_CTRL_RST_SD                 21
-#define OX820_SYS_CTRL_RST_MACB               22
-#define OX820_SYS_CTRL_RST_PCIEB              23
-#define OX820_SYS_CTRL_RST_VIDEO              24
-#define OX820_SYS_CTRL_RST_DDR_PHY            25
-#define OX820_SYS_CTRL_RST_USBHSPHYB          26
-#define OX820_SYS_CTRL_RST_USBDEV             27
-#define OX820_SYS_CTRL_RST_ARMDBG             29
-#define OX820_SYS_CTRL_RST_PLLA               30
-#define OX820_SYS_CTRL_RST_PLLB               31
-
-/* bit numbers of clock control register */
-#define OX820_SYS_CTRL_CLK_COPRO              0
-#define OX820_SYS_CTRL_CLK_DMA                1
-#define OX820_SYS_CTRL_CLK_CIPHER             2
-#define OX820_SYS_CTRL_CLK_SD                 3
-#define OX820_SYS_CTRL_CLK_SATA               4
-#define OX820_SYS_CTRL_CLK_I2S                5
-#define OX820_SYS_CTRL_CLK_USBHS              6
-#define OX820_SYS_CTRL_CLK_MACA               7
-#define OX820_SYS_CTRL_CLK_MAC                OX820_SYS_CTRL_CLK_MACA
-#define OX820_SYS_CTRL_CLK_PCIEA              8
-#define OX820_SYS_CTRL_CLK_STATIC             9
-#define OX820_SYS_CTRL_CLK_MACB               10
-#define OX820_SYS_CTRL_CLK_PCIEB              11
-#define OX820_SYS_CTRL_CLK_REF600             12
-#define OX820_SYS_CTRL_CLK_USBDEV             13
-#define OX820_SYS_CTRL_CLK_DDR                14
-#define OX820_SYS_CTRL_CLK_DDRPHY             15
-#define OX820_SYS_CTRL_CLK_DDRCK              16
-
-/* Regmap offsets */
-#define OX820_CLK_SET_REGOFFSET               0x2c
-#define OX820_CLK_CLR_REGOFFSET               0x30
-#define OX820_RST_SET_REGOFFSET               0x34
-#define OX820_RST_CLR_REGOFFSET               0x38
-#define OX820_SECONDARY_SEL_REGOFFSET         0x14
-#define OX820_TERTIARY_SEL_REGOFFSET          0x8c
-#define OX820_QUATERNARY_SEL_REGOFFSET        0x94
-#define OX820_DEBUG_SEL_REGOFFSET             0x9c
-#define OX820_ALTERNATIVE_SEL_REGOFFSET       0xa4
-#define OX820_PULLUP_SEL_REGOFFSET            0xac
-#define OX820_SEC_SECONDARY_SEL_REGOFFSET     0x100014
-#define OX820_SEC_TERTIARY_SEL_REGOFFSET      0x10008c
-#define OX820_SEC_QUATERNARY_SEL_REGOFFSET    0x100094
-#define OX820_SEC_DEBUG_SEL_REGOFFSET         0x10009c
-#define OX820_SEC_ALTERNATIVE_SEL_REGOFFSET   0x1000a4
-#define OX820_SEC_PULLUP_SEL_REGOFFSET        0x1000ac
-
-struct oxnas_restart_context {
-	struct regmap *sys_ctrl;
-	struct notifier_block restart_handler;
-};
-
-static int ox820_restart_handle(struct notifier_block *this,
-				 unsigned long mode, void *cmd)
-{
-	struct oxnas_restart_context *ctx = container_of(this, struct
-							oxnas_restart_context,
-							restart_handler);
-	u32 value;
-
-	/*
-	 * Assert reset to cores as per power on defaults
-	 * Don't touch the DDR interface as things will come to an impromptu
-	 * stop NB Possibly should be asserting reset for PLLB, but there are
-	 * timing concerns here according to the docs
-	 */
-	value = BIT(OX820_SYS_CTRL_RST_COPRO)		|
-		BIT(OX820_SYS_CTRL_RST_USBHS)		|
-		BIT(OX820_SYS_CTRL_RST_USBHSPHYA)	|
-		BIT(OX820_SYS_CTRL_RST_MACA)		|
-		BIT(OX820_SYS_CTRL_RST_PCIEA)		|
-		BIT(OX820_SYS_CTRL_RST_SGDMA)		|
-		BIT(OX820_SYS_CTRL_RST_CIPHER)		|
-		BIT(OX820_SYS_CTRL_RST_SATA)		|
-		BIT(OX820_SYS_CTRL_RST_SATA_LINK)	|
-		BIT(OX820_SYS_CTRL_RST_SATA_PHY)	|
-		BIT(OX820_SYS_CTRL_RST_PCIEPHY)		|
-		BIT(OX820_SYS_CTRL_RST_STATIC)		|
-		BIT(OX820_SYS_CTRL_RST_UART1)		|
-		BIT(OX820_SYS_CTRL_RST_UART2)		|
-		BIT(OX820_SYS_CTRL_RST_MISC)		|
-		BIT(OX820_SYS_CTRL_RST_I2S)		|
-		BIT(OX820_SYS_CTRL_RST_SD)		|
-		BIT(OX820_SYS_CTRL_RST_MACB)		|
-		BIT(OX820_SYS_CTRL_RST_PCIEB)		|
-		BIT(OX820_SYS_CTRL_RST_VIDEO)		|
-		BIT(OX820_SYS_CTRL_RST_USBHSPHYB)	|
-		BIT(OX820_SYS_CTRL_RST_USBDEV);
-
-	regmap_write(ctx->sys_ctrl, OX820_RST_SET_REGOFFSET, value);
-
-	/* Release reset to cores as per power on defaults */
-	regmap_write(ctx->sys_ctrl, OX820_RST_CLR_REGOFFSET,
-			BIT(OX820_SYS_CTRL_RST_GPIO));
-
-	/*
-	 * Disable clocks to cores as per power-on defaults - must leave DDR
-	 * related clocks enabled otherwise we'll stop rather abruptly.
-	 */
-	value = BIT(OX820_SYS_CTRL_CLK_COPRO)		|
-		BIT(OX820_SYS_CTRL_CLK_DMA)		|
-		BIT(OX820_SYS_CTRL_CLK_CIPHER)		|
-		BIT(OX820_SYS_CTRL_CLK_SD)		|
-		BIT(OX820_SYS_CTRL_CLK_SATA)		|
-		BIT(OX820_SYS_CTRL_CLK_I2S)		|
-		BIT(OX820_SYS_CTRL_CLK_USBHS)		|
-		BIT(OX820_SYS_CTRL_CLK_MAC)		|
-		BIT(OX820_SYS_CTRL_CLK_PCIEA)		|
-		BIT(OX820_SYS_CTRL_CLK_STATIC)		|
-		BIT(OX820_SYS_CTRL_CLK_MACB)		|
-		BIT(OX820_SYS_CTRL_CLK_PCIEB)		|
-		BIT(OX820_SYS_CTRL_CLK_REF600)		|
-		BIT(OX820_SYS_CTRL_CLK_USBDEV);
-
-	regmap_write(ctx->sys_ctrl, OX820_CLK_CLR_REGOFFSET, value);
-
-	/* Enable clocks to cores as per power-on defaults */
-
-	/* Set sys-control pin mux'ing as per power-on defaults */
-	regmap_write(ctx->sys_ctrl, OX820_SECONDARY_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_TERTIARY_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_QUATERNARY_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_DEBUG_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_ALTERNATIVE_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_PULLUP_SEL_REGOFFSET, 0);
-
-	regmap_write(ctx->sys_ctrl, OX820_SEC_SECONDARY_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_SEC_TERTIARY_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_SEC_QUATERNARY_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_SEC_DEBUG_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_SEC_ALTERNATIVE_SEL_REGOFFSET, 0);
-	regmap_write(ctx->sys_ctrl, OX820_SEC_PULLUP_SEL_REGOFFSET, 0);
-
-	/*
-	 * No need to save any state, as the ROM loader can determine whether
-	 * reset is due to power cycling or programatic action, just hit the
-	 * (self-clearing) CPU reset bit of the block reset register
-	 */
-	value =
-		BIT(OX820_SYS_CTRL_RST_SCU) |
-		BIT(OX820_SYS_CTRL_RST_ARM0) |
-		BIT(OX820_SYS_CTRL_RST_ARM1);
-
-	regmap_write(ctx->sys_ctrl, OX820_RST_SET_REGOFFSET, value);
-
-	pr_emerg("Unable to restart system\n");
-	return NOTIFY_DONE;
-}
-
-static int ox820_restart_probe(struct platform_device *pdev)
-{
-	struct oxnas_restart_context *ctx;
-	struct regmap *sys_ctrl;
-	struct device *dev = &pdev->dev;
-	int err = 0;
-
-	sys_ctrl = syscon_node_to_regmap(pdev->dev.of_node);
-	if (IS_ERR(sys_ctrl))
-		return PTR_ERR(sys_ctrl);
-
-	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
-
-	ctx->sys_ctrl = sys_ctrl;
-	ctx->restart_handler.notifier_call = ox820_restart_handle;
-	ctx->restart_handler.priority = 192;
-	err = register_restart_handler(&ctx->restart_handler);
-	if (err)
-		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
-
-	return err;
-}
-
-static const struct of_device_id ox820_restart_of_match[] = {
-	{ .compatible = "oxsemi,ox820-sys-ctrl" },
-	{}
-};
-
-static struct platform_driver ox820_restart_driver = {
-	.probe = ox820_restart_probe,
-	.driver = {
-		.name = "ox820-chip-reset",
-		.of_match_table = ox820_restart_of_match,
-	},
-};
-builtin_platform_driver(ox820_restart_driver);

-- 
2.34.1

