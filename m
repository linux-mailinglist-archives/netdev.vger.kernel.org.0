Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CE7376ADF
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 21:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhEGT4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 15:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhEGT4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 15:56:51 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98747C061574;
        Fri,  7 May 2021 12:55:50 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id b5-20020a9d5d050000b02902a5883b0f4bso8927126oti.2;
        Fri, 07 May 2021 12:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mQnyWX8UpAFeWLBPcl0wEiusAg79AJ6iCjS7XN+qQUM=;
        b=O5HPILdivS0YKoqsFW5OAMccSfukgoFEyl8T8sxZ8qj4bfkEpHHl5xDocVhjtlKa/h
         KsmUB1DuEpCrO/tSrnyXV/6Dglcw9GYIoKGsbHmB1BVHAE7+08kotid/6awVvg2KMcLP
         OgJN3XzHyoWPbAGypOHIurPHF9JhVWJaE05OCMq28h2SBibVWcUrJTrDOVjDoN2ktJqH
         hrHWUvUXr4Zl90u3mOepyMvg6WFXF1FhjSSMN/UWyXUzr3YKNx29U1CUHg3p5WnQcjge
         WbRs0n0b6ywU9WJy4EGJsdc12xiRjZJondmU2lAWvgX717bAFdUw9cm8E2c4kelZO79s
         ASxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mQnyWX8UpAFeWLBPcl0wEiusAg79AJ6iCjS7XN+qQUM=;
        b=aV5LanOPeHFErWlHiyfgTiAEdY5lZQZv/lYOYzWoMRdQBc1LYCao/9nf9h9yVIrQ0r
         5qi6PeFwMFMicTZ7fljCkGScYUmsaf3hmal3fpbA8AbRVEr8jRmeSDarg7MaMmS4ilfZ
         USyo1FafXUr6+fQsAaLf7DRrTjqCbog083hznaGwIL4gfcKDQ6djlnm6mobCUWekotL+
         G6b3xcyEPAl9bA8mDTgMEgNHQTqEJjKxfv+8AdEOpbLQkGJaOa8zmzbQVVPTWa8mQ/vL
         OSq+8LWbqef9elK5f1xj3VmmwKadeAQYdi2LRasvmYhKCo1M5FKsnH+j/s7rie/gboeL
         FFSw==
X-Gm-Message-State: AOAM532ytmSeuLllNvRFjRk9Rz7brKAgUTHy8WH1d2uKCCMM4Tnkyt8b
        gu6ylTyAcS2U/zbPDgmoIoXMsIDLDllQUWcxZtI=
X-Google-Smtp-Source: ABdhPJxSN3/17xHdFjhSCghcx/8s/LWHl/NuI+//RSo2pAWsPuDQlJpfn0/5Rjl3B/LGJlLffIe5AbmBEavYIDEc+bk=
X-Received: by 2002:a9d:51c6:: with SMTP id d6mr3297673oth.311.1620417349972;
 Fri, 07 May 2021 12:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local> <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local> <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local> <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local> <YJWWByISHSPqF+aN@slm.duckdns.org>
In-Reply-To: <YJWWByISHSPqF+aN@slm.duckdns.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 7 May 2021 15:55:39 -0400
Message-ID: <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com>
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

On Fri, May 7, 2021 at 3:33 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, May 07, 2021 at 06:54:13PM +0200, Daniel Vetter wrote:
> > All I meant is that for the container/cgroups world starting out with
> > time-sharing feels like the best fit, least because your SRIOV designers
> > also seem to think that's the best first cut for cloud-y computing.
> > Whether it's virtualized or containerized is a distinction that's getting
> > ever more blurry, with virtualization become a lot more dynamic and
> > container runtimes als possibly using hw virtualization underneath.
>
> FWIW, I'm completely on the same boat. There are two fundamental issues with
> hardware-mask based control - control granularity and work conservation.
> Combined, they make it a significantly more difficult interface to use which
> requires hardware-specific tuning rather than simply being able to say "I
> wanna prioritize this job twice over that one".
>
> My knoweldge of gpus is really limited but my understanding is also that the
> gpu cores and threads aren't as homogeneous as the CPU counterparts across
> the vendors, product generations and possibly even within a single chip,
> which makes the problem even worse.
>
> Given that GPUs are time-shareable to begin with, the most universal
> solution seems pretty clear.

The problem is temporal partitioning on GPUs is much harder to enforce
unless you have a special case like SR-IOV.  Spatial partitioning, on
AMD GPUs at least, is widely available and easily enforced.  What is
the point of implementing temporal style cgroups if no one can enforce
it effectively?

Alex

>
> Thanks.
>
> --
> tejun
