Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C87D67901A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjAXFoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjAXFn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:43:57 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7293B646;
        Mon, 23 Jan 2023 21:43:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eR0otRmxxyF77ANJ8b50GBHj4vsyT2NfjQPtSoyqrbkZ+M5wQBtlave1j7dhgN/HrUC4m50PVqA6ImAEMpCSbLpZWomXGlUgBhALdLrinnoQ4vy2807/ySYuUkMXJ7Bftsd9i0D+UsKdG4IhsMlUkR+qFa3vI4Z3JWeLB++xRDRgVowxbA0OmrlPW2E6iP5agD6rQ56npJ7hiZtN0hIAoxdHMjjoToYpSI6ZlkdOrL0fSwGF2++A31F7qPVgVHk5vhJZEONw/Nr4BhOYQALzmItBx8fEx6ryFI1TR9Fw9YjLm0mX1KWb2M+w7YP22Fb+lVeg168c9YaQQ1yzg5tjSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcDnfPrIlRs7Mnv0oLLyOKfuvKifWQZHkSFcnl2A/vA=;
 b=CllDKvmaGNEnyqbA7IIvt28n1iIzVMu5iyQ8bk9jpJ6kARDQOMc84ojnIEdMQGKZ3FfrwXdpCawH3ACxC/o+B4R/gIzdjQR2N5SH9kXwnmd9SOhH5RIU2n9HHfxko5WVohB5Yk3hdMINz11e4RiYnMW2ShcyNKCtjEaSyyJiO1lZnYR27Y5O8kcdZqH4eNRj4tWzCwL/MFp/K/gSLeR5dj2UzEh/jlffhgEa9kpolg6VJhkUHFj5kzVotm405cpZHyoGBg07nN9/bjhY0M/svzam8jxF16CrJ/1Nu5XUzZoDjlRsMYmzXwndp9RwBbzMMZhpY+Em5rhAju3JNc2G8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcDnfPrIlRs7Mnv0oLLyOKfuvKifWQZHkSFcnl2A/vA=;
 b=tLe7CFrSVMWCB8G+nqyccZlJhPmT7dbtlKjpnf3yvgmdXD80GCPvMd/lAxTfZ01VmOzASeYDf+MSRjcmEAGoc1pQNozCLV0YPuQMbLKXn5QIQhGW9U5JMRfuYTWMub1KG+OBPcAFxWnAo9bKNhh029BZSLqrG6XbmENAa1wd7XDUp1+0oKRgD/AJuWxUmOSTsdaxFrr9dyIOoSR69ufqmF9fbi7Zas0Z2DVtqXVXtm08IIhBr1bwc567WSPtNb+osXjZmDStJ6Zx+bnK/zsU9UWANFfO4DKiSbl0boO3DYaUy5AcJRvSMqY8ThT9xLLZSxd0u4D70UCKcwa1e5Hk+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MW3PR12MB4540.namprd12.prod.outlook.com (2603:10b6:303:52::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 05:43:49 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 05:43:49 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        Alistair Popple <apopple@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [RFC PATCH 02/19] drivers/vhost: Convert to use vm_account
Date:   Tue, 24 Jan 2023 16:42:31 +1100
Message-Id: <97a17a6ab7e59be4287a2a94d43bb787300476b4.1674538665.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYBPR01CA0182.ausprd01.prod.outlook.com
 (2603:10c6:10:52::26) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MW3PR12MB4540:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a85e3d-854d-43c7-cc27-08dafdcdf7c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: abJUjNf4awkT41lafLH+TcN3QopmZ25FPGbBkLfPop7ZB/4n6xB87F5+iUBoBFW8OrANSx0ohukUYsTbDavg9Tduk/7nSAAf3y5F8Z9B/ts7WBCsRe1oyEnJQ/H1thr7ZerdRyXN07Ex847UQUmsCpdIVMLtGDZcvTmZ6TwocH/EKxnybyrCWpe/xEN2VNJjL7E7VeGSIQ1M5treCLZnOEKoqhlNlZ49ocpFkT1A4LldUEuLoBt7eEz6oQByZVGsuSrm1HzQoFwMVMa4E6tTUQ8H8yPhiUVwDliFBss3iQI5EHGXUwT8ndcnCfPZeAgsCu5Nz3i30NpZiAZI8cDUbBzpb2Y0Qllxz7FhrjR5Q6GK3lJwBannxRcQCLJYcXl/u2t5gjO052OhSvf7b+aiLF4rNIVaRM+6+TlMyALsKPmdxGvVMoDzRxOAk+DnZeoE+TOd0oUSzh2b1BhpVc6kaiMxmugeEGy7sw+8xVWN4bfVHmcwD1y6N/GIzSEztYCSfrTd4DU+aprpkXAIE2m7gMzblFu0su80dIg9DU2nZ4LEnIFR9sY4aRWpErXxQKSkwgBW7Xo7GMW341rXbq06DxDTT4UUk7PV5iW1ZpP5sRgdNMGlffwrBk64N8472KaYe8iTJdiLCngfAi+dZzEaYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199015)(36756003)(86362001)(5660300002)(38100700002)(2906002)(4326008)(8936002)(7416002)(83380400001)(41300700001)(66476007)(478600001)(6486002)(66556008)(6506007)(6512007)(8676002)(26005)(186003)(316002)(66946007)(2616005)(54906003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4BM9nFVTTns4uRS+6HT2HmzGTbfRAHJVsVuI86uynpag9i5ELdLIPavTroPC?=
 =?us-ascii?Q?X6TFDa0Kb092p1Qy9Sv8WyuE6rTacn+Grv7TJ1TJSkbaBkJ8OsOmKiTFSM1P?=
 =?us-ascii?Q?r1JL5XBfWNziY52Q3zp5vo3yIbgLOwC4Sl8TJxdUP1ZG1zWjizqvW8LagcaZ?=
 =?us-ascii?Q?UW3kfCTG3YsGt9OY6Uo4wYreMlTzZR7MAkCpUYis4V6wDEsrQ++Yfc+FhKuB?=
 =?us-ascii?Q?T1Y2vXJOwNc5AC+PIStbdST/gfbIBK8h8dlMLL9TKHwbHLVKbI846uixfemP?=
 =?us-ascii?Q?XDLIxdDVzNggiJE3BacPCz34XCXH0lwGzFZWN9JPu+GaUqZSEZvffpjLukut?=
 =?us-ascii?Q?hwA8sC/f3eXkdUkUVesS9AZyczKUkssJPb3TE/I7rpOEsCRRFfbORd3oBiyg?=
 =?us-ascii?Q?PALNaQc6QT9HAqN7oUS0rhCdj3FP1RkWXUAux+wJpAmcGmQ0wQh0TTtSEfwx?=
 =?us-ascii?Q?1CWDD5tUb3ads41sf3nyD3jsMlpgNFIhnfrskSf4wFwzaLvRL7ykj6AtmEqD?=
 =?us-ascii?Q?IJj2C/1ijLtUxooZdjFfHrcWBxI7KHRAjAc+5sZymo5657ySdGlRogv7+DDc?=
 =?us-ascii?Q?+AmJYm4BElyONppJa7/2n464DQ+WviGT9B8Cx1/o0TAkrNiGBkqP/LtY0ZwZ?=
 =?us-ascii?Q?yCvBshj/fzeIa846zEYSzt4My9wY6c1ZgSvdShElEovnV5tmgiknXweiRQTR?=
 =?us-ascii?Q?1QwB16aw92nCG/jsiMddsP/vvoxg20XExbNPpcOnOrLivl/1n0jEu4O6rHaX?=
 =?us-ascii?Q?7ueueZE1HHRcd72Mj+yyJdIj68zZ29ze9e8jfsQ/hR8fnPIoV0CDIxRCnsHO?=
 =?us-ascii?Q?y0mCCdt3Cai4d52EDjSPyB/Nifhuqsy54D1UlF41RdUAienT8K3mtEdOVZTU?=
 =?us-ascii?Q?dWA1mJvS/+7xRCBh081u1Tpcb2WbLbSqvTHjLynMxIT9MHdXu32jpxtV9pbl?=
 =?us-ascii?Q?DHORTLqNh25IjjRVGsE1/QOW1/SCpg34UZgBwEQtQRD2EiTXHUom1fR9KGkp?=
 =?us-ascii?Q?+NeynVH7nv/0t+uO7T/iULf/9iX8w9mILUPxnXFarCgwi2X7un7xMv3LA0co?=
 =?us-ascii?Q?Vq3610mpnBsE/hB/UnHFw+RsgW9AKZD4i29z4MYvE7+CvvtN71zyTCGIQZRd?=
 =?us-ascii?Q?5+IxuHCTpJdcQwRHj+0e2njpDYKugsxAyrj2LyMO1b6Pu2C0z+fISWLhKSoV?=
 =?us-ascii?Q?hYiZNjFpnALisbcq19GVJMk+M31iOaGcntqXigMlobdTDBBIShm7gnnCHsJc?=
 =?us-ascii?Q?5sx54K0my8gjH/39fPoR7bKG/ALu1tYv+WWr/+ApylqFxc8IfIZn9PTXPawn?=
 =?us-ascii?Q?c47SjdkOZN+tVQeGVdutvT2AF21rO6l27auVVYb+Du1tAOJ90TYkvkUforNA?=
 =?us-ascii?Q?IUsBT3QUjvf8hxJ19hExaaRT+lUx3Jq6p9lJU9m7RqOlnpNZfFB3PGCo0uT2?=
 =?us-ascii?Q?uaJhoyG7ed+KPoD68u8uT7x11jdR1zS9lgXAdL/RIHEcgb/dMkc/BMKM8ZoR?=
 =?us-ascii?Q?Ykm/mpZHIalV447dscCiQ0Rd/BFH7qe0B8ObzFHAoKRPIb6S3oi8So9A1zwB?=
 =?us-ascii?Q?kBvJvRJB4uPhKTmw9X3yOfhQzB6Q6B30aZPYKrKY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a85e3d-854d-43c7-cc27-08dafdcdf7c7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:43:49.6973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLlNevmybuGTYgjGjyYs1bJEs1xvf4XnkOdn9RSNGMI2+3s9LW8Hoccklmql4Rpu4y+wGEJl5QdOGw1CxjbMuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4540
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert vhost to use the new vm_account structure and associated
account_pinned_vm() functions.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/vhost/vdpa.c  |  9 +++++----
 drivers/vhost/vhost.c |  2 ++
 drivers/vhost/vhost.h |  1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f78..a31dd53 100644
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
@@ -780,6 +780,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
+	if (!vdpa->use_va)
+		if (vm_account_pinned(&dev->vm_account, PFN_DOWN(size)))
+			return -ENOMEM;
+
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
@@ -799,9 +803,6 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 	}
 
-	if (!vdpa->use_va)
-		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
-
 	return 0;
 }
 
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
index d910910..3a9aed8 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -144,6 +144,7 @@ struct vhost_msg_node {
 struct vhost_dev {
 	struct mm_struct *mm;
 	struct mutex mutex;
+	struct vm_account vm_account;
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-- 
git-series 0.9.1
