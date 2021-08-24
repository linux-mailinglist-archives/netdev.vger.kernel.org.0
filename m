Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020CD3F5760
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhHXEjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhHXEjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:39:37 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF20C061575;
        Mon, 23 Aug 2021 21:38:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z5so38498354ybj.2;
        Mon, 23 Aug 2021 21:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=osgxfVH3etU3QfQUsPTomN47N590LkAY5En3qSBUxJI=;
        b=Q4ehbm7CMa0LgPPtHVSdMQCu2IEQATzLHGzLGMWYxQOaXzGWf9spud5MEgtlAJ0zdf
         4JzijO09x0sVLxHHhepbaq1mxW1c9DzWIxxVftCU1zxI8ZaKuc7ato+USYIkXr+2fBU5
         NZtlyTJIPlqXxzXAUpKrpiqMTeSDAELQJ/1W8q5FGwwR2fkH+NJm50Oa2DjtGy7s4KuV
         xvRw6Ul4D7wALiDIRgdNcEv0icfeCKKh/hJe2GgI2NEa+WE1XQln1Vlpov6q+CgYX4xS
         slBb0+Dm/nhrV62eJIA+0ug4vin/OOxoKvkgB9LzxN4/Xvo8kBSxoTbHhLEzdP139M8z
         Angg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=osgxfVH3etU3QfQUsPTomN47N590LkAY5En3qSBUxJI=;
        b=TYXshH/k6dYv64jhv8DrUwpiE4IWi0SAGhy9m3tUi0xdUB/C7+8gLaRLLwMvMNyz2F
         s2Rzkfff6zHSNiMd8+87zGq89HHp2nS9asVEVHwRZB9V4YDhBLx/DWqbcTrzekT7gj8U
         o3EFEKTbxKBHdTnBObvb3xISghj1fMVcHrrBjSlde8rngQ/s+YMR/ynous+ZtT9rRHTk
         54d9B4FiOTFNVldsDp1mKEq/MruPZ5qvF2J6XFYtNGDGFW8KnimKYHj5puCn2dDQMW0C
         2DlqFmhB99v8X2f1uI1Pk7MNmrYjlzoOwPQfNc6w8HiPMZ/N9+Fm+h0fn98UBqSr9zMF
         QLJA==
X-Gm-Message-State: AOAM531PgITWxThykhMsb4NOxWe+PLrwKlTxCCSjiDof7N32pQB9oyWe
        Fjk0eUSh2f8buXYc5cYOJWJH9FqilxJkB+95sjQ=
X-Google-Smtp-Source: ABdhPJymjl/RgFLFne0oP52/41kFFc17Q2dCJTSwGpW/VViyBOJROnYzbMnJ0FiHtxKn1EPkqWMgR/eAlOxsfJqWcHE=
X-Received: by 2002:a25:fc10:: with SMTP id v16mr28153499ybd.510.1629779932758;
 Mon, 23 Aug 2021 21:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com> <20210821025837.1614098-2-davemarchevsky@fb.com>
In-Reply-To: <20210821025837.1614098-2-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Aug 2021 21:38:41 -0700
Message-ID: <CAEf4BzaLZ0dnJMurvvuZamUQXMzSnoCs5NvZh03vrtF905Mi9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpf: merge printk and seq_printf VARARG max macros
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 7:59 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> MAX_SNPRINTF_VARARGS and MAX_SEQ_PRINTF_VARARGS are used by bpf helpers
> bpf_snprintf and bpf_seq_printf to limit their varargs. Both call into
> bpf_bprintf_prepare for print formatting logic and have convenience
> macros in libbpf (BPF_SNPRINTF, BPF_SEQ_PRINTF) which use the same
> helper macros to convert varargs to a byte array.
>
> Changing shared functionality to support more varargs for either bpf
> helper would affect the other as well, so let's combine the _VARARGS
> macros to make this more obvious.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/bpf.h      | 2 ++
>  kernel/bpf/helpers.c     | 4 +---
>  kernel/trace/bpf_trace.c | 4 +---
>  3 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f4c16f19f83e..be8d57e6e78a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2216,6 +2216,8 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
>  struct btf_id_set;
>  bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
>
> +#define MAX_BPRINTF_VARARGS            12
> +
>  int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>                         u32 **bin_buf, u32 num_args);
>  void bpf_bprintf_cleanup(void);
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 4e8540716187..5ce19b376ef7 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -969,15 +969,13 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
>         return err;
>  }
>
> -#define MAX_SNPRINTF_VARARGS           12
> -
>  BPF_CALL_5(bpf_snprintf, char *, str, u32, str_size, char *, fmt,
>            const void *, data, u32, data_len)
>  {
>         int err, num_args;
>         u32 *bin_args;
>
> -       if (data_len % 8 || data_len > MAX_SNPRINTF_VARARGS * 8 ||
> +       if (data_len % 8 || data_len > MAX_BPRINTF_VARARGS * 8 ||
>             (data_len && !data))
>                 return -EINVAL;
>         num_args = data_len / 8;
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index cbc73c08c4a4..2cf4bfa1ab7b 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -414,15 +414,13 @@ const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>         return &bpf_trace_printk_proto;
>  }
>
> -#define MAX_SEQ_PRINTF_VARARGS         12
> -
>  BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
>            const void *, data, u32, data_len)
>  {
>         int err, num_args;
>         u32 *bin_args;
>
> -       if (data_len & 7 || data_len > MAX_SEQ_PRINTF_VARARGS * 8 ||
> +       if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
>             (data_len && !data))
>                 return -EINVAL;
>         num_args = data_len / 8;
> --
> 2.30.2
>
