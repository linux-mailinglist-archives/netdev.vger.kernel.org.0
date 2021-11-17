Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43882454C6F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239617AbhKQRuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:50:44 -0500
Received: from mail-sn1anam02on2086.outbound.protection.outlook.com ([40.107.96.86]:27973
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239622AbhKQRul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 12:50:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILHoj/Kum0U1K8MneqCV6G5NatWdY/l4Bvm6vx0wen23tzrInDEse7NfYuXcARVEHElCwMbq2v/ulYyuxjcmH9zSPxVj8LWf0KqySu06NFx7oZjxh14sNNoQZmMqzn/cw/f7gD1HBSC6UxFMvJl7kS8FLZ1GCkwmdvq3AFm9VC9JCvy3Z9SS8X4n9YhRch5h3XgbLEENA3mGgsDbudWX8MVC/HG0F4fkT0Cq+iEHRB9N3ozPb+wrbKIzVITCHI+xKVe2SR5Gjg9r/LPit2W2cMLFh4FMveYoNLEl82HYInMC03GFpHGPZyl7RT+6f9kuT18eEPnPccqRp/WvEWzTmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpAsVs1o9GKBM4YD8jiWLWx282UHCfyvkjV/vwWdup8=;
 b=HczpS2kDVCsdMQZZn3/Jrt+HS6Fo+FsO6bzC0ByphVRwEs5Jn2bKtlxsh7oUuRHIyZpBaRUczu8y4KOr8Z0pIQQ+PRYwjNzeTI7hY7F9JPLG8PMlRQHz4ZZLY84Uom1aLis5/mUAWAqxoiScmE4808r43eMUToKht4Ndkwmxwk9mSkpwJDSE9rYvRwnnrdKyC+zA2/D4Z8TCosO9NP6roL+zheFgQcI5SM7NPkPxD8K2Tfbi49c1nbeTnHjSTVP3riAEtpXXtOB4sEYleJOTfV33iQXvekhAPIVG8Ps/7RGIkmeTo7suMFTO0dfcRG7MhSceOnEQ66V0lFZrtTJnZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpAsVs1o9GKBM4YD8jiWLWx282UHCfyvkjV/vwWdup8=;
 b=VAI+tVnd/4THm5Fq0+fvemmIhJ1heod/+GMX7mqrznQQQJ7F63ycWL8To/CQ5Ai0iEyfbzf1+gOBT5ZUz/F0SPncerlBaYz3DEgZxvvO8A59BBeTCI7NC/JJeWB5/avkzeQQPDIwHK392C4IF5yW8nWU3Bje/wfSPR6TPX4U0H7xbfGJOy8wZ3P+3SfRk6lhRQQe5Qn1m1myFJkXBnswZJrbdD33wK+4FSf7XgJEnax1PFqWfoVxe2Oeb3P1988hxPRY8Bv6eFRviK4qcRiD4nmHnEe1yjvJyZxsBaQw76uxtPU1a9+V35Rhx34PHZ0+zqLkzpAGiGMywVrARju/mA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5301.namprd12.prod.outlook.com (2603:10b6:208:31f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 17:47:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 17:47:40 +0000
Date:   Wed, 17 Nov 2021 13:47:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: vfio migration discussions (was: [PATCH V2 mlx5-next 00/14] Add
 mlx5 live migration driver)
Message-ID: <20211117174738.GL2105516@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <87mtm2loml.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtm2loml.fsf@redhat.com>
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 17 Nov 2021 17:47:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mnP22-00BVMa-H3; Wed, 17 Nov 2021 13:47:38 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe1fc7e5-0812-4ee5-f172-08d9a9f2596c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5301:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53010EEB95E357D5EFEE7AD8C29A9@BL1PR12MB5301.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JEvmjv9qDxQO2Kln6PaHC0IrY56fE8+62PNftLTtkZGERR4EB+Jr0hed6BLLiF5V/Yl29ZClMT47X3H/wLiPkXph1eCWvs9dtdklk1l7xCtyNCbJOQ8c8cIdVHOVp+TaNoiq4ynwSGxV7IH6YbZ7+kW/iDOBGyGEhIu5KTfMhlvs4+37iJJWF2kDeTrgr5MhtQbEc/kWtBERhqx8Yg4jpLh3VavS1wiIw4AH5G2lB/gC9to1v9M01V4na2tWYDXAf3gqW55TNtlOF4taHeNu/o/PSfFhh61gJEkCH2iSU6DtAqyPL2aLvlpWYq3639XxN1lZ91jc/Wdll0V86W/X2LpS3hDSnnpWifIcwVCyZcBSxLghcSlpptT2egQfnLcaAXaDMKLBz07Gj0uc2BTij/FS0MLIrzzcbCtoibHuRUneFbNpBzCilRwRqVdybnXPg8qLuuXvNHF+COqOsxHjcUiwmnctbwhsWk/s5zag2ZYr05QjjGBBnP8L2wqAJBF2Steip+5Pf7QwKKgCWn8k18QyH3tsRbJcei3IunsytLLiQDBGzZLABm6UzSLYflok0mMSV7d6ltMtN7VslA1Pa6u6ZlwAILUckc8y9E7fuabb4oGGMzh49EOF/bA411NNM/0mXGaGxTTr8pmwv8J9sYCamZulxy00XytuJL8IFCHfQt80dok4cStcTvJnf92Hiq2Tny4Z5MlS6VTyo9o9xeCa258rhUh3VBOWkoZFlp4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(5660300002)(508600001)(966005)(4001150100001)(1076003)(38100700002)(8936002)(26005)(66476007)(66556008)(83380400001)(316002)(4326008)(9786002)(86362001)(2906002)(9746002)(6916009)(186003)(426003)(2616005)(66946007)(33656002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+dhixhhHQFA25cuZaEysw424rgSTeiHb7ypr7nynUxhv3e1n2M30X5vmAhwd?=
 =?us-ascii?Q?AZKDMxHfbyP8Q4DXISTQSFTvBmumaK1W9ZgE5GR2ZinpO/ebZkfHmdqME+dS?=
 =?us-ascii?Q?Nusq91AOvNbS64N/b5FFpHhGdAaHyc7FZcJ9Zo8mHjSgVL2h+B37xtPhfpf5?=
 =?us-ascii?Q?PBaJAdBsCmWGVRVGscc5bMHWYDhCW3nmnKVfPmgaCUAkZfZ0BFGfnWx7eBz7?=
 =?us-ascii?Q?S3I48jghNyb6rAIg0AOTj2UVcc2C0ALdddkuXvuX78Ep2v1xxGk+hCVpk3n4?=
 =?us-ascii?Q?x1koyQ9FyG2X6+PZqdZNgG0ApkXO6BLSXmEM64rec24Fm2A0Os80bCACZzJT?=
 =?us-ascii?Q?6dRIpyEbmtKxnMT7SrI0p0lLgymW/LFfIdEwhSB2H1luk5mlN0U+UDxjp2Lp?=
 =?us-ascii?Q?TAwjvdESMW2sKzrf8DxaoVQA6vccXlfjrXlRbiKuz2QXT4+si/XDpjTgjwJq?=
 =?us-ascii?Q?vHp4ENtIXGi520B3JaW8Yz44jmUAFySUrGRPWeTczfh/INBZcfI6ufVJtKve?=
 =?us-ascii?Q?yLExRxj5AdLH0AVVLP9yPOvTmXpdm/BkpIf3QApZS2Oj7EIY0sCNlYqCKAcV?=
 =?us-ascii?Q?yCxkigDzcwH0hc/Pf5dcqsfaAdVWDb1EomFyl8AIAo4ezq4TPgT33aN1+/h+?=
 =?us-ascii?Q?MK+gEWga11znyQ+0+7vqRijeJPgdM62yRw74XnLVMUU31ccAtZ3ilv1IpmcH?=
 =?us-ascii?Q?jNHwrMz2VV8NISaMKPopW7DcKJgBFu+NL2ZRZSu3/oFBncNbDpiq9EIPSzq8?=
 =?us-ascii?Q?lnMIR1bar+bGn5CUGLDXLFTORiS9RxnrfoL4yhd6P+Iy/WDx3vjd02KSWt+A?=
 =?us-ascii?Q?UzQlUykGdHS9PytmKRkGEmEj5JPgnhC+BFchyvC6DZ+G4Jh1cof9hRNLkBC+?=
 =?us-ascii?Q?Kk5xOfX/UfdIIT+1RIAVUkEy2CCT4Yn8fns61tdpS0hEVQkKfRJgWbISBKly?=
 =?us-ascii?Q?mONouY40yXy66NmxSYnHnosY6ZE2GH1xaSzjDb8mVFTgK+u5+kCUGUuYN7Lx?=
 =?us-ascii?Q?jm59K8SvJw3DDtiSUOtbMFZGiOaa5cfBxhBTyrUY39hFlvr7Mt3heOisFVUi?=
 =?us-ascii?Q?36GE2ybcmV0t5acp3vzKt0mtHoRvJIFC8X6jo/ZEs3n4HRZ/Oj6ZgPCECpNg?=
 =?us-ascii?Q?X2hzliTLm/H+HOpMAHhTjS/AsLmrZ+hNjeNaiHiF63bMIlXvu5lQPy25rNTb?=
 =?us-ascii?Q?7CRzOg2Et/rdVjtfXcc/8blLYiL0T5R7g6iqfoU66+JWIyd17GvBl5jkIhV/?=
 =?us-ascii?Q?8OmqjgJNJKYJ/LHYVk5VZ2vZFUd1Eiw+pwxgWXI+rR8sQDAVqZ20Ez2hPBzV?=
 =?us-ascii?Q?hjnslz/mkaxhCvviqUW0Q8cpXEguVPgD/ZgZGoWqW90NNnm1f05LGQ3lIcr/?=
 =?us-ascii?Q?n3UUyFXF/UVUtDxE4GLTPortej8KQusfEUpzXqIOpGz7fCZ1fqgPy/eaFnpZ?=
 =?us-ascii?Q?qonuddIcu60LeRl+krv3Xu2HN0IrMbzJGPjPTt/4OikS6Oyg9pTni6w4njdz?=
 =?us-ascii?Q?0u5IhAF8/o2WLkqZ26Skin+HLLNkOG0x6VlV0ePFwVfqt60z4wy7AwXeYnUC?=
 =?us-ascii?Q?606QGPz5XqJJ5hNU98E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1fc7e5-0812-4ee5-f172-08d9a9f2596c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 17:47:39.8650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KurL9kEW8R9RurC1kAqVdhUa+aWIGqufomYTLp/i7EGpEl7j4Rk1NwZyX+P7O4mH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 05:42:58PM +0100, Cornelia Huck wrote:
> Ok, here's the contents (as of 2021-11-17 16:30 UTC) of the etherpad at
> https://etherpad.opendev.org/p/VFIOMigrationDiscussions -- in the hope
> of providing a better starting point for further discussion (I know that
> discussions are still ongoing in other parts of this thread; but
> frankly, I'm getting a headache trying to follow them, and I think it
> would be beneficial to concentrate on the fundamental questions
> first...)

In my mind several of these topics now have answers:

>       * Jason proposed a new NDMA (no-dma) state that seems to match the

NDMA solves the PRI problem too, and allows dirty tracking to be
iterative. So yes to adding to device_state vs implicit via !RUNNING

>     * No definition of what HW needs to preserve when RESUMING toggles
>     off - (eg today SET_IRQS must work, what else?).

Everything in the device controlled by other kernel subystems (IRQs,
MSI, PCI config space) must continue to work across !RUNNING and must
not be disturbed by the migration driver during RESUME.

So, clear yes that SET_IRQs during !RUNNING must be supported

>     * In general, what operations or accesses is the user restricted
>     from performing on the device while !RUNNING

Still a need on this other than the carve out for above. HNS won't
work without restrictions, for instance.

>     * PRI into the guest (guest user process SVA) has a sequencing
>     problem with RUNNING - can not migrate a vIOMMU in the middle of a
>     page fault, must stop and flush faults before stopping vCPUs

NDMA|RUNNING allows to suspend the vIOMMU

> The uAPI could benefit from some more detailed documentation
> (e.g. how to use it, what to do in edge cases, ...) outside of the
> header file.

We have an internal draft of this now

> Trying to use the mlx5 support currently on the list has unearthed
> some problems in QEMU <please summarize :)>

If the kernel does anything odd qemu does abort()

Performance is bad, Yishai sent a patch

Jason
