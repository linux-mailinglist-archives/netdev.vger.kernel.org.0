Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2931FA509
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 02:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgFPAZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 20:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgFPAZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 20:25:11 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D9AC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h95so698040pje.4
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26J9i57XuI3tG/PuFvKTO+VO1i2nL2WVB2t8LtWV05c=;
        b=BSEPUpGU1bfDNggNEUP0Nqj8JTnaO9oNkCnioW9UyA6ww9VVZNq9IKAow/hJO5/x7E
         K0a10xuT2S8dYWvAS+OXJg+2PHzFd//cNbC1MX+hx4O8Gjm4Qnb2PA9mZaQ+M3UePUPU
         qznnlg6z29H6l1ei7e5Kvg21Zcq5Wbt/vWFN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26J9i57XuI3tG/PuFvKTO+VO1i2nL2WVB2t8LtWV05c=;
        b=PB5x0jXINGuF3eP7DFQ0inkr/n5Xc5h57EXEuqnBFu3L2m0DCI1sPZJTNBFe17EKfn
         BJCTH0O8ofldZ4dt5MQFK5gCyO1//Qk+Z8EyBM+afmpnur2rqbGr4whaZxgYci8MLr7A
         61qYj2SgcvIYfp+fKqApkY4npHyzPPkKjxxD70QGJ4sKYPSGLTNx95m5UeQSyWFxT32q
         OzSXj+UYVG/pv88kUU4vMPC3FNFNILzRcdqqdMcX+yQ4NzRhNOtMWsnkheXAnHNqtItn
         z7Avot1erzt2YUwA+EzuTSZelPM9s5pSJbRGfLPV3U14ELkrWe+280a72fAgtjClTxS7
         YKAA==
X-Gm-Message-State: AOAM5301CFDxfMUDWOBlUTCf2+obBXz6rtBzS1umCPveoCzGng4UWnLy
        MO6jgmKYEKuP+dUTl7Vcc07A5w==
X-Google-Smtp-Source: ABdhPJxVB/SPUO4YceUOYDXgO9v7NEYHhRiD2wKqsOs65ag64IEdo4Lgk8Sgle21byjXPyLlrM8QFg==
X-Received: by 2002:a17:902:9301:: with SMTP id bc1mr397515plb.116.1592267110266;
        Mon, 15 Jun 2020 17:25:10 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id x2sm14783781pfr.186.2020.06.15.17.25.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 17:25:09 -0700 (PDT)
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
Subject: [PATCH v5 1/7] Bluetooth: Add definitions for advertisement monitor features
Date:   Mon, 15 Jun 2020 17:24:59 -0700
Message-Id: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for Advertisement Monitor API. Here are the commands
and events added.
- Read Advertisement Monitor Feature command
- Add Advertisement Pattern Monitor command
- Remove Advertisement Monitor command
- Advertisement Monitor Added event
- Advertisement Monitor Removed event

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v5: None
Changes in v4: None
Changes in v3:
- Update command/event opcodes.
- Correct data types.

Changes in v2: None

 include/net/bluetooth/mgmt.h | 49 ++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 16e0d87bd8fae..fcc5d0349f549 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -702,6 +702,45 @@ struct mgmt_rp_set_exp_feature {
 	__le32 flags;
 } __packed;
 
+#define MGMT_ADV_MONITOR_FEATURE_MASK_OR_PATTERNS    BIT(0)
+
+#define MGMT_OP_READ_ADV_MONITOR_FEATURES	0x0051
+#define MGMT_READ_ADV_MONITOR_FEATURES_SIZE	0
+struct mgmt_rp_read_adv_monitor_features {
+	__le32 supported_features;
+	__le32 enabled_features;
+	__le16 max_num_handles;
+	__u8 max_num_patterns;
+	__le16 num_handles;
+	__le16 handles[];
+}  __packed;
+
+struct mgmt_adv_pattern {
+	__u8 ad_type;
+	__u8 offset;
+	__u8 length;
+	__u8 value[31];
+} __packed;
+
+#define MGMT_OP_ADD_ADV_PATTERNS_MONITOR	0x0052
+struct mgmt_cp_add_adv_patterns_monitor {
+	__u8 pattern_count;
+	struct mgmt_adv_pattern patterns[];
+} __packed;
+#define MGMT_ADD_ADV_PATTERNS_MONITOR_SIZE	1
+struct mgmt_rp_add_adv_patterns_monitor {
+	__le16 monitor_handle;
+} __packed;
+
+#define MGMT_OP_REMOVE_ADV_MONITOR		0x0053
+struct mgmt_cp_remove_adv_monitor {
+	__le16 monitor_handle;
+} __packed;
+#define MGMT_REMOVE_ADV_MONITOR_SIZE		2
+struct mgmt_rp_remove_adv_monitor {
+	__le16 monitor_handle;
+} __packed;
+
 #define MGMT_EV_CMD_COMPLETE		0x0001
 struct mgmt_ev_cmd_complete {
 	__le16	opcode;
@@ -933,3 +972,13 @@ struct mgmt_ev_exp_feature_changed {
 	__u8	uuid[16];
 	__le32	flags;
 } __packed;
+
+#define MGMT_EV_ADV_MONITOR_ADDED	0x002b
+struct mgmt_ev_adv_monitor_added {
+	__le16 monitor_handle;
+}  __packed;
+
+#define MGMT_EV_ADV_MONITOR_REMOVED	0x002c
+struct mgmt_ev_adv_monitor_removed {
+	__le16 monitor_handle;
+}  __packed;
-- 
2.26.2

