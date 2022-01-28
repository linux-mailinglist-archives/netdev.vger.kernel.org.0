Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E05E49F113
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345441AbiA1ChG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345445AbiA1ChD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:37:03 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1BAC06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:03 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id x193so9854631oix.0
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sikxb5pnARvkA56Kij0GElMUmmzrgizhHqOL6F720po=;
        b=HIlsYghF6gT+qXNmhBdEqTMvYF8YgKMFPZIdEO9dKCv8hkBabfxPCXhI2D1wFzD6+6
         88vgNwFKutima/hAFPIqZiWZ094s2wYCfZla1pH3XDyfbcAyoSBe0yvy3Qvxo/Zu4qJE
         FTVfUPuSHFcP0gNGcIjDzmflXmGNtPTgy8HqpL5kawiiIkRFRzeCIeegSMyaMez4kzfA
         3Xb6ewuDZl/yA21zrJMSH3WbBxRp2kRcGSDOLWLsRIodimSXTGcM/9ngeS66gbOjPce1
         RoHJDDOMr3jMbTghvg2UkXzlTdWXSdWP1Fi4sCotD/eOMbgWolnVEaQA9ijcXYh+e0P5
         8pQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sikxb5pnARvkA56Kij0GElMUmmzrgizhHqOL6F720po=;
        b=Mj8ptFstz5yLchT97EPPWCEvIbojRcF2JF0x6pll8oOqIrDhS17hNevjfkLh+qU0qL
         hhLT6im7cAEvMu8J/Z+OwmluKN/Xa00WZR5zxsKIGdOI9s1N76W+zhz+PdWP96eYG42s
         CBPBZBnlRJrb8RC1fNqMkEHRnVmf0WPWKe/ur0Q+f6tVJ46+7IF9VV4smxf+v1/k31rR
         DUWYrF085MUD3nUXKY2GaCGAK12UrjP5rvpKrQXamIm0iP1NLOZUL7HfuxNvFNqk4apr
         JyA1lurLa0F4ltubw7sZzTd/QJiyC1n27TkSxqoc71caC0Y7hfschaT8pSYzNGQTYXbr
         RmrQ==
X-Gm-Message-State: AOAM531WO98PDYftlJzlT95Piin4ZXQiEP1u7pxPrdq8x2k/qV7U/xT0
        pxoRFGSaLGtIQhzs4DvRul8VPguy14SV0A==
X-Google-Smtp-Source: ABdhPJygI34GlL1fBBYsF7H2pJ+3OyEelSec+hQmGp3vw8497N3qf9rCeDq2V+ezRPQ9H34UTWXq4Q==
X-Received: by 2002:aca:db45:: with SMTP id s66mr144144oig.22.1643337422181;
        Thu, 27 Jan 2022 18:37:02 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p82sm2586920oib.25.2022.01.27.18.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:37:01 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v5 04/11] net: dsa: realtek: convert subdrivers into modules
Date:   Thu, 27 Jan 2022 23:36:04 -0300
Message-Id: <20220128023611.2424-5-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128023611.2424-1-luizluca@gmail.com>
References: <20220128023611.2424-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preparing for multiple interfaces support, the drivers
must be independent of realtek-smi.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/realtek/Kconfig               | 20 +++++++++++++++++--
 drivers/net/dsa/realtek/Makefile              |  4 +++-
 .../{realtek-smi-core.c => realtek-smi.c}     |  6 ++++++
 drivers/net/dsa/realtek/rtl8365mb.c           |  4 ++++
 .../dsa/realtek/{rtl8366.c => rtl8366-core.c} |  0
 drivers/net/dsa/realtek/rtl8366rb.c           |  4 ++++
 6 files changed, 35 insertions(+), 3 deletions(-)
 rename drivers/net/dsa/realtek/{realtek-smi-core.c => realtek-smi.c} (97%)
 rename drivers/net/dsa/realtek/{rtl8366.c => rtl8366-core.c} (100%)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 1c62212fb0ec..cd1aa95b7bf0 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -2,8 +2,6 @@
 menuconfig NET_DSA_REALTEK
 	tristate "Realtek Ethernet switch family support"
 	depends on NET_DSA
-	select NET_DSA_TAG_RTL4_A
-	select NET_DSA_TAG_RTL8_4
 	select FIXED_PHY
 	select IRQ_DOMAIN
 	select REALTEK_PHY
@@ -18,3 +16,21 @@ config NET_DSA_REALTEK_SMI
 	help
 	  Select to enable support for registering switches connected
 	  through SMI.
+
+config NET_DSA_REALTEK_RTL8365MB
+	tristate "Realtek RTL8365MB switch subdriver"
+	default y
+	depends on NET_DSA_REALTEK
+	depends on NET_DSA_REALTEK_SMI
+	select NET_DSA_TAG_RTL8_4
+	help
+	  Select to enable support for Realtek RTL8365MB
+
+config NET_DSA_REALTEK_RTL8366RB
+	tristate "Realtek RTL8366RB switch subdriver"
+	default y
+	depends on NET_DSA_REALTEK
+	depends on NET_DSA_REALTEK_SMI
+	select NET_DSA_TAG_RTL4_A
+	help
+	  Select to enable support for Realtek RTL8366RB
diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek/Makefile
index 323b921bfce0..8b5a4abcedd3 100644
--- a/drivers/net/dsa/realtek/Makefile
+++ b/drivers/net/dsa/realtek/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_NET_DSA_REALTEK_SMI) 	+= realtek-smi.o
-realtek-smi-objs			:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
+obj-$(CONFIG_NET_DSA_REALTEK_RTL8366RB) += rtl8366.o
+rtl8366-objs 				:= rtl8366-core.o rtl8366rb.o
+obj-$(CONFIG_NET_DSA_REALTEK_RTL8365MB) += rtl8365mb.o
diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi.c
similarity index 97%
rename from drivers/net/dsa/realtek/realtek-smi-core.c
rename to drivers/net/dsa/realtek/realtek-smi.c
index a917801385c9..5514fe81d64f 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -495,19 +495,23 @@ static void realtek_smi_shutdown(struct platform_device *pdev)
 }
 
 static const struct of_device_id realtek_smi_of_match[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8366RB)
 	{
 		.compatible = "realtek,rtl8366rb",
 		.data = &rtl8366rb_variant,
 	},
+#endif
 	{
 		/* FIXME: add support for RTL8366S and more */
 		.compatible = "realtek,rtl8366s",
 		.data = NULL,
 	},
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{
 		.compatible = "realtek,rtl8365mb",
 		.data = &rtl8365mb_variant,
 	},
+#endif
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, realtek_smi_of_match);
@@ -523,4 +527,6 @@ static struct platform_driver realtek_smi_driver = {
 };
 module_platform_driver(realtek_smi_driver);
 
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("Driver for Realtek ethernet switch connected via SMI interface");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 5fb453b5f650..b52bb987027c 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1987,3 +1987,7 @@ const struct realtek_variant rtl8365mb_variant = {
 	.chip_data_sz = sizeof(struct rtl8365mb),
 };
 EXPORT_SYMBOL_GPL(rtl8365mb_variant);
+
+MODULE_AUTHOR("Alvin Šipraga <alsi@bang-olufsen.dk>");
+MODULE_DESCRIPTION("Driver for RTL8365MB-VC ethernet switch");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/realtek/rtl8366.c b/drivers/net/dsa/realtek/rtl8366-core.c
similarity index 100%
rename from drivers/net/dsa/realtek/rtl8366.c
rename to drivers/net/dsa/realtek/rtl8366-core.c
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 34e371084d6d..ff607608dead 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1814,3 +1814,7 @@ const struct realtek_variant rtl8366rb_variant = {
 	.chip_data_sz = sizeof(struct rtl8366rb),
 };
 EXPORT_SYMBOL_GPL(rtl8366rb_variant);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("Driver for RTL8366RB ethernet switch");
+MODULE_LICENSE("GPL");
-- 
2.34.1

