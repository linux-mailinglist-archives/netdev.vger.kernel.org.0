Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314915A046A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiHXXJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiHXXJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:09:47 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4BB384;
        Wed, 24 Aug 2022 16:09:45 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i77so14634987ioa.7;
        Wed, 24 Aug 2022 16:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nfN7vzYKRi5gWBFh5PZpxf6X692fiK9RP6Kfj2aiZUM=;
        b=gXsf98N6BDtt9J46LjhrosbxASaamCjFBbeZyek2SqtophUFTicppVzRdUF6pTo/yi
         0zLbdWXLinOQKmmgDcWfs+3jXCYgvfoj2Xf2Pyn/N2pfJEIFmnWLl04SBRnONOa3KMgJ
         bxfUpvDwhqz7/GKn/kpOXyICb7Orc2aFIoiXpb8YF5tkCudyIGoII9n8BmtGMaGnooV5
         lb8WMQzNiKyjoCnEHEu5TnZYQsTOeqMO8/KAl8+EI6fUIkbWQ3L40cL+ezGYo/KuccUW
         Ya0i30kpcMMwJNL9lUzwJTUl4BZVHkEMkwRsBoe16ebXmYt3s/7wW5WzcbpI45yMdLkG
         J1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nfN7vzYKRi5gWBFh5PZpxf6X692fiK9RP6Kfj2aiZUM=;
        b=I37pCCF4reaO40rXigfpde/vy9J0BpJZEA3PjEPCY+N2N842K0rRvqyrJXTseFaC8v
         9ljLilEkJk1ZDpuuFH7FlWSwT5YvOZOhu8CVFmEJ6cqbwTD0zOPC/Wy5s3nJe7O7Oti2
         /nmz9x6A0XNUMqKLFwbYvIUa7LXMHsEpXWfK+a1ucg2Zldh9GqAZ8UKNRHxKlmBfjzE6
         VCAeQe7CANEB+HH/ZZ5zmhqGIK/iOvvKjoDEs1PXqc5kCphV7qrrcA9S9nk1ICHGUubt
         wKCyAHv8AAVusjJtzsegCsYD49QjE+Owc5GAO4knLf/BKzyy6avS93IR3PEvoG9u0uXZ
         8HQQ==
X-Gm-Message-State: ACgBeo3xKCGB8o0pH4FkjxBaXBVmZJmL1b4gawaVVCBmjHvXDa9Qa2pW
        GHgZ0siNYWIAZO99qwubOXf+hrnCs84RxzvlAQQ=
X-Google-Smtp-Source: AA6agR7/EQ2bOEXOIt+jZVy1v1+iH2ECeJoATcDe46DhXzsnPf0ULjy2Q5zdkar8BcZt1tz9mTx/Jm5N7ihAQJbIDm0=
X-Received: by 2002:a6b:2ac4:0:b0:688:3a14:2002 with SMTP id
 q187-20020a6b2ac4000000b006883a142002mr518008ioq.62.1661382584765; Wed, 24
 Aug 2022 16:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220824030031.1013441-1-haoluo@google.com> <20220824030031.1013441-6-haoluo@google.com>
 <CA+khW7go3_KNjju=auaX0A0Ff4-DcmGr9=+TW1tpuqxFv8uwag@mail.gmail.com>
In-Reply-To: <CA+khW7go3_KNjju=auaX0A0Ff4-DcmGr9=+TW1tpuqxFv8uwag@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 25 Aug 2022 01:09:08 +0200
Message-ID: <CAP01T77oxbfQnHSX5irq0d=srArq=ZTf_VAMuw0QNhfcjJVdKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 5/5] selftests/bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
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

On Thu, 25 Aug 2022 at 01:07, Hao Luo <haoluo@google.com> wrote:
>
> On Tue, Aug 23, 2022 at 8:01 PM Hao Luo <haoluo@google.com> wrote:
> >
> > From: Yosry Ahmed <yosryahmed@google.com>
> >
> > Add a selftest that tests the whole workflow for collecting,
> > aggregating (flushing), and displaying cgroup hierarchical stats.
> >
> > TL;DR:
> > - Userspace program creates a cgroup hierarchy and induces memcg reclaim
> >   in parts of it.
> > - Whenever reclaim happens, vmscan_start and vmscan_end update
> >   per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> >   have updates.
> > - When userspace tries to read the stats, vmscan_dump calls rstat to flush
> >   the stats, and outputs the stats in text format to userspace (similar
> >   to cgroupfs stats).
> > - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> >   updates, vmscan_flush aggregates cpu readings and propagates updates
> >   to parents.
> > - Userspace program makes sure the stats are aggregated and read
> >   correctly.
> >
> > Detailed explanation:
> > - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> >   measure the latency of cgroup reclaim. Per-cgroup readings are stored in
> >   percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> >   cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> >   rstat updated tree on that cpu.
> >
> > - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> >   each cgroup. Reading this file invokes the program, which calls
> >   cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
> >   cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
> >   the stats are exposed to the user. vmscan_dump returns 1 to terminate
> >   iteration early, so that we only expose stats for one cgroup per read.
> >
> > - An ftrace program, vmscan_flush, is also loaded and attached to
> >   bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
> >   once for each (cgroup, cpu) pair that has updates. cgroups are popped
> >   from the rstat tree in a bottom-up fashion, so calls will always be
> >   made for cgroups that have updates before their parents. The program
> >   aggregates percpu readings to a total per-cgroup reading, and also
> >   propagates them to the parent cgroup. After rstat flushing is over, all
> >   cgroups will have correct updated hierarchical readings (including all
> >   cpus and all their descendants).
> >
> > - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
> >   in parts of it, and makes sure that the stats collection, aggregation,
> >   and reading workflow works as expected.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
>
> I saw this test failed on CI on s390x [0], because of using kfunc, and
> on s390x, "JIT does not support calling kernel function". Is there
> anything I can do about it
>

You can add it to the deny list, like this patch:
https://lore.kernel.org/bpf/20220824163906.1186832-1-deso@posteo.net
