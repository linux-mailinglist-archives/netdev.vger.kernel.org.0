Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7F653D1B8
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347909AbiFCSrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347884AbiFCSrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:47:10 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C0E11833;
        Fri,  3 Jun 2022 11:47:06 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id a17so7009730lfs.11;
        Fri, 03 Jun 2022 11:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+4u6kVDW4HmyPiFNJKwOa+wDt+d0qY4cVuOS5P9jlgU=;
        b=G0GlbfMDSx4cJ+0z+gggAxeiX7yEYlhYeUDBz1c2wHPIgvmNu8sl6WbjsJUaTbLp6I
         cIkWUwbt1eiLVfYPdMXkj7L57tdUWcmQMaZdlk3GXoArbIkRW6/0GMrmNpx+fvZA44PJ
         prL2tTi6sEviLrAueBoUZu6+MUM5dmDxRP/LtXbYlgXeF6E/Jq39vGE4+oOyIsZCf/OF
         HnNJHt2t+SK/T+vT3a36ih8qvFtNzxtbJYwCSg5THzMZbD9FKO/EkPUwCMsakVmwcc4X
         3edUBUITB8i6ovdjzXpwu3jxrNPaMfw5xoG/+ibSvavS5yYcM/QiCZgXmoNQ7EvVZzMW
         Ezdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+4u6kVDW4HmyPiFNJKwOa+wDt+d0qY4cVuOS5P9jlgU=;
        b=P38nUyiUigoLEUNJEBcWu46zGLwvR/qkK0/uFlI2A1Eeq1G+SV9MUvoW5XbguGch2N
         qWxYyw9lLcoD+fmo96LSvX37Hp503dJ+7pSpIGnkTn39/kT74tCHlfJe3Lu2aeqHqRVD
         +ZvufDkQRGkGVbLds9/Z24+ts7o6o7aMNt0z238YDCu5BsfndiQ2q+EcgVhMWU2opKGv
         3rG2jotKWa5a1F73w0LaYyJa2OouLgMEGgrBgphgn0L/SYPQ7YHVswVGsCgRE8g37rTr
         VM2+gVsdr2+HUeWjnH5taZJ7LWrm9Jj1+qDVibSQVySCBftdi/77+5pqbocISOnocYxr
         JVVg==
X-Gm-Message-State: AOAM533YxotCbI1suMkwa4JMkKqPxqPQAHY/BMtwf2O8AMHY5/4UatSx
        tOMPYeMs11sKBET+xcZxVvCACqVmSVemEYa23NY=
X-Google-Smtp-Source: ABdhPJxV9xeU45IgiSilfvyQA0Z99BTs9yjgeqcQ/qEH2sbr7iJatXqLpPyE4oq/tWsVOvAVVYgJq15Fwt0Thif9JmA=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr54449876lfa.681.1654282023944; Fri, 03
 Jun 2022 11:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220603092110.1294855-1-jolsa@kernel.org> <20220603092110.1294855-3-jolsa@kernel.org>
In-Reply-To: <20220603092110.1294855-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 11:46:52 -0700
Message-ID: <CAEf4BzYB44Ht20mF2RtYezaJU_TfN+j8nvZNbd82uvN=TmCXAA@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 2/2] perf tools: Rework prologue generation code
To:     Jiri Olsa <jolsa@kernel.org>
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

On Fri, Jun 3, 2022 at 2:21 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Some functions we use for bpf prologue generation are going to be
> deprecated. This change reworks current code not to use them.
>
> We need to replace following functions/struct:
>    bpf_program__set_prep
>    bpf_program__nth_fd
>    struct bpf_prog_prep_result
>
> Currently we use bpf_program__set_prep to hook perf callback before
> program is loaded and provide new instructions with the prologue.
>
> We replace this function/ality by taking instructions for specific
> program, attaching prologue to them and load such new ebpf programs
> with prologue using separate bpf_prog_load calls (outside libbpf
> load machinery).
>
> Before we can take and use program instructions, we need libbpf to
> actually load it. This way we get the final shape of its instructions
> with all relocations and verifier adjustments).
>
> There's one glitch though.. perf kprobe program already assumes
> generated prologue code with proper values in argument registers,
> so loading such program directly will fail in the verifier.
>
> That's where the fallback pre-load handler fits in and prepends
> the initialization code to the program. Once such program is loaded
> we take its instructions, cut off the initialization code and prepend
> the prologue.
>
> I know.. sorry ;-)
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/bpf-loader.c | 128 ++++++++++++++++++++++++++++++-----
>  1 file changed, 110 insertions(+), 18 deletions(-)
>
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index e7992a0eb477..2ce5f9684863 100644
> --- a/tools/perf/util/bpf-loader.c
> +++ b/tools/perf/util/bpf-loader.c
> @@ -9,6 +9,7 @@
>  #include <linux/bpf.h>
>  #include <bpf/libbpf.h>
>  #include <bpf/bpf.h>
> +#include <linux/filter.h>
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> @@ -49,6 +50,7 @@ struct bpf_prog_priv {
>         struct bpf_insn *insns_buf;
>         int nr_types;
>         int *type_mapping;
> +       int *proglogue_fds;

massively copy/pasted typo? prologue_fds?

Other than that looks good to me, but we'll need Arnaldo's ack before
merging into bpf-next.

>  };
>
>  struct bpf_perf_object {
> @@ -56,6 +58,11 @@ struct bpf_perf_object {
>         struct bpf_object *obj;
>  };
>

[...]
