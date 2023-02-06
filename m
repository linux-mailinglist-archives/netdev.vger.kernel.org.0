Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1466B68C0D4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjBFO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBFO7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:59:14 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7142A241FA;
        Mon,  6 Feb 2023 06:59:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTyFAQIqQARjo2NL5deVfHnt0gT3FR5nS13mLOwzhUVJ+amv7ehYHJFvjrrs0QiRiVdOUkshZjOjQMsMcIYjWRGlBK9Hp5iS32t0lbiZyf7RLQrAmzgw087aw52y7jr2L+3rjg287p8DhK1BudbpBoMAwD/8sblJlprxr7yEiIlMPZuzYKLDr0gnkQZjLk+Ai0VTha+ZFuGP5EEcpjYEtzMyxjVwZKfFe0ysCLiVUhGPJs59sgXqayk/7x+6KGkgj4CBQdX4jmYrHgXwq5jcjXp+R+nSlzd6Qj/T3lhpFsbK+eGyNjob0wWQ+qlQoROaEYMD959ZCCbOw7U7/lRSMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwZmXia5PIiEOgumnm+bw1Z7C1uM79mpZkYkBkZFrAw=;
 b=FUxYlkSehipCsB9BlusgSQSIIWGiKNmF1+C+8o/SVKW4X9gQ1r3wJNhgWqmUC/BqUPgKaW+gVojedjSewRhkUEQ+RQx9bSSYyIMOfOKvIVdJveyyhRRQcRRPTOm0kYezIPikp1upYx80PQX+Q+YQM074MY7IjKuK4Nai+Pmg5Y02xkUwzXXAt1y0l048ZGYdcRzm4D1pS/0P+1mGxyTVPIUrTgxZ93ChdyptaddGslvX9ZYw3KQ5FOPpuGQIMgWbKCAlGg3ae2Ij9QIiZmec6Eamd0/hoOF0IXJzUrgWkJ4ojLXnqXPi4JwsCodaXnU0Ddya1Xi8pvIm9LFqpVozzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwZmXia5PIiEOgumnm+bw1Z7C1uM79mpZkYkBkZFrAw=;
 b=ewYGSQtXAggr8s+2TMGlOeuu9xMXwNzcFXyuC2vweJk3JCJY3WIuTckR1s7nUiV55/8ftxvtHjAw/jWZ7/t5DCnxVJ2iX3fPVbeNz6aEr+nKCW9yAWShW9g6wXTQ6LA/pMVIF/6GvxHHvki4ve7beRBmwm6vqexOQ/B/OWUiQi8lIQ/M7E3a2wzwMc70VOmijiHbySAa/Yl33XtQ+JTIDp08GjTVGop8ES/5RET8P1BoJVFk8VbpHNfc4fETmKt9SbydX84bBuk1vBv1AfKeCGinF663C/44NYF/HNOmLVqZjnN16r95/GO5QdRQAhZ69m0winIiTzILuhVF1Lj4yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB5002.namprd12.prod.outlook.com (2603:10b6:610:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:59:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 14:59:04 +0000
Date:   Mon, 6 Feb 2023 10:58:56 -0400
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
Message-ID: <Y+EVsObwG4MDzeRN@nvidia.com>
References: <20230202092507.57698495@kernel.org>
 <Y9v2ZW3mahPBXbvg@nvidia.com>
 <20230202095453.68f850bc@kernel.org>
 <Y9v61gb3ADT9rsLn@unreal>
 <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
 <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
 <Y92kaqJtum3ImPo0@nvidia.com>
 <20230203174531.5e3d9446@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203174531.5e3d9446@kernel.org>
X-ClientProxiedBy: BL0PR0102CA0019.prod.exchangelabs.com
 (2603:10b6:207:18::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB5002:EE_
X-MS-Office365-Filtering-Correlation-Id: 8491a033-1dc7-488c-bc16-08db0852b04e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZFzqxLsMbbX2jVUDIA+C21wnRVSUFOBwx87a2VdES1Xzr8tRA0ifkRG2vNgBYo2fBwtT0N+1OomZiLjgAlVrTMG7y9SmjU/QAaXpzTX7UBpl02oVqQW5n20imuAIWqpl9ZYHEPlnIYwccK+HSXFjQ0ZgCUzd4Tb2ZwQw9pcFXprGNjzvNm2S5TaDqVQ32xOnxmd9x1sNWa3JGUxVSEFJsjNIF+rr3cGrMS0g/xbinID9Z5/Ee4EFXgvRqcgOwiYxhjZT3lvaM7ek1dXoe1dwCyfiKOE04RxNIFVGxQyhXLMhc4Nm7pzjI+CNxlMBfs1WZkTatpEQgIIYzkAUi/1rfXvO3YqsDzTuvQgehd5WWt0zsZHNEZFh0ynVHZIu4+pxomOvzto23xs49Buxc6CTtXnGN6qrI+TvT6uA8H9smg2hu905oBgpnsdRBP/pz/fMJh93icP6GUk3szLaV1Uw0QDy7/fHDfongEVdNLubRxgIHfCjpFnTsxBhNukjyiUXPKsw2hj38OMkWhPSv5LesZjOYA4xESgA8+UUDTJvQb93JdZ2eJKQzouKUSnqLasFo23hbET9cqDFEXzsGPgZgrQ41Lh1U7J1wHtWhgmMTWkkR0285OKLkAjxI8PJDsvaP+UPSPX5JmBocvw0e/+L5QFJ9FUZzfqQSChNaMpHvuwGf7RVPmg3xqwosN1lDfn8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199018)(86362001)(38100700002)(36756003)(41300700001)(8676002)(6916009)(8936002)(5660300002)(66476007)(316002)(66556008)(66946007)(54906003)(4326008)(2906002)(2616005)(83380400001)(6486002)(478600001)(6512007)(186003)(26005)(6666004)(6506007)(66899018)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XvMKbOXINNBrI+R+pMZ9xzZ0W/l9z1CI/Xa4OgwBC8Ygh1JJYOmC10whhkKA?=
 =?us-ascii?Q?6ynG2KEzvmA72mUUSXQI0NBbst4VbI2NpbyC+1ct12Ak6+Hj8m5eD0pibwF/?=
 =?us-ascii?Q?v/MGYni/8cTFcrmTP63bKWrtbJbNzsWsBXf5VZgutgfSanylYYX1fQ+h/Anl?=
 =?us-ascii?Q?/a9Zga8YUpZYCteFidWDvb74y9qQd8vW82fxiYI+x7E8m8jy3etu3V/tTj2c?=
 =?us-ascii?Q?B5ZWH9+zaUB53wdZIg9PsoQgRO65P5s/iMFvb9jCwfURHtLCX2r1WVW1olmw?=
 =?us-ascii?Q?arBK5Txko6XHb7PcyxQ+LUykvoGIGHsQefn6fjHVYKmg43k417gtmddzKwm6?=
 =?us-ascii?Q?F0vY6bc0iTd69yuHokvpNKQCPXssYQCqqw7dIytpAoI49AmOpAv//A6f00ZB?=
 =?us-ascii?Q?a+sQ6NIuV9i/3Ei80cBlYsZAb3cblxGnkSOuex4sF0dGcw53IHXJp5wKbe9/?=
 =?us-ascii?Q?CxB717/hCnJiDovPdD9VfSPedHAHi3b4rH0wROB0tl2RwasD6UQGbzLemp9R?=
 =?us-ascii?Q?/ZmRDxkRLeRa6WXRb9z86sdyFiZ8kRHZeQ7xHHAAylGcxFjj7rpJUUbNM6tR?=
 =?us-ascii?Q?llNQz7KY8Hyao+1qrcBJxG/U67nlePWNISkPMBnuFneRgU0KubBjCdXKEq5R?=
 =?us-ascii?Q?o4tYvKD96K/PNh04mgudBUeaJic5acr8UVFMGZdzfaLL74YD2NIsKqdD7mmt?=
 =?us-ascii?Q?8wu6Y0EDR4/8nOFu1zkb3eMzbBkWxqPAJ+Et+RLYdaNFeu/vEojivqFJEYGv?=
 =?us-ascii?Q?Ozn8q8eZkDIf7lWrb0Yd4ztpZZl8UT5aYV4LiFydDl6iuTzwW45OgZksTbal?=
 =?us-ascii?Q?Na95QK9yeF+KLjizAVe3vvEAe6nvDPEKlfxGm2ZoSuz/VojaniDtuNAPou5/?=
 =?us-ascii?Q?GI8+0gG4+AAraK+BeitTlGG/+CT5BvL39ac3n7lHdGqhZf0Pr0n4MDvaO4Rd?=
 =?us-ascii?Q?H73LBdt+inW8gHU/WKnBGORgx02EkUDCmUdTW86B45/0ouThxfeQCbK8m30C?=
 =?us-ascii?Q?dgThIP0ZCFXU3dftGggsk7qBqKL+wSCK8wFsKm0+7aytUZ34f6h3ubN/wd1r?=
 =?us-ascii?Q?H9FUphWjyQf30fzQmeB6HccwiXaiVU7d7oJxuzF1PLmwb8lrPx8onEccJiCy?=
 =?us-ascii?Q?LZCAtl4RGxFm8H+mTw0ki5eNgL+Q2jpNkfpvGs7cZjkEcfuF4A1s/Xa7xW7a?=
 =?us-ascii?Q?Q2i7PTRGFS6SM7U3DPE1AIl/UxkljaOfpPDz3Rc4h14OtdzBNROft+ruiZ+n?=
 =?us-ascii?Q?xmtUOnZ8Qj+z4YUX9VPYtzWWNJ2kTpLkeoFTZLRe6qWfVxgDgK2zQ0s10mNt?=
 =?us-ascii?Q?3GZjnmwZIgn7/wVxK1yQF2k75tB6+noJUN3H8kaqFUzRXvRA6rhtBWMjCCJS?=
 =?us-ascii?Q?Xi3C1NXnwo0FYuivFwQthceWQEj53a61vX2VFV3WK/3UFUZ9GumEMAlKrEyj?=
 =?us-ascii?Q?tGwOitXfGK3EiJpZcfspI7jHoMdF+UpFWF4eWYV5KAAVlxE8nBMJ9fnY2w+0?=
 =?us-ascii?Q?fVq9WO9YW/tvYuZgEPVVEru5zuwpDPVeQ3NjH30+elPd55Y1HEAA55PzRUJS?=
 =?us-ascii?Q?imkdwuGtYuVqpBSply2h9nRBmj3pTZxtZkw4pt6/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8491a033-1dc7-488c-bc16-08db0852b04e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:59:04.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UsHCmvk6uZH3t6owp4DSuSkfCxNe7aDMFnvmkzafGXUqsboaYFWSIHlvNBNddS/z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5002
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 05:45:31PM -0800, Jakub Kicinski wrote:
> On Fri, 3 Feb 2023 20:18:50 -0400 Jason Gunthorpe wrote:
> > Wow, come down to earth a bit here, jeeze.
> > 
> > You are the maintainer of an open source subcomponent in Linux
> > 
> > I am the maintainer of an open source subcomponent in Linux
> > 
> > Gosh, they have some technological differences, but hey so does netdev
> > vs NVMe too - are you also upset that NVMe is less pure than netdev
> > because all the "crucial" flash management is proprietary?  Or suggest
> > that we should rip out all the AWS, GCP and HyperV drivers because the
> > hypervisor that creates them is closed source?
> 
> Perfectly irrelevant comparisons :/ How many times do I have to say
> that all I'm asking is that you stay away from us and our APIs?

What I'm reacting to is your remarks that came across as trying to
saying that the particular netdev subystem approach to open-ness was
in fact the same as the larger Linux values on open source and
community.

netdev is clearly more restrictive, so is DRM, and that's fine. But it
should stay in netdev and not be exported to the rest of the
kernel. Eg don't lock away APIs for what are really shared resources.

> > Heck, we both have quite interesting employers that bring their own
> > bias's and echo chambers.
> 
> My employer has no influence on my opinions and is completely
> irrelevant here :/ I hope the same is true for you.

Well, I sit in an echo-chamber that is different than yours. I'm
doubtful it doesn't have at least some effect on all of us to hear the
same themes over and over.

What you posted about your goals for netdev is pretty consistent with
the typical approach from a hyperscaler purchasing department: Make it
all the same. Grind the competing vendors on price.

I'd say here things are more like "lets innovate!" "lets
differentiate!" "customers pay a premium for uniquess"

Which side of the purchasing table is better for the resilience and
vibrancy of our community? I don't know. I prefer not to decide, I
think there is room for both to advance their interests. I don't view
one as taking away from the other in terms of open source.

> I think that's accurate. Only dissent I'd like to register is for use
> of "HW" when the devices I'm concerned with run piles and piles of FW.
> To avoid misunderstanding prefer the term "device".

I use the term "HW" because Linux doesn't care what is under that HW
interface. Like I said, the AWS, GCP, HyperV stuff is often all SW
pretending to be HW. Nobody really knows what is hiding under the
register interface of a PCI device.

Even the purest most simple NIC is ultimately connected to a switch
which usually runs loads of proprietary software, so people can make
all kinds of idological arguments about openness and freeness in the
space.

I would say, what the Linux community primarily concerns itself with
is the openness of the drivers and in-kernel code and the openness of
the userspace that consumes it. We've even walked back from demanding
an openness of the HW programming specification over the years.

Personally I feel the openness of the userspace is much more important
to the vibrancy of the community than openness of the HW/FW/SW thing
the device driver talks to. I don't like what I see as a dangerous
trend of large cloud operators pushing things into the kernel where
the gold standard userspace is kept as some internal proprietary
application.

At least here in this thread the IPSEC work is being built with and
tested against fully open source strong/openswan. So, I'm pretty
happy on ideological grounds.

> > That is a very creative definition of proprietary.
> > 
> > If you said "open source software to operate standards based fixed
> > function HW engines" you'd have a lot more accuracy and credibility,
> > but it doesn't sound as scary when you say it like that, does it?
> 
> Here you go again with the HW :)

In the early 2000's when this debate was had and Dave set the course
it really was almost pure HW in some of the devices. IIRC a few of the
TCP Offload vendors were doing TCP offload in SW cores, but that
wasn't universal. Certainly the first true RDMA devices (back in the
1990's!) were more HW that SW.

Even today the mlx devices are largely fixed function HW engines with
a bunch of software to configure them and babysit them when they get
grouchy.

This is why I don't like the HW/FW distinction as something relevant
to Linux - a TOE built in nearly pure HW RTL or a TOE that is all SW
are both equally unfree and proprietary. The SW/FW is just more vexing
because it is easier to imagine it as something that could be freed,
while ASIC gates are more accepted as unrealistic.

> Maybe to you it's all the same because you're not interested in network
> protocols and networking in general? Apologies if that's a
> misrepresentation, I don't really know you. I'm trying to understand
> how can you possibly not see the difference, tho.

I'm interested in the Linux software - and maintaining the open source
ecosystem. I've spent almost my whole career in this kind of space.

So I feel much closer to what I see as Linus's perspective: Bring your
open drivers, bring your open userspace, everyone is welcome.

In most cases I don't feel threatened by HW that absorbed SW
functions. I like NVMe as an example because NVMe sucked in,
basically, the entire MTD subsystem and a filesystem into drive FW and
made it all proprietary. But the MTD stuff still exists in Linux, if
you want to use it. We, as a community, haven't lost anything - we
just got out-competed by a better proprietary solution. Can't win them
all.

Port your essential argument over to the storage world - what would
you say if the MTD developers insisted that proprietary NVMe shouldn't
be allowed to use "their" block APIs in Linux?

Or the MD/DM developers said no RAID controller drivers were allowed
to use "their" block stack?

I think as an overall community we would loose more than we gain.

So, why in your mind is networking so different from storage?

> > We've never once said "you can't do that" to netdev because of
> > something RDMA is doing. I've been strict about that, rdma is on the
> > side of netdev and does not shackle netdev.
> 
> There were multiple cases when I was trying to refactor some code,
> run into RDMA using it in odd ways and had to stop :/

Yes, that is true, but the same can be said about drivers using code
in odd ways and so on. Heck Alistair just hit some wonky netdev code
while working on MM cgroup stuff. I think this is normal and expected.

My threshold is more that if we do the hard work we can overcome
it. I never want to see netdev say "even with hard work we can't do
it because RDMA".  Just as I'd be unhappy for netdev to say MM can't
do the refactor they want (and I guess we will see what becomes of
Alistair's series because he has problems with skbuff that are not
obviously solvable)

What I mean, is we've never said something like - netdev can't
implement VXLAN in netdev because RDMA devices can't HW offload
that. That's obviously ridiculous. I've always thought that the
discussion around the TOE issue way back then was more around concepts
similar to stable-api-nonsense.rst (ie don't tie our SW API to HW
choices) than it was to ideological openness.

> > You've made it very clear you don't like the RDMA technology, but you
> > have no right to try and use your position as a kernel maintainer to
> > try and kill it by refusing PRs to shared driver code.
> 
> For the n-th time, not my intention. RDMA may be more open than NVMe.
> Do your thing. Just do it with your own APIs.

The standards being implemented broadly require the use of the APIs -
particularly the shared IP address.

Try to take them away and it is effectively killing the whole thing.

The shared IP comes along with a lot of baggage, including things like
IPSEC, VLAN, MACSEC, tc, routing, etc, etc. You can't really use just
the IP without the whole kit.

We've tried to keep RDMA implementations away from the TCP/UDP stack
(at Dave's request long ago) but even that is kind of a loosing battle
because the standards bodies have said to use TCP and UDP headers as
well.

If you accept my philosophy "All are welcome" then how can I square
that with your demand to reject entire legitimate standards from
Linux?

Jason
