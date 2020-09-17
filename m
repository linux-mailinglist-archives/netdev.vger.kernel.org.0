Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2526E93D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgIQXFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:05:00 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9060 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQXE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:04:59 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f63eb420000>; Thu, 17 Sep 2020 16:03:30 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 23:04:45 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 23:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1k8tG/kyqKew5mixbH4lbQVkudU0Q5ABmzyd6NUagxgzqld+ZfTTwERM4vJ5S529qqK0yR7pHPy8KjuPhdDBJt2pCpEFHDLMaeMts2xeWm2XUj99zLxZ+4sn49IBclPc1IIM81+RAspu+WDGtrt6mvBdvZ1XsWEQReoN3pwS/GzAclEsk7pNUIYfdn/AuKpuppKiwNg11xCf4Uj/tqzCMiFE2oMzfwGldsD3PaAHqqB0QlYEpPK3sp0wLrUILAT2D9TeYGo1qz1CLC+bX+DsEJPq4Fnc5eRqEBxZG4L4mCZJHu+l6pjg8EAJcqvQwKmxgm30R2x77Rd7dIKR86WXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hntQdeNdghEVtMQ/SMW1wLDTfUub0icxFPmXSSngvbQ=;
 b=GPSodovExiYr3HALjPYYw7Wad9WkxY1HjTNAsc7/nqZvHazcVU9gC+SgotguLB/PVD/xsRIxL0F2E/BS0SJMHX4xkhy6SmizTsJU2yhN3WW0ZM+HpATN9r6iYAc6PTxm9ReRo+wv4p/xdWAEYv/wT2KBOqw30kp+hEkgLo04XVOiqhCSp7OTkVSFfB1ufU9w0Tmzt7gQETmW1cj6yBuoezzu1f95jcQqmkwQqzEr2kJTRnsRtbRTwRcGNoBBwzM45hG2Pdaq7fAv3IffkEwwHOFc5pTk3qGq/bJNCTkQ3bu5IB5fORyU7wUbdEtxEeIeLoLimxcnZuLw3CpE4MtdsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.19; Thu, 17 Sep
 2020 23:04:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 23:04:44 +0000
Date:   Thu, 17 Sep 2020 20:04:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Achiad Shochat <achiad@mellanox.com>,
        Adit Ranadive <aditr@vmware.com>,
        Aharon Landau <aharonl@mellanox.com>,
        Ariel Elior <aelior@marvell.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        "Michael Guralnik" <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        "Somnath Kotur" <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: Re: [PATCH rdma-next v2 0/3] Fix in-kernel active_speed type
Message-ID: <20200917230442.GZ3699@nvidia.com>
References: <20200917090223.1018224-1-leon@kernel.org>
 <20200917114154.GH3699@nvidia.com> <20200917163520.GH869610@unreal>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200917163520.GH869610@unreal>
X-ClientProxiedBy: BL0PR0102CA0045.prod.exchangelabs.com
 (2603:10b6:208:25::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0045.prod.exchangelabs.com (2603:10b6:208:25::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Thu, 17 Sep 2020 23:04:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kJ2xG-000nMf-Ll; Thu, 17 Sep 2020 20:04:42 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e13752a9-8446-44c6-4d5c-08d85b5e10c2
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB281010195925DF08DD514AE0C23E0@DM6PR12MB2810.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiHB2pE9nRy0J8l9M11PXefycERqga5+aUww8x2BnhTL6j2VfV87BF1Gw0N3BKvCViDKGqW4uRMOB2Jw0PeJkYiFtE34H4fhCnAxpQnUiahc4SeCHXXMteecSmj2QEfUhl/h3HHw/15xlxXHjiwcNpZMoMF4FtEchBTVArU4AflbONjI8DRRP6oDypMGcBsCeIx7K3I3CjIhYtm94DZGNrs4izUniM6bRU/IG1AY5Z0sRDVZ3G1TDNKkIENhAwwOQPmkfbB8ysZ7kWeHbQiGjg++kidRbURXgtNHnttS2ogCjlHClHAPKGcgnPyQ4wi6HJiGBGFsqGDR9ScJrdpauigjHikZhzbAPvt0pKi3fI2xWedaf5vUtQn6pXod4KeOKaO3jXHDD1FYJpoqG7iYhDsXJ4T3yN4R212yDPg1chrpMJPjFLGgAK0Q9HMD0iJus+q3DDRTDolxaJfrBOhE0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(66476007)(66556008)(66946007)(86362001)(426003)(33656002)(5660300002)(1076003)(54906003)(83380400001)(6916009)(4326008)(9786002)(966005)(8936002)(2616005)(2906002)(36756003)(7416002)(9746002)(26005)(316002)(186003)(478600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +qak85CoE5PGQMCitPAnsoi4k6kNa8RE4iAjlkqFy1dVS4YTi8o25r+k2H/EqR6UfQzrWDU1dgwA7c3NJtKvwgkEWBW7mg9bUp+2/IZ7dDqfH0JkNHO9DIqFx33Jm6ntcVZCNuJUj1QBUzKqllxe84lzExy1QPnYYg1Uw8tQYIqObp8huQdXiNEoLQHJNQY/eiGfcT7XQtMzL1/5OZMzBxpSGbuX9sppWGhWrP/VdHxHyHUs5JE7SKXvPZuh5KZQMFjXKrMGO3M6fKJTNIIXljF+E/iHZpXFgbvO9mL75OtjjwLJcGBrnrYWK+3SywlUIBTeJZI1aWLu2LI5S4ZxKNtPb8Wtm599r1s5axQrzQWow0/crbJhooGLCgubwzeYA12nCvlAT1VaAoBXQIxpSfZzd1+4fu/RqGNqWfCjAF6pX4nBfuCdhUmiXs5/cS1JU9BQhjuCb5mU7GvrXgQ01MISwi4iBcqkbbmKwipsK8hjBmDUP+DE68IWDBYOrytf7UUj5nVmGHnSvsjReQUpOh+wNCoRkq7MG8jHbwQbtofKKqoyfyHZ3u/57Et/8AsToF5raPrAVJYhIURuezpnzVzChYhuB1mILAAnBwW26Hf1CSZVRX1OT4mfER6adXBJ6zHmPrQEDvoExAez1QtBJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e13752a9-8446-44c6-4d5c-08d85b5e10c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 23:04:44.4654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAsSug7PTRx6kORPGK1MzFVlyL1TuxQzX3kKRVx+YTtQP7igvv1TbKcCj93juIZG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2810
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600383810; bh=hntQdeNdghEVtMQ/SMW1wLDTfUub0icxFPmXSSngvbQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Date:From:To:CC:Subject:Message-ID:
         References:Content-Type:Content-Disposition:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=fTupINdea5asHgDX3OEiRSjmg6syP+L4Jm2MOy2KroOxstxCZNG/vL6AgPBtiTmIV
         KwSpb5qqOdMUXUZQDcv2lcRdvHR9vRtZH51tzDuyW7esvZK+h8Q1EbIm7WFkybyGRX
         LXGsGj7tIaYtl8l7+HmP6fqj8dSFjUtfLGEo4dpygDn2aPw2Nj7Ar99jH8b6pig/n2
         mrubXEDnBYJyK9Ujps6IXqHIOfXiI/h8xv4wCOVO8ueQmR2JJqv9zYsetXyaZc0qL9
         ZW9nlAZFbYQ3hn0zYv0/9Zr/vPpmAEobiuf3a6zp7cBFAd3P50Voohq4Xgd9f3vonq
         afrdNre48J0SA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 07:35:20PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 17, 2020 at 08:41:54AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 17, 2020 at 12:02:20PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Changelog:
> > > v2:
> > >  * Changed WARN_ON casting to be saturated value instead while returning active_speed
> > >    to the user.
> > > v1: https://lore.kernel.org/linux-rdma/20200902074503.743310-1-leon@kernel.org
> > >  * Changed patch #1 to fix memory corruption to help with bisect. No
> > >    change in series, because the added code is changed anyway in patch
> > >    #3.
> > > v0:
> > >  * https://lore.kernel.org/linux-rdma/20200824105826.1093613-1-leon@kernel.org
> > >
> > >
> > > IBTA declares speed as 16 bits, but kernel stores it in u8. This series
> > > fixes in-kernel declaration while keeping external interface intact.
> > >
> > > Thanks
> > >
> > > Aharon Landau (3):
> > >   net/mlx5: Refactor query port speed functions
> > >   RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
> > >   RDMA: Fix link active_speed size
> >
> > Look OK, can you update the shared branch?
> 
> I pushed first two patches to mlx5-next branch:
> 
> e27014bdb47e RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
> 639bf4415cad net/mlx5: Refactor query port speed functions

Applied to for-next, thanks

Jason
