Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A03F5768
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhHXEvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhHXEvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:51:36 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A48C061575;
        Mon, 23 Aug 2021 21:50:52 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id q70so22312159ybg.11;
        Mon, 23 Aug 2021 21:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iqk9yRx8FuVCy/mgcXfxs9LV1M/zZLwIpTXdui+P9lM=;
        b=BYRczni6eszIH9yz/PfsV+yfk9jIUTD6vE6FyZH9K/7kISbFxlJ+AKGfxpezOv9MAs
         YSXwpRJ6+h1KmvN5L7Bzfz5UIYZ7IMbo9TT5MAU8/5w9NRWNw+AZJr081R1ObYaESDe5
         3BaeHk0q90qnpmliXv28IaCXJu/DIWy7bq8Wfq/7dNPBLMDrhplp+nff4uivOHalSm7i
         uNRaz4bwJ+EDfCP+Ci7Y5lwjv2CH8KzIVq60qTgNXOLw562GlT0DqK2jduWZyBGo7JUq
         xVAAxl70Ej0gCzT8MSKeBI8the8nw1u4Tp/vs0LC4aFaJdJjz7Lc3pjO+PeNT2X8NxoU
         8sYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iqk9yRx8FuVCy/mgcXfxs9LV1M/zZLwIpTXdui+P9lM=;
        b=dtY6MhWQz5gJminhrdWBL502Z3tDzdVI2/uyEkOsT8I6WQaqnOsxKOWtaxdfaamM3+
         4CCjepAhengxBXvbITARQ3Dchea5tSo3hbOwmZYK12n3DOBl8+1o4T/hgt569BYlyDvd
         eV866mQpo3v0sW5+m4MTmitTbEx0E2sOzjNHtzltOheXCv9X53iJmRvPKSHRLhxz4niO
         eOgttHr3eXNnbqKJU/z6zh9m/XQHM0txX9fodClPvwNLSZe4Yi17c9S0+ir25soF4tP8
         CVwZYoM2kfo0mlSHFROP7N34Ck9wc4MkHziVa3TzmmjWXsF4ZEmVm0dPPwlsPyuN+h9R
         40iQ==
X-Gm-Message-State: AOAM531vB6dia+Ovsh/Q4sA7ylGbcn4KvQNXYRpZ55vsFMZiKgzPsrF8
        wZQ3u5mDn37zTchPrlWS9MYpwlj3OeLmlb403ZQ=
X-Google-Smtp-Source: ABdhPJypKcBXwRjUoAaGFf/pAsBlJQM285bo4pQq3Dgtzd+wXyZcpd0RGQbvDzQDms7WXT0AUTz5uqoyA49i7HMT3Hw=
X-Received: by 2002:a25:1e03:: with SMTP id e3mr29117671ybe.459.1629780651200;
 Mon, 23 Aug 2021 21:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210821025837.1614098-1-davemarchevsky@fb.com> <20210821025837.1614098-3-davemarchevsky@fb.com>
In-Reply-To: <20210821025837.1614098-3-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Aug 2021 21:50:40 -0700
Message-ID: <CAEf4BzYEOzfmwi8n8K_W_6Pc+gC081ncmRCAq8Fz0vr=y7eMcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: add bpf_trace_vprintk helper
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
> This helper is meant to be "bpf_trace_printk, but with proper vararg

We have bpf_snprintf() and bpf_seq_printf() names for other BPF
helpers using the same approach. How about we call this one simply
`bpf_printf`? It will be in line with other naming, it is logical BPF
equivalent of user-space printf (which outputs to stderr, which in BPF
land is /sys/kernel/debug/tracing/trace_pipe). And it will be logical
to have a nice and short BPF_PRINTF() convenience macro provided by
libbpf.

> support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> array. Write to dmesg using the same mechanism as bpf_trace_printk.

Are you sure about the dmesg part?... bpf_trace_printk is outputting
into /sys/kernel/debug/tracing/trace_pipe.

>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 23 +++++++++++++++
>  kernel/bpf/core.c              |  5 ++++
>  kernel/bpf/helpers.c           |  2 ++
>  kernel/trace/bpf_trace.c       | 52 +++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h | 23 +++++++++++++++
>  6 files changed, 105 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index be8d57e6e78a..b6c45a6cbbba 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1088,6 +1088,7 @@ bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *f
>  int bpf_prog_calc_tag(struct bpf_prog *fp);
>
>  const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
> +const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void);
>
>  typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
>                                         unsigned long off, unsigned long len);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c4f7892edb2b..899a2649d986 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4871,6 +4871,28 @@ union bpf_attr {
>   *     Return
>   *             Value specified by user at BPF link creation/attachment time
>   *             or 0, if it was not specified.
> + *
> + * u64 bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data, u32 data_len)
> + *     Description
> + *             Behaves like **bpf_trace_printk**\ () helper, but takes an array of u64
> + *             to format. Supports up to 12 arguments to print in this way.

we didn't specify 12 in the description of bpf_snprintf() or
bpf_seq_printf(), so why start doing that here? For data/args format,
let's just refer to bpf_snprintf() or bpf_seq_printf(), whichever does
a better job explaining this :)


> + *             The *fmt* and *fmt_size* are for the format string itself. The *data* and
> + *             *data_len* are format string arguments.
> + *
> + *             Each format specifier in **fmt** corresponds to one u64 element
> + *             in the **data** array. For strings and pointers where pointees
> + *             are accessed, only the pointer values are stored in the *data*
> + *             array. The *data_len* is the size of *data* in bytes.
> + *             Formats **%s**, **%p{i,I}{4,6}** requires to read kernel memory.
> + *             Reading kernel memory may fail due to either invalid address or
> + *             valid address but requiring a major memory fault. If reading kernel memory
> + *             fails, the string for **%s** will be an empty string, and the ip
> + *             address for **%p{i,I}{4,6}** will be 0. Not returning error to
> + *             bpf program is consistent with what **bpf_trace_printk**\ () does for now.

This is just a copy/paste from other helpers. Let's avoid duplication
and just point people to a description in other helpers.

> + *
> + *     Return
> + *             The number of bytes written to the buffer, or a negative error
> + *             in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5048,6 +5070,7 @@ union bpf_attr {
>         FN(timer_cancel),               \
>         FN(get_func_ip),                \
>         FN(get_attach_cookie),          \
> +       FN(trace_vprintk),              \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 91f24c7b38a1..a137c550046c 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2357,6 +2357,11 @@ const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
>         return NULL;
>  }
>
> +const struct bpf_func_proto * __weak bpf_get_trace_vprintk_proto(void)
> +{
> +       return NULL;
> +}
> +
>  u64 __weak
>  bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
>                  void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy)
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5ce19b376ef7..863e5ee68558 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1419,6 +1419,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>                 return &bpf_snprintf_btf_proto;
>         case BPF_FUNC_snprintf:
>                 return &bpf_snprintf_proto;
> +       case BPF_FUNC_trace_vprintk:
> +               return bpf_get_trace_vprintk_proto();
>         default:
>                 return NULL;
>         }
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 2cf4bfa1ab7b..8b3f1ec9e082 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -398,7 +398,7 @@ static const struct bpf_func_proto bpf_trace_printk_proto = {
>         .arg2_type      = ARG_CONST_SIZE,
>  };
>
> -const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
> +static __always_inline void __set_printk_clr_event(void)

Please drop __always_inline, we only use __always_inline for
absolutely performance critical routines. Let the compiler decide.

>  {
>         /*
>          * This program might be calling bpf_trace_printk,
> @@ -410,10 +410,58 @@ const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>          */
>         if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
>                 pr_warn_ratelimited("could not enable bpf_trace_printk events");
> +}
>
> +const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
> +{
> +       __set_printk_clr_event();
>         return &bpf_trace_printk_proto;
>  }
>
> +BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, data,
> +          u32, data_len)
> +{
> +       static char buf[BPF_TRACE_PRINTK_SIZE];
> +       unsigned long flags;
> +       int ret, num_args;
> +       u32 *bin_args;
> +
> +       if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
> +           (data_len && !data))
> +               return -EINVAL;
> +       num_args = data_len / 8;
> +
> +       ret = bpf_bprintf_prepare(fmt, fmt_size, data, &bin_args, num_args);
> +       if (ret < 0)
> +               return ret;
> +
> +       raw_spin_lock_irqsave(&trace_printk_lock, flags);
> +       ret = bstr_printf(buf, sizeof(buf), fmt, bin_args);
> +
> +       trace_bpf_trace_printk(buf);
> +       raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
> +
> +       bpf_bprintf_cleanup();
> +
> +       return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_trace_vprintk_proto = {
> +       .func           = bpf_trace_vprintk,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_MEM,
> +       .arg2_type      = ARG_CONST_SIZE,
> +       .arg3_type      = ARG_PTR_TO_MEM_OR_NULL,
> +       .arg4_type      = ARG_CONST_SIZE_OR_ZERO,
> +};
> +
> +const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void)
> +{
> +       __set_printk_clr_event();
> +       return &bpf_trace_vprintk_proto;
> +}
> +
>  BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
>            const void *, data, u32, data_len)
>  {
> @@ -1113,6 +1161,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_snprintf_proto;
>         case BPF_FUNC_get_func_ip:
>                 return &bpf_get_func_ip_proto_tracing;
> +       case BPF_FUNC_trace_vprintk:
> +               return bpf_get_trace_vprintk_proto();
>         default:
>                 return bpf_base_func_proto(func_id);
>         }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index c4f7892edb2b..899a2649d986 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -4871,6 +4871,28 @@ union bpf_attr {
>   *     Return
>   *             Value specified by user at BPF link creation/attachment time
>   *             or 0, if it was not specified.
> + *
> + * u64 bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data, u32 data_len)
> + *     Description
> + *             Behaves like **bpf_trace_printk**\ () helper, but takes an array of u64
> + *             to format. Supports up to 12 arguments to print in this way.
> + *             The *fmt* and *fmt_size* are for the format string itself. The *data* and
> + *             *data_len* are format string arguments.
> + *
> + *             Each format specifier in **fmt** corresponds to one u64 element
> + *             in the **data** array. For strings and pointers where pointees
> + *             are accessed, only the pointer values are stored in the *data*
> + *             array. The *data_len* is the size of *data* in bytes.
> + *             Formats **%s**, **%p{i,I}{4,6}** requires to read kernel memory.
> + *             Reading kernel memory may fail due to either invalid address or
> + *             valid address but requiring a major memory fault. If reading kernel memory
> + *             fails, the string for **%s** will be an empty string, and the ip
> + *             address for **%p{i,I}{4,6}** will be 0. Not returning error to
> + *             bpf program is consistent with what **bpf_trace_printk**\ () does for now.
> + *
> + *     Return
> + *             The number of bytes written to the buffer, or a negative error
> + *             in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5048,6 +5070,7 @@ union bpf_attr {
>         FN(timer_cancel),               \
>         FN(get_func_ip),                \
>         FN(get_attach_cookie),          \
> +       FN(trace_vprintk),              \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> --
> 2.30.2
>
