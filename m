Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AD030A48F
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhBAJnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbhBAJnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:43:40 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE42C061574
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 01:43:00 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id t17so11765514qtq.2
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 01:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2sHxy9y8qkhEHifIfAe0m1ot0K1d3d52OFzD+qlpuBU=;
        b=NeM9ON292bcd64Kcp1z5gL6seKO2huIT0uTkbIjuDyCv8g/B7hwOeO2OAamF9B2PEc
         ZbN3rq15lpmLJV5JUh3CfnQHd9b+YxMq+YDouvd5MsK+lD7L2Ow3FVdaW+XRHlDYD6/H
         WZVypjR7q4M6jZJbuSPLfv9fUnKjSsyRt/TTmDaYdWR/7zYJd72RrYEMvq0o33pqO4K5
         lbJBbkeRyO6N0No28SuLusfI0yy55S87qcE434y+K2PqoQt/6gIeyePbUOOuP/aymnBk
         7oPVPDckhy2fDc1Q/7+/etMpeJc8jE+vtf1E7T6slmA1BWrTkBsk9g0LTJujxL+N2liU
         63PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sHxy9y8qkhEHifIfAe0m1ot0K1d3d52OFzD+qlpuBU=;
        b=tf9F3rrnjtAAYVmNzCPYrzkTDQe+FNDkk69fmaszNLpQ6NwmwLBhwfBrVi9MdHQffy
         UcB+c08E+/rZOcwOqcENiag17Syr1G2fYQsV+FXYRvck2svMH8KuQAI5l3m9Y70CbDoD
         nj9+4nrypKkISoSeYu1AZ1HeHvNky6YWRkwoYqBJZmWbrtqOJMybYWOZThItKHM0KNt1
         kep6KkjsLd4+Qtngm3uHAFzrz3qqf3elYIbbU2sFFTUvbULK4dCeBDEuPAKMAWgBJrRk
         A06+dscLOF6Llo142SFJcZJ7lavhSVrTtUUY7nMXBa+ndhQZV3vz9G6nHvUP4l7AzXhN
         3SuQ==
X-Gm-Message-State: AOAM532hOdyJdez5KjJqv9C0bwvIG3OMj5c+Bus1rVOd5lEqVdjM3paE
        QOfhjsgZ0eMdNfUfI2tLRUq/xB5Oqixi5yo9IoufxQ==
X-Google-Smtp-Source: ABdhPJw/FU0ujXSBV1WzoDZvLs4yUz4Di0PBTFwg18+sWEkhAxDhgDVoLq4LU6FoT1MyO3nDH65GPEApRc4rxfiidFA=
X-Received: by 2002:ac8:480b:: with SMTP id g11mr14124931qtq.290.1612172579083;
 Mon, 01 Feb 2021 01:42:59 -0800 (PST)
MIME-Version: 1.0
References: <CACT4Y+a7UBQpAY4vwT8Od0JhwbwcDrbJXZ_ULpPfJZ42Ew-yCQ@mail.gmail.com>
 <YBfIUwtK+QqVlfRt@hirez.programming.kicks-ass.net>
In-Reply-To: <YBfIUwtK+QqVlfRt@hirez.programming.kicks-ass.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 1 Feb 2021 10:42:47 +0100
Message-ID: <CACT4Y+Yq69nvj2KZUQrYqtyu+Low+jCCcH++U_vuiHkhezQHGw@mail.gmail.com>
Subject: Re: extended bpf_send_signal_thread with argument
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>, kpsingh@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 10:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sun, Jan 31, 2021 at 12:14:02PM +0100, Dmitry Vyukov wrote:
> > Hi,
> >
> > I would like to send a signal from a bpf program invoked from a
> > perf_event. There is:
>
> You can't. Sending signals requires sighand lock, and you're not allowed
> to take locks from perf_event context.


Then we just found a vulnerability because there is
bpf_send_signal_thread which can be attached to perf and it passes the
verifier :)
https://elixir.bootlin.com/linux/v5.11-rc5/source/kernel/trace/bpf_trace.c#L1145

It can defer sending the signal to the exit of irq context:
https://elixir.bootlin.com/linux/v5.11-rc5/source/kernel/trace/bpf_trace.c#L1108
Perhaps this is what makes it work?
