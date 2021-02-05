Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22A3115C2
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhBEWkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhBENuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 08:50:05 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686CCC0617A7
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 05:49:14 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id y21so1614580oot.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 05:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v3dYKQ5xVDmqjq0CCTTfze74f1vEv6vNiVomtR7v+KM=;
        b=GoOBFbj7BzUv6nfQ5N5IfWnhVNXTBZHLwIXJKaNWGpuGrph6mbQqU7HmQTD3L90yDL
         +DdV0bikLU3XO8ZvC0H88ZIiO6Dyd05lRJCJVNLtlTg7gyjmtifiQMHVRD8PELoXLoUP
         CqNxeSy8ddxOxfnWeVDC+vxp0qLijeaLBLhdk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v3dYKQ5xVDmqjq0CCTTfze74f1vEv6vNiVomtR7v+KM=;
        b=hiFdeueEvCLm4mi727gmqkd4Qy52i8Qg2d+76gtISjAGh8JuCeScJfctb7VZTfyOpl
         4wFbrqyRH+ph4VHOptW3Xjv80rneNsM2hYzcLnperJz07RMQscldkQF6SduLjoXp04Sn
         oIj1XkC4tuIODP4B7Q6neZ5iKX5ymFgIPKo4EgJ1h+FhaL0e+QIzNj+cgskbLJQtNQJf
         xKeaCok8+Er8//xvoTUqAOp4bGBJ0N/5+X43mbpd2uAeyXJGrIWD8ZrkvVE8J4+Hjh1V
         7h9uvwnP2eFeP5nUZXn9x3YFN6Iww/ACgFbw+xDKEPNLRnVtZTX1KkPrF9Q67CKK+evJ
         nhjA==
X-Gm-Message-State: AOAM532T8W8rAuXY8nFfbAepwHoHBDr2/RTZYFEwwMFh/Ry3JYXCl0EF
        iH6nCxAU8ESsQ87LSh2HHZIGXArM8ey2ZmN2qa/JQQ==
X-Google-Smtp-Source: ABdhPJy+9jG95INqAnJr0pY3S4vtmLo1Xat23GKAx2VkWNLVs27RaWOVAnEnQaJfmS+LkOOCBm3ADzvIy505tjYDYEw=
X-Received: by 2002:a4a:424c:: with SMTP id i12mr3484467ooj.85.1612532953749;
 Fri, 05 Feb 2021 05:49:13 -0800 (PST)
MIME-Version: 1.0
References: <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local> <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local> <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
In-Reply-To: <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Fri, 5 Feb 2021 14:49:02 +0100
Message-ID: <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Kenny Ho <y2kenny@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Dave Airlie <airlied@gmail.com>, Kenny Ho <Kenny.Ho@amd.com>,
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
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Brian Welty <brian.welty@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kenny

On Wed, Feb 3, 2021 at 8:01 PM Kenny Ho <y2kenny@gmail.com> wrote:
>
> Daniel,
>
> I will have to get back to you later on the details of this because my
> head is currently context switched to some infrastructure and
> Kubernetes/golang work, so I am having a hard time digesting what you
> are saying.  I am new to the bpf stuff so this is about my own
> learning as well as a conversation starter.  The high level goal here
> is to have a path for flexibility via a bpf program.  Not just GPU or
> DRM or CU mask, but devices making decisions via an operator-written
> bpf-prog attached to a cgroup.  More inline.

If you have some pointers on this, I'm happy to do some reading and
learning too.

> On Wed, Feb 3, 2021 at 6:09 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > On Mon, Feb 01, 2021 at 11:51:07AM -0500, Kenny Ho wrote:
> > > On Mon, Feb 1, 2021 at 9:49 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> > > > - there's been a pile of cgroups proposal to manage gpus at the drm
> > > >   subsystem level, some by Kenny, and frankly this at least looks a bit
> > > >   like a quick hack to sidestep the consensus process for that.
> > > No Daniel, this is quick *draft* to get a conversation going.  Bpf was
> > > actually a path suggested by Tejun back in 2018 so I think you are
> > > mischaracterizing this quite a bit.
> > >
> > > "2018-11-20 Kenny Ho:
> > > To put the questions in more concrete terms, let say a user wants to
> > >  expose certain part of a gpu to a particular cgroup similar to the
> > >  way selective cpu cores are exposed to a cgroup via cpuset, how
> > >  should we go about enabling such functionality?
> > >
> > > 2018-11-20 Tejun Heo:
> > > Do what the intel driver or bpf is doing?  It's not difficult to hook
> > > into cgroup for identification purposes."
> >
> > Yeah, but if you go full amd specific for this, you might as well have a
> > specific BPF hook which is called in amdgpu/kfd and returns you the CU
> > mask for a given cgroups (and figures that out however it pleases).
> >
> > Not a generic framework which lets you build pretty much any possible
> > cgroups controller for anything else using BPF. Trying to filter anything
> > at the generic ioctl just doesn't feel like a great idea that's long term
> > maintainable. E.g. what happens if there's new uapi for command
> > submission/context creation and now your bpf filter isn't catching all
> > access anymore? If it's an explicit hook that explicitly computes the CU
> > mask, then we can add more checks as needed. With ioctl that's impossible.
> >
> > Plus I'm also not sure whether that's really a good idea still, since if
> > cloud companies have to built their own bespoke container stuff for every
> > gpu vendor, that's quite a bad platform we're building. And "I'd like to
> > make sure my gpu is used fairly among multiple tenents" really isn't a
> > use-case that's specific to amd.
>
> I don't understand what you are saying about containers here since
> bpf-progs are not the same as container nor are they deployed from
> inside a container (as far as I know, I am actually not sure how
> bpf-cgroup works with higher level cloud orchestration since folks
> like Docker just migrated to cgroup v2 very recently... I don't think
> you can specify a bpf-prog to load as part of a k8s pod definition.)
> That said, the bit I understand ("not sure whether that's really a
> good idea....cloud companies have to built their own bespoke container
> stuff for every gpu vendor...") is in fact the current status quo.  If
> you look into some of the popular ML/AI-oriented containers/apps, you
> will likely see things are mostly hardcoded to CUDA.  Since I work for
> AMD, I wouldn't say that's a good thing but this is just the reality.
> For Kubernetes at least (where my head is currently), the official
> mechanisms are Device Plugins (I am the author for the one for AMD but
> there are a few ones from Intel too, you can confirm with your
> colleagues)  and Node Feature/Labels.  Kubernetes schedules
> pod/container launched by users to the node/servers by the affinity of
> the node resources/labels, and the resources/labels in the pod
> specification created by the users.

Sure the current gpu compute ecosystem is pretty badly fragmented,
forcing higher levels (like containers, but also hpc runtimes, or
anything else) to paper over that with more plugins and abstraction
layers.

That's not really a good excuse that when we upstream these features,
that we should continue with the fragmentation.

> > If this would be something very hw specific like cache assignment and
> > quality of service stuff or things like that, then vendor specific imo
> > makes sense. But for CU masks essentially we're cutting the compute
> > resources up in some way, and I kinda expect everyone with a gpu who cares
> > about isolating workloads with cgroups wants to do that.
>
> Right, but isolating workloads is quality of service stuff and *how*
> compute resources are cut up are vendor specific.
>
> Anyway, as I said at the beginning of this reply, this is about
> flexibility in support of the diversity of devices and architectures.
> CU mask is simply a concrete example of hw diversity that a
> bpf-program can encapsulate.  I can see this framework (a custom
> program making decisions in a specific cgroup and device context) use
> for other things as well.  It may even be useful within a vendor to
> handle the diversity between SKUs.

So I agree that on one side CU mask can be used for low-level quality
of service guarantees (like the CLOS cache stuff on intel cpus as an
example), and that's going to be rather hw specific no matter what.

But my understanding of AMD's plans here is that CU mask is the only
thing you'll have to partition gpu usage in a multi-tenant environment
- whether that's cloud or also whether that's containing apps to make
sure the compositor can still draw the desktop (except for fullscreen
ofc) doesn't really matter I think. And since there's clearly a need
for more general (but necessarily less well-defined) gpu usage
controlling and accounting I don't think exposing just the CU mask is
a good idea. That just perpetuates the current fragmented landscape,
and I really don't see why it's not possible to have a generic "I want
50% of my gpu available for these 2 containers each" solution

Of course on top of that having a bfp hook in amd to do the fine
grained QOS assignement for e.g. embedded application which are very
carefully tuned, should still be possible. But that's on top, not as
the exclusive thing available.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
