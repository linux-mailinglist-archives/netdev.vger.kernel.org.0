Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D5D68CB4E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 01:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBGAir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 19:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBGAiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 19:38:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC6924100;
        Mon,  6 Feb 2023 16:38:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1220C60FBF;
        Tue,  7 Feb 2023 00:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FB5C433D2;
        Tue,  7 Feb 2023 00:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675730323;
        bh=zNV+0uHbpe0bjBw8jZUtcWUbFLSylhHBwHohP4sGmRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T4BWqmRbNIXxM7ZClxKFV8iKGLYm5FpxR/Up7aXBALxwIfHmLfHBRSAbk4oxh458D
         DxGQfrdIAQKpBu2l3zte4GdHR/Cud8KhQdetCvbMB62/XmPOqo3FyH8VxTb4RWJchP
         952O1i5maf2mD8ycfy5oMHH1YAUD/NAGv7lBQddg8ljb1BVFcR3FRfVOSO9X2WNYbV
         UnhKSUmdQdqI6LnocS7biX4dW8t/sGEPf4IO0m2/LgrnSW3TrPu9G6aijXn3a6Ih6Y
         VTGcBm8kyn9jMxM8srQaQcHV4Sx/LH20DfVM6BIYSwu4/V1033EM61uydVo1L0o5QK
         zAWWq+Y7NhyOg==
Date:   Mon, 6 Feb 2023 16:38:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230206163841.0c653ced@kernel.org>
In-Reply-To: <Y+EVsObwG4MDzeRN@nvidia.com>
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
        <Y+EVsObwG4MDzeRN@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Feb 2023 10:58:56 -0400 Jason Gunthorpe wrote:
> On Fri, Feb 03, 2023 at 05:45:31PM -0800, Jakub Kicinski wrote:
> > Perfectly irrelevant comparisons :/ How many times do I have to say
> > that all I'm asking is that you stay away from us and our APIs?  
> 
> What I'm reacting to is your remarks that came across as trying to
> saying that the particular netdev subystem approach to open-ness was
> in fact the same as the larger Linux values on open source and
> community.
>
> netdev is clearly more restrictive, so is DRM, and that's fine. But it
> should stay in netdev and not be exported to the rest of the
> kernel. Eg don't lock away APIs for what are really shared resources.

I think you're misrepresenting. The DRM example is pertinent.
The DRM disagreement as I recall it was whether Dave gets to nack
random drivers in misc/ which are implementing GPU-like functionality
but do _not_ use DRM APIs.

Whether one subsystem can use another subsystem's API over maintainer's
NACK has a pretty obvious answer.

"Don't touch my APIs" separation is the simplest and most effective
solution to the problem of hosting code with different standards.

IMO netdev should not stand in the way of scale-out fabrics (IB etc.)
or IPUs, even tho they don't meet our standards of openness.
Good fences make good neighbors so I'd like to build a fence and avoid
having to discuss this over and over.

> > > Heck, we both have quite interesting employers that bring their own
> > > bias's and echo chambers.  
> > 
> > My employer has no influence on my opinions and is completely
> > irrelevant here :/ I hope the same is true for you.  
> 
> Well, I sit in an echo-chamber that is different than yours. I'm
> doubtful it doesn't have at least some effect on all of us to hear the
> same themes over and over.
> 
> What you posted about your goals for netdev is pretty consistent with
> the typical approach from a hyperscaler purchasing department: Make it
> all the same. Grind the competing vendors on price.

Hyperscalers perhaps drive harder bargains, but the volume is so high
I'd imagine it's much easier for a hyperscaler to spin up a team of
people to support a new vendor.

Everyone is familiar with the term "vendor lock-in". The principles
I listed are hardly hyperscaler driven.

> I'd say here things are more like "lets innovate!" "lets
> differentiate!" "customers pay a premium for uniquess"

Which favors complex and hard-to-copy offloads, over
iterating on incremental common sense improvements.

> Which side of the purchasing table is better for the resilience and
> vibrancy of our community? I don't know. I prefer not to decide, I
> think there is room for both to advance their interests. I don't view
> one as taking away from the other in terms of open source.

The distinction between large users vs vendors is moderately meaningful.
Both will occasionally try to benefit themselves to the detriment of
the community. One has to take the developments case by case.

FWIW the "sides of the purchasing table" phrasing brings to mind
industry forums rather than open source communities... Whether Linux
is turning into an industry forum, and what Joreen would have to say
about that*.. discussion for another time.

(*  https://en.wikipedia.org/wiki/The_Tyranny_of_Structurelessness )

> > I think that's accurate. Only dissent I'd like to register is for use
> > of "HW" when the devices I'm concerned with run piles and piles of FW.
> > To avoid misunderstanding prefer the term "device".  
> 
> I use the term "HW" because Linux doesn't care what is under that HW
> interface. Like I said, the AWS, GCP, HyperV stuff is often all SW
> pretending to be HW. Nobody really knows what is hiding under the
> register interface of a PCI device.

I understand, but it can be very misleading in context of discussions
about open source.

> Even the purest most simple NIC is ultimately connected to a switch
> which usually runs loads of proprietary software, so people can make
> all kinds of idological arguments about openness and freeness in the
> space.
> 
> I would say, what the Linux community primarily concerns itself with
> is the openness of the drivers and in-kernel code and the openness of
> the userspace that consumes it. We've even walked back from demanding
> an openness of the HW programming specification over the years.
> 
> Personally I feel the openness of the userspace is much more important
> to the vibrancy of the community than openness of the HW/FW/SW thing
> the device driver talks to.

Hard to comment in abstract terms, but for me as a networking guy - 
I can fix bugs and experiment with TCP/IP. Take the patches that come
out of Google, or Cloudflare, or anyone else and use them.
Experience very different to those of folks who work on RDMA networks.

> I don't like what I see as a dangerous
> trend of large cloud operators pushing things into the kernel where
> the gold standard userspace is kept as some internal proprietary
> application.

Curious what you mean here.

> At least here in this thread the IPSEC work is being built with and
> tested against fully open source strong/openswan. So, I'm pretty
> happy on ideological grounds.
> 
> > > That is a very creative definition of proprietary.
> > > 
> > > If you said "open source software to operate standards based fixed
> > > function HW engines" you'd have a lot more accuracy and credibility,
> > > but it doesn't sound as scary when you say it like that, does it?  
> > 
> > Here you go again with the HW :)  
> 
> In the early 2000's when this debate was had and Dave set the course
> it really was almost pure HW in some of the devices. IIRC a few of the
> TCP Offload vendors were doing TCP offload in SW cores, but that
> wasn't universal. Certainly the first true RDMA devices (back in the
> 1990's!) were more HW that SW.
> 
> Even today the mlx devices are largely fixed function HW engines with
> a bunch of software to configure them and babysit them when they get
> grouchy.
> 
> This is why I don't like the HW/FW distinction as something relevant
> to Linux - a TOE built in nearly pure HW RTL or a TOE that is all SW
> are both equally unfree and proprietary. The SW/FW is just more vexing
> because it is easier to imagine it as something that could be freed,
> while ASIC gates are more accepted as unrealistic.

Agreed, and that's why saying "device" without specifying HW/FW/SW 
at all should be acceptable middle ground. Not misleading or triggering.

> > Maybe to you it's all the same because you're not interested in network
> > protocols and networking in general? Apologies if that's a
> > misrepresentation, I don't really know you. I'm trying to understand
> > how can you possibly not see the difference, tho.  
> 
> I'm interested in the Linux software - and maintaining the open source
> ecosystem. I've spent almost my whole career in this kind of space.
> 
> So I feel much closer to what I see as Linus's perspective: Bring your
> open drivers, bring your open userspace, everyone is welcome.

(*as long as they are on a side of the purchasing table) ?

> In most cases I don't feel threatened by HW that absorbed SW
> functions. I like NVMe as an example because NVMe sucked in,
> basically, the entire MTD subsystem and a filesystem into drive FW and
> made it all proprietary. But the MTD stuff still exists in Linux, if
> you want to use it. We, as a community, haven't lost anything - we
> just got out-competed by a better proprietary solution. Can't win them
> all.
> 
> Port your essential argument over to the storage world - what would
> you say if the MTD developers insisted that proprietary NVMe shouldn't
> be allowed to use "their" block APIs in Linux?
> 
> Or the MD/DM developers said no RAID controller drivers were allowed
> to use "their" block stack?
> 
> I think as an overall community we would loose more than we gain.
> 
> So, why in your mind is networking so different from storage?

Networking is about connecting devices. It requires standards,
interoperability and backward compatibility.

I'm not an expert on storage but my understanding is that the
standardization of the internals is limited and seen as unnecessary.
So there is no real potential for open source implementations of
disk FW. Movement of data from point (a) to point (b) is not interesting
either so NVMe is perfectly fine. Developers innovate in filesystems 
instead.

In networking we have strong standards so you can (and do) write
open source software all the way down to the PHYs (serdes is where
things get quite tricky). At the same time movement of data from point
a to point b is _the_ problem so we need the ability to innovate in
the transport space.

Now we have strayed quite far from the initial problem under discussion,
but you can't say "networking is just like storage" and not expect
a tirade from a networking guy :-D 

> > > We've never once said "you can't do that" to netdev because of
> > > something RDMA is doing. I've been strict about that, rdma is on the
> > > side of netdev and does not shackle netdev.  
> > 
> > There were multiple cases when I was trying to refactor some code,
> > run into RDMA using it in odd ways and had to stop :/  
> 
> Yes, that is true, but the same can be said about drivers using code
> in odd ways and so on. Heck Alistair just hit some wonky netdev code
> while working on MM cgroup stuff. I think this is normal and expected.
> 
> My threshold is more that if we do the hard work we can overcome
> it. I never want to see netdev say "even with hard work we can't do
> it because RDMA".  Just as I'd be unhappy for netdev to say MM can't
> do the refactor they want (and I guess we will see what becomes of
> Alistair's series because he has problems with skbuff that are not
> obviously solvable)

Core kernel is not a good comparison. The example in DRM vs misc/
would be more fitting.

> What I mean, is we've never said something like - netdev can't
> implement VXLAN in netdev because RDMA devices can't HW offload
> that. That's obviously ridiculous. I've always thought that the
> discussion around the TOE issue way back then was more around concepts
> similar to stable-api-nonsense.rst (ie don't tie our SW API to HW
> choices) than it was to ideological openness.
> 
> > > You've made it very clear you don't like the RDMA technology, but you
> > > have no right to try and use your position as a kernel maintainer to
> > > try and kill it by refusing PRs to shared driver code.  
> > 
> > For the n-th time, not my intention. RDMA may be more open than NVMe.
> > Do your thing. Just do it with your own APIs.  
> 
> The standards being implemented broadly require the use of the APIs -
> particularly the shared IP address.

No point talking about IP addresses, that ship has sailed.
I bet the size of both communities was also orders of magnitude
smaller back then. Different conditions different outcomes.

> Try to take them away and it is effectively killing the whole thing.
> 
> The shared IP comes along with a lot of baggage, including things like
> IPSEC, VLAN, MACSEC, tc, routing, etc, etc. You can't really use just
> the IP without the whole kit.
> 
> We've tried to keep RDMA implementations away from the TCP/UDP stack
> (at Dave's request long ago) but even that is kind of a loosing battle
> because the standards bodies have said to use TCP and UDP headers as
> well.
> 
> If you accept my philosophy "All are welcome" then how can I square
> that with your demand to reject entire legitimate standards from
> Linux?

We don't support black-box transport offloads in netdev. I thought that
it'd come across but maybe I should spell it out - just because you
are welcome in Linux does not mean RDMA devices are welcome in netdev.

As much as we got distracted by our ideological differences over the
course of this thread - the issue is that I believe we had an agreement
which was not upheld.

I thought we compromised that to make the full offload sensible in
netdev world nVidia would implement forwarding to xfrm tunnels using 
tc rules. You want to add a feature in netdev, it needs to be usable 
in a non-trivial way in netdev. Seems fair.

The simplest way forward would be to commit to when mlx5 will support
redirects to xfrm tunnel via tc...
