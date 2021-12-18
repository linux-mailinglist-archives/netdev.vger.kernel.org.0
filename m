Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335614799A2
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhLRIPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbhLRIPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:31 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6E4C061748
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:29 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id kd9so4545569qvb.11
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zZQZN3CAyvIk/V+awDSEjHW9+dZaQ6RnpOTz0Vjv2R0=;
        b=XMysQsXsCvlZDloCQzt00UtFF54I7lm3NOYvg/grjMnAGDAHEWrgjBcybgvn2495L+
         O5eZo+dltYakq4A2rns3ft9DxK8WcrYy85TtyWx3PJGi06DsQThQ4X0QTe1tHO+Wh02K
         dv+iCDmxnVIoporTi34qYsv0HFX2C4EOwtKyi9/Tborl0OQY1IDN7U+sRNRcyjKC7RcJ
         X+pyYCyejoksBwVLmsjKOZPQmX/YEKJH2nl0EUj8N2VtVEec54iKxtgt0NBqfnf7BlG0
         pFINUGbAaEU6hxwCsbrgqoPhWs7R1jhF1uaOJRXfs4jFDCrmJkiqvqKNIZ2gUEcyy6yF
         tKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zZQZN3CAyvIk/V+awDSEjHW9+dZaQ6RnpOTz0Vjv2R0=;
        b=0D+UpZGtI4Y70owlHDNuD46lEIWWbSnNh0n1wbK7Ami3EX8eFToCUeK27OeLH9ta3V
         QpLcFc+UX3d6VMnqI/rnKbyYlCVBYgRm/vYw5Yv5ehPaWARBUCCAnyr8ADHGqGSpt67w
         /hQdFuksRbrlLmoPCUZArlo1qn8rjm5lfNXkUaxYVJRNO2Pr8khraZoiPDGPdoM4AJYs
         pO550AF97Pj66ZxNz1tagwjJeCIy0IFjL+Mjp39NdQjVv6heyf5Cpu54UBZFwLwsF/Cb
         X4fUZ6jZ8DZdOtWfMlPuLmu4MFhTRogP8MRJGazYAoUslHsY2h5aH7oSMBGzpcyZhPPA
         GcUQ==
X-Gm-Message-State: AOAM530uRGGuO3UkZgqn7s9i7WwKJKkZ5vnK70YlNiFiFcwjdK1KGw6p
        j4bD5NY33aHS8M54fcrYHWV4AAAWQPsQJA==
X-Google-Smtp-Source: ABdhPJzkUGnWXrovQKB+hggXXBMMnEn+7pGP9VNnFFwDuE3qdlmcJtOOedv3Z/fjnnRlLErp/XhvlQ==
X-Received: by 2002:ad4:5c45:: with SMTP id a5mr160738qva.7.1639815328960;
        Sat, 18 Dec 2021 00:15:28 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:28 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 12/13] net: dsa: realtek: rtl8365mb: add RTL8367S support
Date:   Sat, 18 Dec 2021 05:14:24 -0300
Message-Id: <20211218081425.18722-13-luizluca@gmail.com>
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
 drivers/net/dsa/realtek/Kconfig        |  5 ++++-
 drivers/net/dsa/realtek/realtek-mdio.c |  1 +
 drivers/net/dsa/realtek/realtek-smi.c  |  4 ++++
 drivers/net/dsa/realtek/rtl8365mb.c    | 31 +++++++++++++++++++++-----
 4 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 73b26171fade..16521500a888 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -31,7 +31,10 @@ config NET_DSA_REALTEK_RTL8365MB
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
-	  Select to enable support for Realtek RTL8365MB
+	  Select to enable support for Realtek RTL8365MB-VC and RTL8367S. This subdriver
+	  might also support RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB, RTL8364NB,
+	  RTL8364NB-VB, RTL8366SC, RTL8367RB-VB, RTL8367SB, RTL8370MB, RTL8310SR
+	  in the future.
 
 config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 08d13bb94d91..0acb95142b7e 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -248,6 +248,7 @@ static const struct of_device_id realtek_mdio_of_match[] = {
 	{ .compatible = "realtek,rtl8366s", .data = NULL, },
 #if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{ .compatible = "realtek,rtl8365mb", .data = &rtl8365mb_variant, },
+	{ .compatible = "realtek,rtl8367s", .data = &rtl8365mb_variant, },
 #endif
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 32690bd28128..0fc096b355c5 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -511,6 +511,10 @@ static const struct of_device_id realtek_smi_of_match[] = {
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
index b79a4639b283..e58dd4d1e7b8 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -103,13 +103,19 @@
 
 /* Chip-specific data and limits */
 #define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
-#define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
+#define RTL8365MB_CHIP_VER_8365MB_VC		0x0040
+
+#define RTL8365MB_CHIP_ID_8367S			0x6367
+#define RTL8365MB_CHIP_VER_8367S		0x00A0
+
+#define RTL8365MB_LEARN_LIMIT_MAX		2112
 
 /* Family-specific data and limits */
 #define RTL8365MB_PHYADDRMAX	7
 #define RTL8365MB_NUM_PHYREGS	32
 #define RTL8365MB_PHYREGMAX	(RTL8365MB_NUM_PHYREGS - 1)
-#define RTL8365MB_MAX_NUM_PORTS  7
+// RTL8370MB and RTL8310SR, possibly suportable by this driver, have 10 ports
+#define RTL8365MB_MAX_NUM_PORTS		10
 
 /* Chip identification registers */
 #define RTL8365MB_CHIP_ID_REG		0x1300
@@ -1964,9 +1970,22 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
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
 
@@ -1974,7 +1993,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
 		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
-		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
+		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-- 
2.34.0

