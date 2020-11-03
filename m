Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0727E2A5A5F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgKCW6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgKCW6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:58:01 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF61EC0613D1;
        Tue,  3 Nov 2020 14:57:59 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 13so15642180pfy.4;
        Tue, 03 Nov 2020 14:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p1h/LKIjKhwCaZN5JW6lQr8X/bwNTpcCZCyLALzsZSg=;
        b=tr5vPjWUjAouhWvPxTC7MBVgGO79ny7u55kLEr8RCRj6bxH1t3gSkiC71IMTkzC2Uq
         tewnvHi/iikOF9VEI0TnR6StnqdbjbcTMYc6+bRCLaFZGXkz4lp/gubVHAELLmPwekr7
         BapanDlC20YtC+zgNpcKEiddgqI3Ntl0Ls3ZK5Syh2j22luIaJbsj1n0Uqzu0HPkpUPt
         O0Pb9O+WEsZTY/rpInmKULg+gW42UB3akBmakChPrjkaO2R6R4dUk4LKibSeEkN7M48u
         9pptgIOUotK2/wmU0/izcuCDPjwnCTvHUgEX3lwdm/fQMdUMM4mb3ZNR+cZV0CP1Bxnr
         wD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p1h/LKIjKhwCaZN5JW6lQr8X/bwNTpcCZCyLALzsZSg=;
        b=RQJcsHzgDAT1oLIJ+1grHWw2GzhOu5t7D0pULav87B1HQmVzOaEv19k18RFZJcWFXW
         aP3a10KbRa5gd2dIKb9ntPTTa6jLoMixBm9L3fo6gAbVeDgjFfWb0ycVcHdnev+dcVzU
         9d0UT6VP2HwdGh9oZlD7BwUei97au3ZTy62L/2Vt3mxni4ItQQgqsOuw/eErbDht9xSk
         QivvrobedQfaNcu8WPq71pVhpR65hp4eg8921RK3s2DwVtBPLyQvexS/hYRagSeYjXcw
         DoUf5U/KguB2rkX5fokCIujJfDntgSQUFL0gyUEXQVspATL0FM5H0mAK93T5QYnJGAQo
         MySw==
X-Gm-Message-State: AOAM532Bj5vz+EJM59rfw9mfbvaHDBSJVIaFlJGUPvOpxSk63jJmACO2
        Hv+zsxi84cI0iKD/VoI+6BkGc2ZRirDffMzpMiYxqrAFRGgLIt2M
X-Google-Smtp-Source: ABdhPJwkXme79PXXaAAJZqprDS/IXxVAL1qJl21a7ycKClcO4oEFYkx0WsiNs9Cv6sHUdW9jMxDhxoZdQCzEH6J6Q4E=
X-Received: by 2002:a63:fb11:: with SMTP id o17mr19448546pgh.109.1604444279120;
 Tue, 03 Nov 2020 14:57:59 -0800 (PST)
MIME-Version: 1.0
References: <20201007152355.2446741-1-Kenny.Ho@amd.com> <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com> <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Tue, 3 Nov 2020 17:57:47 -0500
Message-ID: <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
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

On Tue, Nov 3, 2020 at 4:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Nov 03, 2020 at 02:19:22PM -0500, Kenny Ho wrote:
> > On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny@gmail.com> wrote:
>
> Sounds like either bpf_lsm needs to be made aware of cgv2 (which would
> be a great thing to have regardless) or cgroup-bpf needs a drm/gpu specific hook.
> I think generic ioctl hook is too broad for this use case.
> I suspect drm/gpu internal state would be easier to access inside
> bpf program if the hook is next to gpu/drm. At ioctl level there is 'file'.
> It's probably too abstract for the things you want to do.
> Like how VRAM/shader/etc can be accessed through file?
> Probably possible through a bunch of lookups and dereferences, but
> if the hook is custom to GPU that info is likely readily available.
> Then such cgroup-bpf check would be suitable in execution paths where
> ioctl-based hook would be too slow.
Just to clarify, when you say drm specific hook, did you mean just a
unique attach_type or a unique prog_type+attach_type combination?  (I
am still a bit fuzzy on when a new prog type is needed vs a new attach
type.  I think prog type is associated with a unique type of context
that the bpf prog will get but I could be missing some nuances.)

When I was thinking of doing an ioctl wide hook, the file would be the
device file and the thinking was to have a helper function provided by
device drivers to further disambiguate.  For our (AMD's) driver, we
have a bunch of ioctls for set/get/create/destroy
(https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c#L1763)
so the bpf prog can make the decision after the disambiguation.  For
example, we have an ioctl called "kfd_ioctl_set_cu_mask."  You can
think of cu_mask like cpumask but for the cores/compute-unit inside a
GPU.  The ioctl hook will get the file, the bpf prog will call a
helper function from the amdgpu driver to return some data structure
specific to the driver and then the bpf prog can make a decision on
gating the ioctl or not.  From what you are saying, sounds like this
kind of back and forth lookup and dereferencing should be avoided for
performance considerations?

Having a DRM specific hook is certainly an alternative.  I just wasn't
sure which level of trade off on abstraction/generic is acceptable.  I
am guessing a new BPF_PROG_TYPE_CGROUP_AMDGPU is probably too
specific?  But sounds like BPF_PROG_TYPE_CGROUP_DRM may be ok?

Regards,
Kenny
