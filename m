Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32206D1A70
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjCaIhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjCaIgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:36:51 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6F21FD39
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:27 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d17so21570978wrb.11
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251708;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wyeKmakvQ1hkSbEX4Ij16MupXpQFelz4/2NYVgWuJEU=;
        b=zClFd5Vlxi7e28KuIdUeqTBp1gtaAf//uuz3h43rioEByZfX20BHjwgCWryxHTo+9i
         oWtko8Ixqknbs450gQiNdzgPyJimKEQS8qc/dtfvgsqCDKLQqr6yI900pjhX/qGMFZdX
         E9YiCGD7wJEMaP2livuoEdQ3bY4d1sZa49exj5qQSZvqCNDpuRGe68UZyI6Xua/Z9nt1
         a5+zKV2l3pR4RD+Kel2t/PZXyj7R7YgcnFPa4uM70rQY8XI8A3moL7BiabGuEw6lZAtT
         fhJgPmMUIhLlGzDOshxVzvMD+/1i7AaQ78yMnrrXECZVdQNAju2O9I0ysOGtmNk5iTB6
         qXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251708;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wyeKmakvQ1hkSbEX4Ij16MupXpQFelz4/2NYVgWuJEU=;
        b=kmNnzPEcMt+J4jKAnU4MQJ1hwCXOxTj6JlcG0VhSQ+8d2UBTHmgc5xCTYiTKst1vDD
         B0jlL6JynZ7UaKBpNaboXaBj6+PAQvHPbsk4YzX/8TQI1VsVwN/xMpTJfznG1NhHaUPz
         vzliqpM27RlsoIF8BSZQMl/UUCgFAnD3f6StGX5ycqKb7E2IFnjYrl/y4VR+eqHmulMc
         ZiAPBmk5U4NNycUif2gKM7kJwfYPwnpGfmseEsmKr6Tc+ot/+OcLBcK1w4i4wlGQDMmb
         Q8FMsPUiSYpPrB+YUVHfexPjQl91TcoCTId/uQzwyaBXgzqKyhfVXNHV3sLELx7jIPbD
         xEIQ==
X-Gm-Message-State: AAQBX9eJrEJMOEPUO/zXifaCKJXp9BoBjq/m8GZxqUpjcC9dGJg7/lH5
        E0MYOpyBix8gAMM4LLSPczbKiQ==
X-Google-Smtp-Source: AKy350ZgpW5+Oe3dbmzsCW6vw7rhJNBdmiyWR1Pp/d0MnEm1IxdpSh8x2o9HxYqyhz/1afKGjly3uQ==
X-Received: by 2002:a5d:538e:0:b0:2d5:ac9e:cdde with SMTP id d14-20020a5d538e000000b002d5ac9ecddemr18097313wrv.51.1680251707922;
        Fri, 31 Mar 2023 01:35:07 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:35:07 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:55 +0200
Subject: [PATCH RFC 17/20] reset: oxnas: remove obsolete reset driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-17-5bd58fd1dd1f@linaro.org>
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
for OX810 and OX820 peripheral reset.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/reset/oxnas,reset.txt      |  32 ------
 drivers/reset/Kconfig                              |   3 -
 drivers/reset/Makefile                             |   1 -
 drivers/reset/reset-oxnas.c                        | 114 ---------------------
 4 files changed, 150 deletions(-)

diff --git a/Documentation/devicetree/bindings/reset/oxnas,reset.txt b/Documentation/devicetree/bindings/reset/oxnas,reset.txt
deleted file mode 100644
index d27ccb5d04fc..000000000000
--- a/Documentation/devicetree/bindings/reset/oxnas,reset.txt
+++ /dev/null
@@ -1,32 +0,0 @@
-Oxford Semiconductor OXNAS SoC Family RESET Controller
-================================================
-
-Please also refer to reset.txt in this directory for common reset
-controller binding usage.
-
-Required properties:
-- compatible: For OX810SE, should be "oxsemi,ox810se-reset"
-	      For OX820, should be "oxsemi,ox820-reset"
-- #reset-cells: 1, see below
-
-Parent node should have the following properties :
-- compatible: For OX810SE, should be :
-			"oxsemi,ox810se-sys-ctrl", "syscon", "simple-mfd"
-	      For OX820, should be :
-			"oxsemi,ox820-sys-ctrl", "syscon", "simple-mfd"
-
-Reset indices are in dt-bindings include files :
-- For OX810SE: include/dt-bindings/reset/oxsemi,ox810se.h
-- For OX820: include/dt-bindings/reset/oxsemi,ox820.h
-
-example:
-
-sys: sys-ctrl@000000 {
-	compatible = "oxsemi,ox810se-sys-ctrl", "syscon", "simple-mfd";
-	reg = <0x000000 0x100000>;
-
-	reset: reset-controller {
-		compatible = "oxsemi,ox810se-reset";
-		#reset-cells = <1>;
-	};
-};
diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 2a52c990d4fe..695419d888ab 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -143,9 +143,6 @@ config RESET_NPCM
 	  This enables the reset controller driver for Nuvoton NPCM
 	  BMC SoCs.
 
-config RESET_OXNAS
-	bool
-
 config RESET_PISTACHIO
 	bool "Pistachio Reset Driver"
 	depends on MIPS || COMPILE_TEST
diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index 3e7e5fd633a8..cb1f229e20a6 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -20,7 +20,6 @@ obj-$(CONFIG_RESET_MCHP_SPARX5) += reset-microchip-sparx5.o
 obj-$(CONFIG_RESET_MESON) += reset-meson.o
 obj-$(CONFIG_RESET_MESON_AUDIO_ARB) += reset-meson-audio-arb.o
 obj-$(CONFIG_RESET_NPCM) += reset-npcm.o
-obj-$(CONFIG_RESET_OXNAS) += reset-oxnas.o
 obj-$(CONFIG_RESET_PISTACHIO) += reset-pistachio.o
 obj-$(CONFIG_RESET_POLARFIRE_SOC) += reset-mpfs.o
 obj-$(CONFIG_RESET_QCOM_AOSS) += reset-qcom-aoss.o
diff --git a/drivers/reset/reset-oxnas.c b/drivers/reset/reset-oxnas.c
deleted file mode 100644
index 8209f922dc16..000000000000
--- a/drivers/reset/reset-oxnas.c
+++ /dev/null
@@ -1,114 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Oxford Semiconductor Reset Controller driver
- *
- * Copyright (C) 2016 Neil Armstrong <narmstrong@baylibre.com>
- * Copyright (C) 2014 Ma Haijun <mahaijuns@gmail.com>
- * Copyright (C) 2009 Oxford Semiconductor Ltd
- */
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-#include <linux/reset-controller.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/types.h>
-#include <linux/regmap.h>
-#include <linux/mfd/syscon.h>
-
-/* Regmap offsets */
-#define RST_SET_REGOFFSET	0x34
-#define RST_CLR_REGOFFSET	0x38
-
-struct oxnas_reset {
-	struct regmap *regmap;
-	struct reset_controller_dev rcdev;
-};
-
-static int oxnas_reset_reset(struct reset_controller_dev *rcdev,
-			      unsigned long id)
-{
-	struct oxnas_reset *data =
-		container_of(rcdev, struct oxnas_reset, rcdev);
-
-	regmap_write(data->regmap, RST_SET_REGOFFSET, BIT(id));
-	msleep(50);
-	regmap_write(data->regmap, RST_CLR_REGOFFSET, BIT(id));
-
-	return 0;
-}
-
-static int oxnas_reset_assert(struct reset_controller_dev *rcdev,
-			      unsigned long id)
-{
-	struct oxnas_reset *data =
-		container_of(rcdev, struct oxnas_reset, rcdev);
-
-	regmap_write(data->regmap, RST_SET_REGOFFSET, BIT(id));
-
-	return 0;
-}
-
-static int oxnas_reset_deassert(struct reset_controller_dev *rcdev,
-				unsigned long id)
-{
-	struct oxnas_reset *data =
-		container_of(rcdev, struct oxnas_reset, rcdev);
-
-	regmap_write(data->regmap, RST_CLR_REGOFFSET, BIT(id));
-
-	return 0;
-}
-
-static const struct reset_control_ops oxnas_reset_ops = {
-	.reset		= oxnas_reset_reset,
-	.assert		= oxnas_reset_assert,
-	.deassert	= oxnas_reset_deassert,
-};
-
-static const struct of_device_id oxnas_reset_dt_ids[] = {
-	 { .compatible = "oxsemi,ox810se-reset", },
-	 { .compatible = "oxsemi,ox820-reset", },
-	 { /* sentinel */ },
-};
-
-static int oxnas_reset_probe(struct platform_device *pdev)
-{
-	struct oxnas_reset *data;
-	struct device *parent;
-
-	parent = pdev->dev.parent;
-	if (!parent) {
-		dev_err(&pdev->dev, "no parent\n");
-		return -ENODEV;
-	}
-
-	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->regmap = syscon_node_to_regmap(parent->of_node);
-	if (IS_ERR(data->regmap)) {
-		dev_err(&pdev->dev, "failed to get parent regmap\n");
-		return PTR_ERR(data->regmap);
-	}
-
-	platform_set_drvdata(pdev, data);
-
-	data->rcdev.owner = THIS_MODULE;
-	data->rcdev.nr_resets = 32;
-	data->rcdev.ops = &oxnas_reset_ops;
-	data->rcdev.of_node = pdev->dev.of_node;
-
-	return devm_reset_controller_register(&pdev->dev, &data->rcdev);
-}
-
-static struct platform_driver oxnas_reset_driver = {
-	.probe	= oxnas_reset_probe,
-	.driver = {
-		.name		= "oxnas-reset",
-		.of_match_table	= oxnas_reset_dt_ids,
-	},
-};
-builtin_platform_driver(oxnas_reset_driver);

-- 
2.34.1

