Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3336341207
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhCSBUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhCSBT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:19:59 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C10C06174A;
        Thu, 18 Mar 2021 18:19:58 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id l14so4011270ybe.2;
        Thu, 18 Mar 2021 18:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KwuOSitFmuGAmLlwJyNwkvkzt1PGw2wf2gc/nofwkNo=;
        b=PeXMvvo7EiPlcTZmQL04YE8al5Co7GTw9pm2chpouzDElCkFkzUJpBsj3VypafM+p1
         4UYUWe09QuVpJtqiagF0XgHyMkHSQoU1M/wDQ+cUn0yZ3epyC7hPz6h2UICz/TenOjHr
         wYnJjB4YmqFoJgyZyrbn437382pwz1I4t8PTUQ00peaXmXoIeQabgqWH7NmBkHhuGg7i
         vBf07MbJODWLF1leUPV0wlrY8GUehQ2zOpaBQ8kCce9JKuyKuZZRxCuIzPawDHW5cJWk
         7VFd2ZW9Y8ApZQOo1kiCDxo4C/4BBBAYjbBaDF7sP7N5+5HFiTY3GmZdwkexRdFMpM1l
         UzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KwuOSitFmuGAmLlwJyNwkvkzt1PGw2wf2gc/nofwkNo=;
        b=sz/enxaT6mCQbNBJ4ACiYhLwS2oGpimQyIbaSB+W+QCmnF7KBEUEBoV5Ai0uV17n5R
         nbTMRa48luxBJ73L33IwdLLqm+Ti8yJqzL6VSPP1LnsKrJOi/8rvdxaJ/KuIIr3KGPJF
         0PVZrpVstqRe3Zd9SU+J2i+MpypC/o69i94IawfMi8YCdk3PQHqEcWHMCHFNID/raf3m
         s5hMy41yBTqIfAFqZePa5M1hf4LA1d7U3x0ey6wx0sI3CP3v+6b6PWj/SPD0c1Ya79cP
         NBEwWOg4tO5yQgtw/Y3R7Y+XaQHjmX6ri7Xe7z7rBaQZNwa1ms/SopR1LT7CWfSHJcaQ
         9VAw==
X-Gm-Message-State: AOAM5322XN1smR5oLZkMnXiFWq2xXrVUmw6oc0DlUckW+CHN1puwlBFB
        LoERiUaXINe/kNKFsVF8MUYdWrzgILJ5ny9CfGs=
X-Google-Smtp-Source: ABdhPJzmM54rKwtEOgI4YH+zBYK2D0uKQ+prgOcifBNkX1USIbDnxP1HOun0V7CFbjwXe5NOONJ4HAIKz2rpVF2NqCw=
X-Received: by 2002:a25:4982:: with SMTP id w124mr2999119yba.27.1616116798156;
 Thu, 18 Mar 2021 18:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011420.4177709-1-kafai@fb.com>
In-Reply-To: <20210316011420.4177709-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 18:19:46 -0700
Message-ID: <CAEf4BzYQrudAibsR8zp22dEuBF_iXgziAm46sVCO=98ATeqAqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/15] bpf: tcp: White list some tcp cong
 functions to be called by bpf-tcp-cc
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch white list some tcp cong helper functions, tcp_slow_start()
> and tcp_cong_avoid_ai().  They are allowed to be directly called by
> the bpf-tcp-cc program.
>
> A few tcp cc implementation functions are also white listed.
> A potential use case is the bpf-tcp-cc implementation may only
> want to override a subset of a tcp_congestion_ops.  For others,
> the bpf-tcp-cc can directly call the kernel counter parts instead of
> re-implementing (or copy-and-pasting) them to the bpf program.
>
> They will only be available to the bpf-tcp-cc typed program.
> The white listed functions are not bounded to a fixed ABI contract.
> When any of them has changed, the bpf-tcp-cc program has to be changed
> like any in-tree/out-of-tree kernel tcp-cc implementations do also.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Just nits, of course :)

Whitelist is a single word, but see also 49decddd39e5 ("Merge tag
'inclusive-terminology' of
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux"),
allowlist/denylist is recommended for new code.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  net/ipv4/bpf_tcp_ca.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> index d520e61649c8..ed6e6b5b762b 100644
> --- a/net/ipv4/bpf_tcp_ca.c
> +++ b/net/ipv4/bpf_tcp_ca.c
> @@ -5,6 +5,7 @@
>  #include <linux/bpf_verifier.h>
>  #include <linux/bpf.h>
>  #include <linux/btf.h>
> +#include <linux/btf_ids.h>
>  #include <linux/filter.h>
>  #include <net/tcp.h>
>  #include <net/bpf_sk_storage.h>
> @@ -178,10 +179,50 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
>         }
>  }
>
> +BTF_SET_START(bpf_tcp_ca_kfunc_ids)
> +BTF_ID(func, tcp_reno_ssthresh)
> +BTF_ID(func, tcp_reno_cong_avoid)
> +BTF_ID(func, tcp_reno_undo_cwnd)
> +BTF_ID(func, tcp_slow_start)
> +BTF_ID(func, tcp_cong_avoid_ai)
> +#if IS_BUILTIN(CONFIG_TCP_CONG_CUBIC)
> +BTF_ID(func, cubictcp_init)
> +BTF_ID(func, cubictcp_recalc_ssthresh)
> +BTF_ID(func, cubictcp_cong_avoid)
> +BTF_ID(func, cubictcp_state)
> +BTF_ID(func, cubictcp_cwnd_event)
> +BTF_ID(func, cubictcp_acked)
> +#endif
> +#if IS_BUILTIN(CONFIG_TCP_CONG_DCTCP)
> +BTF_ID(func, dctcp_init)
> +BTF_ID(func, dctcp_update_alpha)
> +BTF_ID(func, dctcp_cwnd_event)
> +BTF_ID(func, dctcp_ssthresh)
> +BTF_ID(func, dctcp_cwnd_undo)
> +BTF_ID(func, dctcp_state)
> +#endif
> +#if IS_BUILTIN(CONFIG_TCP_CONG_BBR)
> +BTF_ID(func, bbr_init)
> +BTF_ID(func, bbr_main)
> +BTF_ID(func, bbr_sndbuf_expand)
> +BTF_ID(func, bbr_undo_cwnd)
> +BTF_ID(func, bbr_cwnd_even),
> +BTF_ID(func, bbr_ssthresh)
> +BTF_ID(func, bbr_min_tso_segs)
> +BTF_ID(func, bbr_set_state)
> +#endif
> +BTF_SET_END(bpf_tcp_ca_kfunc_ids)

see, kfunc here...

> +
> +static bool bpf_tcp_ca_check_kern_func_call(u32 kfunc_btf_id)

...but more verbose kern_func here. I like kfunc everywhere ;)

> +{
> +       return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
> +}
> +
>  static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
>         .get_func_proto         = bpf_tcp_ca_get_func_proto,
>         .is_valid_access        = bpf_tcp_ca_is_valid_access,
>         .btf_struct_access      = bpf_tcp_ca_btf_struct_access,
> +       .check_kern_func_call   = bpf_tcp_ca_check_kern_func_call,
>  };
>
>  static int bpf_tcp_ca_init_member(const struct btf_type *t,
> --
> 2.30.2
>
