Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802BC1C65FE
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 04:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgEFCtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 22:49:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725966AbgEFCtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 22:49:02 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8175C1F0BC7A8D842B63;
        Wed,  6 May 2020 10:48:58 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Wed, 6 May 2020 10:48:49 +0800
From:   Samuel Zou <zou_wei@huawei.com>
To:     <davem@davemloft.net>
CC:     <grygorii.strashko@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Samuel Zou <zou_wei@huawei.com>
Subject: [PATCH -next] net: ethernet: ti: Use PTR_ERR_OR_ZERO() to simplify code
Date:   Wed, 6 May 2020 10:54:58 +0800
Message-ID: <1588733698-33746-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/ethernet/ti/am65-cpts.c:1017:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Samuel Zou <zou_wei@huawei.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 370162c..51c94b2 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -1014,10 +1014,7 @@ static int am65_cpts_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	cpts = am65_cpts_create(dev, base, node);
-	if (IS_ERR(cpts))
-		return PTR_ERR(cpts);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(cpts);
 }
 
 static const struct of_device_id am65_cpts_of_match[] = {
-- 
2.6.2

