Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B80437AB15
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhEKPt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbhEKPt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 11:49:28 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93BBC061574;
        Tue, 11 May 2021 08:48:21 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id e7-20020a4ad2470000b02902088d0512ceso1459943oos.8;
        Tue, 11 May 2021 08:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5G3X0SsMYoBRSudd4/RxfVXt3YIGObL1pFXwXeHxFjA=;
        b=ergBPEMz0eajaLPXgWUA6rjor17KYhfwTmK2sOuzzDbXqsPIWtVRKjfxbIfzY9OkIc
         q0L2k0bcDQHmQnOLvySuWkGTMFVDa41heYsNZzJu0POZhOZPPGT8MDgenaetDOwBDhCO
         JZWEsqDG+G1ALmEIReIrhqYUxm/ZrRY7aAZPIYjXQJCm15gyHomQlJ2mOncSfwLSnUUn
         x2ltw4rw0iutyooHA0z3ND6QaxqyQb28rLR3pop34okjpBS4V5vtmt+PSopxAYHRWt8h
         +pljNqMcTsAXw3aWT6x7hsB4OHac8L/kKUSbwPj5bGCzHiu9F6Sx1u0g/8NXmUgau1Xk
         QhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5G3X0SsMYoBRSudd4/RxfVXt3YIGObL1pFXwXeHxFjA=;
        b=acGR549tbPP/qgYb2blIGz706W1bLxZXNWHCEN43aHlhy1ITzDY6/j6E4U+vrB3oLX
         LDUXDatV7ATfm0Sur33yQZX3hImEtzWizQhdIw/jJEOBRxf3BzbDVypn0To/xlPPQ7Jd
         j24UBx6FfEWVtf0uBIPk0SYkEqQRBYfHePOTHtq0kuyYalqXsSS/UZ/thMIYmDoXbbKk
         9b779wQJ5vOEHJFtutlNTIQhWp3BCLSz5pnFbbWge60Tk2CPDbF+tUStPNkTLhZw9neN
         ZhEKEudry+9sdwmImXtKeJtXbBiTi08eotjo/RI5qy4eF5zaCtJsKiY92aiCwS/GlY+k
         MMZw==
X-Gm-Message-State: AOAM532i7K5wkM2I1xZI8uFqiNZBOkZdqB9CJGyy5yFytHBLdpqyrcq2
        N7iPJ5nwrvhGAKjqceN4R5wBMl/n8lQ1XiehnJscNKZ98Hc=
X-Google-Smtp-Source: ABdhPJzACYbQ8TvRjv21GKdTUAKZG5wgcKKCL8UftacLyBzooNVzwknDRupMyFB2bQaOxgOZJU1/+G22G6kfIOv1RJs=
X-Received: by 2002:a4a:d085:: with SMTP id i5mr23978147oor.61.1620748101287;
 Tue, 11 May 2021 08:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <YJVnO+TCRW83S6w4@phenom.ffwll.local> <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local> <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local> <YJWWByISHSPqF+aN@slm.duckdns.org>
 <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com>
 <YJWqIVnX9giaKMTG@slm.duckdns.org> <CADnq5_PudV4ufQW=DqrDow_vvMQDCJVxjqZeXeTvM=6Xp+a_RQ@mail.gmail.com>
 <YJXRHXIykyEBdnTF@slm.duckdns.org>
In-Reply-To: <YJXRHXIykyEBdnTF@slm.duckdns.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 11 May 2021 11:48:10 -0400
Message-ID: <CADnq5_MDvhJiA2rd6ELAx87x2RdXJ_Am6N=xZQdtsG_KCubAtw@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Tejun Heo <tj@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 7:45 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, May 07, 2021 at 06:30:56PM -0400, Alex Deucher wrote:
> > Maybe we are speaking past each other.  I'm not following.  We got
> > here because a device specific cgroup didn't make sense.  With my
> > Linux user hat on, that makes sense.  I don't want to write code to a
> > bunch of device specific interfaces if I can avoid it.  But as for
> > temporal vs spatial partitioning of the GPU, the argument seems to be
> > a sort of hand-wavy one that both spatial and temporal partitioning
> > make sense on CPUs, but only temporal partitioning makes sense on
> > GPUs.  I'm trying to understand that assertion.  There are some GPUs
>
> Spatial partitioning as implemented in cpuset isn't a desirable model. It's
> there partly because it has historically been there. It doesn't really
> require dynamic hierarchical distribution of anything and is more of a way
> to batch-update per-task configuration, which is how it's actually
> implemented. It's broken too in that it interferes with per-task affinity
> settings. So, not exactly a good example to follow. In addition, this sort
> of partitioning requires more hardware knowledge and GPUs are worse than
> CPUs in that hardwares differ more.
>
> Features like this are trivial to implement from userland side by making
> per-process settings inheritable and restricting who can update the
> settings.
>
> > that can more easily be temporally partitioned and some that can be
> > more easily spatially partitioned.  It doesn't seem any different than
> > CPUs.
>
> Right, it doesn't really matter how the resource is distributed. What
> matters is how granular and generic the distribution can be. If gpus can
> implement work-conserving proportional distribution, that's something which
> is widely useful and inherently requires dynamic scheduling from kernel
> side. If it's about setting per-vendor affinities, this is way too much
> cgroup interface for a feature which can be easily implemented outside
> cgroup. Just do per-process (or whatever handles gpus use) and confine their
> configurations from cgroup side however way.
>
> While the specific theme changes a bit, we're basically having the same
> discussion with the same conclusion over the past however many months.
> Hopefully, the point is clear by now.

Thanks, that helps a lot.

Alex
