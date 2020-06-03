Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188011ECEFD
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFCLtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 07:49:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:38743 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFCLtw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 07:49:52 -0400
IronPort-SDR: F28dNjG7/B2wjhlQTFb6sRuK8wZnPCjW8NykKWlSgST3ypCJeDbjzqNaQSMAvmRWGTPzGCZh+L
 X6XkYBkhYmeA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 04:49:51 -0700
IronPort-SDR: UOzt/GAaTVyn/Wq7RF/jvJhSWnGgRgsYbOgSu9mkKJfktXQyYIUWYF856Xm+qFTzcr6sUHKhnw
 PZcY7fzIplvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,467,1583222400"; 
   d="scan'208";a="293942607"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jun 2020 04:49:48 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc:     Piotr Stankiewicz <piotr.stankiewicz@intel.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Pavel Belous <pbelous@marvell.com>,
        Egor Pomozov <epomozov@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/15] aquantia: atlantic: Use PCI_IRQ_ALL_TYPES where appropriate
Date:   Wed,  3 Jun 2020 13:49:44 +0200
Message-Id: <20200603114945.13790-1-piotr.stankiewicz@intel.com>
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
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 8a70ffe1d326..2a0ebf296478 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -277,9 +277,7 @@ static int aq_pci_probe(struct pci_dev *pdev,
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

