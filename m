Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA0B3D7C2C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhG0RbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0RbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:31:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56863C061757;
        Tue, 27 Jul 2021 10:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kw8e7WCfmPeWl1fPv7zmiWyxo4YPnIDyNybMn9Zb0OY=; b=zmBSYf/TZ+Y56ZIpiaxuHTwu26
        DiIOjo+e3bDXf2GxL0I1SHj5etVxU8I7yZ/C8q4SqtN45lgsW5TdY7GfQtUo/5euF19uM3jToZw9H
        JXk/j5y7xw4CdLNVD9RjeBdvKdAOdOIbPPFrcvyhQ9DmOEu4fW+Fn9/P+Zh3HOorMrgR522ajbzgQ
        7S4KrzpLUyabt01tJeC7DR5Mih//Jzk14e6jpnTZ6lve4dOOYeBzmDSFemzhSHHI2sL8guzbXe858
        PU3aKcHnyXNwt4aBybEwI0yvO/akLFjRM9OPhxDrFfEbtWd9EqK/o3piICtk8tH2KxybPERsmGsiC
        kWy0BgDg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8Qua-00FZrC-9l; Tue, 27 Jul 2021 17:30:36 +0000
Date:   Tue, 27 Jul 2021 10:30:36 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Message-ID: <YQBCvKgH481C7o1c@bombadil.infradead.org>
References: <20210722221905.1718213-1-mcgrof@kernel.org>
 <dbf27fa2f8864e1d91f7015249b1a5f1@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf27fa2f8864e1d91f7015249b1a5f1@AcuMS.aculab.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 24, 2021 at 12:15:10PM +0000, David Laight wrote:
> From: Luis Chamberlain
> > Sent: 22 July 2021 23:19
> > 
> > There is quite a bit of tribal knowledge around proper use of
> > try_module_get() and that it must be used only in a context which
> > can ensure the module won't be gone during the operation. Document
> > this little bit of tribal knowledge.
> > 
> ...
> 
> Some typos.
> 
> > +/**
> > + * try_module_get - yields to module removal and bumps reference count otherwise
> > + * @module: the module we should check for
> > + *
> > + * This can be used to check if userspace has requested to remove a module,
>                                                            a module be removed
> > + * and if so let the caller give up. Otherwise it takes a reference count to
> > + * ensure a request from userspace to remove the module cannot happen.
> > + *
> > + * Care must be taken to ensure the module cannot be removed during
> > + * try_module_get(). This can be done by having another entity other than the
> > + * module itself increment the module reference count, or through some other
> > + * means which gaurantees the module could not be removed during an operation.
>                   guarantees
> > + * An example of this later case is using this call in a sysfs file which the
> > + * module created. The sysfs store / read file operation is ensured to exist
>                                                             ^^^^^^^^^^^^^^^^^^^
> Not sure what that is supposed to mean.

I'll clarify further. How about:

The sysfs store / read file operations are gauranteed to exist using
kernfs's active reference (see kernfs_active()).

> > + * and still be present by kernfs's active reference. If a sysfs file operation
> > + * is being run, the module which created it must still exist as the module is
> > + * in charge of removal of the sysfs file.
> > + *
> > + * The real value to try_module_get() is the module_is_live() check which
> > + * ensures this the caller of try_module_get() can yields to userspace module
> > + * removal requests and fail whatever it was about to process.
> > + */
> 
> But is the comment even right?
> I think you need to consider when try_module_get() can actually fail.

Let's do that!

> I believe the following is right.
> The caller has to have valid module reference and module unload
> must actually be in progress - ie the ref count is zero and
> there are no active IO operations.

If the refcount bump succeeded then module unload will simply not
happen. So what exactly do you mean with the first part of
"The caller has to have a valid module reference" ?

> The module's unload function must (eventually) invalidate the
> caller's module reference to stop try_module_get() being called
> with a (very) stale pointer.

Once a module's exit call is triggered the state is MODULE_STATE_GOING,
which is what module_is_live() checks for.

> So there is a potentially horrid race:
> The module unload is going to do:
> 	driver_data->module_ref = 0;
> and elsewhere there'll be:
> 	ref = driver_data->module_ref;
> 	if (!ref || !try_module_get(ref))
> 		return -error;
> 
> You have to have try_module_get() to allow the module unload
> function to sleep.
> But the above code still needs a driver lock to ensure the
> unload code doesn't race with the try_module_get() and the
> 'ref' be invalidated before try_module_get() looks at it.
> (eg if an interrupt defers processing.)
> 
> So there can be no 'yielding'.

Oh but there is. Consider access to a random sysfs file 'add_new_device'
which takes as input a name, for driver foo, and so foo's
add_new_foobar_device(name="bar") is called. Unless sysfs file
"yields" by using try_module_get() before trying to add a new
foo device called "bar", it will essentially be racing with the
exit routine of module foo, and depending on how locking is implemented
(most drivers get it wrong), this easily leads to crashes.

In fact, this documentation patch was motivated by my own solution to a
possible deadlock when sysfs is used. Using the same example above, if
the same sysfs file uses *any* lock, which is *also* used on the exit
routine, you can easily trigger a deadlock. This can happen for example
by the lock being obtained by the removal routine, then the sysfs file
gets called, waits for the lock to complete, then the module's exit
routine starts cleaning up and removing sysfs files, but we won't be
able to remove the sysfs file (due to kernefs active reference) until
the sysfs file complets, but it cannot complete because the lock is
already held.

Yes, this is a generic problem. Yes I have proof [0]. Yes, a generic
solution has been proposed [1], and because Greg is not convinced and I
need to move on with life, I am suggesting a temporary driver specific
solution (to which Greg is still NACK'ing, without even proposing any
alternatives) [2].

[0] https://lkml.kernel.org/r/20210703004632.621662-5-mcgrof@kernel.org
[1] https://lkml.kernel.org/r/20210401235925.GR4332@42.do-not-panic.com 
[2] https://lkml.kernel.org/r/20210723174919.ka3tzyre432uilf7@garbanzo

> I'm pretty much certain try_module_get(THIS_MODULE) is pretty
> much never going to fail.

It would have to take something very asynchronous and detached from
the module to run. But the only thing I can think now, is something
takes a module pointer right before after try_stop_module() and then
a piece of code in between try_stop_module() and free_module()
asynchronously tries to run something with that pointer.

In the end I can only think of buggy code. Perhaps the more type of
common issue could be code which purposely leave module pointers around
with the intent of cleaning up using a module removal notifier event and
that for some stupid reason runs something asynchronously with that
pointer.

> (It is mostly needed to give a worker thread a reference.)

Greg, do you have a real world example which demonstrates the race
better? Or perhaps a selftest? Or a kunit test?

  Luis
