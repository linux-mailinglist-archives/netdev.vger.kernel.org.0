Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983A550F0D7
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245058AbiDZGW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiDZGW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:22:27 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82A012B440;
        Mon, 25 Apr 2022 23:19:20 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id o5so10782130ils.11;
        Mon, 25 Apr 2022 23:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8iFmPrKvmeoDy51u0C1oOas+JRzSDvA9FRv6LcekjE=;
        b=YM1orJAmrbwfaiMcNxrVbLt3Vx4fJebvS+xzrViwWOxwPkHZJotThjfo7aDtYe1znI
         PJT9ClUEo0VPD9z7ji+hkh8KCGx0PMltoaT6pccFjWMQtnAFE3hS1uMqeU7duVpgreVt
         mbOObtX9fRSomsHXfziNjh5XWLukyIv07le3YWGPHvBTIv955SMvuNlw0Km8tPmFZ987
         7yUk99bOABV6tCx96GgLLO9EeQWY3Sbzf3vDwvqLkAVIqsvaPqbQyBLkdRLt5zSAfYsi
         yCGytrVKcVtur9a8CxfkQE46S0IHPJHw36IIfZegvoWQ2vOBfudlrKTdmBu3UrbZJ8nH
         dbSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8iFmPrKvmeoDy51u0C1oOas+JRzSDvA9FRv6LcekjE=;
        b=eQWyuc7mhIslJCTic5MexM2C1YF7Pd1cnQ3JhOBh9GkzvvKWIarOOtPlCLobwbElm1
         qOH8nTM/bDiyJmAgyG5SHpTQQ8ou2927RC6BdJYh/gX91JUEozUAcsbF/LtXotnqi+rr
         aBa7fcIWMLwAuxRt4Z57h3vC4Ylx8gugaal2xNmStRiUboUFqzr4Vdzy2xEGezE5h7eD
         wZ4ex5FoNTdLb8JrGfv0hm3vrHMFMswbxPop9+YTzjnWJZve/68VhGO8kbCq5xNF+jSD
         FXOOt6Cm9VdSFRKGyGEKQFXuXM2OWkFYbBlMqTtrA8rm9Vdlo7JHUo3TdzMDwPtU3tJx
         5IDQ==
X-Gm-Message-State: AOAM533uC4YpI1JZ2QHzF+tt81uIJFDydx/1xLMzjbwP65hS3JPSMK8w
        eqVGSfUX3vKdsp5kknX6tFwX+r2EMi0TuPw2WSgv6V+y4wE=
X-Google-Smtp-Source: ABdhPJxw75pw3eAwEDGF8hbug0MzLY5F3MgWksY69nPfuonvBNQfwqOISDXT2jljFw51nuBSUOcljw2HfYDFW1NJYwg=
X-Received: by 2002:a92:cd8d:0:b0:2cd:81ce:79bd with SMTP id
 r13-20020a92cd8d000000b002cd81ce79bdmr5351717ilb.252.1650953960180; Mon, 25
 Apr 2022 23:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220422100025.1469207-1-jolsa@kernel.org> <20220422100025.1469207-2-jolsa@kernel.org>
 <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net>
In-Reply-To: <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:19:09 -0700
Message-ID: <CAEf4BzZOKosYRHwK2CfZzpTUcDdrLXPXbYax++Q_PHCMcNdqCw@mail.gmail.com>
Subject: Re: [PATCH perf/core 1/5] libbpf: Add bpf_program__set_insns function
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 9:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/22/22 12:00 PM, Jiri Olsa wrote:
> > Adding bpf_program__set_insns that allows to set new
> > instructions for program.
> >
> > Also moving bpf_program__attach_kprobe_multi_opts on
> > the proper name sorted place in map file.

would make sense to fix it as a separate patch, it has nothing to do
with bpf_program__set_insns() API itself

> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   tools/lib/bpf/libbpf.c   |  8 ++++++++
> >   tools/lib/bpf/libbpf.h   | 12 ++++++++++++
> >   tools/lib/bpf/libbpf.map |  3 ++-
> >   3 files changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 809fe209cdcc..284790d81c1b 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -8457,6 +8457,14 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
> >       return prog->insns_cnt;
> >   }
> >
> > +void bpf_program__set_insns(struct bpf_program *prog,
> > +                         struct bpf_insn *insns, size_t insns_cnt)
> > +{
> > +     free(prog->insns);
> > +     prog->insns = insns;
> > +     prog->insns_cnt = insns_cnt;

let's not store user-provided pointer here. Please realloc prog->insns
as necessary and copy over insns into it.

Also let's at least add the check for prog->loaded and return -EBUSY
in such a case. And of course this API should return int, not void.

> > +}
> > +
> >   int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
> >                         bpf_program_prep_t prep)
> >   {
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 05dde85e19a6..b31ad58d335f 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -323,6 +323,18 @@ struct bpf_insn;
> >    * different.
> >    */
> >   LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
> > +
> > +/**
> > + * @brief **bpf_program__set_insns()** can set BPF program's underlying
> > + * BPF instructions.
> > + * @param prog BPF program for which to return instructions
> > + * @param insn a pointer to an array of BPF instructions
> > + * @param insns_cnt number of `struct bpf_insn`'s that form
> > + * specified BPF program
> > + */

This API makes me want to cry... but I can't come up with anything
better for perf's use case.

But it can only more or less safely and sanely be used from the
prog_prepare_load_fn callback, so please add a big warning here saying
that this is a very advanced libbpf API and the user needs to know
what they are doing and this should be used from prog_prepare_load_fn
callback only. If bpf_program__set_insns() is called before
prog_prepare_load_fn any map/subprog/etc relocation will most probably
fail or corrupt BPF program code.

> > +LIBBPF_API void bpf_program__set_insns(struct bpf_program *prog,
> > +                                    struct bpf_insn *insns, size_t insns_cnt);

s/insns_cnt/insn_cnt/

> > +
>
> Iiuc, patch 2 should be squashed into this one given they logically belong to the
> same change?
>
> Fwiw, I think the API description should be elaborated a bit more, in particular that
> the passed-in insns need to be from allocated dynamic memory which is later on passed
> to free(), and maybe also constraints at which point in time bpf_program__set_insns()
> may be called.. (as well as high-level description on potential use cases e.g. around
> patch 4).

Yep, patch #1 is kind of broken without patch #2, so let's combine them.

>
> >   /**
> >    * @brief **bpf_program__insn_cnt()** returns number of `struct bpf_insn`'s
> >    * that form specified BPF program.
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index dd35ee58bfaa..afa10d24ab41 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -444,7 +444,8 @@ LIBBPF_0.8.0 {
> >       global:
> >               bpf_object__destroy_subskeleton;
> >               bpf_object__open_subskeleton;
> > +             bpf_program__attach_kprobe_multi_opts;
> > +             bpf_program__set_insns;
> >               libbpf_register_prog_handler;
> >               libbpf_unregister_prog_handler;
> > -             bpf_program__attach_kprobe_multi_opts;
> >   } LIBBPF_0.7.0;
> >
>
