Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61912B4C06
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732482AbgKPRCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730829AbgKPRCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:02:00 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F11C0613D1;
        Mon, 16 Nov 2020 09:02:00 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id 7so13385434qtp.1;
        Mon, 16 Nov 2020 09:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hL6L0/Oi2iOOjSEOvFWMXySFm2k4nR3P+6hLuPbYwHk=;
        b=JSRDyR/FtF8dBnJqoxmGMC30xxduHVmw/4OvRrRGiJH/u0jEh9f5sOfhOn35QLpQac
         cf2XkJ6VnhlE9Lld9QkL/GFwahKsh8o28hPTcBnWUjW82HHfamCVBZ7ZSRDuDyhr7xKn
         UCk/areSX00d9dqg+7dHyIm+qxezkp2zmWAAY2xvBtLnCF20AnolrSXioWxmsc6xmgPv
         d64EzqcXHwQrsRCMJkOGHJIQkC/vOVQqeuqnFQWN+eD00t+0ZYM51+Fw7qmwCnEMEPpO
         2bgIYPjVxJnOjZ0PgY75NYzfDs9Ue7ZRuGVOroT0ACxtQa4ZWNzXEKpBUhSBoa+K2yqN
         89Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hL6L0/Oi2iOOjSEOvFWMXySFm2k4nR3P+6hLuPbYwHk=;
        b=ttglClw9dhjD1dHvq0kiaDkXNoR8z7merpa7bnx9DTYBESdK7nRfKMaaIZPB5rGwGn
         iaA7oQjv2jBwNKeZfW7uZEXyqPSd59OmiaQSeqYLjWeZAMPCEoc3eoSrBoSFfPlo0mMf
         jyaYpHGDCKb/LPdpO1hvggHc/SPHwf4DMJerDXmcxLtuv6GKmVfhC4CeBx+y5qYT6YKS
         YVcF67sZsmFctUP0Gawkj+GmP+9e3i6rJnY9WCapXW1xdbEWnwuGqpa3u0jxbm5hgNi7
         hkrwb1XDRnHRGV7ePpLJXnX0ozq0Q70O9bZsNo66IfV7jMPnpgZXwZgoeUmA/bAuQBRw
         wFVA==
X-Gm-Message-State: AOAM532Ub6PQoVvrEOlHoRtfncnljbNIJ8VO7Iy0+KfHpuLuf8R0JsyI
        d4uPNgxo9N+oa/qG/z22s9O9HKyvaQM=
X-Google-Smtp-Source: ABdhPJy2C0qNnRDk+0COOp6sqZDcHtYoT8ju7WhPeqBGr56HUZtlTEhoGNxigQNh1ovvQtOA9ox+pQ==
X-Received: by 2002:a05:622a:208:: with SMTP id b8mr14584000qtx.333.1605546119185;
        Mon, 16 Nov 2020 09:01:59 -0800 (PST)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id r62sm12880971qkd.80.2020.11.16.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 09:01:58 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1] lan743x: replace devicetree phy parse code with library function
Date:   Mon, 16 Nov 2020 12:01:55 -0500
Message-Id: <20201116170155.26967-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

The code in this driver which parses the devicetree to determine
the phy/fixed link setup, can be replaced by a single library
function: of_phy_get_and_connect().

Behaviour is identical, except that the library function will
complain when 'phy-connection-type' is omitted, instead of
blindly using PHY_INTERFACE_MODE_NA, which would result in an
invalid phy configuration.

The library function no longer brings out the exact phy_mode,
but the driver doesn't need this, because phy_interface_is_rgmii()
queries the phydev directly. Remove 'phy_mode' from the private
adapter struct.

While we're here, log info about the attached phy on connect,
this is useful because the phy type and connection method is now
fully configurable via the devicetree.

Tested on a lan7430 chip with built-in phy. Verified that adding
fixed-link/phy-connection-type in the devicetree results in a
fixed-link setup. Used ethtool to verify that the devicetree
settings are used.

Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # 0064c5c1b3bf

To: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Roelof Berg <rberg@berg-solutions.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 35 +++++--------------
 drivers/net/ethernet/microchip/lan743x_main.h |  1 -
 2 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 0c9b938ee0ea..e88789bf2d0f 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -957,7 +957,7 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		data = lan743x_csr_read(adapter, MAC_CR);
 
 		/* set interface mode */
-		if (phy_interface_mode_is_rgmii(adapter->phy_mode))
+		if (phy_interface_is_rgmii(phydev))
 			/* RGMII */
 			data &= ~MAC_CR_MII_EN_;
 		else
@@ -1013,33 +1013,14 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 
 static int lan743x_phy_open(struct lan743x_adapter *adapter)
 {
+	struct net_device *netdev = adapter->netdev;
 	struct lan743x_phy *phy = &adapter->phy;
-	struct phy_device *phydev = NULL;
-	struct device_node *phynode;
-	struct net_device *netdev;
+	struct phy_device *phydev;
 	int ret = -EIO;
 
-	netdev = adapter->netdev;
-	phynode = of_node_get(adapter->pdev->dev.of_node);
-
-	if (phynode) {
-		/* try devicetree phy, or fixed link */
-		of_get_phy_mode(phynode, &adapter->phy_mode);
-
-		if (of_phy_is_fixed_link(phynode)) {
-			ret = of_phy_register_fixed_link(phynode);
-			if (ret) {
-				netdev_err(netdev,
-					   "cannot register fixed PHY\n");
-				of_node_put(phynode);
-				goto return_error;
-			}
-		}
-		phydev = of_phy_connect(netdev, phynode,
-					lan743x_phy_link_status_change, 0,
-					adapter->phy_mode);
-		of_node_put(phynode);
-	}
+	/* try devicetree phy, or fixed link */
+	phydev = of_phy_get_and_connect(netdev, adapter->pdev->dev.of_node,
+					lan743x_phy_link_status_change);
 
 	if (!phydev) {
 		/* try internal phy */
@@ -1047,10 +1028,9 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 		if (!phydev)
 			goto return_error;
 
-		adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
 		ret = phy_connect_direct(netdev, phydev,
 					 lan743x_phy_link_status_change,
-					 adapter->phy_mode);
+					 PHY_INTERFACE_MODE_GMII);
 		if (ret)
 			goto return_error;
 	}
@@ -1065,6 +1045,7 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 
 	phy_start(phydev);
 	phy_start_aneg(phydev);
+	phy_attached_info(phydev);
 	return 0;
 
 return_error:
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index a536f4a4994d..3a0e70daa88f 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -703,7 +703,6 @@ struct lan743x_rx {
 struct lan743x_adapter {
 	struct net_device       *netdev;
 	struct mii_bus		*mdiobus;
-	phy_interface_t		phy_mode;
 	int                     msg_enable;
 #ifdef CONFIG_PM
 	u32			wolopts;
-- 
2.17.1

