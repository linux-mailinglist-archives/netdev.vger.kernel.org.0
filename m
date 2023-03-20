Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CED16C23EB
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjCTVhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjCTVga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B041554A;
        Mon, 20 Mar 2023 14:35:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cy23so52242396edb.12;
        Mon, 20 Mar 2023 14:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xcee6Xz8r8Flo3g57XPt5CCbkDvJlGcwG5+IRvVtSw0=;
        b=ZvBgt7EZxDUhII+m81ZtLolKmHjkR3MgtNGKIdeXj0zfy7Mt+VQ36m1+2U9MpzNuLy
         k9O4RfWxNhmHcnEi+9QyuogJhRjel8v/Z4WHOH6rhWoYNtZXz3gscco9JdkbvwrnofZp
         ZEUkrsDQC6JBulqSkL+vdMENJ0bFKGJCmUA5vjHhZCOl5AxYHYkyon7wZe/IFYyfprX6
         6akclTka2oe3k7IcWS3uMkjiXXxVF7lIbIl6q1pgFP/CjgVpNkK6L0Sr7MUhtCmsLD0C
         8B4/jSl4w2cjyb11toaR/gcBPoHqmACTKwMGkAHfwvIURx0aWdiNIwZOneRdi/9+kMWe
         FbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xcee6Xz8r8Flo3g57XPt5CCbkDvJlGcwG5+IRvVtSw0=;
        b=hL/I9mxFzQb9YwkBVs1vyQua6YQWQYqw6287dckxeS+ZhHZLvfNFMQMzG2yWfXLdZZ
         4KE7CiRgBLYBdJ99mlouNk35KUR203m2BRX7rw8HOqudIsgWElNnWCTalEy69ZR4VXjf
         3cbuMZ245JstX4vNygZCMXzp5OPz1mPUWGv/2z/xNUeQMhs82V9jtxFu7XRf+WdpnOOg
         /aeO9LzEcdY85CU+LptPJsy5a0kRD5HwN7LgRj6lTmvObiqCEn3BdQq455MHKftdYqJH
         hWeGC9nUx2JJTdiihOv30l8ssukj3VfvZ8MvD8g7HMMlxtLOaYG9KkilVUmSlMOWbpfi
         eE7A==
X-Gm-Message-State: AO0yUKVEcxXQsf1u8zrSQ9VbR9JOyi0b5mecfsj0f15rEtbvyWHQX50f
        5dWoavegrdemjSmhaT4nFydsxWaiGU0=
X-Google-Smtp-Source: AK7set+Vw5eEA8z1vlAMmoeB15w4d1gb1sn63IQlubG4Mfy62/gH0MeFYtlfevodH8J2gvxNDYRg6g==
X-Received: by 2002:a05:6402:114d:b0:4fe:9374:30d0 with SMTP id g13-20020a056402114d00b004fe937430d0mr906743edw.39.1679348129274;
        Mon, 20 Mar 2023 14:35:29 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.28
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
Subject: [PATCH v3 7/9] wifi: rtw88: Add support for the SDIO based RTL8822BS chipset
Date:   Mon, 20 Mar 2023 22:35:06 +0100
Message-Id: <20230320213508.2358213-8-martin.blumenstingl@googlemail.com>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

Wire up RTL8822BS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8822B chipset code.

Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
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

