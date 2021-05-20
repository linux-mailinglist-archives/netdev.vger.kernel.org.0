Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67CA38AD0D
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbhETLwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:52:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3445 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241399AbhETLtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:49:00 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fm7FX21yszBv3f;
        Thu, 20 May 2021 19:44:48 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 19:47:35 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 19:47:35 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH 12/12] net/Bluetooth/smp - use the correct print format
Date:   Thu, 20 May 2021 19:44:33 +0800
Message-ID: <1621511073-47766-13-git-send-email-yekai13@huawei.com>
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

