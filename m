Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078774C3797
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiBXVYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiBXVYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:24:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9260A278C9B;
        Thu, 24 Feb 2022 13:24:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nx33ckspCBcnhOsLNC1zrnz3WKqMz8cj0O+nLLNqSgx8p/ozYCW4ikQxz5gUL2ZP8rcMNjYiuBvgapy4bkatcWmSGq5eHym4FDWBPXKYEvegQvjJG1zs9SOqZRIbYd1y3sF8PAtg45ShDBsl05DnieMrOTrkrfEPst+Yd2dpCcfSOOquyPpnYu2br8hqXrzTGz+iWl9ibIbkNI/dyiYLnBzdbLsz6VPmWbhripK+MFOFG3A8B7wx2PomgN7lfFMpbCDB5bHFf6h9J2m4wCuo5m01i7WKyBXB8RXnPWInNt+ncaDzzpLlPCur1EPzEZJykrtZWzZGp+VFAgnJSgGfkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwvBTSeixOOLHffhoPvMUDqtDdFldJ6wjakUEXHknv8=;
 b=aG8k9a42adDSfqWXQSskkfw1xAmoOtdwVxqkbEnLiTjBKPa5lJUTiAqvqTyXrfG/ChQPGpEyLA3Jt4sLLHQuPXa7Lncj5k/REdtfvIAUGff2QQPcigWO9WHyMePoAjZy2msUSvV9MsRaxOxPpkA/1177yVAOZPoL81dFnWO3wU+K+bwgZKdgJ7Q05xyiikerqH0iqTGqDExsT/wr4EaOBp6hPYac2JAwfFW89J9prYnndNe4BMaDZ2mTxFQkgzIj7MNerjQiSF7Y4Oiqh8KHHpa9s0vg1SDK3cHyRbebmxPevsLrmFTYgU1sKT1VqL22FNwKrMvBKknzg6na0T6EaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwvBTSeixOOLHffhoPvMUDqtDdFldJ6wjakUEXHknv8=;
 b=m7YHi8YO2NlSdRHZmoud+81nXpMfo1mX7aex4ACEYCMXb/gH4TgteQi3Jfv4/cjscpD7tbwvxs5IYfifT/xN4+0GLPmzaTRLIYhZsZ2CFfc8V+JF0Xwfj8M9fqX4rFwRFuyB5HxQodo0Xave1eq7a4gQ3EKU5Va7XOoB3ig++dU=
Received: from DM6PR13CA0005.namprd13.prod.outlook.com (2603:10b6:5:bc::18) by
 BN7PR02MB3972.namprd02.prod.outlook.com (2603:10b6:406:ef::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.21; Thu, 24 Feb 2022 21:24:19 +0000
Received: from DM3NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::2d) by DM6PR13CA0005.outlook.office365.com
 (2603:10b6:5:bc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Thu, 24 Feb 2022 21:24:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT046.mail.protection.outlook.com (10.13.4.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:24:19 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:24:17 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:24:17 -0800
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
        id 1nNLay-00095B-PW; Thu, 24 Feb 2022 13:24:17 -0800
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
Subject: [RFC PATCH v2 03/19] vhost-vdpa: passing iotlb to IOMMU mapping helpers
Date:   Fri, 25 Feb 2022 02:52:43 +0530
Message-ID: <20220224212314.1326-4-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed647084-f79e-4f6e-ed98-08d9f7dc04b5
X-MS-TrafficTypeDiagnostic: BN7PR02MB3972:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB3972A14CDD8078988ECEF1B4B13D9@BN7PR02MB3972.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TG1lqB7tLFRkTmVxSIwvriND7BN5d2xQS7KwMDk0Iv7DCc1Ks7TQetEKGxXD1hetoO4at5ijzaIgfzIquPSgHSz9UF18vCilVmFF/reqvvQzg6AdYgzAVYag2uaQQxSRT5Nwa2TtygNx4+LP8hRyIfapPonJ7MqSS2D4fqJ3eGt5iu2e803F1Bq6Q9UvXi8P9LhNBzeA8aRig/s7s+q/ekLEHNGeEJJZr+EKJYhiaq21AlT4VHr1kIl3HP9x2DtAde7hGVqZ2SuLfpVdI7yN4c0bQnC06r5UFn0de3J6Z+t289VW8a5fbgzVqO0+qDHYIJfFfbB7Pdjk9bc55yuTMRfWDG6a2HsyRG3DvHq/bkeLQOEIoxtPdQpF41dBB3WYW5f88vZfP5dDP0ObPbjc4q/j3L98hlwzfetcfyMPdJmjrVVdmHHUTAKLDoFwdsT1/KwNVRlMS93kNH63ClIB+meCdwUzVCRziSrOHUQvFntgtggpzkzzzgtMpdBTPsDL9kV+CeDNAgjbpt0ELPqXZDv5dbBRPrEUZYi2h6h52O9OqRkrrK318UkJq/PwZPxr/O8JzAQPzEE/mMmHQuz7AoIiHsGIdhvJwGKZ9JJw7Fqtnad1l1mlDOTInlDIszy1xeV28GFSQojDdLluv7HxMh9FgiZpMJ9JhZqvWkraqz4+I0iLjs3LaFgmbaGmcIU1KGvuZKMSHhakCIyzlrFspg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(44832011)(9786002)(356005)(316002)(2906002)(7636003)(36860700001)(83380400001)(109986005)(7416002)(336012)(82310400004)(426003)(54906003)(47076005)(5660300002)(2616005)(6666004)(8936002)(4326008)(1076003)(7696005)(70586007)(36756003)(70206006)(186003)(26005)(508600001)(8676002)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:24:19.2595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed647084-f79e-4f6e-ed98-08d9f7dc04b5
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT046.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB3972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prepare for the ASID support for vhost-vdpa, try to pass IOTLB
object to dma helpers. No functional changes, it's just a preparation
for support multiple IOTLBs.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 67 ++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 851539807bc9..146911082514 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -503,10 +503,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	return r;
 }
 
-static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v,
+				struct vhost_iotlb *iotlb,
+				u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct vhost_iotlb_map *map;
 	struct page *page;
 	unsigned long pfn, pinned;
@@ -525,10 +526,10 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	}
 }
 
-static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_va_unmap(struct vhost_vdpa *v,
+				struct vhost_iotlb *iotlb,
+				u64 start, u64 last)
 {
-	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct vhost_iotlb_map *map;
 	struct vdpa_map_file *map_file;
 
@@ -540,21 +541,24 @@ static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	}
 }
 
-static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
+				   struct vhost_iotlb *iotlb,
+				   u64 start, u64 last)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
 	if (vdpa->use_va)
-		return vhost_vdpa_va_unmap(v, start, last);
+		return vhost_vdpa_va_unmap(v, iotlb, start, last);
 
-	return vhost_vdpa_pa_unmap(v, start, last);
+	return vhost_vdpa_pa_unmap(v, iotlb, start, last);
 }
 
 static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
 {
 	struct vhost_dev *dev = &v->vdev;
+	struct vhost_iotlb *iotlb = dev->iotlb;
 
-	vhost_vdpa_iotlb_unmap(v, 0ULL, 0ULL - 1);
+	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
 	kfree(dev->iotlb);
 	dev->iotlb = NULL;
 }
@@ -581,15 +585,15 @@ static int perm_to_iommu_flags(u32 perm)
 	return flags | IOMMU_CACHE;
 }
 
-static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
-			  u64 size, u64 pa, u32 perm, void *opaque)
+static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
+			  u64 iova, u64 size, u64 pa, u32 perm, void *opaque)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
 
-	r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
+	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
 		return r;
@@ -598,13 +602,13 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			r = ops->set_map(vdpa, dev->iotlb);
+			r = ops->set_map(vdpa, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 	}
 	if (r) {
-		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
+		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
 		return r;
 	}
 
@@ -614,25 +618,27 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 	return 0;
 }
 
-static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
+static void vhost_vdpa_unmap(struct vhost_vdpa *v,
+			     struct vhost_iotlb *iotlb,
+			     u64 iova, u64 size)
 {
-	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 
-	vhost_vdpa_iotlb_unmap(v, iova, iova + size - 1);
+	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
 
 	if (ops->dma_map) {
 		ops->dma_unmap(vdpa, iova, size);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			ops->set_map(vdpa, dev->iotlb);
+			ops->set_map(vdpa, iotlb);
 	} else {
 		iommu_unmap(v->domain, iova, size);
 	}
 }
 
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
+			     struct vhost_iotlb *iotlb,
 			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
 	struct vhost_dev *dev = &v->vdev;
@@ -662,7 +668,7 @@ static int vhost_vdpa_va_map(struct vhost_vdpa *v,
 		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
 		map_file->offset = offset;
 		map_file->file = get_file(vma->vm_file);
-		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
+		ret = vhost_vdpa_map(v, iotlb, map_iova, map_size, uaddr,
 				     perm, map_file);
 		if (ret) {
 			fput(map_file->file);
@@ -675,7 +681,7 @@ static int vhost_vdpa_va_map(struct vhost_vdpa *v,
 		map_iova += map_size;
 	}
 	if (ret)
-		vhost_vdpa_unmap(v, iova, map_iova - iova);
+		vhost_vdpa_unmap(v, iotlb, iova, map_iova - iova);
 
 	mmap_read_unlock(dev->mm);
 
@@ -683,6 +689,7 @@ static int vhost_vdpa_va_map(struct vhost_vdpa *v,
 }
 
 static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
+			     struct vhost_iotlb *iotlb,
 			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
 	struct vhost_dev *dev = &v->vdev;
@@ -746,7 +753,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			if (last_pfn && (this_pfn != last_pfn + 1)) {
 				/* Pin a contiguous chunk of memory */
 				csize = PFN_PHYS(last_pfn - map_pfn + 1);
-				ret = vhost_vdpa_map(v, iova, csize,
+				ret = vhost_vdpa_map(v, iotlb, iova, csize,
 						     PFN_PHYS(map_pfn),
 						     perm, NULL);
 				if (ret) {
@@ -776,7 +783,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	}
 
 	/* Pin the rest chunk */
-	ret = vhost_vdpa_map(v, iova, PFN_PHYS(last_pfn - map_pfn + 1),
+	ret = vhost_vdpa_map(v, iotlb, iova, PFN_PHYS(last_pfn - map_pfn + 1),
 			     PFN_PHYS(map_pfn), perm, NULL);
 out:
 	if (ret) {
@@ -796,7 +803,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-		vhost_vdpa_unmap(v, start, size);
+		vhost_vdpa_unmap(v, iotlb, start, size);
 	}
 unlock:
 	mmap_read_unlock(dev->mm);
@@ -807,11 +814,10 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 }
 
 static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
+					   struct vhost_iotlb *iotlb,
 					   struct vhost_iotlb_msg *msg)
 {
-	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 
 	if (msg->iova < v->range.first || !msg->size ||
 	    msg->iova > U64_MAX - msg->size + 1 ||
@@ -823,10 +829,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		return -EEXIST;
 
 	if (vdpa->use_va)
-		return vhost_vdpa_va_map(v, msg->iova, msg->size,
+		return vhost_vdpa_va_map(v, iotlb, msg->iova, msg->size,
 					 msg->uaddr, msg->perm);
 
-	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
+	return vhost_vdpa_pa_map(v, iotlb, msg->iova, msg->size, msg->uaddr,
 				 msg->perm);
 }
 
@@ -836,6 +842,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_iotlb *iotlb = dev->iotlb;
 	int r = 0;
 
 	mutex_lock(&dev->mutex);
@@ -846,17 +853,17 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
-		r = vhost_vdpa_process_iotlb_update(v, msg);
+		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
 		break;
 	case VHOST_IOTLB_INVALIDATE:
-		vhost_vdpa_unmap(v, msg->iova, msg->size);
+		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
 		break;
 	case VHOST_IOTLB_BATCH_BEGIN:
 		v->in_batch = true;
 		break;
 	case VHOST_IOTLB_BATCH_END:
 		if (v->in_batch && ops->set_map)
-			ops->set_map(vdpa, dev->iotlb);
+			ops->set_map(vdpa, iotlb);
 		v->in_batch = false;
 		break;
 	default:
-- 
2.25.0

