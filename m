Return-Path: <netdev+bounces-2835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E767043BE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6D841C20CEE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC1D5252;
	Tue, 16 May 2023 02:55:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC007524C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:55:53 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8408449E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:55:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyC0DbGHstHNuprAefXt07RnvLtXI3P+0Mhdp18cjltZx4W3HI9jcaCAzSJEYscscc5hpuok7Q4ivOcOQ+h16a39apN6ZgFgbMNaFt/dPMfB+TCboDuUCZZYuxdMqdGVj3kA/VVDSTPrYerX3QH1hA+CTdyUbY/EhxM09euf/T4DWzXH5H45K2y7zEbMgzL6O2DwXISHuStyx2IZLLivwdO9yhEQRqkllMJFJsXDUQ/lQiWAFrPz3T2RigZZcXuTGA7rQDYRdP09IxqUrcWwmLWyELWZAkxQvInEeGTX9Xwax3Wrm4ueEsCYtDME71NsgrB15sbpS7MSYvX9HRT6yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvdWJJ254PoiNlvH3a/tCFZju7eimX3KwS1R1DbTR2I=;
 b=jvFVQml0dJF5CWz7WWMygDMAAzlFwPKP/dC0TJkj8PmEaZ8YZ7GLwGBpNKcN0dHt1CpysQNX2j8N8qyOrHof4MwhZ4a+AdJt8+hvm7Iq6ll799bKTOB92Bx5Ns3yQknWrIx5EbIBiiHh221XOd6jdFxQlpnmxzxAQqugidTwz1mLuNApWf/iLYR6LnVyOgxHBNGjQjsBj0FD7mzguwin8n7rwLLZF/t4qgTIPAsY7J/Qk1NBJ/yZ7CEK5iqi4SMV4zP2MXeT8x7VxKCtadPQOlNXt7g9vPf/25SJvcBQKsIYNE0K1bmlFj+aA/YFAmJ0WL5wK9mbrfsUVYfIz/qXAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvdWJJ254PoiNlvH3a/tCFZju7eimX3KwS1R1DbTR2I=;
 b=SFEKOHDU7jIuzi6v+dgqjUfJeQ1cotxjlwXX+EylcOaE5ZW2064gd2avZV3ZZsjaowazUPjTNSNGZ0cMIUkdKvk1qHv+HH4n260c8xz3AbFzHG+cEs2633gjbdQDdMcxCcuAh41bRYegyhI7WcHjRVap+NboSpZzmuX6j6pRQ1I=
Received: from SJ0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:33a::19)
 by PH0PR12MB8051.namprd12.prod.outlook.com (2603:10b6:510:26d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:55:50 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33a:cafe::e8) by SJ0PR03CA0014.outlook.office365.com
 (2603:10b6:a03:33a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Tue, 16 May 2023 02:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.15 via Frontend Transport; Tue, 16 May 2023 02:55:50 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 15 May
 2023 21:55:48 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v6 virtio 07/11] pds_vdpa: virtio bar setup for vdpa
Date: Mon, 15 May 2023 19:55:17 -0700
Message-ID: <20230516025521.43352-8-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230516025521.43352-1-shannon.nelson@amd.com>
References: <20230516025521.43352-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|PH0PR12MB8051:EE_
X-MS-Office365-Filtering-Correlation-Id: fead1460-6ab7-4f71-12b4-08db55b90e74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aNf4Lt0T93m0vD+ioSlXknuf2BkFXEk6eH5Uag3HtvC0vG75uE86TzRvnnS33mnaipkuKMsVVTHCKeIrQObiF6YtOnGb9Nz9RHR3B1U5ihkambLjErv/ZAOHmgL4QQa23936YIZQD9dnWWpcpf43esCXrA1OUYqmFhwiRN6Zg+ValPfHZol1Fkk1DvwoS3liNrVkHIN2kIknRJAGznVROe7zehFvYPpN030blhCoolD7O8Tdh5EfRvcLKmPuPptvcUIk7+87PODekP9aiGBKcrhE9ZnLrgYG1XjrMGLZjZnRv3cDMC5ylO5mfX8pvf/K+n4mI00I3k0mJJItftXWwWBOmPCE4bVQQ908n+pB16I4u5pbG1J6zbnW8BeiahV22G5YAAUZFCKJwhpcD66X8reeVX0UVtW/pNG9p6dd066Hzw9sS9Tz4Bw44aiY7yOX7twguoxEdTvL6FA2ylqiFqBAVh/SNb5NzgBQ/lEKHrFVkfXz1/1B3BsTF4T1ec9He5Jmkg3Sz60h7lAAevf/FiL/f7IkuzRCdxwkde6UqgPJ7wS8z4X690D27vrrbpDApMurMzBCtFN30cvY/zAuOfUsPc1Tg5n4RI8AR/LV4dZOI2YYybyQ24WbSlHV/3DfTpvEmKzEABI56PQLUou4Mt59qUvsSO0z6rk4a4+qerdHeS9J67p6J1SfJF6MxBbbX8tTsiwiHx/L161G33AblANqzC+ESrvP4s/QXNU41foQoxLGnkZdvRmEpGvV4C0uLUTxfNY51tGii0k7b4hDqA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199021)(40470700004)(36840700001)(46966006)(36756003)(110136005)(54906003)(40460700003)(8936002)(8676002)(478600001)(356005)(44832011)(82740400003)(70206006)(40480700001)(70586007)(4326008)(316002)(41300700001)(81166007)(5660300002)(2906002)(26005)(1076003)(86362001)(16526019)(186003)(36860700001)(83380400001)(47076005)(2616005)(336012)(426003)(82310400005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:55:50.1918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fead1460-6ab7-4f71-12b4-08db55b90e74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8051
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
Acked-by: Jason Wang <jasowang@redhat.com>
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


