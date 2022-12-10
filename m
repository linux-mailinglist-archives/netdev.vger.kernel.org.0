Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D49649042
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 19:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiLJSw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 13:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLJSwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 13:52:23 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFF2183A3
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 10:52:12 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id cg5so6053467qtb.12
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 10:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ux000uRhIvBzcJmT+I5Zn16s8FTwiB+xIoLfos10Ds=;
        b=OTXThifSNhozRXE9B96yw+UechhX40Wpc34GA3QOHFgDx/enYs+4y17hm8s474Wgg9
         YsJ+Yv0fdwelTo83br+SVHt0MgMXVOH4Wqjhi9QDHpt4cCnhVDQwY4FkVoi1Pyiybh8V
         au+Ec0cROCq/OGjq8DWg6Rc4qNjaot/8Apysw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Ux000uRhIvBzcJmT+I5Zn16s8FTwiB+xIoLfos10Ds=;
        b=58Fydu5si/lBB3yHMopJSz+0g98h4v51WJRWg68PQs8StUDB/pMT5/x49BYiSmWVUj
         CD1sVL91donX3FBCcyzcfrBRMuk1LhBf1pf8KrG991jyFueaXPU7i6Hcd56M5NYpwiex
         r4lxECvqdzos7QYtgWMvXYOAduAgMNtH4KEeJLGV6yXcQwmhulxzhfw2l3dyKQ3Tg9qv
         xkBUStoZW4IPAj9CVqFRehXeT2T9uQ/sWuGSNOAqBbwTtMX5Ztl7ttWrdbCRTll7JSoh
         qkmHT1YEKT0Xh2pEXaWvVGhg6cLRb5tMdoibvN2hX8cieRn0+azPKUqetN8swEBUQ9HG
         4t3w==
X-Gm-Message-State: ANoB5pm2754XMPRMf9F+XbmvL2C+EHSc7JNO3lCZyeX+HTYNQDwMQGv4
        6JFntLh3SLg3JfDPHA1PeJHR54s2o9VgdikN
X-Google-Smtp-Source: AA0mqf5kVc1UkCwsmSNI7HN0IFAgU7qW9wHctIsCWf2VE4kejCkoOdXG3LGvVFmesdEKQFqkBlPgJg==
X-Received: by 2002:ac8:5cd2:0:b0:3a6:930b:b3ba with SMTP id s18-20020ac85cd2000000b003a6930bb3bamr20784931qta.67.1670698331053;
        Sat, 10 Dec 2022 10:52:11 -0800 (PST)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com. [209.85.160.172])
        by smtp.gmail.com with ESMTPSA id w19-20020a05620a0e9300b006e07228ed53sm2580182qkm.18.2022.12.10.10.52.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 10:52:10 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id h24so6055783qta.9
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 10:52:10 -0800 (PST)
X-Received: by 2002:ac8:688:0:b0:3a5:122:fb79 with SMTP id f8-20020ac80688000000b003a50122fb79mr76081601qth.452.1670698330099;
 Sat, 10 Dec 2022 10:52:10 -0800 (PST)
MIME-Version: 1.0
References: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
In-Reply-To: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 10 Dec 2022 10:51:54 -0800
X-Gmail-Original-Message-ID: <CAHk-=whgzBzTR5t6Dc6gZ_XS1q=UrqeiBf62op_fahbwns+xvQ@mail.gmail.com>
Message-ID: <CAHk-=whgzBzTR5t6Dc6gZ_XS1q=UrqeiBf62op_fahbwns+xvQ@mail.gmail.com>
Subject: Re: [GIT PULL] Add support for epoll min wait time
To:     Jens Axboe <axboe@kernel.dk>
Cc:     netdev <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 7:36 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> This adds an epoll_ctl method for setting the minimum wait time for
> retrieving events.

So this is something very close to what the TTY layer has had forever,
and is useful (well... *was* useful) for pretty much the same reason.

However, let's learn from successful past interfaces: the tty layer
doesn't have just VTIME, it has VMIN too.

And I think they very much go hand in hand: you want for at least VMIN
events or for at most VTIME after the last event.

Yes, yes, you have that 'maxevents' thing, but that's not at all the
same as VMIN. That's just the buffer size.

Also note that the tty layer VTIME is *different* from what I think
your "minimum wait time" is. VTIME is a "inter event timer", not a
"minimum total time". If new events keep on coming, the timer resets -
until either things time out, or you hit VMIN events.

I get the feeling that the tty layer did this right, and this epoll
series did not. The tty model certainly feels more flexible, and does
have decades of experience. tty traffic *used* to be just about the
lowest-latency traffic machines handled back when, so I think it might
be worth looking at as a model.

So I get the feeling that if you are adding some new "timeout for
multiple events" model to epoll, you should look at previous users.

And btw, the tty layer most definitely doesn't handle every possible case.

There are at least three different valid timeouts:

 (a) the "final timeout" that epoll already has (ie "in no case wait
more than this, even if there are no events")

 (b) the "max time we wait if we have at least one event" (your new "min_wait")

 (c) the "inter-event timeout" (tty layer VTIME)

and in addition to the timers, there's that whole "if I have gotten X
events, I have enough, so stop timing out" (tty layer VMIN).

And again, that "at least X events" should not be "this is my buffer
size". You may well want to have a *big* buffer for when there are
events queued up or the machine is just under very heavy load, but may
well feel like "if I got N events, I have enough to deal with, and
don't want to time out for any more".

Now, maybe there is some reason why the tty like VMIN/VTIME just isn't
relevant, but I do think that people have successfully used VMIN/VTIME
for long enough that it should be at least given some thought.

Terminal traffic may not be very relevant any more as a hard load to
deal with well. But it really used to be very much an area that had to
balance both throughput and latency concerns and had exactly the kinds
of issues you describe (ie "returning after one single character is
*much* too inefficient").

Hmm?

              Linus
