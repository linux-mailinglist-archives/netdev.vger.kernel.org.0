Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D814EB742
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241344AbiC2X4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 19:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241293AbiC2X4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:56:34 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19790BF59;
        Tue, 29 Mar 2022 16:54:50 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s11so17265326pfu.13;
        Tue, 29 Mar 2022 16:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LHFIzlMHcD6qDSToyvl5dbn+nrgausa4lYRWBBJH19I=;
        b=p9di60D48ivYtNgPnBsoYU638rald7+YwO7G9bXpnCNkl5b2QhXxBuTBqdgauIvS3r
         89gnjBFR5nK3jUvuVPKaNxcolrTNT1gDlxTNfIQU9okqUmBA3gw3swPqNHe5VL2jVdVZ
         yLUfDE4ETCu4ROdmeBkJZcm7xtGFQbYcJAhBDtQGoSDYNFKh1I7HOskXhmtsbdSzTa/m
         GTCAy6rLqrzOGu8Y9gCb3SgBDBNi8IO9Do4jY/Pp7Em5w+AQlRbrqGjS/Srusq5LMPhc
         C6iFpIEEQ/Og8OZlXeE++4RyuAMfPhZItMuHjbYK1KuOAc2wrkzhRdX2KdeAwDKdu0rg
         CW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LHFIzlMHcD6qDSToyvl5dbn+nrgausa4lYRWBBJH19I=;
        b=MKoJalFrkjV0TmWxwa5JfszBCIMVYKgDVc0Xy3/DtFzJ0cyCevpwUleHbw73qlCP9E
         ssMIAdhAIDu8Rv0f+B2cXIGqLxqsRuAGUnCkRC1Lo3KPe+L5RgaS+KQLGsCYqbUFqojQ
         um++ZpZ1vfSizTJHyGXNstgTEwYv/0x1NnTCPvV7Xm2F/2xMoIaurw/kuulu0oYUoVhr
         xSN3OUJohuAT1WWES9PTKMFr7jTzfARAvjw3DUddYwFlgjCahLSFmNjPDzQ71OCTmg7R
         VsV39iDqAo4NgbbVp7ZnyTfttK1Or9OUSHshj8gDYp+yNoAD0q3eC4NVZ5ebb2fLknlS
         tn0g==
X-Gm-Message-State: AOAM533O8gYpi4SOcuZau4WahHAGedp2oDL2jxDmGFwDn/r9SPatxpj7
        2llH2ifaa4AQz2qNA7U7jS1dmYkiBdslOAUNAuk=
X-Google-Smtp-Source: ABdhPJx1EjSr4a8bjD+W/X5zUF4e6t2htlaLzYE+lDOnWUbSx2ZNCz200Jnr8Z2IHVB2lx+hAbbjyXca3/XDr6FkAuE=
X-Received: by 2002:a05:6a00:995:b0:4fb:607d:444c with SMTP id
 u21-20020a056a00099500b004fb607d444cmr11351045pfg.69.1648598089571; Tue, 29
 Mar 2022 16:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
 <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com>
 <20220329201057.GA2549@kbox> <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
 <20220329231137.GA3357@kbox>
In-Reply-To: <20220329231137.GA3357@kbox>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Mar 2022 16:54:38 -0700
Message-ID: <CAADnVQKCuK0GmRbOJjyce4Hwiq0ieqthVdnqdPbHT_qKqV5rzw@mail.gmail.com>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
>
> > All you did is a poor man version of lttng that doesn't rely
> > on such heavy instrumentation.
>
> Well I am a frugal person. :)
>
> This work has solved some critical issues we've been having, and I would
> appreciate a review of the code if possible.

It's a NACK to connect bpf and user_events.
I would remove user_events from the kernel too.
