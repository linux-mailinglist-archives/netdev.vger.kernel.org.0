Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FB032A31E
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381891AbhCBIrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446188AbhCBDE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 22:04:28 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A71AC06178B
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 19:03:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d13-20020a17090abf8db02900c0590648b1so502009pjs.1
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 19:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1bhqnALZ2+KE5BNt1x/b9t2x1AkPvkj58NfI+kSCMY8=;
        b=UYnhJBpLGeXBzTsG1LRoT9PKDmaTMwK9UVmBSKewIAouqErxx2ofVXdE+eXziIbdpd
         sGoirzJpSJXD/iCzCesUzihCGoEtLPB5MgPV1zx3ZlDdMeVTHur4f+XAPZ+P/Xp2I050
         4AGVuC3F0W9MqITV+2Vh0iABS/bLWKy/hxLNu+nn470erji9VMW/mDFTGDbRlB6fuWov
         o6s4PQooVOtr4HNnNIgMxpRUI0p3tTaywvWy4beq4Hkl67xSc/YbhKve+rR984OE/GFL
         5L3Ua6Vx4i/C3mJ4O858u4zkNv5IHuaNTi2e9FuHOaenQwl3BW2OE/EOaLWKb2sT/Pag
         qDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1bhqnALZ2+KE5BNt1x/b9t2x1AkPvkj58NfI+kSCMY8=;
        b=AJ4xhR6BT4L9sp3YAa+sWcVry9ottTtzIL1sxTdhsOPUNJlwcnpqvXUnmt94CMEiO2
         TE9ousr3PY9PE7Kk1Q3JJyoId+GoL2gRPmLI3NbqwFWAU2vDUvq6RR1a6mhJZGyLMlC3
         Jw7X/jWk+I3cjPf+mLUkJiriyvxBEAO7KssgscML7bS0EgInD4fFbvKzzVZfJvmQxH/C
         EOHTLJ03OAhdoFIV3SDDdm2Y3+a/Zz7GZ9fNmXTlfsJprzUAa3wP269WZOC1AH2eqLDd
         BdAO2s0JOrKy5OVJRWHLcnBAOLduUw49iggWbqO9mjTEqjxD2Y1pCOTj550J26Xy0zGY
         jQuw==
X-Gm-Message-State: AOAM531+R8WIgtPixvppyeFtxZdeIPuOpGB7FbjapZ2LwoNlPWP/tGDL
        X5Zc2fVeuQYSkd69JnoobXmSGko+nAveec+bi03fLQ==
X-Google-Smtp-Source: ABdhPJzkDzVaKb6VAcUaPdmIqjsZ96Mht1x5iPUiMpXvga/HiZejji300KaqZif5tK9B32QsU9s1bkNMxlRSC7wGZyk=
X-Received: by 2002:a17:902:9341:b029:e1:7b4e:57a8 with SMTP id
 g1-20020a1709029341b02900e17b4e57a8mr1633790plp.34.1614654221758; Mon, 01 Mar
 2021 19:03:41 -0800 (PST)
MIME-Version: 1.0
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-3-songmuchun@bytedance.com> <CALvZod7sysj0+wrzLTXnwn7s_Gf-V2eFPJ6cLcoRmR0LdAFk0Q@mail.gmail.com>
In-Reply-To: <CALvZod7sysj0+wrzLTXnwn7s_Gf-V2eFPJ6cLcoRmR0LdAFk0Q@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 2 Mar 2021 11:03:05 +0800
Message-ID: <CAMZfGtVhgPzGXrLp12Z=r_FYuyqOoza9tOkPZ0N1=cHR+ataQA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 2/5] mm: memcontrol: make page_memcg{_rcu}
 only applicable for non-kmem page
To:     Shakeel Butt <shakeelb@google.com>
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

On Tue, Mar 2, 2021 at 2:11 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Sun, Feb 28, 2021 at 10:25 PM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > We want to reuse the obj_cgroup APIs to reparent the kmem pages when
> > the memcg offlined. If we do this, we should store an object cgroup
> > pointer to page->memcg_data for the kmem pages.
> >
> > Finally, page->memcg_data can have 3 different meanings.
> >
> >   1) For the slab pages, page->memcg_data points to an object cgroups
> >      vector.
> >
> >   2) For the kmem pages (exclude the slab pages), page->memcg_data
> >      points to an object cgroup.
> >
> >   3) For the user pages (e.g. the LRU pages), page->memcg_data points
> >      to a memory cgroup.
> >
> > Currently we always get the memcg associated with a page via page_memcg
> > or page_memcg_rcu. page_memcg_check is special, it has to be used in
> > cases when it's not known if a page has an associated memory cgroup
> > pointer or an object cgroups vector. Because the page->memcg_data of
> > the kmem page is not pointing to a memory cgroup in the later patch,
> > the page_memcg and page_memcg_rcu cannot be applicable for the kmem
> > pages. In this patch, we introduce page_memcg_kmem to get the memcg
> > associated with the kmem pages. And make page_memcg and page_memcg_rcu
> > no longer apply to the kmem pages.
> >
> > In the end, there are 4 helpers to get the memcg associated with a
> > page. The usage is as follows.
> >
> >   1) Get the memory cgroup associated with a non-kmem page (e.g. the LRU
> >      pages).
> >
> >      - page_memcg()
> >      - page_memcg_rcu()
>
> Can you rename these to page_memcg_lru[_rcu] to make them explicitly
> for LRU pages?

Yes. Will do. Thanks.

>
> >
> >   2) Get the memory cgroup associated with a kmem page (exclude the slab
> >      pages).
> >
> >      - page_memcg_kmem()
> >
> >   3) Get the memory cgroup associated with a page. It has to be used in
> >      cases when it's not known if a page has an associated memory cgroup
> >      pointer or an object cgroups vector. Returns NULL for slab pages or
> >      uncharged pages, otherwise, returns memory cgroup for charged pages
> >      (e.g. kmem pages, LRU pages).
> >
> >      - page_memcg_check()
> >
> > In some place, we use page_memcg to check whether the page is charged.
> > Now we introduce page_memcg_charged helper to do this.
> >
> > This is a preparation for reparenting the kmem pages. To support reparent
> > kmem pages, we just need to adjust page_memcg_kmem and page_memcg_check in
> > the later patch.
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> [snip]
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -855,10 +855,11 @@ void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
> >                              int val)
> >  {
> >         struct page *head = compound_head(page); /* rmap on tail pages */
> > -       struct mem_cgroup *memcg = page_memcg(head);
> > +       struct mem_cgroup *memcg;
> >         pg_data_t *pgdat = page_pgdat(page);
> >         struct lruvec *lruvec;
> >
> > +       memcg = PageMemcgKmem(head) ? page_memcg_kmem(head) : page_memcg(head);
>
> Should page_memcg_check() be used here?

Yeah. page_memcg_check() can be used here.
But on the inside of the page_memcg_check(),
there is a READ_ONCE(). Actually, we do not
need READ_ONCE() here. So I use page_memcg
or page_memcg_kmem directly. Thanks.

>
> >         /* Untracked pages have no memcg, no lruvec. Update only the node */
> >         if (!memcg) {
> >                 __mod_node_page_state(pgdat, idx, val);
> > @@ -3170,12 +3171,13 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
> >   */
> >  void __memcg_kmem_uncharge_page(struct page *page, int order)
> >  {
> > -       struct mem_cgroup *memcg = page_memcg(page);
> > +       struct mem_cgroup *memcg;
> >         unsigned int nr_pages = 1 << order;
> >
> > -       if (!memcg)
> > +       if (!page_memcg_charged(page))
> >                 return;
> >
> > +       memcg = page_memcg_kmem(page);
> >         VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
> >         __memcg_kmem_uncharge(memcg, nr_pages);
> >         page->memcg_data = 0;
> > @@ -6831,24 +6833,25 @@ static void uncharge_batch(const struct uncharge_gather *ug)
> >  static void uncharge_page(struct page *page, struct uncharge_gather *ug)
> >  {
> >         unsigned long nr_pages;
> > +       struct mem_cgroup *memcg;
> >
> >         VM_BUG_ON_PAGE(PageLRU(page), page);
> >
> > -       if (!page_memcg(page))
> > +       if (!page_memcg_charged(page))
> >                 return;
> >
> >         /*
> >          * Nobody should be changing or seriously looking at
> > -        * page_memcg(page) at this point, we have fully
> > -        * exclusive access to the page.
> > +        * page memcg at this point, we have fully exclusive
> > +        * access to the page.
> >          */
> > -
> > -       if (ug->memcg != page_memcg(page)) {
> > +       memcg = PageMemcgKmem(page) ? page_memcg_kmem(page) : page_memcg(page);
>
> Same, should page_memcg_check() be used here?

Same as above.
