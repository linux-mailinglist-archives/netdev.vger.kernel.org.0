Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6EB68E33A
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBGWDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBGWDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:03:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2756D3B3FD;
        Tue,  7 Feb 2023 14:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B117C61300;
        Tue,  7 Feb 2023 22:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA46CC433EF;
        Tue,  7 Feb 2023 22:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675807412;
        bh=Ng4up2lYqKiT+gvdmO4wyhhQaz6fDwkOmZJxGPD2hks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lEqmyCZXt282QxQnbR7TrdTNb8MUfiyCbnHScD3Bqc4jtUngsO9nCY8zG7ns+F7Y3
         JYxuNDchaqt34CYnKbS4rIXoC8UZxq9tl3DdBPrg/zRm3kWmmQMC3Fc+Chg98oPEoT
         u+ReJMBEx95SEMzeB8Oo9ojMHxJtA9urttRACWsiEhqgKGJIUBmCXzF0l1hhtM3PYG
         wdtMhELTUd5IFUndkvAY/nSG/dJ/HnrQf21vkq5HnTd7LF0k2PDh8xMZv9UsLi3Uz4
         1wJoxlyblz7XupwDYc1Zc+3XoAcod5HGKqhCAoqgYLyHwufdsLdD8/I6fbHIHaxhPN
         q9ZkwJnydrq3A==
Date:   Tue, 7 Feb 2023 14:03:30 -0800
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
Message-ID: <20230207140330.0bbb92c3@kernel.org>
In-Reply-To: <Y+KsG1zLabXexB2k@nvidia.com>
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
        <Y+KsG1zLabXexB2k@nvidia.com>
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

On Tue, 7 Feb 2023 15:52:59 -0400 Jason Gunthorpe wrote:
> On Mon, Feb 06, 2023 at 04:38:41PM -0800, Jakub Kicinski wrote:
> > On Mon, 6 Feb 2023 10:58:56 -0400 Jason Gunthorpe wrote:  
> > > What I'm reacting to is your remarks that came across as trying to
> > > saying that the particular netdev subystem approach to open-ness was
> > > in fact the same as the larger Linux values on open source and
> > > community.
> > >
> > > netdev is clearly more restrictive, so is DRM, and that's fine. But it
> > > should stay in netdev and not be exported to the rest of the
> > > kernel. Eg don't lock away APIs for what are really shared resources.  
> > 
> > I think you're misrepresenting. The DRM example is pertinent.
> > The DRM disagreement as I recall it was whether Dave gets to nack
> > random drivers in misc/ which are implementing GPU-like functionality
> > but do _not_ use DRM APIs.  
> 
> That isn't what I was thinking about.
> 
> The DRM specialness is they are very demanding about having an open
> user space. More so than most places in the kernel.
> 
> The misc/ argument was about drivers trying to avoid the strict DRM
> open user space requirement. In the end Greg agreed that open
> userspace was something he wanted for misc too.
> 
> DRM tried to use DMABUF as some kind of API wedge, but it didn't
> really work out too well.

DMABUF was what I remember from the Maintainer Summit.
I don't follow the DRM tho, so can't tell if it worked or not :(

> In the end the fight was ideological around what is open enough to be
> inside Linux because the GPU devices were skirting around something of
> a grey area in the project's philosophy on how much open user space is
> actually required.

Right, I see that as very similar to our situation.

> > Whether one subsystem can use another subsystem's API over maintainer's
> > NACK has a pretty obvious answer.  
> 
> I would say not, I've never seen this actually aside from netdev vs
> rdma. If the APIs are being used wrong, sure, but not for ideological
> reasons.
> 
> > Good fences make good neighbors so I'd like to build a fence and
> > avoid having to discuss this over and over.  
> 
> I also would like to not discuss this :)

Well, then... Suggest a delineation or a way forward if you don't like
mine. The circular conversation + RDMA gets its way has to end sooner
or later.

> > Everyone is familiar with the term "vendor lock-in". The principles
> > I listed are hardly hyperscaler driven.  
> 
> The hyperscalers brought it to a whole new level. Previously we'd see
> industry consortium's try to hammer out some consolidation, now we
> quite often see hyperscalers make their own private purchasing
> standards and have vendors to use them. I have mixed feelings about
> the ecosystem value of private label standardization, especially if
> the standard itself is kept secret.
> 
> Then of course we see the private standards get quietly implemented in
> Linux.
> 
> An open source kernel implementation of a private standard for HW that
> only one company can purchase that is only usable with a proprietary
> userspace. Not exactly what I'd like to see.

You switched your argument 180 degrees.

Fist you said:

  What you posted about your goals for netdev is pretty consistent with
  the typical approach from a hyperscaler purchasing department: Make it
  all the same. Grind the competing vendors on price.

So "Make it all the same". Now you're saying hyperscalers have their
own standards.

Don't get me wrong, large customers get to ask for custom solutions.
In networking is a well known anti-pattern, ask anyone who ever worked
on telco solutions or routing protocols.

But I'm struggling to find a coherent argument in what you're saying.

> > > I'd say here things are more like "lets innovate!" "lets
> > > differentiate!" "customers pay a premium for uniquess"  
> > 
> > Which favors complex and hard-to-copy offloads, over
> > iterating on incremental common sense improvements.  
> 
> I wouldn't use such a broad brush, but sure sometimes that is a
> direction. More often complex is due to lack of better ideas, nobody
> actually wants it to be complex, that just makes it more expensive to
> build and more likely to fail..

It'd be unprofessional for me to share details in this forum,
unfortunately.

> > FWIW the "sides of the purchasing table" phrasing brings to mind
> > industry forums rather than open source communities... Whether Linux
> > is turning into an industry forum, and what Joreen would have to say
> > about that*.. discussion for another time.  
> 
> Well, Linux is an industry forum for sure, and it varys how much power
> it projects. DRM's principled stand has undoubtedly had a large
> impact, for instance.

And so obviously did netdev.

> > > I don't like what I see as a dangerous
> > > trend of large cloud operators pushing things into the kernel
> > > where the gold standard userspace is kept as some internal
> > > proprietary application.  
> > 
> > Curious what you mean here.  
> 
> Ah, I stumble across stuff from time to time - KVM and related has
> some interesting things. Especially with this new confidential compute
> stuff. AMD just tried to get something into their mainline iommu
> driver to support their out of tree kernel, for instance.
> 
> People try to bend the rules all the time.

AMD is a vendor, tho, you said "trend of large cloud operators pushing
things into the kernel". I was curious to hear the hyperscaler example
'cause I'd like to be vigilant.

> > > I'm interested in the Linux software - and maintaining the open
> > > source ecosystem. I've spent almost my whole career in this kind
> > > of space.
> > > 
> > > So I feel much closer to what I see as Linus's perspective: Bring
> > > your open drivers, bring your open userspace, everyone is
> > > welcome.  
> > 
> > (*as long as they are on a side of the purchasing table) ?  
> 
> Naw, "hobbyists" are welcome of course, but I get the feeling that is
> getting rarer.

And influx of talented incomers is more important to me personally
than keeping vendors happy.

> > > Port your essential argument over to the storage world - what
> > > would you say if the MTD developers insisted that proprietary
> > > NVMe shouldn't be allowed to use "their" block APIs in Linux?
> > > 
> > > Or the MD/DM developers said no RAID controller drivers were
> > > allowed to use "their" block stack?
> > > 
> > > I think as an overall community we would loose more than we gain.
> > > 
> > > So, why in your mind is networking so different from storage?  
> > 
> > Networking is about connecting devices. It requires standards,
> > interoperability and backward compatibility.
> > 
> > I'm not an expert on storage but my understanding is that the
> > standardization of the internals is limited and seen as unnecessary.
> > So there is no real potential for open source implementations of
> > disk FW. Movement of data from point (a) to point (b) is not
> > interesting either so NVMe is perfectly fine. Developers innovate
> > in filesystems instead.
> >
> > In networking we have strong standards so you can (and do) write
> > open source software all the way down to the PHYs (serdes is where
> > things get quite tricky). At the same time movement of data from
> > point a to point b is _the_ problem so we need the ability to
> > innovate in the transport space.
> > 
> > Now we have strayed quite far from the initial problem under
> > discussion, but you can't say "networking is just like storage" and
> > not expect a tirade from a networking guy :-D   
> 
> Heh, well, I don't agree with your characterization - from an open
> source perspective I wouldn't call any FW "uninteresting", and the
> storage device SW internals are super interesting/complicated and full
> of incredible innovation.

That's not what I said. I said movement of data i.e. the device
interface (NVMe) is not interesting.

FW would be interesting. But AFAIU the FW is not open because there was
no "insertion point" for the community to start hacking. I am very glad
that you think all FW is interesting. In my previous job we were able
to open source the FW the device was running, including the
ahead-of-its-time BPF offload: https://github.com/Netronome/nic-firmware
Should I be looking forward to open source FW coming out of nVidia? :)

> Even PHYs, at slow speeds, are mostly closed FW running in proprietary
> DSPs. netdev has a line they want to innovate at the packet level, but
> everything underneath is still basically closed/proprietary.

Yes, that is what I said, serdes and down.

> I think that is great for netdev, but moving the line one OSI level
> higher doesn't suddenly create an open source problem either, IMHO.

Open source problem? Mis-worded perhaps?

> > > The standards being implemented broadly require the use of the
> > > APIs - particularly the shared IP address.  
> > 
> > No point talking about IP addresses, that ship has sailed.
> > I bet the size of both communities was also orders of magnitude
> > smaller back then. Different conditions different outcomes.  
> 
> So, like I said, IP comes with baggage. Where do you draw the line?
> What facets of the IP are we allowed to mirror and what are not? How
> are you making this seemingly arbitrary decision?

I have some heuristics I use, but I don't really want to be in the
defensive position forever. You suggest something, please.

> The ipsec patches here have almost 0 impact on netdev because it is a
> tiny steering engine configuration. I'd have more sympathy to the
> argument if it was consuming a huge API surface to do this.

The existence of the full IPsec offload in its entirety is questionable.
We let the earlier patches in trusting that you'll deliver the
forwarding support. We're calling "stop" here because when the patches
from this PR were posted to the list we learned for the first time
that the forwarding is perhaps less real than expected.

> > We don't support black-box transport offloads in netdev. I thought
> > that it'd come across but maybe I should spell it out - just
> > because you are welcome in Linux does not mean RDMA devices are
> > welcome in netdev.  
> 
> Which is why they are not in netdev :) Nobody doubts this.
> 
> > As much as we got distracted by our ideological differences over the
> > course of this thread - the issue is that I believe we had an
> > agreement which was not upheld.
> >
> > I thought we compromised that to make the full offload sensible in
> > netdev world nVidia would implement forwarding to xfrm tunnels
> > using tc rules. You want to add a feature in netdev, it needs to be
> > usable in a non-trivial way in netdev. Seems fair.  
> 
> Yes, and it is on Leon's work list. Notice Leon didn't do this RDMA
> IPSEC patches. This is a huge journey for us, there are lots of parts
> and several people working on it.
> 
> I understood the agreement was that we would do it, not that it done
> as the very next thing. Stephen also asked for stuff and Leon is
> working on that too.
> 
> > The simplest way forward would be to commit to when mlx5 will
> > support redirects to xfrm tunnel via tc...  
> 
> He needs to fix the bugs he created and found first :)
> 
> As far as I'm concerned TC will stay on his list until it is done.

This is what I get for trusting a vendor :/

If you can't make a commitment my strong recommendation is for this code
to not be accepted upstream until TC patches emerge.
