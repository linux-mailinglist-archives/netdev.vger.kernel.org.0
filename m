Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26B46C5491
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjCVTLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCVTLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:11:04 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAD53526A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:11:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdiM++eNkq67bJSvdT1mCPdYBbHCsOgzrl4le0HpHfXUioFmNR7erTdE8TYw6eCgCYF1QI1TbIUgyAdXeYuhtTB9OqnSXD81LCimQ+Py7TGIWpUcnpZjGWB2vOPE3WDvGoKHMpIE2UQ4pOGQm70TC84LVoZ8devFHKAqRcr1BKvrnarJSlJ8EJTiIiwKJZb3zaRXsT5O5i1hi55u3AGjSdx7VNOMmcZi6bKrvoi04qc7K7DW1G83SRN1JWJSgDyh4JGioUF7T7912/e2tXYZVpJ6suLO0xKib+OAIkjmDt/MZCaQLpjp3PtFSZGvTw68dW4tve5eC6Y9dF6bbr91zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDLBFkpD8KiE57okebDvtHVUXbqGBQahQe4MmMGYYPQ=;
 b=oaKXSgjdFVJOUsTNd+ajQnOD9aCyZ9RrRY7Qd3qr3xMYdMW1LqgKMT6iCw8A2GRFI2nlUFkZXSRAJYiOEqAD+xIEJpUb7HR2W9PAYK0Uy/EvTPP98C8OdNzK+iLPDp91yFQtyeye7919f6/Y2SJQkRSsHrYJmKRZTLmFC2/5NCVXhx4oSOEdzzbl6BmKGZSOfok9aT9Kr3MuB003ohMivJkVdMe+sTGjuY//lxaaBztWiVhEC7dMU+Ge4xV6YhSPjTaZBb8YmhCmKbZ6rfZ+GwDur2snHn/FIwbRZxrKZC6ZoJKZUkErIXJ5YFmxbPnQGNyA3LU8I/MEceG8La+8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDLBFkpD8KiE57okebDvtHVUXbqGBQahQe4MmMGYYPQ=;
 b=M/oRZT6g+WG7fVSj4LDqd/FpPNCc6Ti0JXeuEvuDHntF3zQz6tSJWCbpz4PvjV6fUfh2b4kBU45WFkbLHCVqsdNdH3XyEBIdyouXZyFejWmUHGOpea7khslipIt4XtYizX6h49Esbmml2Fa/nsH9/YAppVJcHR63lTA515I/H+U=
Received: from DS7PR03CA0288.namprd03.prod.outlook.com (2603:10b6:5:3ad::23)
 by IA1PR12MB8239.namprd12.prod.outlook.com (2603:10b6:208:3f7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:11:01 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::88) by DS7PR03CA0288.outlook.office365.com
 (2603:10b6:5:3ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:11:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:11:00 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:10:56 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 4/8] pds_vdpa: virtio bar setup for vdpa
Date:   Wed, 22 Mar 2023 12:10:34 -0700
Message-ID: <20230322191038.44037-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322191038.44037-1-shannon.nelson@amd.com>
References: <20230322191038.44037-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|IA1PR12MB8239:EE_
X-MS-Office365-Filtering-Correlation-Id: 74451bac-5cd0-40be-cab7-08db2b092cf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QZMyTMf07Q3CSh9RTybNoPUGLPIqfVXGSkRJTFgveFOmyjnjzQDI0Wn2jmYcih3wHe16REDtlQCBJZOnb2ioS5AggDMWrvtlgmJidCj52CemfVvWM/Lcc+Ku/8+PoqOF3KmdDFVXKtQTs+DlpfnhXAPZtJ9qXeSeE/8btxGmrEYJBFugJ/q0rr6ZWgSEAbsJh7jX+xqXjlE4F2RltU9TkR2F26RI98CSdh3VLPso61MsXecEFtNEgH6MfTCvaiNoP5geZi9VgBQgypoh0u57WqlvAV7+dQEdczhKO/gZ9HG96uEP5A/Y3N4EnmmDMN0DjEbD58ijqsNNC954lflKAj768UMwPViE0kTiZ6FETptrX3R6vMXS3dwCjP7NDos5t3fEdzS+tSqc1H5F+SfW2Yn0bMRXqG4OKMtPgz+GxposkuYOBZMiTv/Alx2uygB+PkMHjCdmxs2ja3a/XL0Ua6m29QkgLqmpVO+i/lIO/uw2qOZVbS6L9BWhyDNhDoGR+dkQnEshCZkuddB9pKtFdJM7uNlsgiSx0BeVjVAQWIA1vS+OrN9/txXx2kJ3/2yNXgUwJ+e9jbesag863a74KMXGtyRNB6KLYA5r5rfP4csXkqB71PaF3z6/PLicEcxXhTWDoZkZXLnxlYtZXVdiMl9u1/LUhE5eS+YidhIVmgqcNAv/gORlGMFJ4qk+bjTTts353KMq8UkMv049qRWlmTEDRUAXsVvgk96i9P77FEA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199018)(46966006)(36840700001)(40470700004)(356005)(478600001)(81166007)(2616005)(110136005)(316002)(82310400005)(16526019)(186003)(2906002)(70206006)(82740400003)(8676002)(70586007)(26005)(4326008)(86362001)(1076003)(36756003)(44832011)(6666004)(40480700001)(41300700001)(5660300002)(47076005)(36860700001)(336012)(40460700003)(426003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:11:00.8519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74451bac-5cd0-40be-cab7-08db2b092cf1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8239
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 881acd869a9d..8f3ae3326885 100644
--- a/drivers/vdpa/pds/aux_drv.c
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -4,6 +4,7 @@
 #include <linux/auxiliary_bus.h>
 #include <linux/pci.h>
 #include <linux/vdpa.h>
+#include <linux/virtio_pci_modern.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
@@ -20,12 +21,22 @@ static const struct auxiliary_device_id pds_vdpa_id_table[] = {
 	{},
 };
 
+static int pds_vdpa_device_id_check(struct pci_dev *pdev)
+{
+	if (pdev->device != PCI_DEVICE_ID_PENSANDO_VDPA_VF ||
+	    pdev->vendor != PCI_VENDOR_ID_PENSANDO)
+		return -ENODEV;
+
+	return 0;
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
 
@@ -42,8 +53,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
 	if (err)
 		goto err_free_mem;
 
+	/* Find the virtio configuration */
+	vdpa_aux->vd_mdev.pci_dev = padev->vf_pdev;
+	vdpa_aux->vd_mdev.device_id_check_override = pds_vdpa_device_id_check;
+	vdpa_aux->vd_mdev.dma_mask_override = DMA_BIT_MASK(PDS_CORE_ADDR_LEN);
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
@@ -56,6 +80,7 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
 	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
 	struct device *dev = &aux_dev->dev;
 
+	vp_modern_remove(&vdpa_aux->vd_mdev);
 	pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
 
 	kfree(vdpa_aux);
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
index 94ba7abcaa43..8f5140401573 100644
--- a/drivers/vdpa/pds/aux_drv.h
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -4,6 +4,8 @@
 #ifndef _AUX_DRV_H_
 #define _AUX_DRV_H_
 
+#include <linux/virtio_pci_modern.h>
+
 #define PDS_VDPA_DRV_DESCRIPTION    "AMD/Pensando vDPA VF Device Driver"
 #define PDS_VDPA_DRV_NAME           "pds_vdpa"
 
@@ -16,6 +18,7 @@ struct pds_vdpa_aux {
 
 	int vf_id;
 	struct dentry *dentry;
+	struct virtio_pci_modern_device vd_mdev;
 
 	int nintrs;
 };
-- 
2.17.1

