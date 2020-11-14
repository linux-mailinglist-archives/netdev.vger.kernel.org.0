Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7631D2B2BE0
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 08:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKNHCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 02:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgKNHCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 02:02:00 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC85C0613D1;
        Fri, 13 Nov 2020 23:01:59 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id t33so10877164ybd.0;
        Fri, 13 Nov 2020 23:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cCwYM723vu0+HDR43zM2w2KVmNOxRU7b25uAdpj/KzU=;
        b=uQW7h6BPx5Ya3z/xNyGJ+C+sd9L36R3h52xM3F6vlgcY+1XGqCfc71tBWVRJlzWDnd
         EegJZ2m5vWaTv5jdJ1SN1Jj+cAsi4GpHx84GQSJQmH7Jhn731cHVXLwqRsTAtXG8ikqn
         Bc07wvt+Kjln85JIg4DK8nB/4s+bcebhZBXqA0CnWODJq1zzDwBwPh2bxk8EN4w4ujtp
         FFeNpEOmxekrSoNMCHlMYj0lT2YrKFTrIwLy/IqZAv6lGl1GrLu6zFdD2RYLhjVRxXJG
         JguD63nIR1xwn2SsZ4GC/WWWjyZTK9R51PL3f425mxReBt+n2gUeZ34dykcQ+8oAVxGE
         8WZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cCwYM723vu0+HDR43zM2w2KVmNOxRU7b25uAdpj/KzU=;
        b=l5640U51/zCtHAZdB7mAk0ws40N7bfXTk852XnGYb6fJP6CEP0AAT5Y3JuJAJZhdXW
         9z5igmj8TzdygEfPfRBtJkuB7oU3XHXNMfIExwFkLPY2GtSwE8gS67M+W5OLDRJK+3xe
         HiEqzFttx9Wl0PJrNpw2Ktetq9X2idu7LMnfn0lFRdG87WX+mXyrwxRLRC9AGDpJIMR1
         RRgXMm3flMlcV4LbxocZx0TqqS9Eka21JkbG5OJFCDtahE7XozCyyzVxCz03t1Ldx69+
         uB+04r1dxr1XruUZj9VCCTQijQXSW+ahkz+WJlu6jObsMmG0Sp6n+9YLywZMqiL3m1z0
         o/mw==
X-Gm-Message-State: AOAM530QC5TayxWFg2AEMEahJ5WQmJJV8KVetD5KXGf8OjM75WPVWcyG
        FUVgRNdWpcuQUVxydk7rXSWo55U9ccJ1Yr4ihV0=
X-Google-Smtp-Source: ABdhPJw1skR7ONqZ9ZZWxzFVeeLNxYVf7EgcXBv24ecWx2zpqf7en+86gQAyBo6MyWQkBfLjCjga+3aUE/AfEsZqoxg=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr6721728ybg.230.1605337319290;
 Fri, 13 Nov 2020 23:01:59 -0800 (PST)
MIME-Version: 1.0
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com> <1605291013-22575-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1605291013-22575-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Nov 2020 23:01:48 -0800
Message-ID: <CAEf4BzZdE4b5JFBvsvAFL-iSkKs7C-iE1UegiKU-X=wZdz+a_g@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/3] selftests/bpf: verify module-specific types
 can be shown via bpf_snprintf_btf
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 10:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Verify that specifying a module name in "struct btf_ptr *" along
> with a type id of a module-specific type will succeed.
>
> veth_stats_rx() is chosen because its function signature consists
> of a module-specific type "struct veth_stats" and a kernel-specific
> one "struct net_device".
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/snprintf_btf_mod.c    | 96 ++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/btf_ptr.h        |  1 +
>  tools/testing/selftests/bpf/progs/veth_stats_rx.c  | 73 ++++++++++++++++
>  3 files changed, 170 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
>  create mode 100644 tools/testing/selftests/bpf/progs/veth_stats_rx.c
>

[...]

> +       err = veth_stats_rx__load(skel);
> +       if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
> +               goto cleanup;
> +
> +       bss = skel->bss;
> +
> +       bss->veth_stats_btf_id = btf__find_by_name(veth_btf, "veth_stats");

This is really awkward that this needs to be done from user-space.
Libbpf will be able to do this regardless of whether the type is in
vmlinux or kernel module. See my comments on patch #1.

> +
> +       if (CHECK(bss->veth_stats_btf_id <= 0, "find 'struct veth_stats'",
> +                 "could not find 'struct veth_stats' in veth BTF: %d",
> +                 bss->veth_stats_btf_id))
> +               goto cleanup;
> +

[...]

> +       btf_ids[0] = veth_stats_btf_id;
> +       ptrs[0] = (void *)PT_REGS_PARM1_CORE(ctx);
> +#if __has_builtin(__builtin_btf_type_id)

nit: there are a bunch of selftests that just assume we have this
built-in, so I don't think you need to guard it with #if here.

> +       btf_ids[1] = bpf_core_type_id_kernel(struct net_device);
> +       ptrs[1] = (void *)PT_REGS_PARM2_CORE(ctx);
> +#endif

[...]
