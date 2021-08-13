Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5671A3EB5E7
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 15:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbhHMNBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 09:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbhHMNBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 09:01:00 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10D1C0617AD
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 06:00:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so11034394pje.0
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 06:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nNkuij8yUE1tIId8iqJQ6kzgmpwCYF7ujjVAfXSGs24=;
        b=ytr74bAALHy2VuJNKNKVS3wpLJz+g9XIGMjOXTTqex2kkTCg1DM3wTPEwhaOjiSDdL
         quGnQZK7QdiDcJtrn7gfX3j+l7RvUmrjb1RazsDWY/e9cPmVNIcUcUJQ/x9CnD91KfQI
         LqLl5sREMreRvrUa+cZIYT7iahS0LNm1JAa5Ouk9ZPQ4eg6+6AwUeRz1sS4fmT2XOf8H
         qzi1NFyz5+owg9q+SRpwvJGBFVlzDIiE8zk00l69vCmaodNW3lL9vR0h5IeMK0pgKaZH
         XFwSFh8q//3axn8vFZQ/uRecLIgxVR/9cbx4CXLtfaLE1fBM9SvK/ZHL0jTFoZ5JLM6Z
         oJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nNkuij8yUE1tIId8iqJQ6kzgmpwCYF7ujjVAfXSGs24=;
        b=PSUljIaVDmTlCQgqtcyXKroRy3hbGF8ju52qKCz2z6NIrFTMDToHTc7CPnw9WVQM9G
         Q02bu7mxj0TuaW05xkJROC9Ldm04rWgAjWgwA4PoWc+2K49Ah0DyE9IHNSRVs5B1mA+T
         8FpI2nf8wInBS+R/NZK3iAQo/7Im8e39coLuY+j4uy5dYs9tjGqC+GJc778PZwlIjjYX
         WE3HnNf4h44iEdnXPEkORfYBfiUGnPMkFV31P0NmMNT9tp33PdJFCK0aNBB3UbgXiYO3
         Kmki17p69XO8DaWG37/JIyI/OP2ZqHU2H3tNHdjSP/pgwV7/+EBmGXyHJ/fj4lX/2tDl
         pNBg==
X-Gm-Message-State: AOAM530DnxqCuGDl7bn5ZEQfZQv/oXo34w0iqIRQXzVw5FsS3ccX7Vsb
        8cUfv2x1NjRDQRneoA1dit8v
X-Google-Smtp-Source: ABdhPJzhwS9a/AXYvM9PIXi5Ct03LWk8VWsJot4sp7f8DWpDHo/eEQmKQh268wsj5w5lenJpavrnog==
X-Received: by 2002:aa7:8d54:0:b029:3cd:6ce7:bec6 with SMTP id s20-20020aa78d540000b02903cd6ce7bec6mr2295933pfe.69.1628859632121;
        Fri, 13 Aug 2021 06:00:32 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6d88:db48:973:4d84:d444:9ae4])
        by smtp.gmail.com with ESMTPSA id r16sm1993735pje.10.2021.08.13.06.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 06:00:31 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Richard.Laing@alliedtelesis.co.nz, loic.poulain@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] Revert "bus: mhi: pci-generic: configurable network interface MRU"
Date:   Fri, 13 Aug 2021 18:30:14 +0530
Message-Id: <20210813130014.6822-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 5c2c85315948c42c6c0258cf9bad596acaa79043.

First this commit should go via the MHI tree as the "pci_generic" driver
belongs to MHI bus.

Then from the review point of view, the commit uses "mru_default"
variable to hold the MRU size for the MHI device. The term default
doesn't make much sense since there is no way to override this value
anywhere. So the author should just use "mru" in mhi_pci_dev_info
struct.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/pci_generic.c | 4 ----
 drivers/net/mhi_net.c         | 1 -
 include/linux/mhi.h           | 2 --
 3 files changed, 7 deletions(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index b33b9d75e8af..4dd1077354af 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -32,7 +32,6 @@
  * @edl: emergency download mode firmware path (if any)
  * @bar_num: PCI base address register to use for MHI MMIO register space
  * @dma_data_width: DMA transfer word size (32 or 64 bits)
- * @mru_default: default MRU size for MBIM network packets
  * @sideband_wake: Devices using dedicated sideband GPIO for wakeup instead
  *		   of inband wake support (such as sdx24)
  */
@@ -43,7 +42,6 @@ struct mhi_pci_dev_info {
 	const char *edl;
 	unsigned int bar_num;
 	unsigned int dma_data_width;
-	unsigned int mru_default;
 	bool sideband_wake;
 };
 
@@ -274,7 +272,6 @@ static const struct mhi_pci_dev_info mhi_qcom_sdx55_info = {
 	.config = &modem_qcom_v1_mhiv_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
-	.mru_default = 32768,
 	.sideband_wake = false,
 };
 
@@ -667,7 +664,6 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mhi_cntrl->status_cb = mhi_pci_status_cb;
 	mhi_cntrl->runtime_get = mhi_pci_runtime_get;
 	mhi_cntrl->runtime_put = mhi_pci_runtime_put;
-	mhi_cntrl->mru = info->mru_default;
 
 	if (info->sideband_wake) {
 		mhi_cntrl->wake_get = mhi_pci_wake_get_nop;
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 975f7f9bdf4c..a577bff82fe1 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -312,7 +312,6 @@ static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
 	mhi_netdev->skbagg_head = NULL;
-	mhi_netdev->mru = mhi_dev->mhi_cntrl->mru;
 
 	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
 	u64_stats_init(&mhi_netdev->stats.rx_syncp);
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index c493a80cb453..5e08468854db 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -356,7 +356,6 @@ struct mhi_controller_config {
  * @fbc_download: MHI host needs to do complete image transfer (optional)
  * @wake_set: Device wakeup set flag
  * @irq_flags: irq flags passed to request_irq (optional)
- * @mru: the default MRU for the MHI device
  *
  * Fields marked as (required) need to be populated by the controller driver
  * before calling mhi_register_controller(). For the fields marked as (optional)
@@ -449,7 +448,6 @@ struct mhi_controller {
 	bool fbc_download;
 	bool wake_set;
 	unsigned long irq_flags;
-	u32 mru;
 };
 
 /**
-- 
2.25.1

