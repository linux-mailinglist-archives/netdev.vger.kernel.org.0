Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8767F5227C3
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiEJXpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiEJXpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:45:13 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043A5BE6B;
        Tue, 10 May 2022 16:45:12 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e15so444151iob.3;
        Tue, 10 May 2022 16:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wATuxJ90w3SohnNFQrv277+BPZn2Ntr4DIlED5m3scw=;
        b=dbheb9oJ9YgLDUok/wjCXtnU2EgK9IV3VjjeTOkTox5vtD9ImLTlhCjk75DT+EinMU
         4XS3gcJo4K6wOL+ejoL1hHQZ7xo04Po9CAOEip58QhkZmZ1BRAah6yUYV3MRjZhszvA6
         RNWV3r/04GUSrCh/9iTDB/OGdACCo5LxM1krcfA0m3/u2/9AseO5PN+EU6xy5knPpGo/
         09SmNbdQAF4jgE23nZwjDmK6dtbHrlrOud4NMdRgogj6ONW86pmHFQtp1/88US4unvSZ
         1o4fKLi6e+gDi6sQHUDlcYy2C0jYlddc7pSgDDD8BcAJd7AyieTF2G3mcn3ffvBR/2ge
         wX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wATuxJ90w3SohnNFQrv277+BPZn2Ntr4DIlED5m3scw=;
        b=De5NnQ1Al1vLBayFhTWgPeydGv9/oWvyWFo2Ha+jHIsxuGXhYM9KqVxjNovObHW5jX
         MtBLdCjrOIqzo1TC9zCdCottgTXD1irbI/fIhLSvynk7H1lQeCHP0873LUkAdrMj6oXa
         WzKUKq/QO/QaKDD4AecNBQIBYV5C/yE7GU0oZG1YAEfJ7uoT/r/FTV5rMV9KF5fHNjCv
         6DVrVM32ay6LOeFdwTHaE2827pXr3rTK+kd/YYhE9W6ci8smidWAyjlVm+ZYhau4rfEM
         eRM3XZZS6hs15HDHbaYAadMBpaXHUHxCxdrdX0H0XPXGfOhL0RMIib32T3JjTQhieCzq
         aHww==
X-Gm-Message-State: AOAM532ARF9HpNV/5l9OWnZCLW78C2tXAT6pX/iIFxKZurrWXnuCUFFu
        AF/LNPP3YZRkMtvmD7r42O5MnJ8B/QIEHYIcMJU=
X-Google-Smtp-Source: ABdhPJyY+v3smYSOc36bZa6g3lpDz8xQNV/WmwkBYGNeXJOu318bre8+/gDvUoeKaI4xZM7U8xgQMyb3ZELBHbgmUXY=
X-Received: by 2002:a05:6638:16d6:b0:32b:a283:a822 with SMTP id
 g22-20020a05663816d600b0032ba283a822mr11247396jat.145.1652226311934; Tue, 10
 May 2022 16:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220510074659.2557731-1-jolsa@kernel.org> <20220510074659.2557731-3-jolsa@kernel.org>
In-Reply-To: <20220510074659.2557731-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 May 2022 16:45:01 -0700
Message-ID: <CAEf4Bzav8he-_fD=D5KMFW7s=PkJoZG9cUr+BOTuV54KKOC70A@mail.gmail.com>
Subject: Re: [PATCHv2 perf/core 2/3] perf tools: Register fallback libbpf
 section handler
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

On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Perf is using section name to declare special kprobe arguments,
> which no longer works with current libbpf, that either requires
> certain form of the section name or allows to register custom
> handler.
>
> Adding perf support to register 'fallback' section handler to take
> care of perf kprobe programs. The fallback means that it handles
> any section definition besides the ones that libbpf handles.
>
> The handler serves two purposes:
>   - allows perf programs to have special arguments in section name
>   - allows perf to use pre-load callback where we can attach init
>     code (zeroing all argument registers) to each perf program
>
> The second is essential part of new prologue generation code,
> that's coming in following patch.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/bpf-loader.c | 47 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index f8ad581ea247..2a2c9512c4e8 100644
> --- a/tools/perf/util/bpf-loader.c
> +++ b/tools/perf/util/bpf-loader.c
> @@ -86,6 +86,7 @@ bpf_perf_object__next(struct bpf_perf_object *prev)
>              (perf_obj) = (tmp), (tmp) = bpf_perf_object__next(tmp))
>
>  static bool libbpf_initialized;
> +static int libbpf_sec_handler;
>
>  static int bpf_perf_object__add(struct bpf_object *obj)
>  {
> @@ -99,12 +100,58 @@ static int bpf_perf_object__add(struct bpf_object *obj)
>         return perf_obj ? 0 : -ENOMEM;
>  }
>
> +static struct bpf_insn prologue_init_insn[] = {
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_MOV64_IMM(BPF_REG_1, 0),

R0 should be initialized before exit anyway. R1 contains context, so
doesn't need initialization, so I think you only need R2-R5?

> +       BPF_MOV64_IMM(BPF_REG_2, 0),
> +       BPF_MOV64_IMM(BPF_REG_3, 0),
> +       BPF_MOV64_IMM(BPF_REG_4, 0),
> +       BPF_MOV64_IMM(BPF_REG_5, 0),
> +};
> +
> +static int libbpf_prog_prepare_load_fn(struct bpf_program *prog,
> +                                      struct bpf_prog_load_opts *opts __maybe_unused,
> +                                      long cookie __maybe_unused)
> +{
> +       size_t init_size_cnt = ARRAY_SIZE(prologue_init_insn);
> +       size_t orig_insn_cnt, insn_cnt, init_size, orig_size;
> +       const struct bpf_insn *orig_insn;
> +       struct bpf_insn *insn;
> +
> +       /* prepend initialization code to program instructions */
> +       orig_insn = bpf_program__insns(prog);
> +       orig_insn_cnt = bpf_program__insn_cnt(prog);
> +       init_size = init_size_cnt * sizeof(*insn);
> +       orig_size = orig_insn_cnt * sizeof(*insn);
> +
> +       insn_cnt = orig_insn_cnt + init_size_cnt;
> +       insn = malloc(insn_cnt * sizeof(*insn));
> +       if (!insn)
> +               return -ENOMEM;
> +
> +       memcpy(insn, prologue_init_insn, init_size);
> +       memcpy((char *) insn + init_size, orig_insn, orig_size);
> +       bpf_program__set_insns(prog, insn, insn_cnt);
> +       return 0;
> +}
> +
>  static int libbpf_init(void)
>  {
> +       LIBBPF_OPTS(libbpf_prog_handler_opts, handler_opts,
> +               .prog_prepare_load_fn = libbpf_prog_prepare_load_fn,
> +       );
> +
>         if (libbpf_initialized)
>                 return 0;
>
>         libbpf_set_print(libbpf_perf_print);
> +       libbpf_sec_handler = libbpf_register_prog_handler(NULL, BPF_PROG_TYPE_KPROBE,
> +                                                         0, &handler_opts);
> +       if (libbpf_sec_handler < 0) {
> +               pr_debug("bpf: failed to register libbpf section handler: %d\n",
> +                        libbpf_sec_handler);
> +               return -BPF_LOADER_ERRNO__INTERNAL;
> +       }
>         libbpf_initialized = true;
>         return 0;
>  }
> --
> 2.35.3
>
