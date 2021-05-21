Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FCC38BEDD
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhEUGE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:04:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3456 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhEUGEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 02:04:20 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FmbYG4qM5zBvRW;
        Fri, 21 May 2021 14:00:02 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:02:50 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 21 May
 2021 14:02:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v2 01/12] net/Bluetooth/bnep - use the correct print format
Date:   Fri, 21 May 2021 13:59:37 +0800
Message-ID: <1621576788-48092-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621576788-48092-1-git-send-email-yekai13@huawei.com>
References: <1621576788-48092-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Documentation/core-api/printk-formats.rst,
Use the correct print format. Printing an unsigned int value should use %u
instead of %d. Otherwise printk() might end up displaying negative numbers.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 net/bluetooth/bnep/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 43c2841..72f47b3 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -126,8 +126,8 @@ static int bnep_ctrl_set_netfilter(struct bnep_session *s, __be16 *data, int len
 			f[i].start = get_unaligned_be16(data++);
 			f[i].end   = get_unaligned_be16(data++);
 
-			BT_DBG("proto filter start %d end %d",
-				f[i].start, f[i].end);
+			BT_DBG("proto filter start %u end %u",
+			       f[i].start, f[i].end);
 		}
 
 		if (i < BNEP_MAX_PROTO_FILTERS)
@@ -266,7 +266,7 @@ static int bnep_rx_extension(struct bnep_session *s, struct sk_buff *skb)
 			break;
 		}
 
-		BT_DBG("type 0x%x len %d", h->type, h->len);
+		BT_DBG("type 0x%x len %u", h->type, h->len);
 
 		switch (h->type & BNEP_TYPE_MASK) {
 		case BNEP_EXT_CONTROL:
@@ -424,7 +424,7 @@ static int bnep_tx_frame(struct bnep_session *s, struct sk_buff *skb)
 	int len = 0, il = 0;
 	u8 type = 0;
 
-	BT_DBG("skb %p dev %p type %d", skb, skb->dev, skb->pkt_type);
+	BT_DBG("skb %p dev %p type %u", skb, skb->dev, skb->pkt_type);
 
 	if (!skb->dev) {
 		/* Control frame sent by us */
-- 
2.8.1

