Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F3031A552
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhBLTXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhBLTXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:23:33 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57599C0613D6;
        Fri, 12 Feb 2021 11:22:53 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id i71so502382ybg.7;
        Fri, 12 Feb 2021 11:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8WhYApIAA1XHJe5w4ij7wmcVL6byN9dhLexoHXk9CXU=;
        b=YrfMUVKpC/f5k3JZjnDL6rNvRK0OXmafyzLgjCHAqDHQTX4bs24HNqOfG3L3mQzFS4
         QTdlFOS3txBAwjcSI4z94mNFazuzBCYA5WXYSAXlxGO4tU1Gi4b9RrLQaudXC5oVO+XX
         TyyUviB+wC8APn2hH0ZqjYqp6tJmlKq46gftWlsppMclEhK+8vKY9LZE0c47ZRzVwf80
         VSjNGYYQOkHtWAB+JVXBKw4qSWZpZ/8TKincHgEnNGXl2sduB7mxzDE5MxwzK8McJOOS
         243Rq9sHjdu3UTxi+MbrHQ9XbK4JJOUza6XxMV68WEoQ8a5r0XzsJzgSx3LlQU/0RUWO
         aSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WhYApIAA1XHJe5w4ij7wmcVL6byN9dhLexoHXk9CXU=;
        b=iahuPrM1e23f2QZbZ4VnznUoBPhtau6W1xTvXOnNktDHOOByLuVAWCyg5wVky6jsEk
         GNGEqPbKGubnzBBv17yUfmz5mk326Le7ZfNzMnwUUbF2pnnOO/5NenD6cA5B8akBmddH
         fe5AJDxle8gU3MCfud/2ot9rtVlXbV2jnof0Kp69V0NbrxWbKan5yLU2mGlaMiibviNB
         CfBwk42fb1uIwkHydeqTNyDTg0U5mPl6tUvLrE04JOVyvb7izrIcawbsOdlVr9ZFe1BM
         vVF7IuNo8qbgCRtJHiqEj3stZCei0DFnPrCzqX2vddBPS+V806VQ+7J33nAYyhtNmCTm
         +tTQ==
X-Gm-Message-State: AOAM533xpXAEDPxobF5A6dyFkSnm2MajnJvgQQ8YymGocnJ1C+86l6rQ
        eu6NKkNSI9Fny3xOvQtUDcILnkdmWvsE4AEEtEk=
X-Google-Smtp-Source: ABdhPJzjcDXqjDiVwePs6RWmQ2m0nC9cOSkJOppB6obNLed0lF8Z0BKVeL+nnn4RzMAIfSbou04RSJLenSxPM5ueKtI=
X-Received: by 2002:a25:c905:: with SMTP id z5mr6186821ybf.260.1613157772513;
 Fri, 12 Feb 2021 11:22:52 -0800 (PST)
MIME-Version: 1.0
References: <YCKB1TF5wz93EIBK@krava> <YCKlrLkTQXc4Cyx7@krava>
 <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava> <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava> <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava> <YCVIWzq0quDQm6bn@krava> <CAEf4Bzbt2-Mn4+y0c+sSZWUSrP705c_e3SxedjV_xYGPQL79=w@mail.gmail.com>
 <YCavItKm0mKxcVQD@krava>
In-Reply-To: <YCavItKm0mKxcVQD@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Feb 2021 11:22:41 -0800
Message-ID: <CAEf4BzaJkfVYLU+zA6kmJRNd5uqGyk2B8G6BT22pKjMt7RqpSg@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 8:39 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Feb 11, 2021 at 11:59:02AM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> >
> > So in my previous example I assumed we have address ranges for ftrace
> > section, which is exactly the opposite from what we have. So this
> > binary search should be a bit different. start <= addr seems wrong
> > here as well.
> >
> > The invariant here should be that addr[r] is the smallest address that
> > is >= than function start addr, right? Except the corner case where
> > there is no such r, but for that we have a final check in the return
> > below. If you wanted to use index l, you'd need to change the
> > invariant to find the largest addr, such that it is < end, but that
> > seems a bit convoluted.
> >
> > So, with that, I think it should be like this:
> >
> > size_t l = 0, r = count - 1, m;
> >
> > /* make sure we don't use invalid r */
> > if (count == 0) return false;
> >
> > while (l < r) {
> >     /* note no +1 in this case, it's so that at the end, when you
> >      * have, say, l = 0, and r = 1, you try l first, not r.
> >      * Otherwise you might end in in the infinite loop when r never == l.
> >      */
> >     m = l + (r - l) / 2;
> >     addr = addrs[m];
> >
> >     if (addr >= start)
> >         /* we satisfy invariant, so tighten r */
> >         r = m;
> >     else
> >         /* m is not good enough as l, maybe m + 1 will be */
> >         l = m + 1;
> > }
> >
> > return start <= addrs[r] && addrs[r] < end;
> >
> >
> > So, basically, r is maintained as a valid index always, while we
> > constantly try to tighten the l.
> >
> > Does this make sense?
>
> another take ;-)
>
> jirka
>
>
> ---
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..20a93ed60e52 100644
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
> @@ -44,7 +45,7 @@ static struct elf_function *functions;
>  static int functions_alloc;
>  static int functions_cnt;
>
> -static int functions_cmp(const void *_a, const void *_b)
> +static int functions_cmp_name(const void *_a, const void *_b)
>  {
>         const struct elf_function *a = _a;
>         const struct elf_function *b = _b;
> @@ -52,6 +53,16 @@ static int functions_cmp(const void *_a, const void *_b)
>         return strcmp(a->name, b->name);
>  }
>
> +static int functions_cmp_addr(const void *_a, const void *_b)
> +{
> +       const struct elf_function *a = _a;
> +       const struct elf_function *b = _b;
> +
> +       if (a->addr == b->addr)
> +               return 0;
> +       return a->addr < b->addr ? -1 : 1;
> +}
> +
>  static void delete_functions(void)
>  {
>         free(functions);
> @@ -98,6 +109,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
>
>         functions[functions_cnt].name = name;
>         functions[functions_cnt].addr = elf_sym__value(sym);
> +       functions[functions_cnt].size = elf_sym__size(sym);
>         functions[functions_cnt].sh_addr = sh.sh_addr;
>         functions[functions_cnt].generated = false;
>         functions_cnt++;
> @@ -236,6 +248,48 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
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
> @@ -267,7 +321,7 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>         }
>
>         qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> -       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
> +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);

All looks good except this. We don't rely on functions being sorted in
ascending start addr order, do we? If not, just drop this, no need to
slow down the process.

>
>         /*
>          * Let's got through all collected functions and filter
> @@ -275,18 +329,9 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
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
>
>                 /* Make sure function is within ftrace addresses. */
> -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> +               if (is_ftrace_func(func, addrs, count, kmod)) {
>                         /*
>                          * We iterate over sorted array, so we can easily skip
>                          * not valid item and move following valid field into
> @@ -303,6 +348,8 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>
>         if (btf_elf__verbose)
>                 printf("Found %d functions!\n", functions_cnt);
> +
> +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_name);
>         return 0;
>  }
>
> @@ -312,7 +359,7 @@ static struct elf_function *find_function(const struct btf_elf *btfe,
>         struct elf_function key = { .name = name };
>
>         return bsearch(&key, functions, functions_cnt, sizeof(functions[0]),
> -                      functions_cmp);
> +                      functions_cmp_name);
>  }
>
>  static bool btf_name_char_ok(char c, bool first)
>
