Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FFE440AAF
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 19:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhJ3Rnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 13:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhJ3Rnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 13:43:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626E6C061714;
        Sat, 30 Oct 2021 10:41:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o14so21625640wra.12;
        Sat, 30 Oct 2021 10:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3J5zCyAt6QvIKFNQp8gVh7jk8fLM5Aizo3iPLsFee9o=;
        b=FGsYUfG43J176+Wby1dMTYhS/jOfQLdjlI9Af0UIUdAaLAOwWFL5D3UJiqRlZWil+K
         /bJU/ELJjNaRvP3ZHS1PE+eMLJEvLQ/ZhFYIsm1QjjrHLJtHWEkEWtZXDiqi3l4DCTEo
         2M4zkExMBDMxNXa61yQqeWeq9xbX4OsNzvUzvFyrHVOxC2EkEkMpHN23n5kUanq+6baQ
         hXe2PVL4AMakPLTXubeycSRi5dVHRKvDYEshr7kQZU6kyxmGQDWnTcRZc1Tnxk3juTkq
         /4UIN+9OPvdWCCATNIBsAA707oVOIYPXJvWraLgS/uwAVePneJKbYyVMN/weYKmiyvPI
         vqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3J5zCyAt6QvIKFNQp8gVh7jk8fLM5Aizo3iPLsFee9o=;
        b=P5M18zmiHLYIt77lYnMnby5zkDmuHXZ/QswOjw6T0U24OEipOepSDhT0bcRM5OYb62
         +OEuSVgE4+OU58y1Kur6CpRWOZc642337lHtvR9m2jjpJTApDSSjAQbIMbqG+197/CEW
         TGKx0mA0BXK1nMUc05jaoTZtFatG4GaLU+43uEJaeO+8ZIC3DnFtwBvO8GciRSHD234d
         cXZay0U7D9oe7RaHUykSX4DUWLqJrZGx7uIpzqMgcmxgi1rm+9C+H+OoSJfLmPP0rOI/
         aoYquSzsZL4Dy0DHHkJnpm4UAb8pAC6O8uWz7F1+EMbfAxMo1f+KDj7B8owTRnskwInu
         5YgA==
X-Gm-Message-State: AOAM533OmLnKppU2eSjrLPeqfqKpFGWETQArL1ZJC8bKRpl8cMEyjeSi
        HWXrwf8lPCiKa+18qMGwT1clX+HpVcw=
X-Google-Smtp-Source: ABdhPJyrf16dZFwJdNSE5UE59V3nGeGUTMAiYMziacJ6hRNlzUXHlR0Gtz2bgLFgbW8IEn1AEMT4Ag==
X-Received: by 2002:a5d:5651:: with SMTP id j17mr454977wrw.166.1635615672831;
        Sat, 30 Oct 2021 10:41:12 -0700 (PDT)
Received: from debian64.daheim (p5b0d7cd8.dip0.t-ipconnect.de. [91.13.124.216])
        by smtp.gmail.com with ESMTPSA id q14sm8743778wrr.28.2021.10.30.10.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 10:41:12 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1mgsLv-0060hg-SX;
        Sat, 30 Oct 2021 19:41:11 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC net-next/wireless-next v1 2/2] ath10k: move device_get_mac_address() and pass errors up the chain
Date:   Sat, 30 Oct 2021 19:41:11 +0200
Message-Id: <20211030174111.1432663-2-chunkeey@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211030174111.1432663-1-chunkeey@gmail.com>
References: <20211030174111.1432663-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

device_get_mac_address() can now return -EPROBE_DEFER.
This has to be passed back to the device subsystem so
the driver will be probed again at a later time.

This was somewhat involved because the best place for this
seemed in ath10k_core_create() right after allocation.
Thing is that ath10k_core_create() was setup to either
return a valid ath10k* instance, or NULL. So each ath10k
implementation has to be modified to account for ERR_PTR.

This introduces a new side-effect: the returned error codes
from ath10k_core_create() will now be passed along. It's no
longer just -ENOMEM.

Note: If device_get_mac_address() didn't get a valid MAC from
either the DT/ACPI, nvmem, etc... the driver will just generate
random MAC (same as it did before).

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
@Kalle from what I can tell, this is how nvmem-mac could be
done with the existing device_get_mac_address() - at a
different place. The reason for the move was that -EPROBE_DEFER
needs to be returned by the pci/usb/snoc/ahb _probe functions().
This wasn't possible in the old location. As ath10k deferres
the "bring-up" process into a workqueue task which can't return
any errors (it just printk/dev_err them at the end).
Also, When I was asking around about this. The common consensus was
to just post it and see. This is based on net-next + wireless-testing

 drivers/net/wireless/ath/ath10k/ahb.c  |  8 +++++---
 drivers/net/wireless/ath/ath10k/core.c | 14 ++++++++------
 drivers/net/wireless/ath/ath10k/pci.c  |  8 +++++---
 drivers/net/wireless/ath/ath10k/sdio.c |  8 +++++---
 drivers/net/wireless/ath/ath10k/snoc.c |  8 +++++---
 drivers/net/wireless/ath/ath10k/usb.c  |  8 +++++---
 6 files changed, 33 insertions(+), 21 deletions(-)

 

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index ab8f77ae5e66..ad282a06b376 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -745,9 +745,11 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	size = sizeof(*ar_pci) + sizeof(*ar_ahb);
 	ar = ath10k_core_create(size, &pdev->dev, ATH10K_BUS_AHB,
 				hw_rev, &ath10k_ahb_hif_ops);
-	if (!ar) {
-		dev_err(&pdev->dev, "failed to allocate core\n");
-		return -ENOMEM;
+	if (IS_ERR(ar)) {
+		ret = PTR_ERR(ar);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "failed to allocate core: %d\n", ret);
+		return ret;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "ahb probe\n");
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 72a366aa9f60..85d2e8143101 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3291,8 +3291,6 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		ath10k_debug_print_board_info(ar);
 	}
 
-	device_get_mac_address(ar->dev, ar->mac_addr);
-
 	ret = ath10k_core_init_firmware_features(ar);
 	if (ret) {
 		ath10k_err(ar, "fatal problem with firmware features: %d\n",
@@ -3451,11 +3449,11 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  const struct ath10k_hif_ops *hif_ops)
 {
 	struct ath10k *ar;
-	int ret;
+	int ret = -ENOMEM;
 
 	ar = ath10k_mac_create(priv_size);
 	if (!ar)
-		return NULL;
+		goto err_out;
 
 	ar->ath_common.priv = ar;
 	ar->ath_common.hw = ar->hw;
@@ -3464,6 +3462,10 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	ar->hif.ops = hif_ops;
 	ar->hif.bus = bus;
 
+	ret = device_get_mac_address(dev, ar->mac_addr);
+	if (ret == -EPROBE_DEFER)
+		goto err_free_mac;
+
 	switch (hw_rev) {
 	case ATH10K_HW_QCA988X:
 	case ATH10K_HW_QCA9887:
@@ -3580,8 +3582,8 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	destroy_workqueue(ar->workqueue);
 err_free_mac:
 	ath10k_mac_destroy(ar);
-
-	return NULL;
+err_out:
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(ath10k_core_create);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4d4e2f91e15c..f4736148a382 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3602,9 +3602,11 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev, ATH10K_BUS_PCI,
 				hw_rev, &ath10k_pci_hif_ops);
-	if (!ar) {
-		dev_err(&pdev->dev, "failed to allocate core\n");
-		return -ENOMEM;
+	if (IS_ERR(ar)) {
+		ret = PTR_ERR(ar);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "failed to allocate core: %d\n", ret);
+		return ret;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "pci probe %04x:%04x %04x:%04x\n",
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 63e1c2d783c5..87941e047d07 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2526,9 +2526,11 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 
 	ar = ath10k_core_create(sizeof(*ar_sdio), &func->dev, ATH10K_BUS_SDIO,
 				hw_rev, &ath10k_sdio_hif_ops);
-	if (!ar) {
-		dev_err(&func->dev, "failed to allocate core\n");
-		return -ENOMEM;
+	if (IS_ERR(ar)) {
+		ret = PTR_ERR(ar);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&func->dev, "failed to allocate core: %d\n", ret);
+		return ret;
 	}
 
 	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_sdio_napi_poll,
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 9513ab696fff..b9ac89e226a2 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1728,9 +1728,11 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 
 	ar = ath10k_core_create(sizeof(*ar_snoc), dev, ATH10K_BUS_SNOC,
 				drv_data->hw_rev, &ath10k_snoc_hif_ops);
-	if (!ar) {
-		dev_err(dev, "failed to allocate core\n");
-		return -ENOMEM;
+	if (IS_ERR(ar)) {
+		ret = PTR_ERR(ar);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "failed to allocate core: %d\n", ret);
+		return ret;
 	}
 
 	ar_snoc = ath10k_snoc_priv(ar);
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 3d98f19c6ec8..d6dc830a6fa8 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -987,9 +987,11 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 
 	ar = ath10k_core_create(sizeof(*ar_usb), &dev->dev, ATH10K_BUS_USB,
 				hw_rev, &ath10k_usb_hif_ops);
-	if (!ar) {
-		dev_err(&dev->dev, "failed to allocate core\n");
-		return -ENOMEM;
+	if (IS_ERR(ar)) {
+		ret = PTR_ERR(ar);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&dev->dev, "failed to allocate core: %d\n", ret);
+		return ret;
 	}
 
 	usb_get_dev(dev);
-- 
2.33.1

