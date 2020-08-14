Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2799244D3B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHNRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 13:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgHNRB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 13:01:26 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEEEC061384;
        Fri, 14 Aug 2020 10:01:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u20so4849387pfn.0;
        Fri, 14 Aug 2020 10:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xiHC5DUY3Z/y6RtGYjcjT7j7DBa8EN54OpDjf5EfHiE=;
        b=EaUDLCfh8Z6nm4RvCaTT7SUfk/rMB6EyH9B/yh3Mjaxesj8UFgiEsXU3oitdayGTB7
         QRTE3c24Pbq+u0YMyQoPFWfvt8G+8GpR4HkYpXHL0HX4LCavxzJvy0a/VjqaEzxTqmdR
         d2UQpmHgcXK+uNvN02XbohOvWgFVtHT5+48Ze2PLCHiXbKjk7uAI9vXTIIeEmJr8YLQg
         u3RXSgA73Gu0gPlqa/djaNM60TnGPB2PpS05pRmuYrEZLUrRs56g5sCKEXqJjsm1q372
         KzbnbH/zv7R60Rjpm2UNbgdhy8FMbm88cVwVjw1/JHrcQRWdce6ojziowWARYQS/lGWf
         MZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xiHC5DUY3Z/y6RtGYjcjT7j7DBa8EN54OpDjf5EfHiE=;
        b=PZb3NrJaJ7JuExs9KUF2HAXNCUmWECPIVHZpKUyWWqITRZRAB94HZIsxV3ymni+5Fa
         rAtJg095fg1ctt9zmhBnQ6ziqCDQbe1nEfBjrTRfK+yT+IWjsk11Qe2HyZhRxXS1yGY5
         fX2egVvsx47rpKsQDdjDJWdpGdQElbkjWe0dhu7quQx/5eVKrGeNSTjlWv7VXLxCCPT8
         Maz00QAfaZDBkP/6lNDD9Udpgz2ZQjdzzKBChZDF16k4hKDYw86mO5uosCfMYREOUy1m
         ejhDBlNAzCYqYvJEGhw8/kT5Jyq+ReWHIPcLiNxVdYRTDz2n73OvIt0LEiERBaUK55HN
         +svA==
X-Gm-Message-State: AOAM5322Hk1o4GvU3rZ4XfvwzENkqYC41YXbvXsGpkYb8X28YNDLsZJA
        soVmzuyDNtx1YcZIqlaCXLA=
X-Google-Smtp-Source: ABdhPJweDz/UYGVY+PT1HUJ5dSv5+9NA/T7zfFSnrDEqaMooDfesI251oDJYN5qulsRvWqeHjfivoA==
X-Received: by 2002:a63:4c11:: with SMTP id z17mr2324722pga.152.1597424484997;
        Fri, 14 Aug 2020 10:01:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:affd])
        by smtp.gmail.com with ESMTPSA id l7sm8987929pjf.43.2020.08.14.10.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 10:01:23 -0700 (PDT)
Date:   Fri, 14 Aug 2020 10:01:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: make BTF show support generic,
 apply to seq files/bpf_trace_printk
Message-ID: <20200814170120.q5gcmlapm7aldmzg@ast-mbp.dhcp.thefacebook.com>
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
 <1596724945-22859-3-git-send-email-alan.maguire@oracle.com>
 <20200813014616.6enltdpq6hzlri6r@ast-mbp.dhcp.thefacebook.com>
 <alpine.LRH.2.21.2008141344560.6816@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2008141344560.6816@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 02:06:37PM +0100, Alan Maguire wrote:
> On Wed, 12 Aug 2020, Alexei Starovoitov wrote:
> 
> > On Thu, Aug 06, 2020 at 03:42:23PM +0100, Alan Maguire wrote:
> > > 
> > > The bpf_trace_printk tracepoint is augmented with a "trace_id"
> > > field; it is used to allow tracepoint filtering as typed display
> > > information can easily be interspersed with other tracing data,
> > > making it hard to read.  Specifying a trace_id will allow users
> > > to selectively trace data, eliminating noise.
> > 
> > Since trace_id is not seen in trace_pipe, how do you expect users
> > to filter by it?
> 
> Sorry should have specified this.  The approach is to use trace
> instances and filtering such that we only see events associated
> with a specific trace_id.  There's no need for the trace event to
> actually display the trace_id - it's still usable as a filter.
> The steps involved are:
> 
> 1. create a trace instance within which we can specify a fresh
>    set of trace event enablings, filters etc.
> 
> mkdir /sys/kernel/debug/tracing/instances/traceid100
> 
> 2. enable the filter for the specific trace id
> 
> echo "trace_id == 100" > 
> /sys/kernel/debug/tracing/instances/traceid100/events/bpf_trace/bpf_trace_printk/filter
> 
> 3. enable the trace event
> 
> echo 1 > 
> /sys/kernel/debug/tracing/instances/events/bpf_trace/bpf_trace_printk/enable
> 
> 4. ensure the BPF program uses a trace_id 100 when calling bpf_trace_btf()

ouch.
I think you interpreted the acceptance of the
commit 7fb20f9e901e ("bpf, doc: Remove references to warning message when using bpf_trace_printk()")
in the wrong way.

Everything that doc had said is still valid. In particular:
-A: This is done to nudge program authors into better interfaces when
-programs need to pass data to user space. Like bpf_perf_event_output()
-can be used to efficiently stream data via perf ring buffer.
-BPF maps can be used for asynchronous data sharing between kernel
-and user space. bpf_trace_printk() should only be used for debugging.

bpf_trace_printk is for debugging only. _debugging of bpf programs themselves_.
What you're describing above is logging and tracing. It's not debugging of programs.
perf buffer, ring buffer, and seq_file interfaces are the right
interfaces for tracing, logging, and kernel debugging.

> > It also feels like workaround. May be let bpf prog print the whole
> > struct in one go with multiple new lines and call
> > trace_bpf_trace_printk(buf) once?
> 
> We can do that absolutely, but I'd be interested to get your take
> on the filtering mechanism before taking that approach.  I'll add
> a description of the above mechanism to the cover letter and
> patch to be clearer next time too.

I think patch 3 is no go, because it takes bpf_trace_printk in
the wrong direction.
Instead please refactor it to use string buffer or seq_file as an output.
If the user happen to use bpf_trace_printk("%s", buf);
after that to print that string buffer to trace_pipe that's user's choice.
I can see such use case when program author wants to debug
their bpf program. That's fine. But for kernel debugging, on demand and
"always on" logging and tracing the documentation should point
to sustainable interfaces that don't interfere with each other,
can be run in parallel by multiple users, etc.

> > 
> > Also please add interface into bpf_seq_printf.
> > BTF enabled struct prints is useful for iterators too
> > and generalization you've done in this patch pretty much takes it there.
> > 
> 
> Sure, I'll try and tackle that next time.
> 
> > > +#define BTF_SHOW_COMPACT	(1ULL << 0)
> > > +#define BTF_SHOW_NONAME		(1ULL << 1)
> > > +#define BTF_SHOW_PTR_RAW	(1ULL << 2)
> > > +#define BTF_SHOW_ZERO		(1ULL << 3)
> > > +#define BTF_SHOW_NONEWLINE	(1ULL << 32)
> > > +#define BTF_SHOW_UNSAFE		(1ULL << 33)
> > 
> > I could have missed it earlier, but what is the motivation to leave the gap
> > in bits? Just do bit 4 and 5 ?
> > 
> 
> Patch 3 uses the first 4 as flags to bpf_trace_btf();
> the final two are not supported for the helper as flag values
> so I wanted to leave some space for additional bpf_trace_btf() flags.
> BTF_SHOW_NONEWLINE is always used for bpf_trace_btf(), since the
> tracing adds a newline for us and we don't want to double up on newlines, 
> so it's ORed in as an implicit argument for the bpf_trace_btf() case. 
> BTF_SHOW_UNSAFE isn't allowed within BPF so it's not available as
> a flag for the helper.

I see. I think such approach is more error prone than explicit filtering.
It's better to check for NONEWLINE and UNSAFE explicitly in those places
instead of playing obscure game of upper bits.
Also the choice of NONEWLINE vs NEWLINE should be available from the program
when it wants to print it into a string or into a seq_file.
