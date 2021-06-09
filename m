Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8613A1645
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhFIN7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:59:45 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5360 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbhFIN7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:59:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0T9C6Dynz6vr6;
        Wed,  9 Jun 2021 21:53:51 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 21:57:43 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 21:57:43 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: cpsw: Use devm_platform_get_and_ioremap_resource()
Date:   Wed, 9 Jun 2021 22:01:52 +0800
Message-ID: <20210609140152.3198309-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/ti/cpsw.c     | 3 +--
 drivers/net/ethernet/ti/cpsw_new.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c0cd7de88316..b1e80cc96f56 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1532,8 +1532,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	}
 	cpsw->bus_freq_mhz = clk_get_rate(clk) / 1000000;
 
-	ss_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ss_regs = devm_ioremap_resource(dev, ss_res);
+	ss_regs = devm_platform_get_and_ioremap_resource(pdev, 0, &ss_res);
 	if (IS_ERR(ss_regs))
 		return PTR_ERR(ss_regs);
 	cpsw->regs = ss_regs;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 69b7a4e0220a..8d4f3c53385d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1883,8 +1883,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	}
 	cpsw->bus_freq_mhz = clk_get_rate(clk) / 1000000;
 
-	ss_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ss_regs = devm_ioremap_resource(dev, ss_res);
+	ss_regs = devm_platform_get_and_ioremap_resource(pdev, 0, &ss_res);
 	if (IS_ERR(ss_regs)) {
 		ret = PTR_ERR(ss_regs);
 		return ret;
-- 
2.25.1

