Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6184032A31F
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381908AbhCBIrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhCBDhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 22:37:36 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8B1C0617A7
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 19:36:06 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id u18so8531346ljd.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 19:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bz8uBe6K2P4L9vYFmzU92KcgY6OwUuT5aKcfnajTyTg=;
        b=nkB9r6nlkun78l+tTKiB4tMDKf8CVmwjMOSIPEbEjNd/Nsk2XEBNYxNAojcBzAYLbk
         AZ3qK4rVhYuFxAla4ozwFJtYD6Z/O9p4yeXZSEk0nk7YbhHS5lPs/vuhEz3978eNX5AX
         LtqI+33Hy9KMfhUx1wQVkD0jWXw0lzhf4B0Kvyv2KVTZpep4bje6Zrz3lpx8w7lS2Ba/
         Ug6WUvlub1YxrFZctmw4sFRV3100p1Tskm/QI44+PhyTHAD2zkAS8opGBhLwCozw2gYJ
         CpEePgQiSg0GZQN703Eua+bpSAfSr8N72ruBvYM+xHPikZHkpvGIEMslReFyG3+gg62d
         EW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bz8uBe6K2P4L9vYFmzU92KcgY6OwUuT5aKcfnajTyTg=;
        b=If/KU8X8AAHmhU3qp3x+jftLWjlgtFI9HFwBmEiEL0C4mp+i6smSnLKT3s2WyAeI2d
         M9EEv4+u4lFCD7RdUD44uhxzXT60SJGg5T1eC1mWJT8QpVgle/fgwawsCcTqGdlY9maO
         zlSPOWQtp3zwauOF72+glvdG3wLwOVZno+6/Jz48HUb62pDAfa05N8+GPJQPNTFUaU0X
         zAlo4oCS/KgSek3kw7WCkUVwSz9xRv4eQvjlEXEpEwV0utVm+nnaaHq12YcKKYekoyAx
         Tlou6i3M2wIl+T3F4tJvjNY9SOijlvEmpSCoE25OxUTR94S8NLyaWs44suykYWhIVglP
         kjYQ==
X-Gm-Message-State: AOAM531tEllx1AwCZkC+D3HW2ZvkzQuI0kJk6mLjDegtHH2IAVLigiGe
        ROdn4dmTrGNhrHjAbelJKCop0L/qjf/osiTeNbBUNQ==
X-Google-Smtp-Source: ABdhPJzJtFE+1oSFYwIpEGPFNzE9zYTgKDQwzxAeND6Yrtul3/tDAbpsz02NMRsNm2sVGPuN4J8NCXA5gSql+ypr8no=
X-Received: by 2002:a2e:9cc4:: with SMTP id g4mr2003504ljj.34.1614656164850;
 Mon, 01 Mar 2021 19:36:04 -0800 (PST)
MIME-Version: 1.0
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-3-songmuchun@bytedance.com> <CALvZod7sysj0+wrzLTXnwn7s_Gf-V2eFPJ6cLcoRmR0LdAFk0Q@mail.gmail.com>
 <CAMZfGtVhgPzGXrLp12Z=r_FYuyqOoza9tOkPZ0N1=cHR+ataQA@mail.gmail.com>
In-Reply-To: <CAMZfGtVhgPzGXrLp12Z=r_FYuyqOoza9tOkPZ0N1=cHR+ataQA@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 1 Mar 2021 19:35:53 -0800
Message-ID: <CALvZod6TmaG7QnxeM65sCzVJBTGfb34q50=0no391Ciww4ZzCQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 2/5] mm: memcontrol: make page_memcg{_rcu}
 only applicable for non-kmem page
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, bristot@redhat.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Chris Down <chris@chrisdown.name>,
        Wei Yang <richard.weiyang@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Oskolkov <posk@google.com>, Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Waiman Long <longman@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, krisman@collabora.com,
        esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>,
        Marco Elver <elver@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Xiongchun duan <duanxiongchun@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 7:03 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Tue, Mar 2, 2021 at 2:11 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Sun, Feb 28, 2021 at 10:25 PM Muchun Song <songmuchun@bytedance.com> wrote:
> > >
> > > We want to reuse the obj_cgroup APIs to reparent the kmem pages when
> > > the memcg offlined. If we do this, we should store an object cgroup
> > > pointer to page->memcg_data for the kmem pages.
> > >
> > > Finally, page->memcg_data can have 3 different meanings.
> > >
> > >   1) For the slab pages, page->memcg_data points to an object cgroups
> > >      vector.
> > >
> > >   2) For the kmem pages (exclude the slab pages), page->memcg_data
> > >      points to an object cgroup.
> > >
> > >   3) For the user pages (e.g. the LRU pages), page->memcg_data points
> > >      to a memory cgroup.
> > >
> > > Currently we always get the memcg associated with a page via page_memcg
> > > or page_memcg_rcu. page_memcg_check is special, it has to be used in
> > > cases when it's not known if a page has an associated memory cgroup
> > > pointer or an object cgroups vector. Because the page->memcg_data of
> > > the kmem page is not pointing to a memory cgroup in the later patch,
> > > the page_memcg and page_memcg_rcu cannot be applicable for the kmem
> > > pages. In this patch, we introduce page_memcg_kmem to get the memcg
> > > associated with the kmem pages. And make page_memcg and page_memcg_rcu
> > > no longer apply to the kmem pages.
> > >
> > > In the end, there are 4 helpers to get the memcg associated with a
> > > page. The usage is as follows.
> > >
> > >   1) Get the memory cgroup associated with a non-kmem page (e.g. the LRU
> > >      pages).
> > >
> > >      - page_memcg()
> > >      - page_memcg_rcu()
> >
> > Can you rename these to page_memcg_lru[_rcu] to make them explicitly
> > for LRU pages?
>
> Yes. Will do. Thanks.
>

Please follow Johannes' suggestion regarding page_memcg_kmem() and
then no need to rename these.
