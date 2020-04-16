Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85BF1ACBDC
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896182AbgDPNaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896143AbgDPNaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6281217D8;
        Thu, 16 Apr 2020 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043802;
        bh=NITykfahClNeh2m2TORyK2cL4gxW2DmNjs/qeO0kVnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIFZn14rdYCx4dFnyL+zNGPkc2AZASBRY+4Vcb/NrqpwQkkWPH9CZWZbxDkFUt7HT
         l1LiBTzdYl69rgBT2eS2Ot8hrVNagHHoj2EDFRPKW2pXszI4uB4+oGtArz+cEgV6Pz
         gxpOijiKZbHPjzKRe65g8HGuy/O3/h5JaXWPZxSc=
Date:   Thu, 16 Apr 2020 09:30:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416133001.GK1068@sasha-vm>
References: <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
 <20200416052409.GC1309273@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200416052409.GC1309273@unreal>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 08:24:09AM +0300, Leon Romanovsky wrote:
>On Thu, Apr 16, 2020 at 04:08:10AM +0000, Saeed Mahameed wrote:
>> On Wed, 2020-04-15 at 20:00 -0400, Sasha Levin wrote:
>> > On Wed, Apr 15, 2020 at 05:18:38PM +0100, Edward Cree wrote:
>> > > Firstly, let me apologise: my previous email was too harsh and too
>> > >  assertiveabout things that were really more uncertain and unclear.
>> > >
>> > > On 14/04/2020 21:57, Sasha Levin wrote:
>> > > > I've pointed out that almost 50% of commits tagged for stable do
>> > > > not
>> > > > have a fixes tag, and yet they are fixes. You really deduce
>> > > > things based
>> > > > on coin flip probability?
>> > > Yes, but far less than 50% of commits *not* tagged for stable have
>> > > a fixes
>> > >  tag.  It's not about hard-and-fast Aristotelian "deductions", like
>> > > "this
>> > >  doesn't have Fixes:, therefore it is not a stable candidate", it's
>> > > about
>> > >  probabilistic "induction".
>> > >
>> > > > "it does increase the amount of countervailing evidence needed to
>> > > > conclude a commit is a fix" - Please explain this argument given
>> > > > the
>> > > > above.
>> > > Are you familiar with Bayesian statistics?  If not, I'd suggest
>> > > reading
>> > >  something like http://yudkowsky.net/rational/bayes/ which explains
>> > > it.
>> > > There's a big difference between a coin flip and a _correlated_
>> > > coin flip.
>> >
>> > I'd maybe point out that the selection process is based on a neural
>> > network which knows about the existence of a Fixes tag in a commit.
>> >
>> > It does exactly what you're describing, but also taking a bunch more
>> > factors into it's desicion process ("panic"? "oops"? "overflow"?
>> > etc).
>> >
>>
>> I am not against AUTOSEL in general, as long as the decision to know
>> how far back it is allowed to take a patch is made deterministically
>> and not statistically based on some AI hunch.
>>
>> Any auto selection for a patch without a Fixes tags can be catastrophic
>> .. imagine a patch without a Fixes Tag with a single line that is
>> fixing some "oops", such patch can be easily applied cleanly to stable-
>> v.x and stable-v.y .. while it fixes the issue on v.x it might have
>> catastrophic results on v.y ..
>
>I tried to imagine such flow and failed to do so. Are you talking about
>anything specific or imaginary case?

It happens, rarely, but it does. However, all the cases I can think of
happened with a stable tagged commit without a fixes where it's backport
to an older tree caused unintended behavior (local denial of service in
one case).

The scenario you have in mind is true for both stable and non-stable
tagged patches, so it you want to restrict how we deal with commits that
don't have a fixes tag shouldn't it be true for *all* commits?

><...>
>> >
>> > Let me put my Microsoft employee hat on here. We have
>> > driver/net/hyperv/
>> > which definitely wasn't getting all the fixes it should have been
>> > getting without AUTOSEL.
>> >
>>
>> until some patch which shouldn't get backported slips through, believe
>> me this will happen, just give it some time ..
>
>Bugs are inevitable, I don't see many differences between bugs
>introduced by manually cherry-picking or automatically one.

Oh bugs slip in, that's why I track how many bugs slipped via stable
tagged commits vs non-stable tagged ones, and the statistic may surprise
you.

The solution here is to beef up your testing infrastructure rather than
taking less patches; we still want to have *all* the fixes, right?

>Of course, it is true if this automatically cherry-picking works as
>expected and evolving.
>
>>
>> > While net/ is doing great, drivers/net/ is not. If it's indeed
>> > following
>> > the same rules then we need to talk about how we get done right.
>> >
>>
>> both net and drivers/net are managed by the same maitainer and follow
>> the same rules, can you elaborate on the difference ?
>
>The main reason is a difference in a volume between net and drivers/net.
>While net/* patches are watched by many eyes and carefully selected to be
>ported to stable@, most of the drivers/net patches are not.
>
>Except 3-5 the most active drivers, rest of the driver patches almost never
>asked to be backported.

Right, that's exactly my point: If you're not Mellanox, e1000*, etc you
won't see it, but the smaller drivers aren't getting the same handling
as the big ones.

I think that we all love the work DaveM does with net/ - it makes our
lives a lot easier, and if the same thing would happen with drivers/net/
I'll happily go away and never AUTOSEL a *net* commit, but looking at
how our Hyper-V drivers look like it's clearly not there yet.

-- 
Thanks,
Sasha
