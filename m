Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E0F571100
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 05:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiGLD4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 23:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiGLD4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 23:56:14 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307DF3ED70
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 20:56:09 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r10so3257911wrv.4
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 20:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DtZHEZADB3JECY47Yo409VrgFsGXjY17lsaTSbiRvl0=;
        b=mFHOW9FavN+1RbEA0qtYGYDT3GOeLmIbC9FfKIEFWgFL0rMhHfGt1syJts7NBkTf16
         tm9M2Glr9e/Ux/yRWXN/PUZuQrAXYk+Nd1qvH9xf0vzV8P3K1jVUHSmnmopz91cFC2RF
         gXhtOv3ll5MHfypnm+FYriDHMPyPFZYOnKjKLkLZ1RSoWME9VKX9QLMGgF9Uk4gm//c8
         TSCwPrlvCkyaASxFm7rpBZQdDbmxE/buFLLCMzHv4TYTNfUXjJL5pMViBIlwm4EuScsl
         EMHctYmT+oAXDoPwLC+BhycPGkroUnIyKKbUXEk7gExXzpEb5n8uyjGaJY36arV0l+PV
         1dzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DtZHEZADB3JECY47Yo409VrgFsGXjY17lsaTSbiRvl0=;
        b=m+ur9+6cbvrqvyi9Su4uZckzXT7PUhjJRQvc/bpGpmbAyA5QefzvinIsyxWP31VC6Q
         xpEqDxAG2qAGk6SuikOk26f3uXJRfrEP0KMnNJR15JsKixbhmZ3irccgSjcTGsQN/08U
         Eqe60e5yMxrAZKyQrKD2qJQWoOoj4HpvOM1Pt95HuVEleob7jkfMHBerKOd2ewKkT0ih
         PSiC7pMulOj8eww65uoPsHnnvtXjNe1im4DilZDNn2ACBf1CRR3pAnlLlJWNns9fB5Pl
         2x9OxLPpiJ5VWOfXf73jE3Ps1mhHqafJSXIj9IaR0KnEbGMaCsKaTWFp5GKdCDnM8d8U
         SBvw==
X-Gm-Message-State: AJIora8PCxIaljdsBDS2Lev7pvS7PqMVwcicQ+K68u3qNkhHDUmRsKc5
        k8FODp//loKlnOlc1bWcL3Edc2CAEeDuqs24pZLZuw==
X-Google-Smtp-Source: AGRyM1truL0F+xsVarfV3RRzQePPtKq2ND89Q/QqRMEMPbiCLLcdYzV+wndKpkoIPXpNbkYzCP30CkcH035SohjUn68=
X-Received: by 2002:a5d:47c6:0:b0:21d:97dc:8f67 with SMTP id
 o6-20020a5d47c6000000b0021d97dc8f67mr14582631wrc.372.1657598167573; Mon, 11
 Jul 2022 20:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com> <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
In-Reply-To: <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 11 Jul 2022 20:55:31 -0700
Message-ID: <CAJD7tkZUfNqD8z6Cv7vi1TxpwKTXhDn_yweDHnRr++9iJs+=ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
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

On Sun, Jul 10, 2022 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/10/22 5:26 PM, Yonghong Song wrote:
> >
> >
> > On 7/8/22 5:04 PM, Yosry Ahmed wrote:
> >> Add a selftest that tests the whole workflow for collecting,
> >> aggregating (flushing), and displaying cgroup hierarchical stats.
> >>
> >> TL;DR:
> >> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
> >>    in parts of it.
> >> - Whenever reclaim happens, vmscan_start and vmscan_end update
> >>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> >>    have updates.
> >> - When userspace tries to read the stats, vmscan_dump calls rstat to
> >> flush
> >>    the stats, and outputs the stats in text format to userspace (similar
> >>    to cgroupfs stats).
> >> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> >>    updates, vmscan_flush aggregates cpu readings and propagates updates
> >>    to parents.
> >> - Userspace program makes sure the stats are aggregated and read
> >>    correctly.
> >>
> >> Detailed explanation:
> >> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> >>    measure the latency of cgroup reclaim. Per-cgroup readings are
> >> stored in
> >>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> >>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> >>    rstat updated tree on that cpu.
> >>
> >> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> >>    each cgroup. Reading this file invokes the program, which calls
> >>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates
> >> for all
> >>    cpus and cgroups that have updates in this cgroup's subtree.
> >> Afterwards,
> >>    the stats are exposed to the user. vmscan_dump returns 1 to terminate
> >>    iteration early, so that we only expose stats for one cgroup per read.
> >>
> >> - An ftrace program, vmscan_flush, is also loaded and attached to
> >>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is
> >> invoked
> >>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
> >>    from the rstat tree in a bottom-up fashion, so calls will always be
> >>    made for cgroups that have updates before their parents. The program
> >>    aggregates percpu readings to a total per-cgroup reading, and also
> >>    propagates them to the parent cgroup. After rstat flushing is over,
> >> all
> >>    cgroups will have correct updated hierarchical readings (including all
> >>    cpus and all their descendants).
> >>
> >> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
> >>    in parts of it, and makes sure that the stats collection, aggregation,
> >>    and reading workflow works as expected.
> >>
> >> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >> ---
> >>   .../prog_tests/cgroup_hierarchical_stats.c    | 362 ++++++++++++++++++
> >>   .../bpf/progs/cgroup_hierarchical_stats.c     | 235 ++++++++++++
> >>   2 files changed, 597 insertions(+)
> >>   create mode 100644
> >> tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> >>   create mode 100644
> >> tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> >>
> > [...]
> >> +
> >> +static unsigned long long get_cgroup_vmscan_delay(unsigned long long
> >> cgroup_id,
> >> +                          const char *file_name)
> >> +{
> >> +    char buf[128], path[128];
> >> +    unsigned long long vmscan = 0, id = 0;
> >> +    int err;
> >> +
> >> +    /* For every cgroup, read the file generated by cgroup_iter */
> >> +    snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
> >> +    err = read_from_file(path, buf, 128);
> >> +    if (!ASSERT_OK(err, "read cgroup_iter"))
> >> +        return 0;
> >> +
> >> +    /* Check the output file formatting */
> >> +    ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
> >> +             &id, &vmscan), 2, "output format");
> >> +
> >> +    /* Check that the cgroup_id is displayed correctly */
> >> +    ASSERT_EQ(id, cgroup_id, "cgroup_id");
> >> +    /* Check that the vmscan reading is non-zero */
> >> +    ASSERT_GT(vmscan, 0, "vmscan_reading");
> >> +    return vmscan;
> >> +}
> >> +
> >> +static void check_vmscan_stats(void)
> >> +{
> >> +    int i;
> >> +    unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
> >> +
> >> +    for (i = 0; i < N_CGROUPS; i++)
> >> +        vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
> >> +                                 cgroups[i].name);
> >> +
> >> +    /* Read stats for root too */
> >> +    vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
> >> +
> >> +    /* Check that child1 == child1_1 + child1_2 */
> >> +    ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] +
> >> vmscan_readings[4],
> >> +          "child1_vmscan");
> >> +    /* Check that child2 == child2_1 + child2_2 */
> >> +    ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] +
> >> vmscan_readings[6],
> >> +          "child2_vmscan");
> >> +    /* Check that test == child1 + child2 */
> >> +    ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] +
> >> vmscan_readings[2],
> >> +          "test_vmscan");
> >> +    /* Check that root >= test */
> >> +    ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");
> >
> > I still get a test failure with
> >
> > get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> > get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
> > actual 0 <= expected 0
> > check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 0
> > != expected -2
> > check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 0
> > != expected -2
> > check_vmscan_stats:PASS:test_vmscan 0 nsec
> > check_vmscan_stats:PASS:root_vmscan 0 nsec
> >
> > I added 'dump_stack()' in function try_to_free_mem_cgroup_pages()
> > and run this test (#33) and didn't get any stacktrace.
> > But I do get stacktraces due to other operations like
> >          try_to_free_mem_cgroup_pages+0x1fd [kernel]
> >          try_to_free_mem_cgroup_pages+0x1fd [kernel]
> >          memory_reclaim_write+0x88 [kernel]
> >          cgroup_file_write+0x88 [kernel]
> >          kernfs_fop_write_iter+0xd0 [kernel]
> >          vfs_write+0x2c4 [kernel]
> >          __x64_sys_write+0x60 [kernel]
> >          do_syscall_64+0x2d [kernel]
> >          entry_SYSCALL_64_after_hwframe+0x44 [kernel]
> >
> > If you can show me the stacktrace about how
> > try_to_free_mem_cgroup_pages() is triggered in your setup, I can
> > help debug this problem in my environment.
>
> BTW, CI also reported the test failure.
> https://github.com/kernel-patches/bpf/pull/3284
>
> For example, with gcc built kernel,
> https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true
>
> The error:
>
>    get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>    get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>    check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan:
> actual 28390910 != expected 28390909
>    check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan:
> actual 0 != expected -2
>    check_vmscan_stats:PASS:test_vmscan 0 nsec
>    check_vmscan_stats:PASS:root_vmscan 0 nsec
>

Hey Yonghong,

Thanks for helping us debug this failure. I can reproduce the CI
failure in my enviornment, but this failure is actually different from
the failure in your environment. In your environment it looks like no
stats are gathered for all cgroups (either no reclaim happening or bpf
progs not being run). In the CI and in my environment, only one cgroup
observes this behavior.

The thing is, I was able to reproduce the problem only when I ran all
test_progs. When I run the selftest alone (test_progs -t
cgroup_hierarchical_stats), it consistently passes, which is
interesting.

Anyway, one failure at a time :) I am working on debugging the CI
failure (that occurs only when all tests are run), then we'll see if
fixing that fixes the problem in our environment as well.

If you have any pointers about why a test would consistently pass
alone and consistently fail with others that would be good. Otherwise,
I will keep you updated with any findings I reach.

Thanks again!

> >
> >> +}
> >> +
> >> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj,
> >> int cgroup_fd,
> > [...]
