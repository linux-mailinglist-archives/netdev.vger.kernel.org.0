Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3CD3A56F1
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 09:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhFMHnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 03:43:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6464 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhFMHnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 03:43:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G2mfW1GTFzZgfZ;
        Sun, 13 Jun 2021 15:38:43 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 11/11] net: z85230: remove unnecessary out of memory message
Date:   Sun, 13 Jun 2021 15:38:23 +0800
Message-ID: <1623569903-47930-12-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
References: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes unnecessary out of memory message,
to fix the following checkpatch.pl warning:
"WARNING: Possible unnecessary 'out of memory' message"

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 17bdf5e..aac6f31 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -1531,10 +1531,9 @@ static void z8530_rx_done(struct z8530_channel *c)
 		RT_UNLOCK;
 
 		c->skb2 = dev_alloc_skb(c->mtu);
-		if (!c->skb2)
-			netdev_warn(c->netdevice, "memory squeeze\n");
-		else
+		if (c->skb2)
 			skb_put(c->skb2, c->mtu);
+
 		c->netdevice->stats.rx_packets++;
 		c->netdevice->stats.rx_bytes += ct;
 	}
-- 
2.8.1

