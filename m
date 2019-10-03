Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C422CAFC7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388240AbfJCUJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:09:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46812 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388017AbfJCUJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:09:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id u22so5347739qtq.13;
        Thu, 03 Oct 2019 13:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uo5Jpuwo4a0O/oE0zrf1a6d6W/WndGuFaEwLi1b3LiY=;
        b=PrWv7SHym0F+S6oqEQGQ0MJNpZjOB+HiqcRywLF/+2F8pkOHpO6ruapzCbvKIfhZhK
         LVmvUr6lc3ZB0hNbL+mWC0jsTzvbX3A1W4imqyIItpj4sHqzgRlxFiiojact3fxieJ1R
         V/FBezlYOXHppSSPZWhOR+1/F+vMD1G2KTVkZxksFqEVc81EF+QiiuImApySs3tts/GY
         RTC2G4gxOacCgXR3xA5lyfg8MMsPRBSoWT5tKGaCqAZ41xKuP6+3NN+jm1oC4HMbLZCW
         +epZqUAjz6xynNxj4F6nWE5H+IIDBm3NVlJdww2u/XYK181DyU2QPAxYzPxSUDWYsC9y
         9D4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uo5Jpuwo4a0O/oE0zrf1a6d6W/WndGuFaEwLi1b3LiY=;
        b=bo+VqCoPR0pFtsUg8wnOWYHQvit+pH9Gt9+vLdOxT2VolcmcHFwlorSIormcKC0a+j
         fLw8LGiD2RWMa0iklrXlA99fygv0x+8kRzyuTt6/gxkbxP66k+iDPyUiHJOuG+1sQjtN
         OOOR+5rN3LaQhvm6S41jhrnz20D+X6wuqhxdTSmLUT0y4YOa8BgI+u0syHibbvdQoofO
         Pcpdpl/s18KKyXiROMFk94s4Ei2dmI8tUJKo0x28QxfLHxOaX8e75hz9MJ9kgWS0Urh+
         rEf27TA+E0yHsqgCvtoV7YTd7EaKElLvSr7bd5N+lV/9V77Hv03MTeV+s6ZTueqq82m5
         CZew==
X-Gm-Message-State: APjAAAVU6QqP6sMZI61F6pUpwZp4+F6ECCjYoXag0uO74+dgxKefSMu2
        N1YVnc6hst7GrbPI85EAaP52Z8/p/nGd9zJJNEU=
X-Google-Smtp-Source: APXvYqyaNdjYUeNXh651/c/qV51C4icJrFC0RG4R8fA+sY26CDhF+pKdV/d0IujtnUr3JfXzKO0tk7GURnirdhII7m4=
X-Received: by 2002:a0c:9846:: with SMTP id e6mr10245330qvd.114.1570133341806;
 Thu, 03 Oct 2019 13:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-3-andriin@fb.com>
In-Reply-To: <20191002215041.1083058-3-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:08:50 -0700
Message-ID: <CAPhsuW4pS_P0n+UCB40uSVKp6W0N4Xas4UT9oofLxSZjhmyeGw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/7] selftests/bpf: samples/bpf: split off
 legacy stuff from bpf_helpers.h
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 3:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Split off few legacy things from bpf_helpers.h into separate
> bpf_legacy.h file:
> - load_{byte|half|word};
> - remove extra inner_idx and numa_node fields from bpf_map_def and
>   introduce bpf_map_def_legacy for use in samples;
> - move BPF_ANNOTATE_KV_PAIR into bpf_legacy.h.
>
> Adjust samples and selftests accordingly by either including
> bpf_legacy.h and using bpf_map_def_legacy, or switching to BTF-defined
> maps altogether.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

with a nit below

> ---
>  samples/bpf/hbm_kern.h                        | 28 +++++++------
>  samples/bpf/map_perf_test_kern.c              | 23 +++++------
>  samples/bpf/parse_ldabs.c                     |  1 +
>  samples/bpf/sockex1_kern.c                    |  1 +
>  samples/bpf/sockex2_kern.c                    |  1 +
>  samples/bpf/sockex3_kern.c                    |  1 +
>  samples/bpf/tcbpf1_kern.c                     |  1 +
>  samples/bpf/test_map_in_map_kern.c            | 15 +++----
>  tools/testing/selftests/bpf/bpf_helpers.h     | 24 +-----------
>  tools/testing/selftests/bpf/bpf_legacy.h      | 39 +++++++++++++++++++
>  .../testing/selftests/bpf/progs/sockopt_sk.c  | 13 +++----
>  tools/testing/selftests/bpf/progs/tcp_rtt.c   | 13 +++----
>  .../selftests/bpf/progs/test_btf_haskv.c      |  1 +
>  .../selftests/bpf/progs/test_btf_newkv.c      |  1 +
>  14 files changed, 92 insertions(+), 70 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/bpf_legacy.h
>
> diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
> index aa207a2eebbd..91880a0e9c2f 100644
> --- a/samples/bpf/hbm_kern.h
> +++ b/samples/bpf/hbm_kern.h
> @@ -24,6 +24,7 @@
>  #include <net/inet_ecn.h>
>  #include "bpf_endian.h"
>  #include "bpf_helpers.h"
> +#include "bpf_legacy.h"

nit: I guess we don't need bpf_legacy.h here?
