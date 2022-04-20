Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3BD508E1C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 19:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380938AbiDTRPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 13:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380918AbiDTRPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 13:15:00 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F0E4578A;
        Wed, 20 Apr 2022 10:12:13 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id j4so1097916vki.8;
        Wed, 20 Apr 2022 10:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pYT8LiXPjG72JXyjXh0PA/0j6snOgjAInfuhdQQzK4A=;
        b=ZiyMakZPe2qW167OmeXyl2TuWZG/d54+3LqcHKYeCbiytsFzupldZcNEbtc3woraMi
         WuZQ+m7C4d9rEtCo8dS0y+0oipuQi3dRdUE78C8HHIGJOduFOGUFCTxyH/J+xxMObUeo
         3fx2WciP5/4tsVV5rAi1F2Rjh5wBollI5V+EK2kAG90dGELPOYf3oi7PG7tVGwYw9Oqs
         38Jjf6kXP8UYlQkmvWHW62Hj8xWG/XVyj/kAmay4gjQ4liV5GP258qHLLDahX87U4Zce
         TRodUG0FEsekwpItF7t9i66GVhDI7kAzoaTbxbuxVpnEzRABk4BlKz0aQ1H7VVD+nloQ
         4k0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pYT8LiXPjG72JXyjXh0PA/0j6snOgjAInfuhdQQzK4A=;
        b=PcaOulyZDpfPeuCc4tNbK28k45lRdo0dRQzBXGotTiqvMnzfw983G1iIun8UG9pRZv
         3Y0ZHIrSLwtGEry5YLQj/bQXnruGC9ZEECmnkaS4ls8/mh61vma3rE7VOdzBOosiB9ts
         pkIt8RpfpgQL0wPzDhO5Fp/HvqZPWJ0eUWN1wWXpBuBEH8+pf3OhNxtKCZ3TKCabaNBH
         IE896RFVkfNe2KvvWFnyQ3dlRZn52VimRBbORjYwjquSme9mJPqL0HiLjoEPjOZYQ2Mf
         ejq6JtC8X5wMvtjsBVCaKnB9HqFnQkbVZjIwtA0MhskMzA0/WNH2tm+nzzGI2XGrRYDp
         yPbw==
X-Gm-Message-State: AOAM532A6QbIluQTjvo5y2gJc6ton/biNuFYMi/XI0wexHQtJwyDHTaK
        PAv+Bikdsi1cfwJg54GEmlIPHdi17pH6uw7QDM8=
X-Google-Smtp-Source: ABdhPJxnS1xt53URfkC+Hi8iynVsfEwenj/2vAUetV4O4xWYXcnniqZonwmQezQoWp3xT03XpQs1W0FscQZQVDNUGLE=
X-Received: by 2002:a1f:abc5:0:b0:343:20e4:890f with SMTP id
 u188-20020a1fabc5000000b0034320e4890fmr6765514vke.20.1650474732358; Wed, 20
 Apr 2022 10:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-4-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-4-alobakin@pm.me>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 10:12:01 -0700
Message-ID: <CAEf4BzZiuD+bJ2zMikrb_W6KUHWjEqu6jwp5cNEgaHdSgRhUtA@mail.gmail.com>
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
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
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

same as for previous two patches, if there are types that bpftool
expects and might not be in vmlinux.h due to different kernel
configurations, it's cleaner to just define their minimal local
definitions with __attribute__((preserve_access_index))

>                 if (attr->link_create.attach_type != BPF_PERF_EVENT) {
>                         ret = -EINVAL;
>                         goto out;
> --
> 2.35.2
>
>
