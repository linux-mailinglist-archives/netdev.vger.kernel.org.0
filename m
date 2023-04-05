Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D1D6D87C3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbjDEUHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjDEUHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1803C38;
        Wed,  5 Apr 2023 13:07:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w9so144018266edc.3;
        Wed, 05 Apr 2023 13:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnjA6FBr5/rFqhbLZa5joKzrXi8wr1wtK3tAaRbaMeo=;
        b=NcWIrwol5kVuBGZdfBFpO1qDYBl4DdF+znAvSTCs1aZSB701zllKHUWuEmAjfDSVC8
         oBUm7k4mgusG+o9O+cQmHfGCp9orqKfhrO4G1t/6Y7VagVNaqD4Y5wkrioLrGaRGCgUm
         mau6xr4XA2P21iwvVAM7VOLyWrJrX5OfLfJ8KMOitDKVUdM009qcUDDUgZQAhXPHvquY
         VCF3Ua0P/k3VZQLYoVrSjp0iWq3c7EDhlc/IkIQT3/TSbSgReNJ0YTe0Ezi2bf9+Kt6C
         gChXCoJ9YDqkYhLhSHNZHLJ1VGibX2eztsTv1fpaOHRcfksO+4n0laNeqgXgg9BcLxfZ
         VtVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnjA6FBr5/rFqhbLZa5joKzrXi8wr1wtK3tAaRbaMeo=;
        b=GUW29XBiHK9SCP1+SMTJrafCslbAty1HpAQnTRDxsirsn7w+fdJ+SpmZAzWgoMOOy+
         IYMwErRkFgprp+o4tK3HZFNTQ5lUrl5oUoxdx/GWvod6jG2aBPeTWFC8UOij6sPd+RLn
         CKKkJEbZW6aXUi4/5gfmWwaL1Gz2XRe8qCqUlNqRC4cxlx14zcftiOeyQdcIzmOlee74
         PyHRKGEbYO23mQNEw88202yYGqSYtj+YOGb6cN44knF0oGjfK22dBXgxBxVuCI84BIst
         Nmv+wD5pX8q7nQQnz3G4GhcSob4Pb6WrhAa7oMhdDpwN2UBsTtbUZIrNHpokLnXUCS+0
         Up7g==
X-Gm-Message-State: AAQBX9fIofBuWBcwR1b3f2Mx4RzU+Y5FkQ23r80cPSAN2hJNGZ9q5R6d
        Wn1mwEbA/KEub1G7+KlpwbPwY4GXBzxdxg==
X-Google-Smtp-Source: AKy350aWOMv5anM5JoLBIJ2i/Ev2vSC7l0HoHW8T4J1AWOUMIV9pSJniJmxeh9cD1elIZHSmhoyVNw==
X-Received: by 2002:a17:906:2acf:b0:948:b667:e984 with SMTP id m15-20020a1709062acf00b00948b667e984mr3896378eje.27.1680725262896;
        Wed, 05 Apr 2023 13:07:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:42 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macromorgan@hotmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 7/9] wifi: rtw88: Add support for the SDIO based RTL8822BS chipset
Date:   Wed,  5 Apr 2023 22:07:27 +0200
Message-Id: <20230405200729.632435-8-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
References: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
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
Changes since v4:
- none

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

