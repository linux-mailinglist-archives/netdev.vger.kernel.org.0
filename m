Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718E14BCD8A
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242763AbiBTJ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:58:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiBTJ6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:58:44 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9E454191;
        Sun, 20 Feb 2022 01:58:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShhIHoQdng0jXMJIxz2wDRGGYNXFyRRWMsFKH0zu2YsYdeE9HnRMuSy324pInExCkhIMWVJ49g04OACehnIlXWqFQVTo0SwfoOESdclbz/1UGLqqbAxBAgrPiMHaERw8qnxQHwDRx32FyCgkVmizjDfhX5sAQB6imXOz19YT5OWgSq6AjFWcgrsgfzqHtCs/p42pvXP3QUyxEkVYJEnct61RHTj2uPbr4hn6P3ok21N5ZicWndLPmhcwcB8fve7eYCdPWr5dDfGXWfqC+k4Q7j/vbHZvgRYDq4IT9NafD7pNWkRoiIpfNSAhyAG7tnD/61ksH6AZEvKNvevNpitX0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=dKgdMadRWn/O9dbimsz6dWIWzhRKY47zBBukfeAoZINYM1oQMf3jUlq5IjOcYqZXhozMBhgjxiwVeHSs1rPuf38Pzthh4empgAAxKcWGlPwc+SUn8myCiZp6yGETUuAuADdJcPTi/QlIX/E5Qb+tcPsuxdb3rB/0MqxTj+Zd5cZT7HwZ8IrDc2LudbaHJWJVjFopixwTblh5TwG6MbCiZJzSXYnmLdXW0x6geBBNECnwzMkv3UCdZssZollGSsA8aqcS8mH+D7o0i7jN6N9+jv3Zm2UrT45lhjosPMZS8L7iQ9/2DKRnb4oo6+JEquYB1IkgC4vfGgs4bNJUlkivLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NultjMQVehi+CPwn9nKymN3VP3QKmVagd6D7Y7plSUE=;
 b=SckRa4S4yKrwUKd3ZuIjQOn2MHFbTaWQ5igvLUjLdypP4P8Mr6yI/geRRFYx0oY+kqKngiNAKB1Ml1oD5zORk9HycK+KNmDmEbcKjIycoKZIavltbol/PxXq84Z0twDWGzHp0XH87RZ/CsYJKaGK54Q3I2TrRHxVoSRCJEWKxQkJhmecTsUyUFPNN58hVEOo/l0PDA2VRryIBapWbwwPMsZULU1v7opYIe5eMPGAQdUxFB38YPRUIlnu+mWCXHGy+qo5GIEgDmtauMfZX94NcQhyy9ckGOFLhbTCasF11kuMrhUtN6PtNWaVdIx3B46l7WdV18IV7oGQr1gvYbOm3Q==
Received: from DM6PR03CA0073.namprd03.prod.outlook.com (2603:10b6:5:333::6) by
 DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.17; Sun, 20 Feb 2022 09:58:22 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::c8) by DM6PR03CA0073.outlook.office365.com
 (2603:10b6:5:333::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:21 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:20 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:15 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 01/15] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Sun, 20 Feb 2022 11:57:02 +0200
Message-ID: <20220220095716.153757-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ae68a07-f3dc-48d8-e02c-08d9f4578769
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB522934FF7A75AF41296A72B5C3399@DM4PR12MB5229.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMnC4A6MmR9E4ejrhLpRTS6yqOs5aIj0FvZ7GzRVNo8EeR1JOYWcYUD27QuQI6MClumU+9caSzWyiP/6/4CBBb3ah+Z9708LujRX+EOH33kQ2/Xq6QwSAwL37LwPj3j6GWL+bSiMnKzPw0NfEZUZgF5rj7FGQohc/WM1l9Aoa+xI4Igi1cj0XrMDZLcR5T2++C/TQzqzI5Ryh7T7ifhsD3gwjgWdSdXNcK1PC3uJalxvJBC599SR9zzidssMu72namGiUP6e49FVhDQC9E4vm+oreIs4Z1n2VzLMA34gbK1uWzvvCBmxLKJvvQkohTAR+dpQBA7GdrsT1gb1bwDWg3r7ys1Exl/XWwOfm03dMZm39qdhZ71UxeG+2pQw6UYZRyXaDpn+IYJe2clPGi1kY+ItYJxXWFrhvn8Wab8MJt2+IJiNJI5Lt4uGkGD8BuL4buTapzN2HRVyVKk2YwVOr4RrnIiIYsw/y9PM4BPbjxpaNbGBMYjN5AJ1NmATP9ni+vFP4d3My+fhahM5SD6p75PqxUgk1P4GQX79PJ7H6LRrnhj+NxMb4cBvUYP0IgjmDhJpPh/8bzHe+kij8YAW2zQHwqYlHaUsrYQKC+siSQDQGwdhlYS0mM2A5QrLvXNj68Pgqa0UhtGER7uzrqXKyrSfI9Ee7DGSgdVHBhGjuRMdByZvbzbijnM14vort/GwQ3PQxo6ento50y59lUH/ew==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(26005)(47076005)(186003)(83380400001)(426003)(336012)(81166007)(356005)(4326008)(36860700001)(8676002)(1076003)(8936002)(7416002)(5660300002)(70206006)(2906002)(70586007)(6666004)(7696005)(2616005)(6636002)(54906003)(110136005)(316002)(508600001)(86362001)(40460700003)(36756003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:21.9580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae68a07-f3dc-48d8-e02c-08d9f4578769
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5229
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

