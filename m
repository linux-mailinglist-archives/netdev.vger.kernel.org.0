Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E68672107
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjARPUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjARPT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:19:56 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BC732E44;
        Wed, 18 Jan 2023 07:15:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7AMX38483WMPLEb3WZe3hdAXOyWBjU8bq8505wLWPPFt2I43KyNklfeLBafcpRyr1jvvkERuvu7NLWT1k0l3EzbZLb2JQkBpk6ZychWFq5rD2CCLeelpVRA2Qh7qE8iM4iH+/OFMG9OwQGQ50oBN2YT1nmKXPqaT4YY8mNopARdNNIwjnwo+bsXjj5HeyE2w7yUtBtzxL9vduRipRI2QaDCxeyZgAY4KLlL1QhHyvNigQWbG1h37EwSKeQzVgYxFvweE+AsLS4i7VHU//EDUCNj08dedIMej9UVgvBT+zGJOD52kXha32k3VfBPY/88zh9HGoZY3d4CzHUrN7HENA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xLXlvtemBKhxT+1GV7IkwISw+CoMPNriPHVjiccKyA=;
 b=NwqBfDjTL9xcC0sw95Z/BkrjXRS34JQ0NzO+Df15tYzRxCWYDRtOngEdQY1wnTe8eLqf5fRinTUu9dxFjCAlKJKbcKDLfMpD78AQQlMKajnUNIsqyRuN1e55eDf0dOgXNXR6lpZA6QQ/kGiyeYZQaGSWO2ccPqH1tsrvkQfJJQyzhaN8/WXcoyBx48S4jncD7ylQrLup9aruPtcA9Zt0jqHWJ5LwmdXo1IBcBHpO2HC08HDhFtmsD/CBFRdAKNQvFqWBOHaz5+pxOiyeWRCo0w+ugr1Tf7GOxY9tkjGfCt1MHlt0VXOBMXK9KzUAgUeIBr8XeJ+HC2F8CASTR1GPBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xLXlvtemBKhxT+1GV7IkwISw+CoMPNriPHVjiccKyA=;
 b=hdyLkqGV5r+91p5X4Cz0z4Gxj3XKt/blPaQ2OlUIIaTxLLkobqR5tjiuPbGnsDDZYc9/o/HMJLMl0p0o+e6L1VokvX013F+npis3JW9ltWLGCBYHURr6t39/Yychin8Y3ius32/Z+85BSIU7Nt6O/M2uUQwDaY8v8hH2fO4YodleDQ9i0nmUcEWeTrfFB5q8EF3zWbeJCpE13eEjrkVWE4Edik0fm3oa2B/rL+66ZSDGRl8mFitw+jACxPAoKnSWsejWUI7QlO5U98izRvq9t4VtrdxGQkFtmbJkeeyleAl2+qPkPLzR9VXI8WVMTgPJvEc0+Gpz7t2Os8D5JezY2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6770.namprd12.prod.outlook.com (2603:10b6:510:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 15:15:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 15:15:30 +0000
Date:   Wed, 18 Jan 2023 11:15:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 6/8] iommu/intel: Add a gfp parameter to
 alloc_pgtable_page()
Message-ID: <Y8gNEUJ9ffSdfH51@nvidia.com>
References: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <6-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <BN9PR11MB5276A8193DE752CA8D8D89928CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y8ai8i2FpW4CuAX6@nvidia.com>
 <BN9PR11MB52769B8225A81D0636FFE5648CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52769B8225A81D0636FFE5648CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:208:239::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e88fa23-14eb-49ed-3ef4-08daf966d618
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqkeOZyMHCubF29L0ig33g7+rBZaJdLP+HxE0a7KWTJL1bO/GVHuwH9VXCWVlC8VA/puDGcmtuq76cwVUl0ZaiubsrY+G5yqnP8ZQQ4saMe5U3sfka7QSOvqvWfHZshzjspmc1yOJ5vM8ih+9Cp45lxg8mhQ8PBKK8qQVCfIwZhAcFvKm6FKAmivzU4OBx8T6wDuBvbmI/wK4PECoih9kksnc/RqiyfKd+GXHKZ/lsfs8X0kGCb9KpSs03anNaLXD00IuY77tgeC6/tDKeUmc5KLUQwr4hEtNNsISCNDvfRpalXq4fjJgHPPzOStm1e9bLumMS8EefC+xGRbW1kim7YVNmEuPwVkNqWr59/qyYThYyTsZnWLVGAGzw7ZjDRq6ZR0UQgQ+Md+Raqg8G97nFjpjvSR7SHsJaqoIqK7HktLd16n3lzNCYvg372pxEQatUL/5ogQQ01ZNy+GysuzOOPvypfgFwXzRDyaxX6dc5axLUqyeiE05PiJ750Giw7y5PMQeG8ohRL7pOeiWNKslGGhCZtxu19IZWE+34MakhMi0kMVqjQnpxAfxUDvnQ6h8eSuURkqnDwwH3njv/OG23efH9oXzdHPpRgKh1mwQ4JLwNTid9nN9T25fcuqHlFQADHXZ1Zl1RjFdXwP9zS8Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199015)(8676002)(86362001)(38100700002)(7416002)(6916009)(5660300002)(8936002)(2906002)(66476007)(66556008)(4326008)(66946007)(41300700001)(26005)(6506007)(6512007)(2616005)(186003)(478600001)(316002)(6486002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rOpluIWQy+1NxO6yGe6376cl0Tmrlsf1pZTdI6ZISSltWdpHsrIiC4ygZANe?=
 =?us-ascii?Q?17iMBFpiXH4dIj+MYVDYKWyTveytvsJF2TOyJO5X1MlPo95dQoAhiUZ7QgDV?=
 =?us-ascii?Q?HRjO53y8p/CLi4uyqIptvgGlTAZ1krXuBCoqwMV1XBftLDafDofGSfqFtGLw?=
 =?us-ascii?Q?9vq17QpRDzBfpb8+ROqpZdXZ7MV2VUD50zrpemUVoSn2j96Nkc6rZGKfieay?=
 =?us-ascii?Q?yHFpo8kTLwS4vvRPmLA/uCc1c2W+gF8NMSDQp0X8ynTWZpNRMp6FM9COr1nJ?=
 =?us-ascii?Q?43gE7/bUZhZ6J5CpG38EscYXh+y021z0rwTppvb09+Ql2mZ7pZTfzfYrV4eT?=
 =?us-ascii?Q?LnZ985b0NzwyET1IlONll8NWUybOnM9fsXckRpbOjzrEwb2v70aB21+SpXOf?=
 =?us-ascii?Q?48pC8xG7QPVIi8v9iWhx/2xwY4XDJWHOGJeiNe4ZUc01cCENSYPPosjCe5yi?=
 =?us-ascii?Q?2mwTe2/ItMW/2Y96l58WNDyXSdYCR8xkMgkns3D3D0gfI75wcHehQootzEAJ?=
 =?us-ascii?Q?UbWs18WKCJJF3foRcypxCJXTeZJncGNXvZgEzbjL1++p6yYCdb4bu+wHQaR7?=
 =?us-ascii?Q?9G6zINy0P483Dd3KMSatfyfTg02vTavPXr4HzgC6i8E0VDfcpCA7DOPolRAQ?=
 =?us-ascii?Q?2m6A4KUG5W8wTIm5pyh6y0x5Unc2fzbtR6MJ4VR1no0nQuccP2HnfVkvLydG?=
 =?us-ascii?Q?+4eA/9wdzo4uPxZqQR47HRE3uYV58Rnb7ZqIoT+xYq/qATaACOnxEhqEZ3HF?=
 =?us-ascii?Q?CdBJltqtvbTCLrDaNxNciB1mXpdwTKsOc4pLONzhok200Xk51N10CgsYpsAK?=
 =?us-ascii?Q?uwSRrS1wVIqq3UxxUyGY1Nsqa5BivnMdx5sA/En3sKtrKSTfv1sChnKgid52?=
 =?us-ascii?Q?jmGiyAJS1eY+NzCgO7Z/sxlBB7BC3i2DPOA39yCeSk4EfOm0HBAKWzh0kt+f?=
 =?us-ascii?Q?Jy8VxJzPXcRBc9iA96noM+qXoQyJl0cQChyU56UZkJn5LkELEHh6Rw1tOCny?=
 =?us-ascii?Q?/b8CSSFY9yKISluAOJ3pW4qR5jYejr/erVAxDfcYgx8YdP5BPrNZpD1rJ/ku?=
 =?us-ascii?Q?l6ghcHY6T3R++zs7rXqcLMoEfYkRdrU8uKwF1KApSrppyyPmvYvNb/XuOHRR?=
 =?us-ascii?Q?AIBQfs0b+cHEuu1kkPiqkoSUYBfkeUJ1Cbsncuqv2BTz3/iAjPicZl92UXj2?=
 =?us-ascii?Q?3Lh0iT/dPcRpPIvRzjl5tA1KFbDHd0n8R+sfgqLCl5O3F0B9icuij+tAtpZ1?=
 =?us-ascii?Q?NPhniNuoj+IZWJATC49hWlImv4VSdGc8PBlHZdTmDCDe7tifFG9N/JWv/wsV?=
 =?us-ascii?Q?4qLUWJy4uMpEZpSQtfZJ6HPcAgGBovxLPWZX/nglgpTXAUNEhMzVDgMvrNkB?=
 =?us-ascii?Q?lV9w937M6Hl/UvmqzoZK8JPt93HzAcydjCRxnz799wJPT0qUnzowEQWoCRpK?=
 =?us-ascii?Q?YZTyXf6+S9bkQvdE09DsNutidZ+MGx/C7YY8u11SGhtMOlOt24XE0hHrXZi5?=
 =?us-ascii?Q?eG6p+iJZPMzd88nG073Uj7uBMNRf+tY1t2lng8RKyn73ITCoQX9k6AjH6oH7?=
 =?us-ascii?Q?cXCgHAg/1bu1JK4byEAKLxJ1JOvx3Hx3RYokkAWq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e88fa23-14eb-49ed-3ef4-08daf966d618
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 15:15:30.2895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIZyr6v+oKhwQQpCgWjDbbncIhOISvKiO9v5UR7uZ6xhPj2xLZYEfjszUIXgPrOV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6770
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 01:18:18AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, January 17, 2023 9:30 PM
> > 
> > On Tue, Jan 17, 2023 at 03:35:08AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Saturday, January 7, 2023 12:43 AM
> > > >
> > > > @@ -2676,7 +2676,7 @@ static int copy_context_table(struct
> > intel_iommu
> > > > *iommu,
> > > >  			if (!old_ce)
> > > >  				goto out;
> > > >
> > > > -			new_ce = alloc_pgtable_page(iommu->node);
> > > > +			new_ce = alloc_pgtable_page(iommu->node,
> > > > GFP_KERNEL);
> > >
> > > GFP_ATOMIC
> > 
> > Can't be:
> > 
> > 			old_ce = memremap(old_ce_phys, PAGE_SIZE,
> > 					MEMREMAP_WB);
> > 			if (!old_ce)
> > 				goto out;
> > 
> > 			new_ce = alloc_pgtable_page(iommu->node,
> > GFP_KERNEL);
> > 			if (!new_ce)
> > 
> > memremap() is sleeping.
> > 
> > And the only caller is:
> > 
> > 	ctxt_tbls = kcalloc(ctxt_table_entries, sizeof(void *), GFP_KERNEL);
> > 	if (!ctxt_tbls)
> > 		goto out_unmap;
> > 
> > 	for (bus = 0; bus < 256; bus++) {
> > 		ret = copy_context_table(iommu, &old_rt[bus],
> > 					 ctxt_tbls, bus, ext);
> > 
> 
> Yes, but the patch description says "Push the GFP_ATOMIC to all
> callers." implying it's purely a refactoring w/o changing those
> semantics.

Sure, lets split the patch, it is a good idea

Jason
