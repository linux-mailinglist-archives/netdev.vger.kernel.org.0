Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684FA54204F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385332AbiFHAVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835794AbiFGX5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:57:00 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66E8FC83B;
        Tue,  7 Jun 2022 16:21:42 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id c30so4283500ljr.9;
        Tue, 07 Jun 2022 16:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=COK9bRpwazgqXOIrafjqYsXHBImgiEMg19CQNox6XRo=;
        b=MUGtXYPSB3HMe/81ChjyP87+0Eq5slZuNe6SAFcuXYMFN8lqKw3Wk399s+f6oqiO5b
         YcPiplVGM8H0pUtMsdH7HSvMrDT7jMgiDir/VBGvOft8XPAn88r5yXgubrZhJIgYaCJA
         UtYlfUrSH0lYwk2V0tWvdRiP0Z2Tiv3/Vxh1FWpxvXaqczmd090LGvTEuxJKvtD3wiCG
         oZQfHNC2ObA2M5Z6LLr43qESzCIT3x/KnMYxBJZCPlZzU448UK08mVBc0LvZy+6GIDTi
         9/joaK39f/o/SpoDz574P1lK9tdf9HIWPLty3Ao8p01JXkz7kkBUi4eh48UJ2ovsHaR3
         KCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=COK9bRpwazgqXOIrafjqYsXHBImgiEMg19CQNox6XRo=;
        b=l8qFOp6i2S1XpIyHeqPfMlKk8k/SnliYIvHvAzgAIE/gWhb/t26kknvK6olsMtCo2a
         a99FvhdrsUh+djU/oK3ahEQCvEPk9hF/0qor17u852ktBnFzQ2iVqCFcoTELejwDDjzq
         WOKvwK/r9PnUZVn6PUjedtvLlM3zMjVBPZSKDO8AFH8XhiqGWXajRQLD/s5es6XT8Zmq
         6OHb0w5MvHKhpX60xlyyi0opGjdYLDXK9yn+lX82aeEv1xoxDDWbNMwkkNi117SpjWlm
         qQiwB+h+yH+LCBX4mGJbffNAKa5wx/3vxxhhpT8gSmso/gHMQMl9Vx8jd8wKjgI1d8cj
         mywQ==
X-Gm-Message-State: AOAM531q7qMlfnPRPvM2P/IUSuRHI4zHvYli+lPhooK/rFNi0HKlQ6aV
        LFIPj588y9kPLy5FVfWqhsUt/nbt1PPjLrCmKdo=
X-Google-Smtp-Source: ABdhPJwpQUarPlQrNTRrbDSKLAsQf4gXqUxsnLWfPloSNMURSjnD1qLQS5EXDHZOWOv3zEfg0d9KstiDIWd5eQe9DmE=
X-Received: by 2002:a2e:9bc1:0:b0:253:e20a:7a79 with SMTP id
 w1-20020a2e9bc1000000b00253e20a7a79mr49293774ljj.445.1654644101075; Tue, 07
 Jun 2022 16:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220606132741.3462925-1-james.hilliard1@gmail.com>
 <CAEf4BzZ8eTqVnsLqc52=AyHeAsuVB3Nv7uBW19t2pcb9h7p2hQ@mail.gmail.com> <CADvTj4o2cbCpC40487=rgzSJZ8i94U4RR3=_s8ANE=phPQA6VQ@mail.gmail.com>
In-Reply-To: <CADvTj4o2cbCpC40487=rgzSJZ8i94U4RR3=_s8ANE=phPQA6VQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jun 2022 16:21:29 -0700
Message-ID: <CAEf4BzaH0ZzEabjq43eZ4pZ7=SufYswffHwi1POn93Ty9SPJ6Q@mail.gmail.com>
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

On Mon, Jun 6, 2022 at 2:20 PM James Hilliard <james.hilliard1@gmail.com> wrote:
>
> On Mon, Jun 6, 2022 at 12:02 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jun 6, 2022 at 6:28 AM James Hilliard <james.hilliard1@gmail.com> wrote:
> > >
> > > It seems the gcc preprocessor breaks unless pragmas are wrapped
> > > individually inside macros.
> > >
> > > Fixes errors like:
> > > error: expected identifier or '(' before '#pragma'
> > >   106 | SEC("cgroup/bind6")
> > >       | ^~~
> > >
> > > error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
> > >   114 | char _license[] SEC("license") = "GPL";
> > >       | ^~~
> > >
> >
> > We've been using this macro in this form for a while with no errors.
> > How do you get these errors in the first place?
>
> I was attempting to compile the systemd bpf programs using gcc 12.1.
> https://github.com/systemd/systemd/tree/main/src/core/bpf

It would be great to be able to repro it as part of selftests. Can you
try gcc 12 with selftests/bpf and see if you get the same problem?

>
> > _Pragma is supposed to
> > be a full equivalent of #pragma specifically to be able to be used in
> > macros, so these work-arounds shouldn't be necessary.
>
> I did try and style this like the nested macro example here:
> https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Pragmas.html


If you are referring to DO_PRAGMA example? That example is done that
way to do argument stringification, but not because _Pragma can't be
used as is in macros.

>
> > Let's first try
> > to root cause this.
>
> I was looking around and it seems there's a bunch of gcc preprocessor
> pragma issues in general, restyling this seemed to be the best option
> at the moment since a lot looked to be unfixed:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53431
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55578
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89718
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91669
>

I don't like the obscurity of the changes in this patch and don't see
how it fundamentally changes anything. So I'd like to actually try to
be able to repro it and see what other solutions there are before
committing to this.

I also suspect that it's only the SEC() macro that's problematic and
we shouldn't touch any other macro at all. But again, I'd like to get
a repro first.

> >
> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > ---
> > >  tools/lib/bpf/bpf_helpers.h | 26 ++++++++++++++------------
> > >  tools/lib/bpf/bpf_tracing.h | 26 ++++++++++++++------------
> > >  2 files changed, 28 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > > index fb04eaf367f1..6d159082727d 100644
> > > --- a/tools/lib/bpf/bpf_helpers.h
> > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > @@ -22,11 +22,13 @@
> > >   * To allow use of SEC() with externs (e.g., for extern .maps declarations),
> > >   * make sure __attribute__((unused)) doesn't trigger compilation warning.
> > >   */
> > > +#define __gcc_helpers_pragma(x) _Pragma(#x)
> > > +#define __gcc_helpers_diag_pragma(x) __gcc_helpers_pragma("GCC diagnostic " #x)
> > >  #define SEC(name) \
> > > -       _Pragma("GCC diagnostic push")                                      \
> > > -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")          \
> > > +       __gcc_helpers_diag_pragma(push)                                     \
> > > +       __gcc_helpers_diag_pragma(ignored "-Wignored-attributes")           \
> > >         __attribute__((section(name), used))                                \
> > > -       _Pragma("GCC diagnostic pop")                                       \
> > > +       __gcc_helpers_diag_pragma(pop)
> > >
> > >  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
> > >  #undef __always_inline
> > > @@ -215,10 +217,10 @@ enum libbpf_tristate {
> > >         static const char ___fmt[] = fmt;                       \
> > >         unsigned long long ___param[___bpf_narg(args)];         \
> > >                                                                 \
> > > -       _Pragma("GCC diagnostic push")                          \
> > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > > +       __gcc_helpers_diag_pragma(push)                         \
> > > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> > >         ___bpf_fill(___param, args);                            \
> > > -       _Pragma("GCC diagnostic pop")                           \
> > > +       __gcc_helpers_diag_pragma(pop)                          \
> > >                                                                 \
> > >         bpf_seq_printf(seq, ___fmt, sizeof(___fmt),             \
> > >                        ___param, sizeof(___param));             \
> > > @@ -233,10 +235,10 @@ enum libbpf_tristate {
> > >         static const char ___fmt[] = fmt;                       \
> > >         unsigned long long ___param[___bpf_narg(args)];         \
> > >                                                                 \
> > > -       _Pragma("GCC diagnostic push")                          \
> > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > > +       __gcc_helpers_diag_pragma(push)                         \
> > > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> > >         ___bpf_fill(___param, args);                            \
> > > -       _Pragma("GCC diagnostic pop")                           \
> > > +       __gcc_helpers_diag_pragma(pop)                          \
> > >                                                                 \
> > >         bpf_snprintf(out, out_size, ___fmt,                     \
> > >                      ___param, sizeof(___param));               \
> > > @@ -264,10 +266,10 @@ enum libbpf_tristate {
> > >         static const char ___fmt[] = fmt;                       \
> > >         unsigned long long ___param[___bpf_narg(args)];         \
> > >                                                                 \
> > > -       _Pragma("GCC diagnostic push")                          \
> > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > > +       __gcc_helpers_diag_pragma(push)                         \
> > > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> > >         ___bpf_fill(___param, args);                            \
> > > -       _Pragma("GCC diagnostic pop")                           \
> > > +       __gcc_helpers_diag_pragma(pop)                          \
> > >                                                                 \
> > >         bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
> > >                           ___param, sizeof(___param));          \
> > > diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> > > index 01ce121c302d..e08ffc290b3e 100644
> > > --- a/tools/lib/bpf/bpf_tracing.h
> > > +++ b/tools/lib/bpf/bpf_tracing.h
> > > @@ -422,16 +422,18 @@ struct pt_regs;
> > >   * This is useful when using BPF helpers that expect original context
> > >   * as one of the parameters (e.g., for bpf_perf_event_output()).
> > >   */
> > > +#define __gcc_tracing_pragma(x) _Pragma(#x)
> > > +#define __gcc_tracing_diag_pragma(x) __gcc_tracing_pragma("GCC diagnostic " #x)
> > >  #define BPF_PROG(name, args...)                                                    \
> > >  name(unsigned long long *ctx);                                             \
> > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > >  ____##name(unsigned long long *ctx, ##args);                               \
> > >  typeof(name(0)) name(unsigned long long *ctx)                              \
> > >  {                                                                          \
> > > -       _Pragma("GCC diagnostic push")                                      \
> > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > +       __gcc_tracing_diag_pragma(push)                                     \
> > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > >         return ____##name(___bpf_ctx_cast(args));                           \
> > > -       _Pragma("GCC diagnostic pop")                                       \
> > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > >  }                                                                          \
> > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > >  ____##name(unsigned long long *ctx, ##args)
> > > @@ -462,10 +464,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
> > >  ____##name(struct pt_regs *ctx, ##args);                                   \
> > >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> > >  {                                                                          \
> > > -       _Pragma("GCC diagnostic push")                                      \
> > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > +       __gcc_tracing_diag_pragma(push)                                     \
> > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > >         return ____##name(___bpf_kprobe_args(args));                        \
> > > -       _Pragma("GCC diagnostic pop")                                       \
> > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > >  }                                                                          \
> > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > >  ____##name(struct pt_regs *ctx, ##args)
> > > @@ -486,10 +488,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
> > >  ____##name(struct pt_regs *ctx, ##args);                                   \
> > >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> > >  {                                                                          \
> > > -       _Pragma("GCC diagnostic push")                                      \
> > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > +       __gcc_tracing_diag_pragma(push)                                     \
> > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > >         return ____##name(___bpf_kretprobe_args(args));                     \
> > > -       _Pragma("GCC diagnostic pop")                                       \
> > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > >  }                                                                          \
> > >  static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
> > >
> > > @@ -520,10 +522,10 @@ ____##name(struct pt_regs *ctx, ##args);                              \
> > >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> > >  {                                                                          \
> > >         struct pt_regs *regs = PT_REGS_SYSCALL_REGS(ctx);                   \
> > > -       _Pragma("GCC diagnostic push")                                      \
> > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > +       __gcc_tracing_diag_pragma(push)             \
> > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > >         return ____##name(___bpf_syscall_args(args));                       \
> > > -       _Pragma("GCC diagnostic pop")                                       \
> > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > >  }                                                                          \
> > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > >  ____##name(struct pt_regs *ctx, ##args)
> > > --
> > > 2.25.1
> > >
