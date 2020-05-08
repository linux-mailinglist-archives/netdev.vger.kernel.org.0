Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15E61CA07F
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 04:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEHCHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 22:07:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbgEHCHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 22:07:08 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A42A2AC7A5631C917EA2;
        Fri,  8 May 2020 10:07:06 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 10:06:58 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: ethernet: ti: fix error return code in am65_cpsw_nuss_probe()
Date:   Fri, 8 May 2020 02:10:59 +0000
Message-ID: <20200508021059.172001-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -ENOMEM from the cpsw_ale_create()
error handling case instead of 0, as done elsewhere in this function.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f8c589929308..066ba52f57cb 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2065,6 +2065,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	common->ale = cpsw_ale_create(&ale_params);
 	if (!common->ale) {
 		dev_err(dev, "error initializing ale engine\n");
+		ret = -ENOMEM;
 		goto err_of_clear;
 	}



