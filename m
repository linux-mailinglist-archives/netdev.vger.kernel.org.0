Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A76052F3DE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353273AbiETTnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiETTnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:08 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4356919669A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:43:07 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id m1so8124736qkn.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0lG+wkpvvM5BrA6qMbE7wBMotbPnzZWg8Zgz+BedKu0=;
        b=MxqMb1bfrueYp5btVTDjnT2tZ4EudnH7IxjI0/g/SP5vEIe/U2NL9ob1BaPa8WrAAR
         gHX32C1grdPWfQAeZ3t3XutIipxcrCttxt0pbHMynNAuNxoaHJpIUkpJOWdoL+jti5/w
         j2Sz1Ry4bwwp1I09ZXwTrH30sJNUvlsXzNlOJJSHSXHiJ+4F5FE6Bz19mWJUzsgA0AzW
         wag0FmlobomPxKN5cV2/IVZDBNTgvni6AX5t0CfhwObdRYjhIsOOQj+NeZy9qA8qqayf
         jVACJxUx6T2C5Dy7ncHo4iQwQCSGKzdywRmM2t8gw67xFH5l+VlMZ0sqGJELpxpWIyd5
         +t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0lG+wkpvvM5BrA6qMbE7wBMotbPnzZWg8Zgz+BedKu0=;
        b=ay2Ro3MBSSAXCzZPlEZS0kOYQsWJ6k7Y4lrx+4W+sG5uci+cfMSbevLRZKJKGMAhzT
         4fFxof22MmAOL2HPGmaIlTsBBnwYdQefpCadjtQGUIS0cdPQNPhdsl56wtIg0m30sr7T
         I+jpuzUG+/Z9EvqWTen27e+RUbaVtfOPtzbWpx+FMWoI+3HAZQeTXH+bqCGb560fSzk4
         1vwFGNAHpflA7jrVSRX4kkCbhLbmNz0vZllxockiQM7HFhuJz92OmlGWWUUoKMJt2xVJ
         yHUSk18cvSRlIUn8+uFVV/TiObj4uUJhBr83rIYaOf8fj08q6c3pHFKJgtuDdpQnxfW1
         SXTA==
X-Gm-Message-State: AOAM533BXozlrP0ne6KqxUIjNvBLPu8qX2wstKUybDL95bhyZIf9PA4g
        ruaHs2Lfuz5D3S0U7TRA06eTezG7CuXLNi4eV6oZsQ==
X-Google-Smtp-Source: ABdhPJy45IVYn2CCOgFZEJeVpA2FsRx/8rcOslYRPeHOzDEpsvweZJKBB24pgmw3sXjwVs+zdC+Xgi95SaYZkV089GA=
X-Received: by 2002:a05:620a:2849:b0:687:651:54ee with SMTP id
 h9-20020a05620a284900b00687065154eemr7426627qkp.446.1653075786167; Fri, 20
 May 2022 12:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
In-Reply-To: <YofFli6UCX4J5YnU@slm.duckdns.org>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 20 May 2022 12:42:54 -0700
Message-ID: <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
To:     Tejun Heo <tj@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>, Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tejun and Yonghong,

On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj@kernel.org> wrote:
> On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
> > Maybe you can have a bpf program signature like below:
> >
> > int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp,
> > struct cgroup *parent_cgrp)
> >
> > parent_cgrp is NULL when cgrp is the root cgroup.
> >
> > I would like the bpf program should send the following information to
> > user space:
> >    <parent cgroup dir name> <current cgroup dir name>
>
> I don't think parent cgroup dir name would be sufficient to reconstruct the
> path given that multiple cgroups in different subtrees can have the same
> name. For live cgroups, userspace can find the path from id (or ino) without
> traversing anything by constructing the fhandle, open it open_by_handle_at()
> and then reading /proc/self/fd/$FD symlink -
> https://lkml.org/lkml/2020/12/2/1126. This isn't available for dead cgroups
> but I'm not sure how much that'd matter given that they aren't visible from
> userspace anyway.
>

Sending cgroup id is better than cgroup dir name, also because IIUC
the path obtained from cgroup id depends on the namespace of the
userspace process. So if the dump file may be potentially read by
processes within a container, it's better to have the output
namespaced IMO.

> >    <various stats interested by the user>
> >
> > This way, user space can easily construct the cgroup hierarchy stat like
> >                            cpu   mem   cpu pressure   mem pressure ...
> >    cgroup1                 ...
> >       child1               ...
> >         grandchild1        ...
> >       child2               ...
> >    cgroup 2                ...
> >       child 3              ...
> >         ...                ...
> >
> > the bpf iterator can have additional parameter like
> > cgroup_id = ... to only call bpf program once with that
> > cgroup_id if specified.

Yep, this should work. We just need to make the cgroup_id parameter
optional. If it is specified when creating bpf_iter_link, we print for
that cgroup only. If it is not specified, we iterate over all cgroups.
If I understand correctly, sounds doable.

> > The kernel part of cgroup_iter can call cgroup_rstat_flush()
> > before calling cgroup_iter bpf program.

Sounds good to me as well. But my knowledge on rstat_flush is limited.
Yosry can give this a try.

>
> Would it work to just pass in @cgrp and provide a group of helpers so that
> the program can do whatever it wanna do including looking up the full path
> and passing that to userspace?
>

My understanding is, yes, doable. If we need the full path information
of a cgroup, helpers or kfuncs are needed.

The userspace needs to specify the identity of the cgroup, when
creating bpf_iter. This identity could be cgroup id or fd. This
identity needs to be converted to cgroup object somewhere before
passing into bpf program to use.
