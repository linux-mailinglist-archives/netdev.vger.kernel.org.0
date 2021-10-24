Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D66843879D
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhJXIep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:45 -0400
Received: from mail-dm6nam10on2053.outbound.protection.outlook.com ([40.107.93.53]:4608
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231792AbhJXIek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZJy76FdgdN8xOf+X1P9p/9ABL30Ic4IYrfE3ZRo0vZ07BXuLnWqBphQVpSxExDIyrJgR+BCnO4Jjp3JrzOTbSlcINqF6v0+VgwaAs7kOv+/xmONyiiekt7bBpxQrIjZOni5AyPxTsZUPWacIufbc2jMiCzIrlomKWDRbi0NUJdJjfpKes0q13AJAtYNc9202vSn5bE+MwVerURMsX8i9wC0M5AU/1sJmWIQDvTYIBg5S//ksG3ET2U4EyoTE0En8A4tJV+7i0SAAm3T1js3h5Wqv/UPqZz5AnVSd2baFeQkO+V93//YMFC9jchnZP0z8SstW6ydm32zAVNcAQsLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLKFU+sGvBKXZ6cjTNa+FhQ1WxILKlXRvDl9qJoQPqQ=;
 b=X8NtKFJIoF2rtC/3XRfPitInisFdx9QT+Psyw38ecAEmzOw7vedhyvVYbL+VUeUgBURcf1VR279p3FT5FjIMv0XV61HhAyav6VVnc1ek1YX1dN8KcrLTJ83kgKl+jYiQRjgcM3xZmnR4aQcQYTHuh985oZ/AgqLRPgPvANaBfMzN0lK7TX1emndUn4FW2EyxbvlGNCmGRloHy/VVWkP7xffx0AjJsabvlZne7EN+4xii9yGAIkZ97hxWfX3p0ZLfzdqYVI0hQtDqF6gEB8OBkrarq/G5cmKS7Beyf3ocRNQESisWabBVfSKZUqWEdEkCcho5uTpqyPafhcVwnHhlGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLKFU+sGvBKXZ6cjTNa+FhQ1WxILKlXRvDl9qJoQPqQ=;
 b=FOwHcbd8of2eMeOK1j9e2lPrQF3ermLe3uvH98vvcZkJsjAgBQACWko7+ZyXYw2egv035eOjxbpRdHVudYSqlUcJIDuMMaZ+Cdiprjqrj5Tsqv9TywjnRxn0T6ql7116XyK8u4UYkpqSRBycdxUkfjmEyPIydKLowFAvRVvkvj2NbtKQpgFIoinGSGCUkeYzfd87jqxRS5cS5mQ1G6MIqDvIAm7L5NIIOj7URm45mBBoN0kJliU85ZBE6TWP0AIWYqW7Ud8GcxwAAL7sDLeSOSaKSIcWtFWz7Aemz6x7zrvO55lYsAoIXrYJdEBwq47dFncsPxV5BKkB+8hynV4c+g==
Received: from BN9PR03CA0287.namprd03.prod.outlook.com (2603:10b6:408:f5::22)
 by BY5PR12MB3955.namprd12.prod.outlook.com (2603:10b6:a03:1a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Sun, 24 Oct
 2021 08:32:18 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::73) by BN9PR03CA0287.outlook.office365.com
 (2603:10b6:408:f5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend
 Transport; Sun, 24 Oct 2021 08:32:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:32:14 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 01:32:13 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:32:10 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 12/13] vfio/pci: Expose vfio_pci_aer_err_detected()
Date:   Sun, 24 Oct 2021 11:30:18 +0300
Message-ID: <20211024083019.232813-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc7a1c39-3a41-4f7f-4b50-08d996c8c867
X-MS-TrafficTypeDiagnostic: BY5PR12MB3955:
X-Microsoft-Antispam-PRVS: <BY5PR12MB39559E8A41B03DE17DC514D5C3829@BY5PR12MB3955.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VG2qmww9Cmcx/vlQuKZdST+ofLCZCbf2qeZoNQ0iwRsuLk34lvKpi/vgLd2++nsAJVxyyWFfUKKfpyE7JV/eYakFTbzygkd8XOT9hJG5ek3nUHtLmyct2OxQ9wRlqpYn3YPInhWfohT4IKJN3Csu1b1cBKNQPLFZVVq65UfvVd+48a4g6r7J2NdIneo3Q46/vuDui0nHCrGiZp2/rAr7k7bNjAyUCXVnxTpdi+DFeHnShUhhS5oE+9F385JFyNs609McnEENAtwE7aklogXUPgATIvLob3hN5ekzzm+oT9/QRjd3XLzTWh1j881gfJRfLY5g9fpW5B4xF95Q1MV7dtLqoctqfScoY4TH/pxK4GaBfxC4gkQ7XOVr23ivkRe86BBKozzBCRrtrC1STZPkzU6aQ5gSWGr5r1kCnhyzLB4CFGLXs9CztJVONncK27EP4h1x6/EfjDm75LynmF3sp3RWHedLfkYf1nTXhFgGwfhSRfvg/Pvp7Nh2V+sJ1cBiGlKAwpCngm8ImOkZokKpiVbR1egWR1z/GS66ypXZW8xqV/4muw79LK9uOn2K2M/fwRZ6veA0+Goem6K2BWJsdjKDQgvba0z/6rqTPLPRfl81UWDREPZfOSayGeHU6jj2IpxhGpoGt0qfbbUk+hb7bnOAR3wwO191+RTivKoV8J3/u3VeCdgsa4FANiSOvC2tYC8lAr4WMVApZsWC/raNNA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7696005)(5660300002)(47076005)(86362001)(316002)(356005)(36860700001)(26005)(6636002)(36756003)(508600001)(186003)(83380400001)(107886003)(8936002)(54906003)(70206006)(70586007)(4326008)(8676002)(7636003)(1076003)(426003)(336012)(2906002)(2616005)(82310400003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:32:14.7795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7a1c39-3a41-4f7f-4b50-08d996c8c867
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3955
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

