Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA641F8B57
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgFNXem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:34:42 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:60206 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgFNXel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 19:34:41 -0400
X-Greylist: delayed 13996 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2020 19:34:40 EDT
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id D5E8B1B599B;
        Sun, 14 Jun 2020 23:34:34 +0000 (UTC)
Subject: Re: Good idea to rename files in include/uapi/ ?
To:     Jan Engelhardt <jengelh@inai.de>,
        David Howells <dhowells@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
 <174102.1592165965@warthog.procyon.org.uk>
 <nycvar.YFH.7.77.849.2006142244200.30230@n3.vanv.qr>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <ab88e504-c139-231a-0294-953ffd1a9442@al2klimov.de>
Date:   Mon, 15 Jun 2020 01:34:33 +0200
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.77.849.2006142244200.30230@n3.vanv.qr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
X-Spam-Level: **
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 14.06.20 um 23:08 schrieb Jan Engelhardt:
> 
> On Sunday 2020-06-14 22:19, David Howells wrote:
>> Alexander A. Klimov <grandmaster@al2klimov.de> wrote:
>>
>>> *Is it a good idea to rename files in include/uapi/ ?*
>>
>> Very likely not.  If programs out there are going to be built on a
>> case-sensitive filesystem (which happens all the time), they're going to break
>> if you rename the headers.  We're kind of stuck with them.
> 
> Netfilter has precedent for removing old headers, e.g.
> 7200135bc1e61f1437dc326ae2ef2f310c50b4eb's ipt_ULOG.h.
> 
> Even if kernels would not remove such headers, the iptables userspace
> code wants to be buildable with all kinds of kernels, including past
> releases, which do not have modern headers like xt_l2tp.h.
> 
> The mantra for userspace programs is therefore "copy the headers" —
> because you never know what /usr/include/linux you get. iptables and
> iproute2 are two example codebases that employ this. And when headers
> do get copied, header removals from the kernel side are no longer a
Absolutely correct, "*when* headers do get copied ..."

> big deal either.
> 
> A header file rename is no problem. We even have dummy headers
Hmm.. if I understand all of you correctly, David, Stefano, Pablo and Al 
say like no, not a good idea, but only you, Jan, say like should be no 
problem.

Jan, do you have anything like commit messages in mainline or public 
emails from maintainers confirming your opinion?
What exactly makes you sure that Torvalds, the #1 protector of the 
userspace, would tolerate a such patch from me?
Yes, it would break the A*P*I, and not the A*B*I, but who knows..

> already because of this... or related changes. Just look at
> xt_MARK.h, all it does is include xt_mark.h. Cf.
> 28b949885f80efb87d7cebdcf879c99db12c37bd .
> 
> The boilerplate for xt_*h is quite high thanks to the miniscule
> splitting of headers. Does not feel right in this day and age.
> 
