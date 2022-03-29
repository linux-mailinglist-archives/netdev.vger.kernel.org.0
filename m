Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85284EB60A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbiC2Wd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiC2Wd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:33:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C696A1C5526;
        Tue, 29 Mar 2022 15:31:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w8so18893962pll.10;
        Tue, 29 Mar 2022 15:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OX10xLhNulTBcdU5muA8JTM3Au0wWeRUYrKCzsEHaU0=;
        b=XulX9SUn7wpdo6Fv0r2P+0LXSb/g25UbI2y0CULw/8zpw73PJi31NAptJj/hMfqqBA
         Js94HsIZCiFgQY6UJ0HziKiPkGGirLUY4jeZ3AEZ1JFtGUCL4ii6U0HyIUHAvWHWjFv+
         yvgK1MiYg55maIktd/hI3NNTZ9Ag3WTM8jvfMDwpAwl5TGj4BfBFXSi92blY7ckHU3fJ
         bsslItjIJ7wPi7OA6PABXdcnv2SJMzsMqm5XYvmebE7IwRUXn3nejlvvTmg6KzoUvc8J
         yUVQrKNz7rwgW6WBGmpsII1/uAd/jdm1Caw5zb6yZn0zpUi072JW3y4EuFm3WxvKlSlf
         mBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OX10xLhNulTBcdU5muA8JTM3Au0wWeRUYrKCzsEHaU0=;
        b=NQbMkEx+agDDlg72EAIDn0uyk8Yshju5B0sZCLQgN5sMMGwJUrYr5UrNdLQY9xvnCj
         dapG6fqZFeB5eDvlmMqAU/GduwJhje7kmaYQlo0f8Ou11ic9O4UIN/BRLHB9eY+kpEDF
         54VUNJ90J55xE3EBfwjULw2PIwv67eyU5AI/qX/nAHU9rf8R+ubM0GO7s6RbH0nhWzbM
         eb9hCGR7LK0125PBNisnLJwlxq9X07spu0Gz77WRIEoA6w/BUerM/p7UJ9Caq6Kz4KPF
         VvruyzFDsnoHJFVab+DyVpyXQCMjlB59aDjrXU3BVYTIDU04t5K1HcAy+91jfJV/UfcM
         tyEA==
X-Gm-Message-State: AOAM533fih4eVM7+xsXo38oQdsCm713aqvX4kUFhRFjKO+kNYtxBl1I0
        JJ9ozRrArJdQKATp2Btfw9iSRd6NL/DkuxRKv668kZ6a
X-Google-Smtp-Source: ABdhPJzzU9nKYDwnoo0b0tNBKKyIBKwuVtrdgvN/rFLkzfaoP2XTKh8Ld0Ov8YjVYWmKALwefbzUCOijuGRruyzouis=
X-Received: by 2002:a17:90b:4b45:b0:1c7:cc71:fdf7 with SMTP id
 mi5-20020a17090b4b4500b001c7cc71fdf7mr1425270pjb.33.1648593102302; Tue, 29
 Mar 2022 15:31:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
 <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com> <20220329201057.GA2549@kbox>
In-Reply-To: <20220329201057.GA2549@kbox>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Mar 2022 15:31:31 -0700
Message-ID: <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
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

On Tue, Mar 29, 2022 at 1:11 PM Beau Belgrave <beaub@linux.microsoft.com> wrote:
>
> On Tue, Mar 29, 2022 at 12:50:40PM -0700, Alexei Starovoitov wrote:
> > On Tue, Mar 29, 2022 at 11:19 AM Beau Belgrave
> > <beaub@linux.microsoft.com> wrote:
> > >
> > > Send user_event data to attached eBPF programs for user_event based perf
> > > events.
> > >
> > > Add BPF_ITER flag to allow user_event data to have a zero copy path into
> > > eBPF programs if required.
> > >
> > > Update documentation to describe new flags and structures for eBPF
> > > integration.
> > >
> > > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> >
> > The commit describes _what_ it does, but says nothing about _why_.
> > At present I see no use out of bpf and user_events connection.
> > The whole user_events feature looks redundant to me.
> > We have uprobes and usdt. It doesn't look to me that
> > user_events provide anything new that wasn't available earlier.
>
> A lot of the why, in general, for user_events is covered in the first
> change in the series.
> Link: https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/
>
> The why was also covered in Linux Plumbers Conference 2021 within the
> tracing microconference.
>
> An example of why we want user_events:
> Managed code running that emits data out via Open Telemetry.
> Since it's managed there isn't a stub location to patch, it moves.
> We watch the Open Telemetry spans in an eBPF program, when a span takes
> too long we collect stack data and perform other actions.
> With user_events and perf we can monitor the entire system from the root
> container without having to have relay agents within each
> cgroup/namespace taking up resources.
> We do not need to enter each cgroup mnt space and determine the correct
> patch location or the right version of each binary for processes that
> use user_events.
>
> An example of why we want eBPF integration:
> We also have scenarios where we are live decoding the data quickly.
> Having user_data fed directly to eBPF lets us cast the data coming in to
> a struct and decode very very quickly to determine if something is
> wrong.
> We can take that data quickly and put it into maps to perform further
> aggregation as required.
> We have scenarios that have "skid" problems, where we need to grab
> further data exactly when the process that had the problem was running.
> eBPF lets us do all of this that we cannot easily do otherwise.
>
> Another benefit from user_events is the tracing is much faster than
> uprobes or others using int 3 traps. This is critical to us to enable on
> production systems.

None of it makes sense to me.
To take advantage of user_events user space has to be modified
and writev syscalls inserted.
This is not cheap and I cannot see a production system using this interface.
All you did is a poor man version of lttng that doesn't rely
on such heavy instrumentation.
