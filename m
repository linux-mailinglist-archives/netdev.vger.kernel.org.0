Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07DB37681A
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhEGPfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 11:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237940AbhEGPe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 11:34:59 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC38EC061574;
        Fri,  7 May 2021 08:33:59 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a36so12067501ljq.8;
        Fri, 07 May 2021 08:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XItf2h9hovNafxela2Mfpgx6zd0s5dzNeA3YTSrq32g=;
        b=Jx5khNbbvbtn/U6yoK/8cw0ezIGuOk20VXL3g5Xc+1PO4u0/c7u9JdhS4Sh0A/238X
         qJDK3CmCrhsUw3kxgGmtVLKOVBpamJ+mgC++QhBm/huNDdpJjfnji8KQgSRdH6dR/6qw
         gnnCzv+ZkzfWEd8q02n4o5Q1u7vF1VZJ4e7OS4bTosSeDlXkdzxCU2dg/3t0bFiexOvm
         +Fns9n/UTIMVSeDR8FrwK2UMk0Co9GksoDN716frVRknDfq407ihSlg/RkoHgqcpmhWB
         9MxoWewWjLjGhCFj5Iy5vQfpMUzUk5ghM0z3CRFvwHCE5bR6RTjPI1mbzhQOqVqQKwNY
         QLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XItf2h9hovNafxela2Mfpgx6zd0s5dzNeA3YTSrq32g=;
        b=uZvJncYILcHBNHK2Is+inA99tNyMUoWrSM40NBXlz+jIemrDV0xtli0ZsGIk6SBjMf
         swNS6PwmE62sodExhoU0X+5ciCs5pI49NnIIuQv0LHEKDSom/znGwB/o8GiUdq1AhiLS
         iGBwpAktrCQZ0UN1ULrNLjcBAUdNPuIBMnBPL4DoY108au2rjhUrn+FBJQrvAjOg4czT
         2i6D0X5tUvs8o69X1anUAeRjCv/QfPucccdZ+J1zdDMBRVczVveaLzeiAYwp5cZCg92/
         tSLc55AIcsejN/n8E8RByN+dwMEAwcBR1GVhBfxAzaNhqMSj6geoE/TnqIFu9ShJVNko
         v9NA==
X-Gm-Message-State: AOAM532IkOyFSeeH194xLEjxZOUwdbAoycWNRzD+IAzbxoTsSXcbchae
        /6hP6CuN4QJwKHWyu8uUMBZv+ieLpHcZrtOB8Ps=
X-Google-Smtp-Source: ABdhPJx/cIdx8NpTK9Kf5ak04J3JS36S0jqI9UthXLBwNn3zr8xJh29JWdymKYR7PnpZPh/rQLr7Hj7zbOpXNv/R8KY=
X-Received: by 2002:a2e:bf1f:: with SMTP id c31mr8218857ljr.30.1620401638215;
 Fri, 07 May 2021 08:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local> <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local> <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com> <YJUBer3wWKSAeXe7@phenom.ffwll.local>
In-Reply-To: <YJUBer3wWKSAeXe7@phenom.ffwll.local>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Fri, 7 May 2021 11:33:46 -0400
Message-ID: <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Daniel Vetter <daniel@ffwll.ch>
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

On Fri, May 7, 2021 at 4:59 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> Hm I missed that. I feel like time-sliced-of-a-whole gpu is the easier gpu
> cgroups controler to get started, since it's much closer to other cgroups
> that control bandwidth of some kind. Whether it's i/o bandwidth or compute
> bandwidht is kinda a wash.
sriov/time-sliced-of-a-whole gpu does not really need a cgroup
interface since each slice appears as a stand alone device.  This is
already in production (not using cgroup) with users.  The cgroup
proposal has always been parallel to that in many sense: 1) spatial
partitioning as an independent but equally valid use case as time
sharing, 2) sub-device resource control as opposed to full device
control motivated by the workload characterization paper.  It was
never about time vs space in terms of use cases but having new API for
users to be able to do spatial subdevice partitioning.

> CU mask feels a lot more like an isolation/guaranteed forward progress
> kind of thing, and I suspect that's always going to be a lot more gpu hw
> specific than anything we can reasonably put into a general cgroups
> controller.
The first half is correct but I disagree with the conclusion.  The
analogy I would use is multi-core CPU.  The capability of individual
CPU cores, core count and core arrangement may be hw specific but
there are general interfaces to support selection of these cores.  CU
mask may be hw specific but spatial partitioning as an idea is not.
Most gpu vendors have the concept of sub-device compute units (EU, SE,
etc.); OpenCL has the concept of subdevice in the language.  I don't
see any obstacle for vendors to implement spatial partitioning just
like many CPU vendors support the idea of multi-core.

> Also for the time slice cgroups thing, can you pls give me pointers to
> these old patches that had it, and how it's done? I very obviously missed
> that part.
I think you misunderstood what I wrote earlier.  The original proposal
was about spatial partitioning of subdevice resources not time sharing
using cgroup (since time sharing is already supported elsewhere.)

Kenny
