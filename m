Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817F61F36FB
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 11:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgFIJUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 05:20:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:23910 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbgFIJUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 05:20:38 -0400
IronPort-SDR: 8PVx+Od/G2YqBsmUsCnrFBVcpEXbK9Oq367CVfjxRWMUg6bwprzo8l5qVyfc3C4JDiZbkSIDqq
 KCh/GrTjf57g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 02:20:38 -0700
IronPort-SDR: ujF+fLce9SfdyD/evCQB6C/gD70o//xldOuQ1v7euwcjTLiJVaRuJr8VDfdx3GBfc2hoaEm6i8
 EkaGqXWSjAYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,491,1583222400"; 
   d="scan'208";a="295775952"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2020 02:20:34 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc:     Piotr Stankiewicz <piotr.stankiewicz@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 14/15] net: hns3: Use PCI_IRQ_MSI_TYPES where appropriate
Date:   Tue,  9 Jun 2020 11:20:29 +0200
Message-Id: <20200609092033.1944-1-piotr.stankiewicz@intel.com>
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
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 96bfad52630d..535d9f4a31f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2327,8 +2327,7 @@ static int hclge_init_msi(struct hclge_dev *hdev)
 	int i;
 
 	vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
-					hdev->num_msi,
-					PCI_IRQ_MSI | PCI_IRQ_MSIX);
+					hdev->num_msi, PCI_IRQ_MSI_TYPES);
 	if (vectors < 0) {
 		dev_err(&pdev->dev,
 			"failed(%d) to allocate MSI/MSI-X vectors\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1b9578d0bd80..fbfd4e7b2817 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2608,8 +2608,7 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
 						PCI_IRQ_MSIX);
 	else
 		vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
-						hdev->num_msi,
-						PCI_IRQ_MSI | PCI_IRQ_MSIX);
+						hdev->num_msi, PCI_IRQ_MSI_TYPES);
 
 	if (vectors < 0) {
 		dev_err(&pdev->dev,
-- 
2.17.2

