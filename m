Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD34317006
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhBJTWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbhBJTVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 14:21:54 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1066AC06174A;
        Wed, 10 Feb 2021 11:21:14 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id o7so2940850ils.2;
        Wed, 10 Feb 2021 11:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wo8F814c8Q1U970iuYblzGo07tu6wvImEWEKpDE13NA=;
        b=YG1Myj5bgQ3dUuhYAYcWj8PN+Y/+3OGMYVtGeeLbyDMP2ywkO8p2pPW7OdUTSzEQax
         2zbp56TmVr75PV3kxTrcLe00BUM2XXHNCNQUrjJyUmOuPgYHE0QFFFNqJir/PbzSO2pG
         qCtIEX99qFBjo99h+iaUJK5hXq1XbM4Bu6FC6H+WIwhuHDgkiEM89k/+YreQXEa9JETD
         dJlpj16aWoWeFngyEG05REhOeGa4Lxa+Rw+djmpbnsWARhaHeylEPBpokI4/6vC5SSdL
         OW8WZzfUy2F/iYDEXXPBX9wQCRPlE0AHdRNPrxmEkdS25SWRmi281th1ng6Zf7/OHbZY
         OxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wo8F814c8Q1U970iuYblzGo07tu6wvImEWEKpDE13NA=;
        b=gGrGtrTIqy73hGhA2gmWn1du1JoPLNFKbJ6iTzKvVEJSZ4VAEzTabIhdzcm4O47xAu
         WxHSk0aSazubUzmif/G62s1j1eiTUe1AcGDvUQpwIQebUNI2za4sWjOq19JY2D6HSaMa
         mSSZqbw/KCb/CWxU7nnrVq6Dr/Bs1f9uHWt12xnD/StRfppq+tT6OfJ4GGo/2ICCCViz
         4xs7hcIj1HukWT1MF7P6+CEgSIFkty8/g43UTVDg89M4x7TwfyX6gQuWlDjNo8BZGjkp
         Jki2XVWi0PvsgDukNgJcm+j4BQG1UPp1afudlMsYexbpyKofOJuvoja/d0VViaWFHkUv
         DR+Q==
X-Gm-Message-State: AOAM530LdDZ8f4DwT1hd+lvtkVFo0R+Cc6VHWkySCXNDrxjNRpfl2mRY
        Gofqk6M7g0p2kJOIoSj2uXur/FogMDs3W6+IOGg=
X-Google-Smtp-Source: ABdhPJyYqHP2/5bgacYgQAx4tK2s6yx4xvaYPulD2xJznZlEub4vW3MMj2MYZXl6CuKegqeNgJglxdBJ8mXg47mdBqw=
X-Received: by 2002:a92:c269:: with SMTP id h9mr2341665ild.239.1612984873509;
 Wed, 10 Feb 2021 11:21:13 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava> <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava> <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQvuy7m1TJigtaa@krava>
In-Reply-To: <YCQvuy7m1TJigtaa@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 11:21:02 -0800
Message-ID: <CAEf4BzZPw_0GTvJzW4yWBijqcd9dNcye3XuG01ZRKQEb4mVSHQ@mail.gmail.com>
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

On Wed, Feb 10, 2021 at 11:11 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Feb 10, 2021 at 10:20:20AM -0800, Andrii Nakryiko wrote:
> > On Wed, Feb 10, 2021 at 5:26 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Tue, Feb 09, 2021 at 02:00:29PM -0800, Andrii Nakryiko wrote:
> > >
> > > SNIP
> > >
> > > > > > > I'm still trying to build the kernel.. however ;-)
> > > > > > >
> > > > > > > patch below adds the ftrace check only for static functions
> > > > > > > and lets the externa go through.. but as you said, in this
> > > > > > > case we'll need to figure out the 'notrace' and other checks
> > > > > > > ftrace is doing
> > > > > > >
> > > > > > > jirka
> > > > > > >
> > > > > > >
> > > > > > > ---
> > > > > > > diff --git a/btf_encoder.c b/btf_encoder.c
> > > > > > > index b124ec20a689..4d147406cfa5 100644
> > > > > > > --- a/btf_encoder.c
> > > > > > > +++ b/btf_encoder.c
> > > > > > > @@ -734,7 +734,7 @@ int cu__encode_btf(struct cu *cu, int verbose, bool force,
> > > > > > >                         continue;
> > > > > > >                 if (!has_arg_names(cu, &fn->proto))
> > > > > > >                         continue;
> > > > > > > -               if (functions_cnt) {
> > > > > > > +               if (!fn->external && functions_cnt) {
> > > > > >
> > > > > > I wouldn't trust DWARF, honestly. Wouldn't checking GLOBAL vs LOCAL
> > > > > > FUNC ELF symbol be more reliable?
> > > > >
> > > > > that'd mean extra bsearch on each processed function,
> > > > > on the ther hand, we'are already slow ;-) I'll check
> > > > > how big the slowdown would be
> > > > >
> > > >
> > > > We currently record addresses and do binary search. Now we need to
> > > > record address + size and still do binary search with a slightly
> > > > different semantics (find closest entry >= addr). Then just check that
> > > > it overlaps, taking into account the length of the function code. It
> > > > shouldn't result in a noticeable slowdown. Might be actually faster,
> > > > because we might avoid callback function call costs.
> > >
> > > I'm still not sure how to handle the external check for function via elf,
> >
> > I might be missing something, but don't all functions have
> > corresponding ELF symbols? And then symbol can have LOCAL or GLOBAL
> > type. LOCALs are supposed to be not visible outside respective CUs (so
> > correspond to static functions), while GLOBALs are extern-able funcs.
> > So if func's symbol is GLOBAL, it should be ok to assume it's
> > attachable (not inlined, at least).
>
> sure I know where the info is, I was just hesitating to add another bsearch
>
> anyway, I checked the BTF data before and after this change (the dwarf check above)
> and it looks like there are many global functions that are not attachable
>
> attaching diff of BTF functions below - before (.old) and after (.new) adding
> all external functions.. all added (+) functions are external and do not have
> ftrace address - I verified some of them in disassembly and they are not attachable
>
> I think we should check ftrace addresses also for global functions
>
> I'm of course assuming BTF should have only attachable functions


Oh, ok, I didn't realize so many functions are not attachable. Yeah,
let's not do anything special for GLOBALs, given we are fixing the
ftrace addr search anyway.

>
> jirka
>
>
> ---
> --- /tmp/pahole.test.PbD/funcs-vmlinux-x86-gcc-1.old    2021-02-10 19:51:44.727865204 +0100
> +++ /tmp/pahole.test.PbD/funcs-vmlinux-x86-gcc-1.new    2021-02-10 19:51:44.836865827 +0100
> @@ -1662,6 +1662,7 @@

[...]
