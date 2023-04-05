Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6E66D87CD
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbjDEUH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbjDEUHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:47 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD946E8C;
        Wed,  5 Apr 2023 13:07:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b20so144001158edd.1;
        Wed, 05 Apr 2023 13:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2m9p+FRmzgHRmHf5Lbo/LbUxLiQP4mb5MuVlMrvnp4=;
        b=TXHzzNF/yToxRdahTj9dMSLBkvRc/AhpU0TftUAOZceSYagL70XSscjcrfcksCnbeb
         JLjl4/p8d5sJX9KoFDkZJMFdl0Y97kzCWuwvTA2Dga+P89sJ8XNbjAtwLlaMRUmie8IA
         yc2/MLmW0qyfs1iceujDgYSDzCXmap5rsRohpBNGHRrG7SZozmIn9MiqTy//EB/Q6jXl
         fSO1bo2+n/PsUCkIol1NPjxDmAfPz8EjjpaAQ6TNLkdNvnmh67njTDRNDbBVn+jAyt+k
         wsU94Kld1XagijKkUdPbd1pmAMeZio/flEUr6T4/u9mPGkjd5v2CzWso9TKQAaW77qJu
         BKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2m9p+FRmzgHRmHf5Lbo/LbUxLiQP4mb5MuVlMrvnp4=;
        b=7zX5gt/ZV8pe87KN3YLxth8lLQrQPCg6HvEczvrf90gpukqD6XDBW5s/BpdOG4I0hO
         Jf5HBs6jTOpr8TKV2ebBCfkzIGxdoFB1+9x/fbdtTIT2wUfN5EQfZn4zGkSoB4nS1ffS
         QA7mhzr5n8dMC+8h21Uw07HUptt8lU0o6RhCAcsreF2wSyw38dPh+JeFhA18cAX31Xf2
         eBNOD7whgAYOwoUzEohUC6xOszFVM/7bsPC+7qBYMvrn+/OxnHRXb3JoGlMvj2+P2CDF
         4ZdUMohP0bTRxTZyl1dxyRaRf7KuL3/kf4DWYb1iCmO8jxFzPXkfqrdkl9H9SqrtDJtH
         W23A==
X-Gm-Message-State: AAQBX9cQCAlDJAdZswqMSr1g/op/2ue6MgOmMYSqiEq5X5qchswyWmSq
        EyV3P5iTAmMpPakOM7JC5ZtyjUMLH2P5Zg==
X-Google-Smtp-Source: AKy350ZBOOssw7a/+nfMhIKBLsf8N4pU6mnBL+gyZar3LcnDU7BF22Q/COFNvy7xP/J1cUrGbbyeMQ==
X-Received: by 2002:a17:907:8b8d:b0:931:c7fd:10b1 with SMTP id tb13-20020a1709078b8d00b00931c7fd10b1mr4806668ejc.19.1680725264624;
        Wed, 05 Apr 2023 13:07:44 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:44 -0700 (PDT)
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
Subject: [PATCH v5 9/9] wifi: rtw88: Add support for the SDIO based RTL8821CS chipset
Date:   Wed,  5 Apr 2023 22:07:29 +0200
Message-Id: <20230405200729.632435-10-martin.blumenstingl@googlemail.com>
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

Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
well as the existing RTL8821C chipset code.

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v4:
- add Chris Morgan's tested-by (thank you!)

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

