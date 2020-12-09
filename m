Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599CD2D3EA9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgLIJZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:25:37 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9044 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728990AbgLIJZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:25:28 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrWp56nXzzhnlx;
        Wed,  9 Dec 2020 17:24:13 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:24:38 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, "Zheng Yongjun" <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: sja1105: simplify the return sja1105_cls_flower_stats()
Date:   Wed, 9 Dec 2020 17:25:04 +0800
Message-ID: <20201209092504.20470-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_flower.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 12e76020bea3..e9617782e0d0 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -458,7 +458,6 @@ int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cls->cookie);
-	int rc;
 
 	if (!rule)
 		return 0;
@@ -466,12 +465,8 @@ int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
 	if (rule->type != SJA1105_RULE_VL)
 		return 0;
 
-	rc = sja1105_vl_stats(priv, port, rule, &cls->stats,
+	return sja1105_vl_stats(priv, port, rule, &cls->stats,
 				cls->common.extack);
-	if (rc)
-		return rc;
-
-	return 0;
 }
 
 void sja1105_flower_setup(struct dsa_switch *ds)
-- 
2.22.0

