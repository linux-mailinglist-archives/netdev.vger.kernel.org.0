Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4490C34B626
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 11:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhC0KcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 06:32:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15362 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhC0KcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 06:32:24 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F6w8F72xGz8yBB;
        Sat, 27 Mar 2021 18:30:05 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 18:32:00 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: lantiq: Remove redundant dev_err call in xrx200_probe()
Date:   Sat, 27 Mar 2021 18:31:51 +0800
Message-ID: <1616841111-8722-1-git-send-email-huangguobin4@huawei.com>
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
 drivers/net/ethernet/lantiq_xrx200.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 51ed8a54d380..0f8ef8f1232c 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -460,10 +460,8 @@ static int xrx200_probe(struct platform_device *pdev)
 	}
 
 	priv->pmac_reg = devm_ioremap_resource(dev, res);
-	if (IS_ERR(priv->pmac_reg)) {
-		dev_err(dev, "failed to request and remap io ranges\n");
+	if (IS_ERR(priv->pmac_reg))
 		return PTR_ERR(priv->pmac_reg);
-	}
 
 	priv->chan_rx.dma.irq = platform_get_irq_byname(pdev, "rx");
 	if (priv->chan_rx.dma.irq < 0)

