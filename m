Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DE56D5272
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjDCU0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbjDCUZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:25:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D85D449C;
        Mon,  3 Apr 2023 13:25:05 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m8so6893622wmq.5;
        Mon, 03 Apr 2023 13:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680553501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ssoqo4YNW2wUtuKGulU3BLwDG5aJiVVqHT0tabCw2e0=;
        b=A0JYY4Tl/J5h3JTqzzHWcbr7R8McVX7+0xBa+TsAD0ehDmuxCrMCFbCfdaNhu3gOpe
         mKCSRYGyWlCNElQYItJDYYu1eAVmoMs2Qv1fNbPf4SQcKZ4ldbdwK/FSkKIrft6ZvVuB
         K07PKKlrmgjZQ2Idotnq6Wt3WH5fkyZks+DFwZySRpHnLLGmt/qz50b3ES0uWluTW+Y+
         vrHVnF6y4Nj86eCHVwd34BoWix+wT7fZT4bsfDDfJb8Nt/QbEg0T3eyg5l8DexXsjkhh
         uoB0YrC3aC6ujiJto0O/CoUn26y0mVaX69i5nEzlJI5n2SntpHy+xSv1Dlh52EL6svo1
         7XKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680553501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ssoqo4YNW2wUtuKGulU3BLwDG5aJiVVqHT0tabCw2e0=;
        b=Pzmdz6ezSqfhSi5+C9rSHD7Dv8Ra2LmwftTPoPNOacM73C2+S273/BahbqQF1mmtss
         WxkeXT9r4KKXn0rMjAwi0GhtWSWHo16zjAHM7UyCCB4EOhQ2skHh0hNjiJpH6edIoGCi
         KwCM6FF+xJpyDKnqBhxv30A5k6PW6hoHDt+k1BkIXZVzfDz2AuGqKHgE1LuZ9RnX7je+
         5+YUKY6SH2BmNXkCo7wanSCkS2ShownT5GGNryl9FVHrqRfi3R3FAbz3dD9LVIwP7Kz9
         s0xf+eO9XirG87TIpqv59EwP6OanX8vi8Az5fKQpkNnN/2VLk2qdjpGM8W3TvXGdkmH6
         LOzQ==
X-Gm-Message-State: AAQBX9epjHM75S9B/TzqHBb1kCqwdcg96O+CShuX5mmJBEQE1Lq7viSO
        MgJoieavS5MvWk7ML0xj6Fq35OD3ulo=
X-Google-Smtp-Source: AKy350Z5pYWPzKnZFA4aDEip7R8411g2T9a//7m2W+5x+iH4Y/jj2J6qylR88ao+1+SEAS7D5V8mFQ==
X-Received: by 2002:a7b:ce85:0:b0:3ee:2b04:e028 with SMTP id q5-20020a7bce85000000b003ee2b04e028mr481838wmj.14.1680553501455;
        Mon, 03 Apr 2023 13:25:01 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id 24-20020a05600c021800b003ee1acdb036sm12845895wmi.17.2023.04.03.13.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:25:01 -0700 (PDT)
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
Subject: [PATCH v4 9/9] wifi: rtw88: Add support for the SDIO based RTL8821CS chipset
Date:   Mon,  3 Apr 2023 22:24:40 +0200
Message-Id: <20230403202440.276757-10-martin.blumenstingl@googlemail.com>
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

Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8821C chipset code.

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

