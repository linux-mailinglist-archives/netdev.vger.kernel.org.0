Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BD92AE951
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKKHDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgKKHC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:02:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11675C0613D4
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:02:57 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x141so1425791ybe.16
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=0BLblQY5wrVo/fV4Esb72ZfcDIufvpzhr8oLTdedeD8=;
        b=qtEy1ym+hJuQ8GZ7r5v/LMDnwiFdZ4FI3VSHHVJwtvexpWksX2rDQYYqOsLsQ/XUv3
         /Pteu55fSW0Hgq1lDhIhVezZGhxcl2m5WaUpt4jQREUGjVEBWmaILzJb8ge6YSn3O8Be
         +LOhz18qwGG9cSnc2k1tzh/MSaLQTDHt1iQMPlaSUxidpOC6XoMM3Zff2dVtAQuXIvNT
         MSRhCkDerGtA9bdw8qAPGeof+F4kq72mYXt5M6OsacnHeG6nk3dfDq+OC7wzJLb+UHl/
         EEIVTJKuR35FcTBKeeipxp+sElXlBTz1Xw/t33g+mbfA69yThqfhTSZpCyWjLRrOV5+3
         uNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0BLblQY5wrVo/fV4Esb72ZfcDIufvpzhr8oLTdedeD8=;
        b=re+8KJixQawabCvkVoCtGSpeXiyAvNReMbnrJyZdCBtT6TUQFi2rLEttpkqT+TZ8QQ
         1YXScKMh3FCSSXU0TfOfE601o72jA5y7IT1Q8+a3lPDwvK7Zy3s33Q/7tEqDHmpQBfUG
         ppORwAEljq28ITrm+ThwVflfHUiIugKwMB/xe3w5K4jL7rrquKssKV4KDP86K6OaD0OG
         uBov2Q3gjy5DRqCrhU2cx1WeilnmqF4RAvLbIEw9H6DczZ1BzJ0QsWNhPuTUEDLl9oVv
         YPWyZr97i39iGA6+YmY2lFfQ1mUer9yrLB+21navAOnNMfb4zM7MWEW4pDZ32brfBUyk
         daFQ==
X-Gm-Message-State: AOAM531yapx/N1m+vF9uQ3w3UxC30Y2iAt2We4KCirQG5dDiher43n9f
        ArLUCd4KG2qTQpbO1Z7z29/C77L1IrzMfVGcEw==
X-Google-Smtp-Source: ABdhPJzdpnwSyw8bJ6trSORlaz0L9j7EKDEBfMG2827Ib3CUiD6YWliIYT6yrLt+TpkS0cGVW3g61cL+TGqEWfT7Zg==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a5b:78d:: with SMTP id
 b13mr28739061ybq.493.1605078176284; Tue, 10 Nov 2020 23:02:56 -0800 (PST)
Date:   Wed, 11 Nov 2020 15:02:24 +0800
In-Reply-To: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
Message-Id: <20201111150115.v9.6.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v9 6/6] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mmandlik@chromium.org, mcchou@chromium.org,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a configurable parameter to switch off the interleave
scan feature.

Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Howard Chung <howardchung@google.com>
---

Changes in v9:
- Update and rename the macro TLV_GET_LE8

Changes in v7:
- Fix bt_dev_warn arguemnt type warning

Changes in v6:
- Set EnableAdvMonInterleaveScan to 1 byte long

Changes in v4:
- Set EnableAdvMonInterleaveScan default to Disable
- Fix 80 chars limit in mgmt_config.c

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/hci_request.c      |  3 ++-
 net/bluetooth/mgmt_config.c      | 41 +++++++++++++++++++++++++-------
 4 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index cfede18709d8f..63c6d656564a1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -363,6 +363,7 @@ struct hci_dev {
 	__u32		clock;
 	__u16		advmon_allowlist_duration;
 	__u16		advmon_no_filter_duration;
+	__u8		enable_advmon_interleave_scan;
 
 	__u16		devid_source;
 	__u16		devid_vendor;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 65b7b74baba4c..b7cb7bfe250bd 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3595,6 +3595,7 @@ struct hci_dev *hci_alloc_dev(void)
 	/* The default values will be chosen in the future */
 	hdev->advmon_allowlist_duration = 300;
 	hdev->advmon_no_filter_duration = 500;
+	hdev->enable_advmon_interleave_scan = 0x00;	/* Default to disable */
 
 	hdev->sniff_max_interval = 800;
 	hdev->sniff_min_interval = 80;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 172ccbf4f0cd2..28520c4d2d229 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1057,7 +1057,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 				      &own_addr_type))
 		return;
 
-	if (__hci_update_interleaved_scan(hdev))
+	if (hdev->enable_advmon_interleave_scan &&
+	    __hci_update_interleaved_scan(hdev))
 		return;
 
 	bt_dev_dbg(hdev, "interleave state %d", hdev->interleave_scan_state);
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index 282fbf82f3192..1deb0ca7a9297 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -17,12 +17,24 @@
 		__le16 value; \
 	} __packed _param_name_
 
+#define HDEV_PARAM_U8(_param_name_) \
+	struct {\
+		struct mgmt_tlv entry; \
+		__u8 value; \
+	} __packed _param_name_
+
 #define TLV_SET_U16(_param_code_, _param_name_) \
 	{ \
 		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
 		cpu_to_le16(hdev->_param_name_) \
 	}
 
+#define TLV_SET_U8(_param_code_, _param_name_) \
+	{ \
+		{ cpu_to_le16(_param_code_), sizeof(__u8) }, \
+		hdev->_param_name_ \
+	}
+
 #define TLV_SET_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
 	{ \
 		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
@@ -65,6 +77,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		HDEV_PARAM_U16(def_le_autoconnect_timeout);
 		HDEV_PARAM_U16(advmon_allowlist_duration);
 		HDEV_PARAM_U16(advmon_no_filter_duration);
+		HDEV_PARAM_U8(enable_advmon_interleave_scan);
 	} __packed rp = {
 		TLV_SET_U16(0x0000, def_page_scan_type),
 		TLV_SET_U16(0x0001, def_page_scan_int),
@@ -97,6 +110,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 					     def_le_autoconnect_timeout),
 		TLV_SET_U16(0x001d, advmon_allowlist_duration),
 		TLV_SET_U16(0x001e, advmon_no_filter_duration),
+		TLV_SET_U8(0x001f, enable_advmon_interleave_scan),
 	};
 
 	bt_dev_dbg(hdev, "sock %p", sk);
@@ -109,6 +123,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 
 #define TO_TLV(x)		((struct mgmt_tlv *)(x))
 #define TLV_GET_LE16(tlv)	le16_to_cpu(*((__le16 *)(TO_TLV(tlv)->value)))
+#define TLV_GET_U8(tlv)		(*((__u8 *)(TO_TLV(tlv)->value)))
 
 int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			  u16 data_len)
@@ -125,6 +140,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 	/* First pass to validate the tlv */
 	while (buffer_left >= sizeof(struct mgmt_tlv)) {
 		const u8 len = TO_TLV(buffer)->length;
+		size_t exp_type_len;
 		const u16 exp_len = sizeof(struct mgmt_tlv) +
 				    len;
 		const u16 type = le16_to_cpu(TO_TLV(buffer)->type);
@@ -170,20 +186,26 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x001b:
 		case 0x001d:
 		case 0x001e:
-			if (len != sizeof(u16)) {
-				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
-					    len, sizeof(u16), type);
-
-				return mgmt_cmd_status(sk, hdev->id,
-					MGMT_OP_SET_DEF_SYSTEM_CONFIG,
-					MGMT_STATUS_INVALID_PARAMS);
-			}
+			exp_type_len = sizeof(u16);
+			break;
+		case 0x001f:
+			exp_type_len = sizeof(u8);
 			break;
 		default:
+			exp_type_len = 0;
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
 		}
 
+		if (exp_type_len && len != exp_type_len) {
+			bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
+				    len, exp_type_len, type);
+
+			return mgmt_cmd_status(sk, hdev->id,
+				MGMT_OP_SET_DEF_SYSTEM_CONFIG,
+				MGMT_STATUS_INVALID_PARAMS);
+		}
+
 		buffer_left -= exp_len;
 		buffer += exp_len;
 	}
@@ -289,6 +311,9 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		case 0x0001e:
 			hdev->advmon_no_filter_duration = TLV_GET_LE16(buffer);
 			break;
+		case 0x0001f:
+			hdev->enable_advmon_interleave_scan = TLV_GET_U8(buffer);
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.29.2.222.g5d2a92d10f8-goog

