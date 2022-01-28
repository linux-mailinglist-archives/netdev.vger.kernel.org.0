Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B58A49F341
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346273AbiA1GF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346278AbiA1GFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:05:55 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87860C061747
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:55 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id g15-20020a9d6b0f000000b005a062b0dc12so4806825otp.4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9r3/1+7Tf/oc4kKNM1uocD10d58Dj2R9kKVD6jwpMe8=;
        b=j9DqWq+ASlwBIRs+z7hKtAy4Nr4iIxz7JmII+9ck7eEbqH2Gd9MhRVj2MZBNgS95VR
         GiiYojpGT2HcnhSvwmpF/uzvioUf4ocYY3o6V1kzZFu2D0tOW96kx9f3jOqQ8f2PhAjS
         WqVvnG0ZURBWEZz2Rekgn5jV1ZrzpElwGv4JzFvDYGbS51QVI6sNGrvHoZa+YuEtUALh
         t0vyRk6XKyAy+Y7knJ6cKddzxboQzX3X/Q5i/bKmvARcd4GxcZLafM1oLY1O2Gg6l5v+
         rEWfaSbVlTNpNsO3H19zRarPiHuqnSOhtDVHNcAV3Bu1zXnaIQQ+T998XGIbqgMUGTA8
         XbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9r3/1+7Tf/oc4kKNM1uocD10d58Dj2R9kKVD6jwpMe8=;
        b=qi2kKS20/dCtIK7Ky7wbqw761iNlx7cYaBtOhp5XUuthvmndcHXq1cWI+12+Ha+s+Y
         5P5OvPPEogNjljlSa88DGyuK7pMDznSlfNiklvROLxOnnbNf+KikiSWNbsl3rWTV6GMr
         FH0I1BZNwmpfV8TB91OQ/9ZcgmiTaNN1ItiQf0XHj7qB2rLpOvvjN1FkiMgC/AVL+O+D
         wOoc7yzw0wJnKdPoIFcm4iGAkiDmTpDjgQYq/glTJKhp2TrnF9US4t2Gu0VELVgXtVOd
         OR/Gp1gSash4NcUMpkGBuUeiO48Pf/ZPOHxUFUprFwtBGZPI0ZQCx3ogjqQbBfl6e2kd
         /GnQ==
X-Gm-Message-State: AOAM5332cjVJqnxzcdUYBK7X+m/iTT2vA1NmmEzQwojYvQMcivfUYmby
        rdgKC2ZUmW1BJHAKjUxQqysIAnzgZBQO7Q==
X-Google-Smtp-Source: ABdhPJy4lXj2WHwcYlV4vpwo8yt3romQOK/euzESdAQ2w/qr/ggHaH24KoR/q3k6vfQyFu3kB87OMw==
X-Received: by 2002:a9d:6950:: with SMTP id p16mr3975547oto.149.1643349954717;
        Thu, 27 Jan 2022 22:05:54 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:05:54 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 05/13] net: dsa: realtek: convert subdrivers into modules
Date:   Fri, 28 Jan 2022 03:05:01 -0300
Message-Id: <20220128060509.13800-6-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
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
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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
index 5fb86ae2339c..04df06e352d3 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -494,19 +494,23 @@ static void realtek_smi_shutdown(struct platform_device *pdev)
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
@@ -522,4 +526,6 @@ static struct platform_driver realtek_smi_driver = {
 };
 module_platform_driver(realtek_smi_driver);
 
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("Driver for Realtek ethernet switch connected via SMI interface");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index a50cae28b7ae..f91763029dd4 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1986,3 +1986,7 @@ const struct realtek_variant rtl8365mb_variant = {
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
index b301408028ef..7dea8db56b6c 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1816,3 +1816,7 @@ const struct realtek_variant rtl8366rb_variant = {
 	.chip_data_sz = sizeof(struct rtl8366rb),
 };
 EXPORT_SYMBOL_GPL(rtl8366rb_variant);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("Driver for RTL8366RB ethernet switch");
+MODULE_LICENSE("GPL");
-- 
2.34.1

