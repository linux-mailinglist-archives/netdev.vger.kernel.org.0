Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1827255FA18
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiF2IFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiF2IFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:05:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1363B002
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:05:21 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so8216598wmp.3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wnHAviUFhDVaCJzo+0DpZGrtDrNqYmOLuVCsVFlb1Yo=;
        b=AJI/W4FYYhwbpRWqo7dDSDkV2F1tq7JF11puGlbRhqbLU8dU7nSSyTqE1nwkvX47o+
         m5lrBMocawUttiEv5VkFFd68EG7i3M++3Yr7YMrr5acQCezSuhLIXl5wxkUMuWTOH+qj
         DTIVYPUV0ChgbU+Daq8kue7/rQz3vqcUdO0zQSIHluM4qBprv7U6X5IvYhHFfwgTvc/z
         UlqGFEFBjdLYuwHUUKipNPMPnxRLmkeGf+wqckzirfbWPPUmTlai3dSLkUibmlXqTjww
         kWqxgnuLwU/jyIS8jMcjIqk1DrgI3y+aWCDcvgNvem2mcbyaKKCKnLRhBXpJ/o0QBdRL
         lQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wnHAviUFhDVaCJzo+0DpZGrtDrNqYmOLuVCsVFlb1Yo=;
        b=BIAUU9meECKTj6WVuDwDVGPINmsJtlifOxaXaT2ZxScyxY3rVrxCppm1n8ocZKDzvT
         N5/I9HusIhpUvRma5qaNFg4aAOOyUpduNoj72YdnvbV4EtjI8dnEoCFOZuAPVDKn67YH
         W3TL1T5OTP5KVjMp4ae6avDb2TT+jps3eZ4SF0lFulz7QjeHsq3EzQlYp4E4llzNjwHj
         zhpN4aSkCT3g1Nr/PsiofqWGPuW0xiedBXH5TYQTNe9mnllESX93m7E70r1HtvSDddGz
         ZhCQgM98Od1/VDFaHmv/Wh95lQIdWBSfECXGo9n62/X8Doz8wt6zp+v3fhlKiOrhG4cz
         bZwQ==
X-Gm-Message-State: AJIora9ePIPOmZiG5OQ/gMpXaOi7hHsc1tRW17m9xyhG1LunumZ4dsCs
        wcrW2lYtCUZfdHGI+PAQXxGbOb1wXPokBUhWN3AqbQ==
X-Google-Smtp-Source: AGRyM1thojWwCc9/CS74a6yPpo3ci1J1ut6gsAYkM0wuoPQibvIdrtdNrn7x7d4Ye4q8fordsFNUrLJvUAYasXsp7yw=
X-Received: by 2002:a05:600c:34cc:b0:39c:832c:bd92 with SMTP id
 d12-20020a05600c34cc00b0039c832cbd92mr2156810wmq.24.1656489920007; Wed, 29
 Jun 2022 01:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com> <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
 <CAJD7tkaNnx6ebFrMxWgkJbtx=Qoe+cEwnjtWeY5=EAaVktrenw@mail.gmail.com>
 <CAJD7tkZ3AEPEUD9V-5nxUgmS5SLc6qp50ZyrRoAQgdzPM=a-Hg@mail.gmail.com>
 <CAJD7tkarwnbcqR1DUN-iJmt0k_njwBfDMd=P8ket8DfEfRRYjw@mail.gmail.com> <6dc9d46b-f1df-fb1d-8efd-580b7a6a7a6e@fb.com>
In-Reply-To: <6dc9d46b-f1df-fb1d-8efd-580b7a6a7a6e@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Wed, 29 Jun 2022 01:04:43 -0700
Message-ID: <CAJD7tkYsAyFguCOFCKYCaGyaqipCrTE1Q0ecvnrpY1fwG4j=Pg@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 11:48 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/22 5:09 PM, Yosry Ahmed wrote:
> > On Tue, Jun 28, 2022 at 12:14 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >>
> >> On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> >>>
> >>> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> >>>>> Add a selftest that tests the whole workflow for collecting,
> >>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
> >>>>>
> >>>>> TL;DR:
> >>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
> >>>>>     per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> >>>>>     have updates.
> >>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
> >>>>>     the stats, and outputs the stats in text format to userspace (similar
> >>>>>     to cgroupfs stats).
> >>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> >>>>>     updates, vmscan_flush aggregates cpu readings and propagates updates
> >>>>>     to parents.
> >>>>>
> >>>>> Detailed explanation:
> >>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> >>>>>     measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
> >>>>>     percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> >>>>>     cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> >>>>>     rstat updated tree on that cpu.
> >>>>>
> >>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> >>>>>     each cgroup. Reading this file invokes the program, which calls
> >>>>>     cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
> >>>>>     cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
> >>>>>     the stats are exposed to the user. vmscan_dump returns 1 to terminate
> >>>>>     iteration early, so that we only expose stats for one cgroup per read.
> >>>>>
> >>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
> >>>>>     bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
> >>>>>     once for each (cgroup, cpu) pair that has updates. cgroups are popped
> >>>>>     from the rstat tree in a bottom-up fashion, so calls will always be
> >>>>>     made for cgroups that have updates before their parents. The program
> >>>>>     aggregates percpu readings to a total per-cgroup reading, and also
> >>>>>     propagates them to the parent cgroup. After rstat flushing is over, all
> >>>>>     cgroups will have correct updated hierarchical readings (including all
> >>>>>     cpus and all their descendants).
> >>>>>
> >>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >>>>
> >>>> There are a selftest failure with test:
> >>>>
> >>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
> >>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >>>> get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
> >>>> get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
> >>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
> >>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
> >>>> actual 0 <= expected 0
> >>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
> >>>> 781874 != expected 382092
> >>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
> >>>> -1 != expected -2
> >>>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
> >>>> 781874 != expected 781873
> >>>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
> >>>> expected 781874
> >>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>>> destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
> >>>> cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
> >>>> #33      cgroup_hierarchical_stats:FAIL
> >>>>
> >>>
> >>> The test is passing on my setup. I am trying to figure out if there is
> >>> something outside the setup done by the test that can cause the test
> >>> to fail.
> >>>
> >>
> >> I can't reproduce the failure on my machine. It seems like for some
> >> reason reclaim is not invoked in one of the test cgroups which results
> >> in the expected stats not being there. I have a few suspicions as to
> >> what might cause this but I am not sure.
> >>
> >> If you have the capacity, do you mind re-running the test with the
> >> attached diff1.patch? (and maybe diff2.patch if that fails, this will
> >> cause OOMs in the test cgroup, you might see some process killed
> >> warnings).
> >> Thanks!
> >>
> >
> > In addition to that, it looks like one of the cgroups has a "0" stat
> > which shouldn't happen unless one of the map update/lookup operations
> > failed, which should log something using bpf_printk. I need to
> > reproduce the test failure to investigate this properly. Did you
> > observe this failure on your machine or in CI? Any instructions on how
> > to reproduce or system setup?
>
> I got "0" as well.
>
> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
> actual 0 <= expected 0
> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
> 676612 != expected 339142
> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
> -1 != expected -2
> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
> 676612 != expected 676611
> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
> expected 676612
>
> I don't have special config. I am running on qemu vm, similar to
> ci environment but may have a slightly different config.
>
> The CI for this patch set won't work since the sleepable kfunc support
> patch is not available. Once you have that patch, bpf CI should be able
> to compile the patch set and run the tests.
>

I will include this patch in the next version anyway, but I am trying
to find out why this selftest is failing for you before I send it out.
I am trying to reproduce the problem but no luck so far.

> >
> >>
> >>>>
> >>>> Also an existing test also failed.
> >>>>
> >>>> btf_dump_data:PASS:find type id 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:failed/unexpected type_sz 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> >>>> expected/actual match: actual '(union bpf_iter_link_info){.map =
> >>>> (struct){.map_fd = (__u32)1,},.cgroup '
> >>>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
> >>>>
> >>>
> >>> Yeah I see what happened there. bpf_iter_link_info was changed by the
> >>> patch that introduced cgroup_iter, and this specific union is used by
> >>> the test to test the "union with nested struct" btf dumping. I will
> >>> add a patch in the next version that updates the btf_dump_data test
> >>> accordingly. Thanks.
> >>>
> >>>>
> >>>> test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0
> >>>> nsec
> >>>>
> >>>> btf_dump_data:PASS:verify prefix match 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:find type id 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:verify prefix match 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:find type id 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
> >>>>
> >>>>
> >>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
> >>>>
> >>>>
> >>>> #21/14   btf_dump/btf_dump: struct_data:FAIL
> >>>>
> >>>> please take a look.
> >>>>
> >>>>> ---
> >>>>>    .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
> >>>>>    .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
> >>>>>    2 files changed, 585 insertions(+)
> >>>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> >>>>>    create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> >>>>>
> [...]
