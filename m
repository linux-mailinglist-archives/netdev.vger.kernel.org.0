Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D2E2D5C55
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389458AbgLJNtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 08:49:11 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8743 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgLJNtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 08:49:03 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CsFbX4wFpzkmF9;
        Thu, 10 Dec 2020 21:47:36 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 21:48:08 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: stmmac: simplify the return tc_delete_knode()
Date:   Thu, 10 Dec 2020 21:48:33 +0800
Message-ID: <20201210134833.958-1-zhengyongjun3@huawei.com>
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index cc27d660a818..f5bed4d26e80 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -209,17 +209,11 @@ static int tc_config_knode(struct stmmac_priv *priv,
 static int tc_delete_knode(struct stmmac_priv *priv,
 			   struct tc_cls_u32_offload *cls)
 {
-	int ret;
-
 	/* Set entry and fragments as not used */
 	tc_unfill_entry(priv, cls);
 
-	ret = stmmac_rxp_config(priv, priv->hw->pcsr, priv->tc_entries,
-			priv->tc_entries_max);
-	if (ret)
-		return ret;
-
-	return 0;
+	return stmmac_rxp_config(priv, priv->hw->pcsr, priv->tc_entries,
+				 priv->tc_entries_max);
 }
 
 static int tc_setup_cls_u32(struct stmmac_priv *priv,
-- 
2.22.0

