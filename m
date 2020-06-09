Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F631F36F0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 11:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgFIJTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 05:19:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:53795 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgFIJTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 05:19:52 -0400
IronPort-SDR: CCCyd6ge4JTct5mqBCco3IEyVY/O3OE0GCmNqFHl17jxdmdgtljzuFUOqicd64rd6SDZx3qbwG
 67Y/ORGcyU+Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 02:19:50 -0700
IronPort-SDR: nKC6WcbWsw8TySdN5S4WHT+U3YQ4/B27fMHIrG8Ln/pRt5+fQNR3Xb6pko33juIgZ8JQdhQwW1
 g457lWNzuuLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,491,1583222400"; 
   d="scan'208";a="349462010"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2020 02:19:47 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc:     Piotr Stankiewicz <piotr.stankiewicz@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/15] amd-xgbe: Use PCI_IRQ_MSI_TYPES where appropriate
Date:   Tue,  9 Jun 2020 11:19:42 +0200
Message-Id: <20200609091944.1764-1-piotr.stankiewicz@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200609091148.32749-1-piotr.stankiewicz@intel.com>
References: <20200609091148.32749-1-piotr.stankiewicz@intel.com>
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

