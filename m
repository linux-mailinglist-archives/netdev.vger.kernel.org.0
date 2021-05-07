Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B54376CDF
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhEGWcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhEGWcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 18:32:09 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB5DC061574;
        Fri,  7 May 2021 15:31:08 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so5234086oto.0;
        Fri, 07 May 2021 15:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0YWXNTKMAQEd6z039aM9XkewcEru+auENvSRDSVALM=;
        b=ZLVjAoadVZr1dEm4/yvhnrf8/J/nef7G15JbUbGrTvaphSPPg1NYoxyWbrvVrYSS1h
         zIa96XTY8P0hpQ+yNemDEgMJuSG/c4WCmiNe6Nc+iCnLydkMAsdGrWvIm/17ma5Z4yM/
         YzsvyYwW+WiotmISk+eiR/i8Cd7aUBrZpHgxnpBYVJ84BXnaaMaWQ2eKqxevUizYrrdW
         YbtS/h3evHXgpLsmcR18uUbQaKsFRYpehUV3Ng/5C9YykCWFXuYzVQL41A0Sr+comc9P
         aI9Yzg1U+9hzWSAs+VHaET9OhHIE/EcNaIBsMQFPLcf6+DcdHyLoOGNPJ3nmswEFT8wv
         svyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0YWXNTKMAQEd6z039aM9XkewcEru+auENvSRDSVALM=;
        b=Vfinu1tiKSfbT2HgkuLUh/RNaRjLZOTXwYIq9dUy+oHugPYJ/nn4t7XtwX5n6cZ0VP
         AtT/ErTwnq+bWVZw+IAm1x2MLe3AJttM+jqk3R+Xzd5ITsR3SU9caFF1a4wfE7dVbRri
         /Mn1vdPM0tSie4yW97HpK0dsCBxPrI2cBTnU+/ATQWc+ZVM9fuJC2PLap2hXXtKVeCLt
         7ybj5YOpsDR2SITck9vpG6HdH9fUg1zgiaq/Ea7FbH2AcWjpFSQL3cWM48AsKi9ODrQn
         iRCrLKR8AsY7dEaQuNQfr4/0w1PIpVnq/c7nyLj0BXp9J27G4buKDJC1eCDLrgaWBECi
         gbcw==
X-Gm-Message-State: AOAM531rHP/CKo+Zq5PKlXzvqN3YZkijNA8/eGWxA+N49gOfcoKS1mx+
        TQ6oTARKtljW7QHcX3T06zfwi162wPk5YDqI6lEmUvvX
X-Google-Smtp-Source: ABdhPJz6COeoWlO2jYoVGMFtMym8VH6Ykqhm4Rnoo8nk0d6rsnG/F5mHf4daWpwa7y0jBo0WQH9c2O2bb827AYiZUvk=
X-Received: by 2002:a05:6830:1f12:: with SMTP id u18mr10532939otg.132.1620426667759;
 Fri, 07 May 2021 15:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <YJUBer3wWKSAeXe7@phenom.ffwll.local> <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local> <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local> <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local> <YJWWByISHSPqF+aN@slm.duckdns.org>
 <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com> <YJWqIVnX9giaKMTG@slm.duckdns.org>
In-Reply-To: <YJWqIVnX9giaKMTG@slm.duckdns.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 7 May 2021 18:30:56 -0400
Message-ID: <CADnq5_PudV4ufQW=DqrDow_vvMQDCJVxjqZeXeTvM=6Xp+a_RQ@mail.gmail.com>
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

On Fri, May 7, 2021 at 4:59 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, May 07, 2021 at 03:55:39PM -0400, Alex Deucher wrote:
> > The problem is temporal partitioning on GPUs is much harder to enforce
> > unless you have a special case like SR-IOV.  Spatial partitioning, on
> > AMD GPUs at least, is widely available and easily enforced.  What is
> > the point of implementing temporal style cgroups if no one can enforce
> > it effectively?
>
> So, if generic fine-grained partitioning can't be implemented, the right
> thing to do is stopping pushing for full-blown cgroup interface for it. The
> hardware simply isn't capable of being managed in a way which allows generic
> fine-grained hierarchical scheduling and there's no point in bloating the
> interface with half baked hardware dependent features.
>
> This isn't to say that there's no way to support them, but what have been
> being proposed is way too generic and ambitious in terms of interface while
> being poorly developed on the internal abstraction and mechanism front. If
> the hardware can't do generic, either implement the barest minimum interface
> (e.g. be a part of misc controller) or go driver-specific - the feature is
> hardware specific anyway. I've repeated this multiple times in these
> discussions now but it'd be really helpful to try to minimize the interace
> while concentrating more on internal abstractions and actual control
> mechanisms.

Maybe we are speaking past each other.  I'm not following.  We got
here because a device specific cgroup didn't make sense.  With my
Linux user hat on, that makes sense.  I don't want to write code to a
bunch of device specific interfaces if I can avoid it.  But as for
temporal vs spatial partitioning of the GPU, the argument seems to be
a sort of hand-wavy one that both spatial and temporal partitioning
make sense on CPUs, but only temporal partitioning makes sense on
GPUs.  I'm trying to understand that assertion.  There are some GPUs
that can more easily be temporally partitioned and some that can be
more easily spatially partitioned.  It doesn't seem any different than
CPUs.

Alex
