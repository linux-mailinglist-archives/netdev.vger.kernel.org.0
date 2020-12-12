Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74F82D84DB
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 06:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438062AbgLLFYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 00:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437153AbgLLFYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 00:24:30 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC62C0613CF;
        Fri, 11 Dec 2020 21:23:50 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id a16so10129189ybh.5;
        Fri, 11 Dec 2020 21:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Duo/V9MeMQ+jdY4AQzE6ijsYqIG1Vac3kVwwzJgJz+c=;
        b=LrakrQqRdmbG9nW3OTok8WdqMNhJCbECh7y/tSBNAj/u29Mrzw8lqq+kvGXZnFraj/
         /c2QJKyj3RmWgWxNWJS6yaBTPzm0iQZiXD2MdHy2dtbM+VyK+WA7SUT0B49HMFaySYG6
         p1DyBcrjbVM++no4WYvu3vK9bv5IBOcvQ3PhHkvdwQ387WhFV/9Txmax/0A6ymAoUydU
         iaKwGL4WVjPBY6RiJ9SCdN8oTjCwvA48HqDroucufUbZgpA5Bpt2z72Kk3vxIMDWa0AJ
         vIJC0YGGTfxpdrSdSTtQt3QuNQjO7lFUf7IilBizTqD+Trpj7MdW+e64emEkOdhh5xFa
         NrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Duo/V9MeMQ+jdY4AQzE6ijsYqIG1Vac3kVwwzJgJz+c=;
        b=STvpS3DSrzqvxV5NXb2OIoPMmOtuZkQ/w4kHWV5dMDgW0T7M43NEnnK9sBCEqIo03i
         zTNCix1+TDG4BS/qVeS160HDL9chTJyMDXIQ1xk8iM0LcAdrlpoWpXKyzyaBfQqybD4/
         yPkPAObbRv0qVzSeb7wO531BoGPFy5zb2rzP/gUC86ayNoux+eMcPuh+nat4339XB2xU
         9ZvOrOuuuy6FrEQtxkXEglUTlgU+ORaiKezNYUO2KOCmsgx3MaAnqs0FULZEofn5BNZg
         Tpq7PMpTzS/7Yo3EmWVSXY9aoV4X0SSOBicw2znGousPzRDrDy2dFmX1BcQ7deO/vEix
         Nn7g==
X-Gm-Message-State: AOAM532B8eQX4Bk7u3uDmaSVJZWSdOTrtqY1Dx2Nl/cq9M2dlQ7Omhq5
        c7+mcAVShPcnCS1qMgTc5gbgegcY88V8f/2AxCoaDD9j4So=
X-Google-Smtp-Source: ABdhPJwV0MzYKBDvBIX/K0ayk+D1VSxfkOMyU23g4tJhGZqjlN9kgTGjTSd2qaBHfYkgm2raqjHowrRPtTix7tf+NP0=
X-Received: by 2002:a25:f505:: with SMTP id a5mr22760488ybe.425.1607750629250;
 Fri, 11 Dec 2020 21:23:49 -0800 (PST)
MIME-Version: 1.0
References: <20201211042734.730147-1-andrii@kernel.org> <20201211042734.730147-3-andrii@kernel.org>
 <20201211212741.o2peyh3ybnkxsu5a@ast-mbp> <CAEf4BzbZK8uZOprwHq_+mh=2Lb27POv5VMW4kB6eyPc_6bcSPg@mail.gmail.com>
 <20201212015215.zmychededhpv55th@ast-mbp>
In-Reply-To: <20201212015215.zmychededhpv55th@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Dec 2020 21:23:38 -0800
Message-ID: <CAEf4BzY=CVXkpLStPQcFU8Xzk9yNNX+Q5izzeHiuC0PB7k-bPg@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 2/4] bpf: support BPF ksym variables in
 kernel modules
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 5:52 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 11, 2020 at 02:15:28PM -0800, Andrii Nakryiko wrote:
> > On Fri, Dec 11, 2020 at 1:27 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Dec 10, 2020 at 08:27:32PM -0800, Andrii Nakryiko wrote:
> > > > During BPF program load time, verifier will resolve FD to BTF object and will
> > > > take reference on BTF object itself and, for module BTFs, corresponding module
> > > > as well, to make sure it won't be unloaded from under running BPF program. The
> > > > mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> > > ...
> > > > +
> > > > +     /* if we reference variables from kernel module, bump its refcount */
> > > > +     if (btf_is_module(btf)) {
> > > > +             btf_mod->module = btf_try_get_module(btf);
> > >
> > > Is it necessary to refcnt the module? Correct me if I'm wrong, but
> > > for module's BTF we register a notifier. Then the module can be rmmod-ed
> > > at any time and we will do btf_put() for corresponding BTF, but that BTF may
> > > stay around because bpftool or something is looking at it.
> >
> > Correct, BTF object itself doesn't take a refcnt on module.
> >
> > > Similarly when prog is attached to raw_tp in a module we currently do try_module_get(),
> > > but is it really necessary ? When bpf is attached to a netdev the netdev can
> > > be removed and the link will be dangling. May be it makes sense to do the same
> > > with modules?  The raw_tp can become dangling after rmmod and the prog won't be
> >
> > So for raw_tp it's not the case today. I tested, I attached raw_tp,
> > kept triggering it in a loop, and tried to rmmod bpf_testmod. It
> > failed, because raw tracepoint takes refcnt on module. rmmod -f
>
> Right. I meant that we can change that behavior if it would make sense to do so.

Oh, ok, yeah, I guess we can. But given it's been like that for a
while and no one complained, might as well leave it as is for now.

>
> > bpf_testmod also didn't work, but it's because my kernel wasn't built
> > with force-unload enabled for modules. But force-unload is an entirely
> > different matter and it's inherently dangerous to do, it can crash and
> > corrupt anything in the kernel.
> >
> > > executed anymore. So hard coded address of a per-cpu var in a ksym will
> > > be pointing to freed mod memory after rmmod, but that's ok, since that prog will
> > > never execute.
> >
> > Not so fast :) Indeed, if somehow module gets unloaded while we keep
> > BPF program loaded, we'll point to unallocated memory **OR** to a
> > memory re-used for something else. That's bad. Nothing will crash even
> > if it's unmapped memory (due to bpf_probe_read semantics), but we will
> > potentially be reading some garbage (not zeroes), if some other module
> > re-uses that per-CPU memory.
> >
> > As for the BPF program won't be triggered. That's not true in general,
> > as you mention yourself below.
> >
> > > On the other side if we envision a bpf prog attaching to a vmlinux function
> > > and accessing per-cpu or normal ksym in some module it would need to inc refcnt
> > > of that module, since we won't be able to guarantee that this prog will
> > > not execute any more. So we cannot allow dangling memory addresses.
> >
> > That's what my new selftest is doing actually. It's a generic
> > sys_enter raw_tp, which doesn't attach to the module, but it does read
> > module's per-CPU variable.
>
> Got it. I see that now.
>
> > So I actually ran a test before posting. I
> > successfully unloaded bpf_testmod, but kept running the prog. And it
> > kept returning *correct* per-CPU value. Most probably due to per-CPU
> > memory not unmapped and not yet reused for something else. But it's a
> > really nasty and surprising situation.
>
> you mean you managed to unload early during development before
> you've introduced refcnting of modules?

Yep, exactly.

>
> > Keep in mind, also, that whenever BPF program declares per-cpu
> > variable extern, it doesn't know or care whether it will get resolved
> > to built-in vmlinux per-CPU variable or module per-CPU variable.
> > Restricting attachment to only module-provided hooks is both tedious
> > and might be quite surprising sometimes, seems not worth the pain.
> >
> > > If latter is what we want to allow then we probably need a test case for it and
> > > document the reasons for keeping modules pinned while progs access their data.
> > > Since such pinning behavior is different from other bpf attaching cases where
> > > underlying objects (like netdev and cgroup) can go away.
> >
> > See above, that's already the case for module tracepoints.
> >
> > So in summary, I think we should take a refcnt on module, as that's
> > already the case for stuff like raw_tp. I can add more comments to
> > make this clear, of course.
>
> ok. agreed.
>
> Regarding fd+id in upper/lower 32-bit of ld_imm64...
> That works for ksyms because at that end the pair is converted to single
> address that fits into ld_imm64. That won't work for Alan's case
> where btf_obj pointer and btf_id are two values (64-bit and 32-bit).
> So api-wise it's fine here, but cannot adopt the same idea everywhere.

Right, won't work for Alan, but not because of ldimm64 not having
space for pointer and u32. There is bpf_insn_aux, which can store
whatever extra needs to be stored, if necessary.

But for Alan's case, because we want runtime lookup of btf obj + btf
id, the approach has to be different. We might do something like
sockmap, but for BPF types. I.e., user-space writes btf fd + btf id,
but internally we take BTF obj refcnt and store struct btf * and btf
type ID. On read we get BTF object ID + BTF type ID, for example.
WDYT?


>
> re: patch 4
> Please add non-percpu var to the test. Just for completeness.
> The pair fd+id should be enough to disambiguate, right?

Right, kernel detects per-CPU vs non-per-CPU on its own from the BTF
info. The problem is that pahole doesn't generate BTF for non-per-CPU
variables, so it's really impossible to test non-per-CPU variables
right now. :(

>
> re: patch 1.
> Instead of copy paste that hack please convert it to sys_membarrier(MEMBARRIER_CMD_GLOBAL).

Oh, cool, didn't know about it, nice.

>
> The rest looks good to me.
