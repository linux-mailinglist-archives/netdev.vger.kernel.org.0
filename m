Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBFE52F4F0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352912AbiETVTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 17:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241750AbiETVTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:19:23 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A3219C77A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:19:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e28so12448424wra.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjiL3NxvzYrXKj45aHBa+PDLeI3SrPcf1o9kYao+3oU=;
        b=f1SZJ5wLl9KsySVn8cTyhGlWJMoGbRfZWdXIbT19HvldLNIfxvW+e8t2QACM0vOjjl
         TTkCnR8Uv4N+prXqmTruAvJV4jPFv1yFQG5Mcwc/JNk/2wd7QMX3xCRWlmOHUKqiOa8m
         7rN49OeStoRttGDgdidlQT1/mlxLY42xKmmDXWeXODcWslDYXMO/z0UyC6ANAVntoFnN
         dNYejFKQpABvj/LLi6y+ekG47MHIQYksaSFuqWQxHCnopiPAMI0U+V5dHZGF9MC72GLu
         k9uItHw/yoSOK+kR4G3a/Qmt5aepyIBViRMr2gyaWIABqizZ0tr7XgaAqAuOnTlWVB55
         E0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjiL3NxvzYrXKj45aHBa+PDLeI3SrPcf1o9kYao+3oU=;
        b=cnx/STOgI6klGH559ia4LRtN0pJin0U0GnAk4Jo3YoxvSOCfbsPEoZ4QMSa5UF46A3
         Uq9XIPRubC4itKyA3gtrDo6m2Bip1jLWVnn/GtElcdFpmfkkEHA+CsA6ANifFiLYfnDX
         HMea67B6gNE4pTcByPlrxQO9g9hKBgQznDqEsUqtNNSMJoRCw97H3XmworrQgRWbxs1S
         izgvd0GX1TTAdMJOqnZt04WPDAw4gp8H7+8z8kjI5m2X6k+59B9tcUiVZofgYjXPh114
         oF08+LMaMrtHuC5U+1sCERKpQRgt+cDUAe1aFxfHq18KnxaGiWKR+Uw6gPua2GFFDlLv
         BktA==
X-Gm-Message-State: AOAM533FqXogkp0ZaSxPiUMKE0OtYhGLHTRYSOLHn/pvHVlykF45ScRw
        EKJm/QmklJpv2dWggZY6GMawwDtYOIqPKmU8VC2CIw==
X-Google-Smtp-Source: ABdhPJxqSoOtBnq+VE7TR7nxBu5p/47iKtCzXj6VNgKmecJ8rniStzCBDa3ZKu7nYV6YfZMbRec8O2mWvNPLdaBfTb0=
X-Received: by 2002:adf:fb05:0:b0:20a:e113:8f3f with SMTP id
 c5-20020adffb05000000b0020ae1138f3fmr10019749wrr.534.1653081559944; Fri, 20
 May 2022 14:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
In-Reply-To: <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 20 May 2022 14:18:42 -0700
Message-ID: <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
To:     Hao Luo <haoluo@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Yonghong Song <yhs@fb.com>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 12:43 PM Hao Luo <haoluo@google.com> wrote:
>
> Hi Tejun and Yonghong,
>
> On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj@kernel.org> wrote:
> > On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
> > > Maybe you can have a bpf program signature like below:
> > >
> > > int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp,
> > > struct cgroup *parent_cgrp)
> > >
> > > parent_cgrp is NULL when cgrp is the root cgroup.
> > >
> > > I would like the bpf program should send the following information to
> > > user space:
> > >    <parent cgroup dir name> <current cgroup dir name>
> >
> > I don't think parent cgroup dir name would be sufficient to reconstruct the
> > path given that multiple cgroups in different subtrees can have the same
> > name. For live cgroups, userspace can find the path from id (or ino) without
> > traversing anything by constructing the fhandle, open it open_by_handle_at()
> > and then reading /proc/self/fd/$FD symlink -
> > https://lkml.org/lkml/2020/12/2/1126. This isn't available for dead cgroups
> > but I'm not sure how much that'd matter given that they aren't visible from
> > userspace anyway.
> >
>
> Sending cgroup id is better than cgroup dir name, also because IIUC
> the path obtained from cgroup id depends on the namespace of the
> userspace process. So if the dump file may be potentially read by
> processes within a container, it's better to have the output
> namespaced IMO.
>
> > >    <various stats interested by the user>
> > >
> > > This way, user space can easily construct the cgroup hierarchy stat like
> > >                            cpu   mem   cpu pressure   mem pressure ...
> > >    cgroup1                 ...
> > >       child1               ...
> > >         grandchild1        ...
> > >       child2               ...
> > >    cgroup 2                ...
> > >       child 3              ...
> > >         ...                ...
> > >
> > > the bpf iterator can have additional parameter like
> > > cgroup_id = ... to only call bpf program once with that
> > > cgroup_id if specified.
>
> Yep, this should work. We just need to make the cgroup_id parameter
> optional. If it is specified when creating bpf_iter_link, we print for
> that cgroup only. If it is not specified, we iterate over all cgroups.
> If I understand correctly, sounds doable.
>
> > > The kernel part of cgroup_iter can call cgroup_rstat_flush()
> > > before calling cgroup_iter bpf program.
>
> Sounds good to me as well. But my knowledge on rstat_flush is limited.
> Yosry can give this a try.
>
> >
> > Would it work to just pass in @cgrp and provide a group of helpers so that
> > the program can do whatever it wanna do including looking up the full path
> > and passing that to userspace?
> >
>
> My understanding is, yes, doable. If we need the full path information
> of a cgroup, helpers or kfuncs are needed.
>
> The userspace needs to specify the identity of the cgroup, when
> creating bpf_iter. This identity could be cgroup id or fd. This
> identity needs to be converted to cgroup object somewhere before
> passing into bpf program to use.


Let's sum up the discussion here, I feel like we are losing track of
the main problem. IIUC the main concern is that cgroup_iter is not
effectively an iterator, it rather dumps information for one cgroup. I
like the suggestion to make it iterate cgroups by default, and an
optional cgroup_id parameter to make it only "iterate" this one
cgroup. IIUC, this cgroup_id parameter would be a link parameter,
similar to the current approach. Basically, we extend the current
patch so that if cgroup_id is not specified the iterator gets called
for all cgroups instead of one. This fixes the problem for our use
case and also keeps cgroup_iter generic enough. Is my understanding
correct? If yes, I don't see a need to flush rstat in the kernel on
behalf of cgroup_iter progs.
