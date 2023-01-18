Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CE56725E2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjARSBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjARSAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:00:49 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F2E5529C;
        Wed, 18 Jan 2023 10:00:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wx7Mfi9c9598MGO7VDpFziWWxxJ4gz/TyUW7RXtkp7bJ7ZBCWOb3723JTda2aGRQDgncw9G4pNn9AKA+ejnI8Ork6hyWRKi78gVE4P2etY00UCqo/68ej7Pn83M28h7G0K6HVO4xTd1KoE2ev4YqwIT5Q7ggb22tlHOYYbIa+gLi6sdQbolWXiPAfjT2oeneJp2u0k3Etra6csnaZHNT1KX7xCLkLY4t9Mha77TZHlXVHxsCYVOnN1i/n99c03sUNxNdG2zUZDchoc4zYrChitoFllfziUMVSbEvl/Npfu6zfSFlqE4THnfcBzlt8oii0PDB49YlvBWcdZbkC8e+qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XnNRTH+1KqtZpYz+T8OWUErte65QR16s7yRZD6Lo1y0=;
 b=gsgwGo1wYMm92EInpIdGtISZKPN6kLP7zVMyzIG4XPaAYTptiwuNW1DRksSHQwzyZScuybg4/9uzwJ5trG9ABTJQXoSVTbK3gN70DjtdM8Skc+Lcd33d73gDkq84AiXa7jK1PSOaNn6FOoRGysZFCcZyYsl1JRvOsY5YwzaQy6qac4VrVxzax6wW58tnJ25QXkeE3FgNoRdDc5HBSv6v+TRxQIqIvVVFN+Vw3ynfknMDcLs2NySGrX9Ifqj8+iFKsWMRmcRoTiAcbq7cYHCFgFBiYsc3klXL+9Ufd9HiNVqjgyH32BBF+O9WN7y0vZR61NDrZSVj+u+47CTEpbc3ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnNRTH+1KqtZpYz+T8OWUErte65QR16s7yRZD6Lo1y0=;
 b=Or3GiQS44xpDMh4YXT4PN+t+ZTtzD3XDn4nV7Hzgd8gmnDBYIUM5HoA8b88Vjc4fHCYpFerij12VAaCVaZoFMEBbDwDiMnCQ99PAlxSVFyMgW7d98QC49MSEv9AnYZqmgmRgPu/FRD/w/kR+Yyg181ToikOcAAKVTvZm1N/FAedaYiZHVb/Z49zLmjfamqS0kEeVCsMbqC3RdyweFsMNsYhExNc8kml5hGSgCziMpBva5Dp+VAOFMChbnljIfcMVzbePsZF4ml3QDBFeCxifFCi6MaEQk8gvRyqBGgK/dv9qcPgioNpjrfALNg0vz+eVB0Xd0RUrg7Nl4uO9zdzA/A==
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
Subject: [PATCH v2 02/10] iommu: Remove iommu_map_atomic()
Date:   Wed, 18 Jan 2023 14:00:36 -0400
Message-Id: <2-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:208:329::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: 00ed64dc-f8c6-437e-d839-08daf97debfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dipnW/eamyJcaoHLcKnIMEqSMmU5OsjSOROkII/0hH0rEUmWOqMUS4wQC6zUcuQ8R3kdiF3yLMXrN7rkIUNg9Nd48/YitoQLrp8xSN7xXqhRqLSWgb41djZfxt943UQDEQPcIwfYOKCnjs1hRFZbuZu7pp3xGYvlFBXIh9IqS+ZZR0uQMM2XM/lKneS7iv4SrgQWFwu4SWpl3mJezRDHFLPmUK3WCiIOfIBjdLtKHLOy7V5bhFU/hixjYvd73ctxwBYuCgft4xzSPzQBt3gzbC3QhotYaWmkjnUlIN3qyclrFI2C70B+2z+B5DA0f7wwoO2iqA6jEw0B9Nvi3qKS3C8ftpjmDHh35D5kPBJVVsD0PyI4GBE0rlIv0a3jsiib2BMRXZJ7aqTvOz7piDtUpT/0m1kVI68zO53NO88y9XQkhMqSLvWk78rRPU/YIujD1WWBvXs2MVLnE1UigM8jci1BYDVu63MM6K7X2DDoDJ00452vP61WFxjfjra4obMhyE/QJM/uhyxRALB+vdWdDbFL7qdZEEdU9O4ParU7+mpJirH3DaYUFfLnxZBY41XkfUd6T6fP6xEjqMG+aWh6PzDTB00WslGojzevCedglGIw/1FJp5UImlPi32Lo2hkmJB5oQDj1ZeVoFAo0C9ePutuCQlhJmI3bZDvr9KAM/m40JAZ5TNwsqvZAm06UI1Nu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(186003)(26005)(478600001)(6512007)(6486002)(6666004)(54906003)(316002)(110136005)(4326008)(66946007)(66556008)(8676002)(66476007)(36756003)(2616005)(41300700001)(8936002)(83380400001)(2906002)(7416002)(5660300002)(38100700002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fck4Wpnziv2Cz+QwkZG5eG/tqENIhIvF1lMtUwsMzTzIeP6NZPu+49PmtcPt?=
 =?us-ascii?Q?HGu1v7UMs7LwlUFq9PzEJHP+2eXENLnncNIdVmnQa/HNHmEwMjWYRAafVH/j?=
 =?us-ascii?Q?E5qHVgRTKppgKacMifaqSNCWfPsFh5hPNoRPuujUmHczsGnFHcatERKQ4dSk?=
 =?us-ascii?Q?KH00wxo6F22xyj2ZF4OLtBSRX+TODvPWhRClFblr1PuMLcbHoPOW8inlt0tC?=
 =?us-ascii?Q?m67TXfHuVnvMTtnTPz1Wy8t8itxJsIFiy+gdV5quzmeAikCiAiwNH52JvC+W?=
 =?us-ascii?Q?fb79fE2gvMVBpze2Jc76U8YbFSoKR4h4ce7SUNn6ZbbZKAfuEgNzSOsKYQRY?=
 =?us-ascii?Q?3SQiCCBwJfH5umQose98ZfKebiantQ39Mwqsbt/hR++3gxsbUTakzQ9CyZRO?=
 =?us-ascii?Q?oZQue0tnoceCVudOWeWZmfdjJHbXf1xmXZLQe1YsFTGLc74qhqplTiWXmCa6?=
 =?us-ascii?Q?d5gblhnTiQxSy8aW3ChN0rFqFozi9wRG0leFHu+0KTcE1WWbg2yny4Nq2xf9?=
 =?us-ascii?Q?U8Axb8ImXfE66cMqHsqOc3SitE4R6XLBU7Rc3MhWbVvSDqll7fo188UQnGQp?=
 =?us-ascii?Q?EfhhR0ZMUtJiWE7kVkBEOtY995HtqjJ8FfANG8uDCFv1XHuLf7TM3e0XE4Pb?=
 =?us-ascii?Q?C2nlgKRUSJIslbFoyUgHFyBINwyeWbegOBoUHtv8WTKR7XPBlbIE+1eaIT2H?=
 =?us-ascii?Q?aT2DAj6dv/MwdtZXdTeQaJFaV4/zR1GHSNhXvkPswx6ukmB+cdGUm9N5hVAS?=
 =?us-ascii?Q?NzomGwC6DpQePIWVeKHCrcjtRG5szMIqYinvzzJaQWar9OaSLBkthRVd0Zqw?=
 =?us-ascii?Q?ouT7tNEydsFmY79G6EnWPnFzl/ic0IcJuGAu80MpcHRSM6nDHT6ZB92qWNIq?=
 =?us-ascii?Q?PfCLRKiye71yr3ZL5foJJ9Q9Xb3la8x8VfoYBBECrfbd5aKHlAIaqOvGmNBe?=
 =?us-ascii?Q?u7x2rd2dQMo4h2/lsP6ff9ZOB+srrg3lWmHX4dsYqMBhV+abZD1fiDLqpnXd?=
 =?us-ascii?Q?Y2Cd/VCUzE1+KDnu+mqY6bywkrpKbptNtyqnddzVGnr3FHTytiQm+P7sukJW?=
 =?us-ascii?Q?TbHw2ylNxbr0SyDb3NgiP0bMo4iYNaPAVkUmwxWwYWQvaTzvGTBkIkfDLGi0?=
 =?us-ascii?Q?G0Jin6FMa7xuJPYQ3bZ6wWXPO9AjgbX1ZRTEPpgFAsbS/kI4bFsGehW3uHGl?=
 =?us-ascii?Q?km8arweoc1DSwzmd1/XmFp/Vw3o2btpRvklwAY4CXnyAKh3dG6ZEALWxSM/G?=
 =?us-ascii?Q?0k+rrp9rdkasZK+uOF162moJUf6CiKUlgfbeALjPg72XHcTkJfCrSlGHtX/R?=
 =?us-ascii?Q?ZHjOFYu9x860w3sJJ+Q10X0PZsAm9C7EHoy2NGk53UrKnQPmJMCeASHvsWR1?=
 =?us-ascii?Q?aBlmyigdY5NjIoWf3Hm+GDG7KEozB3DZHjdqmJxZJhjRtBpaBuTg6K49nTr7?=
 =?us-ascii?Q?fsTHQh5cR//YUCkj3BGnCtBvABseMwnb0axlioDZVbugLtjNPR9Rd1pmGSdD?=
 =?us-ascii?Q?9esGMmX14xln1DDetdBl+v1a4L3VVHnEXQt3HiIjLS3dUorxzx62sSre0xhd?=
 =?us-ascii?Q?DUd8Xz5soNo/6wUN9PVOfUd439MNOD4otlohN5li?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ed64dc-f8c6-437e-d839-08daf97debfe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:45.4590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +olxkA7gy+fLu/rmzQ4CvFah9pVF9kR60kmfMv20LRjO5anjsEGL3tWZl82WS655
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

There is only one call site and it can now just pass the GFP_ATOMIC to the
normal iommu_map().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 2 +-
 drivers/iommu/iommu.c     | 7 -------
 include/linux/iommu.h     | 9 ---------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 8bdb65e7686ff9..7016db569f81fc 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -713,7 +713,7 @@ static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
 	if (!iova)
 		return DMA_MAPPING_ERROR;
 
-	if (iommu_map_atomic(domain, iova, phys - iova_off, size, prot)) {
+	if (iommu_map(domain, iova, phys - iova_off, size, prot, GFP_ATOMIC)) {
 		iommu_dma_free_iova(cookie, iova, size, NULL);
 		return DMA_MAPPING_ERROR;
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7dac062b58f039..9412b420d07257 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2381,13 +2381,6 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
-int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, size_t size, int prot)
-{
-	return iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
-}
-EXPORT_SYMBOL_GPL(iommu_map_atomic);
-
 static size_t __iommu_unmap_pages(struct iommu_domain *domain,
 				  unsigned long iova, size_t size,
 				  struct iommu_iotlb_gather *iotlb_gather)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2020994f292db..521cd79700f4d8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -468,8 +468,6 @@ extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
-extern int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
-			    phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 			  size_t size);
 extern size_t iommu_unmap_fast(struct iommu_domain *domain,
@@ -778,13 +776,6 @@ static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return -ENODEV;
 }
 
-static inline int iommu_map_atomic(struct iommu_domain *domain,
-				   unsigned long iova, phys_addr_t paddr,
-				   size_t size, int prot)
-{
-	return -ENODEV;
-}
-
 static inline size_t iommu_unmap(struct iommu_domain *domain,
 				 unsigned long iova, size_t size)
 {
-- 
2.39.0

