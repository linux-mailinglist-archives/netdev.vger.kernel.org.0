Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03D3520000
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbiEIOkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237418AbiEIOkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:40:39 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D09D1C6C9E
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:36:45 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x18so19784095wrc.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 07:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HoVmVQwfiBi2YHILDcYtwP/fJDbARk6SD+ZYiz3y2VM=;
        b=BjYFb30KozwqY4XK9gTRnLuy2y15Tj2yMC4zaoJUCgbgnG1gIbX8abvJwASN29bY2d
         ZKH4Pad/3uES7T5p9q/1K/J8wbjn1ihVMiBy5sL71w8qE5wxIynO69/ee16SLUSPgAhU
         B2byfuL8NZvbDLAN3qZQ88UmiQmPbb+JddVIXtLKs0fyV5VooKoaUd5uNE0lZLaZ+mSR
         i9yLJuNK50GXFA49Fbo/TVQ8tBeBoojndgAQMz6W+d82RhIyI6PxvLVaeqg+u58vlRDQ
         aDAPjZARJBl5P1wgLO+snqXGm6nBFMB64eGjVow0YOAfS0o8hcu9gTpMYOap/A84XouZ
         tTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HoVmVQwfiBi2YHILDcYtwP/fJDbARk6SD+ZYiz3y2VM=;
        b=Nad6wlO3iEFObX6PHRCgBCW4ZeYoBhPRb2Lm0A9Oi4DEYwL5xPkkiPRT+aij859NRR
         uwPAgSFM51OTDKxK1s4qCZz7lVAAQIdP4qmtY90XG+dtvT9LP3cDiHXLZP69lmUWmcZn
         CL/3c9CyiKt1ckkd/HXJMJJxim43xcG5WcY7mhg8plRagrsx23iquN2JdAKdktMdrxsn
         HVZHISREvr7DGxDYqsKM62lK/bSGfiXhjIx1KKwIPNdMA+pCKvJe/JV7AP8TyZsAMOcj
         TDY6FrdpGyV8N+Aw73F5XgSBqhWdlwWii7XQqZDCSLxR3yVJmVDrgfpvbgpyb86tZdya
         QBmA==
X-Gm-Message-State: AOAM532FVPP4xMAWzgiChpHNe4HZIMBFNKTygBDIYNoeN0yxesVG3F6Z
        4l619ys6WLu7/MHWzeQdabz3kdYWexMZh9OhwbZWGA==
X-Google-Smtp-Source: ABdhPJw0b20AEi3wemMqAPHZryCPGjaTQID/2ifnOW7RGtSDsioG9CmmFqgS5mQR0BJ4iLsSzrix5Q==
X-Received: by 2002:a5d:56c8:0:b0:20a:d4a1:94de with SMTP id m8-20020a5d56c8000000b0020ad4a194demr13927858wrw.268.1652107003479;
        Mon, 09 May 2022 07:36:43 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id x18-20020adfdd92000000b0020c5253d915sm11121155wrl.97.2022.05.09.07.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 07:36:43 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v4 2/3] net: phy: adin: add support for clock output
Date:   Mon,  9 May 2022 17:36:34 +0300
Message-Id: <20220509143635.26233-3-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220509143635.26233-1-josua@solid-run.com>
References: <20220428082848.12191-1-josua@solid-run.com>
 <20220509143635.26233-1-josua@solid-run.com>
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
V3 -> V4: fix coding style violations reported by Andrew and checkpatch
V2 -> V3: fix integer-as-null-pointer compiler warning
V1 -> V2: revised dts property name for clock(s)
V1 -> V2: implemented all 6 bits in the clock configuration register

 drivers/net/phy/adin.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5ce6da62cc8e..1341249d8d2c 100644
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
+	if (!val) {
+		/* property not present, do not enable GP_CLK pin */
+	} else if (strcmp(val, "25mhz-reference") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_25;
+	} else if (strcmp(val, "125mhz-free-running") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_FREE_125;
+	} else if (strcmp(val, "125mhz-recovered") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_RCVR_125;
+	} else if (strcmp(val, "adaptive-free-running") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_HRT_FREE;
+	} else if (strcmp(val, "adaptive-recovered") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_HRT_RCVR;
+	} else {
+		phydev_err(phydev, "invalid adi,phy-output-clock\n");
+		return -EINVAL;
+	}
+
+	if (device_property_read_bool(dev, "adi,phy-output-reference-clock"))
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
2.35.3

