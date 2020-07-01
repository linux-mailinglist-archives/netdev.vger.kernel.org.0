Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEC0210224
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgGACjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:39:17 -0400
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:46382 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726874AbgGACjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 22:39:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 1BE6B100E7B43;
        Wed,  1 Jul 2020 02:39:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2897:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21627:30012:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: toad01_1017c2226e7d
X-Filterd-Recvd-Size: 2160
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Wed,  1 Jul 2020 02:39:14 +0000 (UTC)
Message-ID: <e49592775b3886ed80122ede38feab198e3ca517.camel@perches.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
From:   Joe Perches <joe@perches.com>
To:     Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Date:   Tue, 30 Jun 2020 19:39:13 -0700
In-Reply-To: <CANn89iLKZQAtpejcLHmOu3dsrGf5eyFfHc8JqoMNYisRPWQ8kQ@mail.gmail.com>
References: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
         <20200701020211.GA6875@gondor.apana.org.au>
         <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com>
         <20200701022241.GA7167@gondor.apana.org.au>
         <CANn89iLKZQAtpejcLHmOu3dsrGf5eyFfHc8JqoMNYisRPWQ8kQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-30 at 19:30 -0700, Eric Dumazet wrote:
> On Tue, Jun 30, 2020 at 7:23 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Tue, Jun 30, 2020 at 07:17:46PM -0700, Eric Dumazet wrote:
> > > The main issue of the prior code was the double read of key->keylen in
> > > tcp_md5_hash_key(), not that few bytes could change under us.
> > > 
> > > I used smp_rmb() to ease backports, since old kernels had no
> > > READ_ONCE()/WRITE_ONCE(), but ACCESS_ONCE() instead.
> > 
> > If it's the double-read that you're protecting against, you should
> > just use barrier() and the comment should say so too.
> 
> I made this clear in the changelog, do we want comments all over the places ?

Having to run git for every line of code isn't great.

Comments in code is better than comments in changelogs.


