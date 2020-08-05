Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E20123CBF2
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHEQDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:03:35 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46760 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725920AbgHEPti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 11:49:38 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 075FYWoS027613
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Aug 2020 11:34:33 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9720B420263; Wed,  5 Aug 2020 11:34:32 -0400 (EDT)
Date:   Wed, 5 Aug 2020 11:34:32 -0400
From:   tytso@mit.edu
To:     Willy Tarreau <w@1wt.eu>
Cc:     Marc Plumb <lkml.mplumb@gmail.com>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200805153432.GE497249@mit.edu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805024941.GA17301@1wt.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 04:49:41AM +0200, Willy Tarreau wrote:
> 
> Not only was this obviously not the goal, but I'd be particularly
> interested in seeing this reality demonstrated, considering that
> the whole 128 bits of fast_pool together count as a single bit of
> entropy, and that as such, even if you were able to figure the
> value of the 32 bits leaked to net_rand_state, you'd still have to
> guess the 96 other bits for each single entropy bit :-/

Not only that, you'd have to figure out which 32-bits in the fast_pool
actually had gotten leaked to the net_rand_state.

I agree with Willy that I'd love to see an exploit since it would
probably give a lot of insights.  Maybe at a Crypto rump session once
it's safe to have those sorts of things again.  :-)

That being said, it certainly is a certificational / theoretical
weakness, and if the bright boys and girls at Fort Meade did figure
out a way to exploit this, they are very much unlikely to share it at
an open Crypto conference.  So replacing LFSR-based PRnG with
something stronger which didn't release any bits from the fast_pool
would certainly be desireable, and I look forward to seeing what Willy
has in mind.

Cheers,

					- Ted
