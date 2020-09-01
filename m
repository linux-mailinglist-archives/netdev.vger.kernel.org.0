Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99B8258A87
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgIAIkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:40:07 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:41173 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgIAIkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 04:40:06 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0818dl80000977;
        Tue, 1 Sep 2020 10:39:47 +0200
Date:   Tue, 1 Sep 2020 10:39:47 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Yann Ylavic <ylavic.dev@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
Message-ID: <20200901083947.GB901@1wt.eu>
References: <20200901064302.849-1-w@1wt.eu>
 <20200901064302.849-2-w@1wt.eu>
 <CAKQ1sVM9SMYVTSZYaGuPDhQHfyEOFSxBL8PNixyaN4pR2PWMxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKQ1sVM9SMYVTSZYaGuPDhQHfyEOFSxBL8PNixyaN4pR2PWMxQ@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 10:33:40AM +0200, Yann Ylavic wrote:
> On Tue, Sep 1, 2020 at 8:45 AM Willy Tarreau <w@1wt.eu> wrote:
> >
> > +/*
> > + *     Generate some initially weak seeding values to allow
> > + *     the prandom_u32() engine to be started.
> > + */
> > +static int __init prandom_init_early(void)
> > +{
> > +       int i;
> > +       unsigned long v0, v1, v2, v3;
> > +
> > +       if (!arch_get_random_long(&v0))
> > +               v0 = jiffies;
> > +       if (!arch_get_random_long(&v1))
> > +               v0 = random_get_entropy();
> 
> Shouldn't the above be:
>                   v1 = random_get_entropy();
> ?

Very good catch, many thanks Yann! Now fixed in my local tree.

Willy
