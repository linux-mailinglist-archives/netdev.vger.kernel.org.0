Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DBD4C37D8
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbiBXVae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiBXVa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:30:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A596E1B30B8;
        Thu, 24 Feb 2022 13:29:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEZlCCSQ/7wT3omznt9fwGXYS+9pEmZtzqEC9z4rMxtMdDCSLvnmcYjDt/6kTWsgN3uNwRxB/wLnM6hmCedD6pAtkV0GDDdyoUDazBoVjSoyrxVGJm9Jd10Dps+uFV/VlU+D3a+NXagyumrpWKhB6OmlavuGpSZF9XPMHzX3XIikoo6kHktAghZ42aQrgaol7NCpnq7JEuPhCZHHQO5fqR8lduOwhz2YI5pTLDCS2eEukCFGbUPXz3WLE7nnLyNQWBRPrfZt7JdlSoQhAiS46CE4Egrq5xYjxjgk/l1pFFl+/dIgs0IE9xyc1lqOwbaH+02DXbY/KqqwR2uJ+lfPkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIVAkmyMu4D/7/q8D7dw9fdXaLEsq0oBEh5MIbgJahw=;
 b=W9TMlgBTN/7KrYWr0VVuz22FhCk5vmTQtAEykCYdiCKsBKO4D61Xh+Xvi8dmuKNW+dR3fRl1lAWXQ4uw9xiaF8AQlKrPawVFE3Wm8eQ1LdNdKZ5E76vmd8tvciZ4cZxqgi6O2kmOwlYdz5+N8ZlJAFnm2fHrXhfkicw/G/OWImDvewI4dwV4CU7r9mOORICGVzNrzGpGYGKB1ETa6WQ2EiBB2nPK2z7I17YVlNYLOhhkCMO2xcC1oSrI1XcPJRuKWAVZ2AnbjkZLvNs6Cd0viW4phEff0hfkC5M8KVdJntq50rqCYizngPy6I2++6VlkCGsmv4ORX3MyPWNr4Msq6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIVAkmyMu4D/7/q8D7dw9fdXaLEsq0oBEh5MIbgJahw=;
 b=XLgc9LOeD4C/bxn9YrsTuhUlfVUUR8UNTWhJ8yIZbwFuc5q69t5fe3NrwCLsxA+EewmAGE0c2Ddhzrc2z33zeJhv4Shv7f1e2tGjPZtQ1r+6Dnz5oEByNJzqNQHpNvtngeDRJvGtvYSoQp9qgtZmhjik0yCDJH6C4L1jaTXcqdk=
Received: from DS7PR05CA0032.namprd05.prod.outlook.com (2603:10b6:8:2f::31) by
 BYAPR02MB4519.namprd02.prod.outlook.com (2603:10b6:a03:59::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.23; Thu, 24 Feb 2022 21:29:41 +0000
Received: from DM3NAM02FT050.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::55) by DS7PR05CA0032.outlook.office365.com
 (2603:10b6:8:2f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Thu, 24 Feb 2022 21:29:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT050.mail.protection.outlook.com (10.13.5.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:29:41 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:29:23 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:29:23 -0800
Envelope-to: eperezma@redhat.com,
 jasowang@redhat.com,
 mst@redhat.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 elic@nvidia.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [10.170.66.102] (port=59620 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nNLfv-00095B-48; Thu, 24 Feb 2022 13:29:23 -0800
From:   Gautam Dawar <gautam.dawar@xilinx.com>
CC:     <gdawar@xilinx.com>, <martinh@xilinx.com>, <hanand@xilinx.com>,
        <tanujk@xilinx.com>, <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH v2 19/19] vdpasim: control virtqueue support
Date:   Fri, 25 Feb 2022 02:52:59 +0530
Message-ID: <20220224212314.1326-20-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8be1b091-5f7b-48ef-2e7b-08d9f7dcc491
X-MS-TrafficTypeDiagnostic: BYAPR02MB4519:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB45192A7EB85A0FD5E8BC0311B13D9@BYAPR02MB4519.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0f6fbxVPZBhaGEavcLR8ANCAoYtqmYt49LKfWN0LjWkpskwTQmbIzeia8dopJ8XSmxxNMPUyL/CgJwFmn14D4RKtzetK/+soUOI8XUc3wCfW9exfa92IXhlTR//89VR01UbXvnElsSqloHd6xEKuiGebtQmxjJYtQtUnwNqC3N54Whbjp/NrxVamir3LwN6UdANVSn5pjHUGfJWBeyvKnwFLqqAiQxqnNMax+KV6vsCZxO9Kh7Bmz36WFnJLZtt+6GHb1E3xGUVN1DDq5SWNUAIPX7b2sb/QMQbim7PLI8mc7A0q/K5iWwFBgBXY4cCQJAFaQs+SGhMMJgGOXF/VPYWlTSQ21sLtvDZHt9x+Uo5Ze1T2JCmWxKwS2p7fRBkBJCAd/ZaBy7CwfCEm/MQ9tj7dELDHNMdF6kPIWuFVPcmIsWNYXxTy7EOTQ9dt0SxtboA7dwAGk4dnE6Jlk4+dtyw/x0UcR9pYYOr3G6FrkmkDaLR1jxmNNKCkne4oT9JwzlM8x8CiHH9EKhK8DY6HpRzWYePGGk7ZVQLmPCJbZH2TewY5m+ZEWMh0FS+PTT5M8AnZfNsdYvm0iPmxezD+exOip+TwbiwvdbdKSajqp9/B/aFG51ojgO3SsKklQK2wIzjNxcn/P21cAUEYtddkJrRZmbPak5oC4CdA9kMHMcJEF3dN40vf/AVeOhRRTafoVkLcMAWfGWImrHmSLuYzCA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(5660300002)(8936002)(508600001)(7416002)(6666004)(9786002)(109986005)(7696005)(316002)(54906003)(8676002)(2906002)(1076003)(4326008)(356005)(7636003)(36756003)(186003)(26005)(2616005)(70586007)(70206006)(336012)(426003)(36860700001)(47076005)(30864003)(83380400001)(82310400004)(44832011)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:29:41.1413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be1b091-5f7b-48ef-2e7b-08d9f7dcc491
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT050.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4519
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the control virtqueue support for vDPA
simulator. This is a requirement for supporting advanced features like
multiqueue.

A requirement for control virtqueue is to isolate its memory access
from the rx/tx virtqueues. This is because when using vDPA device
for VM, the control virqueue is not directly assigned to VM. Userspace
(Qemu) will present a shadow control virtqueue to control for
recording the device states.

The isolation is done via the virtqueue groups and ASID support in
vDPA through vhost-vdpa. The simulator is extended to have:

1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
   contains CVQ
3) two address spaces and the simulator simply implements the address
   spaces by mapping it 1:1 to IOTLB.

For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
to group 1. So we have:

1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
   RX and TX can be assigned to guest directly.
2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
   is the buffers that allocated and managed by VMM only. So CVQ of
   vhost-vdpa is visible to VMM only. And Guest can not access the CVQ
   of vhost-vdpa.

For the other use cases, since AS 0 is associated to all virtqueue
groups by default. All virtqueues share the same mapping by default.

To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
implemented in the simulator for the driver to set mac address.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 91 ++++++++++++++++++++++------
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  2 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 88 ++++++++++++++++++++++++++-
 3 files changed, 161 insertions(+), 20 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 659e2e2e4b0c..59611f18a3a8 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -96,11 +96,17 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 {
 	int i;
 
-	for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
+	spin_lock(&vdpasim->iommu_lock);
+
+	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
 		vdpasim_vq_reset(vdpasim, &vdpasim->vqs[i]);
+		vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
+				 &vdpasim->iommu_lock);
+	}
+
+	for (i = 0; i < vdpasim->dev_attr.nas; i++)
+		vhost_iotlb_reset(&vdpasim->iommu[i]);
 
-	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_reset(vdpasim->iommu);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	vdpasim->features = 0;
@@ -145,7 +151,7 @@ static dma_addr_t vdpasim_map_range(struct vdpasim *vdpasim, phys_addr_t paddr,
 	dma_addr = iova_dma_addr(&vdpasim->iova, iova);
 
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range(vdpasim->iommu, (u64)dma_addr,
+	ret = vhost_iotlb_add_range(&vdpasim->iommu[0], (u64)dma_addr,
 				    (u64)dma_addr + size - 1, (u64)paddr, perm);
 	spin_unlock(&vdpasim->iommu_lock);
 
@@ -161,7 +167,7 @@ static void vdpasim_unmap_range(struct vdpasim *vdpasim, dma_addr_t dma_addr,
 				size_t size)
 {
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_del_range(vdpasim->iommu, (u64)dma_addr,
+	vhost_iotlb_del_range(&vdpasim->iommu[0], (u64)dma_addr,
 			      (u64)dma_addr + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
 
@@ -250,8 +256,9 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 	else
 		ops = &vdpasim_config_ops;
 
-	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
-				    1, dev_attr->name, false);
+	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
+				    dev_attr->ngroups, dev_attr->nas,
+				    dev_attr->name, false);
 	if (IS_ERR(vdpasim)) {
 		ret = PTR_ERR(vdpasim);
 		goto err_alloc;
@@ -278,16 +285,20 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 	if (!vdpasim->vqs)
 		goto err_iommu;
 
-	vdpasim->iommu = vhost_iotlb_alloc(max_iotlb_entries, 0);
+	vdpasim->iommu = kmalloc_array(vdpasim->dev_attr.nas,
+				       sizeof(*vdpasim->iommu), GFP_KERNEL);
 	if (!vdpasim->iommu)
 		goto err_iommu;
 
+	for (i = 0; i < vdpasim->dev_attr.nas; i++)
+		vhost_iotlb_init(&vdpasim->iommu[i], 0, 0);
+
 	vdpasim->buffer = kvmalloc(dev_attr->buffer_size, GFP_KERNEL);
 	if (!vdpasim->buffer)
 		goto err_iommu;
 
 	for (i = 0; i < dev_attr->nvqs; i++)
-		vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu,
+		vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
 				 &vdpasim->iommu_lock);
 
 	ret = iova_cache_get();
@@ -401,7 +412,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
 
 static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
 {
-	return 0;
+	/* RX and TX belongs to group 0, CVQ belongs to group 1 */
+	if (idx == 2)
+		return 1;
+	else
+		return 0;
 }
 
 static u64 vdpasim_get_device_features(struct vdpa_device *vdpa)
@@ -539,20 +554,53 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
 	return range;
 }
 
+static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
+				  unsigned int asid)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	struct vhost_iotlb *iommu;
+	int i;
+
+	if (group > vdpasim->dev_attr.ngroups)
+		return -EINVAL;
+
+	if (asid > vdpasim->dev_attr.nas)
+		return -EINVAL;
+
+	iommu = &vdpasim->iommu[asid];
+
+	spin_lock(&vdpasim->lock);
+
+	for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
+		if (vdpasim_get_vq_group(vdpa, i) == group)
+			vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
+					 &vdpasim->iommu_lock);
+
+	spin_unlock(&vdpasim->lock);
+
+	return 0;
+}
+
 static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 			   struct vhost_iotlb *iotlb)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	struct vhost_iotlb_map *map;
+	struct vhost_iotlb *iommu;
 	u64 start = 0ULL, last = 0ULL - 1;
 	int ret;
 
+	if (asid >= vdpasim->dev_attr.nas)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_reset(vdpasim->iommu);
+
+	iommu = &vdpasim->iommu[asid];
+	vhost_iotlb_reset(iommu);
 
 	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
 	     map = vhost_iotlb_itree_next(map, start, last)) {
-		ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
+		ret = vhost_iotlb_add_range(iommu, map->start,
 					    map->last, map->addr, map->perm);
 		if (ret)
 			goto err;
@@ -561,7 +609,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	return 0;
 
 err:
-	vhost_iotlb_reset(vdpasim->iommu);
+	vhost_iotlb_reset(iommu);
 	spin_unlock(&vdpasim->iommu_lock);
 	return ret;
 }
@@ -573,9 +621,12 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int ret;
 
+	if (asid >= vdpasim->dev_attr.nas)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range_ctx(vdpasim->iommu, iova, iova + size - 1,
-					pa, perm, opaque);
+	ret = vhost_iotlb_add_range_ctx(&vdpasim->iommu[asid], iova,
+					iova + size - 1, pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return ret;
@@ -586,8 +637,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
+	if (asid >= vdpasim->dev_attr.nas)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
+	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return 0;
@@ -611,8 +665,7 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	}
 
 	kvfree(vdpasim->buffer);
-	if (vdpasim->iommu)
-		vhost_iotlb_free(vdpasim->iommu);
+	vhost_iotlb_free(vdpasim->iommu);
 	kfree(vdpasim->vqs);
 	kfree(vdpasim->config);
 }
@@ -643,6 +696,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
 	.get_iova_range         = vdpasim_get_iova_range,
+	.set_group_asid         = vdpasim_set_group_asid,
 	.dma_map                = vdpasim_dma_map,
 	.dma_unmap              = vdpasim_dma_unmap,
 	.free                   = vdpasim_free,
@@ -674,6 +728,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
 	.get_iova_range         = vdpasim_get_iova_range,
+	.set_group_asid         = vdpasim_set_group_asid,
 	.set_map                = vdpasim_set_map,
 	.free                   = vdpasim_free,
 };
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 0be7c1e7ef80..622782e92239 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -41,6 +41,8 @@ struct vdpasim_dev_attr {
 	size_t buffer_size;
 	int nvqs;
 	u32 id;
+	u32 ngroups;
+	u32 nas;
 
 	work_func_t work_fn;
 	void (*get_config)(struct vdpasim *vdpasim, void *config);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index ed5ade4ae570..513970c05af2 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -26,10 +26,15 @@
 #define DRV_LICENSE  "GPL v2"
 
 #define VDPASIM_NET_FEATURES	(VDPASIM_FEATURES | \
+				 (1ULL << VIRTIO_NET_F_MTU) | \
 				 (1ULL << VIRTIO_NET_F_MAC) | \
-				 (1ULL << VIRTIO_NET_F_MTU));
+				 (1ULL << VIRTIO_NET_F_CTRL_VQ) | \
+				 (1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR));
 
-#define VDPASIM_NET_VQ_NUM	2
+/* 3 virtqueues, 2 address spaces, 2 virtqueue groups */
+#define VDPASIM_NET_VQ_NUM	3
+#define VDPASIM_NET_AS_NUM	2
+#define VDPASIM_NET_GROUP_NUM	2
 
 static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
 {
@@ -63,6 +68,81 @@ static bool receive_filter(struct vdpasim *vdpasim, size_t len)
 	return false;
 }
 
+static virtio_net_ctrl_ack vdpasim_handle_ctrl_mac(struct vdpasim *vdpasim,
+						   u8 cmd)
+{
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	size_t read;
+
+	switch (cmd) {
+	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov,
+					     (void *)vdpasim->config.mac,
+					     ETH_ALEN);
+		if (read == ETH_ALEN)
+			status = VIRTIO_NET_OK;
+		break;
+	default:
+		break;
+	}
+
+	return status;
+}
+
+static void vdpasim_handle_cvq(struct vdpasim *vdpasim)
+{
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	struct virtio_net_ctrl_hdr ctrl;
+	size_t read, write;
+	int err;
+
+	if (!(vdpasim->features & (1ULL << VIRTIO_NET_F_CTRL_VQ)))
+		return;
+
+	if (!cvq->ready)
+		return;
+
+	while (true) {
+		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->in_iov,
+					   &cvq->out_iov,
+					   &cvq->head, GFP_ATOMIC);
+		if (err <= 0)
+			break;
+
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov, &ctrl,
+					     sizeof(ctrl));
+		if (read != sizeof(ctrl))
+			break;
+
+		switch (ctrl.class) {
+		case VIRTIO_NET_CTRL_MAC:
+			status = vdpasim_handle_ctrl_mac(vdpasim, ctrl.cmd);
+			break;
+		default:
+			break;
+		}
+
+		/* Make sure data is wrote before advancing index */
+		smp_wmb();
+
+		write = vringh_iov_push_iotlb(&cvq->vring, &cvq->out_iov,
+					      &status, sizeof(status));
+		vringh_complete_iotlb(&cvq->vring, cvq->head, write);
+		vringh_kiov_cleanup(&cvq->in_iov);
+		vringh_kiov_cleanup(&cvq->out_iov);
+
+		/* Make sure used is visible before rasing the interrupt. */
+		smp_wmb();
+
+		local_bh_disable();
+		if (cvq->cb)
+			cvq->cb(cvq->private);
+		local_bh_enable();
+	}
+}
+
 static void vdpasim_net_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
@@ -77,6 +157,8 @@ static void vdpasim_net_work(struct work_struct *work)
 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
 		goto out;
 
+	vdpasim_handle_cvq(vdpasim);
+
 	if (!txq->ready || !rxq->ready)
 		goto out;
 
@@ -162,6 +244,8 @@ static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	dev_attr.id = VIRTIO_ID_NET;
 	dev_attr.supported_features = VDPASIM_NET_FEATURES;
 	dev_attr.nvqs = VDPASIM_NET_VQ_NUM;
+	dev_attr.ngroups = VDPASIM_NET_GROUP_NUM;
+	dev_attr.nas = VDPASIM_NET_AS_NUM;
 	dev_attr.config_size = sizeof(struct virtio_net_config);
 	dev_attr.get_config = vdpasim_net_get_config;
 	dev_attr.work_fn = vdpasim_net_work;
-- 
2.25.0

