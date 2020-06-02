Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50B01EB85C
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgFBJV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:21:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:1795 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgFBJV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 05:21:26 -0400
IronPort-SDR: LtRluJlxI26XtoG3M5ssDq2sgx9OoJyvwPHE8EBIOa4/CE3ZS5KjLndmgZ6YZ7I9DB1UKW3r04
 1HcBghyMmIVQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 02:21:25 -0700
IronPort-SDR: uBXKk7giWwx6FxlD8NK71xMSld+GCXUReo4uazx8S58qgPlUyEAx/IgXgXd3cvuBXAaVK0DT0B
 Y5tjofFa810w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,463,1583222400"; 
   d="scan'208";a="293513929"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by fmsmga004.fm.intel.com with ESMTP; 02 Jun 2020 02:21:24 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Subject: [PATCH 14/15] net: hns3: use PCI_IRQ_MSI_TYPES where appropriate
Date:   Tue,  2 Jun 2020 11:21:18 +0200
Message-Id: <20200602092118.32283-1-piotr.stankiewicz@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seeing as there is shorthand available to use when asking for any type
of interrupt, or any type of message signalled interrupt, leverage it.

Signed-off-by: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a758f9ae32be..c49313e87170 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2334,8 +2334,7 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 	int i;
 
 	vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
-					hdev->num_msi,
-					PCI_IRQ_MSI | PCI_IRQ_MSIX);
+					hdev->num_msi, PCI_IRQ_MSI_TYPES);
 	if (vectors < 0) {
 		dev_err(&pdev->dev,
 			"failed(%d) to allocate MSI/MSI-X vectors\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e02d427131ee..002a40e65ab7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2342,7 +2342,7 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 	else
 		vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
 						hdev->num_msi,
-						PCI_IRQ_MSI | PCI_IRQ_MSIX);
+						PCI_IRQ_MSI_TYPES);
 
 	if (vectors < 0) {
 		dev_err(&pdev->dev,
-- 
2.17.2

