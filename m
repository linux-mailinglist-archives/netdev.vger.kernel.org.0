Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C892749A0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 21:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIVT5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 15:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgIVT5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 15:57:33 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A153C0613D0
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 12:57:33 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a22so15149536ljp.13
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 12:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z6CQ4PR7LXXUvvSI+PnJV2oiFyZAUecU41+cGfwOujU=;
        b=c9Y5X31ITFROkCz58BWDmVOTUSXQxwKVO0+YO5gM7Dueho0fqdMOddqGunqR3K1DSz
         koftFlaQy5AWDynEFTUKrj/IhzVPvGkhTp5Nxa+Zlib8R9NmI9XnuBG9iHCHh7KcMQ/B
         R2VvMWJxVq3CuEFElE+lE4DkpmSBO4nOKPEAgpV6PF+cdQ0sJlc2ScNbTbgx8wIlp+Dj
         kZAs1jbuzLo5f/4MpCexanAo64EI9+2+h41TrGEHG8twyTTttEPJrctB/YnAZ2+HkB5k
         uWovA5v2eCiXYkMwI/ZVzbxoqj8LOi8G4gzoBn6tiRDAJ7YqjH0xAUIYJg7tM5JKyukd
         +iUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z6CQ4PR7LXXUvvSI+PnJV2oiFyZAUecU41+cGfwOujU=;
        b=hOzocPfjgXcOirX8VPSzf2o3/3oSTEAlZf+1OhcOdd4mxDCSl0nrYBZAx5h4HmRdWx
         2SxYT02XGz7gLFYQ1kO6tjiHmrllKAIDahAGtTbIfKk/G7CoKRYd3wEgIb5zzWK052E7
         7nkOx2pvUZ6rS6wdbFycUY8/l14wH2flGv8Vl9Ke3kBZf4sMpS6dQkSXzNxeOEjkkXCp
         UX5k71GtPBoCkpJKMN+er3BbQTpDUJd8oHNx2ileSRBDFhy/M1Z1pf/BZ0iwnsINt80N
         Ae62fveWBwxysHSYqabs3g6o1wwkHy8O9b82IYllFUSOWApqsJekvQsPHLQUMs+/tgTg
         WpLg==
X-Gm-Message-State: AOAM533DXHvArTF4y7oge/ELYuAk4R0DIARDAsxypR5CGZ+FnhD4HM/M
        ULfgNyTNxzaXHegOkBAzZrEjPjTyCexYg41x1osfkg==
X-Google-Smtp-Source: ABdhPJzYews2Ih4OsV/9BJPJX66ITSb1cl147pd8KN4Cqs6H0ueYwNCOPq7ksxkbE9zvtTGB9qj/7KwbIsYjwO4rXFQ=
X-Received: by 2002:a2e:7c09:: with SMTP id x9mr1916202ljc.192.1600804651550;
 Tue, 22 Sep 2020 12:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz> <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
 <20200922095136.GA9682@chrisdown.name> <CAKRVAePisoOg8QBz11gPqzEoUdwPiJ-9Z9MyFE2LHzR-r+PseQ@mail.gmail.com>
 <20200922104252.GB9682@chrisdown.name> <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
In-Reply-To: <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 22 Sep 2020 12:57:19 -0700
Message-ID: <CALvZod64Qwzjv3N2PO-EUtMkA4bs_PM=Tq4=cmuM0VO9P3BAjw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
To:     Chunxin Zang <zangchunxin@bytedance.com>
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

On Tue, Sep 22, 2020 at 5:37 AM Chunxin Zang <zangchunxin@bytedance.com> wr=
ote:
>
> On Tue, Sep 22, 2020 at 6:42 PM Chris Down <chris@chrisdown.name> wrote:
> >
> > Chunxin Zang writes:
> > >On Tue, Sep 22, 2020 at 5:51 PM Chris Down <chris@chrisdown.name> wrot=
e:
> > >>
> > >> Chunxin Zang writes:
> > >> >My usecase is that there are two types of services in one server. T=
hey
> > >> >have difference
> > >> >priorities. Type_A has the highest priority, we need to ensure it's
> > >> >schedule latency=E3=80=81I/O
> > >> >latency=E3=80=81memory enough. Type_B has the lowest priority, we e=
xpect it
> > >> >will not affect
> > >> >Type_A when executed.
> > >> >So Type_A could use memory without any limit. Type_B could use memo=
ry
> > >> >only when the
> > >> >memory is absolutely sufficient. But we cannot estimate how much
> > >> >memory Type_B should
> > >> >use. Because everything is dynamic. So we can't set Type_B's memory=
.high.
> > >> >
> > >> >So we want to release the memory of Type_B when global memory is
> > >> >insufficient in order
> > >> >to ensure the quality of service of Type_A . In the past, we used t=
he
> > >> >'force_empty' interface
> > >> >of cgroup v1.
> > >>
> > >> This sounds like a perfect use case for memory.low on Type_A, and it=
's pretty
> > >> much exactly what we invented it for. What's the problem with that?
> > >
> > >But we cannot estimate how much memory Type_A uses at least.
> >
> > memory.low allows ballparking, you don't have to know exactly how much =
it uses.
> > Any amount of protection biases reclaim away from that cgroup.
> >
> > >For example:
> > >total memory: 100G
> > >At the beginning, Type_A was in an idle state, and it only used 10G of=
 memory.
> > >The load is very low. We want to run Type_B to avoid wasting machine r=
esources.
> > >When Type_B runs for a while, it used 80G of memory.
> > >At this time Type_A is busy, it needs more memory.
> >
> > Ok, so set memory.low for Type_A close to your maximum expected value.
>
> Please forgive me for not being able to understand why setting
> memory.low for Type_A can solve the problem.
> In my scene, Type_A is the most important, so I will set 100G to memory.l=
ow.
> But 'memory.low' only takes effect passively when the kernel is
> reclaiming memory. It means that reclaim Type_B's memory only when
> Type_A  in alloc memory slow path. This will affect Type_A's
> performance.
> We want to reclaim Type_B's memory in advance when A is expected to be bu=
sy.
>

How will you know when to reclaim from B? Are you polling /proc/meminfo?

From what I understand, you want to proactively reclaim from B, so
that A does not go into global reclaim and in the worst case kill B,
right?

BTW you can use memory.high to reclaim from B by setting it lower than
memory.current of B and reset it to 'max' once the reclaim is done.
Since 'B' is not high priority (I am assuming not a latency sensitive
workload), B hitting temporary memory.high should not be an issue.
Also I am assuming you don't much care about the amount of memory to
be reclaimed from B, so I think memory.high can fulfil your use-case.
However if in future you decide to proactively reclaim from all the
jobs based on their priority i.e. more aggressive reclaim from B and a
little bit reclaim from A then memory.high is not a good interface.

Shakeel
