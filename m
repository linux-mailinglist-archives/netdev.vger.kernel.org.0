Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2E529CFA
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbiEQIzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243835AbiEQIyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:54:52 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE1343ACC
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:54:50 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a5so19960006wrp.7
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sgd722oUdEQcOnv0YIZAlSc7MpJGDkYyspN8+WTNP0k=;
        b=gDiSHm20XEX7L1yjHyXHGRXyqHCLNt41sUS/naYkE+80UkklGwt+Lx00LvM+mUUK6i
         RqX2zEzkISnoRL+vyVkhOUD5722OmsP+RV1eiN1aDhTeARu4+hHpV7v6imRE4qWoN7NF
         /uoB1GFPmy+OKAU8Qud16c9/K0Ki+YV542qGdvRRvNEtm7ulMNh4ZTW9kXwrzbY9oQOQ
         csggjw90HvNAZLJF6fVTDPFISKi0TPhPkH503Czz5Y9KCT0MllMXYqvm1ieA495kROmP
         6lMuyEaTZ6TBa5w02aFf6awITr92h8iBLp5O7l+PMLsXJL299w+p25I6v/Qonnq35ch4
         /rng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sgd722oUdEQcOnv0YIZAlSc7MpJGDkYyspN8+WTNP0k=;
        b=B3vvRQmVtiIIuxmgvCeUt2+VlEqUOLO4FuDtklBftJkGqqrBKwU5y9zk2uf1ECd1Cw
         /1rLtp5oAt3IHj1tWrb5EI8zC9admCUkijzKRpD824ogb9psbafF8gezebkS1XyTRVzC
         Bq7+iVGpKxwvMdoOmJcqpVD75YSpcz7wvM1NW4o91aVGQBUsYwztrHLNPh2ySGFsnk7l
         xArM8lLXtrWeS/k1kAZRqb0rcxhbx8H1fWQ9dl474FvVWfu4gJWRL0lTZaaa7/07N3c5
         yLQEgArnVlK1ISAmb0rttFqv6EqDYSyMecw6uQHP6UeQ5T47T4EOTPJr3ccejG2r6IFo
         YY8w==
X-Gm-Message-State: AOAM532i/bf2mZDCHTtTh5q4xRgPIkqjOdxs5lqQKHZyKuw8WXvzwkMU
        iiiQgv5TYg7+9DNOH22HvyB0j2hGfkYNda2CpLk=
X-Google-Smtp-Source: ABdhPJzDlWG2AkeO3Xs0Z3Nvn+C8OtjFUHv+pkD+Ck8JsHSBh6GQCuWs7ltgNeDRqNYPfB0gPnOZHg==
X-Received: by 2002:adf:dd06:0:b0:20d:c4b:e76f with SMTP id a6-20020adfdd06000000b0020d0c4be76fmr5877966wrm.581.1652777688925;
        Tue, 17 May 2022 01:54:48 -0700 (PDT)
Received: from localhost.localdomain (bzq-82-81-54-179.red.bezeqint.net. [82.81.54.179])
        by smtp.gmail.com with ESMTPSA id c13-20020adfa70d000000b0020c5253d8bfsm11880386wrd.11.2022.05.17.01.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:54:48 -0700 (PDT)
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
Subject: [PATCH v5 2/3] net: phy: adin: add support for clock output
Date:   Tue, 17 May 2022 11:54:30 +0300
Message-Id: <20220517085431.3895-2-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220517085431.3895-1-josua@solid-run.com>
References: <20220517085143.3749-1-josua@solid-run.com>
 <20220517085431.3895-1-josua@solid-run.com>
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

Technically the phy also supports a recovered 125MHz clock for
synchronous ethernet. SyncE should be configured dynamically at
runtime, however Linux does not currently have a toggle for this,
so support is explicitly omitted.

Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Josua Mayer<josua@solid-run.com>
---
V4 -> V5: removed recovered clock options
V3 -> V4: fix coding style violations reported by Andrew and checkpatch
V2 -> V3: fix integer-as-null-pointer compiler warning
V1 -> V2: revised dts property name for clock(s)
V1 -> V2: implemented all 6 bits in the clock configuration register

 drivers/net/phy/adin.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5ce6da62cc8e..ee374a85544a 100644
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
@@ -433,6 +442,33 @@ static int adin_set_tunable(struct phy_device *phydev,
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
+	} else if (strcmp(val, "adaptive-free-running") == 0) {
+		sel |= ADIN1300_GE_CLK_CFG_HRT_FREE;
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
@@ -455,6 +491,10 @@ static int adin_config_init(struct phy_device *phydev)
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

