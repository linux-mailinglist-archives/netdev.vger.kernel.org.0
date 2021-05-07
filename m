Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAA737687B
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbhEGQOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbhEGQOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 12:14:53 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7AFC0613ED
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 09:13:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so5203630wmb.3
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 09:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FUW3a1jiCrK1Tn1N2NaYa8UBta2jEUU1Vka07ztzquU=;
        b=g4WfSpbdEojj9t6SkLNDXVSN8j4goD0Y1aN3I2Imymf6okgQfMLTQILeVaPIdzjjyy
         rc5FgeK00c/1rW3oWDgK0rM6pqpYTXnlKBGM3lzF7JRr0lP4t2KJLEo8glyppHIXAZg5
         OlL+tz1UDPB06Xitnob+iK9BxCUL/sEKyEcCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FUW3a1jiCrK1Tn1N2NaYa8UBta2jEUU1Vka07ztzquU=;
        b=ppz0AlpAzxBPT2gsiJshnMe5ulVW3IefZd0aC+K72A77q6YphqUsYPwLXs6RKfeFNr
         IvUZ6aomiYCxxYbyF5JIA3efSNpIXSmQem1l3nMp9yubhhuFHSUs04n25LXfVYGa94wY
         SvwU6bKbhg5oVcHHy0QjE7jzQyk89+vjnktiy9U6bLkZ6hA6RFyPYVpKVhwHlQh9g9Yi
         H/yrcC5fa1kcyTMJvOG5yJLz0tPz5Xm5EzYFb+XdLYFmX6mtlLSOD1W/MqFEsTRc4Ndl
         KUxo+C98hrUQsM+x2TGYrighOupSAoJFzm7WzL3WwF6phSQjWyoCwJh5jD0EWFBSUE09
         i5WA==
X-Gm-Message-State: AOAM533O+VNMkZ1RRxVmckPvPRd/uLLAqS+3WiZ5ssyE0ax1ziEdhaB8
        tK6DbB/uIIe2c6Ex5OmJSuIakQ==
X-Google-Smtp-Source: ABdhPJw2OfJqYx5ZIercYhhRlQ/JLOdMXNxUQ/ODYD+AnW2ThepPqF7/0dUanJkd40jtM214KjqXYQ==
X-Received: by 2002:a05:600c:2154:: with SMTP id v20mr10712151wml.86.1620404030299;
        Fri, 07 May 2021 09:13:50 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id l66sm7286905wmf.20.2021.05.07.09.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:13:49 -0700 (PDT)
Date:   Fri, 7 May 2021 18:13:47 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Kenny Ho <y2kenny@gmail.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Message-ID: <YJVnO+TCRW83S6w4@phenom.ffwll.local>
References: <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
 <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local>
 <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local>
 <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
X-Operating-System: Linux phenom 5.10.32scarlett+ 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 11:33:46AM -0400, Kenny Ho wrote:
> On Fri, May 7, 2021 at 4:59 AM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > Hm I missed that. I feel like time-sliced-of-a-whole gpu is the easier gpu
> > cgroups controler to get started, since it's much closer to other cgroups
> > that control bandwidth of some kind. Whether it's i/o bandwidth or compute
> > bandwidht is kinda a wash.
> sriov/time-sliced-of-a-whole gpu does not really need a cgroup
> interface since each slice appears as a stand alone device.  This is
> already in production (not using cgroup) with users.  The cgroup
> proposal has always been parallel to that in many sense: 1) spatial
> partitioning as an independent but equally valid use case as time
> sharing, 2) sub-device resource control as opposed to full device
> control motivated by the workload characterization paper.  It was
> never about time vs space in terms of use cases but having new API for
> users to be able to do spatial subdevice partitioning.
> 
> > CU mask feels a lot more like an isolation/guaranteed forward progress
> > kind of thing, and I suspect that's always going to be a lot more gpu hw
> > specific than anything we can reasonably put into a general cgroups
> > controller.
> The first half is correct but I disagree with the conclusion.  The
> analogy I would use is multi-core CPU.  The capability of individual
> CPU cores, core count and core arrangement may be hw specific but
> there are general interfaces to support selection of these cores.  CU
> mask may be hw specific but spatial partitioning as an idea is not.
> Most gpu vendors have the concept of sub-device compute units (EU, SE,
> etc.); OpenCL has the concept of subdevice in the language.  I don't
> see any obstacle for vendors to implement spatial partitioning just
> like many CPU vendors support the idea of multi-core.
> 
> > Also for the time slice cgroups thing, can you pls give me pointers to
> > these old patches that had it, and how it's done? I very obviously missed
> > that part.
> I think you misunderstood what I wrote earlier.  The original proposal
> was about spatial partitioning of subdevice resources not time sharing
> using cgroup (since time sharing is already supported elsewhere.)

Well SRIOV time-sharing is for virtualization. cgroups is for
containerization, which is just virtualization but with less overhead and
more security bugs.

More or less.

So either I get things still wrong, or we'll get time-sharing for
virtualization, and partitioning of CU for containerization. That doesn't
make that much sense to me.

Since time-sharing is the first thing that's done for virtualization I
think it's probably also the most reasonable to start with for containers.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
