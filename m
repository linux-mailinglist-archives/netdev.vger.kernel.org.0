Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6CC678862
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjAWUgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjAWUgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:23 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEAA3609D;
        Mon, 23 Jan 2023 12:36:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPkLEN6cAZALux/38ddeGImxM6JEJT6IZ/L/Lcu5holw7YVkfqkMT6A9HfXCWMbULNJLIwKbR9YCs5/taBH9unWi/gevXbIenmBB3B1Mi656OXYby/rgFogoVNmfDxNENhh645xqvEvXL+V+QxQvbhPVhcGYYTsvCJ7hzKy4hRBEZP2W2/p6Kjs8Spwz4Wh1Gus7jvh7kDEifLKVOkEz+1iIQSvbJwZigY7Y6Sp91hcl7/xM3/M73yLB4egx+tkRVTcqwNILtekGTQAY3x7Ml4Czaevo4e7yoRfKtsAEk0VhCt/8ca+c4URZTdGTdkcOSDpMHjVJ0p4wyb0aMGnafQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OakUpRK1YgGseLFLpv682/nAeC2zXBCu2ZQF53p8P8c=;
 b=LiQPn7gAr6OUkmbMq5FvX7cPrAVVVeIqCBTJFjsFi0tq2nfCuscc2lLNM2xm2q9yMtpuvvSxnckdTqawxIY1Kg4FXC+T9cPTnvedyE5hR/5ac4Mg/9dFEOKmzaueIlJgNWK+T/SQO1dRVtTAGVUeTGN72nKHtfkFRID4mccprwpKPiwiqusQY5B8Wag9FgGp1KBVZqf5jbks/3E3tyxR5x11s2IT0DLeV+IkfBlqLjv1JLtvjeQABwuhsTT30IYHCEYNwUrlINxUTygysbTv4SoPpthRHPkrN1d+El8MZlr8JwQN3snizrkFN99tiMEnX7vHB9HI+wWMRKzK6uOJog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OakUpRK1YgGseLFLpv682/nAeC2zXBCu2ZQF53p8P8c=;
 b=rm76RhBpZo8ApOYammvP0mQyd5nUi0WMQ5yekoWaPjGAsY5MwpKVskuuEh+Fa3p/RqUgEEgX4QORp+ZfoYS4s2tVfyLMcpBWW2Dq7Cj2ik409AdGJtCJMyLkrLidyZoYozDYmumOK9iR57VMXc94imFbtm/wO62bR7NJ2Q8jJ1Efi7nXlN/Vo5GpkXPDueH9E18iLT8TZHg20gekUY/kleIOzOiJAXBauZR4DK9pq1FBPCmw75umx2JrZu05JsSxvnvNSaVRKphUzKJUGMX40PWUlLdP529yUTTqHtCm7zXIJR0hcHumE2g64meMaG+VfqrcudAFyy9urxF0YTeOLA==
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
Subject: [PATCH v3 06/10] iommu/intel: Add a gfp parameter to alloc_pgtable_page()
Date:   Mon, 23 Jan 2023 16:35:59 -0400
Message-Id: <6-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:36e::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 49012f85-fe8a-413a-0b34-08dafd8172c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PM5nPKuFPVSQktsEkBm7kDJ3S6860fO+uLyVjqhoXqzhmMtTevLXd8r7Ef745b05XKCqfsc9eNK67zka6mDGq+IXjwTIKob1izmVfAUiMw5FmsZg83ePDwrLOjZIHyNX5Ycvcmg/I9DD7+3rmkky2JOL+jZXQzndIvYlaaGTJilEGCHkbFF8pcHIvcT+sIut04jlfG9Mm/i4K1dLLYFWK5J1bb+UfKbcrF3o/Zq6SwxLZmjfg7tkd+VGL4gfugh+E27f4yMlolqhrLDPbkdjOSl1lssspvyngDcM2sv03nJfV6qgATH7hlEGQSLmrog7ycRVovLuIAzBmHTNqLBGJBTzenADmm9jLV+ykl1cQhtXv8UrNijDhJRuQNyM/WfBZXoTOiq+/yE5FvzLKlfMTMwjJxPYo4a9JEyC4HZCoFhEWRNm9VmAh6vFayqjYHwC45x44tzaSmsiu46GO1qjSrp6Z68XzxdmRbIUjHHl2xH8cSplDR8Tv+sE8gWC51OoIqXGCI9gq5+dvjsLM92ugpC2q5i3laxXAQcWLgfatAXVlfKHUQ3TPGv7iBlCID9ve3Z4jsJiufdY3yxwA2m73Ki8a7TN1mikxmY4E6idBGLHpBV5mjkVutudVqc2hg4Jj0sNRVEEPtsmTgp3z5u35E4q6ZB8gstoH7xOLaxqy+RUuYZrgtMFVW3avr4vezC4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZM2p5glgZGKlAaARhi/XH8xBDSS8mBtT29V5lKz4IBDLsRPVqfHojcaSBcqf?=
 =?us-ascii?Q?ZR9MZ6+QI+T3LiAmvchOO64anmIJmHb13z7ujgz0RWcUJdImXauEnzMg2J+o?=
 =?us-ascii?Q?sLF4HbPRFywTeJGH4JuXxo5DiWU1Fpc29GkV3qCO/blfoaSWDD+AdNMgLlHN?=
 =?us-ascii?Q?bh8aM6FiG2415VE2pZMBvI3G2ZPODn9AecM9MJ8C/+GcaltgwHVPO4RZ5qTW?=
 =?us-ascii?Q?UmAYKRoeK2MibTOyXNV1e+9YGPo6jvz2ol/0rXZfcZDh5rS/+3Eb4q511+tU?=
 =?us-ascii?Q?bI2BZxxosVIWp2URWBGxxHPXzseMwziKfqbX1y/2WdqAOACNd4tAehtMKlwj?=
 =?us-ascii?Q?eJqK5+kEQKhk4Rz0H8fJUPRgMRBVt6i2/i/UdTrcfGQtM0f4mO0WLwLozy0X?=
 =?us-ascii?Q?TgyGITP6+aYx6Om280FNy2CRS32dcW0CWvBkIu0sBy6A++OgTH4+3YzWsAHW?=
 =?us-ascii?Q?k9Jl3u50+Xc+34OIdcLurCkm9rQp6XCsKase7J9DDGqhLIr4h25DXpUwdROm?=
 =?us-ascii?Q?tV/2dV8V+nbkclokkqqqvixsQgeeVgrJlfwjnIk87tRC0JDo7GxGVvK2cD/4?=
 =?us-ascii?Q?b5QDw4GnIqbT7lAisJfZ/DLWIc99iu6QLxEAcraOu8y9CyknArHHmVhBA0oR?=
 =?us-ascii?Q?/3Mt1jScqcg+c3KgItmNcr7RqeBhQG5KLN1eUGkU2NPBQi3lTCIMNM4y23JW?=
 =?us-ascii?Q?w/YkoWvZsE3MbyQPOZHP3/iCr8jYBO9Z/b7PPhr/CySQjiS/p0Iorbuimt0B?=
 =?us-ascii?Q?rJslzP69tzXVZHMTlZGOofMi9+qYUxyiz51l3tMwU3GnKNcSsnt3C1l/onjy?=
 =?us-ascii?Q?Y/o0qw1cK4f0AEwdZ8r/EmESgbNevBax9FDSYCV7trb29d9NQOMb4J+LPXuw?=
 =?us-ascii?Q?m6Ia73MDRySuih+5OdiPvdO2/njdtbgvI2OXcmqGUgjhZ5JwHx1dvYUpAlzD?=
 =?us-ascii?Q?/1n91yvuZ4KXx13SFpMjJfhurU7ZMYJRBKYgWOtC+CNrPFwWy01mV9tVKZQm?=
 =?us-ascii?Q?7IFrNpGknNqsf+E2WXtAqZOcvjkfXjAuX6MZmobGWpuw9vGNuCmORW4HyKC8?=
 =?us-ascii?Q?RweYz0ZpyFfXiAwWSiqqyE+W8UhgPK5PYdN2I5+d8JGZTAxBUnBbdKPl55LE?=
 =?us-ascii?Q?3Ez0/kfzNomyVBJv4x+jmpSxHgkSjW3QEbtVn+FmzdLjWh8L4bUOAhnFdgYF?=
 =?us-ascii?Q?KoLuujnr7LxlmlgH6ao6yJDj0OeGwL5CsclUtz3MUVajxdikGmVTjezhL7Cn?=
 =?us-ascii?Q?8C8uT4RuYlMJ4AjnjiAtVWAUBJielt3qceMWJLgzSAJsyhHHTj5bwF2pZnuA?=
 =?us-ascii?Q?c+PejSQjSAB6yU8ZVPJe53uhxqzh6x1ncS8BHIli2NIF+0b5yuX0F88CITMW?=
 =?us-ascii?Q?saaFD3K92PejOw/pcecYkNe2MQ32aO9VrlK1seIfKaN63z46lmav5UQPQAS+?=
 =?us-ascii?Q?kCy9ZGwbL82LGO5Vg17QgzhCrXRD+EFSOO9OpoqYWMMFMiImPjSGCQ7J5AR9?=
 =?us-ascii?Q?8nXdMgzHyC8b5uW2wkOJWCLwMxzVhhyKlbwQFVVKgAdSh++u1+Qp2nVyJo1t?=
 =?us-ascii?Q?gYvXghWVf3EH1NL9deqsH4OKIAGejYybD+didjWp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49012f85-fe8a-413a-0b34-08dafd8172c3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:04.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEBVz36/YawU11+A/NcI6xuGVrTRRcXyOK236jPlDIX62yEyjaKghkQUxF5tWGFR
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

This is eventually called by iommufd through intel_iommu_map_pages() and
it should not be forced to atomic. Push the GFP_ATOMIC to all callers.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
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

