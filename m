Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0797543C6FC
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhJ0KAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:24 -0400
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:14433
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240102AbhJ0KAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZSu0fuTwffd4wX7Wji32B8lpwP5ldlFnSvNNsxEvLigI+WpdQxzR4jZenmNj7493b9QHkphzcRfgmjiG0zhanpAeFsTKn3VHaf26oQKPynN29FjGSqydqfVotJjpxvQbUUJd4BE6aC7ZvYilyTKopIbtJd/x2AtbS6KhHqa8LHlZrEh7Xh7KMHMwoC3KTFoRa2wtpP0R760w1slV+JZpe/a/Vo/QcjuWLKlQGXojVezqeGwR4wBgx1/xqA9JIT2KtpZDjMzNdx/Btbdk8MgpQBGCXKXM/keRZMhikSertljgyil8uGSjVr2IuwjNKbU8jZn1b6iQnGW3FtZJxfTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=JUIai4tcx6lprIqCNLScUjFCIP7im/ztk8yNaSTbA5g6t0I7x6nBVy3H1qouqoRaQ1batxOqq5CHTaLoBR5xQ9VDpcFvq5hjdaHzERa1WFTlt/3dt4n7WhgWrtPxxxUhgRySGVwHvOI0wGkJaRWid3pMrE9B/59TRBCprv0Zv8qWwSCsMaL8M/M1wB/ACYbmXReIxtGway8UX9ReZJQfyzbYz7jC185vMwOKbDH1MN19BUZci2ysmvVxvrEL7rYulmfAZCvR5tRZCWuFHLMomwPWX+v9V7pdltrgdU6VpB8J1qHwDv9b8ja7BdMYDFGSOOx4tAEeQJVHusDPOswjkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=Ch/cyvte/fhwXCo8q1JtBHym2oxcXcXfr5zbDrKCvxXh1L8GOadlDo+v5ws80TNj/dBFVSDWQRaLxkBZ/On3IOgaBEUilcWTJ4rJWOKMUZ4/+CVRoCYvtVVCH+M4FgTKs7Bd59Upf1msfCiyhcbCfrvGpvr6X7k92Y/s/r+hPE4r19y7vMlcxfavln/jSalvZgC7p0jvLjDAQgQwyZzKPkTEmIB7yVZpKTtzZGJwhvvH0AfCmOPSdqUm3DrGsyk07s0OijvaJkQwWh850T3yr8xX3DNBB1EJSRm+gphJnIUdG9HDrxtTb/eQfMTi9tX0aXcDebmusr4IwA/5WAyW/Q==
Received: from DS7PR06CA0025.namprd06.prod.outlook.com (2603:10b6:8:54::31) by
 BL0PR12MB4993.namprd12.prod.outlook.com (2603:10b6:208:17e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Wed, 27 Oct 2021 09:57:55 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::58) by DS7PR06CA0025.outlook.office365.com
 (2603:10b6:8:54::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Wed, 27 Oct 2021 09:57:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:57:54 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:57:54 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:57:51 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 01/13] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Wed, 27 Oct 2021 12:56:46 +0300
Message-ID: <20211027095658.144468-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16d097c2-279e-42d5-30eb-08d999303f51
X-MS-TrafficTypeDiagnostic: BL0PR12MB4993:
X-Microsoft-Antispam-PRVS: <BL0PR12MB499339E4AAEC1904320A0ED1C3859@BL0PR12MB4993.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9yfiEuse/Xqn7sWZziWJ4Ib6IxJJtVgC9XHRU53VndeOj8aGzmkNtZX+jSxL2VTyFX7gzrlEpW9HMQC+2QNTRbiGLhNhxBVJFyG4kZo6gyCsk5Cy/WZbesA97ZY2AGYk3IGvDpEV91bR5lq5QgX7PCrBz1u5eWt9rgtVFsC6hD25HaPGnPf2gYx6CJDVP4oxRwh6cK3rqWpf3Maz8cZEF0R8hps3cB6ZI4jRwv+lSCLoL57T17gzNJoO5vmzFXUdoE5+/8HogzCLYRQPyDcHcuhcGL1h0cnmrlk1QT86mxLmdz2UjfiA8a+MfxlgPAKGOeLFYCk0BGFfou3gx5Sz9iL4UduyX0VjmwEJXjmygHx4WJTtsIkGIELGlBVcBKcCIPdnlxnAIYF4c6vZLIbPjmfvf9HE7sA5/SgBiuzUamzx/OVbiV4NdnF0XKIeQVRyRWE7BzjMRXu73HPXhJdJ/Yu83xkUDOu9w/doi6nL5OKOdEgcjvgBcGxtgC+jcpyXSIV18cXGocjPH0GVdxP/DtG3WTYGI+404WF1uZoUX8JL7W7v2UtoJpGqC+vg9+gc4th09MMDLtjvE4y28z/9X9S6esNg/ta+H6fwMymnHaMxo2BTyrfNleceuZwTodCUhqK2c+Zt7faSc+sjc9iUiOjGQPkB2qNfV95uCA1NVgYzPl1oBlGHlMValblnz6Ik28ocbi+QWIBIELY6BStvA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(7696005)(82310400003)(83380400001)(7636003)(1076003)(110136005)(186003)(2616005)(8676002)(4326008)(36860700001)(5660300002)(356005)(6636002)(426003)(26005)(336012)(47076005)(70586007)(86362001)(107886003)(316002)(6666004)(508600001)(36756003)(70206006)(8936002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:57:54.8172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d097c2-279e-42d5-30eb-08d999303f51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4993
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

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/iov.c   | 14 ++++++++++++++
 include/linux/pci.h |  8 +++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd0..e7751fa3fe0b 100644
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
index cd8aa6fce204..2337512e67f0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2153,7 +2153,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 #ifdef CONFIG_PCI_IOV
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
-
+int pci_iov_vf_id(struct pci_dev *dev);
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);
 
@@ -2181,6 +2181,12 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
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

