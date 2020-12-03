Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9885C2CDA3F
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgLCPki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgLCPki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:40:38 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34732C061A4E;
        Thu,  3 Dec 2020 07:40:13 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id p21so2256536pjv.0;
        Thu, 03 Dec 2020 07:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nJMrfjYEfkLIdA9yzYR+YuyclC4kKW22S+3DhIBnUgc=;
        b=uFSVZX00hnliG+U1Wh4tAdQny5nLdxQBe3LvKtnhaikeaXSyU5PmOMWOT3uxuUPAzo
         7uISMQlMlAb1IkO8mmtu16XaXr6MrpuDHGrmmmjHDSvEXjtIPPiVzqLZDTawNkQdUumG
         1L4ydeHv5JR9Us2FDsRLIkSKBeKK1kyIJCtOaRB1ALAXvGv3N0lGOmk+3GyvrLZJoXLz
         E0myUsarzHYSzodROYGe/Hog4u0wk5fJUtGpB+EyqYVbkn5yjHDM9mcDbOJg9MEtbxLq
         pyYQogfHTREuesal9Fou2h4kuhPy8cEZLPduX/9m3eoK8CXDqOk7vx0TUixK/lS+2ATz
         /ylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nJMrfjYEfkLIdA9yzYR+YuyclC4kKW22S+3DhIBnUgc=;
        b=XssT9qMr5lI510Q96XhlqOmwlttHMuxrnFJTdQ0FbWhxFlV/+wizM7GFn0XxLV+t1p
         43sYt+6PsF2WTTqzDpOQVYvVeN50rGpmyaDq+vwycCSgDQwiCtNexM7VSjheKTQHsbbM
         8XyKwTEVkhwNjsPPzCrRWPXPpx14QtRon/WqiXgJ5wlV6JNEJLhJngoUs2fZGywisidi
         L7yPwhEP1L7Leofb6ydWM2rntB0yX+WrJR7pkat+U0vgkXsZEVDHw/n8M5QqFd1YE6Vr
         VucL/ZGgyzkgKqWKn/TxNBkVJx34qcri9B3YveNe7z+XNbalEd9E0SGZfZoyqXYw0wol
         FpGA==
X-Gm-Message-State: AOAM532stxmXiLcqb/c2pgxFI71jVed6ZW1MRfTVeqq+A7+6hOSymv+6
        a3/j+uA48K/K7kdXI2ZKfKJLKU+xxfw=
X-Google-Smtp-Source: ABdhPJwr7PQ0UJNHqTKpmj4wLln2vZqfy+j8pJXcH52bXRMB18zrgOQIkJEa7yNlNg2dEUuUMILUpw==
X-Received: by 2002:a17:902:9b97:b029:da:4299:2214 with SMTP id y23-20020a1709029b97b02900da42992214mr3584277plp.37.1607010012678;
        Thu, 03 Dec 2020 07:40:12 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id s65sm1515681pgb.78.2020.12.03.07.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 07:40:11 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] nfc: s3fwrn5: skip the NFC bootloader mode
Date:   Fri,  4 Dec 2020 00:39:50 +0900
Message-Id: <20201203153950.13772-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

If there isn't proper NFC firmware image,
Bootloader mode will be skipped.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/core.c     | 44 ++++++++++++++++++++++++----------
 drivers/nfc/s3fwrn5/firmware.c | 11 +--------
 drivers/nfc/s3fwrn5/firmware.h |  1 +
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index f8e5d78d9078..df89bc5d7338 100644
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
@@ -109,21 +122,26 @@ static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
 	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
 	int ret;
 
-	ret = s3fwrn5_firmware_update(info);
-	if (ret < 0)
-		goto out;
+	if (s3fwrn5_firmware_init(info) == 0) {
+		ret = s3fwrn5_firmware_update(info);
+		if (ret < 0)
+			goto out;
 
-	/* NCI core reset */
-
-	s3fwrn5_set_mode(info, S3FWRN5_MODE_NCI);
-	s3fwrn5_set_wake(info, true);
+		/* NCI core reset */
 
-	ret = nci_core_reset(info->ndev);
-	if (ret < 0)
-		goto out;
+		s3fwrn5_set_mode(info, S3FWRN5_MODE_NCI);
+		s3fwrn5_set_wake(info, true);
 
-	ret = nci_core_init(info->ndev);
+		ret = nci_core_reset(info->ndev);
+		if (ret < 0)
+			goto out;
 
+		ret = nci_core_init(info->ndev);
+	} else {
+		dev_info(&info->ndev->nfc_dev->dev,
+			 "skip bootloader mode\n");
+		ret = 0;
+	}
 out:
 	return ret;
 }
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

