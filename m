Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31382CE229
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgLCWxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgLCWxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 17:53:33 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E88AC061A52;
        Thu,  3 Dec 2020 14:53:08 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so2324707pga.7;
        Thu, 03 Dec 2020 14:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oIe++tU4EfyyFjCAKxrRYoNaW31kt/FbR7e6ygRmz6M=;
        b=F/B89NUmX31NRfpfXzveJauQrM6R2uGHZdVvsWTndOjPvzhv7M/WfLe9pNqfz4DxeM
         JNCZUy7EarFo3a2uy0BYVIaIZxoOk/z+wfF8jEyTav7LsgwowyacXd00J0UrMt4rkOjX
         wYKQ9qBei9dXSZKVIjIafnID77vSLmA4OQ4k24nAF0c6TMqgOCCqQPZnpLAZImEqcx+t
         AmuW/7ggQljS60bYaEfU/HEBL7kq/j+ENX02EiM7mSJbwnd5UioNqiIrf1LwOrIKOEfe
         OZfB1YWXNyy67hdV7quOTQNrj5bX1l3I4UGhB2SzZTNWqbigeYiKabezqtJzxHSdy5OV
         GglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oIe++tU4EfyyFjCAKxrRYoNaW31kt/FbR7e6ygRmz6M=;
        b=tSQp+SnNlf1TqpYRNue0KV37u0o68AQy4BMullnRxDKDXXSDOwSbWqlQ2yQag8e0L3
         ULEx4cRa2AjNWV4qQC55wDWkW653IAbk6Zpd1bwc+cP/AHbdyDyHqPPKZFXcc9TqWNxp
         5ZwjxkQj3BkvmIwoR06fn0e9TW9Vl/WafSamkcd7zRBtZ4en+RbS4tH5I3IpzRi5fFIM
         oGHFO03ej7DOvgORQKYBPbnJK0FRBcNatC6ufEnrG5FcUpoUtr4jBKxBuxI+J56zYG9K
         vtnU3VyEOEOE0fP+UdEpKaNTkuzyqrf/L3I3EAQYrcc/Nb+TNQX7aaqJO4dJNSRvXHRZ
         kprQ==
X-Gm-Message-State: AOAM532qLJYn5WbhFcREGrNPssKxjD4UTNKuwHGqOzw36mRXczdmruwv
        YRYVaWw8L1C0l9j33KnUHlqYxXv7DPY=
X-Google-Smtp-Source: ABdhPJxkGeX9HWhvAG6TJAJJ375yO43bKeia/oXO5VAoa3lovUZV/GtDGabtDHcB6Gk3DmTIyIQBgA==
X-Received: by 2002:a63:db18:: with SMTP id e24mr4958276pgg.155.1607035988012;
        Thu, 03 Dec 2020 14:53:08 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id y21sm3078232pfr.90.2020.12.03.14.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 14:53:07 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next] nfc: s3fwrn5: skip the NFC bootloader mode
Date:   Fri,  4 Dec 2020 07:52:57 +0900
Message-Id: <20201203225257.2446-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

If there isn't a proper NFC firmware image, Bootloader mode will be
skipped.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---

 ChangeLog:
  v2:
   - change the commit message.
   - change the skip handling code.

 drivers/nfc/s3fwrn5/core.c     | 23 +++++++++++++++++++++--
 drivers/nfc/s3fwrn5/firmware.c | 11 +----------
 drivers/nfc/s3fwrn5/firmware.h |  1 +
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index f8e5d78d9078..c00b7a07c3ee 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -20,13 +20,26 @@
 				NFC_PROTO_ISO14443_B_MASK | \
 				NFC_PROTO_ISO15693_MASK)
 
+static int s3fwrn5_firmware_init(struct s3fwrn5_info *info)
+{
+	struct s3fwrn5_fw_info *fw_info = &info->fw_info;
+	int ret;
+
+	s3fwrn5_fw_init(fw_info, "sec_s3fwrn5_firmware.bin");
+
+	/* Get firmware data */
+	ret = s3fwrn5_fw_request_firmware(fw_info);
+	if (ret < 0)
+		dev_err(&fw_info->ndev->nfc_dev->dev,
+			"Failed to get fw file, ret=%02x\n", ret);
+	return ret;
+}
+
 static int s3fwrn5_firmware_update(struct s3fwrn5_info *info)
 {
 	bool need_update;
 	int ret;
 
-	s3fwrn5_fw_init(&info->fw_info, "sec_s3fwrn5_firmware.bin");
-
 	/* Update firmware */
 
 	s3fwrn5_set_wake(info, false);
@@ -109,6 +122,12 @@ static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
 	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
 	int ret;
 
+	if (s3fwrn5_firmware_init(info)) {
+		//skip bootloader mode
+		ret = 0;
+		goto out;
+	}
+
 	ret = s3fwrn5_firmware_update(info);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 4cde6dd5c019..4b5352e2b915 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -280,7 +280,7 @@ static int s3fwrn5_fw_complete_update_mode(struct s3fwrn5_fw_info *fw_info)
 
 #define S3FWRN5_FW_IMAGE_HEADER_SIZE 44
 
-static int s3fwrn5_fw_request_firmware(struct s3fwrn5_fw_info *fw_info)
+int s3fwrn5_fw_request_firmware(struct s3fwrn5_fw_info *fw_info)
 {
 	struct s3fwrn5_fw_image *fw = &fw_info->fw;
 	u32 sig_off;
@@ -358,15 +358,6 @@ int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info)
 	struct s3fwrn5_fw_cmd_get_bootinfo_rsp bootinfo;
 	int ret;
 
-	/* Get firmware data */
-
-	ret = s3fwrn5_fw_request_firmware(fw_info);
-	if (ret < 0) {
-		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Failed to get fw file, ret=%02x\n", ret);
-		return ret;
-	}
-
 	/* Get bootloader info */
 
 	ret = s3fwrn5_fw_get_bootinfo(fw_info, &bootinfo);
diff --git a/drivers/nfc/s3fwrn5/firmware.h b/drivers/nfc/s3fwrn5/firmware.h
index 3c83e6730d30..3a82ce5837fb 100644
--- a/drivers/nfc/s3fwrn5/firmware.h
+++ b/drivers/nfc/s3fwrn5/firmware.h
@@ -89,6 +89,7 @@ struct s3fwrn5_fw_info {
 	char parity;
 };
 
+int s3fwrn5_fw_request_firmware(struct s3fwrn5_fw_info *fw_info);
 void s3fwrn5_fw_init(struct s3fwrn5_fw_info *fw_info, const char *fw_name);
 int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info);
 bool s3fwrn5_fw_check_version(const struct s3fwrn5_fw_info *fw_info, u32 version);
-- 
2.17.1

