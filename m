Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13757D7E09
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388854AbfJORp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:45:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43925 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfJORpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:45:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id a2so12926613pfo.10;
        Tue, 15 Oct 2019 10:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=leMhQGcv5MZdIce7ISt6zmraox7h2mUqGJ8B9d3Ptog=;
        b=BEmuBSnAvDGSKs5TubWVa2+kpsLPz/Cy5OulLkefdDeH29IxYZeBHhRdvk79rQllWt
         FuF4txnM4JGV4/geY3B2sjri8XDlnk5IH2FEWfg6QebBhjU81kTNELkQyfcKCLkxKfmT
         wngOLzIeDDwCgZCvsLuE+mnQg32TrXdHi0wK55HNItoYPBVJpdLsqSTXKeIDlYATsPJI
         s9d6zGZy83VzOWDnbAmKNuWCLdBq9xYp9iNxjPclbLGlFQDJjS1lY+FuezwPC4O03pVW
         9ujCMYfQw8vhRDwmabJjfZvEZskso+gul0v79Hf5x/Kis2ZI4PfTFfY+H2TyaJzohByS
         KD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=leMhQGcv5MZdIce7ISt6zmraox7h2mUqGJ8B9d3Ptog=;
        b=RtZn2ETuzVvjXLOw2jTZg2z7lceBpWmTR/2CASKjZHsP3nXG+OksPPfyn/8FTsc+uL
         CesNkiwNncfaoLFSV1g198mWJPPuaTs+KFrmLzvPoPuEz1utO2CH9p7MwauXODGq8LsH
         ALCWbfjh+RzLtPtG2rIXaUc38n48bgQqTypXSlP0UFmesG9Rd+V9Jr372FUenPUC9glz
         XkLCZdnRBNbJ6chkQnSxGIctZj/20ZG4+qPf7hIYqAZnX936a0FHmHhcbzXArWPaazwt
         RCauDhzRpj3bxzSCoT+SJRHt5LEC+rnIsC8KRejW2M5a8yUFnsUqkuBmgPzwZU8Hjm43
         RKXg==
X-Gm-Message-State: APjAAAXAaTu0Dbj5qv87To0ABHXWtl2JdyIy9NXkNbYPRZyB9SsNw3ng
        QX8ZrrwgozkZc9g73Y4yoIwNyW4J
X-Google-Smtp-Source: APXvYqzIaH2ca9nMIooDw02p+ApGGXY78qq5k+WJ/LUhvqwiAMZYpsatB9Stv7PrjVu7L4agwXWsBg==
X-Received: by 2002:aa7:8046:: with SMTP id y6mr40011448pfm.206.1571161553302;
        Tue, 15 Oct 2019 10:45:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r11sm20716856pgn.67.2019.10.15.10.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 10:45:52 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3
Date:   Tue, 15 Oct 2019 10:45:47 -0700
Message-Id: <20191015174547.9837-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RGMII_MODE_EN bit value was 0 for GENET versions 1 through 3, and
became 6 for GENET v4 and above, account for that difference.

Fixes: aa09677cba42 ("net: bcmgenet: add MDIO routines")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.h | 1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 4a8fc03d82fd..dbc69d8fa05f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -366,6 +366,7 @@ struct bcmgenet_mib_counters {
 #define  EXT_PWR_DOWN_PHY_EN		(1 << 20)
 
 #define EXT_RGMII_OOB_CTRL		0x0C
+#define  RGMII_MODE_EN_V123		(1 << 0)
 #define  RGMII_LINK			(1 << 4)
 #define  OOB_DISABLE			(1 << 5)
 #define  RGMII_MODE_EN			(1 << 6)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 94d1dd5d56bf..e7c291bf4ed1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -258,7 +258,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	 */
 	if (priv->ext_phy) {
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
-		reg |= RGMII_MODE_EN | id_mode_dis;
+		reg |= id_mode_dis;
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			reg |= RGMII_MODE_EN_V123;
+		else
+			reg |= RGMII_MODE_EN;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
 
-- 
2.17.1

