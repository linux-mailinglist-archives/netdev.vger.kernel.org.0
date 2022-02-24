Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFCB4C37B8
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiBXV1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbiBXV1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:27:21 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD01C2DD67;
        Thu, 24 Feb 2022 13:26:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCZNZBFu9PjLuNs7DrPYXNRYGT+4DSm+h6O9KR6PWn5NblTejc8pCohYiO5CqHL/ZGg/E8z7cgIZO7eTiebjHWlYXJNARGTsjoK9oqzEZrdCOjK6ZMwsGPdMpnW3Coi24ldHdoFBnaOPaa48MgKjHhfC01w3d2NJnCMsE9vdaaQ1DZA3+o/xn5wObK0IG9wZklvWpOkSuRlqfpJw9nvR5gJHjABTIo0kBZrkj/mE/lHA5q/7xhuyyY+1+01PTpMRFhLwDipqsE93t8GwodOorJLUxRvX7PoNb9mOTv5ajD5jJA1zKueEjgGcpsOga0w5YCCdxc+upYf0TfaXB2xmYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UMh827kCyqHeMys6i5nUx2W5HRE3fSujaJcYVcit8E=;
 b=RoiGkTDHVSIrf6x+Ukek1Wy2nlm7NnDpanbcPXho5Obmc3CjLvb78e8BnRpRviViFddWyQqn96nfxqiaGQmRgySoCuNS4lVajbos/EOBLRAfw+uZnWQUywGjDdjfi5GxHROnu3GQymAAQCY+qAVgTgc2fF8MWrONeVbRtUjKmXph4iCd/Cuc2J0h0XuOUb45Go0GjDlQ2i1DaChH//MF2cRB195M012XNLsFmQLfNV9p6+y72K1Z/pPZWdOojCilnrtrP7JCLnvMVS/vx9VD02OxW2q9QzUCdgUmALr76uOUDozUGhDHfd6Ko8u6fjgHp8swjLhNLSF11RUnw95FOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UMh827kCyqHeMys6i5nUx2W5HRE3fSujaJcYVcit8E=;
 b=ScsAmTpELrUQ2sXUlvdq9cwFTUaVfrRuB1OHOVG3ocv4e0VV2tePSmB6EkWpZekIF3eZBk/l3Fc0DzOZLJ9BtS3Zj7Tr3KIr16VmKtvIxHC04CRwOYS/gj3XiiHc1Ug4+ZeBSJG/eOumOXxgkeEx7ZpzQobp9TNZ3HiQxxKpUWk=
Received: from DS7PR03CA0143.namprd03.prod.outlook.com (2603:10b6:5:3b4::28)
 by PH0PR02MB8392.namprd02.prod.outlook.com (2603:10b6:510:10b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 21:26:32 +0000
Received: from DM3NAM02FT041.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::46) by DS7PR03CA0143.outlook.office365.com
 (2603:10b6:5:3b4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24 via Frontend
 Transport; Thu, 24 Feb 2022 21:26:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT041.mail.protection.outlook.com (10.13.5.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:26:31 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:26:31 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:26:31 -0800
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
        id 1nNLd8-00095B-TL; Thu, 24 Feb 2022 13:26:31 -0800
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
Subject: [RFC PATCH v2 10/19] vhost-vdpa: introduce asid based IOTLB
Date:   Fri, 25 Feb 2022 02:52:50 +0530
Message-ID: <20220224212314.1326-11-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6319486e-3a8f-4100-a64f-08d9f7dc53cb
X-MS-TrafficTypeDiagnostic: PH0PR02MB8392:EE_
X-Microsoft-Antispam-PRVS: <PH0PR02MB8392D97AE481D2AF31F0AA6AB13D9@PH0PR02MB8392.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5j9loyympihenahdZq4fPDJcdWBtmDSVifawbRM/kDANz3OkmhvZru37Fyz9njEyFQmitkyGg7O2JLQ+2Uu0xXtO12PDTIs2wkKIbShtY4tD1QfEEE4wQ7M5QehB8Qr8CJfBmnImyJJW/KEM5mN0hQd0V+8WbAh1OSnebwS6Q1sp0y1a3Zoo1XPPxrjh14Aujx5NnrkYPhEn41w2Io7kYJLmDlGhVmz0nZDDTUPrl1F7JSxBAmK1G4KKDfG7Cl/gQGv/OEkBifnbzcaI2ll955pFT3fV0PxMuxVJzVOB8PLydsr37AzKyskZqjd0bH8cUWBuVIrDkpK+VAFffH86KMKB5ZJwebaUFf8Mxpou1Ef1gXRLD9AlMXVIuEP4RpDm7y0nwTxBm5vwJOdVBQ6gEAUIO90/JOLraHJ5xIbkUAHNinUD6ukjd1Og7yUiHLN/LkAnsVwDgVRj8fCUMkf3g6FQjDUp1NZUt+Oj9Sl6NZl3WaP/trU0+oOXSA2UcYo3QsymfOlt+4wvdoZItlOCSb4bK9UHVGxGZolKT6mb+/N0Df32k1QXomTGBCP5wQkMBEGDyOqmt3jndyL3Y4EwI/orELrvKxcphC8tYs8ziyeo2JjkINB13/rsK4H4JbubcwQG/DIBG6Ezh/dTHd68DGYJ4PJFK7wI/SiypMemvmcSUDEY5pG5cHYIV6tlhAAOJTDfI/lUxT0PflqECgHbT2idvxS6H7TLpVTaSXAZBGY=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(109986005)(2616005)(508600001)(40460700003)(7696005)(6666004)(1076003)(82310400004)(7636003)(47076005)(356005)(186003)(4326008)(8676002)(54906003)(336012)(2906002)(426003)(316002)(36756003)(7416002)(5660300002)(36860700001)(70206006)(9786002)(44832011)(8936002)(83380400001)(70586007)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:26:31.9419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6319486e-3a8f-4100-a64f-08d9f7dc53cb
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT041.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8392
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the vhost-vDPA device to support multiple IOTLBs
tagged via ASID via hlist. This will be used for supporting multiple
address spaces in the following patches.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 104 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 79 insertions(+), 25 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d0aacc0cc79a..4e8b7c4809cd 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -33,13 +33,21 @@ enum {
 
 #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
 
+#define VHOST_VDPA_IOTLB_BUCKETS 16
+
+struct vhost_vdpa_as {
+	struct hlist_node hash_link;
+	struct vhost_iotlb iotlb;
+	u32 id;
+};
+
 struct vhost_vdpa {
 	struct vhost_dev vdev;
 	struct iommu_domain *domain;
 	struct vhost_virtqueue *vqs;
 	struct completion completion;
 	struct vdpa_device *vdpa;
-	struct vhost_iotlb *iotlb;
+	struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
@@ -49,12 +57,64 @@ struct vhost_vdpa {
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
 	struct vdpa_iova_range range;
+	int used_as;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
+	struct vhost_vdpa_as *as;
+
+	hlist_for_each_entry(as, head, hash_link)
+		if (as->id == asid)
+			return as;
+
+	return NULL;
+}
+
+static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
+	struct vhost_vdpa_as *as;
+
+	if (asid_to_as(v, asid))
+		return NULL;
+
+	as = kmalloc(sizeof(*as), GFP_KERNEL);
+	if (!as)
+		return NULL;
+
+	vhost_iotlb_init(&as->iotlb, 0, 0);
+	as->id = asid;
+	hlist_add_head(&as->hash_link, head);
+	++v->used_as;
+
+	return as;
+}
+
+static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
+
+	/* Remove default address space is not allowed */
+	if (asid == 0)
+		return -EINVAL;
+
+	if (!as)
+		return -EINVAL;
+
+	hlist_del(&as->hash_link);
+	vhost_iotlb_reset(&as->iotlb);
+	kfree(as);
+	--v->used_as;
+
+	return 0;
+}
+
 static void handle_vq_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -554,15 +614,6 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
 	return vhost_vdpa_pa_unmap(v, iotlb, start, last);
 }
 
-static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
-{
-	struct vhost_iotlb *iotlb = v->iotlb;
-
-	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
-	kfree(v->iotlb);
-	v->iotlb = NULL;
-}
-
 static int perm_to_iommu_flags(u32 perm)
 {
 	int flags = 0;
@@ -842,7 +893,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_iotlb *iotlb = v->iotlb;
+	struct vhost_vdpa_as *as = asid_to_as(v, 0);
+	struct vhost_iotlb *iotlb = &as->iotlb;
 	int r = 0;
 
 	mutex_lock(&dev->mutex);
@@ -953,6 +1005,13 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 	}
 }
 
+static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
+{
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
+	vhost_vdpa_remove_as(v, 0);
+}
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -985,15 +1044,12 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	v->iotlb = vhost_iotlb_alloc(0, 0);
-	if (!v->iotlb) {
-		r = -ENOMEM;
-		goto err_init_iotlb;
-	}
+	if (!vhost_vdpa_alloc_as(v, 0))
+		goto err_alloc_as;
 
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_domain;
+		goto err_alloc_as;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -1001,11 +1057,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
-err_alloc_domain:
-	vhost_vdpa_iotlb_free(v);
-err_init_iotlb:
-	vhost_dev_cleanup(&v->vdev);
-	kfree(vqs);
+err_alloc_as:
+	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
 	return r;
@@ -1029,11 +1082,9 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
-	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_dev_cleanup(&v->vdev);
-	kfree(v->vdev.vqs);
 	mutex_unlock(&d->mutex);
 
 	atomic_dec(&v->opened);
@@ -1129,7 +1180,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa *v;
 	int minor;
-	int r;
+	int i, r;
 
 	/* Only support 1 address space and 1 groups */
 	if (vdpa->ngroups != 1 || vdpa->nas != 1)
@@ -1177,6 +1228,9 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	init_completion(&v->completion);
 	vdpa_set_drvdata(vdpa, v);
 
+	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
+		INIT_HLIST_HEAD(&v->as[i]);
+
 	return 0;
 
 err:
-- 
2.25.0

