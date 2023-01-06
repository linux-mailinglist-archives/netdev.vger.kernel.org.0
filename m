Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E612C6605A7
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbjAFRY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbjAFRYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:24:16 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8167D1FD;
        Fri,  6 Jan 2023 09:24:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eS4WQQpuFUVu0BIQ24Tne76BrkHarT20WNH5gB/5ZCjZ2L+s1EdaNDyOqch0er8vtw/9lToOafchyylBbZeuHv+RvAuM8duxVEGJ07Mz2fgG6tyiU0B60Z2MgHkorqOBoXDAMUhoicyK1JN3PbUpyUAfEC2lbMX6wSz9PDJyG7z8JXkc3wEWZWo/hXaW8MQVy8B1NPOVn6jf4MMiwHGFr0VwbXt+fqlRc2P8Jdto5J9qOE+mkt9VpjClLUIxsDNEsjVDa52k6a6V39smSUBd5IpOHEiQPO5YZT0HoPtrrwI7zv0fs8JjwtrpQ6SJl+geNwIuhJ6S6wbYEtmoN6yV0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nC8yyf2i/rJX4emyigWAVpCtFlGoeW7cDYHn+lLikTc=;
 b=f8Kz8Bfw5h9iCquFZM+HlJpSwJQF6rMLmXtlDFR350JAV+djauH7kN9fqYBRjQpwUPou3Miju5Kd+QZUIKRDc2jRcoYC8zlAqg7nEtD+4spvf+uLcyZfuM91Sl/zM+YXp5VjA7O55rKfckOTA2Plqc4YK2PCJfSXbxxtDt5BSRzq3oalIwiaGHZIXf3UqCmD5WyQj1jC8lnXyVncOcAR9MpoLC5NPcJDuqsKw3lmEYAXadBRPB7tHokA2rYPfD8vZkvkUdeU58SHYHX3wydiQM+EOFYnpEECVduqSc0UI3VLSfqmWo26YEMgnjBun5PpfoAjXcgWnpQrIp4MFhYFEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nC8yyf2i/rJX4emyigWAVpCtFlGoeW7cDYHn+lLikTc=;
 b=dy20YQ0zCwCUynL/UqFT3QUZ6wkH8WAP961E41nFNktXLo5DgWVcTZKTe7YDgLfdAcUIDLJPX/QE3pfrYPzi5jbiSj24JpPmIVKd23pD9DbbQr1F3gQlDH90P2a2V0kniP0DC7a1tpqk89VJ0Z6unmx9H8CUFWpaKHoJhUZsxjVoszhyGWwc6JizHnzZ1MAn1gnAnl5YNZwCu8cwxWx65d1H0hCipwIXGaU5bpWmVJc3qXQJBQGb+aChnmOEzrzYDcNzzbtLJOfTuoSV3asnKKxbYyVdkOA3BqmpbFOYVQbk4fxanA5qkSMXtI3qT1j7dwlWSkanKzhPKrArovVEtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB5601.namprd12.prod.outlook.com (2603:10b6:303:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 17:24:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 17:24:12 +0000
Date:   Fri, 6 Jan 2023 13:24:11 -0400
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
Subject: Re: [PATCH 1/8] iommu: Add a gfp parameter to iommu_map()
Message-ID: <Y7hZOwerwljDKoQq@nvidia.com>
References: <1-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <4fd1b194-29ef-621d-4059-a8336058f217@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fd1b194-29ef-621d-4059-a8336058f217@arm.com>
X-ClientProxiedBy: MN2PR12CA0004.namprd12.prod.outlook.com
 (2603:10b6:208:a8::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: a380c960-bbc3-4788-e1ef-08daf00ad407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qJH666CBhIW5tUF2AsyhSKgkkKCL7qQ+0QvpkGXxA5fosBL2pe5k3FzB+YXv22Q2GysE6xXwb1HuOzGxF+qXLaq+nXCQrFd4y/n1GxEk8+S0bp5z9AYM0xBOoKAYRNbd5PBTl0BT7ABQFgzk9OqAQX5tRnqsTsNUgBG0TB6XpeH2RH6klh8Cza8zimRZeiqwEfNkiY3aK2XlvkEJU3OBi1agbVr2x8o2xq1CGGL+CTyWuYyEAF8w4caTrGQGp4bPYE1xwnPc3b3DyeMDZnVgNbBJD+h3lD+VE60bntuYQaIzJqRiOtJI2ksLPU6h8vEggZPTmS1rG51A3T3uTYAWG+dKn1+SxZ+G8iD4GtUWRVLKbLYNCjLOeHX6LsN6vv0fyQYQc8ud+tt9hIV8CdlrqHrpuAwoFwQ5pRuNvPPewxJ4OZILiGc+u6MVIw8lrm5XwFJG2m5n4m0ru0Y6rlol2eqebZJUSM84fCUCjd2fr4ChBU1OyOi34eIEBiJwDRPe6xIuWahIJSlBbFBY3Fv7/KwkjYRD35ynFav+MidO58TKqaGY2VimiJ/rbDKyPX3SXaN5HGJ0QaWCnld407OD+S9TFDS2mf2CozxQjxNITbgoKZqXwrbfspiAk41amQrhl4+9anZ9rkFCh+0s5XviQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199015)(54906003)(186003)(26005)(66556008)(66476007)(2616005)(6486002)(478600001)(6512007)(8676002)(8936002)(7416002)(83380400001)(41300700001)(5660300002)(2906002)(4326008)(316002)(66946007)(86362001)(6916009)(6506007)(53546011)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gUtguh/BhjSsWFMyOvOkTocwMW34MIv6f+dQH0dsuXmPdkuOjqZjELhOoCBR?=
 =?us-ascii?Q?jw/9LzWuOml7GUNslDGnwn35hTk3PfwFosS/n//Om1Omq40fna+7KkqQTSF4?=
 =?us-ascii?Q?D6sIJr7h9Gfk0ZeWsJBVRBm11B+Darv7rylsGsY0WKszhDnvMWSWJRA/MqI9?=
 =?us-ascii?Q?hsetMQd/d1+oJdZAlyW1iiJTtgk8PrMuAzfkTs42KLEZ+2QU6H8iSsT1FyBt?=
 =?us-ascii?Q?VSLPzGYe8cQxO1WUF86hM/4N4RWO3dfhARjrkUizubFVbCstcWf4VA2Q4sm9?=
 =?us-ascii?Q?42sdcJJNEd0DrrgSCfk0chB21gvbI14S6UJ6XJhl81+UKR1TlxKjdkfIVroU?=
 =?us-ascii?Q?vHa3qlcSPjUK7l9PJk46XCLZSa7BLIZLIEn2ktcKl47Azrm6LIu/XszuIu+8?=
 =?us-ascii?Q?UZOWwrCt74fT43uZdnZT9Zfbrwn0w7BW0mGaXpCth8FfaFN07Rl2mam0O7D0?=
 =?us-ascii?Q?gxA1/xJcSE7aUKUncuhSvGsSCPeFfgx1T71E+59Z+8/rGdGH6PD0HwxggPz+?=
 =?us-ascii?Q?gFjHo/QAVRvyJqoTqP3N9gzeaLxiWLoaDwWM+O2eCTe3VaEavpuLW+X7ZqaB?=
 =?us-ascii?Q?nZAyRj8OV/ujMXMFsg4pKDLJSWMsd8u/f5t5rjZgfVBkKFGTZ0CVRjEi2OIM?=
 =?us-ascii?Q?HplJ3hvt6yMxfJ8HU7BcD1G2JXVtQhGD/Lxt8braTiN/MSuDWSO6tUoUmIvs?=
 =?us-ascii?Q?4MVTggacoJznwyUTxA7mKHOs3oX1EQD3Bi/0DAxiCXsWKShBaITtJh6m9ucK?=
 =?us-ascii?Q?k5gbShKvKfd8d6t5YWtP1RrTSUXXVxaXGLHzPg8KlSPCNHcUQhQBWTWYY4By?=
 =?us-ascii?Q?NFE5y/n2dynXHdjy2/nIf8Yxd/vSzBW/gx2vDf7m0kJjIAJk/vdXr8x755Up?=
 =?us-ascii?Q?qgnC7KJ8wu3VE42HIMu+T0s0WGsEZlRNtPGlwAxEI+OisFxdreVgEUmHHFpK?=
 =?us-ascii?Q?nJagpumxXtxVoVDp6I4zPrivqQSVZzplcfplE0qu6mXkdj9qZK2F6wL36b3q?=
 =?us-ascii?Q?jrCXpMZaCFpv+Xal25tX6jqHeYX+3OPYeLc+jZYNZzEpqkTyy2VRvTomYZt1?=
 =?us-ascii?Q?PRhA5xSzVWtHhxDWZXLj+Ha4bpATSb8KkyB1f+G0W5F+OX0f3+U44ZXm5G/d?=
 =?us-ascii?Q?nmuL44r/aT8Odag8gE0zL+vnZsYjkif6UEqiH4w1p/fPdVOTy2Ze8kiB6Ecv?=
 =?us-ascii?Q?GeS18tfQFq2kBnYk/+U6iSkDavbJo5rO8mpMqLb+BzxQfpGAQJZMrfOknBnK?=
 =?us-ascii?Q?oBPIbmEe5Jzp/w1D1B+nuoTMCYm0i6YBD+84hAOe06aU2IVF70WG8pa0Lo67?=
 =?us-ascii?Q?y3gr3I894Exe5oQkhznS2TuG3UDApRj7jZQYSxdOp62P83+SwGHOgL1P6jgA?=
 =?us-ascii?Q?GbV53ubvNCNTBM0uP9GhYwb4WWnjh7jjIDhyZELmQDlSTtuh1tOr67dGTqW2?=
 =?us-ascii?Q?nKOaf5OvnXFR3G+ycDWf6znVbK0mGti3bQ51KYU1ieMy+4Oc9L8HJDxAScD+?=
 =?us-ascii?Q?eUzyRx/JZt4JOZ75y4YnKNES9JvIpZjayYtbPSws/bsAm12Qp7pbrpsNv0Bf?=
 =?us-ascii?Q?BLbdROencX9YMTiONhIirY8MXkPGWLo+bBmeTMjI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a380c960-bbc3-4788-e1ef-08daf00ad407
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 17:24:12.7096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /G4slPQ9LdfbZ+iK5j2t1fMDw7VqdkXkdo74dzB3f1XOhCF0xdxdWnTliW/zmjfK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5601
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 05:15:28PM +0000, Robin Murphy wrote:
> On 2023-01-06 16:42, Jason Gunthorpe wrote:
> > The internal mechanisms support this, but instead of exposting the gfp to
> > the caller it wrappers it into iommu_map() and iommu_map_atomic()
> > 
> > Fix this instead of adding more variants for GFP_KERNEL_ACCOUNT.
> 
> FWIW, since we *do* have two variants already, I think I'd have a mild
> preference for leaving the regular map calls as-is (i.e. implicit
> GFP_KERNEL), and just generalising the _atomic versions for the special
> cases.

I think it is just better to follow kernel convention and have
allocation functions include the GFP because it is a clear signal to
the user that there is an allocation hidden inside the API. The whole
point of gfp is not to have multitudes of every function for every
allocation mode.

There are not so many callers that it seems worth worrying about
removing the extra GFP_KERNEL argument.

> However, echoing the recent activity over on the DMA API side of things, I
> think it's still worth proactively constraining the set of permissible
> flags, lest we end up with more weird problems if stuff that doesn't really
> make sense, like GFP_COMP or zone flags, manages to leak through (that may
> have been part of the reason for having the current wrappers rather than a
> bare gfp argument in the first place, I forget now).

Yeah, that can be done

Thanks,
Jason
