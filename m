Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8116725FA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjARSB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjARSAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:00:51 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC68552AA;
        Wed, 18 Jan 2023 10:00:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0wBWJ5PLq7u65SEgYt76cVl9XecEOjRo5m+JyAiD1lpJ/3L+nBQuTzGn0U5tehiqFbwP9WCK0VmPFnFTmmDg5taSBf6gZCqUT2ypCpNPEFo2mZJXn5IUT9wFsZrXYKxaDqH/ENe4ODpIzkPVxEz2tpl5qu72nxbeih170IWToqNSgokjHCG7wLXsgKW26WjryCMRlTr4UySgtOqCIi5fVYRSGIRurJjPqbSP2OMQa6rc9IvtuQO7Z9DlfxDFEkiOgbYzgn7FwCAZ91lYFq5NHKE6eT2ptjVAyUGXBZnElBFujZ7GKFtjrU3QRitK5yAU72EvoWW9rNcgwmNNJOnyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW/5mujLMwqrzVEZt7wBA4VSpYB7Lob2U3kTzSD4quE=;
 b=mYNdaHQSWoNrNpq41kqgmJvWo+v/BX19qun3XweTQCVUq6Yey1GpebsiBQgF+XsWmPNbbmOTtwjdSYIgQLP5O5VA62aW7SpMSLghstgnCFrzbTDb8lQ5Kec4Tu4HQkop2KnRBtR0oMUY7/zKJyhZ5TFaHnyKSZ8MmU2xfzxcUYXyGi4RC5wlO4B+jOeeyMkau3V7WHlMDkLRiJrxSKX5PGyaF4YqyqMo9/rLsuvKicP7freGhyYXtZQ3tm3/wf3tmrITZ0VI1/Qqe5JDmq7KAEe9j1rLiN27DxaGgMj4Q0MUDrQwq3gPQW24vnjQdkJxBDbKMkB6gnUSCaZY9zqV8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW/5mujLMwqrzVEZt7wBA4VSpYB7Lob2U3kTzSD4quE=;
 b=IIS52DBDnuzB6GfbVJQb6RssA1TqQPqIywi8Emj3mrgbbWu3HmLg0AUD0Mc2NfvgOraj9jEhtP9LPhE5F7+Rmwv2gV4yriBSTropqB1oaD68ZKFPLiHwyFWi9lPR8dpUfFRM48P2x4tSNlMg9BKsKVE/OSos08v10r2WqfRZcvQFKBGd10gDwJ5I08KtB2uNNOKJ+d4ojThvIAXkVVzj3pJqOM7Gt0M3UwAFyxe76jVH/CJIs10OWkJ4RIds8i5MueImrQp+uqgB6VebWZANxB39ZfmURxUY/1bF6g5bexdvKfYUVJ5JDhNLIpuC3sRl/ZozlvkM77tf/XJxB5E/nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 18:00:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:47 +0000
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
Subject: [PATCH v2 05/10] iommufd: Use GFP_KERNEL_ACCOUNT for iommu_map()
Date:   Wed, 18 Jan 2023 14:00:39 -0400
Message-Id: <5-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:208:329::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: 9212b8d5-7b00-4766-3780-08daf97dec20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VhnY/VkdROsKqYj8be1fIWvj9/wmVvhCi5RdHSgcpUI3D7RXN7E/NlHyCI4IaGMavrRy7WNjLTj4gS7AK2XG0R/FnDvs9WhATGQa2YU6LxeWUKoL/vynL7JTTWUEPke5n3QrZfj9mXGYB7CYAiwt6jZMdowB2EcXF1GOlqIV+id3nw+evxRw/4Is4gBEq2bYD5OzLylzWikOdoRCsiT5NT9G5UhHG0KjehYI5QfYYd02QF9nmv8zsgZ5H2OJJKEM/V23Mmv1BZJPm/nS3n3OjalJI/aG38hqnjo7hwicwEeKGZfQY2Sl0QD5TSjgk6/h96NV6u/QLvrmLOyibsCaN92lDNgwEl7F7g/vQenbUi2xQLiBSjXtDJnKV2u/cCd0NJMP0cxBdgIC3YQ7N+wQ5TEpr/6Hdfk52AJAS7fGT6CBnZamQY+dDJv0Y/nHq5uLPRkPmMKzzptv5vNcNiiXgVUyonODB8Pkri5ht3WirfMhkhyPzsqphLwayA6Uu/Qi/9otYtdar/FZ4x8ecZ2zQWHy/fLGbV/SnPDZgfSzXUaqhBYaExRf0GtnYKjvrWUJsRFb8isvnw2n9T+3jKBIsRVWLwDfLFbVi44RMFAMzjiQGd61VBXqVLT5/HFWkfTT64Jpcgb7BiXKvjr9pQc3k4qxDZV+x4B1hFprJb6GCj+6O0LceZKU5GfeuLfapTEk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(186003)(26005)(478600001)(6512007)(6486002)(6666004)(54906003)(316002)(110136005)(4326008)(66946007)(66556008)(8676002)(66476007)(36756003)(2616005)(41300700001)(8936002)(83380400001)(2906002)(7416002)(5660300002)(38100700002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pY8Du1khAX41fW7ZAX/0US/CVQES0iyKzWtL1OlGRvz/lbP0CTnlZRWNiQXa?=
 =?us-ascii?Q?8bCsNWsvg4HuoE4gwYaohFrBHl27vCZPqf18rHHjoZ/51VunMyNxuvsLGrZi?=
 =?us-ascii?Q?z7O6rgnWEX6ktfnjJ7sALrwaqubswcWivYkgxNxZmUZ2QF303uRk+R6LvuFE?=
 =?us-ascii?Q?kxv8zahtJ69IecGsJ5uYY5FYCbGhuUy8HeBf2m82qPSyYi14wgbzRVm+G7QR?=
 =?us-ascii?Q?5Fw00MSRrQh6ZDECg+Hh/5smYwKkEuqGnp1u6Bzmv6COEozCO+ChMiBtyp2U?=
 =?us-ascii?Q?NtasVwIWX4jrmA1rdOcnYxg6Tx6uSNuXHIJ1pk+U/PphREu1Gg3nXBlLoW1G?=
 =?us-ascii?Q?cI09T4lutzexhtHyh8WxMUCk1hl190kBJlVoLw6MEathdsepBdDlTrcc/NoU?=
 =?us-ascii?Q?ufAZtgSGufjqQMUQvyihv3qUwXQRj4GHzqH2XhFuCdrzj0GX16R6D4Tp6nLI?=
 =?us-ascii?Q?U33ZfmPlUJVu8yuCg+hMtq1AGNP768iTm64t+koJgPZGUx3E0q26P1tXe4x5?=
 =?us-ascii?Q?+zyacnfBXxl91eVrorT7Ki7aX6YS8mI2qnL9F+99JDBzCI3K43q0L+qkMDID?=
 =?us-ascii?Q?J0ed1qqSwnU8zEXQyT+GXr8Gdo6Dc3t0Tj2jTjBXhAcicKOXwfo6+4I9Df3C?=
 =?us-ascii?Q?+r97pE0wobeaeDnC8L1pOL2wPlmcVV5k5qggVqidDqZkYJvOW3qLf2WFNprc?=
 =?us-ascii?Q?h5e+2BvLvJAKuHVYBryQgoBZKViS5MrDbRhKmafsZJDYA41jaqSlvsXpH2L6?=
 =?us-ascii?Q?CiTCi4nP39cVY5FUrm/u1jmuicUozkHggXwDkbOR37e3tHQpQPTIrHuq6p/X?=
 =?us-ascii?Q?AQBaDBHK2Wo0FyuOZsjwIFOlIDbFKffGpWz77JpR8F+EQXohs4YTHB98gP04?=
 =?us-ascii?Q?knMn4gJNPFTS0tZFU4Rp3ZjewXavosr9aqpfYViV8HVWEl165CyQ/Hg/PVJK?=
 =?us-ascii?Q?QUjPqvCQZb3jjP7zp8gWLGkRrOE1XwsLpXNQF6dvKxwrW+hDi1XuDedAmr0M?=
 =?us-ascii?Q?Nri18AhibuLCh+9TkCiwERGobeTpxHmRqDG1IGd7knCmQoOHDOAPzuOQZo7w?=
 =?us-ascii?Q?np79dbAuuIDvp48ZBeSPcMdkpF3VFJ1o2JHxFKVRjaJulhVNwDXMiPQHnTMl?=
 =?us-ascii?Q?yAmi7D+V9Sc3ZUR8KqRSqOJNx8SeXx3lXftOfwjlhiwsRMWzsDMhlU2+p7OX?=
 =?us-ascii?Q?fOWjU0b2yY0UMKtqBxQNz0btHFx64y3vmijmjTlnVaSUXrggGCxnN3cBjcSS?=
 =?us-ascii?Q?o8Tf6pXa1v++GpmXSBKQhU9stZ4il6PShl57kw5uJfu7T/KMWgOY6Y57zTSe?=
 =?us-ascii?Q?UtpQuPrWWBAkIlsSRXZIeEO9M56GAyLYKN0ijk36RnLl8JaWJIcA1mKZYrAP?=
 =?us-ascii?Q?AD+7hRQ7YeCIJZ5VbIWCnFTcPNtU99KaSlgtsYzF7O9KByRA6pI+UQbZXCpS?=
 =?us-ascii?Q?LwRQdB2IDx9rfiX/QyihqxndRqbkj3eRl3FvICX4BD2N2NHBUdqthY8WeHKx?=
 =?us-ascii?Q?+JfTL9VpFFKerGKNcL8LCtPueI4JnikpeQCho4iw6MhcE1pOSWdP4Ip04cEf?=
 =?us-ascii?Q?+HcwU4Mw3JA2+lOXwHw53Jg7A8Z+TqBeD4+qawsL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9212b8d5-7b00-4766-3780-08daf97dec20
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:45.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55MBwQPcT8/1g4nIe30PL0YyKmHQHK4QDIV6WRiXYMhdJmqH/hRVQGW0CN50XO91
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7614
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iommufd follows the same design as KVM and uses memory cgroups to limit
the amount of kernel memory a iommufd file descriptor can pin down. The
various internal data structures already use GFP_KERNEL_ACCOUNT.

However, one of the biggest consumers of kernel memory is the IOPTEs
stored under the iommu_domain. Many drivers will allocate these at
iommu_map() time and will trivially do the right thing if we pass in
GFP_KERNEL_ACCOUNT.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/pages.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 22cc3bb0c6c55a..f8d92c9bb65b60 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -457,7 +457,7 @@ static int batch_iommu_map_small(struct iommu_domain *domain,
 
 	while (size) {
 		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot,
-			       GFP_KERNEL);
+			       GFP_KERNEL_ACCOUNT);
 		if (rc)
 			goto err_unmap;
 		iova += PAGE_SIZE;
@@ -502,7 +502,7 @@ static int batch_to_domain(struct pfn_batch *batch, struct iommu_domain *domain,
 			rc = iommu_map(domain, iova,
 				       PFN_PHYS(batch->pfns[cur]) + page_offset,
 				       next_iova - iova, area->iommu_prot,
-				       GFP_KERNEL);
+				       GFP_KERNEL_ACCOUNT);
 		if (rc)
 			goto err_unmap;
 		iova = next_iova;
-- 
2.39.0

