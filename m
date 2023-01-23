Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AD4678861
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjAWUhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjAWUgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:36 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA6B8690;
        Mon, 23 Jan 2023 12:36:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EetR62gpUu0HTDbNhqng81PSXTCx4vrA2eX3k4sTUmWI0XxRGnB75PhkDqiBI8xWCSGyF0+Zt8O4ya9Z0uKttoqa/9xW+s9jf7ZZeAcEch++flRv3KlP540Xh1m96RPFd4g9HhB+obWtVOFOi5AnTPQprojPJmc7NS9UiKJjeJv6hrccgcHZtXk7UiWtin7ePNviZPwJSi4tuojODUsGBM0B5FU8AupAnw8U6tmxWiIHVvMBg1i5gZl6xvYGkfvobFOMUYp5403859yxNXA2rqbUXVLFgiUwCZr29Px0ZIhsXgTQrYqnUBcdaL56lGxKQ7OqTl8NfGDwFWEA5SBOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=332InbhSvFoujt58TApZuDUj6cgS47yRA+YXkHRErTk=;
 b=GqZ611UB9vls7Bb9YQ09rWJXnX5T0W6HfQsxq438utO7KnegA1yYAMt0+KYz/2e6IMUeBTW2JToNNWeaP/G5RQ+gSgHx7IVJj+OcL/YNysQEKxJBfUg8bpxbB2VDtffgGvSDbdyMl4gzs2/0TqbCiLO8LZt+KTN61+pxSc7pvsuWkobNiiaXcipgqObGx8ppE070SapCwD06Qo3gPcux25mIyAoVsVynBjskvhrNY1PjBOtAWK53uz2oCRNnQlJqfpcHhwZZ2fATUATFaXKTMp6ghKwPGRBDrPVYtImhzSBbThh89sUCjh+69U0oTnB+DwrEUnkUZ6PorKS5LXhHzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=332InbhSvFoujt58TApZuDUj6cgS47yRA+YXkHRErTk=;
 b=icHqWD+Aq8H2Vf3Km6CvNx2mvymoTc1LpPH0GnVWVhHW0cpdwGDW4kgXkmG+UBTY649UFGOM7VkYYprohexyn4TYHzLLxDXc+1B2DDMC8sVnOGW/lRJVTbb7D6+XQcf8Ghz3ZtDnZaY8Yn2pbaOe6eY7VRiheSVU0R4DSDEmg/tqpfLx+5UCiHe9Mr2LPydi5GV3UDoBxJGTOaiwZp4Y0dNbvMa/b4YsJXeks94X+D2CFBJ3XMJ5einP2yd3h1mZ5eEQ8NBZ75UKFUJqtKU6rI+UfNJkdWH8SETldOTI/gR8rLhcZ2xAii3zk1u0a3MjcI92vWiWCcdBj2OLtQWZhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6571.namprd12.prod.outlook.com (2603:10b6:208:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Mon, 23 Jan
 2023 20:36:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:36:06 +0000
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
Subject: [PATCH v3 01/10] iommu: Add a gfp parameter to iommu_map()
Date:   Mon, 23 Jan 2023 16:35:54 -0400
Message-Id: <1-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0254.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: ce2f0c45-0261-40ca-97d1-08dafd8172da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmGBOM+lT9sib30Ho9U8EMwHSfaQhS4CARIRh6Vu/SZ34lbpsphqm6/OON6zzJvCwWLRUYpPJlnHzJwQe0dOldpKxLKoMBwiMflg9uZxrhEpbTOrXDWUrdYRCg1DbyGUjEEhqFB+viu7hv8pLhQ1+q1Gxp2c1zwiBaY+xh2yDfZ+bt9Uoy1oII2atdTdUs5jvKA6jUnf+tqBC8QcrI4zVoQfE3l1ghRX/dvCf0YF3usJ8V0hCn1VRH2zZvk1RjnPuSokQIKF6C9/s1Qc5r6awV/cROjaPP9qGmmBq6hvhfao1uy7dpqH4n4S5s8x8/ywTAomSOMvXV54S+CF0lALO+CnqowGqLdSviyIjankkh8fVeEv1FfH56QjmRGhQbjo5We1XQVBhYxmTaGJLLqe9VSc4iDFO0B2M/LXaHHAE2eNmzqXDfllyPqdXGblhOyWtedqJ1Q5Jqein83Ku0e5+2525+lOqFOEyX5tTLhWZdjqb5oAMMBtxI8NMDO/TXAg5E+sr0CCChXAEKShf0Rz4zAH8iYDh78qPiCD0WuMS9v9ENYKsZQnVgthwKDv4xXfEq4Hgl5aojiH8SevWrXK7oYF48pXdt4X0phZJD/I/lEBNNeACfqVQS7YAKYl62E79si318NW8MYqJT2cxUT4UWE0sS28Us81D+ZlJr8TDDe8FuUjlhOO4tz4PvE6J6ti
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(30864003)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FGWsBdhmsXKABhmTFC/ispqOyPHIqXxJhEJpXA0wL/IF3NttdQXOLwliEj2p?=
 =?us-ascii?Q?dD68wF3Cva9wL4Pu5Orcq7lrpA6YpsFdCFxFDOQUvGkyrgm48KBRrxcxaa0O?=
 =?us-ascii?Q?3blVL9R55CmQuE7CxEeSu/71qF2js/rvN+ZVjHAksvju976tKupHTNpw3JOr?=
 =?us-ascii?Q?Aul8iS9cXdScXAHY6qfbFFb+kVADI/AS0ovLYdzrRgUpnaPEfPwMkHd/kC9m?=
 =?us-ascii?Q?p2QsN7EM/sFhXJsfnTvdaHcYFOCneXPPuDHc507CgvN8ou2218ZxSxGQgCnZ?=
 =?us-ascii?Q?suihBwf+jvPQxJuEDmxAfiA1it+acUu9LaPWPjSwv1w1Bi/vHzar3+O/XqPz?=
 =?us-ascii?Q?U3UCvXeogcTbSTwVBWx2ZMhOZvfw7Zn6CxTOITAH8JrKXAw4Wx1KvtTXDfbU?=
 =?us-ascii?Q?5VZ43aJLr3Fz0YSkmQV0LAcKpxAHWzWL+dURMLQNTFfVcHwoJpc9323DIsCR?=
 =?us-ascii?Q?UpUNO9uyVhoexDrnHdqRK70mkS41b6c+P49FFXuZYFVQRWEyOFAKq9jYVu+F?=
 =?us-ascii?Q?WumpiicQ1HdbsbfKo8EhBjf0kQ85NWSB2mKbwxi01kybTQ8q1hyYoaLDpli/?=
 =?us-ascii?Q?/lMLTG7citmBPxyCZQmAj1EWuKswfOsdxsARslktFe/tNFdv0CvpiBxvqIW0?=
 =?us-ascii?Q?PhM0R0FNiWlhUlkVAIUQW16amkXQKvlvqgnI3iEvHmGxjXOB7rSCWLK6MntC?=
 =?us-ascii?Q?IYWzcRprKdbgEBgfKcGoWUSEi1Ze8btxwTipLfOAxBcv2XyA00KzGChAQ/ku?=
 =?us-ascii?Q?wbk/9WG57zGeWHlvTbqyXMODU2O6IBCILLts21eA8abeXx7PCTEF0BHy32tY?=
 =?us-ascii?Q?+5oos8CTeOFbI91SRyPQKvMue+hg34pJmVnHtwvFQM1dX0hBg+LH1ki42TEI?=
 =?us-ascii?Q?1gItydopWTqRUBeEqDmjobU95l2EHi0UK9S7QILIr+aV2erWdW3fS8RZ1YeO?=
 =?us-ascii?Q?iUpvl3fRR4N6OGkfZOEcluyuu3ErI7nsliAbuWWqiIogSIq/mjy34euhrXWW?=
 =?us-ascii?Q?wIQf9uYg5hBkWAe57mxC/gTYt13GXpEOks5PCAqEMhuiWKuXgek0Fu2eOARl?=
 =?us-ascii?Q?9cTlVc2YNMTNKeLlQmNfbb6NZZqaSFleQHJmJzULLrUqqp+/Nb1EK/RqgPDq?=
 =?us-ascii?Q?n2Khw7EnvMv3rtOHUcbqSuL1DHMPU7r9js1do/BUb3tN4EMSM7PPLfG/AodH?=
 =?us-ascii?Q?pJCO6GP1dw8jqTgK0el6izvLyl7Vyhjga8BdllGMlbxqhyWp/WuIP3GJvXDm?=
 =?us-ascii?Q?LDdgwvvrl3mI+7D6EfOrEpkqR9J+4mMJjx3L/MnQL5Mw+cMJXG0dzoRyNet+?=
 =?us-ascii?Q?DzaEbDPTzPRAozQieoEW0CbGRVXKaZZeLHkgzaoWEmRZpcSRNHJa9HOvElRN?=
 =?us-ascii?Q?CqU2IJIYGst0sZpan8JuvMmx4Qwn5vfpLNQXbq0uvamh9Dfg8zja/29z6zQL?=
 =?us-ascii?Q?6Quz/WMT5XhgVAsEHh1QUdYNbG3C2RAXD9I4A1AAQC8rgiOVcERuChMRUlV3?=
 =?us-ascii?Q?L6H/ZbpIVn9PlCAWpzucbkThFkmMUuRjjYvvrVKE47IWeV8BbB+ZFJ3rdMDe?=
 =?us-ascii?Q?amoPSjK59HbKAstq81G9VCISZOgbhRudfxelaaQr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2f0c45-0261-40ca-97d1-08dafd8172da
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:04.8382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkITqmLTbdSOmWYRZg68uXVPvmivKTjXGi1YUju/FublTFqqOsaOZxj0t8pXlFvN
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

The internal mechanisms support this, but instead of exposting the gfp to
the caller it wrappers it into iommu_map() and iommu_map_atomic()

Fix this instead of adding more variants for GFP_KERNEL_ACCOUNT.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm/mm/dma-mapping.c                     | 11 ++++++----
 .../drm/nouveau/nvkm/subdev/instmem/gk20a.c   |  3 ++-
 drivers/gpu/drm/tegra/drm.c                   |  2 +-
 drivers/gpu/host1x/cdma.c                     |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c      |  4 ++--
 drivers/iommu/dma-iommu.c                     |  2 +-
 drivers/iommu/iommu.c                         | 22 +++++++++----------
 drivers/iommu/iommufd/pages.c                 |  6 +++--
 drivers/media/platform/qcom/venus/firmware.c  |  2 +-
 drivers/net/ipa/ipa_mem.c                     |  6 +++--
 drivers/net/wireless/ath/ath10k/snoc.c        |  2 +-
 drivers/net/wireless/ath/ath11k/ahb.c         |  4 ++--
 drivers/remoteproc/remoteproc_core.c          |  5 +++--
 drivers/vfio/vfio_iommu_type1.c               |  9 ++++----
 drivers/vhost/vdpa.c                          |  2 +-
 include/linux/iommu.h                         |  4 ++--
 16 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index c135f6e37a00ca..8bc01071474ab7 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -984,7 +984,8 @@ __iommu_create_mapping(struct device *dev, struct page **pages, size_t size,
 
 		len = (j - i) << PAGE_SHIFT;
 		ret = iommu_map(mapping->domain, iova, phys, len,
-				__dma_info_to_prot(DMA_BIDIRECTIONAL, attrs));
+				__dma_info_to_prot(DMA_BIDIRECTIONAL, attrs),
+				GFP_KERNEL);
 		if (ret < 0)
 			goto fail;
 		iova += len;
@@ -1207,7 +1208,8 @@ static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 
 		prot = __dma_info_to_prot(dir, attrs);
 
-		ret = iommu_map(mapping->domain, iova, phys, len, prot);
+		ret = iommu_map(mapping->domain, iova, phys, len, prot,
+				GFP_KERNEL);
 		if (ret < 0)
 			goto fail;
 		count += len >> PAGE_SHIFT;
@@ -1379,7 +1381,8 @@ static dma_addr_t arm_iommu_map_page(struct device *dev, struct page *page,
 
 	prot = __dma_info_to_prot(dir, attrs);
 
-	ret = iommu_map(mapping->domain, dma_addr, page_to_phys(page), len, prot);
+	ret = iommu_map(mapping->domain, dma_addr, page_to_phys(page), len,
+			prot, GFP_KERNEL);
 	if (ret < 0)
 		goto fail;
 
@@ -1443,7 +1446,7 @@ static dma_addr_t arm_iommu_map_resource(struct device *dev,
 
 	prot = __dma_info_to_prot(dir, attrs) | IOMMU_MMIO;
 
-	ret = iommu_map(mapping->domain, dma_addr, addr, len, prot);
+	ret = iommu_map(mapping->domain, dma_addr, addr, len, prot, GFP_KERNEL);
 	if (ret < 0)
 		goto fail;
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
index 648ecf5a8fbc2a..a4ac94a2ab57fc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
@@ -475,7 +475,8 @@ gk20a_instobj_ctor_iommu(struct gk20a_instmem *imem, u32 npages, u32 align,
 		u32 offset = (r->offset + i) << imem->iommu_pgshift;
 
 		ret = iommu_map(imem->domain, offset, node->dma_addrs[i],
-				PAGE_SIZE, IOMMU_READ | IOMMU_WRITE);
+				PAGE_SIZE, IOMMU_READ | IOMMU_WRITE,
+				GFP_KERNEL);
 		if (ret < 0) {
 			nvkm_error(subdev, "IOMMU mapping failure: %d\n", ret);
 
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 7bd2e65c2a16c5..6ca9f396e55be4 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1057,7 +1057,7 @@ void *tegra_drm_alloc(struct tegra_drm *tegra, size_t size, dma_addr_t *dma)
 
 	*dma = iova_dma_addr(&tegra->carveout.domain, alloc);
 	err = iommu_map(tegra->domain, *dma, virt_to_phys(virt),
-			size, IOMMU_READ | IOMMU_WRITE);
+			size, IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (err < 0)
 		goto free_iova;
 
diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
index 103fda055394ab..4ddfcd2138c95b 100644
--- a/drivers/gpu/host1x/cdma.c
+++ b/drivers/gpu/host1x/cdma.c
@@ -105,7 +105,7 @@ static int host1x_pushbuffer_init(struct push_buffer *pb)
 
 		pb->dma = iova_dma_addr(&host1x->iova, alloc);
 		err = iommu_map(host1x->domain, pb->dma, pb->phys, size,
-				IOMMU_READ);
+				IOMMU_READ, GFP_KERNEL);
 		if (err)
 			goto iommu_free_iova;
 	} else {
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c301b3be9f303d..aeeaca65ace96a 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -277,7 +277,7 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x",
 					va_start, &pa_start, size, flags);
 				err = iommu_map(pd->domain, va_start, pa_start,
-							size, flags);
+						size, flags, GFP_KERNEL);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
@@ -294,7 +294,7 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x\n",
 					va_start, &pa_start, size, flags);
 				err = iommu_map(pd->domain, va_start, pa_start,
-						size, flags);
+						size, flags, GFP_KERNEL);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index f798c44e090337..8bdb65e7686ff9 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1615,7 +1615,7 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	if (!iova)
 		goto out_free_page;
 
-	if (iommu_map(domain, iova, msi_addr, size, prot))
+	if (iommu_map(domain, iova, msi_addr, size, prot, GFP_KERNEL))
 		goto out_free_iova;
 
 	INIT_LIST_HEAD(&msi_page->list);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5f6a85aea501ec..7dac062b58f039 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -930,7 +930,7 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 			if (map_size) {
 				ret = iommu_map(domain, addr - map_size,
 						addr - map_size, map_size,
-						entry->prot);
+						entry->prot, GFP_KERNEL);
 				if (ret)
 					goto out;
 				map_size = 0;
@@ -2360,31 +2360,31 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return ret;
 }
 
-static int _iommu_map(struct iommu_domain *domain, unsigned long iova,
-		      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+int iommu_map(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	int ret;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
+	/* Discourage passing strange GFP flags */
+	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				__GFP_HIGHMEM)))
+		return -EINVAL;
+
 	ret = __iommu_map(domain, iova, paddr, size, prot, gfp);
 	if (ret == 0 && ops->iotlb_sync_map)
 		ops->iotlb_sync_map(domain, iova, size);
 
 	return ret;
 }
-
-int iommu_map(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, size_t size, int prot)
-{
-	might_sleep();
-	return _iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
-}
 EXPORT_SYMBOL_GPL(iommu_map);
 
 int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot)
 {
-	return _iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
+	return iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(iommu_map_atomic);
 
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 1e1d3509efae5e..22cc3bb0c6c55a 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -456,7 +456,8 @@ static int batch_iommu_map_small(struct iommu_domain *domain,
 			size % PAGE_SIZE);
 
 	while (size) {
-		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot);
+		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot,
+			       GFP_KERNEL);
 		if (rc)
 			goto err_unmap;
 		iova += PAGE_SIZE;
@@ -500,7 +501,8 @@ static int batch_to_domain(struct pfn_batch *batch, struct iommu_domain *domain,
 		else
 			rc = iommu_map(domain, iova,
 				       PFN_PHYS(batch->pfns[cur]) + page_offset,
-				       next_iova - iova, area->iommu_prot);
+				       next_iova - iova, area->iommu_prot,
+				       GFP_KERNEL);
 		if (rc)
 			goto err_unmap;
 		iova = next_iova;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 142d4c74017c04..07d4dceb5e72c7 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -158,7 +158,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
 	core->fw.mapped_mem_size = mem_size;
 
 	ret = iommu_map(iommu, VENUS_FW_START_ADDR, mem_phys, mem_size,
-			IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV);
+			IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV, GFP_KERNEL);
 	if (ret) {
 		dev_err(dev, "could not map video firmware region\n");
 		return ret;
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 9ec5af323f731d..991a7d39f06661 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -466,7 +466,8 @@ static int ipa_imem_init(struct ipa *ipa, unsigned long addr, size_t size)
 	size = PAGE_ALIGN(size + addr - phys);
 	iova = phys;	/* We just want a direct mapping */
 
-	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE);
+	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE,
+			GFP_KERNEL);
 	if (ret)
 		return ret;
 
@@ -574,7 +575,8 @@ static int ipa_smem_init(struct ipa *ipa, u32 item, size_t size)
 	size = PAGE_ALIGN(size + addr - phys);
 	iova = phys;	/* We just want a direct mapping */
 
-	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE);
+	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE,
+			GFP_KERNEL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index cfcb759a87deac..9a82f0336d9537 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1639,7 +1639,7 @@ static int ath10k_fw_init(struct ath10k *ar)
 
 	ret = iommu_map(iommu_dom, ar_snoc->fw.fw_start_addr,
 			ar->msa.paddr, ar->msa.mem_size,
-			IOMMU_READ | IOMMU_WRITE);
+			IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (ret) {
 		ath10k_err(ar, "failed to map firmware region: %d\n", ret);
 		goto err_iommu_detach;
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index d34a4d6325b2b4..df8fdc7067f99c 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1021,7 +1021,7 @@ static int ath11k_ahb_fw_resources_init(struct ath11k_base *ab)
 
 	ret = iommu_map(iommu_dom, ab_ahb->fw.msa_paddr,
 			ab_ahb->fw.msa_paddr, ab_ahb->fw.msa_size,
-			IOMMU_READ | IOMMU_WRITE);
+			IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (ret) {
 		ath11k_err(ab, "failed to map firmware region: %d\n", ret);
 		goto err_iommu_detach;
@@ -1029,7 +1029,7 @@ static int ath11k_ahb_fw_resources_init(struct ath11k_base *ab)
 
 	ret = iommu_map(iommu_dom, ab_ahb->fw.ce_paddr,
 			ab_ahb->fw.ce_paddr, ab_ahb->fw.ce_size,
-			IOMMU_READ | IOMMU_WRITE);
+			IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (ret) {
 		ath11k_err(ab, "failed to map firmware CE region: %d\n", ret);
 		goto err_iommu_unmap;
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1cd4815a6dd197..80072b6b628358 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -643,7 +643,8 @@ static int rproc_handle_devmem(struct rproc *rproc, void *ptr,
 	if (!mapping)
 		return -ENOMEM;
 
-	ret = iommu_map(rproc->domain, rsc->da, rsc->pa, rsc->len, rsc->flags);
+	ret = iommu_map(rproc->domain, rsc->da, rsc->pa, rsc->len, rsc->flags,
+			GFP_KERNEL);
 	if (ret) {
 		dev_err(dev, "failed to map devmem: %d\n", ret);
 		goto out;
@@ -737,7 +738,7 @@ static int rproc_alloc_carveout(struct rproc *rproc,
 		}
 
 		ret = iommu_map(rproc->domain, mem->da, dma, mem->len,
-				mem->flags);
+				mem->flags, GFP_KERNEL);
 		if (ret) {
 			dev_err(dev, "iommu_map failed: %d\n", ret);
 			goto free_mapping;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00d4..e14f86a8ef5258 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1480,7 +1480,8 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot | IOMMU_CACHE);
+				npage << PAGE_SHIFT, prot | IOMMU_CACHE,
+				GFP_KERNEL);
 		if (ret)
 			goto unwind;
 
@@ -1777,8 +1778,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size = npage << PAGE_SHIFT;
 			}
 
-			ret = iommu_map(domain->domain, iova, phys,
-					size, dma->prot | IOMMU_CACHE);
+			ret = iommu_map(domain->domain, iova, phys, size,
+					dma->prot | IOMMU_CACHE, GFP_KERNEL);
 			if (ret) {
 				if (!dma->iommu_mapped) {
 					vfio_unpin_pages_remote(dma, iova,
@@ -1866,7 +1867,7 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain)
 		return;
 
 	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
+			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE, GFP_KERNEL);
 	if (!ret) {
 		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f785dfdec1..fd1536de5b1df0 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -792,7 +792,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 			r = ops->set_map(vdpa, asid, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
-			      perm_to_iommu_flags(perm));
+			      perm_to_iommu_flags(perm), GFP_KERNEL);
 	}
 	if (r) {
 		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 46e1347bfa2286..d2020994f292db 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -467,7 +467,7 @@ extern int iommu_sva_unbind_gpasid(struct iommu_domain *domain,
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
-		     phys_addr_t paddr, size_t size, int prot);
+		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
 extern int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
 			    phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
@@ -773,7 +773,7 @@ static inline struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
 }
 
 static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
-			    phys_addr_t paddr, size_t size, int prot)
+			    phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	return -ENODEV;
 }
-- 
2.39.0

