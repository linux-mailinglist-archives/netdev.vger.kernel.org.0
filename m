Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99344512E96
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344362AbiD1IhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344451AbiD1IgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:36:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE921A6E0C
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id q20so2497654wmq.1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iUV3MD6MJVtQufo/3QTs0bizwDdcnDn7xd+ebVY+1Ig=;
        b=z7Kc+STRzxPgMhGBQTxsoGW7qSFRwplz7ysTPRXax1PT8KvV+MY0G/TRdeuDboWO5+
         IKNzmOW9PWf+cde/wPAUlkaAlnCqm480rnbplSUylCt0Y4bzFItK2Z6xuh+J6mkhn3CA
         muVBU0wBNT3aO0A52LyGol71xCrCCYO3mDyB5sFbHg4BerZw/VhMkwKJL9ivaTwoUbMH
         muagIeIi8KCpyK+fOTthYRfD+b/GX5Jt54Y3zXL8F8SGmr9z/0QZY6d+tYd5e5KwAE+O
         dh9NG0aAX9hsMdvRdmK5iHqMw8cdXNQ+4cRpkDYlHpqEyodlGPi39b/D0XY0q6AUHpH7
         AMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iUV3MD6MJVtQufo/3QTs0bizwDdcnDn7xd+ebVY+1Ig=;
        b=0o4mUnPNyVxVntaM7Zs+nTlMQ/cAcGDZK++6cYskO41ZOg+PqOhvjzvcsFH8CEEGBt
         5hiAN6i+yFtDHdgZImWo7MuijyH+vj11ps/BCQouItCzeJzGF5VetjFFAaOY/5EfIsT/
         AOZdTE21zWq56iBjoWyakbp86T8f1hdYlSAYwSC9TZbds0q/FWxLjsbSQ+fiOgHD19OG
         Kxh4axmDx4/UEz4XVTogQ+btQtnnzf/OahPGUH5DTiQRc6LUpW2n/PpRs2XO5wjTbEKQ
         GODclXaRVUExOeGJPbgDR79Gg7h+MnYl5ehhoFKFvmxpzJC/hlg3QmQdqBt2IdOjElt/
         ApEg==
X-Gm-Message-State: AOAM531uain+Ih2jdFKDwMoPIphrIXUZ6lGYOJ++qP+nL6/BFgJgkRns
        A3mYvKXumEGnQm3wEE354MfQDtiRC8nd6CnHFECJWg==
X-Google-Smtp-Source: ABdhPJzd4PL9toOx7EcOqqv9hRX/KxjJFzbV2jiP8qTDAJArmBiqQyjE7YagE4bZrZDb0qHUK7eHkQ==
X-Received: by 2002:a1c:4e0b:0:b0:393:fd8f:e340 with SMTP id g11-20020a1c4e0b000000b00393fd8fe340mr8134882wmh.136.1651134554983;
        Thu, 28 Apr 2022 01:29:14 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id bj3-20020a0560001e0300b0020af3d365f4sm1876249wrb.98.2022.04.28.01.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 01:29:14 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v3 2/3] net: phy: adin: add support for clock output
Date:   Thu, 28 Apr 2022 11:28:47 +0300
Message-Id: <20220428082848.12191-3-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428082848.12191-1-josua@solid-run.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
well as providing the reference clock on CLK25_REF.

Add support for selecting the clock via device-tree properties.

Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Josua Mayer<josua@solid-run.com>
---
V2 -> V3: fix integer-as-null-pointer compiler warning
V1 -> V2: revised dts property name for clock(s)
V1 -> V2: implemented all 6 bits in the clock configuration register

 drivers/net/phy/adin.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5ce6da62cc8e..2de3eaddfb8e 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -99,6 +99,15 @@
 #define ADIN1300_GE_SOFT_RESET_REG		0xff0c
 #define   ADIN1300_GE_SOFT_RESET		BIT(0)
 
+#define ADIN1300_GE_CLK_CFG_REG			0xff1f
+#define   ADIN1300_GE_CLK_CFG_MASK		GENMASK(5, 0)
+#define   ADIN1300_GE_CLK_CFG_RCVR_125		BIT(5)
+#define   ADIN1300_GE_CLK_CFG_FREE_125		BIT(4)
+#define   ADIN1300_GE_CLK_CFG_REF_EN		BIT(3)
+#define   ADIN1300_GE_CLK_CFG_HRT_RCVR		BIT(2)
+#define   ADIN1300_GE_CLK_CFG_HRT_FREE		BIT(1)
+#define   ADIN1300_GE_CLK_CFG_25		BIT(0)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -433,6 +442,37 @@ static int adin_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static int adin_config_clk_out(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	const char *val = NULL;
+	u8 sel = 0;
+
+	device_property_read_string(dev, "adi,phy-output-clock", &val);
+	if(!val) {
+		/* property not present, do not enable GP_CLK pin */
+	} else if(strcmp(val, "25mhz-reference") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_25;
+	} else if(strcmp(val, "125mhz-free-running") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_FREE_125;
+	} else if(strcmp(val, "125mhz-recovered") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_RCVR_125;
+	} else if(strcmp(val, "adaptive-free-running") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_HRT_FREE;
+	} else if(strcmp(val, "adaptive-recovered") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_HRT_RCVR;
+	} else {
+		phydev_err(phydev, "invalid adi,phy-output-clock\n");
+		return -EINVAL;
+	}
+
+	if(device_property_read_bool(dev, "adi,phy-output-reference-clock"))
+		sel |= ADIN1300_GE_CLK_CFG_REF_EN;
+
+	return phy_modify_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_CLK_CFG_REG,
+			      ADIN1300_GE_CLK_CFG_MASK, sel);
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
@@ -455,6 +495,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_clk_out(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.34.1

