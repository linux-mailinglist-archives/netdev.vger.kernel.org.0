Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3ACF316EA2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhBJS3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhBJSZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:25:35 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD507C06178B;
        Wed, 10 Feb 2021 10:24:52 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id q9so2767244ilo.1;
        Wed, 10 Feb 2021 10:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=oDJTdkdJJ7mBLZJmwXA5rlxyJMiuDx1sqSvJMOpL9yI=;
        b=axrnrRsMR6GPSnfE1ztyIKwtVIY/jj3CskFWDA4l68najWxv9DijoYPsqziWIr+7aZ
         FhWbujq/xWOuAlXkXxvve8mVhy6unBKaZVwsFeURNpqmChfoQzIzQMoEqQ4LRzr7OCKf
         MOn93VOyAGvqDJu9a6dvF+oEkdnDD37eQ7y4SJpuwjLstN3UKFp5oXRfYOzO8wZo+PzO
         rpBZRAzKCSCAAZ7rp195+/uJb3LDu853pYd/oXSry9YofHI7bvgelIpPgYgGszKOBaxH
         BdPyqH7ErVxYBQ75Sp0NFGHdA4QrMdluKgo42bDVh4mMiZa89buMJwvVy2gdIF0SsDR9
         3E7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=oDJTdkdJJ7mBLZJmwXA5rlxyJMiuDx1sqSvJMOpL9yI=;
        b=Fopqo6lIyaJzZdEmgNekw/MjUhIPqNmL8CTqWG8SexDdwt3NjQrhX65qjJvRxewjFv
         X9gyLVhsm78iestUhAIG8AH9Uid5cfCphCnJDeELkkJlmv9WrrC2JAWMt0YAWsR++Wd3
         887twCBpZa3jHVK8YOkHEOuVs4QtkgxtnxfMI7ntAT/JGiq7VFUN6cRlMVOPMvg28k65
         3Lcpd3GeUQbTd5JxiAIqYVouZVwkqs6v9hnEaloopZTynIcs48gBGT/Hy/Bn0zZy36kt
         3kDXKFjcty8qw7nvCT7Nva17o/bwewiA9rq/S8ShVF0Xpgmej4/U+/uShLsV1Slm7ROg
         sF+A==
X-Gm-Message-State: AOAM5311fuE2sC4vaindNFTVLmN+PtpJHNKJRE3PErwGkODFRBVsY6cq
        KhcF8WlenvljHwlfh4KEE+mvxqop4fyr7FW/1cz1rApkNXURxw==
X-Google-Smtp-Source: ABdhPJwU0hdNaDARCTYv+SThcMpopiO5ZOh0LQfDZHUwO5jC6VuDOmw/1fJNm+GcZNcu3qQF9nTvSZQiJSjawdHJsnI=
X-Received: by 2002:a05:6e02:4c9:: with SMTP id f9mr2221507ils.186.1612981492049;
 Wed, 10 Feb 2021 10:24:52 -0800 (PST)
MIME-Version: 1.0
References: <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava> <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava> <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
In-Reply-To: <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 10 Feb 2021 19:24:47 +0100
Message-ID: <CA+icZUVPQxPkhGetNzZgbfkq+XNPpws8W_TD8A_V5ounJqdDqA@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
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

On Wed, Feb 10, 2021 at 7:20 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Feb 10, 2021 at 5:26 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Feb 09, 2021 at 02:00:29PM -0800, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > > > > I'm still trying to build the kernel.. however ;-)
> > > > > >
> > > > > > patch below adds the ftrace check only for static functions
> > > > > > and lets the externa go through.. but as you said, in this
> > > > > > case we'll need to figure out the 'notrace' and other checks
> > > > > > ftrace is doing
> > > > > >
> > > > > > jirka
> > > > > >
> > > > > >
> > > > > > ---
> > > > > > diff --git a/btf_encoder.c b/btf_encoder.c
> > > > > > index b124ec20a689..4d147406cfa5 100644
> > > > > > --- a/btf_encoder.c
> > > > > > +++ b/btf_encoder.c
> > > > > > @@ -734,7 +734,7 @@ int cu__encode_btf(struct cu *cu, int verbose, bool force,
> > > > > >                         continue;
> > > > > >                 if (!has_arg_names(cu, &fn->proto))
> > > > > >                         continue;
> > > > > > -               if (functions_cnt) {
> > > > > > +               if (!fn->external && functions_cnt) {
> > > > >
> > > > > I wouldn't trust DWARF, honestly. Wouldn't checking GLOBAL vs LOCAL
> > > > > FUNC ELF symbol be more reliable?
> > > >
> > > > that'd mean extra bsearch on each processed function,
> > > > on the ther hand, we'are already slow ;-) I'll check
> > > > how big the slowdown would be
> > > >
> > >
> > > We currently record addresses and do binary search. Now we need to
> > > record address + size and still do binary search with a slightly
> > > different semantics (find closest entry >= addr). Then just check that
> > > it overlaps, taking into account the length of the function code. It
> > > shouldn't result in a noticeable slowdown. Might be actually faster,
> > > because we might avoid callback function call costs.
> >
> > I'm still not sure how to handle the external check for function via elf,
>
> I might be missing something, but don't all functions have
> corresponding ELF symbols? And then symbol can have LOCAL or GLOBAL
> type. LOCALs are supposed to be not visible outside respective CUs (so
> correspond to static functions), while GLOBALs are extern-able funcs.
> So if func's symbol is GLOBAL, it should be ok to assume it's
> attachable (not inlined, at least).
>
> > but below is change for checking that ftrace addrs are within elf functions
> >
> > seems to work in my tests, I'll run some more tests and send full patch
>
> It seems unnecessarily convoluted. I was thinking about something like
> this (the diff will totally be screwed up by gmail, and I haven't even
> compiled it):
>

Now, I know why vfs_truncate is so problematic.
Let's split it: "vfs + trunc + ate".
Eaten by Gmail :-).

- Sedat -


> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..8162b238bd43 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -236,6 +236,23 @@ get_kmod_addrs(struct btf_elf *btfe, __u64
> **paddrs, __u64 *pcount)
>         return 0;
>  }
>
> +struct func_seg { __u64 start; __u64 end; };
> +
> +static int func_exists(struct func_seg *segs, size_t len, __u64 addr)
> +{
> +       size_t l = 0, r = len - 1, m;
> +
> +       while (l < r) {
> +               m = l + (r - l + 1) / 2;
> +               if (segs[m].start <= addr)
> +                       l = m;
> +               else
> +                       r = m - 1;
> +       }
> +
> +       return segs[l].start <= addr && addr < segs[l].end;
> +}
> +
>  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  {
>         __u64 *addrs, count, i;
> @@ -286,7 +303,7 @@ static int setup_functions(struct btf_elf *btfe,
> struct funcs_layout *fl)
>                 __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
>
>                 /* Make sure function is within ftrace addresses. */
> -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> +               if (func_exists(addrs, count, addr))
>                         /*
>                          * We iterate over sorted array, so we can easily skip
>                          * not valid item and move following valid field into
>
>
> So the idea is to use address segments and check whether there is a
> segment that overlaps with a given address by first binary searching
> for a segment with the largest starting address that is <= addr. And
> then just confirming that segment does overlap with the requested
> address.
>
> WDYT?
>
> >
> > jirka
> >
> >
> > ---
> > diff --git a/btf_encoder.c b/btf_encoder.c
> > index b124ec20a689..548a12847f99 100644
> > --- a/btf_encoder.c
> > +++ b/btf_encoder.c
> > @@ -36,6 +36,7 @@ struct funcs_layout {
> >  struct elf_function {
> >         const char      *name;
> >         unsigned long    addr;
> > +       unsigned long    end;
> >         unsigned long    sh_addr;
> >         bool             generated;
> >  };
> > @@ -44,7 +45,7 @@ static struct elf_function *functions;
> >  static int functions_alloc;
> >  static int functions_cnt;
> >
> > -static int functions_cmp(const void *_a, const void *_b)
> > +static int functions_cmp_name(const void *_a, const void *_b)
> >  {
> >         const struct elf_function *a = _a;
> >         const struct elf_function *b = _b;
> > @@ -52,6 +53,16 @@ static int functions_cmp(const void *_a, const void *_b)
> >         return strcmp(a->name, b->name);
> >  }
> >
> > +static int functions_cmp_addr(const void *_a, const void *_b)
> > +{
> > +       const struct elf_function *a = _a;
> > +       const struct elf_function *b = _b;
> > +
> > +       if (a->addr == b->addr)
> > +               return 0;
> > +       return a->addr < b->addr ? -1 : 1;
> > +}
> > +
> >  static void delete_functions(void)
> >  {
> >         free(functions);
> > @@ -98,6 +109,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
> >
> >         functions[functions_cnt].name = name;
> >         functions[functions_cnt].addr = elf_sym__value(sym);
> > +       functions[functions_cnt].end = (__u64) -1;
> >         functions[functions_cnt].sh_addr = sh.sh_addr;
> >         functions[functions_cnt].generated = false;
> >         functions_cnt++;
> > @@ -236,9 +248,25 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
> >         return 0;
> >  }
> >
> > +static bool is_addr_in_func(__u64 addr, struct elf_function *func, bool kmod)
> > +{
> > +       /*
> > +        * For vmlinux image both addrs[x] and functions[x]::addr
> > +        * values are final address and are comparable.
> > +        *
> > +        * For kernel module addrs[x] is final address, but
> > +        * functions[x]::addr is relative address within section
> > +        * and needs to be relocated by adding sh_addr.
> > +        */
> > +       __u64 start = kmod ? func->addr + func->sh_addr : func->addr;
> > +       __u64 end = kmod ? func->end+ func->sh_addr : func->end;
> > +
> > +       return start <= addr && addr < end;
> > +}
> > +
> >  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >  {
> > -       __u64 *addrs, count, i;
> > +       __u64 *addrs, count, i_func, i_addr;
> >         int functions_valid = 0;
> >         bool kmod = false;
> >
> > @@ -266,43 +294,62 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >                 return 0;
> >         }
> >
> > -       qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> > -       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
> > -
> >         /*
> > -        * Let's got through all collected functions and filter
> > -        * out those that are not in ftrace.
> > +        * Sort both functions and addrs so we can iterate
> > +        * both of them simultaneously and found matching
> > +        * func/addr pairs.
> >          */
> > -       for (i = 0; i < functions_cnt; i++) {
> > -               struct elf_function *func = &functions[i];
> > -               /*
> > -                * For vmlinux image both addrs[x] and functions[x]::addr
> > -                * values are final address and are comparable.
> > -                *
> > -                * For kernel module addrs[x] is final address, but
> > -                * functions[x]::addr is relative address within section
> > -                * and needs to be relocated by adding sh_addr.
> > -                */
> > -               __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> > +       qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> > +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);
> > +
> > +       for (i_func = 0, i_addr = 0; i_func < functions_cnt; i_func++) {
> > +               struct elf_function *func = &functions[i_func];
> > +
> > +               if (i_func + 1 < functions_cnt)
> > +                       func->end = functions[i_func + 1].addr;
> > +
> > +               for (; i_addr < count; i_addr++) {
> > +                       __u64 addr = addrs[i_addr];
> > +
> > +                       /* Functions are  ahead, catch up with addrs. */
> > +                       if (addr < func->addr)
> > +                               continue;
> > +
> > +                       /* Addr is within function - mark function as valid. */
> > +                       if (is_addr_in_func(addr, func, kmod)) {
> > +                               /*
> > +                                * We iterate over sorted array, so we can easily skip
> > +                                * not valid item and move following valid field into
> > +                                * its place, and still keep the 'new' array sorted.
> > +                                */
> > +                               if (i_func != functions_valid)
> > +                                       functions[functions_valid] = functions[i_func];
> > +                               functions_valid++;
> > +                               i_addr++;
> > +                       }
> >
> > -               /* Make sure function is within ftrace addresses. */
> > -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> >                         /*
> > -                        * We iterate over sorted array, so we can easily skip
> > -                        * not valid item and move following valid field into
> > -                        * its place, and still keep the 'new' array sorted.
> > +                        * Addrs are ahead, catch up with functions, or we just
> > +                        * found valid function and want to move to another.
> >                          */
> > -                       if (i != functions_valid)
> > -                               functions[functions_valid] = functions[i];
> > -                       functions_valid++;
> > +                       break;
> >                 }
> >         }
> >
> > +       if (btf_elf__verbose) {
> > +               printf("Found %d functions out of %d symbols and %llu ftrace addresses.\n",
> > +                       functions_valid, functions_cnt, count);
> > +       }
> > +
> >         functions_cnt = functions_valid;
> >         free(addrs);
> >
> > -       if (btf_elf__verbose)
> > -               printf("Found %d functions!\n", functions_cnt);
> > +       /*
> > +        * And finaly sort 'valid' functions by name,
> > +        * so find_function can be used.
> > +        */
> > +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_name);
> > +
> >         return 0;
> >  }
> >
> > @@ -312,7 +359,7 @@ static struct elf_function *find_function(const struct btf_elf *btfe,
> >         struct elf_function key = { .name = name };
> >
> >         return bsearch(&key, functions, functions_cnt, sizeof(functions[0]),
> > -                      functions_cmp);
> > +                      functions_cmp_name);
> >  }
> >
> >  static bool btf_name_char_ok(char c, bool first)
> >
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAEf4BzbzquqsA5%3D_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w%40mail.gmail.com.
