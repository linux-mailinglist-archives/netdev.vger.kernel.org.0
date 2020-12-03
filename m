Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003C12CD38B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388818AbgLCKbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388803AbgLCKbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:31:07 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63445C08E85F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 02:30:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x129so2058816ybg.12
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 02:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=u7LA7TI+m014MHf1r0Np3Fnca+wIIXRyz0e4OSJVybk=;
        b=AiGnGEISBW9febMfT350l4B+LEsYU2Vyi85aZunXUCPDDqmpy++ZIaMeBaozY3vefp
         Yd6bISUo2tP37vay5KdrpTBhCZYbPCmzDUaqnIbKKBsb8IQTjU1ILiOnKWzeS2VOxkha
         gg+h+MEExNYHxsmdhXejQX8I3tiHLO6yAV5jJHVJsNAQvjut+hehTYUy7gpVyhJGtGCi
         lHi8797dsw4c7ExkNcWfaXMM2F23UjK/XNKgh0z0fftULr0r3g0wUMufJMmAk6gv+ZUo
         VLLSfgKgOruZPdUq4B0cNPRavehf+5Vd6W1xmPCQ/jqUl6OE/ZSvd6rBETAqQ73nn94H
         9O8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u7LA7TI+m014MHf1r0Np3Fnca+wIIXRyz0e4OSJVybk=;
        b=mrO7BAm+W7G5dKNu77VjtPb2qt9aBaDZ6EMTIVLGTSuTczHpmNJ+52iZ6K3OVRhy8v
         AZu0r4XCzmhce7g+Bed8XPuTz0VXn9Jfzn/rapP6S5hXRCD/AvBPgdceG7FG84bgac5M
         sOM9XXzRiMQ2BRgWjXqlXb3GSc6y9+GgerWa2DPn31uBrQjyylv8rHm39kkKzhEnMd2s
         MJXLVhvJ9XVd1YXy+Rk2Z3y8AMnDwigb1rf+FO4D+HHXrPO8Z8m1pIlrfD8kHA4iDtz2
         QXg3ZHW1+1dtCHFqV0l8/qQAk0otUlvzWLDPabcExssOhGBUqCLKyHPBljOVst7N7C78
         LpIw==
X-Gm-Message-State: AOAM531hXytJTxLiOF6Uo5asF4xIgFmKdjDIwiPYckXqDmEjz5+vfG+I
        Kuc+xIjcMU4pclBfWe+NOi7AbirdCm23
X-Google-Smtp-Source: ABdhPJxeZHDgb1NLZtyJBmiArkVC0Zo0t3zCQ1zCXBGzL40EwWZRXoa6KOi3JZO1c11HK67x/1NsGn1lssIf
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:f693:9fff:fef4:2347])
 (user=apusaka job=sendgmr) by 2002:a25:ab72:: with SMTP id
 u105mr3621729ybi.406.1606991401633; Thu, 03 Dec 2020 02:30:01 -0800 (PST)
Date:   Thu,  3 Dec 2020 18:29:33 +0800
In-Reply-To: <20201203102936.4049556-1-apusaka@google.com>
Message-Id: <20201203182903.v1.3.I2bdb3d9953a91dc7865da6e57166260b3a75c146@changeid>
Mime-Version: 1.0
References: <20201203102936.4049556-1-apusaka@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v1 3/5] Bluetooth: advmon offload MSFT remove monitor
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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

---

 include/net/bluetooth/hci_core.h |   8 +-
 net/bluetooth/hci_core.c         | 119 +++++++++++++++++++++++------
 net/bluetooth/mgmt.c             | 109 +++++++++++++++++++++-----
 net/bluetooth/msft.c             | 127 ++++++++++++++++++++++++++++++-
 net/bluetooth/msft.h             |   9 +++
 5 files changed, 322 insertions(+), 50 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 275061a1b670..0a211cd52fdb 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1311,11 +1311,13 @@ int hci_remove_adv_instance(struct hci_dev *hdev, u8 instance);
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
 
@@ -1792,8 +1794,10 @@ void mgmt_advertising_added(struct sock *sk, struct hci_dev *hdev,
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
index 7f70812dde15..70bb2a11d9b1 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3012,12 +3012,15 @@ void hci_adv_monitors_clear(struct hci_dev *hdev)
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
@@ -3025,8 +3028,18 @@ void hci_free_adv_monitor(struct adv_monitor *monitor)
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
@@ -3036,6 +3049,11 @@ int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
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
@@ -3082,39 +3100,94 @@ bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
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
+	BT_DBG("%s remove monitor handle %d, status %d, %spending",
+	       hdev->name, handle, *err, pending ? "" : "not ");
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
+	BT_DBG("%s remove all monitors status %d, %spending",
+	       hdev->name, *err, pending ? "" : "not ");
+
+	return pending;
 }
 
 /* This function requires the caller holds hdev->lock */
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index d32761f64360..8af0ff10ee78 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4149,14 +4149,24 @@ static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
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
@@ -4358,48 +4368,105 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	return 0;
 
 unlock:
+	hci_free_adv_monitor(hdev, m);
 	hci_dev_unlock(hdev);
-	hci_free_adv_monitor(m);
 	return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
 			       status);
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
+	    pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR, hdev)) {
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
 
-	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
-				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
+		return mgmt_cmd_complete(sk, hdev->id,
+					 MGMT_OP_REMOVE_ADV_MONITOR,
+					 MGMT_STATUS_SUCCESS,
+					 &rp, sizeof(rp));
+	}
+
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
index 0ac9b15322b1..9f9a11f90b0c 100644
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
 
+static inline bool msft_remove_monitor(struct hci_dev *hdev,
+				       struct adv_monitor *monitor,
+				       u16 handle)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
-- 
2.29.2.454.gaff20da3a2-goog

