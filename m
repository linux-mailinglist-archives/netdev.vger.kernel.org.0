Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A04C23F94F
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 00:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgHHW2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 18:28:15 -0400
Received: from mx.sdf.org ([205.166.94.24]:64293 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgHHW2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 18:28:15 -0400
Received: from sdf.org (IDENT:lkml@sdf.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 078MRrWo002980
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 8 Aug 2020 22:27:53 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 078MRqY8015003;
        Sat, 8 Aug 2020 22:27:52 GMT
Date:   Sat, 8 Aug 2020 22:27:52 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808222752.GG27941@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200808174451.GA7429@1wt.eu>
 <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
 <20200808204729.GD27941@SDF.ORG>
 <CAHk-=whU-3rEAY551DeDsuVsZgLXyq37JX1kCvDzQFnuKzUXew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whU-3rEAY551DeDsuVsZgLXyq37JX1kCvDzQFnuKzUXew@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 01:52:37PM -0700, Linus Torvalds wrote:
> On Sat, Aug 8, 2020 at 1:47 PM George Spelvin <lkml@sdf.org> wrote:
>> I *just* finished explaining, using dribs and drabs of entropy allows an
>> *information theoretical attack* which *no* crypto can prevent.
> 
> The key word here being "theoretical".
> 
> The other key word is "reality".
> 
> We will have to agree to disagree. I don't _care_ about the
> theoretical holes. I care about the real ones.

It's not a theoretical hole, it's a very real one.  Other than the cycles 
to do the brute-force part, it's not even all that complicated.  The 
theory part is that it's impossible to patch.

*If* you do the stupid thing.  WHICH YOU COULD JUST STOP DOING.

> We plugged a real one. Deal with it.

The explain it to me.  What is that actual *problem*?  Nobody's described 
one, so I've been guessing.  What is this *monumentally stupid* abuse of 
/dev/random allegedly fixing?

If you're not an idiot, explain.

Because right now you sound like one.  There's a simple and easy fix which 
I've described and will get back to implementing as soon as I've finished 
yelling at you.  What, FFS, is your objection to considering it?

I'm trying to implement a solution that satisfies everyone's requirements 
*including* the absence of catastrophic security holes.  If there's some 
requirement I'm not satisfying, please tell me.  Just please don't say "I 
prefer doing the stupid thing to changing my mind."  I hear enough of that 
on the news.

I can deal with it *personally* by patching it out of my private kernels, 
but I'd really rather it doesn't get deployed to a billion devices before 
someone exploits it.
