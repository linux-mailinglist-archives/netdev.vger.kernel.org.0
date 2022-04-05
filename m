Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B434F3DDA
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349653AbiDEUCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457618AbiDEQSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:18:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE05119C2B;
        Tue,  5 Apr 2022 09:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsgQSR/6/4R1rUCJcVM/8aIXWPJEpVGRU/H5HB1VJTNc+8uyO6yCARBF3KOEQ2vif2yZvxsuTMhYnbJFFyM6/hA4G4qIprRk4QxblrQskhfg+PPnaZFnO9vkExIA1cialWUSuaY+DfSav7po/KHKfpNepUdlF2Yboa0I19r5/upwQ11AWCLOfTSlzzjHVpEscpybeo7gmumyFMdP5otheFmgeCqz7PYKerzUwr7DSu7boZDlD+rMP7ayXVPiI4yqliCAeDg7ZNdve6XwVZ1bajneReuCmE0KFvcJTme80AQZdFA8WfX4+DWOy3EuxlvyxOvURv7S+PhLy2eGNiYsoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cXS8aEB142780tos2+ZV5bahKx5euq/IyIr1ripIAU=;
 b=Td0IWkW+ue5ppRzJn37yS51hwr0+UuiPfNDH1qHOXSMTAiHn4udF1XOI7XV6GfoubTVGIdxRLMFCY/xTMeOERsF0pNpqdip9kMRvKmcQmqYxFptIxtvryJnrXJC5RAwfPs+x1nZxveYLg7HhijCZpjl1wqNji1Y/zy75+ltmgtRm9TjFK8B6KtksNkyQ4k+1H5tNNpGI+TeSoecAfXFA4XN/zwi0bHhv7xwrJkR3XB/a8YX6cMpoqFibQGjqXzhoX1Olm3MuS302QOCbV3Mwc2V1RpxdP5JNi9KgB0Y0g6v6kmW8vsASDuQPnGgF2/0shRW8Z4PDnRpCZiGMTeGdSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cXS8aEB142780tos2+ZV5bahKx5euq/IyIr1ripIAU=;
 b=DaQrdIeGrKOkWrJbB3bGVcfO0Ad5+eD5xLAJ/a0jQAgYLopbQ7210tFV3mTtW7NvwyWXk77S91OryH16gtV9R+YKXPM3beQlwVH5WN3CmxJ3ks0Z7s0nD9AASskjtonXYhFfjxfkFccAhHYYH1oW0J3d31shAdkbwZldBZhDlOUJevkEnPZZaNo0H5C2MKLqYKApxh/EVM07whGV8M3VPAQ6t5asHd7Jd3x075osgHt9DIkpSa618ast25MoMt2wwcl+gjPYFdVrrj22b32V3ndqsq9QNKj3UfObA2l+e25Iqr+NFLtLS7DL9atXi4m1JgXC+ub9ZUTSYhopgy7taQ==
Received: from BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17)
 by MWHPR12MB1488.namprd12.prod.outlook.com (2603:10b6:301:f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:09 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 16:16:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: [PATCH 3/5] iommu: Introduce the domain op enforce_cache_coherency()
Date:   Tue,  5 Apr 2022 13:16:02 -0300
Message-Id: <3-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0335.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c3ad54f-ab1a-473c-7bd8-08da171f96f1
X-MS-TrafficTypeDiagnostic: BN6PR12MB1153:EE_|MWHPR12MB1488:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1153B2391E46579FC674DC49C2E49@BN6PR12MB1153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHnMRPm0HiKplk/idVUwK3jj8sYng78xKTOKv/9CaenELlFmCvSKE/tin4VwB+tRhE3YMucqb9Cx+KluU/vqHNDA5DG2hW/vJgWBJArue2Bjg1Hhhj6uLPJGVRkwUvNJFYS/f9F7B47L2oocCsz6EHkOEplaDs6CmT78rNY/TDCFpUjRAyN30vE2OeqjaHEqVBm51bRz8hWIoEk4HpQ4Ox8gNjHClMOhksXomK10MtFI2d7Day3atmB7S+lgx8RGEEekcf6MnDRU/PokDzzeoMmnPKwG1czwGDUqggOxfwVe78HpO2xnnRmnD+ePEY9Jm4Qrd+fIjk5PSzvZtj5jxp4t2oNdKBjdZ3ond86oVDyvPiEVH2WEfE+6lKg8qP4XmbReOvssCs/7Wasfuub5+Ah69va8pWe6nxCfc8A1eCv5a0BHcoxYggOa2wKPWtlehvFnIQdOuTohwmoJE8UkERYvPSBY1mqtGWrSqS8nyytT7uTTidRQ7kePPveb04F00K2vbfpA6ah/tO+PMu+UetvKSJWDwklP50inCxthrO4DP+tt6Ix1YY6cth9tX25fxnk9NB1f9tpJiYYTAUjJT65r8IFuoeFugiMSsBPTVYqXRNZrDWY6caGUXurgdPMvGshx7pH+SMq2h9eVrm2smbXyCYmr0GktX+D70LwGWdAOavUuZsssaUlM3z5wKMxaHJFig8KrxdkVSjtDstGfvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1153.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66476007)(6512007)(86362001)(36756003)(186003)(83380400001)(26005)(66556008)(66946007)(316002)(6666004)(6486002)(508600001)(54906003)(110136005)(6506007)(2906002)(921005)(7416002)(38100700002)(5660300002)(8936002)(8676002)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8qbUiuffthHEnLqvjGOqWOTcMc46DcuyHUVb5ws2IINLQwtOBYLF8xyj1TAX?=
 =?us-ascii?Q?hzFC60+/+jayw1fOpSvSpDnoZPuCbjTy3eCQkzq6nVDSUGpx04uIyzWU+99F?=
 =?us-ascii?Q?4Q0TKjik8G5a3uMFKlBf3xilbUZTb+Od1vvxeye79RQ5WCfb1as/PfWhb+2q?=
 =?us-ascii?Q?UsiLsArjS0lbY8cV1mSXp5bIvPnRynbrW9Vsx298E7qVvhGcaOc+FZ9MqsmZ?=
 =?us-ascii?Q?UtFw306Bv+gMpQt2TedFSDkC27Y9KzvVZL8rNDFyUnUF/5AbeN26PCDh6suE?=
 =?us-ascii?Q?pvkfd6OxBF2GHI/K5kGe/pGxGeZfT8Jgi6WQyBWEMe4uKP4j8Ff83j93QHgT?=
 =?us-ascii?Q?AaY1II8yZMYppXRXUTjlh0jno7XALWPnYP2q7fEVZdRmuyIb8nazCt/9BmAL?=
 =?us-ascii?Q?DWbmkCj6QAvyGmyT5brRlqiBB54eoER0H5GRJoK23BGtqKBo9osJKTqtHJ5C?=
 =?us-ascii?Q?HBY5SZfvIjvsWyds8hELN1fBh8/wAGoCuMRm5UOQb/4z+HnUkJXBuK4ZD+TP?=
 =?us-ascii?Q?fZulTHfl28zm3T/+/SfcmFhv+jRoq9CcmOs5Wbk0BHGgsvjt6oDrZx/SeVrw?=
 =?us-ascii?Q?YFGetG2bdgBncqMs8rfdleDQ+zsgJhtGWZCmVTLICcGYot51jpqkQxyQ15HN?=
 =?us-ascii?Q?Qcd6yPWKRnbfs8M/FeFeSsopb0EJaA+g1TkSHEhWLlDWbSdcBGx7e1bPFmEC?=
 =?us-ascii?Q?K792Zv+gyPYDB7HPplyFGqFTJ82gGquuvudcIrZwOGwVdO4KDNlNXJEVuJwe?=
 =?us-ascii?Q?v1I7cG2ew9LkYM8Hj9wAdAKalBo+F9F1XSDfrSeV1CbHgsIhfeQ1+Ze1xu41?=
 =?us-ascii?Q?UnO/HgxVukkgITf6/rNU9ZmnEnEFPrOLdAfUJCxha039FEXByroMvhUvKVRb?=
 =?us-ascii?Q?3rQdKjo2IQP1hlsHKT2PsSHxssIOgvZ4miaMvCvKmaksb8mxQ6oBuR+TtuQk?=
 =?us-ascii?Q?89m9P4IitOqpmxHx5Ml4sO81876UjYDvWWgM9ubCDbDUNH16vaKnZeUm+uuo?=
 =?us-ascii?Q?qXsuYHA0sRrNzJ7qpnvrrjXBiKlDoSWej88v/JAGg9cweoEjPpfOs/ht1gq4?=
 =?us-ascii?Q?oxA+U0z1G2ggHm3pw8F6iecrAveNpwiW5ZkjwpqWl3qcuITwbdnDSEXcenT/?=
 =?us-ascii?Q?uSMwiISND8avvFvOq18eSmKtoDPfsA9jHqRJexlOPhCLFO1LU6bgvyYipvtp?=
 =?us-ascii?Q?t1lCUX4J1cts/vwcaj0s0PhuvT+CzATIuHth2+NjM/jxOrxbyfq0G2zjhCco?=
 =?us-ascii?Q?DoZ2CJ2gM4DAe25DmzIzi9ZXMgm/8avt4lsBrMfxZdP9h3diMg41Rcw9Hivh?=
 =?us-ascii?Q?HT43h42cQj776ijHDPmk1uyHP2EnwXewGdTXOp4zAAbWTZowxwcrsKTyqixC?=
 =?us-ascii?Q?or1nz5pjJLPIqnm5OMFDGIe4WJlgCPW6nISiUPzI3knczb07LNQc1xteryIX?=
 =?us-ascii?Q?xv0OqqJXULUmsGEvgQXlgGYEhuXz2hmdmWKX9zHjnfLQi2DlYO+lPRUr9tVZ?=
 =?us-ascii?Q?Nwh58hv21GaM3lM59h2+C43am/FFF7xwsKEdcNobPQiB2t/FgXVl7M3fjKzS?=
 =?us-ascii?Q?JFBoaUT41t4h30hZ1jqJAiB8kpvCWoEXZxIm/lAyeGj//SBfOAwu2+i3S4Hk?=
 =?us-ascii?Q?V00/9PTth/G75tnrHpVbu6ldBW700LK2OtmBbbgSJMVwL2Dp3ryxBBCuewNw?=
 =?us-ascii?Q?Q0b/0vCXIFK3WGBFVViY/VoLdMON8z/gkQvIIWvrptbFXqWxEQP1ryaDmmLk?=
 =?us-ascii?Q?QFpiVYuuiw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3ad54f-ab1a-473c-7bd8-08da171f96f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 16:16:07.5335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLakBw2q1D0wWcv3Faw3oD5XVeRCPKlmlsj5KuVrYUe/y9XOk6uADUgp1Cz5z053
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1488
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new mechanism will replace using IOMMU_CAP_CACHE_COHERENCY and
IOMMU_CACHE to control the no-snoop blocking behavior of the IOMMU.

Currently only Intel and AMD IOMMUs are known to support this
feature. They both implement it as an IOPTE bit, that when set, will cause
PCIe TLPs to that IOVA with the no-snoop bit set to be treated as though
the no-snoop bit was clear.

The new API is triggered by calling enforce_cache_coherency() before
mapping any IOVA to the domain which globally switches on no-snoop
blocking. This allows other implementations that might block no-snoop
globally and outside the IOPTE - AMD also documents such an HW capability.

Leave AMD out of sync with Intel and have it block no-snoop even for
in-kernel users. This can be trivially resolved in a follow up patch.

Only VFIO will call this new API.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c   |  7 +++++++
 drivers/iommu/intel/iommu.c | 14 +++++++++++++-
 include/linux/intel-iommu.h |  1 +
 include/linux/iommu.h       |  4 ++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a1ada7bff44e61..e500b487eb3429 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2271,6 +2271,12 @@ static int amd_iommu_def_domain_type(struct device *dev)
 	return 0;
 }
 
+static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	/* IOMMU_PTE_FC is always set */
+	return true;
+}
+
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
@@ -2293,6 +2299,7 @@ const struct iommu_ops amd_iommu_ops = {
 		.flush_iotlb_all = amd_iommu_flush_iotlb_all,
 		.iotlb_sync	= amd_iommu_iotlb_sync,
 		.free		= amd_iommu_domain_free,
+		.enforce_cache_coherency = amd_iommu_enforce_cache_coherency,
 	}
 };
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index df5c62ecf942b8..f08611a6cc4799 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4422,7 +4422,8 @@ static int intel_iommu_map(struct iommu_domain *domain,
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= DMA_PTE_WRITE;
-	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
+	if (((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping) ||
+	    dmar_domain->enforce_no_snoop)
 		prot |= DMA_PTE_SNP;
 
 	max_addr = iova + size;
@@ -4545,6 +4546,16 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
+static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	if (!dmar_domain->iommu_snooping)
+		return false;
+	dmar_domain->enforce_no_snoop = true;
+	return true;
+}
+
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
@@ -4898,6 +4909,7 @@ const struct iommu_ops intel_iommu_ops = {
 		.iotlb_sync		= intel_iommu_tlb_sync,
 		.iova_to_phys		= intel_iommu_iova_to_phys,
 		.free			= intel_iommu_domain_free,
+		.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
 	}
 };
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 2f9891cb3d0014..1f930c0c225d94 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -540,6 +540,7 @@ struct dmar_domain {
 	u8 has_iotlb_device: 1;
 	u8 iommu_coherency: 1;		/* indicate coherency of iommu access */
 	u8 iommu_snooping: 1;		/* indicate snooping control feature */
+	u8 enforce_no_snoop : 1;        /* Create IOPTEs with snoop control */
 
 	struct list_head devices;	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9208eca4b0d1ac..fe4f24c469c373 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -272,6 +272,9 @@ struct iommu_ops {
  * @iotlb_sync: Flush all queued ranges from the hardware TLBs and empty flush
  *            queue
  * @iova_to_phys: translate iova to physical address
+ * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
+ *                           including no-snoop TLPs on PCIe or other platform
+ *                           specific mechanisms.
  * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
@@ -300,6 +303,7 @@ struct iommu_domain_ops {
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    dma_addr_t iova);
 
+	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
 	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
-- 
2.35.1

