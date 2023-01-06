Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B305A6604F9
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbjAFQoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbjAFQna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:43:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F87D7A3B2;
        Fri,  6 Jan 2023 08:42:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSQYw2cWFMx8V28onIGgb41pKTxh8rduxMUx2FNWjIVqAe2koKLgl7iqVg5L4FzNNZf3FlQJJzo7z/jUXLOvgJZQJcGSAZ51pPrRccV33E2JRT3MU3Q2xxfNO3Po/c9wdYiQMmQ/ZEYgtT6awD8IPWyrjDR14M5t0Xu1a9BjMYEqdKhoMiDBYDviYZ6NJIbQUaqGit54TpnFvkuu/dPPkpLFaTKJvQzaPrwdKp3pPNXcN7Uy2H+7hRRWZ0RTNfmElOCxBA9mKnz8BSgjw4ad2ydjTlFnha1oACSvq+iQvOpGyLxmzT+FJA7hnvCDAUhcoe02iNcRs3H1jNFfqnD+4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XygBCBJmZO0lHIPyUqo5uBagRbdg24bsaUztUT0w2OA=;
 b=U7RF1Mv9M/7ktoeSixiPJb0RBgPfQMyfW47JLIY9v/V06xNmBpYqwwP9MRMYgs58L+5IZti3hkOqbbYq6KAQHWW5n6OaGi/RuOds1rVEn/YZIjH+80HzAtjmpXJIDY9FVHyOF3HRj3GU73NdMdKorCuDCRRdfZHPVxbzcmj4gVQScRwJjhMz/gi2wfntFASC2f8nJoy6PmZjAGQrKaMYQO8bSH5TbUoi4AmuJeslXMsiNAXKuJJXg/mFnuAiThgvW7cJg/2i+U4aZ/M56CaI6dChr4B6X9fmnae8hyegf7X0qN3SMVVD+835xqLpcJrvbfwtN3FkJ6thrW9E8l2Mpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XygBCBJmZO0lHIPyUqo5uBagRbdg24bsaUztUT0w2OA=;
 b=Tbh9/8B/UT9ocDz73PJS6qggA2YkfcxiwdbNHJ7C+/M618gI82WTBjD9XZmLiwKNMaPVsQVel5XO3Dqo5HK30KdC4visbWytfIgPcsb3niLfkH8UXWG4+6ahc7eZ40oQV2aJ/Z4NN3CT7YuZ9ylEKkkixrXwdppRQqqHWQuHpLa4jRKTdYhXGGvLA1+HpqLeHRW9zlo2exR+VmZwZxpSuQINFeHCPmXLK3VYfrFxpThNTehgovzYuEX8q/KV4aOo8sQTToSyS21xfU6aYu9pQd5r8xskpkbPGNipvwgdKtiTKzl7YwabFCO54FOTK22iWEVYpLgOWtEMDuLrycimYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6437.namprd12.prod.outlook.com (2603:10b6:8:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 16:42:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 16:42:50 +0000
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
Subject: [PATCH 3/8] iommu: Add a gfp parameter to iommu_map_sg()
Date:   Fri,  6 Jan 2023 12:42:43 -0400
Message-Id: <3-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:208:fc::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: 535936a7-378c-498f-b9be-08daf0050bdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ddBXClO3TdH885FpT+z6/fu7Zb+wH0xL2xQyi5Ww08ecDMP0xEsQrCXXm0MQgdh/8tNP4Fl2MYyC5jXzQVJpelBoltQei2DzzGTRuQFsRRbfdWQhoksq7uEhu+9Y1MYdzO9R06xkBs7LvXMqiiirNCk+8sRpNMD6+Up8+nBJ39YAlm4YGNGLVbLb1sDP3CZIXq0JttCNBf4WpvHyQmntDZjcn6hBuxYzyLkoRjT72atPrSl4TJ9XO8iAinAwyQaoEI5qkrC0fII+EC5SDIvI+45xteZ/0oR4Wvs850mNBlu/u+36AwgU0YLZ5VgQqmia5wYUyUiDRyet4nsgUsdtiIkD+OEJO0O7A8EqSIwATJ8cvIzPOLLVijtCw7sTKiUmvamZdxV0PiYCeHfLx5ZW+BfRO8oUvt1ooSQQcaOyqaruAn4f9czuLaFU6fTRsZN+x4PnEpgWupfButSSwoKHdqttj2t0nEKpuZi42M05u8DhAAsEANzZKioXyUfc7GdLzvYJ6RIixYBfFH4/4kLPxL2gYE4rJqhfFSq2iJkkIOt8orsWqmcI0U3dSPrJdnS7RME+TcMhuR1luYOYMiEfCoVjlbM38VxbRkttR8zntLtOUiZINvEwIZah/dFRxVkhZxubGI0+4Rny4gwzPFJSewbotyEPhTR4WiNM2nzZo+NVpDvVw4naD4vNb0Kw/gRR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(7416002)(5660300002)(54906003)(2906002)(41300700001)(8676002)(66946007)(8936002)(66476007)(316002)(4326008)(66556008)(83380400001)(6666004)(478600001)(110136005)(6506007)(36756003)(186003)(2616005)(26005)(6512007)(6486002)(86362001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YJTzNNnR3Uo+lIW612KJEyyU0///XWaTmv5nX0TzHqzZ95ZRuXp0s/HoXNG6?=
 =?us-ascii?Q?J9tBBh2Z0O3ALrSEGeWpinoWAGCU0XXJKJA/+BLHLxkrd4ZVpIJTtTcvgv7+?=
 =?us-ascii?Q?PAejS1ZLpz+wxQMBocQfnI5FryaaRKElZSe09BvnJA7uBR4rRmJ811lynPCZ?=
 =?us-ascii?Q?TYMM+oJ9W1WF8bA1l1/aOWzirpM6OmMzrEHYZdp4jon4B39IXjGyXqjWFrMe?=
 =?us-ascii?Q?LzuKRdY+qaXw05Lo0UY7dzE3BMYvvOw8Ktors0oUofi7ekv3eNrhnDhi1UVf?=
 =?us-ascii?Q?O+BZkuiUvzhEBn5oCw8nad2z4RxbI16s8W9dgeS8k29DuLQ40RNylYAvh35G?=
 =?us-ascii?Q?Xiq2d/+dclcC+LmgQ/f+5++ajD3OahVIJU0r0gj3CqIrXnJKOALL7I9yU0xL?=
 =?us-ascii?Q?Dd2rJODEmbgwh2FzukPG+JQoFD4edmXj/CMZs+7aLh4cSbwafMHFymFTP475?=
 =?us-ascii?Q?l4VKcl4i0gk0LIpozkKIo5ksQDDoDrFL1eTti+QMQypZ2nIzEZk25nH3BJPV?=
 =?us-ascii?Q?v7wrGGQmQrdJRIAt95O8qch94ORmwRiIDKKTwOoHIgBisv9hJLH1n6fx1l4m?=
 =?us-ascii?Q?/g+VPun+JODgqYWF5TggiBUzAg1ZR2UKYfgMAdC/YnO7uSlnbe1qWPAUOY47?=
 =?us-ascii?Q?/DRnGFQQYU/pjKXpnRyDS7lJRa3sYXSUXGjN+XFzkqmBc3QushkqC1/L87WZ?=
 =?us-ascii?Q?FrgDv5wJGC+etsEJva23pB/6dzwjPlNSPZtGLuyOgf9FlDfCKZikIFsDLixj?=
 =?us-ascii?Q?MfMm70YVDqWCX4ZQUtuVO3FtwAka3zp2MYKr184BBSR6S6SqUrsBk1kUziLF?=
 =?us-ascii?Q?PYseHbw/NEjo0PyjlM4Iokc7bBOoeYBlF9cmxhT24jc2I/xNpvtBHjABYR0g?=
 =?us-ascii?Q?yKa3JZMOsPE8T7u0Z3X/5JBq9HvGfAxNr4sK+pwJH30kI75OLa4ywsgrYMeJ?=
 =?us-ascii?Q?vZkcOjP7a62FS3joF8VcqcDTZ5o1prNRu3GKNXgy6qkn90af91pTmHTkJyas?=
 =?us-ascii?Q?B4rrl2aNeqXUrZEG7xEmNEzOuSkLXvnhFYIvlE8rUfdn3yi9FCA1nsw5ehcC?=
 =?us-ascii?Q?no9AdUZBUFxf6me3c9On96h4v3w/KHJ3x4O5MPVjMRj6mVinPGaE/cpHscTe?=
 =?us-ascii?Q?mVIT+NZ5BDy3IcHVl+D4BXVer84L9vFFOfDy3PW+WJS4z/WPx4bs4QNx8ocg?=
 =?us-ascii?Q?QRxJQaW3m0Dfhrxrce+G31bLszWcN+a2+W9goXmUzROPtPhwvNiKLmHBktSG?=
 =?us-ascii?Q?8JTjw4RtYxdoFnglxbT7m3wRH9rkEjsk4gQ+/0OdFytsRwVWi64Ccdx6Vxl4?=
 =?us-ascii?Q?WULL5MeSMGMCkdlh5UFQLHmWs/0D20jkNwxMtsdoUvTVHp3J4NeR7qRMN14x?=
 =?us-ascii?Q?RJNFV8qFwGi/3+Thu8bnuZE/Pwghtm9o+3W+ix+M0l+znpfNdmjkBaYstFUs?=
 =?us-ascii?Q?QvPYARDHQMBUM6ymfwRvw/+/RsyIc5OmeuyebPNcudimG34c6to4Xzmqv0o3?=
 =?us-ascii?Q?tzNVownh0Ev4VJ7HYdZIwEb5Mq+XTleVUjLTcQTPpq/549NDPM2NoME+ZG00?=
 =?us-ascii?Q?qcR+BR4a2PLG3KHEFWhIFLo/1v5STJhyi9XwD/e+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535936a7-378c-498f-b9be-08daf0050bdd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:42:49.2960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFaw49bMjIpwknKATZ1zNEDU+mjzkKu8bY0BTiBK5vw8YKqbcAsHpkrWECXxbnN8
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

Follow the pattern for iommu_map() and remove iommu_map_sg_atomic().

This allows __iommu_dma_alloc_noncontiguous() to use a GFP_KERNEL
allocation here, based on the provided gfp flags.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c |  5 +++--
 drivers/iommu/iommu.c     | 21 +++++----------------
 include/linux/iommu.h     | 18 +++++-------------
 3 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7016db569f81fc..8c2788633c1766 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -833,7 +833,8 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 			arch_dma_prep_coherent(sg_page(sg), sg->length);
 	}
 
-	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot);
+	ret = iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, ioprot,
+			   gfp);
 	if (ret < 0 || ret < size)
 		goto out_free_sg;
 
@@ -1281,7 +1282,7 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	 * We'll leave any physical concatenation to the IOMMU driver's
 	 * implementation - it knows better than we do.
 	 */
-	ret = iommu_map_sg_atomic(domain, iova, sg, nents, prot);
+	ret = iommu_map_sg(domain, iova, sg, nents, prot, GFP_ATOMIC);
 	if (ret < 0 || ret < iova_len)
 		goto out_free_iova;
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fee37bb246f3ea..11fb3981e25642 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2465,9 +2465,9 @@ size_t iommu_unmap_fast(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_unmap_fast);
 
-static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
-		struct scatterlist *sg, unsigned int nents, int prot,
-		gfp_t gfp)
+ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
+		     struct scatterlist *sg, unsigned int nents, int prot,
+		     gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	size_t len = 0, mapped = 0;
@@ -2475,6 +2475,8 @@ static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	unsigned int i = 0;
 	int ret;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
 	while (i <= nents) {
 		phys_addr_t s_phys = sg_phys(sg);
 
@@ -2514,21 +2516,8 @@ static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 
 	return ret;
 }
-
-ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
-		     struct scatterlist *sg, unsigned int nents, int prot)
-{
-	might_sleep();
-	return __iommu_map_sg(domain, iova, sg, nents, prot, GFP_KERNEL);
-}
 EXPORT_SYMBOL_GPL(iommu_map_sg);
 
-ssize_t iommu_map_sg_atomic(struct iommu_domain *domain, unsigned long iova,
-		    struct scatterlist *sg, unsigned int nents, int prot)
-{
-	return __iommu_map_sg(domain, iova, sg, nents, prot, GFP_ATOMIC);
-}
-
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
  * @domain: the iommu domain where the fault has happened
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 521cd79700f4d8..d5c16dc33c87de 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -474,10 +474,8 @@ extern size_t iommu_unmap_fast(struct iommu_domain *domain,
 			       unsigned long iova, size_t size,
 			       struct iommu_iotlb_gather *iotlb_gather);
 extern ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
-		struct scatterlist *sg, unsigned int nents, int prot);
-extern ssize_t iommu_map_sg_atomic(struct iommu_domain *domain,
-				   unsigned long iova, struct scatterlist *sg,
-				   unsigned int nents, int prot);
+			    struct scatterlist *sg, unsigned int nents,
+			    int prot, gfp_t gfp);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
@@ -791,14 +789,7 @@ static inline size_t iommu_unmap_fast(struct iommu_domain *domain,
 
 static inline ssize_t iommu_map_sg(struct iommu_domain *domain,
 				   unsigned long iova, struct scatterlist *sg,
-				   unsigned int nents, int prot)
-{
-	return -ENODEV;
-}
-
-static inline ssize_t iommu_map_sg_atomic(struct iommu_domain *domain,
-				  unsigned long iova, struct scatterlist *sg,
-				  unsigned int nents, int prot)
+				   unsigned int nents, int prot, gfp_t gfp)
 {
 	return -ENODEV;
 }
@@ -1109,7 +1100,8 @@ iommu_get_domain_for_dev_pasid(struct device *dev, ioasid_t pasid,
 static inline size_t iommu_map_sgtable(struct iommu_domain *domain,
 			unsigned long iova, struct sg_table *sgt, int prot)
 {
-	return iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, prot);
+	return iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, prot,
+			    GFP_KERNEL);
 }
 
 #ifdef CONFIG_IOMMU_DEBUGFS
-- 
2.39.0

