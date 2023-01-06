Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24176604F6
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbjAFQoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbjAFQnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:43:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A41880607;
        Fri,  6 Jan 2023 08:43:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5c+hcTUCt3C55plw63Icci7GYWAOZnhERcZ2/nvYpq0BYByKL7/Q3flLjLpwCPoZeHz1YC3b8ojlYMKp8MUeS3VZaaAoHrVeE0DfRzGqWpmEsKpgWQiVGyTPRVhgGZIPEM2MeZfLnlwEIc6WJaR7w/JDf2+HSz2cM3YkRaWRn8fx/MAhgrP3tFGZL3Io6rp9YKb7QjXwDWiZBOVtdLEKVjSCL7Tc5x0MMkm88g6XJxykUE2Z/TUBQSlSJD33DKMbIMfKR6FudgITrs7IeQ1fe6afUkzNM5duVNL9cgIT8tw46bBQOg+vC7+lObqON9W5uLnX6spm6StBijQsy/+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzQQRba27ib0zIdur5Q2BtDxU6+ZR1VaUSgsxRsnoJE=;
 b=JHkQIF6KnrJjbYgJAxagCSHyJmZnD/ZtFi0DRMmqh6krs7sNBSmbvhTAENnhBoYiBcBqGTXf90q+PyGsir/paeuDfrGCyy96oZcq+DzSs3ptIUuswrSwJjdQUzW1ewK3NTWTLAwcqy060OlMJo0QZSSpS1/rQ1Qk9NyTuEXJECpYjvIa5mLJWfu3eOCesPRvV4GLTzR6cuL1RvAqnaK06ZFUq9pndPgLjQD5S40dXLQrovlYAMQ9a7JQpiBScoU4rInI5ETm3YIezgM2wvHngrCT8AaLDaT9/zvGVGVxLWSz2hMtnJfLoYBmmYpTZks+zIf9JtKGvDAtA6FdJ+jKjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzQQRba27ib0zIdur5Q2BtDxU6+ZR1VaUSgsxRsnoJE=;
 b=Qp/PCc0YP4Np2Df5kWB36htRYa8J09YR3WSPNiLFOlSPOP/WJjEOiCWWD/SgJNzb3kBsNI6h2nIkD3rFgHAaBbmRJp25iMmZ5afkzFgR0Lc1NKNPOKBFKAo562YJWACPHHCZ8Ezvth2zIfxUu+u77/JU6QR3Wmfxp0UmpeT+jr19/PzOV7V1xN+t91yg/wtZxxMwtaBTduNaPUuRwHrbxIvuw5ZNUMOiVZ4EUff28xwQi2Y2YmdYI3yrgMenRL4bJ63Ooikj+EviSoX0stdkh5ILNetz/Dr83HxSfakvwtrfpRyMYF21TgytsmzqFWKoaIt2M6z1Y6ON31AzDi/vig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6437.namprd12.prod.outlook.com (2603:10b6:8:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 16:42:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 16:42:56 +0000
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
Subject: [PATCH 2/8] iommu: Remove iommu_map_atomic()
Date:   Fri,  6 Jan 2023 12:42:42 -0400
Message-Id: <2-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0105.namprd02.prod.outlook.com
 (2603:10b6:208:51::46) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: 933ac33b-cb20-41e0-650d-08daf0051003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y96ISAteCpjSWTtFmmsDjxI4coOxOANOS6mzaB7N9SaJNb/1GcQtKO1PY6xogdrtpgRwd+hadAxNTVhu/eX2CklN9LU8FI0m2zDTwaljiIKGiOeFrcWx4kQMf1g/zhmlr2A5wkXP2qaEchQrwZJE7WJC1VnGQjpn4ECQyobtDXIu541tZ1Jt0m7BqoVsUiSr2mJaOJoszYoelU/y6HaQLg5EgSx4ezgGSfZLJRs0vuNd+mr6G7o0+d8ufhLZxviwLNub2ohgjhjQkHnEsID5XgpYAHaQvC4YBnnOeeYMU+zV7QfXZtEwa1YN/XtOKhlY92n/Rx519BHNP3CFuNUJ6NuEBFoXKCAksWfaB3hfRmmiug/e9g70pdNwcBw4LNMi+4jmcUhHBhFF+wkZ9VUKW11J9EQUn5qx467GOX/lG7HFad/5vOD3TB7/Gh1tXHYguS2Ih8QK6n8URpLyoEq5iuxEY5LoFYpK/18M2duA6V5ZPUtdq54NmdRFcOvnwWcAvaLkq0CnNT9P8YqtOCTd9rWdsjlxtxTftSqwWd0CnoU3av/L7t7rt86POqCDN/ROcTYxkAfdzRgPhFqQj3XWrgi7noS5e3E7weMeIZpohf83+2G9fyzjq871ec7VLMMU2R/JcJ0zZPzKLZ0lT2PIYaq0dXegmDiVpUZN4kW6sB42Fs4DZp1rE0NXlNN4a1Gt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(7416002)(5660300002)(54906003)(2906002)(41300700001)(8676002)(66946007)(8936002)(66476007)(316002)(4326008)(66556008)(83380400001)(6666004)(478600001)(110136005)(6506007)(36756003)(186003)(2616005)(26005)(6512007)(6486002)(86362001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ToqhmP2tJXlkVUzifmeafPSm4bo7BAYehL0+YHwG3D/i9T44p8S+8oup8A0?=
 =?us-ascii?Q?lPcIPRUdbH9Q+TX4MU9yMmdj9HJ8VK34klYMZduWtbxpxQlmsKZ8blVHlnOj?=
 =?us-ascii?Q?X6dphUlLK8eJCADc7/9C7p3N97LuuTEFk2gjxWoxZM1CliHAjBFMohsLvNIQ?=
 =?us-ascii?Q?JtWWXHx/jVgdpkesHwtZCl0wA7RYkbb6IRTkZHI0KWxlcSGkHHwv25BMkbsf?=
 =?us-ascii?Q?qITaur6uCfDZ9VPfnERGnM7EfNQmrsMdCTvK1jcqsAgwQ5VRGJCJhNYg0lho?=
 =?us-ascii?Q?zdidOKTCv6BvPzzD8sbp38xAEXNCIgBiUYH3iKebAkwb1sb1M7U31EdMVpw9?=
 =?us-ascii?Q?hAvALGdmvfCdub9CB1FkAQ/Zw97Hzefpd83gpnAyxDR4jsGs0smg0BHDx9k6?=
 =?us-ascii?Q?fRDmYjJhka+JfutLBLT4MQWR/VBTCkFfCr5DqleNnYYBjHH6VFj5PKMCrH5b?=
 =?us-ascii?Q?S7WkO6049zhX7sq2PUY2CVONltgOibjF6KIyjjerA9Z16nLj5cZIGs616kxI?=
 =?us-ascii?Q?v1/nfY/t/ZhChdHoadXoKZHYwBxlGCScTo72ebz1fSRCenmjy9ZTy03sIfMW?=
 =?us-ascii?Q?Xf6cQEkXS0enbq8e2EzSAxjmrGl5Nq6eARuur5lzk6dGhwWroGARFvsZP4Yj?=
 =?us-ascii?Q?GtT8jYFcwy6zpdH35FFb2Yo3hEo6Wa3GzXB1FH3lbaHYN6X6O2ALBVvBBjT0?=
 =?us-ascii?Q?YKLAmhhWGXKvRVzPSTS6/w555NzxD2rxlDO6ZXYFKXXIvW0cvE3a8wd8MNNi?=
 =?us-ascii?Q?1enJ6kjqXIKj/ken0/1zCp5MQ5cHsrCajZp5TgMl3k6U+6CZLx92u1lyitaH?=
 =?us-ascii?Q?d6J6vBTZH/NAF8S/Qel3O6xsZ+V2p65j6ad8+CibPurod+muJBAoXy+E3Hoh?=
 =?us-ascii?Q?EHG4ZE9trhFEFUDCDEvMdWmZTy7Vn3S9zOuGSUDbaeNOiy2Bu5kOj/bIqNqb?=
 =?us-ascii?Q?HV4iKpOC6GgGOTb+SP8wj/P/OgNNdvp72gPT2HiyYpNH1c0J5RRCOKjCyCdy?=
 =?us-ascii?Q?1w6WiZ3J+trH+zkXZHLBOLQy3dngDODxoVEPNCRFuE4CNoUqVjYRFdgNrQNc?=
 =?us-ascii?Q?uoqN1rKKKcxFliUIrfJud3Q416t8b43HtfA1p4uuBSbcRsfOyF1WaXGu3nby?=
 =?us-ascii?Q?38R9/B/58QcfLPfgjeAosHBc6g2gx6sS7hihUfA9OrLHYW0o3TsmAObuAnKn?=
 =?us-ascii?Q?vy6XOWUp6+GPcJ9ZZ9voWq6i4OyUjJPeAMtfmnL224aRPwXvE7R66zFY7gLu?=
 =?us-ascii?Q?SgWJI2Kpc4CYGTV+3Rarm9ru6rjbqXD+Pppy1PoZGPoO3YUrq4rNhDT09Gck?=
 =?us-ascii?Q?KYD6R8MqoGgEajQWp0R/ljKk2tunQ+VBKuJ5xCaE9+uchYg/tK7CQLqsAXNx?=
 =?us-ascii?Q?lCOHQWCYZc8CPFYpA7FrsdFWBTn7Bui76wHDU6EUW7S7CfvqAU/HBss6YYyt?=
 =?us-ascii?Q?jyDrGPwDYAsqJCLcpUeluFX21tr3rC0G6Bbdu5Di6gP23zPYnsQQwqxEi4JR?=
 =?us-ascii?Q?5zTZ2FUIyePHDnlKPOqmSfP14s26+zPMn0BZX92auJC11HTx6kzl59RyRIXi?=
 =?us-ascii?Q?oMIrxmGYZul30lTmrOmmF5wBEAdbzua5WUpnp8eR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933ac33b-cb20-41e0-650d-08daf0051003
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:42:56.2381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBnEyYVrRv2EVy7GJC5T0woZ+vqDqEhHFqi5LhvZP5oK+A50TeUz84D52u+FJkGi
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
index fe29fc2140b132..fee37bb246f3ea 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2376,13 +2376,6 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
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

