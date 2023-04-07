Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5092D6DA9DE
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbjDGINv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjDGINU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:13:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78582A5F8;
        Fri,  7 Apr 2023 01:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtQ3iEQKSXAVWnt6rYrJNc7P2g5GBxwdtwOlhB2UlQ3+AJocr+ihoWTUtviSDi0iC/ehZDvt88y8g6iumzTu8g02VaoSNC8NzCOUI2L5vyhqqmMHn8IjZzCn+gMHHVRdZZJTJWlvuW4k17Z0SsYx1gRrvMZNeoFTh7mB4QZ7yEC5tH4mTfIkzF2vj/nkeeEv/ZQnK0RlKGi7euZyouc5uZwfGs+kbdCpB9JMciHWT7DKzPEYclKhVH6rX1ByskcMO3W4RyigE6p8Nvazf7QbXuo1R0YVA78IFSz7JrWPiweF3L3lT+4QcgLbFpMJbODzOvEct+BaOAJ2F+UuSklBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tX2kiW6ljKISHw7uiLtbewKe1KzATrH2axjEYSL2zys=;
 b=dB+8p4bLhFk9u2auv1q+XW2yoRnc8quGgrbaKNYR8+7muskFVJ8e4V1prHCJRWNRrEtx1wa0x4aCC7zv6Y0BhPeOioqluYemcIKrE8tlH5ntEvU0eIGIezTK+2cg3egKG+e1AZn609OjLi71c2U17Ze98lkVBZVerrX9lYBvRenqfHxCIGW496bQfpujqPjiC7F587tci5bAEUz3KvSLJdEglHQ03iNtxOIKov4a3E+x53l6qV2gekziJAEJn9EDbQafcnNeavhPJuzMiPSTCCHCLsbch38xHh0crt13dF6W/MstqjlvzLeICs2QbFqdjXte7eydKiOH4/x8hjzxAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tX2kiW6ljKISHw7uiLtbewKe1KzATrH2axjEYSL2zys=;
 b=U10LZMXm/HdEKad2q4tJI6FS7vxE9ACCCPSQ3aFYYJdMPq2WG0Haal4fmffcc0/n5/s2aXnRyhoFuP3jQKylLhDWONgIKLavR1GHYswAQZ54wqHwG1pp/WTYudT6VqdF+MyZatB43py9mmB1WPGr3TSS36j/qbC/ZSAznsyLZzM=
Received: from BN9PR03CA0307.namprd03.prod.outlook.com (2603:10b6:408:112::12)
 by SJ2PR12MB7920.namprd12.prod.outlook.com (2603:10b6:a03:4cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Fri, 7 Apr
 2023 08:12:00 +0000
Received: from BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::d5) by BN9PR03CA0307.outlook.office365.com
 (2603:10b6:408:112::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Fri, 7 Apr 2023 08:12:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT109.mail.protection.outlook.com (10.13.176.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.20 via Frontend Transport; Fri, 7 Apr 2023 08:12:00 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:11:59 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:11:55 -0500
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v4 09/14] sfc: implement device status related vdpa config operations
Date:   Fri, 7 Apr 2023 13:40:10 +0530
Message-ID: <20230407081021.30952-10-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT109:EE_|SJ2PR12MB7920:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd2733b-3e6a-4ab1-0535-08db373fc342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Twg7KhPLZ3txqc5mUgQh4kinL///ekIGIf+EJ4FJibzDw+xGif5e2/Be6pGOpsll6LwrSe1K3kSn9vL1TsgikiZSLjKP2JReToSfC9siYyRiCX5eiGZ4aWpTXmULHlrgbxwQD5Ke0EUmHOcS95y98kRyrUPduVhLzg8W51rB6+aY3g+E9FaxXk3lEeQJQz+AdbaXfACuzJ5YLyBrZ0m4EbU7raoCP3hdTMcW9Be8FgS9OyZTKtllW1ApPfpr1PqMyfgEzZkBDYGeIrbiaNB7S86LYm0vSdhh2jI0FIeqhBQ/UDTQofyCUrMsbw64A7uB4DdT+S6wZCl3zu0YK/vM8EtdhFiQpJ8D3+FFXxnuouEJIT8i8s+TeSWDHmOenCjx97p8Lpu/b1ocaoS2OmUwuhp8vJ8bkDrIuBweNxkLfD4Q9TqDV9hvmKMTj4allkbBWYvuN5upNC+a/hO6C93VtjmVuRg2eS9QkwgYXvS72G/lcenCoZrCWsxoYULbsMjfy2Y88TiJX39wdeaCKC4M3PhaX9cxshT9m41DLIhEkTbhGGCBnz4VuzuoGwMAR9sCe6q0Mvy4rPVCQuoaCjUz4dML1IEr4OZKOMnk1j3QssP5OqczENyMHwR/GkzFZfxFusInGNCAHz4dJ2tD19H03T6h59CPL8ij3p/H3XRmJsRzvYH+C4WNGr+J54vlBF6I0YDnrBOk3Ddmo9YNuuVv6R55KPKB14qYWqdbGkwMIVuzeNEiIOjNHxdH3lqSs2cy
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199021)(46966006)(36840700001)(40470700004)(1076003)(26005)(6666004)(40460700003)(36756003)(86362001)(36860700001)(478600001)(40480700001)(82310400005)(186003)(8676002)(7416002)(70586007)(2906002)(336012)(70206006)(921005)(356005)(426003)(83380400001)(5660300002)(47076005)(82740400003)(30864003)(44832011)(2616005)(81166007)(4326008)(316002)(8936002)(110136005)(41300700001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:12:00.0939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd2733b-3e6a-4ab1-0535-08db373fc342
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7920
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA config opertions to handle get/set device status and device
reset have been implemented. Also .suspend config operation is
implemented to support Live Migration.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c     |  16 +-
 drivers/net/ethernet/sfc/ef100_vdpa.h     |   3 +
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 367 ++++++++++++++++++++--
 3 files changed, 356 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index fb4d15caa320..f4a940961f9d 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -68,9 +68,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
 
 static void ef100_vdpa_delete(struct efx_nic *efx)
 {
+	struct vdpa_device *vdpa_dev;
+
 	if (efx->vdpa_nic) {
+		vdpa_dev = &efx->vdpa_nic->vdpa_dev;
+		ef100_vdpa_reset(vdpa_dev);
+
 		/* replace with _vdpa_unregister_device later */
-		put_device(&efx->vdpa_nic->vdpa_dev.dev);
+		put_device(&vdpa_dev->dev);
 	}
 	efx_mcdi_free_vis(efx);
 }
@@ -171,6 +176,15 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 		}
 	}
 
+	rc = devm_add_action_or_reset(&efx->pci_dev->dev,
+				      ef100_vdpa_irq_vectors_free,
+				      efx->pci_dev);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"Failed adding devres for freeing irq vectors\n");
+		goto err_put_device;
+	}
+
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index fbdd108c0e7f..d2d457692008 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -59,6 +59,7 @@ enum ef100_vdpa_nic_state {
 	EF100_VDPA_STATE_INITIALIZED,
 	EF100_VDPA_STATE_NEGOTIATED,
 	EF100_VDPA_STATE_STARTED,
+	EF100_VDPA_STATE_SUSPENDED,
 	EF100_VDPA_STATE_NSTATES
 };
 
@@ -149,6 +150,8 @@ int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
 void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
 void ef100_vdpa_irq_vectors_free(void *data);
 int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
+void ef100_vdpa_irq_vectors_free(void *data);
+int ef100_vdpa_reset(struct vdpa_device *vdev);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index b390d5eee301..13f657d56578 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -22,11 +22,6 @@ static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
 	return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
 }
 
-void ef100_vdpa_irq_vectors_free(void *data)
-{
-	pci_free_irq_vectors(data);
-}
-
 static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
 {
 	struct efx_vring_ctx *vring_ctx;
@@ -52,14 +47,6 @@ static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
 	vdpa_nic->vring[idx].vring_ctx = NULL;
 }
 
-static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
-{
-	vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
-	vdpa_nic->vring[idx].vring_state = 0;
-	vdpa_nic->vring[idx].last_avail_idx = 0;
-	vdpa_nic->vring[idx].last_used_idx = 0;
-}
-
 int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
 {
 	u32 offset;
@@ -103,6 +90,236 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
 	return false;
 }
 
+static void irq_vring_fini(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
+	struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
+
+	devm_free_irq(&pci_dev->dev, vring->irq, vring);
+	vring->irq = -EINVAL;
+}
+
+static irqreturn_t vring_intr_handler(int irq, void *arg)
+{
+	struct ef100_vdpa_vring_info *vring = arg;
+
+	if (vring->cb.callback)
+		return vring->cb.callback(vring->cb.private);
+
+	return IRQ_NONE;
+}
+
+static int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs)
+{
+	int rc;
+
+	rc = pci_alloc_irq_vectors(pci_dev, nvqs, nvqs, PCI_IRQ_MSIX);
+	if (rc < 0)
+		pci_err(pci_dev,
+			"Failed to alloc %d IRQ vectors, err:%d\n", nvqs, rc);
+	return rc;
+}
+
+void ef100_vdpa_irq_vectors_free(void *data)
+{
+	pci_free_irq_vectors(data);
+}
+
+static int irq_vring_init(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
+	struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
+	int irq;
+	int rc;
+
+	snprintf(vring->msix_name, 256, "x_vdpa[%s]-%d\n",
+		 pci_name(pci_dev), idx);
+	irq = pci_irq_vector(pci_dev, idx);
+	rc = devm_request_irq(&pci_dev->dev, irq, vring_intr_handler, 0,
+			      vring->msix_name, vring);
+	if (rc)
+		pci_err(pci_dev,
+			"devm_request_irq failed for vring %d, rc %d\n",
+			idx, rc);
+	else
+		vring->irq = irq;
+
+	return rc;
+}
+
+static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct efx_vring_dyn_cfg vring_dyn_cfg;
+	int rc;
+
+	if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
+		return 0;
+
+	rc = efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
+				    &vring_dyn_cfg);
+	if (rc)
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: delete vring failed index:%u, err:%d\n",
+			__func__, idx, rc);
+	vdpa_nic->vring[idx].last_avail_idx = vring_dyn_cfg.avail_idx;
+	vdpa_nic->vring[idx].last_used_idx = vring_dyn_cfg.used_idx;
+	vdpa_nic->vring[idx].vring_state &= ~EF100_VRING_CREATED;
+
+	irq_vring_fini(vdpa_nic, idx);
+
+	return rc;
+}
+
+static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u32 idx_val;
+
+	if (is_qid_invalid(vdpa_nic, idx, __func__))
+		return;
+
+	if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
+		return;
+
+	idx_val = idx;
+	_efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
+		    vdpa_nic->vring[idx].doorbell_offset);
+}
+
+static bool can_create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	if (vdpa_nic->vring[idx].vring_state == EF100_VRING_CONFIGURED &&
+	    vdpa_nic->status & VIRTIO_CONFIG_S_DRIVER_OK &&
+	    !(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
+		return true;
+
+	return false;
+}
+
+static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	struct efx_vring_dyn_cfg vring_dyn_cfg;
+	struct efx_vring_cfg vring_cfg;
+	int rc;
+
+	rc = irq_vring_init(vdpa_nic, idx);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: irq_vring_init failed. index:%u, err:%d\n",
+			__func__, idx, rc);
+		return rc;
+	}
+	vring_cfg.desc = vdpa_nic->vring[idx].desc;
+	vring_cfg.avail = vdpa_nic->vring[idx].avail;
+	vring_cfg.used = vdpa_nic->vring[idx].used;
+	vring_cfg.size = vdpa_nic->vring[idx].size;
+	vring_cfg.features = vdpa_nic->features;
+	vring_cfg.msix_vector = idx;
+	vring_dyn_cfg.avail_idx = vdpa_nic->vring[idx].last_avail_idx;
+	vring_dyn_cfg.used_idx = vdpa_nic->vring[idx].last_used_idx;
+
+	rc = efx_vdpa_vring_create(vdpa_nic->vring[idx].vring_ctx,
+				   &vring_cfg, &vring_dyn_cfg);
+	if (rc) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: vring_create failed index:%u, err:%d\n",
+			__func__, idx, rc);
+		goto err_vring_create;
+	}
+	vdpa_nic->vring[idx].vring_state |= EF100_VRING_CREATED;
+
+	/* A VQ kick allows the device to read the avail_idx, which will be
+	 * required at the destination after live migration.
+	 */
+	ef100_vdpa_kick_vq(&vdpa_nic->vdpa_dev, idx);
+
+	return 0;
+
+err_vring_create:
+	irq_vring_fini(vdpa_nic, idx);
+	return rc;
+}
+
+static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
+{
+	delete_vring(vdpa_nic, idx);
+	vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
+	vdpa_nic->vring[idx].vring_state = 0;
+	vdpa_nic->vring[idx].last_avail_idx = 0;
+	vdpa_nic->vring[idx].last_used_idx = 0;
+}
+
+static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
+{
+	int i;
+
+	WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
+
+	if (!vdpa_nic->status)
+		return;
+
+	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
+	vdpa_nic->status = 0;
+	vdpa_nic->features = 0;
+	for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
+		reset_vring(vdpa_nic, i);
+	ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
+}
+
+/* May be called under the rtnl lock */
+int ef100_vdpa_reset(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+
+	/* vdpa device can be deleted anytime but the bar_config
+	 * could still be vdpa and hence efx->state would be STATE_VDPA.
+	 * Accordingly, ensure vdpa device exists before reset handling
+	 */
+	if (!vdpa_nic)
+		return -ENODEV;
+
+	mutex_lock(&vdpa_nic->lock);
+	ef100_reset_vdpa_device(vdpa_nic);
+	mutex_unlock(&vdpa_nic->lock);
+	return 0;
+}
+
+static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
+{
+	struct efx_nic *efx = vdpa_nic->efx;
+	struct ef100_nic_data *nic_data;
+	int i, j;
+	int rc;
+
+	nic_data = efx->nic_data;
+	rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
+					  vdpa_nic->max_queue_pairs * 2);
+	if (rc < 0) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"vDPA IRQ alloc failed for vf: %u err:%d\n",
+			nic_data->vf_index, rc);
+		return rc;
+	}
+
+	for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
+		if (can_create_vring(vdpa_nic, i)) {
+			rc = create_vring(vdpa_nic, i);
+			if (rc)
+				goto clear_vring;
+		}
+	}
+
+	vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
+	return 0;
+
+clear_vring:
+	for (j = 0; j < i; j++)
+		delete_vring(vdpa_nic, j);
+
+	ef100_vdpa_irq_vectors_free(efx->pci_dev);
+	return rc;
+}
+
 static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
 				     u16 idx, u64 desc_area, u64 driver_area,
 				     u64 device_area)
@@ -145,22 +362,6 @@ static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32 num)
 	mutex_unlock(&vdpa_nic->lock);
 }
 
-static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
-{
-	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
-	u32 idx_val;
-
-	if (is_qid_invalid(vdpa_nic, idx, __func__))
-		return;
-
-	if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
-		return;
-
-	idx_val = idx;
-	_efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
-		    vdpa_nic->vring[idx].doorbell_offset);
-}
-
 static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
 				 struct vdpa_callback *cb)
 {
@@ -177,6 +378,7 @@ static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
 				    bool ready)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int rc;
 
 	if (is_qid_invalid(vdpa_nic, idx, __func__))
 		return;
@@ -185,9 +387,21 @@ static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
 	if (ready) {
 		vdpa_nic->vring[idx].vring_state |=
 					EF100_VRING_READY_CONFIGURED;
+		if (vdpa_nic->vdpa_state == EF100_VDPA_STATE_STARTED &&
+		    can_create_vring(vdpa_nic, idx)) {
+			rc = create_vring(vdpa_nic, idx);
+			if (rc)
+				/* Rollback ready configuration
+				 * So that the above layer driver
+				 * can make another attempt to set ready
+				 */
+				vdpa_nic->vring[idx].vring_state &=
+					~EF100_VRING_READY_CONFIGURED;
+		}
 	} else {
 		vdpa_nic->vring[idx].vring_state &=
 					~EF100_VRING_READY_CONFIGURED;
+		delete_vring(vdpa_nic, idx);
 	}
 	mutex_unlock(&vdpa_nic->lock);
 }
@@ -356,6 +570,76 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
 	return EF100_VDPA_VENDOR_ID;
 }
 
+static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u8 status;
+
+	mutex_lock(&vdpa_nic->lock);
+	status = vdpa_nic->status;
+	mutex_unlock(&vdpa_nic->lock);
+	return status;
+}
+
+static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	u8 new_status;
+	int rc;
+
+	mutex_lock(&vdpa_nic->lock);
+	if (!status) {
+		dev_dbg(&vdev->dev,
+			"%s: Device reset on receiving status 0\n", __func__);
+		ef100_reset_vdpa_device(vdpa_nic);
+		goto unlock_return;
+	}
+	new_status = status & ~vdpa_nic->status;
+	if (new_status == 0) {
+		dev_dbg(&vdev->dev,
+			"%s: New status same as current status\n", __func__);
+		goto unlock_return;
+	}
+	if (new_status & VIRTIO_CONFIG_S_FAILED) {
+		ef100_reset_vdpa_device(vdpa_nic);
+		goto unlock_return;
+	}
+
+	if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
+		new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
+	}
+	if (new_status & VIRTIO_CONFIG_S_DRIVER) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
+		new_status &= ~VIRTIO_CONFIG_S_DRIVER;
+	}
+	if (new_status & VIRTIO_CONFIG_S_FEATURES_OK) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
+		vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
+		new_status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
+	}
+	if (new_status & VIRTIO_CONFIG_S_DRIVER_OK &&
+	    vdpa_nic->vdpa_state == EF100_VDPA_STATE_NEGOTIATED) {
+		vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER_OK;
+		rc = start_vdpa_device(vdpa_nic);
+		if (rc) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: vDPA device failed:%d\n", __func__, rc);
+			vdpa_nic->status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
+			goto unlock_return;
+		}
+		new_status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
+	}
+	if (new_status) {
+		dev_warn(&vdev->dev,
+			 "%s: Mismatch Status: %x & State: %u\n",
+			 __func__, new_status, vdpa_nic->vdpa_state);
+	}
+
+unlock_return:
+	mutex_unlock(&vdpa_nic->lock);
+}
+
 static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
 {
 	return sizeof(struct virtio_net_config);
@@ -381,6 +665,12 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
 
+	if (vdpa_nic->vdpa_state == EF100_VDPA_STATE_SUSPENDED) {
+		dev_err(&vdev->dev,
+			"config update not allowed in suspended state\n");
+		return;
+	}
+
 	/* Avoid the possibility of wrap-up after the sum exceeds U32_MAX */
 	if (WARN_ON(((u64)offset + len) > sizeof(vdpa_nic->net_config))) {
 		dev_err(&vdev->dev,
@@ -393,6 +683,21 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 		vdpa_nic->mac_configured = true;
 }
 
+static int ef100_vdpa_suspend(struct vdpa_device *vdev)
+{
+	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int i, rc;
+
+	mutex_lock(&vdpa_nic->lock);
+	for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
+		rc = delete_vring(vdpa_nic, i);
+		if (rc)
+			break;
+	}
+	vdpa_nic->vdpa_state = EF100_VDPA_STATE_SUSPENDED;
+	mutex_unlock(&vdpa_nic->lock);
+	return rc;
+}
 static void ef100_vdpa_free(struct vdpa_device *vdev)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
@@ -428,9 +733,13 @@ const struct vdpa_config_ops ef100_vdpa_config_ops = {
 	.get_vq_num_max      = ef100_vdpa_get_vq_num_max,
 	.get_device_id	     = ef100_vdpa_get_device_id,
 	.get_vendor_id	     = ef100_vdpa_get_vendor_id,
+	.get_status	     = ef100_vdpa_get_status,
+	.set_status	     = ef100_vdpa_set_status,
+	.reset               = ef100_vdpa_reset,
 	.get_config_size     = ef100_vdpa_get_config_size,
 	.get_config	     = ef100_vdpa_get_config,
 	.set_config	     = ef100_vdpa_set_config,
 	.get_generation      = NULL,
+	.suspend	     = ef100_vdpa_suspend,
 	.free	             = ef100_vdpa_free,
 };
-- 
2.30.1

