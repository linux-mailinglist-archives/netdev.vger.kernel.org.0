Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A8D65713E
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiL0XdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiL0XcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:32:08 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BB8E0BB;
        Tue, 27 Dec 2022 15:30:53 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id tz12so34949170ejc.9;
        Tue, 27 Dec 2022 15:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjqRO1hM2WmR8bA3fNj6YB7tA/88HOJsev0FI6+d5o4=;
        b=E5TP2oHD4qYQBRZ3fSmijhSgxo7LL4r39JXIVaSU46brUJtEIqhXAstiIc6OFIPzj0
         TcKm2PjQM3b87w2YqT8KAWmSLjrQ6S0gPKC9u6WOFwoPcLWPlrDFu9EzZR+81dA1MfE3
         Fq4bzgdheiOW3o91ebfYV/NTHoMcX5Pu1ldl8w+SJqIFzhXa50OZzeIB79STcHBEqDjv
         KRUyp4trCgjAEOyXVRhfkDDXn+Ks1AxKJrMK2QsoWBdQWQnCe7doaGiGH9GyGyoeTkOO
         CEV4quxrQE8FDF1UQF+eRZp26lV07Y5/QnNx7y6lQivJOkKLrwmHW7YmJeETQTnugMc+
         xYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjqRO1hM2WmR8bA3fNj6YB7tA/88HOJsev0FI6+d5o4=;
        b=PAjOirfryuzxDkGHpzcvrNm+jY2MxgHihDO2SeIhR3RhSKS9VQyELZWsk+99RTcA59
         2Cmr99gvyL5B2b9attLObyMZp94b2Zv+3C1x09lAMdl6SqI8evax1n6gC+Zx70RglebA
         GpwsX4wHi1VpiyraP+ozrq/eaEMWNXJCWt5DgueE/ugGQFygPsqSDlV+U5AVEassmrSW
         /ElASeffnvAYQ4ueOp7/nzfPsO/EZoopea2PmXapk+Y0vS7UoqYvY9RkQxil9AA036+O
         nWTXHrtTQ2PytpTRlE3sUH8rgftrMgYg1mRvo5hEGTXpP2Pw9uE/qhelXy2NeerCJe7o
         rbOg==
X-Gm-Message-State: AFqh2kobiCLr5ll8b7aiOy8GoC27iI08S31tiBLL0143DyZL9o5FpB9H
        HS3jbGW+hKzj8ojuH7Jsel6xDWuf6fo=
X-Google-Smtp-Source: AMrXdXsH0QZPD9s61Gke/d76O1N2kd/8pnWaqz1O+hj7ZO9+3bBQmojwGolERxfXNgb0f9/JAGbQ5w==
X-Received: by 2002:a17:907:6d0c:b0:7c1:652:d109 with SMTP id sa12-20020a1709076d0c00b007c10652d109mr22218951ejc.35.1672183851755;
        Tue, 27 Dec 2022 15:30:51 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:51 -0800 (PST)
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
Subject: [RFC PATCH v1 17/19] rtw88: Add support for the SDIO based RTL8822BS chipset
Date:   Wed, 28 Dec 2022 00:30:18 +0100
Message-Id: <20221227233020.284266-18-martin.blumenstingl@googlemail.com>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

Wire up RTL8822BS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8822B chipset code.

Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 .../net/wireless/realtek/rtw88/rtw8822bs.c    | 34 +++++++++++++++++++
 3 files changed, 48 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index cdf9cb478ee2..0cfc68dcc416 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -45,6 +45,17 @@ config RTW88_8822BE
 
 	  802.11ac PCIe wireless network adapter
 
+config RTW88_8822BS
+	tristate "Realtek 8822BS SDIO wireless network adapter"
+	depends on MMC
+	select RTW88_CORE
+	select RTW88_SDIO
+	select RTW88_8822B
+	help
+	  Select this option will enable support for 8822BS chipset
+
+	  802.11ac SDIO wireless network adapter
+
 config RTW88_8822BU
 	tristate "Realtek 8822BU USB wireless network adapter"
 	depends on USB
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 892cad60ba31..2b8f4dd9707f 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -26,6 +26,9 @@ rtw88_8822b-objs		:= rtw8822b.o rtw8822b_table.o
 obj-$(CONFIG_RTW88_8822BE)	+= rtw88_8822be.o
 rtw88_8822be-objs		:= rtw8822be.o
 
+obj-$(CONFIG_RTW88_8822BS)	+= rtw88_8822bs.o
+rtw88_8822bs-objs		:= rtw8822bs.o
+
 obj-$(CONFIG_RTW88_8822BU)	+= rtw88_8822bu.o
 rtw88_8822bu-objs		:= rtw8822bu.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822bs.c b/drivers/net/wireless/realtek/rtw88/rtw8822bs.c
new file mode 100644
index 000000000000..4c74ad2d2e5e
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bs.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright(c) Jernej Skrabec <jernej.skrabec@gmail.com>
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "sdio.h"
+#include "rtw8822b.h"
+
+static const struct sdio_device_id rtw_8822bs_id_table[] =  {
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
+			    SDIO_DEVICE_ID_REALTEK_RTW8822BS),
+		.driver_data = (kernel_ulong_t)&rtw8822b_hw_spec,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, rtw_8822bs_id_table);
+
+static struct sdio_driver rtw_8822bs_driver = {
+	.name = "rtw_8822bs",
+	.probe = rtw_sdio_probe,
+	.remove = rtw_sdio_remove,
+	.id_table = rtw_8822bs_id_table,
+	.drv = {
+		.pm = &rtw_sdio_pm_ops,
+		.shutdown = rtw_sdio_shutdown,
+	}
+};
+module_sdio_driver(rtw_8822bs_driver);
+
+MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@gmail.com>");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless 8822bs driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.39.0

