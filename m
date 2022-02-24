Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567EE4C37A5
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiBXVZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiBXVZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:25:52 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288D029A56B;
        Thu, 24 Feb 2022 13:25:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBD0fIF0L0HiVEjtRv9ne/3w6z+aunC5+eU3wLmiH07eOScp9JPOQmNrFFtVbiexNJS5eHDe+PcwCCXKuVTPgM+2nZM98yemqZV5F9ZoOUiTXpIgKh5DQFKc0Cs2Jd+cBFBMQpLe2z94fPP3vEr8JwNE1JEepdXu+CnxJ+wr2kFM5me4WyM2mbLG6dxazrRMuHGWoYGGebNJTraUj6FqPHc7YwRAxDKJ63WveGCPK4smuEMDd/6XExtp6OG6JOJEM5p6ESS35wP45/2QLKn36xt8nU3Wei84i5P5F9T2d4HvUCmykpTiujgFFtLkFODa0gKf0GRMwcHJbR2d8te1Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rB4tGoviTm71x7fMbsUTs9o+zpihoaPWHAxfBn7YGcI=;
 b=bngoTvpDHZgojUgxZnGKgT7XYMg0nZue2XVZEWG4IH4Kck/DLsTZc2+VA9DXVOYH9MuzM7jlyIt4wSYhMCybB/ay+ywUTzwJKDcOhvL/hImZD8XZUbtDO8XaVLmRdOeWqxv1FVPKKuaUp7r42vP8VGjIEB8uzgpDJU+CkJzt1KtFgV49VGt87XhDXrWtm3FVAANqItrehe/POJRWRUSACv1xb88IynsVC7nxVgN8xlHYpub9mYDV5HYhPI5DaNdoLMI4U8qh2NzESICLkow7luja4uaI3nRpUA4i3uX8/fnhxLvaqYPUDjhCux2cFMz2vu0HOA0LWI/Bhfo2fgjgfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rB4tGoviTm71x7fMbsUTs9o+zpihoaPWHAxfBn7YGcI=;
 b=SKdCradAFSfB9itTQbzMyMvj1im/TitoOgxskYjMiG/EnckrXgCRRfBeQQq3SnP1U79HqBFzdYVG4nbruePPAdCjQ+Wmhrx9oqnjn0Y4llTH62wjIzIa8nHW/iWVuXFKLBbALoZyt3U9If78MzufgH4RVRkNeMyWpZo8CnLdP60=
Received: from DS7PR03CA0324.namprd03.prod.outlook.com (2603:10b6:8:2b::24) by
 BY5PR02MB6034.namprd02.prod.outlook.com (2603:10b6:a03:1b5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 24 Feb
 2022 21:25:17 +0000
Received: from DM3NAM02FT006.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::a0) by DS7PR03CA0324.outlook.office365.com
 (2603:10b6:8:2b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 21:25:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT006.mail.protection.outlook.com (10.13.4.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:25:16 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:25:14 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:25:14 -0800
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
        id 1nNLbu-00095B-Cd; Thu, 24 Feb 2022 13:25:14 -0800
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
Subject: [RFC PATCH v2 06/19] vdpa: multiple address spaces support
Date:   Fri, 25 Feb 2022 02:52:46 +0530
Message-ID: <20220224212314.1326-7-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41b76508-e63e-482d-3ab2-08d9f7dc26fe
X-MS-TrafficTypeDiagnostic: BY5PR02MB6034:EE_
X-Microsoft-Antispam-PRVS: <BY5PR02MB603477847D03ABD189A6E334B13D9@BY5PR02MB6034.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ctRGZkYlOWkELOpEoxdfeRCw6Ds7qZjNGlsTPD19yceWCcUdsFMof97EOjGjO3EcHZ5Ghe1yK707+xpdrA+rBon+gB12g8IdiSF9l59i0Gl28bgJm212HtCUXc7YVVu5WH3/no5nbcmWf/r3FqmHG0F9KWjklKG83GtMB7MgQW67T1hFUc/v639qff+eBwgqI1y3oEf1R/Gh5Eb5C7lan82IcULDh09kzgIgP/NqaYKhuEl2/Pg0It9b9/7haMJvQVWD98Z80FaxAtqtBd1BgssNDbm10gEFcQ6CeD+7qH4F/2Vwh9k0xd9+qPT/a6C6PmmGuhbcnwqIVrerrj6L3ax09hkp0JwerW6hAJS9zoYO7IEX89XRDuQQQxBPFPjNoFP9gqDFspKgPNWiTUvvJPjFjJzB95i9zQsS/HgLK2/4Pbs1vausuPES1xjTag7D6OuVpyqopEmjZrRxfSguee5xZrn94ZaecgHiLN2mUOcFDV+J8h6leWCvegCj8bB36FGZIEJiKgOAm7rzgXEoq0Izu2q0HjJxp8eNHS/34Dph/Dvu9EV90asXGUqL/A7FcoJNCm3W/R+qHghwvQhSRkL6eYrnrUsMc2hWHaF23XZ90HYVfaxixekIzY1OD3OGjde+UpOBcrCsa4NykhUS/PEEpTYYAzZ7nFwrt7o+RpbY98GNbkpzrNWmq2nlgf6dGOGgLguiSGqikDWTfEVV8Q==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(83380400001)(7696005)(36756003)(70586007)(70206006)(7636003)(36860700001)(336012)(426003)(356005)(47076005)(2906002)(8676002)(4326008)(5660300002)(109986005)(7416002)(54906003)(8936002)(30864003)(44832011)(9786002)(186003)(26005)(316002)(1076003)(2616005)(508600001)(6666004)(82310400004)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:25:16.7759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b76508-e63e-482d-3ab2-08d9f7dc26fe
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT006.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6034
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches introduces the multiple address spaces support for vDPA
device. This idea is to identify a specific address space via an
dedicated identifier - ASID.

During vDPA device allocation, vDPA device driver needs to report the
number of address spaces supported by the device then the DMA mapping
ops of the vDPA device needs to be extended to support ASID.

This helps to isolate the environments for the virtqueue that will not
be assigned directly. E.g in the case of virtio-net, the control
virtqueue will not be assigned directly to guest.

As a start, simply claim 1 virtqueue groups and 1 address spaces for
all vDPA devices. And vhost-vDPA will simply reject the device with
more than 1 virtqueue groups or address spaces.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  5 +++--
 drivers/vdpa/vdpa.c               |  4 +++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 10 ++++++----
 drivers/vhost/vdpa.c              | 14 +++++++++-----
 include/linux/vdpa.h              | 28 +++++++++++++++++++---------
 6 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index c815a2e62440..a4815c5612f9 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -513,7 +513,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	pdev = ifcvf_mgmt_dev->pdev;
 	dev = &pdev->dev;
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, 1, name, false);
+				    dev, &ifc_vdpa_ops, 1, 1, name, false);
 	if (IS_ERR(adapter)) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return PTR_ERR(adapter);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index fcfc28460b72..a76417892ef3 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2282,7 +2282,8 @@ static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
 	return mvdev->generation;
 }
 
-static int mlx5_vdpa_set_map(struct vdpa_device *vdev, struct vhost_iotlb *iotlb)
+static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
+			     struct vhost_iotlb *iotlb)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	bool change_map;
@@ -2581,7 +2582,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	}
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 1, name, false);
+				 1, 1, name, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index a07bf0130559..1793dc12b208 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -160,6 +160,7 @@ static void vdpa_release_dev(struct device *d)
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
  * @ngroups: number of groups supported by this device
+ * @nas: number of address spaces supported by this device
  * @size: size of the parent structure that contains private data
  * @name: name of the vdpa device; optional.
  * @use_va: indicate whether virtual address must be used by this device
@@ -172,7 +173,7 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					unsigned int ngroups,
+					unsigned int ngroups, unsigned int nas,
 					size_t size, const char *name,
 					bool use_va)
 {
@@ -206,6 +207,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->features_valid = false;
 	vdev->use_va = use_va;
 	vdev->ngroups = ngroups;
+	vdev->nas = nas;
 
 	if (name)
 		err = dev_set_name(&vdev->dev, "%s", name);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index c98cb1f869fa..659e2e2e4b0c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -251,7 +251,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 		ops = &vdpasim_config_ops;
 
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
-				    dev_attr->name, false);
+				    1, dev_attr->name, false);
 	if (IS_ERR(vdpasim)) {
 		ret = PTR_ERR(vdpasim);
 		goto err_alloc;
@@ -539,7 +539,7 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
 	return range;
 }
 
-static int vdpasim_set_map(struct vdpa_device *vdpa,
+static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 			   struct vhost_iotlb *iotlb)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -566,7 +566,8 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
 	return ret;
 }
 
-static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
+static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
+			   u64 iova, u64 size,
 			   u64 pa, u32 perm, void *opaque)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -580,7 +581,8 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
 	return ret;
 }
 
-static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 size)
+static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
+			     u64 iova, u64 size)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 655ff7029401..6bf755f84d26 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -599,10 +599,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
+		r = ops->dma_map(vdpa, 0, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			r = ops->set_map(vdpa, iotlb);
+			r = ops->set_map(vdpa, 0, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
@@ -628,10 +628,10 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
 	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
 
 	if (ops->dma_map) {
-		ops->dma_unmap(vdpa, iova, size);
+		ops->dma_unmap(vdpa, 0, iova, size);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			ops->set_map(vdpa, iotlb);
+			ops->set_map(vdpa, 0, iotlb);
 	} else {
 		iommu_unmap(v->domain, iova, size);
 	}
@@ -863,7 +863,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 		break;
 	case VHOST_IOTLB_BATCH_END:
 		if (v->in_batch && ops->set_map)
-			ops->set_map(vdpa, iotlb);
+			ops->set_map(vdpa, 0, iotlb);
 		v->in_batch = false;
 		break;
 	default:
@@ -1128,6 +1128,10 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int r;
 
+	/* Only support 1 address space and 1 groups */
+	if (vdpa->ngroups != 1 || vdpa->nas != 1)
+		return -EOPNOTSUPP;
+
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!v)
 		return -ENOMEM;
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 026b7ad72ed7..de22ca1a8ef3 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -69,6 +69,8 @@ struct vdpa_mgmt_dev;
  * @cf_mutex: Protects get and set access to configuration layout.
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
+ * @ngroups: the number of virtqueue groups
+ * @nas: the number of address spaces
  * @use_va: indicate whether virtual address must be used by this device
  * @nvqs: maximum number of supported virtqueues
  * @mdev: management device pointer; caller must setup when registering device as part
@@ -86,6 +88,7 @@ struct vdpa_device {
 	int nvqs;
 	struct vdpa_mgmt_dev *mdev;
 	unsigned int ngroups;
+	unsigned int nas;
 };
 
 /**
@@ -240,6 +243,7 @@ struct vdpa_map_file {
  *				Needed for device that using device
  *				specific DMA translation (on-chip IOMMU)
  *				@vdev: vdpa device
+ *				@asid: address space identifier
  *				@iotlb: vhost memory mapping to be
  *				used by the vDPA
  *				Returns integer: success (0) or error (< 0)
@@ -248,6 +252,7 @@ struct vdpa_map_file {
  *				specific DMA translation (on-chip IOMMU)
  *				and preferring incremental map.
  *				@vdev: vdpa device
+ *				@asid: address space identifier
  *				@iova: iova to be mapped
  *				@size: size of the area
  *				@pa: physical address for the map
@@ -259,6 +264,7 @@ struct vdpa_map_file {
  *				specific DMA translation (on-chip IOMMU)
  *				and preferring incremental unmap.
  *				@vdev: vdpa device
+ *				@asid: address space identifier
  *				@iova: iova to be unmapped
  *				@size: size of the area
  *				Returns integer: success (0) or error (< 0)
@@ -309,10 +315,12 @@ struct vdpa_config_ops {
 	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
 
 	/* DMA ops */
-	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
-	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
-		       u64 pa, u32 perm, void *opaque);
-	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
+	int (*set_map)(struct vdpa_device *vdev, unsigned int asid,
+		       struct vhost_iotlb *iotlb);
+	int (*dma_map)(struct vdpa_device *vdev, unsigned int asid,
+		       u64 iova, u64 size, u64 pa, u32 perm, void *opaque);
+	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
+			 u64 iova, u64 size);
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
@@ -320,7 +328,7 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					unsigned int ngroups,
+					unsigned int ngroups, unsigned int nas,
 					size_t size, const char *name,
 					bool use_va);
 
@@ -332,17 +340,19 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
  * @ngroups: the number of virtqueue groups supported by this device
+ * @nas: the number of address spaces
  * @name: name of the vdpa device
  * @use_va: indicate whether virtual address must be used by this device
  *
  * Return allocated data structure or ERR_PTR upon error
  */
-#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, name, use_va)   \
+#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, nas, \
+			  name, use_va) \
 			  container_of((__vdpa_alloc_device( \
-				       parent, config, ngroups, \
-				       sizeof(dev_struct) + \
+				       parent, config, ngroups, nas, \
+				       (sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name, use_va)), \
+				       dev_struct, member))), name, use_va)), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
-- 
2.25.0

