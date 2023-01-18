Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0196725F0
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjARSBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjARSAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:00:50 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A6C55290;
        Wed, 18 Jan 2023 10:00:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GI2HIIwK3zS9S45jwmETnOThJouM5GrGCy7Xbk0ulvnB35bNAKDPrhPxWPLb7TX5BuNIkXSJsuWKc4jtrIzlrSuXou11iQxGo5C/e3dMTXNvaDNkSSEbI13i0Rv6GsgWCIjWV8KJXGar+onRKHQOG1V1LVxeorZ1WJ5+7S3/EFckff6aKEbwnOuzJFKL74CQ4mqUQ81wwfJK9xerW7iGJq5OR9uEAl4LhAtn+iGRzMeiBsYatGIt9HxM/mf2YxMTKqnWVzENtbos47vNS6mzapNNsj0rNu5ryCeePFOPyjgaaKNr/1upWMQ01+r7QPYIU0Cwr2SF+qbpFOj935XxQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEwQDOFR0TbCX7RF0Ze8HpmxiFAMTveYfslQp1/pNBc=;
 b=bY4JWBszQpIab5JX7lLIoFMMPQWFS+2rxcyIl0J97PCGzUtKBCeqETG6X5XyCQJ13SKt/2Ley7WZU6jn9I/vVLVN0JpXekaipyNnakY3eXLofCtYnxm1fQgMf6rKf1GTYaN3e0Q/zdJgZcGEc5jyfzlSVXZvev5BMPXx9D3mvmuSbU7Iimy6oYpfKER4I9hBI6PZsmiSPqwm/vwGtNBkaf2rvmdIlwHfAkvUhSfeCsVJCec8O3IGFJOFpw1ZuFiSC2anPOz31EQs93cF8tGQ1xE4X38rTG/AdU40eEloTVaI6cHl8STwFAFPqkl+kscrJltDK8qVYvOhBogMDvdxYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEwQDOFR0TbCX7RF0Ze8HpmxiFAMTveYfslQp1/pNBc=;
 b=OXpekDgKH+SYgcCWy1AXVS7cMTLRawijZmDtr8x8G6qtN6i7sgE7OoR05OD+OKC+CvOhXodlhR9ukLTV7XaMzTTRvvY6ztdOeI0Fgr1Sz5VZMvguiyCoaWvgNIWt+9uU2uyFQM9zmKkh5vsfCVWAtvPnRtHHycOb9oEyWuaMK26B5DuivYoBkS82poIU/KD25p47wi1Zjd7BFcVNRbupSAD50yQLomkYdAWX+PlqZb1H8VTiT7bApY0IYFD9NLLG1yBri5jSR0QIprDRlBYA+QhTqEDOX1y4wvCnRAqTZilBpxteYoGQ2HPh42KhtQjAcYLJfsbMQbtOk1LlE5DgLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 18:00:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:46 +0000
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
Subject: [PATCH v2 06/10] iommu/intel: Add a gfp parameter to alloc_pgtable_page()
Date:   Wed, 18 Jan 2023 14:00:40 -0400
Message-Id: <6-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0133.namprd02.prod.outlook.com
 (2603:10b6:208:35::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: c471ff53-6006-4c87-612c-08daf97dec08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P52R8Y79yja8EkhaUvF8Xv7rpZPa9bIDC18Qb5n+6s9m/kYptY4S78DIt0f5zQTAhkiSIN5YG86uOkG7MjCvnkrwc+8PDKZD+L85nTKOZBbRIz700Iunb07fMousmBWgYR2LwdmoH1i7uux/xXSH4uRmSlqz2RgG9/98d4yg0s8LRHg9RjzEdW4YQpN+l+V5+w0iCih9suDdh3aPnoycFmVY1XOsnvCUuSfhwzfxiFVSnN6aDRhejjWel95mIgg7C+yxtBPi4RcFRz1rERInnUhjIdzVTZWmDPFatbE9XE690NogG/sq0viCzkKS5ykMkXCPp3M3GZ0b1Cm+Yfxz76clIoicv49m+1VbH5Mamh0h7xHxQkm+gqq6+gBPWV49fWLonFLTEqld0FsPXmvKj3MTuG4GMmlLYMYJkn4aIW6W2I/A8m9GlGk+XFygr6+ELTJgXXsCKfyQQc1OP4MBvEyhCm16XObl0PCMeca5UVwcJU5VvPg2+VHw3J+JT8caLWx30XnQ2jDnMwt0GITMKCuijxtxq16WU9H16PYeYiFWVcVtL0avNaaPb+0uEywWk5wiy0bHLdhb1dZUphMYmk01pa2KnaKSbsI5UrcnzeN1Ohf/MaIeKzHzPvMIKk9k8KDiFk6SnK42DseEyuctioowTE5V0048oiq89wqO1dlUMcE2f1qezoglPlq12a/P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(186003)(26005)(478600001)(6512007)(6486002)(6666004)(54906003)(316002)(110136005)(4326008)(66946007)(66556008)(8676002)(66476007)(36756003)(2616005)(41300700001)(8936002)(83380400001)(2906002)(7416002)(5660300002)(38100700002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j9B+qfr2ArgFXUux2Hx89VXIRx9EA3GG6tSWqdkMsDGn/qHDlONRkLod7wum?=
 =?us-ascii?Q?BeswYpt/RImPc+Y9Y24PPe00826/ZwFU2NTs4wJi8CbVCt++XIivDp7Eb1Up?=
 =?us-ascii?Q?eVKvUAZveVwbS0RnjRIP9JqfKtk27wkRvJ02/FF6uHQgtoU0TlUKYxUejWgN?=
 =?us-ascii?Q?GzYL0dgemSvryvq0qUIom/1UHMBUD/luLls0DkcAcson6UxUSYz0SLCald4o?=
 =?us-ascii?Q?C+4z2W75ZOeknEe6PFhzrf7u9wbYwdUp3O6e5Mnu2kcHu67NWbS8At0LI1mA?=
 =?us-ascii?Q?UeXKaHgLlcWzgvEipUlALKuLgsKe1ZU9LGX87z3rSUSlgRKATM8edyiI1bOA?=
 =?us-ascii?Q?2Oyg0/wU+LHilCcT0twf7VoTzagaATcNW5MyMXnM54qE7DVNEpajoaJgztBM?=
 =?us-ascii?Q?IGeuOoYpDBMmnOi5k9QQBHB+uBa6R+6WNFCaFxBMnDVQ8oVi+mzGy45c1WUT?=
 =?us-ascii?Q?b5RtAGpWQJMV0+6/bUI1pkiw84iVL4cqyYLRyEy5wufQiUGmT/hBWhcKDoj/?=
 =?us-ascii?Q?OuDigosVa4s+NRxDB1sDr/fHQSK6S28+2StzUQfF1a48eStLSXpaIoMBpVE7?=
 =?us-ascii?Q?JJXEPoeNGidHbkCCS5yhfLBykiJU7p50zswa/G26ey3aaFRnVbDb1abQdrlK?=
 =?us-ascii?Q?DkMNzg+gxL+NkW0YlPSpeybPRaXs6oPMAreCJu5l6LP5YamHekac8gRoSiYt?=
 =?us-ascii?Q?xhiL2+Ir+zcimpc77fAA/InGCcoFOVhmbf54AtNDJ3tcAF0nq5CkOUcz7q96?=
 =?us-ascii?Q?6OYOIXxItLcFjqbyHgwQBw8KdEkwIV1TqDeBh3zNhgywlFPAcJc5K4sKcAXu?=
 =?us-ascii?Q?kS6ly5pZfZw7NKlGajh55YBG0NC1WaSsnpi5glZHiGaPaMhXAfLkM/w94r1i?=
 =?us-ascii?Q?LUw3TGAJyc9aWK1R/K1/qAap59tzD+kN8cpxnxs/UZvM/JF1tdJ7HcfDN7F9?=
 =?us-ascii?Q?P26WFfhwiDsNp7pgqcUH5/vZaUwWaK7YvZy5x6v2PRyp+D9cMnnjGkE7JVJ5?=
 =?us-ascii?Q?Nkp3T6g3EpPc8epEl49aF4Jc0NQoFiIcSBNs6jWtEJrwrU+tQN7reUPHNEyn?=
 =?us-ascii?Q?x+TUpDumFKgSL/osro9KF7q+Vzemr3CbxxFRLduBA4KjwXydX01YmRC3n5V0?=
 =?us-ascii?Q?jkScULxXZBMq+wUQv2jDuTE7DxcTYTIFvHflmXkuZbTlVBXSQYW3RlTXg8kJ?=
 =?us-ascii?Q?lFmq1S7yp6cBK7bcDzDB/UtJhB3R2tysK3VITaWnfb4QB4j182qRMUE8HfSp?=
 =?us-ascii?Q?NplNTTt9vqZbNKUbA9yuLILDj+4FHnmrDjn2rEyXcvYGGLzI1tbAdxeSxhcn?=
 =?us-ascii?Q?TS9TdjJqU4boTtrpWC+jgEiBpAH48UDng6g4OgydfxJsGl5GCCtHzj3T/KSL?=
 =?us-ascii?Q?6P9ac0EvbemG+VhmopRlOeqyWI+34s2A1TAi3oJS98OgsTIP3ATfTitle53s?=
 =?us-ascii?Q?ISTxAVd/DMf1DLR9+EcOGYd3s277r7ia3Qwr6F7bQZ+s/85Qzlwsp4wgaZ0k?=
 =?us-ascii?Q?d4EkRMQaHeY+bgHsbRhxlVaYHONDQitLco3oMWeRkXHQlRGCmf6VKjQlNugs?=
 =?us-ascii?Q?84uV+rXEYU4oLY3CL/SrVwhUW/ILvSgwwPHthqiM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c471ff53-6006-4c87-612c-08daf97dec08
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:45.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eR1G+sA4Vjr3Bbfb6ntV31Qw8QZTtT8TraOFac4JpoKqOYnzmVKt6F4lFVzsknd0
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

This is eventually called by iommufd through intel_iommu_map_pages() and
it should not be forced to atomic. Push the GFP_ATOMIC to all callers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 14 +++++++-------
 drivers/iommu/intel/iommu.h |  2 +-
 drivers/iommu/intel/pasid.c |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59df7e42fd533c..aa29561d3549b3 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -362,12 +362,12 @@ static int __init intel_iommu_setup(char *str)
 }
 __setup("intel_iommu=", intel_iommu_setup);
 
-void *alloc_pgtable_page(int node)
+void *alloc_pgtable_page(int node, gfp_t gfp)
 {
 	struct page *page;
 	void *vaddr = NULL;
 
-	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
+	page = alloc_pages_node(node, gfp | __GFP_ZERO, 0);
 	if (page)
 		vaddr = page_address(page);
 	return vaddr;
@@ -612,7 +612,7 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 		if (!alloc)
 			return NULL;
 
-		context = alloc_pgtable_page(iommu->node);
+		context = alloc_pgtable_page(iommu->node, GFP_ATOMIC);
 		if (!context)
 			return NULL;
 
@@ -935,7 +935,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 		if (!dma_pte_present(pte)) {
 			uint64_t pteval;
 
-			tmp_page = alloc_pgtable_page(domain->nid);
+			tmp_page = alloc_pgtable_page(domain->nid, GFP_ATOMIC);
 
 			if (!tmp_page)
 				return NULL;
@@ -1186,7 +1186,7 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 {
 	struct root_entry *root;
 
-	root = (struct root_entry *)alloc_pgtable_page(iommu->node);
+	root = (struct root_entry *)alloc_pgtable_page(iommu->node, GFP_ATOMIC);
 	if (!root) {
 		pr_err("Allocating root entry for %s failed\n",
 			iommu->name);
@@ -2676,7 +2676,7 @@ static int copy_context_table(struct intel_iommu *iommu,
 			if (!old_ce)
 				goto out;
 
-			new_ce = alloc_pgtable_page(iommu->node);
+			new_ce = alloc_pgtable_page(iommu->node, GFP_ATOMIC);
 			if (!new_ce)
 				goto out_unmap;
 
@@ -4136,7 +4136,7 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	domain->max_addr = 0;
 
 	/* always allocate the top pgd */
-	domain->pgd = alloc_pgtable_page(domain->nid);
+	domain->pgd = alloc_pgtable_page(domain->nid, GFP_ATOMIC);
 	if (!domain->pgd)
 		return -ENOMEM;
 	domain_flush_cache(domain, domain->pgd, PAGE_SIZE);
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 06e61e4748567a..ca9a035e0110af 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -737,7 +737,7 @@ int qi_submit_sync(struct intel_iommu *iommu, struct qi_desc *desc,
 
 extern int dmar_ir_support(void);
 
-void *alloc_pgtable_page(int node);
+void *alloc_pgtable_page(int node, gfp_t gfp);
 void free_pgtable_page(void *vaddr);
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
 struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb3c7020028d07..c5bf74e9372d62 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -200,7 +200,7 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 retry:
 	entries = get_pasid_table_from_pde(&dir[dir_index]);
 	if (!entries) {
-		entries = alloc_pgtable_page(info->iommu->node);
+		entries = alloc_pgtable_page(info->iommu->node, GFP_ATOMIC);
 		if (!entries)
 			return NULL;
 
-- 
2.39.0

