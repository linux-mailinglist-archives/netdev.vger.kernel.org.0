Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D93A1ECEFA
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 13:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgFCLtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 07:49:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:5555 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgFCLtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 07:49:33 -0400
IronPort-SDR: pkBmDH6Lh5c/BfbK372q975zKEn3O0EGP358uofZZElXzQG0fHmVtiU8VwVq1vA+6WDgyVaEnm
 Av7dn1nGdaog==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 04:49:33 -0700
IronPort-SDR: nPxzuBUZbHQWLxtcEGnSgrGBDV8wzTM/pV+RSw0f7UOv6UpMkpEV8ogLbXHQYHkq5lpCK00hqS
 Wlq7vc1r/Z3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,467,1583222400"; 
   d="scan'208";a="304582926"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by orsmga008.jf.intel.com with ESMTP; 03 Jun 2020 04:49:30 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc:     Piotr Stankiewicz <piotr.stankiewicz@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/15] amd-xgbe: Use PCI_IRQ_MSI_TYPES where appropriate
Date:   Wed,  3 Jun 2020 13:49:24 +0200
Message-Id: <20200603114925.13706-1-piotr.stankiewicz@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200603114212.12525-1-piotr.stankiewicz@intel.com>
References: <20200603114212.12525-1-piotr.stankiewicz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seeing as there is shorthand available to use when asking for any type
of interrupt, or any type of message signalled interrupt, leverage it.

Signed-off-by: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 7b86240ecd5f..903bc5ef2518 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -133,7 +133,7 @@ static int xgbe_config_multi_msi(struct xgbe_prv_data *pdata)
 			    pdata->tx_ring_count);
 
 	ret = pci_alloc_irq_vectors(pdata->pcidev, XGBE_MSI_MIN_COUNT,
-				    vector_count, PCI_IRQ_MSI | PCI_IRQ_MSIX);
+				    vector_count, PCI_IRQ_MSI_TYPES);
 	if (ret < 0) {
 		dev_info(pdata->dev, "multi MSI/MSI-X enablement failed\n");
 		return ret;
-- 
2.17.2

