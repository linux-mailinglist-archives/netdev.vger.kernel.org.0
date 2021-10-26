Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC7943AEB0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhJZJKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:47 -0400
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:45312
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234803AbhJZJKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:10:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y54UVEiqWavvOr3EJXJDmcDNlnUvsxz+7C48QHsAykCTqzR9kzh0LhlVHPgHcBvrT9ksx8Ek6Bq1FFyhsT7YhaOT+uq2IY7hAVKr6Nw6yG1vaDkddE/C7HFhkz2LeMi9kG5tTpAArEIK3exobYElGAcbr/VFUhXMK5x0WpPOpK3Ph7QeOUI8+jAQcV8yZdwYbtP0Uo16DhuvTvf0AjxjXRih/QmLC8EnoDdfDeYsQlJtJpfmlHX5wuxT3JRIIqTfq8ec9HdbCRpSmvLv/mZh/989C2HrW9UQzcdZVjP18RmUe11vvz0lb1P40niF54lGYtxQgJixDIKvMsyQr8UT5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLKFU+sGvBKXZ6cjTNa+FhQ1WxILKlXRvDl9qJoQPqQ=;
 b=C1ntDcXVBhycUmmyFbXG+S2cTiAbTIOAjkz2I0gOFDj9TUn64PMmbK65safO4TxAt7XW9DSopVWfYHleux7ifgT6aPi4zG8zAVjhirg9qFw8sc2B+6LCr/9BMphA1t9ia19JDIuQGtJp7sT7RmIMHMRR1BujuOAKO4ab3ERJjnnynktKX+tZUY/hsSfzIfJLazemEB3aZKgkhnA8I2vk5bRsmjUgMYuPQGR5EpgWDUgosC8ayuYVVCnoLS8LrkDNgw0OKhQuc+RwwRxRgxBUnm+2FvnHo/3GXNH/JGiZf8vpZC6HZCN9YEfa/iKy10ixYMWzSnE2nBhWBrZ1I+PiBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLKFU+sGvBKXZ6cjTNa+FhQ1WxILKlXRvDl9qJoQPqQ=;
 b=eJbaR76vWnqJLCoSud+o/XJ68E0xzZbfo6ob8WYZXLT4WkRWc9P15Ysat9NTwmHiGWYgr06iynudrskZ6/Ul/42vrdAvBXopqThccOh7yiascOrnYh/QVV6nz53SPOlE/dM3NJ+ouFf6JaWQVodsh5VRAcXLX/F9ynqI0p8Xst5PZ2qpHxTIjYFg/EzdBuVKcCTE1UY2jBSnhYChc3wrt7c3X/GyGQwwU4rMu6g82i2ySt70WkACCsu5uaiFkCym6mVbNln+3KFeibpO+qpPGq5lo2ExiWnCp+fXhPnGwOGJZFxeHgUvJKAjVMQ9QN7PMPOaZ30JVEubDUlbofuNvw==
Received: from DM5PR18CA0075.namprd18.prod.outlook.com (2603:10b6:3:3::13) by
 BL1PR12MB5093.namprd12.prod.outlook.com (2603:10b6:208:309::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 09:07:50 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::48) by DM5PR18CA0075.outlook.office365.com
 (2603:10b6:3:3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:50 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:49 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:46 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 12/13] vfio/pci: Expose vfio_pci_aer_err_detected()
Date:   Tue, 26 Oct 2021 12:06:04 +0300
Message-ID: <20211026090605.91646-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ed61919-8e29-4576-9afb-08d99860161a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5093:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5093E2B85113EA08E49181DFC3849@BL1PR12MB5093.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaUD1RCU2iv1rODeDFdBd/atRXLuaApk8/me8Iou4daAkZHlq1WzmospdFROBbquxlUdLknp0iU6bziPidsiR2LyVIad0fps8odvdlEihxZA6OmJ1VyrttazYApHQesk+P450fY2p2rTAxgm7yT5graNI+fTbOelC4tnU6bEsLNo6n6swguNTi51A+fwqDCHrpzaT2accwc0AHoC92PvyC9EQ8SQqpxmQcaS6gyKX0Z8pOKZfo5JGosItKnZTLn0z2ANFZ/fCEQTfJr2sYookPnWNNXCOTILZFh1c8RnbEy5BBeZZGQA9qSC8+kMiFk8aUxW4b1lWcIEYNa/WxUl7DGrrZhf2D/b7lHidecwpp4/1fUB9iQIog+a9vXvI4kd+1SQB7rAw5BqDKMI4kMY4PCrfi8aivBZ27cUnbVC6rlPfpiQ3UOCHokAvfbIPaYD9f0ohDQ0nH3OTpyTCNnzbPgpHuBGMj8P6GS/M3LCDtqhf6+SChrzKt7ke+QGtBWcr94NTvIrSwyDqx7i93DUvgG19JipZG1am7cpL5Ty+c5WL7mBBjaOFZaX2c8WX5ephC0CYyQxiCwLD7ggwj8uJUtBmqLmmIMqZXM/zfluCMAtYFuhsqk5nOxNdhjbGwgvjuX3Gbs53bLfjYq2wlbFTlTWij6OE6BT8JDw5FWhwZkWUlHcchC6n2hzI7hlwL021YnII33RtnBxY3IQxNSlPQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(86362001)(6666004)(110136005)(356005)(70206006)(8936002)(7696005)(54906003)(70586007)(26005)(7636003)(83380400001)(82310400003)(6636002)(47076005)(426003)(107886003)(336012)(4326008)(2906002)(36906005)(36756003)(316002)(1076003)(2616005)(508600001)(186003)(5660300002)(8676002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:50.3741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed61919-8e29-4576-9afb-08d99860161a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose vfio_pci_aer_err_detected() to be used by drivers as part of
their pci_error_handlers structure.

Next patch for mlx5 driver will use it.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 +++--
 include/linux/vfio_pci_core.h    | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index e581a327f90d..0f4a50de913f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1901,8 +1901,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
-static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-						  pci_channel_state_t state)
+pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
+					   pci_channel_state_t state)
 {
 	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
@@ -1924,6 +1924,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_aer_err_detected);
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..768336b02fd6 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -230,6 +230,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
+					   pci_channel_state_t state);
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
-- 
2.18.1

