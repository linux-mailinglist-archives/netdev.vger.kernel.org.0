Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD44F34C141
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhC2BqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:46:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14174 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhC2Bpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:45:36 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F7wM65CsHznWgd;
        Mon, 29 Mar 2021 09:42:58 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:45:25 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: axienet: Remove redundant dev_err call in axienet_probe()
Date:   Mon, 29 Mar 2021 09:45:13 +0800
Message-ID: <1616982313-14119-1-git-send-email-huangguobin4@huawei.com>
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
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5d677db0aee5..f77a794540fc 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1878,7 +1878,6 @@ static int axienet_probe(struct platform_device *pdev)
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
 	if (IS_ERR(lp->regs)) {
-		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
 		ret = PTR_ERR(lp->regs);
 		goto cleanup_clk;
 	}

