Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34933211B21
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGBEaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgGBE3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:29:51 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D5DC08C5C1;
        Wed,  1 Jul 2020 21:29:51 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j19so5966299pgm.11;
        Wed, 01 Jul 2020 21:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SaAU3hiUVjWUOyctEYYV6JFwfF6beu9s6jHYabXwfSA=;
        b=G5lHQdj5Pr4h4MJTATX1WSjQXr2p/dUKlJKcKTN76mRq8mGEobeT3q6rLcIELyvYvj
         y1N71K2gFsDty2BQA9tFML8QOIA+1quS3kuwCZB/X+5tIWDxy1DUXgZs1EK9Ya1Lztzy
         bXRfYDYgOn4KyJzjUyrFU58YuKJ4t2E02dRxs6hjDLjVZMka79q+Dmtnrj1gmyuW5Ded
         NCWNNZkdbAGt5hBFF3aTaJNh01O4K0v3DlIzz1KIVHK6fcXWIsVp02L/a/xxMEihuyaj
         mE66dFBkHr/BICkaGr3HBZj+5zPFsgAD6xtAdjsHJ5f44OrG/YtEufzpbktMQ1Yk3Ybn
         3ARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaAU3hiUVjWUOyctEYYV6JFwfF6beu9s6jHYabXwfSA=;
        b=bzx7tyRz+mVscSq3hYsDGhHMQUubQ+31hx10SFlqqLVgqk2OKnzdKaiIaUo3Cx7/0X
         TYyn+aN8s/FkOj/pv/babMils1RFlQ5hkMn3uGXzJTqlGnlamPr3Arbla5jU5+gqiJTF
         7turi5N1vmRbD+yFu5xUmihBJJiYBB+Oj6nCCYg1px5KuxGcYdFJioJDrmEhCIe8ZlrY
         yNSXh7MU6HydTuXwJ1JbawA3ZeOiOpncptLRDPts/cxtSKR1rcjIZHsJ/vxU9923mVQw
         psHAxbt8adTXpOiOloOagS3KhDiBptUzVT40kv1OLWT1wN0j+pUbzV4inGy0EX7U5rQ0
         FlSA==
X-Gm-Message-State: AOAM533bNDnxM9oedUEauu8GW5w+hv/YJiM8xrDwHb7e4cAAOO15yX+l
        X/xObtT2STdAhLoidH1RNMe+FHfe
X-Google-Smtp-Source: ABdhPJz3/KKfzHuDvNfqVxeI/Jgth8b2+1UZulOFJWzmi4ZzNpNZgMMaOXW2LbaOZDW6Yp2tBRjeFg==
X-Received: by 2002:a63:5a20:: with SMTP id o32mr14284177pgb.15.1593664190745;
        Wed, 01 Jul 2020 21:29:50 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id np5sm6806248pjb.43.2020.07.01.21.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 21:29:49 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/4] net: phy: Change cable test arguments to net_device
Date:   Wed,  1 Jul 2020 21:29:40 -0700
Message-Id: <20200702042942.76674-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702042942.76674-1-f.fainelli@gmail.com>
References: <20200702042942.76674-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to untangle the ethtool/cabletest feature with the PHY library,
make the PHY library functions take a net_device argument and derive the
phy_device reference from there.

No functional changes introduced.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy.c   | 18 ++++++++++++++----
 include/linux/phy.h     |  8 ++++----
 net/ethtool/cabletest.c |  4 ++--
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 56cfae950472..fbb74f37b961 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -489,12 +489,17 @@ static void phy_abort_cable_test(struct phy_device *phydev)
 		phydev_err(phydev, "Error while aborting cable test");
 }
 
-int phy_start_cable_test(struct phy_device *phydev,
+int phy_start_cable_test(struct net_device *dev,
 			 struct netlink_ext_ack *extack)
 {
-	struct net_device *dev = phydev->attached_dev;
+	struct phy_device *phydev = dev->phydev;
 	int err = -ENOMEM;
 
+	if (!dev->phydev) {
+		NL_SET_ERR_MSG(extack, "Network device not attached to a PHY");
+		return -EOPNOTSUPP;
+	}
+
 	if (!(phydev->drv &&
 	      phydev->drv->cable_test_start &&
 	      phydev->drv->cable_test_get_status)) {
@@ -552,13 +557,18 @@ int phy_start_cable_test(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_start_cable_test);
 
-int phy_start_cable_test_tdr(struct phy_device *phydev,
+int phy_start_cable_test_tdr(struct net_device *dev,
 			     struct netlink_ext_ack *extack,
 			     const struct phy_tdr_config *config)
 {
-	struct net_device *dev = phydev->attached_dev;
+	struct phy_device *phydev = dev->phydev;
 	int err = -ENOMEM;
 
+	if (!dev->phydev) {
+		NL_SET_ERR_MSG(extack, "Network device not attached to a PHY");
+		return -EOPNOTSUPP;
+	}
+
 	if (!(phydev->drv &&
 	      phydev->drv->cable_test_tdr_start &&
 	      phydev->drv->cable_test_get_status)) {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 101a48fa6750..53b95c52869d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1266,21 +1266,21 @@ int phy_restart_aneg(struct phy_device *phydev);
 int phy_reset_after_clk_enable(struct phy_device *phydev);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
-int phy_start_cable_test(struct phy_device *phydev,
+int phy_start_cable_test(struct net_device *dev,
 			 struct netlink_ext_ack *extack);
-int phy_start_cable_test_tdr(struct phy_device *phydev,
+int phy_start_cable_test_tdr(struct net_device *dev,
 			     struct netlink_ext_ack *extack,
 			     const struct phy_tdr_config *config);
 #else
 static inline
-int phy_start_cable_test(struct phy_device *phydev,
+int phy_start_cable_test(struct net_device *dev,
 			 struct netlink_ext_ack *extack)
 {
 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
 	return -EOPNOTSUPP;
 }
 static inline
-int phy_start_cable_test_tdr(struct phy_device *phydev,
+int phy_start_cable_test_tdr(struct net_device *dev,
 			     struct netlink_ext_ack *extack,
 			     const struct phy_tdr_config *config)
 {
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 7194956aa09e..0d940a91493b 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -85,7 +85,7 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test(dev->phydev, info->extack);
+	ret = phy_start_cable_test(dev, info->extack);
 
 	ethnl_ops_complete(dev);
 
@@ -341,7 +341,7 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test_tdr(dev->phydev, info->extack, &cfg);
+	ret = phy_start_cable_test_tdr(dev, info->extack, &cfg);
 
 	ethnl_ops_complete(dev);
 
-- 
2.25.1

