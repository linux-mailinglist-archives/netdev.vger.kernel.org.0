Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5E26D526B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbjDCUZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjDCUZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:32 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A90B4491;
        Mon,  3 Apr 2023 13:25:04 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p34so17800988wms.3;
        Mon, 03 Apr 2023 13:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xrjPF3OhYlVBqcryCDeCExa8TOEqm20E0qSA+aRH+Ko=;
        b=nwoCHR9drMsFWfoVZnazl7uKpVa/fagOcMt1HK39eI6Mlzq67RSJSLmuBgHPR76N+L
         0xrQuA/4QPknxi96ph1B0V65LUC5Bnuf/MgS1SzW4pI13V3R7GvOFwIgQt2g0I7nqvJk
         KZ8llUDOwZ1163np3OIAzLjzIhGCY0fD4b3TIvKvVRlJElvkw32tKPRDOQlS8aGPAfgW
         qcSGPUQLYAMqw4/tL5yLSjUqaKMkHmO4lwPbkqtPRmBN+QdglRU/UiZ/VLQZOMfaxRKC
         db3Ix6OatgZXd4NtiFzcpw7DKhRg29jSD0dPanJHP2vB1ETLXDb3U++5Mjy1ho9K3nAb
         mm8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xrjPF3OhYlVBqcryCDeCExa8TOEqm20E0qSA+aRH+Ko=;
        b=Xw/7ujbUeI8nsIP+up6Rel7T3mTQ9HMJN0hIc/55GxOKpc2GFUKNridHaaUbZmB6d6
         7PSigyZi3U3Da4DC2z8ecBRVps/QDlxcjibLSJD0mbfwf47kA93KzvDwLLZO/kuDqTxD
         x8j7y5/C7R8jc+JyqIV0VLM5e83Bx27eyt9RKe6vthXOGeZ4N0oQEjl1KhUcp5t+0Wji
         AkFM4/jUodh4Mc9vWG35jgdrW08ZsY7HVxtXVAIViZk56ubma1iAS1qHtewnlpBYIM4r
         Le+fcww/Ek25kvFOfQbf3KDlt5h5PadJlujZwCj5J41flxZPQuvifqyCw988XvXLqLuL
         RjJA==
X-Gm-Message-State: AAQBX9d+dnD96HWCvSKYC3rIN/IOEG47XORwKUkzz6eQi/8IKm05B0M+
        f25YRSTGeLjfe/1N/nEVeihW+fgJ2oM=
X-Google-Smtp-Source: AKy350ZLcx7k0w1oLApKcNxfSIre7rouy0bE/QO+gH0lPvOxFaGup9N6UG1UEnc6JOYaWmQyEd2cIQ==
X-Received: by 2002:a05:600c:221a:b0:3ee:6cdf:c357 with SMTP id z26-20020a05600c221a00b003ee6cdfc357mr441608wml.20.1680553500452;
        Mon, 03 Apr 2023 13:25:00 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:25:00 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 8/9] wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
Date:   Mon,  3 Apr 2023 22:24:39 +0200
Message-Id: <20230403202440.276757-9-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wire up RTL8822CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8822C chipset code.

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v3:
- add Ping-Ke's reviewed-by

Changes since v2:
- sort includes alphabetically as suggested by Ping-Ke
- add missing #include "main.h" (after it has been removed from sdio.h
  in patch 2 from this series)

Changes since v1:
- use /* ... */ style for copyright comments


 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 .../net/wireless/realtek/rtw88/rtw8822cs.c    | 36 +++++++++++++++++++
 3 files changed, 50 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 0cfc68dcc416..6b65da81127f 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -78,6 +78,17 @@ config RTW88_8822CE
 
 	  802.11ac PCIe wireless network adapter
 
+config RTW88_8822CS
+	tristate "Realtek 8822CS SDIO wireless network adapter"
+	depends on MMC
+	select RTW88_CORE
+	select RTW88_SDIO
+	select RTW88_8822C
+	help
+	  Select this option will enable support for 8822CS chipset
+
+	  802.11ac SDIO wireless network adapter
+
 config RTW88_8822CU
 	tristate "Realtek 8822CU USB wireless network adapter"
 	depends on USB
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 2b8f4dd9707f..6105c2745bda 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -38,6 +38,9 @@ rtw88_8822c-objs		:= rtw8822c.o rtw8822c_table.o
 obj-$(CONFIG_RTW88_8822CE)	+= rtw88_8822ce.o
 rtw88_8822ce-objs		:= rtw8822ce.o
 
+obj-$(CONFIG_RTW88_8822CS)	+= rtw88_8822cs.o
+rtw88_8822cs-objs		:= rtw8822cs.o
+
 obj-$(CONFIG_RTW88_8822CU)	+= rtw88_8822cu.o
 rtw88_8822cu-objs		:= rtw8822cu.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822cs.c b/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
new file mode 100644
index 000000000000..975e81c824f2
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "main.h"
+#include "rtw8822c.h"
+#include "sdio.h"
+
+static const struct sdio_device_id rtw_8822cs_id_table[] =  {
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
+			    SDIO_DEVICE_ID_REALTEK_RTW8822CS),
+		.driver_data = (kernel_ulong_t)&rtw8822c_hw_spec,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, rtw_8822cs_id_table);
+
+static struct sdio_driver rtw_8822cs_driver = {
+	.name = "rtw_8822cs",
+	.probe = rtw_sdio_probe,
+	.remove = rtw_sdio_remove,
+	.id_table = rtw_8822cs_id_table,
+	.drv = {
+		.pm = &rtw_sdio_pm_ops,
+		.shutdown = rtw_sdio_shutdown,
+	}
+};
+module_sdio_driver(rtw_8822cs_driver);
+
+MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com>");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless 8822cs driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.40.0

