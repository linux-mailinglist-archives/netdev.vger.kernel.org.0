Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F8A43A450
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhJYUUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbhJYUUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:20:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29106C110F06
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:53:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nv1-20020a17090b1b4100b001a04861d474so573299pjb.5
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NFWtXOlcg2Ncd4JYvu6Yll9avs/USs5R639VEpIjd3M=;
        b=SsLo4MyeeUh+1+JFbPQwxTMrRvGxzKYNWRpkhPVUUCkP4uqgmiLMOkQFJEvTzorlwu
         YyR5KNgJiGg7wRC04+XUGlm3VeQFJquAZIqpPtVtMr8EMdADIQiLcy1n5TU5gW5bK9B6
         BnG6ZnAJ8VIMjjxXDawpM0lcT6eH7hJlD80OEMPtkkldtzVPhjWBwTIxx2T4NmvJTZX1
         bx39NrEey4CIbecXW7dyJ9uIcZKfJdxFsE5uZwJpq22eadWJsNTTLBwBxqHLTkJgm5ti
         AhIJSC7CLVuDsFOJJ+NOmJSUfL5ppgmmOEb705Xbmt42y5PxAV5oIqFzN1wvwyKeBVJ+
         Z8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NFWtXOlcg2Ncd4JYvu6Yll9avs/USs5R639VEpIjd3M=;
        b=CMQoh/FR1+11dqUymBItCMob6HsHYM4ToyR5ipC/DHh3lxYZvzifMb/ymCt8Nah6fG
         vz8n8KfKmbkuhh4c2UZTrrtuuEtLIQBa6Cjy2dnF8MBwssSOr+7RP9xojPSl2MDnSiHd
         hTklMRKuFD4JTen8YAlTeCggxhEKTwEjfVc68qiLCw8OkvFHtMo+ma8+VhwE3+Tk2Smy
         QD13fNL6qOEOTxiFNAemkVAy6KcLR3/IYK3oSZc5UqNC29UItwZo7bWotnHoEQK0ZYq5
         mIctF6pRgk/sLa0b+0s9HSUOBgiyFEHEJIbgfkLVhuHTcA20VZWaVZbNuoS3pRJLY5vM
         yhpQ==
X-Gm-Message-State: AOAM532LKAummHjqgWJQgiHcvR2lpWVDa1CA6C9zvjAluz5eVsfqHRiH
        r12Ed94awswC25sFEhIVFrRP7sFFvw+Rmw==
X-Google-Smtp-Source: ABdhPJwtK7+OoUYAmO1KwlJYGptYVgaIjkn9gCGWxLXPpdIfrJldeoXxPW8WSry45LxO2Qqd/HCrkTTYPSeclw==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:e7c3:c740:ce43:5358])
 (user=mmandlik job=sendgmr) by 2002:a17:902:e544:b0:13e:e863:6cd2 with SMTP
 id n4-20020a170902e54400b0013ee8636cd2mr18493576plf.41.1635191602544; Mon, 25
 Oct 2021 12:53:22 -0700 (PDT)
Date:   Mon, 25 Oct 2021 12:53:17 -0700
Message-Id: <20211025125123.v4.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v4] bluetooth: Add Adv Monitor Device Found/Lost events
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

Whenever the controller starts/stops monitoring a bt device, it sends
MSFT Monitor Device event. Handle this event and notify the bluetoothd
whenever the controller starts/stops monitoring a particular device.

Test performed:
- verified by logs that the MSFT Monitor Device is received from the
  controller and the bluetoothd is notified whenever the controller
  starts/stops monitoring a device.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
---
Hello Bt-Maintainers,

As mentioned in the bluez patch series [1], we need to capture the 'MSFT
Monitor Device' from the controller and pass it to the bluetoothd.

This is required to further optimize the power consumption by avoiding
handling of RSSI thresholds and timeouts in the user space and let the
controller do the RSSI tracking.

This patch adds support to read HCI_VS_MSFT_LE_Monitor_Device_Event and
introduces new MGMT events MGMT_EV_ADV_MONITOR_DEVICE_FOUND and
MGMT_EV_ADV_MONITOR_DEVICE_LOST to indicate that the controller has
started/stopped tracking a particular device.

Please let me know what you think about this or if you have any further
questions.

[1] https://patchwork.kernel.org/project/bluetooth/list/?series=569881

Thanks,
Manish.

Changes in v4:
- Add Advertisement Monitor Device Found event and update addr type.

Changes in v3:
- Discard changes to the Device Found event and notify bluetoothd only
  when the controller stops monitoring the device via new Device Lost
  event.

Changes in v2:
- Instead of creating a new 'Device Tracking' event, add a flag 'Device
  Tracked' in the existing 'Device Found' event and add a new 'Device
  Lost' event to indicate that the controller has stopped tracking that
  device.

 include/net/bluetooth/hci_core.h |   4 ++
 include/net/bluetooth/mgmt.h     |  12 ++++
 net/bluetooth/mgmt.c             |  28 ++++++++
 net/bluetooth/msft.c             | 109 +++++++++++++++++++++++++------
 4 files changed, 132 insertions(+), 21 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index dd8840e70e25..ed7d2780bdec 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1842,6 +1842,10 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
+void mgmt_adv_monitor_device_found(struct hci_dev *hdev, u16 handle,
+				   bdaddr_t *addr, u8 addr_type);
+void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
+				  bdaddr_t *addr, u8 addr_type);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23a0524061b7..d471aaaa2e4f 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1103,3 +1103,15 @@ struct mgmt_ev_controller_resume {
 #define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
 #define MGMT_WAKE_REASON_UNEXPECTED		0x1
 #define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
+
+#define MGMT_EV_ADV_MONITOR_DEVICE_FOUND	0x002f
+struct mgmt_ev_adv_monitor_device_found {
+	__le16 monitor_handle;
+	struct mgmt_addr_info addr;
+} __packed;
+
+#define MGMT_EV_ADV_MONITOR_DEVICE_LOST		0x0030
+struct mgmt_ev_adv_monitor_device_lost {
+	__le16 monitor_handle;
+	struct mgmt_addr_info addr;
+} __packed;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 44683443300c..087e40761b26 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -173,6 +173,8 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_ADV_MONITOR_REMOVED,
 	MGMT_EV_CONTROLLER_SUSPEND,
 	MGMT_EV_CONTROLLER_RESUME,
+	MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
+	MGMT_EV_ADV_MONITOR_DEVICE_LOST,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -4396,6 +4398,32 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 				 &cp->addr, sizeof(cp->addr));
 }
 
+void mgmt_adv_monitor_device_found(struct hci_dev *hdev, u16 handle,
+				   bdaddr_t *addr, u8 addr_type)
+{
+	struct mgmt_ev_adv_monitor_device_found ev;
+
+	ev.monitor_handle = cpu_to_le16(handle);
+	bacpy(&ev.addr.bdaddr, addr);
+	ev.addr.type = addr_type;
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_FOUND, hdev, &ev, sizeof(ev),
+		   NULL);
+}
+
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
index 255cffa554ee..88520273bd90 100644
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
@@ -341,6 +369,53 @@ void msft_unregister(struct hci_dev *hdev)
 	kfree(msft);
 }
 
+/* This function requires the caller holds hdev->lock */
+static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct msft_ev_le_monitor_device *ev = (void *)skb->data;
+	struct msft_monitor_advertisement_handle_data *handle_data;
+	u8 addr_type;
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
+	switch (ev->addr_type) {
+	case ADDR_LE_DEV_PUBLIC:
+		addr_type = BDADDR_LE_PUBLIC;
+		break;
+
+	case ADDR_LE_DEV_RANDOM:
+		addr_type = BDADDR_LE_RANDOM;
+		break;
+
+	default:
+		bt_dev_err(hdev,
+			   "MSFT vendor event %u: unknown addr type 0x%02x",
+			   ev->addr_type);
+		return;
+	}
+
+	if (ev->monitor_state) {
+		mgmt_adv_monitor_device_found(hdev, handle_data->mgmt_handle,
+					      &ev->bdaddr, addr_type);
+	} else {
+		mgmt_adv_monitor_device_lost(hdev, handle_data->mgmt_handle,
+					     &ev->bdaddr, addr_type);
+	}
+}
+
 void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
@@ -368,37 +443,29 @@ void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
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
2.33.0.1079.g6e70778dc9-goog

