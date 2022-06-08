Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9974542866
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiFHHuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiFHHs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 03:48:56 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8961F35272;
        Wed,  8 Jun 2022 00:13:24 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-e93bbb54f9so26101666fac.12;
        Wed, 08 Jun 2022 00:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oxt+Eme8Pwzvsqr4mfwGIyEUAqfilkYTWVzeRYqwLhA=;
        b=C92jX3FJZGi5LdAjpWR4sj+DeGVbmtDIqC/BDOBoc3UMSfHjHdL/S7IiBKW9UAQ8Ow
         XCAc+K2wKitHjGTy/h/ZMcTaaSmyMuHLUNGTmgKk6bUN1VLEl1PB6kypr8wesZ4nxgk8
         I3CaZ+gElFokyoDMAAL8mrN4VwwouJndMauE6s0Bg5DR6pLwrK2lo+HRKHpXCwYSZ4/M
         wysa2gpUy9KNr1O4Bf7Fu+1vVmx08HrRdWxlv6gkPHhDj4KFjSnSl05mHGqwfdh07HzB
         b8/pdxF9tsW21G1Kx/xQCjRfTN7kcmhW8K6Zy578HzbeJXIvzPyD+lZ2stKOVfvCVe53
         J23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oxt+Eme8Pwzvsqr4mfwGIyEUAqfilkYTWVzeRYqwLhA=;
        b=g0aDS78vw3t8wd5UxzSKJqbw3QN+4aR6JQpwYuwQFZT4P3Lo4/J2lNejf7ail1i0rS
         9ho6b8Ab0qgGX6Lyr12GfF1fEZEy4w87zT2Mj5gqetKI1PLHQ2qBe2+ACMaJDGC+ZtGO
         /KFFucm//ccDYKRnQucGP+w6STI1mDgAHna+//fvkJ7MNrnNR61yqKMrdg/PrDvRUO4N
         2Z2X2qo4At2Mg9rTF6k1KBUOOUrf13hFoibZKFKw2glMs9aKmN1JqsMQzF0XZj2FeNAV
         YJLwVDVChzC0h8fKwOgcicKnwlM6RFZEsKk6H/j4+GQuV3Q2Es+aPWtEzVUEW+LEb75X
         OJow==
X-Gm-Message-State: AOAM533rUaiPfudrei1bsF6RlmZN/1avqltQd2tWO4eRH3BBsckQgGIO
        42cRkeeBBAdcsKKTUgwcbeOy1dbCNKO3LBp9kJU=
X-Google-Smtp-Source: ABdhPJyq+s+Wul9P9/MCSGyyll17uvIz9ynV62zVdHsXgOIkRIvLk8wkHW7peb0eQazys2XE9TV5EdryoSXSNYQOlY0=
X-Received: by 2002:a05:6870:d0ce:b0:f3:3856:f552 with SMTP id
 k14-20020a056870d0ce00b000f33856f552mr1618407oaa.99.1654672403777; Wed, 08
 Jun 2022 00:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220606132741.3462925-1-james.hilliard1@gmail.com>
 <CAEf4BzZ8eTqVnsLqc52=AyHeAsuVB3Nv7uBW19t2pcb9h7p2hQ@mail.gmail.com>
 <CADvTj4o2cbCpC40487=rgzSJZ8i94U4RR3=_s8ANE=phPQA6VQ@mail.gmail.com> <CAEf4BzaH0ZzEabjq43eZ4pZ7=SufYswffHwi1POn93Ty9SPJ6Q@mail.gmail.com>
In-Reply-To: <CAEf4BzaH0ZzEabjq43eZ4pZ7=SufYswffHwi1POn93Ty9SPJ6Q@mail.gmail.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Wed, 8 Jun 2022 01:13:12 -0600
Message-ID: <CADvTj4pf4tg2i7WuiMD54kjPBcJS3j_M5tkCqOR=krCo7VCu6w@mail.gmail.com>
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

On Tue, Jun 7, 2022 at 5:21 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jun 6, 2022 at 2:20 PM James Hilliard <james.hilliard1@gmail.com> wrote:
> >
> > On Mon, Jun 6, 2022 at 12:02 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Jun 6, 2022 at 6:28 AM James Hilliard <james.hilliard1@gmail.com> wrote:
> > > >
> > > > It seems the gcc preprocessor breaks unless pragmas are wrapped
> > > > individually inside macros.
> > > >
> > > > Fixes errors like:
> > > > error: expected identifier or '(' before '#pragma'
> > > >   106 | SEC("cgroup/bind6")
> > > >       | ^~~
> > > >
> > > > error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
> > > >   114 | char _license[] SEC("license") = "GPL";
> > > >       | ^~~
> > > >
> > >
> > > We've been using this macro in this form for a while with no errors.
> > > How do you get these errors in the first place?
> >
> > I was attempting to compile the systemd bpf programs using gcc 12.1.
> > https://github.com/systemd/systemd/tree/main/src/core/bpf
>
> It would be great to be able to repro it as part of selftests. Can you
> try gcc 12 with selftests/bpf and see if you get the same problem?
>
> >
> > > _Pragma is supposed to
> > > be a full equivalent of #pragma specifically to be able to be used in
> > > macros, so these work-arounds shouldn't be necessary.
> >
> > I did try and style this like the nested macro example here:
> > https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Pragmas.html
>
>
> If you are referring to DO_PRAGMA example? That example is done that
> way to do argument stringification, but not because _Pragma can't be
> used as is in macros.
>
> >
> > > Let's first try
> > > to root cause this.
> >
> > I was looking around and it seems there's a bunch of gcc preprocessor
> > pragma issues in general, restyling this seemed to be the best option
> > at the moment since a lot looked to be unfixed:
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53431
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55578
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89718
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91669
> >
>
> I don't like the obscurity of the changes in this patch and don't see
> how it fundamentally changes anything. So I'd like to actually try to
> be able to repro it and see what other solutions there are before
> committing to this.
>
> I also suspect that it's only the SEC() macro that's problematic and
> we shouldn't touch any other macro at all. But again, I'd like to get
> a repro first.

Seems typeof was triggering the issue, replacing it with __typeof__ seems
to fix it:
https://lore.kernel.org/bpf/20220608064004.1493239-1-james.hilliard1@gmail.com/

Seems similar to this issue:
https://patches.dpdk.org/project/dpdk/patch/2601191342CEEE43887BDE71AB977258213F3012@irsmsx105.ger.corp.intel.com/

Looks like gcc and llvm document there's some differences between __typeof__
and typeof with __typeof__ being the more portable variant:
https://gcc.gnu.org/onlinedocs/gcc/Typeof.html
https://clang.llvm.org/docs/UsersManual.html#differences-between-various-standard-modes

>
> > >
> > > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > > ---
> > > >  tools/lib/bpf/bpf_helpers.h | 26 ++++++++++++++------------
> > > >  tools/lib/bpf/bpf_tracing.h | 26 ++++++++++++++------------
> > > >  2 files changed, 28 insertions(+), 24 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > > > index fb04eaf367f1..6d159082727d 100644
> > > > --- a/tools/lib/bpf/bpf_helpers.h
> > > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > > @@ -22,11 +22,13 @@
> > > >   * To allow use of SEC() with externs (e.g., for extern .maps declarations),
> > > >   * make sure __attribute__((unused)) doesn't trigger compilation warning.
> > > >   */
> > > > +#define __gcc_helpers_pragma(x) _Pragma(#x)
> > > > +#define __gcc_helpers_diag_pragma(x) __gcc_helpers_pragma("GCC diagnostic " #x)
> > > >  #define SEC(name) \
> > > > -       _Pragma("GCC diagnostic push")                                      \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")          \
> > > > +       __gcc_helpers_diag_pragma(push)                                     \
> > > > +       __gcc_helpers_diag_pragma(ignored "-Wignored-attributes")           \
> > > >         __attribute__((section(name), used))                                \
> > > > -       _Pragma("GCC diagnostic pop")                                       \
> > > > +       __gcc_helpers_diag_pragma(pop)
> > > >
> > > >  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
> > > >  #undef __always_inline
> > > > @@ -215,10 +217,10 @@ enum libbpf_tristate {
> > > >         static const char ___fmt[] = fmt;                       \
> > > >         unsigned long long ___param[___bpf_narg(args)];         \
> > > >                                                                 \
> > > > -       _Pragma("GCC diagnostic push")                          \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > > > +       __gcc_helpers_diag_pragma(push)                         \
> > > > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> > > >         ___bpf_fill(___param, args);                            \
> > > > -       _Pragma("GCC diagnostic pop")                           \
> > > > +       __gcc_helpers_diag_pragma(pop)                          \
> > > >                                                                 \
> > > >         bpf_seq_printf(seq, ___fmt, sizeof(___fmt),             \
> > > >                        ___param, sizeof(___param));             \
> > > > @@ -233,10 +235,10 @@ enum libbpf_tristate {
> > > >         static const char ___fmt[] = fmt;                       \
> > > >         unsigned long long ___param[___bpf_narg(args)];         \
> > > >                                                                 \
> > > > -       _Pragma("GCC diagnostic push")                          \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > > > +       __gcc_helpers_diag_pragma(push)                         \
> > > > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> > > >         ___bpf_fill(___param, args);                            \
> > > > -       _Pragma("GCC diagnostic pop")                           \
> > > > +       __gcc_helpers_diag_pragma(pop)                          \
> > > >                                                                 \
> > > >         bpf_snprintf(out, out_size, ___fmt,                     \
> > > >                      ___param, sizeof(___param));               \
> > > > @@ -264,10 +266,10 @@ enum libbpf_tristate {
> > > >         static const char ___fmt[] = fmt;                       \
> > > >         unsigned long long ___param[___bpf_narg(args)];         \
> > > >                                                                 \
> > > > -       _Pragma("GCC diagnostic push")                          \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> > > > +       __gcc_helpers_diag_pragma(push)                         \
> > > > +       __gcc_helpers_diag_pragma(ignored "-Wint-conversion")   \
> > > >         ___bpf_fill(___param, args);                            \
> > > > -       _Pragma("GCC diagnostic pop")                           \
> > > > +       __gcc_helpers_diag_pragma(pop)                          \
> > > >                                                                 \
> > > >         bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
> > > >                           ___param, sizeof(___param));          \
> > > > diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> > > > index 01ce121c302d..e08ffc290b3e 100644
> > > > --- a/tools/lib/bpf/bpf_tracing.h
> > > > +++ b/tools/lib/bpf/bpf_tracing.h
> > > > @@ -422,16 +422,18 @@ struct pt_regs;
> > > >   * This is useful when using BPF helpers that expect original context
> > > >   * as one of the parameters (e.g., for bpf_perf_event_output()).
> > > >   */
> > > > +#define __gcc_tracing_pragma(x) _Pragma(#x)
> > > > +#define __gcc_tracing_diag_pragma(x) __gcc_tracing_pragma("GCC diagnostic " #x)
> > > >  #define BPF_PROG(name, args...)                                                    \
> > > >  name(unsigned long long *ctx);                                             \
> > > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > > >  ____##name(unsigned long long *ctx, ##args);                               \
> > > >  typeof(name(0)) name(unsigned long long *ctx)                              \
> > > >  {                                                                          \
> > > > -       _Pragma("GCC diagnostic push")                                      \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > > +       __gcc_tracing_diag_pragma(push)                                     \
> > > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > > >         return ____##name(___bpf_ctx_cast(args));                           \
> > > > -       _Pragma("GCC diagnostic pop")                                       \
> > > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > > >  }                                                                          \
> > > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > > >  ____##name(unsigned long long *ctx, ##args)
> > > > @@ -462,10 +464,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
> > > >  ____##name(struct pt_regs *ctx, ##args);                                   \
> > > >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> > > >  {                                                                          \
> > > > -       _Pragma("GCC diagnostic push")                                      \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > > +       __gcc_tracing_diag_pragma(push)                                     \
> > > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > > >         return ____##name(___bpf_kprobe_args(args));                        \
> > > > -       _Pragma("GCC diagnostic pop")                                       \
> > > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > > >  }                                                                          \
> > > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > > >  ____##name(struct pt_regs *ctx, ##args)
> > > > @@ -486,10 +488,10 @@ static __attribute__((always_inline)) typeof(name(0))                         \
> > > >  ____##name(struct pt_regs *ctx, ##args);                                   \
> > > >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> > > >  {                                                                          \
> > > > -       _Pragma("GCC diagnostic push")                                      \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > > +       __gcc_tracing_diag_pragma(push)                                     \
> > > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > > >         return ____##name(___bpf_kretprobe_args(args));                     \
> > > > -       _Pragma("GCC diagnostic pop")                                       \
> > > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > > >  }                                                                          \
> > > >  static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
> > > >
> > > > @@ -520,10 +522,10 @@ ____##name(struct pt_regs *ctx, ##args);                              \
> > > >  typeof(name(0)) name(struct pt_regs *ctx)                                  \
> > > >  {                                                                          \
> > > >         struct pt_regs *regs = PT_REGS_SYSCALL_REGS(ctx);                   \
> > > > -       _Pragma("GCC diagnostic push")                                      \
> > > > -       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")              \
> > > > +       __gcc_tracing_diag_pragma(push)             \
> > > > +       __gcc_tracing_diag_pragma(ignored "-Wint-conversion")               \
> > > >         return ____##name(___bpf_syscall_args(args));                       \
> > > > -       _Pragma("GCC diagnostic pop")                                       \
> > > > +       __gcc_tracing_diag_pragma(pop)                                      \
> > > >  }                                                                          \
> > > >  static __attribute__((always_inline)) typeof(name(0))                      \
> > > >  ____##name(struct pt_regs *ctx, ##args)
> > > > --
> > > > 2.25.1
> > > >
