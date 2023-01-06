Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A11660504
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbjAFQpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjAFQna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:43:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7999C7CBD1;
        Fri,  6 Jan 2023 08:42:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLyxgUb6i9LfABmWgZ0wuokfuiJonuT6MqPAcsYwiDgGLprwR1KxmAqTyqfsaSCcOuCrWMmXEkpHBu+7SEbhJ3KB38sM8XwIfeoo89xe4FMCTDC9efn8DyTHr7uCaZKH/QkMy43l9MvFm5Cx93AewdfUajXX4OBBcR7XOF37RjM2FJsssAxJtmOxwk6JsqrKlCy035OQmbGn+eH3wc6qOT2FHDsflIDbJZADncbGpj+X66ebimXvv+2q2/QV3+jiDoutbEgh4Gl71xAk/J0Wg8kvw5OFVnYl53/Oi6Cj9VREVDSELRJnFJ1AxUSSvOJvU71teh0jwEw9dZrCnewqpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1oqx3oySm9rAzqJQwBK0SokBCkQT/v6l+Uh9b+rw4M=;
 b=OLiUgOElX7h033i7qb5U6jJ+22zBaQXXGNGiYnteXbOm0Nkt92J61Ql/DDF3l3NP8QHd6GKsUbxHAXRQ44DcMVh+ovKhOyiqmuMCK22JWbIN5T+F0tdYYAy1MbOjPex9lMtv3haTO0brsF4RW7XqPCMydE2lalP93+r+Jtoss12NFHc7oHl1tu5pkjeVTE8uOrzGyu//2uEgV5D+5CqOo2aoe/Nh7hnxVPXAczFW94pNlbZ7He1nBrbJzSJ5a2SjhSq7aYkmqkL3tT7yrE7JoRyN+ZHRDCL5RFCJVLQOCp712R/+4p4jTfb4RnBZkUFyd6Tg7MoNxbB86fwflQxMmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1oqx3oySm9rAzqJQwBK0SokBCkQT/v6l+Uh9b+rw4M=;
 b=sPtsNkUIxhFLdd+MLqtyx4kXkgncpSw2kYJhNMigGY1RkJvjNhY42Ea8Lnf+Chu7pcjK21ngTljatYXA/o6hdrJUWh9W9R/dooi7YsWZjDD4uwJxMEpbV2IvqEONQkQDuYJLRcXaNK6/exO5SqpXwenzFTymuMHgzZu5ToJInIQUVxs2ViNi6C188J94t3qEuHNE7HXO4oHsbpnB/eqioFAF+Nb3wGSQf7PFIXMaizvOqDX3PvinUA92j7aDYBgs7bUQ6H7ypoWR3EwBUdXuSp0yEGh+n0/n0jNLkeiLtYOCBhEqJqFenC2/85FQUkL58+X//SjMO9cku8kCb4kodQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6437.namprd12.prod.outlook.com (2603:10b6:8:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 16:42:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 16:42:49 +0000
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
Subject: [PATCH 0/8] Let iommufd charge IOPTE allocations to the memory cgroup
Date:   Fri,  6 Jan 2023 12:42:40 -0400
Message-Id: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:208:51::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: 1157bfb0-054e-4a1d-d179-08daf0050bb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mXBb7ogv9FbU6HBL295OqF16Kb6CekkcxXk7imSZpp686xXL2CGSPa/+nTp60sxRM37Gi3Jecn224fcPWGQ7IZoXicfHTQ28w8W3T+NU0ulm6SsOyj4GsgoUvEZ48NffBlI3Ze7I7AJ8CnFLpQFfhCLyO1cYeP47QdWVMiES+8k7kX0TNIhDmVTCXqe7J7mkIEeazA1R2PkLmBZChtnaS+VMWAK3zpT/2e8r/VbxpSjTf2g67K49G2LFzY0mVdEOQ7zStAxVE7/sKEASaEz95pvFo6CYW8xasduUBbpXx+fXUcpplTr/QrtzGXhKq64PAD6xlpX7UVEhiWXT9EIQhgphWy3zb13NoNzscIpWPK0wr3ziZx0Fk+cbQBxzvvHbvAfFJbHRhYN+njx/FFA1N076RknmK982jJ+rf7dMnNfLkDIJXKj2PzNsFcwq73I3fDR3WCZlfS3qNbxW3Wqp+nKRyqRvcoOcEk9jEJ+1kl/S+UTkHxCCoteU8xqvcg2x4lgg/9VxR3hfs8ivf7aAOiaLMWwKNmAHzKwM8dp9on/1VNO78c80Xn/AqMTue+NIB2hfVv2Xs0PnB+Zolm4ZAchC8K6gdftta9qgIin0iT3Q0dBMm1Zm4BMHBLNl5bDA01YkaEGr1MXCURVY8KJmsyOWYkMyu2AnBDWvIWIIWVi4gPXQueapZL8Cwe/vAgj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(7416002)(5660300002)(54906003)(2906002)(41300700001)(8676002)(66946007)(8936002)(66476007)(316002)(4326008)(66556008)(83380400001)(6666004)(478600001)(110136005)(6506007)(36756003)(186003)(2616005)(26005)(6512007)(6486002)(86362001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I6eNKkq7MyT/Xi8Ux+ovjqJQyHSQ4R8x7W/4F1QTVe8h9ncrVz2SZAUnkmzu?=
 =?us-ascii?Q?7kaMplOtwk84fWQoBg31yArQcieWgF6KkvnvCENRcn0/k/EEAa8dAk65ZLcJ?=
 =?us-ascii?Q?85F8YdkWZ+EG8R0qE6+tFNbi4HTrZOmZK9JzpPSESPL2huNvo3h4PC3jCc2F?=
 =?us-ascii?Q?J/8QWU03ewvscIeICwAd9mhHX+kRo/anuBnGnTdwPPtFfzSrHAb3pyoxu3Ac?=
 =?us-ascii?Q?KTdk8RQP0Ow9xMrkbY6wW9kPaeiWAnPLCgbfLzhkt2tZc6YLVLOUjkV2mdUF?=
 =?us-ascii?Q?zQziP6QoVk0/38a4oiJkovfkST0m9RiqTRbnLCMtSzBlKsuEXEhYsT1MsjA5?=
 =?us-ascii?Q?qa2T52YLL4Lm5Po5VFvDEtT5ew3XEMqGG424NBDyK6wwk90/qo5oqcwYwzTt?=
 =?us-ascii?Q?rTMLGWXOH5fZLcbf6SxiBvhYHC+MI86QLh+pcjNVxWCnYw2hSU6BwoxXmSc/?=
 =?us-ascii?Q?fple8fyQZzlavVYmBqFYzFvSzWq7MNmW4M2JtpjS3RDXCLyzdkaxnLGREYVS?=
 =?us-ascii?Q?OWE7D9325KzwtBWk+F8IchClQbXMuWKfEkiHz8wjWit09eJN+Mb0h3XmIifq?=
 =?us-ascii?Q?bS/428A3vMVskeUrzY2RUrlqNQZsc8nexe6hlc6uoK2EJ3GGsTFekVZhrGhz?=
 =?us-ascii?Q?PgDohfya5o/NcweAX0UQuPwBAPIMohj9zrtvp20UXOmhIwojUf3PC0AqxK2l?=
 =?us-ascii?Q?r7pgy9VMRdm/NSqIP9ffa7dWO5/WPKloF7oYi9ow+zTtyYG2H1JbnxxvVYkY?=
 =?us-ascii?Q?arvWpdk/1wnM5VitlWHkg8GM6KS50Lkx0F70TePtcJgVoamvurZLbwZ1o8l3?=
 =?us-ascii?Q?+CGrdOrL4nTcYAwIhLc1u1g3cSeZU5ozS8i72ewYOiYO9+a2aX8QXLnvIpsL?=
 =?us-ascii?Q?8VFnltvfIw5rueVRw2lLXVIfT2aKWMYqlOkHCo/KPQd8oyF9rNO7Us9cq8LK?=
 =?us-ascii?Q?wIdWI6KNosNQDNBWICa/dQJYZxqRKLFLSajkVXmLIUNlt3ZxQXWk7QySBWgf?=
 =?us-ascii?Q?PPJUK9Y02Jevx0ZpQhKNcI3AhOnQKPyu7JIi9l1FIIdoDk5t0zbwtj2MO7bZ?=
 =?us-ascii?Q?xjaDt6D5byLPw44vVQ79At1I7yBf2hDw4uriTBWNWuv6Iz6cJIijlQPl2m3Y?=
 =?us-ascii?Q?YiNA4pWgTMqOMyOZ1gl0Dm92vBVQMR39U89WYEOTDIligPqLYX/oZFjrhHVo?=
 =?us-ascii?Q?1sK/dghUFbDc8Bmbda7pCZMFaldOA9+j3FJ+Lnjc+itebh1jUutGa7U0xicQ?=
 =?us-ascii?Q?In6xRnEc3b03W1VF5Z8YEebU1rEm/CY98VNSGnbEHco08dpo4KW3xb+C8mTN?=
 =?us-ascii?Q?HE7lIxwyVL1LuqZ/uNt9iBsJNRdNFQmjo1F7bSHH56+/x1VE/mDU7QAnOpyc?=
 =?us-ascii?Q?Q64nB2tCdOoxpBBjsMmFOb3SI1lWx0kHfyHe0v0db+rjzZM5lPbyeWEaCl/w?=
 =?us-ascii?Q?buNCNoTEPJqyBgWJdMoPF5Jn+DPJkmj3Q3ZKG/O7MGmmQPYMyQXWLayDoyGW?=
 =?us-ascii?Q?Zt72tTIrkwJFKpJQVsM0hmgri1JuDh7ckTzSKCH0XvDmUfSXKp84CmaYVsTk?=
 =?us-ascii?Q?8M3F+yE5mXxFUEJZOVkC5ZYsGf4sYexIiEjsXmsM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1157bfb0-054e-4a1d-d179-08daf0050bb2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:42:48.9836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvdzwNGZbRIslb5NYegHKsoQcLxxNy+6Ytsh4/HL+4fOWQZAeIS4QVVWDp7WObt9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6437
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

Jason Gunthorpe (8):
  iommu: Add a gfp parameter to iommu_map()
  iommu: Remove iommu_map_atomic()
  iommu: Add a gfp parameter to iommu_map_sg()
  iommu/dma: Use the gfp parameter in __iommu_dma_alloc_noncontiguous()
  iommufd: Use GFP_KERNEL_ACCOUNT for iommu_map()
  iommu/intel: Add a gfp parameter to alloc_pgtable_page()
  iommu/intel: Support the gfp argument to the map_pages op
  iommu/s390: Push the gfp parameter to the kmem_cache_alloc()'s

 arch/arm/mm/dma-mapping.c                     | 11 +++--
 arch/s390/include/asm/pci_dma.h               |  5 ++-
 arch/s390/pci/pci_dma.c                       | 31 +++++++------
 .../drm/nouveau/nvkm/subdev/instmem/gk20a.c   |  3 +-
 drivers/gpu/drm/tegra/drm.c                   |  2 +-
 drivers/gpu/host1x/cdma.c                     |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c      |  4 +-
 drivers/iommu/dma-iommu.c                     | 11 ++---
 drivers/iommu/intel/iommu.c                   | 36 +++++++++-------
 drivers/iommu/intel/iommu.h                   |  2 +-
 drivers/iommu/intel/pasid.c                   |  2 +-
 drivers/iommu/iommu.c                         | 43 +++++--------------
 drivers/iommu/iommufd/pages.c                 |  6 ++-
 drivers/iommu/s390-iommu.c                    | 15 ++++---
 drivers/media/platform/qcom/venus/firmware.c  |  2 +-
 drivers/net/ipa/ipa_mem.c                     |  6 ++-
 drivers/net/wireless/ath/ath10k/snoc.c        |  2 +-
 drivers/net/wireless/ath/ath11k/ahb.c         |  4 +-
 drivers/remoteproc/remoteproc_core.c          |  5 ++-
 drivers/vfio/vfio_iommu_type1.c               |  9 ++--
 drivers/vhost/vdpa.c                          |  2 +-
 include/linux/iommu.h                         | 31 +++----------
 22 files changed, 109 insertions(+), 125 deletions(-)


base-commit: 88603b6dc419445847923fcb7fe5080067a30f98
-- 
2.39.0

