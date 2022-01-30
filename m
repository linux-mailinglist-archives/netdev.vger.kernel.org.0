Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B894A37AB
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355656AbiA3QP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:57 -0500
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:28609
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355685AbiA3QPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obf3AOgsB9gw7/NvT76hikNxCVhptZ3isuLEA3XTWxePCp3rpdA3n/CPGsi36zZD+1tqveb+7G7tMPfTu/7js6VS/50co24kUyE3Q9gyDy6mFjgjfXZHyEwRYaqYJkDORGupqV1X1Jyi33xwnWMPdLdLmvdojxwUcJrs/pBXrOEH2lzAfwzcguGwqxH6m1UoHm0SNDbv/+WYGgADt7xIyaFWCu4S55PkzNL5zSJJAj5IWxCOI6H6vGDqdzzTULWGhDsfIeLpSfPELra/ORktdSla42vW5sv7Dq3OvtTtpNTOjSp0Ocx4tJQJw+0hgVDVy0u3suwKOiWWWFf3GZhokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxv1uOw0I4P4eShYTsviRFdCl+zVHza0U2QCm2wrmOc=;
 b=Gq/TCyuj//skORGPkQiXdw5v/A0aemmm+VhLGIZb4XtOKClapwlVvNAjVTY6d1uWhpENXPeZ9LOomJ0l3hUn8TIETsgoRPKc55BdDG7Z8Ul0xcovfTkRrxv9dD8xs4dQb2fMAq6hG7SfCQJOdEy2XP7GyHaxmrh9+dX566BwFHCf5ngOpZB/ZjGbQf1I4/xs+Zvw2we+RjiOFHNIPncQnmHkFc1T1Vgu7PRohawPgDj+KeY3UkzuVBZULbwS1Yq15slG27O9Ue/SQ5WmwOiyQeOzOV4nlqaA1bXz4N1ziWS060x/OATjFCe1Kf4L2LKU2eqehjddD6kQLiKORcqU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxv1uOw0I4P4eShYTsviRFdCl+zVHza0U2QCm2wrmOc=;
 b=dvFa4SNLLgEiQ4vAj40FfCquIoAbWkM+XmV2fVG1iSATziOjlGJaJ+3TiGEeE5LLJcCbXv58q6zxrZkobQoDkUGAYOYlU09V+uZ9q5dJBMeTNTKKkN8qqte5OHaBQ9IXcHC2zS3Zny3Nl4w05bBTT9ozjtWZMJBaQLrO5w8u+N7cptGMUxG/z++L6NIRAnAsHn6EnzSLHoqtpv09vdFYonsSr6PrOfrJLLKHeAUMC8fC0Zk4JFIWnnqd9iGFWowCcjelJRFNGZs9zykS24O/z5cYOiDLhi0rLWMhgZc5xOU2/7ls6y6qbxzSmxTKEke6yPdAgdyXNZbKdrjili57yQ==
Received: from DM6PR11CA0026.namprd11.prod.outlook.com (2603:10b6:5:190::39)
 by MN2PR12MB3712.namprd12.prod.outlook.com (2603:10b6:208:164::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sun, 30 Jan
 2022 16:15:32 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::9c) by DM6PR11CA0026.outlook.office365.com
 (2603:10b6:5:190::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:27 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 13/15] vfio/pci: Expose vfio_pci_core_aer_err_detected()
Date:   Sun, 30 Jan 2022 18:08:24 +0200
Message-ID: <20220130160826.32449-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3da3f58-682f-4151-dd36-08d9e40bbd09
X-MS-TrafficTypeDiagnostic: MN2PR12MB3712:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB371286489D9AE494223D3074C3249@MN2PR12MB3712.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hp02yibww46HRZLpBtFmMMeFAcE+AysJrh1Siw3Tpxtm7jYislY2tbjelmug3/H8WgkVGa2Et4C0xL6bzfHdvQwodxPAjIO1caMZs1ymiz47Cteq5XIPCeRv/31bCNJ5NOn6iUnut0JZ2ZeMTqpJpiVwW6vVlQnORScCd1bqidyhLWekwSX3zhPk1leiUkVZDibOBl+IIMp+ujHf1jMJjkTDmagTTI7roDj7JyKmFM2i2Llgo9VPgRVTUMi2QCES008nr6hdtda3U5lSX1PTsITJ5iVO3LcX34njbwsGhiJ9Z4SR8SSMfXaoL604tZ2wGyujjSZp79/3Im/Hz7k4sj+XFxZuCYD61NQpBrODPLVsfgfnTdC3pXOcZg4Bo5anFgBhAEtL2IMcV7SOURMpsJa4MGcgM4qVYgouA6w49E0q0bgYs3/jc8xgLLAWN1kk8ANEKCtKiLWgwOj6zV9eUhongAZzxE9T43aNzCv7E7NS7TCD9XS1dDOmr8KQHxXtjcQTYmWvPjC18SDDRa/HcUpGZjcr+2yqnKitcI8qjla70Y0ntCRfjEl59uq0qY4na6U9Spp/0dAaJRwt6D6Ixuxpaq9lewEMDLU61uJA3yDciBNWC09Unfe6P6s8RRTDp8HP0Y6rGnZJsMJX+yls1i6lXOM8oqeeWeUfVB0pd+NWewUTnm2xEfhrAbfv46gpCsczyWauZSqm0uCU3SrOlw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8936002)(8676002)(2906002)(508600001)(356005)(81166007)(316002)(6636002)(54906003)(110136005)(7696005)(6666004)(4326008)(26005)(86362001)(82310400004)(2616005)(40460700003)(107886003)(1076003)(336012)(426003)(186003)(5660300002)(36756003)(70586007)(70206006)(36860700001)(47076005)(83380400001)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:31.5543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3da3f58-682f-4151-dd36-08d9e40bbd09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose vfio_pci_core_aer_err_detected() to be used by drivers as part of
their pci_error_handlers structure.

Next patch for mlx5 driver will use it.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 7 ++++---
 include/linux/vfio_pci_core.h    | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 14a22ff20ef8..69e6d22ae815 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1865,8 +1865,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
-static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-						  pci_channel_state_t state)
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+						pci_channel_state_t state)
 {
 	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
@@ -1888,6 +1888,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
@@ -1910,7 +1911,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
-	.error_detected = vfio_pci_aer_err_detected,
+	.error_detected = vfio_pci_core_aer_err_detected,
 };
 EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index beba0b2ed87d..9f1bf8e49d43 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -232,6 +232,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+						pci_channel_state_t state);
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
-- 
2.18.1

