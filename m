Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7AD66DECC
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbjAQN2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjAQN2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:28:51 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B2834C01;
        Tue, 17 Jan 2023 05:28:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRM0f8EmSHj0eOMpjtpFSEJa/RCkzuXV9HH/n/gWfQjKJL9j7y1KDccHPA2GkFkiFjvsPQxYyyPb2SApDFgWG7yye5sOywE/Th6rZ/E8gIqFffPs0O46V07PcbfwXkLetRB0Ym6JaHCTeFm59WDKsBurcO6ha0DPHouG+FR830feNKD17E4AtXkJqyhZ6bEldfnlYlDXAGWRdhzI6tQwEvZ/j+un+JCJ4xNzP6iWsi9gsNJuuy5oIUEESzhSLBW5yREWlECARQGyxtojzOkXZZf18r8k6t/Nv5Vv70VdHhR9UMw/b6m3atTCmZd1O6zf/c9r6MrlHqSKJAa8Zgomgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7Ck6qvdO21rqNebg+H3Bf44feASnVz8+E7RHkeP5Iw=;
 b=Atzv4VFcNM0NbnWPyM8TaKDfWLHCzA8GdsIzZiffXw5F6oXhMVaEPyVmgRsVoSF0GcLdZSpq3U9LRXdUlYweeY/9Ul+Fl+Z4IimqeP0I0kpUBTTjAg3CHXiL2gV0iNEUUjfiybSeaUOMMxW5G4KuMFIlJ3HZNG55TqhuiHd4zBH2cQmPa3YlZFo3zNT+xnQty44tDZ+kiR/YnH3F33Xsw8uQUPJZBkFfB/QlZVVn0xu3E41sjCMP+oAOfiU8E2n8uen59sGlPOoampfpGyIAlLnLLJGaWfa9yrf32DCZyGuy5i7rUKn9U/z54HtBdrPG/e9evDklPynAQ1NondsjAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7Ck6qvdO21rqNebg+H3Bf44feASnVz8+E7RHkeP5Iw=;
 b=diaa30gB3O0WnVPnzY14PbtakuoF/s2Kcg9IGQsPpifD0lBROucWTSa0RZIVwIwVp09wG8meyhqY/QVI+ktPbwyre4BuxmZKAktAvhLEgsxKZL0r7ZB0ba3knLEnhh3/Yoattv7KXBxSLHZ9v4jRQdCJzomJBns7CtX6bdIfpdgjbin843qJGD3eNbD8aMgg4Lp28pcJKv944+pymxaei7vG10P+x/7i+/CL3ErI4yMX/i0flRWRPaRJMtpQRXSWAbpjGYB323QgxhXuSHPTg8mRGBOLN6rjbltXrLv2kNBblWnm0x0qSKc30b0Ufi50hQm8KoXuZq9WXEEorHB1JA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB8167.namprd12.prod.outlook.com (2603:10b6:a03:4e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 13:28:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 13:28:48 +0000
Date:   Tue, 17 Jan 2023 09:28:46 -0400
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
Subject: Re: [PATCH 7/8] iommu/intel: Support the gfp argument to the
 map_pages op
Message-ID: <Y8aijhHjqqf6hjwL@nvidia.com>
References: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <7-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <BN9PR11MB52765EE38CA21BA27EEA06548CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765EE38CA21BA27EEA06548CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:23a::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c08f32f-97d3-4e4a-fb3b-08daf88ec3b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gGdOSydR+wezMWCKxNRQtb9kcvrWccNBt8OBVOW9Gu4CD///byx9zPqALmWUKmHV89iAdXHyco1eWdf0yNUg/UgomQLANZhNZBH04CnenAx+KJUtgmQ6DDoNtbnROo2GEeUvJHr1wYvPnGyyIDS7sHIOHZy14Byr+3RE5fZbuY3cUEBZL2HVos8Eur2hAySK0jdycqYgkZRB8Ejcg3yBUuG4Mp6PXdwD/UAxcxmRh09AbZeFTt0iQdqpJ1Px34uIh3ErWxGWrMXRxyZrLK/HCd3En0wcgLiQ8pE8hBCBk14im5JqOSoYry2zD+OZpLKnjoGuAzHf72wvtOwgGv+lO5d8cmliuOzHmdvzqZKox5Tkrs8MyxgmTlFt7ihM471yIa6JCyy/uSxEsfT32pKCIErSqeZ6QSkg75n49n8RxeTmQtqSHJhqjpCDGxax88tX2QZSjG8J1ckWWfXWVHtQXbCqk0P6DbSBCxnYlURj4XvirupahnIRh2l9qbasuqbGDDFo/QgvPxRG+rTvmz65dggfjTnmq94fjMZ0r2xEPvwRBbzhK8Xrlin0h8YtLGp4osSUeIBgwNizTjuGhXhnw2J28BMiYBHpylh0J6+tk1FH0Dp7Tb257Xq4OSoCVDNHruEiNUyqCn2WU2ESYFBdiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(84040400005)(451199015)(6916009)(66946007)(66476007)(66556008)(26005)(41300700001)(186003)(6512007)(8676002)(4326008)(2616005)(86362001)(36756003)(5660300002)(8936002)(54906003)(478600001)(83380400001)(6506007)(316002)(38100700002)(7416002)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SGjPp+g+3tYicaqyVbQDXvnPfoJE8rpi13E2wqIQ3NVe1AnEKEP3FF/Fk/c9?=
 =?us-ascii?Q?5iJJdGxrqLc0bhc3n+H4Us6lj/xbxJ4JVRX7A53SPGyJRgk1kEMkTqs2iaT8?=
 =?us-ascii?Q?ywgZ6DB2odUNdKl4LFA7p8sV8WWuZMEukoEMHIzo50KSogJe/fcgLHEsbJrd?=
 =?us-ascii?Q?VLVkXoijS6S6HRiqM1EmgV0Ds4Sp64uyaCNMSbFFHilQ1xzHQ0R7u7huXcsg?=
 =?us-ascii?Q?cB1+JDvrQ2VF61IHNDjXHEHSmBaIrMSPo7ZZPVFW+5nXeoQBKkt0+TdoE1is?=
 =?us-ascii?Q?25eU1B0ApbnUvZg2pnhpdhur5AHvS6Ix4de5GW/uOYHSTZt3Q2PVqql2W9pI?=
 =?us-ascii?Q?IACx+hlvjsjnQmT/Tmy4heaAk6H2NyMlLMdNwtmZi99v0FQnCqCS1e45fSvV?=
 =?us-ascii?Q?IQeU3xnrs0lyDR2jo1P74I+MCauVQQvAt7zA9KcE7TBvxt4T9FAmSwCOYn1H?=
 =?us-ascii?Q?xBD35HIV8nPzP25yu8bpKlAubhUmzYsc63SleBVv3EE8/H65Nioa10qS1ulS?=
 =?us-ascii?Q?tQolttI/x+rmfJor4VvtYjhxNWZz6doaHMCgdREPtPmGaVbH70ZQJvkwI6kK?=
 =?us-ascii?Q?yGZI33J0rhKrfPsR7GXGOljts7QuP7ztEP64ZDhlHLp1h7xhQcHEuYbNjALO?=
 =?us-ascii?Q?KKLJ0LuGkG3JLbfx7KTEGs3iQW1sfpZE1lbr+uLfTIJ+WiUaOZjqRR+C+Y2R?=
 =?us-ascii?Q?E6mlUWY8/HjB9Em7va3anektNi9z2PvUp2Y0vGEowupNS7AdvY89x5EQXpDX?=
 =?us-ascii?Q?gPKTW9dbT1gNA6T8PsHV9+7TrD1q8157BzBFJyFgn0yPL8Mk+qGcitWTcG9j?=
 =?us-ascii?Q?Tvy0ijGGW5bv5xlVkPOOjwKFAUUM270sVLs1YZzRp+Q/weLUFjf6veMAuvvc?=
 =?us-ascii?Q?5MHqn7VcP3ClJ+4rfBbq6d1OVJbcctehKTZ3YMFqPFC0G5H6qPLueDz4I+Ad?=
 =?us-ascii?Q?xEqcJy2SAiVrme+Bfa/js7IRvnWvsjPoi4gcazPOq+4kB6fwPcItHvMgdUPL?=
 =?us-ascii?Q?vcRo2LtTWkS2efFPxrm6H7wB6uerSR0McXpAoimZpXDXx6VlyKXDvsKQ1JV5?=
 =?us-ascii?Q?hThtH4fHt3yejUJQ79TYUR9GrY08VrGMJDu8zhCw0TqswfZWZhW5UXclfEug?=
 =?us-ascii?Q?5idM+5heWs1GQfoP9P/R2IIEglpYm2Cw56CDkclOLKTQ75aIYIxQKrMsWiHH?=
 =?us-ascii?Q?28U7+GDFGpn+oNIZIxB0sp/ndOyutZIoGz81QtmNyktlOD0l7Y6NRVkLL5GQ?=
 =?us-ascii?Q?QnjfANyEu3NTv99akz1gL2XV/tZIGmIA25WN25gNt3nLUPcELk0hucVCxAot?=
 =?us-ascii?Q?Ljh5hxOprPKNIW3Qt+uRRWBd4uZoC0bGSieYb6qNYeh4DeLQS/69s9nyw/7s?=
 =?us-ascii?Q?m2ZbnZ35dF1uvoGyNMEqP//RBm4MrFDY4oSG4uirnuh3h0tSzk1JRFZX1fm9?=
 =?us-ascii?Q?r4bRBpC0cFcRAkZ5MT3hZokx9wKEYVHVRplGI4ohl9YvBkhTRrJXQwyG41TH?=
 =?us-ascii?Q?F5oHqtmOVOgbd15hd5qxxqX4Sud0ag72LdYvkbuhkvNOjovZhfxCbIyrP+yn?=
 =?us-ascii?Q?i9yDNGVF6QLtaHZ1E9fYc3KcPBQVQcUuNq+u2cDj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c08f32f-97d3-4e4a-fb3b-08daf88ec3b1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 13:28:48.0330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1t9XnR4LrfHs2iOFsH6NoVgD4cLYVO6IShfpHChIMiiQJ2iyvQI1Vh0TLNT7kEl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8167
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 03:38:51AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, January 7, 2023 12:43 AM
> > 
> > @@ -2368,7 +2372,7 @@ static int iommu_domain_identity_map(struct
> > dmar_domain *domain,
> > 
> >  	return __domain_mapping(domain, first_vpfn,
> >  				first_vpfn, last_vpfn - first_vpfn + 1,
> > -				DMA_PTE_READ|DMA_PTE_WRITE);
> > +				DMA_PTE_READ|DMA_PTE_WRITE,
> > GFP_KERNEL);
> >  }
> 
> Baolu, can you help confirm whether switching from GFP_ATOMIC to
> GFP_KERNEL is OK in this path? it looks fine to me in a quick glance
> but want to be conservative here.

I checked it carefully myself as well, good to check again.

> > @@ -4333,7 +4337,8 @@ static size_t intel_iommu_unmap(struct
> > iommu_domain *domain,
> > 
> >  	/* Cope with horrid API which requires us to unmap more than the
> >  	   size argument if it happens to be a large-page mapping. */
> > -	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
> > &level));
> > +	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
> > &level,
> > +			       GFP_ATOMIC));
> 
> with level==0 it implies it's only lookup w/o pgtable allocation. From this
> angle it reads better to use a more relaxed gfp e.g. GFP_KERNEL here.

We should only write GFP_KERNEL if it is actually a sleepable context
because it will be mighty confusing if it isn't. I couldn't tell what
the context is so I left it as ATOMIC.

You are correct this is only just a lookup and so the value is never
used / doesn't matter.

Jason
