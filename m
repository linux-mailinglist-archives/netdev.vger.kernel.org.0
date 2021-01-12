Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334572F403E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbhALXTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388390AbhALXTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 18:19:52 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36444C061575;
        Tue, 12 Jan 2021 15:19:12 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o17so5926177lfg.4;
        Tue, 12 Jan 2021 15:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2Ayl33U2+jwFSkBY0C2/B0oa+AK3RI49yKP+WjxVhg=;
        b=LbRWSzUcLdepsLvb8kTLdaLBag4uohB7z/fJT2cFD6Ki5GzDIbtG2UFVLF229snzwV
         lkLyyGPWwHGgPlB9G+U759uOn7O589qOQ6I1jcn4I75YrN2ry9lKOjoaljOF6Ig9lzVb
         4Fx2ufDuzu89uKCnRTLV9gLLE2m3wJQNUPeGW9NPiYL8s0E92wYna5rTpcPF5dsm6Wob
         qXPQk4Wy2IfGMeEONZ/VoWswjrTQvKdq0ZQJI3hsx8kNnb8kqajoih+HRfmClPT52Aqr
         +UpNl8cwNfYnp0XbyBs4TYrhXO3brpLxEhV0ZUgloIjzXN0pUsSMrGFZ2QiL1ibqoLp7
         4y6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2Ayl33U2+jwFSkBY0C2/B0oa+AK3RI49yKP+WjxVhg=;
        b=UvPbPzjzKpxP6NOBQ4qw1DNNONl3EyFuzAxGnTx39cVwinNdgrxDUA8FLz05eEd3nT
         40wYSUE2W9N2vn80QuIDxeqxeGsuB34AGOcyimLt7B7enEV36pyd1wL4scI1rLqCxHj6
         6OspUQv8VZk6/m2zHzMuCAkn8Y/k8yHEF1L1zvUtMFr/NUYHQRpExj2ZhjRl8uLyp1gS
         ORvOuYlU+g/31AmGSHsUEN/bvtK9H8kxcTDKAP5B+ZEwg5atlBr4Qld3vebCalpVh6QY
         V6G31pCDf38SwcNNzqrqS4Gt7evT1U6RKesvyjDsIE4plsPDPx1Vqnp+bl9O6DiQ2Zpr
         3Ffg==
X-Gm-Message-State: AOAM532l4vFmGm5fCDH0rHhMnsdmFSmjOCWBYM+FlmDqhz5JbOojFnr8
        i2jT2W7JThyFgtzdWql7e67Wdd4SbBnyK2EZtRC60w+1zgM=
X-Google-Smtp-Source: ABdhPJxPHixFYs6g/zX3DOUEMOuUb3z06V+hSOSkCimhR9xOiiFqXkeYg79q1wA2oWYnG/qPMpVqVRWkrD1oZkAYNRU=
X-Received: by 2002:a19:8b83:: with SMTP id n125mr565827lfd.75.1610493550708;
 Tue, 12 Jan 2021 15:19:10 -0800 (PST)
MIME-Version: 1.0
References: <20210112075520.4103414-1-andrii@kernel.org> <20210112075520.4103414-6-andrii@kernel.org>
 <4155ef59-9e5e-f596-f22b-ecd4bde73e85@iogearbox.net>
In-Reply-To: <4155ef59-9e5e-f596-f22b-ecd4bde73e85@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 12 Jan 2021 15:18:59 -0800
Message-ID: <CAADnVQLjv3iLT3yWyR8tK7kAU8sM1giW_cbMcHHQpDCMigivgQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/7] bpf: support BPF ksym variables in kernel modules
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 8:30 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/12/21 8:55 AM, Andrii Nakryiko wrote:
> > Add support for directly accessing kernel module variables from BPF programs
> > using special ldimm64 instructions. This functionality builds upon vmlinux
> > ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
> > specifying kernel module BTF's FD in insn[1].imm field.
> >
> > During BPF program load time, verifier will resolve FD to BTF object and will
> > take reference on BTF object itself and, for module BTFs, corresponding module
> > as well, to make sure it won't be unloaded from under running BPF program. The
> > mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> >
> > One interesting change is also in how per-CPU variable is determined. The
> > logic is to find .data..percpu data section in provided BTF, but both vmlinux
> > and module each have their own .data..percpu entries in BTF. So for module's
> > case, the search for DATASEC record needs to look at only module's added BTF
> > types. This is implemented with custom search function.
> >
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Acked-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> [...]
> > +
> > +struct module *btf_try_get_module(const struct btf *btf)
> > +{
> > +     struct module *res = NULL;
> > +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> > +     struct btf_module *btf_mod, *tmp;
> > +
> > +     mutex_lock(&btf_module_mutex);
> > +     list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
> > +             if (btf_mod->btf != btf)
> > +                     continue;
> > +
> > +             if (try_module_get(btf_mod->module))
> > +                     res = btf_mod->module;
>
> One more thought (follow-up would be okay I'd think) ... when a module references
> a symbol from another module, it similarly needs to bump the refcount of the module
> that is owning it and thus disallowing to unload for that other module's lifetime.
> That usage dependency is visible via /proc/modules however, so if unload doesn't work
> then lsmod allows a way to introspect that to the user. This seems to be achieved via
> resolve_symbol() where it records its dependency/usage. Would be great if we could at
> some point also include the BPF prog name into that list so that this is more obvious.
> Wdyt?

I thought about it as well, but plenty of kernel things just grab the ref of ko
and don't add any way to introspect what piece of kernel is holding ko.
So this case won't be the first.
Also if we add it for bpf progs it could be confusing in lsmod.
Since it currently only shows other ko-s in there.
Long ago I had an awk script to parse that output to rmmod dependent modules
before rmmoding the main one. If somebody doing something like this
bpf prog names in the same place may break things.
So I think there are more cons than pros.
That is certainly a follow up if we agree on the direction.
