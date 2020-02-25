Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EAC16B6C3
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgBYAd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:33:59 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38628 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgBYAd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:33:59 -0500
Received: by mail-pj1-f66.google.com with SMTP id j17so507114pjz.3;
        Mon, 24 Feb 2020 16:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1MZEZ2GEYvQXg6Ws6U2GBT8ghJZN/P1H3tj6qrQONCo=;
        b=OgCoomylsUw/fqZz3594W9eD37SJGKz5KmF2Eo3eVMnffRMJEqYYkJBTfIbIKAy4Ho
         tnssZPcuqKT3uK9/+uCSzizUJvpY3S4eBjAIwydyaYJPHrUAvbduBLxjI8t3yyMnH82K
         kkPf/QycjXwitMwhmtTW6mF8qxZhGv+IW3XD1DLuy1tbvCEIhOtP94CAiq7JaKgilwNo
         iNnX1/Cr5pKjW6g9kUgiaCn5dROthMX6jSfAXlrIV7gvttYhV4F6szLgMOgii78Ibxve
         Lv8RqOqak+2GdU91U7pmIXSh+YTzBj5z4LmKSxlFop7gLDSmHkpoJWH/cyuot0xI9t4V
         yv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1MZEZ2GEYvQXg6Ws6U2GBT8ghJZN/P1H3tj6qrQONCo=;
        b=LXB1z6VfCGkgYFOsXSPhib90UMUCjVccCWcNM+gvxcdhMGXf65bDmYZicaV7qJwIZf
         V8i1yiRruzWUY9TPE88y9GOr4di4gclZxTKzebo4F9nDIjy4nucqC4pyHT6Dk4S6ZPed
         5VNjgk3XwKZwpAp8DtfqqrIzXoJtxxMIm+tJx/bRPiIUwXbYwUkF8nOSIifFJS32xYhc
         k6QpwQVA0SUjWRkSAEYBQJubDj4U8NN8ulEWIJuqrsPTGAcRAWIyUtx1w9k9Vr9TDskO
         vVNO88AkyTrj5qp716RUvgUvf8GMG28vLRTdncCnoRgABdgjjV/rWfcEvgsWB5DXy2AT
         j9wg==
X-Gm-Message-State: APjAAAUZRHIDcFq5xiB5g9Qat1d2s2QxnmNL8U9/fgzIiV9aqWPHjfaC
        uLjNxwted4jPaZ6Sc+mtlM8=
X-Google-Smtp-Source: APXvYqwZgEpVY2roB2RP3of0Inatyl7DxDuH/WqHG+SulC3s4yRXDHkzhYKieTasi96TN6jKGHPqNA==
X-Received: by 2002:a17:902:9a4c:: with SMTP id x12mr50260950plv.297.1582590837850;
        Mon, 24 Feb 2020 16:33:57 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::7:f76f])
        by smtp.gmail.com with ESMTPSA id 10sm14144428pfu.132.2020.02.24.16.33.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 16:33:56 -0800 (PST)
Date:   Mon, 24 Feb 2020 16:33:52 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V3 06/22] bpf/trace: Remove redundant preempt_disable
 from trace_call_bpf()
Message-ID: <20200225003351.vvsrgyta47ciqhvo@ast-mbp>
References: <20200224140131.461979697@linutronix.de>
 <20200224145643.059995527@linutronix.de>
 <20200224194017.rtwjcgjxnmltisfe@ast-mbp>
 <875zfvk983.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zfvk983.fsf@nanos.tec.linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 09:42:52PM +0100, Thomas Gleixner wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > On Mon, Feb 24, 2020 at 03:01:37PM +0100, Thomas Gleixner wrote:
> >> --- a/kernel/trace/bpf_trace.c
> >> +++ b/kernel/trace/bpf_trace.c
> >> @@ -83,7 +83,7 @@ unsigned int trace_call_bpf(struct trace
> >>  	if (in_nmi()) /* not supported yet */
> >>  		return 1;
> >>  
> >> -	preempt_disable();
> >> +	cant_sleep();
> >>  
> >>  	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> >>  		/*
> >> @@ -115,7 +115,6 @@ unsigned int trace_call_bpf(struct trace
> >>  
> >>   out:
> >>  	__this_cpu_dec(bpf_prog_active);
> >> -	preempt_enable();
> >
> > My testing uncovered that above was too aggressive:
> > [   41.533438] BUG: assuming atomic context at kernel/trace/bpf_trace.c:86
> > [   41.534265] in_atomic(): 0, irqs_disabled(): 0, pid: 2348, name: test_progs
> > [   41.536907] Call Trace:
> > [   41.537167]  dump_stack+0x75/0xa0
> > [   41.537546]  __cant_sleep.cold.105+0x8b/0xa3
> > [   41.538018]  ? exit_to_usermode_loop+0x77/0x140
> > [   41.538493]  trace_call_bpf+0x4e/0x2e0
> > [   41.538908]  __uprobe_perf_func.isra.15+0x38f/0x690
> > [   41.539399]  ? probes_profile_seq_show+0x220/0x220
> > [   41.539962]  ? __mutex_lock_slowpath+0x10/0x10
> > [   41.540412]  uprobe_dispatcher+0x5de/0x8f0
> > [   41.540875]  ? uretprobe_dispatcher+0x7c0/0x7c0
> > [   41.541404]  ? down_read_killable+0x200/0x200
> > [   41.541852]  ? __kasan_kmalloc.constprop.6+0xc1/0xd0
> > [   41.542356]  uprobe_notify_resume+0xacf/0x1d60
> 
> Duh. I missed that particular callchain.
> 
> > The following fixes it:
> >
> > commit 7b7b71ff43cc0b15567b60c38a951c8a2cbc97f0 (HEAD -> bpf-next)
> > Author: Alexei Starovoitov <ast@kernel.org>
> > Date:   Mon Feb 24 11:27:15 2020 -0800
> >
> >     bpf: disable migration for bpf progs attached to uprobe
> >
> >     trace_call_bpf() no longer disables preemption on its own.
> >     All callers of this function has to do it explicitly.
> >
> >     Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >
> > diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> > index 18d16f3ef980..7581f5eb6091 100644
> > --- a/kernel/trace/trace_uprobe.c
> > +++ b/kernel/trace/trace_uprobe.c
> > @@ -1333,8 +1333,15 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
> >         int size, esize;
> >         int rctx;
> >
> > -       if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
> > -               return;
> > +       if (bpf_prog_array_valid(call)) {
> > +               u32 ret;
> > +
> > +               migrate_disable();
> > +               ret = trace_call_bpf(call, regs);
> > +               migrate_enable();
> > +               if (!ret)
> > +                       return;
> > +       }
> >
> > But looking at your patch cant_sleep() seems unnecessary strong.
> > Should it be cant_migrate() instead?
> 
> Yes, if we go with the migrate_disable(). OTOH, having a
> preempt_disable() in that uprobe callsite should work as well, then we
> can keep the cant_sleep() check which covers all other callsites
> properly. No strong opinion though.

ok. I went with preempt_disable() for uprobes. It's simpler.
And pushed the whole set to bpf-next.
In few days we'll send it to Dave for net-next and on the way
to Linus's next release. imo it's a big milestone.
Thank you for the hard work to make it happen.
