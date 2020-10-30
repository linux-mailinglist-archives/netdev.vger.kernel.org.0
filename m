Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9D82A00C9
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgJ3JI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgJ3JIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:08:53 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE92C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:08:53 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h31so3536192qtd.14
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=tpwmZTOgD1UxbTtqAIOlVRLPdGrBx+FStQbhD//PCyI=;
        b=ZaJl6Sh3c9WUJNUq4c1HFicMsykQIKfVCCYE/ze7B9y4tZQ4M3tjc3sxVkVqEX5tMD
         gKM1nFJOoqsCE5I/7mMw+kyKV/iedwViDWneSg53ohKLKlNgd4u2RGG+AMOr81R/yHzm
         vY58OTQEbHQQ+OfIaECzSzqn0qQKQB/lyj4f20zUdyEwNYxrmkmYgMv3AErQ4CAkz9N0
         LMx7IWIbCl+VMKWHcfr1EX/ICEF15mpmsRHiPqJc80o0a/wbfBXEU8JZXzAGMEwYNF00
         yeeuRmbviDhxaLmmiiK58NzOXqKjXC79Mdl44b9IV3Kpvv6hTiXXmMEqPphSonClhhqk
         O6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tpwmZTOgD1UxbTtqAIOlVRLPdGrBx+FStQbhD//PCyI=;
        b=FGG94Oa9/wpn7S9hbXMZzaDNFuPmY2ACgGIg1lRJulQYop2j4tIKBfYdgptdp1whKH
         wcbE6j5GpdW54s8tPJD/17sz63xsEXa6BraWyYmGiySD5p5Wpu1XsVWOjD3SZZU5TXYK
         /xa0tDrFwJSpOpjLNHXibS3nU37BxR0pxMR5D2xqK/cUczoY7uWA7O7UhJ3ygVidiIN3
         5k30w4oWS666/yU32Cr6ciXPTD+uTvC1vmBrxRGxEp9oQGSO2KxDBwIwSYvJrod4nTHz
         Zlg+CVTinUZF+/nItYbu28WDCw1LCAt0OtkjTmeek9qnDRR9faCbWfUxw9qQxFeow+6Q
         w1Zw==
X-Gm-Message-State: AOAM531Ihm3yH3uCu7Ru4Hzze9b1uV+wfKbgb5dnpvrCbDUb1kMWbC+5
        mGuslBDmQTvRDfSIk79dRkWuLf3t+5tfJ/8iKA==
X-Google-Smtp-Source: ABdhPJzQmX/gxSggSuENX9zisnwJV+xhz+FkSwA9Mbzul56vVVefdATZ0EnoWxhCklAA3weNTGVNizdFVbF8lJvTvg==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a05:6214:1507:: with SMTP id
 e7mr8335965qvy.18.1604048932475; Fri, 30 Oct 2020 02:08:52 -0700 (PDT)
Date:   Fri, 30 Oct 2020 17:08:27 +0800
In-Reply-To: <20201030163529.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201030163529.v6.5.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Mime-Version: 1.0
References: <20201030163529.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH v6 5/5] Bluetooth: Add toggle to switch off interleave scan
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mmandlik@chromium.orgi, mcchou@chromium.org,
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
index 396960ef54a13..85948c73c72b3 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1059,7 +1059,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 				      &own_addr_type))
 		return;
 
-	if (__hci_update_interleaved_scan(hdev))
+	if (hdev->enable_advmon_interleave_scan &&
+	    __hci_update_interleaved_scan(hdev))
 		return;
 
 	bt_dev_dbg(hdev, "interleave state %d", hdev->interleave_scan_state);
diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index b735e59c7fd51..a6a6f0338be2e 100644
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
+		  hdev->_param_name_ \
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
+#define TLV_GET_LE8(tlv)	le16_to_cpu(*((__u8 *)(TO_TLV(tlv)->value)))
 
 int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			  u16 data_len)
@@ -125,6 +140,7 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 	/* First pass to validate the tlv */
 	while (buffer_left >= sizeof(struct mgmt_tlv)) {
 		const u8 len = TO_TLV(buffer)->length;
+		u8 exp_type_len;
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
+			hdev->enable_advmon_interleave_scan = TLV_GET_LE8(buffer);
+			break;
 		default:
 			bt_dev_warn(hdev, "unsupported parameter %u", type);
 			break;
-- 
2.29.1.341.ge80a0c044ae-goog

