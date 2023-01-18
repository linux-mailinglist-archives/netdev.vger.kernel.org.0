Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB61C67261C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjARSB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjARSBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:01:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3972359E57;
        Wed, 18 Jan 2023 10:00:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b83gBiPSSsb14AVKvi1HBOtjheXFjagdsSRJfqakIFLmNfwUcBIp3FQaX+Q26xTDjyEAOgJTKf/+MNMRd4Ci+0wejL3ENaK2ZNIPK3NrnC47SQ0P4/PwsEZ7+78/eCg4CeXAwnuBcDYYDPNEcfRGDy001MUq80wIg3QJjO2YaKhrboO3juF1MmFFHTNmaqy4H6LqvHt6rzRzukhgyMX8BcswN2laocFzfbzm/tP/uin99Yt/D6gh8dsAgy87cfus4GNB6zy0ZyKWpQbu1MSWTlZSmCQFUs4FV+bxqoCk8VdWLAB/uCceRGCmzspX3Wq/LVz3J8rnLp+QAU+QPn+12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i28832YwpvUJbHlTSOfIPaYAPWwxtMVLBQ1NJ2uFvIs=;
 b=KJfNJ0Uc473qv0uSwI0jLzEs5yZujhCUZfIlS43l8p0sgD6cmWERbeGserqsFiENhX0p1mrpY8k5gq8kdcfSebO1VwFbLH0ZA418HVWbJHMQh8FJwXYtXuJp3AAeHz7j+ihdY6w90JB7jFMuWeVUkGNXFXCqz/dO2euh1NELN2qfcL4g5OG6XS67dY67c6waNSMzXouFCLzWyOeeiZReWdndsc7oCih4B5SwNv3lxf7YftQ5Fc/Tig/FCbHE9TzYhSdmyTFEvvZUuYfLidiIENZtnHZSEJYAQS+HV/CGbphcmaCa8Myh3kuZtyjqjq8yUH1y7CefsneAe0lA8J/2fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i28832YwpvUJbHlTSOfIPaYAPWwxtMVLBQ1NJ2uFvIs=;
 b=fHM+LdaFx5q7OjQ+Qb0rCCL7c8X8lPPC8rg9Cua2nMoIcWqLLL++dN7EY//pYEJvx5JFNmgst4FCBcxz4SKRZj+99Ghe6DUewGOa7HSBJoZsbNLq5L8hab2AyomYs0p52pbkrtPYEA9jDc8uPo4oq55qZkFGBeFmojHHtlc2qZuosoaYSAwalQupZ4EHNXKLKkLM9KPvBJSjO8TYflME/Y7jZxvtOiciEzfzH8WBT5pkZuOCv+8tZ/OG6mtL17kcsFRWVP3IQU/bW2EaCfJXLDbqF+VKvBaoGF479XgqEv7RA0z6HZATeuzHELd1rDwqQwBVV76ZCvHggj0edd8K5w==
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
Subject: [PATCH v2 04/10] iommu/dma: Use the gfp parameter in __iommu_dma_alloc_noncontiguous()
Date:   Wed, 18 Jan 2023 14:00:38 -0400
Message-Id: <4-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0142.namprd02.prod.outlook.com
 (2603:10b6:208:35::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a42fed2-83fa-4c5b-cefd-08daf97decd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bTRKsduCS9s79AzQ2MPbrMF5hpDqAKyzymEHViYRnb1C1srzo58F3QjMCR4Hw6VIDvEXjcHw8aU7hoN6luCW0VnMQynULsRy1mmXvTrspYlF6GLwX7q49f/CXp5LN3U1tsLu2lOjasz3QV3QZD+ahgW/YVsW3KfdllkSrLk8YBi0rb5qUuye355+Z1l05faxOwwrjE1H5H2Ew5x93+eavvKDn7ywOn2C/Vd6Gvf6oK3QVcZ8y6MQfGb/Wfv167/4NY4O6xpbvlLmmEE31SyGculxQWiRkMrOdw7Fs0Tb/2hED5tUJBOxQCP3shI+sdRZzZqtdeHpUuCO8jxt0uZR/5B9R4Cn5+UZky9Rw83DIB0lVEjQuangj7zbzoMyD7kD//xU2Q2fqzmIpMH17KYGRHqScFprt3fjsTbs0zFcNwAbLk4ayIRsZrKdBO6PFiAjT0piW130GV+OXXIC7m9c0Xy/Sr14qQPZsXURab7B609fEaErIWbMqCFV3xT/xNVHXiCku4nChXZubUJQelPoIUOnxqW+J3VXu10GiRyeXDlzGQ0hdgCXNvNbdltr83urYejgTIindmlknZ+bKBqj/kA+ZZYE0SeJt5cy4OqjAVduTc4zTwLBN7fXLS6BLJnhMCknduphZ4UZosDPKWTF1pZQKGC/zJvzciSrm1gObSMKeifNu70bHJpcVUnR2Aol
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(8676002)(36756003)(83380400001)(41300700001)(8936002)(2906002)(66476007)(2616005)(110136005)(54906003)(4326008)(316002)(5660300002)(38100700002)(86362001)(66556008)(7416002)(4744005)(186003)(6486002)(6512007)(478600001)(26005)(66946007)(6666004)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2f0Uut1aescwxLLm2nudPyU7lR6i3Jh6wJTsepXy+lAJ3Yrq567SDzNCsuxO?=
 =?us-ascii?Q?n7miKfQDY2iNpOCM0oXGyjx7IP/msuTEWpM9zwBvY4XHYwUcoGKFk8rIOzUH?=
 =?us-ascii?Q?2gAEYWSAnHJzOKncKycY4axodL28uBXKM0t9vCXSr5/shLIl7xeqb1gB1KVW?=
 =?us-ascii?Q?DYLtjZL3sWa+4vWwCZgA8fpatbmj3WOyIj+VFQd3evRCQMTrJozUSTQ9Ok6h?=
 =?us-ascii?Q?BsewM+03mr9n+BNLsQ8/FjnbUrbARlkxZioQK46336anodmBKw07jsr2eqjv?=
 =?us-ascii?Q?YQuYU8aFA9nTB+A39r19ZjvS8o9ZwLw7J5k1SppIqw3FmGY7XSeveZlzlVw5?=
 =?us-ascii?Q?CaxOrPG1VyXG21coMM4AzZwb3EGEqIDjcEwzDR6MdMX4Iw0Z8mqfIRSKG0Rb?=
 =?us-ascii?Q?YF9ux7NHebRge8S3fc8kkIT8Lysc2sIpdRfYoK2IZK67IHWWnHhUSaTWWNXQ?=
 =?us-ascii?Q?JodiAIrnU240OEsOy6qvK3PkeJ9BFKIB6MwyO9tsVS90SiDV2a0P/rCC2mqA?=
 =?us-ascii?Q?7wzbxQB2ThVask+v2z+vP8Z5OiHGWgPe7r0Jvyj29gMOxmsteo22JDSQeH1B?=
 =?us-ascii?Q?KNt8ZltYquKXNmJsmXRx2oOlha2TFrDHTuILS+9L9135DQs1tUe2ByCx68Oh?=
 =?us-ascii?Q?+Hucd3GHcvBfvQdltLK0UulM+cj3rLp8xOWoHDqesa6Ft444kMMQRS27x0rH?=
 =?us-ascii?Q?15bFHNBP59kkqHRo0a+2ArtQ58qInqElabz1ZaVCO20aQU/s69IibE92cZzR?=
 =?us-ascii?Q?RritzZRGswxaZxTfx/WgWA7RmlvzRZ/0O/5Lmy/GWdi6EP1ZdRz7bnzonVwW?=
 =?us-ascii?Q?Tfze3MtHjmFEQpFF6K0MsJYKVnPbd02YbeembMH2JcrG8PT/i8zGTI86IT3o?=
 =?us-ascii?Q?OSKtVl7Q9PmufMQfj/fj82NTsRiWDq3OZxcawXze00/0hBUW48QskqunCgcx?=
 =?us-ascii?Q?2EufA5y7BqKDP2RWmQRpdN2CQ4rSUpz/Sr5w4i7MGsGkrKUYrKSJ/N/B3/lH?=
 =?us-ascii?Q?3/Ie2pe61LI0lLKaGbqX15kqamrhG7irtnZEpCVFwrIXNdi/zpUJjoDJqXcN?=
 =?us-ascii?Q?FUPeWGkg2U6flmzOYCo4+2RKBR0LIln6AbGgFidAn+VkbxBRPT4Scmc8Sp/Y?=
 =?us-ascii?Q?Q0nQlSZ7iS42ORrt/9GB7IlRRCTRbt4QgqKTstNmoacMBh2/afCVsHvRBCKH?=
 =?us-ascii?Q?y+JHzYg+uk/f6NNs9bDhwtZ1sbLI7qBp04Xji7SOJa+Mf6MEdW/WtjmHk7CR?=
 =?us-ascii?Q?vnOuniSJjCkny/+9LeR1g+l+bmWixAktIJP4LPCGcx97/USAS74G00y1rv3L?=
 =?us-ascii?Q?WLSaQ2Ak16XOqsjvqAlyD0GBGZC60bv+S6cSRKi+qjIKGwbsrirt41SwG4Lx?=
 =?us-ascii?Q?Nh3T3KbTTu2C14OaCNtxJFaZprakT0lNhYalLQ5CuTRDGxouYpZm7Pf9D+5Y?=
 =?us-ascii?Q?lgWFpIsdVbJxRsb27IAJ1bIzVXiz3cx+GqC5I2W+8TsUnA3HSb0hriInCtJL?=
 =?us-ascii?Q?4jCBbbZrHYEZi5PrbhrASDoR02hMQZR3a8/x9e24xd9iZM4bRAd6fXAcNMhO?=
 =?us-ascii?Q?KRq5hWo5a96jnjAuMZCUuwE9ngtT3S/kE9NACeLv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a42fed2-83fa-4c5b-cefd-08daf97decd0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:46.8806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzD/OnsX4Ro4ty43+yJ9jWAKT/OVO/tqlP+BiA2m7qlXlZRx8unJtenyDPa2RjUd
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

Change the sg_alloc_table_from_pages() allocation that was hardwired to
GFP_KERNEL to use the gfp parameter like the other allocations in this
function.

Auditing says this is never called from an atomic context, so it is safe
as is, but reads wrong.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 8c2788633c1766..e4bf1bb159f7c7 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -822,7 +822,7 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 	if (!iova)
 		goto out_free_pages;
 
-	if (sg_alloc_table_from_pages(sgt, pages, count, 0, size, GFP_KERNEL))
+	if (sg_alloc_table_from_pages(sgt, pages, count, 0, size, gfp))
 		goto out_free_iova;
 
 	if (!(ioprot & IOMMU_CACHE)) {
-- 
2.39.0

