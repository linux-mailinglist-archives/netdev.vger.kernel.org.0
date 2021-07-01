Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE593B8EE0
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 10:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbhGAIhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 04:37:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235159AbhGAIhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 04:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625128474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QbZDZ4ZHDFYvEp+MYmYMyVNCMzCBKo4jKnhjj4SN9Mw=;
        b=Zkw3V6hIaU21lVllJR/HRZWMFsaPTngp9BqGAeatKM54nOCVjc9MHTuig5Yu3k8aAXZpoh
        fzJlExpvkcFaNHd3f3cH4jBL5TTpFEb5jBr5FhiWYXDr9Axs/ifmLpR1AAFphZiSVt5/a2
        q1iOVP5gPe0Y8Gtbb1IYPWi2QcSkDec=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-tPoOW8YWOnGSzvobREhf3A-1; Thu, 01 Jul 2021 04:34:32 -0400
X-MC-Unique: tPoOW8YWOnGSzvobREhf3A-1
Received: by mail-ed1-f71.google.com with SMTP id m4-20020a0564024304b0290394d27742e4so2654344edc.10
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 01:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QbZDZ4ZHDFYvEp+MYmYMyVNCMzCBKo4jKnhjj4SN9Mw=;
        b=eFBBeYpXR3hcUn/mzFHA3nKjABs1N/JVIU9r/94h62SNOPY5ShBDs/I/nTqC09vnBz
         ltoYfO5jH1RQGLhi0oa+WCPs6KzFxpWh/0YN4RG4KdgIzL87o5TJsK69fwSx0Pmk0d+x
         KSnkwHsNzBF7zx5s2CalyPfxC7TXMQNoze2BdybTYr859BxqRq3sqdswHsxIOV+GzmYy
         8RI7W3ls2UXFJCcL51KzL1UXmhw49BkWK2Gjbq67pNItLEVEyzdNtSudbA+PK773W8Yu
         heooSma/C6W/Inea8ufoSZFJ1PnS3c75trdTuAtdWJnq+jXjvddWogq2Z7WXtHs8MYK2
         7kUQ==
X-Gm-Message-State: AOAM533vE1h3tCIfhd0kTduIGyeBePmnE/GCUITfXmddIf7oTWu6j7T0
        WhjmcfmO0ZOyiip8zJkbH+sq80Fs4nAZY1sk4D/g/SKcmu56CAgUqabHCXn9RlQWRfFqNjUwqAM
        rP0/lNLRUtXln+ht4
X-Received: by 2002:a05:6402:10d7:: with SMTP id p23mr52205976edu.74.1625128471736;
        Thu, 01 Jul 2021 01:34:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNRoCTv59leRdo72JrMgUlFAjhjvxTe1Ob16ob0KnFpksXUFIcydSWDH2QctTutviqSFjmVg==
X-Received: by 2002:a05:6402:10d7:: with SMTP id p23mr52205945edu.74.1625128471529;
        Thu, 01 Jul 2021 01:34:31 -0700 (PDT)
Received: from krava ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id l22sm13514617edr.15.2021.07.01.01.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 01:34:31 -0700 (PDT)
Date:   Thu, 1 Jul 2021 10:34:28 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 4/5] bpf: Add bpf_get_func_ip helper for kprobe
 programs
Message-ID: <YN1+FJG6XXyuHNQe@krava>
References: <20210629192945.1071862-1-jolsa@kernel.org>
 <20210629192945.1071862-5-jolsa@kernel.org>
 <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 10:47:01AM -0700, Yonghong Song wrote:
> 
> 
> On 6/29/21 12:29 PM, Jiri Olsa wrote:
> > Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
> > so it's now possible to call bpf_get_func_ip from both kprobe and
> > kretprobe programs.
> > 
> > Taking the caller's address from 'struct kprobe::addr', which is
> > defined for both kprobe and kretprobe.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   include/uapi/linux/bpf.h       |  2 +-
> >   kernel/bpf/verifier.c          |  2 ++
> >   kernel/trace/bpf_trace.c       | 14 ++++++++++++++
> >   kernel/trace/trace_kprobe.c    | 20 ++++++++++++++++++--
> >   kernel/trace/trace_probe.h     |  5 +++++
> >   tools/include/uapi/linux/bpf.h |  2 +-
> >   6 files changed, 41 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 83e87ffdbb6e..4894f99a1993 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4783,7 +4783,7 @@ union bpf_attr {
> >    *
> >    * u64 bpf_get_func_ip(void *ctx)
> >    * 	Description
> > - * 		Get address of the traced function (for tracing programs).
> > + * 		Get address of the traced function (for tracing and kprobe programs).
> >    * 	Return
> >    * 		Address of the traced function.
> >    */
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 701ff7384fa7..b66e0a7104f8 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5979,6 +5979,8 @@ static bool has_get_func_ip(struct bpf_verifier_env *env)
> >   			return -ENOTSUPP;
> >   		}
> >   		return 0;
> > +	} else if (type == BPF_PROG_TYPE_KPROBE) {
> > +		return 0;
> >   	}
> >   	verbose(env, "func %s#%d not supported for program type %d\n",
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 9edd3b1a00ad..1a5bddce9abd 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -961,6 +961,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
> >   	.arg1_type	= ARG_PTR_TO_CTX,
> >   };
> > +BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> > +{
> > +	return trace_current_kprobe_addr();
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> > +	.func		= bpf_get_func_ip_kprobe,
> > +	.gpl_only	= true,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_PTR_TO_CTX,
> > +};
> > +
> >   const struct bpf_func_proto *
> >   bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   {
> > @@ -1092,6 +1104,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   	case BPF_FUNC_override_return:
> >   		return &bpf_override_return_proto;
> >   #endif
> > +	case BPF_FUNC_get_func_ip:
> > +		return &bpf_get_func_ip_proto_kprobe;
> >   	default:
> >   		return bpf_tracing_func_proto(func_id, prog);
> >   	}
> > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > index ea6178cb5e33..b07d5888db14 100644
> > --- a/kernel/trace/trace_kprobe.c
> > +++ b/kernel/trace/trace_kprobe.c
> > @@ -1570,6 +1570,18 @@ static int kretprobe_event_define_fields(struct trace_event_call *event_call)
> >   }
> >   #ifdef CONFIG_PERF_EVENTS
> > +/* Used by bpf get_func_ip helper */
> > +DEFINE_PER_CPU(u64, current_kprobe_addr) = 0;
> 
> Didn't check other architectures. But this should work
> for x86 where if nested kprobe happens, the second
> kprobe will not call kprobe handlers.
> 
> This essentially is to provide an additional parameter to
> bpf program. Andrii is developing a mechanism to
> save arbitrary data in *current task_struct*, which
> might be used here to save current_kprobe_addr, we can
> save one per cpu variable.

ok, will check.. was there a post already?

thanks,
jirka

> 
> > +
> > +u64 trace_current_kprobe_addr(void)
> > +{
> > +	return *this_cpu_ptr(&current_kprobe_addr);
> > +}
> > +
> > +static void trace_current_kprobe_set(struct trace_kprobe *tk)
> > +{
> > +	__this_cpu_write(current_kprobe_addr, (u64) tk->rp.kp.addr);
> > +}
> >   /* Kprobe profile handler */
> >   static int
> > @@ -1585,6 +1597,7 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
> >   		unsigned long orig_ip = instruction_pointer(regs);
> >   		int ret;
> > +		trace_current_kprobe_set(tk);
> >   		ret = trace_call_bpf(call, regs);
> >   		/*
> > @@ -1631,8 +1644,11 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
> >   	int size, __size, dsize;
> >   	int rctx;
> > -	if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
> > -		return;
> > +	if (bpf_prog_array_valid(call)) {
> > +		trace_current_kprobe_set(tk);
> > +		if (!trace_call_bpf(call, regs))
> > +			return;
> > +	}
> >   	head = this_cpu_ptr(call->perf_events);
> >   	if (hlist_empty(head))
> [...]
> 

