Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40F12B8256
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgKRQuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgKRQuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:50:51 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA6AC0613D6
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:50:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k7so1306074plk.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G9I3t8aN7L1xly0yUdg8yWu3OFUJdCn4z7Buna0vemo=;
        b=jkwC9oZ9Upku7sbUkXC7BIfgX2KZ0ZxyHa6bNFDCZYHvGnVO88kTnC0w4u/F4ezXnc
         GREsN/hIh3RnrYa8SD6a6CDC7MAJu4ed+jIwT1rNlu0k8plP0MOlxSgBN1JzWmUewZep
         fvMI1gACSgiaaDnX6igKVeag6vhyjjjsSGa7q/E0k/j04aT6VwIz+wlQ/FYSAx7bNqUj
         ssOnPGUtQ+e1ISYv323ocUT9TNcNCN0ChCc11tGc6cWmjlzvFxFi8YjvV1G+u+9PQcan
         GfOW3i++5NOzBPcvHLHyqTw5BRpaQGfh3JSfFl21svfNJbFlG5JAmExP38mfBSiNtcje
         cJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G9I3t8aN7L1xly0yUdg8yWu3OFUJdCn4z7Buna0vemo=;
        b=irlEZUBbMc6qZ3t0/K0HLmy75Gw00aTneZtnTyqUShLPbD5/OdlLFdA+HJUUFrwg6F
         I2LiNGaguWr7i/Yiy3+vMwQXO+3dOf3Ykd6fi8HcUFH2vE5vOmHyneoB0BJo4IJy8nP2
         T5Q1jJi4CCyF671+Hvd8FoBDe3hL/L9Ifr5WawWyNRjovJJZAaTg1CeWdlxT6xs+AdWH
         dfVs89kKvQGSxjn4Apflgy8PKA/pFwBQdfTKz41aBB4et2CM9lob1fcgkOUVTUGjucT1
         uvLmTUVuwz5/Ep1271igV3Zlkf2OrwxX4Dgy9dUQ8zAfYQlhWxzoSEbOHVsf9PB5b7zR
         KSfA==
X-Gm-Message-State: AOAM533Lx7DQEcVbxi8RnBilc9JTli0QDJi4kmqOEVdaAL5GYnL2dgJI
        GBHoP3DWqtpnXMUOCdf04ziKge3RqV3BzG6JRAIQBQ==
X-Google-Smtp-Source: ABdhPJz7vgjiZ81NHh1dkjauRy3xD7weGPoC85n8NibHpoDwygaoYq4lVfKSiolmozAPc2KrRuV7J9FbC0ZndFIPsJU=
X-Received: by 2002:a17:90a:6b04:: with SMTP id v4mr736163pjj.101.1605718249147;
 Wed, 18 Nov 2020 08:50:49 -0800 (PST)
MIME-Version: 1.0
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
 <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
 <20201117153451.3015c5c9@gandalf.local.home> <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
In-Reply-To: <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 18 Nov 2020 08:50:37 -0800
Message-ID: <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
Subject: Re: violating function pointer signature
To:     Peter Zijlstra <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 5:23 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Nov 17, 2020 at 03:34:51PM -0500, Steven Rostedt wrote:
>
> > > > Since all tracepoints callbacks have at least one parameter (__data), we
> > > > could declare tp_stub_func as:
> > > >
> > > > static void tp_stub_func(void *data, ...)
> > > > {
> > > >   return;
> > > > }
> > > >
> > > > And now C knows that tp_stub_func() can be called with one or more
> > > > parameters, and had better be able to deal with it!
> > >
> > > AFAIU this won't work.
> > >
> > > C99 6.5.2.2 Function calls
> > >
> > > "If the function is defined with a type that is not compatible with the type (of the
> > > expression) pointed to by the expression that denotes the called function, the behavior is
> > > undefined."
> >
> > But is it really a problem in practice. I'm sure we could create an objtool
> > function to check to make sure we don't break anything at build time.
>
> I think that as long as the function is completely empty (it never
> touches any of the arguments) this should work in practise.
>
> That is:
>
>   void tp_nop_func(void) { }

or `void tp_nop_func()` if you plan to call it with different
parameter types that are all unused in the body.  If you do plan to
use them, maybe a pointer to a tagged union would be safer?

>
> can be used as an argument to any function pointer that has a void
> return. In fact, I already do that, grep for __static_call_nop().
>
> I'm not sure what the LLVM-CFI crud makes of it, but that's their
> problem.

If you have instructions on how to exercise the code in question, we
can help test it with CFI.  Better to find any potential issues before
they get committed.
-- 
Thanks,
~Nick Desaulniers
