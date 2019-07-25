Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864D574409
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 05:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389871AbfGYDjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 23:39:33 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36426 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389704AbfGYDjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 23:39:32 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x6P3dEh0019029
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 23:39:15 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id EEF544202F5; Wed, 24 Jul 2019 23:39:13 -0400 (EDT)
Date:   Wed, 24 Jul 2019 23:39:13 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     David Miller <davem@davemloft.net>
Cc:     ebiggers@kernel.org, eric.dumazet@gmail.com, dvyukov@google.com,
        netdev@vger.kernel.org, fw@strlen.de, i.maximets@samsung.com,
        edumazet@google.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
Message-ID: <20190725033913.GB13651@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        David Miller <davem@davemloft.net>, ebiggers@kernel.org,
        eric.dumazet@gmail.com, dvyukov@google.com, netdev@vger.kernel.org,
        fw@strlen.de, i.maximets@samsung.com, edumazet@google.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
 <20190724.130928.1854327585456756387.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724.130928.1854327585456756387.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 01:09:28PM -0700, David Miller wrote:
> From: Eric Biggers <ebiggers@kernel.org>
> Date: Wed, 24 Jul 2019 11:37:12 -0700
> 
> > We can argue about what words to use to describe this situation, but
> > it doesn't change the situation itself.
> 
> And we should argue about those words because it matters to humans and
> effects how they feel, and humans ultimately fix these bugs.
> 
> So please stop with the hyperbole.

Perhaps it would be better to call them, "syzbot reports".  Not all
syzbot reports are bugs.  In fact, Dmitry has steadfastly refused to
add features which any basic bug-tracking system would have, claiming
that syzbot should not be a bug-tracking system, and something like
bugzilla should be forcibly imposed on all kernel developers.  So I
don't consider syzkaller reports as bugs --- they are just reports.

In order for developers to want to engage with "syzbot reports", we
need to reduce developer toil which syzbot imposes on developers, such
that it is a net benefit, instead of it being just a source of
annoying e-mails, some of which are actionable, and some of which are
noise.

In particular, asking developers to figure out which syzbot reports
should be closed, because developers found the problem independently,
and fixed it without hearing about from syzbot first, really isn't a
fair thing to ask.  Especially if we can automate away the problem.

If there is a reproducer, it should be possible to automatically
categorize the reproducer as a reliable reproducer or a flakey one.
If it is a reliable reproducer on version X, and it fails to be
reliably reproduce on version X+N, then it should be able to figure
out that it has been fixed, instead of requesting that a human confirm
it.  If you really want a human to look at it, now that syzkaller has
a bisection feature, it should be possible to use the reliable
reproducer to do a negative bisection search to report a candidate
fix.  This would significantly reproduce the developer toil imposed as
a tax on developers.  And if Dmitry doesn't want to auto-close those
reports that appear to be fixed already, at the very least they should
be down-prioritized on Eric's reports, so people who don't want to
waste their time on "bureaucracy" can do so.

Cheers,

						- Ted

P.S.  Another criteria I'd suggest down-prioritizing on is, "does it
require root privileges?"  After all, since root has so many different
ways of crashing a system already, and if we're all super-busy, we
need to prioritize which reports should be addressed first.
