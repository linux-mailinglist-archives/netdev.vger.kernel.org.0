Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711CB49F347
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346290AbiA1GGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiA1GGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:15 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2797C061748
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:14 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id q186so10504053oih.8
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OUQK9XHJ2LTFl9/BIo4qauxBEQT6/T44BrQplcqdE8U=;
        b=STmqSH4434eql57dvrcviYPQE5NvE1hoIreo864201tpZ35AE8PYkO+dp+937q53ZH
         fRq2fW8dhPhjKFKNcqUceuPEOsWakwBqdWZGk7e+TYZNJ9te34ez4YerLhOV6gUhCJ0T
         LDhBdFDG80lhCX5Kfy3cOp9o4Nodh26R5vIRegCJYDdz+6xEBIWcoNmxSC5BktsA6dJN
         k9NRzxfDU2K54EZJBGnIHgfAjVFNBLEYVFDmgcRgnbaHdjcXXF+P2vQgrUxNnNeGjMZR
         YWwcCIvnEsvlA7nG7MFyXwnvGv5Bqr5phXtjKf6m+5OjTgkUqXql5FVPd2KQl7vs82kM
         SXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OUQK9XHJ2LTFl9/BIo4qauxBEQT6/T44BrQplcqdE8U=;
        b=UxkcCZ4rBCf8X38sG3haw1lQ1hDhrOlbDiQNEJDyjBjSBxY5+bS9Zu5gPH+nTw7pNg
         DDnGf1EIszg/sEy3BUcLM89YwOgNmgyGKdK1yjXOcdqnCQb1jMlg5yZs46J4NSiMq7po
         y+/oM41A5/Xi06pgW56VSH213gYZcfdEnRjcN3G9sW83SysV+NVy7cab7k04YZkmEYDc
         0Sv6bnjEDurzkymhKZcr+EK/Qz+FbxBBSZN6A3fjZhDaQglBtiqgHtwWQwllS0zQX0wL
         gbsJI6s65uqwnfDAK9mTTVm+P7ASRlymRmGSbGmbRp2NeApHaI5casORee6xZ0qQN/eV
         xgKQ==
X-Gm-Message-State: AOAM532egEzh3DeeYxKeDBDORb3DxnGxOJfYJ6So9m4nbImUrusQSJ+Y
        +ZxNsMWe50/oyZ+qxea0ROQMz77kN5H2ew==
X-Google-Smtp-Source: ABdhPJzW/F5JNfDSZvprln3oygRpaiDS2KXcsrtQe+IPQmeLGFP1V+qiOrMgTryKrwttQxkpg0b6mw==
X-Received: by 2002:a05:6808:1592:: with SMTP id t18mr9373609oiw.231.1643349973958;
        Thu, 27 Jan 2022 22:06:13 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:06:13 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 10/13] net: dsa: realtek: rtl8365mb: add RTL8367S support
Date:   Fri, 28 Jan 2022 03:05:06 -0300
Message-Id: <20220128060509.13800-11-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek's RTL8367S, a 5+2 port 10/100/1000M Ethernet switch.
It shares the same driver family (RTL8367C) with other models
as the RTL8365MB-VC. Its compatible string is "realtek,rtl8367s".

It was tested only with MDIO interface (realtek-mdio), although it might
work out-of-the-box with SMI interface (using realtek-smi).

This patch was based on an unpublished patch from Alvin Šipraga
<alsi@bang-olufsen.dk>.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/realtek/Kconfig        |  2 +-
 drivers/net/dsa/realtek/realtek-mdio.c |  1 +
 drivers/net/dsa/realtek/realtek-smi.c  |  4 +++
 drivers/net/dsa/realtek/rtl8365mb.c    | 42 +++++++++++++++++++-------
 4 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 553f696e7435..5242698143d9 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -32,7 +32,7 @@ config NET_DSA_REALTEK_RTL8365MB
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
-	  Select to enable support for Realtek RTL8365MB
+	  Select to enable support for Realtek RTL8365MB-VC and RTL8367S.
 
 config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index b82f96668218..0c5f2bdced9d 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -206,6 +206,7 @@ static const struct of_device_id realtek_mdio_of_match[] = {
 #endif
 #if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{ .compatible = "realtek,rtl8365mb", .data = &rtl8365mb_variant, },
+	{ .compatible = "realtek,rtl8367s", .data = &rtl8365mb_variant, },
 #endif
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 1ef147e55a4c..946fbbd70153 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -510,6 +510,10 @@ static const struct of_device_id realtek_smi_of_match[] = {
 		.compatible = "realtek,rtl8365mb",
 		.data = &rtl8365mb_variant,
 	},
+	{
+		.compatible = "realtek,rtl8367s",
+		.data = &rtl8365mb_variant,
+	},
 #endif
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index d580afc04b8d..6974decf5ebe 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -102,15 +102,22 @@
 #include "realtek.h"
 
 /* Chip-specific data and limits */
-#define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
-#define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
-static const int rtl8365mb_extint_port_map[] = { -1, -1, -1, -1, -1, -1, 1 };
+#define RTL8365MB_CHIP_ID_8365MB_VC	0x6367
+#define RTL8365MB_CHIP_VER_8365MB_VC	0x0040
+
+#define RTL8365MB_CHIP_ID_8367S		0x6367
+#define RTL8365MB_CHIP_VER_8367S	0x00A0
 
 /* Family-specific data and limits */
-#define RTL8365MB_PHYADDRMAX	7
-#define RTL8365MB_NUM_PHYREGS	32
-#define RTL8365MB_PHYREGMAX	(RTL8365MB_NUM_PHYREGS - 1)
-#define RTL8365MB_MAX_NUM_PORTS  7
+#define RTL8365MB_PHYADDRMAX		7
+#define RTL8365MB_NUM_PHYREGS		32
+#define RTL8365MB_PHYREGMAX		(RTL8365MB_NUM_PHYREGS - 1)
+/* RTL8370MB and RTL8310SR, possibly suportable by this driver, have 10 ports */
+#define RTL8365MB_MAX_NUM_PORTS		10
+#define RTL8365MB_LEARN_LIMIT_MAX	2112
+
+/* valid for all 6-port or less variants */
+static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2, -1, -1};
 
 /* Chip identification registers */
 #define RTL8365MB_CHIP_ID_REG		0x1300
@@ -1966,9 +1973,22 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
 	switch (chip_id) {
 	case RTL8365MB_CHIP_ID_8365MB_VC:
-		dev_info(priv->dev,
-			 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
-			 chip_ver);
+		switch (chip_ver) {
+		case RTL8365MB_CHIP_VER_8365MB_VC:
+			dev_info(priv->dev,
+				 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
+				 chip_ver);
+			break;
+		case RTL8365MB_CHIP_VER_8367S:
+			dev_info(priv->dev,
+				 "found an RTL8367S switch (ver=0x%04x)\n",
+				 chip_ver);
+			break;
+		default:
+			dev_err(priv->dev, "unrecognized switch version (ver=0x%04x)",
+				chip_ver);
+			return -ENODEV;
+		}
 
 		priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
 
@@ -1976,7 +1996,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
 		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
-		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
+		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-- 
2.34.1

