Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8649738ACFB
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242122AbhETLvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:51:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3603 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243046AbhETLtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:49:00 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fm7Dg0HfBzQpPZ;
        Thu, 20 May 2021 19:44:03 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 19:47:34 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 19:47:33 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH 03/12] net/Bluetooth/hidp - use the correct print format
Date:   Thu, 20 May 2021 19:44:24 +0800
Message-ID: <1621511073-47766-4-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621511073-47766-1-git-send-email-yekai13@huawei.com>
References: <1621511073-47766-1-git-send-email-yekai13@huawei.com>
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
 net/bluetooth/hidp/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 0db48c8..1dc8dee 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -508,7 +508,7 @@ static int hidp_process_data(struct hidp_session *session, struct sk_buff *skb,
 				unsigned char param)
 {
 	int done_with_skb = 1;
-	BT_DBG("session %p skb %p len %d param 0x%02x", session, skb, skb->len, param);
+	BT_DBG("session %p skb %p len %u param 0x%02x", session, skb, skb->len, param);
 
 	switch (param) {
 	case HIDP_DATA_RTYPE_INPUT:
@@ -553,7 +553,7 @@ static void hidp_recv_ctrl_frame(struct hidp_session *session,
 	unsigned char hdr, type, param;
 	int free_skb = 1;
 
-	BT_DBG("session %p skb %p len %d", session, skb, skb->len);
+	BT_DBG("session %p skb %p len %u", session, skb, skb->len);
 
 	hdr = skb->data[0];
 	skb_pull(skb, 1);
@@ -589,7 +589,7 @@ static void hidp_recv_intr_frame(struct hidp_session *session,
 {
 	unsigned char hdr;
 
-	BT_DBG("session %p skb %p len %d", session, skb, skb->len);
+	BT_DBG("session %p skb %p len %u", session, skb, skb->len);
 
 	hdr = skb->data[0];
 	skb_pull(skb, 1);
-- 
2.8.1

