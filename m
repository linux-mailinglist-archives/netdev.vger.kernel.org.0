Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38F53B4A56
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 23:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFYWAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 18:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYWAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 18:00:12 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410BDC061574;
        Fri, 25 Jun 2021 14:57:50 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v7so9303493pgl.2;
        Fri, 25 Jun 2021 14:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gt2NmkR1E5ZgvFdUpFs+L6Ez4R0M8YKSRPJbGflzW5Q=;
        b=XuoU/qgBb3OcQGUz8euB/lXSxAns36t6fFbFU8gJcU+7z6TuYSC1vb6wyVDDIgsfQu
         +nPrNoTKgdFchB7ek0pISMJKCEhvP3jPDsgY09cOhzBqJqcigIWspBu5B+hTcF3WtukL
         aizq4GEnySkLO7KojwnY/kwG9DS4G72Q8nebRy+87vTnCfHpGsnfGsLy5ONWSkhgugn5
         VVasFk5b1oUhcBrOUbAl3ZXClBKoNoRrGJXLszWe0s9sSSF/nJVxMtWs0cxLzvl+os0H
         DJ4jxp39UhpRnLxwdQJ0bjwoMfZErE/5q9N4AnGXR0GWJK53InKb5eAIUUsgECfPe8VL
         QiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gt2NmkR1E5ZgvFdUpFs+L6Ez4R0M8YKSRPJbGflzW5Q=;
        b=gYGS6lAIj19o3t+kVeYu+y9ah7zDZB341iHYcD7wAdvniVhiu5mwcjwC9fN9bI9vII
         6LQHyHROxgg15ahjern88LzAd5F3c3kiUIwzURUmq8ON4t0G+nhMKZD9WP9t9b2+V751
         xeXU+qjcaJHJvsK3HfD3/O8dQybNtvTeyZJp59pl669EnK2XdxssC2Zef8suuCITi8vc
         zqHb54EFfHFBU2BJfuoaE61GLVi/KeRHCpz2iBpj+IyenZ0jOe6ZPkePGsRlSHJRuROA
         PaChvDVwrNUCC67s2rfh76zSwAQCJqN18b+fGWuWjwuw1W+0Tl96W1YiY8RI+7ARSN8/
         XOuQ==
X-Gm-Message-State: AOAM533qNadAqvLP7SipfgAkhbqvnmzPzfQR61l7KkOI5XuKbVO7oM7c
        3VZEYk2tw/t7mZpaC+UjtNc=
X-Google-Smtp-Source: ABdhPJykHG2bZ4LXTTPKxn60d03hXgbQSzv1+nBaf3Juf7TROkeYfemSG0lpZ0/gYnJ/nefnofOuDg==
X-Received: by 2002:a62:5105:0:b029:305:324:17ae with SMTP id f5-20020a6251050000b0290305032417aemr12691434pfb.28.1624658269783;
        Fri, 25 Jun 2021 14:57:49 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x16sm6598067pfq.74.2021.06.25.14.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 14:57:49 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
Date:   Fri, 25 Jun 2021 14:57:32 -0700
Message-Id: <20210625215732.209588-1-opendmb@gmail.com>
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
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    | 15 ++-------------
 .../net/ethernet/broadcom/genet/bcmgenet_wol.c    |  6 ------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 41f7f078cd27..0260cbaf0197 100644
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
@@ -3318,12 +3319,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -4176,12 +4171,6 @@ static int bcmgenet_resume(struct device *d)
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

