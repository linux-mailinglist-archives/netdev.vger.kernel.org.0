Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E216B51F6
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCJUaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjCJU34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:56 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393EF118825;
        Fri, 10 Mar 2023 12:29:54 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id cw28so25457731edb.5;
        Fri, 10 Mar 2023 12:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40umXtXsxbekuBH113oFvL37RvGW89qIxw/va4fYZ3g=;
        b=FvsdRI+X9p9TR+9ONWNwgfY4huS8PeOK+QkWbO4scGNFTH3DoAs4mh5pZLiUkN1n2w
         N+dN8PlkU6UronoX6BR0vhqBP9b++gyXZ5K2rm+cWVxkX+6XOP+T84qxH3jhXWm6ovTa
         0CsxYmnoQZyBpMQ4+qiQF/C+wTWi/Y3MKtVn82Aw2+GvsXRt1gbLwPaql21ymKSuyQeK
         o0d/PMWgdezDcrtpuE4bnpipXHs3WGPzoyNubkSC3hyKL3ko4M3KLVjCCY23TMwF/HLG
         fr8MV/IwcrAo0hYsEDRgkb8lP42MnbAWpQxvBnBBZaAV71KMpgkZPjk8P/0isMuRtqNu
         AbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40umXtXsxbekuBH113oFvL37RvGW89qIxw/va4fYZ3g=;
        b=Ck07YLCUGTMJwm5bZTI+Mx68KHbDwIpjP9zb6TY3+8kB+CJFr2AOmLvMTMeW/Wx02/
         ANioHz8aWqKFl3R7hisHKNf91cQ55yBP5HxyscpHF8iFnM9kuWD3gnCQJzZDps/1JiL8
         zeQcf8aMeZQ2lqjwcldGzvmHkwf5y+Jr5301Y0aRJHXPCe2PIMNyZicjzfPw0w8bzXk4
         iEBThJv8wuBIub8ZuKTrCX4pG7Ht6OnAvY1j+Tc2yT6Tf5udNt8T4zQKLXWZ7ebF7dHW
         2GmdPiVa7OBI1b21cvlImzjcNB+mkfFIKzhtpHqiOmWJftRuKH/3YKrtlN7caxhr8rFg
         b1LA==
X-Gm-Message-State: AO0yUKWLyoqkF3V2hv/BJnyYjWzyFXU+2nUubpHLGD2yOal8zURLUv9X
        aczZtZR6Z4yYC7Bgskp52WoSNSGEdxE=
X-Google-Smtp-Source: AK7set+A4PPh6FAFiOZRL2w/y4xVvRvTUJ9Y9+4vfuCU2IlAlIAfw+w6h9h6UmPxVz67k5ACXkRgew==
X-Received: by 2002:a17:906:3044:b0:8af:2f5e:93e3 with SMTP id d4-20020a170906304400b008af2f5e93e3mr2819712ejd.29.1678480192627;
        Fri, 10 Mar 2023 12:29:52 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:52 -0800 (PST)
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
Subject: [PATCH v2 RFC 8/9] wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
Date:   Fri, 10 Mar 2023 21:29:21 +0100
Message-Id: <20230310202922.2459680-9-martin.blumenstingl@googlemail.com>
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

Wire up RTL8822CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8822C chipset code.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v1:
- use /* ... */ style for copyright comments


 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 .../net/wireless/realtek/rtw88/rtw8822cs.c    | 35 +++++++++++++++++++
 3 files changed, 49 insertions(+)
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
index 000000000000..db8984b67f89
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+ */
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
2.39.2

