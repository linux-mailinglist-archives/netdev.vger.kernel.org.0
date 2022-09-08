Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259F35B12A9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 04:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiIHCsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 22:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIHCsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 22:48:45 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2757FFBF;
        Wed,  7 Sep 2022 19:48:41 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id v6so4864690ljj.0;
        Wed, 07 Sep 2022 19:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=S007uhudJiEUSw5VwxgkV7xB4iqXJLx8bGrjx4fe7Ec=;
        b=Wynxkd/Lh2b+ogTbqK96/Gt6zE8OZeDngoOQzpEIsMlpgLwgwooTbQV5YtjXg+k+43
         UspSoj/yZnUA2/GoXB9T2DiNXkYLbKF4nXr6Ui8BwkpzIXGa9GwJq+SrJNBX7i2yXbdg
         BfpSllT6UIpzwxu9DLlXK9/1LAXbzA0p4z7ahPmrQIzQB2ovJI9+TvXYJE2+FKSvAGjQ
         3GXNk8TxFQMKZ3d93OIEUlyB05I+Uvqq/2ynKBJCQWJkYwwRYWpoewHgCVzlHSaru083
         ACQrWwhViZfE479uxHlF7W8EID7aiLjo/amxw7glHDaVnxPhJivreP+95GHsAcfCSsJW
         Y3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=S007uhudJiEUSw5VwxgkV7xB4iqXJLx8bGrjx4fe7Ec=;
        b=qc2aE6n2HkG9qJrlqmr4fTkaIjFE9MF6pf6p0nGlWL+jmdZ9TS5oOYo9It/pm0T7/G
         8IQli6iAus0D+DC03P9FBIIuFfRxqTjXrMBQx6TzhqbPW4emB9kqeRlu/ek3b1F3KCoX
         LYmOOWs5G0qB/c2p4keEW6DRFXVJAsWxeIN7D0iAzdanMfVaEpDzSgxws/I8utowDrrE
         Ziik5fnV83U6SzfQfwfhALoqt1GpGalhs0+bR7EAkQJ4VoShyEQ5UMnTX2q/MuPVVRZh
         0Dcj/Xo53eKgVtM/YKfmktm1VBJhx8iq+O2WaFR30o1KyxHVKg9Y5NlE/tCYNqZZw/Po
         IfNA==
X-Gm-Message-State: ACgBeo2XqsCMmzhPs2Cd7OI3qokDYTbQibrXzLTnJjacJ79t23Bm8jnl
        vkNH1Lfx/mv7MH3XrwEq89hU82lszH9fv09lsWY=
X-Google-Smtp-Source: AA6agR51DPksjb7gaR1DJ20WyBaKaOQEPNurBKQksz7/9Z2PW16bQ3gm9ag9gGKHTWzQzy+kZcizRIHGLZcNsqiLDVA=
X-Received: by 2002:a2e:91d7:0:b0:26a:c623:ad26 with SMTP id
 u23-20020a2e91d7000000b0026ac623ad26mr1838663ljg.512.1662605320251; Wed, 07
 Sep 2022 19:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car> <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
 <CAADnVQJHtY0m5TnFxnn8w3xBUfAGNzbf1HmS3ChqcLJadEYJFg@mail.gmail.com>
In-Reply-To: <CAADnVQJHtY0m5TnFxnn8w3xBUfAGNzbf1HmS3ChqcLJadEYJFg@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 8 Sep 2022 10:48:03 +0800
Message-ID: <CALOAHbAwvPFp6F8BXjzTeNnL7rT+LfA6_yoCY5sLO9VVkjXONA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, Sep 8, 2022 at 10:43 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 7, 2022 at 7:37 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
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
> >
> > [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> >
> > > Beatiful? Not. Neither is the proposed solution.
> > >
> >
> > Is it really hard to admit a fault?
>
> Yafang,
>
> This attitude won't get you anywhere.
>

Thanks for pointing it out. It is my fault.

> Selecting memcg by fd is no go.
> You need to work with the community to figure out a solution
> acceptable to maintainers of relevant subsystems.

Yes, I'm trying.

-- 
Regards
Yafang
