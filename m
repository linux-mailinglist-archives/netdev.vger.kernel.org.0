Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DE94F40B4
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345852AbiDEUBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457617AbiDEQSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:18:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B443919C18;
        Tue,  5 Apr 2022 09:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=envp/g5Ogbq/mr4VcVqqfInc8+Pv8V0JCaE/rPG3UFUnUgPH9f0B+aksaPOYC43zIvYYFKdCcTMNLSQeKhN54MNtKOX5P7aFl5yngIY8zsXvFWYOuCp0AN6O0pusWkwRWar3u0bPGNlhDb5HTi30kqHo9g3Ox+u2RflMZNKlesJsPt3BXMpORKuSdWofPz6jfwRNjguTYZaifxvuJvPKtPwV7As1rSuENhjEKbN8jpp7YhBMkpzoRRSc1j907sDUJDruc7jlknLV+S9daA+OR6SVPsHXNIS1KqxKuUOtJGR28X7O8JY7eBZI6guWoljF1kwdQvIRSfofwJZGxm7HlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caLncysSLkUFjIJU7XS5btAFcz/iwrDZ/0nbwg2upIQ=;
 b=nYR3RY8fVvGI3txxwBzsPNAnKpEyU4AMXygnu1x8loyASbz8+XrR2iUjt1H7zp2P1IRVd6g6PPrftljLNegip1ckDg4jQYjawhlXfvNnn95I9ECVoR4F6v88POuZ2zteACwavxSAYdCQKX1+IAqGZRDgjYogBmrepvhk6jSWs40YGk0ba4hZOcouMgaomrbrKp8l9wiFGSURNWNWCNOILi844ciXc0eVafXLedOUb22O3PJdVYLT1f9SnKjcSUjGyiFuMDez3YqVDInPw5e4sZ/wl9E8h1AW5FFmLYyHvWgm1mAM6hKKyMCPCcXKzBdn0tUp1apDAhx6cW4reSKIRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caLncysSLkUFjIJU7XS5btAFcz/iwrDZ/0nbwg2upIQ=;
 b=A45fB/t5GjLmlYsrLjz57WQ2wSdJdfzModwbu5+4o5VbLOY3zQ8cb749U0+Y4zoud8l0DudNLofE25DA8JZt0WnHdpNejCKI8h6kkfpKO+kT7VitSjt0cT0xtEM3+wMDTD2lbohfFXgCaJCkKEZxBUSX/rgjJs1xZaZ3ZprYdj6LWSvLGF5RWL7wjpdiD6+JiM42qNiSMbntnVjfHmOgB8iWAZMOp1fsYl6mrmrhMxazCAswzIOir6/a5l1bMP8YT/sgCMchqEOHlPT/9dRic3AFWDMILQ3eRUVw2LGDxZzC9TtlRELrk51RkP2aiz3nZDTxsT7c8UHMI+dyaGoVhQ==
Received: from BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17)
 by BYAPR12MB2727.namprd12.prod.outlook.com (2603:10b6:a03:71::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:08 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:07 +0000
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
Subject: [PATCH 5/5] iommu: Delete IOMMU_CAP_CACHE_COHERENCY
Date:   Tue,  5 Apr 2022 13:16:04 -0300
Message-Id: <5-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0351.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a809535d-a68f-4eaa-ecd1-08da171f96ae
X-MS-TrafficTypeDiagnostic: BN6PR12MB1153:EE_|BYAPR12MB2727:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1153559F21C4254FD89E7DC7C2E49@BN6PR12MB1153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 73GC5SU+34uDNFbsj0cNzn0J1Qv2CYmv/xx9zoDEn5M32hM/0CIX//1QNIX2EOcoxXOuwQK5ey79NLDBF+nIBpCqey5b9Cnh7y3hD+VPcehA64i9VVz7lyWq0sjZekSsvH/4j5osN0m7sQnWopatLgAy9UX57c/SUu2iFrE9/IaDpa2zR7w3eCHBDlm8vveStMYkEEd9R+UIsfQeG7MvA/FEJv2YgfUtok23DDLfQxi5b3CkRLabB0x05oXR/A0HketTRo4D5WiyCBdYX/bwazloxET0/0ObFZ572q58wSl0VAH0PCoEx74v452Fkwt6V/la7l4bP1Mf3whTm7QX5d0sG93KAYLI/8GZp0If5BhA9Ja4L5kpVBasR3z1dvrIUKH60fpBxrr/vW8mbs25TGiluHE2bmyQRZBJm8ioCsRbrENBOmZPd2WfhqegeBFjwRpofk1H/zFHLJ8a++v4ooYbLhytc9s0fSRu/5Vq7qj6bICplSVk1WVzi7sGsnt/C/jWTdT24nBQIkYKMO4qiHqr2fyR0sOstumL4vLuJ0w/WcC75i1fXf70s4ZTDqUX2BxrfcRVxQad722ds0wsCGwZrtKLTdBEZleht8+iDP/8vEbWI4v5e/0vR4q7WN4EULsZCkaZr4HkJtZ0G7qGFj4NmsMQE5/+gzj6T6yQ3LVW4AryTmyfsaIc4nJNd0h97k+ayWFXZ5vxOXtwdwcFQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1153.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6512007)(2616005)(508600001)(86362001)(66946007)(5660300002)(186003)(66556008)(6506007)(26005)(66476007)(8676002)(6486002)(6666004)(7416002)(4326008)(8936002)(83380400001)(36756003)(921005)(54906003)(316002)(38100700002)(110136005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?toC+hrreXAVOBw/rTbl8HU4Y9qddWRR3yCneKVXSIl0i9DWrYqt5lroRpmD/?=
 =?us-ascii?Q?meBfzXat73hOrfhrBwMbtmymZX1iJ4IWqb+RowtMD8043uLZMprnkIGhgHC4?=
 =?us-ascii?Q?BxQ6+b2P2IIB/auAx1ggd1i7CQGK0MyfJvl7KsihAah3L61J0ZTw5GQYM79V?=
 =?us-ascii?Q?bdj/AxKYjWDkVIROOd4PZlzmqkHJBMBLuNGa45mX2cEUNl94wucVunpFXjYT?=
 =?us-ascii?Q?hIWfcHKE1M8sl099uD43yYnsgn/xlocfb0aPCC/fI1h3ilaZKrH3U+qZI7vE?=
 =?us-ascii?Q?mwGCM/BMrlaXaH81OKsuDNtTmn2K+CuzY4SSmqwAxlodFZMIXxJmyD1/lEow?=
 =?us-ascii?Q?7XjPR3MSjTmVT3zkYBAabhyEK8gM6RE/U8yXQugO0Cufj6bq7Xw8JGHQppy9?=
 =?us-ascii?Q?A2nrfpkzQRxKHt2KVYzjqMiW1GC7rVJEoXrLQbHttxIp/Cec+JjtReMPNMWz?=
 =?us-ascii?Q?0/4MnTt23Mbgl3TaKt69XQkyhNXEgV1r29PlhBP0zv5FPmpH1fVkIPr2Ln4m?=
 =?us-ascii?Q?VVKL6Z7AR+1SDCwOV4sdpZNgo1jHCfsYtC2FvCVTos+YuHMqyrpZrKVsf+F5?=
 =?us-ascii?Q?AOu33rb0HV6sCV7EzEEBXKpNL5La5zdD/neLkhLiQwR2zmNf95AANf6SGghb?=
 =?us-ascii?Q?76ZRxVWsyLx9Sg3o5KiPVGwrkP8RGIbVsYPqlE/L3tV0vLfQXf5UQl7nvA19?=
 =?us-ascii?Q?pb5p5mQIbMqNGaaUNS6rM0nKdgNKcNy2V6quT5AD69lYphqTg4A/849h0VYU?=
 =?us-ascii?Q?Hehx5ZSuNSmKgPk7bMEaFEwn0Cjt7oR43eg9xqEP9iVGxu+0ZjbYfQIVqZqr?=
 =?us-ascii?Q?DkTSYKxY8soQOn7fnhxtBelkt82temjnYuQfO3DWjxpdyy5dye9poalk69K8?=
 =?us-ascii?Q?4ZutXphFnGUQfM+3++LzLr+ps81YKb/XCMca0xzrOJK0lvBEc+Mx8k6GnsMi?=
 =?us-ascii?Q?87MkhdntASYUznUpoKQuUidwMrgpPmsAUlyqwiQvfTvciJCSeaem+79GPKmV?=
 =?us-ascii?Q?n+ZsU885rJKY8ScK/xT40zIJ+E6M7OOHPWiiIJ6l38W5t7gEWIAyWPJ6mIST?=
 =?us-ascii?Q?EmXRIRxoR9YAVZekerHCakOP1ANiV3WXzSjeNoLZmHk6C+x7Eo7d2CULm6f4?=
 =?us-ascii?Q?RG87t28usW62ibYgD+dK+ldWtx+xaTrUEtQom6tF8f7Q9iEe5vHnsb/Ji+kg?=
 =?us-ascii?Q?GSdx8PdctHGAbloHFXf50LQ5wOlrJZkHMk+Y6QPzRzxrPUFFzny4SAvehsr+?=
 =?us-ascii?Q?7BGbMAG4lfmALDeZCekt6jUV2vIjzUFGbsjkoxDo4LRJrsrEk+KlCokZ/c3R?=
 =?us-ascii?Q?iRmlIHR5oeo/K+gymzmcY5+zzYH1W5NkoGJOdOU42cyOnrwjefd2ohEJQ8oV?=
 =?us-ascii?Q?siqKtBL++H6ohRuYxxVFeRb3OHfO0ANx2GYww0Fmz1hpd2FuYGnhD7ogdS1n?=
 =?us-ascii?Q?ekkJxM/uA3SM6Xt25cQlY0hx7DZVb+oxuSQpYkmVYhUz/KgVZGYn9RvBSTkB?=
 =?us-ascii?Q?BOadYdTyHy7nyTg5I2yXjs/yDFdscgpt5SMMjEEdQQnnFVMlz0XOPlZaqV/h?=
 =?us-ascii?Q?5Pgyl43S/UdpUYfhiZogm3vgaIXuV6IRAgw9un593db1PGbbfbs07rl3NWmV?=
 =?us-ascii?Q?CcL61Me4UXcS5bFDCikEUaVtCRvcuEA7MUAJozSZIegV+d+zIFuxtWGwVJfj?=
 =?us-ascii?Q?tFSeDUAjB/Aa2My7XsEa9c+LnQqb6CTdKKCDw/AS2e1jKxv7z2WEWKVCeEY7?=
 =?us-ascii?Q?7bUkhe7jOg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a809535d-a68f-4eaa-ecd1-08da171f96ae
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 16:16:06.8161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +EMg1eWYRJopFedeVUcnCjBip0u//HMgB4uTRppN6ngcTCAmTI94Ste7nnyZub8G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2727
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing reads this value anymore, remove it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   | 2 --
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 --
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 6 ------
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     | 6 ------
 drivers/iommu/fsl_pamu_domain.c             | 6 ------
 drivers/iommu/intel/iommu.c                 | 2 --
 drivers/iommu/s390-iommu.c                  | 2 --
 include/linux/iommu.h                       | 2 --
 8 files changed, 28 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e500b487eb3429..f144eb9fea8e31 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2156,8 +2156,6 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 static bool amd_iommu_capable(enum iommu_cap cap)
 {
 	switch (cap) {
-	case IOMMU_CAP_CACHE_COHERENCY:
-		return true;
 	case IOMMU_CAP_INTR_REMAP:
 		return (irq_remapping_enabled == 1);
 	case IOMMU_CAP_NOEXEC:
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 627a3ed5ee8fd1..c4115015a633a7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1986,8 +1986,6 @@ static const struct iommu_flush_ops arm_smmu_flush_ops = {
 static bool arm_smmu_capable(enum iommu_cap cap)
 {
 	switch (cap) {
-	case IOMMU_CAP_CACHE_COHERENCY:
-		return true;
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 568cce590ccc13..166bf45ac3d444 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1333,12 +1333,6 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
 static bool arm_smmu_capable(enum iommu_cap cap)
 {
 	switch (cap) {
-	case IOMMU_CAP_CACHE_COHERENCY:
-		/*
-		 * Return true here as the SMMU can always send out coherent
-		 * requests.
-		 */
-		return true;
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 4c077c38fbd64f..fc72465fc63d50 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -496,12 +496,6 @@ static phys_addr_t qcom_iommu_iova_to_phys(struct iommu_domain *domain,
 static bool qcom_iommu_capable(enum iommu_cap cap)
 {
 	switch (cap) {
-	case IOMMU_CAP_CACHE_COHERENCY:
-		/*
-		 * Return true here as the SMMU can always send out coherent
-		 * requests.
-		 */
-		return true;
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 69a4a62dc3b9c7..9f80285dab2951 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -177,11 +177,6 @@ static phys_addr_t fsl_pamu_iova_to_phys(struct iommu_domain *domain,
 	return iova;
 }
 
-static bool fsl_pamu_capable(enum iommu_cap cap)
-{
-	return cap == IOMMU_CAP_CACHE_COHERENCY;
-}
-
 static void fsl_pamu_domain_free(struct iommu_domain *domain)
 {
 	struct fsl_dma_domain *dma_domain = to_fsl_dma_domain(domain);
@@ -451,7 +446,6 @@ static void fsl_pamu_release_device(struct device *dev)
 }
 
 static const struct iommu_ops fsl_pamu_ops = {
-	.capable	= fsl_pamu_capable,
 	.domain_alloc	= fsl_pamu_domain_alloc,
 	.probe_device	= fsl_pamu_probe_device,
 	.release_device	= fsl_pamu_release_device,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 0ca43671d934e9..e5062461ab0640 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4557,8 +4557,6 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
-	if (cap == IOMMU_CAP_CACHE_COHERENCY)
-		return domain_update_iommu_snooping(NULL);
 	if (cap == IOMMU_CAP_INTR_REMAP)
 		return irq_remapping_enabled == 1;
 
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 3833e86c6e7b8a..3dbf9663246552 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -42,8 +42,6 @@ static struct s390_domain *to_s390_domain(struct iommu_domain *dom)
 static bool s390_iommu_capable(enum iommu_cap cap)
 {
 	switch (cap) {
-	case IOMMU_CAP_CACHE_COHERENCY:
-		return true;
 	case IOMMU_CAP_INTR_REMAP:
 		return true;
 	default:
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index fe4f24c469c373..aebb73bda19797 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -103,8 +103,6 @@ static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
 }
 
 enum iommu_cap {
-	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
-					   transactions */
 	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 };
-- 
2.35.1

