Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065C5645D12
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLGO6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLGO6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:58:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE0F6388;
        Wed,  7 Dec 2022 06:57:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPOc27J6yXX0KPjtKHhur/njFqw+Ty7ADZuiXd8wvZ2gUtV8w1efmBNGQehG3LzcI1SQs+l1h8ad2AZlqVapsEtTrvERpBEzJOWTVNEyzIChEM4wPTV24s9pN/8Akxam8OfSLzcepOcAdyvivkMaw19Ik5lub76fbM+pufBgUjC5gK7SgwcBSFBhRzfoiBawtsP4af42EGSO2JuF/JmZ0afzt8byjpg3bty86ZcLOXK5WhfFR1FLxNTwVRWewC38aewb7s2ge59pkk0qZA27pId6IDMLganvKdGMELH1UJK6j9rGC6hVLZ5i5x1Vd7ojcsQGZYev7gV+xQKmo+BW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeYlK7TeC5QObliScKEh48xLWbBSlHY1Z26BEvD/iKI=;
 b=ZXS1CSWKCYQyu+qUSjZiAS/eFZ+gTnMCpahp3P3Z7HLzv+WkaAP9fID4ysrKEL3IDkmb5sGqc7xivwZCcdQ4ZG15MIkaVzjs5S+IXGF98r1Y4QyvOS2yuqUplO2EOuEq4xPOK0bzUfoNZy7ZiqKpLOh2ihq2eUswWLdTV4gy04KffJMLr3tBmD7kaCyivHEB+UMYrKD0qSD7PhXaFdoXdqjQI22Sc7+Fki/w6kXRr3Dr1ae+paGj2rieaNKNDmFeI+4qxwWMedtX+qQ1y1Tl1nNVri1gRcYM7AHLVPuvv2FtirEcKqg7V4593BBVTrP6ErWsIQVr59HxavQMplvl4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeYlK7TeC5QObliScKEh48xLWbBSlHY1Z26BEvD/iKI=;
 b=rf/POx1TkO8tuRgYG9lgpAtJRm85W9xh0yEAaFtW8c2Xpyq2jTYhK9lVc8pm7CfrRav+KSkh0shqckgmczyzxL5QPit1tTc47oYIjH4BZVsVo11pk4+zRd4JFCZjX28nlMDKeQrAJ/AeceLkyDyIkxwa2YNSjk1wDCbvcqQfx4Y=
Received: from DS7PR03CA0301.namprd03.prod.outlook.com (2603:10b6:8:2b::8) by
 SA1PR12MB5615.namprd12.prod.outlook.com (2603:10b6:806:229::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:57:36 +0000
Received: from DS1PEPF0000E630.namprd02.prod.outlook.com
 (2603:10b6:8:2b:cafe::8f) by DS7PR03CA0301.outlook.office365.com
 (2603:10b6:8:2b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:57:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E630.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:57:36 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:57:32 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:57:28 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <eperezma@redhat.com>
CC:     <tanuj.kamde@amd.com>, <Koushik.Dutta@amd.com>,
        <harpreet.anand@amd.com>, Gautam Dawar <gautam.dawar@amd.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 10/11] sfc: implement vdpa config_ops for dma operations
Date:   Wed, 7 Dec 2022 20:24:26 +0530
Message-ID: <20221207145428.31544-11-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E630:EE_|SA1PR12MB5615:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd64626-3044-4793-ee99-08dad86360d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMMcKSdxwIb6lh/2dohh3HZC6Apez31TxBCwxRuwletRDwBMLTkBe4N6/mcZw7ljdyH9C3ltotBGc5HNx/ne7IEH5NBBne6cQ9oAlj0qBmkRt9AntWdVIDE1X7MY9tgCSgiEUPvGDvN5rBXdcjot35mmm70oc+57V8RleQldiwSqCeZ+GHnLUXRxSc8N7gxeI1pCj/7vns6ewoCaczhxW/nlAGZQSPr2A+SzfaQ5Tz17lgY9OXhr6tKZye3z+xQs7cD7xTYl8UAPxrtJbMMLmyU9L0/XX/jAx0UbfDtxQQhkO2/crh92A/Afqp708XOpjpRmYoJSGYnvMI1lx/KXwn17qjFPKPK0YFufNyhwKAZtlfFFYj/5nGozok6uCZJWmv8vo35eaDH+Dz1qv4DTB7XStOQ9ZMYj0G+fUasLVbNrY19s+Z6TFGq2C/Z9IJNjbc5aRErBxbCl/dvj1YwBU1gS78wUlaX3XQvF438AafW5QU4J7q6exJQOAv6jNOlT1pPUAuanKZeNDoc2Y5xXUADka1npFI0jgX9uJklaBBsvTaxoHKG1kCLixekla6oNMzMT5jqQdLPItn+5Xetokm7a6aqtFG836Pc1dSLxRxrURYA+94YoJiuOlUSmP1cAhiiadWUoe4UoiYpiC04sZrCO7fby+FwCZfTXOuSxpYRlEsEfSSTTuUUZ3Fi6R3leFaQvXnI2Lrv4udyFk3sHoZvHMMiiqY1lMRCBr0MhhmA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(5660300002)(7416002)(70206006)(66899015)(2906002)(30864003)(316002)(41300700001)(44832011)(4326008)(70586007)(8676002)(8936002)(54906003)(36756003)(478600001)(26005)(110136005)(36860700001)(186003)(82310400005)(1076003)(2616005)(336012)(83380400001)(40460700003)(40480700001)(47076005)(86362001)(426003)(82740400003)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:57:36.3534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd64626-3044-4793-ee99-08dad86360d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E630.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5615
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although sfc uses the platform IOMMU but it still
implements the DMA config operations to deal with
possible IOVA overlap with the MCDI DMA buffer and
relocates the latter if such overlap is detected.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 140 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |   3 +
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 111 +++++++++++++++++
 drivers/net/ethernet/sfc/net_driver.h     |  12 ++
 4 files changed, 266 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index b9368eb1acd5..16681d164fd1 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -309,6 +309,140 @@ static int vdpa_update_domain(struct ef100_vdpa_nic *vdpa_nic)
 					  vdpa_nic->geo_aper_end + 1, 0);
 }
 
+static int ef100_vdpa_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buf)
+{
+	struct ef100_vdpa_nic *vdpa_nic = efx->vdpa_nic;
+	struct device *dev = &vdpa_nic->vdpa_dev.dev;
+	int rc;
+
+	buf->addr = kzalloc(buf->len, GFP_KERNEL);
+	if (!buf->addr)
+		return -ENOMEM;
+
+	rc = iommu_map(vdpa_nic->domain, buf->dma_addr,
+		       virt_to_phys(buf->addr), buf->len,
+		       IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
+	if (rc)
+		dev_err(dev, "iommu_map failed, rc: %d\n", rc);
+
+	return rc;
+}
+
+static void ef100_vdpa_free_buffer(struct ef100_vdpa_nic *vdpa_nic,
+				   struct efx_buffer *buf)
+{
+	struct device *dev = &vdpa_nic->vdpa_dev.dev;
+	int rc;
+
+	rc = iommu_unmap(vdpa_nic->domain, buf->dma_addr, buf->len);
+	if (rc < 0)
+		dev_err(dev, "iommu_unmap failed, rc: %d\n", rc);
+
+	kfree(buf->addr);
+}
+
+int ef100_setup_ef100_mcdi_buffer(struct ef100_vdpa_nic *vdpa_nic)
+{
+	struct efx_nic *efx = vdpa_nic->efx;
+	struct ef100_nic_data *nic_data;
+	struct efx_mcdi_iface *mcdi;
+	struct efx_buffer mcdi_buf;
+	enum efx_mcdi_mode mode;
+	struct device *dev;
+	int rc;
+
+	/* Switch to poll mode MCDI mode */
+	nic_data = efx->nic_data;
+	dev = &vdpa_nic->vdpa_dev.dev;
+	mcdi = efx_mcdi(efx);
+	mode = mcdi->mode;
+	efx_mcdi_mode_poll(efx);
+	efx_mcdi_flush_async(efx);
+
+	/* First, allocate the MCDI buffer for EF100 mode */
+	rc = efx_nic_alloc_buffer(efx, &mcdi_buf,
+				  MCDI_BUF_LEN, GFP_KERNEL);
+	if (rc) {
+		dev_err(dev, "nic alloc buf failed, rc: %d\n", rc);
+		goto restore_mode;
+	}
+
+	/* unmap and free the vDPA MCDI buffer now */
+	ef100_vdpa_free_buffer(vdpa_nic, &nic_data->mcdi_buf);
+	memcpy(&nic_data->mcdi_buf, &mcdi_buf, sizeof(struct efx_buffer));
+	efx->mcdi_buf_mode = EFX_BUF_MODE_EF100;
+
+restore_mode:
+	if (mode == MCDI_MODE_EVENTS)
+		efx_mcdi_mode_event(efx);
+
+	return rc;
+}
+
+int ef100_setup_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
+	enum efx_mcdi_mode mode = mcdi->mode;
+	struct efx_buffer mcdi_buf;
+	int rc;
+
+	efx_mcdi_mode_poll(efx);
+	efx_mcdi_flush_async(efx);
+
+	/* First, prepare the MCDI buffer for vDPA mode */
+	mcdi_buf.dma_addr = mcdi_iova;
+	/* iommu_map requires page aligned memory */
+	mcdi_buf.len = PAGE_ALIGN(MCDI_BUF_LEN);
+	rc = ef100_vdpa_alloc_buffer(efx, &mcdi_buf);
+	if (rc) {
+		pci_err(efx->pci_dev, "alloc vdpa buf failed, rc: %d\n", rc);
+		goto restore_mode;
+	}
+
+	/* All set-up, free the EF100 MCDI buffer now */
+	efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
+	memcpy(&nic_data->mcdi_buf, &mcdi_buf, sizeof(struct efx_buffer));
+	efx->mcdi_buf_mode = EFX_BUF_MODE_VDPA;
+
+restore_mode:
+	if (mode == MCDI_MODE_EVENTS)
+		efx_mcdi_mode_event(efx);
+	return rc;
+}
+
+int ef100_remap_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct ef100_vdpa_nic *vdpa_nic = efx->vdpa_nic;
+	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
+	struct efx_buffer *mcdi_buf;
+	int rc;
+
+	mcdi_buf = &nic_data->mcdi_buf;
+	spin_lock_bh(&mcdi->iface_lock);
+
+	rc = iommu_unmap(vdpa_nic->domain, mcdi_buf->dma_addr, mcdi_buf->len);
+	if (rc < 0) {
+		pci_err(efx->pci_dev, "iommu_unmap failed, rc: %d\n", rc);
+		goto out;
+	}
+
+	rc = iommu_map(vdpa_nic->domain, mcdi_iova,
+		       virt_to_phys(mcdi_buf->addr),
+		       mcdi_buf->len,
+		       IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
+	if (rc) {
+		pci_err(efx->pci_dev, "iommu_map failed, rc: %d\n", rc);
+		goto out;
+	}
+
+	mcdi_buf->dma_addr = mcdi_iova;
+out:
+	spin_unlock_bh(&mcdi->iface_lock);
+	return rc;
+}
+
 static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 						const char *dev_name,
 						enum ef100_vdpa_class dev_type,
@@ -391,6 +525,12 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 		goto err_put_device;
 	}
 
+	rc = ef100_setup_vdpa_mcdi_buffer(efx, EF100_VDPA_IOVA_BASE_ADDR);
+	if (rc) {
+		pci_err(efx->pci_dev, "realloc mcdi failed, err: %d\n", rc);
+		goto err_put_device;
+	}
+
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index c3c77029973d..f15d8739dcde 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -202,6 +202,9 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
 int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
 void ef100_vdpa_irq_vectors_free(void *data);
 int ef100_vdpa_reset(struct vdpa_device *vdev);
+int ef100_setup_ef100_mcdi_buffer(struct ef100_vdpa_nic *vdpa_nic);
+int ef100_setup_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova);
+int ef100_remap_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index 8c198d949fdb..7c632f179bcf 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -12,6 +12,7 @@
 #include "ef100_vdpa.h"
 #include "ef100_iova.h"
 #include "io.h"
+#include "ef100_iova.h"
 #include "mcdi_vdpa.h"
 
 /* Get the queue's function-local index of the associated VI
@@ -739,14 +740,121 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 	}
 }
 
+static bool is_iova_overlap(u64 iova1, u64 size1, u64 iova2, u64 size2)
+{
+	return max(iova1, iova2) < min(iova1 + size1, iova2 + size2);
+}
+
+static int ef100_vdpa_dma_map(struct vdpa_device *vdev,
+			      unsigned int asid,
+			      u64 iova, u64 size,
+			      u64 pa, u32 perm, void *opaque)
+{
+	struct ef100_vdpa_nic *vdpa_nic;
+	struct ef100_nic_data *nic_data;
+	unsigned int mcdi_buf_len;
+	dma_addr_t mcdi_buf_addr;
+	u64 mcdi_iova = 0;
+	int rc;
+
+	vdpa_nic = get_vdpa_nic(vdev);
+	nic_data = vdpa_nic->efx->nic_data;
+	mcdi_buf_addr = nic_data->mcdi_buf.dma_addr;
+	mcdi_buf_len = nic_data->mcdi_buf.len;
+
+	/* Validate the iova range against geo aperture */
+	if (iova < vdpa_nic->geo_aper_start ||
+	    ((iova + size - 1) > vdpa_nic->geo_aper_end)) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: iova range (%llx, %llx) not within geo aperture\n",
+			__func__, iova, (iova + size));
+		return -EINVAL;
+	}
+
+	rc = efx_ef100_insert_iova_node(vdpa_nic, iova, size);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: iova_node insert failure: %d\n", __func__, rc);
+		return rc;
+	}
+
+	if (is_iova_overlap(mcdi_buf_addr, mcdi_buf_len, iova, size)) {
+		dev_info(&vdpa_nic->vdpa_dev.dev,
+			 "%s: mcdi iova overlap detected: %llx\n",
+			 __func__, mcdi_buf_addr);
+		/* find the new iova for mcdi buffer */
+		rc = efx_ef100_find_new_iova(vdpa_nic, mcdi_buf_len,
+					     &mcdi_iova);
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"new mcdi iova not found, err: %d\n", rc);
+			goto fail;
+		}
+
+		if (vdpa_nic->efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA)
+			rc = ef100_remap_vdpa_mcdi_buffer(vdpa_nic->efx,
+							  mcdi_iova);
+		else if (vdpa_nic->efx->mcdi_buf_mode == EFX_BUF_MODE_EF100)
+			rc = ef100_setup_vdpa_mcdi_buffer(vdpa_nic->efx,
+							  mcdi_iova);
+		else
+			goto fail;
+
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"mcdi buf update failed, err: %d\n", rc);
+			goto fail;
+		}
+	}
+
+	rc = iommu_map(vdpa_nic->domain, iova, pa, size, perm);
+	if (rc) {
+		dev_err(&vdev->dev,
+			"%s: iommu_map iova: %llx size: %llx rc: %d\n",
+			__func__, iova, size, rc);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	efx_ef100_remove_iova_node(vdpa_nic, iova);
+	return rc;
+}
+
+static int ef100_vdpa_dma_unmap(struct vdpa_device *vdev,
+				unsigned int asid,
+				u64 iova, u64 size)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int rc;
+
+	rc = iommu_unmap(vdpa_nic->domain, iova, size);
+	if (rc < 0)
+		dev_info(&vdev->dev,
+			 "%s: iommu_unmap iova: %llx size: %llx rc: %d\n",
+			 __func__, iova, size, rc);
+	efx_ef100_remove_iova_node(vdpa_nic, iova);
+	return rc;
+}
+
 static void ef100_vdpa_free(struct vdpa_device *vdev)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int rc;
 	int i;
 
 	if (vdpa_nic) {
 		/* clean-up the mappings and iova tree */
 		efx_ef100_delete_iova(vdpa_nic);
+		if (vdpa_nic->efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
+			rc = ef100_setup_ef100_mcdi_buffer(vdpa_nic);
+			if (rc) {
+				dev_err(&vdev->dev,
+					"setup_ef100_mcdi failed, err: %d\n",
+					rc);
+			}
+		}
 		for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
 			reset_vring(vdpa_nic, i);
 		ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
@@ -782,5 +890,8 @@ const struct vdpa_config_ops ef100_vdpa_config_ops = {
 	.get_config	     = ef100_vdpa_get_config,
 	.set_config	     = ef100_vdpa_set_config,
 	.get_generation      = NULL,
+	.set_map             = NULL,
+	.dma_map	     = ef100_vdpa_dma_map,
+	.dma_unmap           = ef100_vdpa_dma_unmap,
 	.free	             = ef100_vdpa_free,
 };
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 79356d614109..34b94372d9a6 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -846,6 +846,16 @@ enum efx_xdp_tx_queues_mode {
 	EFX_XDP_TX_QUEUES_BORROWED	/* queues borrowed from net stack */
 };
 
+/**
+ * enum efx_buf_alloc_mode - buffer allocation mode
+ * @EFX_BUF_MODE_EF100: buffer setup in ef100 mode
+ * @EFX_BUF_MODE_VDPA: buffer setup in vdpa mode
+ */
+enum efx_buf_alloc_mode {
+	EFX_BUF_MODE_EF100,
+	EFX_BUF_MODE_VDPA
+};
+
 /**
  * struct efx_nic - an Efx NIC
  * @name: Device name (net device name or bus id before net device registered)
@@ -997,6 +1007,7 @@ enum efx_xdp_tx_queues_mode {
  * @tc: state for TC offload (EF100).
  * @mem_bar: The BAR that is mapped into membase.
  * @reg_base: Offset from the start of the bar to the function control window.
+ * @mcdi_buf_mode: mcdi buffer allocation mode
  * @monitor_work: Hardware monitor workitem
  * @biu_lock: BIU (bus interface unit) lock
  * @last_irq_cpu: Last CPU to handle a possible test interrupt.  This
@@ -1182,6 +1193,7 @@ struct efx_nic {
 
 	unsigned int mem_bar;
 	u32 reg_base;
+	enum efx_buf_alloc_mode mcdi_buf_mode;
 #ifdef CONFIG_SFC_VDPA
 	/** @mgmt_dev: vDPA Management device */
 	struct vdpa_mgmt_dev *mgmt_dev;
-- 
2.30.1

