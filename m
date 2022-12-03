Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8841A6419F6
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 00:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiLCXIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 18:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLCXIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 18:08:43 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E037E19C12;
        Sat,  3 Dec 2022 15:08:41 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 5047AC01C; Sun,  4 Dec 2022 00:08:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1670108928; bh=+CO9rF9Z3sjMwxpNknlXTJ5cZA3lSjQQRNAnKsWpV0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h+QJvpndy/8fSkQmxM8YZYNF+JKwabcGgwdDpDUdDcxhUHBDZ4S3/+xxnwn13lvv3
         29d1VXTpTI86vQhKlN6geh+ZWb/w/JwNNzZVP+460QafDIQxWHi4VAUfr1e7Bk64iT
         HHB4lU59wIHZggeH4nqDLfX23pA1LyH8EgR9/v1JbNkX6uB7HAHOrSuDRFCmXKbwZs
         3OqvQFUYMTy+mHt/Kuv78JAzUxMTytgn+3+bDVDuZmvUfvLptsSOOyqrORdPt86BHZ
         YXx7d3fkxxvudKMJHwoXGtVtNBwedRF/zzKS6saaj8CVLrXiv/AUTKu5PAkiNneH6T
         Muf0Yjx83ligQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 3DF9AC009;
        Sun,  4 Dec 2022 00:08:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1670108926; bh=+CO9rF9Z3sjMwxpNknlXTJ5cZA3lSjQQRNAnKsWpV0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vWVy8GgB8kYGFJInSg+trhuXpLCiwXgCUsHXJ8A1UpZPEvMUU17zaJyv/64aXirR7
         eLMWcaddP6oggFpkW3N6Rx8flq2qTzacrLaRy0772HncS8y4aMmdk7obsatJbwic68
         M0EQ/8V12QnhKm4nNXC5CHKLXBqE1PqlBahyIWuM+vANE791bA6sAxZJh1JJLQzeG+
         PvMxsf86PbpuJX9JWf2vstwkRLcwDKv4bGXG0/SwKItJHCaA82+lOVOzx9n1nL646a
         H8lBlLZNID//lIleGfjMfpZUt7OR2diiT3e+wAX6GkgdloSE6W33qQ26OogJbKVYtD
         QzFoRwtapxxUw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1bfa2785;
        Sat, 3 Dec 2022 23:08:31 +0000 (UTC)
Date:   Sun, 4 Dec 2022 08:08:16 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Marco Elver <elver@google.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        rcu <rcu@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kunit-dev@googlegroups.com, lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: arm64: allmodconfig: BUG: KCSAN: data-race in p9_client_cb /
 p9_client_rpc
Message-ID: <Y4vW4CncDucES8m+@codewreck.org>
References: <CA+G9fYsK5WUxs6p9NaE4e3p7ew_+s0SdW0+FnBgiLWdYYOvoMg@mail.gmail.com>
 <CANpmjNOQxZ--jXZdqN3tjKE=sd4X6mV4K-PyY40CMZuoB5vQTg@mail.gmail.com>
 <CA+G9fYs55N3J8TRA557faxvAZSnCTUqnUx+p1GOiCiG+NVfqnw@mail.gmail.com>
 <Y4e3WC4UYtszfFBe@codewreck.org>
 <CA+G9fYuJZ1C3802+uLvqJYMjGged36wyW+G1HZJLzrtmbi1bJA@mail.gmail.com>
 <Y4ttC/qESg7Np9mR@codewreck.org>
 <CANpmjNNcY0LQYDuMS2pG2R3EJ+ed1t7BeWbLK2MNxnzPcD=wZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANpmjNNcY0LQYDuMS2pG2R3EJ+ed1t7BeWbLK2MNxnzPcD=wZw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marco Elver wrote on Sat, Dec 03, 2022 at 05:46:46PM +0100:
> > But I can't really find a problem with what KCSAN complains about --
> > we are indeed accessing status from two threads without any locks.
> > Instead of a lock, we're using a barrier so that:
> >  - recv thread/cb: writes to req stuff || write to req status
> >  - p9_client_rpc: reads req status || reads other fields from req
> >
> > Which has been working well enough (at least, without the barrier things
> > blow up quite fast).
> >
> > So can I'll just consider this a false positive, but if someone knows
> > how much one can read into this that'd be appreciated.
> 
> The barriers only ensure ordering, but not atomicity of the accesses
> themselves (for one, the compiler is well in its right to transform
> plain accesses in ways that the concurrent algorithm wasn't designed
> for). In this case it looks like it's just missing
> READ_ONCE()/WRITE_ONCE().

Aha! Thanks for this!

I've always believed plain int types accesses are always atomic and the
only thing to watch for would be compilers reordering instrucions, which
would be ensured by the barrier in this case, but I guess there are some
architectures or places where this isn't true?


I'm a bit confused though, I can only see five places where wait_event*
functions use READ_ONCE and I believe they more or less all would
require such a marker -- I guess non-equality checks might be safe
(waiting for a value to change from a known value) but if non-atomic
updates are on the table equality and comparisons checks all would need
to be decorated with READ_ONCE; afaiu, unlike usespace loops with
pthread_cond_wait there is nothing protecting the condition itself.

Should I just update the wrapped condition, as below?

-       err = wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);
+       err = wait_event_killable(req->wq,
+                                 READ_ONCE(req->status) >= REQ_STATUS_RCVD);

The writes all are straightforward, there's all the error paths to
convert to WRITE_ONCE too but that's not difficult (leaving only the
init without such a marker); I'll send a patch when you've confirmed the
read looks good.
(the other reads are a bit less obvious as some are protected by a lock
in trans_fd, which should cover all cases of possible concurrent updates
there as far as I can see, but this mixed model is definitely hard to
reason with... Well, that's how it was written and I won't ever have time
to rewrite any of this. Enough ranting.)


> A (relatively) quick primer on the kernel's memory model and
> where/what/how we need to "mark" accesses:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/access-marking.txt

I read Documentation/memory-barriers.txt ages ago but wasn't aware of
this memory-model directory; I've skimmed through and will have a proper
read as time permits.

Thank you,
-- 
Dominique
