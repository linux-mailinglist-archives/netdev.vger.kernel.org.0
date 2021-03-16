Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C4233D0F8
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhCPJlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:41:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:13938 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbhCPJkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:40:40 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F07XQ4JT0zkZr9;
        Tue, 16 Mar 2021 17:39:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 17:40:30 +0800
From:   Jay Fang <f.fangjian@huawei.com>
To:     <elder@kernel.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] net: ipa: Remove useless error message
Date:   Tue, 16 Mar 2021 17:41:06 +0800
Message-ID: <1615887666-15064-1-git-send-email-f.fangjian@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zihao Tang <tangzihao1@hisilicon.com>

Fix the following coccicheck report:

drivers/net/ipa/gsi.c:1341:2-9:
line 1341 is redundant because platform_get_irq() already prints an error

Remove dev_err() messages after platform_get_irq_byname() failures.

Signed-off-by: Zihao Tang <tangzihao1@hisilicon.com>
Signed-off-by: Jay Fang <f.fangjian@huawei.com>
---
 drivers/net/ipa/gsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 390d340..2119367 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1337,10 +1337,9 @@ static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
 	int ret;
 
 	ret = platform_get_irq_byname(pdev, "gsi");
-	if (ret <= 0) {
-		dev_err(dev, "DT error %d getting \"gsi\" IRQ property\n", ret);
+	if (ret <= 0)
 		return ret ? : -EINVAL;
-	}
+
 	irq = ret;
 
 	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
-- 
2.7.4

