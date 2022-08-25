Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E695A053D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiHYAmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiHYAmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:42:31 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907EB8C031
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:42:30 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f14so14070296qkm.0
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Wpl+c4YfOpabx/QJ3AnuJKzBxyiE9VbZKz/xHkTKLAk=;
        b=r7iSTSO5N8EX5GHy2qXheBkYDaCDsoumn505Dy+CVk71CvcADRVPavVRi4XQL41YpW
         nddUiAQlihuhdYgf94AKk17bP/Lg4DS8ALSrWHJaU/mW2rCqXqPEHTnGcF9m9TMHdXX8
         4ZdDcMEP7/0zTw+yec8Oo4ycG2RGwygPL66RjvWJ0nF+8FlQ21yYvGdhT+k5HKUjHdOp
         eRaB7I5AEZq2x2O2rCKYAM4aqUXZ31HsS+FwTsQVkUZOt6S+cZ9sCZRUVTRdDhExxG4l
         dP0IqFDo49hZ+tPyCYzcAt68UlxzNa6nqGWFhN7Qo8lNrdqTfwr8XombersmaWN+ksBW
         GsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Wpl+c4YfOpabx/QJ3AnuJKzBxyiE9VbZKz/xHkTKLAk=;
        b=ZmPRaPbjOZ40swTmaDPTPSVQU4IoRVrnQRqIU7M9PEkXwsWCUp/bx0nrTVs6AR6YMe
         mk6oDVDKn/3t78YtAPituIb+bwziayxcwQGsLxS6FsY2YYCJy1ixOn53u983BHTgP9mx
         OfQWr/8h1AF+V6YZORfQ30mtcW1+U9pUsECX8OWApyxNv5iGvk4Chzx8ImaHO7Ble1WC
         OvT9UeMWElDvVUdq3Cm66HBUGpIBvLsnmyP0R8VJjo3hY8atk/tMAQS5Zch94XQlf8AF
         Ko/IDuRc81Gr5sAhNP7g+RnXurTvcj46v+MXslWvqWfozWQ7r8A6JnAFx29gDX7y/by8
         Q7CA==
X-Gm-Message-State: ACgBeo3ylBQNQpGV+3uibLWqhv55BrUEAbeg8+Cr2ivpMG3UikOZR5w0
        nU4rnQYIz2Jv6GI2yRGqErEjPwiayw6Pm7t8syEBYg==
X-Google-Smtp-Source: AA6agR7knBbdeFoqDGkHsplIJWoJqzu7ZyrCa96vf+uBJ7VxVkfiTHoOoqQNmmSlaEL57z3V58dRrlcwl4ze9iPXBtQ=
X-Received: by 2002:a37:e118:0:b0:6ba:e5ce:123b with SMTP id
 c24-20020a37e118000000b006bae5ce123bmr1382909qkm.221.1661388149595; Wed, 24
 Aug 2022 17:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220824233117.1312810-1-haoluo@google.com> <CAADnVQLT3JE8LtOYrs30mL88PNs+NaSeXgQqAPEAup5LUC+BPQ@mail.gmail.com>
In-Reply-To: <CAADnVQLT3JE8LtOYrs30mL88PNs+NaSeXgQqAPEAup5LUC+BPQ@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Wed, 24 Aug 2022 17:42:18 -0700
Message-ID: <CA+khW7gQi+BK7Qy4Khk=Ro72nfNQaR2kNkwZemB9ELnDo4Nk3Q@mail.gmail.com>
Subject: Re: [RESEND PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
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

On Wed, Aug 24, 2022 at 5:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> >
> > This patch series allows for using bpf to collect hierarchical cgroup
> > stats efficiently by integrating with the rstat framework. The rstat
> > framework provides an efficient way to collect cgroup stats percpu and
> > propagate them through the cgroup hierarchy.
> >
> > The stats are exposed to userspace in textual form by reading files in
> > bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> > cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> > - walking a cgroup's descendants in pre-order.
> > - walking a cgroup's descendants in post-order.
> > - walking a cgroup's ancestors.
> > - process only a single object.
> >
> > When attaching cgroup_iter, one needs to set a cgroup to the iter_link
> > created from attaching. This cgroup can be passed either as a file
> > descriptor or a cgroup id. That cgroup serves as the starting point of
> > the walk.
> >
> > One can also terminate the walk early by returning 1 from the iter
> > program.
> >
> > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > program is called with cgroup_mutex held.
> >
> > ** Background on rstat for stats collection **
> > (I am using a subscriber analogy that is not commonly used)
> >
> > The rstat framework maintains a tree of cgroups that have updates and
> > which cpus have updates. A subscriber to the rstat framework maintains
> > their own stats. The framework is used to tell the subscriber when
> > and what to flush, for the most efficient stats propagation. The
> > workflow is as follows:
> >
> > - When a subscriber updates a cgroup on a cpu, it informs the rstat
> >   framework by calling cgroup_rstat_updated(cgrp, cpu).
> >
> > - When a subscriber wants to read some stats for a cgroup, it asks
> >   the rstat framework to initiate a stats flush (propagation) by calling
> >   cgroup_rstat_flush(cgrp).
> >
> > - When the rstat framework initiates a flush, it makes callbacks to
> >   subscribers to aggregate stats on cpus that have updates, and
> >   propagate updates to their parent.
> >
> > Currently, the main subscribers to the rstat framework are cgroup
> > subsystems (e.g. memory, block). This patch series allow bpf programs to
> > become subscribers as well.
> >
> > Patches in this series are organized as follows:
> > * Patches 1-2 introduce cgroup_iter prog, and a selftest.
> > * Patches 3-5 allow bpf programs to integrate with rstat by adding the
> >   necessary hook points and kfunc. A comprehensive selftest that
> >   demonstrates the entire workflow for using bpf and rstat to
> >   efficiently collect and output cgroup stats is added.
> >
> > ---
> > Changelog:
> > v8 -> v9:
> > - Make UNSPEC (an invalid option) as the default order for cgroup_iter.
> > - Use enum for specifying cgroup_iter order, instead of u32.
> > - Add BPF_ITER_RESHCED to cgroup_iter.
> > - Add cgroup_hierarchical_stats to s390x denylist.
>
> What 'RESEND' is for?
> It seems to confuse patchwork and BPF CI.
>
> The v9 series made it to patchwork...
>
> Please just bump the version to v10 next time.
> Don't add things to subject, since automation cannot recognize
> that yet.

Sorry about that. I thought it was RESEND because no content has
changed. It was just adding an entry in s390 denylist.

Are we good now? Or I need to send a v10?
