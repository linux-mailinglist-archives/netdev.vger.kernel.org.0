Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2A91ED8E6
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 01:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgFCXEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 19:04:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46651 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgFCXDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 19:03:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id b16so2437253pfi.13
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 16:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ez/bvlepDduVIxHglwNwBFWJmOXjR008iaFnpJzBvrU=;
        b=ElHgxlfyjmI7NpucOINNAzsvZ5SNoxnKGKnesGMsgq+IQV/BDLWGnfmdpJzmimiXXu
         ZvbjRqNFBCupDLSbotVaavThprfaI9hOeZQFEefs91YYMupST4hZ86HLrYoqd/Wi7Brt
         HKq8EBzLAbHemO26c3THGoxqcIuMiXxhsmFMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ez/bvlepDduVIxHglwNwBFWJmOXjR008iaFnpJzBvrU=;
        b=rf94ia4DcjXWpdy34gpSdrbmUFxzSNuxI09Bwv6QyGmZlQczmBUGrK06NHl9dCpy1v
         RsRcNZCt8XTR5/g1OXqx2EXKUjdpSt6TIGJORm8aikdGa3YXib2gc2/0NFiZQIEnOaUy
         HIeE454UhNxY5nRXmvfkOo6tz29I/whkA779plF94+HmC2AlwhuM96uXwTg5gLGTESdF
         Dcy0m3EYPWiBW0ykJy+v0PwLU5gZwDpPcn2k1fXQAXDxfEGEwqtU6AcfpC12IEN4HO9V
         j7pKva6s5pTEOjVspO8a0Lx9CSgcJF7wfRXuxBBZpTJ+W4+06ZFFkhpu0CSkFRk9wxNq
         j74g==
X-Gm-Message-State: AOAM532YJl+ajr8UHd3peYQLvs5ehVA7UkjSKQc0oZIthNHPAQ6MUrlo
        n+cYpazpPaE+XKIQ7nK05Ey3dQ==
X-Google-Smtp-Source: ABdhPJzXfRYYgZFvZFZg1PG4JNnOp9p91vozXqd+fMmZBzV1SkYLmbUgwhnlA3AHb8tArt7NlPxYOg==
X-Received: by 2002:a65:5206:: with SMTP id o6mr1568522pgp.16.1591225332425;
        Wed, 03 Jun 2020 16:02:12 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id b11sm2715999pfd.178.2020.06.03.16.02.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jun 2020 16:02:11 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/7] Bluetooth: Add definitions for advertisement monitor features
Date:   Wed,  3 Jun 2020 16:01:44 -0700
Message-Id: <20200603160058.v2.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
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

Changes in v2: None

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

