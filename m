Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C62B477D31
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbhLPUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241257AbhLPUOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:51 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE146C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:50 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id z9so413202qtj.9
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VWH94Un8GoGwi66okxuXS0MUBHEQhsgaWrtRKfs2Cww=;
        b=hI4mwviVo52wlMYPCWDgH/jcLk2nVPzOg73klVYYbbhZweYjcBn3Ni/S2BC/Fp+j16
         qDGj99aubU6thWW/9nXjYwDMifuZBrK5mTdfSSnwP8nKsf6k3lX6sW6ZUxBpCX3/HUyS
         wFcaLtd/ZTr3JkvdP+r0NZKXAxLmGyMf15TdZC1bUE9fScQ5g2G+9O5Ft+MYPAxfh1Xu
         cHaPZmziWV3B5QLxQlUnfNH1QHRrULfeM9NdYai/NT92Y/omBmHl9YTBTsGbuDHcWzab
         TtFsunw9XJCwDVWVo4dqf1Bf/Fpx90oSq6RGgNFJN4snXwEzPurh7mhCPTz9IvC+MMtr
         8sVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VWH94Un8GoGwi66okxuXS0MUBHEQhsgaWrtRKfs2Cww=;
        b=JoOGuCQ+/9mqw8GjNJOVFQFifOV/j6FtW4oRu8EVd/fcTv7nn3b2OS2IZ8ATCuPuAI
         ipUx2ppuYneiOCxnnuf6It2udfyGiBgWXR30BHcu6iTO/N1rtH/7SsKC8ZMMmn9wFZbK
         9tN0kFtcIBtVbBxpkCWzdplLbr4sqP0S3oI5dpGFSwU/LNllWHTvgpfuF//Jo7myE8YV
         JePo3ujUj7JjN0zirDDnwLIlt7VwWjVS56SCqSAKIoAJ+vKGzzrZLAgBWxldlVoUEbJN
         0jHQrmAWpactAZRCh7wwfJj7QzRNtLI0m2bwdNUT4FOqpU9HAQzymCtNvQpWwz5HXuCK
         8Otg==
X-Gm-Message-State: AOAM530zgBxCcrYWInB8bj1ohwT1frF+/8v5WDW+mZ/xxV/hnk2EGQis
        6X6UfK48UrD3t0AIUN8TYh+AENPXdwCGmA==
X-Google-Smtp-Source: ABdhPJxqmxNBfzZzegHExPEh3nAhNAmwm393wQlMVw5v6FozXIM8TSHrDvcZnOChkdBfyIjpPRh7jQ==
X-Received: by 2002:a05:622a:1a9b:: with SMTP id s27mr18748536qtc.417.1639685689665;
        Thu, 16 Dec 2021 12:14:49 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:49 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 13/13] net: dsa: realtek: rtl8367c: add RTL8367S support
Date:   Thu, 16 Dec 2021 17:13:42 -0300
Message-Id: <20211216201342.25587-14-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Realtek's RTL8367S, a 5+2 port 10/100/1000M Ethernet switch.
It shares the same driver family (RTL8367C) with other models
as the RTL8365MB-VC. Its compatible string is "realtek,rtl8367s".

It was tested only with MDIO interface (realtek-mdio), although it might
work out-of-the-box with SMI interface (using realtek-smi).

This patch was based on an unpublished patch from Alvin Šipraga
<alsi@bang-olufsen.dk>.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../bindings/net/dsa/realtek-mdio.txt         |  1 +
 .../bindings/net/dsa/realtek-smi.txt          |  1 +
 drivers/net/dsa/realtek/Kconfig               |  4 +--
 drivers/net/dsa/realtek/realtek-mdio.c        |  1 +
 drivers/net/dsa/realtek/realtek-smi.c         |  4 +++
 drivers/net/dsa/realtek/rtl8367c.c            | 33 +++++++++++++++----
 6 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
index 01b0463b808f..48aa263792ac 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
@@ -11,6 +11,7 @@ Required properties:
       "realtek,rtl8365mb" (4+1 ports)
       "realtek,rtl8366rb" (4+1 ports)
       "realtek,rtl8366s"  (4+1 ports)
+      "realtek,rtl8367s"  (5+2 ports)
 
 Required properties:
 - reg: MDIO PHY ID to access the switch
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index acdb026e5307..b295b8c0d5fc 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -13,6 +13,7 @@ Required properties:
       "realtek,rtl8365mb" (4+1 ports)
       "realtek,rtl8366rb" (4+1 ports)
       "realtek,rtl8366s"  (4+1 ports)
+      "realtek,rtl8367s"  (5+2 ports)
 
 Required properties:
 - mdc-gpios: GPIO line for the MDC clock line.
diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 48194d0dd51f..25de1107732d 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -30,9 +30,9 @@ config NET_DSA_REALTEK_RTL8367C
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
-	  Select to enable support for Realtek RTL8365MB-VC. This subdriver
+	  Select to enable support for Realtek RTL8365MB-VC and RTL8367S. This subdriver
 	  might also support RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB, RTL8364NB,
-	  RTL8364NB-VB, RTL8366SC, RTL8367RB-VB, RTL8367S, RTL8367SB, RTL8370MB, RTL8310SR
+	  RTL8364NB-VB, RTL8366SC, RTL8367RB-VB, RTL8367SB, RTL8370MB, RTL8310SR
 	  in the future.
 
 config NET_DSA_REALTEK_RTL8366RB
diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index b7febd63e04f..1f80b6bdbe5b 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -265,6 +265,7 @@ static const struct of_device_id realtek_mdio_of_match[] = {
 	{ .compatible = "realtek,rtl8366s", .data = NULL, },
 #if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8367C)
 	{ .compatible = "realtek,rtl8365mb", .data = &rtl8367c_variant, },
+	{ .compatible = "realtek,rtl8367s", .data = &rtl8367c_variant, },
 #endif
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 258f90956cec..ecb68a216595 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -511,6 +511,10 @@ static const struct of_device_id realtek_smi_of_match[] = {
 		.compatible = "realtek,rtl8365mb",
 		.data = &rtl8367c_variant,
 	},
+	{
+		.compatible = "realtek,rtl8367s",
+		.data = &rtl8367c_variant,
+	},
 #endif
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek/rtl8367c.c b/drivers/net/dsa/realtek/rtl8367c.c
index a478ddc33a9e..c192ede6ca88 100644
--- a/drivers/net/dsa/realtek/rtl8367c.c
+++ b/drivers/net/dsa/realtek/rtl8367c.c
@@ -90,15 +90,23 @@
 #include "realtek.h"
 
 /* Chip-specific data and limits */
-#define RTL8367C_CHIP_ID_8365MB_VC		0x6367
+#define RTL8367C_CHIP_ID_8367C			0x6367
+/* 0x0276 and 0x0597 as well */
 
-#define RTL8367C_LEARN_LIMIT_MAX	2112
+#define RTL8367C_CHIP_ID_8365MB_VC		RTL8367C_CHIP_ID_8367C
+#define RTL8367C_CHIP_VER_8365MB_VC		0x0040
+
+#define RTL8367C_CHIP_ID_8367S			RTL8367C_CHIP_ID_8367C
+#define RTL8367C_CHIP_VER_8367S			0x00A0
+
+#define RTL8367C_LEARN_LIMIT_MAX		2112
 
 /* Family-specific data and limits */
 #define RTL8367C_PHYADDRMAX	7
 #define RTL8367C_NUM_PHYREGS	32
 #define RTL8367C_PHYREGMAX	(RTL8367C_NUM_PHYREGS - 1)
-#define RTL8367C_MAX_NUM_PORTS  7
+// RTL8370MB and RTL8310SR, possibly suportable by this driver, have 10 ports
+#define RTL8367C_MAX_NUM_PORTS		10
 
 /* Chip identification registers */
 #define RTL8367C_CHIP_ID_REG		0x1300
@@ -1952,10 +1960,21 @@ static int rtl8367c_detect(struct realtek_priv *priv)
 	}
 
 	switch (chip_id) {
-	case RTL8367C_CHIP_ID_8365MB_VC:
-		dev_info(priv->dev,
-			"found an RTL8365MB-VC switch (ver=0x%04x)\n",
-			chip_ver);
+	case RTL8367C_CHIP_ID_8367C:
+		if (chip_ver == RTL8367C_CHIP_VER_8365MB_VC) {
+			dev_info(priv->dev,
+				"found an RTL8365MB-VC switch (ver=0x%04x)\n",
+				chip_ver);
+		} else if (chip_ver == RTL8367C_CHIP_VER_8367S) {
+			dev_info(priv->dev,
+				"found an RTL8367S switch (ver=0x%04x)\n",
+				chip_ver);
+		} else {
+			dev_err(priv->dev, "found an RTL8367C switch with "
+				"unrecognized chip version (ver=0x%04x)\n",
+				chip_ver);
+			return -ENODEV;
+		}
 
 		priv->num_ports = RTL8367C_MAX_NUM_PORTS;
 
-- 
2.34.0

