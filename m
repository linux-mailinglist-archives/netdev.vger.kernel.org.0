Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D9B67885A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjAWUhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjAWUhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:37:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7666537F1F;
        Mon, 23 Jan 2023 12:36:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgSu0KgCZdgvIhHMfIQLJLlzmqurwH/kG1s2Ibv6mq7Kn0kUYe3dcwqwH/x/bIRnPEnxJUPEcdvjy7ZOsnvWsm6mWXxUKgw1uEALoeKOUOphZ8agUobBuqrQCMFxg4Lhde2TxU9qY0KsgSt7PZvECFgWAnHNG/yaY407Myy0+pJGTKS3sHpRhj3ZWUGwJDXKj33Gf5luddt4ZXvZbqw/OgqrRsU08NFZrTuqTz4gY8uW1u5Ok7zcY9bOzPCnrbZDy81RC5izsY5KFQ0GlWzTVCBWlHJmipMn+yk7Ps3RS5eI4BgvEqUKlEvu0Roe8vaNWPf0LvNcHG6P1gzv0qobiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TR3UzV+jM32RAAY4DEyhLcAzLmZzKoYSQnKJfYVwWms=;
 b=Dw/+pxusq+nYFEJeIQN2eEqJSUJ0yFWrjIJKcTsEPY+USzD0QwURM2zFG76VxvJmywpO0VO38SGCkBR7WRsgZ0Jn8BaS8XDeEZVFthmr9noQI2KWHcNFqhdhkKEelGy+RTm0fZ95Gz2UQJT9G2W23rZXOqcM0TLUptDBsxq0wdr+N65qPDqU/SqAhqVzJMHR0TI/UJi/1kHZNheNnqi8A33hog53IQIhh8+FbYNJMcAyjOfyABKn8Jx+FCLHdI7XJ/LufegcYb0IH7cQIuEVVmNBYIw6U2ieLUgpX2uZ3CBJDPv7DNa35MuT+ukMWUx8PiRIR4/HAU1q9/GqfObafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TR3UzV+jM32RAAY4DEyhLcAzLmZzKoYSQnKJfYVwWms=;
 b=qXLH3kr9674VpkPa7WxgeuYvhPjm7kFxBZdvl9fDWiqX5VAOq//tqirCH0X3hKvID2x8+pCQI+XFzDDvZZ3wZ6A9quQwyb9J+qx0E6mp5IrM+VeyccNDYE3zskqDcWZqR2hpNu3ZMiegrSq6q2kxC2DBJ0aMxywTKxg8P0kKG2lpyW31OGVAgftZtR7U5D2cOtK260mmSddw1Wd9JFtdupPwd5QHAIrufRsewtVj2VqxIYKybTueh5hXkng5QF0BbKSyxPsxWFIr3UzpJLfnr1kQoVninTpLoP+176FyUuBAoSLP6uiQVs8JoG+Cr86DgLeT84w5iFPGTdJiA1rwxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6571.namprd12.prod.outlook.com (2603:10b6:208:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Mon, 23 Jan
 2023 20:36:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:36:07 +0000
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
Subject: [PATCH v3 09/10] iommu/s390: Push the gfp parameter to the kmem_cache_alloc()'s
Date:   Mon, 23 Jan 2023 16:36:02 -0400
Message-Id: <9-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0260.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 0317d878-3d3c-4b5c-afd5-08dafd81737c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEpA33d/X3CMUalhYrDZ7KOmkyUDHOjA/XqRO7tMy9jFEPQ9yXqcbKwY/a1cwCM/zp2qUfhixTwdeHqTl3Ki/ld5JMdiZ6tNeI0FIQ4txstT2nBzMiTc4TNRdNgKJH3TtkvBYGEG+iW/syKwEUf14n42c+m32YZ3ivai5d9cxr6VNrRm/K+yRF7zUij+UC8s9rmS6vRRxgpyfqmD0HIdUld6OgJEzgW8SJV9TZb7F0ifbwJah5S8O1OKufu6pMar2M8xUXpsgW45DeO6KnoXJv0umpsoE7x7rR8BfR69TiM22vtwHHFQz0pME8SVCyoN4z8gPPJlTPmU+Q3PONgwr/EE672KpE9B+h7i1jIPJ5eQrBbG0jT1iDSTQ61347SSnL0G71rDW3dMlqfnaYpMJk6a3OgK1QcF/G88wTZsMBaf8J/vNyooM+LHoxEzE/vMgdT/80lWWTXmKyXWv5wsInHPmz38f7Xsq+OuWvAyUwAUhWc7XFvs2GtpUqJRk5Ia0CllOaIHobd8wmkR+GyXHXdVp0tpJK2DMXsQjczDGkqAGcfwvaiAGSbCSdo8X+/9xqvksz+k3IAUDO3u2SVJgNJexe+dsDlPkP5It75XlTC8oZ+kzcty7/EtR2NG+REb1uj8xQHZELI92kal1vdbBXZAs8xJnRWggad1uJpDintR47ibUc6KfBQxnDBBvKKu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+4MV0tVruWWYmY/SNTn0aDiFayyrs43Eafn9FL6tsOJs70psKgLw/CTuxUjr?=
 =?us-ascii?Q?fG/wO2w7vncC4TaoaYPBlBs6at9QI6hT0UqRQ0Zi/sfcq6Fj3q0wzZXJfnsx?=
 =?us-ascii?Q?/X64EC5aHzOSZr3TMMQEN0tS+Yv14sOscQbrJcMOJYjlLKUuTF2H5quiB/m1?=
 =?us-ascii?Q?GqA7hbKQd0GU7VInbfggjGeO7Hk6H3Pq/1T0L3kqjiszWEpi0s9l8dGYdLPM?=
 =?us-ascii?Q?f5aFfmAOGY8T1lshLa0/J2HdwKKczv/shjcbG2w0JmblKqOAUjNKxEkqzZ3m?=
 =?us-ascii?Q?+9ONnEEXzhhl+9zknTkIDGExJJHpBdUTWhD3iRaZBDcL5M+OlRqqw710p5kS?=
 =?us-ascii?Q?X353Xvdz11zHZQ+UXJQXezbdlSQZeiZ5XVqXbXN+sEvlaeKvRKaWjlN24Bb6?=
 =?us-ascii?Q?ITlbLBHaJUV3hA0FcXduTn4+5uBT2xB1BFvQU7mCzz/h1hqp78tmBHBqoEu7?=
 =?us-ascii?Q?66dp1dZxjFLVOcVlENOHkE/LXdj0wFd+WMP6H+dM0c5zI+wvaMPflNxWz6lN?=
 =?us-ascii?Q?uOFQqV7q+a+0ltxxS8PQI6Q01PWAhD4r+MVFJc3Z+YJASxeN/Wn586Yo9EzL?=
 =?us-ascii?Q?tcVfIurJ1tP1DFz769V/xuGisektswxMaVpqwjAmRy+7ph8rdCdTeii/P4Mk?=
 =?us-ascii?Q?0UC32e22G7qC5QQ+0QYnaf1pnlFZW3SqAdD3kD7NSFqYlJ8Bz3V/OiAYRsyY?=
 =?us-ascii?Q?VwBzbL/hmJI/iUU4kAPr+jL729srv0MEwxMVxbalNSTft+IhEC8XZWNmj6rn?=
 =?us-ascii?Q?jmaeSmItn52hS5dbNkpDv9OSGeSJ4Y9Wu2loueselxuN19795eE3rpZ5Jm/F?=
 =?us-ascii?Q?kEcZO06YdiNZoMhJYvlsBDB2J7w1SqSSuyzI+StY8cmFSUYhotgqaqKC2e62?=
 =?us-ascii?Q?MC+CwRcPD+CQzOuSAhyOxk0Z9+2NUH217lNtmBqgzFv8FpEC8gSZGYW27aeH?=
 =?us-ascii?Q?DMMmCmLSutBhdEfvn1lQSBnR1f5hcxl81b9mjvCwbFDC0I5mowm7H1YUl4to?=
 =?us-ascii?Q?GOfZEXbcNa9X3iiPld8f1nm5XaowWzna6kjXNvICQ7HejGuKToD26EVuGoSc?=
 =?us-ascii?Q?YFs89dTZbGmzixJW5OKjIcE0IzbbHOKWqojg7K/O74LSHfxG7dpVVvZqGJUg?=
 =?us-ascii?Q?2Drq9GFsrVi/he6WIrCbHvDx/tBpf6m2M9GTWX4OjZLF9QZJ0aoExf1dDlBp?=
 =?us-ascii?Q?zTWIF2BH3wc00H8KsFqS6oy6OI/xcX26XaIJlrcWpgoBeLm0s2jCxuHzIIuI?=
 =?us-ascii?Q?J2kax4UFTdCvKobgLII74Ahu43lpVSH1yDEIQg38H18+CODPEJ7iDtKsG1tu?=
 =?us-ascii?Q?migZ09ptnSDxEHheVxI+PIoGYQ4OZV4fHkIza5NeDJPikgWRlewG3LC7k+8r?=
 =?us-ascii?Q?6haYz9QsCEDEy+uP726oe8HcEEmhO/dTvEmG64zS30vGXaz6qJbaedl5kAOL?=
 =?us-ascii?Q?xZHYOylDFO3Lvi1AtEv430F1Pd2OzAC1CgsZapDEFxicXsDpZRFq4elbjIQC?=
 =?us-ascii?Q?bTuv9KHYy/p1rTB84GYP1odI+8AVRMiNB9uh/S0KcFDxnk8ToGSi8vs8hxn2?=
 =?us-ascii?Q?1bmgXU/m/E989nn0CvRT6bsOTT6/emEExRhhy7N/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0317d878-3d3c-4b5c-afd5-08dafd81737c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:05.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9xuC5BZWMz3Lqbq2+2cx3IMwGPZ8SDj8MYsokwgEFMu6zMxW/YKfGkE5RJG+2t0
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

dma_alloc_cpu_table() and dma_alloc_page_table() are eventually called by
iommufd through s390_iommu_map_pages() and it should not be forced to
atomic. Thread the gfp parameter through the call chain starting from
s390_iommu_map_pages().

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
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

