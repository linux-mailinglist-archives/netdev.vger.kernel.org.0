Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEF12AFE08
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgKLFdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgKLEIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:08:51 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E058C061A4B
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:07:00 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id u3so2985620qvb.19
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=hG49dpXG23551Q1ZScOL6kFRVUg14DXkPPIp9ofvONU=;
        b=nMODosmJXIBwLmjtUD/lpZvg4hzkZGQDfCplkgOs6MRkUOu9PJohF6Y+uENUAayxz3
         ieMA6eYz9qPsrXWzope7bG460GHK+VifCUpnaCxSIIHcyc/jpWwA000gkB2Q0h1gIdaQ
         aEWE7XFzcpJ+yjAV3bOg7iz6gjX+koUXk1vMicvPHv/Pv4Ehfd1H1LzYZP+cd0Q3QQsz
         0o1LrRVe9NvZGLnT92Ld6UVxn/eihVCLHhC5/0tV3+wHDIKcJFRMKfCEL5+cnQaS1qPM
         msUlv9mxeaRR7EiJq/TzF0OKMLvU83ulnBFa3oNP9zgyZaQfD9tN87vRdfpLGLTG4MHe
         mqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hG49dpXG23551Q1ZScOL6kFRVUg14DXkPPIp9ofvONU=;
        b=MAsKY8RXfZGEsUWaVNSA2ST0N6oBBhBQEjaxo/CwZJy6cY5oUBUetDlna/izmeaLrT
         GzUEKuIhP3BoU/PyFfXC0d2Xc3RYrkeiEm+/OIdoj5q8LJYpNYLgT9/rQ8A6ThTmHn4U
         v/wlxSrshMUFCuxVHszXefKA/O7De+q/FGlYChUI4dOJezM/xZpUGD7DlpkygwoOoNTw
         n5/eNGDXKltO4DfLFkw5pDn+fnrWm8Mv90FwbDs7wkEMNZrQbZUwZ2A0jG3P5nqbAPjK
         R5Qnn2VMBo8Mp/zam6KiN0dhSqQSlEQNMMYuBc+WFGCWLrXz56unZYYPijlRNW80rWpU
         DiRg==
X-Gm-Message-State: AOAM531I2krVhCFxIi366tyPpN2edg0srA8dpaDawPrh2ts8libMnA4z
        QVo0bYfni07Hr3A81SRGo6M4UaVzSHARycmv1w==
X-Google-Smtp-Source: ABdhPJywMKHI5tPk56z6t/hOdNvG04DOBRZe2JgVd2cHxZz0UglBYavO81gi8ofNugYmy4PMr/gxUqSs4V9junXb9w==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:ad4:47b0:: with SMTP id
 a16mr27960088qvz.22.1605154019539; Wed, 11 Nov 2020 20:06:59 -0800 (PST)
Date:   Thu, 12 Nov 2020 12:06:39 +0800
In-Reply-To: <20201112120532.v10.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201112120532.v10.4.I9231b35b0be815c32c3a3ec48dcd1d68fa65daf4@changeid>
Mime-Version: 1.0
References: <20201112120532.v10.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v10 4/5] Bluetooth: Refactor read default sys config for
 various types
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

Refactor read default system configuration function so that it's capable
of returning different types than u16

Signed-off-by: Howard Chung <howardchung@google.com>
---

(no changes since v8)

Changes in v8:
- Update the commit title and message

 net/bluetooth/mgmt_config.c | 140 +++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 56 deletions(-)

diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
index 2d3ad288c78ac..282fbf82f3192 100644
--- a/net/bluetooth/mgmt_config.c
+++ b/net/bluetooth/mgmt_config.c
@@ -11,72 +11,100 @@
 #include "mgmt_util.h"
 #include "mgmt_config.h"
 
-#define HDEV_PARAM_U16(_param_code_, _param_name_) \
-{ \
-	{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
-	{ cpu_to_le16(hdev->_param_name_) } \
-}
+#define HDEV_PARAM_U16(_param_name_) \
+	struct {\
+		struct mgmt_tlv entry; \
+		__le16 value; \
+	} __packed _param_name_
 
-#define HDEV_PARAM_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
-{ \
-	{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
-	{ cpu_to_le16(jiffies_to_msecs(hdev->_param_name_)) } \
-}
+#define TLV_SET_U16(_param_code_, _param_name_) \
+	{ \
+		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
+		cpu_to_le16(hdev->_param_name_) \
+	}
+
+#define TLV_SET_U16_JIFFIES_TO_MSECS(_param_code_, _param_name_) \
+	{ \
+		{ cpu_to_le16(_param_code_), sizeof(__u16) }, \
+		cpu_to_le16(jiffies_to_msecs(hdev->_param_name_)) \
+	}
 
 int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
 			   u16 data_len)
 {
-	struct {
-		struct mgmt_tlv entry;
-		union {
-			/* This is a simplification for now since all values
-			 * are 16 bits.  In the future, this code may need
-			 * refactoring to account for variable length values
-			 * and properly calculate the required buffer size.
-			 */
-			__le16 value;
-		};
-	} __packed params[] = {
+	int ret;
+	struct mgmt_rp_read_def_system_config {
 		/* Please see mgmt-api.txt for documentation of these values */
-		HDEV_PARAM_U16(0x0000, def_page_scan_type),
-		HDEV_PARAM_U16(0x0001, def_page_scan_int),
-		HDEV_PARAM_U16(0x0002, def_page_scan_window),
-		HDEV_PARAM_U16(0x0003, def_inq_scan_type),
-		HDEV_PARAM_U16(0x0004, def_inq_scan_int),
-		HDEV_PARAM_U16(0x0005, def_inq_scan_window),
-		HDEV_PARAM_U16(0x0006, def_br_lsto),
-		HDEV_PARAM_U16(0x0007, def_page_timeout),
-		HDEV_PARAM_U16(0x0008, sniff_min_interval),
-		HDEV_PARAM_U16(0x0009, sniff_max_interval),
-		HDEV_PARAM_U16(0x000a, le_adv_min_interval),
-		HDEV_PARAM_U16(0x000b, le_adv_max_interval),
-		HDEV_PARAM_U16(0x000c, def_multi_adv_rotation_duration),
-		HDEV_PARAM_U16(0x000d, le_scan_interval),
-		HDEV_PARAM_U16(0x000e, le_scan_window),
-		HDEV_PARAM_U16(0x000f, le_scan_int_suspend),
-		HDEV_PARAM_U16(0x0010, le_scan_window_suspend),
-		HDEV_PARAM_U16(0x0011, le_scan_int_discovery),
-		HDEV_PARAM_U16(0x0012, le_scan_window_discovery),
-		HDEV_PARAM_U16(0x0013, le_scan_int_adv_monitor),
-		HDEV_PARAM_U16(0x0014, le_scan_window_adv_monitor),
-		HDEV_PARAM_U16(0x0015, le_scan_int_connect),
-		HDEV_PARAM_U16(0x0016, le_scan_window_connect),
-		HDEV_PARAM_U16(0x0017, le_conn_min_interval),
-		HDEV_PARAM_U16(0x0018, le_conn_max_interval),
-		HDEV_PARAM_U16(0x0019, le_conn_latency),
-		HDEV_PARAM_U16(0x001a, le_supv_timeout),
-		HDEV_PARAM_U16_JIFFIES_TO_MSECS(0x001b,
-						def_le_autoconnect_timeout),
-		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
-		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
+		HDEV_PARAM_U16(def_page_scan_type);
+		HDEV_PARAM_U16(def_page_scan_int);
+		HDEV_PARAM_U16(def_page_scan_window);
+		HDEV_PARAM_U16(def_inq_scan_type);
+		HDEV_PARAM_U16(def_inq_scan_int);
+		HDEV_PARAM_U16(def_inq_scan_window);
+		HDEV_PARAM_U16(def_br_lsto);
+		HDEV_PARAM_U16(def_page_timeout);
+		HDEV_PARAM_U16(sniff_min_interval);
+		HDEV_PARAM_U16(sniff_max_interval);
+		HDEV_PARAM_U16(le_adv_min_interval);
+		HDEV_PARAM_U16(le_adv_max_interval);
+		HDEV_PARAM_U16(def_multi_adv_rotation_duration);
+		HDEV_PARAM_U16(le_scan_interval);
+		HDEV_PARAM_U16(le_scan_window);
+		HDEV_PARAM_U16(le_scan_int_suspend);
+		HDEV_PARAM_U16(le_scan_window_suspend);
+		HDEV_PARAM_U16(le_scan_int_discovery);
+		HDEV_PARAM_U16(le_scan_window_discovery);
+		HDEV_PARAM_U16(le_scan_int_adv_monitor);
+		HDEV_PARAM_U16(le_scan_window_adv_monitor);
+		HDEV_PARAM_U16(le_scan_int_connect);
+		HDEV_PARAM_U16(le_scan_window_connect);
+		HDEV_PARAM_U16(le_conn_min_interval);
+		HDEV_PARAM_U16(le_conn_max_interval);
+		HDEV_PARAM_U16(le_conn_latency);
+		HDEV_PARAM_U16(le_supv_timeout);
+		HDEV_PARAM_U16(def_le_autoconnect_timeout);
+		HDEV_PARAM_U16(advmon_allowlist_duration);
+		HDEV_PARAM_U16(advmon_no_filter_duration);
+	} __packed rp = {
+		TLV_SET_U16(0x0000, def_page_scan_type),
+		TLV_SET_U16(0x0001, def_page_scan_int),
+		TLV_SET_U16(0x0002, def_page_scan_window),
+		TLV_SET_U16(0x0003, def_inq_scan_type),
+		TLV_SET_U16(0x0004, def_inq_scan_int),
+		TLV_SET_U16(0x0005, def_inq_scan_window),
+		TLV_SET_U16(0x0006, def_br_lsto),
+		TLV_SET_U16(0x0007, def_page_timeout),
+		TLV_SET_U16(0x0008, sniff_min_interval),
+		TLV_SET_U16(0x0009, sniff_max_interval),
+		TLV_SET_U16(0x000a, le_adv_min_interval),
+		TLV_SET_U16(0x000b, le_adv_max_interval),
+		TLV_SET_U16(0x000c, def_multi_adv_rotation_duration),
+		TLV_SET_U16(0x000d, le_scan_interval),
+		TLV_SET_U16(0x000e, le_scan_window),
+		TLV_SET_U16(0x000f, le_scan_int_suspend),
+		TLV_SET_U16(0x0010, le_scan_window_suspend),
+		TLV_SET_U16(0x0011, le_scan_int_discovery),
+		TLV_SET_U16(0x0012, le_scan_window_discovery),
+		TLV_SET_U16(0x0013, le_scan_int_adv_monitor),
+		TLV_SET_U16(0x0014, le_scan_window_adv_monitor),
+		TLV_SET_U16(0x0015, le_scan_int_connect),
+		TLV_SET_U16(0x0016, le_scan_window_connect),
+		TLV_SET_U16(0x0017, le_conn_min_interval),
+		TLV_SET_U16(0x0018, le_conn_max_interval),
+		TLV_SET_U16(0x0019, le_conn_latency),
+		TLV_SET_U16(0x001a, le_supv_timeout),
+		TLV_SET_U16_JIFFIES_TO_MSECS(0x001b,
+					     def_le_autoconnect_timeout),
+		TLV_SET_U16(0x001d, advmon_allowlist_duration),
+		TLV_SET_U16(0x001e, advmon_no_filter_duration),
 	};
-	struct mgmt_rp_read_def_system_config *rp = (void *)params;
 
 	bt_dev_dbg(hdev, "sock %p", sk);
 
-	return mgmt_cmd_complete(sk, hdev->id,
-				 MGMT_OP_READ_DEF_SYSTEM_CONFIG,
-				 0, rp, sizeof(params));
+	ret = mgmt_cmd_complete(sk, hdev->id,
+				MGMT_OP_READ_DEF_SYSTEM_CONFIG,
+				0, &rp, sizeof(rp));
+	return ret;
 }
 
 #define TO_TLV(x)		((struct mgmt_tlv *)(x))
-- 
2.29.2.222.g5d2a92d10f8-goog

