Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B73660503
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbjAFQo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbjAFQnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:43:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB4D7CDFA;
        Fri,  6 Jan 2023 08:42:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKKKUO27oWIBdzaRaXYJhd7KCW+dyFqIZBf2fJml4kzYBFM2du/CinC9/FnbeTjE0KZZM2MrJbkjPEeFfjVcuW0z22f3ULRTPiIg08uGifZBJMIr5eEkSndjyR3SPIfLsrPNtOI6vTqvGQdMSi1sVqBDvSfqTmcxyZ+LPc/8cmNB9eBa2LWIe+8Y/nehL4nLc6n7SStLkIyuS8p7+vanTWGEigf5MYmhVEoc2PvueKi/aXgkgc4wXnyvZ0vRdXpIMUR6zwPyT+SY7vSdzSNdvfixYdORzxFfLrfqV0ITp3eOclk3n3hbbBf6aM9xJ8p7/Xp6U7TXsUxTG6/rTNrlYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtyZnwdFxQsh/b7h/nRYnn/WPi+/nJjaPNr6yHdQXRg=;
 b=VNzdyg1O+lc/wD4WEzfkP39pcF2edzksWxw0i/2bOLRo81RzSFwh0ybx3aHeRHBYYNvBbwLc4vjSv7M+65PctqY8e2TKPM6YKYLbYVxgXJqJT9zc8MzM6/ZnlAfbMi3CBo2P8bqKvDfUsx9OI7wivYdYJGHiFSzE5BqajOermMXPG5qRuki8zMMe+7Yz5jqPAPtbbBOazYJiudcMGVk4dhwtADyvkufcpFwNyGnmOLCeUd2VGFu4sd/U6Syu3Xl1mIUdQPakAB/sy7WTR9YpaxYyWMPQ89HZzBTfhS2HdwQKpajwl3AmB4FQo5yZV8itTwq8tcYVPrOI01FULUdtEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtyZnwdFxQsh/b7h/nRYnn/WPi+/nJjaPNr6yHdQXRg=;
 b=bu/TG0GbnC/GqaxtBr+PkgqgLrSSWkvy9P/8aBQghk395HoqFnRrXp//JLrr+ikcFpNugzgDpOwFi7Xwb8a/RzVxsjWvEMjtj9RVaNC9jKhKRKnvz9vvETU0dcMPkjWLMj6gLBN1FHxQsuQAaT8ThdvSvvCfXIEuaCDJxDOxUvSQOZ961ziHMJdm/wb9piLDnrlKfm3StxJRjsHBvnzeByMZncdu9LUwIGfqqXx+y6zpODaPc8eDxGxmcogFzFlTPc3EmkIU0JUNUo9uSuZKaX0cIT5IzDT/V4Hpzk1xrW6ehR1soR1hulxlfopj8rsKJbnjTo0gaCuaFB00h/KYIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6437.namprd12.prod.outlook.com (2603:10b6:8:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 16:42:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 16:42:51 +0000
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
Subject: [PATCH 7/8] iommu/intel: Support the gfp argument to the map_pages op
Date:   Fri,  6 Jan 2023 12:42:47 -0400
Message-Id: <7-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0325.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: f97b4f3e-ece5-413e-50f1-08daf0050c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9s2GJX7M/iJziWYLK+8fyVJS4eXbzRzw5tWWblbXv4Rne1DveE8iJYEj41xFKdOWyfovgBDyiPCILiYkFYhrAe8vVxq/hE1oQaePyMNa4YGeXguIx2BO49z1tGLyBBe4BQzUl8PACGMiPTcb75++7/99uJY0cwsc432kkOsxzrs/6OF56rdsytT9VPhxhqNtjod1KB7bSvQJNgAZc+cz5reWrDX3Xfn19La00G15P+RNQWRiSX7CcJeNcIcCoy9C72/QxnChO8oGKn82aY0HgU9Apab/TksT+Ehk1zB5EuAMZ1SxKJSgEe5U1pscOVQHOzl6pkNlkiBmZgipXcOlkmbieYFXlPQH5vuNmB1wAb5WXL6lrCs9eHiqVy610l0KfUDXElfDELtEz+pvPm9uB86s4aEa75ryot6jpZbXg2240Lzo+9AhQsM3gUXnvX4r3TvQ+ka4xWRG5jgcSDUJqNgMtydst3s+LubXfsjg/hN9bzRnhUs4e/1tgjImYwXGmeCzuVXdrDucufZIT5i4fmomVtbSVHt/LjUVj2O5K+yrtRM7yMg/ubZnrGl1+BtH2vvu93X1dj3ZEoGb72XtLj6K+Yx41v9R3W2dekc+5bO/qMteRpgzy5Lk6Clklfl5N5AbBfCiYSRIYOweEkTx6EFnQMfWVZVasBMA2kK8dX/HiG1/gODGeuvULDw9qrj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(7416002)(5660300002)(54906003)(2906002)(41300700001)(8676002)(66946007)(8936002)(66476007)(316002)(4326008)(66556008)(83380400001)(6666004)(478600001)(110136005)(6506007)(36756003)(186003)(2616005)(26005)(6512007)(6486002)(86362001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xAuvy2Rum2EeTgxRkVf2Ofdp/k+awq0v+1TT9H7mYJpc057JsIvxOaFeOgLg?=
 =?us-ascii?Q?/Pt2Jowk5yATUtW5yQyqerMqJIiDV71IstK8Qn8qwkjme1hevNEE5F2C/17W?=
 =?us-ascii?Q?ue9biHV0GhQlRpkHcQ6lPKvL9SHxlNh9BGSpXqpEYDki2RlgpnKmdj2y/AIQ?=
 =?us-ascii?Q?UxZcxYFISmYfIM7Wn6lV4sIe9U5A3899A+sm0Qd/5ZDzPbMTkd3S7rHM4PqP?=
 =?us-ascii?Q?H7rvQ2mjczK1y5rvCvrS+2Y31yOOlqed2PTMeXMAoo/LNqjnY0bGZBlxCXB8?=
 =?us-ascii?Q?jgwOVk6klQ2BGLIEwfc2ighyzSswXVo/U27u2I2A5VuSakqzZj7I2f4JV7Gp?=
 =?us-ascii?Q?xFahl5Law8X3GzZLPJ7txJLUQ6Q/sGrz9N6/8ZrR078uDwe008ab6Z8FhitT?=
 =?us-ascii?Q?Tq9fhh/dcatoqOflXfc9yR+3UEweWKTZ2qaroX4SggdeZv3VfZkHoGm5wtTZ?=
 =?us-ascii?Q?7a1J9VLLqzaLgAG3Gauhax9kEjqoku//roK/EvlsJin86+j7vtfhsns8QNFz?=
 =?us-ascii?Q?2QpV3p+aSpMTyhPAs11NS5GC+cqn0xhyVK+T2QUuCYDW1Ebc55uj9iWYMKse?=
 =?us-ascii?Q?ylasjOykI3PQOeX7eUt0T/KYSq0FoeirRO/rEBBVQ0/QUfZo5L2HOdGyZh5h?=
 =?us-ascii?Q?ri8MZScgHXQnjGsO3caQjOwJF9HnahNWIHr/fI5Wo9wXQ/AbHPmsFRICMOBK?=
 =?us-ascii?Q?265bzihrlgV26x0PCj43e1+UCYJ+non9EJ44b14EWP+vQYBkrF/1K3zMU3ON?=
 =?us-ascii?Q?yGqcooCnqlgdV22fCxZezLlnX85/1hB/ksPCsztQhPzE/9iY00fMziCRBLoK?=
 =?us-ascii?Q?7KKNq/slpcqq+j9Vo79tEcRATdGIcRFn0oeTFb/j5CUMZqZw2jW67u8fVKz2?=
 =?us-ascii?Q?V55FBQMtE1wMPK2wAw5oPQqp1cl3Zgya7QrFexKTfPjkmulKz8wkVKituhvk?=
 =?us-ascii?Q?2xCUB+zpEGevtZ4VBotA/8ZAyVBHKMKFnXIrygCqdBsYVRuigM3WXW+gAUwX?=
 =?us-ascii?Q?NaMVfKouQKYQpvfmJm0qn08Km4C/W8sBCC32T9yIF+IKuADdFAuV0FSk82fh?=
 =?us-ascii?Q?GeaaJ64LnzChlSMgPSJbz7DIGhCeJp7GklecB0ozg9dRKHQq+KmbbwV0uqLE?=
 =?us-ascii?Q?1WW7qenbw84oFNqzXCEyd0ytlUfnMROQXOuDUCHf0aP4D04FaBcIydqF/lsR?=
 =?us-ascii?Q?MBqS4JGTVOzJyjlahEg0W2klUZRoH/DNvalfhF8gVLuhiY3g3CqL08mYU765?=
 =?us-ascii?Q?BIsxeTR0NPFOCpm51zxssyqTqFMQAjUDaEgjbP3R0gZ1cGqz1x3qQutprXq/?=
 =?us-ascii?Q?BoeKWJyhTlXHzQdKIZzYg+vbyfuJqF7o+a7dhLN35Gkc0U0qHZNBimqn5Ht2?=
 =?us-ascii?Q?rgFsPmbr8R0T8woDdjGB52gnbWqc7O8YIfPKCxAuqpbIzrkck/RSZWJ7ceoL?=
 =?us-ascii?Q?lHLG45SvJNuTWyfUvi9TlHyUVkikUFaG/l4pFL5GOJ1FUne1bTNVM4Ns/EIK?=
 =?us-ascii?Q?TzVqznGEnutsJchhOsF8Fu0cFNfMc+sOq/3wUZoXdBNPYS0C5ajbFMK/Ir/q?=
 =?us-ascii?Q?qQgK5MAT2qVvYbgFrDAa2D4PjjPjZw49eUcXF1WT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97b4f3e-ece5-413e-50f1-08daf0050c8e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:42:50.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FpnNY0ZfFa8YIwCQCblO0pdiZNbT0Em1SDfALrK7Z97EG2AynYi3oxZ834lqKdAs
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

Flow it down to alloc_pgtable_page() via pfn_to_dma_pte() and
__domain_mapping().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e3807776971563..a1a66798e1f06c 100644
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
+				DMA_PTE_READ|DMA_PTE_WRITE, GFP_KERNEL);
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

