Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F5241C92B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346030AbhI2QCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27907 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344440AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWk6xXjzbmfs;
        Wed, 29 Sep 2021 23:53:38 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 008/167] net: convert the prototype of dflt_features_check
Date:   Wed, 29 Sep 2021 23:50:55 +0800
Message-ID: <20210929155334.12454-9-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
dflt_features_check for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/core/dev.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 85d894e06f4e..814e6e7ee579 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3480,12 +3480,11 @@ netdev_features_t passthru_features_check(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(passthru_features_check);
 
-static netdev_features_t dflt_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void dflt_features_check(struct sk_buff *skb,
+				struct net_device *dev,
+				netdev_features_t *features)
 {
-	vlan_features_check(skb, &features);
-	return features;
+	vlan_features_check(skb, features);
 }
 
 static void gso_features_check(const struct sk_buff *skb,
@@ -3551,7 +3550,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		features &= dev->netdev_ops->ndo_features_check(skb, dev,
 								features);
 	else
-		features &= dflt_features_check(skb, dev, features);
+		dflt_features_check(skb, dev, &features);
 
 	harmonize_features(skb, &features);
 	return features;
-- 
2.33.0

