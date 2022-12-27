Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C564657148
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiL0Xdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiL0Xc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:32:29 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9750EE10;
        Tue, 27 Dec 2022 15:30:55 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vm8so28079904ejc.2;
        Tue, 27 Dec 2022 15:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AaBWOz6R05ieMR55ZX/qfxc7kxYQIr83caCYQIdZus=;
        b=OT5WMy9MXt3DOYfq3J7NDT2QccCBOtwhk3EFywa2zk7PnToDkIVzcaKsO9l69DtElG
         +mkgSwIDU8YdwUMOge9xCu3thxgF3daUp1u9dKkNC4bCyl7nP1I6bMh+Dw4mYTN6g7t2
         f9+311qoArRgwYOnmzh+4zOzH/x1SGjP/qrHylxHZ5S/+X/XElb56sc6kSvxKnKMc/L9
         NfbQS5DRXbbHLpxLewXny1HpO3Xpt3bqvGd3gtqRirbJ9SLGIdL0nF3Azvo8wmXIHkif
         t9O1b7qnNLMLKu0cw43wgXhbiV72PVsC0IHD9L2jpE1SfPNiHeF1+k0UGRImNoGbFu/T
         J5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5AaBWOz6R05ieMR55ZX/qfxc7kxYQIr83caCYQIdZus=;
        b=tC94sjVPyPLBDEbDrJuj18IasmHZvvjJq9ZhdOop5YTqWuUu+loPcHj+g2NSUQNVwj
         Lxw1S/13LrW5zhYZHTXq8iJnW6qIJmFePFlyh0+t+N9ghvVefkA0v3Rp0Aw0R4lvl0+D
         aP0Io8A4MvZkDJJDBMcU1GWPZD+zKZbsdpdjKnqtr0joIHVvqutIxjNaQvNDSMZKYHYz
         C+JFyxnHhNuE4BuPe/bjoRmh8mtpdYqm9PhspRkN7qMVa98rgc7fJgvyXQiXCCQTV+Ei
         iwr+IBP4BRF8TsitWPtxQVPZTEogwmjrPBhvan2jl03UZ08NuTE7Qpt9NtpN5pfZoIeZ
         AxMg==
X-Gm-Message-State: AFqh2krOdmXtpx4JJmMEPG48l9aoWY1sDOsm4zqszFKiDNXByhcj+Inw
        zXr12xKktxisyzocHVdLoJXuNuwrxTo=
X-Google-Smtp-Source: AMrXdXvwz3GwTcCXjYIjOMdJ1PkM7hwikq8jAcu58QKAK9t2aunLIrzVkZObcJP4vQa1kLd9N3Nsyw==
X-Received: by 2002:a17:907:b9d5:b0:7c1:f6c:dd4e with SMTP id xa21-20020a170907b9d500b007c10f6cdd4emr19583149ejc.40.1672183853344;
        Tue, 27 Dec 2022 15:30:53 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:53 -0800 (PST)
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
Subject: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based RTL8821CS chipset
Date:   Wed, 28 Dec 2022 00:30:20 +0100
Message-Id: <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
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

Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8821C chipset code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 .../net/wireless/realtek/rtw88/rtw8821cs.c    | 34 +++++++++++++++++++
 3 files changed, 48 insertions(+)
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
index 000000000000..61f82b38cda4
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
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
2.39.0

