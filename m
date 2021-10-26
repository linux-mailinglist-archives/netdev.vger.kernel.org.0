Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0280243AE8D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhJZJJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:09:42 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:53952
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232712AbhJZJJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSeLnmkwkWwVlDhc6C0Vw8MJb6+gmVDEDKmWbC+X9p3XW+ot/rXZHMHMpWvVlCl4/PX4tYxBjDcvVm5Hc3p/Vbcd8paUESCMtRXq0xkdpGKE0Ud0T1MpkjhUw2b77HZLJgfyxvNfzHBVHPCCmrQbBE0SL0drRtbG3Rna5MO4mrsF7w3wLyK8PScM0K+U9+wvTs/4sFkOkbQUGWwuJJuPt/LmA2bOYwg9bgRLeA8QBtYTGkXPM5DQ5D4+al5xoJLjaoVp3XHrh+W/MDeyVCG31b2VtmUW57w8Sls7TYvx5jcStg0XYPMPGHScYJjt5g4s2IN6g2xbVp3fucYIEqIH4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=fir1LiSYGLeUEW+b1VaA5prTre5cRW+91n4VW30O2yprMpCeqxZrXwmnTCTf8EvrV5dHk5W/6nIU8iJ2cbSdRFXlVpv9CnyjuAdg9FBo6VmdE+5yuBupE3Z5a1WQuSNVfca8/2Nni+7aA0GsuMiv8gFBUkuJGQSqOL19CIkuqnnzrvSg+ztdPKbUi4YJrt5uY+Qoumo0zI+n73al7eg+CT9DRPHstrtTXK99PVf2nzLU2zqhq/2qeXHIqrSipliaySCGPUnkRx3uDudO/Yk8WtGDiqITGG4lq4kkwm7ZBso/GAs+d2OeUpF5h9q0w3Db0AT5VL8Oj7iiMoztPz+M+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WQC7MbzY4SkKjUkPCgiLuU12kLGzfDWQ2BT0ZKYN6s=;
 b=YwKztFTLFk3c63GDOv7j8ufJvYIbL1M3kOIHBQNH4Z1VM4HMLVehfgMQLYvg+a9Qt0rmQ0+qI5SAz6zA6f4w/wgNkISCulySuS+1LdSbwbm9KQ/JkMqTHusckfAj1CWsGekLNiU6NH7jb995Kal8B4yl0vQj5mw3K6JW/fpleqFHCnlIoATAMerMHkuGwjtKsZFofJ0NAYJOKHetSBas/Q3UKd7J+ebzEj/wXpUF+eSIWdwuzUbUPq8ZV1G6hdGtsiBYjI71hjLHkdpiocD2gWBCBJUHqy3Wn8pcCaJwHPXEAHj0CwAHkzwG1JVXy+FZDLB6WZx93wRzNxo5tj2NtA==
Received: from DM5PR05CA0013.namprd05.prod.outlook.com (2603:10b6:3:d4::23) by
 MW2PR12MB2364.namprd12.prod.outlook.com (2603:10b6:907:b::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.20; Tue, 26 Oct 2021 09:07:14 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::33) by DM5PR05CA0013.outlook.office365.com
 (2603:10b6:3:d4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:13 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 02:07:13 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:12 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:09 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 01/13] PCI/IOV: Add pci_iov_vf_id() to get VF index
Date:   Tue, 26 Oct 2021 12:05:53 +0300
Message-ID: <20211026090605.91646-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc6f9498-1c6a-4b71-c3dc-08d998600047
X-MS-TrafficTypeDiagnostic: MW2PR12MB2364:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2364CF3ED9C56D3122622CEBC3849@MW2PR12MB2364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziViRgSkfF4u60sTLaq+cqL00zjJy6wK4awKtmbqdoaKXjrItSQ6Nh+2wR13VyzrheOti4KkscIJ35Qh3cJeLVC7JHPOnFCEyTQgddmA1y/2L/w1GKCOafLVVPUJ1DButSvx0oxVrkjVu0fnDtB6MOBG2IpsuNP1gzzeR/6zetkWv0AQkr5BcRItS0sRGObkArAVPs/Kfh43egdga6iSkg3yxVPtFLDXhcMnyytm9+lil/CrbQKmQBsFglUTcSnK2WxeovuLVohK0Bt47fgVgHFW6xKCv01FZw+6qFx38PPLWUYs8GNgyJuUu2T5vuGf4F+k9dlrdNnfeTC5j4Xh8prEf1ta3mFSRKvjd1wr6+lC+dPPVfXrinwcEdeiM48jutwdItC6AlfYDnob/vXP9/VziSm8ImB3qmXuHwr9nst5N5g1bnDRdq4AcPCVXfnVzA1eO+/QKF628QmwqBTs06J8VcmBOrq/yyKYSe3Fj+7lMFTY605oUU7hCgsqyhc0PLVWnJqNUSK328HSycNGR1vl0XT5XW499TdL+nn3OYGJ5Z2wMyiVrnUaoZvhYrQrLY/Gf2DSyw5grPNk4g0Gwv0VAxPE2OZp6O8LDPQGs3LgUNnPieWLXCSEuK8mNTKPtyhJv30v/r3M3dj0uwj4dpmk2F9MoIm8AygaJJOSGjk91S08kE7YUFrbpVR2DeSjKyFX/rwB9nJh8RDYGVdvLw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(82310400003)(86362001)(47076005)(8676002)(8936002)(83380400001)(6666004)(508600001)(316002)(110136005)(356005)(1076003)(54906003)(7696005)(2616005)(6636002)(5660300002)(26005)(36756003)(426003)(70206006)(2906002)(70586007)(336012)(4326008)(186003)(36860700001)(107886003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:13.7512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6f9498-1c6a-4b71-c3dc-08d998600047
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2364
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

