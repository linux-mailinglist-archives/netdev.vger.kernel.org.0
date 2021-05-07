Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF3B3768B6
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbhEGQ13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238122AbhEGQ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 12:27:28 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B81C0613ED
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 09:26:27 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso7499309wmj.2
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 09:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cnji0mghcfsHw4UWJtieqSvlVTnHHvaILHgLJlYFjiQ=;
        b=Dztnyza1z9iIAGrus7EYHI2gelTKFcIiyKjNQ3pd+1XQh17Y1c3IdhPKn/WpIu5ck7
         +LBLLwmA1eW90IxYxW8/EfIeXYw8thLh7ZxU13OvQ6zr6wwualcxavu97qc0EcXQr1CV
         DdtRDF5HoIhHQM+zgbC+RQGDFcKmAlf+2mIIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cnji0mghcfsHw4UWJtieqSvlVTnHHvaILHgLJlYFjiQ=;
        b=rUN2y++hDhYVwspuwA4dT+mBElqIazeLlI6GrlBLjZ/wqpTtVVQFplYh7xuFySbMrL
         YeWpW43kRdoJCYVHnbuONTmQ4IZgstxBjepUrDkArhh8E5JSxblrIOoi+4PpTWeAU5gP
         Xx39szFlCawaJM54f9Kh17TzfVd1F9u3OtXmdrxOtXFKvCKeu+l+Qc/EcvgevjTVQEEo
         CN6MZCPITy0dGRhLTGKNGP5geoJskzkD4swI3SfshYXVvbJXI+WH+KuQ6Wm2kNBOL8jb
         Fciu25TbAR+ISm4EB6G1jveYi0TE7il5/55qMY7A+I+rIDM6brthoVtqKrtMTbwqJaP5
         nzLw==
X-Gm-Message-State: AOAM533fUWXsKl/yLEwYnaumgG9gkM8h3HpXutgD+CdrRoa7njZdWS06
        w3tBslAzV+c/CZxymE7rMPcm0Q==
X-Google-Smtp-Source: ABdhPJyk+pagLFvbBQTfynJmKCWq179zo3fYKMu8ozzdc0iyrHSwlZI6yGqQpT/xlHmTyEMTCx9IUQ==
X-Received: by 2002:a1c:6382:: with SMTP id x124mr22156627wmb.142.1620404786411;
        Fri, 07 May 2021 09:26:26 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v18sm10554009wro.18.2021.05.07.09.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:26:25 -0700 (PDT)
Date:   Fri, 7 May 2021 18:26:23 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Kenny Ho <y2kenny@gmail.com>,
        Song Liu <songliubraving@fb.com>,
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
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Message-ID: <YJVqL4c6SJc8wdkK@phenom.ffwll.local>
References: <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
 <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local>
 <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local>
 <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local>
 <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
X-Operating-System: Linux phenom 5.10.32scarlett+ 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 12:19:13PM -0400, Alex Deucher wrote:
> On Fri, May 7, 2021 at 12:13 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > On Fri, May 07, 2021 at 11:33:46AM -0400, Kenny Ho wrote:
> > > On Fri, May 7, 2021 at 4:59 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> > > >
> > > > Hm I missed that. I feel like time-sliced-of-a-whole gpu is the easier gpu
> > > > cgroups controler to get started, since it's much closer to other cgroups
> > > > that control bandwidth of some kind. Whether it's i/o bandwidth or compute
> > > > bandwidht is kinda a wash.
> > > sriov/time-sliced-of-a-whole gpu does not really need a cgroup
> > > interface since each slice appears as a stand alone device.  This is
> > > already in production (not using cgroup) with users.  The cgroup
> > > proposal has always been parallel to that in many sense: 1) spatial
> > > partitioning as an independent but equally valid use case as time
> > > sharing, 2) sub-device resource control as opposed to full device
> > > control motivated by the workload characterization paper.  It was
> > > never about time vs space in terms of use cases but having new API for
> > > users to be able to do spatial subdevice partitioning.
> > >
> > > > CU mask feels a lot more like an isolation/guaranteed forward progress
> > > > kind of thing, and I suspect that's always going to be a lot more gpu hw
> > > > specific than anything we can reasonably put into a general cgroups
> > > > controller.
> > > The first half is correct but I disagree with the conclusion.  The
> > > analogy I would use is multi-core CPU.  The capability of individual
> > > CPU cores, core count and core arrangement may be hw specific but
> > > there are general interfaces to support selection of these cores.  CU
> > > mask may be hw specific but spatial partitioning as an idea is not.
> > > Most gpu vendors have the concept of sub-device compute units (EU, SE,
> > > etc.); OpenCL has the concept of subdevice in the language.  I don't
> > > see any obstacle for vendors to implement spatial partitioning just
> > > like many CPU vendors support the idea of multi-core.
> > >
> > > > Also for the time slice cgroups thing, can you pls give me pointers to
> > > > these old patches that had it, and how it's done? I very obviously missed
> > > > that part.
> > > I think you misunderstood what I wrote earlier.  The original proposal
> > > was about spatial partitioning of subdevice resources not time sharing
> > > using cgroup (since time sharing is already supported elsewhere.)
> >
> > Well SRIOV time-sharing is for virtualization. cgroups is for
> > containerization, which is just virtualization but with less overhead and
> > more security bugs.
> >
> > More or less.
> >
> > So either I get things still wrong, or we'll get time-sharing for
> > virtualization, and partitioning of CU for containerization. That doesn't
> > make that much sense to me.
> 
> You could still potentially do SR-IOV for containerization.  You'd
> just pass one of the PCI VFs (virtual functions) to the container and
> you'd automatically get the time slice.  I don't see why cgroups would
> be a factor there.

Standard interface to manage that time-slicing. I guess for SRIOV it's all
vendor sauce (intel as guilty as anyone else from what I can see), but for
cgroups that feels like it's falling a bit short of what we should aim
for.

But dunno, maybe I'm just dreaming too much :-)
-Daniel

> Alex
> 
> >
> > Since time-sharing is the first thing that's done for virtualization I
> > think it's probably also the most reasonable to start with for containers.
> > -Daniel
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
> > _______________________________________________
> > amd-gfx mailing list
> > amd-gfx@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/amd-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
