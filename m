Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EFF272193
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgIUK4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgIUK4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFEBC0613CF;
        Mon, 21 Sep 2020 03:56:17 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g128so14830955iof.11;
        Mon, 21 Sep 2020 03:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5BtOR37a3OHIsYrI7h/K+rcNoAndC5S3VxYKqZAyq/I=;
        b=D4rQ16znNdt5CP0e41XYbrzCGebWUDkm16H2DmcjT/Bn1mFbg2muRKWYb3/g7roa1Z
         SIXFKJFiJbvP7v/h0s+Wrgt/QuAVN2/k1Hgtj3vGRVan8w3sk22u5fr84eo5cQiNbf+r
         0hgcFmrfBMEoU8uicUxjxxUi6zYoox4fijENrM8bhnEh7kwMGh0Ke7WzzApLwuZ2QM+K
         TwgSowGJJ36XIJw6wZ4IAQIy0CUnDvalE8cM3hcdOID97NoV5+7ZZMTq2ipat+rmKyP6
         ackv0YLVWrdndNJlFGGUL37XSpjFCG8Oci1fiP4tD/3IgS7xCmQHfNcV8qz4wEAn42JA
         5CDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5BtOR37a3OHIsYrI7h/K+rcNoAndC5S3VxYKqZAyq/I=;
        b=Bkrtkorq3tvgTK+wz5JOhGKo9irlJTWHHp3EC4YN81z3u0vACNjGYh1KEuQZ9QBxU2
         VdjwUPnVbJ03doK2GDiLlcACUKIFfXvMurI5btMoBIxaq6cLZ31rp1ZOgv0blZ0+NPfV
         uZ+x3+iNTr+Sddx9w4aoBOkiuSnPAX6d/Wl83VRLDuQzI86LZ3o8A8SzgBGHRY9Vw6BT
         MDxFI1CRmy0dG5x7tq7dKsZUvs972nkMKchl1muyw4ZPXa9PreP7kBDIDvdui+PhTp/o
         E3wOH4tsKWGGj/fYFiOnztPKQU6WNffCjwbzit22lNcghupDPJ9mynPuHUmGS2ROkpnS
         1Epg==
X-Gm-Message-State: AOAM533O6inRC2zUhxjN2Ttk3qY2TxvASI8TAVbiwSJe377GPrrUVgC/
        Nju9CEyjptlLGQnqtsDMDL2nlZyTlaHVo+hjOhA=
X-Google-Smtp-Source: ABdhPJx56VNqPYz9Y++kiS/q8eylUU9IYIG298M0UB0Xm4SokD4cg+H0rHxRTuF9Sy0GCffccLLpEZlUksaGhsxwsUo=
X-Received: by 2002:a05:6602:21cc:: with SMTP id c12mr35177041ioc.81.1600685777190;
 Mon, 21 Sep 2020 03:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200921080255.15505-1-zangchunxin@bytedance.com> <20200921081200.GE12990@dhcp22.suse.cz>
In-Reply-To: <20200921081200.GE12990@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 21 Sep 2020 18:55:40 +0800
Message-ID: <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
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

On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > From: Chunxin Zang <zangchunxin@bytedance.com>
> >
> > In the cgroup v1, we have 'force_mepty' interface. This is very
> > useful for userspace to actively release memory. But the cgroup
> > v2 does not.
> >
> > This patch reuse cgroup v1's function, but have a new name for
> > the interface. Because I think 'drop_cache' may be is easier to
> > understand :)
>
> This should really explain a usecase. Global drop_caches is a terrible
> interface and it has caused many problems in the past. People have
> learned to use it as a remedy to any problem they might see and cause
> other problems without realizing that. This is the reason why we even
> log each attempt to drop caches.
>
> I would rather not repeat the same mistake on the memcg level unless
> there is a very strong reason for it.
>

I think we'd better add these comments above the function
mem_cgroup_force_empty() to explain why we don't want to expose this
interface in cgroup2, otherwise people will continue to send this
proposal without any strong reason.


> > Signed-off-by: Chunxin Zang <zangchunxin@bytedance.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 11 +++++++++++
> >  mm/memcontrol.c                         |  5 +++++
> >  2 files changed, 16 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index ce3e05e41724..fbff959c8116 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1181,6 +1181,17 @@ PAGE_SIZE multiple when read back.
> >       high limit is used and monitored properly, this limit's
> >       utility is limited to providing the final safety net.
> >
> > +  memory.drop_cache
> > +    A write-only single value file which exists on non-root
> > +    cgroups.
> > +
> > +    Provide a mechanism for users to actively trigger memory
> > +    reclaim. The cgroup will be reclaimed and as many pages
> > +    reclaimed as possible.
> > +
> > +    It will broke low boundary. Because it tries to reclaim the
> > +    memory many times, until the memory drops to a certain level.
> > +
> >    memory.oom.group
> >       A read-write single value file which exists on non-root
> >       cgroups.  The default value is "0".
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 0b38b6ad547d..98646484efff 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6226,6 +6226,11 @@ static struct cftype memory_files[] = {
> >               .write = memory_max_write,
> >       },
> >       {
> > +             .name = "drop_cache",
> > +             .flags = CFTYPE_NOT_ON_ROOT,
> > +             .write = mem_cgroup_force_empty_write,
> > +     },
> > +     {
> >               .name = "events",
> >               .flags = CFTYPE_NOT_ON_ROOT,
> >               .file_offset = offsetof(struct mem_cgroup, events_file),
> > --
> > 2.11.0
>
> --
> Michal Hocko
> SUSE Labs
>


-- 
Thanks
Yafang
