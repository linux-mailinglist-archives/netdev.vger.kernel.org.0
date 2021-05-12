Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62437ED0D
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385072AbhELUGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359640AbhELSxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 14:53:44 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF18C06174A;
        Wed, 12 May 2021 11:50:33 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 82so31964693yby.7;
        Wed, 12 May 2021 11:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZxyM0HpMwe0lQC00HHaHZaHSaC5XVEVqlMr7GZzCwqY=;
        b=Gj30vjccDQoBSEsE+RfMrjqRHFHxMCuyPE0qlJKW6YxuMm+AmDOWmT+vMXkSVBxig/
         uetcWCr/oodsdfwduT7cyKogK0ghO1KwF16Xc90qSuLeSgvgFMBmwwms5ugSqwYGZocA
         XjgekmG7CKPJ1H9OsDa6f5BDMv17xN1Recou+PFa51r9A+3MUMpo2JYe5cS8ES5sKNXk
         +xkRovV1Rjr3wEp29zaem0407YdDqbSujrev2TqjpqX5Bxa1Mevx6kChqb75MHUhdVW5
         Lq4tsd7Naxo8G+MNmBmPtsJ/i9jp3byxyesCOPjY7N32jCUnAK0y0bKoN4/qZE1RMAgt
         KbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZxyM0HpMwe0lQC00HHaHZaHSaC5XVEVqlMr7GZzCwqY=;
        b=sMQIP79jLwAI03NAKPkLYD4JLX2kV14pC5PKa5PvHpH+6hxIoU8v6dJulVZBIvEXZ/
         8GXVNQfyUk9rzXYiPiP63rSLrpYqhHNUWFLp5yyJoO1lgN0Gj5a/7mnw12fwSItyRk9J
         z04Mv7JSDdeRveT9ThgdtB3QG9TU5+YP/0VB8PnnSQSEPzocbpEYK8pgc+66M+sI4OT6
         VpcgjWmVk1bZWgPSVdmpzj9HbdaRGJw4wcFhH0P2AFh2YdaFTlwOd+RNjkvIWXCe1aA9
         dM6VSI74LFdHmtBh/DaPjBWdzbDXdHxZ4WKrUNbagWrzQPIkPH8gtajgmTAnOPbiCXBI
         FV1g==
X-Gm-Message-State: AOAM5308ewcIPV75PuRJkClI3H1OdSLwrM22O4Q2kuCHIZ6xiZTYRhAi
        fXS6gohvLbwdKJrHxQNcDOe2PRzUpQDxOLFN0JM=
X-Google-Smtp-Source: ABdhPJyIjGOzyu/qFT6otrXOfpXNUkgx9bwlkNhdf2+NtisAo1VF1SGriGE13RZXzbGREVyTxuiseJ+/JsfHrclWcJs=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr48373192ybg.459.1620845430785;
 Wed, 12 May 2021 11:50:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
 <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
 <20210504044204.kpt6t5kaomj7oivq@ast-mbp> <CAADnVQ+WV8xZqJfWx8em5Ch8aKA8xcPqR0wT0BdFf9M==W5_FQ@mail.gmail.com>
 <CAEf4BzY2z+oh=N0X26RBLEWw0t9pT7_fN0mWyDqfGcwuK8A-kg@mail.gmail.com> <20210511230505.z3rdnppplk3v3jce@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210511230505.z3rdnppplk3v3jce@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 May 2021 11:50:19 -0700
Message-ID: <CAEf4BzbJ==4iUFp4pYpkgbKy40+Q6+RTPJVh0gUANHajs88ZTg@mail.gmail.com>
Subject: Re: bpf libraries and static variables. Was: [PATCH v2 bpf-next 2/6]
 libbpf: rename static variables during linking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 4:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, May 11, 2021 at 11:59:01AM -0700, Andrii Nakryiko wrote:
> > >
> > > If I understood what folks were saying no one is excited about namespaces in C.
> > > So probably #3 is out and sounds like 1 is prefered?
> > > So don't emit statics ?
> > >
> >
> > I'm in favor of not emitting statics. They just seem to cause more
> > problems than providing any extra benefits. Given it's trivial to just
> > use globals instead and global vs static is already an explicit signal
> > of what has to be in BPF skeleton and what's not. See my RFC about
> > __internal + __hidden semantics, but even if we supported nothing but
> > STV_DEFAULT globals wouldn't be horrible. Clearly we'd expect users to
> > just not mess with BPF library's internal state with not way to
> > enforce that, so I'd still like to have some enforceability.
>
> I'm glad that with Daniel and Lorenz we have a strong consensus here.
> So I've applied first 6 patches from your RFC that stop exposing static
> in skeleton and fix tests.
> I'm only not 100% sure whether
> commit 31332ccb7562 ("bpftool: Stop emitting static variables in BPF skeleton")
> is enough to skip them reliably.
> I think 'char __pad[N]' logic would do the rigth thing when
> statics and globals are interleaved, but would be good to have a test.

Yeah, it should because current offset is re-calculated based on last
processed variable and its size, so it doesn't matter if we skip extra
variables. We can test it in test_static_linked selftest, if we switch
zero-initialized var1 and var2 to be non-zero initialized, so that
they share .data with static variables. I tested locally and they
work, I'll send an update to selftests with a follow up patch set.

> In one .o file clang emits all globals first and then all statics,
> so even without __pad it would have been enough,
> but I don't know how .o-s with statics+global look after static linker combines them.

Static linker preserves relative order across .o's, so you'll have
globals1, statics1, globals2, statics2, which is why proposed above
adjustment to test_static_linked will validate the logic.

>
> I skipped patch 7, since without llvm part it cannot be used and it's
> not clear yet whether llvm will ever be able to emit __internal.

__internal cannot be used explicitly to isolate global variable from
other files, but STV_HIDDEN -> STV_INTERNAL translation would allow to
protect BPF library globals from BPF application, which is still a
desirable feature. But whatever, we can wait and see the resolution of
the Clang bug/feature discussion.

>
> > So my proposal is to allow having a special "library identifier"
> > variable, e.g., something like:
> >
> > SEC(".lib") static char[] lib_name = "my_fancy_lib"; (let's not
> > bikeshed naming for now)
>
> without 'static' probably? since license and version are without?

It's not so clear. static allows to have different library names for
different files. Currently we enforce that version and license
contents match. It's part of what I said earlier that it feels like we
need two separate linking commands: one for building BPF libraries and
one for linking BPF applications. Which is not that far from
user-space, where you linked shared libraries with a special options.
We just want BPF static libraries to have properties of user-space BPF
shared libraries (w.r.t. protection at least). We can discuss it at
office hours, though.

>
> and at will be optional (mostly ignored by toolchain) for libs that
> don't need sub-skeleton and mandatory for sub-skeleton?

yep

>
> > With such library identifiers, BPF static linker will:
> >   1) enforce uniqueness of library names when linking together
> > multiple libraries
>
> you're not proposing for lib name to do namespacing of globals, right?
> Only to indicate that liblru.o and libct.o (as normal elf files)
> are bpf libraries as can be seen in their 'lib_name' strings
> instead of regular .o files.
> (that would be a definition of bpf library).

yes, globals are not namespaced

> So linker can rely on explicit library names given by users in .bpf.c
> (and corresponding dependency on sub-skel) instead of relying
> on file names?

yes, stable unique identifier

> If so, I agree that it's necessary.
> Such 'char lib_name[]' is probably better than elf note.
>
> >   2) append zero-size markers to the very beginning and the very end
> > of each BPF library's DATASECS, something like
> >
> > DATASEC .data:
> >
> >    void *___my_fancy_lib__start[0];
> >    /* here goes .data variables */
> >    void *___my_fancy_lib__end[0];
> >
> > And so on for each DATASEC. What those markers provide? Two things:
> >
> > 1). It makes it much easier for sub-skeleton to find where a
> > particular BPF library's .data/.rodata/.bss starts within the final
> > BPF application's  .data/.rodata/.bss section. All that without
> > storing local BTF and doing type comparisons. Only a simple loop over
> > DATASECs and its variables is needed.
>
> indeed. some lib name or rather sub-skeleton name is needed.
> Since progs can have extern funcs in the lib I see no clean way to
> reliably split prog loading between main skeleton and sub-skeletons.
> Meaning that prog loading and map creation can only be done
> by the main skeleton.

Yes, opening and loading can be done by main skeleton only. But
between opening and loading a sub-skeleton can be instantiated from
bpf_object (or whatever equivalent way for lskel) and further
pre-setup stuff (map definition adjustments, rodata and other vars
setting up, etc). Then main skeleton loads, and if necessary,
user-space part of BPF library can still perform after-load
adjustments before final attachment happens.

> After that is done and mmap-ing of data/rodata/bss is done
> the main skeleton will init sub-skeleton with offsets to their
> corresponding data based on these offsets?
> I think that will work for light skel.

What I had in mind kept skeleton completely isolated from
sub-skeleton. Think about this, when BPF library author is compiling
it's user-space parts that use sub-skeleton, they don't and generally
speaking can't know anything about the final BPF application, so they
can't have any access to the final skeleton. But they need
code-generated sub-skeleton header file, similarly to BPF skeleton
today. So at least for BPF skeleton, the flow I was imagining would be
like this.

1. BPF library abc consists of abc1.bpf.c and abc2.bpf.c. It also has
user-space component in abc.c.
2. BPF app uses abs library and has its own app1.bpf.c and app2.bpf.c
and app.c for user-space.
3. BPF library author sets up its Makefile to do
  a. clang -target bpf -g -O2 -c abc1.bpf.c -o abc1.bpf.o
  b. clang -target bpf -g -O2 -c abc2.bpf.c -o abc2.bpf.o
  c. bpftool gen lib libabc.bpf.o abc1.bpf.o abc2.bpf.o
  d. bpftool gen subskeleton libabc.bpf.o > libabc.subskel.h
  e. abc.c (user-space library) is of the form

#include "libabc.subskel.h"

static struct libabc_bpf *subskel;

int libabc__init(struct bpf_object *obj)
{
    subskel = libabc_bpf__open_subskel(obj);

    subskel->data->abc_my_var = 123;
}

int libabc__attach()
{
    libabc_bpf__attach(subskel);
}

  f. cc abc.c into libabc.a and then libabc.a and libabc.bpf.o are
distributed to end user

3. Now, from BPF application author side:
  a. clang -target bpf -g -O2 -c app1.bpf.c -o app1.bpf.o
  b. clang -target bpf -g -O2 -c app2.bpf.c -o app2.bpf.o
  c. bpftool gen object app.bpf.o app1.bpf.o app2.bpf.o libabc.bpf.o
  d. on user-space side of app in app.c

#include "app.skel.h"

int main()
{
    struct app_bpf *skel;

    skel = app_bpf__open();
    skel->rodata->app_var = 123;

    libabc__init(skel->obj);

    app_bpf__load(skel);

    libabc__attach();

    /* probably shouldn't auto-attach library progs, but don't know
yet how to prevent that */
    app_bpf__attach(skel);

    /* do some useful logic now */
}

  e. cc app.c -o app && sudo ./app


So, app author doesn't need and doesn't have direct access to
subskeleton header. And sub-skeleton header is generated by BPF
library way before the library is linked into the final application.

> I don't see a use case for __end marker yet, but I guess it's good
> for consistency.

Good for knowing whole range of BPF library's data. Can be used for
some extra sanity checking. And can be used to omit parts of variables
from the final skeleton.

> rodata init is tricky.
> Since the main skel and sub-skels will init their parts independently.
> But I think it can be managed.

See above, I showed rodata initialization as well. It works because we
have mmap()'ed memory right after skeleton's open and all the memory
addresses stay fixed.

>
> > 2). (optionally) we can exclude everything between ___<libname>__start
> > and ___<libname>__end from BPF application's skeleton.
>
> So that's leaning towards namespacing ideas?

Not really, because globals are not namespaced and statics are not
exposed to user-space, so there is no need for namespacing. This is to
find data location and, if necessary, filter out library state from
application skeleton.

> The lib_name doesn't hide any names and globals will conflict during
> the linking as usual.
> But with this optional hiding (inside .bpf.c it will have special name?)
> the partial namespacing can happen. And the lib can hide the stuff
> from its users.
> The concept is nice, but lib scope maybe too big.
>
> > It's a pretty long email already and there are a lot things to unpack,
> > and still more nuances to discuss. So I'll put up BPF static linking +
> > BPF libraries topic for this week's BPF office hours for anyone
> > interested to join the live discussion. It would hopefully allow
> > everyone to get more up to speed and onto the same page on this topic.
> > But still curious WDYT?
>
> Sounds great to me. I hope more folks can join the discussion.
