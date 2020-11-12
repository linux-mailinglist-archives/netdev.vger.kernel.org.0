Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF5D2AFF21
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgKLFdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbgKLEIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:08:53 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E146FC061A4D
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:07:03 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id v8so2571507ply.0
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ug0jJlb8P0YSNzd4ECXIheLwlAEh7cIHXtwSmBO57G0=;
        b=CW0qJNPF4MgQYJN4ZF4hdsBKuM5p/nYYn2/zeolITDFQQhidNj5J8JULF2pFNA0ejv
         vbSczxbiHYpVCf0btvm8jxHI0Zi+meu3OMAPEepoBJR2HfKwhQtRnr/3L9qUVrmPzLF1
         rSqOqueMblvRL/EzkvpTorH9nA89DxDhNYTfQqc4b9Q8yoxOo27uSFuZLSNNfaAuXTVX
         Tmkt/LI2LSXxLyMkjVywaddh4funPR7vNAa4qWFdiE11u03rncXr8z5SGtz7F70LY9Cm
         cXuLGDAauo1YJ9OrF7VPZgLatS3XIsURfwR0CvT8Gfq7omfCZug1yqdTcpX29q3utiCt
         CsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ug0jJlb8P0YSNzd4ECXIheLwlAEh7cIHXtwSmBO57G0=;
        b=kZQ2xHn87vRI5jO70ar2PDyXBUNa1zHpqCF19vIKWtznD/XtDrpXAyZ0xZJ15YEV14
         eWFgvpOvPc4OWNYKyI3J87EYLn8Xtkw4btfhKnEQhoNvHltwvxFWuwuurvmSVvmlS6gX
         th5cM7guEEP/q1jXqu8EaBAXx3j9Dq76/0hQFsCvnS6Co3/SitLYOkVbkD9lcaJzD+vs
         ZJ4li0eiNnDUZAvjD3OQ3G6L9LUM3o/B+K7zjnc8uNjHwkdzvRiU0lzmx9HQmcu4u98d
         P1egbUbPW3IJpAoqkb7Jj5rCtG6Qc06NgoMtrBKD7jA4TZxmlcbK6UaVlJCWuM0gZSxB
         qtWA==
X-Gm-Message-State: AOAM533DjPGnedwVBhswg+UXPAobA2aAYooKP/S77jst/UVFO2c6pZJD
        /XRV9eSIOtOW77eBX7waUvY+b0IAVdngnZX91A==
X-Google-Smtp-Source: ABdhPJxk5uQSsOu+/MTIk+c+SeQcCGMcS+RuHrmJ5XNLDg8wV+JsOafcWctsRRrMZntEeJKA4r9zoZjKomrNvXh5KA==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:902:74c7:b029:d7:e593:fcb with
 SMTP id f7-20020a17090274c7b02900d7e5930fcbmr15637736plt.71.1605154023415;
 Wed, 11 Nov 2020 20:07:03 -0800 (PST)
Date:   Thu, 12 Nov 2020 12:06:40 +0800
In-Reply-To: <20201112120532.v10.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201112120532.v10.5.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20201112120532.v10.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v10 5/5] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, mcchou@chromium.org, alainm@chromium.org,
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

(no changes since v9)

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
index 28ca419dcda6f..5b3f3f92a2e43 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3594,6 +3594,7 @@ struct hci_dev *hci_alloc_dev(void)
 
 	hdev->advmon_allowlist_duration = 300;
 	hdev->advmon_no_filter_duration = 500;
+	hdev->enable_advmon_interleave_scan = 0x00;	/* Default to disable */
 
 	hdev->sniff_max_interval = 800;
 	hdev->sniff_min_interval = 80;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 2368b050c17f1..e669988a3785c 100644
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

