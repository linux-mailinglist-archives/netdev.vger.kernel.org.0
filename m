Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4515121E4
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiD0TBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiD0TB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:01:29 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64E7AF1C5;
        Wed, 27 Apr 2022 11:47:53 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g21so4172462iom.13;
        Wed, 27 Apr 2022 11:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14esCJF8oxhC7+SUFQUnNCY+R3HMTtAjg+iM+T6QmHk=;
        b=lJ8lraGidTiZGaFNkBpA40MehmTR0OeN76envnFcftCuPAO9NuIE604PojZkr37zmY
         yRLC8gzsrdjf0u1VQVd/auBX5c9k4QbrljzNimv/lR2bd3EDYNOMacCMubmOtmcnFa0Y
         pVDk9UuRJIwdDQyX+FlE+PQAp1/w3ZJGgKcC/O6qOeEU5V/bxWN5l9jeCmM+dSUCa37Z
         bAH9ek152wS7bBdrV4YpScdhOhlGiDRjo7DdyuwsiMkNSqbs3+OYDF0ORTRmXKc71T0s
         M2ALp92icMvmDCAFORRGJE4IIeNAYLki1+ABv7DYmvrzJZHAO1otAm7Ol6cDzRgmZt6w
         Uqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14esCJF8oxhC7+SUFQUnNCY+R3HMTtAjg+iM+T6QmHk=;
        b=vC5YZguSxqefFjIA/Ab+bspCMeDzV6i6unfk2TlOPcyDqoUcB8Ga7ZzD+gA3N2p44V
         69lRBT+RRiSFmSb75Z+0+Nf6jpVdwgB5oi3bBzdgdfhlaLrgPE1hdTAmA9YtnOmxo8fu
         n7c5hBh3L1AVo14iB3xTdL5Lvie/rYbFQC82c8vsvP6LmTLAzAahFGrIhwINesq2Dowr
         FFcfHZtCsx5aE+Ga/FTsZacFlv3QnD7g4ilE7JN/0wx0uqx/tAj6WxAz/2VYPJsVW7yj
         cRNtM8TRcsEQfKZbfGVHJQJfnd+1w4E1KmyWKeASivfbka3I4Wso8RtcGf4QwcpXX/N4
         Pm7Q==
X-Gm-Message-State: AOAM532nHVnG88DeaXuGiPJAzo9Fisxita3RZ/mQ2DFDoZgm+/AwV2nw
        N0xxS3a5cIvNTbfj55ltPaGWn8xydJREo1CODHoU3/s/
X-Google-Smtp-Source: ABdhPJwctKhC+LoPa0yYdVmlkzCrYOu0J3MbwGtvBhbxBwPqYcmnpKbJoI/stCM52ACnkwmTAtKj8wAFtT5PZmAokBw=
X-Received: by 2002:a05:6602:1683:b0:64f:ba36:d3cf with SMTP id
 s3-20020a056602168300b0064fba36d3cfmr12102330iow.144.1651085273075; Wed, 27
 Apr 2022 11:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220422100025.1469207-1-jolsa@kernel.org> <20220422100025.1469207-2-jolsa@kernel.org>
 <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net> <CAEf4BzZOKosYRHwK2CfZzpTUcDdrLXPXbYax++Q_PHCMcNdqCw@mail.gmail.com>
 <YmeXx0mfy4Nr5jEB@krava> <CAEf4Bza42-aN7dZAWsH1H5KNMhSZh6nUj0WQ5MkOkNjBq2At_A@mail.gmail.com>
 <YmkB6XxM6avEZdSf@krava>
In-Reply-To: <YmkB6XxM6avEZdSf@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 11:47:42 -0700
Message-ID: <CAEf4Bza2MGR9j5HL4eu_PP5UpZ49_8YPG=GLfxe0kHCYQWJWJw@mail.gmail.com>
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

On Wed, Apr 27, 2022 at 1:42 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Tue, Apr 26, 2022 at 08:58:12AM -0700, Andrii Nakryiko wrote:
> > On Mon, Apr 25, 2022 at 11:57 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> > >
> > > On Mon, Apr 25, 2022 at 11:19:09PM -0700, Andrii Nakryiko wrote:
> > > > On Mon, Apr 25, 2022 at 9:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > >
> > > > > On 4/22/22 12:00 PM, Jiri Olsa wrote:
> > > > > > Adding bpf_program__set_insns that allows to set new
> > > > > > instructions for program.
> > > > > >
> > > > > > Also moving bpf_program__attach_kprobe_multi_opts on
> > > > > > the proper name sorted place in map file.
> > > >
> > > > would make sense to fix it as a separate patch, it has nothing to do
> > > > with bpf_program__set_insns() API itself
> > >
> > > np
> > >
> > > >
> > > > > >
> > > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > > ---
> > > > > >   tools/lib/bpf/libbpf.c   |  8 ++++++++
> > > > > >   tools/lib/bpf/libbpf.h   | 12 ++++++++++++
> > > > > >   tools/lib/bpf/libbpf.map |  3 ++-
> > > > > >   3 files changed, 22 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > > index 809fe209cdcc..284790d81c1b 100644
> > > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > > @@ -8457,6 +8457,14 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
> > > > > >       return prog->insns_cnt;
> > > > > >   }
> > > > > >
> > > > > > +void bpf_program__set_insns(struct bpf_program *prog,
> > > > > > +                         struct bpf_insn *insns, size_t insns_cnt)
> > > > > > +{
> > > > > > +     free(prog->insns);
> > > > > > +     prog->insns = insns;
> > > > > > +     prog->insns_cnt = insns_cnt;
> > > >
> > > > let's not store user-provided pointer here. Please realloc prog->insns
> > > > as necessary and copy over insns into it.
> > > >
> > > > Also let's at least add the check for prog->loaded and return -EBUSY
> > > > in such a case. And of course this API should return int, not void.
> > >
> > > ok, will change
> > >
> > > >
> > > > > > +}
> > > > > > +
> > > > > >   int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
> > > > > >                         bpf_program_prep_t prep)
> > > > > >   {
> > > > > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > > > > index 05dde85e19a6..b31ad58d335f 100644
> > > > > > --- a/tools/lib/bpf/libbpf.h
> > > > > > +++ b/tools/lib/bpf/libbpf.h
> > > > > > @@ -323,6 +323,18 @@ struct bpf_insn;
> > > > > >    * different.
> > > > > >    */
> > > > > >   LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
> > > > > > +
> > > > > > +/**
> > > > > > + * @brief **bpf_program__set_insns()** can set BPF program's underlying
> > > > > > + * BPF instructions.
> > > > > > + * @param prog BPF program for which to return instructions
> > > > > > + * @param insn a pointer to an array of BPF instructions
> > > > > > + * @param insns_cnt number of `struct bpf_insn`'s that form
> > > > > > + * specified BPF program
> > > > > > + */
> > > >
> > > > This API makes me want to cry... but I can't come up with anything
> > > > better for perf's use case.
> > > >
> >
> > So thinking about this some more. If we make libbpf not to close maps
> > and prog FDs on BPF program load failure automatically and instead
> > doing it in bpf_object__close(), which would seem to be a totally fine
> > semantics and won't break any reasonable application as they always
> > have to call bpf_object__close() anyways to clean up all the
> > resources; we wouldn't need this horror of bpf_program__set_insns().
> > Your BPF program would fail to load, but you'll get its fully prepared
> > instructions with bpf_program__insns(), then you can just append
> > correct preamble. Meanwhile, all the maps will be created (they are
> > always created before the first program load), so all the FDs will be
> > correct.
> >
> > This is certainly advanced knowledge of libbpf behavior, but the use
> > case you are trying to solve is also very unique and advanced (and I
> > wouldn't recommend anyone trying to do this anyways). WDYT? Would that
> > work?
>
> hm, so verifier will fail after all maps are set up during the walk
> of the program instructions.. I guess that could work, I'll give it
> a try, should be easy change in libbpf (like below) and also in perf
>
> but still the bpf_program__set_insns seems less horror to me

let's keep set_insns API then, but please do add a lot of warnings
into the description to make it very-very scary :)

>
> jirka
>
>
> ---
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index c8df74e5f658..1eb75d4231ff 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7577,19 +7577,6 @@ static int bpf_object_load(struct bpf_object *obj, int extra_log_level, const ch
>         obj->btf_vmlinux = NULL;
>
>         obj->loaded = true; /* doesn't matter if successfully or not */
> -
> -       if (err)
> -               goto out;
> -
> -       return 0;
> -out:
> -       /* unpin any maps that were auto-pinned during load */
> -       for (i = 0; i < obj->nr_maps; i++)
> -               if (obj->maps[i].pinned && !obj->maps[i].reused)
> -                       bpf_map__unpin(&obj->maps[i], NULL);
> -
> -       bpf_object_unload(obj);
> -       pr_warn("failed to load object '%s'\n", obj->path);
>         return libbpf_err(err);
>  }
>
