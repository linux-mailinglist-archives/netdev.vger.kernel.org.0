Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B64C402887
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344167AbhIGMU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:20:26 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36930
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344335AbhIGMTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:51 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4185740191
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017113;
        bh=JDWMUU6nWDzDRnCxtysvffFNd9O3HT0+eb4C8TwA21k=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=THvlgJJVPUdS2G4htPrdV0Btl9JrJh9fDSBov0j9gWIRmyu4+OsgSd/dK3DUp2jn2
         CLSvm5lBdBBU5P+2DqGMF6n0lS+pzfN7PbB32lKw8/EA0H8xzA9u0fe4kzT+Ud7RgM
         P9emRigwDxIeS6iMe0iLXGCnlveUChycCN2fO0RIK3Qte8zWeWVgJBY9Bu3ngYgvpL
         AwPSDFRMp1SW6ReSSJDpUs1+tJk7Yq6jSXZ8dP3uEZXP4AyL8PO7RY0HDOJudrbnoz
         HUowv9VvGCY8ZP/SIAtUsYf9EVgT5FCGNFSQKL/xVsKVPw90DlkY1W2kPFlBtpF6la
         W82n2xBhM8pZQ==
Received: by mail-wm1-f72.google.com with SMTP id u14-20020a7bcb0e0000b0290248831d46e4so1033142wmj.6
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JDWMUU6nWDzDRnCxtysvffFNd9O3HT0+eb4C8TwA21k=;
        b=Zz+OipIcSRoS1jDSWV3OZM7rk9/OIj1m98PxpdqWEiY0oWy77loczMviQYr5DQMKQU
         UX4Z5JphedwOj+6W/rnSCK+K60Xl2QEdvR/WDuQofyH4Gpcq2eA7Ep5y8QgxP79RCeyP
         5j3TFxaEXncpxGnvGmjFD3whYiRwEl35/aLMvO1TQnI5skapOzLuOC23q0OhEcj0IjoU
         wZWyv2S5lQcH1nMLhgYkoORcVilHd5DIf0lTXhe6H2azyZUrxmI2I7mSln2VQm2/VTUc
         Qvvhko8RvCPWtiNv3Jonc0KNuf09UADBNadDMQc3TcmmhG0m04IdtQNO/bfyS6/2iW4+
         S6Yg==
X-Gm-Message-State: AOAM532MKzCXA7/+9jfKtU7ACvdjYpUyPKSl0UDrcp88ERk0W31yOwNM
        d7qTYC8Wj/hWGw4a4v6YT214Wwlw/BNOlVkTSiD7vnu4yQP7pSv1KV5Q9+dIZu0L2cNWFmse3z7
        WOyXKNbQSUz4SNSLUfYrfDcZln1FD5yzZcw==
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr3625643wmk.172.1631017112940;
        Tue, 07 Sep 2021 05:18:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIRJRBnXqqRi/FyU10IMJdS2aVEiOt1XxAF7EDlHa+Uo5rJJxXcKVpKNVHaNkiAm/uo8/TUg==
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr3625633wmk.172.1631017112788;
        Tue, 07 Sep 2021 05:18:32 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:32 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 09/15] nfc: s3fwrn5: simplify dereferencing pointer to struct device
Date:   Tue,  7 Sep 2021 14:18:10 +0200
Message-Id: <20210907121816.37750-10-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code dereferencing several pointers to reach the struct
device.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/s3fwrn5/firmware.c | 29 +++++++++++------------------
 drivers/nfc/s3fwrn5/nci.c      | 18 +++++++-----------
 2 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 1af7a1e632cf..c20fdbac51c5 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -357,6 +357,7 @@ s3fwrn5_fw_is_custom(const struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo)
 
 int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info)
 {
+	struct device *dev = &fw_info->ndev->nfc_dev->dev;
 	struct s3fwrn5_fw_cmd_get_bootinfo_rsp bootinfo;
 	int ret;
 
@@ -364,8 +365,7 @@ int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info)
 
 	ret = s3fwrn5_fw_get_bootinfo(fw_info, &bootinfo);
 	if (ret < 0) {
-		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Failed to get bootinfo, ret=%02x\n", ret);
+		dev_err(dev, "Failed to get bootinfo, ret=%02x\n", ret);
 		goto err;
 	}
 
@@ -373,8 +373,7 @@ int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info)
 
 	ret = s3fwrn5_fw_get_base_addr(&bootinfo, &fw_info->base_addr);
 	if (ret < 0) {
-		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Unknown hardware version\n");
+		dev_err(dev, "Unknown hardware version\n");
 		goto err;
 	}
 
@@ -409,6 +408,7 @@ bool s3fwrn5_fw_check_version(const struct s3fwrn5_fw_info *fw_info, u32 version
 
 int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 {
+	struct device *dev = &fw_info->ndev->nfc_dev->dev;
 	struct s3fwrn5_fw_image *fw = &fw_info->fw;
 	u8 hash_data[SHA1_DIGEST_SIZE];
 	struct crypto_shash *tfm;
@@ -421,8 +421,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 
 	tfm = crypto_alloc_shash("sha1", 0, 0);
 	if (IS_ERR(tfm)) {
-		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Cannot allocate shash (code=%pe)\n", tfm);
+		dev_err(dev, "Cannot allocate shash (code=%pe)\n", tfm);
 		return PTR_ERR(tfm);
 	}
 
@@ -430,21 +429,18 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 
 	crypto_free_shash(tfm);
 	if (ret) {
-		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Cannot compute hash (code=%d)\n", ret);
+		dev_err(dev, "Cannot compute hash (code=%d)\n", ret);
 		return ret;
 	}
 
 	/* Firmware update process */
 
-	dev_info(&fw_info->ndev->nfc_dev->dev,
-		"Firmware update: %s\n", fw_info->fw_name);
+	dev_info(dev, "Firmware update: %s\n", fw_info->fw_name);
 
 	ret = s3fwrn5_fw_enter_update_mode(fw_info, hash_data,
 		SHA1_DIGEST_SIZE, fw_info->sig, fw_info->sig_size);
 	if (ret < 0) {
-		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Unable to enter update mode\n");
+		dev_err(dev, "Unable to enter update mode\n");
 		return ret;
 	}
 
@@ -452,21 +448,18 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 		ret = s3fwrn5_fw_update_sector(fw_info,
 			fw_info->base_addr + off, fw->image + off);
 		if (ret < 0) {
-			dev_err(&fw_info->ndev->nfc_dev->dev,
-				"Firmware update error (code=%d)\n", ret);
+			dev_err(dev, "Firmware update error (code=%d)\n", ret);
 			return ret;
 		}
 	}
 
 	ret = s3fwrn5_fw_complete_update_mode(fw_info);
 	if (ret < 0) {
-		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Unable to complete update mode\n");
+		dev_err(dev, "Unable to complete update mode\n");
 		return ret;
 	}
 
-	dev_info(&fw_info->ndev->nfc_dev->dev,
-		"Firmware update: success\n");
+	dev_info(dev, "Firmware update: success\n");
 
 	return ret;
 }
diff --git a/drivers/nfc/s3fwrn5/nci.c b/drivers/nfc/s3fwrn5/nci.c
index e374e670b36b..ca6828f55ba0 100644
--- a/drivers/nfc/s3fwrn5/nci.c
+++ b/drivers/nfc/s3fwrn5/nci.c
@@ -47,6 +47,7 @@ const struct nci_driver_ops s3fwrn5_nci_prop_ops[4] = {
 
 int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name)
 {
+	struct device *dev = &info->ndev->nfc_dev->dev;
 	const struct firmware *fw;
 	struct nci_prop_fw_cfg_cmd fw_cfg;
 	struct nci_prop_set_rfreg_cmd set_rfreg;
@@ -55,7 +56,7 @@ int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name)
 	int i, len;
 	int ret;
 
-	ret = request_firmware(&fw, fw_name, &info->ndev->nfc_dev->dev);
+	ret = request_firmware(&fw, fw_name, dev);
 	if (ret < 0)
 		return ret;
 
@@ -77,13 +78,11 @@ int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name)
 
 	/* Start rfreg configuration */
 
-	dev_info(&info->ndev->nfc_dev->dev,
-		"rfreg configuration update: %s\n", fw_name);
+	dev_info(dev, "rfreg configuration update: %s\n", fw_name);
 
 	ret = nci_prop_cmd(info->ndev, NCI_PROP_START_RFREG, 0, NULL);
 	if (ret < 0) {
-		dev_err(&info->ndev->nfc_dev->dev,
-			"Unable to start rfreg update\n");
+		dev_err(dev, "Unable to start rfreg update\n");
 		goto out;
 	}
 
@@ -97,8 +96,7 @@ int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name)
 		ret = nci_prop_cmd(info->ndev, NCI_PROP_SET_RFREG,
 			len+1, (__u8 *)&set_rfreg);
 		if (ret < 0) {
-			dev_err(&info->ndev->nfc_dev->dev,
-				"rfreg update error (code=%d)\n", ret);
+			dev_err(dev, "rfreg update error (code=%d)\n", ret);
 			goto out;
 		}
 		set_rfreg.index++;
@@ -110,13 +108,11 @@ int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name)
 	ret = nci_prop_cmd(info->ndev, NCI_PROP_STOP_RFREG,
 		sizeof(stop_rfreg), (__u8 *)&stop_rfreg);
 	if (ret < 0) {
-		dev_err(&info->ndev->nfc_dev->dev,
-			"Unable to stop rfreg update\n");
+		dev_err(dev, "Unable to stop rfreg update\n");
 		goto out;
 	}
 
-	dev_info(&info->ndev->nfc_dev->dev,
-		"rfreg configuration update: success\n");
+	dev_info(dev, "rfreg configuration update: success\n");
 out:
 	release_firmware(fw);
 	return ret;
-- 
2.30.2

