Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4863259CB22
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiHVVxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 17:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiHVVxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 17:53:03 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541FC52FD5
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 14:53:01 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id i5so4886777uat.6
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 14:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=2XNHoc9outJ6+FrRa+lvTbUCgpYDkDMEQnlx6lAVru4=;
        b=DoxhsSzF4mkTjC/l5iKWrNX1D3FuMiXOo5jZExAuxkdIzhGio0bIYfEJEocLCor3Xw
         dxzfOZYWeZ7PYceVCfCi5TaaZ43gQQUZ2xQqLIHKRl442YLxaNVd31DaYDp7/OQT21RW
         IU9cUwfSViaxVMf79gY7HJHDLOnQsGFF/Ggf6uKrOHbKzALbxokg39jTp5Avl4lY7rOb
         4rdtqNDeIzeBeM452bP2s5Bx0+Ak7hIX2pvDe+x01CVNNp2sb9wnTOVX/QvWPW3X4O10
         rMuspP1afMN/Sp8mXaPAmdoPAyMgx77p5hQfV7sU2RUip9cqwS6yCx6fF6VgXJAUO8Q5
         6nsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2XNHoc9outJ6+FrRa+lvTbUCgpYDkDMEQnlx6lAVru4=;
        b=S6A44zwYqKjgKlf3dDpZQvB4TlpOb7PGG9uiOHxxQIfWIDfhCnCb//rxO2TGcGjaS7
         R0FKfV7TyHJ5P51qSKC0POJFECEnZfg4frqL6BEnzUSMTVAMawQgYyqnxvZoGKeT+jim
         rK1OGQisKG+nn2K1oKR1cuQfE9ozfp+DNykjqDoJytevnxF846trFtqCyJqEE6fZbBYC
         00FEdMail8vxSycd8ijcnvXVq5P8ZDCj/nV0ldmzGJfrO4hwt4I3DfNYpE7ISDUrjHD+
         MqyrYF9s8PYIOJiiuNU/OwsY6Wu2Cu+t06AeIs5Pz5RZVkGhj4zkBAtmPW0tTDCNDb9U
         JMxg==
X-Gm-Message-State: ACgBeo2Qup7TVh1hiKILzks71o/xG2hhiKurB92oj+SRcN8mnZa+iqvr
        W/AfxuFa6AGWHyJEcksZ9d/p9Has30KbZmRyO/IE2g==
X-Google-Smtp-Source: AA6agR5qk2qbmqQpmyckbmBB/PpgF54yQcjMVlJIyWGkpldhgtRZPCmVOEm/t4a60iGO5IWUmBjGbCoLM+nu215XFUA=
X-Received: by 2002:a9f:3641:0:b0:384:78e4:3b9d with SMTP id
 s1-20020a9f3641000000b0038478e43b9dmr8129139uad.90.1661205180349; Mon, 22 Aug
 2022 14:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org> <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org> <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org> <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
 <YwPy9hervVxfuuYE@cmpxchg.org>
In-Reply-To: <YwPy9hervVxfuuYE@cmpxchg.org>
From:   Mina Almasry <almasrymina@google.com>
Date:   Mon, 22 Aug 2022 14:52:48 -0700
Message-ID: <CAHS8izON5xo6GNmNAo_0121Hb=ikF7wjoh+44wU3M9Q2KOFdBg@mail.gmail.com>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 2:19 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Aug 22, 2022 at 12:02:48PM -0700, Mina Almasry wrote:
> > On Mon, Aug 22, 2022 at 4:29 AM Tejun Heo <tj@kernel.org> wrote:
> > > b. Let userspace specify which cgroup to charge for some of constructs like
> > >    tmpfs and bpf maps. The key problems with this approach are
> > >
> > >    1. How to grant/deny what can be charged where. We must ensure that a
> > >       descendant can't move charges up or across the tree without the
> > >       ancestors allowing it.
> > >
> > >    2. How to specify the cgroup to charge. While specifying the target
> > >       cgroup directly might seem like an obvious solution, it has a couple
> > >       rather serious problems. First, if the descendant is inside a cgroup
> > >       namespace, it might be able to see the target cgroup at all. Second,
> > >       it's an interface which is likely to cause misunderstandings on how it
> > >       can be used. It's too broad an interface.
> > >
> >
> > This is pretty much the solution I sent out for review about a year
> > ago and yes, it suffers from the issues you've brought up:
> > https://lore.kernel.org/linux-mm/20211120045011.3074840-1-almasrymina@google.com/
> >
> >
> > >    One solution that I can think of is leveraging the resource domain
> > >    concept which is currently only used for threaded cgroups. All memory
> > >    usages of threaded cgroups are charged to their resource domain cgroup
> > >    which hosts the processes for those threads. The persistent usages have a
> > >    similar pattern, so maybe the service level cgroup can declare that it's
> > >    the encompassing resource domain and the instance cgroup can say whether
> > >    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
> > >    resource domain.
> > >
> >
> > I think this sounds excellent and addresses our use cases. Basically
> > the tmpfs/bpf memory would get charged to the encompassing resource
> > domain cgroup rather than the instance cgroup, making the memory usage
> > of the first and second+ instances consistent and predictable.
> >
> > Would love to hear from other memcg folks what they would think of
> > such an approach. I would also love to hear what kind of interface you
> > have in mind. Perhaps a cgroup tunable that says whether it's going to
> > charge the tmpfs/bpf instance to itself or to the encompassing
> > resource domain?
>
> I like this too. It makes shared charging predictable, with a coherent
> resource hierarchy (congruent OOM, CPU, IO domains), and without the
> need for cgroup paths in tmpfs mounts or similar.
>
> As far as who is declaring what goes, though: if the instance groups
> can declare arbitrary files/objects persistent or shared, they'd be
> able to abuse this and sneak private memory past local limits and
> burden the wider persistent/shared domain with it.
>
> I'm thinking it might make more sense for the service level to declare
> which objects are persistent and shared across instances.
>
> If that's the case, we may not need a two-component interface. Just
> the ability for an intermediate cgroup to say: "This object's future
> memory is to be charged to me, not the instantiating cgroup."
>
> Can we require a process in the intermediate cgroup to set up the file
> or object, and use madvise/fadvise to say "charge me", before any
> instances are launched?

I think doing this on a file granularity makes it logistically hard to
use, no? The service needs to create a file in the shared domain and
all its instances need to re-use this exact same file.

Our kubernetes use case from [1] shares a mount between subtasks
rather than specific files. This allows subtasks to create files at
will in the mount with the memory charged to the shared domain. I
imagine this is more convenient than a shared file.

Our other use case, which I hope to address here as well, is a
service-client relationship from [1] where the service would like to
charge per-client memory back to the client itself. In this case the
service or client can create a mount from the shared domain and pass
it to the service at which point the service is free to create/remove
files in this mount as it sees fit.

Would you be open to a per-mount interface rather than a per-file
fadvise interface?

Yosry, would a proposal like so be extensible to address the bpf
charging issues?

[1] https://lore.kernel.org/linux-mm/20211120045011.3074840-1-almasrymina@google.com/
