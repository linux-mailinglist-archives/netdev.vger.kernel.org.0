Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD61468B6AC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBFHtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBFHsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:48:37 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F6618AA0;
        Sun,  5 Feb 2023 23:48:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1HGJAAb6x79B/2uO5UNl7Wjc2N7fO6FI2Dh1hbWDDlv+NO5uTH6mAdcm+er4k8nzu8P0Kaskg3FjHIudIEyRFfVc9Xm0Vk4e0HCDKF0MnkAmGYeoOz1TxF9jUHoP5rWgtbNqzdKjT/nhBnQVpGpsOmo11SmN+OhWMVQc8a3pxFwCVuSBKUFpmuYEYL9tW9J4OqExG8v9wf3KR1LoFdsLRxTuFo9mrXN5sxOPEk9l5jiCTs2QJNp66zeZI9ZeDpGsJCib950WH5sOGgsBpMI6sdq/39XLEmNcRQEo0wrXgYinIoFrAcUd1SZ9Tkb0u7ydaqjIuPUMKsr0WAVQ/xlwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acjFfLRivjpU9Lg3kvi0rHomIWvWZtcIDwMkhY2Ky00=;
 b=WvQHQQY6ns3n0KefoFCSMggyX/x7tUCFBPrbp9NdXBsKIpZia9IjWTqt3eSONUAX+yLUVf/f7jSzoAsBeMeFbcbxdyGcuCNe8fhii7LnJQwbEVhoQP9ez9OILgeKvxr7XE6uG1UX4f3wtfuyx7uueogMthclboyNaqd3qFFXp9gdFuU9z5OQmVn7sX41V3f9gtlgjEpjlE4qtYykdA3BQ0qzRDi9puFRt2fttZpYdTSlTHSwl2yUwb/g78fOqsXXPtwz0BfZPXlM7XilI1VnZOxEpgjccCLr2WPMYZSyjgS55En9q1eQ/dhi5wL5ZcrgPrKpLkHNz+1GhTQZnn1PQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acjFfLRivjpU9Lg3kvi0rHomIWvWZtcIDwMkhY2Ky00=;
 b=fHCzouLaE5kk62Ua+XJqCu+1MTMXe9QNNft5c35YdS0i50bvUAWqQwwDrn6WVqaAYfc5Aidg/xzaQ5SFBBhZ4gA+1ACieJwCaudY6l1BzZjCaxKVgn4qTaBx9hGKlo3/y6J/vkzzjo2G9GpCRfcCOkH2sQmIVJC57BwZg+W0DjiRsab/SpX6BqJr5kYCky0e9uZliBjJYNKp4n5PYxO1SsvltINtqi+iaoiKq/hCDojR1uoXMTeQmZEY3+t1wjV97EZ0mdNWs5YOSNhOa1mvSuEUpJttEznQpB3KvsQ9L9ynFNXmo9SFjZFg14jddI/QyfyTAlVenv/bKHF6vnVsrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:63::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 07:48:29 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:48:28 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 02/19] drivers/vhost: Convert to use vm_account
Date:   Mon,  6 Feb 2023 18:47:39 +1100
Message-Id: <a513e511b71c67453a6a420d8527fbf9a666f594.1675669136.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYYP282CA0007.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::17) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c58a87-391d-4ca5-0a89-08db08168933
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrNBIKLnIaAVk8pRj+5fZdPHiWQLbiCyBMI2zKg2cn/Fb5SIPPTq4lnCgIO9odXsb8ca5CT7XeYfek6V6/WonuEcy5JdMn6sLVlCiVnJ8+Ov1rIIBf9gLZjZuBCjnvH/Wd6xnfauUrOnS+56ZmvqmsGiKMU6TZbflY5PyeUFiyx3IRDXixQZZIT5ym6ZQ7MKh8raEJ/LH1o+UP7NJoPzzuQ48Jb0ifrzKOsxekho/unsBaIl2VV/xLiygpn8AGWQxju5/jRKJnca49WShesGkRCwuOwffP4oE2yAHv1f8cozt4/Yv0H5Uz2ztFJoql8uXWgUwQRX6IUgRTwCE7tQQuLG+Qz4yuo5eO9UsiTTacmJ8Km9Z6QVPwNo0KCrtfKt5095/INsZiz3W/Z6LobWgqDJ54JjdrO5q7VngPFH4X8T9mvvUz8lrVAsBxtlxyWg+EpHxRy7IUxEZP5qoAKo6gPJP0O2ia04BzC700tnSx/zt72yOijmqvpn2vGzxW2oWQqmePxjQduwtPn9uh9Dk2DH6zAoNnmfSHc6IIHnLxiJZaS8qc/la4R7HFKCn5HbPPtBif8eAJAqs5LEH2cvuBbe9xD5r6x0dls19uIBKIJ8FQRsdEQfuF6JagQheOknCfPj5fxaLNnCmWp0X7T88g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(38100700002)(36756003)(6506007)(6666004)(6512007)(26005)(186003)(478600001)(86362001)(6486002)(8676002)(66476007)(83380400001)(66946007)(2616005)(66556008)(4326008)(316002)(54906003)(7416002)(2906002)(8936002)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BcZpvnNwT9Gb780Y2kPdCwKodPcm4oSD6aoJb8it9MH7scy9VMdJ8eQmHUo/?=
 =?us-ascii?Q?tYk3av3s2dxZOcg3ogvWJjgYJU4CmqrjLA6eULGYWsluLBw3iUNDcrusaQMg?=
 =?us-ascii?Q?U/JBCYKX4CFq4sbi4garbnQxS/dBlAc5UWaBAEJv37P0BnLLCYvW/Dwx9ye4?=
 =?us-ascii?Q?gQxLpwkc2n5jCYJeEc6WoZby6mWJO568dMYKg2KqFAI8FtEb6Bo9JoSvaYrJ?=
 =?us-ascii?Q?XHnMENDbbxrwkfTQtV8qXbCNBsDq1bG4y4mUzAcpT6ltL5rHPqvzBcfp9a0G?=
 =?us-ascii?Q?vjXvPnCh1LX1l8HQUHGtYt64+hq7tVHXRKdpIcExFvOwAmgADX31MwxqDpZ1?=
 =?us-ascii?Q?EsigM4KMtzPfDVx/vfmJvaGRTwbpGx0EbqDCfRpQ/NiwpLIUmNj2TLoK9Fgq?=
 =?us-ascii?Q?x52KVlNmvkfN/l+nVudtM3k3zgo7LK0zFvA4Opm+lkj5nJUUHw5HsDR07JdM?=
 =?us-ascii?Q?7STkTeJ6+JFp8GUKNp2S3lSzvg+LD0UHH+9NTqzGYQR1OwQmv9X9qGGWuHfF?=
 =?us-ascii?Q?fRshcD81zL7CSri0B6r0PZn2Skm99ITXb4U7QwWYgs8Mvnu0nltCKavJuxcK?=
 =?us-ascii?Q?RHUid7Kc7yBRK6mvMSgyp1Vs1mvQ+0wMs/inEdtR24LXqGfQ2aWUSH4B4rhE?=
 =?us-ascii?Q?UuKmK5VFvCbXiIbnoW07w8zy+rE9MQ4V2KxbUqGETOP/tnKo7LAqgyPnAZ86?=
 =?us-ascii?Q?Evukt1YLLGqhWC9r7V7i+mv4n/P7mgmDR9Jk1VLcWKqTWA7TOBQHOcEGIUkP?=
 =?us-ascii?Q?ABm1MrZhjL02MNgERX18/btiG1nGe6WpG4Hb/+zY3+a16GI9j88p3JSFcs5x?=
 =?us-ascii?Q?MYdMUgaDQElzTqvfLZRqq8dtaxudsmCkpMPccM85x3bsyKBzyUhOP5MgnZ7/?=
 =?us-ascii?Q?qkaCt9tFdWlBIzyV6B0DN/8vtjiFBwpFdpR4rj0IU8zBuus0sVu51D/E4eGn?=
 =?us-ascii?Q?ljmwG46lyuzyj3hbjrpiJxL9cB+tZiZKndr5GDKLeOr5sV1FGNUfePKzE7Zb?=
 =?us-ascii?Q?3cLL2zqzvs68vmMFuSwXCjEGF0hiTUqmUeAceR2buVQ29OrYUgQL5hgOPrjd?=
 =?us-ascii?Q?gQnhr0AOdQyUVu+ZxlHmB9rtkkghCCZvOqN+HZQ5L5Qfu1tumWUtGXKur+We?=
 =?us-ascii?Q?/kQfOlcujaDorNtRdjDJ57GxX1e5QaE153VWR9tbzgD3JE9w4nww7MTRGrth?=
 =?us-ascii?Q?mSwRkuN2D6gN6680FZRM0Px/D0U8S1b+pXvjU36m3/F7jAHDOiewSiudjzHu?=
 =?us-ascii?Q?2kmF/NEChDPlDSFg2JjWnmtwXC4I2NBznXKXqG09yDjvXfhsuspBJRQA5AXn?=
 =?us-ascii?Q?biEbStPOeCzR5Cmb9xR7X17C9fQEW3gmKHacB9XA1q9yijtgrp3HSRHGuDWl?=
 =?us-ascii?Q?C8M7HjTVWQR8WM/jbVCBXk7zyCwt3eX/Ij0h6a/HZhYTBUCfUWznODflv9lg?=
 =?us-ascii?Q?UyMH4VvEt9Ic7Ks70kksherMhreAowx2RXIO+QQfJcDbFi90lmLWQnUx5vZM?=
 =?us-ascii?Q?dmzU90pOXc8Mjtz2U3x5Ed8urI5Ni3+MqGIBprHYtdNtEDAXVR+dp3tWVhl0?=
 =?us-ascii?Q?URpCAcBafVezXDC9KtVY3LizG/14x+HYNs6/KqUA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c58a87-391d-4ca5-0a89-08db08168933
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 07:48:28.8589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPSgdGbBaHcZDUXMyU+Av5M6xE1fuCzjJ6iTymGC1b4edw5OZwM9c0xmYlltTHFtDUBV871cdAahWmlacV+qeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert vhost to use the new vm_account structure and associated
account_pinned_vm() functions. This means vhost will start enforcing
RLIMIT_MEMLOCK when a user does not have CAP_IPC_LOCK and fail the
mapping request.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/vhost/vdpa.c  | 17 ++++++++++-------
 drivers/vhost/vhost.c |  2 ++
 drivers/vhost/vhost.h |  2 ++
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f78..d970fcc 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -716,7 +716,7 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 				set_page_dirty_lock(page);
 			unpin_user_page(page);
 		}
-		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
+		vm_unaccount_pinned(&dev->vm_account, PFN_DOWN(map->size));
 		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
@@ -780,10 +780,14 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
+	if (!vdpa->use_va)
+		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
+			return -ENOMEM;
+
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
-		return r;
+		goto out_unaccount;
 
 	if (ops->dma_map) {
 		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
@@ -794,15 +798,14 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 	}
-	if (r) {
+	if (r)
 		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
-		return r;
-	}
 
+out_unaccount:
 	if (!vdpa->use_va)
-		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
+		vm_unaccount_pinned(&dev->vm_account, PFN_DOWN(size));
 
-	return 0;
+	return r;
 }
 
 static void vhost_vdpa_unmap(struct vhost_vdpa *v,
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cbe72bf..5645c26 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -556,6 +556,7 @@ static void vhost_attach_mm(struct vhost_dev *dev)
 		dev->mm = current->mm;
 		mmgrab(dev->mm);
 	}
+	vm_account_init_current(&dev->vm_account);
 }
 
 static void vhost_detach_mm(struct vhost_dev *dev)
@@ -569,6 +570,7 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 		mmdrop(dev->mm);
 
 	dev->mm = NULL;
+	vm_account_release(&dev->vm_account);
 }
 
 /* Caller should have device mutex */
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d910910..b2434dd 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -14,6 +14,7 @@
 #include <linux/atomic.h>
 #include <linux/vhost_iotlb.h>
 #include <linux/irqbypass.h>
+#include <linux/vm_account.h>
 
 struct vhost_work;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
@@ -144,6 +145,7 @@ struct vhost_msg_node {
 struct vhost_dev {
 	struct mm_struct *mm;
 	struct mutex mutex;
+	struct vm_account vm_account;
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-- 
git-series 0.9.1
