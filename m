Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA996C23F0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjCTVhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjCTVgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C79BBA5;
        Mon, 20 Mar 2023 14:35:41 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ek18so52364957edb.6;
        Mon, 20 Mar 2023 14:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1r8IjJwVIyRWtJhcwsAyFjYCs6VABNRosrxGLP+PNA=;
        b=JAO+/xDul1UqdTrsgq1ezgAPvwZODfz33KEcngijCvHOWqmptK/a+O+aGWQC2fVcF7
         Satva22kFofbyQ2oTtsmdmq9sWh7cAIT26UMO6XDuIhgoX2gPAjtuvSOukfBUb6igPol
         0SzhSsYUqONO9bFP8Se4AKoUokVBtEbmZzaz5x7JqB9h+lN16bWPhriE9+PNI0O3UaS1
         GY8+MefHIBaaKKn+tt/guJh0k8RRhAKQqLo8kSfX8s2+zGSafcIQaxTCI4R7xl81FH1D
         OkvWlvjfroGj+YKxqaMqs/HLlzbQMUNzlZe4WzBRQchF7XyjJKvbzdT4IGwhBg7a+oDl
         gdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1r8IjJwVIyRWtJhcwsAyFjYCs6VABNRosrxGLP+PNA=;
        b=0pazq9O+HT7HPeMMU7w6CVRl/wZowP2ucxvuRk/MV3BBj4EatPOSxvzZqkUfsu5AA2
         CLKc4mlipKy4EZddB3b/17Iq2KR8+XOqQkocH0QzTll2hrlc+DvO8IzampAHoK0V/UuS
         EQ42GwloFI4aD4s6Vvrf8gUkXdv1HA4s2e0uTA/W7IUGs2XWL7y0HoW7jMFsBYC4/+tR
         ChQ14lxP23Tl55+56zNCBp08dZQ29YJbE2laIEBP5FHa4v5yHLSU/h2iq2qLx43sbSwh
         tlw89Osq3cqWNf/aP9SwYEwe8BJFPia0sg87Csru04m6hH9CH40kOXsp2+10qvA1j/6k
         tyaQ==
X-Gm-Message-State: AO0yUKUHUT5EEyVZTm6y1MlelLj5d38t0CpJPV5F0d5KL2z/pJzXWNGv
        vsMn3QXZZRD2YeRqpyBlhx//xw+Vyds=
X-Google-Smtp-Source: AK7set89jB29vPYJBUi6sTdIZt2LaEw3MvMELFUf0ob23Y3NoiU65FcUExIlvQbnKfCIrlk2D2s8tQ==
X-Received: by 2002:aa7:d4d9:0:b0:4fe:961d:cab0 with SMTP id t25-20020aa7d4d9000000b004fe961dcab0mr1063560edr.5.1679348130257;
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:29 -0700 (PDT)
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
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 8/9] wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
Date:   Mon, 20 Mar 2023 22:35:07 +0100
Message-Id: <20230320213508.2358213-9-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wire up RTL8822CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8822C chipset code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
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

