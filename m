Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4599E678809
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjAWUgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjAWUgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:14 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E4B2CC51;
        Mon, 23 Jan 2023 12:36:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaddsUWoCzgm9/1ydW1qiYBCIHgalYC8v1HyuJs/ITDb7wR9/VMpz1uxe57NRxGznr9Alp+cJACpdbWa0d1TdYrn157VLQ0Ky2QULO2+yS4nPJpaThh6x+yWHTRGR7yhGfW1jtwlhWiUxfxo3EC8QeZTPIS2ltsw/pM6/tkNCVqipZYowCMoRX0q/adBgUKtOU8wCnOyDxoBmP3hFiZ4wh8sxSOYc8jKmCMx4KGaLxJt7ORYgpG50ZbDYG2jWlevlDIIs3Aoj3HLhRDgTfT9sBewJKec+vq5ZWEPPD/ZwPn10XvohkhYhXY+/CwKeW8JyQ17aNqBhzCUP7qaUtNHMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4QVpbt7q7oswyKwpZnjizgh0f/c7LkLOTBKv4E1NBc=;
 b=JxMuhm5oFyl0HzWf1xQ/yNpOSiiWdELOf40Ls6TIiC0xLWLHsTSTcqjVEz/bJi9aXkWsOnEmL1qdUuTwCFqzZd3H+v6//hH/E03wx8MCJLAhfJw2HXszVeLl5+RzBLWQ6AdR1TTAPAvgQk06rxcOtgL6btsp5Pw/hCTygWYd76kNdtr/BZBd/pxF458XCja4k0Kkh2AJ9r/3mKH/NFr/k8im4YnQp72hPHM7qHoY5XhMzxqCkbUUDSV4zhhRyIOV3+zeEzEdbGVfJtG5dq0B8k+VS0VuWa8CCu9Xd/OoXkZRdQlNRkKrZIimVm4gjK85veWOgwXe5nbDx9Ll06stcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4QVpbt7q7oswyKwpZnjizgh0f/c7LkLOTBKv4E1NBc=;
 b=bcQuUzjHR2TWOulVpuPmZwZ61VI+A31a75n0HzTb9b9q6fjUK1rGAaBiLl+VIK1SQ5Fw5/rG0kFcMe8LG/cRBFGlkuVbncXdinMSM2EqeeFgEvQBNajlh8S4WO7FPzTKmlsePZOvjPfXClntA8ycaIz6FqrUUn02S4CYSe0+pC9JcVsVCR9D6N9hjiwW0kI5kMm7I/uFPKfz8qQ83F5X5dzkNoAJG60yCPUCyGczBNsTwqYGu6WkNp6v1KNhTHQqFqHC73OqMT2C//wmtKG+QUF87ScT3Y2xQwKJibMSeBsAXovVdcvRUnoozqfNZSL14uaQD0J+PaXKUtJUjQuQ8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6571.namprd12.prod.outlook.com (2603:10b6:208:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Mon, 23 Jan
 2023 20:36:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:36:04 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 04/10] iommu/dma: Use the gfp parameter in __iommu_dma_alloc_noncontiguous()
Date:   Mon, 23 Jan 2023 16:35:57 -0400
Message-Id: <4-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0173.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf1246c-1cbe-4a82-852f-08dafd81729a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmW3oE7Z1eRHiQQOwzKHNb1sUJigoFwoyT6aypYaHlUypsY/a6gdWzfqRo/QreuOeFdbCq0snvAQPvDPeqaQPbAlTp+BnRaMV0+urpwXVKU4fwZ0heuxdt+bbJ+8E0PJowEnHjvQNr7vleH1ermAXTINsGaba1/CgIbKA/Rgi7qsTEWcNTrkRZ5ud3r0a1MHIxHzo0HPU8Prdkbncr2nt/RoIF6KD1Xkyu7p1LWC5M19wauAFMGBTDqeLOIPelV8/7TjusJrtBGQt3/OQY5YXKI8n+NnaEybbyAVrNgey07NB1X/qVmz0QdiV/mPrj4dL1xh9j+Ddjpxc0B+dyKDOlYsZUek+DrlBW+gyt6fr3ZelWOWTrZwmp5NyZFR/LAnRzfljHT9En2P0cfJcbDreB6tJJunWTM/elbpBNGJtNFyAQJNLFib4PorRY0iae0SlsD3wZ23n7m+btoIQi50BBrWjLdL+W2rs40w6ywOfiTxhzcU7cmnDe2RxE7fyyWYeD44s/iqvx2a7f8PHJIbz/zaQO0FOfuwPu5yhLEFoXaY19d70cbbkhuI5pZy6KV+CLfWR52/GIldFck1xTxU/4HcLEhxNWBaOqBAWk+fgs5ki7EkjLWLxqYe1d4raz/u6He8FNrfdsg3I68AcfIWhU60I5dRBPOtWxizpcoKqyAsMatQWjXZGJGCgP81LY2W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cEJjMZfzcOSxiRcHttCg1D0pDWE+Kw4Drut4d3yHcxHXJwz+UIRAr8JxliVD?=
 =?us-ascii?Q?cLlE8wWdkNhXyfoQI8C8FntmHr5T/MT2U77qW2kZhJ3HwrH8UvtYkEqQ/rvi?=
 =?us-ascii?Q?w5vBAqNIpXJxzZpeqywprmObyGgbIiYLK8TWIu9pLvtfzsrNDIUdXwqEXHYM?=
 =?us-ascii?Q?V0LdXZgx7T+cs3JeDCdm3OGmVTkT5lypSOAkL7S88BpcMcjeyTe7V/pRr+dK?=
 =?us-ascii?Q?tjaHs3hS8eMb8O9PqJW4CDsCyozVNKJXoKMuluyEZp6PQveWXK3HA4xyAEUO?=
 =?us-ascii?Q?TscfK6sX6xa+GQP4xMjgNex9MDVl05+KYoGswwdZYaXSyUMe+1Rru7f3wC32?=
 =?us-ascii?Q?+fD9+n/GoP0KPcKL4rAdBCL6WXnawx7v/1RqcbKUhiM/aZpsrTcODmLOYFT2?=
 =?us-ascii?Q?uav2jNNh+mCOWG2igtoeHvRLriPYvQ/rk6CU1jbqxjOPK9YpslJDWCdRalbC?=
 =?us-ascii?Q?H3W9ew6R6fC/2E/lRgmaUK4SFLgat4I+ICr+HK5O3lrkNjdF6FB8kZxfhEYn?=
 =?us-ascii?Q?ze4+va5jQdrPOBY329baqN9+JLF9xxcf3vp7QrRnhTyl8WmRJvVgetArkBT0?=
 =?us-ascii?Q?JLC8V30tkyMnnMWp+c2XNQHxkoVwd+oHVXJiFhKNe28GaGtHoeHwZibH1S9Q?=
 =?us-ascii?Q?/qf8LfvDz49UJJRYGgMiKmFvlhuDy+Y1WOOh+KDkgt49GzXCnR3J7sPaxo/D?=
 =?us-ascii?Q?1MIJ/uDvd//cP2TqyDAXwBknC+3OrnuUQnQ6sLiJjQ7mae/ENt9YKg2HSX0Z?=
 =?us-ascii?Q?0QWRdOuhy3CA0IWs+Dh6kbudMthJwH4w99VuCw/a8h8De+pLstM9mNw+hVrZ?=
 =?us-ascii?Q?fcSmwA4q19p7LozzjIJd6sZdyqzU6bqHkqWwEv424JZzAEcY35AEBrCVkFRm?=
 =?us-ascii?Q?KGzDIKw+/x+WdxZ8EGRrv+ESF+SFE1KeH77qLAA7QEdhue65oUBT4IxAOCxh?=
 =?us-ascii?Q?HkpjEAlVO6VjbFKMFzTUXH79kA810kID4sddz3+nDu0lOCVVgpjazOrvEcnH?=
 =?us-ascii?Q?fyXMkWdAzZ3tbCJpUndCjY/YLhRs9wuRX8ZxythKCeQLEJtoCtruTR65grhK?=
 =?us-ascii?Q?cgj/RJUpXbkMEfZpq2C+vZuH4gI21EW0HNNB4iBVCu8pi91VuUBQ9i+tiYGu?=
 =?us-ascii?Q?ijwyw6ukdEaveEGxPxc9W2LYYKvAirUG0w0vPJYqwtAOLC8nBgeaSZpnB5LX?=
 =?us-ascii?Q?YPR5aPMDg1YRfXxM63Vm7kAT+S+xYdCWQb/3ds/yoH+jBYrRfToL4FzwPx6i?=
 =?us-ascii?Q?fDXgXhM5IBFap1Pzro7DrYiC7y9Q5uxuNfLDs6Acw88RbZnrbn+yfPOhnXWv?=
 =?us-ascii?Q?+2fffC9VOmga20jGUq7Sqdk2KOjEcHxknVEjT6DEG7CfUZ0rt0Bl2ArrP69O?=
 =?us-ascii?Q?bZPfno0KxJd2HL5z3qBEgHDRCGxuvIY2S5Yr9KlSHV5vb5sRbtuzhchfsV73?=
 =?us-ascii?Q?XUPoIRQFxjq0D0eSBBJHZDO1Vb1Te6jRPF+MVgawqQLTSRU0yoz3WG0r56VZ?=
 =?us-ascii?Q?LAaNBtKucnVIvfgsEzGl6RgsTUUqTVaFPLeGNEOoJj3iA6yjWK57NUC2eRj2?=
 =?us-ascii?Q?JLrq6uoCCunAW+yDfhgaw3Zxzaa6jPihCXsMHTv/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf1246c-1cbe-4a82-852f-08dafd81729a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:04.3090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fvE1MQyzDEKDl0nU0SwBUUq+NIL4nOoSFDIAxz9Kh7Q43tua747ln4DGjiyt2uC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6571
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function does an allocation of a buffer to return to the caller and
then goes on to allocate some internal memory, eg the scatterlist and
IOPTEs.

Instead of hard wiring GFP_KERNEL and a wrong GFP_ATOMIC, continue to use
the passed in gfp flags for all of the allocations. Clear the zone and
policy bits that are only relevant for the buffer allocation before
re-using them for internal allocations.

Auditing says this is never called from an atomic context, so the
GFP_ATOMIC is the incorrect flag.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 72cfa24503b8bc..c99e4bc55d8cb0 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -822,7 +822,14 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 	if (!iova)
 		goto out_free_pages;
 
-	if (sg_alloc_table_from_pages(sgt, pages, count, 0, size, GFP_KERNEL))
+	/*
+	 * Remove the zone/policy flags from the GFP - these are applied to the
+	 * __iommu_dma_alloc_pages() but are not used for the supporting
+	 * internal allocations that follow.
+	 */
+	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM | __GFP_COMP);
+
+	if (sg_alloc_table_from_pages(sgt, pages, count, 0, size, gfp))
 		goto out_free_iova;
 
 	if (!(ioprot & IOMMU_CACHE)) {
@@ -834,7 +841,7 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 	}
 
 	ret = iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, ioprot,
-			   GFP_ATOMIC);
+			   gfp);
 	if (ret < 0 || ret < size)
 		goto out_free_sg;
 
-- 
2.39.0

