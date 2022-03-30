Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1090D4EC942
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348622AbiC3QI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348701AbiC3QIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:08:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1829C23D76F;
        Wed, 30 Mar 2022 09:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8F096179B;
        Wed, 30 Mar 2022 16:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998EC340F2;
        Wed, 30 Mar 2022 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648656397;
        bh=BL5gp9g+4lOt7MP6OWX+etUWh+Qufqk3KhmvfKjHLxk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Zfn2Non3kSBEOnWTt9QLvhBkXdnDzBo9T2WjnFMkn+SdwNlxjoQZnB9KhDABI5xVw
         vzWkoSatYmuHh/Du7CZbHr5rzuMBCF9e6Z9y/jOuAUfQ8pAzRT1h4CCt/omVnCs1Tg
         15E224Sw//26e/uTpGetvwFxid8Oav+ifLLxZsEyi/abUc6j+sDASk1ScVmVTJBr52
         PIOBRoWVz9f3IwdQLebvwdgLW8bXZ/KJF/CbzHpCeMUkmrdSRW+SZMmUDMZ+T3CmZU
         Cq9C9E7iDyEvwWFFlCJJCVAcxzFJk1G3MUrYhqRpP3/XRhTTQrLqtxKdI3iUcQCMgX
         Hf4ww8yfhcFhQ==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2e5827a76f4so224484207b3.6;
        Wed, 30 Mar 2022 09:06:36 -0700 (PDT)
X-Gm-Message-State: AOAM533ap4cN1WUXYknJTU8UMmrHmHY+MlkA5ArGC/VrAfM4lSPhenGO
        RcC4CTj9m9vCGMBU9HRMElNBr8h9e+0QLZj7474=
X-Google-Smtp-Source: ABdhPJy5KgTK+8wsBvhFLFAPMB5Ayg3DaKACrUkQv9LgK9deowojuaZwPLhTmK6zbZsaPVCnURBd8T1vtv61DqwtabA=
X-Received: by 2002:a81:13c4:0:b0:2e6:bdb4:6d9f with SMTP id
 187-20020a8113c4000000b002e6bdb46d9fmr333573ywt.211.1648656396060; Wed, 30
 Mar 2022 09:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
 <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com>
 <20220329201057.GA2549@kbox> <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
 <20220329231137.GA3357@kbox>
In-Reply-To: <20220329231137.GA3357@kbox>
From:   Song Liu <song@kernel.org>
Date:   Wed, 30 Mar 2022 09:06:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com>
Message-ID: <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 4:11 PM Beau Belgrave <beaub@linux.microsoft.com> wrote:
>
> On Tue, Mar 29, 2022 at 03:31:31PM -0700, Alexei Starovoitov wrote:
> > On Tue, Mar 29, 2022 at 1:11 PM Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > >
> > > On Tue, Mar 29, 2022 at 12:50:40PM -0700, Alexei Starovoitov wrote:
> > > > On Tue, Mar 29, 2022 at 11:19 AM Beau Belgrave
> > > > <beaub@linux.microsoft.com> wrote:
> > > > >
> > > > > Send user_event data to attached eBPF programs for user_event based perf
> > > > > events.
> > > > >
> > > > > Add BPF_ITER flag to allow user_event data to have a zero copy path into
> > > > > eBPF programs if required.
> > > > >
> > > > > Update documentation to describe new flags and structures for eBPF
> > > > > integration.
> > > > >
> > > > > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > > >
> > > > The commit describes _what_ it does, but says nothing about _why_.
> > > > At present I see no use out of bpf and user_events connection.
> > > > The whole user_events feature looks redundant to me.
> > > > We have uprobes and usdt. It doesn't look to me that
> > > > user_events provide anything new that wasn't available earlier.
> > >
> > > A lot of the why, in general, for user_events is covered in the first
> > > change in the series.
> > > Link: https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/
> > >
> > > The why was also covered in Linux Plumbers Conference 2021 within the
> > > tracing microconference.
> > >
> > > An example of why we want user_events:
> > > Managed code running that emits data out via Open Telemetry.
> > > Since it's managed there isn't a stub location to patch, it moves.
> > > We watch the Open Telemetry spans in an eBPF program, when a span takes
> > > too long we collect stack data and perform other actions.
> > > With user_events and perf we can monitor the entire system from the root
> > > container without having to have relay agents within each
> > > cgroup/namespace taking up resources.
> > > We do not need to enter each cgroup mnt space and determine the correct
> > > patch location or the right version of each binary for processes that
> > > use user_events.
> > >
> > > An example of why we want eBPF integration:
> > > We also have scenarios where we are live decoding the data quickly.
> > > Having user_data fed directly to eBPF lets us cast the data coming in to
> > > a struct and decode very very quickly to determine if something is
> > > wrong.
> > > We can take that data quickly and put it into maps to perform further
> > > aggregation as required.
> > > We have scenarios that have "skid" problems, where we need to grab
> > > further data exactly when the process that had the problem was running.
> > > eBPF lets us do all of this that we cannot easily do otherwise.
> > >
> > > Another benefit from user_events is the tracing is much faster than
> > > uprobes or others using int 3 traps. This is critical to us to enable on
> > > production systems.
> >
> > None of it makes sense to me.
>
> Sorry.
>
> > To take advantage of user_events user space has to be modified
> > and writev syscalls inserted.
>
> Yes, both user_events and lttng require user space modifications to do
> tracing correctly. The syscall overheads are real, and the cost depends
> on the mitigations around spectre/meltdown.
>
> > This is not cheap and I cannot see a production system using this interface.
>
> But you are fine with uprobe costs? uprobes appear to be much more costly
> than a syscall approach on the hardware I've run on.

Can we achieve the same/similar performance with sys_bpf(BPF_PROG_RUN)?

Thanks,
Song

>
> > All you did is a poor man version of lttng that doesn't rely
> > on such heavy instrumentation.
>
> Well I am a frugal person. :)
>
> This work has solved some critical issues we've been having, and I would
> appreciate a review of the code if possible.
>
> Thanks,
> -Beau
