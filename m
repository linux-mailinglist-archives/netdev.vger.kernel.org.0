Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BA65A054F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiHYArZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiHYArY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:47:24 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA73901BD;
        Wed, 24 Aug 2022 17:47:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u6so19079950eda.12;
        Wed, 24 Aug 2022 17:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cOzunZ0TQ8nKnXZ1VZcYRtC7f0Acf5DwXZKWgmygcKM=;
        b=IwLVmH1ZEwY1PbAdAuS3ODlFbYRP8xZWp2vaQKRxUpfDSL8s3HhcPl9GrSNfiu+umj
         Xporqe5bZLMqOyzMN8sG4RQKa2K+VNub8dkgldHWZnsyJLSp5qRROlQPhFF6r/S+a0FE
         2exsty+Z2+pgV8qxK7qRfLa/Hq82lEHRRW0KFZXLVYg47HwxkHKVQyo2Ngi8FSdAxlh3
         kYgstVx9fFllOlGX3lEwhATGt1tX5ZlTknlKXPMJvqhsP53kUYJV4gYNZ3kH1NUQJ2cs
         vJo8YzcuPbH05jD7fdCrXMn+Jzk9zabSwpvhqdAnR5zbIkVMY4sS1wQo4r7s7/EWB33E
         jtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cOzunZ0TQ8nKnXZ1VZcYRtC7f0Acf5DwXZKWgmygcKM=;
        b=UmRza7eaNJbRtyZ2nxg+uZ2is5sFlirp3WoN+IkF88StxJzseR6023faSK2NWKf1Bl
         FawglvqlK/w/Uoos/66TLFg6vJ1p4Vj0F3AuejlDJZ3HFlB01vi/Ogh7ZQpCKtqbZvGT
         fxBeXFtVwTD8B7id0zCTKHDdavw0FFFDkmAbh3A8G4khXA3nlAIQtpzBg8iBAhjtqymt
         YT8AIAUyM+MIBf/jXRj7GngUGF2l9Phh+K8bmUg/3znQy86mUFE93pazMOUBbxQhmzgb
         4Lr8Z74PCdI/l7//zEJmNDbwoahIxHdABEHp6aZMYbH6exvBGWFlIiTjZW+SmKuIkO1n
         TBMA==
X-Gm-Message-State: ACgBeo0nkW/M6AvL6Cdbh8w0eePeZAlSAvL448yRtpfLyT0NR5CxbE6N
        N0LntEX3lY0wzv9+uqA+MmJfV/jmra6Y50EI4sR2Rm2o
X-Google-Smtp-Source: AA6agR5ItTF1WItPwFSB2QytsD3naWmRfax47efXGMpcf6OzT3HVGqyeAGMdS+068L4PCnpaTwBJda1A6D3zBG7fN3w=
X-Received: by 2002:a05:6402:378f:b0:43a:d3f5:79f2 with SMTP id
 et15-20020a056402378f00b0043ad3f579f2mr1201190edb.338.1661388441774; Wed, 24
 Aug 2022 17:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220824233117.1312810-1-haoluo@google.com> <CAADnVQLT3JE8LtOYrs30mL88PNs+NaSeXgQqAPEAup5LUC+BPQ@mail.gmail.com>
 <CA+khW7gQi+BK7Qy4Khk=Ro72nfNQaR2kNkwZemB9ELnDo4Nk3Q@mail.gmail.com>
In-Reply-To: <CA+khW7gQi+BK7Qy4Khk=Ro72nfNQaR2kNkwZemB9ELnDo4Nk3Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Aug 2022 17:47:10 -0700
Message-ID: <CAADnVQKJDoE3Krn4TEwubJ0Us-QA5cE4oyZ3G2g2MiRMDn3=Cw@mail.gmail.com>
Subject: Re: [RESEND PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical
To:     Hao Luo <haoluo@google.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 5:42 PM Hao Luo <haoluo@google.com> wrote:
>
> On Wed, Aug 24, 2022 at 5:29 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > This patch series allows for using bpf to collect hierarchical cgroup
> > > stats efficiently by integrating with the rstat framework. The rstat
> > > framework provides an efficient way to collect cgroup stats percpu and
> > > propagate them through the cgroup hierarchy.
> > >
> > > The stats are exposed to userspace in textual form by reading files in
> > > bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> > > cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> > > - walking a cgroup's descendants in pre-order.
> > > - walking a cgroup's descendants in post-order.
> > > - walking a cgroup's ancestors.
> > > - process only a single object.
> > >
> > > When attaching cgroup_iter, one needs to set a cgroup to the iter_link
> > > created from attaching. This cgroup can be passed either as a file
> > > descriptor or a cgroup id. That cgroup serves as the starting point of
> > > the walk.
> > >
> > > One can also terminate the walk early by returning 1 from the iter
> > > program.
> > >
> > > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > > program is called with cgroup_mutex held.
> > >
> > > ** Background on rstat for stats collection **
> > > (I am using a subscriber analogy that is not commonly used)
> > >
> > > The rstat framework maintains a tree of cgroups that have updates and
> > > which cpus have updates. A subscriber to the rstat framework maintains
> > > their own stats. The framework is used to tell the subscriber when
> > > and what to flush, for the most efficient stats propagation. The
> > > workflow is as follows:
> > >
> > > - When a subscriber updates a cgroup on a cpu, it informs the rstat
> > >   framework by calling cgroup_rstat_updated(cgrp, cpu).
> > >
> > > - When a subscriber wants to read some stats for a cgroup, it asks
> > >   the rstat framework to initiate a stats flush (propagation) by calling
> > >   cgroup_rstat_flush(cgrp).
> > >
> > > - When the rstat framework initiates a flush, it makes callbacks to
> > >   subscribers to aggregate stats on cpus that have updates, and
> > >   propagate updates to their parent.
> > >
> > > Currently, the main subscribers to the rstat framework are cgroup
> > > subsystems (e.g. memory, block). This patch series allow bpf programs to
> > > become subscribers as well.
> > >
> > > Patches in this series are organized as follows:
> > > * Patches 1-2 introduce cgroup_iter prog, and a selftest.
> > > * Patches 3-5 allow bpf programs to integrate with rstat by adding the
> > >   necessary hook points and kfunc. A comprehensive selftest that
> > >   demonstrates the entire workflow for using bpf and rstat to
> > >   efficiently collect and output cgroup stats is added.
> > >
> > > ---
> > > Changelog:
> > > v8 -> v9:
> > > - Make UNSPEC (an invalid option) as the default order for cgroup_iter.
> > > - Use enum for specifying cgroup_iter order, instead of u32.
> > > - Add BPF_ITER_RESHCED to cgroup_iter.
> > > - Add cgroup_hierarchical_stats to s390x denylist.
> >
> > What 'RESEND' is for?
> > It seems to confuse patchwork and BPF CI.
> >
> > The v9 series made it to patchwork...
> >
> > Please just bump the version to v10 next time.
> > Don't add things to subject, since automation cannot recognize
> > that yet.
>
> Sorry about that. I thought it was RESEND because no content has
> changed. It was just adding an entry in s390 denylist.
>
> Are we good now? Or I need to send a v10?

No need. Assuming that 'RESEND' version will be green in CI.
