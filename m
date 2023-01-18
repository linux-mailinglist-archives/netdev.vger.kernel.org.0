Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B176367261F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjARSCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjARSBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:01:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A6E59E49;
        Wed, 18 Jan 2023 10:00:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkcoa9bO2DmLUEujoDK7cPqe7qArEmmGF5QJ9CftbCf/7ffDljQN0brr78iIwkJuIXN+n5lUl4GxTgbPUaDoEADzF6XW20qM4RTGX21aH1NBheTDw6/+VOIa4fQJZnwe6rMmy6qIaMq2Fn0x3FiDSu2EStY8OtROSu4bDCyQHVMRGhWnv9jaI6lh+/sctXRt15mBoP0ewe6af1smHLtH+LvluzUh9lwXMNwenOrEmVgpa90lSasm0HpW74RnW3gLEM21whLmwHumUFUWzlI27ClyDzm+2DEIGRlgPC5P4wakbZhnjrZ8xOOiTdk10yXtN+2dt5Lqj0QM5o9ucJNCoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00QdWbWiUTWl/6S3U7Pl+WfF55hYSq8tk2e8Rg76hyc=;
 b=I/1o0wPH6qKccjsP8/2qplZC5zhMDAKQBY/hno/pr9qxFnpBwTNJQ/SYuz4ll0Z6RRdSmCkDqHS47eh0kKT++tTAIoJzmn4LPYXJ/dQpdW8ShAUaE3SAWDqbz9RMS2VFiC7mZA3P0FSL/iK4BNE7u4uWoXNaDFgaqtT7ZuVrn+GXGOLf1kixKtZzftJbvMB4u1GYxJqS+Glwcp+Rxvm24QNsxRqwPqvufjMV/DE3n92FpODEBTf4+8l0awd/6xywXaDPz4lJ9Vc9D+HkcNnQQaHtjd10hRN1M3ilVQyyQI2uBTZgZB+/k86nzaw877diVP8Hfe5iClmnJ4PaWtjS1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00QdWbWiUTWl/6S3U7Pl+WfF55hYSq8tk2e8Rg76hyc=;
 b=Te+noWkSQrxmJdQR6nqmu5DkFCRE0NkGr8FdZOTuspMiC7dUnJ2NtDWvyS+149f7IolvrRWoBde7ZAus4WnrpiaQM069dTdAFHaUX1hJKSPRYzEy0wHv4FFtpVvgrc5H9LiCyab5ZLwp8Z6JLFFCnNO2n0oS2LRD9grKVXOiPPkN5WwiHKvFDDirBBvxjEgjhwt/o9tnt/MSSrSyoeILfyh3pacjcTzzfh79elHou/X/TLI8L+KoQ3gR6+P2tAPaA0BCi4SQRKLA2RogQ7AQ0Zw+7cYo/dVdbysHVCfoX8jNZaF1QZpP0jv4NoW5o9IRLaSPAEPbWcZSOqFNB01G3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 18:00:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:52 +0000
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
Subject: [PATCH v2 07/10] iommu/intel: Support the gfp argument to the map_pages op
Date:   Wed, 18 Jan 2023 14:00:41 -0400
Message-Id: <7-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:208:329::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b91501e-2a1c-42c1-a24e-08daf97ded07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXhR/hMOUioS+TAvae2HjS17kk210XPZwUSkleqGo2CZtoJYIv28foLDtPBjmiGcRuk5JA0ETaOD0kBLLuiJeOeIQCN69BjsNVrmJm8XqSXgjcBuVzO/gegL2jqIc54HKaPcKD7UzrB2Aq9kjyAnjmA6yltMi7CF8ItS4n4bbwEx+Wko318RCZ/Br1//Q98THuVsCg+/vZF1V4umCWFRaDfn/6y+JL4W1gmp/CLB9l+t/DP3zCymo1B3HtjznbmFivwGLE96SiBuKn0SWh1gatgs3PZxqKVjeYuAXioBsoN6VyLDny3F5btwGZiX4YKiShY4Y84Os0bnsqWVoD34K4xsUbzjHMd/sztC56gDWHG1C1C6kcGLzncTn6gqEkl5VxRnS0cE8GrUkM6F1NDG46OGGqAOobtdWmryd5B/5/zk6sEUDI2d+HAHzBuEeAc2XqZ9pEj4cHpLiXRnP71c8QSm+KxV/m4lqiwkjn3uCkEAF9Y5oWX4wYt6/qks97C5swEmAcYDFFNsCcWd9omrAegOAXBJ/6suZlU98in2X9k0F1u824/eQRVpqwpn+BX5yFFeYJqwFQMPlA3c8nSIqQlUSdTpVR1/5gpL7frb36He0VTN/ONjqbtMRV3WQoXPpuGXipmPU8pn77ZkPOQjDh9GPB4v+w75KcrQ9GFuPzKqm9AJeLmyXlILmKH6HEa9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(8676002)(36756003)(83380400001)(41300700001)(8936002)(2906002)(66476007)(2616005)(110136005)(54906003)(4326008)(316002)(5660300002)(38100700002)(86362001)(66556008)(7416002)(186003)(6486002)(6512007)(478600001)(26005)(66946007)(6666004)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YsC1oIu8+hWAQkFsEI3zbTnCo5RxDY24onOl1xpoKzQuHS9BKfd/5sC4mEFq?=
 =?us-ascii?Q?WehTZC/nOd3HO7O2CZVcB8UJRa46pdSnBcHqco28s9xB1ioPgx+AZljqG9Fn?=
 =?us-ascii?Q?FNORWOlL1JAwyMtB6IDavDIVTC9YN2qNOGJPtX5lLDGQ9OPAngxJChRMiqK1?=
 =?us-ascii?Q?Okw7l71v+VGthg2CIF2CKlIvfkm9vplAB6u40k6POtbE8ca2IGvLfjfu+EML?=
 =?us-ascii?Q?xiv14RkUNyzuHGG4k2rfGa8Df4VhMyttEfoIp8qFxGMbYOWanNgNyFsPYaHL?=
 =?us-ascii?Q?eNn5CiggQaaL2hCTsFnAt+5OYUKgieQz2EJ+wA/o3XcBEcEcqXdcw2azWbaD?=
 =?us-ascii?Q?y82NaAXBO+lhPyauArIS88j8Ml98VtPMQSI54t0tg9p030of1yxLBHHLqCm1?=
 =?us-ascii?Q?CxW04AA+PbE64nb9dBaCqg+Q1r3K7e38D9JGNb8yZt6LXUC4efVwndLMyZ7A?=
 =?us-ascii?Q?lUgKv22YrsNwTV3hLD/G3G0/OcKYlXUrE6EWHuyM6lFa7tATNvT8qs7imKMA?=
 =?us-ascii?Q?sALQy06mW9XQClGr+yd6LGHBlF2nomEDyhHWToCSJD10MGPOr4s6A5sUyaDE?=
 =?us-ascii?Q?14kBsor87lovQbvT+7IJxmHuiS9zxzz/QAtzkoaLdUAgWwtnNlnnhKRV/c0h?=
 =?us-ascii?Q?Pd3chFsngdoZbkJcVG89EWcJqgYWOVVpf9MO+fMJ61p5UeH622jaVgbtZyQ7?=
 =?us-ascii?Q?vp7QHf277tqJ9rixzafEG7b4/3Qwnyet17al70JbtnzATVhz298WqEothDFh?=
 =?us-ascii?Q?5OHR4IKEFKapQZ2LgXJn6YMhdxcBNVKc+itOpauY9oMdJB/sbh7YFzqgZAI8?=
 =?us-ascii?Q?Jw4cekC+q0kTb6YWAANUU3zmcqHoLKDV5Ycl2gd5Tz+9TyR4FvVT18HlQK1/?=
 =?us-ascii?Q?Zv07/xZAHBs0DLXEEso1DGGCmVHJkZVy3oMCEX/z9Y/R8CZcJRdXvfWWai5g?=
 =?us-ascii?Q?KLVCNEDZPNMoxT7wuhZ7IavGoHbGUuqEKg5KJDMebBc2U60KyPFEQF6S76e/?=
 =?us-ascii?Q?4PVVeP9akaPd8X0WQgnrambdJ3aCTt4EAp5DHy57K0voXA+PS66eAa7Mpot0?=
 =?us-ascii?Q?8LNHbv1RpMvs6TvvBYFZijT/n2ObCg6PllIQi0CwrqS6O3RAhDmavyAaOdrY?=
 =?us-ascii?Q?nXj1bmVz2Eu4fXLgjKKF38Xo8UiJqkLFnhNRuwTU8chxiHZ3VtrDTI7lKd8Q?=
 =?us-ascii?Q?1EaNag8+x0tD7Lypt8P5MYCF0KaIwQtLkGg6ne4WS7N/N+fcuuwUkbniG1lF?=
 =?us-ascii?Q?0iG/C3Z7G7wxvL/+AY0C1d7TSopyVL1QO2Z0KgWE1fAJT1cASs2Ri7WJPPl9?=
 =?us-ascii?Q?qFyRIVxI2kA4bPh0MU+tpd3qgcnTIyMjaPwOfd1yhfopMxUT9JzOQm/OYXy9?=
 =?us-ascii?Q?Phf2AwmQfYFSUrpCZ+lSrqAh3tv9zglkrNEtDLoBU2/pB8QQyCMyJ+vWH5SA?=
 =?us-ascii?Q?t/3u8xqb2d0xl4OsOCWtwHGHRSxIPdZVLFJQUBedmSvzcI6E0b9FvNXtBUJi?=
 =?us-ascii?Q?DIFXRTKVS/V092I/+/3+y1hZHDHhZcPxBU58tIkqoCumxkoXhNXGm1kjLOK0?=
 =?us-ascii?Q?JmBIh1JbwW7iVkmQILacRkuSwQvF/kfNCi2kBLYr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b91501e-2a1c-42c1-a24e-08daf97ded07
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:47.1618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2DstoSMCrTqKjo6SEsEuyqVUk/YdC02pAn/7MeZ7gCKjrdJ6yWDp3WDlP8Ohi5C
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

Flow it down to alloc_pgtable_page() via pfn_to_dma_pte() and
__domain_mapping().

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

