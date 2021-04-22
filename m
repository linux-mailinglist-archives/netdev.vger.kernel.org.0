Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C2D368660
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhDVSKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVSKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:10:05 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAD1C06174A;
        Thu, 22 Apr 2021 11:09:29 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k73so46239124ybf.3;
        Thu, 22 Apr 2021 11:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ck5dXsJs8ipPbbhauxdiabXdKXATC0+chn6WJfCnuNQ=;
        b=vRmB0WK99lI7D7b7/sAtezGJ+4baj7y6MyxzVHCuaHylCBZ1KUe5giyGeCcFNqJOIQ
         Vq4LCxArnIOoDJWJvMvfgcZUKP1czQMw2h5ByprnmcXUbyHopTgDkCk+n22D47c25TaE
         PEQgibzjP4ucoJKg9CKTP03LI4MMyThHOKw4dvOYRyo6vtKq3O8CpZgJ+ytJGzKbYi59
         yTrTlkd4S9HiQOeZYJcE8rQ+0Kj8BP+N7+VoQVn/FltQjth0VEEPYF/YR9Bd3X5N3EI7
         6anxHNhSEpUZ5DH+QJOUbYY0A9fRVGjbt43bez14c64caod9hQP7M2vrT7YLHoJJVbii
         aHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ck5dXsJs8ipPbbhauxdiabXdKXATC0+chn6WJfCnuNQ=;
        b=Gw9wbvuzDhoZ+uwUULOfblmPCNTt2x5w7hKFpKSdc7nDruEzYZzEA+gphAIb420TZp
         GYqOwSlNWGF4yiqCKcZF/1NQrnLZCoZL+fQk66o1Go76xUR+CRMYNE+i9BmQYX9g0Lbt
         p5N7AB8LS/jkZpxhBjyd1yHL1Xy5t3tKkphgOHZS32JbYIZ7I/TMX5OIeHE47pIfxu/7
         /XEqipUPB+7doEz36M68Y9GvCufZ4TL8WLsl5/e5R8wbUdUXYZGcuuxHx+rar500/5vb
         c4xMyPN7OpUU4sZnpc9vAi9+Kump/LEdB1POfEXIiOAFI1/RIx7s0rSRGTTgHuuUKwV3
         NWAA==
X-Gm-Message-State: AOAM532YCBrj3tH7UZEPJhxc6ueiJCNcA0srWjymS5wpNP/1LgEWDFSy
        0zxCHXYxzFnVZKGzI28VOB6DabbZt3iFO2e1HwNSQHQnc1A=
X-Google-Smtp-Source: ABdhPJzZiP4dOMuru75rHtViTdj0UeEuZuyh7/5CUBNrLtZT1gNIAtKlHQaLYTriyRUawwQ3aJ2Ory/U2sJx6PvVqOg=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr6264451ybg.459.1619114968572;
 Thu, 22 Apr 2021 11:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-5-andrii@kernel.org>
 <8cde2756-e62f-7103-05b1-7d9a9d97442a@fb.com>
In-Reply-To: <8cde2756-e62f-7103-05b1-7d9a9d97442a@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:09:17 -0700
Message-ID: <CAEf4BzYFHp8vt6rwgcZG5Lp-DQU0xrVq8QXvDqOyVOtx0gosnw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/17] libbpf: mark BPF subprogs with hidden
 visibility as static for BPF verifier
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 10:43 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Define __hidden helper macro in bpf_helpers.h, which is a short-hand for
> > __attribute__((visibility("hidden"))). Add libbpf support to mark BPF
> > subprograms marked with __hidden as static in BTF information to enforce BPF
> > verifier's static function validation algorithm, which takes more information
> > (caller's context) into account during a subprogram validation.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/lib/bpf/bpf_helpers.h     |  8 ++++++
> >   tools/lib/bpf/btf.c             |  5 ----
> >   tools/lib/bpf/libbpf.c          | 45 ++++++++++++++++++++++++++++++++-
> >   tools/lib/bpf/libbpf_internal.h |  6 +++++
> >   4 files changed, 58 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 75c7581b304c..9720dc0b4605 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -47,6 +47,14 @@
> >   #define __weak __attribute__((weak))
> >   #endif
> >
> > +/*
> > + * Use __hidden attribute to mark a non-static BPF subprogram effectively
> > + * static for BPF verifier's verification algorithm purposes, allowing more
> > + * extensive and permissive BPF verification process, taking into account
> > + * subprogram's caller context.
> > + */
> > +#define __hidden __attribute__((visibility("hidden")))
>
> To prevent potential external __hidden macro definition conflict, how
> about
>
> #ifdef __hidden
> #undef __hidden
> #define __hidden __attribute__((visibility("hidden")))
> #endif
>

We do force #undef only with __always_inline because of the bad
definition in linux/stddef.h And we check #ifndef for __weak, because
__weak is defined in kernel headers. This is not really the case for
__hidden, the only definition is in
tools/lib/traceevent/event-parse-local.h, which I don't think we
should worry about in BPF context. So I wanted to keep it simple and
fix only if that really causes some real conflicts.

And keep in mind that in BPF code bpf_helpers.h is usually included as
one of the first few headers anyways.


> > +
> >   /* When utilizing vmlinux.h with BPF CO-RE, user BPF programs can't include
> >    * any system-level headers (such as stddef.h, linux/version.h, etc), and
> >    * commonly-used macros like NULL and KERNEL_VERSION aren't available through

[...]

> > @@ -698,6 +700,15 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
> >               if (err)
> >                       return err;
> >
> > +             /* if function is a global/weak symbol, but has hidden
> > +              * visibility (or any non-default one), mark its BTF FUNC as
> > +              * static to enable more permissive BPF verification mode with
> > +              * more outside context available to BPF verifier
> > +              */
> > +             if (GELF_ST_BIND(sym.st_info) != STB_LOCAL
> > +                 && GELF_ST_VISIBILITY(sym.st_other) != STV_DEFAULT)
>
> Maybe we should check GELF_ST_VISIBILITY(sym.st_other) == STV_HIDDEN
> instead?

It felt like only STV_DEFAULT should be "exported", semantically
speaking. Everything else would be treated as if it was static, except
that C rules require that function has to be global. Do you think
there is some danger to do it this way?

Currently static linker doesn't do anything special for STV_INTERNAL
and STV_PROTECTED, so we could just disable those. Do you prefer that?

I just felt that there is no risk of regression if we do this for
non-STV_DEFAULT generically.


>
> > +                     prog->mark_btf_static = true;
> > +
> >               nr_progs++;
> >               obj->nr_programs = nr_progs;
> >

[...]
