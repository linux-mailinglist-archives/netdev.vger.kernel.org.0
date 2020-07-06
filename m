Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1258C2151A6
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 06:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgGFE2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 00:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGFE2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 00:28:10 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D145C061794;
        Sun,  5 Jul 2020 21:28:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ch3so1288961pjb.5;
        Sun, 05 Jul 2020 21:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4MlAhZczNRoqPKGUQQKqbIHChSjJilXrVIKMIUGfFJo=;
        b=e4eUU+y0yRdFRQmTArc78FB+m1IGUgO9ipMZdeLBHqozpK9t1b3BuqvtqAHHybftm0
         NoiZxF4uLvGfgN2vkH8doiaPEmuHRVNKnWE7mRP9pZ7oIsUjjLrk2akmo3fCBWnO1vbZ
         8Mil7aOhkpG53zf76/ZQv7v+w27Q1xwUg0oxV6VnNY0l+tdLXW6+QMmqpilJWojE9rW6
         gtkCgHNRiE3FzSp2/xmGq7GVRYM8gygpeF+aM2/HaN2XzuX6ENNJ2qAU765oL/2huYHC
         /ya6mBBdw4I+cG16SQk2ntzKe2paZAmWcc0ujEfoX2RFjxQe29s3O3Suji4G2qMDBxou
         BIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MlAhZczNRoqPKGUQQKqbIHChSjJilXrVIKMIUGfFJo=;
        b=dag5/zob24O6qy147sOnB0u0qyu5T+YlUIOxGNwRItdg3au+y0VPfD6w+kmI7uaxUt
         mMUlRcKbSycw9H0olw4e6towfyRd1pExZOelu0qBBIdCCwPDciMxY2HJAzK0VDDrsfNm
         G2dZDodv/Hkb1DeRopJksbsqYHGriL4gjiWmEW3o8bKoB1Q1/apkvVKW4w0Z09ulGdzo
         5Hg2jTo5s6o6DG1SZOYIP5Hdxeum+dZw2pPJGZBburfYTJ7U0DRrnZ8DNNHsA0Aq4vcx
         4mzwiNhNQmcAt2QxheXGKAje+zPgt8JcLIz9JKDgV+ZW2+Q01qqI2vAvqSsScgD9W/hh
         dB4g==
X-Gm-Message-State: AOAM530XZN02v0JySim0VRSipd29Jl4ivGJVQ8wyiVKYXLWB19raIwFn
        u7YS2LiBNSwL9IWYsP7/RG3D7+Ui
X-Google-Smtp-Source: ABdhPJyNr0MmeEJTS1nk6sRDU2qdjE1022dVc4M/5jzXLV3q+1CNErL+jn0UTVhVcw2t2ktyhFpVcQ==
X-Received: by 2002:a17:902:c206:: with SMTP id 6mr17438764pll.30.1594009688279;
        Sun, 05 Jul 2020 21:28:08 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ia13sm16558680pjb.42.2020.07.05.21.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 21:28:07 -0700 (PDT)
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
Subject: [PATCH net-next v2 3/3] net: ethtool: Remove PHYLIB direct dependency
Date:   Sun,  5 Jul 2020 21:27:58 -0700
Message-Id: <20200706042758.168819-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706042758.168819-1-f.fainelli@gmail.com>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have introduced ethtool_phy_ops and the PHY library
dynamically registers its operations with that function pointer, we can
remove the direct PHYLIB dependency in favor of using dynamic
operations.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/Kconfig             |  1 -
 net/ethtool/cabletest.c | 18 ++++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index d1672280d6a4..3831206977a1 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -455,7 +455,6 @@ config FAILOVER
 config ETHTOOL_NETLINK
 	bool "Netlink interface for ethtool"
 	default y
-	depends on PHYLIB=y || PHYLIB=n
 	help
 	  An alternative userspace interface for ethtool based on generic
 	  netlink. It provides better extensibility and some new features,
diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 7194956aa09e..4f9fbdf7610c 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -58,6 +58,7 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	const struct ethtool_phy_ops *ops;
 	struct net_device *dev;
 	int ret;
 
@@ -81,11 +82,17 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rtnl_lock();
+	ops = ethtool_phy_ops;
+	if (!ops || !ops->start_cable_test) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test(dev->phydev, info->extack);
+	ret = ops->start_cable_test(dev->phydev, info->extack);
 
 	ethnl_ops_complete(dev);
 
@@ -308,6 +315,7 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	const struct ethtool_phy_ops *ops;
 	struct phy_tdr_config cfg;
 	struct net_device *dev;
 	int ret;
@@ -337,11 +345,17 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 		goto out_dev_put;
 
 	rtnl_lock();
+	ops = ethtool_phy_ops;
+	if (!ops || !ops->start_cable_test_tdr) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test_tdr(dev->phydev, info->extack, &cfg);
+	ret = ops->start_cable_test_tdr(dev->phydev, info->extack, &cfg);
 
 	ethnl_ops_complete(dev);
 
-- 
2.25.1

