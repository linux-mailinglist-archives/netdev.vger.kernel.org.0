Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A1522D76
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbiEKHgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243126AbiEKHgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:36:17 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420BE37AB1;
        Wed, 11 May 2022 00:36:16 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id i27so2240283ejd.9;
        Wed, 11 May 2022 00:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EMXOqXwZoRTd9O6dThkFs+3JKTEe2otLzDM0Lar53MM=;
        b=TY7mRuR+2Shnh3rYZ+Hrjt4CrYk+i3FBDt3Fk/2PUI/+Movxhpx2cRIgbVCfbGjFHb
         4LyouVv2PYLZyrjbY7PgZ6m1CwignXX7PARzT9J/fjsRKInqxpKL+FWEKFNIXYmku5WU
         pNN/n78gSGO41Dbvdob3kY8yEh3smDAZJidkDZuErfLyTVW6dQNPO8W4An6F7dCB/P64
         mHNnOHT2z6Itjloc/ya32j+KvmWXUUIZ5tt7uhBO/J5N4Afb16+DTm07lrlH56BvcUtQ
         RvOWok9Ik+D8zCttwrXpo1bc1bfe9RsrE0gE0XDlVxQ23Hph6WAnkE9PhvuwpOYp34NH
         1Jyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EMXOqXwZoRTd9O6dThkFs+3JKTEe2otLzDM0Lar53MM=;
        b=dHPK9HD8NmteydrYD4zsf+hiG8B/aVtAY8w8HWWC3o/J77l+2UPq0UsIQMYCQF9uEJ
         KGD6gi2PK+sSTgkjFr1v/PaQiIoq4EV38jaMmF8TM1p6nB5n4TaYDfYtK8ZtY7FSrmxG
         sd00CTIGgy9dhrR8bE2AlTaJeZxwpdlf21JlTdsMYqbgM5/2hO8zYtYcR9Lc9Z3BSiLx
         iReh6du0XCBN6vu5kVhA2y3IvwMo5Hxusssfn53zVwKOLqsYsextvA4FzcK8uxiFrfpi
         dEDy/FrV1TQfHBoxw70Ry3XMNkgMaqCmTmYN6Aiy/3zx3VVSrubd5K9yDRuReFFBrNW9
         f2Kw==
X-Gm-Message-State: AOAM532bk/0FJb0DylZl4mCdCPNOCXDePxGBmQtoSBX67XouP4afU4g/
        nzXWxWCfz2To6xd6Sex+ajk=
X-Google-Smtp-Source: ABdhPJxytIXbPPDCYqAMQhbZeZPptlGDvZH1yJ2RLxPRdNqHTYocowERsJVev8gD46c0oCYW24MwyA==
X-Received: by 2002:a17:906:974c:b0:6fa:8c68:62a8 with SMTP id o12-20020a170906974c00b006fa8c6862a8mr10459751ejy.293.1652254574671;
        Wed, 11 May 2022 00:36:14 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id hw10-20020a170907a0ca00b006f3ef214e05sm602188ejc.107.2022.05.11.00.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 00:36:14 -0700 (PDT)
Date:   Wed, 11 May 2022 09:36:12 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv2 perf/core 2/3] perf tools: Register fallback libbpf
 section handler
Message-ID: <YntnbEzE1LeIKXk4@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <20220510074659.2557731-3-jolsa@kernel.org>
 <CAEf4Bzav8he-_fD=D5KMFW7s=PkJoZG9cUr+BOTuV54KKOC70A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzav8he-_fD=D5KMFW7s=PkJoZG9cUr+BOTuV54KKOC70A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 04:45:01PM -0700, Andrii Nakryiko wrote:
> On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Perf is using section name to declare special kprobe arguments,
> > which no longer works with current libbpf, that either requires
> > certain form of the section name or allows to register custom
> > handler.
> >
> > Adding perf support to register 'fallback' section handler to take
> > care of perf kprobe programs. The fallback means that it handles
> > any section definition besides the ones that libbpf handles.
> >
> > The handler serves two purposes:
> >   - allows perf programs to have special arguments in section name
> >   - allows perf to use pre-load callback where we can attach init
> >     code (zeroing all argument registers) to each perf program
> >
> > The second is essential part of new prologue generation code,
> > that's coming in following patch.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/perf/util/bpf-loader.c | 47 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >
> > diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> > index f8ad581ea247..2a2c9512c4e8 100644
> > --- a/tools/perf/util/bpf-loader.c
> > +++ b/tools/perf/util/bpf-loader.c
> > @@ -86,6 +86,7 @@ bpf_perf_object__next(struct bpf_perf_object *prev)
> >              (perf_obj) = (tmp), (tmp) = bpf_perf_object__next(tmp))
> >
> >  static bool libbpf_initialized;
> > +static int libbpf_sec_handler;
> >
> >  static int bpf_perf_object__add(struct bpf_object *obj)
> >  {
> > @@ -99,12 +100,58 @@ static int bpf_perf_object__add(struct bpf_object *obj)
> >         return perf_obj ? 0 : -ENOMEM;
> >  }
> >
> > +static struct bpf_insn prologue_init_insn[] = {
> > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > +       BPF_MOV64_IMM(BPF_REG_1, 0),
> 
> R0 should be initialized before exit anyway. R1 contains context, so
> doesn't need initialization, so I think you only need R2-R5?

ah right, I'll remove that

thanks,
jirka

> 
> > +       BPF_MOV64_IMM(BPF_REG_2, 0),
> > +       BPF_MOV64_IMM(BPF_REG_3, 0),
> > +       BPF_MOV64_IMM(BPF_REG_4, 0),
> > +       BPF_MOV64_IMM(BPF_REG_5, 0),
> > +};
> > +
> > +static int libbpf_prog_prepare_load_fn(struct bpf_program *prog,
> > +                                      struct bpf_prog_load_opts *opts __maybe_unused,
> > +                                      long cookie __maybe_unused)
> > +{
> > +       size_t init_size_cnt = ARRAY_SIZE(prologue_init_insn);
> > +       size_t orig_insn_cnt, insn_cnt, init_size, orig_size;
> > +       const struct bpf_insn *orig_insn;
> > +       struct bpf_insn *insn;
> > +
> > +       /* prepend initialization code to program instructions */
> > +       orig_insn = bpf_program__insns(prog);
> > +       orig_insn_cnt = bpf_program__insn_cnt(prog);
> > +       init_size = init_size_cnt * sizeof(*insn);
> > +       orig_size = orig_insn_cnt * sizeof(*insn);
> > +
> > +       insn_cnt = orig_insn_cnt + init_size_cnt;
> > +       insn = malloc(insn_cnt * sizeof(*insn));
> > +       if (!insn)
> > +               return -ENOMEM;
> > +
> > +       memcpy(insn, prologue_init_insn, init_size);
> > +       memcpy((char *) insn + init_size, orig_insn, orig_size);
> > +       bpf_program__set_insns(prog, insn, insn_cnt);
> > +       return 0;
> > +}
> > +
> >  static int libbpf_init(void)
> >  {
> > +       LIBBPF_OPTS(libbpf_prog_handler_opts, handler_opts,
> > +               .prog_prepare_load_fn = libbpf_prog_prepare_load_fn,
> > +       );
> > +
> >         if (libbpf_initialized)
> >                 return 0;
> >
> >         libbpf_set_print(libbpf_perf_print);
> > +       libbpf_sec_handler = libbpf_register_prog_handler(NULL, BPF_PROG_TYPE_KPROBE,
> > +                                                         0, &handler_opts);
> > +       if (libbpf_sec_handler < 0) {
> > +               pr_debug("bpf: failed to register libbpf section handler: %d\n",
> > +                        libbpf_sec_handler);
> > +               return -BPF_LOADER_ERRNO__INTERNAL;
> > +       }
> >         libbpf_initialized = true;
> >         return 0;
> >  }
> > --
> > 2.35.3
> >
