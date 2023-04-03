Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865EB6D5268
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjDCUZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjDCUZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:31 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110503AAE;
        Mon,  3 Apr 2023 13:25:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so20251709wmq.2;
        Mon, 03 Apr 2023 13:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qe7TFlrzOGxxL9D9ZWjyagVp3rXFj5Gl5PKWlevumaA=;
        b=e1bXv3C6ZcZS5PA1oVGqiem+VHwkXTv2+asi6HqWMF2OaAF1HW1MmrVQ0+JsSpII2D
         AmQtifKkztmP8D9HRTh4ckAcSgJfQcTV0L+9ujugs9hJXLLbBHKZpXAaCotoO64gCvv/
         4q1TtOXXYCysxzhpFEBFLTLxxMcy/q0lspkoaBKB5k+Z+/wFUm4wFnnNaQM8BqLa5G+r
         ejVBef74cqg0bbBd99AYYsfRqmHs6NHnYUJpNaN1zFwWcWixxy2HkewFKNeIzK30EECw
         dggiDh/vGUGgpzmalh2+KJEIVJ20nqyGS/61Z9n36zVjDKzA1yywwLFbEd1opio/o/z6
         A92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qe7TFlrzOGxxL9D9ZWjyagVp3rXFj5Gl5PKWlevumaA=;
        b=1G7DU+O9mvEgvbIQexvRddQJWgak+3I4j+o4li9APbBZplcfC3k3C8ViRoNkv7ZA4+
         jf9TPCd4PDphIjgb16gz4LaSAkijNSIGJuDAbzornQQiQEnkH4hHa/Nzs3W+r1en1s+y
         YIo+YIttkKKoUBBpN2Oj0qUHInFmcNzBxgsVG688988QgVa18W9PY7pA6i87CvA3wZJD
         Qkyo7BBswdsZQX61t48ok42cY+vKL5FhFSqtdcWDTkEPYlSQl6V7I/C+ISnaP4AFTHQL
         UH+YX9V0tWm4txVggxOpXAnY76hgSvd9pQa8CZO2zeHGIT6CRGjzacChYGxcgD7EsBzU
         s+Rg==
X-Gm-Message-State: AAQBX9fJgeMGJ5VdhBOIfCe1OR6zaD1UiOMkDkmEGaAIZ+8iwQqCrTbd
        OySy+LuAqpcNLhWfWjKv7wtL6g8yp9Q=
X-Google-Smtp-Source: AKy350bo7dEit+G4rtlo5R6WSti36VLX26GyCsuv7oJUQrSpEJLFWa42GaYFrxaPrA5kgKu+IWsA0w==
X-Received: by 2002:a05:600c:291:b0:3f0:310c:158 with SMTP id 17-20020a05600c029100b003f0310c0158mr466110wmk.6.1680553499486;
        Mon, 03 Apr 2023 13:24:59 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:24:59 -0700 (PDT)
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
Subject: [PATCH v4 7/9] wifi: rtw88: Add support for the SDIO based RTL8822BS chipset
Date:   Mon,  3 Apr 2023 22:24:38 +0200
Message-Id: <20230403202440.276757-8-martin.blumenstingl@googlemail.com>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

Wire up RTL8822BS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8822B chipset code.

Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
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
 .../net/wireless/realtek/rtw88/rtw8822bs.c    | 36 +++++++++++++++++++
 3 files changed, 50 insertions(+)
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
index 000000000000..31d8645f83bd
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bs.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) Jernej Skrabec <jernej.skrabec@gmail.com>
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "main.h"
+#include "rtw8822b.h"
+#include "sdio.h"
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
2.40.0

