Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5752E34B5D6
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 10:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhC0J44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 05:56:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15074 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhC0J4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 05:56:40 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6vMJ4QHWz1BH6C;
        Sat, 27 Mar 2021 17:54:36 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 17:56:28 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Markus Elfring" <elfring@users.sourceforge.net>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] mt76: mt7615: remove redundant dev_err call in mt7622_wmac_probe()
Date:   Sat, 27 Mar 2021 17:56:18 +0800
Message-ID: <1616838978-6420-1-git-send-email-huangguobin4@huawei.com>
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
 drivers/net/wireless/mediatek/mt76/mt7615/soc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/soc.c b/drivers/net/wireless/mediatek/mt76/mt7615/soc.c
index 9aa5183c7a56..be9a69fe1b38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/soc.c
@@ -40,10 +40,8 @@ static int mt7622_wmac_probe(struct platform_device *pdev)
 		return irq;
 
 	mem_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(mem_base)) {
-		dev_err(&pdev->dev, "Failed to get memory resource\n");
+	if (IS_ERR(mem_base))
 		return PTR_ERR(mem_base);
-	}
 
 	return mt7615_mmio_probe(&pdev->dev, mem_base, irq, mt7615e_reg_map);
 }

