Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC4B319560
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhBKVsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:48:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhBKVsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613080042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=erw+oRuJIWU+Lcuv3JLHAsQxLRO/3TX9GolXrQOQEC8=;
        b=e/kMwIxt1LT2y4a50ozM+nE4lfHO0TUrXc1UdkefuJatTp5IaTiOkwbhh3ujOQ/tk2zziD
        MV67GGx3X2QBKuCsEn4aZJGqw+nWHLbbDKF2Ot5iBlGX5Q9q30YwwwzbfmP/PfrXeJ4Nkt
        DLMVni8eaVadhIq0WoxMk7a66akt2IQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-vAjmXrMBMfm9GakvVaaAHQ-1; Thu, 11 Feb 2021 16:47:20 -0500
X-MC-Unique: vAjmXrMBMfm9GakvVaaAHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03B541937FD2;
        Thu, 11 Feb 2021 21:47:10 +0000 (UTC)
Received: from krava (unknown [10.40.192.118])
        by smtp.corp.redhat.com (Postfix) with SMTP id 86E2D6F99D;
        Thu, 11 Feb 2021 21:47:06 +0000 (UTC)
Date:   Thu, 11 Feb 2021 22:47:05 +0100
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
Message-ID: <YCWl2YHTSZSRkiQW@krava>
References: <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava>
 <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava>
 <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava>
 <YCVIWzq0quDQm6bn@krava>
 <CAEf4Bzbt2-Mn4+y0c+sSZWUSrP705c_e3SxedjV_xYGPQL79=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbt2-Mn4+y0c+sSZWUSrP705c_e3SxedjV_xYGPQL79=w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:59:02AM -0800, Andrii Nakryiko wrote:

SNIP

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
> > @@ -236,6 +248,40 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
> >         return 0;
> >  }
> >
> > +static int is_ftrace_func(struct elf_function *func, __u64 *addrs,
> 
> return bool, not int?

yep

> 
> > +                         __u64 count, bool kmod)
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
> > +       __u64 end   = kmod ? func->end + func->sh_addr : func->end;
> > +
> > +       size_t l = 0, r = count - 1, m;
> > +       __u64 addr = 0;
> > +
> > +       while (l < r) {
> > +               m = l + (r - l + 1) / 2;
> > +               addr = addrs[m];
> > +
> > +               if (start <= addr && addr < end)
> > +                       return true;
> 
> this extra check on each step shouldn't be necessary
> 
> > +
> > +               if (start <= addr)
> 
> I don't think this is correct, start == addr is actually a good case,
> but you'll do r = m - 1, skipping it. See below about invariants.

the == case is covered in the check above, but yes it should be <

> 
> > +                       r = m - 1;
> > +               else
> > +                       l = m;
> 
> So in my previous example I assumed we have address ranges for ftrace
> section, which is exactly the opposite from what we have. So this
> binary search should be a bit different. start <= addr seems wrong
> here as well.
> 
> The invariant here should be that addr[r] is the smallest address that
> is >= than function start addr, right? Except the corner case where
> there is no such r, but for that we have a final check in the return
> below. If you wanted to use index l, you'd need to change the
> invariant to find the largest addr, such that it is < end, but that
> seems a bit convoluted.
> 
> So, with that, I think it should be like this:
> 
> size_t l = 0, r = count - 1, m;
> 
> /* make sure we don't use invalid r */
> if (count == 0) return false;
> 
> while (l < r) {
>     /* note no +1 in this case, it's so that at the end, when you
>      * have, say, l = 0, and r = 1, you try l first, not r.
>      * Otherwise you might end in in the infinite loop when r never == l.
>      */

nice catch, did not see that

>     m = l + (r - l) / 2;
>     addr = addrs[m];
> 
>     if (addr >= start)
>         /* we satisfy invariant, so tighten r */
>         r = m;
>     else
>         /* m is not good enough as l, maybe m + 1 will be */
>         l = m + 1;
> }
> 
> return start <= addrs[r] && addrs[r] < end;
> 
> 
> So, basically, r is maintained as a valid index always, while we
> constantly try to tighten the l.
> 
> Does this make sense?

I did not see the possibility to let the search go through
all the way to l == r and that 'extra' check allowed me to split
the interval, without caring about invariant

but I think your solution is cleaner, I'll send new version

> 
> 
> > +       }
> > +
> > +       addr = addrs[l];
> > +       return start <= addr && addr < end;
> > +}
> > +
> >  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >  {
> >         __u64 *addrs, count, i;
> > @@ -267,7 +313,7 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >         }
> >
> >         qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> > -       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
> > +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);
> 
> See below assumptions about function end. If we get it from ELF, you
> don't need to do this extra sort, right?

I had the same assumption and was surprised why my code is not working ;-)

> 
> >
> >         /*
> >          * Let's got through all collected functions and filter
> > @@ -275,18 +321,12 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >          */
> >         for (i = 0; i < functions_cnt; i++) {
> >                 struct elf_function *func = &functions[i];
> > -               /*
> > -                * For vmlinux image both addrs[x] and functions[x]::addr
> > -                * values are final address and are comparable.
> > -                *
> > -                * For kernel module addrs[x] is final address, but
> > -                * functions[x]::addr is relative address within section
> > -                * and needs to be relocated by adding sh_addr.
> > -                */
> > -               __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> > +
> > +               if (i + 1 < functions_cnt)
> > +                       func->end = functions[i + 1].addr;
> 
> This makes a bunch of unnecessary assumptions about functions layout.
> But why, if we have STT_FUNC symbol with function size, so that we
> know the function end right when we collect function info.

ugh forgot about the st_size for STT_FUNC

thanks,
jirka

