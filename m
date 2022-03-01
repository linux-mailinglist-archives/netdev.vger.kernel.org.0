Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C428F4C8C95
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiCAN1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiCAN1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:27:31 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94769D4F3
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 05:26:48 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6D76820585;
        Tue,  1 Mar 2022 14:26:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FqC9JU2CNKYU; Tue,  1 Mar 2022 14:26:45 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7917F2052E;
        Tue,  1 Mar 2022 14:26:45 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 734CE80004A;
        Tue,  1 Mar 2022 14:26:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 1 Mar 2022 14:26:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Mar
 2022 14:26:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 683C23182EF0; Tue,  1 Mar 2022 14:26:44 +0100 (CET)
Date:   Tue, 1 Mar 2022 14:26:44 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: Re: Regression are sometimes merged slowly, maybe optimize the
 downstream interaction?
Message-ID: <20220301132644.GU1223722@gauss3.secunet.de>
References: <37349299-c47b-1f67-2229-78ae9b9b4488@leemhuis.info>
 <20220228094626.7e116e2c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <792b4bc3-af13-483f-0886-ea56da862172@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <792b4bc3-af13-483f-0886-ea56da862172@leemhuis.info>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:06:14AM +0100, Thorsten Leemhuis wrote:
> On 28.02.22 18:46, Jakub Kicinski wrote:
> > On Mon, 28 Feb 2022 14:45:47 +0100 Thorsten Leemhuis wrote:
> >>
> >> Or is there something like that already and the timing just has been bad
> >> a few times when I looked closer?
> > 
> > I think it's a particularly unfortunate time with a few "missed prs"
> > in a short span of time. When Dave was handling all the prs he used
> > to decide the timing based on contents of the tree, maybe that's 
> > a better model for prioritizing fixes getting to Linus, but I lack 
> > the skills necessary to make such calls.
> > 
> > I'll try to advertise the Wednesday rule more, 

I did not know that net pull requests always happen at Wednesdays,
it was always a bit unpredictable to me when that is going to happen.
Knowing about that would already improve the workflow.

> 
> Thx
> 
> > although creating
> > deadlines has proven to lead to rushed work. Which IMHO is much 
> > worse :(
> 
> Don't call it a deadline then. :-D But joking aside, I know what you
> mean, and yes, that is a reasonable concern.
> 
> Maybe one thing could help in here sometimes: if sub-tree maintainers
> with your permission ask Linus to pick up a single patch directly from a
> repo or a list, *if* there is a good reason to get a fix quickly merged.
> 
> > [...]
> > Anyway, thanks for raising the issue, and please keep us posted on how
> > things look from your perspective. It's a balancing act, it'd be great
> > if we can improve things over time without sudden changes.
> 
> Yeah, it's definitely a balancing act.
> 
> And as you asked for how things look from here, let me get back to the
> one issue I already briefly in my mail. To repeat a quote from above:
> 
> >> Often the fixes progress slowly due to the habits of the downstream
> >> maintainers -- some for example are imho not asking you often enough to
> >> pull fixes. I guess that might need to be discussed down the road as
> >> well, but there is something else that imho needs to be addressed first.
> 
> To give an example, but fwiw: that is in no way special, I've seen
> similar turn of events for a few other regressions fixes in sub-tree of
> net, so it really is just meant as an example for a general issue (sorry
> Steffen).

No problem.

> 
> See this fix:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=master&id=a6d95c5a628a09be129f25d5663a7e9db8261f51
> 
> The regression was introduced in 5.14-rc1 and the fix was posted on
> 2022-01-14, so 46 days ago.

Let me give some background on this issue. The PMTU handling with
for IPsec was basically broken forever in the one or the other
subtile way. One attempt to fix it was in 2012 with

commit 91657eafb64b4cb53ec3a2fbc4afc3497f735788
xfrm: take net hdr len into account for esp payload size calculation

nine years later Sabrina noticed that the above fix does not work
for IPv6 if the packet sizes are close to the minimum IPv6 MTU.

She tried to fix it with

commit b515d2637276a3810d6595e10ab02c13bfd0b63a
xfrm: xfrm_state_mtu should return at least 1280 for ipv6

Another year later Jiri noticed that this fix also works
only partially and added his fixes. And honestly, I'm not
sure if this is the end of the story.

This issue has already a long history and never really worked
for all corner cases. That's why I was not in hurry with it at
all.

Btw. how do you pick the regressions you are tracking? Why
this issue and not the many others?

What is the aim of your tracking? Is it to make sure a regression
fix will hit the manline, or/and the stable trees?

Just curious.

> 
> Jiri, who provided the patch, actually wrote "being a regression maybe
> we want the fastest track possible" here:
> https://lore.kernel.org/netdev/20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz/
> 
> Steffen applied the fix 27 days ago:
> https://lore.kernel.org/netdev/20220201064639.GS1223722@gauss3.secunet.de/
> 
> Three days later it was in -next. After some time I asked when it will
> get merged, to which Steffen replied "It will be merged with the next
> pull request for the ipsec tree that will happen likely next week."
> https://lore.kernel.org/regressions/20220216110252.GJ17351@gauss3.secunet.de/
> 
> He sent that PR on Friday, so the fix will finally be merged to mainline
> on Thursday. If Greg immediately picks it up after -rc7 the issue can
> finally get fixed in 5.15.y and 5.16.y mid next week -- more than 50
> days after the patch for the regression was posted.
> 
> Again: I had similar issues with the bluetooth maintainers and the
> wireless maintainers (the latter already seem to have slightly changed
> their workflow to improve things).
> 
> Anyway: sure, reviewing takes time and ideally every fix is in -next for
> a while, but I think 50 days is way too long.
> 
> Maybe sub-tree maintainers should send PRs more often? Or just tell you
> to directly pick up a fix once they reviewed them to avoid the sub-tree
> and a merge commits that brings in just one patch?

If the patches are applied to the ipsec tree they get much more testing
from our test environment before they move to the net and the mainline
tree. In case I apply an urgent patch, I do a pull request immediately.
But as said, I did not consider the above mentioned commit as too
urgent.

