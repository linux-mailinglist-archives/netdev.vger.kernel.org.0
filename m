Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED2868C96F
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 23:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjBFWav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 17:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjBFWar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 17:30:47 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4796FDBF7
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 14:30:16 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 45E32C01E; Mon,  6 Feb 2023 23:30:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1675722636; bh=PDs+/XcuZUGQL4rxDx/aOmfGEWZQWk09vfbKodEdQe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4CwmByaXxPFarPNplBW9YouVyYzUExAEWjP60idxEu4Fnwc4Ch5AgJxZWLDc/3YU
         a/1X/iREANG4qxTfVlxfuFexKZTzBhDvQC+OTlUHosMjmnOE+GGX+P3SYnDbca7KE2
         1XOh86BoIytTGhLrfnY3rCtcvo2rFUU7cU1/47vHR2Q/9+95NNWVlCw2zda+9IFEz8
         I6pPAZZT+RGgGCKKQaZg1DYDgpxsnosq7NWRsSlmeFm4FWj4TJ+XbDFsspkMopbaoV
         oC4m6dV+dyZDbcIgoszqbsib1sx5wRIHlNru9G4xvWsSG8CsxMiT1nY/m7dGnnhavd
         3WiJ4jaM7mXNw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 58247C009;
        Mon,  6 Feb 2023 23:30:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1675722635; bh=PDs+/XcuZUGQL4rxDx/aOmfGEWZQWk09vfbKodEdQe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HuIuZxgRv6uT39CyZgNYHH0EsUW/REqD/AwaFVCbNbdGg/j9ZGAWsG88gSZr0hwuV
         8JOl0SdHNQhbrxRJOdKf6I6TLQJlC1y22w+9xbeiwCB/XWgJM9fWiYrGhcqw+gIeYs
         m97ORxgSJujx1KB6dYadGBTkc4ncVCtpG7GoFqxWfLK/84b1kerjEKOGb6iWivszCx
         QZYVUR6NRSQaGhdfw5t21ym98tbSRN0STP1jzz/khrLi3M9hhKNHJkQLMUaGUZlicF
         qzyhEpPTDvLranOKccamc1yCfxTuh+Qxd0QHDrjMPdS4dwty3lrpeNKez4XtdOoP45
         QiXTnyefN7dSg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 630ff128;
        Mon, 6 Feb 2023 22:30:08 +0000 (UTC)
Date:   Tue, 7 Feb 2023 07:29:53 +0900
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
Message-ID: <Y+F/YSjhcQax1bMm@codewreck.org>
References: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
 <Y99+yzngN/8tJKUq@codewreck.org>
 <ad133b58-9bc1-4da9-73a2-957512e3e162@kernel.dk>
 <Y+F0KrAmOuoJcVt/@codewreck.org>
 <00a0809e-7b47-c43c-3a13-a84cd692f514@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00a0809e-7b47-c43c-3a13-a84cd692f514@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jens Axboe wrote on Mon, Feb 06, 2023 at 02:56:57PM -0700:
> Sure, if you set it again when done, then it will probably work just
> fine. But you need to treat TIF_NOTIFY_SIGNAL and TIF_SIGPENDING
> separately. An attempt at that at the end of this email, totally
> untested, and I'm not certain it's a good idea at all (see below). Is
> there a reason why we can't exit and get the task_work processed
> instead? That'd be greatly preferable.

No good reason aside of "it's not ready", but in the current code things
will probably get weird.
I actually misremembered the tag lookup for trans_fd, since we're not
freeing the tag yet the lookup will work and the connexion might not be
dropped (just reading into a buffer then freeing it in the cb without
any further processing), but even my refcounting works better than I
thought you'll end up with the IO being replayed while the server is
still processing the first one.
This is unlikely, but for example this could happen: 

- first write [0;1MB]
- write is interrupted before server handled it
   - write replayed and handled, userspace continues to...
   - second write [1MB-4k;1MB]
- first write handle by server, overwriting the second write

And who doesn't enjoy a silent corruption for breakfast?


> > Hm, schedule_delayed_work on the last fput, ok.
> > I was wondering what it had to do with the current 9p thread, but since
> > it's not scheduled on a particular cpu it can pick another cpu to wake
> > up, that makes sense -- although conceptually it feels rather bad to
> > interrupt a remote IO because of a local task that can be done later;
> > e.g. between having the fput wait a bit, or cancel a slow operation like
> > a 1MB write, I'd rather make the fput wait.
> > Do you know why that signal/interrupt is needed in the first place?
> 
> It's needed if the task is currently sleeping in the kernel, to abort a
> sleeping loop. The task_work may contain actions that will result in the
> sleep loop being satisfied and hence ending, which means it needs to be
> processed. That's my worry with the check-and-clear, then reset state
> solution.

I see, sleeping loop might not wake up until the signal is handled, but
it won't handle it if we don't get out.
Not bailing out on sigkill is bad enough but that's possibly much worse
indeed... And that also means the busy loop isn't any better, I was
wondering how it was noticed if it was just a few busy checks but in
that case just temporarily clearing the flag won't get out either,
that's not even a workaround.

I assume that also explains why it wants that task, and cannot just run
from the idle context-- it's not just any worker task, it's in the
process context? (sorry for using you as a rubber duck...)

> > I'll setup some uring IO on 9p and see if I can produce these.
> 
> I'm attaching a test case. I don't think it's particularly useful, but
> it does nicely demonstrate the infinite loop that 9p gets into if
> there's task_work pending.

Thanks, that helps!
I might not have time until weekend but I'll definitely look at it.

-- 
Dominique
