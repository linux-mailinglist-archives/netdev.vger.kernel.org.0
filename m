Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2626C31DADA
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 14:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhBQNl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 08:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbhBQNlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 08:41:35 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4121CC061574;
        Wed, 17 Feb 2021 05:40:55 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id u20so13810014iot.9;
        Wed, 17 Feb 2021 05:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=pKgWjzQAq28lvDOvKi+dr3hojkeveN9RkWtFUC/YxTg=;
        b=aXis/N7ExvV1mUsAQkufqpJiqw61UAZBbfugmBaLQx79RQo8SKaH1tJ/r8uIibxgSh
         E2dfQRhkrT0iBHxDy3xxH8AK61GQgsXXQIsbxdG0I20o/rAGeZ8gkFHsZlLOZ4wvas34
         FH/I5huKPO0k/xE307HIYsU5lDVBJijQuxHCohqjbao1gOKeI2TdtdJM2MLXj42oQCPa
         +/jgHCI4e5Ba8lU6eDh859ddrckmvqrGnfK3B+DNdK+b+sLdIGZxQ8B8EDY6BSkz86Nx
         RxRUJMbHyNryq76Qz49yD3ToxX10d0WpaTUY1PDVxlzasmnQXlOEh72A65HZj8HZ8Y5B
         JuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=pKgWjzQAq28lvDOvKi+dr3hojkeveN9RkWtFUC/YxTg=;
        b=UtP61OHDNeWU+oeBxdiJ6PKWTomVU+2geRjyDOnHXeoihvZ/Ew1t2FJNcguaXdq0zp
         ilRYuUjbqIGyNNbAeucaw2eY55e2ysqfvWCArYngvoC/pJrrcDsgX6P8qZdqkoKV72hq
         /nwtuhmBwVWFHq5byUscEFbB9tYXfg+FiS8J5kBXX+8bu21aEYUFAbA0f/5dFlKf91hL
         SRLDGZz+XsuA5ANx7A9w5HzxgvATSfbfSaTjwOz3mtRS2zEmXubUlMLZvLTPN/W+ob/I
         aI8bQwSvcDJ9QnUVWcgL9YLruuXdbYun3Dd2E8BuxpZl/vyFvMChf1BjufHga7gUu8Kb
         u4NA==
X-Gm-Message-State: AOAM532ZtFrGzi9fd3FphkMesXYU5dfB0xY4HtygKuxWnJwe9ItzaxhP
        yAU3/dPqPpr4p5388O5rBNKZ+DlKipsygTp9aCY=
X-Google-Smtp-Source: ABdhPJwYAGJBxU6M4LAOM7Jf2LTK4yz/LFnIA0a88PeeSPmrxPBNYPCA7H5x24wAZRIPmYkmycAaBqia8/nldHZUyBI=
X-Received: by 2002:a02:74a:: with SMTP id f71mr24205309jaf.30.1613569254517;
 Wed, 17 Feb 2021 05:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20210213164648.1322182-1-jolsa@kernel.org> <YC0Pmn0uwhHROsQd@kernel.org>
In-Reply-To: <YC0Pmn0uwhHROsQd@kernel.org>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 17 Feb 2021 14:40:43 +0100
Message-ID: <CA+icZUWBfwJ0WKQi7AO_dhcMpFWmo6riwszpmsZLfn1BwH_kyw@mail.gmail.com>
Subject: Re: [PATCHv2] btf_encoder: Match ftrace addresses within elf functions
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 1:44 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Sat, Feb 13, 2021 at 05:46:48PM +0100, Jiri Olsa escreveu:
> > Currently when processing DWARF function, we check its entrypoint
> > against ftrace addresses, assuming that the ftrace address matches
> > with function's entrypoint.
> >
> > This is not the case on some architectures as reported by Nathan
> > when building kernel on arm [1].
> >
> > Fixing the check to take into account the whole function not
> > just the entrypoint.
> >
> > Most of the is_ftrace_func code was contributed by Andrii.
>
> Applied locally, will go out after tests,
>

Hi Arnaldo,

Is it possible to have a pahole version 1.21 with this patch and the
one from Yonghong Son?

From my local pahole Git:

$ git log --oneline --no-merges v1.20..
2f83aefdbddf (for-1.20/btf_encoder-ftrace_elf-clang-jolsa-v2)
btf_encoder: Match ftrace addresses within elf functions
f21eafdfc877 (for-1.20/btf_encoder-sanitized_int-clang-yhs-v2)
btf_encoder: sanitize non-regular int base type

Both patches fixes all issues seen so far with LLVM/Clang >=
12.0.0-rc1 and DWARF-v5 and BTF (debug-info) and pahole on
Linux/x86_64 and according to Nathan on Linux/arm64.
Yesterday, I tried with LLVM/Clang 13-git from <apt.llvm.org>.

BTW, Nick's DWARF-v5 patches are pending in <kbuild.git#kbuild> (see [1]).

Personally, I can wait until [1] is in Linus Git.

Please, let me/us know what you are planning.
( I know it is Linux v5.12 merge-window. )

Thanks.

Regards,
- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/log/?h=kbuild

> - Arnaldo
>
> > [1] https://lore.kernel.org/bpf/20210209034416.GA1669105@ubuntu-m3-large-x86/
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> > v2 changes:
> >   - update functions addr directly [Andrii]
> >
> >  btf_encoder.c | 40 ++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 38 insertions(+), 2 deletions(-)
> >
> > diff --git a/btf_encoder.c b/btf_encoder.c
> > index b124ec20a689..80e896961d4e 100644
> > --- a/btf_encoder.c
> > +++ b/btf_encoder.c
> > @@ -36,6 +36,7 @@ struct funcs_layout {
> >  struct elf_function {
> >       const char      *name;
> >       unsigned long    addr;
> > +     unsigned long    size;
> >       unsigned long    sh_addr;
> >       bool             generated;
> >  };
> > @@ -98,6 +99,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
> >
> >       functions[functions_cnt].name = name;
> >       functions[functions_cnt].addr = elf_sym__value(sym);
> > +     functions[functions_cnt].size = elf_sym__size(sym);
> >       functions[functions_cnt].sh_addr = sh.sh_addr;
> >       functions[functions_cnt].generated = false;
> >       functions_cnt++;
> > @@ -236,6 +238,39 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
> >       return 0;
> >  }
> >
> > +static int is_ftrace_func(struct elf_function *func, __u64 *addrs, __u64 count)
> > +{
> > +     __u64 start = func->addr;
> > +     __u64 addr, end = func->addr + func->size;
> > +
> > +     /*
> > +      * The invariant here is addr[r] that is the smallest address
> > +      * that is >= than function start addr. Except the corner case
> > +      * where there is no such r, but for that we have a final check
> > +      * in the return.
> > +      */
> > +     size_t l = 0, r = count - 1, m;
> > +
> > +     /* make sure we don't use invalid r */
> > +     if (count == 0)
> > +             return false;
> > +
> > +     while (l < r) {
> > +             m = l + (r - l) / 2;
> > +             addr = addrs[m];
> > +
> > +             if (addr >= start) {
> > +                     /* we satisfy invariant, so tighten r */
> > +                     r = m;
> > +             } else {
> > +                     /* m is not good enough as l, maybe m + 1 will be */
> > +                     l = m + 1;
> > +             }
> > +     }
> > +
> > +     return start <= addrs[r] && addrs[r] < end;
> > +}
> > +
> >  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >  {
> >       __u64 *addrs, count, i;
> > @@ -283,10 +318,11 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >                * functions[x]::addr is relative address within section
> >                * and needs to be relocated by adding sh_addr.
> >                */
> > -             __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> > +             if (kmod)
> > +                     func->addr += func->sh_addr;
> >
> >               /* Make sure function is within ftrace addresses. */
> > -             if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> > +             if (is_ftrace_func(func, addrs, count)) {
> >                       /*
> >                        * We iterate over sorted array, so we can easily skip
> >                        * not valid item and move following valid field into
> > --
> > 2.29.2
> >
>
> --
>
> - Arnaldo
