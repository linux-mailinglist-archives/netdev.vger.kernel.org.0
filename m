Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C8B3D98DE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhG1W3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG1W3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:29:35 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21128C061757;
        Wed, 28 Jul 2021 15:29:32 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x192so6717145ybe.0;
        Wed, 28 Jul 2021 15:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fHvjSU6A/A/tr+gPQptlB2SWGj1sGblRzSgZshCcQOo=;
        b=JQjz90RmV7aN27g1GPoEeRUhhN6avPW3Pw/vubleWcZRjCnDqoLGK8uPEExoSapnaJ
         dGDP2OoBx+lKqQDKJzKWTaWnlUGJw+k9NuDxSsavNOom+aukMyObe3mSM4/aeI6rIiDx
         uNQXasjATmG2YAn7XIXOuugm7dZ/GPxdchsQRSFK8CL/r50j+Knw/yhJE0QcMN7pPR/K
         Z7sCCE4heb5SRdCXh02sf76GKPF4MOlhB8jgZ42JyMpsuGoCIvm2L07eHMd8YbwZ/zas
         YKn6LBkYfQYuZ4v0hMjG4V7y94iA9YPFrLgWnz4v3NBYUkODMOph7ItssGdv9Tuhp0Yv
         1+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fHvjSU6A/A/tr+gPQptlB2SWGj1sGblRzSgZshCcQOo=;
        b=Fvfz1nifGBaWqDRH3xnSXEFREf4mRi3y3aCo/GNAqmkrHJPeAsHq2Hu6u4PH/Bu2WZ
         rNz40I+doBLPdPDrPauzYb5T0PuiDDWCL+Gy0sss6GTXYRvRk5oPw4AJWPoatrCWpj2d
         iD4DfpeaA7GEjmHZZsIo6Wi4YdLjl1ElKmPUflakwjF9wUxvo032o/v0qCxvckgwzahu
         PZz0ZfShGlQm/CDW0Z31UM1kePnboMV6s6T8G/NsYe1CHy1GTpu7NAfMDzWI6bNWsVB2
         a5onwncqC2Lk5n67SP8xBPtSoVpB/VjpwYCoCVORTD/aR3hLTEgOGg6qM0a2i4X03Bhl
         c/WA==
X-Gm-Message-State: AOAM533xgXTIXvNruPYEMVWonJ3+4hAM7X4ppAYmv+xYtyIJ+6AU6KUV
        nY0m5n1WZOsHWYqWRjLbMT0kayOjPUXcKF3MPPE=
X-Google-Smtp-Source: ABdhPJxG6Djkv6N25OH46FcBQXbxjX6Rdhezm/hkYTFSGuT9+amg1u1l/RtqS2/EtwJeaBrTiJyKLdwKsSsSAtNXPd8=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr2489823ybf.425.1627511371351;
 Wed, 28 Jul 2021 15:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <CAEf4Bzb30BNeLgio52OrxHk2VWfKitnbNUnO0sAXZTA94bYfmg@mail.gmail.com>
 <CAEf4BzZZXx28w1y_6xfsue91c_7whvHzMhKvbSnsQRU4yA+RwA@mail.gmail.com>
 <82e61e60-e2e9-f42d-8e49-bbe416b7513d@isovalent.com> <CAEf4BzYpCr=Vdfc3moaapQqBxYV3SKfD72s0F=FAh_zLzSqxqA@mail.gmail.com>
 <bb0d3640-c6da-a802-4794-50cd033119ac@isovalent.com> <CAEf4BzZ8wXhpRwPkBmH3i94oVea2BucC56PCK-0j4N_3gk29Ng@mail.gmail.com>
 <CACdoK4+HCt6+70rKsWuwqMkuOGGcUPCgretnVp430gb_mWpUQw@mail.gmail.com>
In-Reply-To: <CACdoK4+HCt6+70rKsWuwqMkuOGGcUPCgretnVp430gb_mWpUQw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Jul 2021 15:29:20 -0700
Message-ID: <CAEf4Bzbt9vXEYeaSYfbnYrRW_MPOaRxqjpQj_6_5NUMCLOzUYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 2:54 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Tue, 27 Jul 2021 at 21:49, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > > >>>
> > > >>> LIBBPF_DEPRECATED_SINCE(0, 6, "API that will be marked deprecated in v0.6")
> > >
> > > So I've been looking into this, and it's not _that_ simple to do. Unless
> > > I missed something about preprocessing macros, I cannot bake a "#if" in
> > > a "#define", to have the attribute printed if and only if the current
> > > version is >= 0.6 in this example.
> > >
> > > I've come up with something, but it is not optimal because I have to
> > > write a check and macros for each version number used with the
> > > LIBBPF_DEPRECATED_SINCE macro. If we really wanted to automate that part
> > > I guess we could generate a header with those macros from the Makefile
> > > and include it in libbpf_common.h, but that does not really look much
> > > cleaner to me.
> >
> > Yeah, let's not add unnecessary code generation. It sucks, of course,
> > that we can't do #ifdef inside a macro :(
> >
> > So it's either do something like what you did with defining
> > version-specific macros, which is actually not too bad, because it's
> > not like we have tons of those versions anyways.
> >
> > LIBBPF_DEPRECATED_SINCE(0, 6, "use btf__load_from_kernel_by_id instead")
> > LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> >
> > Alternatively, we can go with:
> >
> > #if LIBBPF_AT_OR_NEWER(0, 6)
> > LIBBPF_DEPRECATED("use btf__load_from_kernel_by_id instead")
> > #endif
> > LIBBPF API int btf__get_from_id(__u32 id, struct btf **btf);
> >
> > I don't really dislike the second variant too much either, but
> > LIBBPF_DEPRECATED_SINCE() reads nicer. Let's go with that. See some
> > comments below about implementation.
>
> Ok.
>
> >
> > >
> > > Here's my current code, below - does it correspond to what you had in
> > > mind? Or did you think of something else?
> > >
> > > ------
> > >
> > > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > > index ec14aa725bb0..095d5dc30d50 100644
> > > --- a/tools/lib/bpf/Makefile
> > > +++ b/tools/lib/bpf/Makefile
> > > @@ -8,6 +8,7 @@ LIBBPF_VERSION := $(shell \
> > >         grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
> > >         sort -rV | head -n1 | cut -d'_' -f2)
> > >  LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
> > > +LIBBPF_MINOR_VERSION := $(firstword $(subst ., ,$(subst $(LIBBPF_MAJOR_VERSION)., ,$(LIBBPF_VERSION))))
> >
> > Given all this is for internal use, I'd instead define something like
> > __LIBBPF_CURVER as an integer that is easy to compare against:
> >
> > #define __LIBBPF_CURVER (LIBBPF_MAJOR_VERSION * 100 +
> > LIBBPF_MINOR_VERSION) * 100 + LIBBPF_PATCH_VERSION
> >
> > That will simplify some stuff below and is generally easier to use in
> > code, if we will need this somewhere to use explicitly.
>
> Did you mean computing __LIBBPF_CURVER in the Makefile, or in the
> header?

I was thinking Makefile, but if it's simpler to do in the header
that's fine as well.

>
> I can do that if you want, although I'm not convinced it will simplify
> much. Instead of having one long-ish condition, we'll have to compute
> the integer for the current version, as well as for each of the versions
> that we list for deprecating functions. I suppose I can add another
> dedicated macro.

feels like if we need to do some comparisons, then writing

#if __LIBBPF_VER > 102
/* do something */
#endif

is much simpler than comparing MAJOR_VERSION and MINOR_VERSION
separately. It's just that currently with 0 major version it might
look a bit awkward right now, but that's temporary.

>
> Do you actually want the patch version? I chose to leave it aside
> because 1) I thought it would not be relevant for deprecating symbols,
> and 2) if anything like a -rc1 suffix is ever appended to the version,
> it makes it more complex to parse from the version string.

yeah, you are probably right. major  and minor should be enough

>
> >
> > >
> > >  MAKEFLAGS += --no-print-directory
> > >
> > > @@ -86,6 +87,8 @@ override CFLAGS += -Werror -Wall
> > >  override CFLAGS += $(INCLUDES)
> > >  override CFLAGS += -fvisibility=hidden
> > >  override CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
> > > +override CFLAGS += -DLIBBPF_MAJOR_VERSION=$(LIBBPF_MAJOR_VERSION)
> > > +override CFLAGS += -DLIBBPF_MINOR_VERSION=$(LIBBPF_MINOR_VERSION)
> > >
> > >  # flags specific for shared library
> > >  SHLIB_FLAGS := -DSHARED -fPIC
> > > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > > index cf8490f95641..8b6b5442dbd8 100644
> > > --- a/tools/lib/bpf/btf.h
> > > +++ b/tools/lib/bpf/btf.h
> > > @@ -45,7 +45,8 @@ LIBBPF_API struct btf *btf__parse_raw(const char *path);
> > >  LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
> > >  LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
> > >  LIBBPF_API struct btf *btf__load_from_kernel_by_id_split(__u32 id, struct btf *base_btf);
> > > -LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> > > +LIBBPF_API LIBBPF_DEPRECATED_SINCE(0, 6, "use btf__load_from_kernel_by_id instead")
> >
> > nit: given how long those deprecations will be, let's keep them at a
> > separate (first) line and keep LIBBPF_API near the function
> > declaration itself
>
> I thought having the LIBBPF_API on a separate line would slightly reduce
> the risk, when moving lines around, to move the function prototype but
> not the deprecation attribute. But ok, fine.

highly improbable and then we'll most probably catch it during build anyways

>
> >
> > > +int btf__get_from_id(__u32 id, struct btf **btf);
> > >
> > >  LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
> > >  LIBBPF_API int btf__load(struct btf *btf);
> > > diff --git a/tools/lib/bpf/libbpf_common.h b/tools/lib/bpf/libbpf_common.h
> > > index 947d8bd8a7bb..9ba9f8135dc8 100644
> > > --- a/tools/lib/bpf/libbpf_common.h
> > > +++ b/tools/lib/bpf/libbpf_common.h
> > > @@ -17,6 +17,28 @@
> > >
> > >  #define LIBBPF_DEPRECATED(msg) __attribute__((deprecated(msg)))
> > >
> > > +#ifndef LIBBPF_DEPRECATED_SINCE
> >
> > why #ifndef conditional?
>
> Right, we don't expect to have the macro defined elsewhere. I'll remove
> it.
>
> >
> > > +#define __LIBBPF_VERSION_CHECK(major, minor) \
> > > +       LIBBPF_MAJOR_VERSION > major || \
> > > +               (LIBBPF_MAJOR_VERSION == major && LIBBPF_MINOR_VERSION >= minor)
> >
> > so we don't need this if we do __LIBBPF_CURVER
>
> Right, but we do need to compute an integer for each of the versions
> listed below (0.6 for now). I'll see if I can come up with something
> short.

see above, I'd just do 102 etc. I wonder if 006 will be treated as an
octal number, in that case probably fine to do just 6. Or we can have
a small macro for this, of course. Don't know, doesn't seem to matter
all that much

>
> >
> > > +
> > > +/* Add checks for other versions below when planning deprecation of API symbols
> > > + * with the LIBBPF_DEPRECATED_SINCE macro.
> > > + */
> > > +#if __LIBBPF_VERSION_CHECK(0, 6)
> > > +#define __LIBBPF_MARK_DEPRECATED_0_6(X) X
> > > +#else
> > > +#define __LIBBPF_MARK_DEPRECATED_0_6(X)
> > > +#endif
> > > +
> > > +#define __LIBBPF_DEPRECATED_SINCE(major, minor, msg) \
> > > +       __LIBBPF_MARK_DEPRECATED_ ## major ## _ ## minor (LIBBPF_DEPRECATED("v" # major "." # minor "+, " msg))
> > > +
> > > +/* Mark a symbol as deprecated when libbpf version is >= {major}.{minor} */
> > > +#define LIBBPF_DEPRECATED_SINCE(major, minor, msg) \
> > > +       __LIBBPF_DEPRECATED_SINCE(major, minor, msg)
> >
> > Is it needed for some macro value concatenation magic to have this
> > nested __LIBBPF_DEPRECATED_SINCE?
>
> I double-checked (I needed to, anyway), and it seems not. It's a
> leftover from an earlier version of my code, I'll clean it up before
> the proper submission.

ok, thanks

>
> Thanks!
> Quentin
