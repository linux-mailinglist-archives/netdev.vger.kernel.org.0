Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45C8508E57
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351561AbiDTRXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 13:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344045AbiDTRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 13:23:30 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C611533E3E;
        Wed, 20 Apr 2022 10:20:42 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id m14so2173051vsp.11;
        Wed, 20 Apr 2022 10:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vceL50BIp2v6AiSQ6YiQr6PR8WOQ5ol+sLtkOLau4XA=;
        b=dPSQHu6nx3iobsZSUWBFmXF4+kbgM/szfCsN6teKAmJ9FpHP0/BQhQ7vkzc+xC4nqd
         MlYf4fGWTY35ANgfJwFGNPL2LOBp1umldmad29D2CJ0hU0Mxls3ffBj/tXq7HqkEq6/B
         JKnor+MXg9+H+0s9wpmSgYrMl2w3+eijPyNKoEydWt9ON88mle7z56kT7U/ydH0cRWZq
         NWOYdeVdI8wJRc2PzplJ31uJGHcyViapKYwj22j/YU5QeaZC9gLRDGu4gDXoELQm8aPJ
         79wH0nGGRPIWA560g2smnsMVD4weZ/45UYENV/J0QkSL2DtXM7tjN0jxyEtXlz8eUnS1
         /f+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vceL50BIp2v6AiSQ6YiQr6PR8WOQ5ol+sLtkOLau4XA=;
        b=z+4bFm0zMTWbqHjqtPnJqzpwnd9ZNLLLD/SsghQyu9zNyvDRMb6SkSXUf933bUd37y
         haAi/mPn8uM2v1eKQswWSSywSutLU01lrAv1NVtMDaWXABTzlHuVXDh9iQ9dfHoM0Zet
         FH2mYY6SOkQRCqUIHiuigjv9xi8dZs4Epl7bJBFvVNtFbp8oyMeCDNM63MkFoDIR5XCY
         adzGawu1lTprfvMS51cCFzxY/dNf0BkqiFkP3IEzeygEa3tCrMrWmM+4bve7Gn9xTtFv
         +8FuqzUjPF898FhdXP4Q7n3b7rluoGBvJPITszW+MT2TsWDIfDAr3Dl2xoHBuyXQsXE8
         57gA==
X-Gm-Message-State: AOAM533OfAnNCcrEY1QeuTr67T+tYhM0rRVwV4kRbqrIYyEckUq3jg6x
        vtVBHhx6Dj+SkYyet7j8ivELF1ozqAbUXv82dmY=
X-Google-Smtp-Source: ABdhPJwa5MK25KXgiSTD0eO/ewqGUYce48kyJBJEdJott0E9+lLwDRk0RiatpUDoEtgOvwNXhLZUz4i9JP7/swbztEA=
X-Received: by 2002:a67:f693:0:b0:328:295b:3077 with SMTP id
 n19-20020a67f693000000b00328295b3077mr6552415vso.80.1650475241848; Wed, 20
 Apr 2022 10:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 10:20:31 -0700
Message-ID: <CAEf4Bza2H=vd+2nWV26UXBJCbMJkAVt2kggEj7Jxe8UVcs-qkw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/11] bpf: random unpopular userspace fixes (32
 bit et al.)
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

On Thu, Apr 14, 2022 at 3:44 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> This mostly issues the cross build (1) errors for 32 bit (2)
> MIPS (3) with minimal configuration (4) on Musl (5). The majority
> of them aren't yesterday's, so it is a "who does need it outside
> of x86_64 or ARM64?" moment again.
> Trivial stuff in general, not counting the bpf_cookie build fix.
>
> Alexander Lobakin (11):
>   bpf, perf: fix bpftool compilation with !CONFIG_PERF_EVENTS
>   bpf: always emit struct bpf_perf_link BTF
>   tools, bpf: fix bpftool build with !CONFIG_BPF_EVENTS
>   samples: bpf: add 'asm/mach-generic' include path for every MIPS
>   samples: bpf: use host bpftool to generate vmlinux.h, not target
>   tools, bpf: fix fcntl.h include in bpftool
>   samples: bpf: fix uin64_t format literals
>   samples: bpf: fix shifting unsigned long by 32 positions
>   samples: bpf: fix include order for non-Glibc environments
>   samples: bpf: fix -Wsequence-point
>   samples: bpf: xdpsock: fix -Wmaybe-uninitialized
>

For consistency with majority of other commits, can you please use
"samples/bpf: " prefix for samples/bpf changes and "bpftool: " for
bpftool's ones? Thanks!

>  include/linux/perf_event.h              |  2 ++
>  kernel/bpf/syscall.c                    |  4 +++-
>  samples/bpf/Makefile                    |  7 ++++---
>  samples/bpf/cookie_uid_helper_example.c | 12 ++++++------
>  samples/bpf/lathist_kern.c              |  2 +-
>  samples/bpf/lwt_len_hist_kern.c         |  2 +-
>  samples/bpf/lwt_len_hist_user.c         |  4 ++--
>  samples/bpf/task_fd_query_user.c        |  2 +-
>  samples/bpf/test_lru_dist.c             |  3 ++-
>  samples/bpf/tracex2_kern.c              |  2 +-
>  samples/bpf/xdpsock_user.c              |  5 +++--
>  tools/bpf/bpftool/tracelog.c            |  2 +-
>  12 files changed, 27 insertions(+), 20 deletions(-)
>
> --
> 2.35.2
>
>
