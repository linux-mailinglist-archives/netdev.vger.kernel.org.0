Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7A150F18F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343538AbiDZHAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343520AbiDZHAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:00:23 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9424ECEB;
        Mon, 25 Apr 2022 23:57:16 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id r13so34093576ejd.5;
        Mon, 25 Apr 2022 23:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+D7xSiS0Km1eNdFEjShizW82VnmaVjxgZEwEZR3GerQ=;
        b=PRig5ecewg8gI6OvCTVtRFvY4FJuZPuPazEFYXS4DxOY1ieso+OIDEaeGZrXxhlwTH
         CrHDvPzekLD373DSewAalocKeODNUQ0XY+RokQf93EHJwhGGTyGfV04O0e81zyctmmgT
         BKdgm+BgMSF/cc3LHf/3lpQhpx9ebi1KvwvGq0nqiYvbjbdExFgCYTNuQPURZepuMlxP
         XyaK423H7fpfDdGKnoa3NYSCWrcVjeI6PFGpV+UeDaowm3KUrfISowgEj7Yh3whsDU3s
         Kftm18ox8HZ83UEgDWQwHVa1gESow70Sncu/3qrEPbt4L+jkRcMQpvv2PUew7HjnADl3
         xjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+D7xSiS0Km1eNdFEjShizW82VnmaVjxgZEwEZR3GerQ=;
        b=EfXnnjx4N0fk5iPxf72eiRryXdM4yZnNApCz8lFEv5KsCCevEWaoelAXyloJhHrH52
         k1H1lzBnB5igSj8pzongf4ZGXEY+kcOeAg3GXpfIALvGDNU/RgZaRbBDskLSTO6OcBrH
         kBD8uD4ZgZS/ppANEHvONzX/FOMHZKJUPHeRH/OHXLEbAT37NgPcgImTTv4iqgZ/WA+V
         gqUNlO2os2/JlPVJgecXKDXiA5bwaoxEJetGo++qbJ+WkGAJx9X/9uev8srZJefG1LqS
         5PkU8TCps4mHDrg2YyA4fU5Ro9ranwRNNL8gzT+/Klveh8H9K8An4UZHJY67q6GKsx8l
         WOOA==
X-Gm-Message-State: AOAM533wkfn/BjiBlwag6/YSEdNSChBlA661X5eUtVqT4xMI8D+Yt06t
        ACBtEggMEm2SFCTNXItzpVs=
X-Google-Smtp-Source: ABdhPJx3N0/KiDIvzS/xzc1MJm7tOByvA6A8pJav9doTQhdBlDpra3yH5th/yvsTD2c21sgWiKsnNQ==
X-Received: by 2002:a17:907:7ba6:b0:6f3:8f56:793b with SMTP id ne38-20020a1709077ba600b006f38f56793bmr9735258ejc.473.1650956235030;
        Mon, 25 Apr 2022 23:57:15 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id i2-20020a1709061cc200b006f386217c6bsm2647668ejh.124.2022.04.25.23.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 23:57:14 -0700 (PDT)
Date:   Tue, 26 Apr 2022 08:57:11 +0200
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
Message-ID: <YmeXx0mfy4Nr5jEB@krava>
References: <20220422100025.1469207-1-jolsa@kernel.org>
 <20220422100025.1469207-2-jolsa@kernel.org>
 <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net>
 <CAEf4BzZOKosYRHwK2CfZzpTUcDdrLXPXbYax++Q_PHCMcNdqCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZOKosYRHwK2CfZzpTUcDdrLXPXbYax++Q_PHCMcNdqCw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 11:19:09PM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 25, 2022 at 9:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 4/22/22 12:00 PM, Jiri Olsa wrote:
> > > Adding bpf_program__set_insns that allows to set new
> > > instructions for program.
> > >
> > > Also moving bpf_program__attach_kprobe_multi_opts on
> > > the proper name sorted place in map file.
> 
> would make sense to fix it as a separate patch, it has nothing to do
> with bpf_program__set_insns() API itself

np

> 
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >   tools/lib/bpf/libbpf.c   |  8 ++++++++
> > >   tools/lib/bpf/libbpf.h   | 12 ++++++++++++
> > >   tools/lib/bpf/libbpf.map |  3 ++-
> > >   3 files changed, 22 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 809fe209cdcc..284790d81c1b 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -8457,6 +8457,14 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
> > >       return prog->insns_cnt;
> > >   }
> > >
> > > +void bpf_program__set_insns(struct bpf_program *prog,
> > > +                         struct bpf_insn *insns, size_t insns_cnt)
> > > +{
> > > +     free(prog->insns);
> > > +     prog->insns = insns;
> > > +     prog->insns_cnt = insns_cnt;
> 
> let's not store user-provided pointer here. Please realloc prog->insns
> as necessary and copy over insns into it.
> 
> Also let's at least add the check for prog->loaded and return -EBUSY
> in such a case. And of course this API should return int, not void.

ok, will change

> 
> > > +}
> > > +
> > >   int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
> > >                         bpf_program_prep_t prep)
> > >   {
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index 05dde85e19a6..b31ad58d335f 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -323,6 +323,18 @@ struct bpf_insn;
> > >    * different.
> > >    */
> > >   LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
> > > +
> > > +/**
> > > + * @brief **bpf_program__set_insns()** can set BPF program's underlying
> > > + * BPF instructions.
> > > + * @param prog BPF program for which to return instructions
> > > + * @param insn a pointer to an array of BPF instructions
> > > + * @param insns_cnt number of `struct bpf_insn`'s that form
> > > + * specified BPF program
> > > + */
> 
> This API makes me want to cry... but I can't come up with anything
> better for perf's use case.
> 
> But it can only more or less safely and sanely be used from the
> prog_prepare_load_fn callback, so please add a big warning here saying
> that this is a very advanced libbpf API and the user needs to know
> what they are doing and this should be used from prog_prepare_load_fn
> callback only. If bpf_program__set_insns() is called before
> prog_prepare_load_fn any map/subprog/etc relocation will most probably
> fail or corrupt BPF program code.

will add the warnings

> 
> > > +LIBBPF_API void bpf_program__set_insns(struct bpf_program *prog,
> > > +                                    struct bpf_insn *insns, size_t insns_cnt);
> 
> s/insns_cnt/insn_cnt/
> 
> > > +
> >
> > Iiuc, patch 2 should be squashed into this one given they logically belong to the
> > same change?
> >
> > Fwiw, I think the API description should be elaborated a bit more, in particular that
> > the passed-in insns need to be from allocated dynamic memory which is later on passed
> > to free(), and maybe also constraints at which point in time bpf_program__set_insns()
> > may be called.. (as well as high-level description on potential use cases e.g. around
> > patch 4).
> 
> Yep, patch #1 is kind of broken without patch #2, so let's combine them.

ok

thanks,
jirka
