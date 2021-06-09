Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A613D3A0BC9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 07:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhFIFVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 01:21:38 -0400
Received: from mail-yb1-f181.google.com ([209.85.219.181]:41648 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhFIFVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 01:21:37 -0400
Received: by mail-yb1-f181.google.com with SMTP id q21so33666302ybg.8;
        Tue, 08 Jun 2021 22:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMFK3fLJKVArAEkHgLhQfQOYv2YHIbnWZrsf6bmNjTI=;
        b=mMVEy6cRs7DS/P4ImBtQPfs1cb1hc4f68vJac0gwKE3HJXkFrZBKMen/PqEI11IAqM
         gIJE3jQfHN+2eGlev7zKA23FpaHC9FNG6KhyF5jaQi4XdLTO5TWmh9Zk5/nMdEWmFH3Y
         1qvENwZuULTVWs6IHZGitf1MTOjQ6qBKvUlKm0LnUS4TthMYAXmpj5hKkr8Ay0LTwDAc
         4l/VR0Nwfi41UekjE1QTYY2Cv5FzZJ3VJ5ED8G5p6vJ4Puby/rHUG8Yf+gH4bcF2S/9o
         uBpu9cMgxdIte9Mfj66WKrvSQ3aNm3tDJHtRVXcKfnRmnMj9g6cu6+PV0TsB4iJv6NbY
         5wPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMFK3fLJKVArAEkHgLhQfQOYv2YHIbnWZrsf6bmNjTI=;
        b=WBgoxFY6XMzjYGwjaMgyApMUCvo9KMGReMIzl12sN87hxV34/TE+bJ8gihc8wTVu5j
         CCrjXAOzUGfSM3x6eLTMbq4rrhlwZQRAFLZfn/AKhjmZOk1AbrMVqz4mnpCYjhBF3cye
         BOWh/IW8yRZwKCf4WxI4j6rzspQid6OC5PtRVMCk77sEhxNRCzS8S3m14EQrB7TKYrPT
         IlwGF6lIGWyMk6B1chMts0ZhRNqxqRr4ynFxzyN9C+D6jcojFE1doSszadK/hW8OGI9y
         YzH1SNqq2MaZxagr/JJHfUJmMN+N31aRIuCwinO4NaJbMdF5aLIOD15cfq7W71q2anYG
         nNGA==
X-Gm-Message-State: AOAM533cd3eNWy/qjtOSdqkYOkmr6uHpRWu3OpKxoxQaW63qnXT5QfIJ
        wEU1Y0cFx6cBWptueKY+VniKKZUpqiKiB81HrlM=
X-Google-Smtp-Source: ABdhPJyx5AskNay5Z4MVC+ZVPWiE7c6vefjoY2ajdVwkzIDw3ejW3vnHM0TLo1qJYscvkYKPDlQ5bssubRuwM4opx1Y=
X-Received: by 2002:a25:aa66:: with SMTP id s93mr25618488ybi.260.1623215912362;
 Tue, 08 Jun 2021 22:18:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-14-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-14-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 22:18:21 -0700
Message-ID: <CAEf4BzbrwiAJobuU01rd3XEw_b-vbUiL-uqM4_5_FZuAT7rSxA@mail.gmail.com>
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
To:     Jiri Olsa <jolsa@kernel.org>
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

On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to attach multiple functions to tracing program
> by using the link_create/link_update interface.
>
> Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> API, that define array of functions btf ids that will be attached
> to prog_fd.
>
> The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).

So I'm not sure why we added a new load flag instead of just using a
new BPF program type or expected attach type?  We have different
trampolines and different kinds of links for them, so why not be
consistent and use the new type of BPF program?.. It does change BPF
verifier's treatment of input arguments, so it's not just a slight
variation, it's quite different type of program.

>
> The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> link type, which creates separate bpf_trampoline and registers it
> as direct function for all specified btf ids.
>
> The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> standard trampolines, so all registered functions need to be free
> of direct functions, otherwise the link fails.
>
> The new bpf_trampoline will store and pass to bpf program the highest
> number of arguments from all given functions.
>
> New programs (fentry or fexit) can be added to the existing trampoline
> through the link_update interface via new_prog_fd descriptor.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h            |   3 +
>  include/uapi/linux/bpf.h       |   5 +
>  kernel/bpf/syscall.c           | 185 ++++++++++++++++++++++++++++++++-
>  kernel/bpf/trampoline.c        |  53 +++++++---
>  tools/include/uapi/linux/bpf.h |   5 +
>  5 files changed, 237 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 23221e0e8d3c..99a81c6c22e6 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -661,6 +661,7 @@ struct bpf_trampoline {
>         struct bpf_tramp_image *cur_image;
>         u64 selector;
>         struct module *mod;
> +       bool multi;
>  };
>
>  struct bpf_attach_target_info {
> @@ -746,6 +747,8 @@ void bpf_ksym_add(struct bpf_ksym *ksym);
>  void bpf_ksym_del(struct bpf_ksym *ksym);
>  int bpf_jit_charge_modmem(u32 pages);
>  void bpf_jit_uncharge_modmem(u32 pages);
> +struct bpf_trampoline *bpf_trampoline_multi_alloc(void);
> +void bpf_trampoline_multi_free(struct bpf_trampoline *tr);
>  #else
>  static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
>                                            struct bpf_trampoline *tr)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ad9340fb14d4..5fd6ff64e8dc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1007,6 +1007,7 @@ enum bpf_link_type {
>         BPF_LINK_TYPE_ITER = 4,
>         BPF_LINK_TYPE_NETNS = 5,
>         BPF_LINK_TYPE_XDP = 6,
> +       BPF_LINK_TYPE_TRACING_MULTI = 7,
>
>         MAX_BPF_LINK_TYPE,
>  };
> @@ -1454,6 +1455,10 @@ union bpf_attr {
>                                 __aligned_u64   iter_info;      /* extra bpf_iter_link_info */
>                                 __u32           iter_info_len;  /* iter_info length */
>                         };
> +                       struct {
> +                               __aligned_u64   multi_btf_ids;          /* addresses to attach */
> +                               __u32           multi_btf_ids_cnt;      /* addresses count */
> +                       };

let's do what bpf_link-based TC-BPF API is doing, put it into a named
field (I'd do the same for iter_info/iter_info_len above as well, I'm
not sure why we did this flat naming scheme, we now it's inconvenient
when extending stuff).

struct {
    __aligned_u64 btf_ids;
    __u32 btf_ids_cnt;
} multi;

>                 };
>         } link_create;
>

[...]

> +static int bpf_tracing_multi_link_update(struct bpf_link *link,
> +                                        struct bpf_prog *new_prog,
> +                                        struct bpf_prog *old_prog __maybe_unused)
> +{

BPF_LINK_UPDATE command supports passing old_fd and extra flags. We
can use that to implement both updating existing BPF program in-place
(by passing BPF_F_REPLACE and old_fd) or adding the program to the
list of programs, if old_fd == 0. WDYT?

> +       struct bpf_tracing_multi_link *tr_link =
> +               container_of(link, struct bpf_tracing_multi_link, link);
> +       int err;
> +
> +       if (check_multi_prog_type(new_prog))
> +               return -EINVAL;
> +
> +       err = bpf_trampoline_link_prog(new_prog, tr_link->tr);
> +       if (err)
> +               return err;
> +
> +       err = modify_ftrace_direct_multi(&tr_link->ops,
> +                                        (unsigned long) tr_link->tr->cur_image->image);
> +       return WARN_ON(err);
> +}
> +

[...]
