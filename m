Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25AB16434C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 12:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgBSLYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 06:24:35 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726484AbgBSLYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 06:24:35 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 36923731F1AD512310EE;
        Wed, 19 Feb 2020 19:24:33 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 19:24:24 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <allison@lohutok.net>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <bianpan2016@163.com>,
        <kstewart@linuxfoundation.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH 3/3] NFC: fdp: remove set but not used variable 'client'
Date:   Wed, 19 Feb 2020 19:23:24 +0800
Message-ID: <20200219112324.17682-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/nfc/fdp/i2c.c: In function ‘fdp_nci_i2c_irq_thread_fn’:
drivers/nfc/fdp/i2c.c:205:21: warning: variable ‘client’ set but
not used [-Wunused-but-set-variable]

It is never used, and so can be removed.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 drivers/nfc/fdp/i2c.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 257fdd7a28c7..31de9a7e70f8 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -202,7 +202,6 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 	struct sk_buff *skb;
 	int r;
 
@@ -211,8 +210,6 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-
 	r = fdp_nci_i2c_read(phy, &skb);
 
 	if (r == -EREMOTEIO)
-- 
2.17.2

