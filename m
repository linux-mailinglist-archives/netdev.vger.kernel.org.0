Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCC23D3107
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhGWAHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 20:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhGWAHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 20:07:52 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F9C061575;
        Thu, 22 Jul 2021 17:48:25 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id c16so4244914ybl.9;
        Thu, 22 Jul 2021 17:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vIAtDcCMADhOZX+piEwknLlxTqR2nfl60i/vss4XcQs=;
        b=ihPfPjC5skcXJNEvBSMTusaW/Cai7VTXJHeXi0HvEDJHTAp04MFzCSo6qm2ts3bKEE
         EiijMZA9IVAfze3Q2L1+wykFsRUa1bHej6a7ByWztPEIaAav01HO5sEKTxmTdZ7xa1U7
         julVZ1JseW50JuSeZCCPok5Z+O30LM8sRxG6M/uXzLc7D7t6RJ5RUnXpNepc9Ea+B2xV
         duL4qFhC73wzMfNJJvTm/6o3YIaI5iQCpzywAXfHTyEW0JKo9svzI1jhOI59clW0BYrd
         Qc+2ScvhKGkO9RzOds8wEjhXPtARwN+OPEaN/6hc9LJKI0TNPjTiTd0HNuXhPApWn3dH
         2cxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vIAtDcCMADhOZX+piEwknLlxTqR2nfl60i/vss4XcQs=;
        b=jHEKoCI6yp51bhGKbuP+503QbmQWBpdzrsSbGuby7FHexWTwoDBuG52EdKHhycvC5n
         mDUDi+ho8ufRbJmDZopGzRTQZ6F872tJ1be6mr6FWY8g9jgM4YqwF7cyIosUwVZGeehy
         N7JXWlMp3xYm+3DDTNt+WWiiekXOwooMMR46Am6Irmz1mSorvEgHcdM9k3BaYOc7vJIm
         uyrC6Th1tE4YQZhvI3TI4nFKqu4KBJYhPx6WBjRm1XZRq1S/mO9GEeunKnXA74Udvhii
         VEGDieK6DgZsFwV9LjMRXN84ZhUrUBvZSpnLqhYdGyT4E+5FV8y5q703qbBNq0HIkq/1
         wr1Q==
X-Gm-Message-State: AOAM5308rvljJhtlLLLBDb2lLDYGVKR2QpDi2L8eSs78Y4t01ngoWJD6
        Ij4aAEzmwCHnFQ5NFgSF3Sk7CtEFnutvYn4gwHc=
X-Google-Smtp-Source: ABdhPJyzVj3AWDgSUQoBLp24+J/KQT6Pyt2hjZKrw3Z9Y4Nn5e/Pk9TLrieDW0qqcIDXkvdAcL5UrqBrMV/kXuJJ1Z8=
X-Received: by 2002:a25:b741:: with SMTP id e1mr3023511ybm.347.1627001304920;
 Thu, 22 Jul 2021 17:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <20210721153808.6902-4-quentin@isovalent.com>
In-Reply-To: <20210721153808.6902-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 17:48:13 -0700
Message-ID: <CAEf4BzatvJORZvkz37_XJxvk5+Amr8V8iHq=1_4k_uCz0fE-eQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/5] tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Replace the calls to deprecated function btf__get_from_id() with calls
> to btf__load_from_kernel_by_id() in tools/ (bpftool, perf, selftests).
> Update the surrounding code accordingly (instead of passing a pointer to
> the btf struct, get it as a return value from the function). Also make
> sure that btf__free() is called on the pointer after use.
>
> v2:
> - Given that btf__load_from_kernel_by_id() has changed since v1, adapt
>   the code accordingly instead of just renaming the function. Also add a
>   few calls to btf__free() when necessary.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  tools/bpf/bpftool/btf.c                      |  8 ++----
>  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
>  tools/bpf/bpftool/map.c                      | 16 +++++------
>  tools/bpf/bpftool/prog.c                     | 29 ++++++++++++++------
>  tools/perf/util/bpf-event.c                  | 11 ++++----
>  tools/perf/util/bpf_counter.c                | 12 ++++++--
>  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
>  7 files changed, 51 insertions(+), 35 deletions(-)
>

[...]

> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index 09ae0381205b..12787758ce03 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -805,12 +805,11 @@ static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
>                 }
>                 return btf_vmlinux;
>         } else if (info->btf_value_type_id) {
> -               int err;
> -
> -               err = btf__get_from_id(info->btf_id, &btf);
> -               if (err || !btf) {
> +               btf = btf__load_from_kernel_by_id(info->btf_id);
> +               if (libbpf_get_error(btf)) {
>                         p_err("failed to get btf");
> -                       btf = err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
> +                       if (!btf)
> +                               btf = ERR_PTR(-ESRCH);

why not do a simpler (less conditionals)

err = libbpf_get_error(btf);
if (err) {
    btf = ERR_PTR(err);
}

?

>                 }
>         }
>
> @@ -1039,11 +1038,10 @@ static void print_key_value(struct bpf_map_info *info, void *key,
>                             void *value)
>  {
>         json_writer_t *btf_wtr;
> -       struct btf *btf = NULL;
> -       int err;
> +       struct btf *btf;
>
> -       err = btf__get_from_id(info->btf_id, &btf);
> -       if (err) {
> +       btf = btf__load_from_kernel_by_id(info->btf_id);
> +       if (libbpf_get_error(btf)) {
>                 p_err("failed to get btf");
>                 return;
>         }

[...]

>
>         func_info = u64_to_ptr(info->func_info);
> @@ -781,6 +784,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
>                 kernel_syms_destroy(&dd);
>         }
>
> +       btf__free(btf);
> +

warrants a Fixes: tag?

>         return 0;
>  }
>
> @@ -2002,8 +2007,8 @@ static char *profile_target_name(int tgt_fd)
>         struct bpf_prog_info_linear *info_linear;
>         struct bpf_func_info *func_info;
>         const struct btf_type *t;
> +       struct btf *btf = NULL;
>         char *name = NULL;
> -       struct btf *btf;
>
>         info_linear = bpf_program__get_prog_info_linear(
>                 tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
> @@ -2012,12 +2017,17 @@ static char *profile_target_name(int tgt_fd)
>                 return NULL;
>         }
>
> -       if (info_linear->info.btf_id == 0 ||
> -           btf__get_from_id(info_linear->info.btf_id, &btf)) {
> +       if (info_linear->info.btf_id == 0) {
>                 p_err("prog FD %d doesn't have valid btf", tgt_fd);
>                 goto out;
>         }
>
> +       btf = btf__load_from_kernel_by_id(info_linear->info.btf_id);
> +       if (libbpf_get_error(btf)) {
> +               p_err("failed to load btf for prog FD %d", tgt_fd);
> +               goto out;
> +       }
> +
>         func_info = u64_to_ptr(info_linear->info.func_info);
>         t = btf__type_by_id(btf, func_info[0].type_id);
>         if (!t) {
> @@ -2027,6 +2037,7 @@ static char *profile_target_name(int tgt_fd)
>         }
>         name = strdup(btf__name_by_offset(btf, t->name_off));
>  out:
> +       btf__free(btf);

and another Fixes? :) and two more below

>         free(info_linear);
>         return name;
>  }

[...]
