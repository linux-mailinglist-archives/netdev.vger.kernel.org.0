Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC54D27A290
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 21:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgI0TZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgI0TZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:25:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D803C0613CE;
        Sun, 27 Sep 2020 12:25:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k15so9481618wrn.10;
        Sun, 27 Sep 2020 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fj+MqTYC2iAIS+M4K2lQDTVvuS3lB9CWfLhIHCjPtgo=;
        b=Y9sVAaoeGa0WsUiyIrpAozyW1HjT50dHQRSgxJ9iEx2LORKlf/MCPTGO5gHwkA9+o2
         L0Bt3H8F8wCAxqHKLMzeHoOIAnxr/Ka4ueyWwDBS8feKPbG1+/hLXVmURoK3yV5d4rYb
         AvKTn+9YJbAXNTUzr/bYNykUXeZmpmkXUBPR1Vah7jOLQACS87+169Ow2OeJRyUP0+iE
         pIYxMbLWWYhkxBUq5xzInjxJh00fcEKa6BwqwAO+qys5hXPx9hAju1behnUWvWQM4MU6
         g/n/+gkdtQrKvKP09mXC5M3Y4O2C+pwgkJ4oZfHJkQQQybrdpsHBG6Qy35U75104xi6s
         DvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fj+MqTYC2iAIS+M4K2lQDTVvuS3lB9CWfLhIHCjPtgo=;
        b=PB/3TxWTnRKaI3pfeGpEa3IuzagCcYlUqkMciKOTFrxEZf2GdjulSHxcqDbwBHPdQt
         HrL0q0naLUjNBczhoV9DSyK+NVzcmT4PPsneHgPypd4dUY2jGX2yOl3d5MZPEZKE/wk6
         yrDggJ2ktbOBPjF5BbHz3Wdib7S7sJQz9FGXvCci0yP3StReoqI9C4D1rq42FIV9oq7s
         gMuduNuP4KFayvlEHzLK8xd1Dfy9XMlla6sN2yaqlZORemdVvXrI6qDRGl+GGtyj1iDc
         ZVQ753bl0JLMQv8OoxsP/eRSNb7mfZ2usS1uj/YeKnUYiosPn0aF2SX13T/mizzmBP55
         NiQA==
X-Gm-Message-State: AOAM531MIMJEO9b/6QYiJl6AI0cLOH7YE1hBAQ4ROuoYDuwzyRXJoVHl
        x+cFZvYCaXEB3bFeTLi0vPY=
X-Google-Smtp-Source: ABdhPJztFmpDvpI3aRkkIdSznkGAV72myWBuX/0vmVtKZgeNuymlmR/GrI/gMu+xnRoky9GFyVMiSQ==
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr14995784wrt.84.1601234724930;
        Sun, 27 Sep 2020 12:25:24 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id w21sm6398106wmk.34.2020.09.27.12.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 12:25:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     "0001-ath10k-Try-to-get-mac-address-from-dts . patchKalle Valo" 
        <kvalo@codeaurora.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ath10k: Try to download pre-cal using nvmem api
Date:   Sun, 27 Sep 2020 21:25:14 +0200
Message-Id: <20200927192515.86-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200927192515.86-1-ansuelsmth@gmail.com>
References: <20200927192515.86-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of routers that have the ath10k wifi chip integrated in the Soc
have the pre-cal data stored in a dedicated nvmem partition.
Introduce a new function to directly extract and use it if a nvmem with
the name 'pre-cal' is defined and available.
Pre-cal file have still priority to everything else.

Tested-on: QCA9984 hw1.0 PCI 10.4

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 52 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h |  3 ++
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9ed7b9883..dd509a4a8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/pm_qos.h>
 #include <asm/byteorder.h>
+#include <linux/nvmem-consumer.h>
 
 #include "core.h"
 #include "mac.h"
@@ -920,7 +921,8 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 	}
 
 	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
-	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE ||
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_NVMEM)
 		bmi_board_id_param = BMI_PARAM_GET_FLASH_BOARD_ID;
 	else
 		bmi_board_id_param = BMI_PARAM_GET_EEPROM_BOARD_ID;
@@ -1682,7 +1684,8 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 
 	/* As of now pre-cal is valid for 10_4 variants */
 	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
-	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE ||
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_NVMEM)
 		bmi_otp_exe_param = BMI_PARAM_FLASH_SECTION_ALL;
 
 	ret = ath10k_bmi_execute(ar, address, bmi_otp_exe_param, &result);
@@ -1703,6 +1706,41 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_download_cal_nvmem(struct ath10k *ar)
+{
+	int ret;
+	size_t len;
+	const void *file;
+	struct nvmem_cell *cell;
+	struct platform_device *pdev = of_find_device_by_node(ar->dev->of_node);
+
+	if (!pdev)
+		return -ENODEV;
+
+	cell = nvmem_cell_get(ar->dev, "pre-cal");
+	if (IS_ERR(cell))
+		return PTR_ERR(cell);
+
+	file = nvmem_cell_read(cell, &len);
+	nvmem_cell_put(cell);
+
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ret = ath10k_download_board_data(ar, file, len);
+	if (ret) {
+		ath10k_err(ar, "failed to download cal_file data: %d\n", ret);
+		goto err;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cal file downloaded\n");
+
+	return 0;
+err:
+	kfree(file);
+	return ret;
+}
+
 static int ath10k_download_cal_file(struct ath10k *ar,
 				    const struct firmware *file)
 {
@@ -2049,6 +2087,16 @@ static int ath10k_core_pre_cal_download(struct ath10k *ar)
 		goto success;
 	}
 
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot did not find a pre calibration file, try NVMEM next: %d\n",
+		   ret);
+
+	ret = ath10k_download_cal_nvmem(ar);
+	if (ret == 0) {
+		ar->cal_mode = ATH10K_PRE_CAL_MODE_NVMEM;
+		goto success;
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot did not find a pre calibration file, try DT next: %d\n",
 		   ret);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4cf5bd489..186aba73a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -864,6 +864,7 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_OTP,
 	ATH10K_CAL_MODE_DT,
 	ATH10K_PRE_CAL_MODE_FILE,
+	ATH10K_PRE_CAL_MODE_NVMEM,
 	ATH10K_PRE_CAL_MODE_DT,
 	ATH10K_CAL_MODE_EEPROM,
 };
@@ -886,6 +887,8 @@ static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 		return "dt";
 	case ATH10K_PRE_CAL_MODE_FILE:
 		return "pre-cal-file";
+	case ATH10K_PRE_CAL_MODE_NVMEM:
+		return "pre-cal-nvmem";
 	case ATH10K_PRE_CAL_MODE_DT:
 		return "pre-cal-dt";
 	case ATH10K_CAL_MODE_EEPROM:
-- 
2.27.0

