Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7D9211B1F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgGBE37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgGBE3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:29:54 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD20C08C5C1;
        Wed,  1 Jul 2020 21:29:54 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so12810521pge.12;
        Wed, 01 Jul 2020 21:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9CSB4wi1g7ALKJ04YCMbv+vCl7X+afKawoSmLzpgxuY=;
        b=ESsnn5vZuS4vJ60Up0eoOHlsAE+XfplVIhKXsIR5wcaVOjCeSB55kASeLTxSyGEC8T
         77NpsRy0/BZXxa+o/6yGeik+cbKh1ub1jzXvjEYQTSMhefgi8ZDUOTv2acI/mFCeVZls
         IPcCOwfY4pn7q9l1APycCKVAjiEprExb7B1hzDwPNs379TIbxs1aieaJ1k+JpG+STeiy
         5y5z2oIcBXOO0rcG3VDSmxZ2bTSHHPV/OKMa1tRZsVdS7Q/7Tj5EiSOTPMA7c5R+ZxWN
         YHMRb+ibOIgTi5iQLDKXvnlSae2TyPjGCkZjOpSiRjkA2jj3es5Fu/RxM+SK9R6ehfYe
         BGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9CSB4wi1g7ALKJ04YCMbv+vCl7X+afKawoSmLzpgxuY=;
        b=gencqdzZapCjf8lgpmvQ5tgSJG0dhOcjKrhsD4IPgD7A7OH3hlsSzu9FSpoCKDUXWH
         0AGNw8vKOa7ksu1vSIX7KP/x58Ddx4tfRFuTLJx6wYGGDzHdAhGCMxmbvSdSVAIHEvEx
         1SW0bw2FfLZQFV/FoXmWH42MdWcYv2T2GjfAsNGyRnId9rZQ54oZpoptwRe7Pbjtr+4H
         wi7WwQm18ehJ1+O0IXa8iY3V2QaZzbFYGGQlM0lWxz3UdfpO6tPgr3Df8HS0sy22+PVe
         O47hKJjk2r6sYWgASQ9LpMfCSo9LRiNvGPgF3iz9u9KNEX6rEEwbYFdj5m+gcVExflhy
         ZClg==
X-Gm-Message-State: AOAM531a0KwaPCqnUeRj/pLXaRY8oWX4vqhQZww8Kz+aGwrmq5tZ6eA0
        gIWIEvDLmEKHBICMn/yK1hBP/vcx
X-Google-Smtp-Source: ABdhPJx1zY7xiFM8NE2ejpIuwVuSC6zC0a9nWDMyHkgYaW2QFEguugNXexWjvoR2x9gBwX8qDj/v5g==
X-Received: by 2002:a62:2b96:: with SMTP id r144mr26837035pfr.272.1593664193794;
        Wed, 01 Jul 2020 21:29:53 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id np5sm6806248pjb.43.2020.07.01.21.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 21:29:53 -0700 (PDT)
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
Subject: [PATCH net-next 4/4] net: ethtool: Remove PHYLIB dependency
Date:   Wed,  1 Jul 2020 21:29:42 -0700
Message-Id: <20200702042942.76674-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702042942.76674-1-f.fainelli@gmail.com>
References: <20200702042942.76674-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have converted the ethtool/cabletest code to use netdev_ops,
we can remove the PHY library dependency since the function pointers
will now be provided upon PHY attachment to the network device.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/Kconfig             |  1 -
 net/ethtool/cabletest.c | 12 ++++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

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
index 0d940a91493b..d8e2eb427613 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -58,6 +58,7 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	const struct net_device_ops *ops;
 	struct net_device *dev;
 	int ret;
 
@@ -75,7 +76,8 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 		return ret;
 
 	dev = req_info.dev;
-	if (!dev->phydev) {
+	ops = dev->netdev_ops;
+	if (!ops->ndo_cable_test_start) {
 		ret = -EOPNOTSUPP;
 		goto out_dev_put;
 	}
@@ -85,7 +87,7 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test(dev, info->extack);
+	ret = ops->ndo_cable_test_start(dev, info->extack);
 
 	ethnl_ops_complete(dev);
 
@@ -308,6 +310,7 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
 	struct ethnl_req_info req_info = {};
+	const struct net_device_ops *ops;
 	struct phy_tdr_config cfg;
 	struct net_device *dev;
 	int ret;
@@ -326,7 +329,8 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 		return ret;
 
 	dev = req_info.dev;
-	if (!dev->phydev) {
+	ops = dev->netdev_ops;
+	if (!ops->ndo_cable_test_tdr_start) {
 		ret = -EOPNOTSUPP;
 		goto out_dev_put;
 	}
@@ -341,7 +345,7 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test_tdr(dev, info->extack, &cfg);
+	ret = ops->ndo_cable_test_tdr_start(dev, info->extack, &cfg);
 
 	ethnl_ops_complete(dev);
 
-- 
2.25.1

