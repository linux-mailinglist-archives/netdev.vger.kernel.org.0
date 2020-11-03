Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3C2A55E3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbgKCVX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733243AbgKCVEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:04:35 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C11EC0613D1;
        Tue,  3 Nov 2020 13:04:35 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id b3so15410552pfo.2;
        Tue, 03 Nov 2020 13:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wrUBzqixMNGges3Fm8LEqTkGr+7Sx/OVd1FP+l0kdS0=;
        b=tqKpwE9c1XvzM26lsALNljg7czgItn9B2SFh1tA3jWE/ITdxfbUKdt+lGHvc4AqZJG
         DZ38w2G0ZCOMhepTm9Eowqe4LBfWPO8ILx0Ol+dgIFIwxdAiNzD1wA/i8yt6fsVNOptw
         SaiYvqBnxP3BX8+Vb8wu9Rwugz6FWLSJfUcENjTtu4V78jIYi59xfrDLTeLYUuG5oxAl
         NTgLN9RaB/G1pfPbVdSsuGof6GiB/WaIyBDaEjrF7Ha1Z98pSiyS5oXgB6h/IXv9HV1w
         sOAJhdJr5OPTpCg0tsq/C68T5BgQKFWAUoPDQTzUaXS7gzIxvEKvR4YiROniyFWZyWC3
         0Sag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wrUBzqixMNGges3Fm8LEqTkGr+7Sx/OVd1FP+l0kdS0=;
        b=KKka7vYkgz51er8sxIwdP/omGh2lMRt2rA287qwg/ZKH6SFHlbKWoiRXQE1Eko7UCc
         6Su3w8jPaA8ibD4dZmA6BJfyp8wS3RSuhixDq7O0DrYa2W1okn2bULfsaMeGksyDBzS3
         VhnCTAarnbQW6aL9PAeGRTyZku0PDuH8okCutJ/lNahW3zD3Qy/3/5LPzYZkSI8r1yBf
         u5+Y1ozbb8N5RMbneZzU9CTiJ4BnKUoE/6RLpQb80a9K2uFr/SMKZllJpqNvTxS7aeHd
         l+Hm4KeZmzZIIcT0EiSF+YMhiFpSu8ox/eSCu0f3nMX4Grfd6lvUacQZWEdCELn27UC4
         Chnw==
X-Gm-Message-State: AOAM533oYeYM94Bmvw5QjUsKRv4ATMTAX0N8uUUcsbjv1nx0wtL0i5K+
        LflLpOEpiiaiC1nZkpWi0Cc=
X-Google-Smtp-Source: ABdhPJwKd9ujaje9lKYp2d86AtKj6fAx/PpwqjE7Ypjdq7qZld+7Ol6iwwjneB60m1H6WrfRfHbdnA==
X-Received: by 2002:a17:90b:f85:: with SMTP id ft5mr1161462pjb.86.1604437474559;
        Tue, 03 Nov 2020 13:04:34 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id y22sm29035pfr.62.2020.11.03.13.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:04:33 -0800 (PST)
Date:   Tue, 3 Nov 2020 13:04:18 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kenny Ho <y2kenny@gmail.com>
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
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Message-ID: <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 02:19:22PM -0500, Kenny Ho wrote:
> On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny@gmail.com> wrote:
> > pls don't top post.
> My apology.
> 
> > > Cgroup awareness is desired because the intent
> > > is to use this for resource management as well (potentially along with
> > > other cgroup controlled resources.)  I will dig into bpf_lsm and learn
> > > more about it.
> >
> > Also consider that bpf_lsm hooks have a way to get cgroup-id without
> > being explicitly scoped. So the bpf program can be made cgroup aware.
> > It's just not as convenient as attaching a prog to cgroup+hook at once.
> > For prototyping the existing bpf_lsm facility should be enough.
> > So please try to follow this route and please share more details about
> > the use case.
> 
> Ok.  I will take a look and see if that is sufficient.  My
> understanding of bpf-cgroup is that it not only makes attaching prog
> to cgroup easier but it also facilitates hierarchical calling of
> attached progs which might be useful if users wants to manage gpu
> resources with bpf cgroup along with other cgroup resources (like
> cpu/mem/io, etc.)

Right. Hierarchical cgroup-bpf logic cannot be replicated inside
the program. If you're relying on cgv2 hierarchy to containerize
applications then what I suggested earlier won't work indeed.

> About the use case.  The high level motivation here is to provide the
> ability to subdivide/share a GPU via cgroups/containers in a way that
> is similar to other resources like CPU and memory.  Users have been
> requesting this type of functionality because GPU compute can get
> expensive and they want to maximize the utilization to get the most
> bang for their bucks.  A traditional way to do this is via
> SRIOV/virtualization but that often means time sharing the GPU as a
> whole unit.  That is useful for some applications but not others due
> to the flushing and added latency.  We also have a study that
> identified various GPU compute application types.  These types can
> benefit from more asymmetrical/granular sharing of the GPU (for
> example some applications are compute bound while others can be memory
> bound that can benefit from having more VRAM.)
> 
> I have been trying to add a cgroup subsystem for the drm subsystem for
> this purpose but I ran into two challenges.  First, the composition of
> a GPU and how some of the subcomponents (like VRAM or shader
> engines/compute units) can be shared are very much vendor specific so
> we are unable to arrive at a common interface across all vendors.
> Because of this and the variety of places a GPU can go into
> (smartphone, PC, server, HPC), there is also no agreement on how
> exactly a GPU should be shared.  The best way forward appears to
> simply provide hooks for users to define how and what they want to
> share via a bpf program.

Thank you for sharing the details. It certainly helps.

> From what I can tell so far (I am still learning), there are multiple
> pieces that need to fall in place for bpf-cgroup to work for this use
> case.  First there is resource limit enforcement, which is the
> motivation for this RFC (I will look into bpf_lsm as the path
> forward.)  I have also been thinking about instrumenting the drm
> subsystem with a new BPF program type and have various attach types
> across the drm subsystem but I am not sure if this is allowed (this
> one is more for resource usage monitoring.)  Another thing I have been
> considering is to have the gpu driver provide bpf helper functions for
> bpf programs to modify drm driver internals.  That was the reason I
> asked about the potential of BTF support for kernel modules a couple
> of months ago (and Andrii Nakryiko mentioned that it is being worked
> on.)

Sounds like either bpf_lsm needs to be made aware of cgv2 (which would
be a great thing to have regardless) or cgroup-bpf needs a drm/gpu specific hook.
I think generic ioctl hook is too broad for this use case.
I suspect drm/gpu internal state would be easier to access inside
bpf program if the hook is next to gpu/drm. At ioctl level there is 'file'.
It's probably too abstract for the things you want to do.
Like how VRAM/shader/etc can be accessed through file?
Probably possible through a bunch of lookups and dereferences, but
if the hook is custom to GPU that info is likely readily available.
Then such cgroup-bpf check would be suitable in execution paths where
ioctl-based hook would be too slow.
