Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA0433F2C5
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhCQOhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhCQOhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:37:25 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545DEC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:37:24 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id t18so3335010lfl.3
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xSCKBV4bfFhMXy4U4QU5AjtoMT9RmQVH9z4XmYH/EZM=;
        b=ISZLtuO7D3ti9wjRMfQn9Pz/IwflNYtjchEhjw3tZe/1RZQ/STX+ToaAbKbWYSQUUC
         2ajUEXnJCVb1g2Jfrm9msoThJ8943zfBa2YsLtbpD82Apli9nphUPT4OMqbxHLghe+FK
         NDelg0f4EXong489T9lOww9PD0UxKx+0V4w+CXZtxPGnMdWKB889K1sNP5QHDEJjkcE1
         EaMDG7Pik/uTN7guCnCjw7gbeSX9u2g5jvPOfQAx62UvnTva9Em8FgebaBRnIs8YFeny
         3YsszdvI//vsecaB8w/5+WPn7s/m65KB5+3qbzKByksFZjyen8kIX+3mdGmKGSFegEuH
         XiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xSCKBV4bfFhMXy4U4QU5AjtoMT9RmQVH9z4XmYH/EZM=;
        b=mYYSqxRwAqChf3hBnLqd2CiCNvG9alxBUx7XQ6MBKpJAKEgTTRizM10syRrCyPVaFi
         pHlbx8k7maV0BpvFLs4ovRjjRFi0/d81Ei3iYE+7+en4s2eYVEZAxOkoB0PCt2PnaxxA
         LIANB38WbrOTg00l7G7XAaZwngWVGl81NVf+P2LOfQA9oBstcww+upaop3p7OiI54rBi
         6e6j8N9sjEWy6e7AbjE8hNIr/czCAuAX46wIEqsF4acfq5qY4EUEqoPYvGSaionTa/7E
         PE/h0NekYdTfjrJUia5IFmLXO9VRFQ29gLClx16r8mmgpZ4ilTtqLNHy17ZMrgh7rA+Y
         lOzQ==
X-Gm-Message-State: AOAM532vBGriC7JgZtDzNWwFcAETxDpM1/qzqCFHA7g44vqDYU5gNRlh
        ki9dksj60m+Xk+WxBHRPozs=
X-Google-Smtp-Source: ABdhPJzr7phAYWmjqLrqTmI6RsM42lb5YTdx5Kd1s0CMUJMyb2rAkIkw0bJBlM5jYEb+FbLgrKXL8A==
X-Received: by 2002:a19:f608:: with SMTP id x8mr2558795lfe.380.1615991842902;
        Wed, 17 Mar 2021 07:37:22 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id k5sm3554745ljb.78.2021.03.17.07.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:37:22 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] net: dsa: bcm_sf2: add function finding RGMII register
Date:   Wed, 17 Mar 2021 15:37:05 +0100
Message-Id: <20210317143706.30809-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210317143706.30809-1-zajec5@gmail.com>
References: <20210317143706.30809-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
1. It doesn't validate port argument
2. It doesn't support chipsets with non-lineral RGMII regs layout

Missing port validation could result in getting register offset from out
of array. Random memory -> random offset -> random reads/writes. It
affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).

Fixes: a78e86ed586d ("net: dsa: bcm_sf2: Prepare for different register layouts")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/bcm_sf2.c      | 51 ++++++++++++++++++++++++++++++----
 drivers/net/dsa/bcm_sf2_regs.h |  2 --
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index ba5d546d06aa..942773bcb7e0 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -32,6 +32,30 @@
 #include "b53/b53_priv.h"
 #include "b53/b53_regs.h"
 
+static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
+{
+	switch (priv->type) {
+	case BCM4908_DEVICE_ID:
+		/* TODO */
+		break;
+	default:
+		switch (port) {
+		case 0:
+			return REG_RGMII_0_CNTRL;
+		case 1:
+			return REG_RGMII_1_CNTRL;
+		case 2:
+			return REG_RGMII_2_CNTRL;
+		default:
+			break;
+		}
+	}
+
+	WARN_ONCE(1, "Unsupported port %d\n", port);
+
+	return 0;
+}
+
 /* Return the number of active ports, not counting the IMP (CPU) port */
 static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
 {
@@ -647,6 +671,7 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 id_mode_dis = 0, port_mode;
+	u32 reg_rgmii_ctrl;
 	u32 reg;
 
 	if (port == core_readl(priv, CORE_IMP0_PRT_ID))
@@ -670,10 +695,14 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 		return;
 	}
 
+	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+	if (!reg_rgmii_ctrl)
+		return;
+
 	/* Clear id_mode_dis bit, and the existing port mode, let
 	 * RGMII_MODE_EN bet set by mac_link_{up,down}
 	 */
-	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+	reg = reg_readl(priv, reg_rgmii_ctrl);
 	reg &= ~ID_MODE_DIS;
 	reg &= ~(PORT_MODE_MASK << PORT_MODE_SHIFT);
 
@@ -681,13 +710,14 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	if (id_mode_dis)
 		reg |= ID_MODE_DIS;
 
-	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+	reg_writel(priv, reg, reg_rgmii_ctrl);
 }
 
 static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
 				    phy_interface_t interface, bool link)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
+	u32 reg_rgmii_ctrl;
 	u32 reg;
 
 	if (!phy_interface_mode_is_rgmii(interface) &&
@@ -695,13 +725,17 @@ static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
 	    interface != PHY_INTERFACE_MODE_REVMII)
 		return;
 
+	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+	if (!reg_rgmii_ctrl)
+		return;
+
 	/* If the link is down, just disable the interface to conserve power */
-	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+	reg = reg_readl(priv, reg_rgmii_ctrl);
 	if (link)
 		reg |= RGMII_MODE_EN;
 	else
 		reg &= ~RGMII_MODE_EN;
-	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+	reg_writel(priv, reg, reg_rgmii_ctrl);
 }
 
 static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
@@ -735,8 +769,13 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->dev->ports[port].eee;
+	u32 reg_rgmii_ctrl;
 	u32 reg, offset;
 
+	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+	if (!reg_rgmii_ctrl)
+		return;
+
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
@@ -750,7 +789,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 		    interface == PHY_INTERFACE_MODE_MII ||
 		    interface == PHY_INTERFACE_MODE_REVMII) {
-			reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+			reg = reg_readl(priv, reg_rgmii_ctrl);
 			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 
 			if (tx_pause)
@@ -758,7 +797,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 			if (rx_pause)
 				reg |= RX_PAUSE_EN;
 
-			reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+			reg_writel(priv, reg, reg_rgmii_ctrl);
 		}
 
 		reg = SW_OVERRIDE | LINK_STS;
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 1d2d55c9f8aa..c7783cb45845 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -48,8 +48,6 @@ enum bcm_sf2_reg_offs {
 #define  PHY_PHYAD_SHIFT		8
 #define  PHY_PHYAD_MASK			0x1F
 
-#define REG_RGMII_CNTRL_P(x)		(REG_RGMII_0_CNTRL + (x))
-
 /* Relative to REG_RGMII_CNTRL */
 #define  RGMII_MODE_EN			(1 << 0)
 #define  ID_MODE_DIS			(1 << 1)
-- 
2.26.2

