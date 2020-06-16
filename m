Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D091FA50C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 02:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgFPAZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 20:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgFPAZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 20:25:13 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E14CC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a45so492097pje.1
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=drfa7h4uAZeehtObvAZSlgQuXNyOQkz3IPYMDRbe9fo=;
        b=NFPdQ9nNFD61n5ngJ4UI4OxaKiSx/V7I2VgfDuIKpLKbN1fY+mZhhbM819Y8Oy7v1R
         26ebITzbxBR8VsoNaA21uXtxPWJrhTcXDMtJ8089llno4YvuSHFy/J2CfAD/1qPwlV24
         QB0arWBd/q4HQZzlWb7fT8lqkVPiXgm5PRFDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=drfa7h4uAZeehtObvAZSlgQuXNyOQkz3IPYMDRbe9fo=;
        b=tNDSEmWf4pAz8GkOYoysV26pmBlEuSatmw1UXkdDreBn7ngySmW18SekVlCNSe9pp/
         L6Uj3BUiu7dDN2pc6M04BhGPJWeQiV8ZPfSu/MyaUMJhFOxeSthB4ON4CtskjQELY/I8
         2fG0+DNyRkD7rE2qPSI2spgiIl13poizmh2FudGPDcC8A0dUZHU0VDVIdgGB5MWxOYJs
         0t4eL61KEDdr1cNLJ7sm2NQ8bYnyXuS8aTHEhvsAVuKqQfGpBID822Pe6l2ToOdq9vbv
         hfMymKr3upk69Fv3fBxIS9LK8paaKWZ17AgStJAv/P90Ci6ArIvN9hjb5SmzXI6nmSoK
         d67g==
X-Gm-Message-State: AOAM533ce0FsL2hqctfAXz/xTfxr4ii60/fr4RHYN0ghRIpyYgsWoL8L
        0Jo7tmzTmgOIbM/Nmwc4fd8xTA==
X-Google-Smtp-Source: ABdhPJxUdQqt4tHzFxHcTbY97OKvBYD76DtFlxnNp+PLFLrQl3Cup1Huw/ciaA7vECug+dfj+cprzw==
X-Received: by 2002:a17:90b:fc8:: with SMTP id gd8mr237249pjb.142.1592267111687;
        Mon, 15 Jun 2020 17:25:11 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id x2sm14783781pfr.186.2020.06.15.17.25.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 17:25:11 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 2/7] Bluetooth: Add handler of MGMT_OP_READ_ADV_MONITOR_FEATURES
Date:   Mon, 15 Jun 2020 17:25:00 -0700
Message-Id: <20200615172440.v5.2.I7f3372c74a6569cd3445b77a67a0b0fcfdd8a333@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the request handler of MGMT_OP_READ_ADV_MONITOR_FEATURES
command. Since the controller-based monitoring is not yet in place, this
report only the supported features but not the enabled features.

The following test was performed.
- Issuing btmgmt advmon-features.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v5: None
Changes in v4: None
Changes in v3:
- Update the opcode in the mgmt table.

Changes in v2:
- Convert the values from little-endian to CPU order.
- Fix comment style and improve readability.

 include/net/bluetooth/hci_core.h | 24 ++++++++++++++
 net/bluetooth/hci_core.c         | 10 +++++-
 net/bluetooth/mgmt.c             | 54 ++++++++++++++++++++++++++++++++
 net/bluetooth/msft.c             |  7 +++++
 net/bluetooth/msft.h             |  9 ++++++
 5 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index cdd4f1db8670e..431fe0265dcfb 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -25,6 +25,7 @@
 #ifndef __HCI_CORE_H
 #define __HCI_CORE_H
 
+#include <linux/idr.h>
 #include <linux/leds.h>
 #include <linux/rculist.h>
 
@@ -220,6 +221,24 @@ struct adv_info {
 #define HCI_MAX_ADV_INSTANCES		5
 #define HCI_DEFAULT_ADV_DURATION	2
 
+struct adv_pattern {
+	struct list_head list;
+	__u8 ad_type;
+	__u8 offset;
+	__u8 length;
+	__u8 value[HCI_MAX_AD_LENGTH];
+};
+
+struct adv_monitor {
+	struct list_head patterns;
+	bool		active;
+	__u16		handle;
+};
+
+#define HCI_MIN_ADV_MONITOR_HANDLE		1
+#define HCI_MAX_ADV_MONITOR_NUM_HANDLES	32
+#define HCI_MAX_ADV_MONITOR_NUM_PATTERNS	16
+
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
 /* Min encryption key size to match with SMP */
@@ -477,6 +496,9 @@ struct hci_dev {
 	__u16			adv_instance_timeout;
 	struct delayed_work	adv_instance_expire;
 
+	struct idr		adv_monitors_idr;
+	unsigned int		adv_monitors_cnt;
+
 	__u8			irk[16];
 	__u32			rpa_timeout;
 	struct delayed_work	rpa_expired;
@@ -1217,6 +1239,8 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 int hci_remove_adv_instance(struct hci_dev *hdev, u8 instance);
 void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
 
+void hci_adv_monitors_clear(struct hci_dev *hdev);
+
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb);
 
 void hci_init_sysfs(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 83ce665d3cbfb..bfcf00e4dfa92 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -26,7 +26,6 @@
 /* Bluetooth HCI core. */
 
 #include <linux/export.h>
-#include <linux/idr.h>
 #include <linux/rfkill.h>
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
@@ -2996,6 +2995,12 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 	return 0;
 }
 
+/* This function requires the caller holds hdev->lock */
+void hci_adv_monitors_clear(struct hci_dev *hdev)
+{
+	idr_destroy(&hdev->adv_monitors_idr);
+}
+
 struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *bdaddr_list,
 					 bdaddr_t *bdaddr, u8 type)
 {
@@ -3577,6 +3582,8 @@ int hci_register_dev(struct hci_dev *hdev)
 
 	queue_work(hdev->req_workqueue, &hdev->power_on);
 
+	idr_init(&hdev->adv_monitors_idr);
+
 	return id;
 
 err_wqueue:
@@ -3647,6 +3654,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	hci_smp_irks_clear(hdev);
 	hci_remote_oob_data_clear(hdev);
 	hci_adv_instances_clear(hdev);
+	hci_adv_monitors_clear(hdev);
 	hci_bdaddr_list_clear(&hdev->le_white_list);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
 	hci_conn_params_clear_all(hdev);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 9e8a3cccc6ca3..63536d6332d45 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -36,6 +36,7 @@
 #include "hci_request.h"
 #include "smp.h"
 #include "mgmt_util.h"
+#include "msft.h"
 
 #define MGMT_VERSION	1
 #define MGMT_REVISION	17
@@ -111,6 +112,7 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_READ_SECURITY_INFO,
 	MGMT_OP_READ_EXP_FEATURES_INFO,
 	MGMT_OP_SET_EXP_FEATURE,
+	MGMT_OP_READ_ADV_MONITOR_FEATURES,
 };
 
 static const u16 mgmt_events[] = {
@@ -3849,6 +3851,51 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			       MGMT_STATUS_NOT_SUPPORTED);
 }
 
+static int read_adv_monitor_features(struct sock *sk, struct hci_dev *hdev,
+				     void *data, u16 len)
+{
+	struct adv_monitor *monitor = NULL;
+	struct mgmt_rp_read_adv_monitor_features *rp = NULL;
+	int handle;
+	size_t rp_size = 0;
+	__u32 supported = 0;
+	__u16 num_handles = 0;
+	__u16 handles[HCI_MAX_ADV_MONITOR_NUM_HANDLES];
+
+	BT_DBG("request for %s", hdev->name);
+
+	hci_dev_lock(hdev);
+
+	if (msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR)
+		supported |= MGMT_ADV_MONITOR_FEATURE_MASK_OR_PATTERNS;
+
+	idr_for_each_entry(&hdev->adv_monitors_idr, monitor, handle) {
+		handles[num_handles++] = monitor->handle;
+	}
+
+	hci_dev_unlock(hdev);
+
+	rp_size = sizeof(*rp) + (num_handles * sizeof(u16));
+	rp = kmalloc(rp_size, GFP_KERNEL);
+	if (!rp)
+		return -ENOMEM;
+
+	/* Once controller-based monitoring is in place, the enabled_features
+	 * should reflect the use.
+	 */
+	rp->supported_features = cpu_to_le32(supported);
+	rp->enabled_features = 0;
+	rp->max_num_handles = cpu_to_le16(HCI_MAX_ADV_MONITOR_NUM_HANDLES);
+	rp->max_num_patterns = HCI_MAX_ADV_MONITOR_NUM_PATTERNS;
+	rp->num_handles = cpu_to_le16(num_handles);
+	if (num_handles)
+		memcpy(&rp->handles, &handles, (num_handles * sizeof(u16)));
+
+	return mgmt_cmd_complete(sk, hdev->id,
+				 MGMT_OP_READ_ADV_MONITOR_FEATURES,
+				 MGMT_STATUS_SUCCESS, rp, rp_size);
+}
+
 static void read_local_oob_data_complete(struct hci_dev *hdev, u8 status,
 				         u16 opcode, struct sk_buff *skb)
 {
@@ -7297,6 +7344,13 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ set_exp_feature,         MGMT_SET_EXP_FEATURE_SIZE,
 						HCI_MGMT_VAR_LEN |
 						HCI_MGMT_HDEV_OPTIONAL },
+	{ NULL }, // 0x004B
+	{ NULL }, // 0x004C
+	{ NULL }, // 0x004D
+	{ NULL }, // 0x004E
+	{ NULL }, // 0x004F
+	{ NULL }, // 0x0050
+	{ read_adv_monitor_features, MGMT_READ_ADV_MONITOR_FEATURES_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index d6c4e6b5ae777..8579bfeb28364 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -139,3 +139,10 @@ void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	bt_dev_dbg(hdev, "MSFT vendor event %u", event);
 }
+
+__u64 msft_get_features(struct hci_dev *hdev)
+{
+	struct msft_data *msft = hdev->msft_data;
+
+	return  msft ? msft->features : 0;
+}
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index 5aa9130e1f8ab..e9c478e890b8b 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -3,16 +3,25 @@
  * Copyright (C) 2020 Google Corporation
  */
 
+#define MSFT_FEATURE_MASK_BREDR_RSSI_MONITOR		BIT(0)
+#define MSFT_FEATURE_MASK_LE_CONN_RSSI_MONITOR		BIT(1)
+#define MSFT_FEATURE_MASK_LE_ADV_RSSI_MONITOR		BIT(2)
+#define MSFT_FEATURE_MASK_LE_ADV_MONITOR		BIT(3)
+#define MSFT_FEATURE_MASK_CURVE_VALIDITY		BIT(4)
+#define MSFT_FEATURE_MASK_CONCURRENT_ADV_MONITOR	BIT(5)
+
 #if IS_ENABLED(CONFIG_BT_MSFTEXT)
 
 void msft_do_open(struct hci_dev *hdev);
 void msft_do_close(struct hci_dev *hdev);
 void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
+__u64 msft_get_features(struct hci_dev *hdev);
 
 #else
 
 static inline void msft_do_open(struct hci_dev *hdev) {}
 static inline void msft_do_close(struct hci_dev *hdev) {}
 static inline void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb) {}
+static inline __u64 msft_get_features(struct hci_dev *hdev) { return 0; }
 
 #endif
-- 
2.26.2

