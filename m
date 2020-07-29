Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847A3232489
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgG2SVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2SVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 14:21:47 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E17C061794;
        Wed, 29 Jul 2020 11:21:47 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id b2so731996qvp.9;
        Wed, 29 Jul 2020 11:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uC2Yfa9EauSFl+OWvUk9gA/kGn27Q0HFfGT3/E012rQ=;
        b=NTlMh/A8gTUZMxyYwL/gEdbpPjTNeA/qMBoowZGjv0SH8z5vQwUceiOXR30/dE3Hwm
         Al5Mv/jjP0XuDqJR8uFiSC2rU8SfGda/K+vfAfwwmQFDYGwM5gh/vNco89k1AG38TAvQ
         KefjcgPYfj1219rzNxXzIcvwbzbDpbhcuE2adFp5lE92jrmf+xr7+48y1wkZl07XxY5S
         45hRDnE6uGeK4uV74xwFVrEoEQB0IH33WuuM7XdqYpS6fYLiOGG64qVYOnYBuY94onrO
         bVSHFbJ4rtgCw6ysZsENRd5LLGRyC4ZfBTT/kv9cv1gTqD/Q+7PYpQHxsCluITswsWDz
         5nJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uC2Yfa9EauSFl+OWvUk9gA/kGn27Q0HFfGT3/E012rQ=;
        b=SAuAwagh0K60V7udmol3LZ/UTnz8pvk7JAExh6BGs3baWDsL7vP+xlqrGMGAJXNg9q
         jkfgtURyJCGEUlPS9fiSlrLmGX3i72sn/1XDbMbZ83OHaiU/NAuLc2LxIzZn7cLf0Kg5
         ZbpSpysk2vqmmYJ8FWMV2NCY0Xhmd7lWsBPe8TS8rt7uwF1+R3lrrLwuZz8aEnrHkc/H
         RrBi2bGm2srxcZZov8JU6giRBMqYom4TOyw37FUMLavF1kdCkFqhk2EACO/NVbjtBiul
         IU61casVA3Zl2ZJ7gXOnXp1zNs89UYTzV3g38ygqroOkr4gXcG2Utm3DNk3E9c7mzdnM
         FTUg==
X-Gm-Message-State: AOAM533SFxSLwSVwYnfbPtOScRv6v6vt5D5T/dGZEuJ9hUz5RpIwT8Ll
        yzTNgYqV5ROwZk/Z1ZR6KbsEWQju2A20I0zM+CI=
X-Google-Smtp-Source: ABdhPJw+UxmZlckbtiL6nSgupchii/HyIuAX8Lgd/3uEEbCtVOPzQYxRnRJ6mQNyMcyxkAcbDj2SPErkrmxbWbsFmxo=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr32913779qvf.247.1596046906946;
 Wed, 29 Jul 2020 11:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200724203830.81531-1-alexei.starovoitov@gmail.com> <20200724203830.81531-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20200724203830.81531-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Jul 2020 11:21:35 -0700
Message-ID: <CAEf4BzaJcAerczLS+nHPX5KpvNjfAB6Ushmy3HFyu5OJbKH9+Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: Add BPF program and map iterators as
 built-in BPF programs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 1:39 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> The program and map iterators work similar to seq_file-s.
> Once the program is pinned in bpffs it can be read with "cat" tool
> to print human readable output. In this case about BPF programs and maps.
> For example:
> $ cat /sys/fs/bpf/progs.debug
>   id name            attached
>    5 dump_bpf_map    bpf_iter_bpf_map
>    6 dump_bpf_prog   bpf_iter_bpf_prog
> $ cat /sys/fs/bpf/maps.debug
>   id name            pages
>    3 iterator.rodata     2
>
> To avoid kernel build dependency on clang 10 separate bpf skeleton generation
> into manual "make" step and instead check-in generated .skel.h into git.
>
> Unlike 'bpftool prog show' in-kernel BTF name is used (when available)
> to print full name of BPF program instead of 16-byte truncated name.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Tiny bug below, otherwise looks good.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  kernel/bpf/preload/iterators/.gitignore       |   2 +
>  kernel/bpf/preload/iterators/Makefile         |  57 +++
>  kernel/bpf/preload/iterators/README           |   4 +
>  kernel/bpf/preload/iterators/iterators.bpf.c  | 118 +++++
>  kernel/bpf/preload/iterators/iterators.skel.h | 411 ++++++++++++++++++
>  5 files changed, 592 insertions(+)
>  create mode 100644 kernel/bpf/preload/iterators/.gitignore
>  create mode 100644 kernel/bpf/preload/iterators/Makefile
>  create mode 100644 kernel/bpf/preload/iterators/README
>  create mode 100644 kernel/bpf/preload/iterators/iterators.bpf.c
>  create mode 100644 kernel/bpf/preload/iterators/iterators.skel.h
>

[...]

> +
> +static const char *get_name(struct btf *btf, long btf_id, const char *fallback)
> +{
> +       struct btf_type **types, *t;
> +       unsigned int name_off;
> +       const char *str;
> +
> +       if (!btf)
> +               return fallback;
> +       str = btf->strings;
> +       types = btf->types;
> +       bpf_probe_read_kernel(&t, sizeof(t), types + btf_id);
> +       name_off = BPF_CORE_READ(t, name_off);
> +       if (name_off > btf->hdr.str_len)

>= here?

> +               return fallback;
> +       return str + name_off;
> +}
> +
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
> +               BPF_SEQ_PRINTF(seq, "  id name             pages\n");
> +
> +       BPF_SEQ_PRINTF(seq, "%4u %-16s%6d\n", map->id, map->name, map->memory.pages);

map->memory.pages won't be meaningful, once Roman's patches removing
RLIMIT_MEMLOCK usage land, so might just drop them now

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
> +               BPF_SEQ_PRINTF(seq, "  id name             attached\n");
> +
> +       BPF_SEQ_PRINTF(seq, "%4u %-16s %s %s\n", aux->id,
> +                      get_name(aux->btf, aux->func_info[0].type_id, aux->name),
> +                      aux->attach_func_name, aux->linked_prog->aux->name);
> +       return 0;
> +}
> +char LICENSE[] SEC("license") = "GPL";


[...]
