Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016B5114C65
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 07:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfLFGjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 01:39:48 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45078 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfLFGjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 01:39:48 -0500
Received: by mail-pl1-f194.google.com with SMTP id w7so2285162plz.12;
        Thu, 05 Dec 2019 22:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PnshtQ+DzSYB1m1s28YhSp8Zch6aeX4Qzf6E+sbGNmo=;
        b=V0CATjTs5ss1fAXSo5bWATeALS7lPYJIkaR9pZK7xjv+dw92RFc5wl4BIfvRvJKzTp
         nUwC8e0mWh2IHlvV677ssfj8jHS1T0LvIG42N41uPRsiiKkowuPhGanjXnwzXeUK/iMT
         fKvNFyUaU4s+tmKbWIEWCM63VzHMPaOuB3UU94F2TiqBtxHpaO2GZkFChsqt8Do86aJC
         TiYi+gMoQYh8XJ5SfeA7GIVeqbMizBF1Jh19ZCjDqP7g706aeWeLvDrgCSFxb4/poJwe
         WMQcZYLKn4UoZGErZaB6ZvYtsu1uCQUVQOjyVjAYtfxeK2y4/wdMG17jem5QALz8SdOG
         MFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PnshtQ+DzSYB1m1s28YhSp8Zch6aeX4Qzf6E+sbGNmo=;
        b=NcIy6Da+9ZgY77H7k42caUhLEY77GWmfLIKr2lAvMYKkviCgWLs8F5lMByQma12WKq
         80cjcaSrtgo/pRJWxK4zSnbeLU0La4M+Pr7oHbVdVNKq/rfEtUV60Cd+ua08wUf45Fna
         XUB2Rb228mtGpPvywE+9IkJAgXMh3NXJEQDduYFW34VwZ8lnxpIr2XOeg8MiS9PoTjom
         PLyrQ0l/oafAt/lL/oisaONb/AICplTlfC/cEb+DislqfDzTAmKr26a9T2IIYk0PY1jj
         cnGhmVYzbwdOmLHpQf8YkYG+0AEW0rcLRC42Fh1L0tHeUDzefiBef9AX/a8mVeXSO1kp
         PCoQ==
X-Gm-Message-State: APjAAAW/zFJ5tqNOgM1PbBQOyDabsQY3mod2hApg2vR36KUEYnWKhJ08
        AEkZ+UM6eG5jWmLv/a8jBystQYHV
X-Google-Smtp-Source: APXvYqxIDjbtlEDF9USGivZjgPtRtUc5jVe6auF3YFJtnwos7C2FzEiVwPRfq3vgfXYVNHaDrIzbkQ==
X-Received: by 2002:a17:90a:9f85:: with SMTP id o5mr2442419pjp.0.1575614387092;
        Thu, 05 Dec 2019 22:39:47 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::3f95])
        by smtp.gmail.com with ESMTPSA id v29sm13336847pgl.88.2019.12.05.22.39.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 22:39:46 -0800 (PST)
Date:   Thu, 5 Dec 2019 22:39:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf] bpf: Add LBR data to BPF_PROG_TYPE_PERF_EVENT prog
 context
Message-ID: <20191206063942.5qd6opj6dfgqyxyx@ast-mbp.dhcp.thefacebook.com>
References: <20191206001226.67825-1-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206001226.67825-1-dxu@dxuuu.xyz>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 04:12:26PM -0800, Daniel Xu wrote:
> Last-branch-record is an intel CPU feature that can be configured to
> record certain branches that are taken during code execution. This data
> is particularly interesting for profile guided optimizations. perf has
> had LBR support for a while but the data collection can be a bit coarse
> grained.
> 
> We (Facebook) have recently run a lot of experiments with feeding
> filtered LBR data to various PGO pipelines. We've seen really good
> results (+2.5% throughput with lower cpu util and lower latency) by
> feeding high request latency LBR branches to the compiler on a
> request-oriented service. We used bpf to read a special request context
> ID (which is how we associate branches with latency) from a fixed
> userspace address. Reading from the fixed address is why bpf support is
> useful.
> 
> Aside from this particular use case, having LBR data available to bpf
> progs can be useful to get stack traces out of userspace applications
> that omit frame pointers.
> 
> This patch adds support for LBR data to bpf perf progs.
> 
> Some notes:
> * We use `__u64 entries[BPF_MAX_LBR_ENTRIES * 3]` instead of
>   `struct perf_branch_entry[BPF_MAX_LBR_ENTRIES]` because checkpatch.pl
>   warns about including a uapi header from another uapi header
> 
> * We define BPF_MAX_LBR_ENTRIES as 32 (instead of using the value from
>   arch/x86/events/perf_events.h) because including arch specific headers
>   seems wrong and could introduce circular header includes.
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  include/uapi/linux/bpf_perf_event.h |  5 ++++
>  kernel/trace/bpf_trace.c            | 39 +++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf_perf_event.h b/include/uapi/linux/bpf_perf_event.h
> index eb1b9d21250c..dc87e3d50390 100644
> --- a/include/uapi/linux/bpf_perf_event.h
> +++ b/include/uapi/linux/bpf_perf_event.h
> @@ -10,10 +10,15 @@
>  
>  #include <asm/bpf_perf_event.h>
>  
> +#define BPF_MAX_LBR_ENTRIES 32
> +
>  struct bpf_perf_event_data {
>  	bpf_user_pt_regs_t regs;
>  	__u64 sample_period;
>  	__u64 addr;
> +	__u64 nr_lbr;
> +	/* Cast to struct perf_branch_entry* before using */
> +	__u64 entries[BPF_MAX_LBR_ENTRIES * 3];
>  };
>  
>  #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index ffc91d4935ac..96ba7995b3d7 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1259,6 +1259,14 @@ static bool pe_prog_is_valid_access(int off, int size, enum bpf_access_type type
>  		if (!bpf_ctx_narrow_access_ok(off, size, size_u64))
>  			return false;
>  		break;
> +	case bpf_ctx_range(struct bpf_perf_event_data, nr_lbr):
> +		bpf_ctx_record_field_size(info, size_u64);
> +		if (!bpf_ctx_narrow_access_ok(off, size, size_u64))
> +			return false;
> +		break;
> +	case bpf_ctx_range(struct bpf_perf_event_data, entries):
> +		/* No narrow loads */
> +		break;
>  	default:
>  		if (size != sizeof(long))
>  			return false;
> @@ -1273,6 +1281,7 @@ static u32 pe_prog_convert_ctx_access(enum bpf_access_type type,
>  				      struct bpf_prog *prog, u32 *target_size)
>  {
>  	struct bpf_insn *insn = insn_buf;
> +	int off;
>  
>  	switch (si->off) {
>  	case offsetof(struct bpf_perf_event_data, sample_period):
> @@ -1291,6 +1300,36 @@ static u32 pe_prog_convert_ctx_access(enum bpf_access_type type,
>  				      bpf_target_off(struct perf_sample_data, addr, 8,
>  						     target_size));
>  		break;
> +	case offsetof(struct bpf_perf_event_data, nr_lbr):
> +		/* Load struct perf_sample_data* */
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_perf_event_data_kern,
> +						       data), si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_perf_event_data_kern, data));
> +		/* Load struct perf_branch_stack* */
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct perf_sample_data, br_stack),
> +				      si->dst_reg, si->dst_reg,
> +				      offsetof(struct perf_sample_data, br_stack));

br_stack can be NULL.
if != NULL check has to be emitted too.

Otherwise looks good.
Please add a selftest and resubmit when bpf-next reopens next week.

