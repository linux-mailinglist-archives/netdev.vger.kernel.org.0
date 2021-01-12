Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB282F3D07
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438119AbhALVhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436992AbhALUjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:39:07 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D36DC061786;
        Tue, 12 Jan 2021 12:38:27 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id y4so15697ybn.3;
        Tue, 12 Jan 2021 12:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FGkjr+ZPHg8gkKHMJ5dVZ/qAAwMPTiEQsQ9NPkLnGsw=;
        b=jULcu12WaU9v0odTNjin4I1OYOe8T02A7taISfBFOi26DQrCPqobzVqchIkxAhlvL8
         R5wgzYG3UO3qRqNyzpGRfAa/wkdrkQ995zf8XPgSqEQPkl0zL6m8ZsfxI1TBBnsaiDmh
         RyCM1s7r1IZyJNy/MlUQcxVESKvnZvn4gI3DUbn7RjNcJ6fZ6Cl2oHnAO7MWDaCNUobs
         mwhmdeewrmcv3u68Xp0MfBboWFcerxbJ07HIl4ejXomMhxo2jAqc7WUSAUO157iidCdB
         MwVgWvV2yslpnrPhAzj3L8S+iGfJuZZmiRKIpWcGSeR4gGn73bzD2tA/qoWjKKMFEBMh
         pfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FGkjr+ZPHg8gkKHMJ5dVZ/qAAwMPTiEQsQ9NPkLnGsw=;
        b=pwL3dr+y+kOGOmkMirT+yduWzeHIGYNxIOZLQLxiYd1LAAikJsrLLwR7YdUdepjLrS
         S+vls6ZBj/dcMlr1AwI79vkuzTEbdh9sgOwKM6BxiovKPtSfJMiBr0ZFd6OfFb2fbpcB
         geUviroqlxUD8vUQMhK+/M31ZFN2Ad5GcfNq94aghs2J5wMhrWF5OQoDp8v18O9NGXO9
         EbBZCGPaPHLHQz2p9Zn39uvXNt9dCh2hUxEyUKmLekS9hpkEbEjc+fPKJ8LXtBFSKTCa
         Ny3lqV3Lc1Y4BOmBBcYLXdmepCw1zL+QmykC9248G0DZZDy25yK4OsxsvqwWtq7bt6a9
         lMmA==
X-Gm-Message-State: AOAM533T/KSIXtCiSJvz0oCTmDTrjlc9d+3cg8Ww/A87kj4hODIEjb4A
        gaBzcheHNiWUW1z621gKT+N9zfP4TUVkqf8BYxw=
X-Google-Smtp-Source: ABdhPJzOss52FqTn1amUQk7+g9gwMXium7+WRElgGVdglKBYIVt9zkPRYqG4/TB6JpZhEugXBz2Iwo/uxk8TARw3kQA=
X-Received: by 2002:a25:9882:: with SMTP id l2mr1665224ybo.425.1610483906401;
 Tue, 12 Jan 2021 12:38:26 -0800 (PST)
MIME-Version: 1.0
References: <20210112075520.4103414-1-andrii@kernel.org> <20210112075520.4103414-6-andrii@kernel.org>
 <4155ef59-9e5e-f596-f22b-ecd4bde73e85@iogearbox.net>
In-Reply-To: <4155ef59-9e5e-f596-f22b-ecd4bde73e85@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Jan 2021 12:38:15 -0800
Message-ID: <CAEf4BzbjuWO68DKNH28wYYN9Bcu8HjWN3_sGnRhoZozvfanJkQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/7] bpf: support BPF ksym variables in kernel modules
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 8:27 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
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
>

Yeah, it's definitely nice to see dependent bpf progs. There is struct
module_use, which is used to record these dependencies, but the
assumption there is that dependencies could be only other modules. So
one way is to somehow extend that or add another set of bpf_prog
dependencies. First is a bit intrusive, while the seconds sucks even
more, IMO.

Alternatively, we can rely on bpf_link info to emit module info, if
the BPF program is attached to BTF type from the module. Then with
bpftool it would be easy to see this, but it's not as
readily-available info as /proc/modules, of course.

Any preferences?

> > +             break;
> > +     }
> > +     mutex_unlock(&btf_module_mutex);
> > +#endif
> > +
> > +     return res;
> > +}
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 261f8692d0d2..69c3c308de5e 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -2119,6 +2119,28 @@ static void bpf_free_used_maps(struct bpf_prog_aux *aux)
> >       kfree(aux->used_maps);
> >   }
> >
> > +void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
> > +                       struct btf_mod_pair *used_btfs, u32 len)
> > +{
> > +#ifdef CONFIG_BPF_SYSCALL
> > +     struct btf_mod_pair *btf_mod;
> > +     u32 i;
> > +
> > +     for (i = 0; i < len; i++) {
> > +             btf_mod = &used_btfs[i];
> > +             if (btf_mod->module)
> > +                     module_put(btf_mod->module);
> > +             btf_put(btf_mod->btf);
> > +     }
> > +#endif
> > +}
