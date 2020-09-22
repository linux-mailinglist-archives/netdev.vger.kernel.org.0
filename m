Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6706274227
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 14:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIVMhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 08:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgIVMhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 08:37:45 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB81C0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 05:37:44 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c2so13965502ljj.12
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 05:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gA220xpuIaxUuyuMwr6nlukSuBX7MpFrxgJa3f1luDw=;
        b=GReCqit5HTO/ziRjftty0K8XZi2ySCuJzKJveaG0MdXTTpgULihVLwMvfADeawU2QZ
         IbAydMl3Tn/9XZF79/7c4WOv1D9hB06rNVFZ/DiHhbarrKyedLyRCcCrKNAAgAgynsvl
         PuiO+M0DWum3yqYFnTFuppHoZ6RUqQ5x1aZtz6a6hAJDQtyZm8Nk5IuIu/m6lV5zU0Qa
         YPhNCDslcn72ErQ130linofe9GJPNOAEaCIrlopykwgfmAJg0zLWoF20Oug79KD1o/ie
         h0iyMZUYd3e33ZiaWMrDN63XT+TuA6+CR0zCHGKr/FQJkVpg0EeSRf5Qih1CxKrTnkq8
         Ut5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gA220xpuIaxUuyuMwr6nlukSuBX7MpFrxgJa3f1luDw=;
        b=OVAQUkzU3JQ8QdADBBgryOl31yCjpU1v84V5nix0DB1p2eDKZTVQ8twQtnr/K+Eji5
         QIak/qUTjbPxlgcANZpXXPAJbay0jObQbVKaxVyRPB/ryG6jzRq2BZADRemrTTfZ5Wa6
         +mnHtguXAvIJLZeRLOKwyKFZtfMIb34UU4lUZsnrT1HuNsKudGLvgkRZj4M0qkHa/rir
         P+eUUb3RKgbNf+m8V07LlkfOEiBSqwnvlZaetH6StBTArU6jQ+57cMnmK8HupubGRByN
         IROScHu5c7onHPIZ0kYh5sly+qrNWOK8BJawQZBU/MeQoqQPjL1vTQ8rStZV4aF/q26H
         C6MA==
X-Gm-Message-State: AOAM5310fXh+GPRHL1OJiQ7swSSQY/qvm0dZDZNmxcwo4qnSKImii/1z
        AAN1ADUgznj2jMkbHrzbmMzKT/gG6t8hf8lQfUlHxg==
X-Google-Smtp-Source: ABdhPJy2uCCGncfmVCuod/IiCiTTfxrKsDOlJTrFdVxVRrWlq7JKLI4j/OgY4j/S5nJzpdTEsCyW0xWnIGQadAicUpY=
X-Received: by 2002:a2e:9089:: with SMTP id l9mr1605962ljg.408.1600778262989;
 Tue, 22 Sep 2020 05:37:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz> <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
 <20200922095136.GA9682@chrisdown.name> <CAKRVAePisoOg8QBz11gPqzEoUdwPiJ-9Z9MyFE2LHzR-r+PseQ@mail.gmail.com>
 <20200922104252.GB9682@chrisdown.name>
In-Reply-To: <20200922104252.GB9682@chrisdown.name>
From:   Chunxin Zang <zangchunxin@bytedance.com>
Date:   Tue, 22 Sep 2020 20:37:32 +0800
Message-ID: <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
To:     Chris Down <chris@chrisdown.name>
Cc:     Michal Hocko <mhocko@suse.com>, Yafang Shao <laoar.shao@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 6:42 PM Chris Down <chris@chrisdown.name> wrote:
>
> Chunxin Zang writes:
> >On Tue, Sep 22, 2020 at 5:51 PM Chris Down <chris@chrisdown.name> wrote:
> >>
> >> Chunxin Zang writes:
> >> >My usecase is that there are two types of services in one server. The=
y
> >> >have difference
> >> >priorities. Type_A has the highest priority, we need to ensure it's
> >> >schedule latency=E3=80=81I/O
> >> >latency=E3=80=81memory enough. Type_B has the lowest priority, we exp=
ect it
> >> >will not affect
> >> >Type_A when executed.
> >> >So Type_A could use memory without any limit. Type_B could use memory
> >> >only when the
> >> >memory is absolutely sufficient. But we cannot estimate how much
> >> >memory Type_B should
> >> >use. Because everything is dynamic. So we can't set Type_B's memory.h=
igh.
> >> >
> >> >So we want to release the memory of Type_B when global memory is
> >> >insufficient in order
> >> >to ensure the quality of service of Type_A . In the past, we used the
> >> >'force_empty' interface
> >> >of cgroup v1.
> >>
> >> This sounds like a perfect use case for memory.low on Type_A, and it's=
 pretty
> >> much exactly what we invented it for. What's the problem with that?
> >
> >But we cannot estimate how much memory Type_A uses at least.
>
> memory.low allows ballparking, you don't have to know exactly how much it=
 uses.
> Any amount of protection biases reclaim away from that cgroup.
>
> >For example:
> >total memory: 100G
> >At the beginning, Type_A was in an idle state, and it only used 10G of m=
emory.
> >The load is very low. We want to run Type_B to avoid wasting machine res=
ources.
> >When Type_B runs for a while, it used 80G of memory.
> >At this time Type_A is busy, it needs more memory.
>
> Ok, so set memory.low for Type_A close to your maximum expected value.

Please forgive me for not being able to understand why setting
memory.low for Type_A can solve the problem.
In my scene, Type_A is the most important, so I will set 100G to memory.low=
.
But 'memory.low' only takes effect passively when the kernel is
reclaiming memory. It means that reclaim Type_B's memory only when
Type_A  in alloc memory slow path. This will affect Type_A's
performance.
We want to reclaim Type_B's memory in advance when A is expected to be busy=
.

Best wishes
Chunxin
