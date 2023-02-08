Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B66168FB08
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBHXT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBHXT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:19:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1595A26B7;
        Wed,  8 Feb 2023 15:19:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A111061804;
        Wed,  8 Feb 2023 23:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC5EC433D2;
        Wed,  8 Feb 2023 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675898364;
        bh=ljJtmLj+jfDmiXRtLQ/OLV+zy7HbJNg4XPHu95w/4Ss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YtOqZACNsGX3pfnX+Z90UBxyU6awBMwkY89ozQpFb6BH2jScoT2OYY5gwN6Wq9Ndl
         0pXlQmfhEWwpfaaWD/nggv7bC6AdmWuRExwmdcQiOOnICfi5VHXVsfmXROYI+v9VQW
         /OlY5rgcPO03cpKy+VipSOqSEON0wpCGqvpmg3Kccg81EZFWxTMVmy9EC/Asz1LcJj
         rwus4Ekz3ep4Ssiz6ZDQlyjZYuPho4crl8Za+VNPkJupZ/zmOg0e9Ye0Qs2pNziGFN
         +flBgsHJRgL6hwCpnKq968SGZe/HxXpwwx5YFKDeX+Gu/xAb/jT9rJftwyi0UQxXkP
         4EOcn+EwHaLYA==
Date:   Wed, 8 Feb 2023 15:19:22 -0800
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
Message-ID: <20230208151922.3d2d790d@kernel.org>
In-Reply-To: <Y+PKDOyUeU/GwA3W@nvidia.com>
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
        <Y+PKDOyUeU/GwA3W@nvidia.com>
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

On Wed, 8 Feb 2023 12:13:00 -0400 Jason Gunthorpe wrote:
> On Tue, Feb 07, 2023 at 02:03:30PM -0800, Jakub Kicinski wrote:
> > > I also would like to not discuss this :)  
> > 
> > Well, then... Suggest a delineation or a way forward if you don't like
> > mine. The circular conversation + RDMA gets its way has to end sooner
> > or later.  
> 
> I can't accept yours because it means RDMA stops existing. So we must
> continue with what has been done for the last 15 years - RDMA
> (selectively) mirrors the IP and everything running at or below the IP
> header level.

Re-implement bits you need for configuration, not stop existing.

> > > An open source kernel implementation of a private standard for HW that
> > > only one company can purchase that is only usable with a proprietary
> > > userspace. Not exactly what I'd like to see.  
> > 
> > You switched your argument 180 degrees.
> > 
> > Fist you said:
> > 
> >   What you posted about your goals for netdev is pretty consistent with
> >   the typical approach from a hyperscaler purchasing department: Make it
> >   all the same. Grind the competing vendors on price.
> > 
> > So "Make it all the same". Now you're saying hyperscalers have their
> > own standards.  
> 
> What do you mean? "make it all the same" can be done with private or
> open standards?

Oh. If it's someone private specs its probably irrelevant to the open
source community?

> > > Ah, I stumble across stuff from time to time - KVM and related has
> > > some interesting things. Especially with this new confidential compute
> > > stuff. AMD just tried to get something into their mainline iommu
> > > driver to support their out of tree kernel, for instance.
> > > 
> > > People try to bend the rules all the time.  
> > 
> > AMD is a vendor, tho, you said "trend of large cloud operators pushing
> > things into the kernel". I was curious to hear the hyperscaler example
> > 'cause I'd like to be vigilant.  
> 
> I'm looking at it from the perspective of who owns, operates and
> monetizes the propritary close source kernel fork. It is not AMD.
> 
> AMD/Intel/ARM provided open patches to a hyperscaler(s) for their CC
> solutions that haven't been merged yet. The hyperscaler is the one
> that forked Linux into closed source, integrated them and is operating
> the closed solution.
> 
> That the vendor pushes little parts of the hyperscaler solution to the
> kernel & ecosystem in a trickle doesn't make the sad state of affairs
> exclusively the vendors fault, even if their name is on the patches,
> IMHO.

Sad situation. Not my employer and not in netdev, I hope.
I may have forgotten already what brought us down this rabbit hole...

> > > The ipsec patches here have almost 0 impact on netdev because it is a
> > > tiny steering engine configuration. I'd have more sympathy to the
> > > argument if it was consuming a huge API surface to do this.  
> > 
> > The existence of the full IPsec offload in its entirety is questionable.
> > We let the earlier patches in trusting that you'll deliver the
> > forwarding support. We're calling "stop" here because when the patches
> > from this PR were posted to the list we learned for the first time
> > that the forwarding is perhaps less real than expected.  
> 
> ipsec offload works within netdev for non switch use cases fine. I
> would think that alone is enough to be OK for netdev.
> 
> I have no idea how you are jumping to some conclusion that since the
> RDMA team made their patches it somehow has anything to do with the
> work Leon and the netdev team will deliver in future?

We shouldn't reneg what was agreed on earlier.

> > > He needs to fix the bugs he created and found first :)
> > > 
> > > As far as I'm concerned TC will stay on his list until it is done.  
> > 
> > This is what I get for trusting a vendor :/
> > 
> > If you can't make a commitment my strong recommendation is for this code
> > to not be accepted upstream until TC patches emerge.  
> 
> This is the strongest commitment I am allowed to make in public.

As priorities shift it may never happen.

> I honestly have no idea why you are so fixated on TC, or what it has
> to do with RDMA.

It's a strong justification for having full xfrm offload.
You can't forward without full offload.
Anything else could theoretically be improved on the SW side.
The VF switching offload was the winning argument in the past
discussion.

> Hasn't our netdev team done enough work on TC stuff to earn some
> faith that we do actually care about TC as part of our portfolio?

Shouldn't have brought it up in the past discussion then :|
Being asked to implement something tangential to your goals for 
the community to accept your code is hardly unheard of.
