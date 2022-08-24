Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E215A01B9
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbiHXTCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239834AbiHXTCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:02:18 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBCD18E05
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:02:16 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id i8so2629092ilk.8
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vBlDS68ELiZr1QTGxJOPvYivh7LG+VsuyP+e5BkDizs=;
        b=KFgXrxcerQ3S3zXFOe9MmxseJphuExDFjgTrOTgMM5c828OwMG24lYumRxP31doY51
         K3cCe4S/6ni0oRgdRPgOkwDxqUe2EkEF41lt78W5XERFXOPcHB1Vmy1+NVexHW7RsEtj
         5wmzydLf5j6aH97yWc7b5GXH1MRAmKZyQeJ4rkkIdnI2o9NkcuTf4MH8xLurDgiB1Ld9
         KaA5GWUyP1EakYttIWAzdT0zbylCN4iGgdmjhx2I79snHw8drJY9PzikTZV8arxTMbsZ
         dAouvU+bhh2FPmxFp0+8M6bTInr4nLWqSqrIqdudgOI4HErlyyW4Fm8K+iyW2UfrIA80
         M1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vBlDS68ELiZr1QTGxJOPvYivh7LG+VsuyP+e5BkDizs=;
        b=bGI1pPR0dGsqVQcKszWzzGUJuX2s/Sk2hpDXP42bOKP7VvKcSx6HJ1jEbkBHCCVl+2
         vRx0qySiVzJii8nsuZVMy9gg3w0n4zHhy8GRtdCT6g/Ihs73ibOU6c6lAZbqQlulqAB3
         kng1cHXKFWWU43prpugtBTj13owSuvHY2bDuVGTEHYGQq05xrTf1GgcxieBttd9Vwo6L
         mM9CX/cYjGtxa5XsPOEO6MoqorYdUuDo8MOh+JDmk22dcVTWQqFoyQFgNEcdm3t53EZE
         8HhngOaZuqK12rO0R35zNBj+hFv6UBdXmzH/levBASw/aJgwU4ML1b+9I86Q9ebKMziT
         BUnA==
X-Gm-Message-State: ACgBeo1/Sl3zud4x/olXtyly1ywT+oIUTqxkZNX9C04eG0cA2cPIMN8S
        /cZhrRBf/vMgqTHd/FU3MmP/msmjXDF2yjDFxMrjsg==
X-Google-Smtp-Source: AA6agR6kheze9pyJF4whRD8WXKbfetrZ6izDyQszCHM6aVpmA/tkPpShcjsBYFMe0z/XRNEgnfahZPqeHb1fLLgo3tc=
X-Received: by 2002:a05:6e02:2194:b0:2e9:7f9b:f1c4 with SMTP id
 j20-20020a056e02219400b002e97f9bf1c4mr207575ila.79.1661367735898; Wed, 24 Aug
 2022 12:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org> <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org> <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org> <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
 <YwPy9hervVxfuuYE@cmpxchg.org> <YwRDFe+K837tKGED@P9FQF9L96D> <YwRF+df9P2TPu7Zw@slm.duckdns.org>
In-Reply-To: <YwRF+df9P2TPu7Zw@slm.duckdns.org>
From:   Mina Almasry <almasrymina@google.com>
Date:   Wed, 24 Aug 2022 12:02:04 -0700
Message-ID: <CAHS8izMFMtM5ry12iEo72nwkynDpgycETn6QoXLGj=O6b8z1jg@mail.gmail.com>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
To:     Tejun Heo <tj@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yosry Ahmed <yosryahmed@google.com>,
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

On Mon, Aug 22, 2022 at 8:14 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Mon, Aug 22, 2022 at 08:01:41PM -0700, Roman Gushchin wrote:
> > > > >    One solution that I can think of is leveraging the resource domain
> > > > >    concept which is currently only used for threaded cgroups. All memory
> > > > >    usages of threaded cgroups are charged to their resource domain cgroup
> > > > >    which hosts the processes for those threads. The persistent usages have a
> > > > >    similar pattern, so maybe the service level cgroup can declare that it's
> > > > >    the encompassing resource domain and the instance cgroup can say whether
> > > > >    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
> > > > >    resource domain.
> > > > >
> > > >
> > > > I think this sounds excellent and addresses our use cases. Basically
> > > > the tmpfs/bpf memory would get charged to the encompassing resource
> > > > domain cgroup rather than the instance cgroup, making the memory usage
> > > > of the first and second+ instances consistent and predictable.
> > > >
> > > > Would love to hear from other memcg folks what they would think of
> > > > such an approach. I would also love to hear what kind of interface you
> > > > have in mind. Perhaps a cgroup tunable that says whether it's going to
> > > > charge the tmpfs/bpf instance to itself or to the encompassing
> > > > resource domain?
> > >
> > > I like this too. It makes shared charging predictable, with a coherent
> > > resource hierarchy (congruent OOM, CPU, IO domains), and without the
> > > need for cgroup paths in tmpfs mounts or similar.
> > >
> > > As far as who is declaring what goes, though: if the instance groups
> > > can declare arbitrary files/objects persistent or shared, they'd be
> > > able to abuse this and sneak private memory past local limits and
> > > burden the wider persistent/shared domain with it.
>
> My thought was that the persistent cgroup and instance cgroups should belong
> to the same trust domain and system level control should be applied at the
> resource domain level. The application may decide to shift between
> persistent and per-instance however it wants to and may even configure
> resource control at that level but all that's for its own accounting
> accuracy and benefit.
>
> > > I'm thinking it might make more sense for the service level to declare
> > > which objects are persistent and shared across instances.
> >
> > I like this idea.
> >
> > > If that's the case, we may not need a two-component interface. Just
> > > the ability for an intermediate cgroup to say: "This object's future
> > > memory is to be charged to me, not the instantiating cgroup."
> > >
> > > Can we require a process in the intermediate cgroup to set up the file
> > > or object, and use madvise/fadvise to say "charge me", before any
> > > instances are launched?
> >
> > We need to think how to make this interface convenient to use.
> > First, these persistent resources are likely created by some agent software,
> > not the main workload. So the requirement to call madvise() from the
> > actual cgroup might be not easily achievable.
>
> So one worry that I have for this is that it requires the application itself
> to be aware of cgroup topolgies and restructure itself so that allocation of
> those resources are factored out into something else. Maybe that's not a
> huge problem but it may limit its applicability quite a bit.
>

I agree with this point 100%. The interfaces being discussed here
require existing applications restructuring themselves which I don't
imagine will be very useful for us at least.

> If we can express all the resource contraints and structures in the cgroup
> side and configured by the management agent, the application can simply e.g.
> madvise whatever memory region or flag bpf maps as "these are persistent"
> and the rest can be handled by the system. If the agent set up the
> environment for that, it gets accounted accordingly; otherwise, it'd behave
> as if those tagging didn't exist. Asking the application to set up all its
> resources in separate steps, that might require significant restructuring
> and knowledge of how the hierarchy is setup in many cases.
>

I don't know if this level of granularity is needed with a madvise()
or such. The kernel knows whether resources are persistent due to the
nature of the resource. For example a shared tmpfs file is a resource
that is persistent and not cleaned up after the process using it dies,
but private memory is. madvise(PERSISTENT) on private memory would not
make sense, and I don't think madvise(NOT_PERSISTENT) on tmpfs-backed
memory region would make sense. Also, this requires adding madvise()
hints in userspace code to leverage this.

> > So _maybe_ something like writing a fd into cgroup.memory.resources.
> >

Sorry, I don't see this being useful - to us at least - if it is an
fd-based interface. It needs to support marking entire tmpfs mounts as
persistent. The reasoning is as Tejun alludes to: our container
management agent generally sets up the container hierarchy for a job
and also sets up the filesystem mounts the job requests. This is
generally because the job doesn't run as root and doesn't bother with
mount namespaces. Thus, our jobs are well-trained in receiving mounts
set up for them from our container management agent. Jobs are _not_
well-trained in receiving an fd from the container management agent,
and restructuring our jobs/services for such an interface will not be
feasible I think.

This applies to us but I imagine it is common practice for the
container management agent to set up mounts for the jobs to use,
rather than provide the job with an fd or collection of fds.

> > Second, it would be really useful to export the current configuration
> > to userspace. E.g. a user should be able to query to which cgroup the given
> > bpf map "belongs" and which bpf maps belong to the given cgroups. Otherwise
> > it will create a problem for userspace programs which manage cgroups
> > (e.g. systemd): they should be able to restore the current configuration
> > from the kernel state, without "remembering" what has been configured
> > before.
>
> This too can be achieved by separating out cgroup setup and tagging specific
> resources. Agent and cgroup know what each cgroup is supposed to do as they
> already do now and each resource is tagged whether they're persistent or
> not, so everything is always known without the agent and the application
> having to explicitly share the information.
>
> Thanks.
>
> --
> tejun
