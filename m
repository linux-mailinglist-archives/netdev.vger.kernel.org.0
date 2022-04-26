Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28CB50F0D5
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbiDZGWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiDZGWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:22:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CFF13CF4;
        Mon, 25 Apr 2022 23:19:10 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id kq17so10775235ejb.4;
        Mon, 25 Apr 2022 23:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1h3A+2ACOk79wIDhtERlYmDZwFSMTfhWJdzUK1wRn0k=;
        b=DcPALxPT7L9hw1cWhpXeR5/i2R4SmXKryIX2h4XFeGqw+MuI9oJ1IOxegzppwkw0GE
         9ThFiSGyQCprWmFZfwrQ4qz73s4y4Hm1EdkYNloI7JmlEQ1WcyYFzttt+XDOgcvJN6JN
         kd52/PMU7iIpW1w9NPUjesBAKuq3Z7CcmZbHuf7x+/ZTNeUB5cnDXP6ZDEyhApQ55j+j
         oTupkVvAeOxcsNZJY2wo6J7wgBGXKkKQctv/+d4TxJeXJdVpjUZUO335CCrLAU9RTeFy
         L3tduVLCLve0fYrSy1uxwhpufD0gRjVU2qTrZQvJUBEJeAc7shA7XRGaIm+PQ+/hLZ/J
         KWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1h3A+2ACOk79wIDhtERlYmDZwFSMTfhWJdzUK1wRn0k=;
        b=plkjky9a9MGSJxINT/Ajz4TnV2B6B2xBCr40eShlqEUe/RtNPgJCl7g8Th8d1Sic3t
         wuqi3Hz4LWg00MTP/ZxOGozFGqXe4gAco4x/apv0q2Fpa/JxeX9AxxOlj+sWj6uLUS4k
         VIHmNnE4VUGx2Br8h/zvJMsW8Vv1E2UbtG1Sc6J7rnRhmacymHZnqT24o5mO9xp5CjEM
         OHTZUCl42305q6QisZ6dZO63Upg+K4dVpAe5geK69b7Eo+nFlShu8lPYlH0t7b1K2Lgd
         tII6sf1ri64fo3zssbUHdmHyfGyB43wEFRCjA2cSmcvaCqAaVwvI7I30H7jhYnPYEOQB
         Aa9g==
X-Gm-Message-State: AOAM5301Idarpb4uv7mu983SA8Uz8+5A1cs0NZp9ZpG2f3klQE3tSaZt
        WBJqeRNsZkj1gZlhdrlTqQk=
X-Google-Smtp-Source: ABdhPJyYeSjACawgXozOsLlD5PJmBpWMvkhibqBuvLt1NJF3+yDr/4kr/3LKOzaXiqNK3XADQmp4/A==
X-Received: by 2002:a17:907:2159:b0:6f3:a307:d01d with SMTP id rk25-20020a170907215900b006f3a307d01dmr5218614ejb.760.1650953948694;
        Mon, 25 Apr 2022 23:19:08 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm4312058eja.55.2022.04.25.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 23:19:08 -0700 (PDT)
Date:   Tue, 26 Apr 2022 08:19:05 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCH perf/core 1/5] libbpf: Add bpf_program__set_insns function
Message-ID: <YmeO2YOHv5jRu/ca@krava>
References: <20220422100025.1469207-1-jolsa@kernel.org>
 <20220422100025.1469207-2-jolsa@kernel.org>
 <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 06:22:37PM +0200, Daniel Borkmann wrote:
> On 4/22/22 12:00 PM, Jiri Olsa wrote:
> > Adding bpf_program__set_insns that allows to set new
> > instructions for program.
> > 
> > Also moving bpf_program__attach_kprobe_multi_opts on
> > the proper name sorted place in map file.
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
> >   	return prog->insns_cnt;
> >   }
> > +void bpf_program__set_insns(struct bpf_program *prog,
> > +			    struct bpf_insn *insns, size_t insns_cnt)
> > +{
> > +	free(prog->insns);
> > +	prog->insns = insns;
> > +	prog->insns_cnt = insns_cnt;
> > +}
> > +
> >   int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
> >   			  bpf_program_prep_t prep)
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
> > +LIBBPF_API void bpf_program__set_insns(struct bpf_program *prog,
> > +				       struct bpf_insn *insns, size_t insns_cnt);
> > +
> 
> Iiuc, patch 2 should be squashed into this one given they logically belong to the
> same change?

right, that's probably better

> 
> Fwiw, I think the API description should be elaborated a bit more, in particular that
> the passed-in insns need to be from allocated dynamic memory which is later on passed
> to free(), and maybe also constraints at which point in time bpf_program__set_insns()
> may be called.. (as well as high-level description on potential use cases e.g. around
> patch 4).

ok, will add that

thanks,
jirka

> 
> >   /**
> >    * @brief **bpf_program__insn_cnt()** returns number of `struct bpf_insn`'s
> >    * that form specified BPF program.
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index dd35ee58bfaa..afa10d24ab41 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -444,7 +444,8 @@ LIBBPF_0.8.0 {
> >   	global:
> >   		bpf_object__destroy_subskeleton;
> >   		bpf_object__open_subskeleton;
> > +		bpf_program__attach_kprobe_multi_opts;
> > +		bpf_program__set_insns;
> >   		libbpf_register_prog_handler;
> >   		libbpf_unregister_prog_handler;
> > -		bpf_program__attach_kprobe_multi_opts;
> >   } LIBBPF_0.7.0;
> > 
> 
