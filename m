Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B92868A731
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 01:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjBDAS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 19:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjBDAS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 19:18:58 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005878A7FB;
        Fri,  3 Feb 2023 16:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaMUO6GyDjFJFjZzgKoe66gs34WJMGVup9/wh33q+HCPKjWjxccGkSvZNWOkXZy2uX3GsXUyn4PaIIx79NOrS1qUpCMDee8esbKeIQjCW6YQHm1fmsZcDKmaAHrTN28Y3oEMnWLBoH0kcqbG1YEQyNMzGGiPNAGFJoYO6Vkpb+pN7P1pk975cP3yvHhPPfMwdVWRYLp6mM1imtIsu1//U/fckzvhbTqS9x00tJEBviUL4+ixg3WM8j6v8MuEdpl8hhq/KXOjQKxJ8TtQtYCvf47rXIi5l9/l1eRd2XYUfLCXZrLd3ECmV8RnEgmxMB1vlcvSgIRrOuU66LaST8MgFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3cvz8kXd9qEIO5NZqfoWCb4P75Z6WUcw/LpXAPqLLA=;
 b=oW69aMt3jO4vU2LhvOybVSHlxVbVc3UhaUX6keylYx0eA+ZmfoEgOJnHAC1fESj8Y/X5ttPLulUxligBRisWIxvdcfs0L7TJCl4sHd2X1ynaFDyoh8NJ8Qhwfr6Jl7YWvlatnbgSBRPPKsiIL/VFDjCrDhd8SlFwiYKaD8OKrcEKBV1qDz3QDaDNjZ3DN31B4EAqm4+H7k/pto9Hn3CUas5UfFb7N5lM/eUXKr5LQUwqkly5v0kspiKQ+FFO6TM0zwYDXIgg6zeU0ZHgOIK5ZxoK+z3jW3YNDKModRD0cdAmANjauQrWJ5rdLIjtHVjgez7/N2AOh5yA720FEnMDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3cvz8kXd9qEIO5NZqfoWCb4P75Z6WUcw/LpXAPqLLA=;
 b=eUnI40rHEzYIflTC3Qa2w6iqEkMmyE7s2Fn9H6l2w3QPKWjUSPnPQzsTxRvK1pNwrdP0KojmIEZOG1i1yq0W9XvnH8y3jJk8iOZtHRuVe6JSZTDJBw5b+ZHD8wURpy8s4N04M/ipfLbPzowsvN5gocPZzexfdauFlKACxOK5ZhOESXuCVU/K9ogcowm4Wc8mXI8zQk/e4rj19x6iOpor/pSLXnQmL99WyPZopWEdkDQYns6IWt71Sb9zHX6DSbChhUtNVfugZqVGqmjhTk93fKaSx9skPTxxwvaCnPa9aMoyehasSj4oxKdA+hjjckCbAbjSJq8Axd/bcM9Fo5ZPXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7595.namprd12.prod.outlook.com (2603:10b6:610:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 00:18:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Sat, 4 Feb 2023
 00:18:51 +0000
Date:   Fri, 3 Feb 2023 20:18:50 -0400
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
Message-ID: <Y92kaqJtum3ImPo0@nvidia.com>
References: <20230202091312.578aeb03@kernel.org>
 <Y9vvcSHlR5PW7j6D@nvidia.com>
 <20230202092507.57698495@kernel.org>
 <Y9v2ZW3mahPBXbvg@nvidia.com>
 <20230202095453.68f850bc@kernel.org>
 <Y9v61gb3ADT9rsLn@unreal>
 <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
 <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230203131456.42c14edc@kernel.org>
X-ClientProxiedBy: MN2PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:208:fc::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: aba1045c-deca-410c-98ea-08db064564cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gajU11npY/kKYHpntPDfw+k5xtkKSQTStsbJum+T+MSQtWLsN7BzyJiDoPaiAwCumY+K5HhOu9octz5ipzErCoZf6t0jJu2SfxSlkUSJvPMwD2Lu6fHCdD9J3DXArSksQaZgV54bAxWEoKQes4op1Kq0Yt7sGIp+fZh+uxrMHtWKAaGRq+Pd0cZwumfVKb/vmz/ErfMQ2Cj4GzUSOxhD8Xg/7bTQ7xRvR8FVM9azCJO/vfKY5kSk8ht6Vf5KUyWgIDo2cv6/GZn95QQvUgHs+mQTc5Vkah3M0f88MIRTrFxW4+JlnSHfUcYd8aiXYI0k2KqdJbsdTAzeW+jWjYdhsszkvYqPssNiphxR8Nc4rjx6qDTPUgerTZBpt4nt6PDyzFVq+KIAJp/diumkMnmYBPRS0IYFaD09M6bnpSO3ceHe7adhc9PnotshqWkv1KGpB7FCARKtuIMOZo6YddMIyPz2SKSo3NlB7Wxs/AtsDEUIBWTmYwalU3xyvI6gbyeJ+MJ1r37sgAOYDKqGysmOwkL3fFoDlk0OxuHvlfPV38qlBXd0eRBNtIYbK4IF8q5yc63N0x9DUopBKTQs5kH71+wAaWcvL3Ys527TOb6fOBob0XbBFGI5sE+zjkDViFDjwLJkA+KDFqP2oOKmawWwE1qTKRh31vC9B95haY8vL06QtY8xWG0ZB7ZcZHlMkn9UHQ67DIuhxkRmheAhoNWUULou5ehjZhx03ylKHsE79oM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(2616005)(38100700002)(83380400001)(36756003)(26005)(6512007)(478600001)(6486002)(186003)(86362001)(6506007)(966005)(316002)(8676002)(54906003)(6916009)(66476007)(66899018)(66556008)(66946007)(4326008)(41300700001)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WldpbkdRZmhSM1crRUhPWDIzZTZBbldESFhRSWxEODgvdGFhcW55TmhYWmZS?=
 =?utf-8?B?OFc0QWk0V0tzRzBGRmthV3lzSm5MRCtSaTRJcFo4V1hqUVZZeGNyR2UzM0hz?=
 =?utf-8?B?SDBmbWYrcWw0V2V3QWMwNVRJdFB3bDNHVWZwWHNYdERPZjducHJhVmRoZVdK?=
 =?utf-8?B?NW91TWRtMW5RR1J4M01zVmZwZzNBWmtRUkEvT0poTVJha1BMRFJsRnFwNEZY?=
 =?utf-8?B?bUs2d0NXN1pBVTd6c2VweVRYQUhOTysvUWRwOEgyWXppTFhCMGlUUFQyS3Iv?=
 =?utf-8?B?d1UwTTZFOW45eFhyeGZ4MUM5dnRoTVVWbithcFdvVjNyVXBkNHNhbUdVeFVK?=
 =?utf-8?B?WlZKb1RXTTltcDZ3RjlselhhQXFVL1l4MU8xWnZwQzBuUXY3cFQ2dUMwZXpY?=
 =?utf-8?B?Tm5uQVkrblFocit1NEtVTE1XSjhwRWRUNk5OUnpyZk1MbXhGUWh4d1FPcnJV?=
 =?utf-8?B?UHgreDY2TVlJVWxwNGVUT2xtYWVhRlJMa0JFbXVycS9reWxsZEtDMStQNHlR?=
 =?utf-8?B?YVZlODBCSUdnMTFMMmVUbTlTUWdsb2lGQW9lOThIRi91SFhlakVlRDdQVUpK?=
 =?utf-8?B?WXNkdTN4bm1jN1ZQSWZBa29qc0ZiMlYxRkU2QTlGbVhINjdUUjFoUkFDdURK?=
 =?utf-8?B?ZkNXcjdHUit5YlhYNEduejRteTk3anZHbnhtZ1hrb3EzNU51eEFhNHFmbVVF?=
 =?utf-8?B?V00yTFppekdMQmNSQUd6WW1UQmM1Q0MxdFovay9QVEZUb3dBcStGNmtTbi9W?=
 =?utf-8?B?c2RuTWFWT0hvUWFQRU5qSmhZa3pqQW5wUmt5YXd3UHovYXZ5RkYrbE5Gd1FL?=
 =?utf-8?B?TURGYW0ybnQvNEVEZmYxdUI2Q2RselBKOEpUaUJBU2NaQW9UYzkyY2hnR0Qw?=
 =?utf-8?B?cUprVk1HTktQSnRwKzkxMlhkb25tTzRVekRRSlZQVlFDc1p4Y1hiTFkxeXdk?=
 =?utf-8?B?dEs3bkNsNWJ1RXVvRk1ZZ1R3cGI4anRicEo5RXJuMHJtWklMQTFrN2QwU0Rm?=
 =?utf-8?B?Y0lEc1BvdVBid3F2VFpqdFpieGkwQng4Qk5LUkw1L1N0eGRqYzV1WFpFSHB1?=
 =?utf-8?B?TUZRQm9GR2FnenlQM3M1UWVXN3BJTHJSN2RxNE5NUVpsREIydkZKeGRWd3Vs?=
 =?utf-8?B?c1h0cFZRNHhHeTE2OHNtWUlubmNOalI2eStvK3k5emFjMzZ1YTFyckNBSmVk?=
 =?utf-8?B?RVZmZ0tkQlJoSGVxWHJkT2dPSVVBcnlZVXhvdHRYM0ZTVmExcjE3MW9EOG8r?=
 =?utf-8?B?ejJKdGg4dityTGRpMXB5UStKSzFUWlFJQkw4aDgyMFFUQzY2MFM4a1prTDJz?=
 =?utf-8?B?ZzM4Z1duVzFqbkFTbjcxQW96VlI4Ri9sVXJEcE5SVjh5aEJTZk9PZUFscFZX?=
 =?utf-8?B?TjNhbm9ZcEYrNDlSZDBoaXZadW43UmxSSFNHUU41Y1piVGFLTE56YVdzeTFv?=
 =?utf-8?B?WWJRZ1psN0h0SXl5N21kYVFjNTAyb0NkaTlFMzVoNndUV2dGQ05QK2VGM01n?=
 =?utf-8?B?aVhqSU9VT0xWeUJzMXlkQnBQMjY2bjJZT0cvWlNmUTJpSHZuNU9ZVlgxV0dD?=
 =?utf-8?B?YmozNFVZVXBmdHZXWGd3M1VpT3NQakdTTHRBRDFNOG51YUJKUTNKa2xwQXl0?=
 =?utf-8?B?MTdYb1ZCb1lxYmMrak5yQ2VGdGdDR0JEQWJtOEh2V012cVpCS0dROEVCZHNm?=
 =?utf-8?B?L2d6Vi9PQU1yRUVXUkRUVE02d0E0a0pSWWtnTDlZQUdDTHpyK2lSUGJGVjdm?=
 =?utf-8?B?QU9hQ001WGZvNnFTM2hOWklpbkwva1diL3R1cUtXRzZrTlFvTVd5OXBnMnJn?=
 =?utf-8?B?cjRTeUFXYWgwUVpVZzhLdGUxM2pHVzh3MThuck9nZlY1MHhha1doMmNjTG53?=
 =?utf-8?B?NXQvYm83TkFGNitHM1FjRzlTMFNrWFZUclVnMmRSeEx3b0F4cmVtOU8vN0gw?=
 =?utf-8?B?ajFkRDQvR1I3SlRUcjhyYjFuYkFmRnlteU4wRlV6Myt3MU94ME5iN1lzRis0?=
 =?utf-8?B?V3o0dkZnTmtQakt6UDJhelFuTGpLSUxqS1BrcDQrTXNLRjZPeW4yaU5kS21L?=
 =?utf-8?B?ZERQVVR5RUVqUHcwODV0cVJoUDdSTTZQYTdkbTVaRFkyWGdIWTlEYlQ4U0dQ?=
 =?utf-8?Q?K1xTO67ZV9D1/Cp9HBX8kgX7x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba1045c-deca-410c-98ea-08db064564cf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 00:18:51.8456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoRuGEAIOY4J7ubB49sbjmn3wIO59dRnXnJ/4EZNEv40t3KpUAmOAC5IMIbvAVmG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7595
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 01:14:56PM -0800, Jakub Kicinski wrote:
> I believe Paolo is planning to look next week. No idea why the patch
> got marked as Accepted 🤷️
> 
> On Fri, 3 Feb 2023 12:05:56 -0800 Saeed Mahameed wrote:
> > I don't agree, RDMA isn't proprietary, and I wish not to go into this
> > political discussion, as this series isn't the right place for that.
> 
> I don't think it's a political discussion. Or at least not in the sense 
> of hidden agendas because our agendas aren't hidden. I'm a maintainer
> of an open source networking stack, you're working for a vendor who
> wants to sell their own networking stack.

Wow, come down to earth a bit here, jeeze.

You are the maintainer of an open source subcomponent in Linux

I am the maintainer of an open source subcomponent in Linux

Gosh, they have some technological differences, but hey so does netdev
vs NVMe too - are you also upset that NVMe is less pure than netdev
because all the "crucial" flash management is proprietary?  Or suggest
that we should rip out all the AWS, GCP and HyperV drivers because the
hypervisor that creates them is closed source?

Heck, we both have quite interesting employers that bring their own
bias's and echo chambers.

Dave drew his line for netdev long ago, and I really respect that
choice and his convictions. But don't act like it is "better" or
somehow "more Linusy" than every other subsystem in the kernel.

> I don't think we can expect Linus to take a hard stand on this, but
> do not expect us to lend you our APIs and help you sell your product.

I think Linus has taken a stand. He is working on *Linux* not GNU
Hurd. The difference is Linux welcomes all HW and all devices. Bring
your open source kernel code and open source user space and you are
welcome here.

Sure the community has lots of different opinions, and there is a
definite group that leans in direction of wanting more open-ness
outside the kernel too, but overall Linus has kept consistent and has
not refused participation of HW on stricter ideological grounds.

"You are welcome here" is exactly why Linux dominates the industry and
GNU Hurd is a footnote.

"help you sell your product" when talking about a fellow open source
subsystem is an insulting line that has no business on these mailing
lists.

> Saying that RDMA/RoCE is not proprietary because there is a "standard"
> is like saying that Windows is an open source operating system because
> it supports POSIX.

That is a very creative definition of proprietary.

If you said "open source software to operate standards based fixed
function HW engines" you'd have a lot more accuracy and credibility,
but it doesn't sound as scary when you say it like that, does it?

RDMA is a alot more open than an NVMe drive, for instance.

> My objectives for netdev are:
>  - give users vendor independence
>  - give developers the ability to innovate
> 
> I have not seen an RDMA implementation which could deliver on either.
> Merging this code is contrary to my objectives for the project.

The things we do in other parts of the kernel in no way degrade these
activities for netdev. RDMA mirroring the netdev configurations is
irrelevant to the continued technical development of netdev, or its
ability to innovate.

We've never once said "you can't do that" to netdev because of
something RDMA is doing. I've been strict about that, rdma is on the
side of netdev and does not shackle netdev.

You've made it very clear you don't like the RDMA technology, but you
have no right to try and use your position as a kernel maintainer to
try and kill it by refusing PRs to shared driver code.

Let's try to all get along.

> > To summarize, mlx5_core is doing RoCE traffic processing and directs it to
> > mlx5_ib driver (a standard rdma stack), in this series we add RoCE ipsec
> > traffic processing as we do for all other RoCE traffic.
> 
> I already said it. If you wanted to configure IPsec for RoCE you should
> have added an API in the RDMA subsystem.

Did that years ago.

https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/man/mlx5dv_flow_action_esp.3.md

HW accelerated IPSEC has been in RDMA and DPDK for a long time now,
the mlx5 team is trying to catch up netdev because NVIDIA has
customers interested in using netdev with ipsec and would like to get
best performance from their HW.

We always try to do a complete job and ensure that RDMA's use of the
shared IP/port and netdev use of the shared IP/port are as consistent
as we can get - and now that it is technically trivial for mlx5 to run
the RDMA IP traffic inside the HW that matches the netdev flows we
will do that too.

It is really paranoid to think we somehow did all the netdev
enablement just to get something in RDMA. Sorry, there is no
incredible irreplaceable value there. The netdev stuff was a lot of
difficult work and was very much done to run traffic originating in
netdev.

Real customers have mixed workloads, and I think that's great. You
should try looking outside the bubble of your peculiar hyperscaler
employer someday and see what the rest of the industry is doing. There
is a reason every high speed NIC has a RDMA offering now, a reason
every major cloud has some kind of RDMA based networking offering and
a reason I've been merging a couple new RDMA drivers every year.

None of that activity takes away from netdev - it is not a zero sum
game. Even more importantly, for Linux, my multivendor open source
community is every bit as legitimate as yours.

I appreciate your political leanings, and your deep concern for
netdev. But I have no idea why you care what RDMA does, and reject
this absurd notion that the IP address, or APIs inside our shared
Linux kernel are somehow "yours" alone to decide how and when they are
used.

Jason
