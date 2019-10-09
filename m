Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF138D055E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfJIBvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:51:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37442 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfJIBvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:51:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id p1so359303pgi.4;
        Tue, 08 Oct 2019 18:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=0mdGCRWjUTyephaV+2jLG555MDHtlgXCjF9iBbHjnFI=;
        b=c4jBo2/PxNveO+hjo+EwN1iUIMTH27FSWNE5WRyJ/riN3TRxT5zkTgf+YRFyFyjBqy
         4vEfWe0zKFXGcRR04pNf1QK8uHJeX5KHVchpysApe2iXETMADBIHoo9QBQvDKsUDRf7+
         9zACo1f2DkXgpeF02DkE1z0vaYxuIRuVYxtEfCS/y+GpVnFEHDIfSuZCq1vPGEjN/TiA
         Y55F0fzWaB4kseQ0YNn9uTbeKxX9aF/ySR9HsN/riRWiKIA8fUt1e2xsEH6Fv18ztoY8
         MeBGxja2xw/wKocDgGkIfWk7CWDqo2O4lB3YLwmYRtSa5mi3E7oOsiXPUNMRE/tuKJaC
         Njmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=0mdGCRWjUTyephaV+2jLG555MDHtlgXCjF9iBbHjnFI=;
        b=fZ41kHZD7cQ7/Xb02msIj6L/7K4fuNpp4UnGC7m3CycHNUfAdl9bWZqKz2RtfLJJ3E
         A4UJJUD4UWrf3Gjq/vSy2vhG8Uap/6uD140S02KrKtTk+epRASD04ZTdOiFjVZVpIFKH
         9laTS4JuuNH2pcybZfGCEs7r1xXY8FnN2GMqDR+7ah3lc7FRenmKxiwK7brtM7kCip97
         e3cwxAd520/0yLMaOknYwbzRGx/ohFBhoTQi42YVsVkKElNH+n6gpOFQqJPGhDXj045I
         tbhjKJOv7kuWoSnxN/m/Oz4NjzguvKvI5VtdakxOp/zxSAgR3o/HKr9+1KUTdCAJzPRe
         AxcQ==
X-Gm-Message-State: APjAAAWmf9lku+lbWLXiZRWGzQxZBPFbQecNVfVrxSGcLEZByb6m3Kfg
        QTYpmfwIQ3V5c6ibhKQLsBw=
X-Google-Smtp-Source: APXvYqzgFStDLl40mKVxSCJp5phF42olQABHpPmPsW4UcTx/6QRdRGarQ7NV+3ig1wzT40274rhYaA==
X-Received: by 2002:a63:d450:: with SMTP id i16mr1642635pgj.126.1570585882017;
        Tue, 08 Oct 2019 18:51:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::851e])
        by smtp.gmail.com with ESMTPSA id b5sm352496pfp.38.2019.10.08.18.51.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 18:51:21 -0700 (PDT)
Date:   Tue, 8 Oct 2019 18:51:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Message-ID: <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
 <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sgo3lkx9.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:07:46AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Mon, Oct 07, 2019 at 07:20:36PM +0200, Toke Høiland-Jørgensen wrote:
> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
> >> 
> >> This adds support for wrapping eBPF program dispatch in chain calling
> >> logic. The code injection is controlled by a flag at program load time; if
> >> the flag is set, the BPF program will carry a flag bit that changes the
> >> program dispatch logic to wrap it in a chain call loop.
> >> 
> >> Ideally, it shouldn't be necessary to set the flag on program load time,
> >> but rather inject the calls when a chain call program is first loaded. The
> >> allocation logic sets the whole of struct bpf_prog to be read-only memory,
> >> so it can't immediately be modified, but conceivably we could just unlock
> >> the first page of the struct and flip the bit when a chain call program is
> >> first attached.
> >> 
> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> ---
> >>  include/linux/bpf.h      |    3 +++
> >>  include/linux/filter.h   |   34 ++++++++++++++++++++++++++++++++--
> >>  include/uapi/linux/bpf.h |    6 ++++++
> >>  kernel/bpf/core.c        |    6 ++++++
> >>  kernel/bpf/syscall.c     |    4 +++-
> >>  5 files changed, 50 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index 5b9d22338606..13e5f38cf5c6 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -365,6 +365,8 @@ struct bpf_prog_stats {
> >>  	struct u64_stats_sync syncp;
> >>  };
> >>  
> >> +#define BPF_NUM_CHAIN_SLOTS 8
> >> +
> >>  struct bpf_prog_aux {
> >>  	atomic_t refcnt;
> >>  	u32 used_map_cnt;
> >> @@ -383,6 +385,7 @@ struct bpf_prog_aux {
> >>  	struct list_head ksym_lnode;
> >>  	const struct bpf_prog_ops *ops;
> >>  	struct bpf_map **used_maps;
> >> +	struct bpf_prog *chain_progs[BPF_NUM_CHAIN_SLOTS];
> >>  	struct bpf_prog *prog;
> >>  	struct user_struct *user;
> >>  	u64 load_time; /* ns since boottime */
> >> diff --git a/include/linux/filter.h b/include/linux/filter.h
> >> index 2ce57645f3cd..3d1e4991e61d 100644
> >> --- a/include/linux/filter.h
> >> +++ b/include/linux/filter.h
> >> @@ -21,6 +21,7 @@
> >>  #include <linux/kallsyms.h>
> >>  #include <linux/if_vlan.h>
> >>  #include <linux/vmalloc.h>
> >> +#include <linux/nospec.h>
> >>  
> >>  #include <net/sch_generic.h>
> >>  
> >> @@ -528,6 +529,7 @@ struct bpf_prog {
> >>  				is_func:1,	/* program is a bpf function */
> >>  				kprobe_override:1, /* Do we override a kprobe? */
> >>  				has_callchain_buf:1, /* callchain buffer allocated? */
> >> +				chain_calls:1, /* should this use the chain_call wrapper */
> >>  				enforce_expected_attach_type:1; /* Enforce expected_attach_type checking at attach time */
> >>  	enum bpf_prog_type	type;		/* Type of BPF program */
> >>  	enum bpf_attach_type	expected_attach_type; /* For some prog types */
> >> @@ -551,6 +553,30 @@ struct sk_filter {
> >>  	struct bpf_prog	*prog;
> >>  };
> >>  
> >> +#define BPF_MAX_CHAIN_CALLS 32
> >> +static __always_inline unsigned int do_chain_calls(const struct bpf_prog *prog,
> >> +						   const void *ctx)
> >> +{
> >> +	int i = BPF_MAX_CHAIN_CALLS;
> >> +	int idx;
> >> +	u32 ret;
> >> +
> >> +	do {
> >> +		ret = (*(prog)->bpf_func)(ctx, prog->insnsi);
> >
> > This breaks program stats.
> 
> Oh, right, silly me. Will fix.
> 
> >> +
> >> +		if (ret + 1 >= BPF_NUM_CHAIN_SLOTS) {
> >> +			prog = prog->aux->chain_progs[0];
> >> +			continue;
> >> +		}
> >> +		idx = ret + 1;
> >> +		idx = array_index_nospec(idx, BPF_NUM_CHAIN_SLOTS);
> >> +
> >> +		prog = prog->aux->chain_progs[idx] ?: prog->aux->chain_progs[0];
> >> +	} while (prog && --i);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >>  DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> >>  
> >>  #define BPF_PROG_RUN(prog, ctx)	({				\
> >> @@ -559,14 +585,18 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> >>  	if (static_branch_unlikely(&bpf_stats_enabled_key)) {	\
> >>  		struct bpf_prog_stats *stats;			\
> >>  		u64 start = sched_clock();			\
> >> -		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
> >> +		ret = prog->chain_calls ?			\
> >> +			do_chain_calls(prog, ctx) :			\
> >> +			 (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
> >
> > I thought you agreed on 'no performance regressions' rule?
> 
> As I wrote in the cover letter I could not measurable a performance
> impact from this, even with the simplest possible XDP program (where
> program setup time has the largest impact).
> 
> This was the performance before/after patch (also in the cover letter):
> 
> Before patch (XDP DROP program):  31.5 Mpps
> After patch (XDP DROP program):   32.0 Mpps
> 
> So actually this *increases* performance ;)
> (Or rather, the difference is within the measurement uncertainty on my
> system).

I have hard time believing such numbers.
If I wasn't clear before: Nack to such hack in BPF_PROG_RUN.
Please implement proper indirect calls and jumps.
Apps have to cooperate with each other regardless
whereas above is a narrow solution to one problem.

