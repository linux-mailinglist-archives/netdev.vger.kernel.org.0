Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787FF53D279
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbiFCTsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242689AbiFCTr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:47:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2F936E29
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 12:47:57 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k19so11633764wrd.8
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 12:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hf1EFIN8wN+xApR8nEDafV6Gk+3OhHAa3jEidZPGbZc=;
        b=aJaJKzikO5eDUXLYlMQkk6J6ILhL4sZRwmdyNqH6PYP4ohOC3rv2SReqmGB+rPOMht
         UOTzIp/VT5biwIqC4/FBcLg7lAVXWRiWICMvTdYhef17p6hAvhgAInRBrZtQmSNe9CJH
         ercSOALRJYh6tZ9fKPlywKZ2m+om0hNFSS/+/hncGejPHNHrEGJzr9ECZomqL6Pfxamm
         omnr65p7WOu7Up/+h/xzezS5g4dCBQjCyfIZbaTeUmErBqsIuS2BdhnsxTi962FailTo
         Ijf7seLLuPuA5VJch61OS5Fol22qULKemAVREwRoiQ0L/Oo225JKSi8kRW/U+CjUCa8B
         TiRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hf1EFIN8wN+xApR8nEDafV6Gk+3OhHAa3jEidZPGbZc=;
        b=nFAxUQ+a8yusWYK9HYQLWG1tDrxY7GZ9eEJlIjiYjrGgJtZIVROfeOFhULBVnqHE7v
         UL/48gBKfDnIQAg2p2QLfSOQ7Uc3ESq+B+nVc3HQTVUHmJOGmJIT2IsKfTzykglEB1s5
         k/PMCP3/gbzzib96CRlN1LX/8M4S9PeQGCJMXaYFT2ZRplV0BHsBlM4tWCxraZLh6xtU
         b8DhoFWe60UdV9l/66AzZUiqtMhpNoAitxv3fNQ9618kozb8VS5+5Bx8Z6ky/1kj6Nje
         J/dJIpTIPUqZVvcOzQZVI8vyroGH5g3/Jhc9zvAH49KQVcAqdDCtxW3P7iCZkLS1WvAD
         MQGQ==
X-Gm-Message-State: AOAM530gzfUkxxDQZwEAKcep0rbmAeibFByShGR/mPPv5hEXGXGNnDjW
        E1nwvNG60vu1xtt0CqvLnf3PrNuyuNIjo5yRZfHhBg==
X-Google-Smtp-Source: ABdhPJwCCN88F2N/ZjqR5N+AF9zRTGhHD/9JuM1YLXYlwR3kMDIsYpeY7Kegy65OyUQUwNRW6n4OVzo6J/DAPZY7wL4=
X-Received: by 2002:a05:6000:1541:b0:20f:f91a:2095 with SMTP id
 1-20020a056000154100b0020ff91a2095mr9749227wry.80.1654285675634; Fri, 03 Jun
 2022 12:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com> <20220603162247.GC16134@blackbody.suse.cz>
In-Reply-To: <20220603162247.GC16134@blackbody.suse.cz>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 3 Jun 2022 12:47:19 -0700
Message-ID: <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Jun 3, 2022 at 9:22 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> Hello Yosry et al.
>
> This is an interesting piece of work, I'll add some questions and
> comments.
>
> On Fri, May 20, 2022 at 01:21:28AM +0000, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > This patch series allows for using bpf to collect hierarchical cgroup
> > stats efficiently by integrating with the rstat framework. The rstat
> > framework provides an efficient way to collect cgroup stats and
> > propagate them through the cgroup hierarchy.
>
> About the efficiency. Do you have any numbers or examples?
> IIUC the idea is to utilize the cgroup's rstat subgraph of full tree
> when flushing.
> I was looking at your selftest example and the measuring hooks call
> cgroup_rstat_updated() and they also allocate an entry bpf_map[cg_id].
> The flush callback then looks up the cg_id for cgroups in the rstat
> subgraph.
> (I'm not familiar with bpf_map implementation or performance but I
> imagine, you're potentially one step away from erasing bpf_map[cg_id] in
> the flush callback.)
> It seems to me that you're building a parallel structure (inside
> bpf_map(s)) with similar purpose to the rstat subgraph.
>
> So I wonder whether there remains any benefit of coupling this with
> rstat?

Hi Michal,

Thanks for taking a look at this!

The bpf_map[cg_id] is not a similar structure to the rstat flush
subgraph. This is where the stats are stored. These are long running
numbers for (virtually) all cgroups on the system, they do not get
allocated every time we call cgroup_rstat_updated(), only the first
time. They are actually not erased at all in the whole selftest
(except when the map is deleted at the end). In a production
environment, we might have "setup" and "destroy" bpf programs that run
when cgroups are created/destroyed, and allocate/delete these map
entries then, to avoid the overhead in the first stat update/flush if
necessary.

The only reason I didn't do this in the demo selftest is because it
was complex/long enough as-is, and for the purposes of showcasing and
testing it seemed enough to allocate entries on demand on the first
stat update. I can add a comment about this in the selftest if you
think it's not obvious.

In short, think of these bpf maps as equivalents to "struct
memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
controller. They are just containers to store the stats in, they do
not have any subgraph structure and they have no use beyond storing
percpu and total stats.

I run small microbenchmarks that are not worth posting, they compared
the latency of bpf stats collection vs. in-kernel code that adds stats
to struct memcg_vmstats[_percpu] and flushes them accordingly, the
difference was marginal. If the map lookups are deemed expensive and a
bottleneck in the future, I have some ideas about improving that. We
can rewrite the cgroup storage map to use the generic bpf local
storage code, and have it be accessible from all programs by a cgroup
key (like task_storage for e.g.) rather than only programs attached to
that cgroup. However, this discussion is a tangent here.

>
>
> Also, I'd expect the custom-processed data are useful in the
> structured form (within bpf_maps) but then there's the cgroup iter thing
> that takes available data and "flattens" them into text files.
> I see this was discussed in subthreads already so it's not necessary to
> return to it. IIUC you somehow intend to provide the custom info via the
> text files. If that's true, I'd include that in the next cover message
> (the purpose of the iterator).

The main reason for this is to provide data in a similar fashion to
cgroupfs, in text file per-cgroup. I will include this clearly in the
next cover message. You can always not use the cgroup_iter and access
the data directly from bpf maps.

>
>
> > * The second patch adds cgroup_rstat_updated() and cgorup_rstat_flush()
> > kfuncs, to allow bpf stat collectors and readers to communicate with rs=
tat.
>
> kfunc means that it can be just called from any BPF program?
> (I'm thinking of an unprivileged user who issues cgroup_rstat_updated()
> deep down in the hierarchy repeatedly just to "spam" the rstat subgraph
> (which slows down flushers above). Arguably, this can be done already
> e.g. by causing certain MM events, so I'd like to just clarify if this
> can be a new source of such arbitrary updates.)

AFAIK loading bpf programs requires a privileged user, so someone has
to approve such a program. Am I missing something?

>
> > * The third patch is actually v2 of a previously submitted patch [1]
> > by Hao Luo. We agreed that it fits better as a part of this series. It
> > introduces cgroup_iter programs that can dump stats for cgroups to
> > userspace.
> > v1 - > v2:
> > - Getting the cgroup's reference at the time at attaching, instead of
> >   at the time when iterating. (Yonghong) (context [1])
>
> I noticed you take the reference to cgroup, that's fine.
> But the demo program also accesses via RCU pointers
> (memory_subsys_enabled():cgroup->subsys).
> Again, my BPF ignorance here, does the iterator framework somehow take
> care of RCU locks?

bpf_iter_run_prog() is used to run bpf iterator programs, and it grabs
rcu read lock before doing so. So AFAICT we are good on that front.

Thanks a lot for this great discussion!

>
>
> Thanks,
> Michal
