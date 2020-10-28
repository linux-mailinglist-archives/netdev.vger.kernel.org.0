Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8AE29DB40
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389602AbgJ1XrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJ1Xqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:46:37 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B613C0613CF;
        Wed, 28 Oct 2020 16:46:37 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id k65so1408973oih.8;
        Wed, 28 Oct 2020 16:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2GSUDEJbjH2FqhUp9WcP5f/c+uzyd2rZvXRcjYSEPrE=;
        b=HRMaF3ILDuon2LXXbarGehN0syTyN4OZJCfOPM2S0qL5JbjfzvAe1CO6AX5X4NsOte
         HRAVdwaqsrJ+YFRrIvxSVyVXpkQt3Czo1hbJYPryFdicWQOzU97zucuYLRvUp2kSSl7V
         mR/1h7HYOMpSGBn/fho/4Y9PCgKrRegbNBEO7mnHHKMicZLUTY6yo1ZOKGl3kXpvUPMI
         VGvPXEPhOZpNRA/MP/zmcLkzEPA/c0GTE9sEUhz6PN2RWow8felrIyF2QSVVmLJ74My/
         lnuAXjLmkOmdKMIyry42XYAJgJvLF3vI5sy1Qat5w2xZm/MPQ9UA3XA+fQeMRKz/ijqr
         j7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2GSUDEJbjH2FqhUp9WcP5f/c+uzyd2rZvXRcjYSEPrE=;
        b=qO6urrLfecyn+ZJXAv2eKiIj4OQOhg8u7MzSESvmwso2OHIchffgA67pgfitaZWsCL
         mPk6IICVPLVYzMFnV4nHyBddEy7NO+7HEvjXw2x/taI9cg+00g9JVFeGG8anPrVA1qSf
         ralYPmjOCWhCIW9QwfhIAAsWwKLgDPlGFfb2ct5ineQpsubDKl+JxPtjmepN4GagPxL8
         r9eOXFnk/8cBenMsKMgAgPQ+lBmNvAFVdleP9b1ySxbJL++gv2GU0jZLytQNKzikG/wu
         2rKvYkUZ8Dcfu8SZikKWAU/iQAM4Id8BGua/nzpiPBwBmQ59rYmbPykbYdlfM1ySECOs
         bZOg==
X-Gm-Message-State: AOAM530BcehVwAx4FQluNzu3kI1n/gScdN56WaaeRhQHAn7luOwytFyR
        cAPDQkc6ifRKvlu2aCApnKkK6PIK8bgvKeSf
X-Google-Smtp-Source: ABdhPJwnHb6k8SvUlKeJVwM/JO+X8M9DEeIWrrLdJGRPkr+Gi63iuXsWDLjuRZb20UY3uFlxZAADzw==
X-Received: by 2002:a17:90a:bf05:: with SMTP id c5mr7213513pjs.11.1603895322133;
        Wed, 28 Oct 2020 07:28:42 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id g67sm6581754pfb.9.2020.10.28.07.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:28:41 -0700 (PDT)
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
Subject: [RFC PATCH 3/3] mwifiex: pcie: add reset_wsid quirk for Surface 3
Date:   Wed, 28 Oct 2020 23:27:53 +0900
Message-Id: <20201028142753.18855-4-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142753.18855-1-kitakar@gmail.com>
References: <20201028142753.18855-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds reset_wsid quirk and uses this quirk for Surface 3 on
card reset.

To reset mwifiex on Surface 3, it seems that calling the _DSM method
exists in \_SB.WSID [1] device is required.

On Surface 3, calling the _DSM method removes/re-probes the card by
itself. So, need to place the reset function before performing FLR and
skip performing any other reset-related works.

Note that Surface Pro 3 also has the WSID device [2], but it seems to need
more work. This commit only supports Surface 3 yet.

[1] https://github.com/linux-surface/acpidumps/blob/05cba925f3a515f222acb5b3551a032ddde958fe/surface_3/dsdt.dsl#L11947-L12011
[2] https://github.com/linux-surface/acpidumps/blob/05cba925f3a515f222acb5b3551a032ddde958fe/surface_pro_3/dsdt.dsl#L12164-L12216

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
Current issues:
1) After reset with this quirk, ASPM settings don't get restored.

Below is the "sudo lspci -nnvvv" diff before/after fw reset on Surface 3:

    #
    # root port of wifi:
    # 00:1c.0 PCI bridge [0604]: Intel Corporation Atom/Celeron/Pentium Processor x5-E8000/J3xxx/N3xxx Series PCI Express Port #1 [8086:22c8] (rev 20) (prog-if 00 [Normal decode])
    #
    @@ -103,7 +103,7 @@
                    DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
                    LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <512ns, L1 <16us
                            ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
    -               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes, Disabled- CommClk+
    +               LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
                            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                    LnkSta: Speed 2.5GT/s (downgraded), Width x1 (ok)
                            TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
    
    #
    # no changes on wifi regarding ASPM
    #

As you see, the ASPM of wifi root port is disabled after fw reset (thus
breaks S0ix).

2) Creating a new device driver for the WSID device is better?

then export the reset function, and call it from mwifiex. As the comments
in code states, on S3, calling the _DSM methods immediately
remove/re-probe mwifiex. So, resetting the wifi externally is a better
idea? (Also in this way, hopefully supporting SP3 may become easier.)

 drivers/net/wireless/marvell/mwifiex/pcie.c   | 10 +++
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 77 ++++++++++++++++++-
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  5 ++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c0c4b5a9149ab..b3aacd19cc48f 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2966,6 +2966,16 @@ static void mwifiex_pcie_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 
+	/* On Surface 3, reset_wsid method removes then re-probes card by
+	 * itself. So, need to place it here and skip performing any other
+	 * reset-related works.
+	 */
+	if (card->quirks & QUIRK_FW_RST_WSID_S3) {
+		mwifiex_pcie_reset_wsid_quirk(card->dev);
+		/* skip performing any other reset-related works */
+		return;
+	}
+
 	/* We can't afford to wait here; remove() might be waiting on us. If we
 	 * can't grab the device lock, maybe we'll get another chance later.
 	 */
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
index edc739c542fea..f0a6fa0a7ae5f 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
@@ -9,10 +9,21 @@
  * down, or causes NULL ptr deref).
  */
 
+#include <linux/acpi.h>
 #include <linux/dmi.h>
 
 #include "pcie_quirks.h"
 
+/* For reset_wsid quirk */
+#define ACPI_WSID_PATH		"\\_SB.WSID"
+#define WSID_REV		0x0
+#define WSID_FUNC_WIFI_PWR_OFF	0x1
+#define WSID_FUNC_WIFI_PWR_ON	0x2
+/* WSID _DSM UUID: "534ea3bf-fcc2-4e7a-908f-a13978f0c7ef" */
+static const guid_t wsid_dsm_guid =
+	GUID_INIT(0x534ea3bf, 0xfcc2, 0x4e7a,
+		  0x90, 0x8f, 0xa1, 0x39, 0x78, 0xf0, 0xc7, 0xef);
+
 /* quirk table based on DMI matching */
 static const struct dmi_system_id mwifiex_quirk_table[] = {
 	{
@@ -87,7 +98,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface 3"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_WSID_S3,
 	},
 	{
 		.ident = "Surface Pro 3",
@@ -113,6 +124,9 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
 		dev_info(&pdev->dev, "no quirks enabled\n");
 	if (card->quirks & QUIRK_FW_RST_D3COLD)
 		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
+	if (card->quirks & QUIRK_FW_RST_WSID_S3)
+		dev_info(&pdev->dev,
+			 "quirk reset_wsid for Surface 3 enabled\n");
 }
 
 static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
@@ -169,3 +183,64 @@ int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev)
 
 	return 0;
 }
+
+int mwifiex_pcie_reset_wsid_quirk(struct pci_dev *pdev)
+{
+	acpi_handle handle;
+	union acpi_object *obj;
+	acpi_status status;
+
+	dev_info(&pdev->dev, "Using reset_wsid quirk to perform FW reset\n");
+
+	status = acpi_get_handle(NULL, ACPI_WSID_PATH, &handle);
+	if (ACPI_FAILURE(status)) {
+		dev_err(&pdev->dev, "No ACPI handle for path %s\n",
+			ACPI_WSID_PATH);
+		return -ENODEV;
+	}
+
+	if (!acpi_has_method(handle, "_DSM")) {
+		dev_err(&pdev->dev, "_DSM method not found\n");
+		return -ENODEV;
+	}
+
+	if (!acpi_check_dsm(handle, &wsid_dsm_guid,
+			    WSID_REV, WSID_FUNC_WIFI_PWR_OFF)) {
+		dev_err(&pdev->dev,
+			"_DSM method doesn't support wifi power off func\n");
+		return -ENODEV;
+	}
+
+	if (!acpi_check_dsm(handle, &wsid_dsm_guid,
+			    WSID_REV, WSID_FUNC_WIFI_PWR_ON)) {
+		dev_err(&pdev->dev,
+			"_DSM method doesn't support wifi power on func\n");
+		return -ENODEV;
+	}
+
+	/* card will be removed immediately after this call on Surface 3 */
+	dev_info(&pdev->dev, "turning wifi off...\n");
+	obj = acpi_evaluate_dsm(handle, &wsid_dsm_guid,
+				WSID_REV, WSID_FUNC_WIFI_PWR_OFF,
+				NULL);
+	if (!obj) {
+		dev_err(&pdev->dev,
+			"device _DSM execution failed for turning wifi off\n");
+		return -EIO;
+	}
+	ACPI_FREE(obj);
+
+	/* card will be re-probed immediately after this call on Surface 3 */
+	dev_info(&pdev->dev, "turning wifi on...\n");
+	obj = acpi_evaluate_dsm(handle, &wsid_dsm_guid,
+				WSID_REV, WSID_FUNC_WIFI_PWR_ON,
+				NULL);
+	if (!obj) {
+		dev_err(&pdev->dev,
+			"device _DSM execution failed for turning wifi on\n");
+		return -EIO;
+	}
+	ACPI_FREE(obj);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
index 8b9dcb5070d87..3ef7440418e32 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
@@ -7,6 +7,11 @@
 
 /* quirks */
 #define QUIRK_FW_RST_D3COLD	BIT(0)
+/* Surface 3 and Surface Pro 3 have the same _DSM method but need to
+ * be handled differently. Currently, only S3 is supported.
+ */
+#define QUIRK_FW_RST_WSID_S3	BIT(1)
 
 void mwifiex_initialize_quirks(struct pcie_service_card *card);
 int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
+int mwifiex_pcie_reset_wsid_quirk(struct pci_dev *pdev);
-- 
2.29.1

