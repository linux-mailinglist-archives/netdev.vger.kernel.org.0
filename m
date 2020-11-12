Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F69D2B03F1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgKLLdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:33:16 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8074 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgKLLc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:32:58 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CWzwq5dG2zLnGM;
        Thu, 12 Nov 2020 19:32:43 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 12 Nov 2020 19:32:52 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <nbd@nbd.name>, <john@phrozen.org>, <sean.wang@mediatek.com>,
        <Mark-MC.Lee@mediatek.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <matthias.bgg@gmail.com>,
        <bgolaszewski@baylibre.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: ethernet: mtk-star-emac: fix error return code in mtk_star_enable()
Date:   Thu, 12 Nov 2020 19:34:39 +0800
Message-ID: <1605180879-2573-1-git-send-email-zhangchangzhong@huawei.com>
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

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 1325055..2ebacb6 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -966,6 +966,7 @@ static int mtk_star_enable(struct net_device *ndev)
 				      mtk_star_adjust_link, 0, priv->phy_intf);
 	if (!priv->phydev) {
 		netdev_err(ndev, "failed to connect to PHY\n");
+		ret = -ENODEV;
 		goto err_free_irq;
 	}
 
-- 
2.9.5

