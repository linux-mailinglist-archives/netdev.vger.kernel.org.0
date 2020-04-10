Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142601A4448
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgDJJKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:10:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37894 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgDJJKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 05:10:54 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 30B5BEFD006BE3C7C63C;
        Fri, 10 Apr 2020 17:10:51 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 10 Apr 2020
 17:10:43 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pizza@shaftnet.org>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] wireless: cw1200: make cw1200_spi_irq_unsubscribe() void
Date:   Fri, 10 Apr 2020 17:09:10 +0800
Message-ID: <20200410090910.27132-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/st/cw1200/cw1200_spi.c:273:5-8: Unneeded variable:
"ret". Return "0" on line 279

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/st/cw1200/cw1200_spi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wireless/st/cw1200/cw1200_spi.c
index ef01caac629c..271ed2ce2d7f 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
@@ -268,15 +268,11 @@ static int cw1200_spi_irq_subscribe(struct hwbus_priv *self)
 	return ret;
 }
 
-static int cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
+static void cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
 {
-	int ret = 0;
-
 	pr_debug("SW IRQ unsubscribe\n");
 	disable_irq_wake(self->func->irq);
 	free_irq(self->func->irq, self);
-
-	return ret;
 }
 
 static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
-- 
2.17.2

