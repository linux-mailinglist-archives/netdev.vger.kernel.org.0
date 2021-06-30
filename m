Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABDC3B7AE4
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 02:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhF3ARX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 20:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbhF3ARW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 20:17:22 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC194C061760;
        Tue, 29 Jun 2021 17:14:53 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i4so454415plt.12;
        Tue, 29 Jun 2021 17:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HjDc05rmkSkok71SD9eQm5289Hg1nmZXAZ5nbacfW1w=;
        b=qvlMPsqVa0B2uTEJLFew8kmUcnXhO2vw7qr+gaIbSGry14NhOUtsntn/KFNFh7pwMR
         45UWVeMRUro6bUaw7K5/iEaFWtEg4Z4H0DvIfgAI7qUbpajon1SmTWWekOBvYRxp5DYo
         gCr54nlMCcLWeFuAW9yrYwyLyYh+3reguIk92XOaPekmlQ0S20zYAfHnIm6Betber/Ii
         3WqHO9tHTwrls9Q65v9baq1CXWU4YnOys7UltfaT0hnt1Aq1YUcyjaPdMm5c4y5TDrYg
         3cqBBimv+rgWIJKa5JkuL2TN5u5Gx1vcWrKRTHoU3EZu4ZXYL5XcIwoSt1EF/PUjI5Us
         IeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HjDc05rmkSkok71SD9eQm5289Hg1nmZXAZ5nbacfW1w=;
        b=EKYHs6JKi6Y/d/y5G31+qqc6pBcxcVVlBS1QjrnH42mpemr/YLsPcHPcRK7incIKR5
         VaGJMW9WtXg6dkzl53hcK0sffCP19qwicNIwgFiS5yGR5y/ke4JgVUDUroL8PDWgMWYu
         Bp4h434flYi3fdwOpnad8DDHuL3F8287KpjIYhK3zsKsiulnPFdyadFMleib29nr6vjB
         +oOMcY9WlutW7YI1OU6UKNI/U44CwX7RvLGbwUe7WvYKhR6XE+iu8NyLKWieVrcRfn/k
         v/kQMTgrJQxeCWUsG4SBBiCtZxwpT+2sLOWvij5PI1ieuzMPgnbnytnf/2LP0p7nuDos
         c8Nw==
X-Gm-Message-State: AOAM533MFqHwpxN4P49jst+OjFuL/T27PGeXkrLMVB54rEl4cWtwJTDU
        gN3+lLuLFTbkY7O21kbxtnE=
X-Google-Smtp-Source: ABdhPJwKJjLk/RqVZXgKrdajYQm6/4nA1KBJo5PVkbSZvWKjkhjI1jaZhpo0RhQBCR+nMppb18kLjw==
X-Received: by 2002:a17:902:9a02:b029:118:307e:a9dd with SMTP id v2-20020a1709029a02b0290118307ea9ddmr29912202plp.47.1625012093378;
        Tue, 29 Jun 2021 17:14:53 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y130sm237271pfg.79.2021.06.29.17.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 17:14:52 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net v2] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
Date:   Tue, 29 Jun 2021 17:14:19 -0700
Message-Id: <20210630001419.402366-1-opendmb@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
logic of the internal PHY to prevent the system from sleeping. Some
internal PHYs will report that energy is detected when the network
interface is closed which can prevent the system from going to sleep
if WoL is enabled when the interface is brought down.

Since the driver does not support waking the system on this logic,
this commit clears the bit whenever the internal PHY is powered up
and the other logic for manipulating the bit is removed since it
serves no useful function.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c  | 17 ++---------------
 .../net/ethernet/broadcom/genet/bcmgenet_wol.c  |  6 ------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 41f7f078cd27..35e9956e930c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1640,7 +1640,8 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
-		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS);
+		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
+			 EXT_ENERGY_DET_MASK);
 		if (GENET_IS_V5(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
@@ -3292,7 +3293,6 @@ static int bcmgenet_open(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
-	u32 reg;
 	int ret;
 
 	netif_dbg(priv, ifup, dev, "bcmgenet_open\n");
@@ -3318,12 +3318,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -4139,7 +4133,6 @@ static int bcmgenet_resume(struct device *d)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rxnfc_rule *rule;
 	unsigned long dma_ctrl;
-	u32 reg;
 	int ret;
 
 	if (!netif_running(dev))
@@ -4176,12 +4169,6 @@ static int bcmgenet_resume(struct device *d)
 		if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
 			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index facde824bcaa..e31a5a397f11 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -186,12 +186,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
-	if (priv->hw_params->flags & GENET_HAS_EXT) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg &= ~EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	reg = UMAC_IRQ_MPD_R;
 	if (hfb_enable)
 		reg |=  UMAC_IRQ_HFB_SM | UMAC_IRQ_HFB_MM;
-- 
2.25.1

