Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B857447E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 06:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389764AbfGYEkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 00:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389297AbfGYEkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 00:40:35 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD337218DA;
        Thu, 25 Jul 2019 04:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564029634;
        bh=wcwG4pMAinnKbG7g0QnFfuSmByspa9vQBYKTGDgSLfg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=n+AtQlS8DgC2uB6+dqe/2ZEDwF3+o+vdoXUv6KtJTv0AHp/MSsnvsCcDfXcSgDSJ0
         OZ1T+sQ4jg8/TT3FFRy3w1cHk2dwBj39FE36wLS5wiziIl7JgMc9dHmUmSikmOUe9r
         sCoBZxU4mgjtSWFIDDM8CtUgykz6sKZnNU0bMEBM=
Date:   Wed, 24 Jul 2019 21:40:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        dvyukov@google.com, netdev@vger.kernel.org, fw@strlen.de,
        i.maximets@samsung.com, edumazet@google.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
Message-ID: <20190725044032.GB677@sol.localdomain>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        dvyukov@google.com, netdev@vger.kernel.org, fw@strlen.de,
        i.maximets@samsung.com, edumazet@google.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
 <20190724.130928.1854327585456756387.davem@davemloft.net>
 <20190725033913.GB13651@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725033913.GB13651@mit.edu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:39:13PM -0400, Theodore Y. Ts'o wrote:
> On Wed, Jul 24, 2019 at 01:09:28PM -0700, David Miller wrote:
> > From: Eric Biggers <ebiggers@kernel.org>
> > Date: Wed, 24 Jul 2019 11:37:12 -0700
> > 
> > > We can argue about what words to use to describe this situation, but
> > > it doesn't change the situation itself.
> > 
> > And we should argue about those words because it matters to humans and
> > effects how they feel, and humans ultimately fix these bugs.
> > 
> > So please stop with the hyperbole.
> 
> Perhaps it would be better to call them, "syzbot reports".  Not all
> syzbot reports are bugs.  In fact, Dmitry has steadfastly refused to
> add features which any basic bug-tracking system would have, claiming
> that syzbot should not be a bug-tracking system, and something like
> bugzilla should be forcibly imposed on all kernel developers.  So I
> don't consider syzkaller reports as bugs --- they are just reports.
> 
> In order for developers to want to engage with "syzbot reports", we
> need to reduce developer toil which syzbot imposes on developers, such
> that it is a net benefit, instead of it being just a source of
> annoying e-mails, some of which are actionable, and some of which are
> noise.
> 
> In particular, asking developers to figure out which syzbot reports
> should be closed, because developers found the problem independently,
> and fixed it without hearing about from syzbot first, really isn't a
> fair thing to ask.  Especially if we can automate away the problem.
> 
> If there is a reproducer, it should be possible to automatically
> categorize the reproducer as a reliable reproducer or a flakey one.
> If it is a reliable reproducer on version X, and it fails to be
> reliably reproduce on version X+N, then it should be able to figure
> out that it has been fixed, instead of requesting that a human confirm
> it.  If you really want a human to look at it, now that syzkaller has
> a bisection feature, it should be possible to use the reliable
> reproducer to do a negative bisection search to report a candidate
> fix.  This would significantly reproduce the developer toil imposed as
> a tax on developers.  And if Dmitry doesn't want to auto-close those
> reports that appear to be fixed already, at the very least they should
> be down-prioritized on Eric's reports, so people who don't want to
> waste their time on "bureaucracy" can do so.
> 
> Cheers,
> 
> 						- Ted
> 
> P.S.  Another criteria I'd suggest down-prioritizing on is, "does it
> require root privileges?"  After all, since root has so many different
> ways of crashing a system already, and if we're all super-busy, we
> need to prioritize which reports should be addressed first.
> 

I agree with all this.  Fix bisection would be really useful.  I think what we'd
actually need to do to get decent results, though, is consider many different
signals (days since last occurred, repro type, fix bisected, bug bisected,
occurred in mainline or not, does the repro work as root, is it clearly a "bad"
bug like use-after-free, etc.) and compute an appropriate timeout based on that.

However, I'd like to emphasize that in my reminder emails, I've *already*
considered many of these factors when sorting the bug reports, and in particular
the bugs/reports that have been seen recently are strongly weighted towards
being listed first, especially if they were seen in mainline.  In this
particular reminder email, for example, the first 18 bugs/reports have *all*
been seen in the last 4 days.

These first 18 bugs/reports are ready to be worked on and fixed now.  It's
unclear to me what is most impeding this.  Is it part of the syzbot process?
Bad reproducers?  Too much noise?  Or is it no funding?  Not enough qualified
people?  No maintainers?  Not enough reminders?  Lack of CVEs and demonstrable
exploits?  What is most impeding these 18 bugs from being fixed?

- Eric
