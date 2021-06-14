Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C4A3A6546
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbhFNLg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:36:56 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:6301 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbhFNLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:34:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G3TgY0lgFz1BMKj;
        Mon, 14 Jun 2021 19:27:05 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:03 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 04/11] net: z85230: remove redundant initialization for statics
Date:   Mon, 14 Jun 2021 19:28:44 +0800
Message-ID: <1623670131-49973-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
References: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not initialise statics to 0.
According to Documentation/process/volatile-considered-harmful.rst,
the "volatile" type class should not be used, so remove it.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

---
Change Log:
V1 -> V2:
1, fix the comments from Andrew, add commit message
   about remove volatile.
---


---
 drivers/net/wan/z85230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 94ed9a2..f815bb5 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -685,7 +685,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 {
 	struct z8530_dev *dev=dev_id;
 	u8 intr;
-	static volatile int locker=0;
+	static int locker;
 	int work=0;
 	struct z8530_irqhandler *irqs;
 	
-- 
2.8.1

