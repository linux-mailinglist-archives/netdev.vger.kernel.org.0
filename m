Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D485108168
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKXB7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:59:11 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39568 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfKXB7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:59:11 -0500
Received: by mail-pj1-f68.google.com with SMTP id v93so1565921pjb.6;
        Sat, 23 Nov 2019 17:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=vMn7ZocFioCM73wm+s8+cVy75L+8mxcsii3pNfRq9Ps=;
        b=dPfkNLNega8sjiTmeCMmiw5K9LaOnZOTalNvk5vUWv72sLtuf9sYO6KMgdoy/5szpr
         qupFMxjtzLtJQkxyGuPv4PBUT1adkZoUA5FREoz1foi0NHk69aEbexrhT2QuUpEU972R
         hsMlL/ShZgbVb6X4cm0gkPWAeiKcV08cZyfztOT9KCOiP6NcwwNRb0154RR+EcEQpIPf
         Bk6DUt9q04dZUgU1FEk1oY0ew1AuNkBD1Em1JYZ6YlxXQEu38IYm3yPWE9B1Qh8abJJF
         DJPibLuCPu30nw5bBqkVOp6iIdaGWAruZlaz1tOI8gucHveQ+I/EMbMtjpuDvLK4WOaI
         lHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vMn7ZocFioCM73wm+s8+cVy75L+8mxcsii3pNfRq9Ps=;
        b=ej3195NW7pSSiG0cjNQ1T/GO41iQ6aGUxiwxAB5YIT8yuTHQ3CtgORN+cM92zfuhS6
         lqDNYj02aC+nf6zUfqX7U6VPq/RPNHo8oe6FzEfz1UDc0CV8BmhSiW5Mk/4sQ08H83Me
         bS7mD9bqb5fMbBaw2dpIJ9wui1HY5BTmjjydb6S5L8cQUcbk3noC1f05xPWL8mv1bXIM
         p9mypPeqZHjtXfmLSUvxfWlYO//dku2MUNMdydGdoq/BQWZ5VYyfatjiJwLNbYUN0lHE
         gq4CqqdnAMxLag70ErM4W3S1p9vIjYM2rmxyaTjrlDSP59bMiTF7PDwU5QQOz+MOm4wO
         pEWw==
X-Gm-Message-State: APjAAAVAm/vC96Gw0v1lfqUJmmiaKMGRt6DAH2CSthIqBiXk6mffH6ZD
        XXldZ3j83KNA7dnWX75EbAY=
X-Google-Smtp-Source: APXvYqz9YBucCCArDFrnk9Cil1lwQJG4OnTlNfTR2YBDl1nAN+dZxOHKgZUhKyA60ahJzSRtuJWnjA==
X-Received: by 2002:a17:90a:f983:: with SMTP id cq3mr26007179pjb.54.1574560750305;
        Sat, 23 Nov 2019 17:59:10 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::c39e])
        by smtp.gmail.com with ESMTPSA id v15sm2930932pfe.44.2019.11.23.17.59.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 17:59:09 -0800 (PST)
Date:   Sat, 23 Nov 2019 17:59:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: Re: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
Message-ID: <20191124015907.fdqr2v2jymewjesd@ast-mbp.dhcp.thefacebook.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
 <20191123071226.6501-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191123071226.6501-3-bjorn.topel@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 08:12:21AM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The xdp_call.h header wraps a more user-friendly API around the BPF
> dispatcher. A user adds a trampoline/XDP caller using the
> DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
> xdp_call_update(). The actual dispatch is done via xdp_call().
> 
> Note that xdp_call() is only supported for builtin drivers. Module
> builds will fallback to bpf_prog_run_xdp().
> 
> The next patch will show-case how the i40e driver uses xdp_call.
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  include/linux/xdp_call.h | 66 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 include/linux/xdp_call.h
> 
> diff --git a/include/linux/xdp_call.h b/include/linux/xdp_call.h
> new file mode 100644
> index 000000000000..69b2d325a787
> --- /dev/null
> +++ b/include/linux/xdp_call.h
> @@ -0,0 +1,66 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2019 Intel Corporation. */
> +#ifndef _LINUX_XDP_CALL_H
> +#define _LINUX_XDP_CALL_H
> +
> +#include <linux/filter.h>
> +
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_RETPOLINE) && !defined(MODULE)
> +
> +void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
> +				struct bpf_prog *to);
> +
> +#define XDP_CALL_TRAMP(name)	____xdp_call_##name##_tramp
> +
> +#define DEFINE_XDP_CALL(name)						\
> +	unsigned int XDP_CALL_TRAMP(name)(				\
> +		const void *xdp_ctx,					\
> +		const struct bpf_insn *insnsi,				\
> +		unsigned int (*bpf_func)(const void *,			\
> +					 const struct bpf_insn *))	\
> +	{								\
> +		return bpf_func(xdp_ctx, insnsi);			\
> +	}
> +
> +#define DECLARE_XDP_CALL(name)						\
> +	unsigned int XDP_CALL_TRAMP(name)(				\
> +		const void *xdp_ctx,					\
> +		const struct bpf_insn *insnsi,				\
> +		unsigned int (*bpf_func)(const void *,			\
> +					 const struct bpf_insn *))
> +
> +#define xdp_call_run(name, prog, ctx) ({				\
> +	u32 ret;							\
> +	cant_sleep();							\
> +	if (static_branch_unlikely(&bpf_stats_enabled_key)) {		\
> +		struct bpf_prog_stats *stats;				\
> +		u64 start = sched_clock();				\
> +		ret = XDP_CALL_TRAMP(name)(ctx,				\
> +					   (prog)->insnsi,		\
> +					   (prog)->bpf_func);		\
> +		stats = this_cpu_ptr((prog)->aux->stats);		\
> +		u64_stats_update_begin(&stats->syncp);			\
> +		stats->cnt++;						\
> +		stats->nsecs += sched_clock() - start;			\
> +		u64_stats_update_end(&stats->syncp);			\
> +	} else {							\
> +		ret = XDP_CALL_TRAMP(name)(ctx,				\
> +					   (prog)->insnsi,		\
> +					   (prog)->bpf_func);		\
> +	}								\
> +	ret; })

I cannot help but wonder whether it's possible to avoid copy-paste from
BPF_PROG_RUN().
At least could you place this new macro right next to BPF_PROG_RUN?
If it's in a different file eventually they may diverge.

