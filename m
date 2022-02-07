Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790B64AC750
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358420AbiBGR1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241198AbiBGRXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:20 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E30C0401DB;
        Mon,  7 Feb 2022 09:23:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecdwJD+HDvJ7C0P597O3hLtbytm5YvXlVLXjuDQmuweVn8YHuFdwzVcnHuSCHQsoM091yOwqqBXp4C4L8eNc80VOjLLdZhpGgShEnbtbww7LxbvC2OnhvVRXhaBVDWEWWRkYqNB/iVS9kUPVXUFfYamzLxorT3xCOucEAaoEwNxOn0eEOqXP5ejVaRAEYRGqR/rindbvc6HILESoclOyuQ/0JB2/I0ff/tE0mzL1qRMnn5/O55n7xE/K0fk8y6feCnG5SUSDNm/ca4vJZJC1X0w4ztA98s0Hb+iRaYa1dauQAJiLElY6Q3XXl40KHktlDIWYRFBXq2MDfCppFgfG+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=B+e096VrGIJr2UR7anjbmD2nPFnfPUxIhtWCQDGpDTxmNFZZHKranqjemFQQaQEW7rtHbYHYP7bUOUbNyhz8EMfLknblTPa1hglvydJMoQNoLIoN5tCikBKmhTINItqYF4Mq3CmNzTIqF0UR2DiY9IrVeZCN3gPX+Pz2LJaDREf1f+Pg34AOL0OSuwzYJrotMlru0XtMlkEoC8ILKnTUn8VwaLXwFzsdO0Bn5XPdNp6hwGDsEbmheAQaDZmI+hmL5ZvdPQSUudSaGKa3oHVMeKSGNMVaszlQ6CI5vfbiAkVjj/CFj8uBzWkO8h3TVslXLaKW0mKf/LGKSNn8AKSX3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=Hd3yi9MZ1z3N/8lX0z9vE4LkcD2w1Z4h3WghM7CDrx0prbIsAxXuq9EVKr3ToWflpUyPEjGBrlN83pmwoNbpYdvZuanWH4PgkZcqtX15E4nl0J+qOCgfsRfc945hkvY3E5X8UojGu2MucsRAdRhmQfXhmUpwusyFyu/5VJrkcfvrufHYe5+bVWL5OEpoa3h3Fzksoo9WUhAIFLLHbjdUhycnrA4z3AYbFSrcDXGobsLV6NL0+TYYIJIoO97jzWy9QjN3BGFr4BYWHJ6RgDhw+MnetHt08Fb9r+D1AcfA7bv80oyg+DtiuGQ6AAwER39Um5IIRY5xrKpCThNHtmzxTA==
Received: from MWHPR19CA0001.namprd19.prod.outlook.com (2603:10b6:300:d4::11)
 by DM5PR12MB1499.namprd12.prod.outlook.com (2603:10b6:4:8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.11; Mon, 7 Feb 2022 17:23:10 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::43) by MWHPR19CA0001.outlook.office365.com
 (2603:10b6:300:d4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:09 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:05 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 01/15] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Mon, 7 Feb 2022 19:22:02 +0200
Message-ID: <20220207172216.206415-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bc703b0-6974-4c41-8c96-08d9ea5e8391
X-MS-TrafficTypeDiagnostic: DM5PR12MB1499:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1499C8692A908D261B8C9E09C32C9@DM5PR12MB1499.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utQQzjRuLcX6c7G6rjhlnDpvAQ8vFnmLn1HFMYCyZhgRFckTJ0HvCX6migHfMkQrX17s8EX51vWpywj5cuwGJBMN2sTyXa705aaUzRVeEpp/ChXC7zwr7esAMNuSLuIF2zg4yqoyJPFpT6M9hmEMfI/1CiQp7EcKt0d3myuZMUH2wsuCRBi2lwzF5a752JFeW1n9PdZQMoYlKH0EKjmXfiM7C6Tggg69dqMqgPQ/+9IR5BmK7uYRepZrwMmR0XE5tSjH8oOF2qaS6BOYn0g8k0+wDjmYM1eO44egyeM1nGxLvwwHTq7XKpxrz/CjG/GuMqqU7PbXXsldDD+WYO71R+k+6UoXkm9Xt+JSHl6bxpVJuzi5S2ZDMNbN2KbzyYtWv8y6iAXbFu0Atso9WzDTafKafOanADKnFWQzSOTaMzFWFXa10KEYZkfgP3EZHgv7GJTDz1pnviLPoTBCJArTJJr7kXFhprvzM1pq6REuTG2seA8KlS6yXMmIQE+2wcDqEjDnOELkhksavY4UD0ufzjtugbkbL/RZyQq53CjdKC3hXryA0G5fu6bO4/FbbW491D2Ick6spglsKJj0BddfbZ1WZRfHxZcQfMrlkc6OtbP2P2EF+x7z24bBPgO2y7aOTZAOblsvmmBj4H32YnEvG4x5/3dMRY5/v3YgAEZBYStyHdCk/D3tZeggWIBWju0stGPQnGrvDExz6ydEwggggg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(110136005)(40460700003)(6636002)(6666004)(54906003)(508600001)(7696005)(316002)(4326008)(8676002)(8936002)(86362001)(70586007)(70206006)(36860700001)(82310400004)(356005)(47076005)(5660300002)(83380400001)(81166007)(1076003)(2616005)(26005)(336012)(426003)(186003)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:10.3721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc703b0-6974-4c41-8c96-08d9ea5e8391
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1499
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

