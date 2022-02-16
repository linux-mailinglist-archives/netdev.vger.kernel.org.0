Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5264B876B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 13:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiBPMOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 07:14:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiBPMOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 07:14:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD7C2A229A;
        Wed, 16 Feb 2022 04:14:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7VgW8TutMZNrtln0LsJPy3UY2APGlLCiYT6+UV4n0MP1xP3bhYMOrvgyu9TwUsV0o7sJMXd6e4IhaBQoxT3ecmSFq0l+o/qZovrTgR+LOV9aUGgl+or1bMD1lhNoZNjwN9QiD8kiXQHqiLyGNQUM8+CsDG2Ie5MEMTLq1uc7PMZOGrYtHJxHq3oLFwKwkNhVV8j2eeLGAUPu/+tJaMu/UnyIpFFrQm8t0Di93ZlRdtN60w49juDHM5SANOldEP/tzBv+DuqVW+jIp7tujrT79C7n10nGlgN4+p6WOH+qd1QabXeY52cTklr5gPtYWUrWz7AnOEHfOL3wJvwG7TC2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ay3Shv3nhMrsz0DwTk4vvjRTEzA92i2QgVItYKq5wlg=;
 b=OEriwcnZAzUbGMEU4me8bTR9oft9yb0YUgLWi8kevJmVJkLjsEAjY/v1xxeMN7Gp9IugsFDMHnLMODHdkVKoZfbribmEn9K+7v3Vw4wGgqzS0CtslRYBG4tKPy9DrhKqP+5cT4BZHJpVIjSdKzD/kV8iNgo7ye0lrpWQ+FAeUwBzO/FRZ9iIpX+hflS7ltY8QaUsZBt/3MUwzNP3xJSUo9hT6yIK83Yud5ejnofYDHi+Pz4lYeOzUSSpQzgm+oWi2IUv8QYmZ9kcDOOBkBK1UFB3bYKAaQm08YjW4B0pkJPj+q5xqMjOKKDyyHd56sfp7o/6Fzm3EPt1/c51WKBDQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay3Shv3nhMrsz0DwTk4vvjRTEzA92i2QgVItYKq5wlg=;
 b=tYIp93/HAO6Q9mG4n4K4R3N8NaucRnY2qcEAoz+eai/4xK1SZ+Ee2bfkec/gqvfUaEMrLL7hzqkwpvI0hLAFmhWYTl4V0HfF4ifOruS2KNlQ+IzKFpRJXF+yxK83sWIFOTIn97eHpyt8s0p/R3cwhpid5hb1DlC1k7us7HlTjVBO3HBfYw2qIju/udb9Ue0lAllsrNAXwthMNRqQ2leGNGAwYVuLuZ2hkhckqkfUSE3C49ShEi+MZTF7sxLcPx9Lv9B31rc8GHWrDF4cpE5hUnu+mCC8xO7Tfz2KRCVXKkSRMJWhIOV4nKa/fgvD1fmeSWeJ7wdRYQZr0jHLx8+Hig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5606.namprd12.prod.outlook.com (2603:10b6:510:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Wed, 16 Feb
 2022 12:14:17 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 12:14:17 +0000
Date:   Wed, 16 Feb 2022 08:14:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220216121416.GF4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com>
 <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220215160419.GC1046125@nvidia.com>
 <BN9PR11MB527610A23D8271F45F72C1728C359@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527610A23D8271F45F72C1728C359@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR16CA0063.namprd16.prod.outlook.com
 (2603:10b6:208:234::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b0109d0-e9f0-4d48-042f-08d9f145dac7
X-MS-TrafficTypeDiagnostic: PH0PR12MB5606:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB56062F5C702DD53604425585C2359@PH0PR12MB5606.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g775xNJdFlcsT7x68g2ui2gl2b8cLbrXLmKy/EMx/87KoPw3MI/VDZuFdgh3qhdmuWXv9O9OeSd5m0BEmybzJlPuBFMsMtWR9RmlxEFmfoEeuwnlX8AB8JssWt34nt2J1HlMyVZz4aJsaHPcQcOOpBZeOV6rZPEJoX/V6R6Yjf0EcbSIA/zQt+DykahG6RDmcwnSKFV5ZmxUo/Sab7iHMzzRKQNUYTlND+wnDe2VrNuBMYb+aLI7LXli06uYG0nc5AMBKcEryqdiJCeYkIWZ1WQWPD7pkGzoN/3i2aYV8ofhV6MZIATphhXXDFeyuoJjWPvig/USGrhN+aJWbnBA27nr1kqHapT3DVSrOEWd6rT1xY2d09Zb+k3bPbt5IYd6DCI4bX4h/cxPrHNu2OoEWP5dwB1wMLbd5i71TAmOmokb3UWRgwRotgohXOQigBvVhHMUo7kkl8/htaoEjfyXynZVAkJlDkjQEdUIfPKFPf8S5Gxh9ZkBKNIlXQMtWpaBDBSjCJIwAJ0NXLireeAz9Ye7FJT6JAp/0OHEfiG0p+mhOwZBVpVzzNupHDgp5PNOaYIhahFmTlyrPEZJGng8MUpSIhWNgmgsOSA7s6u9YHvV5NYaIk9VKjHprz7oKHf4JSbN3c/Sfhsur4V8d7NGkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(6916009)(6486002)(2616005)(6506007)(66946007)(54906003)(186003)(2906002)(26005)(4744005)(1076003)(36756003)(508600001)(8676002)(38100700002)(66476007)(5660300002)(86362001)(8936002)(6512007)(66556008)(33656002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kGwbsdh8zYNSiQihSSHMNabuKts2pGKBj7EWBUGsDhAcdf4h2dK0WI+sFgdZ?=
 =?us-ascii?Q?VAnImQmJlJ3DhrX8OCtLh0XnXhhCIsRkqQKIKohj7+Q0IhZNFuVjEtY3J1HB?=
 =?us-ascii?Q?Pp3pulOQVLYpxNZ9GZYFO+oM67WdwPrKoEvExOTyaDD0tDP3tCUQMjnQLJVD?=
 =?us-ascii?Q?u/GcIHqQ/wqwxWBNHcT6lDLDHcDe0IkWwhmO43HzEqiVkbtonnuVkju9PbM6?=
 =?us-ascii?Q?yNDYCIhx5Zst9ARXVWULlfqImaKyJzQtGILakLfsYL6eNIk4FDY4ZFsgzjX2?=
 =?us-ascii?Q?G9EIeXgQPgi89OFiSPOkLzyWyTJ5Nm7OZEq7kqkjiyzqtK+9WxGuUrdImd3B?=
 =?us-ascii?Q?igY4IO2suEoGVDAVpL7k1vvSLPfvWDByquUXaRUT+SS4/QPHB4k5xCXU7nPe?=
 =?us-ascii?Q?z7/Q+V4f/akAGZGF9T0cLVPe+Z3qQWNWIxz53AKnuBYRAVdB++YFIY5dGP5d?=
 =?us-ascii?Q?Y7W9rHCKnDnvzRshA+0O4ez+nBsKSIC90DcAozFlpK1UkIDtXsAvF/Dmejcq?=
 =?us-ascii?Q?52p15IEegD56lIh1+G185CPB0866kZbh+tWG7vfPTiZsIzmFs3fDXjTQgLNF?=
 =?us-ascii?Q?tOZ2QdTv9r/1NSBoPnwAeQ7rmAG/p+chMC522katVIhUkPNVlty/kH1+CBEK?=
 =?us-ascii?Q?TTSHFGcKdgvUK8BM7PKARlYIruXdzi7MNKWwYv2wQGIXPnXtLh48QuP5k5cW?=
 =?us-ascii?Q?/vh1FSXzVHAW/MgCRPKv9eauPFC4288mb82KQLg0C/CyZ2IJEPlyJqFdJaoe?=
 =?us-ascii?Q?qmoh/l3YixAw7CNCz2tmmW6uFj6PVhF65a88XLZjM5DXkdFbDaRda6HuEJGm?=
 =?us-ascii?Q?3+gO+KMHV7LlPdcsJd60TGMlxgx4LXTcTODWZSQWSc/oUEu3yyfo4Y7sgzGt?=
 =?us-ascii?Q?6X2YWRhJ73kx2lpJaBlaioZNHmImOqu0BOXoU0tafUikxsEXtg0mFaiWXCld?=
 =?us-ascii?Q?BB4ctTKL7Tjk/DyUwIZA/v3B2N758jOmRUUnKjEAYy7C8XkrklgTBKP1l2oI?=
 =?us-ascii?Q?tcMmHLRX8RuDJD+4WEcgjJFU+dMD6Ts/otzgm9L/ODP2FsttwYcdsqt9KEzB?=
 =?us-ascii?Q?7M/uiDLcp6AVNB9CeHXP8ARHOyuaYHIgXxUOJ862LNASdTt/CSj7iuEva9EF?=
 =?us-ascii?Q?aUbBe86vdsnUas1GGpv3/Tg42dM8llcqfUWewMOFa4OippLTKez1ShqbBxnJ?=
 =?us-ascii?Q?ZD7R24k2Rod61uWj3jKLcvlf4gjnKJ80OQkfwt6a2Ujler8+XvinItMcNzGQ?=
 =?us-ascii?Q?lkxBpDRLK1Wp32H8lwR4tjGbhIZc0ok9f0KGdBSTjXa1PN4Dm7KYJuFO/qa1?=
 =?us-ascii?Q?wYBuIvLNlMlN3DK9wJu7bycD/spFlwX9dAb50yd3NZpurX9BOl1rCaA9/FvM?=
 =?us-ascii?Q?PXK/JPsNCtLAZeoz3xDZTe0M5KinxWagGd+9ifH/76gX6DntIWMQ+3OTjIgI?=
 =?us-ascii?Q?oNgEKSmMELxccHFUL1EBZaA5iSYzcqoJfKGk9YO9vrdADgJAifhPp3w6CWap?=
 =?us-ascii?Q?p3Y+ppYgS2VCHvc4ZcvXuVpPCht4X31vGD01f59bBPfs0BMZy/BqleYnZHLP?=
 =?us-ascii?Q?V+5Z13Z+VIbDFebced4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0109d0-e9f0-4d48-042f-08d9f145dac7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 12:14:17.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K95KZpzMxVvD/1YAFjbaJTZmmmynpd21KEfCzF+r+OUU/rE+nRaxey2Ku/eVCRNP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5606
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 03:17:36AM +0000, Tian, Kevin wrote:

> those requests don't rely on vCPUs but still take time to complete
> (thus may break SLA) and are invisible to migration driver (directly
> submitted by the guest thus cannot be estimated). So the only means 
> is for user to wait on a fd with a timeout (based on whatever SLA) and
> if expires then aborts migration (may retry later).

I think I explained in my other email how this can be implemented
today with v2 for STOP_COPY without an event fd.

Such a device might even be able to implement an abort..

Jason
