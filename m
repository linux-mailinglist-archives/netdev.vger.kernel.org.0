Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D340F2A5A8E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 00:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgKCX2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 18:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgKCX2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 18:28:09 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C74C0613D1;
        Tue,  3 Nov 2020 15:28:09 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id x13so14929503pgp.7;
        Tue, 03 Nov 2020 15:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eRl//7At+Wm2EvC4VlJ9A50IgrwQOr/jqI3Y/MXhPxg=;
        b=kmZVUoU/Ml29s2vai8g/wNXjAaEbkI2ty7/6v1tIWH/TsVrRa4VJjMGFgMG6+GfqOd
         9YUZ70jBPbJJsjQW/+jbVP+kYL/cKNZnzawk7FKkjXECBfHU0twg+Y03hcoyYt1HAV4r
         dwuVHNxylpag7OCuMJnFlLe/C1x/Gtlnr/dRj2KKStNq7iQecKuIkiwlgblsw44EQOCi
         +u/IO3JItZUNB9dcbEqwcJ6zSBEnqh3W7zEq03ns+7jyjKspZ61r4pdJQZGsqvvgg8Rt
         oeJ/OCsatIzsx20LV3rXcQ4JRKe03TqSXJu1lX8dMm4zOhLKyK9wt7RGo0qAPkfiqv6S
         cdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eRl//7At+Wm2EvC4VlJ9A50IgrwQOr/jqI3Y/MXhPxg=;
        b=PpDYWBpft5QfqqDUOiW0aB0i+brG0Lt9ZC1YaiIPzwHmu2WrNNo/wZCUVMzJLMqhOJ
         B3rt2xvc2uEe0OfHDyHx/J7A0YeC0JoSK6HYvsrOhT402fopcCEFd95MDar4OqSInD5V
         2FDX6yCpElEw5vW3QrM7cPN0yeKrmvNNRFBru4QshYJBr+GFeM8qWAmijF8QcKj1vtsX
         fSbmGz5R+m5MvWoJsv9VLPlOWoA0HXDx5b0kkuY6ClO7DamhE7FBeNbW3XRHtjgRdJNh
         MQrtgJk3FH9SH0hPq2uNOnEXzLDaGqGP9var9GzLwqbZ3XGwiwF1LiMUqZdrNSax9zUM
         EBCA==
X-Gm-Message-State: AOAM531ILp624++hlI6MXOk72A0peev0YvUd8J1NT497jvDloDWQLLZG
        q3D1bvq4ZW1qLGfE0GengZI=
X-Google-Smtp-Source: ABdhPJwA1Y3V3bXAbq5RWgN0tRPA1Lm5ZwU9tdZvWFuGd5NX2rWIgARC5HkbuwN5Li8owzB81DvZcw==
X-Received: by 2002:a63:5153:: with SMTP id r19mr18783989pgl.130.1604446089195;
        Tue, 03 Nov 2020 15:28:09 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id w19sm209327pff.6.2020.11.03.15.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 15:28:08 -0800 (PST)
Date:   Tue, 3 Nov 2020 15:28:05 -0800
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
Message-ID: <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 05:57:47PM -0500, Kenny Ho wrote:
> On Tue, Nov 3, 2020 at 4:04 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Nov 03, 2020 at 02:19:22PM -0500, Kenny Ho wrote:
> > > On Tue, Nov 3, 2020 at 12:43 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > > On Mon, Nov 2, 2020 at 9:39 PM Kenny Ho <y2kenny@gmail.com> wrote:
> >
> > Sounds like either bpf_lsm needs to be made aware of cgv2 (which would
> > be a great thing to have regardless) or cgroup-bpf needs a drm/gpu specific hook.
> > I think generic ioctl hook is too broad for this use case.
> > I suspect drm/gpu internal state would be easier to access inside
> > bpf program if the hook is next to gpu/drm. At ioctl level there is 'file'.
> > It's probably too abstract for the things you want to do.
> > Like how VRAM/shader/etc can be accessed through file?
> > Probably possible through a bunch of lookups and dereferences, but
> > if the hook is custom to GPU that info is likely readily available.
> > Then such cgroup-bpf check would be suitable in execution paths where
> > ioctl-based hook would be too slow.
> Just to clarify, when you say drm specific hook, did you mean just a
> unique attach_type or a unique prog_type+attach_type combination?  (I
> am still a bit fuzzy on when a new prog type is needed vs a new attach
> type.  I think prog type is associated with a unique type of context
> that the bpf prog will get but I could be missing some nuances.)
> 
> When I was thinking of doing an ioctl wide hook, the file would be the
> device file and the thinking was to have a helper function provided by
> device drivers to further disambiguate.  For our (AMD's) driver, we
> have a bunch of ioctls for set/get/create/destroy
> (https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c#L1763)
> so the bpf prog can make the decision after the disambiguation.  For
> example, we have an ioctl called "kfd_ioctl_set_cu_mask."  You can

Thanks for the pointer.
That's one monster ioctl. So much copy_from_user.
BPF prog would need to be sleepable to able to examine the args in such depth.
After quick glance at the code I would put a new hook into
kfd_ioctl() right before
retcode = func(filep, process, kdata);
At this point kdata is already copied from user space 
and usize, that is cmd specific, is known.
So bpf prog wouldn't need to copy that data again.
That will save one copy.
To drill into details of kfd_ioctl_set_cu_mask() the prog would
need to be sleepable to do second copy_from_user of cu_mask.
At least it's not that big.
Yes, the attachment point will be amd driver specific,
but the program doesn't need to be.
It can be generic tracing prog that is agumented to use BTF.
Something like writeable tracepoint with BTF support would do.
So on the bpf side there will be minimal amount of changes.
And in the driver you'll add one or few writeable tracepoints
and the result of the tracepoint will gate
retcode = func(filep, process, kdata);
call in kfd_ioctl().
The writeable tracepoint would need to be cgroup-bpf based.
So that's the only tricky part. BPF infra doesn't have
cgroup+tracepoint scheme. It's probably going to be useful
in other cases like this. See trace_nbd_send_request.
