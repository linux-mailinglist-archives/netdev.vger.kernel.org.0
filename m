Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9667672618
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjARSBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjARSBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:01:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B0359E5A;
        Wed, 18 Jan 2023 10:00:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiWjsrqKjtvOVCAvtrnb5mydyw0RB9yAjwq1VlPZy+74LuXD2yt1pVdibICj7XtUS7hJmQmmjOlRQgKotSvKm9VcZRMNJR+MV4pagzL5gXYREjtQyDxAVH7kabeu0NfnC7B+jshtzJHJboLpIlqdnsEFyGxCz5jZaMbvNd2hkPKv2OWqUOYMISbseDdaTCDzufcVfwHcJzag/mFn+ITsYx608jgxDevLXfiRCl7CpGt8xIcReYX8V+mVvPP5TvKyBQiFleOvp/MaHOq2BMfWKNv1PNLKWPJHSy4ueFDBEBDhq8eP4vwGoaNlRVWM/581YTEAupeuANR22grQ6WzAjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1xwhjMld43bunpt9PDVXY/d6PVY9W3hUPitUQLHOPs=;
 b=ViCptLNimGZzNfG7o3kyytAy2t0yDi/WX5MlJamOInmkcoMl5vKf3FmGMFtBEgChE+IRFQ5LNR7drwDOF7Efo9QV2Zt97KRrrKUeVCZ2nD/HLhDTUWt3C5sYao8AEAt4xaOs5DzOM9tNJ0caOiO+rZNb8nMyl3BM+2Db+Vgk9yvxkzrSmRNbOA0OCHOBNYYAtcFWfLQb98prcxsTzhxGCuyTAFfdnVsNyUh4IYQP5CwWJ/8IyUOTo+S479KjP7AXCXRwxnNQtyM50QCARTEvjpQHeH9ZWDOaRS+67vumqc7ODh7X8IkCm6v+gNx9TJR4cEeRdJN7UPcrQMfpjunCeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1xwhjMld43bunpt9PDVXY/d6PVY9W3hUPitUQLHOPs=;
 b=VukqlncPbWG+1BYjjk7I9xWT7DldWJA8zvyRqMkWK3Jz6eYcgm//kMpOUgALoflqCQxFy0OSQLAqEzx2ikFtd+BmzS1QfHAfVB0c3oc9RuR8243g1hVMbBJn90BckMeRKSQ2ts+F9AFuw8bkUvlVRiC9pspQIynJWNMJkulHfpWyrrMFBlzCQvKbWtiExmUfwM8H59or2m0SxC6p0za8BTaYq8PMm5cHCqN1JqeReFKXZjwttyVoVJzUwDLvp2OzBOjA/hndU1daeUewzCkwLrLqutVFHpDt+UifToitT8sZZj28qFyv+PJYunYeSgkTEfSKhmogc+NavMwM7sxPXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 18:00:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:51 +0000
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
Subject: [PATCH v2 09/10] iommu/s390: Push the gfp parameter to the kmem_cache_alloc()'s
Date:   Wed, 18 Jan 2023 14:00:43 -0400
Message-Id: <9-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:36e::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d75bdf-3e7b-4587-bd0a-08daf97decbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ckscbfr5WsT0dd8T7+NWZi955iLwXT90Ji5HZL5XmCpQbDJeq7yZJf9UUJROjS8qHd5duGEpuwmeC3BPaBcLokwwGYpaIKoTBJxivaTYLmkICz1QQXReTqr8NVa6LdjK+HYvlUZiDBZqlTiAmihQYZ+FoyrF/lfLzCP2NnwMAJxLcnRNoxJ9Uvvi2E/YbyNehcCMQX9LoXMhGYJANBcgK7sMGHIB9nIjZfUhW27lBU/tZz/ZvX2JwqpXZk+/ZS3vwLWChNfn1tLe6UVBdkP3Y7AS0wfxiPEUJR9t8CZm2TI0NnCrhGXxX2inKDZf3N7Qkh2S5pJxcBdfzhDYI1noDWJ4lU9exwhF6DJtgEo0LtY9OpvVuTqki5g46d8s092u0KFEvHlCammxGzDD9sEvAr6lh9HN18pSDa5ihfJmQahXaEywEPgVlFCFSA+irqkSlprboMnwf/CO4uiMLMVtmMWDbRbaVvI8Az6AfdX6/7ycuJkQE+fz9jp1yEPM8vnjAdCCYw42w4Oliz1pEY0eu8/PmfCkyj3zsi8L95hnI0SyEqnox7v1L9hn/5XvaNMTkMDJd+f3KrJtdpVGm80XlpS1nBKrQZepcd7n86bU+HFjcGFE4VGIv6byiUBRgN8r0o2puJSjBLLiuNBEQoaAMyrocP0jL9gAiKcRGo9sxlVY/EB3lOzPya9lyDpcJRRC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(8676002)(36756003)(83380400001)(41300700001)(8936002)(2906002)(66476007)(2616005)(110136005)(54906003)(4326008)(316002)(5660300002)(38100700002)(86362001)(66556008)(7416002)(186003)(6486002)(6512007)(478600001)(26005)(66946007)(6666004)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SJX4ukpYbXeJu+CCuanE9tXeZjV1+4ZZIu8EK4SE0f7zClv56y+oM2bkDqeH?=
 =?us-ascii?Q?8sBE2CsYLRnMOimf71jZK9olbpQAiBPF/HvdfHgoBgOFcwl5lGDkq2bKRXCV?=
 =?us-ascii?Q?hjeMAu3ZY2pRmVuQOnXU7tgGkDiZQbDbOQC4BYaS18yc5OOUJYlO1URDb0J2?=
 =?us-ascii?Q?SYbyWRkMJix/DxMdeYIwTqs4iahBJavJIMwfs9QWgV6NDlMKxvm1FRsFmwMD?=
 =?us-ascii?Q?NtdK9IH0Ol9bzbnVmEIGEW80YpDEyRIlNanp7bBTdlzMoktDhWLMZHoZNHQW?=
 =?us-ascii?Q?c6tnGg5dKxft8e/y2nvW4PRNq7wfSNBoIDNmDKzja1CyIvJamWI2PVLUkOr4?=
 =?us-ascii?Q?BMmjB4FBUuwqtSK5K4rP9nQlzayhOqQuEdVJwgkKl5bxGTMAfC8DpSuYlNqz?=
 =?us-ascii?Q?D7slS/7VK46Dxv1mD2iW2ldZcxV7Cc61/XjCFoPEU+TyplPJ6zj2Ch0rElwT?=
 =?us-ascii?Q?aGzk31HYiARuaZRZSwWZCA18biII+gnR34yGeLkNLAkN+vVqY/rRuGfMnBDe?=
 =?us-ascii?Q?abCId9VFpidkJPMA6TVQO0HXNSP9Hr7jmg5SPfuafN5d3/x5fhfBtqsA5PAU?=
 =?us-ascii?Q?VueUzPlrRfLGskvpgsUXMEt4pOczv7BmmNz5rAMUYQ2UJpLBXesipoWBSHay?=
 =?us-ascii?Q?D3VirgKB1Ybx/VlAqePPdX2Y7c5VP7yj3HIfMZ0EuR1PexV2CW+T8jQ9HwhU?=
 =?us-ascii?Q?He31SR0eceluUICpSEASixf1CTYbmVPRj1PxgFfrSGZGdRGHFCfYV42zeSZc?=
 =?us-ascii?Q?8UTs1BOabzMc5ECWiBYISNEcjTwHPQ4R2w3sxWnyqFXjNT+5sx7FadUwbv7w?=
 =?us-ascii?Q?yUAiOVokZMyXcmmnmv+65TIUlsOM7eWQuQx1cVkJIYdpiOy4FUGhbna4aPm1?=
 =?us-ascii?Q?HmiO7gChTlHDZZLmP9yWJ5x985Y0Gbq5ZuIZjOCBW3iQSl+jUZQMFILXv8Ot?=
 =?us-ascii?Q?H37scR9rG5ln80ZHJPHAFEHLYW5eQBGsR3yarkJAbFILTlSm/IsxcZWXUgdM?=
 =?us-ascii?Q?93Are4l74/My/+kd0A0keUeoEraL3r9TmT63pSyBOtoBryGjogo4rXpvZF88?=
 =?us-ascii?Q?TOJ89qWPiVAQsTrZxZaxfNJGo4qo/uc1m4/+HNnMGZnpRYdm5gtNmGKnk0Z4?=
 =?us-ascii?Q?2rUSJCJEVjA8DVSflD5PR0mheG/sRa5CEV3O+Wjfz0YVVP5A+tCK/tX0lUiA?=
 =?us-ascii?Q?ZwyBxsXP21FNH0ktf2YranrG5zbMkkc9mDYBV5MUQNHxVYaiDqX7EasIsRR8?=
 =?us-ascii?Q?E8JsAe7EHTqU2I+bxPAs9+ufCs47mYlTn40RKg9QDOZyHHw49fzK19507rH+?=
 =?us-ascii?Q?USlowM/J1vefGeOPFdM0G24SwOdTNKOiDYn9ldWEXGdOmChM7S6akQST3Bcg?=
 =?us-ascii?Q?XV9a6P91XOixwCGdueEcY+0F80zo6x9WBBoTAgzEeA3+NbWYLQVJ1QWqNSIe?=
 =?us-ascii?Q?WdCQwAUNRRqIKqt1rc2y+xEj2UrJldW6WfcYPV2yXAMWJR+JlfzfCO2URqlX?=
 =?us-ascii?Q?M+D2WKU+EXyYpJDBIETLSkm7rigP5x3Dl8IdkFdx/trpgLwn+O206CsfH6li?=
 =?us-ascii?Q?V6Ws0JVUhEcx7YHkpgZ0q73s5AdImGR1AQQq9wuE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d75bdf-3e7b-4587-bd0a-08daf97decbd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:46.6931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kj9B0OeXC9AMFmSjSQKRKU4oER2+ssLk7PN/SYMvdFbPQ/LbUlcD1v2dT8GmOvqv
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

dma_alloc_cpu_table() and dma_alloc_page_table() are eventually called by
iommufd through s390_iommu_map_pages() and it should not be forced to
atomic. Thread the gfp parameter through the call chain starting from
s390_iommu_map_pages().

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
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
index ea478d11fbd132..2f6d05d6da4f76 100644
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
+	zdev->dma_table = dma_alloc_cpu_table(GFP_ATOMIC);
 	if (!zdev->dma_table) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index ed33c6cce08362..654ec4411fe36c 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -52,7 +52,7 @@ static struct iommu_domain *s390_domain_alloc(unsigned domain_type)
 	if (!s390_domain)
 		return NULL;
 
-	s390_domain->dma_table = dma_alloc_cpu_table();
+	s390_domain->dma_table = dma_alloc_cpu_table(GFP_ATOMIC);
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

