Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC2927A8EA
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgI1Hlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgI1Hlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:41:39 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B57C0613CE
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:41:39 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h31so81867qtd.14
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zHaU/ix5unThTgMUa96KOpEqcmetXrcMu44aPQNxyfE=;
        b=GTWP8/homJOMh8dXqsuqDXQvFgkWP6SFqRsITlryl1NTpxjAKawmLuatBjyeMAWTpS
         5mOOFFZMRVNEhS5gSyTp2XNyK5Xr9MZDI3TIeN5hLIHhmx2fktLnyXJfowSBq+qz4z2T
         aSicfdTGE94r9//60WbhP42x6L7toNe9mvRnpkA14/yu0dszqBZr3VBNdJTPpls20dqS
         lcG8s5k03S/W3dizfoP6gH+NXOG68aQHYHbzlq9X+EKe15dwnzzhsbSmrgC9ZrX0pNlp
         CC/bzGsuscOyJawYd/C+GycDGCS26NuaMs3AWr7N/4oT2RtHXkwN5TaYFqaY4R4pIEZy
         PZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zHaU/ix5unThTgMUa96KOpEqcmetXrcMu44aPQNxyfE=;
        b=HPEM7LZqQdSX2/Ud+ggaNp2hbhGj9HUai7iIcRG7fJ20hgjVxNKU5qwmRpTIu3Jrox
         fx5vlbDQsETwOr7Sruh0AStxiNiXOpdCjwR1B01xxg2DuhgSE20j7wO6a85WvJNj4XMa
         oMb9RHkUGqYadpzaJynWIdYKZxDy6zw6oRwW6Yc5ctCpYsGOofNuI+zI24xTxG/MVmqY
         KgpLbw9G9Y5Weq+2PrHh+wx9yub+Ufjm1VvoEKJl0eMaUon3qYLDtsVLLKNz+splK30m
         Qj7NJsmNy+Bhm+nDx3Cg3sZUu4HY1ufQTKCfeaGGXUsCWtpCOV/aG95X+nOJuWAZuapc
         JIAQ==
X-Gm-Message-State: AOAM5321wuuzvBwNwQY4G0PU8Vv72LvZ8kILQmicO8LFQ/A49oUPOmSd
        rBXhOmitezBt/BnZBmNPhGl7f9DVTvpJgK5dpQ==
X-Google-Smtp-Source: ABdhPJzoG6cuP1lS8hRdnDWDv7UyzLKsReoiDBRklRomatsPBZ5PsBA1fnaLNM3ZUtFHAxBdmeEXxNxBYk5is5Qz1Q==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:8ecb:: with SMTP id
 y11mr10534693qvb.51.1601278898446; Mon, 28 Sep 2020 00:41:38 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:41:21 +0800
In-Reply-To: <20200928154107.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200928154107.v6.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20200928154107.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v6 4/4] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.orgi,
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

Changes in v6:
- Change the type of enable_advmon_interleave_scan to u8

Changes in v4:
- Set EnableAdvMonInterleaveScan default to Disable
- Fix 80 chars limit in mgmt_config.c

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/hci_request.c      |  3 ++-
 net/bluetooth/mgmt_config.c      | 39 +++++++++++++++++++++++---------
 4 files changed, 32 insertions(+), 12 deletions(-)

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
index 2d3ad288c78ac..f7906c5d7f01a 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -17,6 +17,12 @@
 	{ cpu_to_le16(hdev->_param_name_) } \
 }
 
+#define HDEV_PARAM_U8(_param_code_, _param_name_) \
+{ \
+	{ (_param_code_), sizeof(__u8) }, \
+	{ hdev->_param_name_ } \
+}
+
 #define HDEV_PARAM_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
 { \
 	{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
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
+		u8 exp_data_len;
 
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
 
+		if (len != exp_data_len) {
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
2.28.0.681.g6f77f65b4e-goog

