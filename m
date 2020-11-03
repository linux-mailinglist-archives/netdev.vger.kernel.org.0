Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FD52A3C08
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgKCFjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCFjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:39:43 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D2EC0617A6;
        Mon,  2 Nov 2020 21:39:41 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 33so6281332wrl.7;
        Mon, 02 Nov 2020 21:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6C1TddxGZ0d1C85NySMzJA5NrgJ86kaMDvlk9LRzkyE=;
        b=n2AklAvwP4/fcdo+i/2fc9mZ6k8H5UKcX7DnjoynfxwW2cGSAiXmmmv6QRVRqMm3GT
         Qs4H+7sA+/utS7+pg3ScIu8hjO7RJdSpK6pOHrk32QdTt13Iy00a82UWD2iSmlvdVF5d
         mVP7mPciRHJmHaWX8zErMZexWJF6aAcK/5vvmjGCj2kE1TzLTDOozUos0fJHuvurT7i1
         /HA+XLm91nJ5I7CADFUOaiGcQJ7wSSb2upTmZQKcs4bU3wfvA8NdSS0GBO/GbMxGWptQ
         tN10B55HLmapm2QvRBMaDxWAa2uHDRV4kXgPTXk6lPTAM958Je4nwgSuUsNJ85rtjTUC
         t3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6C1TddxGZ0d1C85NySMzJA5NrgJ86kaMDvlk9LRzkyE=;
        b=AqFpIF9pCsRFoh2/0tSlQQbXwTkWLjsb652Mjx+P96cjtkDt4DEffu/fURWB82QWpI
         T8AeW9SjY0Fgl284Gj+zZhMBofTc0rWXW17900eCD8H5EzWlQBZFi98Efq5C88qmiAyx
         fl6psRgzxf9UgPgNw1tznSDqYm77GcEvGx3mzuUugQXwGkulleKqZNZ+vgHGjAg/dl05
         htRFqg13xoXe/6euXvz0zvKH77ewOkELpv7GoBB1lTu5VdqdcKZIQKCvLhaRr3r2bFoL
         2UXveOTRU9h6ZkPwsZaLTFU2pnCbUCLo61Y5+A3YNnsIBBHSZa5DeD6gYeMRCJ1jEU1a
         RcXw==
X-Gm-Message-State: AOAM533SkTDf2eDl00sltSTb7EMs5NTTXfz8DcauQPMN2+vN0rjyKiFm
        ACQSb1qxQczzyWeBSV6+1Se/azrFDJI+X26kuYE=
X-Google-Smtp-Source: ABdhPJxl2fyP6H4Ckfcblm4W3ysXznnjOu273I6HMBCs7HZg2+3bhOixkyuBsxDq0UlHPwnyP0E32xGegpqQeZr/ekM=
X-Received: by 2002:a5d:6287:: with SMTP id k7mr23777512wru.402.1604381980020;
 Mon, 02 Nov 2020 21:39:40 -0800 (PST)
MIME-Version: 1.0
References: <20201007152355.2446741-1-Kenny.Ho@amd.com> <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Tue, 3 Nov 2020 00:39:28 -0500
Message-ID: <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
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
        KP Singh <kpsingh@chromium.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cgroups@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the reply.  Cgroup awareness is desired because the intent
is to use this for resource management as well (potentially along with
other cgroup controlled resources.)  I will dig into bpf_lsm and learn
more about it.

Regards,
Kenny


On Tue, Nov 3, 2020 at 12:32 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Nov 02, 2020 at 02:23:02PM -0500, Kenny Ho wrote:
> > Adding a few more emails from get_maintainer.pl and bumping this
> > thread since there hasn't been any comments so far.  Is this too
> > crazy?  Am I missing something fundamental?
>
> sorry for delay. Missed it earlier. Feel free to ping the mailing list
> sooner next time.
>
> > On Wed, Oct 7, 2020 at 11:24 AM Kenny Ho <Kenny.Ho@amd.com> wrote:
> > >
> > > This is a skeleton implementation to invite comments and generate
> > > discussion around the idea of introducing a bpf-cgroup program type to
> > > control ioctl access.  This is modelled after
> > > BPF_PROG_TYPE_CGROUP_DEVICE.  The premise is to allow system admins to
> > > write bpf programs to block some ioctl access, potentially in conjunction
> > > with data collected by other bpf programs stored in some bpf maps and
> > > with bpf_spin_lock.
> > >
> > > For example, a bpf program has been accumulating resource usaging
> > > statistic and a second bpf program of BPF_PROG_TYPE_CGROUP_IOCTL would
> > > block access to previously mentioned resource via ioctl when the stats
> > > stored in a bpf map reaches certain threshold.
> > >
> > > Like BPF_PROG_TYPE_CGROUP_DEVICE, the default is permissive (i.e.,
> > > ioctls are not blocked if no bpf program is present for the cgroup.) to
> > > maintain current interface behaviour when this functionality is unused.
> > >
> > > Performance impact to ioctl calls is minimal as bpf's in-kernel verifier
> > > ensure attached bpf programs cannot crash and always terminate quickly.
> > >
> > > TODOs:
> > > - correct usage of the verifier
> > > - toolings
> > > - samples
> > > - device driver may provide helper functions that take
> > > bpf_cgroup_ioctl_ctx and return something more useful for specific
> > > device
> > >
> > > Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
> ...
> > > @@ -45,6 +46,10 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > >         if (!filp->f_op->unlocked_ioctl)
> > >                 goto out;
> > >
> > > +       error = BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg);
> > > +       if (error)
> > > +               goto out;
> > > +
>
> That's a bit problematic, since we have bpf_lsm now.
> Could you use security_file_ioctl hook and do the same filtering there?
> It's not cgroup based though. Is it a concern?
> If cgroup scoping is really necessary then it's probably better
> to add it to bpf_lsm. Then all hooks will become cgroup aware.
