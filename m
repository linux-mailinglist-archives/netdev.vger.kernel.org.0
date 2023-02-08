Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA0C68F2E9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjBHQNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjBHQNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:13:06 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2086.outbound.protection.outlook.com [40.107.102.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACCD4A1CA;
        Wed,  8 Feb 2023 08:13:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lqyp9WasZMd4yTlldteqAhxAwe0jUVcCMDYnZqnCfl/tB202MYKVYCSVc41ZZYxp13f4Kt8JSSPziNDo0pXXAjDzYOZdgIZJoW00ivhApwR3BaIBxg5Vrz7r4T8hsaxoW+YPeYMCVO/xpdOXmszbEudDdvIqY9renQHX2s6p6/rfQRQ1+nWaWlJts6BI2bhJEVQFbA9x/A3HFS+8oxX+8yXunvL1VjQO810dBNXXcvAzfjiSILeXzc0NkaksrUqMnrqazkoq/vUAgvMPwkEC5GoWoDgdLKqr2g01+GSwdhYQz9zMMlmP+rgVcUPMx1Ws28OV8kZD6xtdutP0c/OQoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=reYj7qWLcR6bURB2gCK8XoKskeXHgClp7LJpHaMLoFw=;
 b=dPyvdYaTmVmhF2skb+Pa5rxA7rcB9gkSzq8iWaNMEqM45wQJR9R/zfPatGSUH8lv239pSGRqcuJvqzy9ANgXWLq7UIJuJqxjNhZSHDkPY6RhUb5IzEhzyBc4WuWNc38tofKvAFulZTnRL0e8+7idmlMhMg/Rzh9tHNTo1ws7WzMByqknAUBL8dZhQKCrJf/nfP6so9ef7J1xksuUO2HAB4fcG099Gp1XLrzPg4k4aPYgeSkDen1qbIHpIhRVChZ/8VU7IvQ7MwQCYninxe0JzIoz4Sn9uIYlBd8Nt7zZzbXTZIlEoCIK3upei3677yTs/rkbOFoWwPsTBKx6FzYuIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=reYj7qWLcR6bURB2gCK8XoKskeXHgClp7LJpHaMLoFw=;
 b=ufg6wiN4mbbfINQbHx58AMKGCVosgN5UB1buIcbVYARdGXoI/4sepVNpV5duDFXNi5I5vDJgpJf+y9YC0PdvfYEbpXcMVpFtzGiG5GLnFOTNSzDAgbvkrGW5wfV4lvDBjYQHnLtz4Xw5gaCWJyKj+gEA10P6iYbEEdWfZAX6QmPO+EBup971O/b3wdEckXJq87j3b/asSKKZrztpfy57k9pqBZ6QOO4DwGtSSA/lsHSX9COJhY0l00wNn35vzqXXWmsVDyVqQyHI39kwAj7gP45FevG9aY5ctr/m8v//QT/01PPJziJ7Fm6OQPPZEI7LZLqG+cab/be29SYwPHIVsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4933.namprd12.prod.outlook.com (2603:10b6:a03:1d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 16:13:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 16:13:02 +0000
Date:   Wed, 8 Feb 2023 12:13:00 -0400
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
Message-ID: <Y+PKDOyUeU/GwA3W@nvidia.com>
References: <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
 <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
 <Y92kaqJtum3ImPo0@nvidia.com>
 <20230203174531.5e3d9446@kernel.org>
 <Y+EVsObwG4MDzeRN@nvidia.com>
 <20230206163841.0c653ced@kernel.org>
 <Y+KsG1zLabXexB2k@nvidia.com>
 <20230207140330.0bbb92c3@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207140330.0bbb92c3@kernel.org>
X-ClientProxiedBy: YT4PR01CA0284.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4933:EE_
X-MS-Office365-Filtering-Correlation-Id: c75f91d4-2e75-49a2-38e1-08db09ef5a85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Qyz//b/mK4LXpOXYb7jISpY7e8JlhNPT4eQ1cuSRjd03fyC3wDVcpX4YeRKAKo8th70X2Z7T7rt/nTJmX4C6UH7bWoC66YCrOkV2935KWck+rJyq6U/gbc7bQs5wzNKyYGGP9bZYTz3m4JJKsjB3Y5zi14tC+wR8JOJfajmbfLpvXeepT2qIMPkT7gAR/QDha8UtC4niuuWSEplFch0BTMU9Y97nOH6eW6pIkUxx0NF8P5+GUMx7Wraub2MaEvyBC8Lg7sC5NYiY+ZPv15qgHZdyBhWvSgeEhOpn6TuiFDcmhryLVP8rdqq9sQ/r9EOqXLdjit0k1h8S9z0Fq3EN0gOkioOBJ91Hg+06HXcYKLz5eQ1NMgIuuDVNpHhZecLgXkDGrXpZVgekv50XSPOgT0j2YbxEptMCZUqry5OFGcgVU7sfSKVOywgkvXv/izywZqyvGiQP3Zbuv7USp0VlxXmSydGyA0dcK4xItbWh4Sz4yDGOuXd44XSY5QimfvMucVCLSfe7HsnITBjEE/rn6Xdm7s91nPq1vwAk+t/EcvICVE+p8hEGOee6iZpTBInPX8Qyra/aouvA/SM3rvh6WOaHuyJxEaYbGH9Cv1UTRRllFjU2s2AYgtE6oHXexa//quxxN7+UzkzGKejmJf6Ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199018)(5660300002)(36756003)(2906002)(83380400001)(2616005)(38100700002)(8676002)(4326008)(66946007)(54906003)(6916009)(66476007)(8936002)(66556008)(41300700001)(6512007)(186003)(6506007)(26005)(316002)(86362001)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEJtmlIfaFusd5YytLxSDjdgrTcjdp/4ru5xag/o+RO/5btFwkE7VTizx2hO?=
 =?us-ascii?Q?zlc8YXHajSuIc3qiyvhp47zsfPle14Yik9Gt3sS0wA0MchaBA7N2b0D3BhBf?=
 =?us-ascii?Q?0L3qp6HJD6EEhQVSNVGoE2m89twTgRp/yCZr/oEHIwTLQoPq7tP+l7BDoapl?=
 =?us-ascii?Q?2nGVLVEeBh51i/49TAUKo1tydpcm0wDGTMAUtenyiKNFhqUylVQvaY/M7RvS?=
 =?us-ascii?Q?A37mELyNSafn4HRjjHjWsvM5Jc5P/EgHAeIPNtP9oe6WJrTEIkquBvTEpt6D?=
 =?us-ascii?Q?zSd2PHVXjMQY9Jp6fJUYSMwtW5V3GpBNs98M51RIS21dDm3zN/uex5pEIgnU?=
 =?us-ascii?Q?rm27IAg+aw21QAZRQJumaNWRbcEOfpQO8SRAURQaqR05kiNToE4LBqgqMgZz?=
 =?us-ascii?Q?9Osshgb5u7x6hpyJxtqEA+ERarUvrLjtThnOJfZHgDK9q0UsHiJTk0yY/tbw?=
 =?us-ascii?Q?bVqQFnvVchViO0s0PJYLQRvJXA1G4ubr4iQ44Zi/STln5a/kId4L9rvIJ30Q?=
 =?us-ascii?Q?GxjLxELuo6/ELrYxU+xCtesLO2rwWXN6hXI8ogkR0i8ZTbgw/Mjb5sTwhLCV?=
 =?us-ascii?Q?PvIzSmCj6XpEd3e+uxFVTxPc7+klJnuaOfzjX5+ZUNgHUfbuNjJhV+Fon+Fx?=
 =?us-ascii?Q?H7gD2LW5rBE2n+IOiy7RgctIV64G6Hgncx2CHi0G/mG4qSzT5+iEcmKvf3qG?=
 =?us-ascii?Q?pWShVG0FfBXUAnD5JrlRSqCVNDPM7T1DuboabfXLhxPeCvQBAKn8a0KJiJsx?=
 =?us-ascii?Q?+tA+YtlI8iYBSDEyv9fSH8UiUu0xYHIY0VVMD6RipbA9ROG39VIHZt14VJ5s?=
 =?us-ascii?Q?PhTWfd3qN5gbP166BmQ0NxLZA6DWWq59Wsw6yHMSYhceWT46JXKgOfTX9Yrx?=
 =?us-ascii?Q?MRAqSh9LGe1Bf2WS7Hlo2mmdKFbm0WLoqlOsNiE8CTNnMErEp6jG5iK7v1GK?=
 =?us-ascii?Q?+rh8EoYll5W+NubyJS3vk3b2ezu16tPiXs4MqEpwNovCZsNXblPJ0LGvi6zk?=
 =?us-ascii?Q?jn2LukMgKSc8Qyti7GgUBS/lfiBovv9J4grqnBh1vRJ3iLwFTdZYonFnvcsb?=
 =?us-ascii?Q?Cbz0937hbe196shU8TMMGa3moRwDrZ+kzckMFQix0DY7fJu9Q+QzTIwPHZyv?=
 =?us-ascii?Q?UgI2Dn9mxunz3u71wqAY8QkLl5h+mAA5p3OIwDZVadB6EDNFc5ACXdjR064C?=
 =?us-ascii?Q?5khVwP9Lpx25/Htq5O0UQHArucXvhBvkHcvfMSvIXegTWSc7pHkC8XmWLgsS?=
 =?us-ascii?Q?bicYfVPg/KeF3bIW7cR4dB+/rhXxpW16ds91kpYvegW2xkul9V6rEW2jJhRy?=
 =?us-ascii?Q?VvAZTW5AzvmCztyw08QhapD91gWZHfo3dUphzc/orX8HXz+FjLFDLZZJP0RG?=
 =?us-ascii?Q?GGK7t4EqaZ9cd7KWALwEOndJJgj9d4vhP9AcfNXFo0TdQqY0TUUQ1Zi/XkNm?=
 =?us-ascii?Q?4EM9cXHbDIErhwHKJqKAR3//edT/18Xq+qRzXGcQyUT+n07KIPzoay41+bQ6?=
 =?us-ascii?Q?u+cpxButaOfFrt1wNyLCzMtUJmQ2dWm7h0JxqT2VD9Pn71vLR9IR4IuZAtqg?=
 =?us-ascii?Q?nDUDsRepdjb5z3n//N95TRIYyB9ZvFG9ODhIGSjX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75f91d4-2e75-49a2-38e1-08db09ef5a85
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 16:13:02.5145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VulIlytQtnmOmh21Li5MLxPjCHC9pcg3boO1ktAnrUcG1VrOTSpaGEkL4wMEFJuY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4933
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 02:03:30PM -0800, Jakub Kicinski wrote:
> > In the end the fight was ideological around what is open enough to be
> > inside Linux because the GPU devices were skirting around something of
> > a grey area in the project's philosophy on how much open user space is
> > actually required.
> 
> Right, I see that as very similar to our situation.

Er, not at all. As I've explained many times now RDMA is well aligned
with mainstream Linux ideology on code openness.

> > > Good fences make good neighbors so I'd like to build a fence and
> > > avoid having to discuss this over and over.  
> > 
> > I also would like to not discuss this :)
> 
> Well, then... Suggest a delineation or a way forward if you don't like
> mine. The circular conversation + RDMA gets its way has to end sooner
> or later.

I can't accept yours because it means RDMA stops existing. So we must
continue with what has been done for the last 15 years - RDMA
(selectively) mirrors the IP and everything running at or below the IP
header level.

> > An open source kernel implementation of a private standard for HW that
> > only one company can purchase that is only usable with a proprietary
> > userspace. Not exactly what I'd like to see.
> 
> You switched your argument 180 degrees.
> 
> Fist you said:
> 
>   What you posted about your goals for netdev is pretty consistent with
>   the typical approach from a hyperscaler purchasing department: Make it
>   all the same. Grind the competing vendors on price.
> 
> So "Make it all the same". Now you're saying hyperscalers have their
> own standards.

What do you mean? "make it all the same" can be done with private or
open standards?

> > Ah, I stumble across stuff from time to time - KVM and related has
> > some interesting things. Especially with this new confidential compute
> > stuff. AMD just tried to get something into their mainline iommu
> > driver to support their out of tree kernel, for instance.
> > 
> > People try to bend the rules all the time.
> 
> AMD is a vendor, tho, you said "trend of large cloud operators pushing
> things into the kernel". I was curious to hear the hyperscaler example
> 'cause I'd like to be vigilant.

I'm looking at it from the perspective of who owns, operates and
monetizes the propritary close source kernel fork. It is not AMD.

AMD/Intel/ARM provided open patches to a hyperscaler(s) for their CC
solutions that haven't been merged yet. The hyperscaler is the one
that forked Linux into closed source, integrated them and is operating
the closed solution.

That the vendor pushes little parts of the hyperscaler solution to the
kernel & ecosystem in a trickle doesn't make the sad state of affairs
exclusively the vendors fault, even if their name is on the patches,
IMHO.

> > The ipsec patches here have almost 0 impact on netdev because it is a
> > tiny steering engine configuration. I'd have more sympathy to the
> > argument if it was consuming a huge API surface to do this.
> 
> The existence of the full IPsec offload in its entirety is questionable.
> We let the earlier patches in trusting that you'll deliver the
> forwarding support. We're calling "stop" here because when the patches
> from this PR were posted to the list we learned for the first time
> that the forwarding is perhaps less real than expected.

ipsec offload works within netdev for non switch use cases fine. I
would think that alone is enough to be OK for netdev.

I have no idea how you are jumping to some conclusion that since the
RDMA team made their patches it somehow has anything to do with the
work Leon and the netdev team will deliver in future?

> > > The simplest way forward would be to commit to when mlx5 will
> > > support redirects to xfrm tunnel via tc...  
> > 
> > He needs to fix the bugs he created and found first :)
> > 
> > As far as I'm concerned TC will stay on his list until it is done.
> 
> This is what I get for trusting a vendor :/
> 
> If you can't make a commitment my strong recommendation is for this code
> to not be accepted upstream until TC patches emerge.

This is the strongest commitment I am allowed to make in public.

I honestly have no idea why you are so fixated on TC, or what it has
to do with RDMA.

Hasn't our netdev team done enough work on TC stuff to earn some
faith that we do actually care about TC as part of our portfolio?

Jason
