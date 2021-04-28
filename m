Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADD836DF0B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 20:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbhD1Sli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 14:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbhD1Slh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 14:41:37 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF13C061573;
        Wed, 28 Apr 2021 11:40:52 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q192so21533794ybg.4;
        Wed, 28 Apr 2021 11:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TtZICZnQ98q0CAgvMscWKwp7g86lW1S5rzl8TrxSBwA=;
        b=BXyxVIe2Bbpi+GCb5qCP6R4XhsKe0EVZK995Hj28reSLgurZf5DpcGLfRun8qL8ZPp
         3S+ZIBtyk9ZS1mgJd33ypyzWTcWqs9jvgqhVRrSjoxcu1ZfM1nti+khLDKkQ9ZsSTnoh
         1kjIxRtV2OdAhUX0OOFMV0qW1CTnp9fuzJDDlWFjO6tONJlac7r9SVVy64EH8/eNRs4a
         efsowlr/bCnokiiIiWZ31fSz/MU9SmvyW63dM9TTE3LatNyxykw/whO37W9gTpgcm1n/
         vjV+DGUVSLCJNFYwgFeWRPVfFUcrCF667d8Nys12lvfFHfB2pQaA2gHTJcla0jRssXYW
         y43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TtZICZnQ98q0CAgvMscWKwp7g86lW1S5rzl8TrxSBwA=;
        b=SKCYCb39sXKZMuFv8aTrjUMywZE/2bXJVZzQumBuSHErCQS/b5Bs3R5tyau06DtxGx
         OYHbRRTzr0V7SwLixZmUUcTP3yTCfE0v3wF0YN9F6Q+URYowap3X/R/VPPu3E5++cHbN
         fOpTfN9sWtoia7Gxcdpnb4JqbbC+aMB3xAs0C3Bt51rbwVJIyJBjtS2hCTWVRl5AzUQQ
         hJGKo6MWhPulB8k+rSdoqi3VVVBq2lcVJk76z+fBpokuWAQsgoX2XUZw/rsRrisGpTGe
         h1voBUneQ96diD8UJ9yqiLKsjTbpYHraaGcjsrzd/fRoB1q1JIS52nUszVCxLVzPqhzE
         GYMw==
X-Gm-Message-State: AOAM533UoNO62Jtl9fKIM9P5rIBf+9cZkktNGwYkGu3pEe5w6ETVB/qZ
        e0Al/XNJuDBLR/EWZxjMVB5jtwHYI7L2i/BwKGQ=
X-Google-Smtp-Source: ABdhPJzDZRDGEV5jxod36yEzy1RK02iNIm7IFU4Cbb8FwgClHpgJkzdRBIyWJuPSAeWMFFZX0PrsLdkqRZ8tf5toHzM=
X-Received: by 2002:a25:9942:: with SMTP id n2mr42772019ybo.230.1619635251290;
 Wed, 28 Apr 2021 11:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-10-alexei.starovoitov@gmail.com> <CAEf4BzZ5CJmF45_aBWBHt2jYeLjs2o5VXEA3zfLDvTncW_hjZg@mail.gmail.com>
 <20210427025309.yma2vy4m4qbk5srv@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbDUwev3Wk7_K=2LDwTR0GN8_So8nDUwa9TfSXS0J+FCg@mail.gmail.com> <20210428013242.2iqeygfpmoyzwvxh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210428013242.2iqeygfpmoyzwvxh@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Apr 2021 11:40:40 -0700
Message-ID: <CAEf4BzaXmvkwt0YdovvZebec6tcgLzvb8Gb3mPNFrnuZzspk3w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 09/16] libbpf: Support for fd_idx
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 6:32 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 27, 2021 at 09:36:54AM -0700, Andrii Nakryiko wrote:
> > On Mon, Apr 26, 2021 at 7:53 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Apr 26, 2021 at 10:14:45AM -0700, Andrii Nakryiko wrote:
> > > > On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > >
> > > > > Add support for FD_IDX make libbpf prefer that approach to loading programs.
> > > > >
> > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > > ---
> > > > >  tools/lib/bpf/bpf.c             |  1 +
> > > > >  tools/lib/bpf/libbpf.c          | 70 +++++++++++++++++++++++++++++----
> > > > >  tools/lib/bpf/libbpf_internal.h |  1 +
> > > > >  3 files changed, 65 insertions(+), 7 deletions(-)
> > > > >
> > > >
> >
> > [...]
> >
> > > > >         for (i = 0; i < obj->nr_programs; i++) {
> > > > >                 prog = &obj->programs[i];
> > > > >                 if (prog_is_subprog(obj, prog))
> > > > > @@ -7256,10 +7308,14 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> > > > >                         continue;
> > > > >                 }
> > > > >                 prog->log_level |= log_level;
> > > > > +               prog->fd_array = fd_array;
> > > >
> > > > you are not freeing this memory on success, as far as I can see.
> > >
> > > hmm. there is free on success below.
> >
> > right, my bad, I somehow understood as if it was only for error case
> >
> > >
> > > > And
> > > > given multiple programs are sharing fd_array, it's a bit problematic
> > > > for prog to have fd_array. This is per-object properly, so let's add
> > > > it at bpf_object level and clean it up on bpf_object__close()? And by
> > > > assigning to obj->fd_array at malloc() site, you won't need to do all
> > > > the error-handling free()s below.
> > >
> > > hmm. that sounds worse.
> > > why add another 8 byte to bpf_object that won't be used
> > > until this last step of bpf_object__load_progs.
> > > And only for the duration of this loading.
> > > It's cheaper to have this alloc here with two free()s below.
> >
> > So if you care about extra 8 bytes, then it's even more efficient to
> > have just one obj->fd_array rather than N prog->fd_array, no?
>
> I think it's layer breaking when bpf_program__load()->load_program()
> has to reach out to prog->obj to do its work.
> The layers are already a mess due to:
> &prog->obj->maps[prog->obj->rodata_map_idx]
> I wanted to avoid making it uglier.

I don't think it's breaking any layer. bpf_program is not an
independent entity from libbpf's point of view, it always belongs to
bpf_object. And there are bpf_object-scoped properties, shared across
all progs, like BTF, global variables, maps, license, etc.

It's another thing that bpf_program__load() just shouldn't be a public
API, and we are going to address that in libbpf 1.0.

>
> > And it's
> > also not very clean that prog->fd_array will have a dangling pointer
> > to deallocated memory after bpf_object__load_progs().
>
> prog->reloc_desc is free and zeroed after __relocate.
> prog->insns are freed and _not_ zereod after __load_progs.
> so prog->fd_array won't be the first such pointer.
> I can add zeroing, of course.

cool, it would be great to fix prog->insns to be zeroed out as well

>
> >
> > But that brings the entire question of why use fd_array at all here?
> > Commit description doesn't explain why libbpf has to use fd_array and
> > why it should be preferred. What are the advantages justifying added
> > complexity and extra memory allocation/clean up? It also reduces test
> > coverage of the "old ways" that offer the same capabilities. I think
> > this should be part of the commit description, if we agree that
> > fd_array has to be used outside of the auto-generated loader program.
>
> I can add a knob to it to use it during loader gen for the loader gen
> and for the runner of the loader prog.

So that's why I'm saying a better commit description is necessary. I
lost track, again, that those patched instructions with embedded
map_idx are assumed by prog loader program and then only fd_array is
modified in runtime by BPF loader program. Please, don't skim on
commit description, there are many moving pieces that are obvious only
in hindsight.

Getting back to code, given it's necessary for gen_loader only, I'd
switch out all those `kernel_supports(FEAT_FD_IDX)` checks with
`obj->gen_loader` and leave the current behavior as is. And we also
won't need to do FEAT_FD_IDX feature probing and extra memory
allocation at all. And bpf_load_and_run() uses fd_array
unconditionally without feature probing anyways.

> I think it will add more complexity.
> The bpf CI runs on older kernels, so the test coverage of "old ways"
> is not reduced regardless.

I'm the only one who checks that, and we keep shrinking the set of
tests that run on older kernels because we update existing ones with
dependencies on newer kernel features. So coverage is shrinking, but
basic stuff is still tested, of course.

> From the kernel pov BPF_PSEUDO_MAP_FD vs BPF_PSEUDO_MAP_IDX there is
> no advantage.
> From the libbpf side patch 9 looked trivial enough _not_ do it conditionally,
> but whatever. I don't mind more 'if'-s.

I do mind unnecessary ifs, that's not what I was proposing.
