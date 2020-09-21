Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA412721CA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 13:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIULFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 07:05:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:48524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgIULFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 07:05:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600686306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JbHgBz0aomN5pIFfxuOnm8ox/XRaHVRuL/a8R/t+W4A=;
        b=eL+FH/xVmyP8IdigcZ5a4u7kHJf6RwmLhlfQwsnfcss6tnGPYKb5I4tNsxdX5ShApxJwD4
        PoNov/l7i+HWrjj4fhL8wEUmOToZ/ce5LA7BF7H9V+YAwudUts6p0uOo6Hor6UobHAXM0I
        BZqmvLSBzfoozCfUeXbV/WJmM/GA+7M=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 71CDBAC23;
        Mon, 21 Sep 2020 11:05:42 +0000 (UTC)
Date:   Mon, 21 Sep 2020 13:05:05 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
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
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
Message-ID: <20200921110505.GH12990@dhcp22.suse.cz>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz>
 <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 21-09-20 18:55:40, Yafang Shao wrote:
> On Mon, Sep 21, 2020 at 4:12 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> > > From: Chunxin Zang <zangchunxin@bytedance.com>
> > >
> > > In the cgroup v1, we have 'force_mepty' interface. This is very
> > > useful for userspace to actively release memory. But the cgroup
> > > v2 does not.
> > >
> > > This patch reuse cgroup v1's function, but have a new name for
> > > the interface. Because I think 'drop_cache' may be is easier to
> > > understand :)
> >
> > This should really explain a usecase. Global drop_caches is a terrible
> > interface and it has caused many problems in the past. People have
> > learned to use it as a remedy to any problem they might see and cause
> > other problems without realizing that. This is the reason why we even
> > log each attempt to drop caches.
> >
> > I would rather not repeat the same mistake on the memcg level unless
> > there is a very strong reason for it.
> >
> 
> I think we'd better add these comments above the function
> mem_cgroup_force_empty() to explain why we don't want to expose this
> interface in cgroup2, otherwise people will continue to send this
> proposal without any strong reason.

I do not mind people sending this proposal.  "V1 used to have an
interface, we need it in v2 as well" is not really viable without
providing more reasoning on the specific usecase.

_Any_ patch should have a proper justification. This is nothing really
new to the process and I am wondering why this is coming as a surprise.

-- 
Michal Hocko
SUSE Labs
