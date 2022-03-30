Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E54ECC80
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350070AbiC3Si7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350056AbiC3SZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:25:15 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C649CF14;
        Wed, 30 Mar 2022 11:22:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso906841pjh.3;
        Wed, 30 Mar 2022 11:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+CAeQ6WbO75b05CAGgEyrOcN/e8ROoiFTSHaPW0jBEU=;
        b=W9mnOdTJXi67DDGPDvM/CI7eE6yWDHJKjY77YMX5aYlBYvnffHWK17C8Cb1lUi3X1A
         /e4/iaifYgfXWjdsta3C3K8yoO090sUdApnAaAyf8mEADC6v2dOia2eMoQvZ0Ht2e30s
         BcCn00DtCu5QXB9vb2NCfra9khR8kcoZvht/Nawa9CwDcaHjSXxPuxnd8CUROC5c+pXC
         ImusgsO9px5vn0X+ZswQgxp9rdFYInYG5F5DpwBAnP7Py++PEjxDFRy9JeaYOSbxYw2s
         UGLeAPZkDrc6LVYWcbzWq7Ad0OtZdYSZXxScLaP2LrAIEoitWcnYweUky1uT+YHJ4V2E
         5jYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+CAeQ6WbO75b05CAGgEyrOcN/e8ROoiFTSHaPW0jBEU=;
        b=hGoPIQIl4zRvNbNwadMIwgckx62Umad3L7S/2n0jfeevt4oum4ugXioipAZEwFfSJG
         o5dsPwlJTGwrsBhO3arlJn1XSn7jZacc3+uCWGsLvR/4yIhri68+hc88gooSSz2oVulJ
         vH63xUieGbV9HqKf9Q/sovVNP7QoWIzz+EdabWACuKFiat38mWzMciSNyToeSEpergpT
         Ob8C//hm5+Oa//7voT4zx2SrX203iE2KcU3I/vdptgnJ6fMvKrOcMv/gy2gU1kegpPDi
         NJjJzjZtiS8VrWIMH1h3h3ZBMUH/8JVnYqr7mq60gbneshylYurNVVVMjCGPusefs+nP
         8dOw==
X-Gm-Message-State: AOAM531o3THBaGslMLS8XTDMrDLe5ReQXwKN2mGi5YFmbXXpIL9yKcm8
        xyJH/zef0xtAS2IkE1hjJvnTEbeeCw+yetucsWjm5Ptw
X-Google-Smtp-Source: ABdhPJyYxmyaH69ztISMlFUIhBXJ6kSvz8m/+MHArZXryyDLLdkJ7zwHk5XRiWm72rVNX35roncs4phtAedywt9F07c=
X-Received: by 2002:a17:902:ba83:b0:154:727e:5fc5 with SMTP id
 k3-20020a170902ba8300b00154727e5fc5mr633290pls.55.1648664563315; Wed, 30 Mar
 2022 11:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
 <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com>
 <20220329201057.GA2549@kbox> <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
 <20220329231137.GA3357@kbox> <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com>
 <20220330163411.GA1812@kbox>
In-Reply-To: <20220330163411.GA1812@kbox>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 30 Mar 2022 11:22:32 -0700
Message-ID: <CAADnVQKQw+K2CoCW-nA=bngKtjP495wpB1yhEXNjKg4wSeXAWg@mail.gmail.com>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Song Liu <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 9:34 AM Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > >
> > > But you are fine with uprobe costs? uprobes appear to be much more costly
> > > than a syscall approach on the hardware I've run on.

Care to share the numbers?
uprobe over USDT is a single trap.
Not much slower compared to syscall with kpti.

> >
> > Can we achieve the same/similar performance with sys_bpf(BPF_PROG_RUN)?
> >
>
> I think so, the tough part is how do you let the user-space know which
> program is attached to run? In the current code this is done by the BPF
> program attaching to the event via perf and we run the one there if
> any when data is emitted out via write calls.
>
> I would want to make sure that operators can decide where the user-space
> data goes (perf/ftrace/eBPF) after the code has been written. With the
> current code this is done via the tracepoint callbacks that perf/ftrace
> hook up when operators enable recording via perf, tracefs, libbpf, etc.
>
> We have managed code (C#/Java) where we cannot utilize stubs or traps
> easily due to code movement. So we are limited in how we can approach
> this problem. Having the interface be mmap/write has enabled this
> for us, since it's easy to interact with in most languages and gives us
> lifetime management of the trace objects between user-space and the
> kernel.

Then you should probably invest into making USDT work inside
java applications instead of reinventing the wheel.

As an alternative you can do a dummy write or any other syscall
and attach bpf on the kernel side.
No kernel changes are necessary.
