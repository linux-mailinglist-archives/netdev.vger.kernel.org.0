Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4F82739A5
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 06:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgIVEV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 00:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgIVEV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 00:21:28 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD2DC061755;
        Mon, 21 Sep 2020 21:21:28 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y2so5319600ila.0;
        Mon, 21 Sep 2020 21:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZNNbuALh04//uifYVPdDjh++fb2lT/Xqcs4an3gHVio=;
        b=eF/EbBSe9yFBqTjdwzbFsunrkCPqbYXgfxHDSEkrckP5A1JHkh3XKpgKh1/IGo/vpm
         PxlwoZMqDyyio84Vt96+iIDsRTiLJBgiQsTvGsDCpKt/pgm36IvvjTbwaqIKrGYde6Hi
         0BHrqmtRg+GVQzDb9NRZEk/zfFZn8kaIVBnLwClJLRYsQc+uNdTo9V0vEmmil93p8bpC
         gB9+qh4AB+tp0jmSgoo6Fcn9UmBpXDRPaykudNaQMqKbTqnFcAEL0jv3aGMx7vnanVue
         GIlYCRrZPBKR9PHUH6u1kyqfeUZu/yQM1gKgTq9owy3HhmFOH2sUvEg8zRosVx5M7MpM
         vbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZNNbuALh04//uifYVPdDjh++fb2lT/Xqcs4an3gHVio=;
        b=ELqTN1ptjUZ0xy1YDpLE9z7r94uOTlGql3AEKLgPWcJXgJxfN5qBJI5wwUnzNN5+CK
         F6F8WcjvtJ6qqGaxdqwMvfQIal0zB5TqIoeFxdP03h1px1mgZtrFM9DST+aHm2ggBqRf
         IOGR9K1f/anaiHIZ+IMzg+DpSb5LpJ9o0sEZNvW+Fb+Ezv6dbZkmiV2vPBiKpJp14yNE
         1VhxKOtYIG0ZQUGkHnTUlo30LabxAB2vKp0ISXefpHWkuhTF7kvDp3GqCXWqa7tjNP7Q
         waA1ZvlQCjDtbUmX2HMx/dvOUiFkJIYshrms/VzlxyKF+AcmkNzQ1EWTCwWch4nMQHdj
         NYXw==
X-Gm-Message-State: AOAM532YZq5wlZa8xJvtykpux3TuSunX5IuatjMb46MZB0W4/dgqYZHe
        peysrAANkkMyU6wUEk5fRXpopzv6nvwEgV1qlzc=
X-Google-Smtp-Source: ABdhPJzDl8MdjPVNRJmS4FRLkv0hUY6IYs3el3g0ioVtIQKA0mfz3YZi4KUDwxEL6Q++VW2yZEYb9pNfWRlG4ObXVfo=
X-Received: by 2002:a92:c7b0:: with SMTP id f16mr2847131ilk.137.1600748488148;
 Mon, 21 Sep 2020 21:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz> <CALOAHbCDXwjN+WDSGVv+G3ho-YRRPjAAqMJBtyxeGHH6utb5ew@mail.gmail.com>
 <20200921113646.GJ12990@dhcp22.suse.cz>
In-Reply-To: <20200921113646.GJ12990@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 22 Sep 2020 12:20:52 +0800
Message-ID: <CALOAHbCker64WEW9w4oq8=avA6oKf3-Jrn-vOOgkpqkV3g+CYA@mail.gmail.com>
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
To:     Michal Hocko <mhocko@suse.com>
Cc:     zangchunxin@bytedance.com, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 7:36 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 21-09-20 19:23:01, Yafang Shao wrote:
> > On Mon, Sep 21, 2020 at 7:05 PM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Mon 21-09-20 18:55:40, Yafang Shao wrote:
> > > > On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
> > > > >
> > > > > On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > > > > > From: Chunxin Zang <zangchunxin@bytedance.com>
> > > > > >
> > > > > > In the cgroup v1, we have 'force_mepty' interface. This is very
> > > > > > useful for userspace to actively release memory. But the cgroup
> > > > > > v2 does not.
> > > > > >
> > > > > > This patch reuse cgroup v1's function, but have a new name for
> > > > > > the interface. Because I think 'drop_cache' may be is easier to
> > > > > > understand :)
> > > > >
> > > > > This should really explain a usecase. Global drop_caches is a terrible
> > > > > interface and it has caused many problems in the past. People have
> > > > > learned to use it as a remedy to any problem they might see and cause
> > > > > other problems without realizing that. This is the reason why we even
> > > > > log each attempt to drop caches.
> > > > >
> > > > > I would rather not repeat the same mistake on the memcg level unless
> > > > > there is a very strong reason for it.
> > > > >
> > > >
> > > > I think we'd better add these comments above the function
> > > > mem_cgroup_force_empty() to explain why we don't want to expose this
> > > > interface in cgroup2, otherwise people will continue to send this
> > > > proposal without any strong reason.
> > >
> > > I do not mind people sending this proposal.  "V1 used to have an
> > > interface, we need it in v2 as well" is not really viable without
> > > providing more reasoning on the specific usecase.
> > >
> > > _Any_ patch should have a proper justification. This is nothing really
> > > new to the process and I am wondering why this is coming as a surprise.
> > >
> >
> > Container users always want to drop cache in a specific container,
> > because they used to use drop_caches to fix memory pressure issues.
>
> This is exactly the kind of problems we have seen in the past. There
> should be zero reason to addre potential reclaim problems by dropping
> page cache on the floor. There is a huge cargo cult about this
> procedure and I have seen numerous reports when people complained about
> performance afterwards just to learn that the dropped page cache was one
> of the resons for that.
>
> > Although drop_caches can cause some unexpected issues, it could also
> > fix some issues.
>
> "Some issues" is way too general. We really want to learn about those
> issues and address them properly.
>

One use case in our production environment is that some of our tasks
become very latency sensitive from 7am to 10am, so before these tasks
become active we will use drop_caches to drop page caches generated by
other tasks at night to avoid these tasks triggering direct reclaim.
The best way to do it is to fix the latency in direct reclaim, but it
will take great effort. while drop_caches give us an easier way to
achieve the same goal.
IOW, drop_caches give the users an option to achieve their goal before
they find a better solution.

> > So container users want to use it in containers as
> > well.
> > If this feature is not implemented in cgroup, they will ask you why
> > but there is no explanation in the kernel.
>
> There is no usecase that would really require it so far.
>
> > Regarding the memory.high, it is not perfect as well, because you have
> > to set it to 0 to drop_caches, and the processes in the containers
> > have to reclaim pages as well because they reach the memory.high, but
> > memory.force_empty won't make other processes to reclaim.
>
> Since 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering
> memory.high") the limit is set after the reclaim so the race window when
> somebody would be pushed to high limit reclaim is reduced. But I do
> agree this is just a workaround.
>
> > That doesn't mean I agree to add this interface, while I really mean
> > that if we discard one feature we'd better explain why.
>
> We need to understand why somebody wants an interface because once it is
> added it will have to be maintained for ever.
> --
> Michal Hocko
> SUSE Labs



-- 
Thanks
Yafang
