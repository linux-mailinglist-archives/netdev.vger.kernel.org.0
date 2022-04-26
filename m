Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE4B51025D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352715AbiDZQBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352709AbiDZQBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:01:33 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C38415F5BE;
        Tue, 26 Apr 2022 08:58:24 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 79so20525532iou.7;
        Tue, 26 Apr 2022 08:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d8FLyaN1lsrCzWPKXANEWACyzqrmLi1Yyh4Z8+MPj3M=;
        b=ab0y09KjsgKm4bMjyedLySmbGf5nHdwS4JDBlHmnofM6W+bpJ6tYAGN5GYbMgFzLDf
         eNbO2iftFU6sShQTTHGzekiztz2RG9gDfKzLPE1Xa8XvCNhpmqS7CwFhtMvb7xqhAmHU
         rUxnKIcEqK+rsgycLTzoOqhrEHDFMRe3518MoZdhvgaQ9ntJYncGx+GLFTpfjcIYXIBG
         RSrThPQhZSeEs5Rh0ICWc4a2O36rjRrZcGBYP61YDPV5lAeuqbIL78GP+cj5jdTmYluE
         WVbzS5JS4hwfP5lvGu5T6N9rOcNAN5od771ouhWbfd4O/Yx/alxZcHffZ55z/9ISFcGB
         MVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d8FLyaN1lsrCzWPKXANEWACyzqrmLi1Yyh4Z8+MPj3M=;
        b=348smgSHfFSkGS/rX4GYKgkwQDFB7gxbDXg4S2BfXfSQZuWY5Pf6pWFjjDyPnz8Akg
         5N79ADUHOPPeMla/WrWCmco8LsZK41RcltFudOlimH/BwwkgI4UDtmDyoQi2499vl18P
         bjXwM+V9kvemrlaRNocyVsk6Lu9/0YlkErCjYyS3abY0Kn4ikwBCVS3kk99S8VXlo9m9
         SZAukVDd1uEIfBOeobXGQ8pWfFAzTmLtP5R4DrlzZmPNOR4jY79tBc9dZi5hInHsHO4s
         ylefg2OYledgMx8ev8v7alH8HHETzA8iM7B+4XS4TlNJg1XVeQ2UrPEpZARRxZkWxEya
         kmiw==
X-Gm-Message-State: AOAM530omEp47rO65xPx12ocYa2aP6XG5nDa6MVcFj6HAjXyirGpi0ET
        9BoVpX3Q+NIck65PdKJVQpoIZwvJ91BC2FH8GP4=
X-Google-Smtp-Source: ABdhPJxlBp941tDGyA4ji5llToCTNpwkqcM1zPijWP6pE88/bFK42Tx/Y4oKZcA8+Yjc9x9zP66kzcBg24odBfuJiJw=
X-Received: by 2002:a92:c247:0:b0:2cc:1798:74fe with SMTP id
 k7-20020a92c247000000b002cc179874femr9258731ilo.239.1650988703597; Tue, 26
 Apr 2022 08:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220422100025.1469207-1-jolsa@kernel.org> <20220422100025.1469207-2-jolsa@kernel.org>
 <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net> <CAEf4BzZOKosYRHwK2CfZzpTUcDdrLXPXbYax++Q_PHCMcNdqCw@mail.gmail.com>
 <YmeXx0mfy4Nr5jEB@krava>
In-Reply-To: <YmeXx0mfy4Nr5jEB@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Apr 2022 08:58:12 -0700
Message-ID: <CAEf4Bza42-aN7dZAWsH1H5KNMhSZh6nUj0WQ5MkOkNjBq2At_A@mail.gmail.com>
Subject: Re: [PATCH perf/core 1/5] libbpf: Add bpf_program__set_insns function
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
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

On Mon, Apr 25, 2022 at 11:57 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Mon, Apr 25, 2022 at 11:19:09PM -0700, Andrii Nakryiko wrote:
> > On Mon, Apr 25, 2022 at 9:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 4/22/22 12:00 PM, Jiri Olsa wrote:
> > > > Adding bpf_program__set_insns that allows to set new
> > > > instructions for program.
> > > >
> > > > Also moving bpf_program__attach_kprobe_multi_opts on
> > > > the proper name sorted place in map file.
> >
> > would make sense to fix it as a separate patch, it has nothing to do
> > with bpf_program__set_insns() API itself
>
> np
>
> >
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >   tools/lib/bpf/libbpf.c   |  8 ++++++++
> > > >   tools/lib/bpf/libbpf.h   | 12 ++++++++++++
> > > >   tools/lib/bpf/libbpf.map |  3 ++-
> > > >   3 files changed, 22 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index 809fe209cdcc..284790d81c1b 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -8457,6 +8457,14 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
> > > >       return prog->insns_cnt;
> > > >   }
> > > >
> > > > +void bpf_program__set_insns(struct bpf_program *prog,
> > > > +                         struct bpf_insn *insns, size_t insns_cnt)
> > > > +{
> > > > +     free(prog->insns);
> > > > +     prog->insns = insns;
> > > > +     prog->insns_cnt = insns_cnt;
> >
> > let's not store user-provided pointer here. Please realloc prog->insns
> > as necessary and copy over insns into it.
> >
> > Also let's at least add the check for prog->loaded and return -EBUSY
> > in such a case. And of course this API should return int, not void.
>
> ok, will change
>
> >
> > > > +}
> > > > +
> > > >   int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
> > > >                         bpf_program_prep_t prep)
> > > >   {
> > > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > > index 05dde85e19a6..b31ad58d335f 100644
> > > > --- a/tools/lib/bpf/libbpf.h
> > > > +++ b/tools/lib/bpf/libbpf.h
> > > > @@ -323,6 +323,18 @@ struct bpf_insn;
> > > >    * different.
> > > >    */
> > > >   LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
> > > > +
> > > > +/**
> > > > + * @brief **bpf_program__set_insns()** can set BPF program's underlying
> > > > + * BPF instructions.
> > > > + * @param prog BPF program for which to return instructions
> > > > + * @param insn a pointer to an array of BPF instructions
> > > > + * @param insns_cnt number of `struct bpf_insn`'s that form
> > > > + * specified BPF program
> > > > + */
> >
> > This API makes me want to cry... but I can't come up with anything
> > better for perf's use case.
> >

So thinking about this some more. If we make libbpf not to close maps
and prog FDs on BPF program load failure automatically and instead
doing it in bpf_object__close(), which would seem to be a totally fine
semantics and won't break any reasonable application as they always
have to call bpf_object__close() anyways to clean up all the
resources; we wouldn't need this horror of bpf_program__set_insns().
Your BPF program would fail to load, but you'll get its fully prepared
instructions with bpf_program__insns(), then you can just append
correct preamble. Meanwhile, all the maps will be created (they are
always created before the first program load), so all the FDs will be
correct.

This is certainly advanced knowledge of libbpf behavior, but the use
case you are trying to solve is also very unique and advanced (and I
wouldn't recommend anyone trying to do this anyways). WDYT? Would that
work?

> > But it can only more or less safely and sanely be used from the
> > prog_prepare_load_fn callback, so please add a big warning here saying
> > that this is a very advanced libbpf API and the user needs to know
> > what they are doing and this should be used from prog_prepare_load_fn
> > callback only. If bpf_program__set_insns() is called before
> > prog_prepare_load_fn any map/subprog/etc relocation will most probably
> > fail or corrupt BPF program code.
>
> will add the warnings
>
> >
> > > > +LIBBPF_API void bpf_program__set_insns(struct bpf_program *prog,
> > > > +                                    struct bpf_insn *insns, size_t insns_cnt);
> >
> > s/insns_cnt/insn_cnt/
> >
> > > > +
> > >
> > > Iiuc, patch 2 should be squashed into this one given they logically belong to the
> > > same change?
> > >
> > > Fwiw, I think the API description should be elaborated a bit more, in particular that
> > > the passed-in insns need to be from allocated dynamic memory which is later on passed
> > > to free(), and maybe also constraints at which point in time bpf_program__set_insns()
> > > may be called.. (as well as high-level description on potential use cases e.g. around
> > > patch 4).
> >
> > Yep, patch #1 is kind of broken without patch #2, so let's combine them.
>
> ok
>
> thanks,
> jirka
