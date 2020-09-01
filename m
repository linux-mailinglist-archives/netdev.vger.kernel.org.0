Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D43258EFB
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgIANTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:19:08 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:41229 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbgIANRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 09:17:11 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 081DGNvk001119;
        Tue, 1 Sep 2020 15:16:23 +0200
Date:   Tue, 1 Sep 2020 15:16:23 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tytso@mit.edu" <tytso@mit.edu>, Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
Message-ID: <20200901131623.GB1059@1wt.eu>
References: <20200901064302.849-1-w@1wt.eu>
 <20200901064302.849-2-w@1wt.eu>
 <b460c51a3fa1473b8289d6030a46abdb@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b460c51a3fa1473b8289d6030a46abdb@AcuMS.aculab.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 01:10:18PM +0000, David Laight wrote:
> From: Willy Tarreau
> > Sent: 01 September 2020 07:43
> ...
> > +/*
> > + *	Generate some initially weak seeding values to allow
> > + *	the prandom_u32() engine to be started.
> > + */
> > +static int __init prandom_init_early(void)
> > +{
> > +	int i;
> > +	unsigned long v0, v1, v2, v3;
> > +
> > +	if (!arch_get_random_long(&v0))
> > +		v0 = jiffies;
> 
> Isn't jiffies likely to be zero here?

I don't know. But do we really care ? I'd personally have been fine
with not even assigning it in this case and leaving whatever was in
the stack in this case, though it could make some static code analyzer
unhappy.

Willy
