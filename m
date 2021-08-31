Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5912D3FCFF9
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbhHaXhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbhHaXha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:37:30 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3008C061575;
        Tue, 31 Aug 2021 16:36:34 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id e131so1634268ybb.7;
        Tue, 31 Aug 2021 16:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HIGHN55nRj75KL6kDiiE+6J+8Vs2x7VbhacGk72I/WM=;
        b=bIbWoI5PlcFux2zFTWHHy4dVKyqhnyBmLvwqp+VHj35HAIF+yzxmVsdlolwwyelY5A
         VW7Lr/c4f1CBcFdyo8jc7RdIcGIeDTypU5icLbRCIN+gYZ3ni+paKQxSYSEuxPeTCN7+
         X6ij0bWlxRMBQoMwYvehSsvKiPk4CW2CjrCprK+ZcyBsq8kg7ED7wUN16xQ/TETlRtNf
         bqZGaO1n5mu+B3mRRi1vzYklu1CG2m0ICvuTaHnaP4XGxh6Hd0b8BJXIy4/jiz6TI9Kh
         T1y8rKVTs7X2RwgS7JR2+vygIiSz+A2xJ55RuRczCLTpZxQ6yUKyvJX3ZEn5EftCxkk4
         +oCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HIGHN55nRj75KL6kDiiE+6J+8Vs2x7VbhacGk72I/WM=;
        b=l+6zb4Tma1t3HP8ll4Ei6Jq/u/Iq2KV1ZJwitTh0luG4IRM5csM8uWznZzcLO6ZI7H
         HgSzT/77CTv1RF+JslGNx1iajNqP5JvaVeHNftt0uV2eIYd8cb0dwmdwb9k5sJ9bsRC3
         ZpwjsZkZG282wJt3YRhE3bnQAJCLOvy60Rn8gKQEscFfsxfLgGDbktoeggO3+D+mxPNb
         JnrIJEZrIeHYxouKq1HhXx9A4P/0/vbvI6oD5FUNT0+hmKjlOgXK3quZcHIUg5S6EVOL
         gHBnh3Y9GuXwtGO4a082+xWEjuwOnaHaiMsPe56EkHi5994mOKofsw0a5R1JgWuQMCMC
         pmlg==
X-Gm-Message-State: AOAM5310EvxuBaIZMNcWO1Z3lMDt2iTb1oWV9HZDWaPJOfN15U4ZhKkO
        DOd/GibLJLWXkduWqwHicpq4+rPasMwCXwVClcY=
X-Google-Smtp-Source: ABdhPJxrWaa256WJKjm2NvRcRiVaxSg6U749SsEzG1tPH9EoKnz8OOEofv7Pisc4Gah/BxgGyQlgzcpRnOG/ffcYCUo=
X-Received: by 2002:a5b:142:: with SMTP id c2mr32095840ybp.425.1630452993875;
 Tue, 31 Aug 2021 16:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210826193922.66204-1-jolsa@kernel.org> <20210826193922.66204-18-jolsa@kernel.org>
In-Reply-To: <20210826193922.66204-18-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 16:36:22 -0700
Message-ID: <CAEf4BzbvhgG8uLtkWHYmTBzKnPSJOLAmqDum0tZn1LNVi-8-nw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 17/27] bpf: Add multi trampoline attach support
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding new multi trampoline link (BPF_LINK_TYPE_TRACING_MULTI)
> as an interface to attach program to multiple functions.
>
> The link_create bpf_attr interface already has 'bpf_prog' file
> descriptor, that defines the program to be attached. It must be
> loaded with BPF_F_MULTI_FUNC flag.
>
> Adding new multi_btf_ids/multi_btf_ids_cnt link_create bpf_attr
> fields that provides BTF ids.
>
> The new link gets multi trampoline (via bpf_trampoline_multi_get)
> and links the provided program with embedded trampolines and the
> 'main' trampoline with new multi link/unlink functions:
>
>   int bpf_trampoline_multi_link_prog(struct bpf_prog *prog,
>                                      struct bpf_trampoline_multi *tr);
>   int bpf_trampoline_multi_unlink_prog(struct bpf_prog *prog,
>                                        struct bpf_trampoline_multi *tr);
>
> If embedded trampoline contains fexit programs, we need to switch
> its model to the multi trampoline model (because of the final 'ret'
> argument). We keep the count of attached multi func programs for each
> trampoline, so we can tell when to switch the model.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h            |   5 ++
>  include/uapi/linux/bpf.h       |   5 ++
>  kernel/bpf/core.c              |   1 +
>  kernel/bpf/syscall.c           | 120 +++++++++++++++++++++++++++++++++
>  kernel/bpf/trampoline.c        |  87 ++++++++++++++++++++++--
>  tools/include/uapi/linux/bpf.h |   5 ++
>  6 files changed, 219 insertions(+), 4 deletions(-)
>

[...]

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 1f9d336861f0..9533200ffadf 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1008,6 +1008,7 @@ enum bpf_link_type {
>         BPF_LINK_TYPE_NETNS = 5,
>         BPF_LINK_TYPE_XDP = 6,
>         BPF_LINK_TYPE_PERF_EVENT = 7,
> +       BPF_LINK_TYPE_TRACING_MULTI = 8,
>
>         MAX_BPF_LINK_TYPE,
>  };
> @@ -1462,6 +1463,10 @@ union bpf_attr {
>                                  */
>                                 __u64           bpf_cookie;
>                         } perf_event;
> +                       struct {
> +                               __aligned_u64   multi_btf_ids;          /* addresses to attach */
> +                               __u32           multi_btf_ids_cnt;      /* addresses count */
> +                       };

Please follow the pattern of perf_event, name this struct "multi".

>                 };
>         } link_create;
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index bad03dde97a2..6c16ac43dd91 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c

[...]

> +
> +       bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING_MULTI,
> +                     &bpf_tracing_multi_link_lops, prog);
> +       link->attach_type = prog->expected_attach_type;
> +       link->multi = multi;
> +
> +       err = bpf_link_prime(&link->link, &link_primer);
> +       if (err)
> +               goto out_free;
> +       err = bpf_trampoline_multi_link_prog(prog, multi);
> +       if (err)
> +               goto out_free;

bpf_link_cleanup(), can't free link after priming. Look at other
places using bpf_link.


> +       return bpf_link_settle(&link_primer);
> +
> +out_free:
> +       bpf_trampoline_multi_put(multi);
> +       kfree(link);
> +out_free_ids:
> +       kfree(btf_ids);
> +       return err;
> +}
> +

[...]
