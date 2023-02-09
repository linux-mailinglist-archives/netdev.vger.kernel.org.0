Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BDC68FC08
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBIAgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBIAgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:36:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50B21042D;
        Wed,  8 Feb 2023 16:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39BA961835;
        Thu,  9 Feb 2023 00:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B129C433D2;
        Thu,  9 Feb 2023 00:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675902979;
        bh=H4MvkZOoKYJgCisttzOTiTmlGN7VAbZohVsTiQOqwKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EjxmHN3kPQo52M5MVlD0He4LK5Ky1bvnlVe+ucQCsbvqhSUtRAITtCmCjjWLB3K5t
         IeAj1pPpQa7oy37ZY029ySwQXp0IynhtjbiiCgeMtf43cBk6dCk3h2NPeZzDQwmWrc
         HfvdaJLwDD+eM3xkojmHDwzU97wxBusCR6BQ3f4pTWeG/1fWBglbdPliWoF+mgQOa/
         Z5/K7uteQ/SYN4GG6V1ZmF/ShuLDcpBQsJqev26I/OrUIo9yfwtIh/0mzS44ZCITeV
         7+C7dRh8GKc0Zt3qNizeeXNlhOti2J1ADYrEJnY2Ve9wPnS2F3fJhocdjfTUcIYxSa
         KW3MI7VaDxhRQ==
Date:   Wed, 8 Feb 2023 16:36:18 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y+RAAowqXn1JmMY4@x130>
References: <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
 <Y92kaqJtum3ImPo0@nvidia.com>
 <20230203174531.5e3d9446@kernel.org>
 <Y+EVsObwG4MDzeRN@nvidia.com>
 <20230206163841.0c653ced@kernel.org>
 <Y+KsG1zLabXexB2k@nvidia.com>
 <20230207140330.0bbb92c3@kernel.org>
 <Y+PKDOyUeU/GwA3W@nvidia.com>
 <20230208151922.3d2d790d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230208151922.3d2d790d@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Feb 15:19, Jakub Kicinski wrote:
>On Wed, 8 Feb 2023 12:13:00 -0400 Jason Gunthorpe wrote:
>> On Tue, Feb 07, 2023 at 02:03:30PM -0800, Jakub Kicinski wrote:
>> > > I also would like to not discuss this :)
>> >
>> > Well, then... Suggest a delineation or a way forward if you don't like
>> > mine. The circular conversation + RDMA gets its way has to end sooner
>> > or later.
>>
>> I can't accept yours because it means RDMA stops existing. So we must
>> continue with what has been done for the last 15 years - RDMA
>> (selectively) mirrors the IP and everything running at or below the IP
>> header level.
>
>Re-implement bits you need for configuration, not stop existing.
>

Why ?? we will end up with the same code in this PULL plus some redundant
rdma API, please see explanation below.

>> > > An open source kernel implementation of a private standard for HW that
>> > > only one company can purchase that is only usable with a proprietary
>> > > userspace. Not exactly what I'd like to see.
>> >
>> > You switched your argument 180 degrees.
>> >
>> > Fist you said:
>> >
>> >   What you posted about your goals for netdev is pretty consistent with
>> >   the typical approach from a hyperscaler purchasing department: Make it
>> >   all the same. Grind the competing vendors on price.
>> >
>> > So "Make it all the same". Now you're saying hyperscalers have their
>> > own standards.
>>
>> What do you mean? "make it all the same" can be done with private or
>> open standards?
>
>Oh. If it's someone private specs its probably irrelevant to the open
>source community?
>
>> > > Ah, I stumble across stuff from time to time - KVM and related has
>> > > some interesting things. Especially with this new confidential compute
>> > > stuff. AMD just tried to get something into their mainline iommu
>> > > driver to support their out of tree kernel, for instance.
>> > >
>> > > People try to bend the rules all the time.
>> >
>> > AMD is a vendor, tho, you said "trend of large cloud operators pushing
>> > things into the kernel". I was curious to hear the hyperscaler example
>> > 'cause I'd like to be vigilant.
>>
>> I'm looking at it from the perspective of who owns, operates and
>> monetizes the propritary close source kernel fork. It is not AMD.
>>
>> AMD/Intel/ARM provided open patches to a hyperscaler(s) for their CC
>> solutions that haven't been merged yet. The hyperscaler is the one
>> that forked Linux into closed source, integrated them and is operating
>> the closed solution.
>>
>> That the vendor pushes little parts of the hyperscaler solution to the
>> kernel & ecosystem in a trickle doesn't make the sad state of affairs
>> exclusively the vendors fault, even if their name is on the patches,
>> IMHO.
>
>Sad situation. Not my employer and not in netdev, I hope.
>I may have forgotten already what brought us down this rabbit hole...
>
>> > > The ipsec patches here have almost 0 impact on netdev because it is a
>> > > tiny steering engine configuration. I'd have more sympathy to the
>> > > argument if it was consuming a huge API surface to do this.
>> >
>> > The existence of the full IPsec offload in its entirety is questionable.
>> > We let the earlier patches in trusting that you'll deliver the
>> > forwarding support. We're calling "stop" here because when the patches
>> > from this PR were posted to the list we learned for the first time
>> > that the forwarding is perhaps less real than expected.
>>
>> ipsec offload works within netdev for non switch use cases fine. I
>> would think that alone is enough to be OK for netdev.
>>
>> I have no idea how you are jumping to some conclusion that since the
>> RDMA team made their patches it somehow has anything to do with the
>> work Leon and the netdev team will deliver in future?
>
>We shouldn't reneg what was agreed on earlier.
>
>> > > He needs to fix the bugs he created and found first :)
>> > >
>> > > As far as I'm concerned TC will stay on his list until it is done.
>> >
>> > This is what I get for trusting a vendor :/
>> >
>> > If you can't make a commitment my strong recommendation is for this code
>> > to not be accepted upstream until TC patches emerge.
>>
>> This is the strongest commitment I am allowed to make in public.
>
>As priorities shift it may never happen.
>
>> I honestly have no idea why you are so fixated on TC, or what it has
>> to do with RDMA.
>
>It's a strong justification for having full xfrm offload.
>You can't forward without full offload.

This pull has nothing to do with "full" xfrm offload, 
For RoCE to exist it has to rely on netdev attributes, such as 
IP, vlan, mac, etc .. in this series we do the same for ipsec,
we setup the steering pipeline with the proper attributes for
RoCE to function.

I don't see it will be reasonable for the rdma user to setup these
attributes twice, once via netdev API and once via rdma APIs,
this will be torture for that user, just because rdma bits are not allowed
in netdev, it's exactly that, some rdma/roce bits purely mlx5_core logic,
and it has to be in mlx5_core due to the sharing of hardware resources
between rdma and netdev.

>Anything else could theoretically be improved on the SW side.
>The VF switching offload was the winning argument in the past
>discussion.
>
>> Hasn't our netdev team done enough work on TC stuff to earn some
>> faith that we do actually care about TC as part of our portfolio?
>
>Shouldn't have brought it up in the past discussion then :|
>Being asked to implement something tangential to your goals for
>the community to accept your code is hardly unheard of.
