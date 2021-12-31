Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF4E4821FE
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbhLaEfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242693AbhLaEfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:35:01 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5611FC06173E
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:35:01 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 131so24371344qkk.2
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kuJBzShHdfds6UzFh1wUW2TtvGr/r+jS4L1Kt7Ffoac=;
        b=IZynKfmvC2K+APwtV9C6eZsPnsjN+Mgfbd4Iz4fy/UXttoW8HWPTxABbUelgHc+G/x
         oXl3s3WKhFlwN1cW1Gvo6q9Hsxvkgrf7dFQfHKRoX05BLavWSRGCGrBI5mWkrmFhxde6
         VG23QZclF+1D8+N5vFVZfPpfDPnKGeCG7yBH1xU4DPYZ4rT6Q6FT+IGgreIbNsLeLsjC
         RXg8NAz4MAFua3J9dcG0ZYWiEPvfJuU74ck85UOMTonpBL3yoDSoRGwsvB2vnP9yIsGo
         Pq+ordP+SyLjuJm5FF/wYQO095bE/8Cn5gBiuO0oct3YcwZXYBIRrrrT2S9iiHEDPm2r
         P4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kuJBzShHdfds6UzFh1wUW2TtvGr/r+jS4L1Kt7Ffoac=;
        b=y5cr11yXtKQJvDa7Qvu9J4NnCNjYDgFSkzb9JrspBEVjS33I+9zS6Bqnyri8VRmUXe
         PInYzysxB+A/BSH5hbo4c/PfFEi+S/pX5m+5Z34wc6ckHLVj54xAbi41bO8zc9TD9B/q
         K5jC9cFRvVvzL6uIemeWLP3NhXthwUXJ9C31NGimBfcKqEhjcwI/Mmah/wYi1hX7XtF/
         G5vkNZx35V6Lc/n4aCpo3Ut5JDsyBG7eavghbyjhpm7qIIcqpmxWPjSFsN8HQDWxmUaf
         CYepKq/RPz55M9WMjOJUsKwPL3F1eGsf8VUXuZeIs6pPeKiwa6HYInx76YSXPA8irB70
         AA0g==
X-Gm-Message-State: AOAM5311e2nL6MDYYTpxsODvjxRp06PKLXfOeb1fPc3ZkVg+UUzLniB2
        kkMsbiqJ1YSdpWDDLTpvYXzsfLd+207aYivS
X-Google-Smtp-Source: ABdhPJydj9wO4woab7f/z1UVfbVVXeehMxjyFgkUB2+rxGJcyupWnTcckUhzzgKUIY8crdklS6aYew==
X-Received: by 2002:a05:620a:797:: with SMTP id 23mr24028324qka.30.1640925300280;
        Thu, 30 Dec 2021 20:35:00 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:34:59 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 10/11] net: dsa: realtek: rtl8365mb: add RTL8367S support
Date:   Fri, 31 Dec 2021 01:33:05 -0300
Message-Id: <20211231043306.12322-11-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
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
---
 drivers/net/dsa/realtek/Kconfig        |  2 +-
 drivers/net/dsa/realtek/realtek-mdio.c |  1 +
 drivers/net/dsa/realtek/realtek-smi.c  |  4 +++
 drivers/net/dsa/realtek/rtl8365mb.c    | 38 +++++++++++++++++++-------
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 73b26171fade..d0d6b5ba4bdd 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -31,7 +31,7 @@ config NET_DSA_REALTEK_RTL8365MB
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
-	  Select to enable support for Realtek RTL8365MB
+	  Select to enable support for Realtek RTL8365MB-VC and RTL8367S.
 
 config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index ee10a0ecaab6..4a180d4475cb 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -199,6 +199,7 @@ static const struct of_device_id realtek_mdio_of_match[] = {
 #endif
 #if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{ .compatible = "realtek,rtl8365mb", .data = &rtl8365mb_variant, },
+	{ .compatible = "realtek,rtl8367s", .data = &rtl8365mb_variant, },
 #endif
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 1f024e2520a6..c330a4d8ebf0 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -513,6 +513,10 @@ static const struct of_device_id realtek_smi_of_match[] = {
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
index 168e857a4e34..8b6f729f843c 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -102,14 +102,19 @@
 #include "realtek.h"
 
 /* Chip-specific data and limits */
-#define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
-#define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
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
 
 /* Chip identification registers */
 #define RTL8365MB_CHIP_ID_REG		0x1300
@@ -1971,9 +1976,22 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
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
 
@@ -1981,7 +1999,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
 		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
-		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
+		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-- 
2.34.0

