Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4353A53F188
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 23:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiFFVUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 17:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiFFVUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 17:20:39 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30ABA180;
        Mon,  6 Jun 2022 14:20:37 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-f2e0a41009so20733037fac.6;
        Mon, 06 Jun 2022 14:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HuxHinGBrJBTK3TTWKqPn9B+ODkbbS/hGNHjx9GIcog=;
        b=kMa1xkT91B+otL9XYAY5Ftp80mSKxNBhqXVlLmVwxQh/D2QjVBJTQa2j6ahKVSww5H
         tBhUfvbHw+ZIHPhz6sia28yNt4o+xFkz7OL75a2Th7QzwIRF4ueLITrl2LDsElyIoJxW
         xqg5M8KsgNyfYqXdOJHqLAPfAF2hhDoQ/WpQi1OQxWcj6gjwNyJiiVwkqj4EjlP6p3KV
         PqQrbszBCbPdrMWPZctn3boOYJTLPWzMPKrcsybCl5NhZH1kRmOaIfshPhNGl09SVTpD
         iAc3OLRSBJ4CIIQLZBE3yo9cWvP3ngKc6I0SAgQ5sdur6BcQ7NhJtyfD+PRxp+KU4k/m
         Vg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HuxHinGBrJBTK3TTWKqPn9B+ODkbbS/hGNHjx9GIcog=;
        b=VRt0rfoFYQePMJiHP1w/eBCbPGwks7mDZQAn7LbR30ooXnA7oPwBoQ+/caFR7NlWw2
         P36F8wIQsRvo9ea+cpP8HT8krRR2JWHaYWfXDLrbI8YDrVrHgyXZ1pU0a+awC37YZHGq
         Q1doDx71EtFmLAJoToNc0OTgFqScLbjdhmr5TnJQirJli9fujYa4AjCrfA5fxSRGmeZl
         p698mwX0VI6/AblMnIglz8cUhMuYzuisej2qeVh55QLUr/5Ttrq26110D6mR9ykGNIDf
         0CLXfLHmfZ705RaZ5BtljZm3wKSKyP3HuABh2V9aa5m3QS6gxrv6uAdyRrDoHACbjfhb
         XlJg==
X-Gm-Message-State: AOAM530s+Nuc06QSRAg1ZfX80rHtUtHUiZCK50dkokdDZzemTinwgJ3+
        fe1iAAEeVkWzSfUE6A5bIFxPKbFXukfSJmXA0326muqz4mM=
X-Google-Smtp-Source: ABdhPJycZiOgkgYr6ckkBj/PLYQmTOLBoWRaZbnm03XSyIwTO35GvE2BqOvRcW9UKMyzg6Cf2K03IK4xe25QN4FMhDI=
X-Received: by 2002:a05:6870:3105:b0:f2:9615:ff8e with SMTP id
 v5-20020a056870310500b000f29615ff8emr30161673oaa.200.1654550437084; Mon, 06
 Jun 2022 14:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220606132741.3462925-1-james.hilliard1@gmail.com> <CAEf4BzZ8eTqVnsLqc52=AyHeAsuVB3Nv7uBW19t2pcb9h7p2hQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ8eTqVnsLqc52=AyHeAsuVB3Nv7uBW19t2pcb9h7p2hQ@mail.gmail.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Mon, 6 Jun 2022 15:20:25 -0600
Message-ID: <CADvTj4o2cbCpC40487=rgzSJZ8i94U4RR3=_s8ANE=phPQA6VQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: fix broken gcc pragma macros in bpf_helpers.h/bpf_tracing.h
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 12:02 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jun 6, 2022 at 6:28 AM James Hilliard <james.hilliard1@gmail.com> wrote:
> >
> > It seems the gcc preprocessor breaks unless pragmas are wrapped
> > individually inside macros.
> >
> > Fixes errors like:
> > error: expected identifier or '(' before '#pragma'
> >   106 | SEC("cgroup/bind6")
> >       | ^~~
> >
> > error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
> >   114 | char _license[] SEC("license") = "GPL";
> >       | ^~~
> >
>
> We've been using this macro in this form for a while with no errors.
> How do you get these errors in the first place?

I was attempting to compile the systemd bpf programs using gcc 12.1.
https://github.com/systemd/systemd/tree/main/src/core/bpf

> _Pragma is supposed to
> be a full equivalent of #pragma specifically to be able to be used in
> macros, so these work-arounds shouldn't be necessary.

I did try and style this like the nested macro example here:
https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Pragmas.html

> Let's first try
> to root cause this.

I was looking around and it seems there's a bunch of gcc preprocessor
pragma issues in general, restyling this seemed to be the best option
at the moment since a lot looked to be unfixed:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53431
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55578
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89718
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91669

>
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > ---
> >  tools/lib/bpf/bpf_helpers.h | 26 ++++++++++++++------------
> >  tools/lib/bpf/bpf_tracing.h | 26 ++++++++++++++------------
> >  2 files changed, 28 insertions(+), 24 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index fb04eaf367f1..6d159082727d 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -22,11 +22,13 @@
> >   * To allow use of SEC() with externs (e.g., for extern .maps declarations),
> >   * make sure __attribute__((unused)) doesn't trigger compilation warning.
> >   */
> > +#define __gcc_helpers_pragma(x) _Pragma(#x)
> > +#define __gcc_helpers_diag_pragma(x) __gcc_helpers_pragma("GCC diagnostic " #x)
> >  #define SEC(name) \
> > -       _Pragma("GCC diagnostic push")                                      \
> > -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")          \
> > +       __gcc_helpers_diag_pragma(push)                                     \
> > +       __gcc_helpers_diag_pragma(ignored "-Wignored-attributes")           \
> >         __attribute__((section(name), used))                                \
> > -       _Pragma("GCC diagnostic pop")                                       \
> > +       __gcc_helpers_diag_pragma(pop)
> >
> >  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
> >  #undef __always_inline
> > @@ -215,10 +217,10 @@ enum libbpf_tristate {
> >         static const char ___fmt[] = fmt;                       \
> >         unsigned long long ___param[___bpf_narg(args)];         \
> >                                                                 \
> > -       _Pragma("GCC diagnostic push")                          \
> > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > +       __gcc_helpers_diag_pragma(push)                         \
> > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> >         ___bpf_fill(___param, args);                            \
> > -       _Pragma("GCC diagnostic pop")                           \
> > +       __gcc_helpers_diag_pragma(pop)                          \
> >                                                                 \
> >         bpf_seq_printf(seq, ___fmt, sizeof(___fmt),             \
> >                        ___param, sizeof(___param));             \
> > @@ -233,10 +235,10 @@ enum libbpf_tristate {
> >         static const char ___fmt[] = fmt;                       \
> >         unsigned long long ___param[___bpf_narg(args)];         \
> >                                                                 \
> > -       _Pragma("GCC diagnostic push")                          \
> > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > +       __gcc_helpers_diag_pragma(push)                         \
> > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> >         ___bpf_fill(___param, args);                            \
> > -       _Pragma("GCC diagnostic pop")                           \
> > +       __gcc_helpers_diag_pragma(pop)                          \
> >                                                                 \
> >         bpf_snprintf(out, out_size, ___fmt,                     \
> >                      ___param, sizeof(___param));               \
> > @@ -264,10 +266,10 @@ enum libbpf_tristate {
> >         static const char ___fmt[] = fmt;                       \
> >         unsigned long long ___param[___bpf_narg(args)];         \
> >                                                                 \
> > -       _Pragma("GCC diagnostic push")                          \
> > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > +       __gcc_helpers_diag_pragma(push)                         \
> > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> >         ___bpf_fill(___param, args);                            \
> > -       _Pragma("GCC diagnostic pop")                           \
> > +       __gcc_helpers_diag_pragma(pop)                          \
> >                                                                 \
> >         bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
> >                           ___param, sizeof(___param));          \
> > diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> > index 01ce121c302d..e08ffc290b3e 100644
> > --- a/tools/lib/bpf/bpf_tracing.h
> > +++ b/tools/lib/bpf/bpf_tracing.h
> > @@ -422,16 +422,18 @@ struct pt_regs;
> >   * This is useful when using BPF helpers that expect original context
> >   * as one of the parameters (e.g., for bpf_perf_event_output()).
> >   */
> > +#define __gcc_tracing_pragma(x) _Pragma(#x)
> > +#define __gcc_tracing_diag_pragma(x) __gcc_tracing_pragma("GCC diagnostic " #x)
> >  #define BPF_PROG(name, args...)                                                    \
> >  name(unsigned long long *ctx);                                             \
> >  static __attribute__((always_inline)) typeof(name(0))                      \
> >  ____##name(unsigned long long *ctx, ##args);                               \
> >  typeof(name(0)) name(unsigned long long *ctx)                              \
> >  {                                                                          \
> > -       _Pragma("GCC diagnostic push")                                      \
> > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > +       __gcc_tracing_diag_pragma(push)                                     \
> > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> >         return ____##name(___bpf_ctx_cast(args));                           \
> > -       _Pragma("GCC diagnostic pop")                                       \
> > +       __gcc_tracing_diag_pragma(pop)                                      \
> >  }                                                                          \
> >  static __attribute__((always_inline)) typeof(name(0))                      \
> >  ____##name(unsigned long long *ctx, ##args)
> > @@ -462,10 +464,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
> >  ____##name(struct pt_regs *ctx, ##args);                                   \
> >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> >  {                                                                          \
> > -       _Pragma("GCC diagnostic push")                                      \
> > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > +       __gcc_tracing_diag_pragma(push)                                     \
> > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> >         return ____##name(___bpf_kprobe_args(args));                        \
> > -       _Pragma("GCC diagnostic pop")                                       \
> > +       __gcc_tracing_diag_pragma(pop)                                      \
> >  }                                                                          \
> >  static __attribute__((always_inline)) typeof(name(0))                      \
> >  ____##name(struct pt_regs *ctx, ##args)
> > @@ -486,10 +488,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
> >  ____##name(struct pt_regs *ctx, ##args);                                   \
> >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> >  {                                                                          \
> > -       _Pragma("GCC diagnostic push")                                      \
> > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > +       __gcc_tracing_diag_pragma(push)                                     \
> > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> >         return ____##name(___bpf_kretprobe_args(args));                     \
> > -       _Pragma("GCC diagnostic pop")                                       \
> > +       __gcc_tracing_diag_pragma(pop)                                      \
> >  }                                                                          \
> >  static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
> >
> > @@ -520,10 +522,10 @@ ____##name(struct pt_regs *ctx, ##args);                              \
> >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> >  {                                                                          \
> >         struct pt_regs *regs = PT_REGS_SYSCALL_REGS(ctx);                   \
> > -       _Pragma("GCC diagnostic push")                                      \
> > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > +       __gcc_tracing_diag_pragma(push)             \
> > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> >         return ____##name(___bpf_syscall_args(args));                       \
> > -       _Pragma("GCC diagnostic pop")                                       \
> > +       __gcc_tracing_diag_pragma(pop)                                      \
> >  }                                                                          \
> >  static __attribute__((always_inline)) typeof(name(0))                      \
> >  ____##name(struct pt_regs *ctx, ##args)
> > --
> > 2.25.1
> >
