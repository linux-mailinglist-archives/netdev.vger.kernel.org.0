Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1443B34C135
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhC2BjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:39:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15025 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhC2Bix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:38:53 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7wCM5qf5zPld2;
        Mon, 29 Mar 2021 09:36:15 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:38:44 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: mdio: Remove redundant dev_err call in mdio_mux_iproc_probe()
Date:   Mon, 29 Mar 2021 09:38:32 +0800
Message-ID: <1616981912-13213-1-git-send-email-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guobin Huang <huangguobin4@huawei.com>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
---
 drivers/net/mdio/mdio-mux-bcm-iproc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 641cfa41f492..03261e6b9ceb 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -197,10 +197,8 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 		res->end = res->start + MDIO_REG_ADDR_SPACE_SIZE - 1;
 	}
 	md->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(md->base)) {
-		dev_err(&pdev->dev, "failed to ioremap register\n");
+	if (IS_ERR(md->base))
 		return PTR_ERR(md->base);
-	}
 
 	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!md->mii_bus) {

