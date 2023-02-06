Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D63A68C8DC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBFVm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjBFVmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:42:25 -0500
X-Greylist: delayed 128349 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Feb 2023 13:42:24 PST
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC1D2685E
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:42:24 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 6693EC01F; Mon,  6 Feb 2023 22:42:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1675719764; bh=j5ebleK+ZBbQU54WkW2EioiEoqVKceozsg5iO9IxCZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C7rmuGLbwPvm0RSZuUPL46400QNy/vNdoBM6GpqXqlsqRh3pU7xhnXRnIJwjp4nO6
         ViesfFHOW7dChh//RdY5XFPqZr21fA8ZqEla7jQiFclq5iNnkB23eAYSE1qds5qYDJ
         twoKRPtsvL/KZhUiPyQQczPYD+IO5ux9MqA5W9J0Gw4J0OXJqU2N6tWh9X3nqFp3e0
         l/dqN2ihMXxiRPMQ3xmC6n5+ivWJbzlHqQTsmzH8i4yC0CHotY7HPz9QH3Z3hf9xPy
         AwJq22f74QAdKXu1cK1kpMFV9/cut0xc7kdgVVKkojF8U+fp6kU60pKAgPOfd3UOod
         10zY2h+YKbyWw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 69621C009;
        Mon,  6 Feb 2023 22:42:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1675719763; bh=j5ebleK+ZBbQU54WkW2EioiEoqVKceozsg5iO9IxCZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RMww8lbj57mCJsg0KRriZtG9v+9WAMuy7avDlylTeximxd/2oW/duxULe72bIk24o
         gtibcCMPVUftqwZGH8c/ktdcpMGp10je87cIgMsrGiBco6xfTiSXKMnmThyAK9+vfr
         vH7EFlOGPuHUG8E6qaAVQD6Dg45n/R5ClG6Cuun6O59YGHsaWi+mDKKXqT6ZIIbVBT
         Q40PG8TQqNleV/SouegAfAz1f+j+oFkiKAtCW/AUzOK/T3apNambVlHW9gh3LRVxxN
         /f2gLjLEJtLTCkrXLzkRI7ilMVd/Z5y/xyte7KrbUjYsKdDQTZz6FXaYDHMkXB8PuK
         7uNywywCjY82A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1adebe52;
        Mon, 6 Feb 2023 21:42:17 +0000 (UTC)
Date:   Tue, 7 Feb 2023 06:42:02 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH v2] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
Message-ID: <Y+F0KrAmOuoJcVt/@codewreck.org>
References: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
 <Y99+yzngN/8tJKUq@codewreck.org>
 <ad133b58-9bc1-4da9-73a2-957512e3e162@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad133b58-9bc1-4da9-73a2-957512e3e162@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jens Axboe wrote on Mon, Feb 06, 2023 at 01:19:24PM -0700:
> > I agree with your assessment that we can't use task_work_run(), I assume
> > it's also quite bad to just clear the flag?
> > I'm not familiar with these task at all, in which case do they happen?
> > Would you be able to share an easy reproducer so that I/someone can try
> > on various transports?
> 
> You can't just clear the flag without also running the task_work. Hence
> it either needs to be done right there, or leave it pending and let the
> exit to userspace take care of it.

Sorry I didn't develop that idea; the signal path resets the pending
signal when we're done, I assumed we could also reset the TWA_SIGNAL
flag when we're done flushing. That might take a while though, so it's
far from optimal.

> > If it's "rare enough" I'd say sacrificing the connection might make more
> > sense than a busy loop, but if it's becoming common I think we'll need
> > to spend some more time thinking about it...
> > It might be less effort to dig out my async flush commits if this become
> > too complicated, but I wish I could say I have time for it...
> 
> It can be a number of different things - eg fput() will do it.

Hm, schedule_delayed_work on the last fput, ok.
I was wondering what it had to do with the current 9p thread, but since
it's not scheduled on a particular cpu it can pick another cpu to wake
up, that makes sense -- although conceptually it feels rather bad to
interrupt a remote IO because of a local task that can be done later;
e.g. between having the fput wait a bit, or cancel a slow operation like
a 1MB write, I'd rather make the fput wait.
Do you know why that signal/interrupt is needed in the first place?

> The particular case that I came across was io_uring, which will use
> TWA_SIGNAL based task_work for retry operations (and other things). If
> you use io_uring, and depending on how you setup the ring, it can be
> quite common or will never happen. Dropping the connection task_work
> being pending is not a viable solution, I'm afraid.

Thanks for confirming that it's perfectly normal, let's not drop
connections :)

My preferred approach is still to try and restore the async flush code,
but that will take a while -- it's not something that'll work right away
and I want some tests so it won't be ready for this merge window.
If we can have some sort of workaround until then it'll probably be for
the best, but I don't have any other idea (than temporarily clearing the
flag) at this point.

I'll setup some uring IO on 9p and see if I can produce these.

-- 
Dominique
