Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8446041A076
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhI0UrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236828AbhI0UrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:47:11 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2530C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:45:32 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 61-20020aed2143000000b002a6a0f52ce7so77810989qtc.0
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4H750WdlE+myrUpYgnk2R4AjBcEk4k1kPvzzhGr+CC4=;
        b=SQkvFEQRk7cdMn0lZ1uQpPts8fU7lY6KV821JmoUCf9QwLpf4NDx9B3Su+xvN3LAwD
         BmRorJzbqjM9CnWo03RJQSibXGZC7nEKNgCAeobNRmwE8TCj9my9UDtCg1Q/hVGcQks0
         Ch1CI9w3BNNuCTx5NC7yARkAySZO+WbVXARINPiLFGb0EuTvgFXVoPdu/oL28PUalLGf
         JW5L4F7eono7wTz2aMj+yxIqrG7W8mf2YlsCRXr7Aq6k6SbOwwrCJtlt1ye0lo00I4ZX
         zllzTORnhBZ6BjyerCTspiyJnOOXAfawMHJVepg7e1ZgpyLoHJ0HzBdKvtDjKojtKjFV
         Zo5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4H750WdlE+myrUpYgnk2R4AjBcEk4k1kPvzzhGr+CC4=;
        b=Llb02/BN27ZgkCFR20yH0whaKiZD9zfEo61h0ZQ2GM/A6XienMgU4RfEtNV9dAc3Ki
         UwyKKJtjoSTzfbkID0BA8oQ8jnaFiIkBuE7iwC0RNuy0Znv0pw+pKr/Umkj9DBsYdfsP
         dZaNZMaovK3YdtzHOyHGrReFoESFbM1j8FW6Rfe+5yC1/OPvEHbyMVmtvoaUqDRBq5Se
         aUlriYpPhaRKdOxJv9WKazWxSJ/e/2ZjiM5G6ic0mPCsEvtwCyh9E8glEucXqGf1bvrb
         qyDLkQrKVykt3CoRtllPOC/WF7Uq1yMvEoKCtJS7Bv+YzClBRybxfkVr0DVLFTlbcRuP
         WbOg==
X-Gm-Message-State: AOAM531ygbOTZINSSdFjeSwdsBoHoigSs6MBcfT3K6vFXEb9Nssg0AAl
        qIg2i8gQU7GJdorQgd63pdNUbW8CZnToqw==
X-Google-Smtp-Source: ABdhPJyMB1V/owBAqWfyZ4shYTz/1p1APTesxWHe1FPDMv0GMSRuhgjJ559xbyv5hJgZVwdFf+fh6n04+fBVZw==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:8f29:89eb:dfbc:3b00])
 (user=mmandlik job=sendgmr) by 2002:a0c:f20b:: with SMTP id
 h11mr1929166qvk.66.1632775531875; Mon, 27 Sep 2021 13:45:31 -0700 (PDT)
Date:   Mon, 27 Sep 2021 13:45:25 -0700
Message-Id: <20210927134453.v1.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v1] bluetooth: Add support to handle MSFT Monitor Device event
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Manish Mandlik <mmandlik@google.com>,
        Archie Pusaka <mcchou@google.com>,
        Miao-chen Chou <apusaka@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MSFT Monitor Device event indicates that the controller has either
started or stopped monitoring a Bluetooth device. This event is used by
the bluetoothd to notify clients with DeviceFound/DeviceLost.

Test performed:
- verified by logs that the Monitor Device event is received from the
  controller and sent to the bluetoothd when the controller starts/stops
  monitoring a bluetooth device.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Archie Pusaka <mcchou@google.com>
Reviewed-by: Miao-chen Chou <apusaka@google.com>
---
Hello Bt-Maintainers,

As mentioned in the bluez patch series [1] that introduces a new MGMT
event MGMT_EV_ADV_MONITOR_TRACKING, we need to capture the Monitor
Device event from the controller and pass it to the bluetoothd.

This is required to further optimize the power consumption by avoiding
handling of RSSI thresholds and timeouts in the user space and let the
controller do the RSSI tracking.

This patch adds support to read HCI_VS_MSFT_LE_Monitor_Device_Event,
introduces a new MGMT interface MGMT_EV_ADV_MONITOR_TRACKING and sends
information received in MSFT event to the bluetoothd via new MGMT event.

Please let me know what you think about this or if you have any further
questions.

[1]
https://patchwork.kernel.org/project/bluetooth/patch/20210927131456.BlueZ.v1.1.I7f6bdb9282c1e12ffc6c662674678f2b1cb69182@changeid/

Thanks,
Manish.

 include/net/bluetooth/hci_core.h |  2 +
 include/net/bluetooth/mgmt.h     |  7 +++
 net/bluetooth/mgmt.c             | 14 +++++
 net/bluetooth/msft.c             | 88 ++++++++++++++++++++++++--------
 4 files changed, 90 insertions(+), 21 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index d46e342328b1..f8ca0dd62934 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1896,6 +1896,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
+void mgmt_adv_monitor_tracking(struct hci_dev *hdev, u16 handle, u8 state,
+			       bdaddr_t *addr, u8 addr_type);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 7ffc5d9d3e56..2724fdb3de9e 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1104,3 +1104,10 @@ struct mgmt_ev_controller_resume {
 #define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
 #define MGMT_WAKE_REASON_UNEXPECTED		0x1
 #define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
+
+#define MGMT_EV_ADV_MONITOR_TRACKING	0x002f
+struct mgmt_ev_adv_monitor_tracking {
+	__le16 monitor_handle;
+	__u8   monitor_state;
+	struct mgmt_addr_info addr;
+} __packed;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index c88f1a72296f..78f1f948dc03 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -199,6 +199,7 @@ static const u16 mgmt_untrusted_events[] = {
 	MGMT_EV_EXP_FEATURE_CHANGED,
 	MGMT_EV_ADV_MONITOR_ADDED,
 	MGMT_EV_ADV_MONITOR_REMOVED,
+	MGMT_EV_ADV_MONITOR_TRACKING,
 };
 
 #define CACHE_TIMEOUT	msecs_to_jiffies(2 * 1000)
@@ -4339,6 +4340,19 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle)
 	mgmt_event(MGMT_EV_ADV_MONITOR_REMOVED, hdev, &ev, sizeof(ev), sk_skip);
 }
 
+void mgmt_adv_monitor_tracking(struct hci_dev *hdev, u16 handle, u8 state,
+			       bdaddr_t *addr, u8 addr_type)
+{
+	struct mgmt_ev_adv_monitor_tracking ev;
+
+	ev.monitor_handle = cpu_to_le16(handle);
+	ev.monitor_state = state;
+	bacpy(&ev.addr.bdaddr, addr);
+	ev.addr.type = addr_type;
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_TRACKING, hdev, &ev, sizeof(ev), NULL);
+}
+
 static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
 				 void *data, u16 len)
 {
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 2b10abb73b40..2dc4324fe1d9 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -79,6 +79,14 @@ struct msft_rp_le_set_advertisement_filter_enable {
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
@@ -104,6 +112,26 @@ bool msft_monitor_supported(struct hci_dev *hdev)
 	return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR);
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
 static bool read_supported_features(struct hci_dev *hdev,
 				    struct msft_data *msft)
 {
@@ -254,6 +282,32 @@ void msft_power_off(struct hci_dev *hdev)
 	}
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
+	mgmt_adv_monitor_tracking(hdev, handle_data->mgmt_handle,
+				  ev->monitor_state, &ev->bdaddr,
+				  ev->addr_type);
+}
+
 void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
@@ -281,37 +335,29 @@ void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
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
2.33.0.685.g46640cef36-goog

