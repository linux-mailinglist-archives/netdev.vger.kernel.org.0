Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453D81A3EB7
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 05:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDJD0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 23:26:12 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53273 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgDJD0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 23:26:11 -0400
Received: by mail-pj1-f66.google.com with SMTP id l36so315949pjb.3;
        Thu, 09 Apr 2020 20:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9JV/gsI/brY30JMD45NU99lc9N/lQD3DootR2HCpf9s=;
        b=VJ7SBbt3LGmi1I51RpkDElx8zeZ0zTDiddVE3g6vdPnPlIYgVr+7jIlQgp6wifUzBM
         kYkeYpxOX7RAS2ZdAOp6NvvpjJIqGN8yznTYemjCBlo5DAURaYju6ytLDHKVTvriBIsY
         CbHzX96/fjIJsOaLspIIx8ONvasZbPLwbF4Z5Lw9z8vx3MS3RI/3URzZeEl+1cLPCtIh
         xZBqJedlB82ALKx6Jxg9d3LLFlc8fXRudVGWMPQeSu2gOI/UhoeKgo62g+JMSdDlTUuS
         BZPTbPlnMRRjKNh991m4bc03Lbwk6oZOkbMLozpmJSPUo7zr8CpDV9u/ACWRQVHHaFwE
         HIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9JV/gsI/brY30JMD45NU99lc9N/lQD3DootR2HCpf9s=;
        b=XfhDl6ObB1irkpgjsy4TIExmVGZDzt/3PvIhptGqBncMxlm64emhwpQJl85g3s5PRA
         B29eg2y9lBwEDUKIDOU6660d9dbBp/3AiEzw54lDFSfqi0Vww+YL6f3N40fFpW2Nbk2O
         TkJsfY6Qj9O+XODJVMpotZhAxjRQJMx5t5qYyODNfN4xEXIhxccLHYhsdOCo64zTvFPz
         3QnYq3Z2QCyZcQARDM9MeTn8bMEHRdTC8YQ1zUqfr3eqQXc14osqSUrmp85jwwRWiSzD
         Vh1bdxTFQK6bmVvL6Ve1fx6MxFvVdbaFcdoFFw6z9mu4616aXO+D3/EMsK6ZD8gvBZ/q
         uSWw==
X-Gm-Message-State: AGi0Pub5rPuL7Roloa+tL8GbrqH7ARUFUpMf13buwEryomolvsrfjp6j
        e741qfckU3U6YklKjBWMYh0=
X-Google-Smtp-Source: APiQypIKjpM00TRQc2qwLkCo476xsCa4g9R+8wK/dTWobNAAKn99DnIJSjk7Z/rJEtbv68pX4EVL3Q==
X-Received: by 2002:a17:902:342:: with SMTP id 60mr2899118pld.29.1586489170914;
        Thu, 09 Apr 2020 20:26:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f219])
        by smtp.gmail.com with ESMTPSA id i26sm504427pfk.176.2020.04.09.20.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 20:26:10 -0700 (PDT)
Date:   Thu, 9 Apr 2020 20:26:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next 09/16] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
Message-ID: <20200410032608.x5hloyizpfyxnudz@ast-mbp.dhcp.thefacebook.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232531.2676134-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408232531.2676134-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 04:25:31PM -0700, Yonghong Song wrote:
>  
> +BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size, u64, arg1,
> +	   u64, arg2)
> +{
> +	bool buf_used = false;
> +	int i, copy_size;
> +	int mod[2] = {};
> +	int fmt_cnt = 0;
> +	u64 unsafe_addr;
> +	char buf[64];
> +
> +	/*
> +	 * bpf_check()->check_func_arg()->check_stack_boundary()
> +	 * guarantees that fmt points to bpf program stack,
> +	 * fmt_size bytes of it were initialized and fmt_size > 0
> +	 */
> +	if (fmt[--fmt_size] != 0)
> +		return -EINVAL;
...
> +/* Horrid workaround for getting va_list handling working with different
> + * argument type combinations generically for 32 and 64 bit archs.
> + */
> +#define __BPF_SP_EMIT()	__BPF_ARG2_SP()
> +#define __BPF_SP(...)							\
> +	seq_printf(m, fmt, ##__VA_ARGS__)
> +
> +#define __BPF_ARG1_SP(...)						\
> +	((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))	\
> +	  ? __BPF_SP(arg1, ##__VA_ARGS__)				\
> +	  : ((mod[0] == 1 || (mod[0] == 0 && __BITS_PER_LONG == 32))	\
> +	      ? __BPF_SP((long)arg1, ##__VA_ARGS__)			\
> +	      : __BPF_SP((u32)arg1, ##__VA_ARGS__)))
> +
> +#define __BPF_ARG2_SP(...)						\
> +	((mod[1] == 2 || (mod[1] == 1 && __BITS_PER_LONG == 64))	\
> +	  ? __BPF_ARG1_SP(arg2, ##__VA_ARGS__)				\
> +	  : ((mod[1] == 1 || (mod[1] == 0 && __BITS_PER_LONG == 32))	\
> +	      ? __BPF_ARG1_SP((long)arg2, ##__VA_ARGS__)		\
> +	      : __BPF_ARG1_SP((u32)arg2, ##__VA_ARGS__)))
> +
> +	__BPF_SP_EMIT();
> +	return seq_has_overflowed(m);
> +}

This function is mostly a copy-paste of bpf_trace_printk() with difference
of printing via seq_printf vs __trace_printk.
Please find a way to share the code.
