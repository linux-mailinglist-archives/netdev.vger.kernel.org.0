Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009EA62FF6B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKRViE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiKRViD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:38:03 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B5CA4654;
        Fri, 18 Nov 2022 13:38:00 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b29so6050029pfp.13;
        Fri, 18 Nov 2022 13:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hJH91dDaZ1QxgMmSGvIo+VIxXA/J5w+ZrpGsEJ0OWJI=;
        b=cGPtDnwYpQn92k1bUaIRCWFdeOsYbmWwtfcblbWPXTPr/llygj8fiQuILeJrs9DGkR
         fRvzayl6lw12s1fBMLABc8JJaf/jG1cTzOcnVavdRQ0TDEEzM52QKTiCxbqzHFxklhi7
         uq8wl9stN/lPzUTcXMiKdST2HcfQxCbu5mXlFsccKOwosNIpaa9oT/3rgu3N9VXSb/0i
         a0lK6ELDDswD/CA39srLA6KCKjb/L4/9TcTAjL+KL4OOFPrEu2syuBZ/GjlYjRApzEPl
         X0YPWucjlcf+9F8C0OxCaIlZr9/ndYOLDUg6R7pVs0kjAyyvBUqKEH5QNXYdIpU7z2oB
         Sitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hJH91dDaZ1QxgMmSGvIo+VIxXA/J5w+ZrpGsEJ0OWJI=;
        b=LVHrh2vLS1uEUYu4AuRS56Y0C0kxq2BXq6UFfLI5BQFR4bFsn8FumuEMbuasVsCxXd
         11FI3hta+SupzQxAX3XPLEn9dMxLyI8nCCSxl/0LsulYFotuei6K39JtFMchUS5qf6lU
         l679qod9LPJfrtGaWc7jQ65pXqWUMaywsJL2q144sBH/hy3HwfQgPmNB8qJTzxs/EGY9
         54tsuqhR3OhQDtqsDRlC3evM6qW70cXm5cBzWqqTQIasS5OD176rmNlLTcHKtnL1wVR3
         Eoiudc0vnb8lRW7pbF1kkwm51IoTGZb+EZAITEvhUnF7drZqvBRuso/i1MlK5umkucj7
         cw1Q==
X-Gm-Message-State: ANoB5pmk/SCS11iP329I4yZ/mXmMyWM7lQ86bxGfjkFvhqEO6ON6fZIF
        6BisVi8CenPIBxe9AGSIiaU7uHC8iF8=
X-Google-Smtp-Source: AA0mqf5p/bfuyGiIaibIkl7TLZEjZE4yeHdDqpKOuFmxe3Nh025zHXgtaq92hFN1247KHeSpPrsEVw==
X-Received: by 2002:a05:6a00:24c1:b0:56e:a001:8cb0 with SMTP id d1-20020a056a0024c100b0056ea0018cb0mr9541911pfv.60.1668807479538;
        Fri, 18 Nov 2022 13:37:59 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y10-20020a17090322ca00b0017bb38e4588sm4254635plg.135.2022.11.18.13.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 13:37:58 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: bcmgenet: Clear RGMII_LINK upon link down
Date:   Fri, 18 Nov 2022 13:37:54 -0800
Message-Id: <20221118213754.1383364-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear the RGMII_LINK bit upon detecting link down to be consistent with
setting the bit upon link up. We also move the clearing of the
out-of-band disable to the runtime initialization rather than for each
link up/down transition.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 7ded559842e8..b615176338b2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -72,7 +72,6 @@ static void bcmgenet_mac_config(struct net_device *dev)
 	 * Receive clock is provided by the PHY.
 	 */
 	reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
-	reg &= ~OOB_DISABLE;
 	reg |= RGMII_LINK;
 	bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 
@@ -95,10 +94,18 @@ static void bcmgenet_mac_config(struct net_device *dev)
  */
 void bcmgenet_mii_setup(struct net_device *dev)
 {
+	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
+	u32 reg;
 
-	if (phydev->link)
+	if (phydev->link) {
 		bcmgenet_mac_config(dev);
+	} else {
+		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
+		reg &= ~RGMII_LINK;
+		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
+	}
+
 	phy_print_status(phydev);
 }
 
@@ -266,18 +273,20 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 			(priv->phy_interface != PHY_INTERFACE_MODE_MOCA);
 
 	/* This is an external PHY (xMII), so we need to enable the RGMII
-	 * block for the interface to work
+	 * block for the interface to work, unconditionally clear the
+	 * Out-of-band disable since we do not need it.
 	 */
+	reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
+	reg &= ~OOB_DISABLE;
 	if (priv->ext_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
 		reg &= ~ID_MODE_DIS;
 		reg |= id_mode_dis;
 		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
 			reg |= RGMII_MODE_EN_V123;
 		else
 			reg |= RGMII_MODE_EN;
-		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
+	bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 
 	if (init)
 		dev_info(kdev, "configuring instance for %s\n", phy_name);
-- 
2.34.1

