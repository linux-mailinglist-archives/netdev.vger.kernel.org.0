Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7C2B0A98
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgKLQpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:45:38 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37566 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728977AbgKLQpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:45:38 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0ACGjWVr030274;
        Thu, 12 Nov 2020 10:45:32 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605199532;
        bh=nEeyGV/g8WhnDhmKwXjMR/xIRfMtEk/NvzJI7KH1IEg=;
        h=From:To:CC:Subject:Date;
        b=Npe45z1FSa8F+JxCBhh/LjOhcnJYvBvCpbZYribufbxj3kQd8+7B76xAs2QYK1Si9
         0mTWvBX28fRfouowO7kkIYUbLJBMJse2FXSL6LOYjiLiAl3Ypdbk76TExVHGESigk9
         S/S3kzeu5/wzB2fr0GI7Rx2gDB32DwPv/HOAe6AA=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0ACGjWYP057547
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 10:45:32 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 12
 Nov 2020 10:45:31 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 12 Nov 2020 10:45:31 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0ACGjVJ1098180;
        Thu, 12 Nov 2020 10:45:31 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Wang Qing <wangqing@vivo.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v5] net: ethernet: ti: am65-cpts: update ret when ptp_clock is ERROR
Date:   Thu, 12 Nov 2020 18:45:41 +0200
Message-ID: <20201112164541.3223-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

We always have to update the value of ret, otherwise the
 error value may be the previous one.

Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
Signed-off-by: Wang Qing <wangqing@vivo.com>
[grygorii.strashko@ti.com: fix build warn, subj add fixes tag]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
Hi

I've update patch as requested and added Acked-by from Richard from v1.

v4: https://lore.kernel.org/patchwork/patch/1336771/
v3: https://lore.kernel.org/patchwork/patch/1334871/
v2: https://lore.kernel.org/patchwork/patch/1334549/
v1: https://lore.kernel.org/patchwork/patch/1334067/

 drivers/net/ethernet/ti/am65-cpts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 75056c14b161..5dc60ecabe56 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
 		dev_err(dev, "Failed to register ptp clk %ld\n",
 			PTR_ERR(cpts->ptp_clock));
-		if (!cpts->ptp_clock)
-			ret = -ENODEV;
+		ret = cpts->ptp_clock ? PTR_ERR(cpts->ptp_clock) : -ENODEV;
 		goto refclk_disable;
 	}
 	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
-- 
2.17.1

