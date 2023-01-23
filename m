Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9831678854
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjAWUhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjAWUgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:46 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C8C3646D;
        Mon, 23 Jan 2023 12:36:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALtUwrP9Gurrauo70Pb71n7L3FFql1sw7qy4mLrrOK9DhbHYiv5nZ5wKZP/3JADMQX3rxleO4geAA2CXO/mVnFpTnzDZ+mVyEk4uC1M8bYQ2gu+MWYMZ9aLrbGVrKPeU7vWfsQoD06Fa1EDKxZKuyAqUP6g/OTEm71IgoFgYcU616/6rUVTktLhFaiS9mLXsmy7tIgMiLa2vIf1IEvqng645JsQsW7JDRunyLVcLkE/6O1A9gU28zT0AMa4MPUosSX3l5epG6IQmAJYZKSmeDl2SUD0RwnjKFVlksWbGjxyyY7L8L0zDgvdv79fsm9RpSFueHciYh1htWiNLTbrXxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YvAgjs2Gj01CDFnHkr1OBh2RqOFGO5naa0J3OW2sFA=;
 b=TEv53GbdeLgA5V0BINniiz8Zdv+McTSld2v9Mqp/g/byURUsjbQ+0SzqpeOSZQmd7FR74oB9VnVVWyQwRe5J02ruAn/NzOvvlKipdbcsdG/cQ1ijYaXvY8o2BxWn5Oy1mGDOAadfLDM6RnOPlif35Q3MoZZ3OcQZ+oUDZYRUgkMLClK76S1XysxGM8Ku0KfBzMYoQWn6oxjfS9ut3i03dM3y03uUDxPy8nY0ej0tlcV1YAmBTtLxSYr+1BU+UiOWrLDjZdHaBVVerw8bST/RRwTY9Xc6Gdi0/GdfCJ2qdJyBnH4BQgpmCYuL4i7uNx6sd7QenviAh4KqVoqPSXZtHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YvAgjs2Gj01CDFnHkr1OBh2RqOFGO5naa0J3OW2sFA=;
 b=oPL4613czCk0zwK59crO4LB0Rhq8wsayS5orXmzFdAD1Vt2uom300aFtM74nIH3Q4oVPl+MA0SAoBbuDRQTZNzE1KX8StUPQSvy1V30FGwwyEeoxrlhGVVFKMJX+AY7dbFFf83+sUs3S9G4807Sb9j2/EHcBQ9q+ooWELnmCzLEJaUX/qxHp67tnY6D31RKfgLB3+k5qs+hW032MpJVKg2JkiIh3Ujk3IBQ9JnIl2b152Ypv3JuDtD7WCFU9kzj9l7qDjbdAjNG2jVw3L+bTaKOYTTBg2xo1U16PdXVEyyC2fu5fVzKa9kQ/gqX1GNo9U814HEokTBljTC6roKlWMw==
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
Subject: [PATCH v3 03/10] iommu: Add a gfp parameter to iommu_map_sg()
Date:   Mon, 23 Jan 2023 16:35:56 -0400
Message-Id: <3-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:208:23a::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: ff729660-5aae-41f2-6281-08dafd81736e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SMip5N0QFyPZlIZ+fldM0WWSnXscGJyjnSGNfQseA86IOJL9XXAUYPYjldgbTwMx6+RBYryG6tDYR2vUI3MAQVuHFEVasWpbsB1F4epTO/bP1NECpV18wo7HFvLXVbhKBH8TDMcG1PpywBs0sj4KckIuh1RfLJgksTdwiWzhvj0ixPg/uey0anjTRp0xbFgga9HOAkqHV/YZbWV69yyObfgah1s7U0IfEx+jbvZzItNjP+iALnYVvRYp3AwiQ/G+uXlBmA/5Ae/aqiTWEz6iBMmA8AU1Dcyqvgn5f8+dCNqnEcMPTjQrMiQ5qRJpUS4RLaJuberO8ZcHfq+5Q8phRv3f/r9knItnYBxT8fENUPtPBl3RnS/ONwQjxsGFXQB0L33ErR+Dw3ozdn2tuGqJNIIN+4tWJEFX/HTWg9iPoPKfmtL2uDfcO8QMkWiBuMs8cLtJY6AQVKISc6gyQY28ZoZeOCohmcxMrg3/4Ydgf3ZntLayJkuuL8STbznWm7Y3iHKUarWxOQJjrEI2c+S6hRnFWwWm6EO+001cqA//ZsyFKbECUDhfGv3K0bE9M1ABjM7LvqQOPMM2D/bNIzz92lZmZ8IZ+LpzpOvP1BkZo7bW17MPdFYUBIwTsZ8OECWiraC6/Q64hK+4gFbbzg7JC1rflIqBMQL40VgowyTcq9r85woEFYQuWbIF4qdUlSf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+fLYrU49kNxga2Kw/P+FWyGC47PKmWuOc265dPEQG7UEaWbb0ucBi/NX1DnS?=
 =?us-ascii?Q?xr+r6ZPipCabhydEGToUDooTC2iX2izYxHHgvyHJyRS+qDZvcHfrnyWg1h5C?=
 =?us-ascii?Q?MGTnUdFZkYfB8b5hY9cP28+VRyhYXWkvkgEEgl1/m2OScKxqTdXOV1oh1msP?=
 =?us-ascii?Q?uC1D70GQEL3wvuPBoNPM8R9p3Amdpf5/64Bv9XBglOkJrbcfvEyZQR3VbNe/?=
 =?us-ascii?Q?p1/kCpKRrL6DfCGEilbX2wJeGIG0yuOv1XKZhyvXHn9+2ja4WbkV1WbSFb3f?=
 =?us-ascii?Q?uKWucH2JysUOqoS5szQHbCBdb1Ime6/a7uATLt3fS8w4wD/TGhUuyavc87tG?=
 =?us-ascii?Q?Jif339T2dv2w3dbKS5wNCwd8gLe++ksOrdo1TfVf39x8kKTLXOs7ahFgTf7s?=
 =?us-ascii?Q?Mx/FFQnY+2gaKJLAWip8ZMxWqz6BNRL45wvX9OGkpFGNK5Dv770WAStIwV1+?=
 =?us-ascii?Q?X1k1D8RwkitUbXFMaCQfVZpVwpZ2w6J2TkzSkZJf4Qr/Prg/fCtvUBJRbq0F?=
 =?us-ascii?Q?ejddjFXExzdshibj5ZICSn2PwqSYoZ4xli5lopWgO74PTUujfGPeVqrtFE4g?=
 =?us-ascii?Q?04QA6LfXMcgt2oGZL8ysGiYHJrLFXTz+ujSRrNV07HmNfuMuFVnS7UAPaRZ9?=
 =?us-ascii?Q?9akOhf/jRLU3vLtqf3e3KRLkXV3iEcf3GGbcXHg5izasOS6ZwXxad/yXuNLo?=
 =?us-ascii?Q?1+ltNHMBZj85f7MbiL38gu7ae03eFlQVmjdLyVh2VQVoycpHRGoGhFn0ghTv?=
 =?us-ascii?Q?6ILRHhA2fSbomQbiR0SLEFJLb7ZyLe4FGV4TJO6Ed9/KJF2I2NblsuAz3SI7?=
 =?us-ascii?Q?guTHBNrpLC2hYzl9lIv4gQs8R1vxXIlDzDqdhTPxtKF0SZyFacSvKM/uMHQW?=
 =?us-ascii?Q?Vo+Nk0OlJD5EXkzZS0N0/B5gzNfk0G92TcmcHwtfN5P5uQ+nAkXCeWzXxXBm?=
 =?us-ascii?Q?IysBcyXs5dgub2VbgkIroA6tDG8aN1JfDLYw/7nPM5QbrWlIKQF5n9i4WI/n?=
 =?us-ascii?Q?Uss0HMPltaR7hbjrV+IEBbz00YKLIT8fdiC12yslW7tWRW93Y71yN1Ejjtag?=
 =?us-ascii?Q?+95g6IoXfhvTGaOVi5ymp6969455bRuvAn5ji1leP5F8MfOy7yTir2YpVtS1?=
 =?us-ascii?Q?/bCj+qqCfZJvmo8WR6DWtFXJ/Ij6KEBVfXwhJ+5LYgmm9sVt8roBbaMOHx8M?=
 =?us-ascii?Q?Hd4yHw9WtK8z+YPIg5I7M0Fc30UfIYJP8x0z/UsVxA4QwNR+XZKOqayWYU/E?=
 =?us-ascii?Q?LIP6tyPNI7hUWX2uLksqO8SW0fFegN0V7QvIvwxD5iQz/NynK3HFhlDAi6x5?=
 =?us-ascii?Q?Tm51anf5Ky03oJwvE38dFubPD+5sHsX4IqC9KievA5Qw+Hi2R8e6pEoFKi6/?=
 =?us-ascii?Q?4J6zcMvhKCZBATgzbzYOnSmBEdIDESeipcyXFjd6b1fdvsg68HNhMHsJxCGv?=
 =?us-ascii?Q?81ycwl1cZ058XQdIQpodCRzKnR3el4K+puoHO2537PEhgY14alPmGGK6i4TX?=
 =?us-ascii?Q?4k9LWeTgxLyT1NN1QRCObe1UFQKm4jyzQ93YV3skaNvcEhCEGsWrU8By561r?=
 =?us-ascii?Q?LPYlC/XCKyxY2z65CXP9HBvp7yGnvVTHipYHb7sr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff729660-5aae-41f2-6281-08dafd81736e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:05.6662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35jcedsy/7n90zhFPuVxA9wN95FAcLfRtOVX4byuz9vQbjsO66zl92LqCX+B0Wr0
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

Follow the pattern for iommu_map() and remove iommu_map_sg_atomic().

This allows __iommu_dma_alloc_noncontiguous() to use a GFP_KERNEL
allocation here, based on the provided gfp flags.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c |  5 +++--
 drivers/iommu/iommu.c     | 26 ++++++++++----------------
 include/linux/iommu.h     | 18 +++++-------------
 3 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7016db569f81fc..72cfa24503b8bc 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -833,7 +833,8 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 			arch_dma_prep_coherent(sg_page(sg), sg->length);
 	}
 
-	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot);
+	ret = iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, ioprot,
+			   GFP_ATOMIC);
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
index 9412b420d07257..cc6e7c6bf72758 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2470,9 +2470,9 @@ size_t iommu_unmap_fast(struct iommu_domain *domain,
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
@@ -2480,6 +2480,13 @@ static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	unsigned int i = 0;
 	int ret;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
+	/* Discourage passing strange GFP flags */
+	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				__GFP_HIGHMEM)))
+		return -EINVAL;
+
 	while (i <= nents) {
 		phys_addr_t s_phys = sg_phys(sg);
 
@@ -2519,21 +2526,8 @@ static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 
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

