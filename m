Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C2C225D34
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgGTLMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:12:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728047AbgGTLMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 07:12:47 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4EC88F12689ECCFD9523;
        Mon, 20 Jul 2020 19:12:42 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 20 Jul 2020 19:12:40 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <pantelis.antoniou@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: fs_enet: remove redundant null check
Date:   Mon, 20 Jul 2020 19:12:33 +0800
Message-ID: <1595243553-12325-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because clk_prepare_enable and clk_disable_unprepare already
checked NULL clock parameter, so the additional checks are
unnecessary, just remove them.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index b0d4b198..bf846b4 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1043,8 +1043,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 out_free_dev:
 	free_netdev(ndev);
 out_put:
-	if (fpi->clk_per)
-		clk_disable_unprepare(fpi->clk_per);
+	clk_disable_unprepare(fpi->clk_per);
 out_deregister_fixed_link:
 	of_node_put(fpi->phy_node);
 	if (of_phy_is_fixed_link(ofdev->dev.of_node))
@@ -1065,8 +1064,7 @@ static int fs_enet_remove(struct platform_device *ofdev)
 	fep->ops->cleanup_data(ndev);
 	dev_set_drvdata(fep->dev, NULL);
 	of_node_put(fep->fpi->phy_node);
-	if (fep->fpi->clk_per)
-		clk_disable_unprepare(fep->fpi->clk_per);
+	clk_disable_unprepare(fep->fpi->clk_per);
 	if (of_phy_is_fixed_link(ofdev->dev.of_node))
 		of_phy_deregister_fixed_link(ofdev->dev.of_node);
 	free_netdev(ndev);
-- 
1.8.3.1

