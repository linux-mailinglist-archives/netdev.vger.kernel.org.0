Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2015742C11B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhJMNPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbhJMNPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:15:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A470BC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 06:13:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s6-20020a254506000000b005b6b6434cd6so3014693yba.9
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 06:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2IbrE7OdI5lAN+e+5DSyYHcce5Lqaw+WSvS0Y2XHZ5Q=;
        b=HdSK0Bue6zaqRHswcd7UVxgshHI93l7F+SZqOGuNfc4vouErDlpd2oMiBoY/lD8cBz
         6u4IsjzBPrAWpxPqHtx5jpTqLv3H56g6nMFjSLSlz4u+8uz7NfRX/WYMwaxRnTU3DXBg
         UoMVwkLRj3cI2aR7FOoB+PrpAGM0PuBwUcQ9Cq7CoYlZ9Ke/75y/FiXovIa44Lj7/JbO
         pGb5vQlH1dJO/ZgzlwO6EnQ8TTyec2wSAtiEuVmnu6l1jaQmusucbLv3vdi9kjhs/anq
         IrPzGcDypy0salt6VljVSsK/VzYuOT1PGGBauffNGGIXWcMNqBBED6B8+LTPoUiW7/gx
         Livw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2IbrE7OdI5lAN+e+5DSyYHcce5Lqaw+WSvS0Y2XHZ5Q=;
        b=plk4IZj1N10dnUwIyVHnjhlSxoHk9CIiZShhqQ7sUcgXyCHCmxFqTYjqpnjyn8kNQO
         tjvSQgJPPOoy6jGsk2nte6nOq+aZL+l2nzIX/V6dH0SUV5/ErrLRQjjcwxXXTwU3Mssr
         9QAKibphUHI0l9o1zUuBZ94opXbDyo7m7l2T3wRxY1JmUSiAqK/N8Ozeox9xLXIUqUvq
         iB5dXo7Wc6hp2EJ1EKR8jvcRoHylBq++pRB9r2MP7UEBMUaHPMY12BCUvmf1PZWM+T5Y
         SyVbRPXn5csnNyM+tz5QGkVccqia/WD192X5rHBhhQCgJQ6aBGC5XMQznCe6m1vXVfnr
         6boQ==
X-Gm-Message-State: AOAM533ElqpNEoQYWPP2k6IglMpSOY1pQAvbk5rwg8ulrEQAdXyS6K7R
        Lo9o/jGknr2mG8o5Ctq9vL/Z5W5HU1XweQ==
X-Google-Smtp-Source: ABdhPJx0fOEHf3bvAUG4vTvaEObPVNuHKP2Q0PALhT85G6cDKlnFggxqZdIBLB9MZqqdPi9lhjdPDy92I2hStw==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:f8a0:57c1:fc2b:3837])
 (user=mmandlik job=sendgmr) by 2002:a25:552:: with SMTP id
 79mr34250843ybf.202.1634130812818; Wed, 13 Oct 2021 06:13:32 -0700 (PDT)
Date:   Wed, 13 Oct 2021 06:12:41 -0700
Message-Id: <20211013060746.v2.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2] bluetooth: Add support to handle MSFT Monitor Device event
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MSFT Monitor Device event indicates that the controller has either
started or stopped monitoring a Bluetooth device. This event is used by
the bluetoothd to notify clients with DeviceFound/DeviceLost.

Whenever the controller starts monitoring a device, 'Device Tracked'
flag in the 'Device Found' event is set and 'Monitor_Handle' indicates
the matched monitor id. When the controller stops monitoring the device,
the 'Device Lost' event is sent to the bluetoothd.

Test performed:
- verified by logs that Monitor Device is received from the controller
  and sent to the bluetoothd when the controller starts/stops monitoring
  a bluetooth device.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
---
Hello Bt-Maintainers,

As mentioned in the bluez patch series [1], we need to capture the 'MSFT
Monitor Device' from the controller and pass it to the bluetoothd.

This is required to further optimize the power consumption by avoiding
handling of RSSI thresholds and timeouts in the user space and let the
controller do the RSSI tracking.

This patch adds support to read HCI_VS_MSFT_LE_Monitor_Device_Event,
adds a flag in Device Found event to indicate device is being tracked,
introduces a new MGMT event MGMT_EV_ADV_MONITOR_DEVICE_LOST to indicate
that the controller has stopped tracking that particular device.

Please let me know what you think about this or if you have any further
questions.

[1] https://patchwork.kernel.org/project/bluetooth/list/?series=562679

Thanks,
Manish.

Changes in v2:
- Instead of creating a new 'Device Tracking' event, add a flag 'Device
  Tracked' in the existing 'Device Found' event and add a new 'Device
  Lost' event to indicate that the controller has stopped tracking that
  device.

 include/net/bluetooth/hci_core.h |  11 ++++
 include/net/bluetooth/mgmt.h     |   8 +++
 net/bluetooth/hci_core.c         |  12 ++++
 net/bluetooth/mgmt.c             |  39 +++++++++++-
 net/bluetooth/msft.c             | 103 ++++++++++++++++++++++++-------
 5 files changed, 151 insertions(+), 22 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index dd8840e70e25..36c50e36a594 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -256,6 +256,14 @@ struct adv_info {
 
 #define HCI_ADV_TX_POWER_NO_PREFERENCE 0x7F
 
+struct monitored_device {
+	struct list_head list;
+
+	bdaddr_t bdaddr;
+	__u8     addr_type;
+	__u16    handle;
+};
+
 struct adv_pattern {
 	struct list_head list;
 	__u8 ad_type;
@@ -548,6 +556,7 @@ struct hci_dev {
 	struct list_head	pend_le_reports;
 	struct list_head	blocked_keys;
 	struct list_head	local_codecs;
+	struct list_head	monitored_devices;
 
 	struct hci_dev_stats	stat;
 
@@ -1842,6 +1851,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
+void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
+				  bdaddr_t *addr, u8 addr_type);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23a0524061b7..3d0472b3ebdc 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -940,12 +940,14 @@ struct mgmt_ev_auth_failed {
 #define MGMT_DEV_FOUND_LEGACY_PAIRING  0x02
 #define MGMT_DEV_FOUND_NOT_CONNECTABLE 0x04
 #define MGMT_DEV_FOUND_INITIATED_CONN  0x08
+#define MGMT_DEV_FOUND_MONITORING      0x10
 
 #define MGMT_EV_DEVICE_FOUND		0x0012
 struct mgmt_ev_device_found {
 	struct mgmt_addr_info addr;
 	__s8	rssi;
 	__le32	flags;
+	__le16  monitor_handle;
 	__le16	eir_len;
 	__u8	eir[];
 } __packed;
@@ -1103,3 +1105,9 @@ struct mgmt_ev_controller_resume {
 #define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
 #define MGMT_WAKE_REASON_UNEXPECTED		0x1
 #define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
+
+#define MGMT_EV_ADV_MONITOR_DEVICE_LOST		0x002f
+struct mgmt_ev_adv_monitor_device_lost {
+	__le16 monitor_handle;
+	struct mgmt_addr_info addr;
+} __packed;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 98533def61a3..e3e4a60b74e1 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1600,6 +1600,16 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
 	BT_DBG("All LE pending actions cleared");
 }
 
+static void hci_monitored_devices_clear(struct hci_dev *hdev)
+{
+	struct monitored_device *dev, *tmp;
+
+	list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
+		list_del(&dev->list);
+		kfree(dev);
+	}
+}
+
 int hci_dev_do_close(struct hci_dev *hdev)
 {
 	bool auto_off;
@@ -1670,6 +1680,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_inquiry_cache_flush(hdev);
 	hci_pend_le_actions_clear(hdev);
 	hci_conn_hash_flush(hdev);
+	hci_monitored_devices_clear(hdev);
 	hci_dev_unlock(hdev);
 
 	smp_unregister(hdev);
@@ -3738,6 +3749,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 	INIT_LIST_HEAD(&hdev->conn_hash.list);
 	INIT_LIST_HEAD(&hdev->adv_instances);
 	INIT_LIST_HEAD(&hdev->blocked_keys);
+	INIT_LIST_HEAD(&hdev->monitored_devices);
 
 	INIT_LIST_HEAD(&hdev->local_codecs);
 	INIT_WORK(&hdev->rx_work, hci_rx_work);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 44683443300c..fe69554b80ce 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -173,6 +173,7 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_ADV_MONITOR_REMOVED,
 	MGMT_EV_CONTROLLER_SUSPEND,
 	MGMT_EV_CONTROLLER_RESUME,
+	MGMT_EV_ADV_MONITOR_DEVICE_LOST,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -4396,6 +4397,19 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 				 &cp->addr, sizeof(cp->addr));
 }
 
+void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
+				  bdaddr_t *addr, u8 addr_type)
+{
+	struct mgmt_ev_adv_monitor_device_lost ev;
+
+	ev.monitor_handle = cpu_to_le16(handle);
+	bacpy(&ev.addr.bdaddr, addr);
+	ev.addr.type = addr_type;
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_LOST, hdev, &ev, sizeof(ev),
+		   NULL);
+}
+
 static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
 				   u16 handle)
 {
@@ -9609,8 +9623,10 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 		       u8 *eir, u16 eir_len, u8 *scan_rsp, u8 scan_rsp_len)
 {
 	char buf[512];
+	struct monitored_device *dev, *tmp_dev;
 	struct mgmt_ev_device_found *ev = (void *)buf;
 	size_t ev_size;
+	bool monitored = false;
 
 	/* Don't send events for a non-kernel initiated discovery. With
 	 * LE one exception is if we have pend_le_reports > 0 in which
@@ -9686,7 +9702,28 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	ev->eir_len = cpu_to_le16(eir_len + scan_rsp_len);
 	ev_size = sizeof(*ev) + eir_len + scan_rsp_len;
 
-	mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
+	if (!list_empty(&hdev->monitored_devices)) {
+		/* An advertisement could match multiple advertisement monitors.
+		 * Send the Device Found event once for all matched monitors.
+		 */
+		list_for_each_entry_safe(dev, tmp_dev, &hdev->monitored_devices,
+					 list) {
+			if (!bacmp(&dev->bdaddr, &ev->addr.bdaddr)) {
+				ev->flags |= MGMT_DEV_FOUND_MONITORING;
+				ev->monitor_handle = cpu_to_le16(dev->handle);
+
+				list_del(&dev->list);
+				kfree(dev);
+
+				mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev,
+					   ev_size, NULL);
+				monitored = true;
+			}
+		}
+	}
+
+	if (!monitored)
+		mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
 }
 
 void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 255cffa554ee..2f88136bf816 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -80,6 +80,14 @@ struct msft_rp_le_set_advertisement_filter_enable {
 	__u8 sub_opcode;
 } __packed;
 
+#define MSFT_EV_LE_MONITOR_DEVICE	0x02
+struct msft_ev_le_monitor_device {
+	__u8     addr_type;
+	bdaddr_t bdaddr;
+	__u8     monitor_handle;
+	__u8     monitor_state;
+} __packed;
+
 struct msft_monitor_advertisement_handle_data {
 	__u8  msft_handle;
 	__u16 mgmt_handle;
@@ -103,6 +111,26 @@ static int __msft_add_monitor_pattern(struct hci_dev *hdev,
 static int __msft_remove_monitor(struct hci_dev *hdev,
 				 struct adv_monitor *monitor, u16 handle);
 
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
 bool msft_monitor_supported(struct hci_dev *hdev)
 {
 	return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR);
@@ -341,6 +369,47 @@ void msft_unregister(struct hci_dev *hdev)
 	kfree(msft);
 }
 
+/* This function requires the caller holds hdev->lock */
+static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct msft_ev_le_monitor_device *ev = (void *)skb->data;
+	struct msft_monitor_advertisement_handle_data *handle_data;
+	struct monitored_device *dev;
+
+	if (skb->len < sizeof(*ev)) {
+		bt_dev_err(hdev,
+			   "MSFT vendor event %u: insufficient data (len: %u)",
+			   MSFT_EV_LE_MONITOR_DEVICE, skb->len);
+		return;
+	}
+	skb_pull(skb, sizeof(*ev));
+
+	bt_dev_dbg(hdev,
+		   "MSFT vendor event %u: handle 0x%04x state %d addr %pMR",
+		   MSFT_EV_LE_MONITOR_DEVICE, ev->monitor_handle,
+		   ev->monitor_state, &ev->bdaddr);
+
+	handle_data = msft_find_handle_data(hdev, ev->monitor_handle, false);
+
+	if (ev->monitor_state) {
+		dev = kmalloc(sizeof(*dev), GFP_KERNEL);
+		if (!dev) {
+			bt_dev_err(hdev, "MSFT vendor event %u: no memory");
+			return;
+		}
+
+		bacpy(&dev->bdaddr, &ev->bdaddr);
+		dev->addr_type = ev->addr_type;
+		dev->handle = handle_data->mgmt_handle;
+
+		INIT_LIST_HEAD(&dev->list);
+		list_add(&dev->list, &hdev->monitored_devices);
+	} else {
+		mgmt_adv_monitor_device_lost(hdev, handle_data->mgmt_handle,
+					     &ev->bdaddr, ev->addr_type);
+	}
+}
+
 void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
@@ -368,37 +437,29 @@ void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	if (skb->len < 1)
 		return;
 
+	hci_dev_lock(hdev);
+
 	event = *skb->data;
 	skb_pull(skb, 1);
 
-	bt_dev_dbg(hdev, "MSFT vendor event %u", event);
-}
+	switch (event) {
+	case MSFT_EV_LE_MONITOR_DEVICE:
+		msft_monitor_device_evt(hdev, skb);
+		break;
 
-__u64 msft_get_features(struct hci_dev *hdev)
-{
-	struct msft_data *msft = hdev->msft_data;
+	default:
+		bt_dev_dbg(hdev, "MSFT vendor event %u", event);
+		break;
+	}
 
-	return msft ? msft->features : 0;
+	hci_dev_unlock(hdev);
 }
 
-/* is_mgmt = true matches the handle exposed to userspace via mgmt.
- * is_mgmt = false matches the handle used by the msft controller.
- * This function requires the caller holds hdev->lock
- */
-static struct msft_monitor_advertisement_handle_data *msft_find_handle_data
-				(struct hci_dev *hdev, u16 handle, bool is_mgmt)
+__u64 msft_get_features(struct hci_dev *hdev)
 {
-	struct msft_monitor_advertisement_handle_data *entry;
 	struct msft_data *msft = hdev->msft_data;
 
-	list_for_each_entry(entry, &msft->handle_map, list) {
-		if (is_mgmt && entry->mgmt_handle == handle)
-			return entry;
-		if (!is_mgmt && entry->msft_handle == handle)
-			return entry;
-	}
-
-	return NULL;
+	return msft ? msft->features : 0;
 }
 
 static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
-- 
2.33.0.882.g93a45727a2-goog

