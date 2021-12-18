Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BFC479999
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhLRIPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbhLRIPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:11 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24080C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:11 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id v22so5020031qtx.8
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L6HBz+sZJ2MzxGthdslhSjontff4DIsZjprCeQlL+jc=;
        b=fYr1+bDSGqHtfuketBtnHtaOrTVUV9C5IpwJ5ObVA2h8nXfwWDZGU63lfj77TwTWs2
         Nn/dbI6YKLAlkAuXeeRLSV2gDf+9fQb4n4bKkWXzc/HguLNzOjD2jjmFTT1y2iGFauxO
         4GT2GXTLBzXcWDJsBQyY4Ty/wjwnBHNlzRECApt4nMKCY+wgvoWUDbL0o/d+wGimx3+0
         dsTxkuVvA+KmH+cSIsEetZtvkwMd1zZ5uQ/V75ifDQNt+Y6FMD5+zN9O7iJcofkYaGSt
         jX6PA/ayGkZzlZwtp2+e2tgU841Xf/WQqBlxKPyZjm6lOdKt8qWml+q4EsR7HTsNPmiE
         F3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L6HBz+sZJ2MzxGthdslhSjontff4DIsZjprCeQlL+jc=;
        b=CZAKghLkapt1dQt8wKR9qD87KI5q6Ht2wnLWl0VA/cKeyqqlITHzGwKmdHqkgN64GG
         b+fgq9AoiWlUF8Zl/evoiO0/01kMgdDCYD2bAUhHt8avZZqWRr/nXIp2uy+xGrzzQ+xq
         YZEP+Xj22INEhmoJnBwiMVOT94zR/03Il4NB+5aZl+bdUnUw1ZnNEovcekc8WNo8wd/3
         H7gVosFw/9zPGLbx/jtQhVc3cgTjvJrVyXenr7wf2hrujPyq0Z4dLfQWchLxX9sXTmAP
         l/A58VIOcJZxUQgcbOOCbx5lqkM/SuVka/AY9TpwTYokUddJhyeT6ZgoWDvCZvvgjngD
         Recw==
X-Gm-Message-State: AOAM5301Gfe4Tc2k8g70a28hQGmN3B10qy8wTU1Tzsl6Rg0W47Iipe6B
        BlniCdrNk91g4yRfnV5V3HHJnAVHS4ctnA==
X-Google-Smtp-Source: ABdhPJyaKeN/yHEAvXHoeOIdae+jkLyHmwW3UjBqH0uhXjANfrqjr6HZljdPFtJpaYrl+bfBt1x2LA==
X-Received: by 2002:ac8:5ccd:: with SMTP id s13mr5541380qta.510.1639815310047;
        Sat, 18 Dec 2021 00:15:10 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:09 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 05/13] net: dsa: realtek: convert subdrivers into modules
Date:   Sat, 18 Dec 2021 05:14:17 -0300
Message-Id: <20211218081425.18722-6-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preparing for multiple interfaces support, the drivers
must be independent of realtek-smi.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
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
index 1578b6650255..351df8792ab3 100644
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
2.34.0

