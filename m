Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C706C1448AB
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 01:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAVAD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 19:03:27 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33523 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 19:03:26 -0500
Received: by mail-pf1-f196.google.com with SMTP id z16so2358979pfk.0;
        Tue, 21 Jan 2020 16:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BTyeweeyeIFU8C/r6JAMXAKnmGdLmEgNkN2spf9BFoI=;
        b=babe4ezVJrG2aZVAnqFzOBy/dDAcob7eJDD+ErVjmRQ63dVn93xUhfLt+ojJmLPR/N
         QbxSbcfORaA9pbHhqE5vF+J0fFE839FHBQGuwqRls/euFNpNChLz0AwWsxMqw5Vwf0Z/
         wd3TLhmladZ5XPHJmK0hdbyA8UmUr60PP+tELXXw51xiYv5HsscI/pnaVEl1blIzjW0b
         9M9f4TSKo4/XXkNFFxADkw1Au+iLgfkKdUjLJQ7zXrZ4xymJcCiThIPMMpplty3FkjRg
         Cb/DpFWpNARcTrc7c4816LD6c/kq8x/TlBbeKi7oCbParwV3O2DR4oQ1ZNMjblCz28Gp
         tHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BTyeweeyeIFU8C/r6JAMXAKnmGdLmEgNkN2spf9BFoI=;
        b=YC/RxnmB5RD5HGFouCwXXjvvFPIAoNndSiuqbscVGNdhtHczPQo2bJ0fi4dIW3/Lnk
         1nFVjA7anzDBDkmVTuIuOghaTi59k/sbr/aXcz9qeKkOrotKWVg6wWU7ljPEMU1xKFBw
         gAMEd7zQGRdSr5SXXwtwxtS3tOQ98azko+Xz6FiMl61CQtrmuvgGyVhJseB9oKOn9Pmk
         kOpOCzeGBqe2Y9PzO65kUhiPYfDluWZsJniS5v/K8luqXKi/B0+577cPC9blSkWL1Qrd
         8C8huYb4mBPF9UqpQCEqz3DBvdzfZzql6vYuyMnhDmF29jZClkXYC9gkOB72PLhCmTHS
         z74g==
X-Gm-Message-State: APjAAAWabz2P3tsoR7wAQQ3gRBAi+NJUTvRSdA8RFP8PCGT2YDZ7GLL8
        1h+QzORL3jnpO9JZ7sJ6tga9vbXMmDo=
X-Google-Smtp-Source: APXvYqyqBbMaTb02mS4S4BBN+Ch4wG0sPXZpJrbOay1T/avKMwSktjxGwhHRzfAmdyTf/1pHqR0jsw==
X-Received: by 2002:a63:e649:: with SMTP id p9mr8253180pgj.15.1579651406003;
        Tue, 21 Jan 2020 16:03:26 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:3806])
        by smtp.gmail.com with ESMTPSA id l14sm553908pjq.5.2020.01.21.16.03.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 16:03:25 -0800 (PST)
Date:   Tue, 21 Jan 2020 16:03:23 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH 2/6] bpf: Add bpf_perf_event_output_kfunc
Message-ID: <20200122000322.ogarpgwv3xut75m3@ast-mbp.dhcp.thefacebook.com>
References: <20200121120512.758929-1-jolsa@kernel.org>
 <20200121120512.758929-3-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121120512.758929-3-jolsa@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 01:05:08PM +0100, Jiri Olsa wrote:
> Adding support to use perf_event_output in
> BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.
> 
> Using nesting regs array from raw tracepoint helpers.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 41 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 19e793aa441a..6a18e2ae6e30 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1172,6 +1172,43 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  	}
>  }
>  
> +BPF_CALL_5(bpf_perf_event_output_kfunc, void *, ctx, struct bpf_map *, map,
> +	   u64, flags, void *, data, u64, size)
> +{
> +	struct pt_regs *regs = get_bpf_raw_tp_regs();
> +	int ret;
> +
> +	if (IS_ERR(regs))
> +		return PTR_ERR(regs);
> +
> +	perf_fetch_caller_regs(regs);
> +	ret = ____bpf_perf_event_output(regs, map, flags, data, size);
> +	put_bpf_raw_tp_regs();
> +	return ret;
> +}

I'm not sure why copy paste bpf_perf_event_output_raw_tp() into new function.

> @@ -1181,6 +1218,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_skb_output_proto;
>  #endif
>  	default:
> +		if (prog->expected_attach_type == BPF_TRACE_FENTRY ||
> +		    prog->expected_attach_type == BPF_TRACE_FEXIT)
> +			return kfunc_prog_func_proto(func_id, prog);
> +
>  		return raw_tp_prog_func_proto(func_id, prog);

Are you saying bpf_perf_event_output_raw_tp() for some reason
didn't work for fentry/fexit?
But above is exact copy-paste and it somehow worked?

Ditto for patches 3,4.
