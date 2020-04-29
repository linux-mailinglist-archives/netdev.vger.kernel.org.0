Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76DD1BE798
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgD2Tqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727082AbgD2Tqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5906DC035493;
        Wed, 29 Apr 2020 12:46:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l20so1499813pgb.11;
        Wed, 29 Apr 2020 12:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J0qBpGmXm74u59PdUpmcex0+8Nx3UhOE65qV5C+byAc=;
        b=mXU60n7W5KlSj674qZ6wRc2+TY4jl1O3zQ6rDty/jHysavyNLftX4QkLxepPEgYot6
         gTSO5Qmf16d2oYe8oBczByM1YvhI6bMAduIAop+kMSnwhf3IqRHTx+oYT8kHqKuAJyb6
         OacMxnyscgY2vkEW6vLYkfI5mBSUTkuiwjrT3HohcHepRzBNB0OW5lIM1Nk/ni3B3R7t
         k3O+PuWYLxYxCBbeXo7gCjbeK6P+0/qoRrL9/MlKM4LKDbWBsH0ELEWDftX2On6qHQkZ
         2fOUeZ1e73t83igk7Z133nqgyxg2AkvG3wMUsfncKkQqcODY4dZQEmmBsqbvEDZLX/Hw
         PigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J0qBpGmXm74u59PdUpmcex0+8Nx3UhOE65qV5C+byAc=;
        b=BlviqNx+87U4QUEdv2NZFdWBnxMGG7nKpIvrR7SNJW+aHwQnz+Ya8iRsvJHMC7kVDU
         coTczsW6JDUTyMj1xGKHPBP3oJ5gIfiSqBI0nuPW3QtT731spYF0xaqzd12aC8rmoUzj
         5tEIjx53fwDjzFKwQnsUPcG7MQ/+C6XQsbRudPLObeNUFbk4+JPhE1UeWjmNoPI8vtjK
         lFPH8YyiXZixbRgOHV5H3ZwkhjtxCRo8MFO+w3KQkSQxaA7Q/gkQ5Pp2R2SchM9E3ZH1
         69JYJujlGScNCR9/gzN5OjqUtjSKlNofa/zJ3PuF4UPW/5lhg6qJLY9GFWl0LH9CESmh
         p9cQ==
X-Gm-Message-State: AGi0PuYfja7Thto0mkpYj/UX6nbqOP/iiOJNFtjw9W9SKks4lExKpk+W
        ij0F2slkFp+EG+l91POst2o=
X-Google-Smtp-Source: APiQypJbX3B9Yc4LM6n4Vkb19l0L7aE/svz7d0FvUb4NqkJlktWLYiSCdSEauk+CkyU5eCdXr3in1g==
X-Received: by 2002:aa7:9f93:: with SMTP id z19mr31189717pfr.50.1588189605903;
        Wed, 29 Apr 2020 12:46:45 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:45 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 7/7] net: bcmgenet: add WAKE_FILTER support
Date:   Wed, 29 Apr 2020 12:45:52 -0700
Message-Id: <1588189552-899-8-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588189552-899-1-git-send-email-opendmb@gmail.com>
References: <1588189552-899-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enables support for the WAKE_FILTER method of Wake on
LAN for the GENET driver. The method can be enabled by adding 'f'
to the interface 'wol' setting specified by ethtool.

Rx network flow rules can be specified using ethtool. Rules that
define a flow-type with the RX_CLS_FLOW_WAKE action (i.e. -2) can
wake the system from the 'standby' power state when the WAKE_FILTER
WoL method is enabled.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  5 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 43 +++++++++++++++++-----
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 5ef1ea7e5312..ad614d7201bd 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -724,7 +724,7 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 		break;
 	}
 
-	if (!fs->ring_cookie) {
+	if (!fs->ring_cookie || fs->ring_cookie == RX_CLS_FLOW_WAKE) {
 		/* Ring 0 flows can be handled by the default Descriptor Ring
 		 * We'll map them to ring 0, but don't enable the filter
 		 */
@@ -1499,7 +1499,8 @@ static int bcmgenet_insert_flow(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	if (cmd->fs.ring_cookie > priv->hw_params->rx_queues) {
+	if (cmd->fs.ring_cookie > priv->hw_params->rx_queues &&
+	    cmd->fs.ring_cookie != RX_CLS_FLOW_WAKE) {
 		netdev_err(dev, "rxnfc: Unsupported action (%llu)\n",
 			   cmd->fs.ring_cookie);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index da45a4645b94..4b9d65f392c2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -42,7 +42,7 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
-	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE;
+	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
 	wol->wolopts = priv->wolopts;
 	memset(wol->sopass, 0, sizeof(wol->sopass));
 
@@ -61,7 +61,7 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
 
-	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE))
+	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER))
 		return -EINVAL;
 
 	if (wol->wolopts & WAKE_MAGICSECURE)
@@ -117,8 +117,9 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 				enum bcmgenet_power_mode mode)
 {
 	struct net_device *dev = priv->dev;
+	struct bcmgenet_rxnfc_rule *rule;
+	u32 reg, hfb_ctrl_reg, hfb_enable = 0;
 	int retries = 0;
-	u32 reg;
 
 	if (mode != GENET_POWER_WOL_MAGIC) {
 		netif_err(priv, wol, dev, "unsupported mode: %d\n", mode);
@@ -135,13 +136,24 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	mdelay(10);
 
-	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-	reg |= MPD_EN;
-	if (priv->wolopts & WAKE_MAGICSECURE) {
-		bcmgenet_set_mpd_password(priv);
-		reg |= MPD_PW_EN;
+	if (priv->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE)) {
+		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
+		reg |= MPD_EN;
+		if (priv->wolopts & WAKE_MAGICSECURE) {
+			bcmgenet_set_mpd_password(priv);
+			reg |= MPD_PW_EN;
+		}
+		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+	}
+
+	hfb_ctrl_reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	if (priv->wolopts & WAKE_FILTER) {
+		list_for_each_entry(rule, &priv->rxnfc_list, list)
+			if (rule->fs.ring_cookie == RX_CLS_FLOW_WAKE)
+				hfb_enable |= (1 << rule->fs.location);
+		reg = (hfb_ctrl_reg & ~RBUF_HFB_EN) | RBUF_ACPI_EN;
+		bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
 	}
-	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
 	/* Do not leave UniMAC in MPD mode only */
 	retries = bcmgenet_poll_wol_status(priv);
@@ -149,6 +161,7 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
 		reg &= ~(MPD_EN | MPD_PW_EN);
 		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+		bcmgenet_hfb_reg_writel(priv, hfb_ctrl_reg, HFB_CTRL);
 		return retries;
 	}
 
@@ -158,6 +171,13 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	clk_prepare_enable(priv->clk_wol);
 	priv->wol_active = 1;
 
+	if (hfb_enable) {
+		bcmgenet_hfb_reg_writel(priv, hfb_enable,
+					HFB_FLT_ENABLE_V3PLUS + 4);
+		hfb_ctrl_reg = RBUF_HFB_EN | RBUF_ACPI_EN;
+		bcmgenet_hfb_reg_writel(priv, hfb_ctrl_reg, HFB_CTRL);
+	}
+
 	/* Enable CRC forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = 1;
@@ -197,6 +217,11 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg &= ~(MPD_EN | MPD_PW_EN);
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
+	/* Disable WAKE_FILTER Detection */
+	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
+	reg &= ~(RBUF_HFB_EN | RBUF_ACPI_EN);
+	bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
+
 	/* Disable CRC Forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
-- 
2.7.4

