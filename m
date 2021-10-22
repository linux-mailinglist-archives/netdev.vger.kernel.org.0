Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECAB437AC6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhJVQTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbhJVQT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:19:29 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A86EC061764;
        Fri, 22 Oct 2021 09:17:11 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g184so3757793pgc.6;
        Fri, 22 Oct 2021 09:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WXbmJaulO9/0IuhRPsYWAyYuPJMPjmxreH9KY1srL8E=;
        b=WQyN/Zoj1RTznGl1rmGRsnJdHCRq5HTIivu9ZCk+UGjJ6inWAJlNxkDkbxPdnJPaxs
         v2BGufr22CaAmm+TxkU7tOYns6kZgCTaBv7gvFj3ZAGRGMUF5BcNmAkzbHOnk4dw5uxH
         eysVvxiIou1WOmEyRGu0RYgeaExceUKsZXXEsWFn5h4pIPl6Km4eNaRpS+mwzCCg9LM5
         HZ+RasCBnGafhKy/MbB/rPGi8tdEPmnssmgwn6A29fysE/1oWJRjqNk3DEWCDYpw+ntr
         sL8ZBqTUg/18pJzt6p+N1UX/ujogqfIbC7l/yhHJwTlfhIoowluiJja0FlkZ0pSvOk+o
         dQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WXbmJaulO9/0IuhRPsYWAyYuPJMPjmxreH9KY1srL8E=;
        b=Ve4V8NJBk5DkEs+FUMgez5JF1jeX49geVf+d3NAncGphOddip1mqDRdxcrimvkzaVZ
         DocmMe22XGsFmbFuLE67VKstNuXQWWOWpusGAy4SU6GPw9TEn7UnKDPcJEIJN39AZm4x
         nEdGkY3KiDAqbQRe2VzpvxJ/QqEdScaCKuKEXggMeUYYBPmO0lqPEkNZZ730guLhay9v
         iTPHrbWHj8e6S+qL8EKoaaBWGl7TJxPcrkZowq4CthzpvOSRAxk6bqX49D1u5LAAdpPN
         i7X1YGE/zhUNedQvrpdmJ0SIgalSbqZWIzHKgtH6KOfbrALSIJ8NVNt/66/5rihjQ0Ju
         rQnw==
X-Gm-Message-State: AOAM530UBwRb1I6BaYsZNQFJXG1Hyi0EWegmIAGLlu1D+XsZ87tCT31O
        oedn1m5jLv/2P4yVB227cOqmMNDpSdo=
X-Google-Smtp-Source: ABdhPJyIhAf9KgwZev2LZ1FuSLB8CcGyfFAKKNWq/75Blc1PJg2sqPuzNq6VVP98rQwcc4gQA7QKDw==
X-Received: by 2002:a05:6a00:731:b0:44c:7c1b:fe6a with SMTP id 17-20020a056a00073100b0044c7c1bfe6amr989849pfm.44.1634919430629;
        Fri, 22 Oct 2021 09:17:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id nn14sm9866556pjb.27.2021.10.22.09.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 09:17:10 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 3/3] net: bcmgenet: Add support for 7712 16nm internal EPHY
Date:   Fri, 22 Oct 2021 09:17:03 -0700
Message-Id: <20211022161703.3360330-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022161703.3360330-1-f.fainelli@gmail.com>
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 16nm internal EPHY that is present in 7712 is actually a 16nm
Gigabit PHY which has been forced to operate in 10/100 mode. Its
controls are therefore via the EXT_GPHY_CTRL registers and not via the
EXT_EPHY_CTRL which are used for all GENETv5 adapters. Add a match on
the 7712 compatible string to allow that differentiation to happen.

On previous GENETv4 chips the EXT_CFG_IDDQ_GLOBAL_PWR bit was cleared by
default, but this is not the case with this chip, so we need to make
sure we clear it to power on the EPHY.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 13 +++++++++++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  2 ++
 drivers/net/ethernet/broadcom/genet/bcmmii.c   |  7 ++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 5da9c00b43b1..226f4403cfed 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1653,7 +1653,7 @@ static int bcmgenet_power_down(struct bcmgenet_priv *priv,
 		/* Power down LED */
 		if (priv->hw_params->flags & GENET_HAS_EXT) {
 			reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-			if (GENET_IS_V5(priv))
+			if (GENET_IS_V5(priv) && !priv->ephy_16nm)
 				reg |= EXT_PWR_DOWN_PHY_EN |
 				       EXT_PWR_DOWN_PHY_RD |
 				       EXT_PWR_DOWN_PHY_SD |
@@ -1690,7 +1690,7 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 	case GENET_POWER_PASSIVE:
 		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
 			 EXT_ENERGY_DET_MASK);
-		if (GENET_IS_V5(priv)) {
+		if (GENET_IS_V5(priv) && !priv->ephy_16nm) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
 				 EXT_PWR_DOWN_PHY_SD |
@@ -3910,6 +3910,7 @@ static void bcmgenet_set_hw_params(struct bcmgenet_priv *priv)
 struct bcmgenet_plat_data {
 	enum bcmgenet_version version;
 	u32 dma_max_burst_length;
+	bool ephy_16nm;
 };
 
 static const struct bcmgenet_plat_data v1_plat_data = {
@@ -3942,6 +3943,12 @@ static const struct bcmgenet_plat_data bcm2711_plat_data = {
 	.dma_max_burst_length = 0x08,
 };
 
+static const struct bcmgenet_plat_data bcm7712_plat_data = {
+	.version = GENET_V5,
+	.dma_max_burst_length = DMA_MAX_BURST_LENGTH,
+	.ephy_16nm = true,
+};
+
 static const struct of_device_id bcmgenet_match[] = {
 	{ .compatible = "brcm,genet-v1", .data = &v1_plat_data },
 	{ .compatible = "brcm,genet-v2", .data = &v2_plat_data },
@@ -3949,6 +3956,7 @@ static const struct of_device_id bcmgenet_match[] = {
 	{ .compatible = "brcm,genet-v4", .data = &v4_plat_data },
 	{ .compatible = "brcm,genet-v5", .data = &v5_plat_data },
 	{ .compatible = "brcm,bcm2711-genet-v5", .data = &bcm2711_plat_data },
+	{ .compatible = "brcm,bcm7712-genet-v5", .data = &bcm7712_plat_data },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bcmgenet_match);
@@ -4029,6 +4037,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (pdata) {
 		priv->version = pdata->version;
 		priv->dma_max_burst_length = pdata->dma_max_burst_length;
+		priv->ephy_16nm = pdata->ephy_16nm;
 	} else {
 		priv->version = pd->genet_version;
 		priv->dma_max_burst_length = DMA_MAX_BURST_LENGTH;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 1cc2838e52c6..946f6e283c4e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -329,6 +329,7 @@ struct bcmgenet_mib_counters {
 #define  EXT_CFG_IDDQ_BIAS		(1 << 0)
 #define  EXT_CFG_PWR_DOWN		(1 << 1)
 #define  EXT_CK25_DIS			(1 << 4)
+#define  EXT_CFG_IDDQ_GLOBAL_PWR	(1 << 3)
 #define  EXT_GPHY_RESET			(1 << 5)
 
 /* DMA rings size */
@@ -612,6 +613,7 @@ struct bcmgenet_priv {
 	phy_interface_t phy_interface;
 	int phy_addr;
 	int ext_phy;
+	bool ephy_16nm;
 
 	/* Interrupt variables */
 	struct work_struct bcmgenet_irq_work;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index ad56f54eda0a..5f259641437a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -139,14 +139,15 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 	u32 reg = 0;
 
 	/* EXT_GPHY_CTRL is only valid for GENETv4 and onward */
-	if (GENET_IS_V4(priv)) {
+	if (GENET_IS_V4(priv) || priv->ephy_16nm) {
 		reg = bcmgenet_ext_readl(priv, EXT_GPHY_CTRL);
 		if (enable) {
 			reg &= ~EXT_CK25_DIS;
 			bcmgenet_ext_writel(priv, reg, EXT_GPHY_CTRL);
 			mdelay(1);
 
-			reg &= ~(EXT_CFG_IDDQ_BIAS | EXT_CFG_PWR_DOWN);
+			reg &= ~(EXT_CFG_IDDQ_BIAS | EXT_CFG_PWR_DOWN |
+				 EXT_CFG_IDDQ_GLOBAL_PWR);
 			reg |= EXT_GPHY_RESET;
 			bcmgenet_ext_writel(priv, reg, EXT_GPHY_CTRL);
 			mdelay(1);
@@ -154,7 +155,7 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 			reg &= ~EXT_GPHY_RESET;
 		} else {
 			reg |= EXT_CFG_IDDQ_BIAS | EXT_CFG_PWR_DOWN |
-			       EXT_GPHY_RESET;
+			       EXT_GPHY_RESET | EXT_CFG_IDDQ_GLOBAL_PWR;
 			bcmgenet_ext_writel(priv, reg, EXT_GPHY_CTRL);
 			mdelay(1);
 			reg |= EXT_CK25_DIS;
-- 
2.25.1

