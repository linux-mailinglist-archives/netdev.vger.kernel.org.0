Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324213193C6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 21:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhBKUAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 15:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhBKT7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 14:59:55 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A49C061574;
        Thu, 11 Feb 2021 11:59:14 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id i71so6798335ybg.7;
        Thu, 11 Feb 2021 11:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hPbSRc+yRT2VXhtKVtD9k+7CT69OWN/HR+DyRaSYA0=;
        b=YeORjITVFhpK4QDANTfn/sir7PlNKveXr/tz7+BR35vxW5yUj7K2z/H2omhTTP9goz
         Zb5STTrgRUorksDAMuabStmkgTreK/lUzdANrVu9ff/s/5TPx3p7N9GzP1HS7kn4Kj60
         UXY9yT3s2M+ev5ZB88hT0hEWG26p4tp04czjlD8RUMz9JpxrqGazj85eA3JGGYKWN99X
         9QNWJoj5030d6apaSULrDG2gPEzt4nRe7NBbDoVTZbv1A/pgWxrCDEQ9NFoiUFUhO3bc
         kfEMf5L8m2pDVMyRAzrtqfmBUGmYpqOPvdg8zef+MaVRXjn4GSS2B9U3aZ2q1yRYyTDq
         ziiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2hPbSRc+yRT2VXhtKVtD9k+7CT69OWN/HR+DyRaSYA0=;
        b=He+2bu6P/fNy05K1C44/a4DqAeXBaD1zu4FXG3M83p9Tgr2zykCwAiPac52vgdUrl8
         PL//OM0FnFyKnS2S4yGdnPDu41oC1Y4AT0pxewhuWjtDocQvBWZTllQQmELbqLdBrITH
         Wv729aC1v7dzREBZZjtI+DTPkPiE69Zb1KJ+3Mtqi8xu8pAcdS6vJFj20EC5HO9TvcUF
         XSE6aEm50FOj/W5vpTuJfRTpGG8XIoeLB2cGTjhZI7X3uF1Va44oL62l9wy7RMiX7TFc
         uFfCJfI9mtWpBZjVd+dDiUhjK/cw/1ufoLnooMBG8RTxyvGbnZupi12bmtLUOvc7Vxvz
         Et/A==
X-Gm-Message-State: AOAM5310kTRMof4FCJ1XIHPNwQ5L2eVJmv783ROU8yQQcEnBd3iujCwm
        k+vPix9gzDUMoKnDbXfLfLjDuD0V5lwB1W+Q374=
X-Google-Smtp-Source: ABdhPJw7UznPJOcOaq25UJGSJ17zvGMiXUNJzZhGVwqpjfi8yU0tBgYj5F6mUpzqFsSgexSYijqUb5oPRwbzL0GKJu0=
X-Received: by 2002:a25:9882:: with SMTP id l2mr13043250ybo.425.1613073553551;
 Thu, 11 Feb 2021 11:59:13 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava> <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava> <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava> <YCVIWzq0quDQm6bn@krava>
In-Reply-To: <YCVIWzq0quDQm6bn@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Feb 2021 11:59:02 -0800
Message-ID: <CAEf4Bzbt2-Mn4+y0c+sSZWUSrP705c_e3SxedjV_xYGPQL79=w@mail.gmail.com>
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

On Thu, Feb 11, 2021 at 7:08 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Feb 10, 2021 at 09:13:47PM +0100, Jiri Olsa wrote:
> > On Wed, Feb 10, 2021 at 10:20:20AM -0800, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > > but below is change for checking that ftrace addrs are within elf functions
> > > >
> > > > seems to work in my tests, I'll run some more tests and send full patch
> > >
> > > It seems unnecessarily convoluted. I was thinking about something like
> > > this (the diff will totally be screwed up by gmail, and I haven't even
> > > compiled it):
> > >
> > > diff --git a/btf_encoder.c b/btf_encoder.c
> > > index b124ec20a689..8162b238bd43 100644
> > > --- a/btf_encoder.c
> > > +++ b/btf_encoder.c
> > > @@ -236,6 +236,23 @@ get_kmod_addrs(struct btf_elf *btfe, __u64
> > > **paddrs, __u64 *pcount)
> > >         return 0;
> > >  }
> > >
> > > +struct func_seg { __u64 start; __u64 end; };
> > > +
> > > +static int func_exists(struct func_seg *segs, size_t len, __u64 addr)
> > > +{
> > > +       size_t l = 0, r = len - 1, m;
> > > +
> > > +       while (l < r) {
> > > +               m = l + (r - l + 1) / 2;
> > > +               if (segs[m].start <= addr)
> > > +                       l = m;
> > > +               else
> > > +                       r = m - 1;
> > > +       }
> > > +
> > > +       return segs[l].start <= addr && addr < segs[l].end;
> > > +}
> > > +
> > >  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> > >  {
> > >         __u64 *addrs, count, i;
> > > @@ -286,7 +303,7 @@ static int setup_functions(struct btf_elf *btfe,
> > > struct funcs_layout *fl)
> > >                 __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> > >
> > >                 /* Make sure function is within ftrace addresses. */
> > > -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> > > +               if (func_exists(addrs, count, addr))
> >
> > you pass addrs in here, but you mean func_seg array
> > filled with elf functions start/end values, right?
> >
> > >                         /*
> > >                          * We iterate over sorted array, so we can easily skip
> > >                          * not valid item and move following valid field into
> > >
> > >
> > > So the idea is to use address segments and check whether there is a
> > > segment that overlaps with a given address by first binary searching
> > > for a segment with the largest starting address that is <= addr. And
> > > then just confirming that segment does overlap with the requested
> > > address.
> > >
> > > WDYT?
>
> heya,
> with your approach I ended up with change below, it gives me same
> results as with the previous change
>
> I think I'll separate the kmod bool address computation later on,
> but I did not want to confuse this change for now
>
> jirka
>
>
> ---
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..34df08f2fb4e 100644
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
> @@ -236,6 +248,40 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
>         return 0;
>  }
>
> +static int is_ftrace_func(struct elf_function *func, __u64 *addrs,

return bool, not int?

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
> +       __u64 end   = kmod ? func->end + func->sh_addr : func->end;
> +
> +       size_t l = 0, r = count - 1, m;
> +       __u64 addr = 0;
> +
> +       while (l < r) {
> +               m = l + (r - l + 1) / 2;
> +               addr = addrs[m];
> +
> +               if (start <= addr && addr < end)
> +                       return true;

this extra check on each step shouldn't be necessary

> +
> +               if (start <= addr)

I don't think this is correct, start == addr is actually a good case,
but you'll do r = m - 1, skipping it. See below about invariants.

> +                       r = m - 1;
> +               else
> +                       l = m;

So in my previous example I assumed we have address ranges for ftrace
section, which is exactly the opposite from what we have. So this
binary search should be a bit different. start <= addr seems wrong
here as well.

The invariant here should be that addr[r] is the smallest address that
is >= than function start addr, right? Except the corner case where
there is no such r, but for that we have a final check in the return
below. If you wanted to use index l, you'd need to change the
invariant to find the largest addr, such that it is < end, but that
seems a bit convoluted.

So, with that, I think it should be like this:

size_t l = 0, r = count - 1, m;

/* make sure we don't use invalid r */
if (count == 0) return false;

while (l < r) {
    /* note no +1 in this case, it's so that at the end, when you
     * have, say, l = 0, and r = 1, you try l first, not r.
     * Otherwise you might end in in the infinite loop when r never == l.
     */
    m = l + (r - l) / 2;
    addr = addrs[m];

    if (addr >= start)
        /* we satisfy invariant, so tighten r */
        r = m;
    else
        /* m is not good enough as l, maybe m + 1 will be */
        l = m + 1;
}

return start <= addrs[r] && addrs[r] < end;


So, basically, r is maintained as a valid index always, while we
constantly try to tighten the l.

Does this make sense?


> +       }
> +
> +       addr = addrs[l];
> +       return start <= addr && addr < end;
> +}
> +
>  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  {
>         __u64 *addrs, count, i;
> @@ -267,7 +313,7 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>         }
>
>         qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> -       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
> +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);

See below assumptions about function end. If we get it from ELF, you
don't need to do this extra sort, right?

>
>         /*
>          * Let's got through all collected functions and filter
> @@ -275,18 +321,12 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
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
> +
> +               if (i + 1 < functions_cnt)
> +                       func->end = functions[i + 1].addr;

This makes a bunch of unnecessary assumptions about functions layout.
But why, if we have STT_FUNC symbol with function size, so that we
know the function end right when we collect function info.

>
>                 /* Make sure function is within ftrace addresses. */
> -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> +               if (is_ftrace_func(func, addrs, count, kmod)) {
>                         /*
>                          * We iterate over sorted array, so we can easily skip
>                          * not valid item and move following valid field into
> @@ -303,6 +343,8 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>
>         if (btf_elf__verbose)
>                 printf("Found %d functions!\n", functions_cnt);
> +
> +       qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_name);
>         return 0;
>  }
>
> @@ -312,7 +354,7 @@ static struct elf_function *find_function(const struct btf_elf *btfe,
>         struct elf_function key = { .name = name };
>
>         return bsearch(&key, functions, functions_cnt, sizeof(functions[0]),
> -                      functions_cmp);
> +                      functions_cmp_name);
>  }
>
>  static bool btf_name_char_ok(char c, bool first)
>
