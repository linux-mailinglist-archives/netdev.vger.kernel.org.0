Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376C61F7FB2
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 01:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgFLXqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 19:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgFLXqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 19:46:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFDCC03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:46:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a45so4638123pje.1
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGRzpb5lB92OX59ZTLb3ILoKGjAfwI8TyMX6hJG2aFU=;
        b=WK4D0qcBlxRaJ4ICJ4AKgC72AKQhP9eKgCDlnSWkh1Vu7x2SGnx8b+w0dw8bkrhrZc
         E5+A79X5XGoMa3N1nh7BOviCHx+N9YeQ3koFvfjtroCiUOmlVcILexZX2qf3uOfrkRPS
         ANdpvT0x1t/mWNB4s0PaADQpGi/RZqq8zimSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGRzpb5lB92OX59ZTLb3ILoKGjAfwI8TyMX6hJG2aFU=;
        b=LsxrtHadKRZzC1M1jNTPJWVaSIXKsuXS4y1D+zkgxKG5p19CoqAxan8quYlJSp187m
         vu585dwaGoBil/8sV0Pf6kO5HLI4IrCmVgZZJUMenaA1WBkzQcTJZbhSEmyOF7sjI608
         /dl4YrLVEIcL8PHhw+har/S9G6oPWFJEGZ56oo8niVUbKJYuDgY5sQ0HKjaVDowqknVo
         AozsXbk2bKhBtqynwC2ipvEhcMTolz7Po/ParphQA3ocpYJrXw74SQlcmvljhdysmeni
         8mcejZuesqhyitoZ4L9ki2L0TmNmtrzOinxDgZvGEkJmGv7puXQtR81AON+Nf2svmE8n
         k29g==
X-Gm-Message-State: AOAM531K3oLyoOUtd7VZ2X0dNru+jCsV+rg4G3o18HY5U2pEa408znM9
        s+tI1glaaTUMRO2o3LLmhujaxA==
X-Google-Smtp-Source: ABdhPJwA7krUN2We5VsuUZM60FdTbjQhCBCJa8wPWTZs8e/1st6xqlaRG9iTgKTewBXG1ggCmlk0Bw==
X-Received: by 2002:a17:902:ee15:: with SMTP id z21mr13463040plb.233.1592005575019;
        Fri, 12 Jun 2020 16:46:15 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id b19sm6198639pjo.57.2020.06.12.16.46.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jun 2020 16:46:13 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 1/7] Bluetooth: Add definitions for advertisement monitor features
Date:   Fri, 12 Jun 2020 16:45:50 -0700
Message-Id: <20200612164243.v4.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
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

