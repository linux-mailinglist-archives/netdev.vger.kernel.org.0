Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F1B67882C
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjAWUg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbjAWUg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:26 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D29D303F6;
        Mon, 23 Jan 2023 12:36:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IICk8JCLVQYkkI/PNKn2j2IcUyqSMJ3VHsVfmpR7hJt9Fa6xNuShgpXkjVAbT3t+E/UF+my0MsKLB+/ZoEkvkEiRKaACCa6en64XSdU5lddyiHEWtM2dRl7+9MigWqZGnYgFxZSVyae7o5spPJfnn4WtMnnjs4mZFN/K63MOj8ESnemG+EF2oNWbrds6T3S1PxY1pGSWQ7cK00fNGEkH3zL89PeFq6XzzKmKKiogBxa0/QgY50Bp7/yNt3LIbjbM8ml1qcwWR+okjMkOTyErXpXmUjCxC8VDH0Wb2Ue81jw6Hdh+PTs2HyV3tuB+/pm8kqHUe+3jxwKbKetI4/jfNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HL50Jn1C/DZnXdmbxxODy5J97mMbNk5sIcBxdl6xSJA=;
 b=KhpCVbgwDD1aZHZtENbq+DzH1Um9XUkBfsTBNJR3wcFqJJkGbuAOUu02uXOMD2PBsVumUGAkcEQK6Kz4ZM84YXQQsalHtD4nVysio9KKaR+deTDHM9sJnkDQoZRILPC19bikI4JiUP5lUTesg6A4H1OpOSTDfSyJbwtDuDuAcrK4YnczA7bwiY89ctt/l6vGWgQgaQnAVzvnRCIQgimJtCz2oQed084T58h7hNefxwpYymeEJzBY5Tf+C9cWFUJTyncbMEFH6xJCXDjaVGRaJjM3mNBXI52Taj23AFGiX3WxSc0nGKQW8ppDBFnXM7hCEICef5fMYy98G0sjxafnag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HL50Jn1C/DZnXdmbxxODy5J97mMbNk5sIcBxdl6xSJA=;
 b=YkRRjn388rcubEYUQTThVZL8MTNd0LbtfvOaRjHAGdTSq2Ma2LN734syUTZh4o9PYb47QJNLhVMPI90ZaeJbYugULSWakkEqJXH3ulf4HNfEEP3Y0BXGXZeU6G90+dep4FAROu/aGMoWs+xc1uaIrrzZDFNVUwMCRhsgPMr9mOvPIoJ4lG6e9ZuDTrJmTAkobyvwpBU+Z7TNtw/eM9PRm1iDJ2VygiLXzeG9QxPuTJXKXGdc+Ck1v9XYvcgoUZRdS+6nLF3MCaY92HSxfz9Uc7bhNjun1bwJqzNt/R8ek/4afcW7V5lJa7ZastT1GxBJvtLjDhoCpcjgcJ04wvjPfA==
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
Subject: [PATCH v3 05/10] iommufd: Use GFP_KERNEL_ACCOUNT for iommu_map()
Date:   Mon, 23 Jan 2023 16:35:58 -0400
Message-Id: <5-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:36e::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 36e43812-6633-4d30-0b34-08dafd8172c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vC1oPuyzjB12HdsszA1wAdPObBVftxQLchByRvpbik6ivNhUbYc5JXVjzYr5/PxuUBndxlmB6vRu16dsHJcyt2jcg3U3gUAY42q2Y7QpbigSXz94cGrDf6sPNDuTngjKry4ORHPLHvH2uokg+ilwDcu16yUToY9RYV1QnoNW9bUF8lcMGMZFmsO+6bLe/Oy0slE88oxRTVbZgMkptXUVdPHdeYDW/wy/uH/DfzuMw3w8N0O5sOzOlxbcb1jBlIh9NLhL9hl7inoSWi0YcWcLStEMJcSfUy+Z2FSf/GVbY8pHYPOMLq5Pq4zmq9oa9CRIbOitihr1qJhl2Mm8eQWXq3+kdKayMy9Dtbj3xxNS/H1Cypc3ivd7PdDhzm54iD7eiVkAeGnHFDFcPTy338JLrvnaxtvuUe8RP/AEa88Cg+vEA74Amb8GDHJ6sTes8POxqCxegFH/v63mlE2PrH5H9W1MRqbHdNF0S9m09Hy3vzqIqYH9WD88k8/b8jmOpU7iqqikPzSIpNj1pLM34xsnUv+Qt89PrGf46mUpMfw8jcP9rTYFXBoGoIhzr19KwtpyzA5a0l9F2SZVXgZBe3f2TeIwZFOzbE7CGRUfIhF2xnkP4tQAkKO7bNM3e2gEU1pKtDnsKrzDgjmJ08RdcGYPN4po5XQtI65mPhhdAN4uLYMQ65RYXLVHUGUKHNQBcTk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B5JAhH5UTO8t0pnbBJS+pJIUq7qWu4+0+QPlcMV/PpgHie+67c1Q5YeHv20X?=
 =?us-ascii?Q?0DylUfU8DauJNeK4ywV/SHJ2jpdbW+TeojXJC3oQXkeyqTSDUZ0LkvD7Xrh0?=
 =?us-ascii?Q?4CtjAh5U4vmZ6RfG+ghehU7SkLDfu8xGn8ZPaqNzjfE0vOcSj/xcxqG8/iKG?=
 =?us-ascii?Q?kCzeC3PiTM4U5tHSJcBKSTsIq48YXFCVOxgRwQDBOgTqVJpZykQtEJAZuc4q?=
 =?us-ascii?Q?sKIDdNz1YZLBELWWcoOdwv6lDZRr52++AhC3plfTPFnNxBkBmYniLYrdy0K7?=
 =?us-ascii?Q?t2L5P1y94vf0Jxkx6Zin2+AJ515Pa8k726/mgv6HPLFaYbPYJ4FJUPkBODyg?=
 =?us-ascii?Q?XlUNDZgTjIFOkfYRk67Fvh2EW7HBofTv91ZspXyx4w+Xb+6gXJ9ZtaHRnP4Q?=
 =?us-ascii?Q?kJJ7IsRobIHp+cwuMVIulfLd9htWeLRyixy1nuHgzt8wJAFqxfb9wETf7YRC?=
 =?us-ascii?Q?erjTwKGovzdmrmJV5m464pWfGBaiSHL4K738p/c5VQST7+Eq40+ow3FpFavF?=
 =?us-ascii?Q?3eWsTxI8+7P7te18wCjn17Uyw9YaktfqOWPEeQFajVZJCV0qeWfzdu+heRD9?=
 =?us-ascii?Q?OkwXhM5eDePKktgo0fSt5twOuIF0WkU7TQ+hfDWcx0XDsB6k+fnjOcJ81XH2?=
 =?us-ascii?Q?F9Ie12lXsWmkH3o/+tKHNtFlc6jv2BFJjrxTHNJcBros5rg2Qgcu1OX85O23?=
 =?us-ascii?Q?ZmbFHhCBcLECQTSsb9znpGIv5dUa6QbF8M2evf65eRRmDPOyhvIaMxXYH4Mb?=
 =?us-ascii?Q?sxzbHTzvfzhzPGUoEFhNhxbpqZylfbu2KZTtsMiKjpT2uWTJirU1ryrvpQAR?=
 =?us-ascii?Q?7Rd0G/VqI6yUB7Z4h3sKWIBQMt/eruOeZwOjQMMArbP06fLmXtWhHIQAV71l?=
 =?us-ascii?Q?szxKD/ERG53fMILpV+vrM1Q1n0V6N4tz5i205b86MYEpalJ14giJPnNEdvhm?=
 =?us-ascii?Q?perjfzZ20aniJ3T0Qt6GUPU6swPs1PW2TzKatPxOxnUmbzBwVFwzQdGWKrKK?=
 =?us-ascii?Q?tDW2ABKBUq76qP+KZ0/Lte5PQJrOKsL9jC023I8xtSi0A8vgE67jEj9jKHFw?=
 =?us-ascii?Q?dm99oXfqc0Sf+L0TbM/j0kMn3HRumbTi15TlMxelbIyz48mT+k0j1C5PSyh7?=
 =?us-ascii?Q?jbjfkB6TVE69UVksDEvS7eTO71lBBeXmciuOPDYSiJh/BFPy75P4wCgxmuRH?=
 =?us-ascii?Q?rEqUcYYN90ZTMGeQ2WLI5+ODrtnagfDc0gtU87iIRk6r9MFDMZETqmHlwjjs?=
 =?us-ascii?Q?e+0rG1Dp96cTKaqGPwaI+cmk0+XVPqTNi8A05k8n3TUCvJFKocPaErN0p3SN?=
 =?us-ascii?Q?gUag0Qo9Ao/DSrtKcmUudftg0OVy+Q/C4A1lSBA29NeHnXkxw9w5r/7TVx1i?=
 =?us-ascii?Q?RHCr121ohOSawCKqds+hVHCze9Tb9YZXOG4xxIeZ6aVt84/n8xoIBekfJf2r?=
 =?us-ascii?Q?3P6PePx5JsM99UkV3s7SrLEG65F3NLRdhW0NKjYNUrA37OKGlPef2tw+Wmov?=
 =?us-ascii?Q?qMwPenXhdcEbftaIXk1809f/yLmI9+EYOVLIiyMD8NunpYnzMrSjopOsnzQJ?=
 =?us-ascii?Q?BK7PPnRCD6LXWmjvCkt9I+TT38H+iu8Bo0XAVD/r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e43812-6633-4d30-0b34-08dafd8172c3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:04.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BRLeZOZZG/8G7w9is9OvocRVNQB5hnyIZUH9fAdafvLbxh9wYujh4J/I3a0BULa
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

iommufd follows the same design as KVM and uses memory cgroups to limit
the amount of kernel memory a iommufd file descriptor can pin down. The
various internal data structures already use GFP_KERNEL_ACCOUNT.

However, one of the biggest consumers of kernel memory is the IOPTEs
stored under the iommu_domain. Many drivers will allocate these at
iommu_map() time and will trivially do the right thing if we pass in
GFP_KERNEL_ACCOUNT.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/pages.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 22cc3bb0c6c55a..f8d92c9bb65b60 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -457,7 +457,7 @@ static int batch_iommu_map_small(struct iommu_domain *domain,
 
 	while (size) {
 		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot,
-			       GFP_KERNEL);
+			       GFP_KERNEL_ACCOUNT);
 		if (rc)
 			goto err_unmap;
 		iova += PAGE_SIZE;
@@ -502,7 +502,7 @@ static int batch_to_domain(struct pfn_batch *batch, struct iommu_domain *domain,
 			rc = iommu_map(domain, iova,
 				       PFN_PHYS(batch->pfns[cur]) + page_offset,
 				       next_iova - iova, area->iommu_prot,
-				       GFP_KERNEL);
+				       GFP_KERNEL_ACCOUNT);
 		if (rc)
 			goto err_unmap;
 		iova = next_iova;
-- 
2.39.0

