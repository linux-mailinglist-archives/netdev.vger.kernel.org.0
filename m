Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20806EE9A6
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbjDYV0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236384AbjDYV00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:26:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DB818BAD
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:26:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1ACau3SiDezZgGI3d+wQxP1q8YzIfcINNTK4Ev0hyOTeGRnk7WXNNtDv0Q4cSBwixkBelDOwjJ7SNNHWQR6A8MwGpUwxMhzuQR0SPLa15HHILqzd+8OpXY+JSxM/Wq/VQ/4KRJtJPnuygA6UjxwAf1PmdjxHiEL1Nsy/zzYe9Ibz7PwIAbaf0yebW/YXE2J0c5EePzzB9QdSX+2Tg1zvVgLyPlXxYpp5XLRfgtjfxF+0x8RbA44OiIN6d9THSx+uvexuuvOyoDvLnBMBb9fQd/3AzRGODPCxkBZd/dVbrwOrYKk4puqG0X1FSDvSOOTP6zmMsPuSLDVQeCQnBtw+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hI3GyhMnBtqvIHpTxFneyeexCVk+UAAzceGNrNvELJg=;
 b=iqq3vsxb4rMVMccGpITq3GRplMwTaqQ05Kq3MDb3gDi+hM1+Z1XbPjt3w3eVlvw6aRgwFEg0pvCze1st39Rk7sIR4CPQsJgIpHwJWckCx5UC90JC3BAUvOg3/xFG68z7T96ic8lLJIjgL7SmjiYcqYefMgk4MeEbcJZsEKxUc7EmUtBPAu/hKZP+lQQmBq/RkllzG39AJ8RCfvPc3CA+FwX0b/sLuWB8YRJAJUBN1Ugz1rflhKm7yZYaqICie6b3Vnoerrv2izCi9N/g66L8no8UKOIWN6JZKfHtWBUOOeggsSn5gvaJ1JVlRuJoINIMKOpOCKAgpaxOfbu4PPg8Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hI3GyhMnBtqvIHpTxFneyeexCVk+UAAzceGNrNvELJg=;
 b=uto6T7Czqc2Q1Cw7ZR/Mmb2I6ndKC01LYgY9N6UAy1ZOqM413SAF6E8BZEVUJBh3117L6RR8SgJCNDkI4PSqJA+lgWbxubRQXQvjLQv8RAzcItJgkzB+p1CLOkzdy1KnVTipVlK/2r9U1nL0IAud1zEN/VnfTj2y9R99tiJ2NEA=
Received: from DS7PR03CA0343.namprd03.prod.outlook.com (2603:10b6:8:55::17) by
 SJ0PR12MB5440.namprd12.prod.outlook.com (2603:10b6:a03:3ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 21:26:23 +0000
Received: from DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::5b) by DS7PR03CA0343.outlook.office365.com
 (2603:10b6:8:55::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34 via Frontend
 Transport; Tue, 25 Apr 2023 21:26:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT090.mail.protection.outlook.com (10.13.172.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.20 via Frontend Transport; Tue, 25 Apr 2023 21:26:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 25 Apr
 2023 16:26:22 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v4 virtio 06/10] pds_vdpa: virtio bar setup for vdpa
Date:   Tue, 25 Apr 2023 14:25:58 -0700
Message-ID: <20230425212602.1157-7-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230425212602.1157-1-shannon.nelson@amd.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT090:EE_|SJ0PR12MB5440:EE_
X-MS-Office365-Filtering-Correlation-Id: c8cd6442-6586-4582-a7e2-08db45d3b83c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mmRL3fztJlzxYCvCV7wlMIKTtO2b0cDJDvyPT2pSv6jvuEK7EHHHJoY4x5a6fBMpBLNKilBFYnJzK7IXrZDr4uJS2onL1Aueq4o7muX44J74TCjqx2okejsjVj809ZkNZ0Ss6lszCdX+3xmL3AlVE2WVnOWe1sIPXAUbsIeWdUH2mKGcSfdkm9OcbuTN1rAWx6kGa4as6fXm8OJ4/U2VhLeqITDp5ZNGpq4FWhh9v2MJqlB4f9BaOjZ2AWjNa2lswHbSbUGAW+Q3MYsaoYrbYR6jqefPfZnao/5AzAx0QKkmv0RixmL56AfyrAkC2a/Cc6hj3KgjlfKuv6GuwZZNu+F2i4cbrQVceWcz4ugLVdf4liTqCGXdbicr6wpaOtogm/m3ISZGZiKSJwKKz57IFEMUZHI3bDSBR6Qo3ZmWDlwnDxaWbPKplSCYUiD4Q6fEZomnN4hL4h2f5GL/r5chfyecaVI0WYA6zfggc8n8c8UhAdFMoIKsOnlfwVy+e84UY8hmx0vnqzIuo0NjQ2DBGw6Ve79C1lkIhwAjsVbsJqZwnTdBHeriNdCDJjus7ag+KoAKNEJggI9LHkFV0Zx8ylh5Hwa3k8qG1fTdvvT7y/VhMLQFnBvqAlkLFfspItGSM6iPRALsHJDEuTjof0y31rBXgk75tl77NV61FhWxQNw4n6MrpsxHa4E5c6Br9F32wvV0SxSfV/mHO72qNw4t4RD6jQdbhgoYnL/BqATvAeU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(36756003)(110136005)(82310400005)(86362001)(478600001)(41300700001)(81166007)(8676002)(8936002)(44832011)(2906002)(40480700001)(4326008)(316002)(356005)(82740400003)(70586007)(70206006)(5660300002)(16526019)(186003)(1076003)(26005)(336012)(426003)(47076005)(36860700001)(2616005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 21:26:23.3674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8cd6442-6586-4582-a7e2-08db45d3b83c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5440
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prep and use the "modern" virtio bar utilities to get our
virtio config space ready.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/aux_drv.c | 25 +++++++++++++++++++++++++
 drivers/vdpa/pds/aux_drv.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
index aa748cf55d2b..0c4a135b1484 100644
--- a/drivers/vdpa/pds/aux_drv.c
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -4,6 +4,7 @@
 #include <linux/auxiliary_bus.h>
 #include <linux/pci.h>
 #include <linux/vdpa.h>
+#include <linux/virtio_pci_modern.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
@@ -19,12 +20,22 @@ static const struct auxiliary_device_id pds_vdpa_id_table[] = {
 	{},
 };
 
+static int pds_vdpa_device_id_check(struct pci_dev *pdev)
+{
+	if (pdev->device != PCI_DEVICE_ID_PENSANDO_VDPA_VF ||
+	    pdev->vendor != PCI_VENDOR_ID_PENSANDO)
+		return -ENODEV;
+
+	return PCI_DEVICE_ID_PENSANDO_VDPA_VF;
+}
+
 static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
 			  const struct auxiliary_device_id *id)
 
 {
 	struct pds_auxiliary_dev *padev =
 		container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
+	struct device *dev = &aux_dev->dev;
 	struct pds_vdpa_aux *vdpa_aux;
 	int err;
 
@@ -41,8 +52,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
 	if (err)
 		goto err_free_mem;
 
+	/* Find the virtio configuration */
+	vdpa_aux->vd_mdev.pci_dev = padev->vf_pdev;
+	vdpa_aux->vd_mdev.device_id_check = pds_vdpa_device_id_check;
+	vdpa_aux->vd_mdev.dma_mask = DMA_BIT_MASK(PDS_CORE_ADDR_LEN);
+	err = vp_modern_probe(&vdpa_aux->vd_mdev);
+	if (err) {
+		dev_err(dev, "Unable to probe for virtio configuration: %pe\n",
+			ERR_PTR(err));
+		goto err_free_mgmt_info;
+	}
+
 	return 0;
 
+err_free_mgmt_info:
+	pci_free_irq_vectors(padev->vf_pdev);
 err_free_mem:
 	kfree(vdpa_aux);
 	auxiliary_set_drvdata(aux_dev, NULL);
@@ -55,6 +79,7 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
 	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
 	struct device *dev = &aux_dev->dev;
 
+	vp_modern_remove(&vdpa_aux->vd_mdev);
 	pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
 
 	kfree(vdpa_aux);
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
index dcec782e79eb..99e0ff340bfa 100644
--- a/drivers/vdpa/pds/aux_drv.h
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -4,6 +4,8 @@
 #ifndef _AUX_DRV_H_
 #define _AUX_DRV_H_
 
+#include <linux/virtio_pci_modern.h>
+
 #define PDS_VDPA_DRV_DESCRIPTION    "AMD/Pensando vDPA VF Device Driver"
 #define PDS_VDPA_DRV_NAME           KBUILD_MODNAME
 
@@ -16,6 +18,7 @@ struct pds_vdpa_aux {
 
 	int vf_id;
 	struct dentry *dentry;
+	struct virtio_pci_modern_device vd_mdev;
 
 	int nintrs;
 };
-- 
2.17.1

