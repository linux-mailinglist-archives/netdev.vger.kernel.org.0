Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B355CB83
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbiF0U43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 16:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiF0U42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 16:56:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9132ACD;
        Mon, 27 Jun 2022 13:56:27 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id o9so14764561edt.12;
        Mon, 27 Jun 2022 13:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZYxoCPScWXjQwHFlcANYHGk3bPGNCdA16fhomtXzig=;
        b=faGaQLRpG+IQROqdEzZ4ky3l7Le5IQ+LCAxS/3EHNHKYbddYRQ9XgwIwUqXyWa3R2K
         Zl6dEtw1+qLg8qaj14p++CQBTiPXbQFX8kzaUqFaWxmT1ak2rJ6i7xftxkpORqvkP/+x
         ccjiGREgPQf8W3l5Lr0OAHGgduHe27M1Vci6ciP58d3lb1CFdaoMSD1pD87RAVakxh5E
         5pWp45VYYC5N/3vNHhlilp8dSWi9HiWRKq29g9MTVNzr9JtRzgOIPYN/FMZvwFl8L+wM
         zgGMimUBRZDUUEM7JpeMhGXki8/I86b8N/SZHlA0nJASY6kbTRkBMTtF/cLDwyQbiJux
         z+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZYxoCPScWXjQwHFlcANYHGk3bPGNCdA16fhomtXzig=;
        b=ku/CSB3eyq2p0/9Z6lOn1A74G4iKYIr5fMr7cYTgK/x371HmP4ZsjnTBU6uKmAm2Ee
         jII5sd5+qw8h+uppYkGoD0VE3iZXR1e7uXEVY5KThdnEHY8qLL+HyOGM2JNrG38puA2e
         jIlbmeR7Gp1ZRYqQ44dRAQx7+Pi1smk16lgCfUBG144NZoMGAgSYkDWCucIfwqTwGYQe
         aKeuNmQO/Fhee0hQc3K8c5xr5PaBbbIrC7DOOJRV5fyfKqBY1dan936MmL6rqvTbck8L
         rqL6f9/Hx7155K+5RoeFVuI+O+tser0u8hj7vIl8VqJinhhXDeIUM013P0KgN3TuGu2T
         xlfg==
X-Gm-Message-State: AJIora80sbXaUQ96xkuEfKgH/Bn6RMJKNHXr3yGwbUrTeY0rQp12/G0L
        DcjtP6kISBE+1/rkqp06y05e3VQtUcF1VJ4z1eg=
X-Google-Smtp-Source: AGRyM1vSFR/5VfuUx99F/9e3fpf5w79op2GZg/nz3Tn8dAZhwJQByxpaIv+hq3rUNAk1YwfppxULTZUS/fan6EOKfTk=
X-Received: by 2002:a05:6402:3514:b0:435:f24a:fbad with SMTP id
 b20-20020a056402351400b00435f24afbadmr18301496edd.311.1656363385709; Mon, 27
 Jun 2022 13:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220614014714.1407239-1-irogers@google.com>
In-Reply-To: <20220614014714.1407239-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jun 2022 13:56:13 -0700
Message-ID: <CAEf4BzYXQULPgC_qP-O9F6yo9ohKfDRWChDAOsqYX8bWYuv5ng@mail.gmail.com>
Subject: Re: [PATCH] perf bpf: 8 byte align bpil data
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
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

On Mon, Jun 13, 2022 at 6:47 PM Ian Rogers <irogers@google.com> wrote:
>
> bpil data is accessed assuming 64-bit alignment resulting in undefined
> behavior as the data is just byte aligned. With an -fsanitize=undefined
> build the following errors are observed:
>
> $ sudo perf record -a sleep 1
> util/bpf-event.c:310:22: runtime error: load of misaligned address 0x55f61084520f for type '__u64', which requires 8 byte alignment
> 0x55f61084520f: note: pointer points here
>  a8 fe ff ff 3c  51 d3 c0 ff ff ff ff 04  84 d3 c0 ff ff ff ff d8  aa d3 c0 ff ff ff ff a4  c0 d3 c0
>              ^
> util/bpf-event.c:311:20: runtime error: load of misaligned address 0x55f61084522f for type '__u32', which requires 4 byte alignment
> 0x55f61084522f: note: pointer points here
>  ff ff ff ff c7  17 00 00 f1 02 00 00 1f  04 00 00 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00
>              ^
> util/bpf-event.c:198:33: runtime error: member access within misaligned address 0x55f61084523f for type 'const struct bpf_func_info', which requires 4 byte alignment
> 0x55f61084523f: note: pointer points here
>  58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00 3b 00 00 00 ab  02 00 00 44 00 00 00 14  03 00 00
>
> Correct this by rouding up the data sizes and aligning the pointers.

typo: rounding

>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Makes sense.

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  tools/perf/util/bpf-utils.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/bpf-utils.c b/tools/perf/util/bpf-utils.c
> index e271e05e51bc..80b1d2b3729b 100644
> --- a/tools/perf/util/bpf-utils.c
> +++ b/tools/perf/util/bpf-utils.c
> @@ -149,11 +149,10 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
>                 count = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
>                 size  = bpf_prog_info_read_offset_u32(&info, desc->size_offset);
>
> -               data_len += count * size;
> +               data_len += roundup(count * size, sizeof(__u64));
>         }
>
>         /* step 3: allocate continuous memory */
> -       data_len = roundup(data_len, sizeof(__u64));
>         info_linear = malloc(sizeof(struct perf_bpil) + data_len);
>         if (!info_linear)
>                 return ERR_PTR(-ENOMEM);
> @@ -180,7 +179,7 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
>                 bpf_prog_info_set_offset_u64(&info_linear->info,
>                                              desc->array_offset,
>                                              ptr_to_u64(ptr));
> -               ptr += count * size;
> +               ptr += roundup(count * size, sizeof(__u64));
>         }
>
>         /* step 5: call syscall again to get required arrays */
> --
> 2.36.1.476.g0c4daa206d-goog
>
