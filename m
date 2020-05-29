Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B281E8906
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgE2UlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgE2Uk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:40:59 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6902EC03E969;
        Fri, 29 May 2020 13:40:58 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j32so3058007qte.10;
        Fri, 29 May 2020 13:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXkNvGIjvhtl1zJvkrCHCb9Rfn4fNhDMflNxOWodfvg=;
        b=KYnDTv94Nn4hSZ/ju6jtpSsfnesA2SVvk+4jNMv4P0JWqt9yLCxuztmPrYEuh4hzrS
         lpmPhn07QXkRuSrpy4ksWzqD91AhXZ1Kn5GrPqVeo/5azESTJTEHisSAvWPYaaRn6cTo
         tjF9aWNmPVuv/HRYsiwkUZPbz8p3eF5MgLvzwrJn2tJQMySrftF0geMITy9bLkolQEP0
         nbMeQZ03uv2ip+YIJyYSV5M2bY8le0mzykAknH8Wf6wjeRKx/sGhyPGu2O+i3lWw33hs
         2M0GDtJiWHloSTLPhhc2VClW2HoKOchETK3QU6S0Hj7/mKghlsnXG4ghamPdwjG1+6Og
         M6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXkNvGIjvhtl1zJvkrCHCb9Rfn4fNhDMflNxOWodfvg=;
        b=aFK0xUpJIxodj0D0nZsSK4+Z0JIUflvWtS58UaNwoJLdyOsbiN+Y8CL1AXz8PZBwQX
         s2/zSI2iFg4mDMB8hzeihAVoqvlo3eSc99MRBupqvFpoTXvJI2xI50SEyHhrcwf8tnZK
         Fz8IR4tLQQ4IlDF4awHSpBwBgvcvnuYpZE/8uFabDvNvgXvFzL9Q50AX2r1L1nzaXtiY
         h+MS27OlSaD7erYzx5MExfDwRUjKrzeXYTHMgwDZZjrXp7QjLjctRgfnJPg8HqSvNf1I
         Iun8FCsvjLr5q5//3GHEXo+q/o2Tx6ckLcVlZ3TkCfgkiYrQ/hTG/KtwFUaiIqBtldSo
         ObYQ==
X-Gm-Message-State: AOAM5336Wnjs5H7aYMajrlsaKQs3PezlWX66xXqfyiJ7ktRFcWT7s24o
        jrhpDI8GSKev7TXHbb016MrJz4uEkGDKVuCWq6U=
X-Google-Smtp-Source: ABdhPJxy8XOGr60jC8pyD/7Mc1YaCm8dDHvdq6Zke732oHVgjfT6bZgh8yqOi3LAtpZV1iNyGsMGeDQ1+l+uqozSnxY=
X-Received: by 2002:aed:3f3b:: with SMTP id p56mr10434675qtf.93.1590784857482;
 Fri, 29 May 2020 13:40:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200522022336.899416-1-kafai@fb.com> <20200522022342.899756-1-kafai@fb.com>
 <9c00ced2-983f-ad59-d805-777ebd1f1cab@iogearbox.net> <20200523010003.6iyavqny3aruv6u2@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza===GwERi_x0Evf_Wjm+8=wBHnG4VHPNtZ=GPPZ+twiQ@mail.gmail.com> <20200529063054.edz7qfiqgfgjzj43@kafai-mbp>
In-Reply-To: <20200529063054.edz7qfiqgfgjzj43@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 May 2020 13:40:46 -0700
Message-ID: <CAEf4BzbpwfFPUruwdbcarTeT_7pcxNw5PPO0RE81QLvJxkXOBw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Consolidate inner-map-compatible
 properties into bpf_types.h
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 11:31 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, May 26, 2020 at 10:54:26AM -0700, Andrii Nakryiko wrote:
> > On Fri, May 22, 2020 at 6:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Sat, May 23, 2020 at 12:22:48AM +0200, Daniel Borkmann wrote:
> > > > On 5/22/20 4:23 AM, Martin KaFai Lau wrote:
> > > > [...]
> > > > >   };

[...]


> > >
> > > >
> > > > Like explicit annotating via struct bpf_map_ops where everything is visible in one
> > > > single place where the map is defined:
> > > >
> > > > const struct bpf_map_ops array_map_ops = {
> > > >         .map_alloc_check = array_map_alloc_check,
> > > >         [...]
> > > >         .map_flags_fixed = BPF_MAP_IN_MAP_OK,
> > > > };
> > > I am not sure about adding it to bpf_map_ops instead of bpf_types.h.
> > > It will be easier to figure out what map types do not support MAP_IN_MAP (and
> > > other future map's fixed properties) in one place "bpf_types.h" instead of
> > > having to dig into each map src file.
> >
> > I'm 100% with Daniel here. If we are consolidating such things, I'd
> > rather have them in one place where differences between maps are
> > defined, which is ops. Despite an "ops" name, this seems like a
> > perfect place for specifying all those per-map-type properties and
> > behaviors. Adding flags into bpf_types.h just splits everything into
> > two places: bpf_types.h specifies some differences, while ops specify
> > all the other ones.
> >
> > Figuring out map-in-map support is just one of many questions one
> > might ask about differences between map types, I don't think that
> > justifies adding them to bpf_types.h. Grepping for struct bpf_map_ops
> > with search context (i.e., -A15 or something like that) should be
> > enough to get a quick glance at all possible maps and what they
> > define/override.
> >
> > It also feels like adding this as bool field for each aspect instead
> > of a collection of bits is cleaner and a bit more scalable. If we need
> > to add another property with some parameter/constant, or just enum,
> > defining one of few possible behaviors, it would be easier to just add
> > another field, instead of trying to cram that into u32. It also solves
> > your problem of "at the glance" view of map-in-map support features.
> > Just name that field unique enough to grep by it :)
> How about another way.  What patch 2 want is each map could have its own
> bpf_map_meta_equal().  Instead of adding 2 flags, add the bpf_map_meta_equal()
> as a ops to bpf_map_ops.  Each map supports to be used as an inner_map
> needs to set this ops.  Then it will be an opt-in.
> A default implementation can be provided for most maps' use.
> The maps (e.g. arraymap and other future maps) that has different requirement
> can implement its own.  For the existing maps, when we address those
> limitations (e.g. arraymap's gen_lookup) later,  we can then change its
> bpf_map_meta_equal.
>
> Thoughts?
>

I think that would work as well, I don't mind.

> >
> > >
> > > If the objective is to have the future map "consciously" opt-in, how about
> > > keeping the "BPF_MAP_TYPE" name as is but add a fixed_flags param as the
> > > earlier v1 and flip it from NO to OK flag.  It will be clear that,
> > > it is a decision that the new map needs to make instead of a quiet 0
> > > in "struct bpf_map_ops".
> > >
> > > For example,
> > > BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops, BPF_MAP_IN_MAP_OK)
> > > BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops, 0)
> > > BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops, BPF_MAP_IN_MAP_OK | BPF_MAP_IN_MAP_DYNAMIC_SIZE_OK)
> > >
> > > >
> > > > That way, if someone forgets to add .map_flags_fixed to a new map type, it's okay since
> > > > it's _safe_ to forget to add these flags (and okay to add in future uapi-wise) as opposed
> > > > to the other way round where one can easily miss the opt-out case and potentially crash
> > > > the machine worst case.
