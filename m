Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF0029D684
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgJ1WPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730978AbgJ1WPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:15:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5C9C0613CF;
        Wed, 28 Oct 2020 15:15:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e15so617255pfh.6;
        Wed, 28 Oct 2020 15:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ocxFtg8A0KwULRID7o8Oiqt9sWxa5tw0cXhwztdaM1U=;
        b=dZCseKhewWe+HqzTBXdKeyG6gzR5nLhrHD0ZVXG08fhArzeno9/T7b4bkDypo7DR+q
         zO2mXET29blZu0W6RoNo2a0W0Xhbrfsh0hujyI+zwXETiuQDi+jtKDl9vCxN7SVVbff5
         c4UTeoqIFmlquJ9zvTDoFG633GoHDvk2/tr20+EF7o3qAxUGoMDV9rFfLuP3TPUXhMp3
         Vv9Z4DgbC7yMfPIHvHgZ/gsQyMC/b8+nOpJzaFpBlAHLG+dn6mBo4pob33UfrNvg0l7z
         8Q51J85Ru6wYtq/8ZZGYg6Ztoj1NXHR3WNbpJFAU/YxzY+Fos3mm36KLvC85KHwDYtWT
         VcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ocxFtg8A0KwULRID7o8Oiqt9sWxa5tw0cXhwztdaM1U=;
        b=syKJKhdt+JNT76Hgj8q4M1ULVZ6ZYuGC708RY03tLBxFe8KW30vhZzC8mIKn6vhWlc
         GPPC95qgQ7N8zvHRQ/Yw70scnqo+btVpbIjI9Ppx+Tn4nKyQmMOwPDwt2snOZqV7uVkN
         oygATHtvv3QOhln5FDsScoSIcosPmE1CXkO254l01AOgNZV5KR8tvD6zcGAkqdxQBjiU
         4Odr/T6ojiqwUUHwbXNkLi1YE3Pqhpxsc8gWTZTt0UYK5bGpO/T9OWbnh6zW8TKvDnZV
         X3dR4v1OM9TV2n0DhYKNVPtc9NZ0yfev9O5lHJsjGWYShUi4poxp8slF4TrHBjW1hqCT
         JW3Q==
X-Gm-Message-State: AOAM532BENJXTC9TBAAZVEqFkhjMWwCCdOFjeDNGzFhRYvQw39YZxsOS
        HhJfUQMJqg4a5XNEnzjqdqSdzl8IPZKz/BlM
X-Google-Smtp-Source: ABdhPJxz7zFzCJrzIBjaAaSCT2wNHuc13SjWZYUOLY43sL3EhM+IEahD44ByiPxkMqyy2iYhCYxlqA==
X-Received: by 2002:a65:47c2:: with SMTP id f2mr6742686pgs.4.1603895307406;
        Wed, 28 Oct 2020 07:28:27 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id g67sm6581754pfb.9.2020.10.28.07.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:28:26 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [RFC PATCH 1/3] mwifiex: pcie: add DMI-based quirk impl for Surface devices
Date:   Wed, 28 Oct 2020 23:27:51 +0900
Message-Id: <20201028142753.18855-2-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142753.18855-1-kitakar@gmail.com>
References: <20201028142753.18855-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds quirk implementation based on DMI matching with DMI
table for Microsoft Surface devices that uses mwifiex chip (currently,
all the devices that use mwifiex equip PCIe-88W8897 chip).

This implementation can be used for quirks later.

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/Makefile |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c   |   4 +
 drivers/net/wireless/marvell/mwifiex/pcie.h   |   2 +
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 114 ++++++++++++++++++
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  11 ++
 5 files changed, 132 insertions(+)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h

diff --git a/drivers/net/wireless/marvell/mwifiex/Makefile b/drivers/net/wireless/marvell/mwifiex/Makefile
index fdfd9bf15ed46..8a1e7c5b9c6e2 100644
--- a/drivers/net/wireless/marvell/mwifiex/Makefile
+++ b/drivers/net/wireless/marvell/mwifiex/Makefile
@@ -49,6 +49,7 @@ mwifiex_sdio-y += sdio.o
 obj-$(CONFIG_MWIFIEX_SDIO) += mwifiex_sdio.o
 
 mwifiex_pcie-y += pcie.o
+mwifiex_pcie-y += pcie_quirks.o
 obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
 
 mwifiex_usb-y += usb.o
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6a10ff0377a24..362cf10debfa0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -27,6 +27,7 @@
 #include "wmm.h"
 #include "11n.h"
 #include "pcie.h"
+#include "pcie_quirks.h"
 
 #define PCIE_VERSION	"1.0"
 #define DRV_NAME        "Marvell mwifiex PCIe"
@@ -410,6 +411,9 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 			return ret;
 	}
 
+	/* check quirks */
+	mwifiex_initialize_quirks(card);
+
 	if (mwifiex_add_card(card, &card->fw_done, &pcie_ops,
 			     MWIFIEX_PCIE, &pdev->dev)) {
 		pr_err("%s failed\n", __func__);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 843d57eda8201..09839a3bd1753 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -242,6 +242,8 @@ struct pcie_service_card {
 	struct mwifiex_msix_context share_irq_ctx;
 	struct work_struct work;
 	unsigned long work_flags;
+
+	unsigned long quirks;
 };
 
 static inline int
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
new file mode 100644
index 0000000000000..929aee2b0a60a
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * File for PCIe quirks.
+ */
+
+/* The low-level PCI operations will be performed in this file. Therefore,
+ * let's use dev_*() instead of mwifiex_dbg() here to avoid troubles (e.g.
+ * to avoid using mwifiex_adapter struct before init or wifi is powered
+ * down, or causes NULL ptr deref).
+ */
+
+#include <linux/dmi.h>
+
+#include "pcie_quirks.h"
+
+/* quirk table based on DMI matching */
+static const struct dmi_system_id mwifiex_quirk_table[] = {
+	{
+		.ident = "Surface Pro 4",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Pro 5",
+		.matches = {
+			/* match for SKU here due to generic product name "Surface Pro" */
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Pro 5 (LTE)",
+		.matches = {
+			/* match for SKU here due to generic product name "Surface Pro" */
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Pro 6",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Book 1",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Book 2",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Laptop 1",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Laptop 2",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface 3",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface 3"),
+		},
+		.driver_data = 0,
+	},
+	{
+		.ident = "Surface Pro 3",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 3"),
+		},
+		.driver_data = 0,
+	},
+	{}
+};
+
+void mwifiex_initialize_quirks(struct pcie_service_card *card)
+{
+	struct pci_dev *pdev = card->dev;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id = dmi_first_match(mwifiex_quirk_table);
+	if (dmi_id)
+		card->quirks = (uintptr_t)dmi_id->driver_data;
+
+	if (!card->quirks)
+		dev_info(&pdev->dev, "no quirks enabled\n");
+}
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
new file mode 100644
index 0000000000000..5326ae7e56713
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Header file for PCIe quirks.
+ */
+
+#include "pcie.h"
+
+/* quirks */
+// quirk flags can be added here
+
+void mwifiex_initialize_quirks(struct pcie_service_card *card);
-- 
2.29.1

