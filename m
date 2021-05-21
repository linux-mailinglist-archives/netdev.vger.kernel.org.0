Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441AE38BEE2
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhEUGEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:04:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4711 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbhEUGEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 02:04:20 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmbYJ2KcYz16QgL;
        Fri, 21 May 2021 14:00:04 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:02:51 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 21 May
 2021 14:02:51 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH v2 07/12] net/Bluetooth/amp - use the correct print format
Date:   Fri, 21 May 2021 13:59:43 +0800
Message-ID: <1621576788-48092-8-git-send-email-yekai13@huawei.com>
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
 net/bluetooth/amp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
index be2d469..2134f92 100644
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -78,7 +78,7 @@ struct amp_ctrl *amp_ctrl_lookup(struct amp_mgr *mgr, u8 id)
 {
 	struct amp_ctrl *ctrl;
 
-	BT_DBG("mgr %p id %d", mgr, id);
+	BT_DBG("mgr %p id %u", mgr, id);
 
 	mutex_lock(&mgr->amp_ctrls_lock);
 	list_for_each_entry(ctrl, &mgr->amp_ctrls, list) {
@@ -179,7 +179,7 @@ int phylink_gen_key(struct hci_conn *conn, u8 *data, u8 *len, u8 *type)
 
 	/* Legacy key */
 	if (conn->key_type < 3) {
-		bt_dev_err(hdev, "legacy key type %d", conn->key_type);
+		bt_dev_err(hdev, "legacy key type %u", conn->key_type);
 		return -EACCES;
 	}
 
@@ -257,7 +257,7 @@ void amp_read_loc_assoc_frag(struct hci_dev *hdev, u8 phy_handle)
 	struct hci_request req;
 	int err;
 
-	BT_DBG("%s handle %d", hdev->name, phy_handle);
+	BT_DBG("%s handle %u", hdev->name, phy_handle);
 
 	cp.phy_handle = phy_handle;
 	cp.max_len = cpu_to_le16(hdev->amp_assoc_size);
-- 
2.8.1

