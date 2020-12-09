Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE0D2D4BB5
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbgLIUZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388219AbgLIUZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 15:25:14 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931D4C0613CF;
        Wed,  9 Dec 2020 12:24:34 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id w127so2528498ybw.8;
        Wed, 09 Dec 2020 12:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PdC3VejKGPC3dWD2jeX637qG2QKAXVWgIi8YqrpP3d4=;
        b=BJkr+WWygQ0+aLRP0kHhJWluHotQxRtSuhdzUaEY+jVX2ZbG5ylZuSVrcFftcI3UGV
         BU97tt3z/zcUcpLsgfGo5P+Qzp2+2BWIjaeq1dY4d9Ol8rTF2wYc4IP9cC58yNOaMt6r
         24tqhx18XnZtu4ms4+q3ISXMy9pS5Ap78DwoBaWH9UcyMA39p1PjP7kHZGNdiUwzPNr5
         fyW3/DUo6fDnnV2yRrmUI2mEtdLflXHImxx4zqh7Av8A35Q4uv33fFdfnjJf9jW1QyhK
         cKJR8En5CzNB5bLqdRVUMzsf1FB0Tluj5Q03Rd5RNNta33rE1NHwb8tjpd1RKYuEYMfL
         Om+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PdC3VejKGPC3dWD2jeX637qG2QKAXVWgIi8YqrpP3d4=;
        b=Q9EEcyd0WNuePlDJapWCY9jVR2qW7YhZU6MVsazcO5oZh+vIfw+X1ixTZtEnMKPTz6
         FQdraOH3tRDeJ8zvNXelPN+UA+0tUtTc2zklR7abREFkt8whT9wn/21Ixkw4K7GZZJAP
         P7BIByVMLb+xhUVFDeDHc961fxTfBQyg5/wYDXqHraYFHry3OyxwKUNm5sI/NnVFLjI9
         48nbVSdoB8G8lpNo05AU/sSSR6KGN7eMoqdFZClP7X0BXJUscMP0SL/8DPEtJg446b+H
         e1oDzLPoO0gkzv0ErxsEToBa7/S1ek8HdGA4+mRonD33eSz+yZfFdhj+WUwJcrEHku/Q
         AG1w==
X-Gm-Message-State: AOAM531JrpCGD3MybZEHy5qXVs8nt0rOFDK7cGTqdLH+YCD60EthUHW0
        REBCksFgyOfzKfRTTBXNdZUJQGJufwq7Vslns5gZ/+rJOHHOCQ==
X-Google-Smtp-Source: ABdhPJwr7+SIEGjhixn2qPULGmBVTd8ltlU6gfNtspOVKrTWI/tg9RorDMrmX0G9HnuIS4Hm/Gr4SUQ4EomCTy3xnE8=
X-Received: by 2002:a25:c089:: with SMTP id c131mr5897209ybf.510.1607545473871;
 Wed, 09 Dec 2020 12:24:33 -0800 (PST)
MIME-Version: 1.0
References: <20201209142912.99145-1-jolsa@kernel.org>
In-Reply-To: <20201209142912.99145-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Dec 2020 12:24:23 -0800
Message-ID: <CAEf4BzYBddPaEzRUs=jaWSo5kbf=LZdb7geAUVj85GxLQztuAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix selftest compilation on clang 11
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        KP Singh <kpsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 7:16 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We can't compile test_core_reloc_module.c selftest with clang 11,
> compile fails with:
>
>   CLNG-LLC [test_maps] test_core_reloc_module.o
>   progs/test_core_reloc_module.c:57:21: error: use of unknown builtin \
>   '__builtin_preserve_type_info' [-Wimplicit-function-declaration]
>    out->read_ctx_sz = bpf_core_type_size(struct bpf_testmod_test_read_ctx);
>
> Skipping these tests if __builtin_preserve_type_info() is not
> supported by compiler.
>
> Fixes: 6bcd39d366b6 ("selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF")
> Fixes: bc9ed69c79ae ("selftests/bpf: Add tp_btf CO-RE reloc test for modules")

The test isn't really broken, so "Fixes: " tags seem wrong here.

Given core_relo tests have established `data.skip = true` mechanism,
I'm fine with this patch. But moving forward I think we should
minimize the amount of feature-detection and tests skipping in
selftests. The point of selftests is to test the functionality at the
intersection of 4 projects: kernel, libbpf, pahole and clang. We've
stated before and I think it remains true that the expectation for
anyone that wants to develop and run selftests is to track latests
versions of all 4 of those, sometimes meaning nightly builds or
building from sources. For clang, which is arguably the hardest of the
4 to build from sources, LLVM project publishes nightly builds for
Ubuntu and Debian, which are very easy to use to get recent enough
versions for selftests. That's exactly what libbpf CI is doing, BTW.

It's hard and time-consuming enough to develop these features, I'd
rather keep selftests simpler, more manageable, and less brittle by
not having excessive amount of feature detection and skipped
selftests. I think that's the case for BPF atomics as well, btw (cc'ed
Yonghong and Brendan).

To alleviate some of the pain of setting up the environment, one way
would be to provide script and/or image to help bring up qemu VM for
easier testing. To that end, KP Singh (cc'ed) was able to re-use
libbpf CI's VM setup and make it easier for local development. I hope
he can share this soon.

So given minimal additions code-wise, but also considering all the above:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../testing/selftests/bpf/progs/test_core_reloc_module.c  | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
> index 56363959f7b0..f59f175c7baf 100644
> --- a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
> +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
> @@ -40,6 +40,7 @@ int BPF_PROG(test_core_module_probed,
>              struct task_struct *task,
>              struct bpf_testmod_test_read_ctx *read_ctx)
>  {
> +#if __has_builtin(__builtin_preserve_enum_value)
>         struct core_reloc_module_output *out = (void *)&data.out;
>         __u64 pid_tgid = bpf_get_current_pid_tgid();
>         __u32 real_tgid = (__u32)(pid_tgid >> 32);
> @@ -61,6 +62,9 @@ int BPF_PROG(test_core_module_probed,
>         out->len_exists = bpf_core_field_exists(read_ctx->len);
>
>         out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
> +#else
> +       data.skip = true;
> +#endif
>
>         return 0;
>  }
> @@ -70,6 +74,7 @@ int BPF_PROG(test_core_module_direct,
>              struct task_struct *task,
>              struct bpf_testmod_test_read_ctx *read_ctx)
>  {
> +#if __has_builtin(__builtin_preserve_enum_value)
>         struct core_reloc_module_output *out = (void *)&data.out;
>         __u64 pid_tgid = bpf_get_current_pid_tgid();
>         __u32 real_tgid = (__u32)(pid_tgid >> 32);
> @@ -91,6 +96,9 @@ int BPF_PROG(test_core_module_direct,
>         out->len_exists = bpf_core_field_exists(read_ctx->len);
>
>         out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
> +#else
> +       data.skip = true;
> +#endif
>
>         return 0;
>  }
> --
> 2.26.2
>
