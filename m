Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C8D243CED
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 18:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgHMQCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 12:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 12:02:47 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1516C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 09:02:47 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k4so5500310oik.2
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 09:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=OsOO5EM1k8kX5EKcp4tmQWmYqANkLh9Q/4PJEJSeU1o=;
        b=Ovv2Va9ukCZ2LuqUBDaTJhN+L1JzAE094kjIglcuqaOwLep46eKkgOaPPmswRP3VdF
         kJnbzrmg9HsLaW5POqozHjGi7C3r51IqhSoG/+jcsrcAr4lwLrIf0EaUava9fki3cGr8
         dAYmENwLizujGTLv02SbfOrlfLLF5/32hI6tDdYnVt+5qWC2PWX4u+fU88re5IeyWJhh
         I+hiZ+dVyjA7Hc4vsI5/9/rkOlUnOcwquj2LSrtLUH5Hif6+rS97zW0HAsH+8r4txN6w
         jCM4c9aqYGGj175tM0kImKfJx+SuKvWZP5alSwP+lnJOoNUtucUx1RHv5T7b7KnIaTye
         55YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=OsOO5EM1k8kX5EKcp4tmQWmYqANkLh9Q/4PJEJSeU1o=;
        b=DVqk8/K79cjKdlVHsDX9OHnf7ztbLU2ljxmkaTFfqwbKSwQ37Ceipez4Ijb2Mqw+Tw
         Z/YMF0OEt5iPBVwFV2rxhUZhL5YvyJS5KYHAhaVZJOwnL5AhGwQE/2GSpQQvKyBsns6/
         30sz/8oGHyLzczNd3xx2ItA0TTBPYuOwwa40jN8NNxD2WnbyWS2joWf3Y+PjaajztJ+T
         /SYSXN+na9YWSwkIOfoC7NmqVjdRuoiKVDTVmDdLXnm+kAuq55dwJ5JRJF/z9RFmHET6
         BybYm9yZSDOsHidCRNAgpYyhToHx0hnsScFBjEcUwhClWDDlVrUg5aDBwizxo7EPTQMy
         1R8A==
X-Gm-Message-State: AOAM532HB7d5q7ENdrdeR4UlZ73gaJddRu31ddChMVW7weJ/ynvnoYgH
        /PFuRJvbVbDL5IpB5KvtZCgnLo26t54Dr64b7oc=
X-Google-Smtp-Source: ABdhPJyI21ylWx7D8cTTmHYPNZwceAnaAJXhT+G3yhXE7WXfzwFLCMKdi5b3maHhtOnG9qdYXcMCsvGITdDSS3dsyyU=
X-Received: by 2002:aca:724f:: with SMTP id p76mr3954553oic.35.1597334566887;
 Thu, 13 Aug 2020 09:02:46 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG> <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG> <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG> <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu> <CA+icZUWiXyP-s+=V9xy00ZwjaSQKZ9GOG_cvkCetNTVYHNipGg@mail.gmail.com>
 <CA+icZUUdtRm7uHPT=TtT1BEE0dQU3pFP-nvqwBE7ES1F_kvXSA@mail.gmail.com> <CANn89i+Yp7duamws_yH6KdFJjiUrH_aGxVf7ANPo8DEmib8Cbw@mail.gmail.com>
In-Reply-To: <CANn89i+Yp7duamws_yH6KdFJjiUrH_aGxVf7ANPo8DEmib8Cbw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 13 Aug 2020 18:02:34 +0200
Message-ID: <CA+icZUVTvB2A-6ZKcrW2crn8SMRqYPzYALf=3eWiRcBpb=k7Cg@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Eric Dumazet <edumazet@google.com>
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 4:00 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Aug 13, 2020 at 1:27 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > I run a perf session looks like this in my KDE/Plasma desktop-environment:
> >
> > [ PERF SESSION ]
> >
> >  1016  2020-08-13 09:57:24 echo 1 > /proc/sys/kernel/sched_schedstats
> >  1017  2020-08-13 09:57:24 echo prandom_u32 >>
> > /sys/kernel/debug/tracing/set_event
> >  1018  2020-08-13 09:57:24 echo traceon >
> > /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
> >  1019  2020-08-13 09:57:25 echo 1 > /sys/kernel/debug/tracing/events/enable
> >
> >  1020  2020-08-13 09:57:32 sysctl -n kernel.sched_schedstats
> >  1021  2020-08-13 09:57:32 cat /sys/kernel/debug/tracing/events/enable
> >  1022  2020-08-13 09:57:32 grep prandom_u32 /sys/kernel/debug/tracing/set_event
> >  1023  2020-08-13 09:57:33 cat
> > /sys/kernel/debug/tracing/events/random/prandom_u32/trigger
> >
> > root# /home/dileks/bin/perf record -a -g -e random:prandom_u32 sleep 5
> >
>
> To be clear : This "perf record -a -g -e random:prandom_u32 sleep 5"
> is self sufficient.
>
> You have nothing to do before (as reported in your email), this is
> simply not needed.
>
> I am not sure why you added all this irrelevant stuff, this is distracting.

Initially I followed these Links:

Link: https://www.kernel.org/doc/html/v5.8/trace/events.html
Link: https://www.kernel.org/doc/html/v5.8/trace/events.html#boot-option
Link: http://www.brendangregg.com/perf.html
Link: http://www.brendangregg.com/perf.html#DynamicTracing

You are right, it's not needed to set and check all these variables as
perf says:

root# /home/dileks/bin/perf list | grep prandom_u32
  random:prandom_u32                                 [Tracepoint event]

So these two steps are indeed enough:

root# /home/dileks/bin/perf record -a -g -e random:prandom_u32 sleep 5
root# /home/dileks/bin/perf report --no-children --stdio

Lessons learned.

- Sedat -
