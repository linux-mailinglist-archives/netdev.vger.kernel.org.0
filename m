Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2806B2B15ED
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 07:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgKMGsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 01:48:03 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7188 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgKMGsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 01:48:03 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CXTYc6SV2z15Vys;
        Fri, 13 Nov 2020 14:47:48 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 13 Nov 2020 14:47:51 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <grygorii.strashko@ti.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <m-karicheri2@ti.com>, <brouer@redhat.com>,
        <richardcochran@gmail.com>, <yanaijie@huawei.com>
CC:     <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: ethernet: ti: cpsw: fix error return code in cpsw_probe()
Date:   Fri, 13 Nov 2020 14:49:33 +0800
Message-ID: <1605250173-18438-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/ti/cpsw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9fd1f77..7882a00 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1631,6 +1631,7 @@ static int cpsw_probe(struct platform_device *pdev)
 				       CPSW_MAX_QUEUES, CPSW_MAX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "error allocating net_device\n");
+		ret = -ENOMEM;
 		goto clean_cpts;
 	}
 
-- 
2.9.5

