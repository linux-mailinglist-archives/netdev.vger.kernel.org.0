Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CA238BEEE
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbhEUGEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:04:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5711 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhEUGEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 02:04:20 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmbXS47j7zqVYp;
        Fri, 21 May 2021 13:59:20 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:02:52 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 21 May
 2021 14:02:51 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v2 09/12] net/Bluetooth/mgmt - use the correct print format
Date:   Fri, 21 May 2021 13:59:45 +0800
Message-ID: <1621576788-48092-10-git-send-email-yekai13@huawei.com>
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
 net/bluetooth/mgmt.c        | 16 ++++++++--------
 net/bluetooth/mgmt_config.c |  4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 51c7e64..efdec6c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4269,7 +4269,7 @@ int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
 
 done:
 	hci_dev_unlock(hdev);
-	bt_dev_dbg(hdev, "add monitor %d complete, status %d",
+	bt_dev_dbg(hdev, "add monitor %d complete, status %u",
 		   rp.monitor_handle, status);
 
 	return err;
@@ -4494,7 +4494,7 @@ int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
 
 done:
 	hci_dev_unlock(hdev);
-	bt_dev_dbg(hdev, "remove monitor %d complete, status %d",
+	bt_dev_dbg(hdev, "remove monitor %d complete, status %u",
 		   rp.monitor_handle, status);
 
 	return err;
@@ -4824,7 +4824,7 @@ void mgmt_start_discovery_complete(struct hci_dev *hdev, u8 status)
 {
 	struct mgmt_pending_cmd *cmd;
 
-	bt_dev_dbg(hdev, "status %d", status);
+	bt_dev_dbg(hdev, "status %u", status);
 
 	hci_dev_lock(hdev);
 
@@ -5080,7 +5080,7 @@ void mgmt_stop_discovery_complete(struct hci_dev *hdev, u8 status)
 {
 	struct mgmt_pending_cmd *cmd;
 
-	bt_dev_dbg(hdev, "status %d", status);
+	bt_dev_dbg(hdev, "status %u", status);
 
 	hci_dev_lock(hdev);
 
@@ -5293,7 +5293,7 @@ static int set_device_id(struct sock *sk, struct hci_dev *hdev, void *data,
 static void enable_advertising_instance(struct hci_dev *hdev, u8 status,
 					u16 opcode)
 {
-	bt_dev_dbg(hdev, "status %d", status);
+	bt_dev_dbg(hdev, "status %u", status);
 }
 
 static void set_advertising_complete(struct hci_dev *hdev, u8 status,
@@ -6337,7 +6337,7 @@ static void conn_info_refresh_complete(struct hci_dev *hdev, u8 hci_status,
 	handle = __le16_to_cpu(cp->handle);
 	conn = hci_conn_hash_lookup_handle(hdev, handle);
 	if (!conn) {
-		bt_dev_err(hdev, "unknown handle (%d) in conn_info response",
+		bt_dev_err(hdev, "unknown handle (%u) in conn_info response",
 			   handle);
 		goto unlock;
 	}
@@ -7641,7 +7641,7 @@ static void add_advertising_complete(struct hci_dev *hdev, u8 status,
 	struct adv_info *adv_instance, *n;
 	u8 instance;
 
-	bt_dev_dbg(hdev, "status %d", status);
+	bt_dev_dbg(hdev, "status %u", status);
 
 	hci_dev_lock(hdev);
 
@@ -8172,7 +8172,7 @@ static void remove_advertising_complete(struct hci_dev *hdev, u8 status,
 	struct mgmt_cp_remove_advertising *cp;
 	struct mgmt_rp_remove_advertising rp;
 
-	bt_dev_dbg(hdev, "status %d", status);
+	bt_dev_dbg(hdev, "status %u", status);
 
 	hci_dev_lock(hdev);
 
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index 1deb0ca..6ef701c 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -146,7 +146,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		const u16 type = le16_to_cpu(TO_TLV(buffer)->type);
 
 		if (buffer_left < exp_len) {
-			bt_dev_warn(hdev, "invalid len left %d, exp >= %d",
+			bt_dev_warn(hdev, "invalid len left %u, exp >= %u",
 				    buffer_left, exp_len);
 
 			return mgmt_cmd_status(sk, hdev->id,
@@ -198,7 +198,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		}
 
 		if (exp_type_len && len != exp_type_len) {
-			bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
+			bt_dev_warn(hdev, "invalid length %d, exp %zu for type %u",
 				    len, exp_type_len, type);
 
 			return mgmt_cmd_status(sk, hdev->id,
-- 
2.8.1

