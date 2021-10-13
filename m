Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1996A42C9DE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 21:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhJMTWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 15:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhJMTWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 15:22:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEB3C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 12:19:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i21-20020a253b15000000b005b9c0fbba45so4262490yba.20
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 12:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=d0rAx93itBTSy1xOFmXFYBiya33QB5vLyzSyQgo9d2c=;
        b=D0+l2u4oHREq5LiRim/bUBO5IIzBDxCa771gjZQxRJ+bWU4NFILtxa9VrWxdPA88Ba
         +COehWk0YG+QXxNevytH5qXsLOwufKKazg2eg3Eq/ze3To5hkil+lfnM0fjyDT/RAKxL
         zmMpS76ZUFqu6cwwikvocolnJEfxIoqHJFcdLBWVSaK+O2vxYluCJaGwPXaimtioKFQR
         /hVfN4+W6BPhBB3TGdndzYaxMsG+NCWNNIbDC5DWiIK8fGif/qiaZUm4JPyKVmaWlOf6
         AzlK1u9qPMuavAvJ+EBpc1L97awfCOlESTQVx65Pa+gWRZC+eLP1dMl3rgNIyNJFo38p
         1vMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=d0rAx93itBTSy1xOFmXFYBiya33QB5vLyzSyQgo9d2c=;
        b=OtT/kkrtL/UeJL7KjoP0yIq7c7lFfVn0XvgwtVNfJMigtvnqRKFEqwUGBqS6Nhss4M
         5bL/V02nytSfDYsEkQHLnmptHXy6mlFzFuAm7CEog/YhKqRfBWg4fbLQhkd6MlsjGnTq
         v7/OHPZF3J9tfXCRJSlideLMMXZ6BF+qT+BxGWgP/k+tjgXtFdQYpXWmzjk+gCrC5lEY
         32N6qy/AzdMJYevUr0uLnaul9BAPOOFGNpBrwhDSjm9fF1rAJW6oMZzBvoQRCQEJiqLq
         apFctVcn2P5sAYkiVzZh6HonSifPcTAngGd0kRlPNZlZ+qVXRicPJFjmkslQA/EBvj8g
         kfXA==
X-Gm-Message-State: AOAM533EFuoqcz3066kbJXW0tcuwIVXtkU4jWYePlvDLXhOAVM7reEck
        HKnCa8AMZ++4pHKwlJtW0zMFnw/YL8AxBw==
X-Google-Smtp-Source: ABdhPJwulKZu414F3l5Atx3YNuWmHlorG2mHqfczLBh6vFzVZjLMPq9K6DvJuf7brTnwZT98+IHBFEwRVS5ylg==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:9910:f10f:1467:c3f])
 (user=mmandlik job=sendgmr) by 2002:a25:df06:: with SMTP id
 w6mr1182115ybg.459.1634152796951; Wed, 13 Oct 2021 12:19:56 -0700 (PDT)
Date:   Wed, 13 Oct 2021 12:19:52 -0700
Message-Id: <20211013121544.v3.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v3] bluetooth: Add Adv Monitor Device Lost event
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever the controller starts/stops monitoring a bt device, it sends
MSFT Monitor Device event. Handle this event and notify the bluetoothd
whenever the controller stops monitoring a particular device.

Test performed:
- verified by logs that the MSFT Monitor Device is received from the
  controller and the bluetoothd is notified when the controller stops
  monitoring the device.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
---
Hello Bt-Maintainers,

As mentioned in the bluez patch series [1], we need to capture the 'MSFT
Monitor Device' from the controller and pass it to the bluetoothd.

This is required to further optimize the power consumption by avoiding
handling of RSSI thresholds and timeouts in the user space and let the
controller do the RSSI tracking.

This patch adds support to read HCI_VS_MSFT_LE_Monitor_Device_Event and
introduces a new MGMT event MGMT_EV_ADV_MONITOR_DEVICE_LOST to indicate
that the controller has stopped tracking that particular device.

Please let me know what you think about this or if you have any further
questions.

[1] https://patchwork.kernel.org/project/bluetooth/list/?series=562967

Thanks,
Manish.

Changes in v3:
- Discard changes to the Device Found event and notify bluetoothd only
  when the controller stops monitoring the device via new Device Lost
  event.

Changes in v2:
- Instead of creating a new 'Device Tracking' event, add a flag 'Device
  Tracked' in the existing 'Device Found' event and add a new 'Device
  Lost' event to indicate that the controller has stopped tracking that
  device.

 include/net/bluetooth/hci_core.h |  2 +
 include/net/bluetooth/mgmt.h     |  6 ++
 net/bluetooth/mgmt.c             | 14 +++++
 net/bluetooth/msft.c             | 94 +++++++++++++++++++++++++-------
 4 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index dd8840e70e25..8a160c0bba21 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1842,6 +1842,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
+void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
+				  bdaddr_t *addr, u8 addr_type);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23a0524061b7..d438b51310d4 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1103,3 +1103,9 @@ struct mgmt_ev_controller_resume {
 #define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
 #define MGMT_WAKE_REASON_UNEXPECTED		0x1
 #define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
+
+#define MGMT_EV_ADV_MONITOR_DEVICE_LOST		0x002f
+struct mgmt_ev_adv_monitor_device_lost {
+	__le16 monitor_handle;
+	struct mgmt_addr_info addr;
+} __packed;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 44683443300c..c3c178e1878e 100644
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
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 255cffa554ee..40f95263ebb6 100644
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
@@ -341,6 +369,38 @@ void msft_unregister(struct hci_dev *hdev)
 	kfree(msft);
 }
 
+/* This function requires the caller holds hdev->lock */
+static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct msft_ev_le_monitor_device *ev = (void *)skb->data;
+	struct msft_monitor_advertisement_handle_data *handle_data;
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
+	if (!ev->monitor_state) {
+		/* Notify the bluetoothd ONLY when the controller stops
+		 * monitoring a particular device. No need to notify when
+		 * the controller starts monitoring a device as the Device
+		 * Found event will be sent anyway.
+		 */
+		mgmt_adv_monitor_device_lost(hdev, handle_data->mgmt_handle,
+					     &ev->bdaddr, ev->addr_type);
+	}
+}
+
 void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
@@ -368,37 +428,29 @@ void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
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

