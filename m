Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F333379CB8
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhEKCL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhEKCKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:10:13 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF5AC061364;
        Mon, 10 May 2021 19:07:47 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d11so18465144wrw.8;
        Mon, 10 May 2021 19:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LjF+h6zVM9Quo5sRZfrPUJDPQbdHpzTgaoj5QFEqGYQ=;
        b=MpgaUcXFhVwbeojAiutw8iYUiolQ5+dB9mY/vwgIPNpgDzRchRTJiToO37cd4G8Kqw
         G82gLQTx084faQPXp6ZJJCswF0gP6AyrwYve4r+xYII56M44O5WZtK1DIUgIYs9+6+S2
         zyVUmptPBp7genEEzzS6MMzzn3G/ck3RGYuAltSiTPzkO9j4e5cl8Z2b9i7xvuM32YP6
         F8oFkoiYljCj6JuXH8qgKmlSocCTnTAi4XgZ9kLj0Na8YYbe4BimM4hW+PMcj+KrzIu/
         l+zz81Oo3U+RN6XODVVZ7sMivCYiZNPVd2sJKpZo2R9wzr2TD6rxB2reYTlidp/NcM/F
         UJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LjF+h6zVM9Quo5sRZfrPUJDPQbdHpzTgaoj5QFEqGYQ=;
        b=i5U+NQzWOOKGWVZuOk5bUZFg3klBItmVW4xuGI0xk9vRgxfvQHadHicLrJeFX+3iBQ
         rcwNFvJiv+yeEaym3MR62Moy6bYsMpODEeqeKfMzHPA/yxM2VRmG95Oo6YP/S+sVSREW
         0W1HCkd3S9MypGiylUSy6mGULqIKjqId1ybdZ/ZVD+5rE4m0g6tnNgXoyezDChP9/ham
         u+QS3X8z1WM3kdOpedFNtwTn0jeSb13vPTxywOWXLvnLe8V2QMfpMCB9TERy6+AlZaLW
         Qavc1dIKt5kNfx9TME1b6eHrDB+kSNanUJP6JQVKNU9ajwn+gEYpfZSKQ2Mw6xX+/zj8
         4YLg==
X-Gm-Message-State: AOAM530F42bLlPp6QFDHvkBlJC5xx56HpuqfEePOkdT5rco9d4KZM56e
        vkSU4bjp9azKzjCs8MdiuQc=
X-Google-Smtp-Source: ABdhPJxvms7MjATLWv1uG6P8op4wY7ozDf5l7NhXWBA90F8VE952fM8uiQQW9DdrrXldz1avftj3NQ==
X-Received: by 2002:adf:f90c:: with SMTP id b12mr12323304wrr.409.1620698866044;
        Mon, 10 May 2021 19:07:46 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:45 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 24/25] net: phy: at803x: clean whitespace errors
Date:   Tue, 11 May 2021 04:04:59 +0200
Message-Id: <20210511020500.17269-25-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean any whitespace errors and fix not aligned define.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 32af52dd5aed..d2378a73de6f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -83,8 +83,8 @@
 #define AT803X_MODE_CFG_MASK			0x0F
 #define AT803X_MODE_CFG_SGMII			0x01
 
-#define AT803X_PSSR			0x11	/*PHY-Specific Status Register*/
-#define AT803X_PSSR_MR_AN_COMPLETE	0x0200
+#define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
+#define AT803X_PSSR_MR_AN_COMPLETE		0x0200
 
 #define AT803X_DEBUG_REG_0			0x00
 #define AT803X_DEBUG_RX_CLK_DLY_EN		BIT(15)
@@ -128,24 +128,28 @@
 #define AT803X_CLK_OUT_STRENGTH_HALF		1
 #define AT803X_CLK_OUT_STRENGTH_QUARTER		2
 
-#define AT803X_DEFAULT_DOWNSHIFT 5
-#define AT803X_MIN_DOWNSHIFT 2
-#define AT803X_MAX_DOWNSHIFT 9
+#define AT803X_DEFAULT_DOWNSHIFT		5
+#define AT803X_MIN_DOWNSHIFT			2
+#define AT803X_MAX_DOWNSHIFT			9
 
 #define AT803X_MMD3_SMARTEEE_CTL1		0x805b
 #define AT803X_MMD3_SMARTEEE_CTL2		0x805c
 #define AT803X_MMD3_SMARTEEE_CTL3		0x805d
 #define AT803X_MMD3_SMARTEEE_CTL3_LPI_EN	BIT(8)
 
-#define ATH9331_PHY_ID 0x004dd041
-#define ATH8030_PHY_ID 0x004dd076
-#define ATH8031_PHY_ID 0x004dd074
-#define ATH8032_PHY_ID 0x004dd023
-#define ATH8035_PHY_ID 0x004dd072
+#define ATH9331_PHY_ID				0x004dd041
+#define ATH8030_PHY_ID				0x004dd076
+#define ATH8031_PHY_ID				0x004dd074
+#define ATH8032_PHY_ID				0x004dd023
+#define ATH8035_PHY_ID				0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
-#define AT803X_PAGE_FIBER		0
-#define AT803X_PAGE_COPPER		1
+#define AT803X_PAGE_FIBER			0
+#define AT803X_PAGE_COPPER			1
+
+/* don't turn off internal PLL */
+#define AT803X_KEEP_PLL_ENABLED			BIT(0)
+#define AT803X_DISABLE_SMARTEEE			BIT(1)
 
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
@@ -153,8 +157,6 @@ MODULE_LICENSE("GPL");
 
 struct at803x_priv {
 	int flags;
-#define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
-#define AT803X_DISABLE_SMARTEEE	BIT(1)
 	u16 clk_25m_reg;
 	u16 clk_25m_mask;
 	u8 smarteee_lpi_tw_1g;
-- 
2.30.2

