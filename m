Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB892FA979
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407824AbhARS7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393762AbhARS5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 13:57:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9BBA206D4;
        Mon, 18 Jan 2021 18:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610996219;
        bh=1vTCgBc1BfZgrY9vBQmTci420oqBaiYrPXOzp8GSXMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vGUV0zspjru7umtHIEWI/xL6U4S4sZMThQ6igSQNpE9rlOWjW3M5GVdQlolkpc8NK
         V4y/lXTeajijAH0Q8Hi+EA1BStocThB/v7j415mblTWY8y/9OnGVXVjPQdEnwtP/S7
         dS5fEJIghahrsP3ygdO4ZFKwfwSzfWkkqFuSSJ0Nn6LHHDFZkl1U+lr1MMyDEED14t
         K2B+771d/DRLVgROy9oBdfJo9ZtFyvg9h1Pt9OOZ5gt1CkerkcmJCx2fNlZzjDcRZu
         OhusiJgli/08WnmtnMRLrTJUBxyB6YlTQXrzoqdUZQ8+5+UEQL3yvZHz1PGjodULDM
         dv3tEZraOIqMA==
Date:   Mon, 18 Jan 2021 10:56:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Pravin B Shelar <pbshelar@fb.com>, netdev@vger.kernel.org,
        pablo@netfilter.org, laforge@gnumonks.org
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling
 API
Message-ID: <20210118105657.72d9a6fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fea30896-e296-5eb3-4202-05a6bf2c1e8e@norrbonn.se>
References: <20210110070021.26822-1-pbshelar@fb.com>
        <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
        <20210118092722.52c9d890@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fea30896-e296-5eb3-4202-05a6bf2c1e8e@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 19:27:53 +0100 Jonas Bonn wrote:
> On 18/01/2021 18:27, Jakub Kicinski wrote:
> > v5 itself was laying around on patchwork for almost a week, marked as
> > "Needs Review/Ack".  
> 
> When new series show up just hours after review, it's hard to take them 
> seriously.  It takes a fair amount of time to go through an elephant 
> like this and to make sense of it; the time spent in response to review 
> commentary shouldn't be less.

Agreed.

> > Normally we try to merge patches within two days. If anything my
> > lesson from this whole ordeal is in fact waiting longer makes
> > absolutely no sense. The review didn't come in anyway, and we're
> > just delaying whatever project Pravin needs this for :/  
> 
> I think the expectation that everything gets review within two days is 
> unrealistic. 

Right, it's perfectly fine to send an email saying "please wait, I'll
review it on $date".

> Worse though, is the insinuation that anything unreviewed 
> gets blindly merged...  No, the two day target should be for the merging 
> of ACK:ed patches.

Well, certainly, the code has to be acceptable to the person merging it.

Let's also remember that Pravin is quite a seasoned contributor.

> > Do I disagree with you that the patch is "far from pretty"? Not at all,
> > but I couldn't find any actual bug, and the experience of contributors
> > matters to us, so we can't wait forever.
> >   
> >> The following issues remain unaddressed after review:
> >>
> >> i)  the patch contains several logically separate changes that would be
> >> better served as smaller patches
> >> ii) functionality like the handling of end markers has been introduced
> >> without further explanation
> >> iii) symmetry between the handling of GTPv0 and GTPv1 has been
> >> unnecessarily broken
> >> iv) there are no available userspace tools to allow for testing this
> >> functionality  
> > 
> > I don't understand these points couldn't be stated on any of the last
> > 3 versions / in the last month.  
> 
> I believe all of the above was stated in review of series v1 and v2.  v3 
> was posted during the merge window so wasn't really relevant for review. 
>   v4 didn't address the comments from v1 and v2.  v5 was posted 3 hours 
> after receiving reverse christmas tree comments and addressed only 
> those.  v5 received commentary within a week... hardly excessive for a 
> lightly maintained module like this one.

Sorry, a week is far too long for netdev. If we were to wait that long
we'd have a queue of 300+ patches always hanging around.

> >> I have requested that this patch be reworked into a series of smaller
> >> changes.  That would allow:
> >>
> >> i) reasonable review
> >> ii) the possibility to explain _why_ things are being done in the patch
> >> comment where this isn't obvious (like the handling of end markers)
> >> iii) the chance to do a reasonable rebase of other ongoing work onto
> >> this patch (series):  this one patch is invasive and difficult to rebase
> >> onto
> >>
> >> I'm not sure what the hurry is to get this patch into mainline.  Large
> >> and complicated patches like this take time to review; please revert
> >> this and allow that process to happen.  
> > 
> > You'd need to post a revert with the justification to the ML, so it can
> > be reviewed on its merits. That said I think incremental changes may be
> > a better direction.
> 
> I guess I'll have to do so, but that seems like setting the bar higher 
> than for even getting the patch in in the first place.
> 
> I don't think it's tenable for patches to sneak in because they are so 
> convoluted that the maintainers just can't find the energy to review 
> them.  I'd say that the maintainers silence on this particular patch 
> speaks volumes in itself.

Sadly most maintainers are not particularly dependable, so we can't
afford to make that the criteria.

I have also pinged for reviews on v4 and nobody replied.

> Sincerely frustrated because rebasing my IPv6 series on top of this mess 
> will take days,

I sympathize, perhaps we should document the expectations we have so
less involved maintainers know the expectations :(
