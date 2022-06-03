Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561C353D25B
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349252AbiFCT21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237562AbiFCT2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:28:25 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF7D2A71E;
        Fri,  3 Jun 2022 12:28:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a15so3064465wrh.2;
        Fri, 03 Jun 2022 12:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4uPbkf5UwcTv67eMoEK+jU8Mqfc5cs35phf6Mu3osaU=;
        b=bvRS7X5ZAUfrd3gsGqATChaxH2yV66tlhpE6HY65QIoEVuaoLZ/Ed6vmfKj5dVax7Y
         KC7sF+Kes73MccmeOXAvLhCbXQVVvxlfO/eIxSsCYH9MJBlOADOHTrWJnw3pstfmmHJI
         59URI4W5msImaCKEFm2/IciRNO0/Q4LwA0He8pX2eZyw2cQsFlWU0CqaYzHMCCp/g7zZ
         jbhv2xQ2tRqfe9EvDbJFu9pmGpOtGMupcBW/JI1oidB+Eax7bEbLkEMJRzSulBT7sxV3
         frpY3rc7gZJ/sKy9wqeuo1KX0E22d8S29LO9IDEAk7/IIx8l+PdK71TRB33IDERBIySw
         bSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4uPbkf5UwcTv67eMoEK+jU8Mqfc5cs35phf6Mu3osaU=;
        b=dr1DQzChr8lxrvMjk1VzlWQXDv1xc/nuNIbDih6s0GM13hntzhsjbKb/oAjwF4aQaS
         k5LzILNmR1DU2RBQ5j8CKdDJpTe88PwX2yRVBI9bRUFW//PEev6r+VF5XdG7OcREfcAX
         y8lqkfXa0Z7B4y7fOlMDVeK8UyCOk+LFnJBdR2vV39bnDHi91cuvJM965YvmObLHTXY+
         qPGtvUim8P/WsyEkflZ4cZD9/enN2MBGHZS+27aAV1+KMysc6QyEjC0kxFogTJeBcgBt
         lgnxB1/nvtAF37xhfm/Xku9pcJXlwKYir03ovzcUWB+X3XaS0jR5wk+epH9rG5ShLm1g
         OqUA==
X-Gm-Message-State: AOAM532HtCRWQ4G14DzpGouUc2KMSkFP0ufhpw4aGrsnkrzd9XZDMlei
        AIPytm65DuEbw9PdjPoDQs0=
X-Google-Smtp-Source: ABdhPJwHFEDixDm7cpm7RPAbljg13vJ/exLx3Kh7goEgC/OPKYeE7bcC3AD0Omo6R6xVbeFOF8L03A==
X-Received: by 2002:a5d:6445:0:b0:211:7eee:2f94 with SMTP id d5-20020a5d6445000000b002117eee2f94mr9447352wrw.631.1654284503374;
        Fri, 03 Jun 2022 12:28:23 -0700 (PDT)
Received: from krava ([83.240.62.162])
        by smtp.gmail.com with ESMTPSA id h6-20020adfa4c6000000b0020fe61acd09sm8560295wrb.12.2022.06.03.12.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 12:28:22 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 3 Jun 2022 21:28:20 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Subject: Re: [PATCHv3 bpf-next 2/2] perf tools: Rework prologue generation
 code
Message-ID: <Yppg1KCn4Mkw6T2K@krava>
References: <20220603092110.1294855-1-jolsa@kernel.org>
 <20220603092110.1294855-3-jolsa@kernel.org>
 <CAEf4BzYB44Ht20mF2RtYezaJU_TfN+j8nvZNbd82uvN=TmCXAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYB44Ht20mF2RtYezaJU_TfN+j8nvZNbd82uvN=TmCXAA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 11:46:52AM -0700, Andrii Nakryiko wrote:
> On Fri, Jun 3, 2022 at 2:21 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Some functions we use for bpf prologue generation are going to be
> > deprecated. This change reworks current code not to use them.
> >
> > We need to replace following functions/struct:
> >    bpf_program__set_prep
> >    bpf_program__nth_fd
> >    struct bpf_prog_prep_result
> >
> > Currently we use bpf_program__set_prep to hook perf callback before
> > program is loaded and provide new instructions with the prologue.
> >
> > We replace this function/ality by taking instructions for specific
> > program, attaching prologue to them and load such new ebpf programs
> > with prologue using separate bpf_prog_load calls (outside libbpf
> > load machinery).
> >
> > Before we can take and use program instructions, we need libbpf to
> > actually load it. This way we get the final shape of its instructions
> > with all relocations and verifier adjustments).
> >
> > There's one glitch though.. perf kprobe program already assumes
> > generated prologue code with proper values in argument registers,
> > so loading such program directly will fail in the verifier.
> >
> > That's where the fallback pre-load handler fits in and prepends
> > the initialization code to the program. Once such program is loaded
> > we take its instructions, cut off the initialization code and prepend
> > the prologue.
> >
> > I know.. sorry ;-)
> >
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/perf/util/bpf-loader.c | 128 ++++++++++++++++++++++++++++++-----
> >  1 file changed, 110 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> > index e7992a0eb477..2ce5f9684863 100644
> > --- a/tools/perf/util/bpf-loader.c
> > +++ b/tools/perf/util/bpf-loader.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/bpf.h>
> >  #include <bpf/libbpf.h>
> >  #include <bpf/bpf.h>
> > +#include <linux/filter.h>
> >  #include <linux/err.h>
> >  #include <linux/kernel.h>
> >  #include <linux/string.h>
> > @@ -49,6 +50,7 @@ struct bpf_prog_priv {
> >         struct bpf_insn *insns_buf;
> >         int nr_types;
> >         int *type_mapping;
> > +       int *proglogue_fds;
> 
> massively copy/pasted typo? prologue_fds?

mama mia :)) time to have my eyes checked..  sry, I'll send new version

jirka

> 
> Other than that looks good to me, but we'll need Arnaldo's ack before
> merging into bpf-next.
> 
> >  };
> >
> >  struct bpf_perf_object {
> > @@ -56,6 +58,11 @@ struct bpf_perf_object {
> >         struct bpf_object *obj;
> >  };
> >
> 
> [...]
