Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15881672611
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjARSBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjARSBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:01:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5161059B7D;
        Wed, 18 Jan 2023 10:00:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b13MVDYY7bbGHTUlgwSYceJVDjyUJZupY3pgMiyFK1TKbeP97ncYvK4CjK17HFBsq4KaaVh62JifSV4251Pz7A1fLGGbNhI38KukZDARp/DDMhT77K70Pnlg2JKYNrqoX+rBoy0LF+b0Pt/VBwLhhkvf+BG6Vx8CjHe2o2JZe9Rhvm53Oe5rYq3Jd7uO8tDdC2efjDaK3p7lnwFE0qNx63RK+UcdnSKhakPHCeiiP7ny7yMx1M2Yh0pkZju8prBzLenXvowWnZwIBkMbA0VPQHZN3dw9XatzJGRHFflTsdduMS9O8XR9vj1At02tSvBBFt59+hNk+sLlB4Ol6bxo0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXY/qk74Ck4Y66fZQMt4tpXzsyUT4nAbalQAysEmLhI=;
 b=XVW3okh659iMcvaJl7MDK/xeuemIwZYRHrKHnSvdRSwkGIwoxDc1WXt5wBjXxjs2I+6q5jS3IJMwKVERouraFf+bwXlRd3O/p+hXuZSWK8EnHyCGHOExF1tOi4Hih5Sp3Esd+fNgWJQvhk1UMlcroKct5vdjG7hk0gMyAiRQ1LykofOL//YCoQb8oe3j2xyzgnSXEnt40uRg0fKdFhEn983Ht7ZFUGSzpWdSHSuyQDO5Pt7fvScSDsWD3yPzO1qRk+Yib12j1wL/stt+jSDqCa38xot6M6Q4f73IKkFsLQ1HyxgQ2EfcZmjALJE4GYrhPM25eiYFee4M4Ik8RYfNtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXY/qk74Ck4Y66fZQMt4tpXzsyUT4nAbalQAysEmLhI=;
 b=TUwlS+NBxcX+vCPVtzaYrc76yJkjqdBbQSY2sOB0iH4VncYJ3qbdw3nDXPjsTAP+hF8M0F2stGmSewFk7wvvbLnoyQ/bBe7mizH/RuIRWjMuzflT3uETdWHsQRDT3DMIETOxgdOl4ANZPhCNZ+2OgWRPed7nStgWCaUCq79fWqQQfQ1cHQZQZ7oajjCHdcmkdNGowVmby7/TZBnaEJK1FquDHTfb1obO4naPZ6L5+2LHtRfVuL2Go3H2wb4bs+iq5DEFi0AhfSvu7qbYuuF7ElqAuSWCh3fue1K7JLF1hUgfpT2+++Dk2RhbcKVcdV166GL8qvbDzC7qLimi1G1KGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 18:00:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:50 +0000
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
Subject: [PATCH v2 00/10] Let iommufd charge IOPTE allocations to the memory cgroup
Date:   Wed, 18 Jan 2023 14:00:34 -0400
Message-Id: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb5a4b7-172b-4677-f89a-08daf97decb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhP7/JH5PJMpBi3jgPqbwyjejs4hvrmKK3Fk6bDqtC2i7rBV+4IQBRJx+2tGiPJEZUcTGIvh/bMCVkamjb5TS9IVBlzpLrzJ593r7yfa90hVEppx7DOER0DiIezgs4MmqJ6/GxrmxPRMSvMq1d4SumkMCK1Np58pIzthcP/NMBilOBde7K7Sfwvg1nA3+ijAB5p1rPoqnnsRfRmMmAylIEW5vDlMNnu4+rr2ZfrM6xI3RFGTvGb2ITuZBJQ4UyVOlcDCnU2fzKU+Pp7KJynLVEUPPM54k8TrUeiMmfoNnigk0KINY9N5qw97RxM0/2L7QHqkzPGt+UPt/aqa/ZMuQmH63F3z+e0CAc2qxSJEj5Tz5eaeNphusUpeVCmymolXnxpZ1A+zV8pvRPaVdfnS/hUC+rS1dk9U/Ifv4NdqDM4Cn0escktZRxgYe3FSw/St3BqYMhpag+ezcNs5ETtm4hHmGAIe8ZSSzXt2k4+W8/i8l09qvT+BKBEfamuQQRfZhUThBRVYFIl5XOPo0gKZm7TP47UqCjut5ON3TRM4EL7INixslVkOOH5K/WsmR0o8MldEvshCrn8tN3wxdILDYw8siHxfBhCtdwAvQUqNnzJk65LaSYYqwOikLkbr7kCWArLHlWt3AqJrvq0LHxqwo1CMZqNcZlC4lce4dmg5qldFxeANL/sQeLd+4UPbUeOs0ocEuQv7M9TKxO+Sl27+dP1pjtwAqiJKK7Ec0mLnMytJWoTDHpdWHFE0r2TDVL5/KbMjibdTrYvjMnE1drY0Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(8676002)(36756003)(83380400001)(41300700001)(8936002)(2906002)(66476007)(2616005)(110136005)(54906003)(4326008)(316002)(5660300002)(38100700002)(86362001)(66556008)(7416002)(186003)(6486002)(966005)(6512007)(478600001)(26005)(66946007)(6666004)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0+ipP0cNJR2O6QiA4qAaCOd1JJtpo+Q3j+cwqjBTF2x0XiedG6mwWY8m4syw?=
 =?us-ascii?Q?VqaPUfT3771B6PHVF3pa4eUCY5aAISihxLoMpnwqIMgDZK6nZyBfv+QZNpIz?=
 =?us-ascii?Q?jdNsMszjfxcyZgs4zplJWVfeQ/kXpRLKQagSE9WpfES6s1w2ucjznFkX6/Ph?=
 =?us-ascii?Q?NGs/1ugsrZOon702kvPlS1jDKPzetVhrNFGvM3Mz5h+MT+ZJzceQAuPvDcys?=
 =?us-ascii?Q?x3F//F8LMt59t4A3M81KNIjgMxzv4re1HxH9rfZI4KSFAH/NzmTflXiv1wYp?=
 =?us-ascii?Q?2Ngl9cfzjveo5PSWh5A2PuXrceSar6J+Adl0qBitNs8IJPhx4iuVB4h7P6o8?=
 =?us-ascii?Q?60xV2l2MvD0ysfhVSTJUtrvmw8QKEdFoM/YpscVsICLB1PytaLGuIIQrL8eu?=
 =?us-ascii?Q?TfyBXcHEoFXN+aJYopewsFT43KXNYSamP2cjLT8Q7K9lPZO8+7EbYhX4AwK9?=
 =?us-ascii?Q?PCmpxzKSOt0YQYAzQimzrDvpZzM+FlCdciwyQWPqhAOzrKuMW3cniTOfFTkk?=
 =?us-ascii?Q?+fZt34Jac5t5ydnk9Zx8AsttfjQq6V/kv9OOTnSsP9PMQj7YzZe13mjbOS3V?=
 =?us-ascii?Q?OoMw1RAFi9jq1KKDnAzjMk+ynL6L/OQdsV4ec0ZR70QpsF/PfW6EeY8SsiY+?=
 =?us-ascii?Q?D4IGOG/XT4ssA6eq5cxiA4J3r5CHDAeISote6SbiSeykopbkfuN56ZiAORBn?=
 =?us-ascii?Q?ZdztHdTZ00l3ilwF+4YZJFcA4hlIm/zlp0SN283dWAz4xtbcdGnK4mzXa/mm?=
 =?us-ascii?Q?fcg1VDdUQ65TfqynvCXCBuK7QQfwss15ToKItTK+3PMIBA7hfc4rAdKcNbZJ?=
 =?us-ascii?Q?RBa4h6kuEfePhIfC9TfOCkAUfU+b5bboiqLdk8yBsAB4hwLEE3EBO3OL5Hfu?=
 =?us-ascii?Q?gjeIjgrqz8jn1yPCaLVUAi9ijzUy6KEWpxCakHhyZJB5OLeNQ5HhB0OY4Ny6?=
 =?us-ascii?Q?201l7yta+8FvttgWSXSm2Ee/UsbIlM7Tbs1gn8WaNyA40GwkFO0A1zGUPMyN?=
 =?us-ascii?Q?bErVz4KdK0ktRnEN/1S6E6XRRIk5bE/av/cvCawQjyRu7BvrLXGKFQcagWvL?=
 =?us-ascii?Q?UJ60G3pebbKDX9g3Hu73QGD7EA17+A8tj0+XMH1mpijjGz+125mRn/iTEWnD?=
 =?us-ascii?Q?sJkgCFlbFDOGtpPKXlsu0wW3kryKng9mafn2sLdpfD+vM9ihZfKyKS7brGqU?=
 =?us-ascii?Q?rHT3yEfUauqdqtm7GB6rPBHhGZMvUhLznmjTIwXqNg590Imkr02G1GoVX+kN?=
 =?us-ascii?Q?MRRY4HcY+3osmGhrgI2Y6c+eT3kB7sezMngl+STL9qAXw9ZhDiysUc2et5nW?=
 =?us-ascii?Q?jVxlDPDUpc2yi74FuDwcXkWKb5/tc8p3mC1Rzmmbe0cb4ntUHf64R8lvp9TP?=
 =?us-ascii?Q?KRwcKM1ZGLQevf+yO+1Y7uldA3INxd5+8hdRh3CEScfKvxkQneEd3MKWvptF?=
 =?us-ascii?Q?y9h65bkhwPwE+KYNrV5qJZLgfuiGjRWN8lBQTdaLcuglmRlBsz7Bk/U/4hoB?=
 =?us-ascii?Q?dgtdwmLKSTne1sT/4M21wMFV2Ylqq2p1xyXRgAui5DAbVY5cXbiK6BmtzjJO?=
 =?us-ascii?Q?8OM+FY96VE55yFmFvVEUYUm6yt0RE1J2CDAFAjS7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb5a4b7-172b-4677-f89a-08daf97decb8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:46.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOJpGrHkqt8CsdlS6nmGOEHGfnMgfuRRM0eCoTW337GkTTyDQ89VkV1f0l1EeTO2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818
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
various internal data structures already use GFP_KERNEL_ACCOUNT to charge
its own memory.

However, one of the biggest consumers of kernel memory is the IOPTEs
stored under the iommu_domain and these allocations are not tracked.

This series is the first step in fixing it.

The iommu driver contract already includes a 'gfp' argument to the
map_pages op, allowing iommufd to specify GFP_KERNEL_ACCOUNT and then
having the driver allocate the IOPTE tables with that flag will capture a
significant amount of the allocations.

Update the iommu_map() API to pass in the GFP argument, and fix all call
sites. Replace iommu_map_atomic().

Audit the "enterprise" iommu drivers to make sure they do the right thing.
Intel and S390 ignore the GFP argument and always use GFP_ATOMIC. This is
problematic for iommufd anyhow, so fix it. AMD and ARM SMMUv2/3 are
already correct.

A follow up series will be needed to capture the allocations made when the
iommu_domain itself is allocated, which will complete the job.

v2:
 - Prohibit bad GFP flags in the iommu wrappers
 - Split out the new GFP_KERNEL usages into dedicated patches so it is
   easier to check. No code change after the full series
v1: https://lore.kernel.org/r/0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com

Jason Gunthorpe (10):
  iommu: Add a gfp parameter to iommu_map()
  iommu: Remove iommu_map_atomic()
  iommu: Add a gfp parameter to iommu_map_sg()
  iommu/dma: Use the gfp parameter in __iommu_dma_alloc_noncontiguous()
  iommufd: Use GFP_KERNEL_ACCOUNT for iommu_map()
  iommu/intel: Add a gfp parameter to alloc_pgtable_page()
  iommu/intel: Support the gfp argument to the map_pages op
  iommu/intel: Use GFP_KERNEL in sleepable contexts
  iommu/s390: Push the gfp parameter to the kmem_cache_alloc()'s
  iommu/s390: Use GFP_KERNEL in sleepable contexts

 arch/arm/mm/dma-mapping.c                     | 11 ++--
 arch/s390/include/asm/pci_dma.h               |  5 +-
 arch/s390/pci/pci_dma.c                       | 31 ++++++-----
 .../drm/nouveau/nvkm/subdev/instmem/gk20a.c   |  3 +-
 drivers/gpu/drm/tegra/drm.c                   |  2 +-
 drivers/gpu/host1x/cdma.c                     |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c      |  4 +-
 drivers/iommu/dma-iommu.c                     | 11 ++--
 drivers/iommu/intel/iommu.c                   | 36 +++++++------
 drivers/iommu/intel/iommu.h                   |  2 +-
 drivers/iommu/intel/pasid.c                   |  2 +-
 drivers/iommu/iommu.c                         | 53 +++++++------------
 drivers/iommu/iommufd/pages.c                 |  6 ++-
 drivers/iommu/s390-iommu.c                    | 15 +++---
 drivers/media/platform/qcom/venus/firmware.c  |  2 +-
 drivers/net/ipa/ipa_mem.c                     |  6 ++-
 drivers/net/wireless/ath/ath10k/snoc.c        |  2 +-
 drivers/net/wireless/ath/ath11k/ahb.c         |  4 +-
 drivers/remoteproc/remoteproc_core.c          |  5 +-
 drivers/vfio/vfio_iommu_type1.c               |  9 ++--
 drivers/vhost/vdpa.c                          |  2 +-
 include/linux/iommu.h                         | 31 +++--------
 22 files changed, 119 insertions(+), 125 deletions(-)


base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.0

