Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B367338A74
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 11:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhCLKo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 05:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbhCLKoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 05:44:07 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AB0C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 02:44:06 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id v2so31953251lft.9
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 02:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6EfcaawdrmvSu2gh2Px/Pikw9FQkPq0ilq3GxSttWbM=;
        b=OdKKY947M2i8lhOJ/dsZChtuML40A9z9uqRl0jyHfqscFrRdTvy8vbeXJaP65RmKpY
         8rrCk3cmopSQGflX8u3qv5k8m6Bgm7OpFkAxJvRiwhjoFlziAb1nXwLhq+1AiRnx4BZg
         d0r1T7YeRvfXcqQuKt6/GsyMIhuOl929oGhlF/a6V/tWZyxEFYW7Aq7yXYGTucg2GtMg
         Ji30bEdsSmPhrDobVLe98SeAUvyWtsyFAWF8uzQ0Vo7iE4LVzKB1Kds7ornaBYjEr9ea
         3bd/NgxJqWTwQwZBI2d2Q+4Ly0m3+IgPuxGz+pEQC9Q5tiCBXwZiNADN9iwaixPd+Zov
         ww+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6EfcaawdrmvSu2gh2Px/Pikw9FQkPq0ilq3GxSttWbM=;
        b=qSoBZBZZ+pQYHX1kAuQ6uwKD0l7WztkcP++XsjNNt8lOvNezi4AZkXq7u/lSs9Qhip
         aiD/pMr5y4+xkbJsUQrupsD2Rh/rBZvPOm9uP5sZlnZnTtiwUAjl1ogwlpR9/bXG9fS7
         /YYmBmaHxIEiKDm9WQTfX2WLpNQ6i4h1y8jpjJJ0QJIhKC0LRX+XpYXrt8brL/DINeeM
         bb4ha9HsbY1ygBH1u+UjLRByxJbShhgfeNKTcqtc/w66NHraB5n+8a9j4IaNwPOqEzuj
         T87/iwQJGQiPZQqIIJJoAxXPWLyKo4p9+FM75mq1AwndmvfwNpbbnxwMXCs0VO2ppG9F
         fuMA==
X-Gm-Message-State: AOAM531MBDPl00FLfNySCizeR0vGsy0s9UiGlSiTShDVr5wCXcSto/l4
        gzR0G5MYHzRtzCRUKqAfsug=
X-Google-Smtp-Source: ABdhPJye2yN3DYSSYieXwAivyqz/A8EeJy6iARIik0PNOxELGzhQJa6gBBhCMGBwbeN2M6NWoTPpIA==
X-Received: by 2002:ac2:54ab:: with SMTP id w11mr5150127lfk.260.1615545845160;
        Fri, 12 Mar 2021 02:44:05 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id w5sm1676606lfu.179.2021.03.12.02.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 02:44:04 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 2/2] net: dsa: bcm_sf2: setup BCM4908 internal crossbar
Date:   Fri, 12 Mar 2021 11:41:08 +0100
Message-Id: <20210312104108.10862-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312104108.10862-1-zajec5@gmail.com>
References: <20210312104108.10862-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

On some SoCs (e.g. BCM4908, BCM631[345]8) SF2 has an integrated
crossbar. It allows connecting its selected external ports to internal
ports. It's used by vendors to handle custom Ethernet setups.

BCM4908 has following 3x2 crossbar. On Asus GT-AC5300 rgmii is used for
connecting external BCM53134S switch. GPHY4 is usually used for WAN
port. More fancy devices use SerDes for 2.5 Gbps Ethernet.

              ┌──────────┐
SerDes ─── 0 ─┤          │
              │   3x2    ├─ 0 ─── switch port 7
 GPHY4 ─── 1 ─┤          │
              │ crossbar ├─ 1 ─── runner (accelerator)
 rgmii ─── 2 ─┤          │
              └──────────┘

Use setup data based on DT info to configure BCM4908's switch port 7.
Right now only GPHY and rgmii variants are supported. Handling SerDes
can be implemented later.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Use phy_interface_mode_is_rgmii()
---
 drivers/net/dsa/bcm_sf2.c      | 45 ++++++++++++++++++++++++++++++++++
 drivers/net/dsa/bcm_sf2.h      |  1 +
 drivers/net/dsa/bcm_sf2_regs.h |  7 ++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index bc0dbc0daa1a..28c3cd11520f 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -435,6 +435,44 @@ static int bcm_sf2_sw_rst(struct bcm_sf2_priv *priv)
 	return 0;
 }
 
+static void bcm_sf2_crossbar_setup(struct bcm_sf2_priv *priv)
+{
+	struct device *dev = priv->dev->ds->dev;
+	int shift;
+	u32 mask;
+	u32 reg;
+	int i;
+
+	mask = BIT(priv->num_crossbar_int_ports) - 1;
+
+	reg = reg_readl(priv, REG_CROSSBAR);
+	switch (priv->type) {
+	case BCM4908_DEVICE_ID:
+		shift = CROSSBAR_BCM4908_INT_P7 * priv->num_crossbar_int_ports;
+		reg &= ~(mask << shift);
+		if (0) /* FIXME */
+			reg |= CROSSBAR_BCM4908_EXT_SERDES << shift;
+		else if (priv->int_phy_mask & BIT(7))
+			reg |= CROSSBAR_BCM4908_EXT_GPHY4 << shift;
+		else if (phy_interface_mode_is_rgmii(priv->port_sts[7].mode))
+			reg |= CROSSBAR_BCM4908_EXT_RGMII << shift;
+		else if (WARN(1, "Invalid port mode\n"))
+			return;
+		break;
+	default:
+		return;
+	}
+	reg_writel(priv, reg, REG_CROSSBAR);
+
+	reg = reg_readl(priv, REG_CROSSBAR);
+	for (i = 0; i < priv->num_crossbar_int_ports; i++) {
+		shift = i * priv->num_crossbar_int_ports;
+
+		dev_dbg(dev, "crossbar int port #%d - ext port #%d\n", i,
+			(reg >> shift) & mask);
+	}
+}
+
 static void bcm_sf2_intr_disable(struct bcm_sf2_priv *priv)
 {
 	intrl2_0_mask_set(priv, 0xffffffff);
@@ -867,6 +905,8 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 		return ret;
 	}
 
+	bcm_sf2_crossbar_setup(priv);
+
 	ret = bcm_sf2_cfp_resume(ds);
 	if (ret)
 		return ret;
@@ -1139,6 +1179,7 @@ struct bcm_sf2_of_data {
 	const u16 *reg_offsets;
 	unsigned int core_reg_align;
 	unsigned int num_cfp_rules;
+	unsigned int num_crossbar_int_ports;
 };
 
 static const u16 bcm_sf2_4908_reg_offsets[] = {
@@ -1163,6 +1204,7 @@ static const struct bcm_sf2_of_data bcm_sf2_4908_data = {
 	.core_reg_align	= 0,
 	.reg_offsets	= bcm_sf2_4908_reg_offsets,
 	.num_cfp_rules	= 0, /* FIXME */
+	.num_crossbar_int_ports = 2,
 };
 
 /* Register offsets for the SWITCH_REG_* block */
@@ -1273,6 +1315,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	priv->reg_offsets = data->reg_offsets;
 	priv->core_reg_align = data->core_reg_align;
 	priv->num_cfp_rules = data->num_cfp_rules;
+	priv->num_crossbar_int_ports = data->num_crossbar_int_ports;
 
 	priv->rcdev = devm_reset_control_get_optional_exclusive(&pdev->dev,
 								"switch");
@@ -1346,6 +1389,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 		goto out_clk_mdiv;
 	}
 
+	bcm_sf2_crossbar_setup(priv);
+
 	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
 
 	ret = bcm_sf2_mdio_register(ds);
diff --git a/drivers/net/dsa/bcm_sf2.h b/drivers/net/dsa/bcm_sf2.h
index a0fe0bf46d9f..0d48402068d3 100644
--- a/drivers/net/dsa/bcm_sf2.h
+++ b/drivers/net/dsa/bcm_sf2.h
@@ -74,6 +74,7 @@ struct bcm_sf2_priv {
 	const u16			*reg_offsets;
 	unsigned int			core_reg_align;
 	unsigned int			num_cfp_rules;
+	unsigned int			num_crossbar_int_ports;
 
 	/* spinlock protecting access to the indirect registers */
 	spinlock_t			indir_lock;
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 1d2d55c9f8aa..e297b09411f3 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -48,6 +48,13 @@ enum bcm_sf2_reg_offs {
 #define  PHY_PHYAD_SHIFT		8
 #define  PHY_PHYAD_MASK			0x1F
 
+/* Relative to REG_CROSSBAR */
+#define CROSSBAR_BCM4908_INT_P7		0
+#define CROSSBAR_BCM4908_INT_RUNNER	1
+#define CROSSBAR_BCM4908_EXT_SERDES	0
+#define CROSSBAR_BCM4908_EXT_GPHY4	1
+#define CROSSBAR_BCM4908_EXT_RGMII	2
+
 #define REG_RGMII_CNTRL_P(x)		(REG_RGMII_0_CNTRL + (x))
 
 /* Relative to REG_RGMII_CNTRL */
-- 
2.26.2

