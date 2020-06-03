Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67731ECEFF
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgFCLuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 07:50:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:5625 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFCLuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 07:50:09 -0400
IronPort-SDR: 5n0TzM5hZlLd+qoq2uDEZn6zW0GFs9BYAfnQyufdqc5byc7DcETsNiJkGidmTXO6TGLJRPWHmi
 3GNlMhlCbo5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 04:50:09 -0700
IronPort-SDR: rjz6sjJuksB3FUZFHwtSPCFgTQNaTjuyYCffhA9Yy2klRAHJrhXomb/NmttnOhBsQYTp+FpgPr
 R1Bs52peKK2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,467,1583222400"; 
   d="scan'208";a="416538253"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2020 04:50:05 -0700
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
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/15] net: hns3: Use PCI_IRQ_MSI_TYPES where appropriate
Date:   Wed,  3 Jun 2020 13:49:59 +0200
Message-Id: <20200603115002.13874-1-piotr.stankiewicz@intel.com>
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
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

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
index e02d427131ee..2b02024bd00a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2341,8 +2341,7 @@ static int hclgevf_init_msi(struct hclgevf_dev *hdev)
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

