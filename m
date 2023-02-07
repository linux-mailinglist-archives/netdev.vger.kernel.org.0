Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F1468E185
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjBGTxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBGTxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:53:04 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12B6CA13;
        Tue,  7 Feb 2023 11:53:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYQ19oGmIBjVI7xPIpYM5BQew7P7zyKec/FjESvFPFdx2HrXis8SfpX74Rzl/Zo/AV68L/K1yJL8oGBgYbaYp+uT8XvH9K4wpLsYLuj4mpFAlK11IoaUSIWJJnStscZFDbMgrAD1mjQbpqC4yh/tVQvoMi8SMGh+BXjgJBmsUIlubglRHbru/XZMQP8sZ/lQ413QLgYYEuyLagMTvcrYaQ4TuF9B7RCY5mBNrLKVBri8/8/wnrMku0g6Y5MtYUysBi8O/0xVU2wy+JII3sMhR30LQ+3qu0TP6cVytaAKmMDFh5RKP0G8+n3H2hUUQvDMXSiGDLn8dWKAqruiP55pmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHYz/2ItAg4fS8cvSPT0tYXiJ4OOUcjkkvcTcs6DcnQ=;
 b=GlpmSTPIrFk3lq9kU/EFMz2DRrYE4kdMXPM4ycu/Ml/hldzVPGlaWU9WQcIkqPuHRbdbmFVsEpT6z/wcC69bw+3Fraf00cA2F1kGs5ot6SslakqLPtBXxkyN0fz9de3i2q8w9wzwDcl5NI8emHAMxJZ/GMUuKV7QH9TKuShd6BBJWcQvE1EeOkuhNIIpeRMcuRmo23qqK1T04xS0kdwHKX1rc3li8mxgSj8J0vVSEgSwGPC72LGlvhj9mY13fqHkJ36N0+PbBLrShb4GhcWz4RgZqy1pW+MJDZVsVCCtIdCImx3N575e0RStRoE7HSPV5/KetF6x9cA975y0utsgyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHYz/2ItAg4fS8cvSPT0tYXiJ4OOUcjkkvcTcs6DcnQ=;
 b=rsLPflcRDFwtvvv0pFamuiPgKQP1wNVETIpZDV1zDLvwILWZ4CYCFPffEXIQkHzkBJLLErt3d5cdN0hecGGEtnp4U3w4LSIvpWQn9wmEleTBugQkPfMutingJZ+YssPHYx0r90sVzQz5BWBj9yxqD57OtiieHRZf893yRg1tVJMnLWENUKAvdYIGTcCfIYT6ZZcCPVnNZkguKXQgBtJousmTh9n/4T+KAxpE3MDfpxpvaCcWCBo2cSwfpWAxrjIfUEp9GvTxtbBj+ATIQW7H5am0GkD1qpuePuNEqGEVmADA8Ed+B26WdvH7WpyKzhFVwf3yY37rI/B950Tg0frGGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 19:53:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Tue, 7 Feb 2023
 19:53:00 +0000
Date:   Tue, 7 Feb 2023 15:52:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y+KsG1zLabXexB2k@nvidia.com>
References: <20230202095453.68f850bc@kernel.org>
 <Y9v61gb3ADT9rsLn@unreal>
 <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
 <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
 <Y92kaqJtum3ImPo0@nvidia.com>
 <20230203174531.5e3d9446@kernel.org>
 <Y+EVsObwG4MDzeRN@nvidia.com>
 <20230206163841.0c653ced@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206163841.0c653ced@kernel.org>
X-ClientProxiedBy: BLAPR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:335::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4264:EE_
X-MS-Office365-Filtering-Correlation-Id: cb6e810e-59f1-49e9-5d73-08db0944ea88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSQGIJNWf18Xi4b5v4TlePeZ+RUdv+fOMi7C1mMfo4NJUr6N4p1p8nCtNB1teLMZZH+SW2BqrwJE5BJ+s/gDnjkgu+gZ6yT5TV5mnjRc5tAY3ZTsvc4SCqUP7JmtxiND683wY6e5svgyX/zAt6O/1j9fLW6yurtzxu6O9xaJq8M6PJFozNVNDA4h+vxkxE53EjMpIj4byJJcg8IFoyBrZ5NNZUBTGtcAA9NDiComFxpTT0DQjJrJPtNqRfEnv446B47UOq4bBkIwEF2UbIglRmf7ocu7Ulr8ldxBxCkSXqXTKNMmaPBxGNPkIC9IGnWvGh0t7vb7kIUxgOxWOsy6vU01C8aYEw5ahRCfKvGkDF4lG8XYBZa0Mn5idncdTbelrX522wfiPnys1/vpWawE42rvHAyGAyvOiNmT7zkcDhwn9oJMiyVskg+cPiUn7eGaPfe8cuGKJdRpXeQL79nu0bffayjHBEHERW8pl10R24RhCXbZSFrt2oG1xNYb/ULHncgMWDqLRXr1++qhseuKCEISipGkRed9NYuYQQKoVE/Sfknoz2z0cEWXUOfS1KEg7OtTAn9UjgICRuQ9eU9piQLuykKZL//Ns+Gazx7VCVwsA4pSWVbBP++wRQ7hFnj/mCCblvu5lLKPDTbmVy/b78M6KBeqGfghwf9f6G6iKews4OFthV9PaVghURt+U8L3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199018)(66899018)(83380400001)(38100700002)(8936002)(66476007)(41300700001)(66556008)(6916009)(4326008)(8676002)(2906002)(66946007)(6506007)(186003)(6512007)(26005)(2616005)(316002)(478600001)(54906003)(36756003)(6486002)(86362001)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IGpxZt10p7/hFbmO95cIDDEdQpAGwnaZPShvRsiDYQaX9F6bKXd3WHNz9g3e?=
 =?us-ascii?Q?QaToptvW1YuiKS7K1nqkEx/fiPqtJya9gKa5w0m2cULO+rTKV1gvJPVZisD/?=
 =?us-ascii?Q?i7Za4H8bWLGZDzl8JtF1zOvud82jpKFCjWA5jyc2/O+5X4s3rGoElW4eBWTq?=
 =?us-ascii?Q?l1PkWVmm+p4l1v7hMD3xg1QFc4F3h/irNlpM4K+4zlqOkTCtWDyY89G9/Ghj?=
 =?us-ascii?Q?VpYFKFS5cB3T6a+VHjhFMskUYCtnNyzUwxSZ0KxS+LNW1Sb9dzW9g4SVTlY3?=
 =?us-ascii?Q?cODJDRGruk9AFC35Z3WbnjvOc9DE/r1Xf0CvXwqj2AJjqJ+lJMOs5w40U40c?=
 =?us-ascii?Q?vPaEFU3PiAalNepux4v9DvgsWl5YncxO8/HsmCpn8erL7wKk/sFPiAlhDWdN?=
 =?us-ascii?Q?ZpI7k3OCo7LT5pDwtMPJsuarVH/34jTd5QJwF4vXUdvSX3vT8Dg8XtIVtoLJ?=
 =?us-ascii?Q?Sn6DL6X9mUEI5usZPcxYRUVBVrGqU145ncgk6ghKM3gn29AscgRruXDBddQc?=
 =?us-ascii?Q?daSfSoTOh7sMy9wN0x4ThYCxCxeSgXRKQg6CK2uubVlf/BKQV3dh1CfBJcxQ?=
 =?us-ascii?Q?VG0KICEDG8zmEgU2GPS/ghwgUzdxC4HYX9x8B/zc1/5F+DvvfyZiHcPFvUIv?=
 =?us-ascii?Q?mTrCaQqUYB8uoWuBLHCGt80ZC5NYc3z5/7hp7DWjcT1s7R//MO/naBpF+MYM?=
 =?us-ascii?Q?vctMBxU4GlfZsbF8bjm1sglqS2Rp/0SHD3RsjdDPdPDgfFx1mJ6xKBqZC1iM?=
 =?us-ascii?Q?6eCulXAvGq+eDfUdTQWQwBz+266GYeCIqp50g5l3lV69Xa5aLtUCnrIP9vP0?=
 =?us-ascii?Q?1aEt/98Qx4bcYh8MLowWGtz8qaa9QR54SkW9jmLN+pzQ8WnU27Vtac4i/oLf?=
 =?us-ascii?Q?euwIj4jZgtCVnqB0nHZlHPCn/W9vHE9WddvMST45Ifiq1mLDa3bgYqwbZIId?=
 =?us-ascii?Q?xPp6IzbNFlyx2OCpT2VIe5wCmeTHtZTlttYi80EOmOXGIwTJRkJWY/v5omBY?=
 =?us-ascii?Q?RJySSvmvf0ttyqlQ6HGC8zgf3nohQO0olHT4ZblnGppU6IlDweEuRHT0sN1E?=
 =?us-ascii?Q?o/P88AnH/oRAwEEGfppNRD8D4cXSsjMucl4AP7fKUmBkPV/i26TsrKDjqF6l?=
 =?us-ascii?Q?/YMpqli2+VxYCS9zlxswInxJATFT62O3Ks6f8G2/6n4bFrWfZBUZgAtYlQOH?=
 =?us-ascii?Q?a6Z04ifJ255m66FpLvOHKIJGJX8EgvrknMq+kilz+tnOZCByHXj3olsSkfIw?=
 =?us-ascii?Q?4fUwsBE7tDe4P+LwJmqpgfsyWyGhMsBtwiA1Z3br46j0QPWesekJPScI+iVG?=
 =?us-ascii?Q?+h+qdrlTNeENZ3jbqUVe+L4ONt+h0Uf5dXB8zglr5BRN+JIBnlKasGoPPkg2?=
 =?us-ascii?Q?KW0aHmMMJ5QuaZGS0myOzH8FolToQNAJJsNiZTNeHlCxjrlJxi/LfvUg2XtZ?=
 =?us-ascii?Q?JyH1OJuAC5qpC27xx/LJ7BXhzECDU2ziy8qDMNkxBuot89tzvqoilaOqAVrI?=
 =?us-ascii?Q?6VzWye/LZgLIhLDkacLFpM05iWIz9MVGO4T0IFOrw8e6Xl35bdSO+JhbpIDq?=
 =?us-ascii?Q?Rx3vAUvdljvpxkSGNFgfPSokyfiMJSG7Ro5EiZ6r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6e810e-59f1-49e9-5d73-08db0944ea88
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 19:53:00.2319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAYmo3kohGcgONJ1Eeo+HojZz6naaWw6h7Bq6eMV3PoO+M8ffyLCDQmGWNLYQ1cw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 04:38:41PM -0800, Jakub Kicinski wrote:
> On Mon, 6 Feb 2023 10:58:56 -0400 Jason Gunthorpe wrote:
> > On Fri, Feb 03, 2023 at 05:45:31PM -0800, Jakub Kicinski wrote:
> > > Perfectly irrelevant comparisons :/ How many times do I have to say
> > > that all I'm asking is that you stay away from us and our APIs?  
> > 
> > What I'm reacting to is your remarks that came across as trying to
> > saying that the particular netdev subystem approach to open-ness was
> > in fact the same as the larger Linux values on open source and
> > community.
> >
> > netdev is clearly more restrictive, so is DRM, and that's fine. But it
> > should stay in netdev and not be exported to the rest of the
> > kernel. Eg don't lock away APIs for what are really shared resources.
> 
> I think you're misrepresenting. The DRM example is pertinent.
> The DRM disagreement as I recall it was whether Dave gets to nack
> random drivers in misc/ which are implementing GPU-like functionality
> but do _not_ use DRM APIs.

That isn't what I was thinking about.

The DRM specialness is they are very demanding about having an open
user space. More so than most places in the kernel.

The misc/ argument was about drivers trying to avoid the strict DRM
open user space requirement. In the end Greg agreed that open
userspace was something he wanted for misc too.

DRM tried to use DMABUF as some kind of API wedge, but it didn't
really work out too well.

In the end the fight was ideological around what is open enough to be
inside Linux because the GPU devices were skirting around something of
a grey area in the project's philosophy on how much open user space is
actually required.

> Whether one subsystem can use another subsystem's API over maintainer's
> NACK has a pretty obvious answer.

I would say not, I've never seen this actually aside from netdev vs
rdma. If the APIs are being used wrong, sure, but not for ideological
reasons.

> Good fences make good neighbors so I'd like to build a fence and avoid
> having to discuss this over and over.

I also would like to not discuss this :)

> Everyone is familiar with the term "vendor lock-in". The principles
> I listed are hardly hyperscaler driven.

The hyperscalers brought it to a whole new level. Previously we'd see
industry consortium's try to hammer out some consolidation, now we
quite often see hyperscalers make their own private purchasing
standards and have vendors to use them. I have mixed feelings about
the ecosystem value of private label standardization, especially if
the standard itself is kept secret.

Then of course we see the private standards get quietly implemented in
Linux.

An open source kernel implementation of a private standard for HW that
only one company can purchase that is only usable with a proprietary
userspace. Not exactly what I'd like to see.

> > I'd say here things are more like "lets innovate!" "lets
> > differentiate!" "customers pay a premium for uniquess"
> 
> Which favors complex and hard-to-copy offloads, over
> iterating on incremental common sense improvements.

I wouldn't use such a broad brush, but sure sometimes that is a
direction. More often complex is due to lack of better ideas, nobody
actually wants it to be complex, that just makes it more expensive to
build and more likely to fail..

> FWIW the "sides of the purchasing table" phrasing brings to mind
> industry forums rather than open source communities... Whether Linux
> is turning into an industry forum, and what Joreen would have to say
> about that*.. discussion for another time.

Well, Linux is an industry forum for sure, and it varys how much power
it projects. DRM's principled stand has undoubtedly had a large
impact, for instance.

> > I don't like what I see as a dangerous
> > trend of large cloud operators pushing things into the kernel where
> > the gold standard userspace is kept as some internal proprietary
> > application.
> 
> Curious what you mean here.

Ah, I stumble across stuff from time to time - KVM and related has
some interesting things. Especially with this new confidential compute
stuff. AMD just tried to get something into their mainline iommu
driver to support their out of tree kernel, for instance.

People try to bend the rules all the time.

> > I'm interested in the Linux software - and maintaining the open source
> > ecosystem. I've spent almost my whole career in this kind of space.
> > 
> > So I feel much closer to what I see as Linus's perspective: Bring your
> > open drivers, bring your open userspace, everyone is welcome.
> 
> (*as long as they are on a side of the purchasing table) ?

Naw, "hobbyists" are welcome of course, but I get the feeling that is
getting rarer.

> > Port your essential argument over to the storage world - what would
> > you say if the MTD developers insisted that proprietary NVMe shouldn't
> > be allowed to use "their" block APIs in Linux?
> > 
> > Or the MD/DM developers said no RAID controller drivers were allowed
> > to use "their" block stack?
> > 
> > I think as an overall community we would loose more than we gain.
> > 
> > So, why in your mind is networking so different from storage?
> 
> Networking is about connecting devices. It requires standards,
> interoperability and backward compatibility.
> 
> I'm not an expert on storage but my understanding is that the
> standardization of the internals is limited and seen as unnecessary.
> So there is no real potential for open source implementations of
> disk FW. Movement of data from point (a) to point (b) is not interesting
> either so NVMe is perfectly fine. Developers innovate in filesystems 
> instead.
>
> In networking we have strong standards so you can (and do) write
> open source software all the way down to the PHYs (serdes is where
> things get quite tricky). At the same time movement of data from point
> a to point b is _the_ problem so we need the ability to innovate in
> the transport space.
> 
> Now we have strayed quite far from the initial problem under discussion,
> but you can't say "networking is just like storage" and not expect
> a tirade from a networking guy :-D 

Heh, well, I don't agree with your characterization - from an open
source perspective I wouldn't call any FW "uninteresting", and the
storage device SW internals are super interesting/complicated and full
of incredible innovation.

Even PHYs, at slow speeds, are mostly closed FW running in proprietary
DSPs. netdev has a line they want to innovate at the packet level, but
everything underneath is still basically closed/proprietary.

I think that is great for netdev, but moving the line one OSI level
higher doesn't suddenly create an open source problem either, IMHO.

> > > > You've made it very clear you don't like the RDMA technology, but you
> > > > have no right to try and use your position as a kernel maintainer to
> > > > try and kill it by refusing PRs to shared driver code.  
> > > 
> > > For the n-th time, not my intention. RDMA may be more open than NVMe.
> > > Do your thing. Just do it with your own APIs.  
> > 
> > The standards being implemented broadly require the use of the APIs -
> > particularly the shared IP address.
> 
> No point talking about IP addresses, that ship has sailed.
> I bet the size of both communities was also orders of magnitude
> smaller back then. Different conditions different outcomes.

So, like I said, IP comes with baggage. Where do you draw the line?
What facets of the IP are we allowed to mirror and what are not? How
are you making this seemingly arbitrary decision?

The ipsec patches here have almost 0 impact on netdev because it is a
tiny steering engine configuration. I'd have more sympathy to the
argument if it was consuming a huge API surface to do this.

> We don't support black-box transport offloads in netdev. I thought that
> it'd come across but maybe I should spell it out - just because you
> are welcome in Linux does not mean RDMA devices are welcome in netdev.

Which is why they are not in netdev :) Nobody doubts this.

> As much as we got distracted by our ideological differences over the
> course of this thread - the issue is that I believe we had an agreement
> which was not upheld.
>
> I thought we compromised that to make the full offload sensible in
> netdev world nVidia would implement forwarding to xfrm tunnels using 
> tc rules. You want to add a feature in netdev, it needs to be usable
> in a non-trivial way in netdev. Seems fair.

Yes, and it is on Leon's work list. Notice Leon didn't do this RDMA
IPSEC patches. This is a huge journey for us, there are lots of parts
and several people working on it.

I understood the agreement was that we would do it, not that it done
as the very next thing. Stephen also asked for stuff and Leon is
working on that too.

> The simplest way forward would be to commit to when mlx5 will support
> redirects to xfrm tunnel via tc...

He needs to fix the bugs he created and found first :)

As far as I'm concerned TC will stay on his list until it is done.

Jason
