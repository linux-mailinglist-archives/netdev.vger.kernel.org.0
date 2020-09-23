Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF1F274F1A
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 04:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgIWClS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 22:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbgIWClO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 22:41:14 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84920C0613D1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 19:41:12 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id k25so15864013ljg.9
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 19:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jc8uPyWeA8lh2ZEVJXFhzEZM6SYIOAImDuM4KwfSrTg=;
        b=D48LKiLW724RXEbvVDcCcvfb/bjfn6Fz7yz848goAqBzaGa96OEdXkzKjJWrEmtr2B
         u1Ww6BlgX5m69XKUjtHN8FSlwIlBBUpYuv+Iprcmx2j45NU7WOcpX7v16h5UuMpNF38e
         rsVxKDi8d64KgOP8GtIFzSYqLc0BiBaOMx2UDviVVwCnG96aL140S/UQe+emedYdhZEg
         hLu/zoRv1FrpWJxCY41I5V0IOBitx8WcSRot3JvqOKnLgKIvj1M9XJRrffwtrDXr8TdH
         22yXODro1beLbWdfHb8BQK9j1iuDsUBHVXXEoj11HOHfDNHMT70/R3FvWVOmVx7rcYUS
         MoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jc8uPyWeA8lh2ZEVJXFhzEZM6SYIOAImDuM4KwfSrTg=;
        b=lAkZbay5CKvucvgQVYgHRwKR0ZNlzZ7MjVP8pl+ok5lCfWLMX0ZfUn/TRI4Q16E1Oo
         oi/FmESUKZBHc6Y2+WFaHli7xK2txNQBscv8UIJnNMF9tw9PfQn+qflkni7WF6isrQKb
         Q+yM+uTn/fRNjAnDjh1iRYRN7TNZhLnFcniAeqE++L/cVWSpAJrJqdBjnCoAR0moawGW
         lcEQb7mnJ+XQkU+EYvZq80QZh4Z0HqgCNa5hvN4CiEKKXzrYFl1KqeH+iSeXMhs9wSBl
         NeHZwv87DhhR5/3NwSEEZVYcaUC+fawcy1ddYtPC67Z6jrRD7D70xeeR7QBL7KVhgQ6y
         pQXA==
X-Gm-Message-State: AOAM532QDP8r6KZwhWwn4JOL5flEoM0hUa/FJCdOse8BzA/euDOz4snW
        yl2raQYRNtZpbWfXckWyR0EXV6nd2CCWotJlkP0Znw==
X-Google-Smtp-Source: ABdhPJwQf9C/dYCgdMs0kvxVPlQBoNh6rC23MBqQ+8aghqCHQkwJBsaQqfGzXUr350qTd1zXmvtw67PsWspk7HwJrUc=
X-Received: by 2002:a2e:889a:: with SMTP id k26mr2388797lji.214.1600828870825;
 Tue, 22 Sep 2020 19:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz> <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
 <20200922095136.GA9682@chrisdown.name> <CAKRVAePisoOg8QBz11gPqzEoUdwPiJ-9Z9MyFE2LHzR-r+PseQ@mail.gmail.com>
 <20200922104252.GB9682@chrisdown.name> <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
 <CALvZod64Qwzjv3N2PO-EUtMkA4bs_PM=Tq4=cmuM0VO9P3BAjw@mail.gmail.com>
In-Reply-To: <CALvZod64Qwzjv3N2PO-EUtMkA4bs_PM=Tq4=cmuM0VO9P3BAjw@mail.gmail.com>
From:   Chunxin Zang <zangchunxin@bytedance.com>
Date:   Wed, 23 Sep 2020 10:40:59 +0800
Message-ID: <CAKRVAeOKWfdeupv9CAj09xxP5RjKq5ji7n+xVnxo+Q4wR0KzTg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Chris Down <chris@chrisdown.name>, Michal Hocko <mhocko@suse.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 3:57 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Tue, Sep 22, 2020 at 5:37 AM Chunxin Zang <zangchunxin@bytedance.com> =
wrote:
> >
> > On Tue, Sep 22, 2020 at 6:42 PM Chris Down <chris@chrisdown.name> wrote=
:
> > >
> > > Chunxin Zang writes:
> > > >On Tue, Sep 22, 2020 at 5:51 PM Chris Down <chris@chrisdown.name> wr=
ote:
> > > >>
> > > >> Chunxin Zang writes:
> > > >> >My usecase is that there are two types of services in one server.=
 They
> > > >> >have difference
> > > >> >priorities. Type_A has the highest priority, we need to ensure it=
's
> > > >> >schedule latency=E3=80=81I/O
> > > >> >latency=E3=80=81memory enough. Type_B has the lowest priority, we=
 expect it
> > > >> >will not affect
> > > >> >Type_A when executed.
> > > >> >So Type_A could use memory without any limit. Type_B could use me=
mory
> > > >> >only when the
> > > >> >memory is absolutely sufficient. But we cannot estimate how much
> > > >> >memory Type_B should
> > > >> >use. Because everything is dynamic. So we can't set Type_B's memo=
ry.high.
> > > >> >
> > > >> >So we want to release the memory of Type_B when global memory is
> > > >> >insufficient in order
> > > >> >to ensure the quality of service of Type_A . In the past, we used=
 the
> > > >> >'force_empty' interface
> > > >> >of cgroup v1.
> > > >>
> > > >> This sounds like a perfect use case for memory.low on Type_A, and =
it's pretty
> > > >> much exactly what we invented it for. What's the problem with that=
?
> > > >
> > > >But we cannot estimate how much memory Type_A uses at least.
> > >
> > > memory.low allows ballparking, you don't have to know exactly how muc=
h it uses.
> > > Any amount of protection biases reclaim away from that cgroup.
> > >
> > > >For example:
> > > >total memory: 100G
> > > >At the beginning, Type_A was in an idle state, and it only used 10G =
of memory.
> > > >The load is very low. We want to run Type_B to avoid wasting machine=
 resources.
> > > >When Type_B runs for a while, it used 80G of memory.
> > > >At this time Type_A is busy, it needs more memory.
> > >
> > > Ok, so set memory.low for Type_A close to your maximum expected value=
.
> >
> > Please forgive me for not being able to understand why setting
> > memory.low for Type_A can solve the problem.
> > In my scene, Type_A is the most important, so I will set 100G to memory=
.low.
> > But 'memory.low' only takes effect passively when the kernel is
> > reclaiming memory. It means that reclaim Type_B's memory only when
> > Type_A  in alloc memory slow path. This will affect Type_A's
> > performance.
> > We want to reclaim Type_B's memory in advance when A is expected to be =
busy.
> >
>
> How will you know when to reclaim from B? Are you polling /proc/meminfo?
>

Monitor global memory usage through the daemon. If the memory is used
80% or 90%, it will reclaim B's memory.

> From what I understand, you want to proactively reclaim from B, so
> that A does not go into global reclaim and in the worst case kill B,
> right?

Yes, it is.

>
> BTW you can use memory.high to reclaim from B by setting it lower than
> memory.current of B and reset it to 'max' once the reclaim is done.
> Since 'B' is not high priority (I am assuming not a latency sensitive
> workload), B hitting temporary memory.high should not be an issue.
> Also I am assuming you don't much care about the amount of memory to
> be reclaimed from B, so I think memory.high can fulfil your use-case.
> However if in future you decide to proactively reclaim from all the
> jobs based on their priority i.e. more aggressive reclaim from B and a
> little bit reclaim from A then memory.high is not a good interface.
>
> Shakeel

Thanks for these suggestions, I will give it a try.

Best wishes
Chunxin
