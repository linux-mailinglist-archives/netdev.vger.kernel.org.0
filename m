Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E5E675F09
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 21:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjATUi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 15:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjATUiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 15:38:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2048.outbound.protection.outlook.com [40.107.100.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB54966FD;
        Fri, 20 Jan 2023 12:38:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgbYVJU626le31ZRWXr2CPdZMKn686BILxA6T/cblLVWEA8mb9NQc/nvXfpTvTDKWF1xsgd/+SXtBdHBPyEkJ/De+O9PHRpaYywFG9rFlR8cXkhyU9UUvLEMvZv7uy/U1WMN0ph41p6d/dKPAocId2OZzgx9KLz8UeT0AE0cAbZyj77BYpbtpsxzLXqwHnyd62F8us6wijWwseNVbx/AsELyJ5rAuGMwX3J2xhml+jLRQzag+85jkXuaQna6Q57eyv/+GE2n+6NjBafW2UrWHHmKQApxSyfee+FL6Rgmfl/9erDISP1z19CNq+jqwC9ZQnY7J8NibC7V/z/tednb7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65YIash6zu+NspDmH4rIMcXSTVQi4mw9TTPwHsfeFN0=;
 b=IReNjXRMhtikCvbkuqQ1oo6ufdbweW2MZlDAgVN0MzQH8huEaSx0TITWr/t3AUg40y9qDL8NMJRfwHc7BzhEBk+PU+cUY5QenKjqVwcVg8OH+QUrhO+6feWdg3VRYr8xJryzmXMSzFc3GkX22yzUMpnwvbn4h0stfK99Qr6G5jwuUHjBdbhpGp7ADEnKXUub0aueLvNsoMpw7E0ipXQmeNLYcoW7OVqKBcn9xfIZg615Y+yzh2roR9cL7sdm75WU1h5/nNrswaFsgI4lSfks0K4Sm71Ja0VQOxB7a1xAnsgslJ7jA5Ma7JASwovEH0nVYHYHNqWiYDjQzu+lFL52+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65YIash6zu+NspDmH4rIMcXSTVQi4mw9TTPwHsfeFN0=;
 b=jU4Arc84rMDK1/GY9iwQq9jYNVYBfMlkjBmnuulc3fI9gav5Tydx9c9UmoOU8qTG2EqXZ37JTDfCNZ0AaNgwXOI3fFE+IpTRaIslxzn6i4Ht7qwJfSDJrfZPnXg42j6DQ19ttpBGHTpPbH7e6pWbZG1OhvG8/2Hjcwv7ReuAotaNqH7gInaj4m44wXsdcQIFN6CGT3r+iPf+TISKJeyFe3Jp3JYKmIOXs3c+6/z5JrlrZ6A1dXdmo5/xJ4rwCmDzvBDLqeS9DvXKGFTo79tgU/RkjSQNDCoXeyAbqitNUFUv52TQRcP/QmP+EB9p+m4KYLYDgqHApfwJsWH76sQslQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5832.namprd12.prod.outlook.com (2603:10b6:510:1d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 20:38:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Fri, 20 Jan 2023
 20:38:19 +0000
Date:   Fri, 20 Jan 2023 16:38:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v2 04/10] iommu/dma: Use the gfp parameter in
 __iommu_dma_alloc_noncontiguous()
Message-ID: <Y8r7ujD8BVgWiIH/@nvidia.com>
References: <4-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
 <f24fcba7-2fcb-ed43-05da-60763dbb07bf@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f24fcba7-2fcb-ed43-05da-60763dbb07bf@arm.com>
X-ClientProxiedBy: BL1PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5832:EE_
X-MS-Office365-Filtering-Correlation-Id: c7e236de-7c93-454f-b089-08dafb2643f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZRZHOHjF1dSv4pXCeo1eko9iM0cmlCnSjGxmQAchQ5Nv+g/kwgiWS8la+MpfnHKGwNmIdLt4tG2jhQROjRYejvJwrUka6rX5kz68qWrJ4snIJ5zcIIBYQplkQFqy9WAptn5Y8AlYKGoD+zjN+3YGT7FuBKDJtwzhPJjb3Ja+Rzf7CF8kpimOaIkYZSBQjYP1zdfA8Zb3quT1sQ0qXZ/qK73t9k0/LtHQANmHxlao2mUmkRKphysfXI4373eF7f0NshfofwG7P11XERGjO2HlqPas6bJKusEaYj6/s6Xu4WRzeBLhTBlUpwHHYbPwQsw0Xay4AOqKj0YC2TSY8JtaqbU0cNcdnIKXES2/yAbnuu+NDSg0bALk0oGaYzXmYjlC8VnkiquCrpT1kbek6+SPHZL6Ow0pxf6FJkDaeGKyGRnTQt5bYGkR/Mw1ZoNAdaHBaarZdTzkPq5TZ4Z4/Du8At7VsAatk8cfAE4GsMSrGq5sFrR+vY2J7tl2QbxQWrF2ThCtDdirPaFrKpo+D9wc9SIIZlDkS758YhRnygHl8BIV1TGa6BcSBP2RtCfOive7BWXSlN6ShWFnM7P7Xzs9/osIWB9yamZVVCIx/Uo/wPiup1e9k4ZbHqcC642yrNw07pjnMPcm2r5R1AUY/uIRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199015)(8936002)(316002)(5660300002)(86362001)(6486002)(478600001)(36756003)(6506007)(53546011)(2906002)(2616005)(83380400001)(6512007)(54906003)(6916009)(4326008)(8676002)(66556008)(7416002)(186003)(26005)(66476007)(66946007)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eLNs2NpejaIlYGQJD7BSOOF8jqxbQLUwSjPxwiqPm8yOsE3TFBuR1dwsqnPh?=
 =?us-ascii?Q?fSjIvvzStUErWKQNWdKaVtTomJbu3DJ7HGP3mDx4NXVdmdMdMIDuh8yNQETW?=
 =?us-ascii?Q?6dsaFX6imCqqI6yte9AmOyJ65Obu8ODrxidy3RXFRLW5qiHg+lPyYmMSsJJL?=
 =?us-ascii?Q?Efi8Xk+wlLKtYpFHiTegMWy+YracsaRIM8voTm/MqHk0fNww5qtLK+3BXzov?=
 =?us-ascii?Q?BxgjBaapmzZVcQAz3rUO5Ba0XFglxDayN+ZRsiM5CQhLZdeubkxRTmfsb0oc?=
 =?us-ascii?Q?7Qf27NMo9/PayC4ppKZxobriQ04T1qglsklGzsSNZ8S3VVBKUsxxTyWl7ryE?=
 =?us-ascii?Q?lDYuOOVGW/ZF/LdSZL9+w/5Vl7jectcLANgN/897PMtVNXTFejPZZGYFqQEx?=
 =?us-ascii?Q?CE+SE3VtS+FoBL7NDv1gma247PitkjyOeTvv6i9nn4vH6I6ChQtzk7Uz+KuT?=
 =?us-ascii?Q?ZhSoJF1IoJ/eoIAGcmY0tM0QKZtgGvFFAkjISNbXyfKZB+4X/sqJAQoEIan3?=
 =?us-ascii?Q?4RL5qt/IPWpbKTMtqB88KFpEb2iPlGo0U1Oj++CZeXv25UG6M8TQQkno5VYA?=
 =?us-ascii?Q?6C27X1MXFwxaqaiTh7RUXoRJTSKvVoD8rxzkUEev8sMvQtZ9NiEUnzaIMeWM?=
 =?us-ascii?Q?N3LccgBMJz83qvT36sQv9Bv8u3CJCeR8RzuuWdwHJ500+tJML73WDk79zqaL?=
 =?us-ascii?Q?WxaR/lb+iaO8BMapdsipnlDUfbJD5i390CNjzbiNMlMdHGIkbB5akvxNrQI0?=
 =?us-ascii?Q?LZNSqwttNY1U+qyfQcGrQftKtNZmubAAEx6dMJEUpF2N7jT4siSQwlP3wPzP?=
 =?us-ascii?Q?ZfCsz4pYxrHjnRCLwjo+ba2MzCEn5PjhbtAoe2CnQjn3RCG8jkcbNNd/Sci2?=
 =?us-ascii?Q?Bzr/oQuAr528RcCjpl5h7H92rsTaq249xOkti/hpkOBBntfVH1qZGKxnNvtT?=
 =?us-ascii?Q?PV/CTrRdFguBy05/4CoSwXQFGIAi9nQkbYSEyhV2CLESw8lZ3QxfKbSBMVGK?=
 =?us-ascii?Q?YmdNkaZwNu8dzToq6GDnxUHsz0oEfid2UdCGQTgyjLiV9dHE03LU+GgjGnyV?=
 =?us-ascii?Q?Jbv60xIkvyiSW+7w6bCRVfyMvsSWGDnpN/60GKCDyilBoVPjYSA4RrWJFfEu?=
 =?us-ascii?Q?CxaqXkEZEclp/ejV33Fh87B5+bSbsXWjkDlDEfzDnleAdEcWTV0G93K5Y2RS?=
 =?us-ascii?Q?++aS9oMY/GdbEkoaVk5wFBMMrRTzg1C/y4RSbAgvmBA7y7mv/fC6kg2oZ/RP?=
 =?us-ascii?Q?MmCnZ8wc911dPtVTwzSCt++84PV/H/7IX4XajxVXivaudWDnRBnLyFjjLW8Q?=
 =?us-ascii?Q?+LgIozmeLyPN/fDPSNn3g3fJjss+oCyJqPhoS8ZaqDeAo6qcWfwvEdKTc9vF?=
 =?us-ascii?Q?4Nn5liLbUJXNAAT1eDk1hyJkhyV26doqKK89SZRAsuTZxutabe5H8sFkyrOA?=
 =?us-ascii?Q?PCMcq6tv2MaNOGTdvpv8qOpDZo9s+so/SzkEKTgZrRIkIT1irrKybAYwvgAS?=
 =?us-ascii?Q?Lp2hwsykuDIXrUtdyqEa+Lz/6EPg079r5+AlImISzXmrPjjq+g1EOES7A3ut?=
 =?us-ascii?Q?JJIDdfGelfYpkRWQJO5zNJEN2+e3reaZsTzzL05X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e236de-7c93-454f-b089-08dafb2643f8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 20:38:19.6234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4oTXB2HGiakYi0h1ZGvqDZ0EKLD00yaUn4LwqJEODca1cuxfEW6JYt7EaHjMJ75
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5832
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 07:28:19PM +0000, Robin Murphy wrote:
> On 2023-01-18 18:00, Jason Gunthorpe wrote:
> > Change the sg_alloc_table_from_pages() allocation that was hardwired to
> > GFP_KERNEL to use the gfp parameter like the other allocations in this
> > function.
> > 
> > Auditing says this is never called from an atomic context, so it is safe
> > as is, but reads wrong.
> 
> I think the point may have been that the sgtable metadata is a
> logically-distinct allocation from the buffer pages themselves. Much like
> the allocation of the pages array itself further down in
> __iommu_dma_alloc_pages().

That makes sense, and it is a good reason to mask off the allocation
policy flags from the gfp.

On the other hand it also makes sense to continue to pass in things
like NOWAIT|NOWARN to all the allocations. Even to the iommu driver.

So I'd prefer to change this to mask and make all the following calls
consistently use the input gfp

> I'd say the more confusing thing about this particular context is why we're
> using iommu_map_sg_atomic() further down - that seems to have been an
> oversight in 781ca2de89ba, since this particular path has never supported
> being called in atomic context.

Huh. I had fixed that in v1, this patch was supposed to have that
hunk, that was the main point of making this patch actually..

> Overall I'm starting to wonder if it might not be better to stick a "use
> GFP_KERNEL_ACCOUNT if you allocate" flag in the domain for any level of the
> API internals to pick up as appropriate, rather than propagate per-call gfp
> flags everywhere. 

We might get to something like that, but it requires more parts that
are not ready yet. Most likely this would take the form of some kind
of 'this is an iommufd created domain' indication. This happens
naturally as part of the nesting patches.

Right now I want to get people to start testing with this because the
charge from the IOPTEs is far and away the largest memory draw.  Parts
like fixing the iommu drivers to actually use gfp are necessary to
make it work.

If we flip the two places using KERNEL_ACCOUNT to something else later
it doesn't really matter. I think the removal of the two _atomic
wrappers is still appropriate stand-alone.

> As it stands we're still missing potential pagetable and other
> domain-related allocations by drivers in .attach_dev and even (in

Yes, I plan to get to those when we add an alloc_domain_iommufd() or
whatever op. The driver will know the calling context and can set the
gfp flags for any allocations under alloc_domain under that time.

Then we can go and figure out if there are other allocations and if
all or only some drivers need a flag - eg at attach time. Though this
is less worrying because you can only scale attach up to num_pasids *
num open vfios.

iommufd will let userspace create and populate an unlimited number of
iommu_domains, so everything linked to an unattached iommu_domain
should be charged.

> probably-shouldn't-really-happen cases) .unmap_pages...

Gah, unmap_pages isn't allow to fail. There is no way to recover from
this. iommufd will spew a warn and then have a small race where
userspace can UAF kernel memory.

I'd call such a driver implementation broken. Why would you need to do
this?? :(

Thanks,
Jason
