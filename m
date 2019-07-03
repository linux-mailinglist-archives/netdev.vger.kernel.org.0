Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A315E853
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfGCQBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfGCQBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 12:01:40 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A821F2189E;
        Wed,  3 Jul 2019 16:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562169699;
        bh=sEHptRbLdsEYKSwjvY3/qz3IvFgJjdcb8qCsSzdw0vY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CR/aA+HR1zGuRCS/ctRotaVzni53LoFZ77UI7OI9cYOVYeUKMDl3Ed1l2w3VRH9EZ
         MYVEp+cWb34lbTInhOsRIKWeByf8P2aSr02Akc0V4iC76iRrlxqTmKFkMVKaTl+Cxh
         f5/Tput0fGNikRUjsD6//pJ98OcGBcTLCjfz48So=
Date:   Wed, 3 Jul 2019 09:01:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        bpf@vger.kernel.org,
        syzbot <syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com>
Subject: Re: [net/tls] Re: KMSAN: uninit-value in aesti_encrypt
Message-ID: <20190703160137.GB21629@sol.localdomain>
References: <000000000000a97a15058c50c52e@google.com>
 <20190627164627.GF686@sol.localdomain>
 <5d1508c79587a_e392b1ee39f65b45b@john-XPS-13-9370.notmuch>
 <20190627190123.GA669@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627190123.GA669@sol.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 12:01:23PM -0700, Eric Biggers wrote:
> On Thu, Jun 27, 2019 at 11:19:51AM -0700, John Fastabend wrote:
> > Eric Biggers wrote:
> > > [+TLS maintainers]
> > > 
> > > Very likely a net/tls bug, not a crypto bug.
> > > 
> > > Possibly a duplicate of other reports such as "KMSAN: uninit-value in gf128mul_4k_lle (3)"
> > > 
> > > See https://lore.kernel.org/netdev/20190625055019.GD17703@sol.localdomain/ for
> > > the list of 17 other open syzbot bugs I've assigned to the TLS subsystem.  TLS
> > > maintainers, when are you planning to look into these?
> > > 
> > > On Thu, Jun 27, 2019 at 09:37:05AM -0700, syzbot wrote:
> > 
> > I'm looking at this issue now. There is a series on bpf list now to address
> > many of those 17 open issues but this is a separate issue. I can reproduce
> > it locally so should have a fix soon.
> > 
> 
> Okay, great!  However, just to clarify, the 17 syzbot bugs I assigned to TLS are
> in addition to the 30 I assigned to BPF
> (https://lore.kernel.org/lkml/20190624050114.GA30702@sol.localdomain/).
> (Well, since I sent that it's actually up to 35 now.)
> 
> I do expect most of these are duplicates, so when you are fixing the bugs, it
> would be really helpful (for everyone, including you in the future :-) ) if you
> would include the corresponding Reported-by syzbot line for *every* syzbot
> report you think is addressed, so they get closed.
> 

Hi John, there's no activity on your patch thread
(https://lore.kernel.org/bpf/5d1507e7b3eb6_e392b1ee39f65b463@john-XPS-13-9370.notmuch/T/#t)
this week yet, nor do the patches seem to be applied anywhere.  What is the ETA
on actually fixing the bug(s)?  There are now like 20 syzbot reports for
seemingly the same bug, since it's apparently causing massive memory corruption;
and this is wasting a lot of other kernel developers' time.  This has been going
on for over a month; any reason why it's taking so long to fix?

Also, have you written a regression test for this bug so it doesn't happen
again?

- Eric
