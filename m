Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878016D87C4
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjDEUH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjDEUHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:47 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE166E91;
        Wed,  5 Apr 2023 13:07:45 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w9so144018411edc.3;
        Wed, 05 Apr 2023 13:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bp+R7zQ4RuR3/A5CmEUbZnCQbbZRzAWmXQ+x2H2Nqa8=;
        b=EDHQ9Nc5Iomho0GsndGePOSpQlAz/HeGIfX75oWnLOtolzyu/3bPyndHWHabBMU0v/
         VLkcpcBiiEzM4pHW9acpmCvDh5o++dbLLundv++CrmpIAKyUDSzCk1A2bhZ8KP1d/NmZ
         wzqsol8TjCIe+oy4iM2/uqkLXPr3EiwdWUG1wNYOhtAS7SkFM+D3v0O2MwtMjeGxhZPm
         PJHDB+LlBghrkdcrBJt0IEdo/SMtvTpzJEyVEvrj+BRZh/NHz/79Qh1xZWb9lS4K7JkL
         jarxEVtpT/eWwgeYPkjO2fOrGUHA1kh4uSkS7jFTSl8WCk64a77IOwA5nLW95+7fCkMM
         cqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bp+R7zQ4RuR3/A5CmEUbZnCQbbZRzAWmXQ+x2H2Nqa8=;
        b=mTiNolVzLKHQBeng5ZBA81C+3qdnGYwtaPLAF2AvlWBvgISHqGXCS3+oyewSMeuS6u
         1ULHurcqYwAzVHC0TyBTj8oNclJnoZ3TBWt6OTq8AG9IjTVeCSXUOFv3oAQCJaprE51E
         8PnLR67wA9lbe/Zau0vsTSGo0bVF28kr7KzntKBCFH08ETGLx/8s1UInGjdjAZ3hgCk3
         2+ojcdoJDcaBTYCX1PI1WiNtsVoZSkxl8+X9nKsR1f1UO8Af4qGomRgy6mjowr1tm5om
         6wyfXlGUJeRCUCybb0cBMAWl5hpYXVxh4Jey8Fj2N3gP2MCG2GmYRGLy5XIoox8N4T7Z
         KxyA==
X-Gm-Message-State: AAQBX9fCn0W3t0HE2pkBzr09DU9yxi7wME6f1eeBb5KQSLeoM5Of1maE
        0rJK/kvb2wpviQqqSaTwM94FWypYVoyWPA==
X-Google-Smtp-Source: AKy350aJaRzcxWx466aJV8CUIQrQ67VRFmjWgNcv1rDUk0ZyQiHDJnVL+odEQVLyHVkz6jpkH2a6Jw==
X-Received: by 2002:a17:906:c2c2:b0:933:2f77:ca78 with SMTP id ch2-20020a170906c2c200b009332f77ca78mr3967185ejb.28.1680725263699;
        Wed, 05 Apr 2023 13:07:43 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:43 -0700 (PDT)
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
Subject: [PATCH v5 8/9] wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
Date:   Wed,  5 Apr 2023 22:07:28 +0200
Message-Id: <20230405200729.632435-9-martin.blumenstingl@googlemail.com>
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

Wire up RTL8822CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8822C chipset code.

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
 .../net/wireless/realtek/rtw88/rtw8822cs.c    | 36 +++++++++++++++++++
 3 files changed, 50 insertions(+)
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
index 000000000000..975e81c824f2
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "main.h"
+#include "rtw8822c.h"
+#include "sdio.h"
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
2.40.0

