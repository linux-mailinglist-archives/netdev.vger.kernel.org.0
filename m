Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951113D7F90
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhG0Uyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbhG0Uyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:54:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD19C061757;
        Tue, 27 Jul 2021 13:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MBrBM2hWSSFJKN0za7twq1O9odGp29rpAsJCQ0flnEg=; b=vbm6nTwMY9s5EUFtqtEUpQ/fdO
        50MABQ301exgOgwuy15+9Q0GSyqRn0P9WyXq5dgm2UR5LQ9oawo84jeNCDARuh7gqA7/kIsfVwZ73
        ZYkRar/zbKmHnkPbEEyxUFqcFfsDmyeBkLKnkz8ht4sVpncWYKo3NkdeUVxF0Fz2fUpoNpDnewUmt
        ZaoB4iQDKLUkDBsTQ147poEW4F2OUO8D0QqX237/WXVQIGMPbEH1nx9r9T7x6Z7x8T65eC6kDN9a5
        pwi+7X4ZTm0BP/7oQ4gXfpaAaQWl8gJ8z4VwJOMmcN94TpvWy6sUw/Ijrg/lf0b3lDG0ruSOvP9fY
        BYWrgWAg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8U5l-00GHkQ-28; Tue, 27 Jul 2021 20:54:21 +0000
Date:   Tue, 27 Jul 2021 13:54:21 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andriin@fb.com" <andriin@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "weiwan@google.com" <weiwan@google.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "sergey.senozhatsky.work@gmail.com" 
        <sergey.senozhatsky.work@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "mbenes@suse.com" <mbenes@suse.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module: add documentation for try_module_get()
Message-ID: <YQByfUaDaXCUqrlo@bombadil.infradead.org>
References: <20210722221905.1718213-1-mcgrof@kernel.org>
 <dbf27fa2f8864e1d91f7015249b1a5f1@AcuMS.aculab.com>
 <YQBCvKgH481C7o1c@bombadil.infradead.org>
 <YQBGemOIF4sp/ges@kroah.com>
 <YQBN2/K4Ne5orgzS@bombadil.infradead.org>
 <YQBSutZfhqfTzKQa@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQBSutZfhqfTzKQa@kroah.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 08:38:50PM +0200, gregkh@linuxfoundation.org wrote:
> On Tue, Jul 27, 2021 at 11:18:03AM -0700, Luis Chamberlain wrote:
> > On Tue, Jul 27, 2021 at 07:46:34PM +0200, gregkh@linuxfoundation.org wrote:
> > > On Tue, Jul 27, 2021 at 10:30:36AM -0700, Luis Chamberlain wrote:
> > > > On Sat, Jul 24, 2021 at 12:15:10PM +0000, David Laight wrote:
> > > > > From: Luis Chamberlain
> > > > > > Sent: 22 July 2021 23:19
> > > > The sysfs store / read file operations are gauranteed to exist using
> > > > kernfs's active reference (see kernfs_active()).
> > > 
> > > But that has nothing to do with module reference counts.  kernfs knows
> > > nothing about modules.
> > 
> > Yes but we are talking about sysfs files which the module creates. So
> > but inference again, an active reference protects a module.
> 
> What active reference? 

kernfs_active()

> > > > In fact, this documentation patch was motivated by my own solution to a
> > > > possible deadlock when sysfs is used. Using the same example above, if
> > > > the same sysfs file uses *any* lock, which is *also* used on the exit
> > > > routine, you can easily trigger a deadlock. This can happen for example
> > > > by the lock being obtained by the removal routine, then the sysfs file
> > > > gets called, waits for the lock to complete, then the module's exit
> > > > routine starts cleaning up and removing sysfs files, but we won't be
> > > > able to remove the sysfs file (due to kernefs active reference) until
> > > > the sysfs file complets, but it cannot complete because the lock is
> > > > already held.
> > > > 
> > > > Yes, this is a generic problem. Yes I have proof [0]. Yes, a generic
> > > > solution has been proposed [1], and because Greg is not convinced and I
> > > > need to move on with life, I am suggesting a temporary driver specific
> > > > solution (to which Greg is still NACK'ing, without even proposing any
> > > > alternatives) [2].
> > > > 
> > > > [0] https://lkml.kernel.org/r/20210703004632.621662-5-mcgrof@kernel.org
> > > > [1] https://lkml.kernel.org/r/20210401235925.GR4332@42.do-not-panic.com 
> > > > [2] https://lkml.kernel.org/r/20210723174919.ka3tzyre432uilf7@garbanzo
> > > 
> > > My problem with your proposed solution is that it is still racy, you can
> > > not increment your own module reference count from 0 -> 1 and expect it
> > > to work properly.  You need external code to do that somewhere.
> > 
> > You are not providing *any* proof for this.
> 
> I did provide proof of that.  Here it is again.

<irrelevant example> 

sysfs files are safe to use try_module_get() because once they are
active a removal of the file cannot happen, and so removal will wait.

> > And even so, I believe I have clarified as best as possible how a
> > kernfs active reference implicitly protects the module when we are
> > talking about sysfs files.
> 
> I do not see any link anywhere between kernfs and modules, what am I
> missing?  Pointers to lines of code would be appreciated.

I provided a selftests with error injections inserted all over
kernfs_fop_write_iter(). Please study that and my error injection
code.

> > > Now trying to tie sysfs files to the modules that own them would be
> > > nice, but as we have seen, that way lies way too many kernel changes,
> > > right?
> > 
> > It's not a one-liner fix. Yes.
> > 
> > > Hm, maybe.  Did we think about this from the kobj_attribute level?  If
> > > we use the "wrapper" logic there and the use of the macros we already
> > > have for attributes, we might be able to get the module pointer directly
> > > "for free".
> > >
> > > Did we try that?
> > 
> > That was my hope. I tried that first. Last year in November I determined
> > kernfs is kobject stupid. But more importantly *neither* are struct device
> > specific, so neither of them have semantics for modules or even devices.
> 
> But what about at the kobject level?

kernfs is kobject stupid.

> I will try to look at that this week, can't promise anything...

  Luis
