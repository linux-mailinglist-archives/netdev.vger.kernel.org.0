Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2C736DFAD
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbhD1Teg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244021AbhD1Tee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 15:34:34 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD37C061573;
        Wed, 28 Apr 2021 12:33:49 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l7so108494ybf.8;
        Wed, 28 Apr 2021 12:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s1Ds+AZkOX99qhQ7XDgMKyD614n+TW/51OYXwa++zys=;
        b=f/DFdSW7r+PYa3TiLwd3dLYA+Lk+x9gm9zYwQh8eQmtY1Wg97OPFOxsCwaljKanDsf
         +wr6KadgtkSJ2u8ZjKTg9CbkwKU1wu6oBEx2SZz1dL3qjUDZg0xTkC7csaZbfeMLs+7F
         X9lgsQP8wh+PZhsqN9u5DCqFpue62BLP5pAj5EY3G6Ga+KEj/veF0VgIGnfvDaqWDcbt
         amcFiNyN8CBDtBwr2Sy3RcLoH224vpk67TTpjdFPL1GIKjDq4l6MU1Pl37SWJJZq1Ab9
         PJ/ZTqOIYqSPjXT5vvFyC902GOOduSdjeii2e4nhYSLxVzW3rCfH2PC9fjFaSXA9ApPD
         3iuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s1Ds+AZkOX99qhQ7XDgMKyD614n+TW/51OYXwa++zys=;
        b=WT3KHdTbcoPS89qk9Ar+ELSImjL3B3439qnla+0XsuQxfO2GSHYlNwvi5EWxWKrKRt
         tDmaQOOjlgcH4C3pxy2Aa5XC2SiKg3NAVUEpW+ksaEFao6Bbz7YLsXzVotuIrdMOfsUs
         6RwfGfxWYmDsvh1F8pZDlzfa+fov0qRztFxMuyDP+IDVMeN7T5rr9GpK33MLhFLbj5O1
         oJQE/lvJ5fjplEaNqd1jxRYT67zYfMFEltFFiOyjW7mkFASXvfj1Rq0BM2Jmrjh9Bpjf
         1vz+xHLR0l0IbnIEBgs3GjAaGtDPUWjYCkFEzKHcIc6jDBFPELj7bPXPYxij5VneuENm
         jpdQ==
X-Gm-Message-State: AOAM532KAMefee7gDG3kk89Vief07hSZPMTXQrATrTZ0ds2ZL9o7u07E
        bLjoMMuY2UmtLOaVEBot0e2AMKp0a0+SHmSyL9o=
X-Google-Smtp-Source: ABdhPJwvvEdXeYp4LncBSV29zKasUM/5JbcV1A9GZ8ZiIUNFE7bW9MzJzdtWb+CxPQpaDkfDfiOFISaT0+Txg+gf7Bs=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr39946905ybg.459.1619638428150;
 Wed, 28 Apr 2021 12:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
 <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
 <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
 <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com> <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Apr 2021 12:33:36 -0700
Message-ID: <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 9:55 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 27, 2021 at 02:27:26PM -0700, Andrii Nakryiko wrote:
> >
> > It's static for the purposes of BPF code, so no naming collisions in
> > BPF code and no intentional or unintentional accesses beyond a single
> > .bpf.c file. That's what we want. We don't want BPF library writers to
> > worry about names colliding with some other library or user code.
>
> Who is 'we' ?

Me and Yonghong, at least. Putting myself into BPF library
writer/maintainer shoes (which I have plans for), I'd say any BPF
library writer as well.

> The skel gen by accident (probably) extended 'static' visibility
> from .bpf.c into user space .c.
> My point that it was a bad accident and I only realized it now.
> The naming conflict in linking exposed this problem.

There is no linking naming conflict. We are talking about BPF skeleton
(and not just trough BPF skeleton, potentially) access to
global/static variables (and static maps as well).

> The selftests are relying on this 'feature' now.
> Potentially some user could have used it as well.
> Do I want to break that use case? Not really, but that's still an option.
>
> I agree that library writers shouldn't worry about
> naming conflicts in *.bpf.c space.
> If they're exporting a static from .bpf.c into .c I think it's ok
> to make them do extra steps.
> Such 'static in .bpf.c' but 'extern into .c' should somehow work
> without requiring people rename their vars.
> I mean that the user of the library shouldn't need to do renames,
> but the library author shouldn't rely on 'all statics are visible
> in skel'.
> In that sense what I proposed earlier to allow linking, but fail
> skel gen is a step towards such development process.

This is not just variables in BPF skeleton. Static maps, even without
skeleton, will have the same problem. All maps are accessible through
bpf_object__find_map_by_name().

> Something like attr(alias()) or some other way hopefully can
> help library authors create such library where static+something
> is visible to library's skeleton, but users of the library
> don't see its statics.
> I think the static handling logic needs to be discussed
> with your sub-skeleton idea.
> If I got it correctly there will be something like this:
> - lib.bpf.c compiled into lib.bpf.o

small adjustment here, it might be lib1.bpf.c + lib2.bpf.c + and so on
-> (through intermediate .bpf.o) -> final lib.bpf.o

> - main.bpf.c that links with lib.bpf.o
>   It's all in *.bpf.c space and static has normal C scope.
>   The static vars and maps in lib.bpf.c are not
>   visible in main.bpf.c
> - there is lib.c that works with lib.bpf.c via lib.skel.h
>   that was generated out of lib.bpf.o
> - main.c that links with lib.o
>   main.c works with main.bpf.c via main.skel.h
>
> I think lib.skel.h you were calling sub-skeleton.
> pls correct me.

no, all correct

> Since main.bpf.o was linked with lib.bpf.o
> the main.skel.h will include the things from it.
> But main.c shouldn't be accessing them, since that's the
> point of the library.
>
> At the same time lib.bpf.c and main.bpf.c could have been
> just two files of the same project. If lib.bpf.o isn't a library
> then main.skel.h should access it just fine.
> So what is bpf library? How should it be defined?

In very abstract terms, it's a piece of BPF application (maps,
programs, variables) and corresponding user-space (initialization,
teardown, runtime operations) that is not a complete application and
is supposed to be linked into (potentially) someone else's
application.

You are right that right now main.skel.h will have visibility into
library's maps, variables, programs. Not great, but didn't feel that
horrible either. After all, user of BPF library has to follow some API
expectations regardless, like calling some init and teardown APIs and
otherwise setting up BPF library at runtime.

I'm not sure what alternative there is. User-space C ecosystem doesn't
differentiate between linking with some my_prog.o vs libbpf.a. So
static libraries are not special in any way and if they have
conflicting global variable names, it will cause linker error. This is
where static variables are important.

Shared libraries are a bit more formally recognized, but that's a very
different thing (that's where STV_HIDDEN plays the role in user-space
linking).

So I feel like you are getting at something, but don't quite spell it
out. Please elaborate.

> And what is the scope and visibility of its vars/maps/funcs?
> Unlike traditional C the bpf has two worlds .bpf.c and .c
> So traditional 'static' doesn't cover these cases.

Right, static is static only within the BPF world.

>
> > And
> > from the perspective of a user of two BPF libraries that have
> > colliding names it's not great to have to somehow rename those
> > libraries' internal variables through source code changes.
>
> It's not great. That's why I'm trying to provoke a discussion
> of more options and pick the best considering all + and -.
>

We are having this discussion, even if it produces disappointing
results. I don't know better options short of disabling static
variables. I've thought a lot about it.

What's worse, to bpftool, generating BPF skeleton for .bpf.o straight
from Clang or to statically-linked .bpf.o is indistinguishable, so
it's not even simple to just say "let's not generate static variables
into BPF skeleton". But there are also static maps with similar issues
and non-skeleton-based APIs to access them by name
(bpf_object__find_map_by_name()). There we definitely can't just keep
saying that static maps are not supported. I think we both agreed
static maps would be good to have, but no one will die if we drop
them.

> >
> > Omitting static variables from skeleton is a regression and will
> > surprise existing users, we already went over this with you and
> > Yonghong in previous emails.
>
> Do I want to suffer this regression? No, but it could be the only option.
>
> > Beyond that, it's not clear what exactly you are proposing.
>
> To discuss all options as a whole and hopefully you and others
> can come up with more than what I proposed.
>
> > For
> > alias() seems like another variable with that "external_name" has to
> > be already defined and you can't initialize var, it has to be just a
> > declaration. And BTF doesn't capture attributes right now as well. And
> > overall it sounds like an overly complicated approach both for users
> > and for libbpf.
>
> yes. supporting alias() would mean more work in clang, libbpf and
> maybe new bits in BTF.
>
> > As for the extra SEC() annotation. It's both not supported by libbpf
> > right now, and it's not exactly clear how it helps with name conflicts
> > (see example above with two libraries colliding). In that regard a
> > prefix and ability to override it by user gives them an opportunity to
> > resolve such naming conflicts. I know it's kind of ugly, but name
> > overrides should hopefully be rarely needed.
>
> Yes. it's not supported today. All I'm saying it's one of the options.
>
> > What can I do to unblock BPF static linker work, though?
>
> I believe that the way bpf toolchain interprets static is
> a critical long term decision that shouldn't be done lightly.
> There is no rush to define it quickly as an automatic prefix of filename
> to all statics only because it's trivial to implement and sort-of works.
> It's not something we can undo later. Today there are no libraries
> and static definition of maps doesn't really work.
> So the only regression (if we decide to change) would be the way skeleton
> emits statics.
>
> > I don't think we'll find an ideal solution that will satisfy everyone.
>
> I think we didn't even start looking for that solution.
> At least I'm only starting to grasp the complexity of the problem.

I did and didn't find anything satisfactory. But I think we are coming
at this from two different angles, which is why we can't agree on
anything. So just a reminder, static is about two properties:
    1) access protection
    2) naming collisions.

I'm trying to let name collisions on BPF side happen and be allowed
*while* also allowing access to those same name-collisioned entities
(maps and vars, both) from user-space in some non-random fashion. That
inevitably requires some compromises/conventions on the user-space
side. Such an approach preserves both 1) and 2).

You are trying to enforce unique names (or at least aliases) for
static variables, if I understand correctly, which preserves 1) at the
expense of 2). It seems to be a similar idea with custom SEC(), though
you ignored my request to elaborate on how you see that used, so I'm
guessing here a bit.

But I think we can get just 1) with global variables with custom
visibilities. E.g., just marking map/variable as __hidden would
disallow extern'ing it from other files. That's obviously limiting for
extern'ing within the library, so we can keep digging deeper and
define __internal (STV_INTERNAL) that would be "upgraded" to
STV_HIDDEN after the initial linking pass. So you'd compile your BPF
library with __internal, but your lib.bpf.o will have those global
variables as STV_HIDDEN and thus inaccessible from other libraries and
BPF app itself.

So if we are ok breaking existing static variable users, then just
dropping statics from BPF skeleton and supporting extra __hidden and
__internal semantics for variables and maps would bypass these issues.
I wanted statics mostly for property 2), but if I can't get it, then
I'd drop statics from skeletons altogether.

If I could drop statics for skeletons that were statically linked,
that wouldn't be a regression. It's impossible to do right now, but we
can also add a new SHT_NOTE section, which we can use to detect
statically linked vs Clang-generated .bpf.o. Certainly more ELF
fussing around than I'd like, but not the end of the world either.

Thoughts? Did that summarize the issue well enough?
