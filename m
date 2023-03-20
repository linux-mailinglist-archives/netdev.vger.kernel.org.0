Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93686C23F4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjCTVhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjCTVgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:53 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644D426CFC;
        Mon, 20 Mar 2023 14:35:45 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x3so52293313edb.10;
        Mon, 20 Mar 2023 14:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRUPutZwNWZYPrEdHD3f1bxNn6Sbt826jZtmdfwtuO4=;
        b=EZaHlDkDdBUQlLo202RLsbkBx+FqP9Je3xgomDebJzgbmwZjIND/+H7gqyF4g+5SUH
         JqdvcUWhhGCXLci2T67q6gOsAjkpKhXDihEqMe5IlUp/I/V67XF832TbnqTmG/Kb8tgq
         53xlKqfsMTvUg9a+0k6Z/RW9NVOdwLQZ8tzuSgJRJxMDk7RUHTYU8qyo7O8e/IWP+Ltb
         K33vf9rvW4xKB8tuhfLS/dx6n5L4J6bOyu6BnV/JbaJmZICBEUWhwY53YHbV5ns6hv4U
         eCEnVoUm0fBddpJWFURJjtFjkP4f8UbUM3asKuDCBcFv+mb3JEwrkRR4p7qxWz7fsMek
         /iDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LRUPutZwNWZYPrEdHD3f1bxNn6Sbt826jZtmdfwtuO4=;
        b=CbuLkeQUolnCYEz9HThP5dQJZkmTfw5Gtt2kMKka/Hurm0CYQVy0VUJbZNRDarMD1k
         le4yIofMNpcdRTJinV6DBQRpdkiKZxVBTLPxAGwLrpStZmod5/qSNC05tPHXUTn5Z4Oy
         35efDROxWYYDdeCuIeEUGPuX4m8TVfam1h5qsNDIWjz7docW6RPVshFNd530dJf7xXdo
         a5T8XAAH9i0YuK3+3XA+EQEFqSORmRxNJovcv8FOM+g0SRZrbpWnULyFg7O6dJOkSVQi
         X97Sy9Y1pqN3mPGPY1uIdAx8b2BAUozwLdiU1anEmnDn69oSxCfa5suxSP8fXHCtPQp5
         JtLQ==
X-Gm-Message-State: AO0yUKUQ4d+uTyIQIBejOmHNbXnyZEiuTwePytrH0bpQoyJluCcCA+x0
        VKhZE59ef9fjEUHlLeFD8fnzv9h391s=
X-Google-Smtp-Source: AK7set/taZhkIbhZ6VFy8gpVNGzgOUL+BlWY2PH1Hl9PmB/za6a2jleDoLUChmhenKP5msWXNsyFMw==
X-Received: by 2002:aa7:c242:0:b0:500:5627:a20b with SMTP id y2-20020aa7c242000000b005005627a20bmr1095338edo.1.1679348131208;
        Mon, 20 Mar 2023 14:35:31 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:30 -0700 (PDT)
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
Subject: [PATCH v3 9/9] wifi: rtw88: Add support for the SDIO based RTL8821CS chipset
Date:   Mon, 20 Mar 2023 22:35:08 +0100
Message-Id: <20230320213508.2358213-10-martin.blumenstingl@googlemail.com>
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

Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8821C chipset code.

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
 .../net/wireless/realtek/rtw88/rtw8821cs.c    | 36 +++++++++++++++++++
 3 files changed, 50 insertions(+)
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
index 000000000000..a359413369a4
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "main.h"
+#include "rtw8821c.h"
+#include "sdio.h"
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
2.40.0

