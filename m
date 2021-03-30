Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DC034F064
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhC3SBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 14:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbhC3SAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 14:00:55 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8A4C061574;
        Tue, 30 Mar 2021 11:00:54 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id x189so18330166ybg.5;
        Tue, 30 Mar 2021 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JPCVgHC06KGxZ8d0B9PzGmGGDLqoKdjmyAG5QpX9hX0=;
        b=odLcWm6v025rOqkb028ZTg4+B+I2Pxvq55kLnNkRKyEEV5ILbbA3X0ZTpMCtZVfImM
         psrNtF1Wj+EXZeiKHM4+XsELHtdSxbrofYuSd7vSp6nHZECKq2a+GnUKH4tBlCEmq3ms
         hZyw8aAI1RFOYySioWthKwMtW+I6f7Yo46/OK3BcwX+Yi5Q8ruCdTuxNsHqmreEMel9c
         U5jCZyJ1cNw1ZxtijJ+wfsxJFIy/j9PYdzOdm+GdmEoQH8FRsWhGLWf5FdLPLr83ft25
         Gxbbnql3pilkPLRlr9US4flryCSlV5dGv7CSndCTMa3uSU12VBzwknnk+eMfb0mO2pcC
         +SLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JPCVgHC06KGxZ8d0B9PzGmGGDLqoKdjmyAG5QpX9hX0=;
        b=YdFdTNIhwY+Y2FXb+8/GNLBMIRO28v2GpibD6TlYRSFvxs2I+9GJwYMtajwRMD56st
         5DITVYKisrb62FR3n8Sb0GeTLhfGBbH0FyGNUHWkxK4VoDeK+tbEjeiDSPlWJb9/2QV3
         V+7hG6+4GEb7x3akLyDcTlhlG0J2NWqvQdqOyv9UmPBgn43QlBcBpUjp1nmzvZQpUmpD
         rcEHIuFzl/oF6rYrF6Pary7pm1G9Gev4zPLGcdfUNQkfw/R3DZ5Chd6JzzH8dd82kPhI
         h8KBKW2vZYcDSgneUFy7nniLpel6BfkbzIrOd3T0sRapAQNZoC9x2GmY5sFdhHilUPok
         pkvg==
X-Gm-Message-State: AOAM5316l/r7ceHb9LrJR0Tza/BmxpxeoG2L9VBS8f6AWPfOI5SzaPsz
        8od0zhNSVM3Fmj4J0s8A6Wy42BO5HVQwHGWvhIU=
X-Google-Smtp-Source: ABdhPJy97zq99yz43eQFJwipVPHazYHtngdKQuW20Aka0q5rhEKf8eSQf1KhtTwcYzF41kPrK01Sm0rROFPrGJR+jXw=
X-Received: by 2002:a25:9942:: with SMTP id n2mr45449290ybo.230.1617127254136;
 Tue, 30 Mar 2021 11:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210319205909.1748642-1-andrii@kernel.org> <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp> <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
 <20210322010734.tw2rigbr3dyk3iot@ast-mbp> <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
 <20210322175443.zflwaf7dstpg4y2b@ast-mbp> <CAEf4BzYHP00_iav1Y_vhMXBmAO3AnqqBz+uK-Yu=NGYUMEUyxw@mail.gmail.com>
 <CAADnVQKDOWz7fW0kxGEeLtMJLf7J5v9Un=uDXKmwhkweoVQ3Lw@mail.gmail.com>
 <CAEf4Bza-uieOvR6AQkC-suD=_mjs5KC_1Ra3xo9kvdSxAMmeRg@mail.gmail.com> <20210329185558.mjoikgfdp53lq2it@ast-mbp>
In-Reply-To: <20210329185558.mjoikgfdp53lq2it@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Mar 2021 11:00:43 -0700
Message-ID: <CAEf4BzYQFbngzELvyySd_f-otYOe74rH4ESNMDCEo5+PJw=umQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
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

On Mon, Mar 29, 2021 at 11:56 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Mar 28, 2021 at 11:09:23PM -0700, Andrii Nakryiko wrote:
> >
> > BPF skeleton works just fine without BTF, if BPF programs don't use
> > global data. I have no way of knowing how BPF skeleton is used in the
> > wild, and specifically whether it is used without BTF and
> > .data/.rodata.
>
> No way of knowing?

Yes, of course I don't know all the ways that people use bpftool and
how they write applications. We can speculate about probability of
breaking someone's flow and how low chances are, but ultimately we are
guessing and hoping.

> The skel gen even for the most basic progs fails when there is no BTF in .o
>
> $ bpftool gen skeleton prog_compiled_without_dash_g.o
> libbpf: BTF is required, but is missing or corrupted.
>
> libbpf_needs_btf() check is preventing all but the most primitive progs.

Up until less than two years ago those were the only programs you
could write with libbpf. It's up to everyone's opinion to qualify them
as primitive or not. We even still have few selftests (which we should
convert, of course) that use bpf_map_def.

> Any prog with new style of map definition:
> struct {
>         __uint(type, BPF_MAP_TYPE_ARRAY);
>         __uint(max_entries, 1);
>         __type(key, __u32);
>         __type(value, __u64);
> } array SEC(".maps");
> would fail skel gen.
>
> bpftool is capable of skel gen for progs with old style maps only:
> struct bpf_map_def SEC("maps")
>

Yes, that's why my test is using a legacy-style map definition (which
for better or worse is still supported by libbpf). One can still write
full-fledged BPF applications without any BTF whatsoever.

> I think it's a safe bet that if folks didn't adopt new map definition
> they didn't use skeleton either.

I'm not going to argue, because I don't know. If I knew about BPF
skeleton but couldn't upgrade Clang, for instance, I'd still use BPF
skeleton to get nice access to maps/progs and get BPF object file
embedding in user-space without the hassle of distributing additional
.o.

>
> I think making skel gen reject such case is a good thing for the users,
> since it prevents them from creating maps that look like blob of bytes.
> It's good for admins too that more progs will get BTF described map key/value
> and systems are easier to debug.

I agree it's good, I added BTF-defined maps myself for that very reason.

>
> Ideally the kernel should reject loading progs and maps without BTF
> to guarantee introspection.
> Unfortunately the kernel backward compatibility prevents doing such
> drastic things.
> We might add a sysctl knob though.
>
> The bpftool can certainly add a message and reject .o-s without BTF.
> The chance of upsetting anyone is tiny.

Ok.

> Keep supporting old style 'bpf_map_def' is a maintenance burden.
> Sooner or later it needs to be removed not only from skel gen,
> but from libbpf as well.

I've already proposed to remove that in libbpf v1.0. See [0] for
discussion in the doc around that.

   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY?disco=AAAALj68dg8

>
> > No one is asking for that, but they might be already using BTF-less
> > skeleton. So I'm fixing a bug in bpftool. In a way that doesn't cause
> > long term maintenance burden. And see above about my stance on tools'
> > assumptions.
>
> The patch and long term direction I'm arguing against is this one:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210319205909.1748642-2-andrii@kernel.org/
> How is this a bug fix?
> From commit log:
> "If BPF object file is using global variables, but is compiled without BTF or
> ends up having only some of DATASEC types due to static linking"
>
> global vars without BTF were always rejected by bpftool

That's exactly what I consider a bug, because it wasn't intentional on my part.

> and should continue being rejected.
> I see no reason for adding such feature.
>
> > we both know this very well. But just as a fun exercise, I just
> > double-checked by compiling fentry demo from libbpf-bootstrap ([0]).
> > It works just fine without `-g` and BTF.
> >
> >   [0] https://github.com/libbpf/libbpf-bootstrap/blob/master/src/fentry.bpf.c
>
> yes. the skel gen will work for such demo prog, but the user should
> be making them introspectable.
>
> Try llvm-strip prog.o
> Old and new bpftool-s will simply crash, because there are no symbols.
> Should skel gen support such .o as well?

No, because libbpf doesn't support loading such BPF object files.
While my proposed patch was fixing the case in which libbpf would load
BPF object file.

> I don't think so. imo it's the same category of non-introspectable progs
> that shouldn't be allowed.
>

I understand. I just hope there was an opportunity to not always agree
100% with your opinions and have discussion without exaggerated
claims, like BPF skeleton not usable without BTF and others I tried to
address in this thread.

So, in summary, let's drop the patch.

> > Yeah, that's fine and we do require BTF for new features (where it
> > makes sense, of course, not just arbitrarily).
>
> I'm saying the kernel should enforce introspection.
> sysctl btf_enforced=1 might be the answer.
