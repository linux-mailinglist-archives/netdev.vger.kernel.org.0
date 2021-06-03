Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E663A399BE1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhFCHqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:46:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhFCHqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:46:16 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FwdBd12rZzYqQ3;
        Thu,  3 Jun 2021 15:41:45 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 15:44:15 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 15:44:15 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v3 12/12] Bluetooth: smp: Use the correct print format
Date:   Thu, 3 Jun 2021 15:41:05 +0800
Message-ID: <1622706065-45409-13-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
References: <1622706065-45409-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
 net/bluetooth/smp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 2def906..56c59f8 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -859,7 +859,7 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 	memset(smp->tk, 0, sizeof(smp->tk));
 	clear_bit(SMP_FLAG_TK_VALID, &smp->flags);
 
-	bt_dev_dbg(hcon->hdev, "auth:%d lcl:%d rem:%d", auth, local_io,
+	bt_dev_dbg(hcon->hdev, "auth:%u lcl:%u rem:%u", auth, local_io,
 		   remote_io);
 
 	/* If neither side wants MITM, either "just" confirm an incoming
@@ -925,7 +925,7 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 		get_random_bytes(&passkey, sizeof(passkey));
 		passkey %= 1000000;
 		put_unaligned_le32(passkey, smp->tk);
-		bt_dev_dbg(hcon->hdev, "PassKey: %d", passkey);
+		bt_dev_dbg(hcon->hdev, "PassKey: %u", passkey);
 		set_bit(SMP_FLAG_TK_VALID, &smp->flags);
 	}
 
@@ -1654,7 +1654,7 @@ int smp_user_confirm_reply(struct hci_conn *hcon, u16 mgmt_op, __le32 passkey)
 	case MGMT_OP_USER_PASSKEY_REPLY:
 		value = le32_to_cpu(passkey);
 		memset(smp->tk, 0, sizeof(smp->tk));
-		bt_dev_dbg(conn->hcon->hdev, "PassKey: %d", value);
+		bt_dev_dbg(conn->hcon->hdev, "PassKey: %u", value);
 		put_unaligned_le32(value, smp->tk);
 		fallthrough;
 	case MGMT_OP_USER_CONFIRM_REPLY:
-- 
2.8.1

