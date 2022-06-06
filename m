Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09B253ED70
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiFFSDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiFFSC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:02:59 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEEE6FD15;
        Mon,  6 Jun 2022 11:02:57 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id be31so24545047lfb.10;
        Mon, 06 Jun 2022 11:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97rzWQFE1AtsQDQrkeu4wHy1IeluYAPjOrBN3JDfUAQ=;
        b=mpXT18X63OmEoHZ3hFHcWblFdaKwXBAQMhZ+WYqGEfsmLoT3U7sLE124TUStzu6mHq
         AHfrfXGbrbRGd7o0jM5pWhUB81F0X2DEVOG2YPad83PazQ3jgGmylZKpOBVQ5v/GCJie
         YJ8IASvmXIEVcuDyD9bm+ZXPPrjihzwNYImxnUs3lakMD4ctX6bRzmGaZqqqXn8t+wCf
         x0xdYypbguFmnxrDbe9EERWfyglU6pv82vwb/jMpZ8khA2YMfr/S128QhgrVaWbgcUBD
         6uTp/Bs4Fezs6xqYOiTWi3wo0X9lXZvU1QRE3thiQaGmPJiGvqtKXHzeJK1GsZXm1+G8
         o77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97rzWQFE1AtsQDQrkeu4wHy1IeluYAPjOrBN3JDfUAQ=;
        b=eMhdRNHi/2ikiuFVr/E5WeXJaibVmfGC8hF61mqAESF3tPiKNQXJklxepmDbRwPH0f
         e1QMGbaklFcimigc06WZvmnyT6n/Sxec0oq5I9yMMG632nN7b4dLGquyMNc/YmA7fIvx
         ULJvXR5ufdn61V+vEUYEZAe59x5GW+aSIHV0z99SBxNxnDsuVCOknt/ifQ2hftixFNKO
         MYodHAE3349CQjLRZMPepe+r3aLQS7MfEBNGdZOTAMLxH/hmUV5H1hxKEquW/LmCzhdv
         LYSKnJ8jI6QZZeA2ZfWOiHYFdso4Xfy4BOOg6nxW8DkOADnWq20ubRu0mgq4SUNhoPtS
         NVtQ==
X-Gm-Message-State: AOAM532/8iJjD5N7aiJhknyzgZ8bB+FFSpUzCxEu9U18PJ56hsPgjXVP
        4cY5vvKXx+/Q25kCHr87NT8uYTmz+0rdlukqVjw=
X-Google-Smtp-Source: ABdhPJwBs78td/is/dI6ZXvJhu818Ge6Ngp3wjufF0A1i17eKnVOco6n20x7KMCDPDYiAmWDCWzyn36lAHFnYQ1p498=
X-Received: by 2002:a05:6512:b2a:b0:479:12f5:91ba with SMTP id
 w42-20020a0565120b2a00b0047912f591bamr13971198lfu.443.1654538574348; Mon, 06
 Jun 2022 11:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220606132741.3462925-1-james.hilliard1@gmail.com>
In-Reply-To: <20220606132741.3462925-1-james.hilliard1@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jun 2022 11:02:42 -0700
Message-ID: <CAEf4BzZ8eTqVnsLqc52=AyHeAsuVB3Nv7uBW19t2pcb9h7p2hQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: fix broken gcc pragma macros in bpf_helpers.h/bpf_tracing.h
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 6:28 AM James Hilliard <james.hilliard1@gmail.com> wrote:
>
> It seems the gcc preprocessor breaks unless pragmas are wrapped
> individually inside macros.
>
> Fixes errors like:
> error: expected identifier or '(' before '#pragma'
>   106 | SEC("cgroup/bind6")
>       | ^~~
>
> error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
>   114 | char _license[] SEC("license") = "GPL";
>       | ^~~
>

We've been using this macro in this form for a while with no errors.
How do you get these errors in the first place? _Pragma is supposed to
be a full equivalent of #pragma specifically to be able to be used in
macros, so these work-arounds shouldn't be necessary. Let's first try
to root cause this.

> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 26 ++++++++++++++------------
>  tools/lib/bpf/bpf_tracing.h | 26 ++++++++++++++------------
>  2 files changed, 28 insertions(+), 24 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index fb04eaf367f1..6d159082727d 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -22,11 +22,13 @@
>   * To allow use of SEC() with externs (e.g., for extern .maps declarations),
>   * make sure __attribute__((unused)) doesn't trigger compilation warning.
>   */
> +#define __gcc_helpers_pragma(x) _Pragma(#x)
> +#define __gcc_helpers_diag_pragma(x) __gcc_helpers_pragma("GCC diagnostic " #x)
>  #define SEC(name) \
> -       _Pragma("GCC diagnostic push")                                      \
> -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")          \
> +       __gcc_helpers_diag_pragma(push)                                     \
> +       __gcc_helpers_diag_pragma(ignored "-Wignored-attributes")           \
>         __attribute__((section(name), used))                                \
> -       _Pragma("GCC diagnostic pop")                                       \
> +       __gcc_helpers_diag_pragma(pop)
>
>  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
>  #undef __always_inline
> @@ -215,10 +217,10 @@ enum libbpf_tristate {
>         static const char ___fmt[] = fmt;                       \
>         unsigned long long ___param[___bpf_narg(args)];         \
>                                                                 \
> -       _Pragma("GCC diagnostic push")                          \
> -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> +       __gcc_helpers_diag_pragma(push)                         \
> +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
>         ___bpf_fill(___param, args);                            \
> -       _Pragma("GCC diagnostic pop")                           \
> +       __gcc_helpers_diag_pragma(pop)                          \
>                                                                 \
>         bpf_seq_printf(seq, ___fmt, sizeof(___fmt),             \
>                        ___param, sizeof(___param));             \
> @@ -233,10 +235,10 @@ enum libbpf_tristate {
>         static const char ___fmt[] = fmt;                       \
>         unsigned long long ___param[___bpf_narg(args)];         \
>                                                                 \
> -       _Pragma("GCC diagnostic push")                          \
> -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> +       __gcc_helpers_diag_pragma(push)                         \
> +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
>         ___bpf_fill(___param, args);                            \
> -       _Pragma("GCC diagnostic pop")                           \
> +       __gcc_helpers_diag_pragma(pop)                          \
>                                                                 \
>         bpf_snprintf(out, out_size, ___fmt,                     \
>                      ___param, sizeof(___param));               \
> @@ -264,10 +266,10 @@ enum libbpf_tristate {
>         static const char ___fmt[] = fmt;                       \
>         unsigned long long ___param[___bpf_narg(args)];         \
>                                                                 \
> -       _Pragma("GCC diagnostic push")                          \
> -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> +       __gcc_helpers_diag_pragma(push)                         \
> +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
>         ___bpf_fill(___param, args);                            \
> -       _Pragma("GCC diagnostic pop")                           \
> +       __gcc_helpers_diag_pragma(pop)                          \
>                                                                 \
>         bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
>                           ___param, sizeof(___param));          \
> diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> index 01ce121c302d..e08ffc290b3e 100644
> --- a/tools/lib/bpf/bpf_tracing.h
> +++ b/tools/lib/bpf/bpf_tracing.h
> @@ -422,16 +422,18 @@ struct pt_regs;
>   * This is useful when using BPF helpers that expect original context
>   * as one of the parameters (e.g., for bpf_perf_event_output()).
>   */
> +#define __gcc_tracing_pragma(x) _Pragma(#x)
> +#define __gcc_tracing_diag_pragma(x) __gcc_tracing_pragma("GCC diagnostic " #x)
>  #define BPF_PROG(name, args...)                                                    \
>  name(unsigned long long *ctx);                                             \
>  static __attribute__((always_inline)) typeof(name(0))                      \
>  ____##name(unsigned long long *ctx, ##args);                               \
>  typeof(name(0)) name(unsigned long long *ctx)                              \
>  {                                                                          \
> -       _Pragma("GCC diagnostic push")                                      \
> -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> +       __gcc_tracing_diag_pragma(push)                                     \
> +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
>         return ____##name(___bpf_ctx_cast(args));                           \
> -       _Pragma("GCC diagnostic pop")                                       \
> +       __gcc_tracing_diag_pragma(pop)                                      \
>  }                                                                          \
>  static __attribute__((always_inline)) typeof(name(0))                      \
>  ____##name(unsigned long long *ctx, ##args)
> @@ -462,10 +464,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
>  ____##name(struct pt_regs *ctx, ##args);                                   \
>  typeof(name(0)) name(struct pt_regs *ctx)                                  \
>  {                                                                          \
> -       _Pragma("GCC diagnostic push")                                      \
> -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> +       __gcc_tracing_diag_pragma(push)                                     \
> +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
>         return ____##name(___bpf_kprobe_args(args));                        \
> -       _Pragma("GCC diagnostic pop")                                       \
> +       __gcc_tracing_diag_pragma(pop)                                      \
>  }                                                                          \
>  static __attribute__((always_inline)) typeof(name(0))                      \
>  ____##name(struct pt_regs *ctx, ##args)
> @@ -486,10 +488,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
>  ____##name(struct pt_regs *ctx, ##args);                                   \
>  typeof(name(0)) name(struct pt_regs *ctx)                                  \
>  {                                                                          \
> -       _Pragma("GCC diagnostic push")                                      \
> -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> +       __gcc_tracing_diag_pragma(push)                                     \
> +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
>         return ____##name(___bpf_kretprobe_args(args));                     \
> -       _Pragma("GCC diagnostic pop")                                       \
> +       __gcc_tracing_diag_pragma(pop)                                      \
>  }                                                                          \
>  static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
>
> @@ -520,10 +522,10 @@ ____##name(struct pt_regs *ctx, ##args);                              \
>  typeof(name(0)) name(struct pt_regs *ctx)                                  \
>  {                                                                          \
>         struct pt_regs *regs = PT_REGS_SYSCALL_REGS(ctx);                   \
> -       _Pragma("GCC diagnostic push")                                      \
> -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> +       __gcc_tracing_diag_pragma(push)             \
> +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
>         return ____##name(___bpf_syscall_args(args));                       \
> -       _Pragma("GCC diagnostic pop")                                       \
> +       __gcc_tracing_diag_pragma(pop)                                      \
>  }                                                                          \
>  static __attribute__((always_inline)) typeof(name(0))                      \
>  ____##name(struct pt_regs *ctx, ##args)
> --
> 2.25.1
>
