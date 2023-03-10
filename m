Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9936B51F5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCJUaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjCJU3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:55 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9405B11880F;
        Fri, 10 Mar 2023 12:29:53 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s11so25417088edy.8;
        Fri, 10 Mar 2023 12:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72WtqG0+vnMEFpCrkfHg3PJtuN3M4VluH6MP9rrJ3h4=;
        b=WkmHqfHpqC+lA+QimyYp+n185h9AJ9904POoOGwDrSr+7AGpnG59t/KKgffNZJkiRs
         c1eGR0rj44Vf4xY8vmjhx6sXGVmv3Nf4ekW5QZNr3d8d9qX/c7kq1zwvmqFsgKdNxCMd
         PITVjMLd8yaql2akPxuf66SfkR47XK6dMJ7otqM1ClybFoYAtS3g6SxLouDKtBhHcxFB
         SDFYjIzBziqYtVZBiySTkzEav5pzoRaOfetWKqPe3dFJ2KSBlm/9suVi3IecbKueiHIh
         UGY4lE4aNFhz9Qe+yvHRzpRVv1gh7NQJ4anPuJ1twTXlmaNSvjaPnilMf7oDW8naaVYS
         rBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72WtqG0+vnMEFpCrkfHg3PJtuN3M4VluH6MP9rrJ3h4=;
        b=pCq3mKXFwmgNtYTCGRT3XyOdgxKSAvrpp9eC5WR32Uhum8WuMazkTAOuIEpOtYGv1r
         D1DmqloZPP8qhuTL13SjfyATyM2pfHMxlqQ6XmEZpYye9DRlZxMN7JJhLgIaplmCXu92
         8Bkx9oKmf8yDlrP9I62L7OhP7/nRfTYjRuXvVAhCS0hdAIFX9VUwJojv37cvuIY7TFeW
         ar+ZHeyc7qqPfGwiYQBPLCBxgmTtjBz6Z5NUCT2+aKwmFaQoGMjL/Dtw+zeIijZR1uu3
         siqV+V+ormK0iyXm/bH/80vy3xtUENHwBfq6PZOMm3q6Pp5lm+VQ5YRIvfP/61dlPIUl
         lvEQ==
X-Gm-Message-State: AO0yUKX7AJZOeo0JPRuRee3dITIt2PfNnpfmRtG2MwxZUVEKyc4Vdwt5
        JpuP6vL+XrAum7AHhNcMG3ax5VpkFe8=
X-Google-Smtp-Source: AK7set8B3NdjiLpt+D458HcmzbqBUhgvDXJLC9ZR9evV7RhHG3amnrJvmDUpmVj3tOzSusKpZMyR9A==
X-Received: by 2002:a17:906:b88c:b0:8cf:fda0:5b9b with SMTP id hb12-20020a170906b88c00b008cffda05b9bmr3477171ejb.22.1678480191751;
        Fri, 10 Mar 2023 12:29:51 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:51 -0800 (PST)
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
Subject: [PATCH v2 RFC 7/9] wifi: rtw88: Add support for the SDIO based RTL8822BS chipset
Date:   Fri, 10 Mar 2023 21:29:20 +0100
Message-Id: <20230310202922.2459680-8-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
Changes since v1:
- use /* ... */ style for copyright comments


 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 .../net/wireless/realtek/rtw88/rtw8822bs.c    | 35 +++++++++++++++++++
 3 files changed, 49 insertions(+)
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
index 000000000000..76645e7a6bc7
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bs.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) Jernej Skrabec <jernej.skrabec@gmail.com>
+ */
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
2.39.2

