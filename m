Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330BB34AD25
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhCZRM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 13:12:27 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:29793
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230080AbhCZRMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 13:12:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhoUfwN3owIes/Kb9LkMfKLMx5JnZ4qVeYi11P+pzfXbO74Kz+QV3KEj+ojPje/5bHx3ZjyDpbmyoOojImv3RccSQdfU8ESQj+jCsSiYSp5dEMCSNINyOh24GoPmvhrln6/2r7hQJl5YLkywP9mg9OhprH453fW7K4tRiyIYEHMg2hvKMDyNgXKUWCJEqIIa/qMyIteV2Fb0HFPlt9teGW6hn2MZrCjRUAdzRwC5M1nlQFsIrdMg5QlyYNxYO5MckBzLRFjl+kD1rURD6oIjhc6ipwhhNKKGYT/U3hLM5rHjWlFLOvn1ejTYsOHHMt/ZIjuAdlATFMus0cqJtBwIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iae8KLBRfPQOT6ncut+xqvUNg+fySkpVwNteUfVYTQE=;
 b=KmY2LAXpzhF59cdoqNhdEoZ+LvsPyMhTHvITlXbkX4T9H5h1NLOoIc+Lp5GnjNOZDkOHuQikS1lpyNz/HJ6bu268hi+LzdoFAwKLHIPkMqv31YXDzX2qYmjcId9AhZcoY3ym4WYJR0Cnjy+3JyhW9BiapIBQcJcz6/T5XxJ0zMRRTMyEtazfxElgWffYJY6Gbsyqing3h+SgeZ+wwO08jia7Ax6hv7hMvgRW98a+4mImfKTFULFtyDbbba4UsXAOYN+Fs2xC4aVozRVNl8YI5iRpIUvyCbCxXI1qaZTYpx1GxOxh4gUkJaySjAlg1JwaBtTdnxmK2VydWR7zTp/RuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iae8KLBRfPQOT6ncut+xqvUNg+fySkpVwNteUfVYTQE=;
 b=D7IOGLFgQsZnyyscZNQXdfFph4yaV/oE+Z5KrAXwOnFCVq+ha06UqAWDCF543qZ5VkTNW3APHvvGHxMKgwMVxh7YHpLmA53A145ojs5Bo1C7gKusmtJ+qg+ptWlKaczLhhMbySpw1Ckxt0rfdo3STwfZvzJKuFwltikvNsi12KkHyF1991VVLN9F69Rcx1BkQJ2lvbX9cwPYFMMvFyQTQXbqzvje62IUaQKTRt7p+C4p6Wl64UO7+kLtFdY034I/kPZ6XalShBuetBo2igjRC10V48t/jTZALb2mH78SZmlcYmFXzHKAnxtrzdjVDJRaGI2SOtIn1nEiV0rsSDh/Hg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 17:12:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Fri, 26 Mar 2021
 17:12:10 +0000
Date:   Fri, 26 Mar 2021 14:12:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210326171209.GP2356281@nvidia.com>
References: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
 <20210326170831.GA890834@bjorn-Precision-5520>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326170831.GA890834@bjorn-Precision-5520>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:208:d4::46) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR04CA0033.namprd04.prod.outlook.com (2603:10b6:208:d4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 17:12:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPq0H-003e41-7D; Fri, 26 Mar 2021 14:12:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f443c0cd-1003-42ba-0767-08d8f07a4acc
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1883242987E160124EC9FEE9C2619@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKOQiU/Tjf1XcKPhnIhfK7rOawjcEe3ESlRP7/CrSvIkmgJTyqN3vtfdCoLN9GykgufVpzFxqTB15cKcDEIvjFy1BPlFXiVrFAGzyOJBdo+3xe9+Frr5OGtRD6YlF915SiSQ0CQEiRZ1g2aK3EGL3l3EuYdadYiM/qfqy13F2UzFFqBwAEgp93/zPV9dRfs6TW5cXoSj7GrHfN4j3O5bE94Gt0+Tj9WQgd88IfqOaLanpOXHZwzder2Q/5cWIgeJ7Ze/a8Vuik0leicrEAFTtqWqm48P/L465fd7kS46w66KMrtuAT+53fX5frOHFZUqun/GBLlq8yhEClxoF3doad3Kt0QYIUtzxbI65vbIgfMj9rbUDAp8WI4ikhUomISNywBTzw6PyeKrrH0CuR5G3vgSFkUzyExu8lCW/7M9Sx3pb1UguKCssssCefw44f5Dk3KJFnYNBh7yPQ2BTuQId1e9sJgy89VZGxB61jSH1NE9mdtlhfEzNPBli8/iCQ/tTXU7yGr7XvS3q0b6AY8qmRTWHfpAuqMlZNcaPkbfUATqMwhDwiMbOTlw6EiEpjtp8wGid3f34Tdq+OvdaM0Ylc/SNqlQf/RhQP8zSC2fGHgXvIooFSeZVY9BJ/hTt1ggKUjoOR0yxJOvwmVGGj4gKKacAHt/hGndgFWZHy7xp3c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(6916009)(36756003)(8936002)(1076003)(86362001)(8676002)(558084003)(478600001)(66476007)(316002)(2616005)(26005)(426003)(66556008)(2906002)(54906003)(66946007)(9786002)(7416002)(38100700001)(5660300002)(4326008)(186003)(9746002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TpcCsM87J0x8yfGE44cvqtEeONwqxu2ca4Mz4gMuXr1KFsq2Xboch8vETKfh?=
 =?us-ascii?Q?QDj3avrDdzDJNcWyKWtpzq0G8pkHkr2kSDuhwiOIPy7XiRAZ4WqYO+XMlZne?=
 =?us-ascii?Q?WtaZq297Cz2i+hJUr4ae63h1UZp0uhKdxpR8vdK0EzbJJkP/xDBpIthwJ5gj?=
 =?us-ascii?Q?bWZCAEjM7sF1YwE05wvCY1d+TiUCELBb7kg+If+QY6tfbjik5wKKiz0IG92n?=
 =?us-ascii?Q?iG2hGyuV6g0D5dbsmFdMdvqx6VQA6sCY3kdU9Y97kSR8GbAbdjhWbXE52vWu?=
 =?us-ascii?Q?q7ZljoCM+TLl6QxYNxbNN92hIkTubIdoV0AMQLWHP2pkJiK6S060qQSVBGO2?=
 =?us-ascii?Q?gCJ7ZEpsgfNoAtbKaIDzwlHcIw7m8D0dcGw0xVXyqc3DKIvlj2UP87PvKVYE?=
 =?us-ascii?Q?lvU4+nH4JBRD5iTq50pX14ujpzWXajtnrEfFYZhp6mjF4RWVRO+5qDjXpHg4?=
 =?us-ascii?Q?Rq6OOWuX70U+oyramYRx023yw73IQjNPJBwBqcxDt4e5GIA21B7FRsdkTZog?=
 =?us-ascii?Q?ZaxqXO1O7P5ZnWbccvv+v6Te+MOlbP5EobuCPhrzyNzV1GOL8SgnN2Ord83v?=
 =?us-ascii?Q?1chDu7fO4DVv9aRHyNzyAD4oK/KxFcx1Sb2yD9re/ziD1ivjQh1E+FPsIgGM?=
 =?us-ascii?Q?MtPOQB37gCm76aaowRBPUhMo30SkIMI7os2cPGcrtR77V9Clo7lndALxgqDB?=
 =?us-ascii?Q?4v9hFEuJX7aTb5FF8vKUURp53Lrj/bicg5p7GQXscADlOLsotpuXZ6Qkn+ts?=
 =?us-ascii?Q?PkbFHByJyoe9ProO0po/xyCtmqlmMdXi9j5LFlzP2evoe6pumKmzvrvEdxvc?=
 =?us-ascii?Q?mr5VfCAoByJrgPv0CuBrri4iP9FAH6BdEUOPWm8ozXNwBKG3F72OYQtaQZxr?=
 =?us-ascii?Q?riv+DfNnO2UIwe2z68b4wXS+nt7I7zsVU1W/nnGToBhNcYFLweZC2p+SB2+s?=
 =?us-ascii?Q?wLPgqeDQX6B89dtWCkt4r7tO5fKaksgkpCziMtE16cEiD3a/yxevBBVdHj+y?=
 =?us-ascii?Q?FtpxL56cZrRUibfW9dAlGs5RvyGqk8W0AbEwouJGithdLVLqs1hsOBPakv3b?=
 =?us-ascii?Q?umxiOM/y6gXTQ/OG05BVpRAu7yv/60bsX+PGtmXKVFgunuRVSsQcCLgtqg8Y?=
 =?us-ascii?Q?ZDyqQ+a4VFElCccoR8LGa7U9hxee84FkcZMG9ljdtftV8EcJQLxIWv7jnvqh?=
 =?us-ascii?Q?dMtfnDrwcmuTGdWWtn7zszt/8WWUnYSKI7lpZ1ezYb8SNY8N55QfZb15CJNa?=
 =?us-ascii?Q?kSAORW4eoPRDaG+zZKyMRC1w4+cIqF1WWnAqiqn4Pg64O5h3aEq4B4957vk9?=
 =?us-ascii?Q?XeIkfRQtjNBo5r/qelwJqY0UNxezHu/nptQAPmzBKrlz0A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f443c0cd-1003-42ba-0767-08d8f07a4acc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 17:12:10.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJsO3AfPLBsijdxcFd8vaumI4kOsUWogSIDwMZVhhLAXyXXt1vHkQyVf/IzhPVOg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 12:08:31PM -0500, Bjorn Helgaas wrote:

> Leon has implemented a ton of variations, but I don't think having all
> the files in the PF directory was one of them.

If you promise this is the last of this bike painting adventure then
let's do it.

Jason
