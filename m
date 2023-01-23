Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66405678832
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjAWUgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjAWUgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:23 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D6F1E289;
        Mon, 23 Jan 2023 12:36:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJecD9vEyZ+TP3fm+1ackrYY9PSN2nSEuvrs93iG8LwVUcxoxpfYDZ/gzrvu1NGU+b4BV9akzLXTpRkLXfwLM9nFIM/T1CkCRF+KeLmxCgd0k5XMrX7n7okCSNTI+DJYjFtUfJqG/cfE6WxQWs/WiELgIDBLHJeetULBX1Ir1297CoCTGsfntakjV4tW0f1WzKJ9DNgRXGVWWK/ni6/TsSE+14aj7hInLGtCkj4eTwjAl3CJiMuMDjCQA8Js9nzrMLS0j8cnb0n1NxU+8NSL+iWa/CDn7l8Gia/sEAZet+SSHi7ptwDjNMN2x6jyLlW9Wkqaw0adNJqoUTeARVTT2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nBCMHMAOxVyylbTsSdPtuYEtvKe4RbQ5AcPHuPFZVo=;
 b=cn2ljKgG/WEQci9wtjfdnkbsgzHa33dCK6XsgcSsb929VLkA0gLcOstCCYSRB9SfWVYiOix/FWokyM6yKuJguQVKrwVVoUE0HgM39TBdi5E/e8W+zSqGYGhakh51L/Gw2i7c/yUqZ5W8rAaLGb/lRm9LLQQAnbZiilmoFKId0mKSlyUW9cRKanjSOYNtuMpVUbx2ns/WVDyxKFb6xwQS1OC4cdMFxgKrvcjhOHjrAa8/HlbziCw7Mcf9C7JPQbsUm0pWfwwDr7v3p4aIUCZuabhqbJYCFmHj8BM1qwfQGUmXfKgCfAEJNru/ULYTsaaZurmCIni/VKzI+yvJzBgFEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nBCMHMAOxVyylbTsSdPtuYEtvKe4RbQ5AcPHuPFZVo=;
 b=dHYzSnHRsFgUz268YImx5p70dQ1uAHvif3tiOJGVheKfdzRe+S/LxU9ps3/q8xmPWilWnBzzcrL8TNB+QPTdrYFFIADDaeYymjBWf5mbbuoq2fhWO6oG2YBxGXS/gCcNhhiHRJZRfjcu+7jesocqe10OxBT7MBW9xwkmdH+IfDwpCErObhcfUq8Hoot6t0oluCne6oAungZ+LIG87sZwZU3P8BJv4pIA0osA6y34P7QBXMKhGhLr1K60ylXzCvLuDyIgRDIcut7FXNPMWdldr8MnYRYz40cRe2B6ZTIoDfYX4LOuOHmDw0rOOnhajokD+XvUZSttF8OZJCACr3iUQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6571.namprd12.prod.outlook.com (2603:10b6:208:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Mon, 23 Jan
 2023 20:36:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:36:05 +0000
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
Subject: [PATCH v3 07/10] iommu/intel: Support the gfp argument to the map_pages op
Date:   Mon, 23 Jan 2023 16:36:00 -0400
Message-Id: <7-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: c0970f0b-4045-4727-0b34-08dafd8172c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AHAczyS1HvFGvl6QJN292omfdyNi4az+MsfOAYEClFNQoH7zTFZsR8EY96XVsLwrf6oe5RKD+JG2PzkrpMzU6TkaPeuEVmQpL1W+nWr78YcAOKFIU7PDC/I9SfmAqvGS4Q7maynoqdhXkrcVuGz+yJMmFmA8jX2sl0Q8J1/O3zx5fLCYD7w3hxxDwHiPmC5w33UeB9pYppDqy6mgtau2BP2D5D1lfGieQguY2dX1leGheSDCpayMfLYrAIgu0Q1N/0zohn93VBTHeVZGiszX2RnRugohiIXMxBffCz4lpdsteV2Mx6Xl6MIA5tourFfGlv/osfLUjpYXXbt8ICkn2QDx0LqloCzb43e+Ro8WotpDS95rpdgaSG6kpi4VGF/+DEFQARFD0I1L0c5bEIaq02xPBDD1g46ZMc22LFFG+GGiQuksgFbcWpSgph3b0kjBSKusp800br4bAT2S3xWVFx/Pyb9jYCKVvc17mefyB6oCvOUDPPKu4ttXb5WLisx6AyZq3S6ereyN2jjM6jpdDN2dOf8Bc7X0IIgghEq8gc/kKkNr0oRwshFvMAvpcGDdcm0dzEmQA+M5OUL+YKtPNdgNy7qHRO3C0H/8afDbPKVWPlK1OEAVfI99nEwOTFQjRAN45XbM+0AsjvkmCt2/UoMJHiw1NGWMiTLyl5I1xG5oMbFPHMIukLSclO8A181/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u1Z0FIO50yE2Qyuu8nK1YS6zldly+J7CC4qTvSsD10w2BrO3Uhgpwsa6lkr4?=
 =?us-ascii?Q?PPo1xFXrjVH7M8kSGjh4VxHLzhjrStFFLrV5Cl25S9ljkqU3aksJ0Urmihjv?=
 =?us-ascii?Q?1/nKEsdgdKo+WrN4TyU3p70ZVArMvzJcHr1VhWs8ThHm5ZDjCb1Hs6RRJ5pf?=
 =?us-ascii?Q?w4oARHgbRcxXcWi+yCOuS5Cep1GEHMaL2ZIE4QwnpdCDSghTU4OwRYqIXSZZ?=
 =?us-ascii?Q?w1H8ADpWQXLWra1yIFKK3HU/jcD1Gz+VudGaPh2fbeM/6X5J/elZkntGd6o/?=
 =?us-ascii?Q?3o/jFEZcqjcDwG+mvNIpWsJn6ZtT6XTZGYpHnp2ugXB91Fz6k3O9IWF5SCL6?=
 =?us-ascii?Q?Qk2NwqgVaoH4ChfgV8RTXbNPLjTPX48stqocPTxDsxCsXlB7zvipnUEzJmIX?=
 =?us-ascii?Q?K3xnrxsZflj8suzKqiWvVvEx/+OD6dUpqu5E0UbJEzzghz0CaSbDibJE+c0S?=
 =?us-ascii?Q?QhPdYrXDvayuWbmTIHEBNZkCtmxadGsBeQ1LCCapIEq16+WPM12dN0wj03NY?=
 =?us-ascii?Q?aBgd7JmsG7EhgHqP2IP8wBQpfOwpshrLmLH9HTUrfDGTFYDftPIIz/lIKyBH?=
 =?us-ascii?Q?2cMQVrOKhSGQ6+zYSAg77p8jMqeMTAhE7i8eqVDMxFQbUabo9UgG0mW8PXNJ?=
 =?us-ascii?Q?b9syn1jKOGs4K0vkjw6G04SY1kAaJyBHQeTsnAREAW3HHf8Jbr4SjpqlJBK/?=
 =?us-ascii?Q?2Zk2hNK9va0Mji/OjfvKovHyk0gdXGkRsqO8k43Bq+tfZC7lbT3NukgaHrWH?=
 =?us-ascii?Q?3kFHIhp4wNX4qbxzbtaiWYgZVjLfeKRe/uqlrNU/zy/0q9UkS1MteuVE2tSM?=
 =?us-ascii?Q?VKWAlTAjJCD4L9mRhhCMOsY9QZ8KUVm2/jbGZyp0CBUP/r1QbO/KQCr9dryk?=
 =?us-ascii?Q?A772IhGH7E8WP9iao/iTdC+13w7tl4ZTxd+m6THmWvND+WYW8VViR/oujihM?=
 =?us-ascii?Q?uP3wp1QB/IC0ig/unugOJc+faKza/2/t/QSOs370ZIfknQOi4Hrq5gJl0kI7?=
 =?us-ascii?Q?YGoXUtH5RBQpXuZsOwiwj34VRqLreErHVcUUWISAZICZlfAcaMetpV0DyQeD?=
 =?us-ascii?Q?YHBVmjuoij25aHz8heXf2vNhs4K3AuwhQ4znQLo7bQ1SF4z9BlSNyCsyAmOr?=
 =?us-ascii?Q?klhy2j82uxaQBthZnEksXA6D9Fo4SMU+j2xxlj+J7tyIhjBZUotMOsQeLPrX?=
 =?us-ascii?Q?mU/1GbTEaU6zdkNtpo+ZZU37spq7yMmQKLl69IxKm+ubcrymPZImjocZHFR9?=
 =?us-ascii?Q?y0+fP/Xbmo10+rboBqGqA2G+mbIOPX2qOaGvlM0W5s5gDi/Zpl3xTHLVIUix?=
 =?us-ascii?Q?uCazNKW+8azWRGtEKIWF+YIX6rN8i1EFg8M4Z2i2Xp2S6nTwf0zjlGcIYJ04?=
 =?us-ascii?Q?cKFvNx/GUyLs923vipzOe6yH96U1BfXcw3fUzL6g3kS1JIArcnmXUIQpbwwk?=
 =?us-ascii?Q?Ere1AzFXv1zPC+P1cyOeIGHUh8GaFOm50fP/rwhm6BwHnm5a13ZcqweJvqQg?=
 =?us-ascii?Q?guifWn3CzTDs+GeOm+Wu5ZnzoP74yXXqv7tL9lsBaZGBIkYNPQw/AY/PVRHv?=
 =?us-ascii?Q?wGwC8rQpUvgb1z+hA57Xta7CX7b5Exr+TT8nb8a/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0970f0b-4045-4727-0b34-08dafd8172c3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:04.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SdKKK3P61Y5dSOAs/ZithmyXc4aMUd7VB05fVxVwtqpjALbNbMQbr8J/BNhCz3HW
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

Flow it down to alloc_pgtable_page() via pfn_to_dma_pte() and
__domain_mapping().

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index aa29561d3549b3..e95f7703ce7b83 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -908,7 +908,8 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 #endif
 
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
-				      unsigned long pfn, int *target_level)
+				      unsigned long pfn, int *target_level,
+				      gfp_t gfp)
 {
 	struct dma_pte *parent, *pte;
 	int level = agaw_to_level(domain->agaw);
@@ -935,7 +936,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 		if (!dma_pte_present(pte)) {
 			uint64_t pteval;
 
-			tmp_page = alloc_pgtable_page(domain->nid, GFP_ATOMIC);
+			tmp_page = alloc_pgtable_page(domain->nid, gfp);
 
 			if (!tmp_page)
 				return NULL;
@@ -2150,7 +2151,8 @@ static void switch_to_super_page(struct dmar_domain *domain,
 
 	while (start_pfn <= end_pfn) {
 		if (!pte)
-			pte = pfn_to_dma_pte(domain, start_pfn, &level);
+			pte = pfn_to_dma_pte(domain, start_pfn, &level,
+					     GFP_ATOMIC);
 
 		if (dma_pte_present(pte)) {
 			dma_pte_free_pagetable(domain, start_pfn,
@@ -2172,7 +2174,8 @@ static void switch_to_super_page(struct dmar_domain *domain,
 
 static int
 __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
-		 unsigned long phys_pfn, unsigned long nr_pages, int prot)
+		 unsigned long phys_pfn, unsigned long nr_pages, int prot,
+		 gfp_t gfp)
 {
 	struct dma_pte *first_pte = NULL, *pte = NULL;
 	unsigned int largepage_lvl = 0;
@@ -2202,7 +2205,8 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			largepage_lvl = hardware_largepage_caps(domain, iov_pfn,
 					phys_pfn, nr_pages);
 
-			pte = pfn_to_dma_pte(domain, iov_pfn, &largepage_lvl);
+			pte = pfn_to_dma_pte(domain, iov_pfn, &largepage_lvl,
+					     gfp);
 			if (!pte)
 				return -ENOMEM;
 			first_pte = pte;
@@ -2368,7 +2372,7 @@ static int iommu_domain_identity_map(struct dmar_domain *domain,
 
 	return __domain_mapping(domain, first_vpfn,
 				first_vpfn, last_vpfn - first_vpfn + 1,
-				DMA_PTE_READ|DMA_PTE_WRITE);
+				DMA_PTE_READ|DMA_PTE_WRITE, GFP_ATOMIC);
 }
 
 static int md_domain_init(struct dmar_domain *domain, int guest_width);
@@ -4298,7 +4302,7 @@ static int intel_iommu_map(struct iommu_domain *domain,
 	   the low bits of hpa would take us onto the next page */
 	size = aligned_nrpages(hpa, size);
 	return __domain_mapping(dmar_domain, iova >> VTD_PAGE_SHIFT,
-				hpa >> VTD_PAGE_SHIFT, size, prot);
+				hpa >> VTD_PAGE_SHIFT, size, prot, gfp);
 }
 
 static int intel_iommu_map_pages(struct iommu_domain *domain,
@@ -4333,7 +4337,8 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 
 	/* Cope with horrid API which requires us to unmap more than the
 	   size argument if it happens to be a large-page mapping. */
-	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level));
+	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level,
+			       GFP_ATOMIC));
 
 	if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
 		size = VTD_PAGE_SIZE << level_to_offset_bits(level);
@@ -4392,7 +4397,8 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	int level = 0;
 	u64 phys = 0;
 
-	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
+	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level,
+			     GFP_ATOMIC);
 	if (pte && dma_pte_present(pte))
 		phys = dma_pte_addr(pte) +
 			(iova & (BIT_MASK(level_to_offset_bits(level) +
-- 
2.39.0

