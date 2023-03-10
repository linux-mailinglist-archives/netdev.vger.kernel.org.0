Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9AE6B51F2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjCJUaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjCJU3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:55 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1378B118815;
        Fri, 10 Mar 2023 12:29:54 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ec29so25432014edb.6;
        Fri, 10 Mar 2023 12:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8pZKlejve1428qStCG0RMeVmZ4upKoJrMvi5IlICBI=;
        b=GqtyCN7r9RM6GkJazWR3HFollxvPGavLzejWII2UZyzcFzJwMjMGHZXwEgMhq0a4Lc
         UiExCA8fiiGFczNheebxETAymcsajbRiR82bZ9qkehwUK3IThUTpKnipArWWryo6G/QD
         DR0uFwBHX2ZwfQ0/yeTHpuBP5GiFIcSSAENdcF4b5NG4eF9gjUQTp6mZK01gbvZPU0mQ
         eacQzCPTtb8tDjMkHxA0iAUPPAhEmuePvWnwNSu+JzWKCzjIT5PBxlOSrTaGK35njfNu
         U4PaIwxvloNxCIjTWsvthKxcDVphovp/iSJelFwh4Bt490YcbsUmIJH4nQ6RcEZtRvJ4
         odVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8pZKlejve1428qStCG0RMeVmZ4upKoJrMvi5IlICBI=;
        b=UORemEf0bO5rH6qxpZw97e05kw3QVG4ozp/ei83QjwZJrf4nix5G7zejBD7WJahf93
         8SFfNmfJWsu/sXs0jnxbwcmPYZmZtb8V7xOTTL6L8hi5mCHXSJUyvjtyDYiadX5sDBxX
         XuTouAbt9YJcuqE/W6H3L1nv+rFi7eRb2+INXzPepZRy5dTLwOcqD3ODOIoHRSRAdWdI
         ALhWHH0C3behkHvQVAspjWbqiP8BtdHwIAh2KC8gnmCrFJL+Gb7DBsBMdEVyPoz1EnRO
         PMbvieTJK+dUcgMiWtNNkliUoZTAk0Fgtfb7Ppetk5pPmEWp1LXvXDLE3PH5XBeQoSIy
         L/iQ==
X-Gm-Message-State: AO0yUKWqQV5/79y455XCYAlCFfST30+Ig0w+CQ7oek+agLWxTX4sTJIC
        NPT7FFFzy0erzVIJ6hcIgIHW91IzVeg=
X-Google-Smtp-Source: AK7set9RM0579bjaZEGE6QvGIe2oGLhDMRT3CqhFy8M6d7U/msI1IK0JBp9KWYZLW80huko1gwPSjg==
X-Received: by 2002:a17:906:4f94:b0:8ed:e8d6:42c4 with SMTP id o20-20020a1709064f9400b008ede8d642c4mr26149521eju.12.1678480193480;
        Fri, 10 Mar 2023 12:29:53 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:53 -0800 (PST)
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
Subject: [PATCH v2 RFC 9/9] wifi: rtw88: Add support for the SDIO based RTL8821CS chipset
Date:   Fri, 10 Mar 2023 21:29:22 +0100
Message-Id: <20230310202922.2459680-10-martin.blumenstingl@googlemail.com>
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

Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8821C chipset code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v1:
- use /* ... */ style for copyright comments


 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 .../net/wireless/realtek/rtw88/rtw8821cs.c    | 35 +++++++++++++++++++
 3 files changed, 49 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 6b65da81127f..29eb2f8e0eb7 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -133,6 +133,17 @@ config RTW88_8821CE
 
 	  802.11ac PCIe wireless network adapter
 
+config RTW88_8821CS
+	tristate "Realtek 8821CS SDIO wireless network adapter"
+	depends on MMC
+	select RTW88_CORE
+	select RTW88_SDIO
+	select RTW88_8821C
+	help
+	  Select this option will enable support for 8821CS chipset
+
+	  802.11ac SDIO wireless network adapter
+
 config RTW88_8821CU
 	tristate "Realtek 8821CU USB wireless network adapter"
 	depends on USB
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 6105c2745bda..82979b30ae8d 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -59,6 +59,9 @@ rtw88_8821c-objs		:= rtw8821c.o rtw8821c_table.o
 obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
 rtw88_8821ce-objs		:= rtw8821ce.o
 
+obj-$(CONFIG_RTW88_8821CS)	+= rtw88_8821cs.o
+rtw88_8821cs-objs		:= rtw8821cs.o
+
 obj-$(CONFIG_RTW88_8821CU)	+= rtw88_8821cu.o
 rtw88_8821cu-objs		:= rtw8821cu.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821cs.c b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
new file mode 100644
index 000000000000..7ad7c13ac9e6
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "sdio.h"
+#include "rtw8821c.h"
+
+static const struct sdio_device_id rtw_8821cs_id_table[] =  {
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
+			    SDIO_DEVICE_ID_REALTEK_RTW8821CS),
+		.driver_data = (kernel_ulong_t)&rtw8821c_hw_spec,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, rtw_8821cs_id_table);
+
+static struct sdio_driver rtw_8821cs_driver = {
+	.name = "rtw_8821cs",
+	.probe = rtw_sdio_probe,
+	.remove = rtw_sdio_remove,
+	.id_table = rtw_8821cs_id_table,
+	.drv = {
+		.pm = &rtw_sdio_pm_ops,
+		.shutdown = rtw_sdio_shutdown,
+	}
+};
+module_sdio_driver(rtw_8821cs_driver);
+
+MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com>");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821cs driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.39.2

