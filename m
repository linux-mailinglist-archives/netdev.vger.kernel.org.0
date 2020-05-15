Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527931D5A23
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgEOTko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEOTko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:40:44 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393E2C061A0C;
        Fri, 15 May 2020 12:40:43 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id d7so2975973qtn.11;
        Fri, 15 May 2020 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7ou8JV19REXcnpzqyrzp5r1aAUsTMKh8ZTeIZObEj0s=;
        b=FNPXlXtplV8T8Z7258sH/+oLdanFfWXAst/oYMZKUgpXJ3FdyB27CjJht3ztm13skK
         sR6WgVGY5yVrg5e+IhA0oA1uXmozEfkW6PLQ6Hm6t8kMJ14OPXXYW3rZkjAT5f6nXNrP
         Xpyt28LohTOz0yIn6u/MUdQnfldPWZ4mJ7ti9jkInxt/1YBwX5nZ0q3E4DmSfZEH8ixW
         MjXaGqXj/tUf1sbpVcgWQcbN2juSdyvCoVt3PqX4LpgbMbw5ojLSVd8pggE2s55xpAmb
         YYyHAOhpvBqcM6dzH3v3hLIWJKQ1nSaFq+flNT8RN+RmBxibdno9fm3iJqEJ4hoBZQ0o
         xjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7ou8JV19REXcnpzqyrzp5r1aAUsTMKh8ZTeIZObEj0s=;
        b=Qwho5HUXtxA6QRjPmIfkANaji/dXbPXLObRHpNWpg+LmTPY/nIQjgiz6O8DAC7Gjev
         8w/PBg7jb9AfgFKF20+d+tl5LNUPZLYaMxMQWK1xSjcXcRZInpqLsVWt2kP/VI8JDInt
         /jiORA0IUbm08QaI+XgwjbEo/bQ3rpq3ccfdSLwXU5XBOYxFSzpkpnSewWpGRg2KkYC+
         nuDG1Pk3QNmIRq4mPrZZ6PbaEXJxCsHyJRvDShsIJaDCpyv+QsA5HEajbf0cHkt9KU3u
         lkA0lxvP7YTboR5ymn1l2zJr2WoMTVYZBLMSoGQDuhjmJGTxOvdpzPpzX3MX+jvq8R9V
         oFuw==
X-Gm-Message-State: AOAM5323RVWpWgNI3dWSVkPjwWIvx2jNEnJuKUCbhz2Qnh5foGUEGUXx
        s4JY4aeZYenPJxpZP8W7KdSxFmdOoMjVsGV7VrA=
X-Google-Smtp-Source: ABdhPJxRxWp+3bmI47j+jDQ2Qkqcfissm4Juxx3AGQUgOCmN6uO7SGAF+3h7z8BWeQjCp/2Ju0fFfvvMdhhTkjVpdSQ=
X-Received: by 2002:ac8:1ae7:: with SMTP id h36mr5217245qtk.59.1589571642463;
 Fri, 15 May 2020 12:40:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515165007.217120-4-irogers@google.com>
In-Reply-To: <20200515165007.217120-4-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 May 2020 12:40:31 -0700
Message-ID: <CAEf4BzbASksH9Ne7GVcdMSZRB_7nVwsr1Y4V66PfiCiK-fzQvg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] libbpf hashmap: Fix signedness warnings
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 9:51 AM Ian Rogers <irogers@google.com> wrote:
>
> Fixes the following warnings:
>
> hashmap.c: In function =E2=80=98hashmap__clear=E2=80=99:
> hashmap.h:150:20: error: comparison of integer expressions of different s=
ignedness: =E2=80=98int=E2=80=99 and =E2=80=98size_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Werror=3Dsign-compare]
>   150 |  for (bkt =3D 0; bkt < map->cap; bkt++)        \
>
> hashmap.c: In function =E2=80=98hashmap_grow=E2=80=99:
> hashmap.h:150:20: error: comparison of integer expressions of different s=
ignedness: =E2=80=98int=E2=80=99 and =E2=80=98size_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Werror=3Dsign-compare]
>   150 |  for (bkt =3D 0; bkt < map->cap; bkt++)        \
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/hashmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
> index cffb96202e0d..a405dad068f5 100644
> --- a/tools/lib/bpf/hashmap.c
> +++ b/tools/lib/bpf/hashmap.c
> @@ -60,7 +60,7 @@ struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
>  void hashmap__clear(struct hashmap *map)
>  {
>         struct hashmap_entry *cur, *tmp;
> -       int bkt;
> +       size_t bkt;
>
>         hashmap__for_each_entry_safe(map, cur, tmp, bkt) {
>                 free(cur);
> @@ -100,8 +100,7 @@ static int hashmap_grow(struct hashmap *map)
>         struct hashmap_entry **new_buckets;
>         struct hashmap_entry *cur, *tmp;
>         size_t new_cap_bits, new_cap;
> -       size_t h;
> -       int bkt;
> +       size_t h, bkt;
>
>         new_cap_bits =3D map->cap_bits + 1;
>         if (new_cap_bits < HASHMAP_MIN_CAP_BITS)
> --
> 2.26.2.761.g0e0b3e54be-goog
>
