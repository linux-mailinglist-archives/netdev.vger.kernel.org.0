Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E5330AAF5
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhBAPTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhBAOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:50:15 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94668C061788
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 06:49:29 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id e15so13414626wme.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EGmzCB5chSwq9pe2qQDXhGstL/uSMglbti4AeZbvc9M=;
        b=T0u0mZ+Z3spqI5csq8199vdWw2F0HEI5De5S85KRWxCdxr+4jQR5HF/ESPI+khBobI
         0kID6zY387C7nAXsNhluEAdeknIbOqrsZ2D0JaogcRsYEATDQywghJ/9qSSQ5q5A55FI
         yWsOBfzIjs33oPqk4PuKrYwi8nfXeV5MoJxBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EGmzCB5chSwq9pe2qQDXhGstL/uSMglbti4AeZbvc9M=;
        b=mB6nagCOnLJLNLG8JQdGZKKUWnBbaXWvTvaNQMwraUEvcXlW/srVE3EG6NooW2yq7g
         Wf6RNGkmzNxqInoEh+5DXkFy4yr+g81ayGW3F9KRLafCzBWrCPYHMRJkZGpkBK7RaXjQ
         QY1N1DsmUbQuJQgTb6Jdh8rD0oxYFkCWB1DohTUM8xgJu6SZ9SF1qSrBTd0m5FQRfgSU
         u1T7NfVGCC4V4yPGFhdZXj/CN/Pi4U8Zj51GQfjjMm+EFVF3nKkQHZCuR51RND/rXk59
         jVXZKAZOjegTEsaAkB9HazEvgpiikGtb/t3cuMPiHePoqM9gI4OYm/laObBFd0Vf+A3P
         /H8g==
X-Gm-Message-State: AOAM530JmK6zVZ+TEXJfuItznHRpN2/pCTzb2g6uaIcmZGZJFx1KCHGx
        hnwo369LjPITpjXFgvdmCSbL0A==
X-Google-Smtp-Source: ABdhPJzB4Q25SCm85fnRZK3Sfm9L/kEowDZQU6EzC3QxehecRfUoCDENb9bS5nw1au+0MSHzKsed+A==
X-Received: by 2002:a7b:cd97:: with SMTP id y23mr15626961wmj.0.1612190968210;
        Mon, 01 Feb 2021 06:49:28 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z18sm26511725wro.91.2021.02.01.06.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 06:49:27 -0800 (PST)
Date:   Mon, 1 Feb 2021 15:49:25 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Dave Airlie <airlied@gmail.com>
Cc:     Kenny Ho <y2kenny@gmail.com>, Kenny Ho <Kenny.Ho@amd.com>,
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
Message-ID: <YBgU9Vu0BGV8kCxD@phenom.ffwll.local>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding gpu folks.

On Tue, Nov 03, 2020 at 03:28:05PM -0800, Alexei Starovoitov wrote:
> On Tue, Nov 03, 2020 at 05:57:47PM -0500, Kenny Ho wrote:
> > On Tue, Nov 3, 2020 at 4:04 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Nov 03, 2020 at 02:19:22PM -0500, Kenny Ho wrote:
> > > > On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny@gmail.com> wrote:
> > >
> > > Sounds like either bpf_lsm needs to be made aware of cgv2 (which would
> > > be a great thing to have regardless) or cgroup-bpf needs a drm/gpu specific hook.
> > > I think generic ioctl hook is too broad for this use case.
> > > I suspect drm/gpu internal state would be easier to access inside
> > > bpf program if the hook is next to gpu/drm. At ioctl level there is 'file'.
> > > It's probably too abstract for the things you want to do.
> > > Like how VRAM/shader/etc can be accessed through file?
> > > Probably possible through a bunch of lookups and dereferences, but
> > > if the hook is custom to GPU that info is likely readily available.
> > > Then such cgroup-bpf check would be suitable in execution paths where
> > > ioctl-based hook would be too slow.
> > Just to clarify, when you say drm specific hook, did you mean just a
> > unique attach_type or a unique prog_type+attach_type combination?  (I
> > am still a bit fuzzy on when a new prog type is needed vs a new attach
> > type.  I think prog type is associated with a unique type of context
> > that the bpf prog will get but I could be missing some nuances.)
> > 
> > When I was thinking of doing an ioctl wide hook, the file would be the
> > device file and the thinking was to have a helper function provided by
> > device drivers to further disambiguate.  For our (AMD's) driver, we
> > have a bunch of ioctls for set/get/create/destroy
> > (https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c#L1763)
> > so the bpf prog can make the decision after the disambiguation.  For
> > example, we have an ioctl called "kfd_ioctl_set_cu_mask."  You can
> 
> Thanks for the pointer.
> That's one monster ioctl. So much copy_from_user.
> BPF prog would need to be sleepable to able to examine the args in such depth.
> After quick glance at the code I would put a new hook into
> kfd_ioctl() right before
> retcode = func(filep, process, kdata);
> At this point kdata is already copied from user space 
> and usize, that is cmd specific, is known.
> So bpf prog wouldn't need to copy that data again.
> That will save one copy.
> To drill into details of kfd_ioctl_set_cu_mask() the prog would
> need to be sleepable to do second copy_from_user of cu_mask.
> At least it's not that big.
> Yes, the attachment point will be amd driver specific,
> but the program doesn't need to be.
> It can be generic tracing prog that is agumented to use BTF.
> Something like writeable tracepoint with BTF support would do.
> So on the bpf side there will be minimal amount of changes.
> And in the driver you'll add one or few writeable tracepoints
> and the result of the tracepoint will gate
> retcode = func(filep, process, kdata);
> call in kfd_ioctl().
> The writeable tracepoint would need to be cgroup-bpf based.
> So that's the only tricky part. BPF infra doesn't have
> cgroup+tracepoint scheme. It's probably going to be useful
> in other cases like this. See trace_nbd_send_request.


Yeah I think this proposal doesn't work:

- inspecting ioctl arguments that need copying outside of the
  driver/subsystem doing that copying is fundamentally racy

- there's been a pile of cgroups proposal to manage gpus at the drm
  subsystem level, some by Kenny, and frankly this at least looks a bit
  like a quick hack to sidestep the consensus process for that.

So once we push this into drivers it's not going to be a bpf hook anymore
I think.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
