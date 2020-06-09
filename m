Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697571F36F6
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 11:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgFIJUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 05:20:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:4211 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbgFIJUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 05:20:06 -0400
IronPort-SDR: eSzPCfAw95JgzxfNEMqpUVKAi/1wlTzgsW98wFkvK6XPy/bJJVd0xne+8IE2YzjM0tnP+Iocp1
 0GWsxaYbZ4eA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 02:20:05 -0700
IronPort-SDR: tH4aESQr2kjh3PumuZ2O4pBFFXpYcCtUDsaeyIMleu7QYvVlCAiYJvMdkRL7VE+EhbM91smRfY
 MeRa8BLORonA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,491,1583222400"; 
   d="scan'208";a="379687004"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by fmsmga001.fm.intel.com with ESMTP; 09 Jun 2020 02:20:02 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc:     Piotr Stankiewicz <piotr.stankiewicz@intel.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Richard Clark <richard.xnu.clark@gmail.com>,
        zhengbin <zhengbin13@huawei.com>,
        Pavel Belous <pbelous@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/15] aquantia: atlantic: Use PCI_IRQ_ALL_TYPES where appropriate
Date:   Tue,  9 Jun 2020 11:19:59 +0200
Message-Id: <20200609092000.1850-1-piotr.stankiewicz@intel.com>
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
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 41c0f560f95b..bc228be9f0a3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -299,9 +299,7 @@ static int aq_pci_probe(struct pci_dev *pdev,
 	numvecs += AQ_HW_SERVICE_IRQS;
 	/*enable interrupts */
 #if !AQ_CFG_FORCE_LEGACY_INT
-	err = pci_alloc_irq_vectors(self->pdev, 1, numvecs,
-				    PCI_IRQ_MSIX | PCI_IRQ_MSI |
-				    PCI_IRQ_LEGACY);
+	err = pci_alloc_irq_vectors(self->pdev, 1, numvecs, PCI_IRQ_ALL_TYPES);
 
 	if (err < 0)
 		goto err_hwinit;
-- 
2.17.2

