Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA232316E87
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhBJSZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhBJSWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:22:53 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AF7C0613D6;
        Wed, 10 Feb 2021 10:20:32 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id q12so809543ybm.8;
        Wed, 10 Feb 2021 10:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XUbrz/8xxXdqtk8DEEenUBbYYKqni3z7WGyd8h4oZBY=;
        b=J9eWa3RpkQaebDbcQKNXKnSBZqx9C75YjbJL8V6IyuhI5IBc4sTEyLvG+Nj2s2h1QI
         jhSEzgvIgVKtaIT4ag2tUySMoC4aVWxS74EsSqS32UDeowmR9ZQEhGxvnfv7QJG6mige
         RY25Kww5WvRQPeKxDoL20fTVYAAEJTq30YXM+OdQnflpknrIAObdQSWoFn+flzdyrUlg
         s4H11eYWGl5GQ0L9Cq8kGhJ+3H7t2MJtcbY353U/H38Zg6UvHhwVQeoT+kqAT3EftkrG
         B/71zNBuxzjdUeqpCYrtFxZ8APFory4XbdMdJRayFbDKGHqodnc/5JAnY5ErdqZUQdzP
         zPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XUbrz/8xxXdqtk8DEEenUBbYYKqni3z7WGyd8h4oZBY=;
        b=f2kvlMi9zca9fAY0iM5uT2hAa3cq/CJ786hhvxb8j9OTwRzWGCi7Yxnog3JQB5whgW
         lw1bDZQc9/no2kZ55hA+X7nAreeUx9oN3cP6jbjvPDv/qaMep8qTBg9y2/JHQtGE/hk+
         Dzkfl2EbWgbC822I4SDkHBwGYrNnFIl/CVub8uHk+vRhmJxiYNoAQ/+afeF9M8ZuQJhJ
         V6DtHf42RXOeyMJ9SCqIayx21knz5nbl6namVCs7SzooGM9TikafDN7AwjxnnFd/UG4d
         p6h8w+ApTyTYTzN6SwRJojJj7yHj6sSOwQoUAgXXE8wtO7b5MLqrSm3pfnrhTU7dLfCG
         bKYA==
X-Gm-Message-State: AOAM531p2yzc0BzOBrKh9EzVS4F8X4uxSfRQKYzdZCH17ipB2m0MECmM
        e5gdbZkWCsdQZuF41TcHKqDO4klRNJf8API0NGoLkBCHNUTqaw==
X-Google-Smtp-Source: ABdhPJzXyCnLbaMkBV2vpG2T7RtKv6hUcKpEzK48FT2v3pKmRsOpbI15DIMcznlQz8LOFKHrvlh+XtO4P2b/cknanIc=
X-Received: by 2002:a25:c905:: with SMTP id z5mr5909207ybf.260.1612981231520;
 Wed, 10 Feb 2021 10:20:31 -0800 (PST)
MIME-Version: 1.0
References: <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava> <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava>
In-Reply-To: <YCPfEzp3ogCBTBaS@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 10:20:20 -0800
Message-ID: <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
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

On Wed, Feb 10, 2021 at 5:26 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Feb 09, 2021 at 02:00:29PM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > > > > I'm still trying to build the kernel.. however ;-)
> > > > >
> > > > > patch below adds the ftrace check only for static functions
> > > > > and lets the externa go through.. but as you said, in this
> > > > > case we'll need to figure out the 'notrace' and other checks
> > > > > ftrace is doing
> > > > >
> > > > > jirka
> > > > >
> > > > >
> > > > > ---
> > > > > diff --git a/btf_encoder.c b/btf_encoder.c
> > > > > index b124ec20a689..4d147406cfa5 100644
> > > > > --- a/btf_encoder.c
> > > > > +++ b/btf_encoder.c
> > > > > @@ -734,7 +734,7 @@ int cu__encode_btf(struct cu *cu, int verbose, bool force,
> > > > >                         continue;
> > > > >                 if (!has_arg_names(cu, &fn->proto))
> > > > >                         continue;
> > > > > -               if (functions_cnt) {
> > > > > +               if (!fn->external && functions_cnt) {
> > > >
> > > > I wouldn't trust DWARF, honestly. Wouldn't checking GLOBAL vs LOCAL
> > > > FUNC ELF symbol be more reliable?
> > >
> > > that'd mean extra bsearch on each processed function,
> > > on the ther hand, we'are already slow ;-) I'll check
> > > how big the slowdown would be
> > >
> >
> > We currently record addresses and do binary search. Now we need to
> > record address + size and still do binary search with a slightly
> > different semantics (find closest entry >= addr). Then just check that
> > it overlaps, taking into account the length of the function code. It
> > shouldn't result in a noticeable slowdown. Might be actually faster,
> > because we might avoid callback function call costs.
>
> I'm still not sure how to handle the external check for function via elf,

I might be missing something, but don't all functions have
corresponding ELF symbols? And then symbol can have LOCAL or GLOBAL
type. LOCALs are supposed to be not visible outside respective CUs (so
correspond to static functions), while GLOBALs are extern-able funcs.
So if func's symbol is GLOBAL, it should be ok to assume it's
attachable (not inlined, at least).

> but below is change for checking that ftrace addrs are within elf functions
>
> seems to work in my tests, I'll run some more tests and send full patch

It seems unnecessarily convoluted. I was thinking about something like
this (the diff will totally be screwed up by gmail, and I haven't even
compiled it):

diff --git a/btf_encoder.c b/btf_encoder.c
index b124ec20a689..8162b238bd43 100644
--- a/btf_encoder.c
+++ b/btf_encoder.c
@@ -236,6 +236,23 @@ get_kmod_addrs(struct btf_elf *btfe, __u64
**paddrs, __u64 *pcount)
        return 0;
 }

+struct func_seg { __u64 start; __u64 end; };
+
+static int func_exists(struct func_seg *segs, size_t len, __u64 addr)
+{
+       size_t l = 0, r = len - 1, m;
+
+       while (l < r) {
+               m = l + (r - l + 1) / 2;
+               if (segs[m].start <= addr)
+                       l = m;
+               else
+                       r = m - 1;
+       }
+
+       return segs[l].start <= addr && addr < segs[l].end;
+}
+
 static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
 {
        __u64 *addrs, count, i;
@@ -286,7 +303,7 @@ static int setup_functions(struct btf_elf *btfe,
struct funcs_layout *fl)
                __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;

                /* Make sure function is within ftrace addresses. */
-               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
+               if (func_exists(addrs, count, addr))
                        /*
                         * We iterate over sorted array, so we can easily skip
                         * not valid item and move following valid field into


So the idea is to use address segments and check whether there is a
segment that overlaps with a given address by first binary searching
for a segment with the largest starting address that is <= addr. And
then just confirming that segment does overlap with the requested
address.

WDYT?

>
> jirka
>
>
> ---
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..548a12847f99 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -36,6 +36,7 @@ struct funcs_layout {
>  struct elf_function {
>         const char      *name;
>         unsigned long    addr;
> +       unsigned long    end;
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
> +       functions[functions_cnt].end = (__u64) -1;
>         functions[functions_cnt].sh_addr = sh.sh_addr;
>         functions[functions_cnt].generated = false;
>         functions_cnt++;
> @@ -236,9 +248,25 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
>         return 0;
>  }
>
> +static bool is_addr_in_func(__u64 addr, struct elf_function *func, bool kmod)
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
> +       __u64 end = kmod ? func->end+ func->sh_addr : func->end;
> +
> +       return start <= addr && addr < end;
> +}
> +
>  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  {
> -       __u64 *addrs, count, i;
> +       __u64 *addrs, count, i_func, i_addr;
>         int functions_valid = 0;
>         bool kmod = false;
>
> @@ -266,43 +294,62 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>                 return 0;
>         }
>
> -       qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> -       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
> -
>         /*
> -        * Let's got through all collected functions and filter
> -        * out those that are not in ftrace.
> +        * Sort both functions and addrs so we can iterate
> +        * both of them simultaneously and found matching
> +        * func/addr pairs.
>          */
> -       for (i = 0; i < functions_cnt; i++) {
> -               struct elf_function *func = &functions[i];
> -               /*
> -                * For vmlinux image both addrs[x] and functions[x]::addr
> -                * values are final address and are comparable.
> -                *
> -                * For kernel module addrs[x] is final address, but
> -                * functions[x]::addr is relative address within section
> -                * and needs to be relocated by adding sh_addr.
> -                */
> -               __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> +       qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);
> +
> +       for (i_func = 0, i_addr = 0; i_func < functions_cnt; i_func++) {
> +               struct elf_function *func = &functions[i_func];
> +
> +               if (i_func + 1 < functions_cnt)
> +                       func->end = functions[i_func + 1].addr;
> +
> +               for (; i_addr < count; i_addr++) {
> +                       __u64 addr = addrs[i_addr];
> +
> +                       /* Functions are  ahead, catch up with addrs. */
> +                       if (addr < func->addr)
> +                               continue;
> +
> +                       /* Addr is within function - mark function as valid. */
> +                       if (is_addr_in_func(addr, func, kmod)) {
> +                               /*
> +                                * We iterate over sorted array, so we can easily skip
> +                                * not valid item and move following valid field into
> +                                * its place, and still keep the 'new' array sorted.
> +                                */
> +                               if (i_func != functions_valid)
> +                                       functions[functions_valid] = functions[i_func];
> +                               functions_valid++;
> +                               i_addr++;
> +                       }
>
> -               /* Make sure function is within ftrace addresses. */
> -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
>                         /*
> -                        * We iterate over sorted array, so we can easily skip
> -                        * not valid item and move following valid field into
> -                        * its place, and still keep the 'new' array sorted.
> +                        * Addrs are ahead, catch up with functions, or we just
> +                        * found valid function and want to move to another.
>                          */
> -                       if (i != functions_valid)
> -                               functions[functions_valid] = functions[i];
> -                       functions_valid++;
> +                       break;
>                 }
>         }
>
> +       if (btf_elf__verbose) {
> +               printf("Found %d functions out of %d symbols and %llu ftrace addresses.\n",
> +                       functions_valid, functions_cnt, count);
> +       }
> +
>         functions_cnt = functions_valid;
>         free(addrs);
>
> -       if (btf_elf__verbose)
> -               printf("Found %d functions!\n", functions_cnt);
> +       /*
> +        * And finaly sort 'valid' functions by name,
> +        * so find_function can be used.
> +        */
> +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_name);
> +
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
