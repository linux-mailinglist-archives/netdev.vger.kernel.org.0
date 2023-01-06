Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFED36604F7
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbjAFQor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjAFQn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:43:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A47CDD1;
        Fri,  6 Jan 2023 08:42:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr5EmxyJFb2rB/U4UA1bhSTQ5z1GVTPzulUz61WxjQXWyvmgIJ8r2zAdi3gNeXXz29AQkZHLqNX9bxM7KG/90SiO8ro9rRgIGsLEgq+dRkRedFarmnDf0llb3YiZ5GOteAsAqluzcwbjewTtdXUkQ5hJM/S5WV/r3dzF/crqQunhN0pF4w79thiaPc2Lhyjeu7ggRXdGsZ93dzvgmArwo2VewpduCmamxzDS1X6cIbH0rIYnD6GCSvmpyNUlT6/ZinvQk28/3l4sFPxYL1juVYt39+bvLSRQ4Rrx1HpLiSFvwd4neKv7qikPFaqeerWU7o++7eupGrva2HTcXDOoRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HigpJeFWsOlcgebaCKqaAynZtfAQbseuvE1UgD2HyI=;
 b=QAT99uQnMFHJTztTIjHCMvaVrtb1IG1ZRoQwp0sg5JHwa1nuMagvKYAOcM1QJHROvsq4UB33+4SG1Z+YTG7Pc+Ws32rTTH0HBPFQuVGM/4NI+jHgWaWTD0d4AXgsxt8+UTsW8oQll0ZzyWPn6lB06BZX91zfVEZG0lQq3oJEljZNRWo1/6XhpsyB1SqsWKKnObeem3JEnKbf2XOUocmGF9b9KXhnAQpMkKKOMsFY2HOMywyDKnJUrxUu59HYUen9HyEyTCtfhHvNGQy3HcOOmFjCvdxKq4fM/Z8iUzpfGNsoh5up7nLoEva8jQOx/2L857NKNKcnGGtImzG6aAii+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HigpJeFWsOlcgebaCKqaAynZtfAQbseuvE1UgD2HyI=;
 b=TlIE/5em2EpYFxRbcn29LdYllmDHc6uPYVxnl6isTIz2URV+ey1ZTWLZxKXjTjHeVtX3vkPmZiFPBoimRsrxUB1Tx5ca+KfTu9Xtez0aw5yEMgNN8Il+aAWf3//+9DXEU79e5wRVveiwf7hiNba6x5BD5MmqX654a93j+PpTtjU5ipf5oZ0Dg3GZr9UiTQt+51xmP0NjfGqdsx2E+yuVvuDyvJlV9Kf0pieaPDwiDR1gwoPuw/cOyxh6+YkhpBk1ngYca03g/4NlZCIUbsHQ/O2j8JxWeSt2NiDBFz+A7i9ehwcI9+hmAc2wvtNRR1g4j9TsVyB/ifeuAihdj4L8sg==
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
Subject: [PATCH 6/8] iommu/intel: Add a gfp parameter to alloc_pgtable_page()
Date:   Fri,  6 Jan 2023 12:42:46 -0400
Message-Id: <6-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0098.namprd02.prod.outlook.com
 (2603:10b6:208:51::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: fe172e13-c294-4ba6-30e4-08daf0050bd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0lUnMCVcSzH1Puv6yCloCgczl2NXeOT3sDWmIHXgWGKYy0leJ38S+jGe89KW9EXQ6sEnS7j8s+YNxu7/AvE0QQvZiz04MX0nfQJSTLv2ih6n0IBRBQ7KW1y3kGGUuH3/Zode1/2egtm9NS/WozTWJUfDPbTJ/ht0DXder5jG+meCN/yJv8QMoO1k/LEW7SOOI67YztQMO+CJ7v5BMTl+cpYmY7odDFBVzymlpKvkR1lNw+Naesp6WWiUBt/vyjXQnH5ifDxiOXg0C64cz6h3pBzihlrPmcOrBb5R5huR4MoA7b2DLeBrt08mGqQwpUqsckJZVZdQKvlmMXbljQvXLGWdGoIKSkbtXy+V93xEQNtu5Uz3oEXxye9gJcH28nBqsqfqnxqU6QKQevNeeDJC3sKtWbw2PfAeQyY3L/rtduSCRkKh0EzV9tue03mAiAACc/Rd2ZsCLUDc0VXzswm0ff8rCqeiM2XIXUaDDeZG5a903PJB0jJYZZpw0p/Gy3bfLt8n11XLZxVIbVaJVwCzCVkpOJdZII9ySEZv1BoNROD0wXcfoMjoxZ2EWZVzlb9sQbdYwekcb9H72OJcCCwiboHsUNo4jtTkJxOKrlGoyInEswElKtMXdVFLDNgdFRY43GoEfjLIrYZF5x+V0+mATRQhPgtayuHdXHo3b13dAMHdAIj2ABSTH8rtNiNlX2h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(7416002)(5660300002)(54906003)(2906002)(41300700001)(8676002)(66946007)(8936002)(66476007)(316002)(4326008)(66556008)(83380400001)(6666004)(478600001)(110136005)(6506007)(36756003)(186003)(2616005)(26005)(6512007)(6486002)(86362001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3B2UKqPd9l/UhHfozua1ChXTLTNNFK2rAcnbiJrwpgtq7en0fU+ZwwuZzDqv?=
 =?us-ascii?Q?SV8K1/H7Z4Dvd3GdRfpM1QqZJi6kr1PZ8QhVQ407KzHx2rTBcQiEL+ewLutF?=
 =?us-ascii?Q?yyWjjIMobCs60fxIJLurCaEBqbfX6WD03og6MT5ixLKAr1OkR4wqV+8k52Sm?=
 =?us-ascii?Q?zRA0NSTUUF/wDR2DTlu+nRurnK7T6VgYbWMoXqpPAX8l65FnEFqzaRekBwz1?=
 =?us-ascii?Q?qTT+GTiFpl7NAUPVH3uVkolBeWimBmL5qCrEixMtoG+K7zRPbmKrGPBkpfA/?=
 =?us-ascii?Q?Mci12GEvZ1+fAVG22gfxTg/qtiIA5FAMNBgC+VTLvJaG1mi+vPpn+0+PSdI0?=
 =?us-ascii?Q?PGvAIXg5X1H6VlJX2dMgHFkfaJF/Bn4WdBuxk92eZJs6EWwE4+TC6KppovsO?=
 =?us-ascii?Q?SsXJsT62qDZEjMvtwnbB/u+lStc4FUou8p5ywclCOkp1pxhMNv5ttYzWg5oX?=
 =?us-ascii?Q?H3NyxhbXF2K6CRJgbxSe/kekxTBFL4JAjjzVplhIUkelCtuSnZzGG9VteqNY?=
 =?us-ascii?Q?deHy6L5AMpwnxxRCGku19s0fz/RvZXVnIWaK8VCJRrHf/ApbAfRMQyo5XnOR?=
 =?us-ascii?Q?I04dlgaOGWp5f70rHtY5Uxv1cdaGfCBvLlo+LqkXj8lo1sLo5hKAIp5eRFnC?=
 =?us-ascii?Q?ra6xJDeokguCfNGGmrInmy6ozJZeGoHFlue83m16j0zgMPBJauTjP77zUZe9?=
 =?us-ascii?Q?0ffaYxZeCyIGWusHaSmzehMU5PpLv9ImHYF6YFE6KrSwsyT38R3jUuB8syEz?=
 =?us-ascii?Q?D+NYML+WM8OLqdR5znJKdXUecZSl+egNYldS9DkNNxp/EWNeqdbhE12kgu+e?=
 =?us-ascii?Q?wZT27e+R9eSAablO0Q+GZvrGinhRcCdnSX32hWD8NSj7WUrTgtWbgfLSTUqn?=
 =?us-ascii?Q?wMXIa8rK5RVMnjHxMBmHEu/vCE2jcCZIly0dRgNUlpe3Ir4+H+p6f0DrVeJ0?=
 =?us-ascii?Q?UqDeAUWrsttaM0QIJtYJ9fKbj5vtYcCbUoSG1EDr/ANijlLkhr0ZR9ElyAMh?=
 =?us-ascii?Q?rR8cgIn8Fwgck7IpoLSN2BiTUN5/UUizqYVjN7yDNKq7YHK4zH26W77tv15r?=
 =?us-ascii?Q?dArnYKlABbaSG4zGJNHKmD0N9bY2uehEk4IOR3Jo744pOQ2zVb8JkbIizJD1?=
 =?us-ascii?Q?lCDqptR9balA/EG0oFZylWuEjUB0iPv6BfKHHx01W7C2nE1rrwxM4hGLXrG0?=
 =?us-ascii?Q?LpZa/+uX85MdZatGvnJGpNgUdHnkcgWOI83eKbMmk7vmXnTZ04Hbo4g5pTrT?=
 =?us-ascii?Q?SJLTu73rVj2dV4+LuCQbI6aG5Cmu7npq4FlN7tEHgrNyZP4CYHCRWv3aMxPD?=
 =?us-ascii?Q?n+nM6RgW60juN+0QOQVm6AhCgv+p5C2A4Dq79pY02BXjgYeVUOnO8hdnBsdK?=
 =?us-ascii?Q?p/+opo3Ku5ygI6gIK6BQ4RoOoYa6kxXegrdAPzYTGeAlaM6SjaXO+I/BgUSM?=
 =?us-ascii?Q?yheY0ROZW6cOClo4cwRbgFXsRGp4odOpNSXbdZcv41sMqUIYHAwEgWYUW197?=
 =?us-ascii?Q?+Evwx2G5APEhHCqbMZmYTQ30Q9kndlXMW0JKp9TjXSG+Y6s8TKxfvJ/09NwX?=
 =?us-ascii?Q?WmjQk5mQXZoOlEFirMylUdvIsgAkXUvLy28U7lNP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe172e13-c294-4ba6-30e4-08daf0050bd4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:42:49.2335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBSEZC6JCTwd0tc5lSbCcrdkGVZfydMg8uYREbqLlc+ZQhEOuEsixyTvigoRDuxd
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

This is eventually called by iommufd through intel_iommu_map_pages() and
it should not be forced to atomic. Push the GFP_ATOMIC to all callers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 14 +++++++-------
 drivers/iommu/intel/iommu.h |  2 +-
 drivers/iommu/intel/pasid.c |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59df7e42fd533c..e3807776971563 100644
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
+			new_ce = alloc_pgtable_page(iommu->node, GFP_KERNEL);
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

