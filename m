Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30428DBDE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfHNR2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:28:37 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42541 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNR2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:28:37 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so22402796qtp.9;
        Wed, 14 Aug 2019 10:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LcgGVH6zxjU3w1I/TqX02OsI2mEpWAYlE8Rqdn52Tv4=;
        b=FRckY87nx3Z7oATwrYj0zEzBMEu1/SzwGHLUhPE2VRMKwEGC1MktQWkUHf2ugq4l67
         6d+UHJrvUzXxvU+sSZ5Ji/QCYRfAlEnjens/Xfh63amDKdWowAPNtBnNar6KyaWRll1x
         h8OLDtNy9+wTOX/nwiv58RdMzJyrktL+81PGAoBszjEyMxmnV2XqKTr/oO70RRZi5dd3
         KxUbAzoT61Uug0yTZ1BFFhlLLlDHhfpqmhSvriL4A/gHJbpO44C/bzs1Gz5A/+vnvnub
         3LpxvpqYCMfN59C9Qys7so6DcYp2wZJRugLfLVpCOLitckF69/tgG6CfZLMauowkSHkR
         r3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LcgGVH6zxjU3w1I/TqX02OsI2mEpWAYlE8Rqdn52Tv4=;
        b=g2JxaLGhpHoAmdWzqhxXljdLlTX7NKPkYghwX2PTmvLKRiScamxV5yHv+IVEc+K9x3
         RAKtHuAdIOVqYoZ9iRdjmDZHyTOk89Zf/jSMHrDIa+YImunNvn956sqUC2h7HlykhMW0
         aXQ7YX5G4YnDjsQ5zcPPOrSc86q/Cm6Y5BgNoZ229KY1NSO0VqA29j7BWBa17BS++44n
         2ZfdJPo2ELwJkAj+hXg+QSWMu/9EL1ZFoIDGboh3nktLk5opFXI+TMU1I/rzQF/FUdL0
         FQnRjWpBgcDyj3pmC9SpOCefy5Sahy7K8T6Tmy131Cfz2bN8Y+Y0cW+VMd1qkRIRWaIP
         fXUw==
X-Gm-Message-State: APjAAAUHtYGlIzqZs/YJJAGHp+I65v7npIkMyyOjYowXoNyQqhTlVNpr
        D9fP6fVw0uZNVkNfGyDHmO9xut3UnpPROE3MnEkIRHJYEmg=
X-Google-Smtp-Source: APXvYqzYwBuuOBWdo0aV7CNV+hXAJ9m5g6o2uIpsw4+dR6wQx1vin4BkTqecOUZm3WImXzyuSMFNrIKM6xv42sM/ng4=
X-Received: by 2002:ac8:488a:: with SMTP id i10mr407937qtq.93.1565803715563;
 Wed, 14 Aug 2019 10:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190813232408.1246694-1-andriin@fb.com> <20190814002824.GA29281@rdna-mbp>
 <CAEf4Bza49YeDM=rgSOWoqAA9qc166x_dend=1U_3mMLiSdxFrQ@mail.gmail.com> <20190814071242.GA41688@rdna-mbp>
In-Reply-To: <20190814071242.GA41688@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 10:28:24 -0700
Message-ID: <CAEf4Bza3xU-Lmgp75CcqEi=-dUeCcfNxi7x8XVE8Gf8xd8=OHQ@mail.gmail.com>
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

On Wed, Aug 14, 2019 at 12:12 AM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> [Tue, 2019-08-13 21:46 -0700]:
> > On Tue, Aug 13, 2019 at 5:28 PM Andrey Ignatov <rdna@fb.com> wrote:
> > >
> > > Andrii Nakryiko <andriin@fb.com> [Tue, 2019-08-13 16:24 -0700]:
> > > > Currently libbpf version is specified in 2 places: libbpf.map and
> > > > Makefile. They easily get out of sync and it's very easy to update one,
> > > > but forget to update another one. In addition, Github projection of
> > > > libbpf has to maintain its own version which has to be remembered to be
> > > > kept in sync manually, which is very error-prone approach.
> > > >
> > > > This patch makes libbpf.map a source of truth for libbpf version and
> > > > uses shell invocation to parse out correct full and major libbpf version
> > > > to use during build. Now we need to make sure that once new release
> > > > cycle starts, we need to add (initially) empty section to libbpf.map
> > > > with correct latest version.
> > > >
> > > > This also will make it possible to keep Github projection consistent
> > > > with kernel sources version of libbpf by adopting similar parsing of
> > > > version from libbpf.map.
> > >
> > > Thanks for taking care of this!
> > >
> > >
> > > > Cc: Andrey Ignatov <rdna@fb.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/lib/bpf/Makefile   | 12 +++++-------
> > > >  tools/lib/bpf/libbpf.map |  3 +++
> > > >  2 files changed, 8 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > > > index 9312066a1ae3..d9afc8509725 100644
> > > > --- a/tools/lib/bpf/Makefile
> > > > +++ b/tools/lib/bpf/Makefile
> > > > @@ -1,9 +1,10 @@
> > > >  # SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> > > >  # Most of this file is copied from tools/lib/traceevent/Makefile
> > > >
> > > > -BPF_VERSION = 0
> > > > -BPF_PATCHLEVEL = 0
> > > > -BPF_EXTRAVERSION = 4
> > > > +BPF_FULL_VERSION = $(shell \
> > >
> > > Nit: Should it be LIBBPF_VERSION? IMO it's more descriptive name.
> >
> > LIBBPF_VERSION is used below, but combining your suggestion with
> > Jakub's eager evaluation, I can use just LIBBPF_VERSION and drop
> > BPF_FULL_VERSION altogether.
> >
> > >
> > > > +     grep -E 'LIBBPF_([0-9]+)\.([0-9]+)\.([0-9]+) \{' libbpf.map | \
> > > > +     tail -n1 | cut -d'_' -f2 | cut -d' ' -f1)
> > >
> > > It can be done simpler and IMO versions should be sorted before taking
> > > the last one (just in case), something like:
> > >
> > > grep -oE '^LIBBPF_[0-9.]+' libbpf.map | cut -d_ -f 2 | sort -nr | head -n 1
> >
> > Ah, you mean making regex simpler? Yeah, I originally intended to
> > extract major, patch, and extra version, but ralized patch and extra
> > are not used for anything. I'll simplify regex. But second `cut -d' '
> > -f1` is still needed to drop " {".
>
> Yeah, regex, but not only. Note `-o' in the `grep' arguments, it returns
> only matched piece of a string and the second `cut' is not needed.

Oh, TIL, will do -o as well, didn't notice it first time.
>
>
> > Regarding sorting. I don't think it's necessary, as I can't imagine
> > having non-ordered libbpf.map. Even more so, sort -nr doesn't sort
> > versions like these correctly anyway:
> >
> > 0.1.2
> > 0.1.12
> >
> > So this will just give us false sense of correctness, while being a "time bomb".
>
> Right, `-n' is not a good one, `-V' is much better since it's intended
> to sort specifically versions:
>
>   % printf "0.1.2\n0.1.12\n0.1.11\n"
>   0.1.2
>   0.1.12
>   0.1.11
>   % printf "0.1.2\n0.1.12\n0.1.11\n" | sort -cV
>   sort: -:3: disorder: 0.1.11
>   % printf "0.1.2\n0.1.12\n0.1.11\n" | sort -V
>   0.1.2
>   0.1.11
>   0.1.12
>
>
> The reason I brought this up is the version string can be an arbitrary string
> and for example glibc does this:
>
>   % grep -Eo '^\s+GLIBC_\S+' sysdeps/unix/sysv/linux/Versions | tail -n 3
>   GLIBC_2.29
>   GLIBC_2.30
>   GLIBC_PRIVATE
>
> I agree though that it's not a problem with the current version script
> structure and it should be fine to postpone adding some kind of sorting till
> the time this structure is changed (if at all).

I like sort -V, will use that in v3, thanks!

>
> > > > +BPF_VERSION = $(firstword $(subst ., ,$(BPF_FULL_VERSION)))
> > > >
> > > >  MAKEFLAGS += --no-print-directory
> > > >
> > > > @@ -79,15 +80,12 @@ export prefix libdir src obj
> > > >  libdir_SQ = $(subst ','\'',$(libdir))
> > > >  libdir_relative_SQ = $(subst ','\'',$(libdir_relative))
> > > >
> > > > +LIBBPF_VERSION       = $(BPF_FULL_VERSION)
> > > >  VERSION              = $(BPF_VERSION)
> > > > -PATCHLEVEL   = $(BPF_PATCHLEVEL)
> > > > -EXTRAVERSION = $(BPF_EXTRAVERSION)
> > > >
> > > >  OBJ          = $@
> > > >  N            =
> > > >
> > > > -LIBBPF_VERSION       = $(BPF_VERSION).$(BPF_PATCHLEVEL).$(BPF_EXTRAVERSION)
> > > > -
> > > >  LIB_TARGET   = libbpf.a libbpf.so.$(LIBBPF_VERSION)
> > > >  LIB_FILE     = libbpf.a libbpf.so*
> > > >  PC_FILE              = libbpf.pc
> > > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > > index f9d316e873d8..4e72df8e98ba 100644
> > > > --- a/tools/lib/bpf/libbpf.map
> > > > +++ b/tools/lib/bpf/libbpf.map
> > > > @@ -184,3 +184,6 @@ LIBBPF_0.0.4 {
> > > >               perf_buffer__new_raw;
> > > >               perf_buffer__poll;
> > > >  } LIBBPF_0.0.3;
> > > > +
> > > > +LIBBPF_0.0.5 {
> > > > +} LIBBPF_0.0.4;
> > >
> > > I'm not sure version should be bumped in this patch since this patch is
> > > about keeping the version in one place, not about bumping it, right?
> >
> > This is actually fixing a version. Current libbpf version in bpf-next
> > is 0.0.5, it just was never updated in Makefile.
> >
> > >
> > >
> > > > --
> > > > 2.17.1
> > > >
> > >
> > > --
> > > Andrey Ignatov
>
> --
> Andrey Ignatov
