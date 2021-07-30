Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3FE3DBDAD
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhG3RYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG3RYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:24:54 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C525EC06175F;
        Fri, 30 Jul 2021 10:24:49 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id g76so17204624ybf.4;
        Fri, 30 Jul 2021 10:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bmb9EdWI6i/F5TlygeZvpTKTNwNJ5JcjLeJNhgb3CPw=;
        b=Jrf5/it2QZBRYAm9pE489VZv7NkWaHHosqg6SZw+xX5PTdofO/EzZGzi9T++0osCiM
         H/n13DCEVgSlsX0gveSLpQtPulrYLorTQZYOPS2Ha8SzFCTX1PRMK+UA7f7lEocFyELe
         FXq28ZccnEIbBhYXsFClAcyxxpF/rAK7GYkLgLrSPkh01JHZIlL6Q1pvvVgCk/K3rgW6
         +xQaT1CaaOTG15uJuTjyfzSyFQWCgAlI1SpgurrZBOegUDY4tQts9+UxcjX6/n6IHBGe
         rEsbxFB79+B0KXP7ChtaXxZzrMbPJTWZ2SWtv+SQTSDmew/e4aEdR+clcIOS/Lpn1Zvw
         OSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bmb9EdWI6i/F5TlygeZvpTKTNwNJ5JcjLeJNhgb3CPw=;
        b=Z33NIVOQtPhlOryCpcP29SJMaD9BROGRbdugrHh9qzg3rbM2FRo1TzqBke7I0XL3bP
         qwSl+BmtVUI+ZMmU1DpWlKxNZMe9bdL8wpguWHzZeJhoS3A/pSM6znLVKksHl2mexnMI
         3M+32uDw9SPqASB3BLeNCw5BDJL/SkTbvK0s3vTR27Ht7Lr+C6ibVkzR2FSX8RotYH2v
         QlFts/2dEMFYMuLVj7KeJDD51wa/GN5lRls31aTjMUvnKPtf4oktQ4zCdH9HWAXXsG0m
         7MXAWGLFbVJv0eRC7W4JiVAHnVQjL1KDIDbhlMXErVSgcLbdUBlOuIkoUUPUT7U58i8Y
         DJrA==
X-Gm-Message-State: AOAM53260vgs4L8erGrAROb++ITZ+Ia67E1xQvxuVPL3uja8QTxQxYXX
        SKErX4c70hwUdQ1X8arrW3+PCdyYxNL7y/xZTpI=
X-Google-Smtp-Source: ABdhPJxh+ysByQewmkd/sX5zE14R6pUkzf9oqKklC829TmWk+lwifcbdCj5MNJFc7PMZp7xMpRezXMGC65w9DaTC/kc=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr4455377ybf.425.1627665889010;
 Fri, 30 Jul 2021 10:24:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162028.29512-1-quentin@isovalent.com> <CAEf4BzbrQOr8Z2oiywT-zPBEz9jbP9_6oJXOW28LdOaqAy8pLw@mail.gmail.com>
 <22d59def-51e7-2b98-61b6-b700e7de8ef6@isovalent.com>
In-Reply-To: <22d59def-51e7-2b98-61b6-b700e7de8ef6@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 10:24:38 -0700
Message-ID: <CAEf4BzbjN+zjio3HPRkGLRgZpbLj9MUGLnXt1KDSsoOHB8_v3Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/8] libbpf: rename btf__get_from_id() and
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

On Fri, Jul 30, 2021 at 8:23 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-29 17:31 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Thu, Jul 29, 2021 at 9:20 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> As part of the effort to move towards a v1.0 for libbpf [0], this set
> >> improves some confusing function names related to BTF loading from and to
> >> the kernel:
> >>
> >> - btf__load() becomes btf__load_into_kernel().
> >> - btf__get_from_id becomes btf__load_from_kernel_by_id().
> >> - A new version btf__load_from_kernel_by_id_split() extends the former to
> >>   add support for split BTF.
> >>
> >> The old functions are marked for deprecation for the next minor version
> >> (0.6) of libbpf.
> >>
> >> The last patch is a trivial change to bpftool to add support for dumping
> >> split BTF objects by referencing them by their id (and not only by their
> >> BTF path).
> >>
> >> [0] https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
> >>
> >> v3:
> >> - Use libbpf_err_ptr() in btf__load_from_kernel_by_id(), ERR_PTR() in
> >>   bpftool's get_map_kv_btf().
> >> - Move the definition of btf__load_from_kernel_by_id() closer to the
> >>   btf__parse() group in btf.h (move the legacy function with it).
> >> - Fix a bug on the return value in libbpf_find_prog_btf_id(), as a new
> >>   patch.
> >> - Move the btf__free() fixes to their own patch.
> >> - Add "Fixes:" tags to relevant patches.
> >> - Re-introduce deprecation (removed in v2) for the legacy functions, as a
> >>   new macro LIBBPF_DEPRECATED_SINCE(major, minor, message).
> >>
> >> v2:
> >> - Remove deprecation marking of legacy functions (patch 4/6 from v1).
> >> - Make btf__load_from_kernel_by_id{,_split}() return the btf struct, adjust
> >>   surrounding code and call btf__free() when missing.
> >> - Add new functions to v0.5.0 API (and not v0.6.0).
> >>
> >> Quentin Monnet (8):
> >>   libbpf: return non-null error on failures in libbpf_find_prog_btf_id()
> >>   libbpf: rename btf__load() as btf__load_into_kernel()
> >>   libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
> >>   tools: free BTF objects at various locations
> >>   tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
> >>   libbpf: prepare deprecation of btf__get_from_id(), btf__load()
> >>   libbpf: add split BTF support for btf__load_from_kernel_by_id()
> >>   tools: bpftool: support dumping split BTF by id
> >>
> >>  tools/bpf/bpftool/btf.c                      |  8 ++---
> >>  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
> >>  tools/bpf/bpftool/map.c                      | 14 ++++-----
> >>  tools/bpf/bpftool/prog.c                     | 29 +++++++++++------
> >>  tools/lib/bpf/Makefile                       |  3 ++
> >>  tools/lib/bpf/btf.c                          | 33 ++++++++++++++------
> >>  tools/lib/bpf/btf.h                          |  7 ++++-
> >>  tools/lib/bpf/libbpf.c                       | 11 ++++---
> >>  tools/lib/bpf/libbpf.map                     |  3 ++
> >>  tools/lib/bpf/libbpf_common.h                | 19 +++++++++++
> >>  tools/perf/util/bpf-event.c                  | 11 ++++---
> >>  tools/perf/util/bpf_counter.c                | 12 +++++--
> >>  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
> >>  13 files changed, 113 insertions(+), 47 deletions(-)
> >>
> >> --
> >> 2.30.2
> >>
> >
> > I dropped patch #7 with deprecations and LIBBPF_DEPRECATED_SINCE and
> > applied to bpf-next.
> >
> > Current LIBBPF_DEPRECATED_SINCE approach doesn't work (and you should
> > have caught this when you built selftests/bpf, what happened there?).
> > bpftool build generates warnings like this:
> >
> > In file included from /data/users/andriin/linux/tools/lib/bpf/libbpf.h:20,
> >                  from xlated_dumper.c:10:
> > /data/users/andriin/linux/tools/lib/bpf/libbpf_common.h:22:23:
> > warning: "LIBBPF_MAJOR_VERSION" is not defined, evaluates to 0
> > [-Wundef]
> >   __LIBBPF_GET_VERSION(LIBBPF_MAJOR_VERSION, LIBBPF_MINOR_VERSION)
> >                        ^~~~~~~~~~~~~~~~~~~~
>
> Apologies, I didn't realise the change would impact external applications.

It doesn't matter, we expect everyone to compile selftest (just `make`
in tools/testing/selftests/bpf) and run at least test_progs,
preferably also test_maps and test_verifier. Especially with vmtest.sh
script it's quite simple (once you get latest Clang and pahole
compiled locally). We obviously have CI and maintainers as the last
line of defense, but that should be the last line of defense, not the
main line :)

>
> >
> > And it makes total sense. LIBBPF_DEPRECATED_SINCE() assumes
> > LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION is defined at compilation
> > time of the *application that is using libbpf*, not just libbpf's
> > compilation time. And that's clearly a bogus assumption which we can't
> > and shouldn't make. The right approach will be to define
> > LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION in some sort of
> > auto-generated header, included from libbpf_common.h and installed as
> > part of libbpf package.
>
> So generating this header is easy. Installing it with the other headers
> is simple too. It becomes a bit trickier when we build outside of the
> directory (it seems I need to pass -I$(OUTPUT) to build libbpf).

Not sure why using the header is tricky. We auto-generate
bpf_helper_defs.h, which is included from bpf_helpers.h, which is
included in every single libbpf-using application. Works good with no
extra magic.

>
> The step I'm most struggling with at the moment is bpftool, which
> bootstraps a first version of itself before building libbpf, by looking
> at the headers directly in libbpf's directory. It means that the
> generated header with the version number has not yet been generated. Do
> you think it is worth changing bpftool's build steps to implement this
> deprecation helper?

If it doesn't do that already, bpftool should do `make install` for
libbpf, not just build. Install will put all the headers, generated or
otherwise, into a designated destination folder, which should be
passed as -I parameter. But that should be already happening due to
bpf_helper_defs.h.

>
> Alternatively, wouldn't it make more sense to have a script in the
> GitHub repo for libbpf, and to run it once during the release process of
> a new version to update, say, the version number, or even the
> deprecation status directly?

I'd like to avoid extra manual steps that I or someone else will
definitely forget from time to time. Again, taking bpf_helper_defs.h
as a precedent. In the kernel repo we auto-generate it during build.
But when we sync libbpf to Github, we copy and check-in
bpf_helper_defs.h, so it's always available there (and will get
installed on `make install` or during packaging). We should do the
same for this new header (libbpf_version.h?).

>
> >
> > Anyways, I've removed all the LIBBPF_DEPRECATED_SINCE stuff and
> > applied all the rest, as it looks good and is a useful addition.
>
> Thanks.
> Quentin
