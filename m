Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5AD5873AA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 00:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiHAWAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 18:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiHAWAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 18:00:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF84DFFC;
        Mon,  1 Aug 2022 15:00:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p5so15405461edi.12;
        Mon, 01 Aug 2022 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hQjaiLlOPDHg8PJMxt51e7po/sQpoZ8WOzBvNGfMuJw=;
        b=SgVAraQQNEuyUU1IYaTN+0ukCGUBlTYzej3Y9PZ6rXYfTtTnWWtxrdXvWhO6BHwLbr
         YbN4vLDYHRjxIkedz67wdupFmHhyMFB1IU3qJhVsbo2+2B+vNS9sso8K+RaT3/DUl2KP
         o4DnXejif53KP2eB22SMFYZ959/PJ3y7IPd2Raf5vPkPrPW629H66Ym7+xMXv9uNvGQl
         4PrmeuW09HMUJJhjTbyX7VI/flRMz64gJFXRUUXGKo8JqCZWXbAVghTcwGEyEDQORt4P
         AtOPiX7DnQyir7PzYCNffdg6/LSu3VyokofWb+kO39AP7DMlpcTBT6r/bpAtYYcAS/vt
         QPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hQjaiLlOPDHg8PJMxt51e7po/sQpoZ8WOzBvNGfMuJw=;
        b=NvHqvQDmZdQu+MQBkv9ReO5tIJHqOcQN9Y5EmLDo0mf4IiH35ndNFv7eMYs9IH7Nd4
         Ake/FFTi/KEqJ4wsgVEh7vH6ODDDCULk6/ZnQZd5FT2DOWBKmbkQIpHtUJ42B2ect0m0
         CClPGsQhDEfhKeooT27p8FjVi5aEJvaW1eq13bdNOSWb+mxJCcBVYHJDIa/XlkMZAYMh
         sRk0f6b0DDTlAXek+jNsWhTxSvf4FyhlkblXk4n2N7WmPreXLa4pbUalaRe6UvYPZ3gP
         lzj5y1no340x1N0mK9k5iyJ83JtcNoHgLes3pl5s6noRbHwySg8x55nrY8nOCvXD703B
         QRnQ==
X-Gm-Message-State: ACgBeo2Z5/G/Usn5yHFBccUlnxLOMmmU/4nRkWAtqVkeKJUtqLXcQ0qF
        JmWWq6/uYQ3w2FJaGIseeftY7BaXndJ9i9V8bLo=
X-Google-Smtp-Source: AA6agR4BHIatxtmS+U0WWvYuA9anzo03WeJOAUuTrGKsWpHfq1dAIfQ9ca2kLQijM24ByFg4sbpFwj6Krq18eTuU648=
X-Received: by 2002:aa7:ccc4:0:b0:43d:9e0e:b7ff with SMTP id
 y4-20020aa7ccc4000000b0043d9e0eb7ffmr7521645edt.14.1659391231767; Mon, 01 Aug
 2022 15:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-9-haoluo@google.com>
In-Reply-To: <20220801175407.2647869-9-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Aug 2022 15:00:20 -0700
Message-ID: <CAEf4Bza0BzW1urrDghOw2oynftOQ6jP7_k4VvEq-UgyBHp6D8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 8/8] selftests/bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo@google.com> wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Add a selftest that tests the whole workflow for collecting,
> aggregating (flushing), and displaying cgroup hierarchical stats.
>
> TL;DR:
> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>   in parts of it.
> - Whenever reclaim happens, vmscan_start and vmscan_end update
>   per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>   have updates.
> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>   the stats, and outputs the stats in text format to userspace (similar
>   to cgroupfs stats).
> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>   updates, vmscan_flush aggregates cpu readings and propagates updates
>   to parents.
> - Userspace program makes sure the stats are aggregated and read
>   correctly.
>
> Detailed explanation:
> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>   measure the latency of cgroup reclaim. Per-cgroup readings are stored in
>   percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>   cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>   rstat updated tree on that cpu.
>
> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>   each cgroup. Reading this file invokes the program, which calls
>   cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>   cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>   the stats are exposed to the user. vmscan_dump returns 1 to terminate
>   iteration early, so that we only expose stats for one cgroup per read.
>
> - An ftrace program, vmscan_flush, is also loaded and attached to
>   bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>   once for each (cgroup, cpu) pair that has updates. cgroups are popped
>   from the rstat tree in a bottom-up fashion, so calls will always be
>   made for cgroups that have updates before their parents. The program
>   aggregates percpu readings to a total per-cgroup reading, and also
>   propagates them to the parent cgroup. After rstat flushing is over, all
>   cgroups will have correct updated hierarchical readings (including all
>   cpus and all their descendants).
>
> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>   in parts of it, and makes sure that the stats collection, aggregation,
>   and reading workflow works as expected.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  .../prog_tests/cgroup_hierarchical_stats.c    | 358 ++++++++++++++++++
>  .../bpf/progs/cgroup_hierarchical_stats.c     | 218 +++++++++++
>  2 files changed, 576 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>

[...]

> +extern void cgroup_rstat_updated(struct cgroup *cgrp, int cpu) __ksym;
> +extern void cgroup_rstat_flush(struct cgroup *cgrp) __ksym;
> +
> +static struct cgroup *task_memcg(struct task_struct *task)
> +{
> +       return task->cgroups->subsys[memory_cgrp_id]->cgroup;

memory_cgrp_id is kernel-defined internal enum which actually can
change based on kernel configuration (i.e., which cgroup subsystems
are enabled or not), is that right?

In practice you wouldn't hard-code it, it's better to use
bpf_core_enum_value() to capture enum's value in CO-RE-relocatable
way.

So it might be a good idea to demonstrate that here.

> +}
> +
> +static uint64_t cgroup_id(struct cgroup *cgrp)
> +{
> +       return cgrp->kn->id;
> +}
> +

[...]
