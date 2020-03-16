Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08414187503
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732782AbgCPVpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:45:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50196 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732723AbgCPVpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:45:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id z13so3299504wml.0;
        Mon, 16 Mar 2020 14:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pXT8TIAVee6xo+bpC98Iu+UB6NDYNqSMgC4PSpdz87I=;
        b=MK7Dc54v99mqQ/drZJDMk4arSiyED6WK5Gg/zmXSr44uL1U3dqIB2eRFNEEpjbJTWQ
         k4dzaCMDCGBIjM/C9fjCx8yz6dPDYq1vRIXn0H2qlUCCbc/xWKm0KzSHi1+1pVRUpMdJ
         krM5m4L6biz9Gk8+MwLy3VuzqHFA29DS7NZPVQFUEs4uioh4t/KHgl3GE0JEo6g30hwN
         M3TijijriodYNrnmUIpBMLXhEGwGbGVw/17f4zszQVHJL5y7T4jhTcrosHZRpqVZ8FQB
         sbFPn46GbpTXIZfMiq5d8XE/mwhMxmwHew/MfAJf22YFomqR5Nx/FZB6OOHIzG6Mt63a
         7K8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pXT8TIAVee6xo+bpC98Iu+UB6NDYNqSMgC4PSpdz87I=;
        b=WdqQJOOI8B1nXE4UNe7oeiZbkkV7mJZXlhAIMulxmJhbUXcoGFJRzasR6gkUifkcGA
         f7cA9EoTiFz0YiVcFOm5tJqTKCPpZtEqoRVRxBc6b1BacrRj3tXHh96reyLcYO9I0S/v
         bjdD7b1PGK5xtOZmQcqaoaHC68CIEKGA444iYHyTR0L8DTuK6cS3RZrAyaZoyPt9Q14R
         vglrDuaceI8BP31WVJTJnLlP0JnoVDgDvn6JnpY033NqHirKBmMo5WfWemA8AxiLArxT
         ybCsCFSLwItVCM6j5i4idnFTl/QCWcDplxT6gwNI8GFOrUVjUTUn5FHaWwoET2ShZXMA
         0i2g==
X-Gm-Message-State: ANhLgQ1P7kEjo5mElrvWtGmFY48AY5z6qw4mDnP5DV99mGmoscYmm8if
        kBl61IgUwvKl5vbXu3v6344=
X-Google-Smtp-Source: ADFU+vupNq0HG0Gf0HPIDLFNuFLeqm6QD5uQsQt+A8/6XadCcsALmRavrMxe9RypOBrideaAtSZN7w==
X-Received: by 2002:a1c:7ed0:: with SMTP id z199mr1212571wmc.52.1584395129711;
        Mon, 16 Mar 2020 14:45:29 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a13sm1625676wrh.80.2020.03.16.14.45.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Mar 2020 14:45:29 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 1/2] Revert "net: bcmgenet: use RGMII loopback for MAC reset"
Date:   Mon, 16 Mar 2020 14:44:55 -0700
Message-Id: <1584395096-41674-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
References: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3a55402c93877d291b0a612d25edb03d1b4b93ac.

This is not a good solution when connecting to an external switch
that may not support the isolation of the TXC signal resulting in
output driver contention on the pin.

A different solution is necessary.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  2 ++
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 34 --------------------------
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e50a15397e11..c8ac2d83208f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1989,6 +1989,8 @@ static void reset_umac(struct bcmgenet_priv *priv)
 
 	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
 	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
+	udelay(2);
+	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 10244941a7a6..69e80fb6e039 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -181,38 +181,8 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	const char *phy_name = NULL;
 	u32 id_mode_dis = 0;
 	u32 port_ctrl;
-	int bmcr = -1;
-	int ret;
 	u32 reg;
 
-	/* MAC clocking workaround during reset of umac state machines */
-	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	if (reg & CMD_SW_RESET) {
-		/* An MII PHY must be isolated to prevent TXC contention */
-		if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
-			ret = phy_read(phydev, MII_BMCR);
-			if (ret >= 0) {
-				bmcr = ret;
-				ret = phy_write(phydev, MII_BMCR,
-						bmcr | BMCR_ISOLATE);
-			}
-			if (ret) {
-				netdev_err(dev, "failed to isolate PHY\n");
-				return ret;
-			}
-		}
-		/* Switch MAC clocking to RGMII generated clock */
-		bcmgenet_sys_writel(priv, PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
-		/* Ensure 5 clks with Rx disabled
-		 * followed by 5 clks with Reset asserted
-		 */
-		udelay(4);
-		reg &= ~(CMD_SW_RESET | CMD_LCL_LOOP_EN);
-		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
-		/* Ensure 5 more clocks before Rx is enabled */
-		udelay(2);
-	}
-
 	switch (priv->phy_interface) {
 	case PHY_INTERFACE_MODE_INTERNAL:
 		phy_name = "internal PHY";
@@ -282,10 +252,6 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 
 	bcmgenet_sys_writel(priv, port_ctrl, SYS_PORT_CTRL);
 
-	/* Restore the MII PHY after isolation */
-	if (bmcr >= 0)
-		phy_write(phydev, MII_BMCR, bmcr);
-
 	priv->ext_phy = !priv->internal_phy &&
 			(priv->phy_interface != PHY_INTERFACE_MODE_MOCA);
 
-- 
2.7.4

