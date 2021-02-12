Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6878C31A770
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBLWV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhBLWV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 17:21:56 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E138C061574;
        Fri, 12 Feb 2021 14:21:16 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id n195so929069ybg.9;
        Fri, 12 Feb 2021 14:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKWeJCj4GoLGsmc/rqtRETsvzyNtzdAMI1J104MLKeI=;
        b=Nm5SGO15yGsQv3nj+NzDaqDGb4zBZ0XnCACa1ALeIMSXVjksV5A2f4ZZlJBMtHgig3
         D5PML+gyNEpsEGNC5YjkN8gCZ9wPxLMIt3R4Ntphvt03MaafOGSxwrk2vjC1e/Hqb84a
         yB32bsww6imVA2Z3sKQr6l5Nf+6x+ciYzQKXOZkTnZnqUQnWbaHy17wNJrjzEx+LQrqa
         D/V9HrFEb0iKzzZGTnHXvQDgmaXM6Rn2kXiOAkARNwV55aADNe2QrckhU5GfByTnW5uF
         BL1V9UJNtp/0iW7hNrV2HLKmbibKFUgaZLxVTtafakqIyMD//WYtef7xoNE9y5BXJYR2
         1RpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKWeJCj4GoLGsmc/rqtRETsvzyNtzdAMI1J104MLKeI=;
        b=P6D5B4eRbJJuGUd8vEwjwRmXmZD7lrbpOtoNrhIHiYi6rzfOZRdLoaNcdPBe6MF3ln
         i7/rRjNy4zi8BVq/5aCGRrGp9cQFQclI/CYY8rilK+ZHXeRl2l4xoze2mYlgwbnceGmB
         Z+S14HLEukRAYTBUjiehW1CUc4jGJOtNh0m9FTDA3Z1fHewMmk4Czz0eWEZAa/as2CJe
         hpiidizDX94yIjfgh0wKZtOsQO2cqp5dpdcFDUuibFWbsGhqzrCCGeKhkPg13IhFR8Q/
         b4pXdRrxKAa6eSeAp2XzRNiyvHiq1O7ddC4bqR2vUGicLYOm3l1L6ewG7Ru3VKo6PGqf
         5Uew==
X-Gm-Message-State: AOAM5333bffkG3zzqAOVxuuvOrx3BaucAZXh8PfpygL2QvDi61An6vmy
        EF/IgUfXcYrWsH3ypEYEVxy2A1NYHe7+nwd6mxI=
X-Google-Smtp-Source: ABdhPJwmcNHcG0ISz3V5EdTDWi31kaInHaBkcFJs5Zt/CL7dyC7nbvSbjQCz8CfjlHp0UNiYdyVjEXLVKFpaedyChAc=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr6827758yba.403.1613168475253;
 Fri, 12 Feb 2021 14:21:15 -0800 (PST)
MIME-Version: 1.0
References: <20210212135427.1250224-1-jolsa@redhat.com> <20210212220420.1289014-1-jolsa@kernel.org>
In-Reply-To: <20210212220420.1289014-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Feb 2021 14:21:04 -0800
Message-ID: <CAEf4BzYN7FnGjEYMDqQFK1LryUi0+cBTqaFXmPU_kBN1jJ+LLg@mail.gmail.com>
Subject: Re: [PATCH] btf_encoder: Match ftrace addresses within elf functions
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 2:05 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currently when processing DWARF function, we check its entrypoint
> against ftrace addresses, assuming that the ftrace address matches
> with function's entrypoint.
>
> This is not the case on some architectures as reported by Nathan
> when building kernel on arm [1].
>
> Fixing the check to take into account the whole function not
> just the entrypoint.
>
> Most of the is_ftrace_func code was contributed by Andrii.
>
> [1] https://lore.kernel.org/bpf/20210209034416.GA1669105@ubuntu-m3-large-x86/
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM. But see another suggestion below. In either case:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  btf_encoder.c | 55 +++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 45 insertions(+), 10 deletions(-)
>
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..03242f04c55d 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -36,6 +36,7 @@ struct funcs_layout {
>  struct elf_function {
>         const char      *name;
>         unsigned long    addr;
> +       unsigned long    size;
>         unsigned long    sh_addr;
>         bool             generated;
>  };
> @@ -98,6 +99,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
>
>         functions[functions_cnt].name = name;
>         functions[functions_cnt].addr = elf_sym__value(sym);
> +       functions[functions_cnt].size = elf_sym__size(sym);
>         functions[functions_cnt].sh_addr = sh.sh_addr;
>         functions[functions_cnt].generated = false;
>         functions_cnt++;
> @@ -236,6 +238,48 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
>         return 0;
>  }
>
> +static int is_ftrace_func(struct elf_function *func, __u64 *addrs,
> +                         __u64 count, bool kmod)
> +{
> +       /*
> +        * For vmlinux image both addrs[x] and functions[x]::addr
> +        * values are final address and are comparable.
> +        *
> +        * For kernel module addrs[x] is final address, but
> +        * functions[x]::addr is relative address within section
> +        * and needs to be relocated by adding sh_addr.
> +        */
> +       __u64 start = kmod ? func->addr + func->sh_addr : func->addr;
> +       __u64 addr, end = func->addr + func->size;
> +
> +       /*
> +        * The invariant here is addr[r] that is the smallest address
> +        * that is >= than function start addr. Except the corner case
> +        * where there is no such r, but for that we have a final check
> +        * in the return.
> +        */
> +       size_t l = 0, r = count - 1, m;
> +
> +       /* make sure we don't use invalid r */
> +       if (count == 0)
> +               return false;
> +
> +       while (l < r) {
> +               m = l + (r - l) / 2;
> +               addr = addrs[m];
> +
> +               if (addr >= start) {
> +                       /* we satisfy invariant, so tighten r */
> +                       r = m;
> +               } else {
> +                       /* m is not good enough as l, maybe m + 1 will be */
> +                       l = m + 1;
> +               }
> +       }
> +
> +       return start <= addrs[r] && addrs[r] < end;
> +}
> +
>  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  {
>         __u64 *addrs, count, i;
> @@ -275,18 +319,9 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>          */
>         for (i = 0; i < functions_cnt; i++) {
>                 struct elf_function *func = &functions[i];
> -               /*
> -                * For vmlinux image both addrs[x] and functions[x]::addr
> -                * values are final address and are comparable.
> -                *
> -                * For kernel module addrs[x] is final address, but
> -                * functions[x]::addr is relative address within section
> -                * and needs to be relocated by adding sh_addr.
> -                */
> -               __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;

if we just...

if (kmod)
    func->addr += func->sh_addr;

... here, that would make is_ftrace_func() free of kmod knowledge. If
there are other places that rely on kmod vs non-kmod address of a
function, that would be simplified as well, right?

>
>                 /* Make sure function is within ftrace addresses. */
> -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> +               if (is_ftrace_func(func, addrs, count, kmod)) {
>                         /*
>                          * We iterate over sorted array, so we can easily skip
>                          * not valid item and move following valid field into
> --
> 2.29.2
>
