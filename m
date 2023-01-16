Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88EF66CEC3
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbjAPSZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjAPSZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:25:01 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C382B623;
        Mon, 16 Jan 2023 10:12:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/UFsE4V5qEKX9nrM3Fpp9lsN2qLBmN8tD/NG9PeD4cGYzEXv1QZSuYdVFE//4FHg1Ma6T493XFEtRpkTM4FqlWZbGPCrc/cFfLLwxrTpsm8lsqsvFQtLS4yyyafn+voFdFFcrG0TTMojV4pntd025SSnrLr7POBE4YrDa1OjhuZHbBa3+gGFn0+f38Lr8xkjk2JgNY0muxgYGNi6OVVVLgtHxwJ+rwUlfqWt4R5GL48KJ7Z7XHI5FQ1n1M8ni9pLs2w1p/GiIotRkuH9ZGvQWeop4vV5shMhfTnxwdP2AiB4x4gZ/nurtq0Lidgut0ef/41TY9EMaV9O3hnEfLh6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JukM/nUwbNRHihOph/niRlYy7rWrM+EGivCRaFHD5aY=;
 b=Y12J4+7KNZig5wXRTLQsekR1C7a7ZqAgeBNtWEVpqcVctVkpxoZtSjPW+ecBi53DohA0RBb+RCTb2917d19S8pETmpUF7v4H2J1r1XOWprT5Y7jCqvc4Ckv2km4Nhw2b+zEV2d3giSiExeLOv2/yNjnNJFCSncIWHBfaYExdt5QvVTSLzMM2LFFo1zXXXi7PYLRZGHhnfCWKXdr56hGiQSBtmXVgUkL1Ou2o2CMs+z0OWqkdJqGyQ7d+6x9Bm36tIlyZCFU+iTTGha23narqdjPCoh22MA6IOXGnajumQeBWlgun5uPNBLx2GAHUQco0Mh8AxDgA7HKoTta/Ipww0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JukM/nUwbNRHihOph/niRlYy7rWrM+EGivCRaFHD5aY=;
 b=lLUfFeJptDqLiyc5ppxVzU+amLhp9JlBmfd7Z3f4RIo1vZ33EKKlCx5fcG9Q9+hfk+SaZynmxNmQHCd5VKgtbCRDpOBKtWz4wBXZBaCDgZyO8m5k3ibIA/Z0PTrnifhDMtnvf5XL4qTK5y2+PnLnEm7Adib2B206h4Kq6ZL7Tm3xSp6oOscoaoU0aHhwTls5zwwjRUDRyrZKSdLpODmcW6Vm+14gICppJsHMxS1ioASUFhtRq/+Xz7B1P2fRFhNL1ZGkohOgn3hBTBhb7MwDPvUMHKTRNxKTDgI85ReVJtTTsVHYYKriBONbyBFKsNyRvwUjenU9O57q3oq0NGAVyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4926.namprd12.prod.outlook.com (2603:10b6:5:1bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 18:12:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 18:12:08 +0000
Date:   Mon, 16 Jan 2023 14:12:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH 1/8] iommu: Add a gfp parameter to iommu_map()
Message-ID: <Y8WTd/37G6lWA8c5@nvidia.com>
References: <1-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <4fd1b194-29ef-621d-4059-a8336058f217@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fd1b194-29ef-621d-4059-a8336058f217@arm.com>
X-ClientProxiedBy: MN2PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:208:23a::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ae353bf-8a49-4427-7886-08daf7ed2e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmqdVF6nmcepiFbzShVZrJtLnSMQtb5ZdL37qrVJuCEgC325K55hyxaaBgAeh1t0EuwOn2PZTw0fRVHCfjcGLtJKimxxGoDbIe6mAfVs2zTkRFuuOg0c3dIhgTem3blhJyHtVD3q4purpoMAkOlxNEDU+4KWrT2ZRgTBy7cCkZ9g5lLw0Miff9dah0hYz12zkDGOpQ8WfktTBTBzdIGX+Any+qP6d9u9ekNKJEsfZj92+BXKzqpr4PyfuE54C4K3z86b7KD695lmN+by7cCSVdVlnI/gyFiGDkI2LGcMGN/6aMAFivTpaFCzCAHpVNYS4XPn7m63dTNa7vqz5jC+dng5znQjMQ0N2E4+V5JVhIAKJWZAFKLFDD0j+hqXOa8N4DL1xrIFbhPBSf+fZkk6ErELg263Jrt2PHX9if7D0n8j8pw2mDhlcOhLd36lf+2TdsV5NiFBva1kPCfxSCyqCaS4NW/znjJgcT+uLe0FYupZe0EVCkxPdugrzZOkGVEj4UzhqM6AwMyeips9jtXF3sBdOAMWqhve+TQeIqZk+qyHd4hRWAv0AXxOh0u9XVSODNHMp15HVVmTPjS/DqTCtSV6MjE2KB4plAWjkUsgDLyyQA4UKeKAAMr01Um8NW1kUs2wFu/mMtGEc6eHsJKvvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199015)(83380400001)(38100700002)(86362001)(5660300002)(4326008)(2906002)(7416002)(6916009)(8936002)(8676002)(66946007)(66476007)(66556008)(41300700001)(2616005)(186003)(6506007)(26005)(6512007)(316002)(54906003)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iqLAhGaMK9tC+iiHkUjnDk7PDlkLuXKmkZmL4X7DdETvVwXCClv3dh9CD5IO?=
 =?us-ascii?Q?OAdmaSHpwHYUh0LqFdcZH0zowcypIlCdqTrsNNZMT96amSHGPJIYo5xPNRN4?=
 =?us-ascii?Q?pB5QFs6HiioMgaUjam5Jz4jMHxHoss0voiYpOTM764ifpZ84u06IJv7O9xCs?=
 =?us-ascii?Q?zn9mWOn9wdBmZWKi+CPZig8OGUaEf8b2aWbU12AL8cmdhKyl1Tu3m3MMyhu6?=
 =?us-ascii?Q?nl8W1qlu7VS6SXjO2+ouAewOW8VoLVfYCjnWysa16xezT8v094Ei0iP/pd2L?=
 =?us-ascii?Q?u/x878vo3gXupx2g0ne2hm73bHqMXDswuyuj3+6khPiIV63faNnY7o+QmW2c?=
 =?us-ascii?Q?ceRHUZaloaBGVxBGmTif6jj8zbevnBKIqPxyJWR6F/LwjdHd4MVeskByB8dY?=
 =?us-ascii?Q?u3HLzdWggMZtyKgMxZksTekSbTSv9ZwsGl+PDOlsby3lvHT8UQMYKnCObafs?=
 =?us-ascii?Q?kG7ZqYzCBLZzHK/003WYjhheXBMd0KVec2OVA7geCliPO4IjOONDhjsl/h55?=
 =?us-ascii?Q?UmBRczwl1vxBWtZb2AwR6AnCqfuI708NQFDoQyDeu5d0P1iVEMCTCB7xojTT?=
 =?us-ascii?Q?raRqbsx2fvSz2woUHEHQxMGskA4P1OeS5kC7QI1DI2qiyJxQmkAlgPF2qXGj?=
 =?us-ascii?Q?gAA7YWm3nPO3j/M6Wip/8Vyscy9NKq8WvnpDSnS5HQR6E3yonGrcEmZqvHJW?=
 =?us-ascii?Q?1MDtfnUmzQQ6tkvYPZYkNntQ4pXz7yr0feHriDuu3oe1Hv7D4Mu1xwycdAkd?=
 =?us-ascii?Q?IWvHBMntrbpKSZr/5L8Z14Trfau8Pv3twD0hshgTGmTs7jKRCxiGImkjujma?=
 =?us-ascii?Q?ZaXAHmcOtUeudgUTWkbY99n8k3qQJkKkFZi6s5a54t1Xb9TaPEiXbFpsz1Xe?=
 =?us-ascii?Q?iieKK2X3CatUTcllRyGScR+ZI4HlTSZQkxOMpHTTezSrSq5DozxmeHApoQjp?=
 =?us-ascii?Q?qtTl6P+u5iPvslVGtzY4jnjydvVC+Jdelcj/PdE0l8tJcwg3Ta+kY2FoitrJ?=
 =?us-ascii?Q?DFc3HfUaQwmoxr9elXLHpLlMyomu2WzcyBuOJdWkfVF4o3scP5dwPywqt65+?=
 =?us-ascii?Q?X98pH36r6lOrOxdOgu0nnT42YZfb7GY9+VPByVUMmqkBuraljtzBpLG3gKw9?=
 =?us-ascii?Q?XmelyLXaTD6j6vDX3juV8dPW9sknkm8XYbCA+VsJLG1jgAKsRjQ/E2uSALbw?=
 =?us-ascii?Q?6NMStnh2DJUVYOb004rlbeRhsLRmxyP/YlZPVnXZ0CazxNUjJniUkpl3ppv2?=
 =?us-ascii?Q?ycxOZw8ce+O6Zolyebv6OtadcG1tyfmsOeCJq9u3FFC/KcOkvHvLTFJQmh0T?=
 =?us-ascii?Q?nDrIgLqhZxaebgzsIyz79fxuWGfzg5cz1lRfJQLFFAZsbScijd7AL1/3CEbI?=
 =?us-ascii?Q?OZfkLHXbwDYoq+i/ISmZLiwZkaOp9i7Rg6c87wGgInyeIhoncTGnX0iFaXMR?=
 =?us-ascii?Q?T1OvHR8rBeIcCrvjtSQzH5QzVYvB/BfDOTE+1Cvnm6TzVfCn+YqicLfodwVL?=
 =?us-ascii?Q?YKZJiuXxQ4Y4PGN7jDpWCrLry4zDi32WkF9JWBX72aRs99Aemolr2W65lSFV?=
 =?us-ascii?Q?lLH7gpbO42lZbGwhxobDZrm93gHOuayDu0lh5hnC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae353bf-8a49-4427-7886-08daf7ed2e65
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 18:12:08.6557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFw+JuKwM3CCPS5ceNOeGkRx0q3WgfvLvvzHQWweGpEiQdpepnDQCDP7V2Q/rULz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4926
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 05:15:28PM +0000, Robin Murphy wrote:

> However, echoing the recent activity over on the DMA API side of things, I
> think it's still worth proactively constraining the set of permissible
> flags, lest we end up with more weird problems if stuff that doesn't really
> make sense, like GFP_COMP or zone flags, manages to leak through (that may
> have been part of the reason for having the current wrappers rather than a
> bare gfp argument in the first place, I forget now).

I did it like this:

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2368,6 +2368,11 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 
 	might_sleep_if(gfpflags_allow_blocking(gfp));
 
+	/* Discourage passing strange GFP flags */
+	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				__GFP_HIGHMEM)))
+		return -EINVAL;
+
 	ret = __iommu_map(domain, iova, paddr, size, prot, gfp);
 	if (ret == 0 && ops->iotlb_sync_map)
 		ops->iotlb_sync_map(domain, iova, size);
@@ -2477,6 +2482,11 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 
 	might_sleep_if(gfpflags_allow_blocking(gfp));
 
+	/* Discourage passing strange GFP flags */
+	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				__GFP_HIGHMEM)))
+		return -EINVAL;
+
 	while (i <= nents) {
 		phys_addr_t s_phys = sg_phys(sg);
 
Will post a v2 when the driver people take a look

Thanks,
Jason
