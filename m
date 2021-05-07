Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C7837690C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbhEGQvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhEGQvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 12:51:19 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08849C061574;
        Fri,  7 May 2021 09:50:19 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so2097410oop.12;
        Fri, 07 May 2021 09:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gEhp98aWgf02GTF44Vv5XNSpyCZQUaDhXZ1T/jvvLtA=;
        b=JORdvGomBxcOgeh8Aw+kCftF8w4jJ6wKk61sca7YG6GZTd87uNKFNfzGesgagdq079
         jmIHJRTDP/ZydemJfTZ6mJE3qOJXukS3jDrh6ZfpR4qdE+tlOPXBHpK6HbSv1yrjMDDc
         5A05p1WTniQcRC6hlqCUOHFTjjTtf+Rekwb3Xk9Ar3ellN+/4E1Ip1ZJc8JzgkE55HJd
         uABpNTFzNCvzbG2ywN2Y1AscaOmzb5athRt7SrP3oaonCaeMMjNUNGhoeEZ2bHRqmGvd
         KzOsBW3EREVB4wwYHIzns+48YOleRgWLS2I4ZVDKf1he2a+G9G54B4DRmiElMH/g6/EO
         gN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gEhp98aWgf02GTF44Vv5XNSpyCZQUaDhXZ1T/jvvLtA=;
        b=RCxcUBtQEt8D1bu56bIeLuc01nHxlgNgQijyeZUy00poI31vcBCN/NVtxUVKqXwQKE
         TZTTOjq2GZUsvcrCg/6hohHDFfX/r6r8zIFImpqBdOF6EjQOi0iHei5fwboFhSAAjkp6
         nzp73WCvKxVMe2SoG3rvxScAIj0L1IweBDF8HXh2jEIDrMYG8+3n2mGysNVE7obpSmUy
         GGMQdu8m/lLZnLAgyAWQhGn3JBEDOJBFUTeRgSkxKCG7legW0PIm/FpVwDQSYHRFVNlK
         YfHUt2vAiAd8+UTebIpaiQihEj+moaNiVqE1DHTtROFbMxtJLoAVIxmzEzEcux8kcxBk
         kkIA==
X-Gm-Message-State: AOAM5312OfZEYZXtwACTDxMFzuPAWNs2Zq3dCByEZsm6vd+1ya+w0ZDI
        3lunCp/TNUzWAwFwulb26xngRAPYGU5m/r9TKxg=
X-Google-Smtp-Source: ABdhPJwhHBPINVIrJEa2Eetgoqm/GYzk8Jzl1rM/fYedkREtS21pQlINfBkfNOiB31jt2P6jFp4QeTclpwPFqehsvPE=
X-Received: by 2002:a4a:d004:: with SMTP id h4mr8418227oor.90.1620406218393;
 Fri, 07 May 2021 09:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <YBgU9Vu0BGV8kCxD@phenom.ffwll.local> <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local> <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local> <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local> <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local> <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
In-Reply-To: <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 7 May 2021 12:50:07 -0400
Message-ID: <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Kenny Ho <y2kenny@gmail.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kenny Ho <Kenny.Ho@amd.com>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Brian Welty <brian.welty@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Network Development <netdev@vger.kernel.org>,
        KP Singh <kpsingh@chromium.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 12:31 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>
> On Fri, May 7, 2021 at 12:26 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > On Fri, May 07, 2021 at 12:19:13PM -0400, Alex Deucher wrote:
> > > On Fri, May 7, 2021 at 12:13 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> > > >
> > > > On Fri, May 07, 2021 at 11:33:46AM -0400, Kenny Ho wrote:
> > > > > On Fri, May 7, 2021 at 4:59 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> > > > > >
> > > > > > Hm I missed that. I feel like time-sliced-of-a-whole gpu is the easier gpu
> > > > > > cgroups controler to get started, since it's much closer to other cgroups
> > > > > > that control bandwidth of some kind. Whether it's i/o bandwidth or compute
> > > > > > bandwidht is kinda a wash.
> > > > > sriov/time-sliced-of-a-whole gpu does not really need a cgroup
> > > > > interface since each slice appears as a stand alone device.  This is
> > > > > already in production (not using cgroup) with users.  The cgroup
> > > > > proposal has always been parallel to that in many sense: 1) spatial
> > > > > partitioning as an independent but equally valid use case as time
> > > > > sharing, 2) sub-device resource control as opposed to full device
> > > > > control motivated by the workload characterization paper.  It was
> > > > > never about time vs space in terms of use cases but having new API for
> > > > > users to be able to do spatial subdevice partitioning.
> > > > >
> > > > > > CU mask feels a lot more like an isolation/guaranteed forward progress
> > > > > > kind of thing, and I suspect that's always going to be a lot more gpu hw
> > > > > > specific than anything we can reasonably put into a general cgroups
> > > > > > controller.
> > > > > The first half is correct but I disagree with the conclusion.  The
> > > > > analogy I would use is multi-core CPU.  The capability of individual
> > > > > CPU cores, core count and core arrangement may be hw specific but
> > > > > there are general interfaces to support selection of these cores.  CU
> > > > > mask may be hw specific but spatial partitioning as an idea is not.
> > > > > Most gpu vendors have the concept of sub-device compute units (EU, SE,
> > > > > etc.); OpenCL has the concept of subdevice in the language.  I don't
> > > > > see any obstacle for vendors to implement spatial partitioning just
> > > > > like many CPU vendors support the idea of multi-core.
> > > > >
> > > > > > Also for the time slice cgroups thing, can you pls give me pointers to
> > > > > > these old patches that had it, and how it's done? I very obviously missed
> > > > > > that part.
> > > > > I think you misunderstood what I wrote earlier.  The original proposal
> > > > > was about spatial partitioning of subdevice resources not time sharing
> > > > > using cgroup (since time sharing is already supported elsewhere.)
> > > >
> > > > Well SRIOV time-sharing is for virtualization. cgroups is for
> > > > containerization, which is just virtualization but with less overhead and
> > > > more security bugs.
> > > >
> > > > More or less.
> > > >
> > > > So either I get things still wrong, or we'll get time-sharing for
> > > > virtualization, and partitioning of CU for containerization. That doesn't
> > > > make that much sense to me.
> > >
> > > You could still potentially do SR-IOV for containerization.  You'd
> > > just pass one of the PCI VFs (virtual functions) to the container and
> > > you'd automatically get the time slice.  I don't see why cgroups would
> > > be a factor there.
> >
> > Standard interface to manage that time-slicing. I guess for SRIOV it's all
> > vendor sauce (intel as guilty as anyone else from what I can see), but for
> > cgroups that feels like it's falling a bit short of what we should aim
> > for.
> >
> > But dunno, maybe I'm just dreaming too much :-)
>
> I don't disagree, I'm just not sure how it would apply to SR-IOV.
> Once you've created the virtual functions, you've already created the
> partitioning (regardless of whether it's spatial or temporal) so where
> would cgroups come into play?

For some background, the SR-IOV virtual functions show up like actual
PCI endpoints on the bus, so SR-IOV is sort of like cgroups
implemented in hardware.  When you enable SR-IOV, the endpoints that
are created are the partitions.

Alex

>
> Alex
>
> > -Daniel
> >
> > > Alex
> > >
> > > >
> > > > Since time-sharing is the first thing that's done for virtualization I
> > > > think it's probably also the most reasonable to start with for containers.
> > > > -Daniel
> > > > --
> > > > Daniel Vetter
> > > > Software Engineer, Intel Corporation
> > > > http://blog.ffwll.ch
> > > > _______________________________________________
> > > > amd-gfx mailing list
> > > > amd-gfx@lists.freedesktop.org
> > > > https://lists.freedesktop.org/mailman/listinfo/amd-gfx
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
