Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8D55D294
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiF0RSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238961AbiF0RSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:18:09 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62056136
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:18:07 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b26so1627010wrc.2
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rx9f3FFpQHBCbk0ON6Xh6VW45WNeEZB24W/hAUNIOhc=;
        b=G+D6o8B0JVucQW6+PhCQ5L2XRwfWedIWe5iLwmsIKnP8l2kIPE3ln4/ME0/NvRV+UI
         IRq3HZNljewherNlCxkZNHbPRyhOKbLAJsPLf/122Lc0zDeUZ3DSYptMKEcEzzE5M49v
         K7z5/G6X58efTmpm/XecTLJdA7JzogWXZL37jfBfaiP12a4vZimKbpMNVbZqbhlrQndn
         amVSil4XRxHxN3Czg+9XDVPJzWWjWA1lGbD0M6Gf9a4KCdlQI4edBbYRGLimeSp7uaaN
         pvrRhrhKcOF/RRlK5ucxsSdCE8jF8RFh7BplqDvHDLsP9MUYF1Emg8N/f0LtedmrcKxn
         UcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rx9f3FFpQHBCbk0ON6Xh6VW45WNeEZB24W/hAUNIOhc=;
        b=pZipCK2075jVnbTMZH1t9TdIDy9yhizrf9SEoCmWKpXeJ6zv4dNclrqjWhFGmtw+do
         20nuWhNg+TUecBgADhnFEMBOz85mDB/4UDXLQ23/MCF9rOIpwNigifAvLYcqo4kDw2Iv
         lmQ9hV46xRXbpWSITfe4AyH/K5YAvgU8bJT02cFz/vP+aPsrTR1dNshFGX4aba3fiwNW
         PBgnrw/VVINc9oc5+QrsZG+hT43VICbhhCZtwf2nD96y3Q1k6LB8/9psPAPRfZLslAp/
         brzarTm9JXATpQ6z1VSSRCWTeHncO/1YefMi9KcbFCcv1CLmLG1AyzEeq8TJ5LyCZ0SS
         hfCA==
X-Gm-Message-State: AJIora+/MMqAdXONKVvrbWR3pk7co5RowciutPa6S++DQ1fekmCliSlp
        8GiK0CSYjU4nbPb6QohzRylVq6Ta8vIZCY2VjbEleA==
X-Google-Smtp-Source: AGRyM1vXlEJ2cJEQvlLdrnPihXwK9o/E1cIAWChD1xuv8agkjMs9iJuTfwntYyHAZfhGP9MzEdXOJwWhE277bB/fsJI=
X-Received: by 2002:a5d:6b91:0:b0:21b:bc0b:7282 with SMTP id
 n17-20020a5d6b91000000b0021bbc0b7282mr13477019wrx.375.1656350285740; Mon, 27
 Jun 2022 10:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220614014714.1407239-1-irogers@google.com>
In-Reply-To: <20220614014714.1407239-1-irogers@google.com>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 27 Jun 2022 10:17:51 -0700
Message-ID: <CAP-5=fVg9ZVOONuiJZopC7RyuEXvP8t79EFjQF0GCcV=atGbCg@mail.gmail.com>
Subject: Re: [PATCH] perf bpf: 8 byte align bpil data
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Happy Monday, polite ping!

Thanks,
Ian

> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
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
