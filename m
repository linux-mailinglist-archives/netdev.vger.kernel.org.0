Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5F52192EB
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgGHV4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHV4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:56:02 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EEDC061A0B;
        Wed,  8 Jul 2020 14:56:01 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id ed14so60382qvb.2;
        Wed, 08 Jul 2020 14:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7O5VagG2AewCrkpK9SMpTigVOJGwjJDU9ZCind3bOZY=;
        b=dX/HRH8lGDtiuEUwwQcPIB6Rmp/9hPAxbL0QYrRNCh6Eqp1LDjrDX5gOCd4bIqt9M1
         UDFACw6mrIVAHw0JCDeS1oxy1kKTkRpi7jITFmUcLK2Q8tDZ1oP9l7JSgzoQ81XCpSrZ
         BoBLH8eko/OoiKxjFBUHGxm2DdGqpNVIf4lKBFPZ03Ik1D9DR2RW089tY9C4kuIvo0Cb
         PLGbsYluvaJX0pG4bgW0ocikXHpxCBcDJmTKWEIN6YrBmvqpJcqxYGCT/HbdaokuD4ss
         wUeJmGvHlsByzWxDyEixF7AYcFHLIB8Px69+GM+YwnL+ufmd75i5TXknaEaGrAjPVizl
         8rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7O5VagG2AewCrkpK9SMpTigVOJGwjJDU9ZCind3bOZY=;
        b=W8iAgbW9h2YKt2n0s7jqkxU09KZi28mqRd2mr4qlG6WhP2DuLl5aAnG4V8oDLkcSFx
         SVspV3vX0bIhWWWgVtpg8+SOS7KpHpA5YafYofTJLQwpr408GF3uvV/0kvzGZm+sD/S9
         r0IV8QBjrF8B5n+zArybNqyQ42tow1sH1wzCf6J7z8hrndnuJQaEQskkJeiIx4Kfbzgb
         bjMxfheOC0E8YZHui5Xa7/ECP/Gd/vXB2dCuATMnUZaj5Cu9Nn5SI89dGhnLORzcNrH5
         XSdXsapr/uH8PD4Zm2lhStF8FzQQadvGA7LvDRRUL/obZZEDiC0bL7p3Jj0YGtC3TJx3
         OV/Q==
X-Gm-Message-State: AOAM530zXKYw8Y5VZGZO8HXo+2tEh7IDPw+jCKgcktgYwPBq+HiVSqIY
        Zm+XkdI6s+f7AuhJsWWcCKAJdVIu2q/+Jgtu3GM=
X-Google-Smtp-Source: ABdhPJw/d+8nsahqn0k5Lz5akcXmd5Qp6ML0LT/JIo4ucIXeBVVHslifRz0qD0McRxEzbwzuatQ75/NLkwe3KpO7MRU=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr55992303qvb.228.1594245361141;
 Wed, 08 Jul 2020 14:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com> <20200702200329.83224-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20200702200329.83224-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jul 2020 14:55:50 -0700
Message-ID: <CAEf4BzZA3_eXuUQtUCUF6hMk5winEYgsUeT1HoJCFnz9REkjZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add BPF program and map iterators as
 built-in BPF programs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 1:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> The program and map iterators work similar to seq_file-s.
> Once the program is pinned in bpffs it can be read with "cat" tool
> to print human readable output. In this case about BPF programs and maps.
> For example:
> $ cat /sys/fs/bpf/progs
>   id name            pages attached
>    5    dump_bpf_map     1 bpf_iter_bpf_map
>    6   dump_bpf_prog     1 bpf_iter_bpf_prog



> $ cat /sys/fs/bpf/maps
>   id name            pages
>    3 iterator.rodata     2
>
> To avoid kernel build dependency on clang 10 separate bpf skeleton generation
> into manual "make" step and instead check-in generated .skel.h into git.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/preload/iterators/.gitignore       |   2 +
>  kernel/bpf/preload/iterators/Makefile         |  57 +++
>  kernel/bpf/preload/iterators/README           |   4 +
>  kernel/bpf/preload/iterators/iterators.bpf.c  |  81 ++++
>  kernel/bpf/preload/iterators/iterators.skel.h | 359 ++++++++++++++++++
>  5 files changed, 503 insertions(+)
>  create mode 100644 kernel/bpf/preload/iterators/.gitignore
>  create mode 100644 kernel/bpf/preload/iterators/Makefile
>  create mode 100644 kernel/bpf/preload/iterators/README
>  create mode 100644 kernel/bpf/preload/iterators/iterators.bpf.c
>  create mode 100644 kernel/bpf/preload/iterators/iterators.skel.h
>

[...]

> +struct seq_file;
> +struct bpf_iter_meta {
> +       struct seq_file *seq;
> +       __u64 session_id;
> +       __u64 seq_num;
> +} __attribute__((preserve_access_index));
> +
> +struct bpf_map_memory {
> +       __u32 pages;
> +};

forgot __attribute__((preserve_access_index)) here?

> +struct bpf_map {
> +       __u32 id;
> +       struct bpf_map_memory memory;
> +       char name[16];
> +} __attribute__((preserve_access_index));
> +

[...]

> +SEC("iter/bpf_map")
> +int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
> +{
> +       struct seq_file *seq = ctx->meta->seq;
> +       __u64 seq_num = ctx->meta->seq_num;
> +       struct bpf_map *map = ctx->map;
> +
> +       if (!map)
> +               return 0;
> +
> +       if (seq_num == 0)
> +               BPF_SEQ_PRINTF(seq, "  id name            pages\n");
> +
> +       BPF_SEQ_PRINTF(seq, "%4u%16s%6d\n", map->id, map->name, map->memory.pages);

Here and below, please use %-16s for left-aligned strings for map name
and prog name.

> +       return 0;
> +}
> +
> +SEC("iter/bpf_prog")
> +int dump_bpf_prog(struct bpf_iter__bpf_prog *ctx)
> +{
> +       struct seq_file *seq = ctx->meta->seq;
> +       __u64 seq_num = ctx->meta->seq_num;
> +       struct bpf_prog *prog = ctx->prog;
> +       struct bpf_prog_aux *aux;
> +
> +       if (!prog)
> +               return 0;
> +
> +       aux = prog->aux;
> +       if (seq_num == 0)
> +               BPF_SEQ_PRINTF(seq, "  id name            pages attached\n");
> +
> +       BPF_SEQ_PRINTF(seq, "%4u%16s%6d %s %s\n", aux->id, aux->name, prog->pages,
> +                      aux->attach_func_name, aux->linked_prog->aux->name);
> +       return 0;
> +}
> +char LICENSE[] SEC("license") = "GPL";

[...]
