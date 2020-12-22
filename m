Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595612E0867
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 10:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgLVJ6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 04:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgLVJ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 04:58:33 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CD4C0611CA
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:28 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id t7so10254230qtn.19
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=h+egx8jf9cJX3Sw1Ur5v/c0d0lYjBoeqnv3qm3aC9sc=;
        b=jqq39lrxLFNDT4p8nOSymb4GgY/ks1h8ZA5Vbfgl5e//KA7kLnA6FcMCUowk4yBj5K
         xX1wVwRypuHLZ6WoDgtsesqXL1PvuFBKwDlL0qZoinU17m1uWYlpKnl+lXj1+MYd3NaO
         syXNg3H84d+SjzttGNMz/kz5L6bDcT4OPAXcFgeRERec4/MovwU2M7Wyau53Ub2y6+sS
         9eJvL82BildK6YG4i6LWUdVWoGPNbnXT5NLW0bkSpjyDDQ+D9LzCKx23spIDtFDvx14z
         Tgh7lX/08Rcj9W3sbjiT/fTi65Vt5F2NPGmuLmAMSw4Th0rVf0XQkJtgxE7U8uEtuWu7
         kv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h+egx8jf9cJX3Sw1Ur5v/c0d0lYjBoeqnv3qm3aC9sc=;
        b=YtelfHTRIK+kspouHfTfIF20kEM5KeWBM0f2NOAalk/wO8XV+4KNM8yPL+PElBFH5n
         AqSum7yIolahcipH0e7XSOK81Y8FpSSKUyh/UyqfIfryryTRV8xH1I/sKE0dWP+z6rpv
         YcG0k/K20i887GPax0y21+Bhd2J+9v7xbf/hSX1oV1hi+34vA09nn42wIaM83OJPC8Yp
         xx0PVRGPeDGF0Hr4BC+J0Hj2QNDWGuHJuuqa5z/LGDfXbfiWQJ12dYft+QffurmczH/c
         L/5b/7o4oRVt8aG911i9MPInURaZ9P5BCQ2setax5WXE6990B3mJudHNFk1SO3EkZFyB
         OcOA==
X-Gm-Message-State: AOAM532vDf8gyMdWAOlllRv6cQv5rc3tX6pYTnIen6wD2Dcw7gY49KZJ
        A2nn68d3AbCC+PfC/6evg5m099oE7JB5
X-Google-Smtp-Source: ABdhPJycFCoZcGgq1tD9DThNVx/wYtfht3uPAYdkiffz5lTkhyhVAFqzzj6f+yNGXWvFSShPfWwTYL4qtPiT
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([172.30.210.44])
 (user=apusaka job=sendgmr) by 2002:a0c:f7c5:: with SMTP id
 f5mr21411815qvo.33.1608631046436; Tue, 22 Dec 2020 01:57:26 -0800 (PST)
Date:   Tue, 22 Dec 2020 17:57:04 +0800
In-Reply-To: <20201222095706.948827-1-apusaka@google.com>
Message-Id: <20201222175659.v4.3.I2bdb3d9953a91dc7865da6e57166260b3a75c146@changeid>
Mime-Version: 1.0
References: <20201222095706.948827-1-apusaka@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v4 3/5] Bluetooth: advmon offload MSFT remove monitor
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

Implements the monitor removal functionality for advertising monitor
offloading to MSFT controllers. Supply handle = 0 to remove all
monitors.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Yun-Hao Chung <howardchung@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

---

(no changes since v3)

Changes in v3:
* Fix return type of msft_remove_monitor

 include/net/bluetooth/hci_core.h |   8 +-
 net/bluetooth/hci_core.c         | 119 +++++++++++++++++++++++------
 net/bluetooth/mgmt.c             | 110 +++++++++++++++++++++-----
 net/bluetooth/msft.c             | 127 ++++++++++++++++++++++++++++++-
 net/bluetooth/msft.h             |   9 +++
 5 files changed, 323 insertions(+), 50 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 879d1e38ce96..29cfc6a2d689 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1332,11 +1332,13 @@ int hci_remove_adv_instance(struct hci_dev *hdev, u8 instance);
 void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
 
 void hci_adv_monitors_clear(struct hci_dev *hdev);
-void hci_free_adv_monitor(struct adv_monitor *monitor);
+void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
 int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
+int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 			int *err);
-int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle);
+bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle, int *err);
+bool hci_remove_all_adv_monitor(struct hci_dev *hdev, int *err);
 bool hci_is_adv_monitoring(struct hci_dev *hdev);
 int hci_get_adv_monitor_offload_ext(struct hci_dev *hdev);
 
@@ -1813,8 +1815,10 @@ void mgmt_advertising_added(struct sock *sk, struct hci_dev *hdev,
 			    u8 instance);
 void mgmt_advertising_removed(struct sock *sk, struct hci_dev *hdev,
 			      u8 instance);
+void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
+int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 625298f64a20..b0a63f643a07 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3051,12 +3051,15 @@ void hci_adv_monitors_clear(struct hci_dev *hdev)
 	int handle;
 
 	idr_for_each_entry(&hdev->adv_monitors_idr, monitor, handle)
-		hci_free_adv_monitor(monitor);
+		hci_free_adv_monitor(hdev, monitor);
 
 	idr_destroy(&hdev->adv_monitors_idr);
 }
 
-void hci_free_adv_monitor(struct adv_monitor *monitor)
+/* Frees the monitor structure and do some bookkeepings.
+ * This function requires the caller holds hdev->lock.
+ */
+void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 {
 	struct adv_pattern *pattern;
 	struct adv_pattern *tmp;
@@ -3064,8 +3067,18 @@ void hci_free_adv_monitor(struct adv_monitor *monitor)
 	if (!monitor)
 		return;
 
-	list_for_each_entry_safe(pattern, tmp, &monitor->patterns, list)
+	list_for_each_entry_safe(pattern, tmp, &monitor->patterns, list) {
+		list_del(&pattern->list);
 		kfree(pattern);
+	}
+
+	if (monitor->handle)
+		idr_remove(&hdev->adv_monitors_idr, monitor->handle);
+
+	if (monitor->state != ADV_MONITOR_STATE_NOT_REGISTERED) {
+		hdev->adv_monitors_cnt--;
+		mgmt_adv_monitor_removed(hdev, monitor->handle);
+	}
 
 	kfree(monitor);
 }
@@ -3075,6 +3088,11 @@ int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
 	return mgmt_add_adv_patterns_monitor_complete(hdev, status);
 }
 
+int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
+{
+	return mgmt_remove_adv_monitor_complete(hdev, status);
+}
+
 /* Assigns handle to a monitor, and if offloading is supported and power is on,
  * also attempts to forward the request to the controller.
  * Returns true if request is forwarded (result is pending), false otherwise.
@@ -3122,39 +3140,94 @@ bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 	return (*err == 0);
 }
 
-static int free_adv_monitor(int id, void *ptr, void *data)
+/* Attempts to tell the controller and free the monitor. If somehow the
+ * controller doesn't have a corresponding handle, remove anyway.
+ * Returns true if request is forwarded (result is pending), false otherwise.
+ * This function requires the caller holds hdev->lock.
+ */
+static bool hci_remove_adv_monitor(struct hci_dev *hdev,
+				   struct adv_monitor *monitor,
+				   u16 handle, int *err)
 {
-	struct hci_dev *hdev = data;
-	struct adv_monitor *monitor = ptr;
+	*err = 0;
 
-	idr_remove(&hdev->adv_monitors_idr, monitor->handle);
-	hci_free_adv_monitor(monitor);
-	hdev->adv_monitors_cnt--;
+	switch (hci_get_adv_monitor_offload_ext(hdev)) {
+	case HCI_ADV_MONITOR_EXT_NONE: /* also goes here when powered off */
+		goto free_monitor;
+	case HCI_ADV_MONITOR_EXT_MSFT:
+		*err = msft_remove_monitor(hdev, monitor, handle);
+		break;
+	}
 
-	return 0;
+	/* In case no matching handle registered, just free the monitor */
+	if (*err == -ENOENT)
+		goto free_monitor;
+
+	return (*err == 0);
+
+free_monitor:
+	if (*err == -ENOENT)
+		bt_dev_warn(hdev, "Removing monitor with no matching handle %d",
+			    monitor->handle);
+	hci_free_adv_monitor(hdev, monitor);
+
+	*err = 0;
+	return false;
 }
 
-/* This function requires the caller holds hdev->lock */
-int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle)
+/* Returns true if request is forwarded (result is pending), false otherwise.
+ * This function requires the caller holds hdev->lock.
+ */
+bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle, int *err)
+{
+	struct adv_monitor *monitor = idr_find(&hdev->adv_monitors_idr, handle);
+	bool pending;
+
+	if (!monitor) {
+		*err = -EINVAL;
+		return false;
+	}
+
+	pending = hci_remove_adv_monitor(hdev, monitor, handle, err);
+	if (!*err && !pending)
+		hci_update_background_scan(hdev);
+
+	bt_dev_dbg(hdev, "%s remove monitor handle %d, status %d, %spending",
+		   hdev->name, handle, *err, pending ? "" : "not ");
+
+	return pending;
+}
+
+/* Returns true if request is forwarded (result is pending), false otherwise.
+ * This function requires the caller holds hdev->lock.
+ */
+bool hci_remove_all_adv_monitor(struct hci_dev *hdev, int *err)
 {
 	struct adv_monitor *monitor;
+	int idr_next_id = 0;
+	bool pending = false;
+	bool update = false;
+
+	*err = 0;
 
-	if (handle) {
-		monitor = idr_find(&hdev->adv_monitors_idr, handle);
+	while (!*err && !pending) {
+		monitor = idr_get_next(&hdev->adv_monitors_idr, &idr_next_id);
 		if (!monitor)
-			return -ENOENT;
+			break;
 
-		idr_remove(&hdev->adv_monitors_idr, monitor->handle);
-		hci_free_adv_monitor(monitor);
-		hdev->adv_monitors_cnt--;
-	} else {
-		/* Remove all monitors if handle is 0. */
-		idr_for_each(&hdev->adv_monitors_idr, &free_adv_monitor, hdev);
+		pending = hci_remove_adv_monitor(hdev, monitor, 0, err);
+
+		if (!*err && !pending)
+			update = true;
 	}
 
-	hci_update_background_scan(hdev);
+	if (update)
+		hci_update_background_scan(hdev);
 
-	return 0;
+	bt_dev_dbg(hdev, "%s remove all monitors status %d, %spending",
+		   hdev->name, *err, pending ? "" : "not ");
+
+	return pending;
 }
 
 /* This function requires the caller holds hdev->lock */
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fea5e9763b72..8ff9c4bb43d1 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4167,14 +4167,24 @@ static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
 	mgmt_event(MGMT_EV_ADV_MONITOR_ADDED, hdev, &ev, sizeof(ev), sk);
 }
 
-static void mgmt_adv_monitor_removed(struct sock *sk, struct hci_dev *hdev,
-				     u16 handle)
+void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle)
 {
-	struct mgmt_ev_adv_monitor_added ev;
+	struct mgmt_ev_adv_monitor_removed ev;
+	struct mgmt_pending_cmd *cmd;
+	struct sock *sk_skip = NULL;
+	struct mgmt_cp_remove_adv_monitor *cp;
+
+	cmd = pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev);
+	if (cmd) {
+		cp = cmd->param;
+
+		if (cp->monitor_handle)
+			sk_skip = cmd->sk;
+	}
 
 	ev.monitor_handle = cpu_to_le16(handle);
 
-	mgmt_event(MGMT_EV_ADV_MONITOR_REMOVED, hdev, &ev, sizeof(ev), sk);
+	mgmt_event(MGMT_EV_ADV_MONITOR_REMOVED, hdev, &ev, sizeof(ev), sk_skip);
 }
 
 static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
@@ -4324,8 +4334,8 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	return 0;
 
 unlock:
+	hci_free_adv_monitor(hdev, m);
 	hci_dev_unlock(hdev);
-	hci_free_adv_monitor(m);
 	return mgmt_cmd_status(sk, hdev->id, op, status);
 }
 
@@ -4459,42 +4469,100 @@ static int add_adv_patterns_monitor_rssi(struct sock *sk, struct hci_dev *hdev,
 					 MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI);
 }
 
+int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
+{
+	struct mgmt_rp_remove_adv_monitor rp;
+	struct mgmt_cp_remove_adv_monitor *cp;
+	struct mgmt_pending_cmd *cmd;
+	int err = 0;
+
+	hci_dev_lock(hdev);
+
+	cmd = pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev);
+	if (!cmd)
+		goto done;
+
+	cp = cmd->param;
+	rp.monitor_handle = cp->monitor_handle;
+
+	if (!status)
+		hci_update_background_scan(hdev);
+
+	err = mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
+				mgmt_status(status), &rp, sizeof(rp));
+	mgmt_pending_remove(cmd);
+
+done:
+	hci_dev_unlock(hdev);
+	bt_dev_dbg(hdev, "remove monitor %d complete, status %d",
+		   rp.monitor_handle, status);
+
+	return err;
+}
+
 static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 			      void *data, u16 len)
 {
 	struct mgmt_cp_remove_adv_monitor *cp = data;
 	struct mgmt_rp_remove_adv_monitor rp;
-	unsigned int prev_adv_monitors_cnt;
-	u16 handle;
-	int err;
+	struct mgmt_pending_cmd *cmd;
+	u16 handle = __le16_to_cpu(cp->monitor_handle);
+	int err, status;
+	bool pending;
 
 	BT_DBG("request for %s", hdev->name);
+	rp.monitor_handle = cp->monitor_handle;
 
 	hci_dev_lock(hdev);
 
-	handle = __le16_to_cpu(cp->monitor_handle);
-	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
+	if (pending_find(MGMT_OP_SET_LE, hdev) ||
+	    pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev) ||
+	    pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR, hdev) ||
+	    pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI, hdev)) {
+		status = MGMT_STATUS_BUSY;
+		goto unlock;
+	}
 
-	err = hci_remove_adv_monitor(hdev, handle);
-	if (err == -ENOENT) {
-		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
-				      MGMT_STATUS_INVALID_INDEX);
+	cmd = mgmt_pending_add(sk, MGMT_OP_REMOVE_ADV_MONITOR, hdev, data, len);
+	if (!cmd) {
+		status = MGMT_STATUS_NO_RESOURCES;
 		goto unlock;
 	}
 
-	if (hdev->adv_monitors_cnt < prev_adv_monitors_cnt)
-		mgmt_adv_monitor_removed(sk, hdev, handle);
+	if (handle)
+		pending = hci_remove_single_adv_monitor(hdev, handle, &err);
+	else
+		pending = hci_remove_all_adv_monitor(hdev, &err);
 
-	hci_dev_unlock(hdev);
+	if (err) {
+		mgmt_pending_remove(cmd);
 
-	rp.monitor_handle = cp->monitor_handle;
+		if (err == -ENOENT)
+			status = MGMT_STATUS_INVALID_INDEX;
+		else
+			status = MGMT_STATUS_FAILED;
+
+		goto unlock;
+	}
+
+	/* monitor can be removed without forwarding request to controller */
+	if (!pending) {
+		mgmt_pending_remove(cmd);
+		hci_dev_unlock(hdev);
+
+		return mgmt_cmd_complete(sk, hdev->id,
+					 MGMT_OP_REMOVE_ADV_MONITOR,
+					 MGMT_STATUS_SUCCESS,
+					 &rp, sizeof(rp));
+	}
 
-	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
-				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
+	hci_dev_unlock(hdev);
+	return 0;
 
 unlock:
 	hci_dev_unlock(hdev);
-	return err;
+	return mgmt_cmd_status(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
+			       status);
 }
 
 static void read_local_oob_data_complete(struct hci_dev *hdev, u8 status,
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index e4b8fe71b9c3..f5aa0e3b1b9b 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -58,6 +58,17 @@ struct msft_rp_le_monitor_advertisement {
 	__u8 handle;
 } __packed;
 
+#define MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT	0x04
+struct msft_cp_le_cancel_monitor_advertisement {
+	__u8 sub_opcode;
+	__u8 handle;
+} __packed;
+
+struct msft_rp_le_cancel_monitor_advertisement {
+	__u8 status;
+	__u8 sub_opcode;
+} __packed;
+
 struct msft_monitor_advertisement_handle_data {
 	__u8  msft_handle;
 	__u16 mgmt_handle;
@@ -70,6 +81,7 @@ struct msft_data {
 	__u8  *evt_prefix;
 	struct list_head handle_map;
 	__u16 pending_add_handle;
+	__u16 pending_remove_handle;
 };
 
 bool msft_monitor_supported(struct hci_dev *hdev)
@@ -205,6 +217,26 @@ __u64 msft_get_features(struct hci_dev *hdev)
 	return msft ? msft->features : 0;
 }
 
+/* is_mgmt = true matches the handle exposed to userspace via mgmt.
+ * is_mgmt = false matches the handle used by the msft controller.
+ * This function requires the caller holds hdev->lock
+ */
+static struct msft_monitor_advertisement_handle_data *msft_find_handle_data
+				(struct hci_dev *hdev, u16 handle, bool is_mgmt)
+{
+	struct msft_monitor_advertisement_handle_data *entry;
+	struct msft_data *msft = hdev->msft_data;
+
+	list_for_each_entry(entry, &msft->handle_map, list) {
+		if (is_mgmt && entry->mgmt_handle == handle)
+			return entry;
+		if (!is_mgmt && entry->msft_handle == handle)
+			return entry;
+	}
+
+	return NULL;
+}
+
 static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
 					     u8 status, u16 opcode,
 					     struct sk_buff *skb)
@@ -247,16 +279,71 @@ static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
 	monitor->state = ADV_MONITOR_STATE_OFFLOADED;
 
 unlock:
-	if (status && monitor) {
-		idr_remove(&hdev->adv_monitors_idr, monitor->handle);
-		hci_free_adv_monitor(monitor);
-	}
+	if (status && monitor)
+		hci_free_adv_monitor(hdev, monitor);
 
 	hci_dev_unlock(hdev);
 
 	hci_add_adv_patterns_monitor_complete(hdev, status);
 }
 
+static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
+						    u8 status, u16 opcode,
+						    struct sk_buff *skb)
+{
+	struct msft_cp_le_cancel_monitor_advertisement *cp;
+	struct msft_rp_le_cancel_monitor_advertisement *rp;
+	struct adv_monitor *monitor;
+	struct msft_monitor_advertisement_handle_data *handle_data;
+	struct msft_data *msft = hdev->msft_data;
+	int err;
+	bool pending;
+
+	if (status)
+		goto done;
+
+	rp = (struct msft_rp_le_cancel_monitor_advertisement *)skb->data;
+	if (skb->len < sizeof(*rp)) {
+		status = HCI_ERROR_UNSPECIFIED;
+		goto done;
+	}
+
+	hci_dev_lock(hdev);
+
+	cp = hci_sent_cmd_data(hdev, hdev->msft_opcode);
+	handle_data = msft_find_handle_data(hdev, cp->handle, false);
+
+	if (handle_data) {
+		monitor = idr_find(&hdev->adv_monitors_idr,
+				   handle_data->mgmt_handle);
+		if (monitor)
+			hci_free_adv_monitor(hdev, monitor);
+
+		list_del(&handle_data->list);
+		kfree(handle_data);
+	}
+
+	/* If remove all monitors is required, we need to continue the process
+	 * here because the earlier it was paused when waiting for the
+	 * response from controller.
+	 */
+	if (msft->pending_remove_handle == 0) {
+		pending = hci_remove_all_adv_monitor(hdev, &err);
+		if (pending) {
+			hci_dev_unlock(hdev);
+			return;
+		}
+
+		if (err)
+			status = HCI_ERROR_UNSPECIFIED;
+	}
+
+	hci_dev_unlock(hdev);
+
+done:
+	hci_remove_adv_monitor_complete(hdev, status);
+}
+
 static bool msft_monitor_rssi_valid(struct adv_monitor *monitor)
 {
 	struct adv_rssi_thresholds *r = &monitor->rssi;
@@ -346,3 +433,35 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
 
 	return err;
 }
+
+/* This function requires the caller holds hdev->lock */
+int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
+			u16 handle)
+{
+	struct msft_cp_le_cancel_monitor_advertisement cp;
+	struct msft_monitor_advertisement_handle_data *handle_data;
+	struct hci_request req;
+	struct msft_data *msft = hdev->msft_data;
+	int err = 0;
+
+	if (!msft)
+		return -EOPNOTSUPP;
+
+	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
+
+	/* If no matched handle, just remove without telling controller */
+	if (!handle_data)
+		return -ENOENT;
+
+	cp.sub_opcode = MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
+	cp.handle = handle_data->msft_handle;
+
+	hci_req_init(&req, hdev);
+	hci_req_add(&req, hdev->msft_opcode, sizeof(cp), &cp);
+	err = hci_req_run_skb(&req, msft_le_cancel_monitor_advertisement_cb);
+
+	if (!err)
+		msft->pending_remove_handle = handle;
+
+	return err;
+}
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index 0ac9b15322b1..6f126a1f1688 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -18,6 +18,8 @@ void msft_do_close(struct hci_dev *hdev);
 void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
 __u64 msft_get_features(struct hci_dev *hdev);
 int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor);
+int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
+			u16 handle);
 
 #else
 
@@ -36,4 +38,11 @@ static inline int msft_add_monitor_pattern(struct hci_dev *hdev,
 	return -EOPNOTSUPP;
 }
 
+static inline int msft_remove_monitor(struct hci_dev *hdev,
+				      struct adv_monitor *monitor,
+				      u16 handle)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
-- 
2.29.2.729.g45daf8777d-goog

