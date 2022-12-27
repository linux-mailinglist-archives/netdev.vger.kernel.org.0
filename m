Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB3657143
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiL0Xdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiL0Xc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:32:27 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B85E0D7;
        Tue, 27 Dec 2022 15:30:54 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id m21so20871685edc.3;
        Tue, 27 Dec 2022 15:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkWht2yLW1tGoXrbVkq+ldlAYVXsEoXS4p1SnmxgLa8=;
        b=ZiriEed9I3WRaJMRtKe86e/jk6AAyzctAFRQypbcsjHumMGY5Hw2LAvRKPVWY6t8U8
         lcYIU3JCxmtH3P9ejpISD/yiKKdCKrMGzm7MgvZNvACyQ/IOXCDCr8iHlEJIVGoFv++p
         yghQsza97xnHpd5Z/fC7ZMMko1/+rKe6GAnib/LZIj3Zc5p0/YYkVQYVg+XyYbT03p4c
         v0Rg6X7keFfBqc97wAOxp9RsN/OcUQ3XjTH6waKcWHIZYXba46BSyDyZTsIeFzzbJcZ0
         Ua9l18g66CKIKG3Qds/fxEDgPqYBdlEK3UpO7nZb5degjTpr/n4dx3sJXbkTFQeJ5fC2
         U/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkWht2yLW1tGoXrbVkq+ldlAYVXsEoXS4p1SnmxgLa8=;
        b=hDhASs7jtxIud9UPJgxJxpnwLiPiFw/DXFGUQ1LngGjzDxUkgb4jFiT2pirAVPe5RL
         nNbSGsgVxuT9Q9dsFz/T6SPodmtD2O5hyAHNRx1E2heeWr8yj+iHI7AICLAOTq6jmoxC
         hWmvH2q1V1neDAsZPNPqpBtcUh+RlRUP/UTSgYD/inPAC8qWC0Ds9kyi2a0Rx/3ezhAf
         SVsJC9BCWfPwoghCpIGRtaFfoO678tU8oiuhbCF/vkb1oyw/FyX7FNU/4Bhd93PgkY/0
         tcw40CM+ZSGd3EQVlie4ZNHuYppywKPgNqd4HRzavzD1vKn4BEy6Z8vVIfVKJ2tRm01C
         DjeA==
X-Gm-Message-State: AFqh2kqhiXgqvjv4BWUGitGBWDHc6O2+O+TzXEj7risWnAAR+i4HcZwm
        S6uGjqz7FRqckWeiyQcC7N2QsBaZNyo=
X-Google-Smtp-Source: AMrXdXtqMomD1AYMVjv53V+sPRjBXDm52IoCAQVKs6DsvUau/rII4ajhWxNdNNJZTvB+9FONKtVr4A==
X-Received: by 2002:a05:6402:12d4:b0:461:6219:4b16 with SMTP id k20-20020a05640212d400b0046162194b16mr19942317edx.33.1672183852522;
        Tue, 27 Dec 2022 15:30:52 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:52 -0800 (PST)
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
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH v1 18/19] rtw88: Add support for the SDIO based RTL8822CS chipset
Date:   Wed, 28 Dec 2022 00:30:19 +0100
Message-Id: <20221227233020.284266-19-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
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
 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 .../net/wireless/realtek/rtw88/rtw8822cs.c    | 34 +++++++++++++++++++
 3 files changed, 48 insertions(+)
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
index 000000000000..3d7279d70aa9
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "sdio.h"
+#include "rtw8822c.h"
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
2.39.0

