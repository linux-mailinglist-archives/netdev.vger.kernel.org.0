Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CC3484CCC
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbiAEDQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbiAEDQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:16:17 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D374C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:16:17 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id m25so36173741qtq.13
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KyuS2XSy3WGtrNZRtTq5+LxGebpS1BmD5Es5Ck6Y/5g=;
        b=O+NbYA7q644haZr30dZC3Ik8a/Ube3ew8AZ24X2jJs4VLf+Lu8V1HKwRRBrtQrfSRV
         Dl47lAJV9gOo0010n3UvmoTka0Gu9Z7iMT4bFPbHY+JbVhrWr0SIgx2VMsFW8/+NjBC2
         9wt8MAzR7vu+bvXnb2KNX71u6jTPIai/dcVzbtMnLDJ/+l7UcBBvzC5zWmJq+eYtLqxz
         0vgwG6ERA0slRVR2mCdCjkRIy3oxcsS7/IuBffuGvmsdwhqpRm9+eZaePrUnKiiPeAnC
         oowpDGYmlsWCg8/suOxcMP6i5Lipws6V/ONsGNlrE+5M7Q4bEmPF+/mM0xCksNAfdSNH
         KgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KyuS2XSy3WGtrNZRtTq5+LxGebpS1BmD5Es5Ck6Y/5g=;
        b=Q0gYt7L6Luqmc54/SOSJcYDduBsNREwexnK1+GdA7ZLqG39upK5EmErCmauMSH5rej
         VVo5BKpZofuQacqmDsfFwKqcDnQb0O8m34JJKllST055RH4XgDlCK/w/z5zV5KKMb8lb
         HrM/gQ+FSsUNvYgYM1UVkMVCf8dpjPIkCvd1z5rHZoRPA3RINhE6it0ZJ7Sw0+Sw05ps
         /O9oGHjym1jPrJtr0oqBLy+DDQSfuqJjBFKzezP6ihOD8Tq6iVQvY7oWao+G4jxtGYOB
         ya5Yuqjo3GC/RRuNnuNi/4SBxVdj4pTWzwVj2JWWcddP9gJZ66ztHD3+5voXB/umvhoS
         Fkww==
X-Gm-Message-State: AOAM532jWE7cXrHCWHL+rXPX9+B6oR85ezb5PBXrm2TBTTC3slvZZi5L
        tITnXTp2E/JIEny/hG2VQ1CMyPC1EAGQh6XB
X-Google-Smtp-Source: ABdhPJxD3WZkaIRCjfNyLQ7zI9oD7tIc/pHPF8QO9ACkxTJSMEgWANyRlz/KsGDcKgU3ZBKnkThlKg==
X-Received: by 2002:ac8:7fc3:: with SMTP id b3mr47621703qtk.328.1641352576326;
        Tue, 04 Jan 2022 19:16:16 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:16:15 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 10/11] net: dsa: realtek: rtl8365mb: add RTL8367S support
Date:   Wed,  5 Jan 2022 00:15:14 -0300
Message-Id: <20220105031515.29276-11-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
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
index b505f4d3c5f0..2bed65981c7d 100644
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
index adc72f0844ae..59e08b192c06 100644
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

