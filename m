Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8435B67AE
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 08:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiIMGQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 02:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiIMGQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 02:16:00 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C845459B0;
        Mon, 12 Sep 2022 23:15:59 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id u18so18417728lfo.8;
        Mon, 12 Sep 2022 23:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=iL+PSuTvBsgGgVuYBzw23P7DA3wgNTk8Y2M7Kc+r7u8=;
        b=UXg7Y3VmdYKh0yVQeWq3KV0amIKGmR9oIbm2MDgvqcrlBMbu3Gz0DwJ2d7oTuamu/6
         MNqFRm+GD3j1yKbm3LDTkdJ4gee9fnjmeQVk7onS2afn0pU1gUPmFp0Ort3ThmUpqA0P
         BCRjT363Klq15cX5XXoZwn7aC1EW4FZso6vCdIvC6WRpB6PZNTsmNFVUdoVwmhGOrCoN
         Fd5buTIBvFqWtyxkxWCx+SQ9CXELd4rl/uPSaEFApnVvkLyVB3sAcMwPC0sOajU+oldm
         D3lKi3nkb3r+0KVHyovGr1Q1S7rQkiFWuDJHhpqPSVfxddUM2JVIAt+djtL61R2yldi+
         ypcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=iL+PSuTvBsgGgVuYBzw23P7DA3wgNTk8Y2M7Kc+r7u8=;
        b=AAq6AeZB1lqZclOI911iPHhqBYzLVT8XcnUPohUEvEFvlwrB0Yhk4ia8OcyDsKNfVN
         V6tK2J+vaSouw06nbZ+tUuEqjMo7+SSXVN872jIoWmjy1Bll5QbKImZx/flsGz80Qcxu
         uzD6o+SAUyVwu71LpicVntmPFLJmLp0FpY1iEmkDpVuh7ae/bhpWSzP2Mh1/ImEEgPE/
         Gi4rc74/28sLfjeC9YQW48bQ3swS97x8u1YobOfNjc+RxDTiCQZqgXTpEQ18CgELpG/c
         KmVJPQZR0R7T1/60fGaubUAY+IyJEboeIQMf5icSrft0KWBiEOvxKRpbQPMh0R4VLgGD
         m9wQ==
X-Gm-Message-State: ACgBeo0fbkVYXW8/6D1bloCJqgkt8gMkjLzCYGtCUqobQ4rR6sqKh7KW
        ieH99kZfIgt9YhzUAkLZrvro2yo+/4+rVFXvPs0W0ltl9Zg=
X-Google-Smtp-Source: AA6agR5VmWxfy56PXWZAcwLrkMGS5wp/Ejn6/hngmWDh5knnHYWEpK2RjT7MF2S80VGErukdVML8SxZeKNR+2oc2bAU=
X-Received: by 2002:a05:6512:308d:b0:499:bd1a:d1bc with SMTP id
 z13-20020a056512308d00b00499bd1ad1bcmr4830380lfd.274.1663049757320; Mon, 12
 Sep 2022 23:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car> <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
 <YxoUkz05yA0ccGWe@P9FQF9L96D.corp.robot.car>
In-Reply-To: <YxoUkz05yA0ccGWe@P9FQF9L96D.corp.robot.car>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 13 Sep 2022 14:15:20 +0800
Message-ID: <CALOAHbAzi0s3N_5BOkLsnGfwWCDpUksvvhPejjj5jo4G2v3mGg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 12:13 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Thu, Sep 08, 2022 at 10:37:02AM +0800, Yafang Shao wrote:
> > On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > >
> > > On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > > > Hello,
> > > >
> > > > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > > > ...
> > > > > This patchset tries to resolve the above two issues by introducing a
> > > > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > > > Possible use cases of the selectable memcg as follows,
> > > >
> > > > As discussed in the following thread, there are clear downsides to an
> > > > interface which requires the users to specify the cgroups directly.
> > > >
> > > >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> > > >
> > > > So, I don't really think this is an interface we wanna go for. I was hoping
> > > > to hear more from memcg folks in the above thread. Maybe ping them in that
> > > > thread and continue there?
> > >
> >
> > Hi Roman,
> >
> > > As I said previously, I don't like it, because it's an attempt to solve a non
> > > bpf-specific problem in a bpf-specific way.
> > >
> >
> > Why do you still insist that bpf_map->memcg is not a bpf-specific
> > issue after so many discussions?
> > Do you charge the bpf-map's memory the same way as you charge the page
> > caches or slabs ?
> > No, you don't. You charge it in a bpf-specific way.
>

Hi Roman,

Sorry for the late response.
I've been on vacation in the past few days.

> The only difference is that we charge the cgroup of the processes who
> created a map, not a process who is doing a specific allocation.

This means the bpf-map can be indepent of process, IOW, the memcg of
bpf-map can be indepent of the memcg of the processes.
This is the fundamental difference between bpf-map and page caches, then...

> Your patchset doesn't change this.

We can make this behavior reasonable by introducing an independent
memcg, as what I did in the previous version.

> There are pros and cons with this approach, we've discussed it back
> to the times when bpf memcg accounting was developed. If you want
> to revisit this, it's maybe possible (given there is a really strong and likely
> new motivation appears), but I haven't seen any complaints yet except from you.
>

memcg-base bpf accounting is a new feature, which may not be used widely.

> >
> > > Yes, memory cgroups are not great for accounting of shared resources, it's well
> > > known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> > > in a particular cgroup setup. Honestly, I don't think it's worth the added
> > > complexity. Especially because a similar behaviour can be achieved simple
> > > by placing the task which creates the map into the desired cgroup.
> >
> > Are you serious ?
> > Have you ever read the cgroup doc? Which clearly describe the "No
> > Internal Process Constraint".[1]
> > Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.
>
> But you can place it into another leaf cgroup. You can delete this leaf cgroup
> and your memcg will get reparented. You can attach this process and create
> a bpf map to the parent cgroup before it gets child cgroups.

If the process doesn't exit after it created bpf-map, we have to
migrate it around memcgs....
The complexity in deployment can introduce unexpected issues easily.

> You can revisit the idea of shared bpf maps and outlive specific cgroups.
> Lof of options.
>
> >
> > [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> >
> > > Beatiful? Not. Neither is the proposed solution.
> > >
> >
> > Is it really hard to admit a fault?
>
> Yafang, you posted several versions and so far I haven't seen much of support
> or excitement from anyone (please, fix me if I'm wrong). It's not like I'm
> nacking a patchset with many acks, reviews and supporters.
>
> Still think you're solving an important problem in a reasonable way?
> It seems like not many are convinced yet. I'd recommend to focus on this instead
> of blaming me.
>

The best way so far is to introduce specific memcg for specific resources.
Because not only the process owns its memcg, but also specific
resources own their memcgs, for example bpf-map, or socket.

struct bpf_map {                                 <<<< memcg owner
    struct memcg_cgroup *memcg;
};

struct sock {                                       <<<< memcg owner
    struct mem_cgroup *sk_memcg;
};

These resources already have their own memcgs, so we should make this
behavior formal.

The selectable memcg is just a variant of 'echo ${proc} > cgroup.procs'.

-- 
Regards
Yafang
