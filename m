Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC2226954
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfEVRpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:45:49 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36646 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfEVRpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:45:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id a17so3424749qth.3;
        Wed, 22 May 2019 10:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MpNcFOLGQwthAMyqIOYeGLCmEhZ7QMmLEGiQjve6Ba8=;
        b=rib7cicjHGVVnKO/MyFKWoLnM4bo0Pk5oVi0PVUAginjkwmF9oW+sCIWyqT9BhuqMm
         tnmPNDhzvII62LQDlBkwVBB2ADp1OkrlWQkbvySRDUr3YScBOmbnLVvN83Mw3Skc0duQ
         3OgP9X1btMVecXWa9zbiMhtp6tbhqgTpYTMzg+e2NQ/xvTSTygfcSnzUiBa26x3bVq1C
         1EThmcW/+qZyPrw+UrASIFlVgV3KkhZzNN9Cf9cqsBepZMgNnsZS0mFs7qzYR5UAmKyP
         2tEX0yAp9zaliOTW1zf/ua+sFWo/JQjKPtGt0BI8qJ8saddqFzuYR6QUbDx7zlPCuxGm
         CLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MpNcFOLGQwthAMyqIOYeGLCmEhZ7QMmLEGiQjve6Ba8=;
        b=j4/VoiClf5yl9Jxajas8P4gHQu96fRtf9ph0KjXdRpoEjs69IWdagnipiOmexnONo7
         2yJc/8cZPm9x3tk2r8F9bNxUso3XQULKjGXwRIXz9gsTBSIYz1QeKcLllpq+fUMGBePD
         Ned7Dmn5yh7PnEv+EUH0K1D+4Ti/cPQ8z0e3Kb8xjcnq96GxTZtenyVd7barMeSGbOWt
         NMuBCd7U6be75Sgp9LLXI0t/6tHNUw9vVsD8m+KsmvAntd4ig7QQjZl922LvpkCKlrj6
         xTNGMPq3SzuwfuVJ7ACoMnsOvy26U04D8lLbwn42TE87EOvW9HK+UthX7hMTZNvX0NRr
         AnYg==
X-Gm-Message-State: APjAAAVh4oPLybsjUOgC9hlY23sqd7hjRpAIU21vT64Kift6R9oyiWNy
        NyUv3lz2QOw441DQ3stw42kgzQGqeWftj28+Pk0=
X-Google-Smtp-Source: APXvYqy74KpNsDbAYVEDAJSAEtz+VYZqgjY4/tyDrPPEsSY45Qmpo2JD9NViwBfVDBiZUPrEj+EmKxt8r2eDhget2sg=
X-Received: by 2002:ac8:668d:: with SMTP id d13mr74623105qtp.59.1558547148423;
 Wed, 22 May 2019 10:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190522161520.3407245-1-andriin@fb.com> <1b027a52-4ac7-daf8-ee4a-eb528f53e526@fb.com>
 <20190522164656.GK10244@mini-arch>
In-Reply-To: <20190522164656.GK10244@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 May 2019 10:45:37 -0700
Message-ID: <CAEf4BzYRRgei0DE_K2XKg9y6BJRj8X1ob_6uV4oi9Vm5t=eAQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: emit diff of mismatched public API, if any
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 9:46 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/22, Alexei Starovoitov wrote:
> > On 5/22/19 9:15 AM, Andrii Nakryiko wrote:
> > > It's easy to have a mismatch of "intended to be public" vs really
> > > exposed API functions. While Makefile does check for this mismatch, if
> > > it actually occurs it's not trivial to determine which functions are
> > > accidentally exposed. This patch dumps out a diff showing what's not
> > > supposed to be exposed facilitating easier fixing.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >   tools/lib/bpf/.gitignore | 2 ++
> > >   tools/lib/bpf/Makefile   | 8 ++++++++
> > >   2 files changed, 10 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
> > > index d9e9dec04605..c7306e858e2e 100644
> > > --- a/tools/lib/bpf/.gitignore
> > > +++ b/tools/lib/bpf/.gitignore
> > > @@ -3,3 +3,5 @@ libbpf.pc
> > >   FEATURE-DUMP.libbpf
> > >   test_libbpf
> > >   libbpf.so.*
> > > +libbpf_global_syms.tmp
> > > +libbpf_versioned_syms.tmp
> > > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > > index f91639bf5650..7e7d6d851713 100644
> > > --- a/tools/lib/bpf/Makefile
> > > +++ b/tools/lib/bpf/Makefile
> > > @@ -204,6 +204,14 @@ check_abi: $(OUTPUT)libbpf.so
> > >                  "versioned symbols in $^ ($(VERSIONED_SYM_COUNT))." \
> > >                  "Please make sure all LIBBPF_API symbols are"       \
> > >                  "versioned in $(VERSION_SCRIPT)." >&2;              \
> > > +           readelf -s --wide $(OUTPUT)libbpf-in.o |                 \
> > > +               awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
> > > +               sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
> > > +           readelf -s --wide $(OUTPUT)libbpf.so |                   \
> > > +               grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
> > > +               sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
> > > +           diff -u $(OUTPUT)libbpf_global_syms.tmp                  \
> > > +                $(OUTPUT)libbpf_versioned_syms.tmp;                 \
> > >             exit 1;                                                  \
> >
> > good idea.
> > how about removing tmp files instead of adding them to .gitignore?
> We should be able to do it without any temp files. At least in bash
> one can do:
>
> diff -u <(readelf -s --wide ${OUTPUT}libbpf-in.o | \
>           awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $8}' | \
>           sort -u) \
>         <(readelf -s --wide ${OUTPUT}libbpf.so | \
>           grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | \
>           sort -u)
>
> But might be complicated in the makefile :-/

that was my initial implementation, but it doesn't work in Makefile,
as it's bash-specific
