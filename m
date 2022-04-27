Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73025113AE
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 10:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359497AbiD0Ipk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 04:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiD0Ipd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 04:45:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4F68233B;
        Wed, 27 Apr 2022 01:42:22 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id e23so1077556eda.11;
        Wed, 27 Apr 2022 01:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VqYAKvduflFt7r2OK51ZmulDMRePsr391vKLFS7HJW4=;
        b=h0RxgxXlI5ILM/FpadKTnw+IsnxUHFnT7XGkT6eLr9fwVyMwMInILr/Nb0XDCzQ64g
         pV1SGUNHIaGEGfvFiWKEDKmlbnLC0Lf2z16vN5IB4Q8fyI0ls3octBTcc7mc8qUi2W9W
         K9Mh2iQkyXlc4/W8juIJkuMFL+j4uCNaYTo03lUi9DZrDvNfgLzxD4lQbN6e4dbondiC
         VFbNvmb7NXkThhWDs0X7DSjYHO5u4iEbFOfK1KwmCGLS0mD817Ys5PdU8fAQQliFn0T/
         42jlWcR/ZCfY+RnJ8WV89T0Wjqyasg785jHc9gw0h7PmPTe1yrT2I8+wdn3aE87zAx23
         aj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VqYAKvduflFt7r2OK51ZmulDMRePsr391vKLFS7HJW4=;
        b=UVFT1gf717yIN8NVdNcFLCdJs4mYC4GSU0A/9M+E9I/QjwMRKmNN/BE08gwpKLIOMc
         wUtAsq6HLOBUOJSD6KJHztJ4hzFxNYLPDN+j4OcNb0JXdTfP/AaHpHKAoUoUvcrfGyXl
         jl1G0ATfpEtm+SAnIxJHswMHlTp+8J0lrP9Ny1nwMuFCwwaBXR2ObHsmE4WZHo3p3xeG
         RUzHDl/pa+Bzfx+tKbD2ZHlN1q3kmEnxb3CNIcMulYvJtEcYY8JxoY+GxCgTPOt8OlTQ
         dBXW9ad/RrM1fqN1w2cOs1XMthM3j4TnIbikEKYHKx/yU4SAHVT8Z2dDzRVb0gIvTX02
         OTZw==
X-Gm-Message-State: AOAM531cck7eDz+AXSRUplB4v2kprj0NRa8BVpxctNEFpQv8C/GEcv6R
        OfRT1lSe8XzVU1LJi21ZMvufuyjPpIPvs2q9
X-Google-Smtp-Source: ABdhPJyiWuJxBHlI/Y3nGxfxtmrQ9ysxEbkczQaP3k3kzJtC5oBGPnv5HaQ8qcmI+WiA5ByUy/P/nQ==
X-Received: by 2002:a05:6402:4388:b0:423:f7c9:7e04 with SMTP id o8-20020a056402438800b00423f7c97e04mr29285708edc.298.1651048940937;
        Wed, 27 Apr 2022 01:42:20 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id lz12-20020a170906fb0c00b006f3a36a9807sm3179566ejb.19.2022.04.27.01.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 01:42:20 -0700 (PDT)
Date:   Wed, 27 Apr 2022 10:42:17 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH perf/core 1/5] libbpf: Add bpf_program__set_insns function
Message-ID: <YmkB6XxM6avEZdSf@krava>
References: <20220422100025.1469207-1-jolsa@kernel.org>
 <20220422100025.1469207-2-jolsa@kernel.org>
 <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net>
 <CAEf4BzZOKosYRHwK2CfZzpTUcDdrLXPXbYax++Q_PHCMcNdqCw@mail.gmail.com>
 <YmeXx0mfy4Nr5jEB@krava>
 <CAEf4Bza42-aN7dZAWsH1H5KNMhSZh6nUj0WQ5MkOkNjBq2At_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza42-aN7dZAWsH1H5KNMhSZh6nUj0WQ5MkOkNjBq2At_A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 08:58:12AM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 25, 2022 at 11:57 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Mon, Apr 25, 2022 at 11:19:09PM -0700, Andrii Nakryiko wrote:
> > > On Mon, Apr 25, 2022 at 9:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On 4/22/22 12:00 PM, Jiri Olsa wrote:
> > > > > Adding bpf_program__set_insns that allows to set new
> > > > > instructions for program.
> > > > >
> > > > > Also moving bpf_program__attach_kprobe_multi_opts on
> > > > > the proper name sorted place in map file.
> > >
> > > would make sense to fix it as a separate patch, it has nothing to do
> > > with bpf_program__set_insns() API itself
> >
> > np
> >
> > >
> > > > >
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > ---
> > > > >   tools/lib/bpf/libbpf.c   |  8 ++++++++
> > > > >   tools/lib/bpf/libbpf.h   | 12 ++++++++++++
> > > > >   tools/lib/bpf/libbpf.map |  3 ++-
> > > > >   3 files changed, 22 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > index 809fe209cdcc..284790d81c1b 100644
> > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > @@ -8457,6 +8457,14 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
> > > > >       return prog->insns_cnt;
> > > > >   }
> > > > >
> > > > > +void bpf_program__set_insns(struct bpf_program *prog,
> > > > > +                         struct bpf_insn *insns, size_t insns_cnt)
> > > > > +{
> > > > > +     free(prog->insns);
> > > > > +     prog->insns = insns;
> > > > > +     prog->insns_cnt = insns_cnt;
> > >
> > > let's not store user-provided pointer here. Please realloc prog->insns
> > > as necessary and copy over insns into it.
> > >
> > > Also let's at least add the check for prog->loaded and return -EBUSY
> > > in such a case. And of course this API should return int, not void.
> >
> > ok, will change
> >
> > >
> > > > > +}
> > > > > +
> > > > >   int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
> > > > >                         bpf_program_prep_t prep)
> > > > >   {
> > > > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > > > index 05dde85e19a6..b31ad58d335f 100644
> > > > > --- a/tools/lib/bpf/libbpf.h
> > > > > +++ b/tools/lib/bpf/libbpf.h
> > > > > @@ -323,6 +323,18 @@ struct bpf_insn;
> > > > >    * different.
> > > > >    */
> > > > >   LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
> > > > > +
> > > > > +/**
> > > > > + * @brief **bpf_program__set_insns()** can set BPF program's underlying
> > > > > + * BPF instructions.
> > > > > + * @param prog BPF program for which to return instructions
> > > > > + * @param insn a pointer to an array of BPF instructions
> > > > > + * @param insns_cnt number of `struct bpf_insn`'s that form
> > > > > + * specified BPF program
> > > > > + */
> > >
> > > This API makes me want to cry... but I can't come up with anything
> > > better for perf's use case.
> > >
> 
> So thinking about this some more. If we make libbpf not to close maps
> and prog FDs on BPF program load failure automatically and instead
> doing it in bpf_object__close(), which would seem to be a totally fine
> semantics and won't break any reasonable application as they always
> have to call bpf_object__close() anyways to clean up all the
> resources; we wouldn't need this horror of bpf_program__set_insns().
> Your BPF program would fail to load, but you'll get its fully prepared
> instructions with bpf_program__insns(), then you can just append
> correct preamble. Meanwhile, all the maps will be created (they are
> always created before the first program load), so all the FDs will be
> correct.
> 
> This is certainly advanced knowledge of libbpf behavior, but the use
> case you are trying to solve is also very unique and advanced (and I
> wouldn't recommend anyone trying to do this anyways). WDYT? Would that
> work?

hm, so verifier will fail after all maps are set up during the walk
of the program instructions.. I guess that could work, I'll give it
a try, should be easy change in libbpf (like below) and also in perf

but still the bpf_program__set_insns seems less horror to me

jirka


---
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c8df74e5f658..1eb75d4231ff 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7577,19 +7577,6 @@ static int bpf_object_load(struct bpf_object *obj, int extra_log_level, const ch
 	obj->btf_vmlinux = NULL;
 
 	obj->loaded = true; /* doesn't matter if successfully or not */
-
-	if (err)
-		goto out;
-
-	return 0;
-out:
-	/* unpin any maps that were auto-pinned during load */
-	for (i = 0; i < obj->nr_maps; i++)
-		if (obj->maps[i].pinned && !obj->maps[i].reused)
-			bpf_map__unpin(&obj->maps[i], NULL);
-
-	bpf_object_unload(obj);
-	pr_warn("failed to load object '%s'\n", obj->path);
 	return libbpf_err(err);
 }
 
