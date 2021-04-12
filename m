Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B1235BAD7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhDLH2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236882AbhDLH2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:28:20 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F66C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:28:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o123so8640069pfb.4
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lcOYm0+hZPIlY5PfuRNEcpFAsAalynGSx2Riv6ARavU=;
        b=Oy//IH6JFOnstM2AWkdrGYIKjwKW5Q1adL7A1GAT8VP5//CRSdqLU0bNp3VPg9gPPQ
         P2q6V1tvmM5J1LYa/dSLQ6vyhgGA40+Jh0MFcIdzZwW+OmDoZ3nysQX6aw5kaINZcQqh
         hzDE96+JG1dBbcX7MNOzXD1lCGJ1zx2dnr5Uk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lcOYm0+hZPIlY5PfuRNEcpFAsAalynGSx2Riv6ARavU=;
        b=rvggVpCbPBm3RW7FIiXx3HAt4nsZ/pC91wibAWfp5iJmgogtigi/CQB/MfV0ETMun9
         hTVA08lyQ2YKk1Kne5dVwxXfvmuiDKoik4hU1EmdVKQPuViViyCguA37XTBiCb1nUcTb
         pvru3f7nCNhc3v7Rig8bsF9AxNtk/5Dp6YWTNBv0XbEiUyop/Hy9LR8Rz/jBId4CqO16
         rm8k29+/PTQJjubkfjI0lyW9vTMDmSQXHVarqB87f/pKYaZ5ukxFR8iK9PAAJ/z3JfCJ
         LBx8lzVL2UrEArsYSr/nzYRre/XjhRb99TTwKeSHldxnzjh2CmIH9nz0tvHM2tmXDEXg
         xoEQ==
X-Gm-Message-State: AOAM5313ZF5cJBu3z7Xp9j0QiyX/FEcfk5Y/FLQJeaSEl5eMv76vuRA+
        +Z40gwvpSC3Zp3GAHoXRiE7vhw==
X-Google-Smtp-Source: ABdhPJz4huqaaj1ocPdObUCO3tntwZGF7LjMI4zahIu50qM8JInssptjhi5Qrdo5Zuf04W68mMuCDQ==
X-Received: by 2002:a63:c02:: with SMTP id b2mr25752502pgl.79.1618212482260;
        Mon, 12 Apr 2021 00:28:02 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:b:99d4:3dd9:e3a7:45cf])
        by smtp.gmail.com with ESMTPSA id s22sm8797161pfe.150.2021.04.12.00.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 00:28:02 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Chethan Tumkur Narayan 
        <chethan.tumkur.narayan@intel.corp-partner.google.com>,
        Kiran Krishnappa <kiran.k@intel.corp-partner.google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 2/2] Bluetooth: Support the vendor specific debug events
Date:   Mon, 12 Apr 2021 15:27:34 +0800
Message-Id: <20210412072734.2567956-2-josephsih@chromium.org>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
In-Reply-To: <20210412072734.2567956-1-josephsih@chromium.org>
References: <20210412072734.2567956-1-josephsih@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows a user space process to enable/disable the vendor
specific (vs) debug events dynamically through the set experimental
feature mgmt interface if CONFIG_BT_FEATURE_VS_DBG_EVT is enabled.

Since the debug event feature needs to invoke the callback function
provided by the driver, i.e., hdev->set_vs_dbg_evt, a valid controller
index is required.

For generic Linux machines, the vendor specific debug events are
disabled by default.

Reviewed-by: Chethan Tumkur Narayan <chethan.tumkur.narayan@intel.corp-partner.google.com>
Reviewed-by: Kiran Krishnappa <kiran.k@intel.corp-partner.google.com>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Joseph Hwang <josephsih@chromium.org>
---

 drivers/bluetooth/btintel.c      |  73 ++++++++++++++++++++-
 drivers/bluetooth/btintel.h      |  13 ++++
 drivers/bluetooth/btusb.c        |   8 +++
 include/net/bluetooth/hci.h      |   4 ++
 include/net/bluetooth/hci_core.h |  10 +++
 net/bluetooth/Kconfig            |  10 +++
 net/bluetooth/mgmt.c             | 107 ++++++++++++++++++++++++++++++-
 7 files changed, 223 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index de1dbdc01e5a..c0f81d29aa5f 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -1213,6 +1213,7 @@ void btintel_reset_to_bootloader(struct hci_dev *hdev)
 }
 EXPORT_SYMBOL_GPL(btintel_reset_to_bootloader);
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
 int btintel_read_debug_features(struct hci_dev *hdev,
 				struct intel_debug_features *features)
 {
@@ -1254,14 +1255,18 @@ int btintel_set_debug_features(struct hci_dev *hdev,
 	u8 trace_enable = 0x02;
 	struct sk_buff *skb;
 
-	if (!features)
+	if (!features) {
+		bt_dev_warn(hdev, "Debug features not read");
 		return -EINVAL;
+	}
 
 	if (!(features->page1[0] & 0x3f)) {
 		bt_dev_info(hdev, "Telemetry exception format not supported");
 		return 0;
 	}
 
+	bt_dev_info(hdev, "trace_enable %d mask %d", trace_enable, mask[3]);
+
 	skb = __hci_cmd_sync(hdev, 0xfc8b, 11, mask, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Setting Intel telemetry ddc write event mask failed (%ld)",
@@ -1290,6 +1295,72 @@ int btintel_set_debug_features(struct hci_dev *hdev,
 }
 EXPORT_SYMBOL_GPL(btintel_set_debug_features);
 
+int btintel_reset_debug_features(struct hci_dev *hdev,
+				 const struct intel_debug_features *features)
+{
+	u8 mask[11] = { 0x0a, 0x92, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00 };
+	u8 trace_enable = 0x00;
+	struct sk_buff *skb;
+
+	if (!features) {
+		bt_dev_warn(hdev, "Debug features not read");
+		return -EINVAL;
+	}
+
+	if (!(features->page1[0] & 0x3f)) {
+		bt_dev_info(hdev, "Telemetry exception format not supported");
+		return 0;
+	}
+
+	bt_dev_info(hdev, "trace_enable %d mask %d", trace_enable, mask[3]);
+
+	/* Should stop the trace before writing ddc event mask. */
+	skb = __hci_cmd_sync(hdev, 0xfca1, 1, &trace_enable, HCI_INIT_TIMEOUT);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Stop tracing of link statistics events failed (%ld)",
+			   PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+	kfree_skb(skb);
+
+	skb = __hci_cmd_sync(hdev, 0xfc8b, 11, mask, HCI_INIT_TIMEOUT);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Setting Intel telemetry ddc write event mask failed (%ld)",
+			   PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+	kfree_skb(skb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(btintel_reset_debug_features);
+
+int btintel_set_vs_dbg_evt(struct hci_dev *hdev, bool enable)
+{
+	struct intel_debug_features features;
+	int err;
+
+	bt_dev_dbg(hdev, "enable %d", enable);
+
+	/* Read the Intel supported features and if new exception formats
+	 * supported, need to load the additional DDC config to enable.
+	 */
+	err = btintel_read_debug_features(hdev, &features);
+	if (err)
+		return err;
+
+	/* Set or reset the debug features. */
+	if (enable)
+		err = btintel_set_debug_features(hdev, &features);
+	else
+		err = btintel_reset_debug_features(hdev, &features);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(btintel_set_vs_dbg_evt);
+#endif
+
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
 MODULE_VERSION(VERSION);
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index d184064a5e7c..0b35b0248b91 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -171,10 +171,15 @@ int btintel_download_firmware_newgen(struct hci_dev *hdev,
 				     u32 *boot_param, u8 hw_variant,
 				     u8 sbe_type);
 void btintel_reset_to_bootloader(struct hci_dev *hdev);
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
 int btintel_read_debug_features(struct hci_dev *hdev,
 				struct intel_debug_features *features);
 int btintel_set_debug_features(struct hci_dev *hdev,
 			       const struct intel_debug_features *features);
+int btintel_reset_debug_features(struct hci_dev *hdev,
+			       const struct intel_debug_features *features);
+int btintel_set_vs_dbg_evt(struct hci_dev *hdev, bool enable);
+#endif
 #else
 
 static inline int btintel_check_bdaddr(struct hci_dev *hdev)
@@ -301,10 +306,18 @@ static inline int btintel_read_debug_features(struct hci_dev *hdev,
 	return -EOPNOTSUPP;
 }
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
 static inline int btintel_set_debug_features(struct hci_dev *hdev,
 					     const struct intel_debug_features *features)
 {
 	return -EOPNOTSUPP;
 }
 
+static inline int btintel_reset_debug_features(struct hci_dev *hdev,
+					       const struct intel_debug_features *features)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 096b743977a7..cc4cc920a713 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2864,6 +2864,11 @@ static int btusb_setup_intel_new(struct hci_dev *hdev)
 		btintel_load_ddc_config(hdev, ddcname);
 	}
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+	hci_dev_clear_flag(hdev, HCI_VS_DBG_EVT);
+	bt_dev_dbg(hdev, "HCI_VS_DBG_EVT cleared");
+#endif
+
 	/* Read the Intel version information after loading the FW  */
 	err = btintel_read_version(hdev, &ver);
 	if (err)
@@ -4596,6 +4601,9 @@ static int btusb_probe(struct usb_interface *intf,
 		hdev->set_diag = btintel_set_diag;
 		hdev->set_bdaddr = btintel_set_bdaddr;
 		hdev->cmd_timeout = btusb_intel_cmd_timeout;
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+		hdev->set_vs_dbg_evt = btintel_set_vs_dbg_evt;
+#endif
 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index ea4ae551c426..0c1eba73844a 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -331,6 +331,10 @@ enum {
 	HCI_CMD_PENDING,
 	HCI_FORCE_NO_MITM,
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+	HCI_VS_DBG_EVT,
+#endif
+
 	__HCI_NUM_FLAGS,
 };
 
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c73ac52af186..d68e06be51c7 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -604,6 +604,9 @@ struct hci_dev {
 	int (*set_bdaddr)(struct hci_dev *hdev, const bdaddr_t *bdaddr);
 	void (*cmd_timeout)(struct hci_dev *hdev);
 	bool (*prevent_wake)(struct hci_dev *hdev);
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+	int (*set_vs_dbg_evt)(struct hci_dev *hdev, bool enable);
+#endif
 };
 
 #define HCI_PHY_HANDLE(handle)	(handle & 0xff)
@@ -751,12 +754,19 @@ extern struct mutex hci_cb_list_lock;
 #define hci_dev_test_and_clear_flag(hdev, nr)  test_and_clear_bit((nr), (hdev)->dev_flags)
 #define hci_dev_test_and_change_flag(hdev, nr) test_and_change_bit((nr), (hdev)->dev_flags)
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+#define hci_dev_clear_flag_vs_dbg_evt(x) { hci_dev_clear_flag(hdev, x); }
+#else
+#define hci_dev_clear_flag_vs_dbg_evt(x) {}
+#endif
+
 #define hci_dev_clear_volatile_flags(hdev)			\
 	do {							\
 		hci_dev_clear_flag(hdev, HCI_LE_SCAN);		\
 		hci_dev_clear_flag(hdev, HCI_LE_ADV);		\
 		hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);\
 		hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);	\
+		hci_dev_clear_flag_vs_dbg_evt(HCI_VS_DBG_EVT)	\
 	} while (0)
 
 /* ----- HCI interface to upper protocols ----- */
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index e0ab4cd7afc3..4930ec495f60 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -148,4 +148,14 @@ config BT_FEATURE_DEBUG
 	  This provides an option to enable/disable debugging statements
 	  at runtime via the experimental features interface.
 
+config BT_FEATURE_VS_DBG_EVT
+	bool "Enable runtime option for logging vendor specific debug events"
+	depends on BT && !DYNAMIC_DEBUG
+	default n
+	help
+	  This provides an option to enable/disable vendor specific debug
+	  events logging at runtime via the experimental features interface.
+	  The debug events may include the categories of system exceptions,
+	  connections/disconnection, the link quality statistics, etc.
+
 source "drivers/bluetooth/Kconfig"
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index f9be7f9084d6..d220917e2b8e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3788,6 +3788,14 @@ static const u8 debug_uuid[16] = {
 };
 #endif
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+/* 330859bc-7506-492d-9370-9a6f0614037f */
+static const u8 vs_dbg_evt_uuid[16] = {
+	0x7f, 0x03, 0x14, 0x06, 0x6f, 0x9a, 0x70, 0x93,
+	0x2d, 0x49, 0x06, 0x75, 0xbc, 0x59, 0x08, 0x33,
+};
+#endif
+
 /* 671b10b5-42c0-4696-9227-eb28d1b049d6 */
 static const u8 simult_central_periph_uuid[16] = {
 	0xd6, 0x49, 0xb0, 0xd1, 0x28, 0xeb, 0x27, 0x92,
@@ -3803,7 +3811,7 @@ static const u8 rpa_resolution_uuid[16] = {
 static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 				  void *data, u16 data_len)
 {
-	char buf[62];	/* Enough space for 3 features */
+	char buf[82];   /* Enough space for 4 features: 2 + 20 * 4 */
 	struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
 	u16 idx = 0;
 	u32 flags;
@@ -3847,6 +3855,15 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 		idx++;
 	}
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+	if (hdev) {
+		flags = hci_dev_test_flag(hdev, HCI_VS_DBG_EVT) ? BIT(0) : 0;
+		memcpy(rp->features[idx].uuid, vs_dbg_evt_uuid, 16);
+		rp->features[idx].flags = cpu_to_le32(flags);
+		idx++;
+	}
+#endif
+
 	rp->feature_count = cpu_to_le16(idx);
 
 	/* After reading the experimental features information, enable
@@ -3889,6 +3906,23 @@ static int exp_debug_feature_changed(bool enabled, struct sock *skip)
 }
 #endif
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+static int exp_vs_dbg_evt_feature_changed(bool enabled, struct sock *skip)
+{
+	struct mgmt_ev_exp_feature_changed ev;
+
+	BT_INFO("enabled %d", enabled);
+
+	memset(&ev, 0, sizeof(ev));
+	memcpy(ev.uuid, vs_dbg_evt_uuid, 16);
+	ev.flags = cpu_to_le32(enabled ? BIT(0) : 0);
+
+	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, NULL,
+				  &ev, sizeof(ev),
+				  HCI_MGMT_EXP_FEATURE_EVENTS, skip);
+}
+#endif
+
 static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			   void *data, u16 data_len)
 {
@@ -4035,6 +4069,77 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 		return err;
 	}
 
+#ifdef CONFIG_BT_FEATURE_VS_DBG_EVT
+	if (!memcmp(cp->uuid, vs_dbg_evt_uuid, 16)) {
+		bool val, changed;
+		int err;
+		u16 mgmt_index = hdev ? hdev->id : MGMT_INDEX_NONE;
+
+		/* Command requires to use a valid controller index */
+		if (!hdev)
+			return mgmt_cmd_status(sk, hdev->id,
+					       MGMT_OP_SET_EXP_FEATURE,
+					       MGMT_STATUS_INVALID_INDEX);
+
+		/* Parameters are limited to a single octet */
+		if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
+			return mgmt_cmd_status(sk, mgmt_index,
+					       MGMT_OP_SET_EXP_FEATURE,
+					       MGMT_STATUS_INVALID_PARAMS);
+
+		/* Only boolean on/off is supported */
+		if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
+			return mgmt_cmd_status(sk, mgmt_index,
+					       MGMT_OP_SET_EXP_FEATURE,
+					       MGMT_STATUS_INVALID_PARAMS);
+
+		hci_req_sync_lock(hdev);
+
+		val = !!cp->param[0];
+		changed = (val != hci_dev_test_flag(hdev, HCI_VS_DBG_EVT));
+
+		if (hdev->set_vs_dbg_evt) {
+			BT_INFO("vendor specific debug event %d changed %d",
+				val, changed);
+			if (changed) {
+				err = hdev->set_vs_dbg_evt(hdev, val);
+				if (err) {
+					BT_ERR("set_vs_dbg_evt value %d err %d",
+					       val, err);
+					err = mgmt_cmd_status(sk, mgmt_index,
+							      MGMT_OP_SET_EXP_FEATURE,
+							      MGMT_STATUS_FAILED);
+					goto unlock_vs_dbg_evt;
+				}
+			}
+
+			if (val)
+				hci_dev_set_flag(hdev, HCI_VS_DBG_EVT);
+			else
+				hci_dev_clear_flag(hdev, HCI_VS_DBG_EVT);
+
+			memcpy(rp.uuid, vs_dbg_evt_uuid, 16);
+			rp.flags = cpu_to_le32(val ? BIT(0) : 0);
+			hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+			err = mgmt_cmd_complete(sk, mgmt_index,
+						MGMT_OP_SET_EXP_FEATURE, 0,
+						&rp, sizeof(rp));
+
+			if (changed)
+				exp_vs_dbg_evt_feature_changed(val, sk);
+		} else {
+			BT_INFO("vendor specific debug event not supported");
+			err = mgmt_cmd_status(sk, mgmt_index,
+					      MGMT_OP_SET_EXP_FEATURE,
+					      MGMT_STATUS_NOT_SUPPORTED);
+		}
+
+unlock_vs_dbg_evt:
+		hci_req_sync_unlock(hdev);
+		return err;
+	}
+#endif
+
 	return mgmt_cmd_status(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
 			       MGMT_OP_SET_EXP_FEATURE,
 			       MGMT_STATUS_NOT_SUPPORTED);
-- 
2.31.1.295.g9ea45b61b8-goog

