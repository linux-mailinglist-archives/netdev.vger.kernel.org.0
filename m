Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7DA38BEF0
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhEUGEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:04:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3639 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhEUGEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 02:04:21 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FmbYt5HjQzmXpF;
        Fri, 21 May 2021 14:00:34 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
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
Subject: [PATCH v2 08/12] net/Bluetooth/hci - use the correct print format
Date:   Fri, 21 May 2021 13:59:44 +0800
Message-ID: <1621576788-48092-9-git-send-email-yekai13@huawei.com>
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
 net/bluetooth/hci_conn.c    |  8 ++++----
 net/bluetooth/hci_core.c    | 48 ++++++++++++++++++++++-----------------------
 net/bluetooth/hci_event.c   | 24 +++++++++++------------
 net/bluetooth/hci_request.c |  8 ++++----
 net/bluetooth/hci_sock.c    |  6 +++---
 net/bluetooth/hci_sysfs.c   |  2 +-
 6 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 88ec089..5b6bbeb 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -300,7 +300,7 @@ static bool find_next_esco_param(struct hci_conn *conn,
 		if (lmp_esco_2m_capable(conn->link) ||
 		    (esco_param[conn->attempt - 1].pkt_type & ESCO_2EV3))
 			break;
-		BT_DBG("hcon %p skipped attempt %d, eSCO 2M not supported",
+		BT_DBG("hcon %p skipped attempt %u, eSCO 2M not supported",
 		       conn, conn->attempt);
 	}
 
@@ -471,7 +471,7 @@ static void hci_conn_idle(struct work_struct *work)
 					     idle_work.work);
 	struct hci_dev *hdev = conn->hdev;
 
-	BT_DBG("hcon %p mode %d", conn, conn->mode);
+	BT_DBG("hcon %p mode %u", conn, conn->mode);
 
 	if (!lmp_sniff_capable(hdev) || !lmp_sniff_capable(conn))
 		return;
@@ -637,7 +637,7 @@ int hci_conn_del(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;
 
-	BT_DBG("%s hcon %p handle %d", hdev->name, conn, conn->handle);
+	BT_DBG("%s hcon %p handle %u", hdev->name, conn, conn->handle);
 
 	cancel_delayed_work_sync(&conn->disc_work);
 	cancel_delayed_work_sync(&conn->auto_accept_work);
@@ -1574,7 +1574,7 @@ void hci_conn_enter_active_mode(struct hci_conn *conn, __u8 force_active)
 {
 	struct hci_dev *hdev = conn->hdev;
 
-	BT_DBG("hcon %p mode %d", conn, conn->mode);
+	BT_DBG("hcon %p mode %u", conn, conn->mode);
 
 	if (conn->mode != HCI_CM_SNIFF)
 		goto timer;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b0d9c36..49e15b6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -261,7 +261,7 @@ static int hci_init1_req(struct hci_request *req, unsigned long opt)
 		amp_init1(req);
 		break;
 	default:
-		bt_dev_err(hdev, "Unknown device type %d", hdev->dev_type);
+		bt_dev_err(hdev, "Unknown device type %u", hdev->dev_type);
 		break;
 	}
 
@@ -1386,7 +1386,7 @@ int hci_inquiry(void __user *arg)
 	ir.num_rsp = inquiry_cache_dump(hdev, max_rsp, buf);
 	hci_dev_unlock(hdev);
 
-	BT_DBG("num_rsp %d", ir.num_rsp);
+	BT_DBG("num_rsp %u", ir.num_rsp);
 
 	if (!copy_to_user(ptr, &ir, sizeof(ir))) {
 		ptr += sizeof(ir);
@@ -2897,7 +2897,7 @@ int hci_remove_adv_instance(struct hci_dev *hdev, u8 instance)
 	if (!adv_instance)
 		return -ENOENT;
 
-	BT_DBG("%s removing %dMR", hdev->name, instance);
+	BT_DBG("%s removing %uMR", hdev->name, instance);
 
 	if (hdev->cur_adv_instance == instance) {
 		if (hdev->adv_instance_timeout) {
@@ -3010,7 +3010,7 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 	INIT_DELAYED_WORK(&adv_instance->rpa_expired_cb,
 			  adv_instance_rpa_expired);
 
-	BT_DBG("%s for %dMR", hdev->name, instance);
+	BT_DBG("%s for %uMR", hdev->name, instance);
 
 	return 0;
 }
@@ -3169,7 +3169,7 @@ static bool hci_remove_adv_monitor(struct hci_dev *hdev,
 
 free_monitor:
 	if (*err == -ENOENT)
-		bt_dev_warn(hdev, "Removing monitor with no matching handle %d",
+		bt_dev_warn(hdev, "Removing monitor with no matching handle %u",
 			    monitor->handle);
 	hci_free_adv_monitor(hdev, monitor);
 
@@ -3194,7 +3194,7 @@ bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle, int *err)
 	if (!*err && !pending)
 		hci_update_background_scan(hdev);
 
-	bt_dev_dbg(hdev, "%s remove monitor handle %d, status %d, %spending",
+	bt_dev_dbg(hdev, "%s remove monitor handle %u, status %d, %spending",
 		   hdev->name, handle, *err, pending ? "" : "not ");
 
 	return pending;
@@ -3877,7 +3877,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	sprintf(hdev->name, "hci%d", id);
 	hdev->id = id;
 
-	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
+	BT_DBG("%p name %s bus %u", hdev, hdev->name, hdev->bus);
 
 	hdev->workqueue = alloc_ordered_workqueue("%s", WQ_HIGHPRI, hdev->name);
 	if (!hdev->workqueue) {
@@ -3968,7 +3968,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 {
 	int id;
 
-	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
+	BT_DBG("%p name %s bus %u", hdev, hdev->name, hdev->bus);
 
 	hci_dev_set_flag(hdev, HCI_UNREGISTER);
 
@@ -4171,7 +4171,7 @@ static void hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	int err;
 
-	BT_DBG("%s type %d len %d", hdev->name, hci_skb_pkt_type(skb),
+	BT_DBG("%s type %d len %u", hdev->name, hci_skb_pkt_type(skb),
 	       skb->len);
 
 	/* Time stamp */
@@ -4206,7 +4206,7 @@ int hci_send_cmd(struct hci_dev *hdev, __u16 opcode, __u32 plen,
 {
 	struct sk_buff *skb;
 
-	BT_DBG("%s opcode 0x%4.4x plen %d", hdev->name, opcode, plen);
+	BT_DBG("%s opcode 0x%4.4x plen %u", hdev->name, opcode, plen);
 
 	skb = hci_prepare_cmd(hdev, opcode, plen, param);
 	if (!skb) {
@@ -4283,7 +4283,7 @@ struct sk_buff *hci_cmd_sync(struct hci_dev *hdev, u16 opcode, u32 plen,
 	if (!test_bit(HCI_UP, &hdev->flags))
 		return ERR_PTR(-ENETDOWN);
 
-	bt_dev_dbg(hdev, "opcode 0x%4.4x plen %d", opcode, plen);
+	bt_dev_dbg(hdev, "opcode 0x%4.4x plen %u", opcode, plen);
 
 	hci_req_sync_lock(hdev);
 	skb = __hci_cmd_sync(hdev, opcode, plen, param, timeout);
@@ -4326,19 +4326,19 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
 		hci_add_acl_hdr(skb, chan->handle, flags);
 		break;
 	default:
-		bt_dev_err(hdev, "unknown dev_type %d", hdev->dev_type);
+		bt_dev_err(hdev, "unknown dev_type %u", hdev->dev_type);
 		return;
 	}
 
 	list = skb_shinfo(skb)->frag_list;
 	if (!list) {
 		/* Non fragmented */
-		BT_DBG("%s nonfrag skb %p len %d", hdev->name, skb, skb->len);
+		BT_DBG("%s nonfrag skb %p len %u", hdev->name, skb, skb->len);
 
 		skb_queue_tail(queue, skb);
 	} else {
 		/* Fragmented */
-		BT_DBG("%s frag %p len %d", hdev->name, skb, skb->len);
+		BT_DBG("%s frag %p len %u", hdev->name, skb, skb->len);
 
 		skb_shinfo(skb)->frag_list = NULL;
 
@@ -4359,7 +4359,7 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
 			hci_skb_pkt_type(skb) = HCI_ACLDATA_PKT;
 			hci_add_acl_hdr(skb, conn->handle, flags);
 
-			BT_DBG("%s frag %p len %d", hdev->name, skb, skb->len);
+			BT_DBG("%s frag %p len %u", hdev->name, skb, skb->len);
 
 			__skb_queue_tail(queue, skb);
 		} while (list);
@@ -4385,7 +4385,7 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	struct hci_dev *hdev = conn->hdev;
 	struct hci_sco_hdr hdr;
 
-	BT_DBG("%s len %d", hdev->name, skb->len);
+	BT_DBG("%s len %u", hdev->name, skb->len);
 
 	hdr.handle = cpu_to_le16(conn->handle);
 	hdr.dlen   = skb->len;
@@ -4451,7 +4451,7 @@ static struct hci_conn *hci_low_sent(struct hci_dev *hdev, __u8 type,
 			break;
 		default:
 			cnt = 0;
-			bt_dev_err(hdev, "unknown link type %d", conn->type);
+			bt_dev_err(hdev, "unknown link type %u", conn->type);
 		}
 
 		q = cnt / num;
@@ -4604,7 +4604,7 @@ static void hci_prio_recalculate(struct hci_dev *hdev, __u8 type)
 
 			skb->priority = HCI_PRIO_MAX - 1;
 
-			BT_DBG("chan %p skb %p promoted to %d", chan, skb,
+			BT_DBG("chan %p skb %p promoted to %u", chan, skb,
 			       skb->priority);
 		}
 
@@ -4647,7 +4647,7 @@ static void hci_sched_sco(struct hci_dev *hdev)
 
 	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
 		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
-			BT_DBG("skb %p len %d", skb, skb->len);
+			BT_DBG("skb %p len %u", skb, skb->len);
 			hci_send_frame(hdev, skb);
 
 			conn->sent++;
@@ -4671,7 +4671,7 @@ static void hci_sched_esco(struct hci_dev *hdev)
 	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
 						     &quote))) {
 		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
-			BT_DBG("skb %p len %d", skb, skb->len);
+			BT_DBG("skb %p len %u", skb, skb->len);
 			hci_send_frame(hdev, skb);
 
 			conn->sent++;
@@ -4694,7 +4694,7 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
 		while (quote-- && (skb = skb_peek(&chan->data_q))) {
-			BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
+			BT_DBG("chan %p skb %p len %u priority %u", chan, skb,
 			       skb->len, skb->priority);
 
 			/* Stop if priority has changed */
@@ -4746,7 +4746,7 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 		while (quote > 0 && (skb = skb_peek(&chan->data_q))) {
 			int blocks;
 
-			BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
+			BT_DBG("chan %p skb %p len %u priority %u", chan, skb,
 			       skb->len, skb->priority);
 
 			/* Stop if priority has changed */
@@ -4819,7 +4819,7 @@ static void hci_sched_le(struct hci_dev *hdev)
 	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
 		while (quote-- && (skb = skb_peek(&chan->data_q))) {
-			BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
+			BT_DBG("chan %p skb %p len %u priority %u", chan, skb,
 			       skb->len, skb->priority);
 
 			/* Stop if priority has changed */
@@ -4855,7 +4855,7 @@ static void hci_tx_work(struct work_struct *work)
 	struct hci_dev *hdev = container_of(work, struct hci_dev, tx_work);
 	struct sk_buff *skb;
 
-	BT_DBG("%s acl %d sco %d le %d", hdev->name, hdev->acl_cnt,
+	BT_DBG("%s acl %u sco %u le %u", hdev->name, hdev->acl_cnt,
 	       hdev->sco_cnt, hdev->le_cnt);
 
 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 341c8ce..266b7fb 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -519,7 +519,7 @@ static void hci_cc_read_num_supported_iac(struct hci_dev *hdev,
 
 	hdev->num_iac = rp->num_iac;
 
-	BT_DBG("%s num iac %d", hdev->name, hdev->num_iac);
+	BT_DBG("%s num iac %u", hdev->name, hdev->num_iac);
 }
 
 static void hci_cc_write_ssp_mode(struct hci_dev *hdev, struct sk_buff *skb)
@@ -765,7 +765,7 @@ static void hci_cc_read_buffer_size(struct hci_dev *hdev, struct sk_buff *skb)
 	hdev->acl_cnt = hdev->acl_pkts;
 	hdev->sco_cnt = hdev->sco_pkts;
 
-	BT_DBG("%s acl mtu %d:%d sco mtu %d:%d", hdev->name, hdev->acl_mtu,
+	BT_DBG("%s acl mtu %u:%u sco mtu %u:%u", hdev->name, hdev->acl_mtu,
 	       hdev->acl_pkts, hdev->sco_mtu, hdev->sco_pkts);
 }
 
@@ -883,7 +883,7 @@ static void hci_cc_read_data_block_size(struct hci_dev *hdev,
 
 	hdev->block_cnt = hdev->num_blocks;
 
-	BT_DBG("%s blk mtu %d cnt %d len %d", hdev->name, hdev->block_mtu,
+	BT_DBG("%s blk mtu %u cnt %u len %u", hdev->name, hdev->block_mtu,
 	       hdev->block_cnt, hdev->block_len);
 }
 
@@ -1046,7 +1046,7 @@ static void hci_cc_le_read_buffer_size(struct hci_dev *hdev,
 
 	hdev->le_cnt = hdev->le_pkts;
 
-	BT_DBG("%s le mtu %d:%d", hdev->name, hdev->le_mtu, hdev->le_pkts);
+	BT_DBG("%s le mtu %u:%u", hdev->name, hdev->le_mtu, hdev->le_pkts);
 }
 
 static void hci_cc_le_read_local_features(struct hci_dev *hdev,
@@ -1435,7 +1435,7 @@ static void le_set_scan_enable_complete(struct hci_dev *hdev, u8 enable)
 		break;
 
 	default:
-		bt_dev_err(hdev, "use of reserved LE_Scan_Enable param %d",
+		bt_dev_err(hdev, "use of reserved LE_Scan_Enable param %u",
 			   enable);
 		break;
 	}
@@ -3801,7 +3801,7 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	int i;
 
 	if (hdev->flow_ctl_mode != HCI_FLOW_CTL_MODE_PACKET_BASED) {
-		bt_dev_err(hdev, "wrong event for mode %d", hdev->flow_ctl_mode);
+		bt_dev_err(hdev, "wrong event for mode %u", hdev->flow_ctl_mode);
 		return;
 	}
 
@@ -3811,7 +3811,7 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
-	BT_DBG("%s num_hndl %d", hdev->name, ev->num_hndl);
+	BT_DBG("%s num_hndl %u", hdev->name, ev->num_hndl);
 
 	for (i = 0; i < ev->num_hndl; i++) {
 		struct hci_comp_pkts_info *info = &ev->handles[i];
@@ -3853,7 +3853,7 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
 			break;
 
 		default:
-			bt_dev_err(hdev, "unknown type %d conn %p",
+			bt_dev_err(hdev, "unknown type %u conn %p",
 				   conn->type, conn);
 			break;
 		}
@@ -3876,7 +3876,7 @@ static struct hci_conn *__hci_conn_lookup_handle(struct hci_dev *hdev,
 			return chan->conn;
 		break;
 	default:
-		bt_dev_err(hdev, "unknown dev_type %d", hdev->dev_type);
+		bt_dev_err(hdev, "unknown dev_type %u", hdev->dev_type);
 		break;
 	}
 
@@ -3889,7 +3889,7 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	int i;
 
 	if (hdev->flow_ctl_mode != HCI_FLOW_CTL_MODE_BLOCK_BASED) {
-		bt_dev_err(hdev, "wrong event for mode %d", hdev->flow_ctl_mode);
+		bt_dev_err(hdev, "wrong event for mode %u", hdev->flow_ctl_mode);
 		return;
 	}
 
@@ -3899,7 +3899,7 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
-	BT_DBG("%s num_blocks %d num_hndl %d", hdev->name, ev->num_blocks,
+	BT_DBG("%s num_blocks %d num_hndl %u", hdev->name, ev->num_blocks,
 	       ev->num_hndl);
 
 	for (i = 0; i < ev->num_hndl; i++) {
@@ -3925,7 +3925,7 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, struct sk_buff *skb)
 			break;
 
 		default:
-			bt_dev_err(hdev, "unknown type %d conn %p",
+			bt_dev_err(hdev, "unknown type %u conn %p",
 				   conn->type, conn);
 			break;
 		}
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 8ace5d3..b9b39ed 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -301,7 +301,7 @@ struct sk_buff *hci_prepare_cmd(struct hci_dev *hdev, u16 opcode, u32 plen,
 	if (plen)
 		skb_put_data(skb, param, plen);
 
-	bt_dev_dbg(hdev, "skb len %d", skb->len);
+	bt_dev_dbg(hdev, "skb len %u", skb->len);
 
 	hci_skb_pkt_type(skb) = HCI_COMMAND_PKT;
 	hci_skb_opcode(skb) = opcode;
@@ -316,7 +316,7 @@ void hci_req_add_ev(struct hci_request *req, u16 opcode, u32 plen,
 	struct hci_dev *hdev = req->hdev;
 	struct sk_buff *skb;
 
-	bt_dev_dbg(hdev, "opcode 0x%4.4x plen %d", opcode, plen);
+	bt_dev_dbg(hdev, "opcode 0x%4.4x plen %u", opcode, plen);
 
 	/* If an error occurred during request building, there is no point in
 	 * queueing the HCI command. We can simply return.
@@ -1103,7 +1103,7 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 		interval = hdev->le_scan_interval;
 	}
 
-	bt_dev_dbg(hdev, "LE passive scan with whitelist = %d", filter_policy);
+	bt_dev_dbg(hdev, "LE passive scan with whitelist = %u", filter_policy);
 	hci_req_start_scan(req, LE_SCAN_PASSIVE, interval, window,
 			   own_addr_type, filter_policy, addr_resolv);
 }
@@ -3078,7 +3078,7 @@ static void le_scan_restart_work(struct work_struct *work)
 
 	hci_req_sync(hdev, le_scan_restart, 0, HCI_CMD_TIMEOUT, &status);
 	if (status) {
-		bt_dev_err(hdev, "failed to restart LE scan: status %d",
+		bt_dev_err(hdev, "failed to restart LE scan: status %u",
 			   status);
 		return;
 	}
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 251b912..6ef2be0 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -193,7 +193,7 @@ void hci_send_to_sock(struct hci_dev *hdev, struct sk_buff *skb)
 	struct sock *sk;
 	struct sk_buff *skb_copy = NULL;
 
-	BT_DBG("hdev %p len %d", hdev, skb->len);
+	BT_DBG("hdev %p len %u", hdev, skb->len);
 
 	read_lock(&hci_sk_list.lock);
 
@@ -258,7 +258,7 @@ static void __hci_send_to_channel(unsigned short channel, struct sk_buff *skb,
 {
 	struct sock *sk;
 
-	BT_DBG("channel %u len %d", channel, skb->len);
+	BT_DBG("channel %u len %u", channel, skb->len);
 
 	sk_for_each(sk, &hci_sk_list.head) {
 		struct sk_buff *nskb;
@@ -305,7 +305,7 @@ void hci_send_to_monitor(struct hci_dev *hdev, struct sk_buff *skb)
 	if (!atomic_read(&monitor_promisc))
 		return;
 
-	BT_DBG("hdev %p len %d", hdev, skb->len);
+	BT_DBG("hdev %p len %u", hdev, skb->len);
 
 	switch (hci_skb_pkt_type(skb)) {
 	case HCI_COMMAND_PKT:
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 9874844..be37a5e 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -48,7 +48,7 @@ void hci_conn_add_sysfs(struct hci_conn *conn)
 
 	BT_DBG("conn %p", conn);
 
-	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
+	dev_set_name(&conn->dev, "%s:%u", hdev->name, conn->handle);
 
 	if (device_add(&conn->dev) < 0) {
 		bt_dev_err(hdev, "failed to register connection device");
-- 
2.8.1

