Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D562E43343C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbhJSLCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:02:46 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:27649
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235408AbhJSLCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:02:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEgAldvft6tD2q1s7/YyNh8i/XogO5qP59WYVmtsO7sMaTQXdF93/dniRs5RNN8gI9e1nd3cgE/fEe306yYR6jpxjlswDD+pqXbO26Z0cRvcXyDDVln/Qij1T2kylV5GWyu0wAoFCt6lg7RfPk0qI054c0EOmTAV1yIHl0vQ03BRaoH0fM4KDeihUqnohbrhRCQ1lCpLIRLCEqvWrM5wfEV/tjrQ2n80BG55a7yTkoinKwSQZqAfiHEe9r+zHuo1psUxDnZ5DBwmB1wDnamrxosqCqkbkD4sDr34T42Ae0OKqjWraqt9M9qRiVzq6MnVV9L2igD8TsVWcOsMSwEWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLKFU+sGvBKXZ6cjTNa+FhQ1WxILKlXRvDl9qJoQPqQ=;
 b=Vn95dwrSR1/dfAIomg4zLotckRJkPCRmnPHdQL/acXFSd2jphUEKbStD2p6BxR5iE2SaA5+N0jWcs28+pNIp9ZgEmoZvxtgc6bdUw5E7Jj7hjAh/RhaQuJo0DKiOtLDgq0NDZQnjOj+c2jdKCfwrG3oU1O8YegvAdUjtD/1nwk2udmsl48cNuaY3rB1EqEUha4eFy9IGNlzzp6/mWn1LR5Io9S1gBFl71E94g2j5Udj5ZohVqPhTGCSr7JBli+maa5jqmhi5pbyxjYDte9QIQxYzr4XCGAdzsY+BZSLv0z0Wa7zuG+dLqkinTDpPkqZJLhi7rP7kX1PzVHbj8ANPRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLKFU+sGvBKXZ6cjTNa+FhQ1WxILKlXRvDl9qJoQPqQ=;
 b=QYyKl1sBLpYPjMpxn+vPOdllvU1kg65/uRjNelOMtEkmN5nVzhaPttxEVENtWHV8aAkXaxBxpVJgnZa3CemVC4SS3FXYjW9VsDBIK8ASnDsJpXa0O8wqIQjCuw2FnpncKNGngdhWZgO9fXpxxMTq3ckONWLG0+GQr2SE1VLmDJfz8a3FRD+XfnNlLyUXmsl8xtQGruJwEQtL4a5dY4X354GH6xrtL0Xg0x6fDkMM2NuAk02aE7GaVwQDaXMaKKixX1zvBcy3WVUSrcr17RCucK0cJsAiUOMQ5eg4yUB7TdaJkz+uR+eNW66CdHZD44vRt4uNZRD8lhlOoPQO3EU5Kg==
Received: from BN8PR04CA0002.namprd04.prod.outlook.com (2603:10b6:408:70::15)
 by DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 10:59:58 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::14) by BN8PR04CA0002.outlook.office365.com
 (2603:10b6:408:70::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:57 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:53 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:50 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 13/14] vfio/pci: Expose vfio_pci_aer_err_detected()
Date:   Tue, 19 Oct 2021 13:58:37 +0300
Message-ID: <20211019105838.227569-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32fd51bf-0b16-4154-1861-08d992ef972b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5357:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5357B6810404EA1EED3D6BADC3BD9@DM4PR12MB5357.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GEysapSabDjvQfgyesbLaYShRmozP/101WK3nAJ52FwnaV7CDPTZHxMQJ4mIsl37BDrtUjSXD7X/+cltel4YZqIxqMpeU0yI0puA9KHsjuI5XiLtI8bRxDN7GW2ZBqv/WBOCsQma9wre9X7xVqxZ5YrGYxNjzE5Hk/GErhho79Z1ZUA9hXiDoGAuMaMJxX0e58CPkYIBvU/rtpWS6JBF9bJ9UP5xHUrKi+HhKav3d2WiiINVIKSaLic5/SXlkzmxPaV0+B608U00dtj4F4Z57ZtWneDbZvumuTQN0anLV2/uvfE3WeNtWNRiD6xBqCToTuZHXoRpN9NGed3KH5tRk+2DAQez/phxB4IRLsR1rRaZdNSkZNG5uBEYaDsmo7ACBJNQHEAvIwpmEnCVEnCzLSh3wuDp0fxxI8mqDf6g7tvDTtz9OqQSpTzkBF6XPb0zJvXLmh6QinVkXDspnSwzQTfmTEA6rVkw28dVvU49LuewGT26POXJ3/tLZtrHYHtTJiPaGwDxAtndOG4ywLNvUcGpEBlOeAg172fRpI+ZhZOpnOqBJ2jaHEXxgHqIPFtemzNfsd9/vvO0qVPMFilcW2Df1kKjaCalkfZ6eAOxZFMH4bmiOpCzfN8o2D6IIstKmjzDANpVYmguzVXrv0P6a7ECiRrVm5KpWG1JgR5VsFn4QQt/Ls/XvmALL4GO+jrsLvI6h9+F+IrnPxLPHEKzKA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(336012)(316002)(2616005)(7696005)(47076005)(26005)(8676002)(36756003)(110136005)(426003)(508600001)(8936002)(7636003)(356005)(6636002)(83380400001)(82310400003)(70206006)(107886003)(186003)(86362001)(6666004)(70586007)(54906003)(2906002)(4326008)(1076003)(36860700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:57.5821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32fd51bf-0b16-4154-1861-08d992ef972b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5357
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

