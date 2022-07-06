Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E3756945C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiGFVad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiGFVac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:30:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E290C27145
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 14:30:29 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h17so10602784wrx.0
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 14:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQw39tPtKwwT0TwawC+SleFl+XxjNJEpZjL17UZWqD0=;
        b=TJ0JwctkW4FEMEufZxjl6PXg89sMUFNRoAy0Z5jhygDZZFckNW8E4XxJ8eCgL/hDjV
         hpoomx5AObK3ULKhJgcDQLBiab+fZf8xg/BY/LryOR1DX8vA3JDoAj8gpSib9lNy/s/e
         /jzooYkBVmWDEH5zOICcV4QgtMCIhgJSD6R5rt6p8JNkeUND/+ROwETEoXbXZcSx3Pw5
         +kO8Eawr7OH8uiz5h4pEiZrUnntkQIZncf0aUqDcaOyWbRd8t3dclS0SKnZIHTtW5x8L
         dikFgDoKYwxUBoOszJ6rcwJsmQibZ2dVNTX63FmKNc/RgDWCF4smHfVSDETfonEAlYnp
         OgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQw39tPtKwwT0TwawC+SleFl+XxjNJEpZjL17UZWqD0=;
        b=VFaxmYIPuI4DsmI9dd6ddMVAewltIMH6MFVb4njtSV70/+8dk3mshoKga7s4d8OT2n
         6m0smFFtOhXSZmg/oaUH7CUE/QvRqkOuNsokSTV6zGTKCpxrNex40DgiFZ6mivxeEWqX
         yZSaSKGj7MRwtFqIRViCHjzTOYdNvy7OTDqOZkVZd0M3ORWh7jv+zDUOWaQ2coKaxzvv
         pEXT8zdzJL0EFmbUT0tQCC9vsc+znzIx/IfV2+txM2qq/VFPIvr9HgZfBEmGtO6LbVYS
         Ve7YSL8gaqYl7w2pihJ5C2U2sZYrjARj9beWzeY9kO2jdGQBKOdHvwVUZBkWJyRsol/Z
         6VEw==
X-Gm-Message-State: AJIora+qSjNIAZK2N09mjZlFdG6Wnnw9vsSvgC8YsL/hzw2gFzEDMGtr
        LpX+DluxrnAXFaHXjng4S0OLKr9yWLT0LmnA6V0KAA==
X-Google-Smtp-Source: AGRyM1sa1KLvVwiqE5w//w51IOO4ULLgKKe5OZNbipaSgJ+tftt4F/w5yFFO60u5gE8GvclfS23cyFQEJzqOqzwpxUg=
X-Received: by 2002:a5d:664d:0:b0:21a:3b82:6bb2 with SMTP id
 f13-20020a5d664d000000b0021a3b826bb2mr39462129wrw.534.1657143028112; Wed, 06
 Jul 2022 14:30:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com> <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
 <CAJD7tkaNnx6ebFrMxWgkJbtx=Qoe+cEwnjtWeY5=EAaVktrenw@mail.gmail.com>
 <CAJD7tkZ3AEPEUD9V-5nxUgmS5SLc6qp50ZyrRoAQgdzPM=a-Hg@mail.gmail.com>
 <CAJD7tkarwnbcqR1DUN-iJmt0k_njwBfDMd=P8ket8DfEfRRYjw@mail.gmail.com>
 <6dc9d46b-f1df-fb1d-8efd-580b7a6a7a6e@fb.com> <CAJD7tkYsAyFguCOFCKYCaGyaqipCrTE1Q0ecvnrpY1fwG4j=Pg@mail.gmail.com>
 <d144ca6b-7f25-f3fa-def7-6c63a6dfc1aa@fb.com>
In-Reply-To: <d144ca6b-7f25-f3fa-def7-6c63a6dfc1aa@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Wed, 6 Jul 2022 14:29:51 -0700
Message-ID: <CAJD7tkYpiuHi0aFNUoeELPi=o0v=owexMgf_HhC7qqr6X9jG8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
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

On Fri, Jul 1, 2022 at 5:55 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/29/22 1:04 AM, Yosry Ahmed wrote:
> > On Tue, Jun 28, 2022 at 11:48 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 6/28/22 5:09 PM, Yosry Ahmed wrote:
> >>> On Tue, Jun 28, 2022 at 12:14 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >>>>
> >>>> On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> >>>>>
> >>>>> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> >>>>>>> Add a selftest that tests the whole workflow for collecting,
> >>>>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
> >>>>>>>
> >>>>>>> TL;DR:
> >>>>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
> >>>>>>>      per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> >>>>>>>      have updates.
> >>>>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
> >>>>>>>      the stats, and outputs the stats in text format to userspace (similar
> >>>>>>>      to cgroupfs stats).
> >>>>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> >>>>>>>      updates, vmscan_flush aggregates cpu readings and propagates updates
> >>>>>>>      to parents.
> >>>>>>>
> >>>>>>> Detailed explanation:
> >>>>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> >>>>>>>      measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
> >>>>>>>      percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> >>>>>>>      cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> >>>>>>>      rstat updated tree on that cpu.
> >>>>>>>
> >>>>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> >>>>>>>      each cgroup. Reading this file invokes the program, which calls
> >>>>>>>      cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
> >>>>>>>      cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
> >>>>>>>      the stats are exposed to the user. vmscan_dump returns 1 to terminate
> >>>>>>>      iteration early, so that we only expose stats for one cgroup per read.
> >>>>>>>
> >>>>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
> >>>>>>>      bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
> >>>>>>>      once for each (cgroup, cpu) pair that has updates. cgroups are popped
> >>>>>>>      from the rstat tree in a bottom-up fashion, so calls will always be
> >>>>>>>      made for cgroups that have updates before their parents. The program
> >>>>>>>      aggregates percpu readings to a total per-cgroup reading, and also
> >>>>>>>      propagates them to the parent cgroup. After rstat flushing is over, all
> >>>>>>>      cgroups will have correct updated hierarchical readings (including all
> >>>>>>>      cpus and all their descendants).
> >>>>>>>
> >>>>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >>>>>>
> >>>>>> There are a selftest failure with test:
> >>>>>>
> >>>>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
> >>>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >>>>>> get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
> >>>>>> get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
> >>>>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
> >>>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >>>>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
> >>>>>> actual 0 <= expected 0
> >>>>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
> >>>>>> 781874 != expected 382092
> >>>>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
> >>>>>> -1 != expected -2
> >>>>>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
> >>>>>> 781874 != expected 781873
> >>>>>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
> >>>>>> expected 781874
> >>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>>>> destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
> >>>>>> cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
> >>>>>> #33      cgroup_hierarchical_stats:FAIL
> >>>>>>
> >>>>>
> >>>>> The test is passing on my setup. I am trying to figure out if there is
> >>>>> something outside the setup done by the test that can cause the test
> >>>>> to fail.
> >>>>>
> >>>>
> >>>> I can't reproduce the failure on my machine. It seems like for some
> >>>> reason reclaim is not invoked in one of the test cgroups which results
> >>>> in the expected stats not being there. I have a few suspicions as to
> >>>> what might cause this but I am not sure.
> >>>>
> >>>> If you have the capacity, do you mind re-running the test with the
> >>>> attached diff1.patch? (and maybe diff2.patch if that fails, this will
> >>>> cause OOMs in the test cgroup, you might see some process killed
> >>>> warnings).
> >>>> Thanks!
> >>>>
> >>>
> >>> In addition to that, it looks like one of the cgroups has a "0" stat
> >>> which shouldn't happen unless one of the map update/lookup operations
> >>> failed, which should log something using bpf_printk. I need to
> >>> reproduce the test failure to investigate this properly. Did you
> >>> observe this failure on your machine or in CI? Any instructions on how
> >>> to reproduce or system setup?
> >>
> >> I got "0" as well.
> >>
> >> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
> >> actual 0 <= expected 0
> >> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
> >> 676612 != expected 339142
> >> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
> >> -1 != expected -2
> >> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
> >> 676612 != expected 676611
> >> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
> >> expected 676612
> >>
> >> I don't have special config. I am running on qemu vm, similar to
> >> ci environment but may have a slightly different config.
> >>
> >> The CI for this patch set won't work since the sleepable kfunc support
> >> patch is not available. Once you have that patch, bpf CI should be able
> >> to compile the patch set and run the tests.
> >>
> >
> > I will include this patch in the next version anyway, but I am trying
> > to find out why this selftest is failing for you before I send it out.
> > I am trying to reproduce the problem but no luck so far.
>
> I debugged this a little bit and found that this two programs
>
> SEC("tp_btf/mm_vmscan_memcg_reclaim_begin")
> int BPF_PROG(vmscan_start, struct lruvec *lruvec, struct scan_control *sc)
>
> and
>
> SEC("tp_btf/mm_vmscan_memcg_reclaim_end")
> int BPF_PROG(vmscan_end, struct lruvec *lruvec, struct scan_control *sc)
>
> are not triggered.

Thanks so much for doing this. I am still failing to reproduce the
problem so this is very useful. I believe if those programs are not
triggered at all then we are not walking the memcg reclaim path, which
shouldn't happen since we are setting memory.high to a limit and then
allocating more memory, which should trigger memcg reclaim.

I am looking at the code now, and there are some conditions that will
cause memory.high to not invoke reclaim (at least synchronously). Did
you try diff2.patch attached in the previous email? It changes the
test to use memory.max instead of memory.high, this will cause an OOM
kill of the test child process, but it should be a stronger guarantee
that reclaim happens and we hit mm_vmscan_memcg_reclaim_begin/end().
If diff2.patch above works, is it okay to keep it? Is it okay to have
some test processes OOM killed during testing?

>
> I do have CONFIG_MEMCG enabled in my config file:
> ...
> CONFIG_MEMCG=y
> CONFIG_MEMCG_SWAP=y
> CONFIG_MEMCG_KMEM= > ...
>
> Maybe when cgroup_rstat_flush() is called, some code path won't trigger
> mm_vmscan_memcg_reclaim_begin/end()?
>

cgroup_rstat_flush() should be completely separate in this regard, and
should not affect the code path that triggers
mm_vmscan_memcg_reclaim_begin/end().

> >
> >>>
> >>>>
> >>>>>>
> >>>>>> Also an existing test also failed.
> >>>>>>
> >>>>>> btf_dump_data:PASS:find type id 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:failed/unexpected type_sz 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> >>>>>> expected/actual match: actual '(union bpf_iter_link_info){.map =
> >>>>>> (struct){.map_fd = (__u32)1,},.cgroup '
> >>>>>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
> >>>>>>
> >>>>>
> >>>>> Yeah I see what happened there. bpf_iter_link_info was changed by the
> >>>>> patch that introduced cgroup_iter, and this specific union is used by
> >>>>> the test to test the "union with nested struct" btf dumping. I will
> >>>>> add a patch in the next version that updates the btf_dump_data test
> >>>>> accordingly. Thanks.
> >>>>>
> >>>>>>
> >>>>>> test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0
> >>>>>> nsec
> >>>>>>
> >>>>>> btf_dump_data:PASS:verify prefix match 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:find type id 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:verify prefix match 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:find type id 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
> >>>>>>
> >>>>>>
> >>>>>> #21/14   btf_dump/btf_dump: struct_data:FAIL
> >>>>>>
> >>>>>> please take a look.
> >>>>>>
> >>>>>>> ---
> >>>>>>>     .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
> >>>>>>>     .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
> >>>>>>>     2 files changed, 585 insertions(+)
> >>>>>>>     create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> >>>>>>>     create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> >>>>>>>
> >> [...]
