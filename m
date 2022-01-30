Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506474A3786
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355537AbiA3QOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:14:54 -0500
Received: from mail-sn1anam02on2058.outbound.protection.outlook.com ([40.107.96.58]:48387
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344953AbiA3QOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:14:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0aHxecIJwU3xOJ4fwjR8sfQEUq/kPBIVS/T3z5CYiJ/7lCZzEtoYgwqYJEce2SXQP/EN+owHy6xJIj4bunNVHlrCzbE6JjrizrodgWxzL9rR+6UW7a5xqxmD4xReuQO+GU9LF45yu0Akf4fP4bBx7yNzWTPYPlWBTr3xCcU7KIwBZ4K+AQx7Tb9kXZCvAZ0K/20olh1FqkcLAnC9aZlrR06Ryf3cgotmzwBSPA8FWygEvhUhiGdA3zTezCTEZ9Eq3QkTDaFYiaUFujZBe9hSMa1liHgWYhJhaZLZmhEwQWrc5APejraLHt+hr1N3LAJ0NzakB3lwoN2QAesCysc3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=CQ3Yl5QWv/2kCsWOrEEPbmVCjwHKuy1zdNxVfJq041J9mn34irCUI/T7y0X7Bs2bU/OmXT32grHCKw90rcv7LCoAt8We3daX75PIU2SV6LmbNk6jXTMMBzybATwlOjSVvihRUd7XjQUDunQuPwz+2iIf7wEbWIXxcaMG1VnLPOP1rJHYSCmyiaJOHr1QtCS4q+8Y3U9fqRuotG41VZG+fS9rzdjErkuygwkeJfBkMRBN2SMy3T9r6GLYqLnhEqgL9l3hgBz8fbajMzzs3eNrpC2yOtZprpnMyChR5y5t9/tdevYMd6kF3UcQ8yAtnBTRJZmPFttfdgbUqLhwaJx7VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=pAtXOMN+VoTkXU9iYSrQKIM+Y3vKIU1wVnUnekkc6l7XE9x2C891HYdERSJ9e2cQg2ED7xQ/l/j+qpEbbLZ1LNE244n0sUuqWKwo/M9Pa3gGscNUOtLhPCCkWlhVf12pP/rwBL833gEuwQrT2WRPMEQzocjgFMrVrZ7g3GW/paB31SiVyZ/72047hyelURsz9YkCgD01KGH0FEPbTRds2NoXDwGoF/meDe8pZ/Mbq2bhDf7Son16A8k3sEROggZOM6XiuagRBg6X8AelQ9PTJsc08misBF4W7hfy1Kz+kV85hwpv2tpi3q1vVzasaIGp43oGlPP/OL+4dCxHE3xt0w==
Received: from MW4PR04CA0097.namprd04.prod.outlook.com (2603:10b6:303:83::12)
 by DM6PR12MB4894.namprd12.prod.outlook.com (2603:10b6:5:209::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Sun, 30 Jan
 2022 16:14:50 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::9f) by MW4PR04CA0097.outlook.office365.com
 (2603:10b6:303:83::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18 via Frontend
 Transport; Sun, 30 Jan 2022 16:14:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:14:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:14:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:14:48 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:14:45 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 01/15] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Sun, 30 Jan 2022 18:08:12 +0200
Message-ID: <20220130160826.32449-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d946d60-fe0b-4eaa-a3cc-08d9e40ba430
X-MS-TrafficTypeDiagnostic: DM6PR12MB4894:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4894DFAB3E99810899C66ECBC3249@DM6PR12MB4894.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0M5yRAwTvG+FTDnH2NTxuEJNuoqmEfvH9wbizMHtRDqEF4wt9px51t4BmhOivFwaEhni1nZ2VaWhM9TBJZkhyFNmpBzsHgr1rkdL2YyQEz2oLCj+t+vPtIrHooej7vcL+BJlDzJAUWYy94lszKWIU+C85vVhL8CiNtln9kmhxDhF8RVc9IbcQsl40kART+MDCS+daWZ8DcnY1DDeG0vxZ717TrlRHfkyBMinm45NHDe/Ozl58zaJtFDmOtwif4Fi3aN1n277jMZYc6KO3UEyu2DXj5rCbWBoWzOCFdHYpL43VFmVgIqRflW3G09zmfRpnkiXmhF3ky8mm5i+MZQShMotJy+B70GAFUbiauVkwL8Wiw4Z0YRJwEOE8nvT2vzVPk0O7NkKepKEnBhnp0m8xrkutfoUkEKamsl8Ofz9r5e6U5xmXowZQpYr0l4Fx+zu6miWx09ilzeiX5Rq/fSCyDXvCUO4EK+pJEJd0KKC7sTRJ/PxITqAESb6xRybxw8y3GAf2aX4x9kQQcaumPWUJwCrzKh/jGcX3oLpB5HoD35AacKmwNzmRKxvuGDm6IuFZMTDxex9MWLqpO94gw3Fw3M6y+ijm8Be7qWmGRCKgHoyCIFwe6IeOBJpN0Nf8l5V7v+2uIfTcLehUv/zvK+1Q3W4LJTw0eU2XB3I3j1CHJlwL9msSvEyWEzajLcR2OKFLj8I5zWYi6oH0Kwa5oj4w==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70586007)(70206006)(8676002)(316002)(36860700001)(4326008)(5660300002)(47076005)(6636002)(36756003)(2906002)(8936002)(110136005)(54906003)(40460700003)(81166007)(1076003)(26005)(186003)(6666004)(7696005)(426003)(508600001)(86362001)(2616005)(107886003)(336012)(356005)(83380400001)(82310400004)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:14:49.8810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d946d60-fe0b-4eaa-a3cc-08d9e40ba430
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The PCI core uses the VF index internally, often called the vf_id,
during the setup of the VF, eg pci_iov_add_virtfn().

This index is needed for device drivers that implement live migration
for their internal operations that configure/control their VFs.

Specifically, mlx5_vfio_pci driver that is introduced in coming patches
from this series needs it and not the bus/device/function which is
exposed today.

Add pci_iov_vf_id() which computes the vf_id by reversing the math that
was used to create the bus/device/function.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/pci/iov.c   | 14 ++++++++++++++
 include/linux/pci.h |  8 +++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0267977c9f17..2e9f3d70803a 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -33,6 +33,20 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
 }
 EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);
 
+int pci_iov_vf_id(struct pci_dev *dev)
+{
+	struct pci_dev *pf;
+
+	if (!dev->is_virtfn)
+		return -EINVAL;
+
+	pf = pci_physfn(dev);
+	return (((dev->bus->number << 8) + dev->devfn) -
+		((pf->bus->number << 8) + pf->devfn + pf->sriov->offset)) /
+	       pf->sriov->stride;
+}
+EXPORT_SYMBOL_GPL(pci_iov_vf_id);
+
 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
  * change when NumVFs changes.
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8253a5413d7c..3d4ff7b35ad1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2166,7 +2166,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 #ifdef CONFIG_PCI_IOV
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
-
+int pci_iov_vf_id(struct pci_dev *dev);
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);
 
@@ -2194,6 +2194,12 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
 {
 	return -ENOSYS;
 }
+
+static inline int pci_iov_vf_id(struct pci_dev *dev)
+{
+	return -ENOSYS;
+}
+
 static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 { return -ENODEV; }
 
-- 
2.18.1

