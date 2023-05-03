Return-Path: <netdev+bounces-200-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AED6F5DB3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CCCF1C20F5B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76010BE61;
	Wed,  3 May 2023 18:13:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6283BBE45
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:13:10 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2051.outbound.protection.outlook.com [40.107.96.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D282E26B6
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:13:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuvCnqtxN9DZCcf0d/fClFwggljgBoSP+KQm+23qD/8Klaw0OkpWrw9QhtOPirb/9pEX3yZrD91BALfFi185iG/emyU0jrsV2mhba7odb3UpAn2tK4b7xe5n9VD0qxVafMDg1ldJHC3ucOTW2/+0V0ptE8NQfUWWRBGjBLLLKFZsBzM2jNxdK18n8PynK6LKgIPrd/n5VdwV1OeBc9egp77feXGsSC4Ai7/Mees1afL1UlgKdDaIbU1tfkesb+L1Y/zpH6ywjvfj5yd9WQgd2+Gfb+fE5EbbyWmfwsethUk37m2upDimHQlvCrG2yWN2ukGlaBeTgL3n5Da5+0FPyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hI3GyhMnBtqvIHpTxFneyeexCVk+UAAzceGNrNvELJg=;
 b=eZvgMq1dkhnHqr2j0GIisxkAyiPSNoZWpXIq71+Dj3wjvSO+fB2J6XujmLqZO4y0DF1p5EzaaM47QaMAG3l+ERhLCuZ1Ojr8kA8K7jndRI/SJMub1KTaqOXkWWbRsSOi++JtIu/kMigHaxsSJSP5Znkg1NM6ud1K7USFYrBFGGFNS9dco0rukNF4XcqaP2YttpQ7pVFZ1/3D4WHBjG1I3jMQJAH3I6v8fdTA2UxK7Iae8aMIDYZAa7GdzOI6cG4V3AEfTDUZGu1cHnXdgQ1+Ly+DPZMAZzECbWCyA2DDo6twCJ6cyFjEmYGm6/nBt0Q2YpDuuGUuX/VEPGu4dtfOMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hI3GyhMnBtqvIHpTxFneyeexCVk+UAAzceGNrNvELJg=;
 b=oro+gd+deHzxFkpJHNpu2+z4v3OrmDK0OwX2Xgqx5zlMIPpJI2Xad4Ft9Lgkrlq8bqt4czIsY4oTH9SJ697UUcU/+OmjccemQdMNR1rSVCeMI2taMdnZmEE/JpigXp8EBmx/AzyasTZGx8n+nTulbyuTuypnsVJWmG6PxG1JzyM=
Received: from DM6PR03CA0037.namprd03.prod.outlook.com (2603:10b6:5:100::14)
 by SN7PR12MB7853.namprd12.prod.outlook.com (2603:10b6:806:348::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Wed, 3 May
 2023 18:13:04 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::21) by DM6PR03CA0037.outlook.office365.com
 (2603:10b6:5:100::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22 via Frontend
 Transport; Wed, 3 May 2023 18:13:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.22 via Frontend Transport; Wed, 3 May 2023 18:13:04 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 3 May
 2023 13:13:03 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v5 virtio 07/11] pds_vdpa: virtio bar setup for vdpa
Date: Wed, 3 May 2023 11:12:36 -0700
Message-ID: <20230503181240.14009-8-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230503181240.14009-1-shannon.nelson@amd.com>
References: <20230503181240.14009-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|SN7PR12MB7853:EE_
X-MS-Office365-Filtering-Correlation-Id: 54078279-ca9c-4f06-4b9e-08db4c020a11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LU4kubmkCoso4D4Oa+gFs37748244EK/ksc5fZp2RewKn4LXCvm030BACVmsrSpJO8iVUZ0rQDUiOOoLNhj6q2abTvwG6e3UPOyrt6L16W8qmLefkv4ip8qRHtH1Og1ztHaR1UEZmqeKp75pYAws6KMjIycGfrLVNsSIT6zkReSv4tSBauKZeij3yMpRUMlvY74bmJPRPLWP43Czq79ofKfPe67dOe7rjdyBAzYvNVCcWYTPmDrWDfkVdyx7X37GjFeyQmTtL5rJjfq6KnEOMVi4weQ/k8QxvPzDilj/LDE6H+y2f6tij4LLbRpJivjfcwhq5uZKQv26zoDOehj4MvQez9irqbEsoaN2yo74uNBFbA5jRjfhQU+cm0pQIdRaxBpzpaGacupu/ZbL7uZ9Xck8MJFRFiQHJrzkCz7DVVsZQDFgxqNfNUtTG7LJaZV7+d3bfBZ5+rcbhuGKuLIytWmmRoL5bVzkgrXBDY6ZuOZ31ZvxxWzmzYeB5Nn9F6aHIUiRRBU3SRO83olpF/zDePy5fHHfsXe549am+a3xKxV8MOJ5Qqi8yQUKjKvn1hBT8GGnsnHaW3rgpqtDnnZjHk0SWnkXYXAsdBx6lW/s3EZY9DLTQ9oGukSj9ExKcj20NNapIEzhWEDvd131ndBwDLxnmbLz+0dQDMk+preybdM/K/U/JHEzzHBf+lyYNREJfGe2HOM+MTEWzcvzDaZ6j3to6z7kLZz5Q1CXCFLbwLk=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199021)(36840700001)(46966006)(40470700004)(186003)(316002)(36860700001)(81166007)(70586007)(44832011)(356005)(8936002)(70206006)(82310400005)(5660300002)(8676002)(82740400003)(36756003)(336012)(2906002)(2616005)(40460700003)(86362001)(40480700001)(41300700001)(4326008)(47076005)(478600001)(26005)(426003)(1076003)(16526019)(110136005)(6666004)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 18:13:04.4827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54078279-ca9c-4f06-4b9e-08db4c020a11
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7853
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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


