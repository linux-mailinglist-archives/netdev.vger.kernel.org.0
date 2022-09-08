Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37B95B129B
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiIHCnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiIHCnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:43:47 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA855F9F;
        Wed,  7 Sep 2022 19:43:46 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id fy31so34844471ejc.6;
        Wed, 07 Sep 2022 19:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1Kp8lVSbVqh0xdCaSGzBnGS0KimrRJEGXexqvO+A61k=;
        b=VU3x/RATySGCqkn35FuoVNPIlVepIfpPqgHywrVV6qyGcNNaafm8aZ8BLY70OtBm8O
         7B2qayTgwJ3sgII+LEWkS6NTw3tVAR1E6MLM0fQeIcQhqPItOa+d/+7V+dCP/Mdq8RgN
         02dVJ/2tCG0NmAFC75e/nIAYNd+tVV8TAOTDpnLEmsm8EVE8OQebqMYLwlUBhIyix0vj
         awJTD1sijvEhwy/eBYewmdFWk4Rhlo/e0CMllu3BEgKQFjY/A6XNhpG6SyJmXW9tgMt7
         GXQZAQdAwX/2KlD+gHx4uBCwhxHE0Zp1cW4rE+kqQkCLH54uuYRLqZbMrlkVhwbnKKPF
         AINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1Kp8lVSbVqh0xdCaSGzBnGS0KimrRJEGXexqvO+A61k=;
        b=LzGw39JyjJWzI5Qk/FKcgK8nfoAAe9N1aDBJNy+BLfiBzyZGCOg5oqgL+SPEgF6UIf
         IrilAnBnqx5w1KxUMjgZ4Fn/tnt4qgO1qiDNWwPa9tGnSOWm/sLs7eEBayDmrvSp/qvz
         DV4cFwtF5ik5JseZO7mdchJeYCHIfENv8b2u9i407JMF2hqo/ey88SsSHvvHzry2kEZa
         +nEt2bT1b6reEthkraTv0CAcVuW1ZifLG0bf3GCtUI5nqM8XpQgCLYBJUoVqhK7dottP
         /jdlsP14sPDyD/nU5ALVdaS/RI0wHJjmv7IjCeNPvs0mIuS6gdrpxZClp2xozyn1GG7p
         O0Sg==
X-Gm-Message-State: ACgBeo3ydJDXsuYbwB+bcVAGRuNrxSEZne1wErEpXuMpaXF0UG27AJ4i
        wHQO+QEG+cvvxYM7hIC0fUl+F4XhpK68uRUlt6s=
X-Google-Smtp-Source: AA6agR728kGj9mp65ybKd5ugwGh1WxmY+DSTIg1OQyFpIInFinhIgvFQ72NHe18Wr5xU5wWoSb94EcYU8qJp+G1h7Y0=
X-Received: by 2002:a17:906:ef90:b0:730:9cd8:56d7 with SMTP id
 ze16-20020a170906ef9000b007309cd856d7mr4214987ejb.94.1662605024595; Wed, 07
 Sep 2022 19:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car> <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
In-Reply-To: <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Sep 2022 19:43:33 -0700
Message-ID: <CAADnVQJHtY0m5TnFxnn8w3xBUfAGNzbf1HmS3ChqcLJadEYJFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Sep 7, 2022 at 7:37 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > > Hello,
> > >
> > > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > > ...
> > > > This patchset tries to resolve the above two issues by introducing a
> > > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > > Possible use cases of the selectable memcg as follows,
> > >
> > > As discussed in the following thread, there are clear downsides to an
> > > interface which requires the users to specify the cgroups directly.
> > >
> > >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> > >
> > > So, I don't really think this is an interface we wanna go for. I was hoping
> > > to hear more from memcg folks in the above thread. Maybe ping them in that
> > > thread and continue there?
> >
>
> Hi Roman,
>
> > As I said previously, I don't like it, because it's an attempt to solve a non
> > bpf-specific problem in a bpf-specific way.
> >
>
> Why do you still insist that bpf_map->memcg is not a bpf-specific
> issue after so many discussions?
> Do you charge the bpf-map's memory the same way as you charge the page
> caches or slabs ?
> No, you don't. You charge it in a bpf-specific way.
>
> > Yes, memory cgroups are not great for accounting of shared resources, it's well
> > known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> > in a particular cgroup setup. Honestly, I don't think it's worth the added
> > complexity. Especially because a similar behaviour can be achieved simple
> > by placing the task which creates the map into the desired cgroup.
>
> Are you serious ?
> Have you ever read the cgroup doc? Which clearly describe the "No
> Internal Process Constraint".[1]
> Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.
>
> [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
>
> > Beatiful? Not. Neither is the proposed solution.
> >
>
> Is it really hard to admit a fault?

Yafang,

This attitude won't get you anywhere.

Selecting memcg by fd is no go.
You need to work with the community to figure out a solution
acceptable to maintainers of relevant subsystems.
