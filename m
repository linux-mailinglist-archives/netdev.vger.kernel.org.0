Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFB71E70E0
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437827AbgE1XzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437677AbgE1XzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:55:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7FDC08C5C9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:07 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y198so263244pfb.4
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7SGnHQEJZH8F0krQCl34Ydvm5S42dlpxkmjv3VJYu0=;
        b=eZumT5u8Wa2rtx0tfJi7hNCNpvi5FowWlYQPg0HGhtWAz2exsdLuiOm9vm80khaBOZ
         sEerEOEVmI0X1JZBo5ez4n+g2U3SHxddLQSXjkFGGWId8po8DcqSbdABFlsPp2KqMeTt
         fy7p33+jZTYUOaIG0lXROVj5SfR/tCZnOlUGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7SGnHQEJZH8F0krQCl34Ydvm5S42dlpxkmjv3VJYu0=;
        b=j9O6li+hNNvee9YAM+98vaT8wOKfoUSOevyMcwfT46IkJLf3l+Jz9kdPF7L7GE5THS
         5MiBZpkKWItoHC3sJ2FWwLCmBCRfeTYTGO5I9JztnXxgckYotvrqib/FNiPyJVCRMBNi
         K3eEzMw/Mungn+nu4QfY+Kj/aUiyX8IrLbyCNS/xHkDAG9eYvH4eUyuOCp9D0AyJWZ6K
         h1FQJLDn+dpMsIkjyLQtObstNECxVEKKXjrbMtunDj8/Ehv0S2CgjJXMEnnadBLnqHVy
         GVOBQtNJBUgbo217aY7F+S0xVEGyxbaFtTLpHe7jCKkGzEIQrr6dYkYp6Xj0AdNMVpH8
         dG8Q==
X-Gm-Message-State: AOAM530Ug6veIOmOVQn/mb/9IhrcpvJnpqmpCV1QPG38dNR0K5N5HqBq
        BFa+ohkP+8GOSfdzsGRJK3z2cQ==
X-Google-Smtp-Source: ABdhPJwwodXakmojQKptX1+Fol9ux6f2AaOWGzBj7pIY7pNb4HrA3CwJVMigps57BlYgCLq/Gmt2LA==
X-Received: by 2002:a62:7dcb:: with SMTP id y194mr5544651pfc.65.1590710106747;
        Thu, 28 May 2020 16:55:06 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id f18sm5022591pga.75.2020.05.28.16.55.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 16:55:05 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 1/7] Bluetooth: Add definitions for advertisement monitor features
Date:   Thu, 28 May 2020 16:54:49 -0700
Message-Id: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
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

 include/net/bluetooth/mgmt.h | 49 ++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 16e0d87bd8fae..df36c50d15f53 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -702,6 +702,45 @@ struct mgmt_rp_set_exp_feature {
 	__le32 flags;
 } __packed;
 
+#define MGMT_ADV_MONITOR_FEATURE_MASK_OR_PATTERNS    BIT(0)
+
+#define MGMT_OP_READ_ADV_MONITOR_FEATURES	0x004B
+#define MGMT_READ_ADV_MONITOR_FEATURES_SIZE	0
+struct mgmt_rp_read_adv_monitor_features {
+	__u32 supported_features;
+	__u32 enabled_features;
+	__u16 max_num_handles;
+	__u8 max_num_patterns;
+	__u16 num_handles;
+	__u16 handles[];
+}  __packed;
+
+struct mgmt_adv_pattern {
+	__u8 ad_type;
+	__u8 offset;
+	__u8 length;
+	__u8 value[31];
+} __packed;
+
+#define MGMT_OP_ADD_ADV_PATTERNS_MONITOR	0x004C
+struct mgmt_cp_add_adv_patterns_monitor {
+	__u8 pattern_count;
+	struct mgmt_adv_pattern patterns[];
+} __packed;
+#define MGMT_ADD_ADV_PATTERNS_MONITOR_SIZE	1
+struct mgmt_rp_add_adv_patterns_monitor {
+	__u16 monitor_handle;
+} __packed;
+
+#define MGMT_OP_REMOVE_ADV_MONITOR		0x004D
+struct mgmt_cp_remove_adv_monitor {
+	__u16 monitor_handle;
+} __packed;
+#define MGMT_REMOVE_ADV_MONITOR_SIZE		2
+struct mgmt_rp_remove_adv_monitor {
+	__u16 monitor_handle;
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
+#define MGMT_EV_ADV_MONITOR_ADDED	0x0028
+struct mgmt_ev_adv_monitor_added {
+	__u16 monitor_handle;
+}  __packed;
+
+#define MGMT_EV_ADV_MONITOR_REMOVED	0x0029
+struct mgmt_ev_adv_monitor_removed {
+	__u16 monitor_handle;
+}  __packed;
-- 
2.26.2

