Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B960350F16D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbiDZGso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343513AbiDZGsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:48:40 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99F8186FD;
        Mon, 25 Apr 2022 23:45:32 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id c125so18340370iof.9;
        Mon, 25 Apr 2022 23:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fUYbd0odstCs+XiFoMaHpPv/Lzph2nClBQiUgMUBiOQ=;
        b=ORrk68RJd/KyYS1gcrBo3WoXUOl1eP4ZWF9Z6ihMZ5DNTBrIEPEErwJ1MEMk+Vo84R
         RevQ/4Z2ofWIlQn42G7/UZ7YSLcqtXGsp7epU3zPOb2C1eqGRLmCB4zvNszXC+gYoM5L
         hxwoL6cQ3NNeHrdi9ABqisrzznsqt1yQ8qnwvCSkVmLOOVh9Hf/yAu4V4jA/DNVVW8N5
         iFmqaEo2Dyh7VWb2msCToH9WeAs9TBmFiUYAgDsXMBFTL7VlR8lLXUHBttqlea2y+dog
         dpDUtodWpIrWL2dvKpgHJy2rOoOQS4/Bwo6Hq8j+dIOeyaH0xCuejCiQTX4Lj6NK0sng
         9hhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fUYbd0odstCs+XiFoMaHpPv/Lzph2nClBQiUgMUBiOQ=;
        b=VTSiq5AbPYNu/zuZuweXgze6MIK7NkG3OXB+8+zqbf+JEK3CFYwHOR6Ag3A1Ky11SC
         YuhD767ZzjdBMbKylvAtQoy49Gf50UyQuseTG/LCGelCwNElVaXsB3jRqiZr+MrdtKPi
         7GFIITo7esvEZMw6Brp8+dkx+AVgWtQBlevI9kcP2cbaWYu+xBRwylLL3q2VbVJpzlqn
         g2KmqW3nSmxcvqki20DFhDi95zVJbGxspIWBtjemkHs0V8cnRyBkQxmoWlIacAxMhJhL
         lQtdiFo1msgVKQSBgwAlEzKMDr2YEfhYhNMFzPm4EvmNQuEX2Q+8zS7eYxLIjorNhdi8
         RfaA==
X-Gm-Message-State: AOAM532S5cXV/UrRJg+B6bvMRQG/9AQmvr2lW+Q0DEbGqQ3K7HiHYnOQ
        Tk16WAGFqSJS0IH43IP6IPFQxOmzZYw0kUhOd6ZnL31o
X-Google-Smtp-Source: ABdhPJzysE88krKvwikXRboer8fD0V8kHiurMRV/MMpH9cBeDtTAvVorWjalzHLbU5/L0zsQjZA98mcxfzqK8tbEG80=
X-Received: by 2002:a05:6638:3393:b0:32a:93cd:7e48 with SMTP id
 h19-20020a056638339300b0032a93cd7e48mr9259336jav.93.1650955532240; Mon, 25
 Apr 2022 23:45:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com>
In-Reply-To: <20220423140058.54414-1-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:45:21 -0700
Message-ID: <CAEf4BzbhODOBrE=unLOUpo40uUYz72BJX-+uJobiwhF9VFSizQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] bpf: Generate helpers for pinning through
 bpf object skeleton
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sat, Apr 23, 2022 at 7:01 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Currently there're helpers for allowing to open/load/attach BPF object
> through BPF object skeleton. Let's also add helpers for pinning through
> BPF object skeleton. It could simplify BPF userspace code which wants to
> pin the progs into bpffs.
>
> After this change, with command 'bpftool gen skeleton XXX.bpf.o', the
> helpers for pinning BPF prog will be generated in BPF object skeleton.
>
> The new helpers are named with __{pin, unpin}_prog, because it only pins
> bpf progs. If the user also wants to pin bpf maps, he can use
> LIBBPF_PIN_BY_NAME.

API says it's pinning programs, but really it's trying to pin links.
But those links might not even be created for non-auto-attachable
programs, and for others users might or might not set
<skel>.links.<prog_name> links.

There are lots of questions about this new functionality... But the
main one is why do we need it? What does it bring that's hard to do
otherwise?

>
> Yafang Shao (4):
>   libbpf: Define DEFAULT_BPFFS
>   libbpf: Add helpers for pinning bpf prog through bpf object skeleton
>   bpftool: Fix incorrect return in generated detach helper
>   bpftool: Generate helpers for pinning prog through bpf object skeleton
>
>  tools/bpf/bpftool/gen.c     | 18 ++++++++++-
>  tools/lib/bpf/bpf_helpers.h |  2 +-
>  tools/lib/bpf/libbpf.c      | 61 ++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h      | 10 ++++--
>  tools/lib/bpf/libbpf.map    |  2 ++
>  5 files changed, 88 insertions(+), 5 deletions(-)
>
> --
> 2.17.1
>
