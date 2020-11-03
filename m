Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9652A3BF6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgKCFct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCFct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:32:49 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65D3C0617A6;
        Mon,  2 Nov 2020 21:32:48 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id z1so8007034plo.12;
        Mon, 02 Nov 2020 21:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UZv2P1PlpxDMiV1uaU5trzoljWOaeGRNHFFhjSzWpT0=;
        b=R3TNMnNAlQI5nJk2Z1ytvhVYBiVwW4jJCzEMwcWSeKfdU8/TYHNzwU4h334zUfqlAe
         mHCFPEyqYmaSVAwtm4y51iDoEh8042L5KYyHyUhFTSAlyy+hMU/xrAQKyzJwYX4VnzY/
         iE8tNHVgpwLT/jMYHQsx5ybz5lHoksD6NSsy0MSePcuduroaMKYFbVvgW1xZKieDS9lu
         +H7Z8F3R0qGNzKYTn0otbJ2e/0geFcV4wmzmJDU9UjVnY4rPzBlWMIQ73tesAEtd8lfn
         PjHuJcRwkXtJZwlMFWzh3EB/mBDdmII/6RDf51vpqb8IRd+IX+sb+rewRDnT7Plim/nj
         YIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UZv2P1PlpxDMiV1uaU5trzoljWOaeGRNHFFhjSzWpT0=;
        b=FNoOlYFIwRRwU5wsuoROhFh6paUoai+ZvhSoUsh+h0O+0N3053w+DHnGwsSgf+lp/R
         9k6Y1h6GUFoSeAohWIcb3u/kRKvPCbjecGO5DOfmR0ErISX13E5voFlzpfdqbzFdZkgV
         r9NZe7UJ9VT4tWfMLTv9LIJYekyVS2pZnmOde92JelcgVB4pCNeWc1p1cJlItIlN12u/
         oNiphmucljczCO9YGYnwf1QdcQhEfPuGr450vdNDQtRbTSeX3Xl0mK3MjRYAjnN/MgKW
         aRfCZDPL2JCi2mhGDqLU2LVoEnaajNfS5zgaAIaBWG0bWlJrMnj5alHvlgMejUB4MnyM
         6pGg==
X-Gm-Message-State: AOAM530I9qBRsUMk75LdyDjrKXCQkAXGS2NmElYtLUwI4EpQnRcGfRUd
        6q/u/PipEZ8TkgtVdox3u1YbqzHOl+jX7A==
X-Google-Smtp-Source: ABdhPJwVwHxTBpJRDKlFrvmNcUTQ70oA9jZz+ScZQugs3f1VEc0nyAyXVJbJRJc5m/C9NiFao8dyaw==
X-Received: by 2002:a17:902:ed01:b029:d6:bb79:d46a with SMTP id b1-20020a170902ed01b02900d6bb79d46amr12801660pld.76.1604381568335;
        Mon, 02 Nov 2020 21:32:48 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id q5sm1400422pjj.26.2020.11.02.21.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 21:32:47 -0800 (PST)
Date:   Mon, 2 Nov 2020 21:32:44 -0800
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
        KP Singh <kpsingh@chromium.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cgroups@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Message-ID: <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 02:23:02PM -0500, Kenny Ho wrote:
> Adding a few more emails from get_maintainer.pl and bumping this
> thread since there hasn't been any comments so far.  Is this too
> crazy?  Am I missing something fundamental?

sorry for delay. Missed it earlier. Feel free to ping the mailing list
sooner next time.

> On Wed, Oct 7, 2020 at 11:24 AM Kenny Ho <Kenny.Ho@amd.com> wrote:
> >
> > This is a skeleton implementation to invite comments and generate
> > discussion around the idea of introducing a bpf-cgroup program type to
> > control ioctl access.  This is modelled after
> > BPF_PROG_TYPE_CGROUP_DEVICE.  The premise is to allow system admins to
> > write bpf programs to block some ioctl access, potentially in conjunction
> > with data collected by other bpf programs stored in some bpf maps and
> > with bpf_spin_lock.
> >
> > For example, a bpf program has been accumulating resource usaging
> > statistic and a second bpf program of BPF_PROG_TYPE_CGROUP_IOCTL would
> > block access to previously mentioned resource via ioctl when the stats
> > stored in a bpf map reaches certain threshold.
> >
> > Like BPF_PROG_TYPE_CGROUP_DEVICE, the default is permissive (i.e.,
> > ioctls are not blocked if no bpf program is present for the cgroup.) to
> > maintain current interface behaviour when this functionality is unused.
> >
> > Performance impact to ioctl calls is minimal as bpf's in-kernel verifier
> > ensure attached bpf programs cannot crash and always terminate quickly.
> >
> > TODOs:
> > - correct usage of the verifier
> > - toolings
> > - samples
> > - device driver may provide helper functions that take
> > bpf_cgroup_ioctl_ctx and return something more useful for specific
> > device
> >
> > Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
...
> > @@ -45,6 +46,10 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >         if (!filp->f_op->unlocked_ioctl)
> >                 goto out;
> >
> > +       error = BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg);
> > +       if (error)
> > +               goto out;
> > +

That's a bit problematic, since we have bpf_lsm now.
Could you use security_file_ioctl hook and do the same filtering there?
It's not cgroup based though. Is it a concern?
If cgroup scoping is really necessary then it's probably better
to add it to bpf_lsm. Then all hooks will become cgroup aware.
