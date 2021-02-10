Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B381F317102
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhBJUPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:15:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232633AbhBJUPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:15:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612988034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F8qPD5DmBym140GmfNF1grPRmnSGg7P4Xsc0eTmldHE=;
        b=D5qiBQ48RuO/+Skve4raz4q60NeMfmUluX2UlNyF/5SmbWicPe0pladhAHRoniY+sEU+Xi
        wIun3JX57dO7X9usAdGzdWQBrMfPlOiwQckIIikFqNJ4eO/5mdehWTkAOfiDcsLqzdj6dq
        KbenCDLG4VHEJYttushYnkhKpn5g7tU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-iC_hdPsLNaufqMXmbgQzow-1; Wed, 10 Feb 2021 15:13:50 -0500
X-MC-Unique: iC_hdPsLNaufqMXmbgQzow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D622384E240;
        Wed, 10 Feb 2021 20:13:47 +0000 (UTC)
Received: from krava (unknown [10.40.195.206])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5E5C119D7C;
        Wed, 10 Feb 2021 20:13:44 +0000 (UTC)
Date:   Wed, 10 Feb 2021 21:13:43 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <YCQ+d0CVgIclDwng@krava>
References: <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava>
 <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava>
 <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 10:20:20AM -0800, Andrii Nakryiko wrote:

SNIP

> > but below is change for checking that ftrace addrs are within elf functions
> >
> > seems to work in my tests, I'll run some more tests and send full patch
> 
> It seems unnecessarily convoluted. I was thinking about something like
> this (the diff will totally be screwed up by gmail, and I haven't even
> compiled it):
> 
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

you pass addrs in here, but you mean func_seg array
filled with elf functions start/end values, right?

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

I liked the approach below because it got rid of that bsearch ;-)

but yea, yours seems to be less code chage and staighforward

jirka

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

