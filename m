Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4EC46FC8A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 09:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238402AbhLJIXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 03:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbhLJIXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 03:23:02 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DCDC0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:19:28 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id v19so5781430plo.7
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fiJPYf6H6wZ8S6m4+bMfnKs750o6XkD8svvPAd3zlBI=;
        b=dtzzcA8Xld4+Ox+XPzjrCw9psaAUni/Zg9OLuhMgHN4pyfHJGYcEn8KWWeybRA8MS4
         4S+9zSVnlOMMV9/Bis8ylg7Zd9MWjwOWdx6aDFIlTt8W6OcnaU+3ahz0R5qg73drGObk
         UaOxmjSwwoccde4fv0j+18WsQjSXVdU7dFPE1xP5N+gevxbsSr9ztIEHedeO84CCK/oe
         K2D0IVoxH7vfKrLTQTMPJ1sXRBGo3Fh8mbQuMCjLGgVo96NzDbTWFUylbJrbJzaApmRW
         fEG4OOQeJk8C7p+nbSDtuXhC8crJOa2UDjlYehEG8djP4in2OelBTllFbhweFGqERARV
         pFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fiJPYf6H6wZ8S6m4+bMfnKs750o6XkD8svvPAd3zlBI=;
        b=BaaQE0cxGH09BYCEUPvpZa+qioPfGGJwXRfZCvqL0ymoxJ0+tTGqduD0zB8y6X9KYM
         qzw44axexfF3k1Rj+FQLSBe0dxdI8y71QHUt/VXI5DmivymvcqtOcONjv+VOW4goBkLU
         kNR4UeChsRBH/9jOODoYuI5zg3+7DuvVoHK8SKI+pRv7uwiUVgPmX36Kb6GOuNssDmEJ
         iVOp0gHy2H22lrOGReiUIB0PhtfSBllECwg/6gQoz6RpdbRy/Za52aBh1nxiZAALCI/X
         iTG5ChB9kQesNf6qxvXzvsAsDw7Ga4EyIe5jsZSIcdE6CrmwVvrmp6nddd1l/1bwcrtZ
         CrpA==
X-Gm-Message-State: AOAM5324Dk9sDD8n73b3RzCMkPT0daN72wDvkzIaiNM69qIb1+HXbgEx
        8X3ww/1NjECmIta/ioH0D8npsQ==
X-Google-Smtp-Source: ABdhPJwAUYZ7yO9fwT+I0qQYkftVCpkpMn6gLkhPeLxKFAg1pZZsBil3vGxzFmubvPDBEMm9HInJZw==
X-Received: by 2002:a17:902:d4cf:b0:141:d36c:78f6 with SMTP id o15-20020a170902d4cf00b00141d36c78f6mr73935087plg.56.1639124367495;
        Fri, 10 Dec 2021 00:19:27 -0800 (PST)
Received: from starnight.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.googlemail.com with ESMTPSA id 38sm1827099pgl.73.2021.12.10.00.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 00:19:27 -0800 (PST)
From:   Jian-Hong Pan <jhp@endlessos.org>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
Date:   Fri, 10 Dec 2021 16:17:01 +0800
Message-Id: <20211210081659.4621-1-jhp@endlessos.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More and more laptops become frozen, due to the equipped RTL8821CE.

This patch follows the idea mentioned in commits 956c6d4f20c5 ("rtw88:
add quirks to disable pci capabilities") and 1d4dcaf3db9bd ("rtw88: add
quirk to disable pci caps on HP Pavilion 14-ce0xxx"), but disables its
PCI ASPM capability of RTL8821CE directly, instead of checking DMI.

Buglink:https://bugzilla.kernel.org/show_bug.cgi?id=215239
Fixes: 1d4dcaf3db9bd ("rtw88: add quirk to disable pci caps on HP Pavilion 14-ce0xxx")
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
---
 drivers/net/wireless/realtek/rtw88/main.h     |  3 ++
 drivers/net/wireless/realtek/rtw88/pci.c      | 33 ++-----------------
 drivers/net/wireless/realtek/rtw88/pci.h      |  5 +++
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |  3 ++
 4 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index bbdd535b64e7..31cd427a0949 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1259,6 +1259,9 @@ struct rtw_chip_info {
 	const struct rtw_hw_reg *btg_reg;
 	const struct rtw_reg_domain *coex_info_hw_regs;
 	u32 wl_fw_desired_ver;
+
+	/* quirk flags */
+	u32 pci_quirk_data;
 };
 
 enum rtw_coex_bt_state_cnt {
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a7a6ebfaa203..0a858db2d515 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1702,14 +1702,9 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 	netif_napi_del(&rtwpci->napi);
 }
 
-enum rtw88_quirk_dis_pci_caps {
-	QUIRK_DIS_PCI_CAP_MSI,
-	QUIRK_DIS_PCI_CAP_ASPM,
-};
-
-static int disable_pci_caps(const struct dmi_system_id *dmi)
+static int disable_pci_caps_by_chip(const struct rtw_chip_info *chip)
 {
-	uintptr_t dis_caps = (uintptr_t)dmi->driver_data;
+	u32 dis_caps = chip->pci_quirk_data;
 
 	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_MSI))
 		rtw_disable_msi = true;
@@ -1719,28 +1714,6 @@ static int disable_pci_caps(const struct dmi_system_id *dmi)
 	return 1;
 }
 
-static const struct dmi_system_id rtw88_pci_quirks[] = {
-	{
-		.callback = disable_pci_caps,
-		.ident = "Protempo Ltd L116HTN6SPW",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Protempo Ltd"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "L116HTN6SPW"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{
-		.callback = disable_pci_caps,
-		.ident = "HP HP Pavilion Laptop 14-ce0xxx",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Laptop 14-ce0xxx"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{}
-};
-
 int rtw_pci_probe(struct pci_dev *pdev,
 		  const struct pci_device_id *id)
 {
@@ -1791,7 +1764,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
-	dmi_check_system(rtw88_pci_quirks);
+	disable_pci_caps_by_chip(rtwdev->chip);
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 66f78eb7757c..f470387fbb9a 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -274,4 +274,9 @@ struct rtw_pci_tx_buffer_desc *get_tx_buffer_desc(struct rtw_pci_tx_ring *ring,
 	return (struct rtw_pci_tx_buffer_desc *)buf_desc;
 }
 
+enum rtw88_quirk_dis_pci_caps {
+	QUIRK_DIS_PCI_CAP_MSI,
+	QUIRK_DIS_PCI_CAP_ASPM,
+};
+
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 80a6f4da6acd..4d684534fa1e 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "bf.h"
 #include "regd.h"
+#include "pci.h"
 
 static const s8 lna_gain_table_0[8] = {22, 8, -6, -22, -31, -40, -46, -52};
 static const s8 lna_gain_table_1[16] = {10, 6, 2, -2, -6, -10, -14, -17,
@@ -1947,6 +1948,8 @@ struct rtw_chip_info rtw8821c_hw_spec = {
 
 	.coex_info_hw_regs_num = ARRAY_SIZE(coex_info_hw_regs_8821c),
 	.coex_info_hw_regs = coex_info_hw_regs_8821c,
+
+	.pci_quirk_data = BIT(QUIRK_DIS_PCI_CAP_ASPM),
 };
 EXPORT_SYMBOL(rtw8821c_hw_spec);
 
-- 
2.34.1

