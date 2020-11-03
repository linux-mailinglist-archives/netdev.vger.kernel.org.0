Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C732A4FF5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgKCTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbgKCTTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:34 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A29AC0613D1;
        Tue,  3 Nov 2020 11:19:34 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id a200so15100257pfa.10;
        Tue, 03 Nov 2020 11:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RyTUHv4YPLTNqL42MTqa/fFS08HR2dajcyLQhdo9vRs=;
        b=LoYboUnHFQ3lxhuQT6RRR/I/kiFa6P1380rLhwUGdHscqd75CFuNDxUwo46/P1QYRO
         kX2dtjRF/Lfs70NWS1UlHiyh/a4EgKZpJq8LBrJheRjh4dWbOmN9r7d6rdXK0kKygIFV
         vG01bgpQGk2sGuu9rbEdeqPY8X/CZ4eVUHDREeOpE5+Vq4+f2i4hi/DrvyhjYBnneT+g
         pwCyBxGvmYfSB6W+mXDw1n7r50Nou9jQS2LuO8qnuVoEgc8g0CKa2Ifz289fe9pRBu1v
         9v/XfxkFbA+ETHQ83acEr23zBclzMESJgpUxVS4emEr6p0ZectaduvuAC5lQeU78DZFP
         re6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RyTUHv4YPLTNqL42MTqa/fFS08HR2dajcyLQhdo9vRs=;
        b=L05Yn/wUmSxHe+oOX7lfcRcLrQaVwhfs6PCFMvjfi+uhPsE009/0pOw3SiJwOXordB
         1j6Cr0K7eU61VLn/aZGItRkb7NvfWr2EYzNN85KXlxSw+aSW139nxOKjrOgODvUwn0VI
         6u+8Tn96Z1LUXqoRl2uu88GY+uZyAY4DHIx2BzddKcW8+TAfHv0TJDrgBSzUEAWWy9/5
         oV5gcwUaECizXhu6T0egLwsBBRZQW4y9Zcn2p8E7sT36DbY63AMN22kdQLRLZ6QtZKKK
         R9x3jXdHEYoKHBF44cTAwLpGnQw92G7/y1LCTShcfVtPguFbdcWdVSDgeH8XpHws91Cf
         +HVQ==
X-Gm-Message-State: AOAM53213X+muMe0x/iCb2Y7mi9dZLmaSL3IJz+15FuMukjq6hFm1TfV
        lpbzynfeh4MQtv1AQ5JTg+DKD2aXvhSuoLiIbvU=
X-Google-Smtp-Source: ABdhPJyS5KGX9mdkfbE1gtYPEJ7SMa69KuVYRRcH1stREUhbeiEnctTzXjnI+hsOhH4oDKqG2vLQpMQT7LtdOXPDG1M=
X-Received: by 2002:a62:5f83:0:b029:18a:e039:4908 with SMTP id
 t125-20020a625f830000b029018ae0394908mr11860139pfb.23.1604431173654; Tue, 03
 Nov 2020 11:19:33 -0800 (PST)
MIME-Version: 1.0
References: <20201007152355.2446741-1-Kenny.Ho@amd.com> <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com> <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
In-Reply-To: <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Tue, 3 Nov 2020 14:19:22 -0500
Message-ID: <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kenny Ho <Kenny.Ho@amd.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny@gmail.com> wrote:
> pls don't top post.
My apology.

> > Cgroup awareness is desired because the intent
> > is to use this for resource management as well (potentially along with
> > other cgroup controlled resources.)  I will dig into bpf_lsm and learn
> > more about it.
>
> Also consider that bpf_lsm hooks have a way to get cgroup-id without
> being explicitly scoped. So the bpf program can be made cgroup aware.
> It's just not as convenient as attaching a prog to cgroup+hook at once.
> For prototyping the existing bpf_lsm facility should be enough.
> So please try to follow this route and please share more details about
> the use case.

Ok.  I will take a look and see if that is sufficient.  My
understanding of bpf-cgroup is that it not only makes attaching prog
to cgroup easier but it also facilitates hierarchical calling of
attached progs which might be useful if users wants to manage gpu
resources with bpf cgroup along with other cgroup resources (like
cpu/mem/io, etc.)

About the use case.  The high level motivation here is to provide the
ability to subdivide/share a GPU via cgroups/containers in a way that
is similar to other resources like CPU and memory.  Users have been
requesting this type of functionality because GPU compute can get
expensive and they want to maximize the utilization to get the most
bang for their bucks.  A traditional way to do this is via
SRIOV/virtualization but that often means time sharing the GPU as a
whole unit.  That is useful for some applications but not others due
to the flushing and added latency.  We also have a study that
identified various GPU compute application types.  These types can
benefit from more asymmetrical/granular sharing of the GPU (for
example some applications are compute bound while others can be memory
bound that can benefit from having more VRAM.)

I have been trying to add a cgroup subsystem for the drm subsystem for
this purpose but I ran into two challenges.  First, the composition of
a GPU and how some of the subcomponents (like VRAM or shader
engines/compute units) can be shared are very much vendor specific so
we are unable to arrive at a common interface across all vendors.
Because of this and the variety of places a GPU can go into
(smartphone, PC, server, HPC), there is also no agreement on how
exactly a GPU should be shared.  The best way forward appears to
simply provide hooks for users to define how and what they want to
share via a bpf program.

From what I can tell so far (I am still learning), there are multiple
pieces that need to fall in place for bpf-cgroup to work for this use
case.  First there is resource limit enforcement, which is the
motivation for this RFC (I will look into bpf_lsm as the path
forward.)  I have also been thinking about instrumenting the drm
subsystem with a new BPF program type and have various attach types
across the drm subsystem but I am not sure if this is allowed (this
one is more for resource usage monitoring.)  Another thing I have been
considering is to have the gpu driver provide bpf helper functions for
bpf programs to modify drm driver internals.  That was the reason I
asked about the potential of BTF support for kernel modules a couple
of months ago (and Andrii Nakryiko mentioned that it is being worked
on.)

Please feel free to ask more questions if any of the above is unclear.
Feedbacks are always welcome.

Regards,
Kenny
