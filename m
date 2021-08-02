Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1143DE1BF
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhHBVf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhHBVf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 17:35:57 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296DDC06175F;
        Mon,  2 Aug 2021 14:35:47 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id j77so28783036ybj.3;
        Mon, 02 Aug 2021 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VEqtTDy9OvPABvWDgwaz/79fdbp1plJiCs2dDgJYUy4=;
        b=s7qfCuI571Fu9llPhe90aUiFWQj6/8jdvt6dqy6nOwgrQCm1aIuYoozNE8HWUvZaH0
         73+fEtkMwqIPFiqzMO940fNigrkr7HIDFBoRWWYOxPBCXFQjlDTUJKxwVgKhLwierzj1
         mqcs8s+9Q+wPEdOt6Df7YRKmFP61noJ0ocBlRbAVlJVitVjK9D0ygC2p+X4vfsMafe81
         CVoIn8GZLRT9q4s2LGHvJG2pKmYcltFoC6p1s8R49kf1Ly3oA4le5in4LGRids1gXMG1
         BLDiJSckArqLOs+8UQcf+TXHIQzOWJwLA9lbpNsQuHidtrc5lWDsVC4qFfUaE+Xq+7R6
         hPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VEqtTDy9OvPABvWDgwaz/79fdbp1plJiCs2dDgJYUy4=;
        b=FcUiQon5KRQw3PLpmSLcXUggdK/kSsjfuIKMKmjpiIfXvKaBsQOFwzfEtSrhOq6mN6
         1DJk7VvqlL37202ob0xsxirP3052YCry6giZN7rkB05QmwaTagTwXPQfMrgK1yhi0fgZ
         C6TfRBTPgXVDEYL/ztgMGPgES+9YLSXwfV5zByQRwRM/ShyeDcfiLm7FgUbFYLXE7VQr
         fMKuhncmxg7NCn2jZohILRUTbl2oXhTr1igqLquPXCJh4V7+ZuOXvtvRXZT0HzTZtFFE
         dYzUi77xS58jCdrFZDa02KGYz95ag/TKVE+Lx1krPHWF+3OzDxtzhVznNT0S/cMi501e
         Cc0w==
X-Gm-Message-State: AOAM530bJNhQ0U/B0T03G7uXD9ngCYOmg0GBkM6byErTakoIWau8Re1p
        V5jhtF7RbK85/rxF7Mnmihlsia/nZGnvhtN3RGI=
X-Google-Smtp-Source: ABdhPJz8Ew8kbzlyYA5F5+dTC69os1cvHr+av/Y1KJb7blkma+weYPqKHknn2DrNg3uniI17xAU8U6QnXvZOU/HsZv8=
X-Received: by 2002:a25:1455:: with SMTP id 82mr23362603ybu.403.1627940146455;
 Mon, 02 Aug 2021 14:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210731233056.850105-1-davemarchevsky@fb.com> <20210731233056.850105-2-davemarchevsky@fb.com>
In-Reply-To: <20210731233056.850105-2-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Aug 2021 14:35:35 -0700
Message-ID: <CAEf4BzYJanf4gCmeeNHZhjJeUwwOQOCteCP4Uoj3yRD698BJCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/1] bpf: migrate cgroup_bpf to internal
 cgroup_bpf_attach_type enum
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 4:33 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> Add an enum (cgroup_bpf_attach_type) containing only valid cgroup_bpf
> attach types and a function to map bpf_attach_type values to the new
> enum. Inspired by netns_bpf_attach_type.
>
> Then, migrate cgroup_bpf to use cgroup_bpf_attach_type wherever
> possible.  Functionality is unchanged as attach_type_to_prog_type
> switches in bpf/syscall.c were preventing non-cgroup programs from
> making use of the invalid cgroup_bpf array slots.
>
> As a result struct cgroup_bpf uses 504 fewer bytes relative to when its
> arrays were sized using MAX_BPF_ATTACH_TYPE.
>
> bpf_cgroup_storage is notably not migrated as struct
> bpf_cgroup_storage_key is part of uapi and contains a bpf_attach_type
> member which is not meant to be opaque. Similarly, bpf_cgroup_link
> continues to report its bpf_attach_type member to userspace via fdinfo
> and bpf_link_info.
>
> To ease disambiguation, bpf_attach_type variables are renamed from
> 'type' to 'atype' when changed to cgroup_bpf_attach_type.
>
> Regarding testing: biggest concerns here are 1) attach/detach/run for
> programs which shouldn't map to a cgroup_bpf_attach_type should continue
> to not involve cgroup_bpf codepaths; and 2) attach types that should be
> mapped to a cgroup_bpf_attach_type do so correctly and run as expected.
>
> Existing selftests cover both scenarios well. The udp_limit selftest
> specifically validates the 2nd case - BPF_CGROUP_INET_SOCK_RELEASE is
> larger than MAX_CGROUP_BPF_ATTACH_TYPE so if it were not correctly
> mapped to CG_BPF_CGROUP_INET_SOCK_RELEASE the test would fail.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

Love the change, thanks! This has been bothering me for a while now.
type -> atype rename is quite noisy, though. I don't mind it, but I'll
let Daniel decide.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/bpf-cgroup.h     | 200 +++++++++++++++++++++++----------
>  include/uapi/linux/bpf.h       |   2 +-
>  kernel/bpf/cgroup.c            | 154 +++++++++++++++----------
>  net/ipv4/af_inet.c             |   6 +-
>  net/ipv4/udp.c                 |   2 +-
>  net/ipv6/af_inet6.c            |   6 +-
>  net/ipv6/udp.c                 |   2 +-
>  tools/include/uapi/linux/bpf.h |   2 +-
>  8 files changed, 243 insertions(+), 131 deletions(-)
>

[...]

>  #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk)                                     \
> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_CREATE)
> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET_SOCK_CREATE)
>
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk)                             \
> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_RELEASE)
> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET_SOCK_RELEASE)
>
>  #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk)                                       \
> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET4_POST_BIND)
> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET4_POST_BIND)
>
>  #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk)                                       \
> -       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET6_POST_BIND)
> +       BPF_CGROUP_RUN_SK_PROG(sk, CG_BPF_CGROUP_INET6_POST_BIND)
>

all these macros are candidate for a rewrite to proper (always
inlined) functions, similarly to what I did in [0]. It would make it
much harder to accidentally use wrong constant and will make typing
explicit. But let's see how that change goes first.

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210730053413.1090371-3-andrii@kernel.org/

> -#define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, type)                                       \
> +#define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)                                      \
>  ({                                                                            \
>         u32 __unused_flags;                                                    \
>         int __ret = 0;                                                         \
> -       if (cgroup_bpf_enabled(type))                                          \
> -               __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> +       if (cgroup_bpf_enabled(atype))                                         \
> +               __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
>                                                           NULL,                \
>                                                           &__unused_flags);    \
>         __ret;                                                                 \
>  })
>

[...]
