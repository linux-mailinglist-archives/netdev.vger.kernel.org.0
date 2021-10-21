Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F5B4364FC
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhJUPHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhJUPHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:07:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1348BC061348
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:04:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v20so608894plo.7
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+7ZZ5NEQvmKMVpumrFViPwChqWqhssGnPZ02YAN9YdY=;
        b=i95t92b2Q4lUhdSuI0qG+4TT7Epm7Ya6L8Xna+yyPox+5giXcQhMxkdGkR9A2OutPL
         unj/zai0nOc2rvGY6EbfoKm8gi3TlJlWlavzPmCOQNpaHC2M95jsEr1GoVyi7kF/8MIw
         lJtQURZT+tjTUadZUWf/310mY0iCpk8OJbUZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+7ZZ5NEQvmKMVpumrFViPwChqWqhssGnPZ02YAN9YdY=;
        b=PY1uKIpEvyGht6942ienBPxP4n8PvQEFEm5gJCOwCt2NW3WSX3GLf82Pl5D9Nk1E9T
         cnSbwXhdt3WN5d8a2y37QoPJjgWfoaMIx0eMmLRJZTuc0ofWYS6DFtgaFvK99faHiH8a
         nzvanZJc1XUfcGgMlUruunY63FtYeDmtJ8tZZwPkdTkXrXyuVCFklR/xbwA3KklYbUy8
         4BbpMIupSapzAIcn4KehJblcAspcaJp66/4ks7l5E8TfNK1ODI4UskDdEYHYYy1F/4wB
         noLAoL/0oG58lQ13EdxCcRnO+/L68B4bFZbRF2NhY6L+AFIQ0jFojIqq2AvQvI6JUywg
         3rjw==
X-Gm-Message-State: AOAM532JaqWkzU26Pme/QjCGzpWbAKVDqcFeyT0BuViJ2jbM0sQK8ykX
        KbMYwWQs6f3Bjp3D8F1H3vEcEQ==
X-Google-Smtp-Source: ABdhPJz3ggWax17jrJJfhyp5cR5clwL26aLQhXGER64HejHwJ01ao3uMXFtcT3GQqQrbnDZnso4sLQ==
X-Received: by 2002:a17:903:234a:b0:13e:f01a:24f with SMTP id c10-20020a170903234a00b0013ef01a024fmr5673861plh.43.1634828684485;
        Thu, 21 Oct 2021 08:04:44 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:acf2:287:fa53:43f4])
        by smtp.gmail.com with ESMTPSA id 21sm9546045pjg.57.2021.10.21.08.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:04:43 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v6 1/3] Bluetooth: Add struct of reading AOSP vendor capabilities
Date:   Thu, 21 Oct 2021 23:04:23 +0800
Message-Id: <20211021230356.v6.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the struct of reading AOSP vendor capabilities.
New capabilities are added incrementally. Note that the
version_supported octets will be used to determine whether a
capability has been defined for the version.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>

---

Changes in v6:
- Add historical versions of struct aosp_rp_le_get_vendor_capabilities.
- Perform the basic check about the struct length.
- Through the version, bluetooth_quality_report_support can be checked.

Changes in v5:
- This is a new patch.
- Add struct aosp_rp_le_get_vendor_capabilities so that next patch
  can determine whether a particular capability is supported or not.

 include/net/bluetooth/hci_core.h |   1 +
 net/bluetooth/aosp.c             | 116 ++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index dd8840e70e25..32b3774227f2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -603,6 +603,7 @@ struct hci_dev {
 
 #if IS_ENABLED(CONFIG_BT_AOSPEXT)
 	bool			aosp_capable;
+	bool			aosp_quality_report;
 #endif
 
 	int (*open)(struct hci_dev *hdev);
diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
index a1b7762335a5..64684b2bf79b 100644
--- a/net/bluetooth/aosp.c
+++ b/net/bluetooth/aosp.c
@@ -8,9 +8,53 @@
 
 #include "aosp.h"
 
+/* Command complete parameters of LE_Get_Vendor_Capabilities_Command
+ * The parameters grow over time. The first version that declares the
+ * version_supported field is v0.95. Refer to
+ * https://cs.android.com/android/platform/superproject/+/master:system/
+ *         bt/gd/hci/controller.cc;l=452?q=le_get_vendor_capabilities_handler
+ */
+
+/* the base capabilities struct with the version_supported field */
+struct aosp_rp_le_get_vendor_capa_v95 {
+	__u8	status;
+	__u8	max_advt_instances;
+	__u8	offloaded_resolution_of_private_address;
+	__u16	total_scan_results_storage;
+	__u8	max_irk_list_sz;
+	__u8	filtering_support;
+	__u8	max_filter;
+	__u8	activity_energy_info_support;
+	__u16	version_supported;
+	__u16	total_num_of_advt_tracked;
+	__u8	extended_scan_support;
+	__u8	debug_logging_supported;
+} __packed;
+
+struct aosp_rp_le_get_vendor_capa_v96 {
+	struct aosp_rp_le_get_vendor_capa_v95 v95;
+	/* v96 */
+	__u8	le_address_generation_offloading_support;
+} __packed;
+
+struct aosp_rp_le_get_vendor_capa_v98 {
+	struct aosp_rp_le_get_vendor_capa_v96 v96;
+	/* v98 */
+	__u32	a2dp_source_offload_capability_mask;
+	__u8	bluetooth_quality_report_support;
+} __packed;
+
+struct aosp_rp_le_get_vendor_capa_v100 {
+	struct aosp_rp_le_get_vendor_capa_v98 v98;
+	/* v100 */
+	__u32	dynamic_audio_buffer_support;
+} __packed;
+
 void aosp_do_open(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
+	struct aosp_rp_le_get_vendor_capa_v95 *base_rp;
+	u16 version_supported;
 
 	if (!hdev->aosp_capable)
 		return;
@@ -20,9 +64,79 @@ void aosp_do_open(struct hci_dev *hdev)
 	/* LE Get Vendor Capabilities Command */
 	skb = __hci_cmd_sync(hdev, hci_opcode_pack(0x3f, 0x153), 0, NULL,
 			     HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb))
+	if (IS_ERR(skb)) {
+		bt_dev_warn(hdev, "AOSP get vendor capabilities (%ld)",
+			    PTR_ERR(skb));
 		return;
+	}
+
+	bt_dev_dbg(hdev, "aosp le vendor capabilities length %d", skb->len);
+
+	base_rp = (struct aosp_rp_le_get_vendor_capa_v95 *)skb->data;
+
+	if (base_rp->status) {
+		bt_dev_err(hdev, "AOSP LE Get Vendor Capabilities status %d",
+			   base_rp->status);
+		goto done;
+	}
+
+	version_supported = le16_to_cpu(base_rp->version_supported);
+	bt_dev_info(hdev, "AOSP version %u", version_supported);
+
+	/* Do not support very old versions. */
+	if (version_supported < 95) {
+		bt_dev_err(hdev, "capabilities version %u too old",
+			   version_supported);
+		goto done;
+	}
+
+	if (version_supported >= 95) {
+		struct aosp_rp_le_get_vendor_capa_v95 *rp;
+
+		rp = (struct aosp_rp_le_get_vendor_capa_v95 *)skb->data;
+		if (skb->len < sizeof(*rp))
+			goto length_error;
+	}
+
+	if (version_supported >= 96) {
+		struct aosp_rp_le_get_vendor_capa_v96 *rp;
+
+		rp = (struct aosp_rp_le_get_vendor_capa_v96 *)skb->data;
+		if (skb->len < sizeof(*rp))
+			goto length_error;
+	}
+
+	if (version_supported >= 98) {
+		struct aosp_rp_le_get_vendor_capa_v98 *rp;
+
+		rp = (struct aosp_rp_le_get_vendor_capa_v98 *)skb->data;
+		if (skb->len < sizeof(*rp))
+			goto length_error;
+
+		/* The bluetooth_quality_report_support is defined at version v0.98.
+		 * Refer to https://cs.android.com/android/platform/superproject/+/
+		 *                  master:system/bt/gd/hci/controller.cc;l=477
+		 */
+		if (rp->bluetooth_quality_report_support) {
+			hdev->aosp_quality_report = true;
+			bt_dev_info(hdev, "bluetooth quality report is supported");
+		}
+	}
+
+	if (version_supported >= 100) {
+		struct aosp_rp_le_get_vendor_capa_v100 *rp;
+
+		rp = (struct aosp_rp_le_get_vendor_capa_v100 *)skb->data;
+		if (skb->len < sizeof(*rp))
+			goto length_error;
+	}
+
+	goto done;
+
+length_error:
+	bt_dev_err(hdev, "AOSP capabilities length %d too short", skb->len);
 
+done:
 	kfree_skb(skb);
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

