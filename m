Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067AD4C37A1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiBXVZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiBXVZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:25:31 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F7E293A23;
        Thu, 24 Feb 2022 13:25:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVt0uVkY4R1bCG4WrmAlVWEaOjY7a9Jo2vWPJ/fFNi/6seHojdckVetnHigQ/b5Si464uX/9sYJg06Rs7s4mrv7FfhDkbTdjud/i7ovaBw1bB19SYTih2XRWekWswJYvzoCgT5Yj/bllBBQYOTQVhYQSgAL3WPktpU7G/6TQlbVhIk4jksOQrk12nyZWkcLI2HCo8pG02wCvLilozitTbhGVxxSWiB41J7FrdAlZ+afygKDyOdKfHXSSakKGRY3lV4MNSQvcgFyqBaImzE6JP1fL5knmKWajLxzLvngKzPWbaueU+sMDM+MVJQZE4uGXUAYeRltLjYF2oV6JHb4sHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jyV3IZwgLLB1SYiMihS28vGApAg0sxiaAEbsRr/1fhQ=;
 b=Gxha8kpxIkxzySXHTjWQTZqFRPK8hvZczsIAhppucfCOUp7d/KD9qX3KC5lDj4jf7e0HIA/h72JZJriDkmDkEir/ncXINJoT8vil+btf0yJl6y62UWTQuByCKGVl1rQ1YUVPOSiTJl1NloQPrW2BNHyHUCTDliHxAnuP4/x7fJiVCtMkZ/K5x/HBsoiwyXfURC/JyyjCQpHKBweK8Z2k2TDgxfKtUAgltJANZePehoLctcMbEKi686CzFK38m2NOnh6aLuLM+lQu47PCtvSuV/UU2q4DotKnDkKpfOmxfbTWddNfOwZGnW4P+gpbQByV6QKQhSDRuRAI1w+RYfOwGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyV3IZwgLLB1SYiMihS28vGApAg0sxiaAEbsRr/1fhQ=;
 b=cvl1efRoqRRizCwFzeUi0LI911gowNXvrrLcqT5hb7w/mRtvXaTCIlsArhob3vwLLbByHQgbvzh+H7lOqT3uSUHYioQew7rRvwKXxQxy7xCTFYVgJvcIXsxZIOaYCODK4/zI5rXVIAu2LijOcB3p1GOt9l6ZaM+f2XxZLivABOk=
Received: from DM5PR10CA0016.namprd10.prod.outlook.com (2603:10b6:4:2::26) by
 DM8PR02MB8278.namprd02.prod.outlook.com (2603:10b6:8:9::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.24; Thu, 24 Feb 2022 21:24:58 +0000
Received: from DM3NAM02FT008.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::5b) by DM5PR10CA0016.outlook.office365.com
 (2603:10b6:4:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 21:24:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT008.mail.protection.outlook.com (10.13.5.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:24:58 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:24:56 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:24:56 -0800
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
        id 1nNLbb-00095B-Gx; Thu, 24 Feb 2022 13:24:56 -0800
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
Subject: [RFC PATCH v2 05/19] vdpa: introduce virtqueue groups
Date:   Fri, 25 Feb 2022 02:52:45 +0530
Message-ID: <20220224212314.1326-6-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56a8f47a-ee28-4fad-8cc1-08d9f7dc1bda
X-MS-TrafficTypeDiagnostic: DM8PR02MB8278:EE_
X-Microsoft-Antispam-PRVS: <DM8PR02MB8278D0BFB89788342880100FB13D9@DM8PR02MB8278.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /dDOc+g/MA3LTLx5PgqfB1MmDtBmnA4O4Ttppx5AfoBXc12NgMIxx3C32JnLpdRtxHcXKE7yDLfrLnleThY4NoqTBB/Mxf5XJvqRtdV/oei8hmsh99AYN16l2ouH0qeEyTIKxrVl1V95hNR/UuiuROSRHB3933jzcw8FjUfnXgDCofqlNtbEwcxKLAAdo5vl/AJoZqzCC5gL9ECY1PAwfHUPrEI+NKaLSbBJxrFOxVughtfzcNj1FTW+ZI4yUpWKwZ9OFb1XTy4l6Kpdnri7bIQQ4gAdV3kwFNkj9lsnpo56HviwUZL+omC6/N8z78ao9hFZvqIraES9M5NIi9lwczQ2DSNgZopjFcCImZN6gm+utavfPtDgRfpUAlkDbrv1DcNygu7tvMF2zamd/n958q4PkIbKQxbbVH4gIL5xbF0wLi+4VUT3tCJYPuf1A44RFkdRIsGQqiwfJiU61O7tFpHCra03a5FgM8yv86CCxO91KN9wAK05TErTiwJi9JIovmwv7qTd3AGsBZCTOuCQHG3I6RdluLJTevRPAP8aAPT95nyVTKRiTQytMU8ZNPv/5XZY//+LTe6Eh81k6PalJb8zXbTTrp3eE1NSscPcURom1b4yOnvAlUq8lSv2nLtDejHAWak6eyx72MibaKkP+75oOlOIWiAOAi0ytII1xJEOnYyO2F8miRUlqN3qjH62vrR2c2A9MJtadWgSfxrGwUddtTRFEQG9yHdizDQHPW4=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(9786002)(36860700001)(316002)(40460700003)(7696005)(1076003)(2906002)(83380400001)(54906003)(7416002)(508600001)(82310400004)(5660300002)(6666004)(186003)(70206006)(70586007)(44832011)(36756003)(109986005)(47076005)(7636003)(26005)(356005)(8936002)(4326008)(8676002)(336012)(2616005)(426003)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:24:58.0871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a8f47a-ee28-4fad-8cc1-08d9f7dc1bda
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT008.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8278
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces virtqueue groups to vDPA device. The virtqueue
group is the minimal set of virtqueues that must share an address
space. And the address space identifier could only be attached to
a specific virtqueue group.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c   |  8 +++++++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  8 +++++++-
 drivers/vdpa/vdpa.c               |  3 +++
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |  9 ++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.h  |  1 +
 include/linux/vdpa.h              | 16 ++++++++++++----
 6 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index d1a6b5ab543c..c815a2e62440 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -378,6 +378,11 @@ static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
 	return  vf->config_size;
 }
 
+static u32 ifcvf_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
+{
+	return 0;
+}
+
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
 				  unsigned int offset,
 				  void *buf, unsigned int len)
@@ -453,6 +458,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_device_id	= ifcvf_vdpa_get_device_id,
 	.get_vendor_id	= ifcvf_vdpa_get_vendor_id,
 	.get_vq_align	= ifcvf_vdpa_get_vq_align,
+	.get_vq_group	= ifcvf_vdpa_get_vq_group,
 	.get_config_size	= ifcvf_vdpa_get_config_size,
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
@@ -507,7 +513,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	pdev = ifcvf_mgmt_dev->pdev;
 	dev = &pdev->dev;
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, name, false);
+				    dev, &ifc_vdpa_ops, 1, name, false);
 	if (IS_ERR(adapter)) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return PTR_ERR(adapter);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index b53603d94082..fcfc28460b72 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1847,6 +1847,11 @@ static u32 mlx5_vdpa_get_vq_align(struct vdpa_device *vdev)
 	return PAGE_SIZE;
 }
 
+static u32 mlx5_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
+{
+	return 0;
+}
+
 enum { MLX5_VIRTIO_NET_F_GUEST_CSUM = 1 << 9,
 	MLX5_VIRTIO_NET_F_CSUM = 1 << 10,
 	MLX5_VIRTIO_NET_F_HOST_TSO6 = 1 << 11,
@@ -2363,6 +2368,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vq_notification = mlx5_get_vq_notification,
 	.get_vq_irq = mlx5_get_vq_irq,
 	.get_vq_align = mlx5_vdpa_get_vq_align,
+	.get_vq_group = mlx5_vdpa_get_vq_group,
 	.get_device_features = mlx5_vdpa_get_device_features,
 	.set_driver_features = mlx5_vdpa_set_driver_features,
 	.get_driver_features = mlx5_vdpa_get_driver_features,
@@ -2575,7 +2581,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	}
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 name, false);
+				 1, name, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 9846c9de4bfa..a07bf0130559 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -159,6 +159,7 @@ static void vdpa_release_dev(struct device *d)
  * initialized but before registered.
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
+ * @ngroups: number of groups supported by this device
  * @size: size of the parent structure that contains private data
  * @name: name of the vdpa device; optional.
  * @use_va: indicate whether virtual address must be used by this device
@@ -171,6 +172,7 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
+					unsigned int ngroups,
 					size_t size, const char *name,
 					bool use_va)
 {
@@ -203,6 +205,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->config = config;
 	vdev->features_valid = false;
 	vdev->use_va = use_va;
+	vdev->ngroups = ngroups;
 
 	if (name)
 		err = dev_set_name(&vdev->dev, "%s", name);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index ddbe142af09a..c98cb1f869fa 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -250,7 +250,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 	else
 		ops = &vdpasim_config_ops;
 
-	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
+	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
 				    dev_attr->name, false);
 	if (IS_ERR(vdpasim)) {
 		ret = PTR_ERR(vdpasim);
@@ -399,6 +399,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
 	return VDPASIM_QUEUE_ALIGN;
 }
 
+static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
+{
+	return 0;
+}
+
 static u64 vdpasim_get_device_features(struct vdpa_device *vdpa)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -620,6 +625,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.set_vq_state           = vdpasim_set_vq_state,
 	.get_vq_state           = vdpasim_get_vq_state,
 	.get_vq_align           = vdpasim_get_vq_align,
+	.get_vq_group           = vdpasim_get_vq_group,
 	.get_device_features    = vdpasim_get_device_features,
 	.set_driver_features    = vdpasim_set_driver_features,
 	.get_driver_features    = vdpasim_get_driver_features,
@@ -650,6 +656,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.set_vq_state           = vdpasim_set_vq_state,
 	.get_vq_state           = vdpasim_get_vq_state,
 	.get_vq_align           = vdpasim_get_vq_align,
+	.get_vq_group           = vdpasim_get_vq_group,
 	.get_device_features    = vdpasim_get_device_features,
 	.set_driver_features    = vdpasim_set_driver_features,
 	.get_driver_features    = vdpasim_get_driver_features,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index cd58e888bcf3..0be7c1e7ef80 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -63,6 +63,7 @@ struct vdpasim {
 	u32 status;
 	u32 generation;
 	u64 features;
+	u32 groups;
 	/* spinlock to synchronize iommu table */
 	spinlock_t iommu_lock;
 };
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 2de442ececae..026b7ad72ed7 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -85,6 +85,7 @@ struct vdpa_device {
 	bool use_va;
 	int nvqs;
 	struct vdpa_mgmt_dev *mdev;
+	unsigned int ngroups;
 };
 
 /**
@@ -172,6 +173,10 @@ struct vdpa_map_file {
  *				for the device
  *				@vdev: vdpa device
  *				Returns virtqueue algin requirement
+ * @get_vq_group:		Get the group id for a specific virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns u32: group id for this virtqueue
  * @get_device_features:	Get virtio features supported by the device
  *				@vdev: vdpa device
  *				Returns the virtio features support by the
@@ -282,6 +287,7 @@ struct vdpa_config_ops {
 
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
+	u32 (*get_vq_group)(struct vdpa_device *vdev, u16 idx);
 	u64 (*get_device_features)(struct vdpa_device *vdev);
 	int (*set_driver_features)(struct vdpa_device *vdev, u64 features);
 	u64 (*get_driver_features)(struct vdpa_device *vdev);
@@ -314,6 +320,7 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
+					unsigned int ngroups,
 					size_t size, const char *name,
 					bool use_va);
 
@@ -324,17 +331,18 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
  * @member: the name of struct vdpa_device within the @dev_struct
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
+ * @ngroups: the number of virtqueue groups supported by this device
  * @name: name of the vdpa device
  * @use_va: indicate whether virtual address must be used by this device
  *
  * Return allocated data structure or ERR_PTR upon error
  */
-#define vdpa_alloc_device(dev_struct, member, parent, config, name, use_va)   \
-			  container_of(__vdpa_alloc_device( \
-				       parent, config, \
+#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, name, use_va)   \
+			  container_of((__vdpa_alloc_device( \
+				       parent, config, ngroups, \
 				       sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name, use_va), \
+				       dev_struct, member)), name, use_va)), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
-- 
2.25.0

