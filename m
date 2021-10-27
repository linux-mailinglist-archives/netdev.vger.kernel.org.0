Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D665E43C71F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbhJ0KBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:01:35 -0400
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:21601
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241388AbhJ0KBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:01:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hN4NaTSeO0hZxRp5eDPoJDWWLiHIvdL52XwBZKbxjB64TwQdoZLQAMFYFHIKr3m6vXUyTHXVRUDX1TbbgyrC7cIlqocRVaU3ZGnvn4pXotZUV3QbLngmwEpVwCF8E1e05IyV4+HGUXNJRVmIvO/TpOuruxFndzvBBJJbO5nix/BPDjo95tW4+MpOgxPaIUTD+BQGImH56zvdMV36ANqfZv6af8KEQhDOVzhy5ppdMyy9MXVmFb6POCP9lXBiyl4lQ1bWNgqB5zffkTDs4D+xMjJ0yS+Dg39ntE0erq3Oedp5LKZ4pWh88PRT1gYoHk+Cg2ky/o54mm8iwizwl7cwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ja/rUegBB7659EIbtq3Kdem/6ZPQT+8i4/dTHhY78k=;
 b=I9Sy2gcucxWPfdI3uyUiMCVKyXY4hbs8p++4iA2+ztSVEaYJOgOqB0olE4c8QCgJn8X4TWjBq4ZYP5ijSoaPruitxKmDhp2/V1Ji0jDGGogb9FN/CywSmpb/HN2Efr/GZdrgN5Rc7SZ6hYHqjiyP4mkSS0Ecz/eEejEQfm0J2Yv+PAFrqWdc4M61kBtp4pP72KtiWB0gdRiCA1QHygpMrgfA0/s+irRiBpAhhCePhEL5q6eMAyxRnspaxatzl0i2u4TEBx/qjRUQyqM2zSjVjC+0v0rOc/zcH6mLNbbsU+Bs5dQ7249cMK+d0y8ihACcL+O6GpmmC70FH5VLS8tPJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ja/rUegBB7659EIbtq3Kdem/6ZPQT+8i4/dTHhY78k=;
 b=bWa2D7g3vZlg9wnxGPuf/hSS4RErjiNDDJKyuNQwmRJeHz3thHzVu4iKhHUzWm6CqKoWNBIdahpJjF2HntREZBkWncVptuaG4R9HowbpOaFd3uG08amgTqGM6DYQ/nhAfc2WFOqVoZyNmzhRH2ehtLlmNDPZu+qxEcSyC671RsLP6oOrgXxamCrFGWhJDaR7BodKrLy0agB0OcuBbBnj72Gf//YtburOf2WnjdEg26EBTyKHKUvOZHUKeGVE/2H/F0GKDXYs3fkwf5vFM6rlhXyvJU4K5KNZZwHtnxZOhjCX1YGeHu0099QnEjNokqO0wTCZ/8dtA+SEzCroRxotBA==
Received: from DS7PR03CA0048.namprd03.prod.outlook.com (2603:10b6:5:3b5::23)
 by BN8PR12MB3250.namprd12.prod.outlook.com (2603:10b6:408:99::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:33 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::15) by DS7PR03CA0048.outlook.office365.com
 (2603:10b6:5:3b5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:32 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:58:31 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:31 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:28 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 12/13] vfio/pci: Expose vfio_pci_core_aer_err_detected()
Date:   Wed, 27 Oct 2021 12:56:57 +0300
Message-ID: <20211027095658.144468-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7534a1ba-2801-4e8d-b8e4-08d999305601
X-MS-TrafficTypeDiagnostic: BN8PR12MB3250:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3250D7DCBE741957AD1E5054C3859@BN8PR12MB3250.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qBzf0zSL4VMbtTg62aYY35XlOxgI8vmHuG0hKmHwIYo2VxUC4Dw/acpYK27lPIsU5YxnUK5kN58TNpxzu7mSqeP05Mvu0nAtAeIhbCXu94+q2FHyVU8dEW+hanRWjsMh46zt1FQ0ViTB5FlG0NTgpA2ll69fVeZisCrM1eqL/bxvBqlSAoe6YuC3yNxF4wCHSBTKc623ERbb8x1UE+AI89r40SQmrR47l3TWOSfZViHHhEwvmqWWOZ+G75xAyFxTxUkxtzblOgbL988Q16n2SSpzquMPvAMe4bFNG8GsEoDaQdV1HcJMLfcyh1r4MFdjLcpIZjZGL2ZZeK2vuvjr71WaUBEozilmR3XPIo4ue94tAhnBuUtPcusnrgAQJqhKQuZuhp/GUL2xrpeqKuDJ0LIWtj56gqdJYMYpVeB0RGJXR/H/eh3rlyJ985GXrX6BroeykE+Zp/KNXpoVVxLxicgsA96tWLKWJ1k1DNxx4ChkcC80Cdl0EyfPWvCknH6OjQjVOjcsP7M+G5MEpmXiXBOpT9gzlyVzyHpUyY4WU1E7QXIkZ/r8ybZ3ZqEyccMRa2tVN/NKlb8nQkF5ANV3j5Q2O0Y9hhlsvbA9j59PVLs4/kxJ0hQMfkvqrU+P4opacLl9fsDK6Gsj4X3KZj5qG4ZOaDNbSSKrOdMDGVgJvaZqv7Ay7YBwNW8BX5uZ6mIzR6FQmUKvS4XY8Z91tOeNyQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(82310400003)(54906003)(8936002)(83380400001)(426003)(36860700001)(110136005)(4326008)(36756003)(70206006)(186003)(6666004)(508600001)(6636002)(107886003)(316002)(86362001)(2906002)(1076003)(356005)(47076005)(2616005)(70586007)(7696005)(5660300002)(8676002)(336012)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:32.8010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7534a1ba-2801-4e8d-b8e4-08d999305601
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3250
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
index e581a327f90d..80e08e17d027 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1901,8 +1901,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
-static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-						  pci_channel_state_t state)
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+						pci_channel_state_t state)
 {
 	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
@@ -1924,6 +1924,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
@@ -1946,7 +1947,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
-	.error_detected = vfio_pci_aer_err_detected,
+	.error_detected = vfio_pci_core_aer_err_detected,
 };
 EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..6bde57780311 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -230,6 +230,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+						pci_channel_state_t state);
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
-- 
2.18.1

