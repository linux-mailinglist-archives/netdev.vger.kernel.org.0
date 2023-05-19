Return-Path: <netdev+bounces-4022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F6670A245
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4328D2816C8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A13182CD;
	Fri, 19 May 2023 21:57:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A40182CC
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:57:00 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF6A10F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:56:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhFwd9MCZ5pdGOU9KDqvKR97YXJM21V1/75/6lOqs1DUxA+dfuW3mlf6tRQXSmEBscvhiFluYT/H079tX41DMEi3lQaIq7JML1VFHOWHq/WoH+uQRhqXf+HJRuc7QT6SQTapALyMnMLHbDNpsGX+f7+9mX73RRy7gyG6U4O2jweQ64m3y7pQ9K2U4yFNWbnD7jrTy2nCeMxVb3coU8dYopUXNPvEgpvwari44AOavGkIPyyBYI82n9IW+H+WsBTosJublcCNC9b37XfLXsliagP1EQtWzDaOxSowKf5AkPZfHL5+feVOycfVA8i54DCTbxQHpngjbSR0Y9Y5bHs1Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvdWJJ254PoiNlvH3a/tCFZju7eimX3KwS1R1DbTR2I=;
 b=dMHeiFs3mOGIxdkcOmu921kleuNIDZLEOlVjjkVzCFJDKdGIISgcd2ZEbZQ1+9OCaYgxuDS8+Fly4os22emEcFk5rA4OGWipIPv7DQzRHoZMjq08/MCg7WxpVyMQtkUDcPkDPp7UoSg2l8oHxBpFh90PESb4xxY6+fegHcxodLrZDXq/jG9Lte7voF7XRxFUmjdQ7b51yLf7jTJb4l6cTjmyK+9iLCkdgvBmwO9ydMSCHqrpRfVYr3cw16pmXGUhaEEsHbAuA17FOC2IDiyUinaWQslB2OtZS+l6R9f8T/iRTqySjpWNB8KWS3LQ8WKRV8ILO1DiDp8Ht8uL3vFpfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvdWJJ254PoiNlvH3a/tCFZju7eimX3KwS1R1DbTR2I=;
 b=gCzIOtFyp6r+eh7qvnwHdlMFkQTFoAyBrqmt/TFwgg0nbgIh5YuzD9qO5nrzII3Ehl/BARjo26xxkkO/v9yUSLSmOxuDCHlWqUZx/EPdRDMSQhmbICKfmg/dsFFDyZbVT6wcoGVyFyFA02sTFIvZB39b2o9LQEtJFvi6NR2bDlc=
Received: from BN7PR02CA0023.namprd02.prod.outlook.com (2603:10b6:408:20::36)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 21:56:56 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::55) by BN7PR02CA0023.outlook.office365.com
 (2603:10b6:408:20::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21 via Frontend
 Transport; Fri, 19 May 2023 21:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 21:56:56 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 19 May
 2023 16:56:55 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v7 virtio 07/11] pds_vdpa: virtio bar setup for vdpa
Date: Fri, 19 May 2023 14:56:28 -0700
Message-ID: <20230519215632.12343-8-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230519215632.12343-1-shannon.nelson@amd.com>
References: <20230519215632.12343-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: c5268e7e-ae28-40d1-ad0d-08db58b3f6d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m6rqyDZUUmhgz9Tc/lU9/6Cp5ITeEO+qQOzikaQypnCcby4/0uk0cLWQ6DZ0K+JvidgzgKHDUr58q+oImEjWLfjdOM1ICz0mSR0NBczB0uLqqFO5EztItOFAWthPLxBeSzBg1RxrGZ2JBdQs1H/+oBdjJhQiMSSv+/rtl6INDBuJr8jcSZfKzWPq0rtBvPuRawyE1K8BDkRh8bgVMFJi7pg1cXKYTHK1IDY3xo045MsGipSVY/0umQ/tyf/PDaQoJWddJJD03XeENCD4drD+PDtgoo+Y1YDZ1Ba5/ZHskWM1TqkOfVezYsnDmO2vsRQzHI8EB4GJj1A0vm44W62SDAgIsTm+FKmCSNbSrYfcO0Bg4DGwDFJGgC7fIIX+eu8idWNvmI+nBDb0E5yTxJgHzC+TTeBUYIDLvICeCEmdcuIzUCpkDjuRqar1Wuer8auzGjivN9Vfi4c5SNX8ozrRfXPtW9UT+UC9sfVZcdU0CixETr8RXi+4xhCXejJyVOKlS7EdTmNbbdn9f/xljZgaUqR2YPOLGW6DSPWqTUVr0w6ehOpZ6+QVh+znZf2xxVLJI2ILVb3bfKQkX902HXq2taZW1J9xVOog327+DZ3gjJUA+eznu1j9L6Is0J6V40Bjtr210oJYeFoO9M3z5mFechl6+JSeH6d74dSooA74Io6WVBs0qKgDhPRZpgGo+1gdQKX25cSDXzP2o1Y1ht33es3NJi4tlfPW3n1+Kb8ytKzc/13KHheE180yC/TM+eMIHCOK2HXSCpE5vFRal74UcA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(110136005)(5660300002)(8936002)(44832011)(478600001)(6666004)(54906003)(41300700001)(316002)(4326008)(70206006)(70586007)(1076003)(186003)(8676002)(16526019)(2906002)(47076005)(336012)(26005)(426003)(2616005)(40460700003)(83380400001)(36860700001)(356005)(40480700001)(81166007)(82740400003)(82310400005)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 21:56:56.6308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5268e7e-ae28-40d1-ad0d-08db58b3f6d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
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


