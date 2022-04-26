Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A23850F0E5
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245078AbiDZG0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbiDZG0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:26:12 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F481229E3;
        Mon, 25 Apr 2022 23:23:05 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g21so18282929iom.13;
        Mon, 25 Apr 2022 23:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LqVkyBIhzhNpiRN/LGuBXZr8SW/fdepd0hhgilnDnss=;
        b=EvdE9fuftx7AR+GnsJwkucmF6PupS/0lpHf8VFilrthJvUcvR8507LZX6xzTIywxGh
         ecgTac3ni12FBpL5SQJeSXzQZiTxvjIE51APnyhRhAnwqUvvbnc6UhIU4N6YnZ2SEP46
         8Y5FxY6NLwZUQ4WI/7r7kYcONl789pWu4g5gtM+BVQy0itGU1Bj2GoxpKRHXg3ovyYK8
         a2eu7g3UZiJBsFmbPkqNtuB8rEHbhSUUYUQ+wkXG6UGxaKHwD6CfZcjWjING3GdlY+sW
         nh7BEoJq5z/eWLb+Zqt4+JZrM91hfwTxOL+iz5xg8wDrPZu9XV216x90Hkd3mkB6ItXO
         OhHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LqVkyBIhzhNpiRN/LGuBXZr8SW/fdepd0hhgilnDnss=;
        b=nCrQdMOOEqBPewB3TV+7+2J91BHcUrZPOkCUVzfcSFkLJJV4FTiOMcUH5cBnFMXO+G
         xfjsQzscNyLEVzHMWBmQkUpaa599pyN5wkc552OwZEVDSWDTzPe92QYxClWiO7QZ151A
         gvPsJ+0QcQemNXnvMISrCAB5URLJ+o+bnUkwbudl3EEv7l8t6ss0bJ+xC+LCHveYEPU7
         JMK+4RA6XOSsDCrcx2wUovDki+/P9+1aPe0UMn6NOzB+TQ7OO/gkPhy0owdeVSPDRjGO
         28EaV3ArzT8j6GnOusMLppgYjMroagc2g9ysy3lt9SHV5WO5rnudvDypE3umOK9977UM
         cHBQ==
X-Gm-Message-State: AOAM530cg5CmSQ96jtcfcQT9kbUODgVo2ugl4OmD9E68ridBJ+iMEREx
        lpcUuRZHlb7BQ2pbjGpraO6KBqHrLch4vUZlTyU=
X-Google-Smtp-Source: ABdhPJxQKC56jm4swRm708aaucl5EVjTQMEQqgnuwDr7H5d68yD2HZghCZ+5tWse+CQwF4OBTi/rimJa+/CHtskzdl0=
X-Received: by 2002:a6b:4e09:0:b0:653:d046:b8cd with SMTP id
 c9-20020a6b4e09000000b00653d046b8cdmr8477977iob.112.1650954185410; Mon, 25
 Apr 2022 23:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220422100025.1469207-1-jolsa@kernel.org> <20220422100025.1469207-5-jolsa@kernel.org>
In-Reply-To: <20220422100025.1469207-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:22:54 -0700
Message-ID: <CAEf4BzaGLRYiQtT4_HV1ntAV0Br2yyRo5sZiebVAt9QJ8WVF5g@mail.gmail.com>
Subject: Re: [PATCH perf/core 4/5] perf tools: Register perfkprobe libbpf
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 3:01 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Perf is using section name to declare special kprobe arguments,
> which no longer works with current libbpf, that either requires
> certain form of the section name or allows to register custom
> handler.
>
> Adding support for 'perfkprobe/' section name handler to take
> care of perf kprobe programs.
>
> The handler servers two purposes:
>   - allows perf programs to have special arguments in section name
>   - allows perf to use pre-load callback where we can attach init
>     code (zeroing all argument registers) to each perf program
>
> The second is essential part of new prologue generation code,
> that's coming in following patch.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/bpf-loader.c | 50 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index f8ad581ea247..92dd8cc18edb 100644
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
> @@ -99,12 +100,61 @@ static int bpf_perf_object__add(struct bpf_object *obj)
>         return perf_obj ? 0 : -ENOMEM;
>  }
>
> +static struct bpf_insn prologue_init_insn[] = {
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_MOV64_IMM(BPF_REG_1, 0),
> +       BPF_MOV64_IMM(BPF_REG_2, 0),
> +       BPF_MOV64_IMM(BPF_REG_3, 0),
> +       BPF_MOV64_IMM(BPF_REG_4, 0),
> +       BPF_MOV64_IMM(BPF_REG_5, 0),
> +};
> +
> +#define LIBBPF_SEC_PREFIX "perfkprobe/"

libbpf allows to register fallback handler that will handle any SEC()
definition besides the ones that libbpf handles. Would that work in
this case instead of adding a custom prefix handler here? See
prog_tests/custom_sec_handlers.c for example:

fallback_id = libbpf_register_prog_handler(NULL,
BPF_PROG_TYPE_SYSCALL, 0, &opts);

> +

[...]
