Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C398CA81
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 06:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfHNEpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 00:45:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46611 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfHNEpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 00:45:38 -0400
Received: by mail-qt1-f196.google.com with SMTP id j15so15253542qtl.13;
        Tue, 13 Aug 2019 21:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98xq8329bTHRildDsFE2k7X/t3b61IFPuYv4iGex6Dk=;
        b=KzYADkwJeilGXkmK1b7cjNNRBbWoYRDnz/c3gbInfedl6M8P31uk0Z8eaOERmPlyCS
         DEGXnzhURGyrKyz0TycMfzVIxlV2AL5U4przJVpuhLD0KsQkgbQWHa27Jt6sxT87UQji
         LrVi0b+Ct2NEilrujqQcfR3ArWnxja/xctVuImvyj024ipMSIiEIrAU63OZfOP/mzYZU
         CSCGX/TGtIqdPoRCS4m8QuI+ro6makjV6Skt0a0CDliUW0uRJqqB9VR73NK6vTfm5/97
         S8YuyWXArzvSK5MVP/dyI5cbsLlYjtps4wFgTvxu40WTPwJyW4Liz86bKUsizpp2sP8g
         IHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98xq8329bTHRildDsFE2k7X/t3b61IFPuYv4iGex6Dk=;
        b=W+GuvPml2fRjWDxs/DEVnRiwBTRl2s1U5DB8u7fUeCI29r2o7mZa65tcW9diwP6kQx
         ommeFXBLgwqNTJsn6sZgByD8j55hmODyJ8yULom3CmJShacNtSiMxzhKfQqv6pLzquOv
         ed+OYiZXmPfqnZ8//Cuiw9q0nNcuiRLbdmrAMG8cIZIWQvphmUjfb7KJdBtDUGbjT878
         NdRZolpcYpjbiyBGH4LzGChpzED76zzC9UhEx9XnNssD59J+sBmseQDi5HSBQ0HRrprr
         atud7ErI5GqTURBjzB76/FT4dTCFW+knr4A7GIOMvB1om3EUr3FUYLzV2ppoUPEtpEOQ
         dSDQ==
X-Gm-Message-State: APjAAAWsyoQ/ZmyhIk+Qn3MdcozB02KTd9LVqTXy7Neu8lgU2g0iMa2z
        54uM07JA6kNu6f18/9Jn/sr522VcfLJAHbA8YL8=
X-Google-Smtp-Source: APXvYqzHdR6cVftaCMGb4sUI+B9mxfX2y6Lx34FSOZMPGW7gKVwSjjmbcaDyUv9rhW27ZOgGN2k6b0s8tE9IibsAD4A=
X-Received: by 2002:ac8:6688:: with SMTP id d8mr11064134qtp.141.1565757936812;
 Tue, 13 Aug 2019 21:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190813232408.1246694-1-andriin@fb.com> <20190814002824.GA29281@rdna-mbp>
In-Reply-To: <20190814002824.GA29281@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Aug 2019 21:45:25 -0700
Message-ID: <CAEf4Bza49YeDM=rgSOWoqAA9qc166x_dend=1U_3mMLiSdxFrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 5:28 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> [Tue, 2019-08-13 16:24 -0700]:
> > Currently libbpf version is specified in 2 places: libbpf.map and
> > Makefile. They easily get out of sync and it's very easy to update one,
> > but forget to update another one. In addition, Github projection of
> > libbpf has to maintain its own version which has to be remembered to be
> > kept in sync manually, which is very error-prone approach.
> >
> > This patch makes libbpf.map a source of truth for libbpf version and
> > uses shell invocation to parse out correct full and major libbpf version
> > to use during build. Now we need to make sure that once new release
> > cycle starts, we need to add (initially) empty section to libbpf.map
> > with correct latest version.
> >
> > This also will make it possible to keep Github projection consistent
> > with kernel sources version of libbpf by adopting similar parsing of
> > version from libbpf.map.
>
> Thanks for taking care of this!
>
>
> > Cc: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/Makefile   | 12 +++++-------
> >  tools/lib/bpf/libbpf.map |  3 +++
> >  2 files changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index 9312066a1ae3..d9afc8509725 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -1,9 +1,10 @@
> >  # SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> >  # Most of this file is copied from tools/lib/traceevent/Makefile
> >
> > -BPF_VERSION = 0
> > -BPF_PATCHLEVEL = 0
> > -BPF_EXTRAVERSION = 4
> > +BPF_FULL_VERSION = $(shell \
>
> Nit: Should it be LIBBPF_VERSION? IMO it's more descriptive name.

LIBBPF_VERSION is used below, but combining your suggestion with
Jakub's eager evaluation, I can use just LIBBPF_VERSION and drop
BPF_FULL_VERSION altogether.

>
> > +     grep -E 'LIBBPF_([0-9]+)\.([0-9]+)\.([0-9]+) \{' libbpf.map | \
> > +     tail -n1 | cut -d'_' -f2 | cut -d' ' -f1)
>
> It can be done simpler and IMO versions should be sorted before taking
> the last one (just in case), something like:
>
> grep -oE '^LIBBPF_[0-9.]+' libbpf.map | cut -d_ -f 2 | sort -nr | head -n 1

Ah, you mean making regex simpler? Yeah, I originally intended to
extract major, patch, and extra version, but ralized patch and extra
are not used for anything. I'll simplify regex. But second `cut -d' '
-f1` is still needed to drop " {".

Regarding sorting. I don't think it's necessary, as I can't imagine
having non-ordered libbpf.map. Even more so, sort -nr doesn't sort
versions like these correctly anyway:

0.1.2
0.1.12

So this will just give us false sense of correctness, while being a "time bomb".

>
>
> > +BPF_VERSION = $(firstword $(subst ., ,$(BPF_FULL_VERSION)))
> >
> >  MAKEFLAGS += --no-print-directory
> >
> > @@ -79,15 +80,12 @@ export prefix libdir src obj
> >  libdir_SQ = $(subst ','\'',$(libdir))
> >  libdir_relative_SQ = $(subst ','\'',$(libdir_relative))
> >
> > +LIBBPF_VERSION       = $(BPF_FULL_VERSION)
> >  VERSION              = $(BPF_VERSION)
> > -PATCHLEVEL   = $(BPF_PATCHLEVEL)
> > -EXTRAVERSION = $(BPF_EXTRAVERSION)
> >
> >  OBJ          = $@
> >  N            =
> >
> > -LIBBPF_VERSION       = $(BPF_VERSION).$(BPF_PATCHLEVEL).$(BPF_EXTRAVERSION)
> > -
> >  LIB_TARGET   = libbpf.a libbpf.so.$(LIBBPF_VERSION)
> >  LIB_FILE     = libbpf.a libbpf.so*
> >  PC_FILE              = libbpf.pc
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index f9d316e873d8..4e72df8e98ba 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -184,3 +184,6 @@ LIBBPF_0.0.4 {
> >               perf_buffer__new_raw;
> >               perf_buffer__poll;
> >  } LIBBPF_0.0.3;
> > +
> > +LIBBPF_0.0.5 {
> > +} LIBBPF_0.0.4;
>
> I'm not sure version should be bumped in this patch since this patch is
> about keeping the version in one place, not about bumping it, right?

This is actually fixing a version. Current libbpf version in bpf-next
is 0.0.5, it just was never updated in Makefile.

>
>
> > --
> > 2.17.1
> >
>
> --
> Andrey Ignatov
