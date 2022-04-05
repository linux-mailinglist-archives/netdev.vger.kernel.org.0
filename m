Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBD54F424F
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244767AbiDEUAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457616AbiDEQSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:18:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FFF19C16;
        Tue,  5 Apr 2022 09:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/HOEJp1fiJka0X+UzXl3p2VBHGCp2QL8VO2WQSqmXGbkYb4SqvJ+bBHCP8Dsw+P+VBd26MNK46srlmUtmctPBrUV759giChF37fWlrq9m6yCAEV1LEqZwc6/4Y8LZ/J5Kx0ldPh/+enp0DwDMnMSON2l+VCSkFHNX98VdS5OA4pA64HLYtkSf1VADIE0qpU5eVKEPrrsn3fEMZ+Kpd0m69pb84KSA0FN8Fq7CeIwVMuedYTAm40YAtn/1lhdd93CTLWDDgs76t6BFHXL8zuf/s/7W5eu9AEG8JdJLN4qCRFEaB42nLsavIzmx4+sriuPupNmBbJSGIh9p07rMKqcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rJMAM//g3GG6PN8WYRNfcOTDWEB0/sAjxYzw+ILqvk=;
 b=ijSARo25Iie3l45l2NAGDyxUx+dxw6zAYbOYUbTorKNqu28d6gmpEx7FU6nHI73jqxDExwSXq8r7s5osWBZhrT36163pw1lgTzP0yQ2loQDwu1skQq22TgX21R8L4cQNrQBxR7dHMOpCKW0RXfLkPZK2XJLdEKNXAzm4V7UgvG4C75nXkB/uKIB6bd4RHeAePLTAx2U9RXFfiOF6w1f5ec+Lnf4b5PKYQhpfwlUr/9id/vK0E05LqKJng8jj7PeBzpM1vicm4R5pkNie1N0hxsnthqxoFGO/6FV+M/oEmSuQhjUisu2uJ+HMswNmqe9KeVOgJJ14nCVmSCWyFGWbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rJMAM//g3GG6PN8WYRNfcOTDWEB0/sAjxYzw+ILqvk=;
 b=JZc2HOkkr5rohL0atxegmfCwKZqI4wbHvavocv/TEF4iBtHYUJzgkI8g7kMUtMT6AOyqdQ28/HEVyJ901kY2bPDbNBNgI9IPTL0BRB/+zvqdPR3nP3+f45Od5DfGmP+O9CrOkusuEq6PoaXuZ6B30EmUAq21tblb08Lty3XtK4WZDRqVpNOryYaCnT/E1z+3VeZ/zTtJaRzU691hdcPrMwkO7KOicpcbdevJXeOT36wfUSBtdFOlXlvoS67Xu3PyZNy9fOVzIElC0GrH7c0vuRXNQLto8zvAy66WSNnev6992YeFiYJHhLzZgcTcV3NipDnnreOLlrZDbN+7QKQOmA==
Received: from BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17)
 by MW2PR12MB2506.namprd12.prod.outlook.com (2603:10b6:907:7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:09 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 16:16:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: [PATCH 4/5] vfio: Move the Intel no-snoop control off of IOMMU_CACHE
Date:   Tue,  5 Apr 2022 13:16:03 -0300
Message-Id: <4-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:208:32e::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 731aaced-2fcc-420d-ecd1-08da171f96ae
X-MS-TrafficTypeDiagnostic: BN6PR12MB1153:EE_|MW2PR12MB2506:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB115359FE34392E58B75136D8C2E49@BN6PR12MB1153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FIMy67zoM4b5OBJtY4r2m5qgeyvqom2HJosJfjGHgHt3V+CBySSyQr1J80+d56zJWFe2gGoECFccp3DMpUCT/LGajPKchK3BuJy8voutIs5dLPGt/ifE3jOK4t/6+3XrSyYJOYRaYDy7CtiylpdobAPgu5jmPcWuek7ZVyWalu/Kp7/2EAi0cG60Qy1FvobZibq1j7ulEOXQ017DJwWoEajIS1Xqe7xEd/GFOKqD6NznmYSjAdgXHEA0B5W6ygl8LYKyJZVjbh+lpREwlyDTU/HuPjoZws0FsM9m8PrjvfL4eKkBIEbWCnMRxOylkdn66DGoNc9fF8Yh6GxiJIiYUO5YNBNXwd1JsSAqVRLIPKyApyqxJfCvwXj1Z5HZ5arAjMQRW0olokb8WDmvxYX49CoVPye5SGPyB7AwpuU16NyEm6BdnNXrP6ZWViIzCQA9cpLgCCPsdQwE3A+ih8i5woqdMOupmS1Qu4ZT4d5ZMtM/4eWrYciqJE2lsh7KrOGkjYRQDgEM0BS0WFFEuHs2S9wD/2WbVgfTtZnDBWXjSdbpIQML5PEf7u188srU3wo6Y8AEx0qKMo4IizOL3VI2dwP27m7lcJVp7WKK7I85uTkA63YcvMggrJ9vBfYEmeQOOqsB7cX3DLNQu++gLnR4Kq4QRvt2ARIBFkDjKTtFsx2ed3kmR/w8IzKZyXJuK70CesERbqGIPW5NWvAMiNlNzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1153.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(508600001)(7416002)(38100700002)(8936002)(921005)(2616005)(26005)(186003)(6486002)(83380400001)(54906003)(66556008)(86362001)(8676002)(6512007)(6506007)(2906002)(316002)(6666004)(4326008)(66476007)(66946007)(36756003)(110136005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gT00MiJyk8qem9OtNL1VdGnRVxR/BXjU+F6FzTlKKPkV3O7c/kJLwqmJdCaJ?=
 =?us-ascii?Q?NSWWF6yGDgNYPMrrnrmxGCv4xGWTzztMKOPOV/hDiaDUaKP1bdqZhmPF3fS4?=
 =?us-ascii?Q?Er2O5WJtExkF02yHpfYIWsmmBZBUuZ9lObpYxwxZe3coDxkHWFE7HQB47RkX?=
 =?us-ascii?Q?MyJb4/CIt2MvrRK2IwG0ckb4yOKUEIp01PBiMvkifaUc2l/lIKxprGg338V0?=
 =?us-ascii?Q?ili3XFaqp+DMM3UkEJCzf/+1uWnqktQmEAdVd9a+9iKREjC68nQz3ry+1eVS?=
 =?us-ascii?Q?ERGG+W7hnf6ocNSW2F7dJ/7g2pOvMLBgm00V+HUsHK3gJs5fXDp9PeU/5Wq0?=
 =?us-ascii?Q?9zg5ZXZl2hvw00R7YtxfLZd4Bdi3QIzikJq4gmzN+SCBeLxN5ZTAYN+ZvCTv?=
 =?us-ascii?Q?/QJP/vXOVTfRvB7rxfSyzxptYrJXeuD55v1tDKiNsNlYaFydr13RSSwZTMmU?=
 =?us-ascii?Q?qJDs1L1rvlNF6trqVObc6xUROluc283g5+GrF1YLRBOS9txwPjMiw3Ug/2Ub?=
 =?us-ascii?Q?9eQhXeLni27FaMQAvRjAiV9G5MlNaWgZAhpZVRpwCSTrbSEjzLKlBKmA1GBt?=
 =?us-ascii?Q?2sWAfcDKZ3puiHkxDeBHzKCG+di9pIZ7/RB/BqhhlsxUek+Vt9VGL8Wo3/id?=
 =?us-ascii?Q?MPCG7N9NueCHAytIHVCtTbD2kSJCnIwlRLdVXE7wCHrksHyiNvqal/2xKMx/?=
 =?us-ascii?Q?lDzZUyfYulCkCzXSGZesQI12R2cYgiOdsXqVgpvhYg5sRveuray/vF4XAz6u?=
 =?us-ascii?Q?tJv36yKxaTz0ZArw/2+s1tugVtQwN6gkz+Mt26EZVAp3IPqiXvW0yBxCHfKM?=
 =?us-ascii?Q?rgO1ZgPR5UdMaJry75o2KeImW2fsxSB+eoG42SR97WHpz+ARnt26L00qkzyS?=
 =?us-ascii?Q?n2i3Gj6GErnbFQjNOsZjC4dr3Z6LrW3Zm7TUHtMg7yITaAz/xV/eSyoDAY7E?=
 =?us-ascii?Q?Qq/WOZCwR/jNo8iIj5ctNRl3VSAbqG0q75U6EXvKBFzbhU8FfrqX0u956XfE?=
 =?us-ascii?Q?QwDl3UK6uL/rLuV/lIuj1fb/CT/HPsMmmQ2hdOgOurLiEB152bW09dD94n9D?=
 =?us-ascii?Q?XHZFiBdhT+uUqZXuupN5yeEJFoUukJPk4jc8FxckzgmKFUk/QfOAPDvLz45E?=
 =?us-ascii?Q?3iDnsVZWKPsukYkYnreRtj967G1P/89rT4FCWziQieVwrw6Uf+s1qRjC5AkJ?=
 =?us-ascii?Q?FLKhjntNL7XqTO8DU9EGOb4shY9RdTRzmLe9p0lJhLtZ5x46JPmrh+ALFES7?=
 =?us-ascii?Q?ixgnwCIFHkB7eTYECi9wkkQCe3WwueMBP+D2hplJV9ERD4QE925tiSqphNfq?=
 =?us-ascii?Q?0jrv/o9bQFAj4dneBnCJE+7KLz3a+kVQSLKaWJB18Uf7TfSjl6COi/VelOyK?=
 =?us-ascii?Q?GqbhnCm/Yr+zXEFLtfNx9sYeEzrSYbz/TMR5iR8TDlt7iKzfmuitsxa4C2+0?=
 =?us-ascii?Q?49ps/CN/ZX40y6f6OF7gsTrjcfcjE+OLHjk4QO7OcU991NEPJ5yff5mYsaQj?=
 =?us-ascii?Q?yJqeC++6f4A1vXIrgYX2d/FtguXzNRK1xmmO/i6+ff9vX1PJ1mlnn7Taq/fT?=
 =?us-ascii?Q?DQtQ/RBdnYVjUaRXnIPZis+yDEv7CMFVEU6y3k3WgKP+Ux8NTb3eJVrxINb/?=
 =?us-ascii?Q?jXkw2X+wzgT7FeYaY+ef2TaWij7/gE0qnyWRIPRH/DhMqFd78w8QWHkXIIo1?=
 =?us-ascii?Q?2Cqa31JWxOJgwIkTch2v7hYnOTMho5vOcBuaWOVBnmn32GCF4usSEO645K1+?=
 =?us-ascii?Q?t/1ZWIBahg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 731aaced-2fcc-420d-ecd1-08da171f96ae
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 16:16:06.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzczWhkzm5fFCBX6dlnVRZ0KozIPF5/oigHvvKl1V8xx/4Rd5P1ZIMDKao9aHmzt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2506
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IOMMU_CACHE means "normal DMA to this iommu_domain's IOVA should be cache
coherent" and is used by the DMA API. The definition allows for special
non-coherent DMA to exist - ie processing of the no-snoop flag in PCIe
TLPs - so long as this behavior is opt-in by the device driver.

The flag is used by the DMA API and is always available if
dev_is_dma_coherent() is set.

For Intel IOMMU IOMMU_CACHE was redefined to mean 'force all DMA to be
cache coherent' which has the practical effect of causing the IOMMU to
ignore the no-snoop bit in a PCIe TLP.

x86 platforms are always IOMMU_CACHE, so Intel should ignore this flag.

Instead use the new domain op enforce_cache_coherency() which causes every
IOPTE created in the domain to have the no-snoop blocking behavior.

Reconfigure VFIO to always use IOMMU_CACHE and call
enforce_cache_coherency() to operate the special Intel behavior.

Remove the IOMMU_CACHE test from Intel IOMMU.

Ultimately VFIO plumbs the result of enforce_cache_coherency() back into
the x86 platform code through kvm_arch_register_noncoherent_dma() which
controls if the WBINVD instruction is available in the guest. No other
arch implements kvm_arch_register_noncoherent_dma().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c     |  3 +--
 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f08611a6cc4799..0ca43671d934e9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4422,8 +4422,7 @@ static int intel_iommu_map(struct iommu_domain *domain,
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= DMA_PTE_WRITE;
-	if (((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping) ||
-	    dmar_domain->enforce_no_snoop)
+	if (dmar_domain->enforce_no_snoop)
 		prot |= DMA_PTE_SNP;
 
 	max_addr = iova + size;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9394aa9444c10c..c13b9290e35759 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -84,8 +84,8 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
-	int			prot;		/* IOMMU_CACHE */
-	bool			fgsp;		/* Fine-grained super pages */
+	bool			fgsp : 1;	/* Fine-grained super pages */
+	bool			enforce_cache_coherency : 1;
 };
 
 struct vfio_dma {
@@ -1461,7 +1461,7 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot | d->prot);
+				npage << PAGE_SHIFT, prot | IOMMU_CACHE);
 		if (ret)
 			goto unwind;
 
@@ -1771,7 +1771,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			}
 
 			ret = iommu_map(domain->domain, iova, phys,
-					size, dma->prot | domain->prot);
+					size, dma->prot | IOMMU_CACHE);
 			if (ret) {
 				if (!dma->iommu_mapped) {
 					vfio_unpin_pages_remote(dma, iova,
@@ -1859,7 +1859,7 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain)
 		return;
 
 	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | domain->prot);
+			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
 	if (!ret) {
 		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
 
@@ -2267,8 +2267,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_detach;
 	}
 
-	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
-		domain->prot |= IOMMU_CACHE;
+	/*
+	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
+	 * no-snoop set) then VFIO always turns this feature on because on Intel
+	 * platforms it optimizes KVM to disable wbinvd emulation.
+	 */
+	if (domain->domain->ops->enforce_cache_coherency)
+		domain->enforce_cache_coherency =
+			domain->domain->ops->enforce_cache_coherency(
+				domain->domain);
 
 	/*
 	 * Try to match an existing compatible domain.  We don't want to
@@ -2279,7 +2286,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		if (d->domain->ops == domain->domain->ops &&
-		    d->prot == domain->prot) {
+		    d->enforce_cache_coherency ==
+			    domain->enforce_cache_coherency) {
 			iommu_detach_group(domain->domain, group->iommu_group);
 			if (!iommu_attach_group(d->domain,
 						group->iommu_group)) {
@@ -2611,14 +2619,14 @@ static void vfio_iommu_type1_release(void *iommu_data)
 	kfree(iommu);
 }
 
-static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
+static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
 	int ret = 1;
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next) {
-		if (!(domain->prot & IOMMU_CACHE)) {
+		if (!(domain->enforce_cache_coherency)) {
 			ret = 0;
 			break;
 		}
@@ -2641,7 +2649,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
 			return 0;
-		return vfio_domains_have_iommu_cache(iommu);
+		return vfio_domains_have_enforce_cache_coherency(iommu);
 	default:
 		return 0;
 	}
-- 
2.35.1

