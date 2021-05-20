Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39EF38ACF7
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbhETLvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:51:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3623 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243050AbhETLtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:49:00 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm7G56x5lzmXDG;
        Thu, 20 May 2021 19:45:17 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 19:47:34 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 19:47:34 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH 06/12] net/Bluetooth/a2mp - use the correct print format
Date:   Thu, 20 May 2021 19:44:27 +0800
Message-ID: <1621511073-47766-7-git-send-email-yekai13@huawei.com>
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
 net/bluetooth/a2mp.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
index 463bad5..1fcc482 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -120,7 +120,7 @@ static int a2mp_command_rej(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (le16_to_cpu(hdr->len) < sizeof(*rej))
 		return -EINVAL;
 
-	BT_DBG("ident %d reason %d", hdr->ident, le16_to_cpu(rej->reason));
+	BT_DBG("ident %u reason %d", hdr->ident, le16_to_cpu(rej->reason));
 
 	skb_pull(skb, sizeof(*rej));
 
@@ -219,7 +219,7 @@ static int a2mp_discover_rsp(struct amp_mgr *mgr, struct sk_buff *skb,
 
 	cl = (void *) skb->data;
 	while (len >= sizeof(*cl)) {
-		BT_DBG("Remote AMP id %d type %d status %d", cl->id, cl->type,
+		BT_DBG("Remote AMP id %u type %u status %u", cl->id, cl->type,
 		       cl->status);
 
 		if (cl->id != AMP_ID_BREDR && cl->type != AMP_TYPE_BREDR) {
@@ -273,7 +273,7 @@ static int a2mp_change_notify(struct amp_mgr *mgr, struct sk_buff *skb,
 	struct a2mp_cl *cl = (void *) skb->data;
 
 	while (skb->len >= sizeof(*cl)) {
-		BT_DBG("Controller id %d type %d status %d", cl->id, cl->type,
+		BT_DBG("Controller id %u type %u status %u", cl->id, cl->type,
 		       cl->status);
 		cl = skb_pull(skb, sizeof(*cl));
 	}
@@ -302,7 +302,7 @@ static int a2mp_getinfo_req(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (le16_to_cpu(hdr->len) < sizeof(*req))
 		return -EINVAL;
 
-	BT_DBG("id %d", req->id);
+	BT_DBG("id %u", req->id);
 
 	hdev = hci_dev_get(req->id);
 	if (!hdev || hdev->dev_type != HCI_AMP) {
@@ -344,7 +344,7 @@ static int a2mp_getinfo_rsp(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (le16_to_cpu(hdr->len) < sizeof(*rsp))
 		return -EINVAL;
 
-	BT_DBG("id %d status 0x%2.2x", rsp->id, rsp->status);
+	BT_DBG("id %u status 0x%2.2x", rsp->id, rsp->status);
 
 	if (rsp->status)
 		return -EINVAL;
@@ -373,7 +373,7 @@ static int a2mp_getampassoc_req(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (le16_to_cpu(hdr->len) < sizeof(*req))
 		return -EINVAL;
 
-	BT_DBG("id %d", req->id);
+	BT_DBG("id %u", req->id);
 
 	/* Make sure that other request is not processed */
 	tmp = amp_mgr_lookup_by_state(READ_LOC_AMP_ASSOC);
@@ -423,7 +423,7 @@ static int a2mp_getampassoc_rsp(struct amp_mgr *mgr, struct sk_buff *skb,
 
 	assoc_len = len - sizeof(*rsp);
 
-	BT_DBG("id %d status 0x%2.2x assoc len %zu", rsp->id, rsp->status,
+	BT_DBG("id %u status 0x%2.2x assoc len %zu", rsp->id, rsp->status,
 	       assoc_len);
 
 	if (rsp->status)
@@ -457,7 +457,7 @@ static int a2mp_getampassoc_rsp(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (!hcon)
 		goto done;
 
-	BT_DBG("Created hcon %p: loc:%d -> rem:%d", hcon, hdev->id, rsp->id);
+	BT_DBG("Created hcon %p: loc:%u -> rem:%u", hcon, hdev->id, rsp->id);
 
 	mgr->bredr_chan->remote_amp_id = rsp->id;
 
@@ -481,7 +481,7 @@ static int a2mp_createphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (le16_to_cpu(hdr->len) < sizeof(*req))
 		return -EINVAL;
 
-	BT_DBG("local_id %d, remote_id %d", req->local_id, req->remote_id);
+	BT_DBG("local_id %u, remote_id %u", req->local_id, req->remote_id);
 
 	memset(&rsp, 0, sizeof(rsp));
 
@@ -562,7 +562,7 @@ static int a2mp_discphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (le16_to_cpu(hdr->len) < sizeof(*req))
 		return -EINVAL;
 
-	BT_DBG("local_id %d remote_id %d", req->local_id, req->remote_id);
+	BT_DBG("local_id %u remote_id %u", req->local_id, req->remote_id);
 
 	memset(&rsp, 0, sizeof(rsp));
 
@@ -599,7 +599,7 @@ static int a2mp_discphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
 static inline int a2mp_cmd_rsp(struct amp_mgr *mgr, struct sk_buff *skb,
 			       struct a2mp_cmd *hdr)
 {
-	BT_DBG("ident %d code 0x%2.2x", hdr->ident, hdr->code);
+	BT_DBG("ident %u code 0x%2.2x", hdr->ident, hdr->code);
 
 	skb_pull(skb, le16_to_cpu(hdr->len));
 	return 0;
@@ -620,7 +620,7 @@ static int a2mp_chan_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 		hdr = (void *) skb->data;
 		len = le16_to_cpu(hdr->len);
 
-		BT_DBG("code 0x%2.2x id %d len %u", hdr->code, hdr->ident, len);
+		BT_DBG("code 0x%2.2x id %u len %u", hdr->code, hdr->ident, len);
 
 		skb_pull(skb, sizeof(*hdr));
 
-- 
2.8.1

