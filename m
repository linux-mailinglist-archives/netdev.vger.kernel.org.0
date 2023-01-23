Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9115A678824
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbjAWUg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjAWUgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:20 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB73CE04C;
        Mon, 23 Jan 2023 12:36:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQdu4X9gOvGj2p5R0XxOcYhdXz7lqP+SROcbR02rgVqtE1YSsPDymzODdvzXgo+YQRLSp+CxwpKZWUyRaMu4eWjruxHde1AcdwFtGFeF+80tJ5kbe7AsVMOD7GV6djq2IAEtqjSBOEJXJvI3r/VorbAeBEbUCkp+bAK927tMrYUTre6AJ4EQBfb3mb9eT3akkVfMkubTpKRe0XGt71gifHcsoKqYEzGOe2xyANSQWT8uHi5xupnqNGq/QvXeNI36DouZe7jO07VA2qyEOh3R4nvpoMw1s89JYEe5D+fqyPDpCrYZJZQROB640DXC8ONNF0nKFaRmXM9G2Ut9MAHWXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yr3Vh37QBYLrjm83cKMD5EEuq4JtjyN4kOlmHNMMt5g=;
 b=NaULF8rNUgeGClO3gXp0ZsU3BjgxXpk8bpAsAUEiUYf0/DruD6ifCGMIxpirj28coe4aoJc1aDWnURGKMFsAqkVeKb2eS2midMY0q5fVLVwU6gA17HQufli5M80OBY0agyCwbVko3cKI/s5g5qgxNgC7+pj9Nojl9e3dvOHBg6RpfP6blbDdCZAJUPMM0GJIEX600VYfADlt5haZglT9LikX3qJlB6wMH7DVFTDtO55o9hCi9fWrQ/kHjkeZQsBiKy+10GQfIvas4xFpD5RtaodG+fg71Ajyt6clQ2wqHHNfhe9uYbQE0o58hhqcWj+Wr3hDne7yDO2DVrlbmG1WDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yr3Vh37QBYLrjm83cKMD5EEuq4JtjyN4kOlmHNMMt5g=;
 b=TE7K2h2vcxo6KbxJTIMMjovxnLd391F0RrDRpGZTdqYcbqXs2DC50wy5idi2k/5cNnYkb589SJEByoSBYTDBHJoJBWUDuQnjf5idh1sN42bDHGQEtlwrL6fRN70N88PpP1pRQf6C1OmZgaWpRHDvwV2juGuP4Gz/Xdxws5HODnZBd1AKJNswzl7u8SMcZQRpNZIOXAHRUsynTrE+8/z1J/tw5XRj1GlhxydJJFvlLwxufxmFTxPQ6eR109VLSF1+BoEoIDSGNAWIV3hpHiZYRQ019Mctmfg19VAgCLmpU3aczxwIu9L9RStY3Wxo6pACN94LL8dM9cILVc5ijTLRaQ==
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
Subject: [PATCH v3 00/10] Let iommufd charge IOPTE allocations to the memory cgroup
Date:   Mon, 23 Jan 2023 16:35:53 -0400
Message-Id: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 808b6e2a-c9d1-4ffd-852f-08dafd81729a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /qwTNrBFLnOuOvrtPPzK6WNp4+MzYoRMe7/K+868I50KEqOI/9cZ9jS6MYKqXkKAwnjXz2UcjznWeywRVoCOg1JfxpZ6iEwdxeHCIx/Tfa3siFs6O1xYxw5thRoG4mKcjpTY+5k8t810ZlCwHWVhU9rNtUwL+DhL/5VeazIfha/AJWqbdoTYEG7eQEhFWk5VZix+D/kUBA/jRSwUmcjs4ItQUnHUQNkGiefll4vrXyFxx1Ljc8lb98opVkSauDaNnGP5C3iMkjf3YtgnrwpoVLUSq6lx/F32949ODqIW1xnrE8PSF1syCTlzlycjJUrPReg7NKnzGnCtQMlbgnb7bPbkM6iaP+rLBXA27N/IJoT9cC2zDPcK8IdfgkX4CWgwCk/7w7aQ2fQb+6kGLFqd5qV4gBHIS+yzt/jlnlup5W78wH24g8RKnE2tf8gqLAryW3pf3hvqIvjLCoo551rz2aYmYLqeUQshia7Z2jV6bWm1+13ELEETLMl2+BUMOMnbxfyENLSaYJMZbIwiVJ/86a6+EGMKN9zFsEvv3rWm+yOXYyu0h7YtNkt+rD4vTY8TuB9Vw8LtFasctYopcl4pGGY7Ip6MxocUoGxjulOjmoUdaNjGeAz5gQ35N/LAaVcI6dSwcTBKOXmq+XJNtuB/Hygn4S+oCrPWEAVWfxlX71NtLuk+fYsfBdgZuufN4n3KC3/eraukHWYhgHdEaYc3L4qn+7475FfjgO2O9a0D2DC+km8Aow0IHLQ3GfBK9qcALQ2v71UneT3zU3c/GXA6ruFiRi19ckfpLFWYuoCAQtkmhfTgx9E5i2w7aNp7QJOg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(966005)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vAYN7Tx1dy3bge4mTiovHW5AvAtW/Q/us19gbM+Xj2rF+dIgfj8H7TR2REl2?=
 =?us-ascii?Q?rnP48CBsKksfFrkJPe0xs9u2n6flUSkJ+70OcnVZILDytdebIWhsEyrExEZs?=
 =?us-ascii?Q?7Ck/3J0StPL2PqX1P5ShpUNG3K5yqUQINzXKMymMaevms088OM1xdaSJxDxv?=
 =?us-ascii?Q?+v5ZIGC/8y56FY/rVRy54vRITTI/ukKfsaBU1c/9851HZzt+GqmBzxV/ZZV/?=
 =?us-ascii?Q?w7mSsbCeAB/MqfjcDqRivnDmM6RBtzip/QRliWsTWvcw7MKigMdT/8VWdcrh?=
 =?us-ascii?Q?BqOiTDbZp7P1dRtyzpzijgsWHQ5XrozWRWEYMbYQlpw922UEl2kp+D6hz+Kd?=
 =?us-ascii?Q?IYkeDP//F0RiUdQPmByuhgoIFnhfYGYeT5O7ag4jIH+7QZgoU2rSS56dhuxZ?=
 =?us-ascii?Q?9Ji/eAuNnyGRt+NUsve1RXr9NgrleEts52w3Iz8sPKdL5F2zmiW+R3smJN09?=
 =?us-ascii?Q?ZAN2SM+8kmOj3arbaaU8cU5XQG2IFb7+/2cxnVtz4iGIIeK26bkeLJrOtrMe?=
 =?us-ascii?Q?ZLOmlFpo25DDjYUFHPe1AphcqLskkgIVu5DvnMctngzBNVUivgrSOD/1ofPa?=
 =?us-ascii?Q?FcaKNYWH3K+Ro304hd2EH0b59canUMBcuWR+hHNE+ISY9tDrnCR1HhC/rj1q?=
 =?us-ascii?Q?AZ8KT9woEpXdvDkl1nY+JCyciOnipfb193jwZX1kY0W5ZjNhPGx+Ijnl9TR8?=
 =?us-ascii?Q?ZetMN53tz3xwBin+wCILJtjyMN+xT5QTp0t5y78TFN54FmqN7DDNOW09TVLn?=
 =?us-ascii?Q?ZyuRalFWH2o6winaaAhzFCSWjUKFlnv1CNjms6MFZnUDV/q305jfPRaOYkMO?=
 =?us-ascii?Q?1t6uDKEjUH/931luA1A6A40fHISReAcWptwjszxXtBaY5ws93d9DHGnmI7Mu?=
 =?us-ascii?Q?D4sgr+fNOazAFYN06/rRdOd57mxt5RM264pE2VZhi2SFgoRhdnjm/fFoo4/7?=
 =?us-ascii?Q?DKIBDK00owEms33MYf5ppanK/Q3kDl6mOpT3854fGe1LD+XrsoFNFNirMEx9?=
 =?us-ascii?Q?PBwzoSnhHNt4dRB9FGAZp8DzvT0nK2eS6lb6eyEGhSCvRGqtTMGUy6Xzv3TH?=
 =?us-ascii?Q?toLV1ZjijT4JoP/wlNRhmILJ6E8lq5l/YCOj0BfHwc6ETsHdHfqlnvPMFBuO?=
 =?us-ascii?Q?JlmUskvgbjznpUTceoWcYx2qFGKwdHZygPJhDFywMywUa6m/Lb9b2HTqidMk?=
 =?us-ascii?Q?ESnoyiHqlu+94KBIM6d40rqpT1ndJw/SXgE7O9Fd9/lCtCaXNiFkFQ6WhIas?=
 =?us-ascii?Q?9Z+mXP4cOdME7UzrdYhl399F+O2zQ9/AX7D0GFZZ7qEE5J8r3pS0Q/KwBFyX?=
 =?us-ascii?Q?TBK/mBNM2V5Wpnhb/DOXURImaahv4sxrOiTc5SctUUW6b99SR8PiOQyGwXaw?=
 =?us-ascii?Q?2nV+Qp7yAYBL/FNaTHz+AluAwppirNQseoLxun+n/c24vNcR3YpMncUBDHG/?=
 =?us-ascii?Q?QJWCcRR72g5IM3LPlJcqnvyLa/Kf8NRBVM1sSby4VbEMip+69HSifZ7M1VAK?=
 =?us-ascii?Q?gf8aax1FVqlhqDGAtw64dAyeFuqc6jVVp+bd7l5lFsWsRA7o2rrE1/Ianv8J?=
 =?us-ascii?Q?CLbfEWMkzgIWBjbMb8orOxI0t52l7pljMDGACsua?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 808b6e2a-c9d1-4ffd-852f-08dafd81729a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:04.2777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHlL7iwdfLJOVwSWdoQkotYBVZTbCXUsK2C6oTuCQxNQ86RydNUUAETqqJ+VfKlL
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

v3:
 - Leave a GFP_ATOMIC in "Add a gfp parameter to iommu_map_sg()"
   and move the conversion to gfp argument to "Use the gfp parameter in
   __iommu_dma_alloc_noncontiguous()"
 - Mask off the zone/policy flags from gfp before doing internal
   allocations and add a comment about Robin's note that this is to keep
   the buffer and internal seperate.
v2: https://lore.kernel.org/r/0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com
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
 drivers/iommu/dma-iommu.c                     | 18 +++++--
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
 22 files changed, 126 insertions(+), 125 deletions(-)


base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.0

