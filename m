Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2789427CB2B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732673AbgI2MZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbgI2Ldm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:33:42 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212A3C0613D9
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:26:01 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id g10so2711135qto.1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=7yVE0hDJj9pKSNAQ+VSoIDhA2dHCIkPYxHfj7EtvuPc=;
        b=W7CiVMjMHM5DUVf1tvFpAh8T7aM8jX8iIecVJoyqZtyn2ZSQ9jCz980tlMzkD8Mu93
         Dw0yEcprM09SYdipQO+asMq7wE2zofDyw3+Vs0db+X6B2RVuMYLQ5cAAy3WAt6fxR4AO
         kEIKIgV9VlsziNxX1kl2nXgMGz7/MmsTzER0clepM0MV2Ov/4w34URn61U655/ijmmFu
         dwrrK1pKqyxZSJ1nk4vUnxWRlPWeixUH4qa7vTCm7d8NluQ7OeTrIv8UXEvV7Pn9/On2
         ThAXrKYJsTc+VFb6FU+NdANb1dyiYOYI+tUqDg+K7qeFm2Zc1gtlxLvP1bNsieSjuxup
         imMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7yVE0hDJj9pKSNAQ+VSoIDhA2dHCIkPYxHfj7EtvuPc=;
        b=himxEZByCMlwAxR9KWn+Er1bEc6GQXmBiVozU5/bSgeviSnUHS2zvFP5EfMa+N/yIA
         bCUSAgblk8iJJ4UqVObNHx/GGhO3OYA9YRFD4imv3oWVaiCEdCfjEh7cDkLagqofTfEQ
         NTK0uxSYqHf/YGLJ7egrPZ7nzmtVeJ6AW2AmXpFkm4ARBOF25E8HrHpy585kYVa/G79C
         FctKUdG5BEyDyyBIBXz4N3kj678qNrKgsfBkxXLQ5782tvubfED9cgNClMkWhYiqUvUe
         2jWMiXaLlhLsbq7E+nsLBPXxvoQoSHnYGM2ovthF6ZxWQHsV5aO0/EHXA07MNjzZ1A0f
         rhpg==
X-Gm-Message-State: AOAM531n1GGhod+P0jKprCttKOtjradnLCZXixUVARUom10/k8/RUJMy
        GyRDLVmLOdbXBzFmjIiXE8Ko599lRcDnIWhaVw==
X-Google-Smtp-Source: ABdhPJypGMmrA0vpu0XbaNlkImYP9ncaoU6oLvtM1ZgHYrRLX27xgR7ILPDHjRuuk2xG5qYyYE0IIJWtXNg5o38jLw==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:f0d1:: with SMTP id
 d17mr3995373qvl.34.1601378760125; Tue, 29 Sep 2020 04:26:00 -0700 (PDT)
Date:   Tue, 29 Sep 2020 19:25:26 +0800
In-Reply-To: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200929192508.v7.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v7 4/4] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, alainm@chromium.org, mcchou@chromium.org,
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

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

Changes in v7:
- Fix test bot warning

Changes in v6:
- Change the type of enable_advmon_interleave_scan to u8

Changes in v4:
- Set EnableAdvMonInterleaveScan default to Disable
- Fix 80 chars limit in mgmt_config.c

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/hci_request.c      |  3 ++-
 net/bluetooth/mgmt_config.c      | 41 ++++++++++++++++++++++----------
 4 files changed, 33 insertions(+), 13 deletions(-)

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
index 6c8850149265a..c37b2d5395abc 100644
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
index 4048c82d4257f..23381f263678b 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1057,7 +1057,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 				      &own_addr_type))
 		return;
 
-	if (__hci_update_interleaved_scan(hdev))
+	if (hdev->enable_advmon_interleave_scan &&
+	    __hci_update_interleaved_scan(hdev))
 		return;
 
 	/* Adding or removing entries from the white list must
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index 2d3ad288c78ac..a9d580b4aaad1 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -14,7 +14,13 @@
 #define HDEV_PARAM_U16(_param_code_, _param_name_) \
 { \
 	{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
-	{ cpu_to_le16(hdev->_param_name_) } \
+	{ .value_le16 = cpu_to_le16(hdev->_param_name_) } \
+}
+
+#define HDEV_PARAM_U8(_param_code_, _param_name_) \
+{ \
+	{ (_param_code_), sizeof(__u8) }, \
+	{ .value_u8 = hdev->_param_name_ } \
 }
 
 #define HDEV_PARAM_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
@@ -30,11 +36,12 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		struct mgmt_tlv entry;
 		union {
 			/* This is a simplification for now since all values
-			 * are 16 bits.  In the future, this code may need
+			 * are fixed bits.  In the future, this code may need
 			 * refactoring to account for variable length values
 			 * and properly calculate the required buffer size.
 			 */
-			__le16 value;
+			__le16 value_le16;
+			__u8 value_u8;
 		};
 	} __packed params[] = {
 		/* Please see mgmt-api.txt for documentation of these values */
@@ -69,6 +76,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 						def_le_autoconnect_timeout),
 		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
 		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
+		HDEV_PARAM_U8(0x001f, enable_advmon_interleave_scan),
 	};
 	struct mgmt_rp_read_def_system_config *rp = (void *)params;
 
@@ -81,7 +89,7 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 
 #define TO_TLV(x)		((struct mgmt_tlv *)(x))
 #define TLV_GET_LE16(tlv)	le16_to_cpu(*((__le16 *)(TO_TLV(tlv)->value)))
-
+#define TLV_GET_U8(tlv)		(*((__u8 *)(TO_TLV(tlv)->value)))
 int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			  u16 data_len)
 {
@@ -100,6 +108,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 		const u16 exp_len = sizeof(struct mgmt_tlv) +
 				    len;
 		const u16 type = le16_to_cpu(TO_TLV(buffer)->type);
+		size_t exp_data_len = 0;
 
 		if (buffer_left < exp_len) {
 			bt_dev_warn(hdev, "invalid len left %d, exp >= %d",
@@ -142,20 +151,25 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
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
+			exp_data_len = sizeof(u16);
+			break;
+		case 0x001f:
+			exp_data_len = sizeof(u8);
 			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
 		}
 
+		if (exp_data_len && len != exp_data_len) {
+			bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
+				    len, exp_data_len, type);
+
+			return mgmt_cmd_status(sk, hdev->id,
+				MGMT_OP_SET_DEF_SYSTEM_CONFIG,
+				MGMT_STATUS_INVALID_PARAMS);
+		}
+
 		buffer_left -= exp_len;
 		buffer += exp_len;
 	}
@@ -261,6 +275,9 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
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
2.28.0.709.gb0816b6eb0-goog

