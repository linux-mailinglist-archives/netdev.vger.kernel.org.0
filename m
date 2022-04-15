Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE545032EB
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiDOXhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiDOXhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:37:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3605940E59;
        Fri, 15 Apr 2022 16:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDB69B82CE7;
        Fri, 15 Apr 2022 23:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF28C385A8;
        Fri, 15 Apr 2022 23:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650065686;
        bh=H8TG9TaTkxthyp0a78kt3dMEbKUO8m3PltS7yJt03Lk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gIDIFML52510OKuQReILMZhX3fFpruAsOz8I2y/UUWSS/XA9np+igAuQ9J71VVmaI
         yc8pvY+JCT6UUVSGrSR28Ayfzg/8ReygDBjTJSLAShxwB5Q1Qo9/MOMFj3FAGgFIFR
         b+quTWnBobJaTM9heJhVac+VBoK7X8aOPkPesZjtk8Sw8CgLhMwjtdcnPb2R0zdM+R
         b0IRTjA8BaIlnt3lHEL4f2tkElrFZItoG10MxYNsonfzToHNWoxA30Y2vSy9nx+Wsv
         Spv7lDZszmOJuMuhvCckvgwOwqBC0cMLNzx3iUNLR2OxRTtmfNwJJFOnS20TCvMtzG
         A0718dSkj3OuA==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2ebf4b91212so95347557b3.8;
        Fri, 15 Apr 2022 16:34:46 -0700 (PDT)
X-Gm-Message-State: AOAM533UrQlHQSa+Mhg0xgFELEHrKjqqmCWoghMhVlH/knn2FAWhiuBE
        chXG7QpxApc4ACMRS4jIvSh6RtzQ2blyiRGoRHI=
X-Google-Smtp-Source: ABdhPJzFi4avB4LXxfU1+vAL7RiFsHM0NYSgX5xmyngsW8isXQE/FvZ8UGsTCkZUMTOvj9iYRuUPlvo38P1Pwkh32Ek=
X-Received: by 2002:a81:688:0:b0:2ec:239:d1e with SMTP id 130-20020a810688000000b002ec02390d1emr1124694ywg.211.1650065685677;
 Fri, 15 Apr 2022 16:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-4-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-4-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:34:34 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6_9nq6wesTwDbpV50euq=ubqdLdfVkc9-pNOnGevXs1Q@mail.gmail.com>
Message-ID: <CAPhsuW6_9nq6wesTwDbpV50euq=ubqdLdfVkc9-pNOnGevXs1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/11] tools, bpf: fix bpftool build with !CONFIG_BPF_EVENTS
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 3:45 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Fix the following error when building bpftool:
>
>   CLANG   profiler.bpf.o
>   CLANG   pid_iter.bpf.o
> skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof' to an incomplete type 'struct bpf_perf_event_value'
>         __uint(value_size, sizeof(struct bpf_perf_event_value));
>                            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:13:39: note: expanded from macro '__uint'
>                                       ^~~
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helper_defs.h:7:8: note: forward declaration of 'struct bpf_perf_event_value'
> struct bpf_perf_event_value;
>        ^
>
> struct bpf_perf_event_value is being used in the kernel only when
> CONFIG_BPF_EVENTS is enabled, so it misses a BTF entry then.
> Emit the type unconditionally to fix the problem.
>
> Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/syscall.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 34fdf27d14cf..dd8284a60a8e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -4286,6 +4286,7 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
>                 goto out;
>         case BPF_PROG_TYPE_PERF_EVENT:
>         case BPF_PROG_TYPE_TRACEPOINT:
> +               BTF_TYPE_EMIT(struct bpf_perf_event_value);
>                 if (attr->link_create.attach_type != BPF_PERF_EVENT) {
>                         ret = -EINVAL;
>                         goto out;
> --
> 2.35.2
>
>
