Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F959812D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 19:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfHURYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 13:24:11 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43686 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbfHURYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 13:24:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id h15so2871787ljg.10;
        Wed, 21 Aug 2019 10:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ImUO9R2zFHULTGLAfy/amMjTreuObHPtY/k9LK1EvQs=;
        b=QD80siO81QUF7hQIILnvgjrDLEvWPs85k4obC2CzqFtze9ccI8D5qA3bWHNJs68Tbm
         9K+gS+RVuk04q5aU4WE0hpfEmnbN9LOIR1Z3+97/6gw5yyWYPRatSyJgQUS3uziKzBsT
         Cu702YKbzAy7XbM1RzpCfj21qXM1mc0fA70FYkCiFXlgZDc5Du/5nG+3esfzSKfljpd3
         6xOZlegCvIZX7E8qhkwVZeCTC4bnSnOg5mc+9vQ0BWITcZTLeW7R4BciTRHhXAyn7Wmu
         0HxTkHyFIDpQIKqUf+JQrbClPGXta4LuXhQP3qrn3MBZ+xhuZhUKJVxQvlAPNPLMiyZi
         U6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ImUO9R2zFHULTGLAfy/amMjTreuObHPtY/k9LK1EvQs=;
        b=m9E+bE1FXn/HE8LxmpDuDA46gnKgxEMPD9YBm22VvZFAL2XoNU1iCyhB1qTPV66+lC
         /nL4VVSJSvp1PVMfKj1Z9DuJu0Asq4KWn0OE1tHcP2BN6zP66G0ckTqDq8jelpZqdNKQ
         aTBEGsTXP3oyP41OfTpJtJFi3b6DkX7uGoZgLl7XFQSiMsLsJP7mfex3PiISZoMWKkE8
         uGyGvk0uPwm0qTFuYxzieky8W2LnWogHUVDic+HWWI2MrhHauTFUg6XfOGaLNMfCrkQh
         WVVYpnhyQaCgC8bo9UVWKjbEQiRRCBWfqzuDdd6ro3Z5WLu8TZvkUpLXbMwZ/693DvV2
         kiew==
X-Gm-Message-State: APjAAAW69kUZ9k61nOJWObyRq8DHTfiMZ+FmUALstn57M5jF+hcrOo6s
        9ORdFmXPky1ZDGpNK5bhQyLrV/jopztocS2+mwDjwRmt
X-Google-Smtp-Source: APXvYqz33ncCwZwD2/AjqAgHdu2e1J/pZT+JsCyyBshuqGRJk+UC+iKE9jjOrLe6sjYyJcVA14KThFw6G4bn2p3gRiA=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr3270230ljc.210.1566408248481;
 Wed, 21 Aug 2019 10:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190820230900.23445-1-peter@lekensteyn.nl> <20190820230900.23445-4-peter@lekensteyn.nl>
 <20190820232221.vzxemergvzy3bg4j@ast-mbp> <20190821000413.GA28011@al>
In-Reply-To: <20190821000413.GA28011@al>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 21 Aug 2019 10:23:56 -0700
Message-ID: <CAADnVQ+hU6QOC_dPmpjnuv=9g4SQEeaMEMqXOS2WpMj=q=LdiQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] bpf: clarify when bpf_trace_printk discards lines
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 5:04 PM Peter Wu <peter@lekensteyn.nl> wrote:
>
> On Tue, Aug 20, 2019 at 04:22:23PM -0700, Alexei Starovoitov wrote:
> > On Wed, Aug 21, 2019 at 12:08:59AM +0100, Peter Wu wrote:
> > > I opened /sys/kernel/tracing/trace once and kept reading from it.
> > > bpf_trace_printk somehow did not seem to work, no entries were appended
> > > to that trace file. It turns out that tracing is disabled when that file
> > > is open. Save the next person some time and document this.
> > >
> > > The trace file is described in Documentation/trace/ftrace.rst, however
> > > the implication "tracing is disabled" did not immediate translate to
> > > "bpf_trace_printk silently discards entries".
> > >
> > > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> > > ---
> > >  include/uapi/linux/bpf.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 9ca333c3ce91..e4236e357ed9 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -575,6 +575,8 @@ union bpf_attr {
> > >   *                 limited to five).
> > >   *
> > >   *                 Each time the helper is called, it appends a line to the trace.
> > > + *                 Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
> > > + *                 open, use *\/sys/kernel/debug/tracing/trace_pipe* to avoid this.
> >
> > that's not quite correct.
> > Having 'trace' file open doesn't discard lines.
> > I think this type of comment in uapi header makes more confusion than helps.
>
> Having the 'trace' file open for reading results in discarding lines. It
> took me a while to figure that out. At first I was not even sure whether
> my eBPF program was executed or not due to lack of entries in the
> 'trace' file.
>
> I ended up setting a breakpoint and ended up with this call stack:
>
>   - bpf_trace_printk
>     - ____bpf_trace_printk
>       - __trace_printk
>         - trace_vprintk
>           - trace_array_vprintk
>             - __trace_array_vprintk
>               - __trace_array_vprintk
>                 - __trace_buffer_lock_reserve
>                   - ring_buffer_lock_reserve
>
> The function ends up skipping the even because record_disabled == 1:
>
>     if (unlikely(atomic_read(&buffer->record_disabled)))
>         goto out;
>
> Why is that? Well, I guessed that ring_buffer_record_disable and
> ring_buffer_record_enable would be related. Sure enough, the first one
> was hit when the 'trace' file is opened for reading while the latter is
> called when the file is closed.
>
> The relevant code from kernel/trace/trace.c (__tracing_open), "snapshot"
> is true when "trace" is opened, and "false" when "trace_pipe" is used:
>
>     /* stop the trace while dumping if we are not opening "snapshot" */
>     if (!iter->snapshot)
>         tracing_stop_tr(tr);
>
> So I think this supports the claim that lines are discarded. Do you
> think this is not the case?

Indeed.
I missed "(opened)" part in Documentation/trace/ftrace.rst:
  trace:
        This file holds the output of the trace in a human
        readable format (described below). Note, tracing is temporarily
        disabled while this file is being read (opened).

I always thought that reading disables it.
It's indeed odd part of the ftrace implementation that
worth documenting here.

Applied the set to bpf-next. Thanks
