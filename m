Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C2621F6B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiKHWmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKHWmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:42:23 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E6A6035A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:42:22 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-370547b8ca0so147476577b3.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 14:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tnDk2k9M8/LVHtazSqy+bXviz9yt0llV/82RlpALNZU=;
        b=AUOW/h1u1FYK+H4+PLsSeADr4/+ODoTN3DzAnxb2B5ppCYAPRUAPVB5WygYNXNI3Lx
         UHaKux2Mj+tl5XEee4y/7+yWqveJ35A4ozXA4yWTLd5Vp3AWRe3mvg0yhzD/NM1pN4X8
         1L8VQE4MDpcJm/dsDc07kxIlXMftM+joJbYqe+FgFNMJP3mOCFmKNCjcCn5igOejlq5M
         nmq1vjrKKt7lzWGMNkjUGR9Ghj9Rm66SHT0AgVZIFW292YjMLt0Sl36+vv6LElZtv2hF
         aOAoICZnmrKeqIDGN4GEu+shE9+0IZtToOfvj/sqNS7tu0JcF6MOd0YojqAqLza1Qdfq
         GSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tnDk2k9M8/LVHtazSqy+bXviz9yt0llV/82RlpALNZU=;
        b=u/ZDl521b/bTQWKcnLZbKpzbJhEK4H8e3xpURLRCsJ8t5vEcHoBlbyz/IaW/bzb//I
         fI2JjrGag/8EbpNt6mScbPKvDikHm8EleYVh7QP1Xzzb5Qa4108lC98rUAkhkAuNvH9D
         qMrOA1FDq2Se/HVSeKIgmPZnS/vp5LAcErAdjfwvu1prhC12t0uaLn34dNYBXkzWHCsM
         yf4lsE3seb8Qa72pwSrhq5VIl35m9fHzKN9KcD1R3oJB9ivBK/X07ZVI8o47g0uFIIR3
         YKoMDINVz2st2i19TnrzD03qSmMLoy3XmbrVqcyIjWPceCbW1OqG8rR8teoTO/qD/7fk
         DO0Q==
X-Gm-Message-State: ACrzQf01bA1B3+Zpg+6j7v+HGnwzpvd/msd5NEOXRDjhcXwazZeXs3x6
        ocUWD+u8h/B1dgLfManflJnprfebgo6G8yjsJSbstw==
X-Google-Smtp-Source: AMsMyM44LOxVnaU+k/J26C1tqoizUB1mFwMJtGmuZM09A2ceLVIK4Z+bqO/Bm46wq5W5N99wDdZmRAG543LJdWychcU=
X-Received: by 2002:a81:6e05:0:b0:35d:7f88:12f9 with SMTP id
 j5-20020a816e05000000b0035d7f8812f9mr959219ywc.471.1667947341642; Tue, 08 Nov
 2022 14:42:21 -0800 (PST)
MIME-Version: 1.0
References: <20221030220203.31210-1-axboe@kernel.dk> <20221030220203.31210-7-axboe@kernel.dk>
 <Y2rUsi5yrhDZYpf/@google.com> <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
In-Reply-To: <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 8 Nov 2022 17:41:45 -0500
Message-ID: <CACSApvZg-H4y0ibOy=+dNyrfEaAz0dw8sFjzuqSNbfsBK3cULw@mail.gmail.com>
Subject: Re: [PATCH 6/6] eventpoll: add support for min-wait
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 5:20 PM Jens Axboe <axboe@kernel.dk> wrote:
> > Is there a way to short cut the wait if the process is being terminated?
> >
> > We issues in production systems in the past where too many threads were
> > in epoll_wait and the process got terminated.  It'd be nice if these
> > threads could exit the syscall as fast as possible.
>
> Good point, it'd be a bit racy though as this is called from the waitq
> callback and hence not in the task itself. But probably Good Enough for
> most use cases?

Sounds good. We can definitely do that as a follow up later.

> This should probably be a separate patch though, as it seems this
> affects regular waits too without min_wait set?
>
> >> @@ -1845,6 +1891,18 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
> >>              ewq.timed_out = true;
> >>      }
> >>
> >> +    /*
> >> +     * If min_wait is set for this epoll instance, note the min_wait
> >> +     * time. Ensure the lowest bit is set in ewq.min_wait_ts, that's
> >> +     * the state bit for whether or not min_wait is enabled.
> >> +     */
> >> +    if (ep->min_wait_ts) {
> >
> > Can we limit this block to "ewq.timed_out && ep->min_wait_ts"?
> > AFAICT, the code we run here is completely wasted if timeout is 0.
>
> Yep certainly, I can gate it on both of those conditions.

Thanks. I think that would help. You might also want to restructure the if/else
condition above but it's your call.

On Tue, Nov 8, 2022 at 5:29 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/8/22 3:25 PM, Willem de Bruijn wrote:
> >>> This would be similar to the approach that willemb@google.com used
> >>> when introducing epoll_pwait2.
> >>
> >> I have, see other replies in this thread, notably the ones with Stefan
> >> today. Happy to do that, and my current branch does split out the ctl
> >> addition from the meat of the min_wait support for this reason. Can't
> >> seem to find a great way to do it, as we'd need to move to a struct
> >> argument for this as epoll_pwait2() is already at max arguments for a
> >> syscall. Suggestions more than welcome.
> >
> > Expect an array of two timespecs as fourth argument?
>
> Unfortunately even epoll_pwait2() doesn't have any kind of flags
> argument to be able to do tricks like that... But I guess we could do
> that with epoll_pwait3(), but it'd be an extra indirection for the copy
> at that point (copy array of pointers, copy pointer if not NULL), which
> would be unfortunate. I'd hate to have to argue that API to anyone, let
> alone Linus, when pushing the series.

I personally like what Willem suggested. It feels more natural to me
and as you suggested previously it can be a struct argument.

The overheads would be similar to any syscall that accepts itimerspec.

I understand your concern on "epoll_pwait3".  I wish Linus would weigh
in here. :-)
