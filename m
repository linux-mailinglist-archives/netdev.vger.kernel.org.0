Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AAE660501
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbjAFQow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbjAFQnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:43:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47E37CDD0;
        Fri,  6 Jan 2023 08:42:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxX13QTs3SwIX72p0Dcyb9ZT48dwndwX1Jo0M2SX5IuMehGfI/nJPztS4kY+vqAmD89LPfEDvzVXuFHj1nrceRjmlflqoqHa1VSYHqFufmyRNwz1RThz0HyDPG2fW8qXE8akVdkpnw/zt2kigP3p0omL/IjBMVm0EvBNdOSYRLGZEjiE+NNlWmgGb17CzdqcDGOFIIg006vaMkhJbfdN2Zh4hc7uo1xBoLn7Pps9SCe6Y8dMsRxY1LjDPJuTwY0nK068QvvD/o9JgrkCJbs7TNKQvU9NGtEF5UMu4/cnhHffK1GEAHYHhMJMzUunv+qApwVf2b8/VoDyrHFZNYoZ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzG5H4TYc4/7qSv+sCyigoBtM53TeWCoA9jDKKuj2uo=;
 b=Pw8nB48825Gp1Lue95FJaeJWGP4L/GBTHtTDD88ikRvODFD/wvdbda25HjGqwYBohS8hyqEJFjms1SdXpO+R4VV17aaoHvKn/dF0mqBVfmpwFAojKDpmuQjw2i2RaW3JOCaTapN82A+PGfSKQWbVGNiymItw+TatnxKfianOjQW66ncrZzwH/b63HDMAxblDaA8lzhQJRRnf6FU2VbXQdXrpti1xpk/sIH/gsB5TutkY8wubxmYXqZP0Azb7l5MNxniV9wjbf2HiUFMRjxbutiHgd+R64eyaXcuCmcAW0tTmMC4gd0Iil+C04pZanZivajTthn6je8+NunNqnHvzbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzG5H4TYc4/7qSv+sCyigoBtM53TeWCoA9jDKKuj2uo=;
 b=WyY1TjMVJnlz52coLQeHeH9IznA7WtTmrFyNfjKdDuIoN7WGY8aaC/Js1PrD78O4Qro0koGcwQuLJ2RNDqd//U94QC+edzgI5SHlKJza2pRIbOpctWhrSa64e6xV64U/NRpK/1sAws4dEzALKWXZiZ4p0euOOBkoNgJ3N5OCrrxYlCKYbRYfXlZaNGYdXH1ZLUTo5iGELMRRB17HjiKhUWYyp1qWidHOsDZ4BRImzFNaHkBsylxS5yHEdbcjXxgsp8rhQoGYSj55u/71Y66moL5tQ0KoGBY0fBCxzZXP20o2d4SmzkftVEDekW4qbcAgNNoeNBbZ6fI26kDqmjpv2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6437.namprd12.prod.outlook.com (2603:10b6:8:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 16:42:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 16:42:52 +0000
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
Subject: [PATCH 8/8] iommu/s390: Push the gfp parameter to the kmem_cache_alloc()'s
Date:   Fri,  6 Jan 2023 12:42:48 -0400
Message-Id: <8-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:208:fc::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: a0017374-1d4e-494e-3c18-08daf0050c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhQN2tDydbCVLbhZ93Se++51k+9xCzhFbxHRGUavBJji5EpqwM9abcbsF7V0lzTYHcnucm4+GxrnaZSKNTOWYweqB28MEEVITP40FJ+9Q7SrUFeZAwdVukNeGTgNa5C2GYXKGeiRS8okwrz95MqRBgPgffNlsOnB6tpTX3puABx6FgEEokb9MvvtD19MTYLIThXfrbiQ7fFFcTrQMhvMbhA1P/kTGykB58Ig5S7Qch+Do2ivTlnyuk3wyGiE2VuTKd9ClLMfNacvr9B2zraoBA9mc7Y1SsNZNzrpL2ta/FJQzotvhwF6eQQE9+zcZMccQzk9Vgk8+ineqFhThWWjP22SFFRibPd4gv86NF8dW+YHlc2lBgeQrBCKatHQMyLnUBRwyoNSsVkA6QLKqxYWmDDGC1MIqYoYZiyT4bFY8+rW7OlFBVa7ignf/iiMGBbeDTLX+NMPWW7GXXyZhvViw2Rp1tZnIhOTvH0d6gOyAVmU/9M1LXp8VtiuxDfo50kxenPwQqh8I2ojcsH2VSKB9bswYcnjYb0sotdtK7hTw0naUYV+xk4wsTkd1GhUu4xBEGpFlVSZwHqah5vCDIEQE2v6RCFKIt10uU2SvH3tOYNTR+J9/HBpa1ienutudhs2JsOrxsY0swbL2Dkae6ai1Q0PIhvGX4xPt3J0lh7sGQS90+/t9zC5J1E0Bo6m3bjY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(7416002)(5660300002)(54906003)(2906002)(41300700001)(8676002)(66946007)(8936002)(66476007)(316002)(4326008)(66556008)(83380400001)(6666004)(478600001)(110136005)(6506007)(36756003)(186003)(2616005)(26005)(6512007)(6486002)(86362001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sc5MxYePZ38UOERpbfLkiFylsIZuVor4DKkdlwSgsWKdtdRNjboiT7D2VVA4?=
 =?us-ascii?Q?70ECVb+7YVZNcEd/rpY3fsAYKJZdHDvRCxqyujDdrfDQcgofx7lR5Lom1Aek?=
 =?us-ascii?Q?BF1jDR4ok9WRQmIhusgec1qtLDaUfGcrZXZFcY1D7L4lC6++buac6PDHpJ+m?=
 =?us-ascii?Q?gHvomrtIOB1UO38R894mmdPJZzeycTebpVIdQDfBIOQfxgocNtVBvgTP8qpV?=
 =?us-ascii?Q?y3lBx/NsUNYWpUmuBZOjzarydFuA0eF/ytnRzl4kZAOoUtTuSOE7WBBPW/au?=
 =?us-ascii?Q?y6NwoO1yLzwcKr5JMOw3VnL2RIdQIxEwEDw518bTsmXHFba+8tSOb/OkEyhT?=
 =?us-ascii?Q?BAXVX4/OrDlKOj+5x8qrNwiWzFSJytCDK2oxd+4oijUaf3ZzNHmshuHpShIb?=
 =?us-ascii?Q?e8S33dAK3hcmohqQkygAM/0kbo5rI1aZFyBa7TSx6fz3TlSPPk0+Joqw6Wz6?=
 =?us-ascii?Q?ZaQSDhyUQ1ekmgTcWYmi51h5K9OBAGwGvyRL8SgCSlXmhi4VlupSyRLF4J44?=
 =?us-ascii?Q?Fn5fTqJYvmotixmgzU1EzpqOxS9GIu4/937LK83J57aAs3GXbl89NcEGgEs7?=
 =?us-ascii?Q?53baYdZtFtbWvFa2FQgUS8XxtIDLGxGX40KhylZcFTOFbxjcleQLEXKLObsB?=
 =?us-ascii?Q?XLs+UBAmjn1gYfDOKASu1Dt9ma+Ib0PJn9I1sucMPqh2WWIwjhdiSj4Dnaxt?=
 =?us-ascii?Q?NYhFO9BLJOdLax3Itiq0n54/kQJmcRR0DNYx17HgHGrD90dIM0pjkzUsHtHJ?=
 =?us-ascii?Q?eaquqzx+0IHYUk/HhP++bxIy/n0dKeX+IjbTAaygITTuYxXgqmYc/Vyckq8+?=
 =?us-ascii?Q?PVvyLrN9PFE0EO4q7jj4rRVP4xX8LuPQO5nZW2V76DhOsCiuYkw0hR8ParBB?=
 =?us-ascii?Q?QBLGvPZTjlN+UtkwX9zv8W3YKw+/t2est/7VlOgWRypzP2UmFMekuFSPlt6u?=
 =?us-ascii?Q?XrkSVZBfG2ug/63+wEuH+repKEfZgIspgrnkkvmPOMbB4rf8FHpeq+fjI7kG?=
 =?us-ascii?Q?mzUpvRsmw9qrxvFEW2KNggBHNJtn9Smzmj0eYNP77myqrx5Kb1DpVzDNm2P4?=
 =?us-ascii?Q?wjsRhmQgoFzt9JL1DAMfueID/cvoZkwNN4fttzWDVBOIMAvRBYwgwXAddPdF?=
 =?us-ascii?Q?E8XkyuPB88/i6CWg4lh5NIwQPpdAjc8GjWBVM9PtbUZ11lmpOdhfHx0vrcMp?=
 =?us-ascii?Q?0b9xbKsXWYDAxzkwNHxSg76i3R1oXCSuY4Go1fDOf6x58HtqhdXUgsnxc4u+?=
 =?us-ascii?Q?rFa47+O1fU0UGwaTUZz2uf1GpwKrsQix5bywJ81XtlsaubnDRFXIGDcqWH+p?=
 =?us-ascii?Q?kFtZTL8NY8MsIeFqWiswBPaONdVTr6Lwj8xJj3jlEF1BUdYv1VFNHucc0qOj?=
 =?us-ascii?Q?rz3+vDO/0LaHQ/6ucXF/zr5U1I4Xmv51NIV2qG6DMyzIHRqBsq4nlxZhM7Wc?=
 =?us-ascii?Q?dqT0z6rLcS6XI8ZM4rXn8FNlTnhLzsYr0spsIbe7Z8Y9HRZyqMwQE8lVU2IL?=
 =?us-ascii?Q?A1zXm9hg5IbgPdUXk+IiLp9UmzUTzJs0f2MWB75Y3FFzVvhPez8hQiWzWOpo?=
 =?us-ascii?Q?f1j2eP2ukOEC+LlQ2SQTt5CRuAX9n60a2/UAGuc4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0017374-1d4e-494e-3c18-08daf0050c9a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:42:50.5174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGZm3I+oQ+4QRJzUh+HSjTL0W5DpYFauZa8CmmV9xmQuH2FSE6KkMuNfczmmYs+W
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

dma_alloc_cpu_table() and dma_alloc_page_table() are eventually called by
iommufd through s390_iommu_map_pages() and it should not be forced to
atomic. Thread the gfp parameter through the call chain starting from
s390_iommu_map_pages().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/s390/include/asm/pci_dma.h |  5 +++--
 arch/s390/pci/pci_dma.c         | 31 +++++++++++++++++--------------
 drivers/iommu/s390-iommu.c      | 15 +++++++++------
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index 91e63426bdc53f..7119c04c51c5c8 100644
--- a/arch/s390/include/asm/pci_dma.h
+++ b/arch/s390/include/asm/pci_dma.h
@@ -186,9 +186,10 @@ static inline unsigned long *get_st_pto(unsigned long entry)
 
 /* Prototypes */
 void dma_free_seg_table(unsigned long);
-unsigned long *dma_alloc_cpu_table(void);
+unsigned long *dma_alloc_cpu_table(gfp_t gfp);
 void dma_cleanup_tables(unsigned long *);
-unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr);
+unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr,
+				  gfp_t gfp);
 void dma_update_cpu_trans(unsigned long *entry, phys_addr_t page_addr, int flags);
 
 extern const struct dma_map_ops s390_pci_dma_ops;
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index ea478d11fbd132..2d9b01d7ca4c5c 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -27,11 +27,11 @@ static int zpci_refresh_global(struct zpci_dev *zdev)
 				  zdev->iommu_pages * PAGE_SIZE);
 }
 
-unsigned long *dma_alloc_cpu_table(void)
+unsigned long *dma_alloc_cpu_table(gfp_t gfp)
 {
 	unsigned long *table, *entry;
 
-	table = kmem_cache_alloc(dma_region_table_cache, GFP_ATOMIC);
+	table = kmem_cache_alloc(dma_region_table_cache, gfp);
 	if (!table)
 		return NULL;
 
@@ -45,11 +45,11 @@ static void dma_free_cpu_table(void *table)
 	kmem_cache_free(dma_region_table_cache, table);
 }
 
-static unsigned long *dma_alloc_page_table(void)
+static unsigned long *dma_alloc_page_table(gfp_t gfp)
 {
 	unsigned long *table, *entry;
 
-	table = kmem_cache_alloc(dma_page_table_cache, GFP_ATOMIC);
+	table = kmem_cache_alloc(dma_page_table_cache, gfp);
 	if (!table)
 		return NULL;
 
@@ -63,7 +63,7 @@ static void dma_free_page_table(void *table)
 	kmem_cache_free(dma_page_table_cache, table);
 }
 
-static unsigned long *dma_get_seg_table_origin(unsigned long *rtep)
+static unsigned long *dma_get_seg_table_origin(unsigned long *rtep, gfp_t gfp)
 {
 	unsigned long old_rte, rte;
 	unsigned long *sto;
@@ -72,7 +72,7 @@ static unsigned long *dma_get_seg_table_origin(unsigned long *rtep)
 	if (reg_entry_isvalid(rte)) {
 		sto = get_rt_sto(rte);
 	} else {
-		sto = dma_alloc_cpu_table();
+		sto = dma_alloc_cpu_table(gfp);
 		if (!sto)
 			return NULL;
 
@@ -90,7 +90,7 @@ static unsigned long *dma_get_seg_table_origin(unsigned long *rtep)
 	return sto;
 }
 
-static unsigned long *dma_get_page_table_origin(unsigned long *step)
+static unsigned long *dma_get_page_table_origin(unsigned long *step, gfp_t gfp)
 {
 	unsigned long old_ste, ste;
 	unsigned long *pto;
@@ -99,7 +99,7 @@ static unsigned long *dma_get_page_table_origin(unsigned long *step)
 	if (reg_entry_isvalid(ste)) {
 		pto = get_st_pto(ste);
 	} else {
-		pto = dma_alloc_page_table();
+		pto = dma_alloc_page_table(gfp);
 		if (!pto)
 			return NULL;
 		set_st_pto(&ste, virt_to_phys(pto));
@@ -116,18 +116,19 @@ static unsigned long *dma_get_page_table_origin(unsigned long *step)
 	return pto;
 }
 
-unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr)
+unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr,
+				  gfp_t gfp)
 {
 	unsigned long *sto, *pto;
 	unsigned int rtx, sx, px;
 
 	rtx = calc_rtx(dma_addr);
-	sto = dma_get_seg_table_origin(&rto[rtx]);
+	sto = dma_get_seg_table_origin(&rto[rtx], gfp);
 	if (!sto)
 		return NULL;
 
 	sx = calc_sx(dma_addr);
-	pto = dma_get_page_table_origin(&sto[sx]);
+	pto = dma_get_page_table_origin(&sto[sx], gfp);
 	if (!pto)
 		return NULL;
 
@@ -170,7 +171,8 @@ static int __dma_update_trans(struct zpci_dev *zdev, phys_addr_t pa,
 		return -EINVAL;
 
 	for (i = 0; i < nr_pages; i++) {
-		entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr);
+		entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr,
+					   GFP_ATOMIC);
 		if (!entry) {
 			rc = -ENOMEM;
 			goto undo_cpu_trans;
@@ -186,7 +188,8 @@ static int __dma_update_trans(struct zpci_dev *zdev, phys_addr_t pa,
 		while (i-- > 0) {
 			page_addr -= PAGE_SIZE;
 			dma_addr -= PAGE_SIZE;
-			entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr);
+			entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr,
+						   GFP_ATOMIC);
 			if (!entry)
 				break;
 			dma_update_cpu_trans(entry, page_addr, flags);
@@ -576,7 +579,7 @@ int zpci_dma_init_device(struct zpci_dev *zdev)
 
 	spin_lock_init(&zdev->iommu_bitmap_lock);
 
-	zdev->dma_table = dma_alloc_cpu_table();
+	zdev->dma_table = dma_alloc_cpu_table(GFP_KERNEL);
 	if (!zdev->dma_table) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index ed33c6cce08362..7dcfffed260e6b 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -52,7 +52,7 @@ static struct iommu_domain *s390_domain_alloc(unsigned domain_type)
 	if (!s390_domain)
 		return NULL;
 
-	s390_domain->dma_table = dma_alloc_cpu_table();
+	s390_domain->dma_table = dma_alloc_cpu_table(GFP_KERNEL);
 	if (!s390_domain->dma_table) {
 		kfree(s390_domain);
 		return NULL;
@@ -260,7 +260,8 @@ static void s390_iommu_iotlb_sync_map(struct iommu_domain *domain,
 
 static int s390_iommu_validate_trans(struct s390_domain *s390_domain,
 				     phys_addr_t pa, dma_addr_t dma_addr,
-				     unsigned long nr_pages, int flags)
+				     unsigned long nr_pages, int flags,
+				     gfp_t gfp)
 {
 	phys_addr_t page_addr = pa & PAGE_MASK;
 	unsigned long *entry;
@@ -268,7 +269,8 @@ static int s390_iommu_validate_trans(struct s390_domain *s390_domain,
 	int rc;
 
 	for (i = 0; i < nr_pages; i++) {
-		entry = dma_walk_cpu_trans(s390_domain->dma_table, dma_addr);
+		entry = dma_walk_cpu_trans(s390_domain->dma_table, dma_addr,
+					   gfp);
 		if (unlikely(!entry)) {
 			rc = -ENOMEM;
 			goto undo_cpu_trans;
@@ -284,7 +286,7 @@ static int s390_iommu_validate_trans(struct s390_domain *s390_domain,
 	while (i-- > 0) {
 		dma_addr -= PAGE_SIZE;
 		entry = dma_walk_cpu_trans(s390_domain->dma_table,
-					   dma_addr);
+					   dma_addr, gfp);
 		if (!entry)
 			break;
 		dma_update_cpu_trans(entry, 0, ZPCI_PTE_INVALID);
@@ -301,7 +303,8 @@ static int s390_iommu_invalidate_trans(struct s390_domain *s390_domain,
 	int rc = 0;
 
 	for (i = 0; i < nr_pages; i++) {
-		entry = dma_walk_cpu_trans(s390_domain->dma_table, dma_addr);
+		entry = dma_walk_cpu_trans(s390_domain->dma_table, dma_addr,
+					   GFP_ATOMIC);
 		if (unlikely(!entry)) {
 			rc = -EINVAL;
 			break;
@@ -339,7 +342,7 @@ static int s390_iommu_map_pages(struct iommu_domain *domain,
 		flags |= ZPCI_TABLE_PROTECTED;
 
 	rc = s390_iommu_validate_trans(s390_domain, paddr, iova,
-				       pgcount, flags);
+				       pgcount, flags, gfp);
 	if (!rc)
 		*mapped = size;
 
-- 
2.39.0

