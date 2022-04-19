Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17E15068B0
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242187AbiDSKaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242200AbiDSKaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:30:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C8C27B04
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:28 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g18so21755319wrb.10
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G6dhAVYyP/wywNlXMOP4V43Gf3+8APppoWjfx5jTK/w=;
        b=3UN1h382knsq7/ihsf5/UGJAe2yzIlCc0lwTnZ/xfBu8RM60dJZheaJbCLPr1Dx6Td
         pYhaNwfjGwv0wNjJPVfNP66Ar59GT+hT87QoQCPy7SJeBKnQzK3mpNZo81Jn1ltSJ10O
         AZSqGvFdlVLCr8ACQKy47oG5aaTExoF/Jds0zqv78ymyHdXyO65F3DjcOHGJIkgpHKJ9
         web1lgonzOvq69fis9w3SVB8aThcnT3+hnrjCJLMWlw0olcu74mSI4QDsAMc/Xtw8GAk
         NTJLXa5r82V6JzkNsLhWZWV+JWcSRls/GFfaXhgsEWrk65VNemSi8JAemKMDRum7ggEm
         Y9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6dhAVYyP/wywNlXMOP4V43Gf3+8APppoWjfx5jTK/w=;
        b=bZ6HAWGdH6HwIBqxQrBvzR2i7gSQ4niK2Xe5mNmNfAyguf1N5OvPdRrI7N+1N7Ghwk
         g+Ika+D90sS2xf+DoS3USpm8HAxiibLIMoff+GtWILgvFfFWq2NCcweAnDdjCTiazaK2
         prEoECLNt1t7q+A3zasKXVwj6eDdsmGeg1dJ8FVK7BwHOwFbBIj0Dl7KgCKXkJd6tsVf
         iFze9btmjDf7ZRewlFmXsoptfBeGRm68w3CL5F4gUM8rqlEmJwLzrFG0KDPqTYzMa1zq
         UNYq1d24Y3qA64klACGsaAyeKQVu7fBtJSzpfCewFjXRGM1DJsRgiM30Pcxn3U0R55hk
         u/Jw==
X-Gm-Message-State: AOAM531QbgCCBVzI0362d37EZlKJOUw0WVtV631AiwmmFw/eSFwsah6p
        hVUNmwvY4yJbhDA+nPg+7GLdf0Nvia3CCgRx
X-Google-Smtp-Source: ABdhPJxQhf8jq3gLp+KKe2oI0YbYBbttyCeoLBSaF26ZDhwb/mhs6B5Ed4Xp0OMI0PFaRON2zlMc1A==
X-Received: by 2002:a05:6000:110f:b0:207:a89b:ddf9 with SMTP id z15-20020a056000110f00b00207a89bddf9mr11410223wrw.371.1650364047004;
        Tue, 19 Apr 2022 03:27:27 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id m4-20020a7bcb84000000b00389efb7a5b4sm19036166wmi.17.2022.04.19.03.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 03:27:26 -0700 (PDT)
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
Subject: [PATCH v2 2/3] net: phy: adin: add support for clock output
Date:   Tue, 19 Apr 2022 13:27:08 +0300
Message-Id: <20220419102709.26432-3-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419102709.26432-1-josua@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
V1 -> V2: revised dts property name for clock(s)
V1 -> V2: implemented all 6 bits in the clock configuration register

 drivers/net/phy/adin.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5ce6da62cc8e..e7150a8e34d2 100644
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
+	const char *val = 0;
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

