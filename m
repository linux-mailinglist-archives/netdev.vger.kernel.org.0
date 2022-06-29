Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBC755F9FC
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiF2IEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF2IEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:04:23 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F1629CB5
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:04:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k22so21156067wrd.6
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zRf5UwJSFwOKMWYCo+NYCtcvIlqTfbI8aBejevwXVI4=;
        b=qGU014NppgnQ4NbDPye4XEUlwmw0vOqpih0l20x5Lyk+Wz4aDJ8DVlo9on/rJ9KU2l
         h+7pRoY82L9tJXbAALnFHTmEmxkV1m6Av8BuOqJTndMfM/Gg/ZrvBJPPkY71wyB8CjL+
         i+HmFQrI4WL7pXkhjMp0RPUB8BZChmeM/1Qf0X4yCN1QzeekMSLm15ybVmap+hDd/Qhb
         7Y0uXcMiGGFjmgOpcGgeWuVsE9FFH7ALZIgsb97HLswmSLq4U9zn8iZkLmWEit9vhFcF
         CGmhi56oBjLbI+944WQa22TdRrGeF8Mf6IQWDNvBqWkEopbF+UCKcRWLIOFwUS0MQCJ7
         IkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zRf5UwJSFwOKMWYCo+NYCtcvIlqTfbI8aBejevwXVI4=;
        b=eCOm2/lBo6BLWo9BwHnRR7/Wd+LAt95IZeS5QFzTXmOGav/HkifZZC1wYzxjdH/LQw
         SsJuLd5U1MDUTyFkSOeFwlk0ScPzN5/aE5HWIZg5wwz5/Mm6xMkEhe6vrePGzIR6tu4p
         261KYCmWHk8I7a83MdM33Aw0K0yXqoLdrYOwksoIgG1SBnMdKAn/2Mn3Y9Nv4s5bkgRu
         fTY48VmQfwRrZwKmuDdm6hxjW9xRjQqFqw63a3ltY5PDecLBpvE3MAPB+rdfYgoMFr0x
         jJx8FHAQusuS+TozzdyJrxaijKwQtSgVio8XTivUFtDPSghs03Jjh0XYyv3m28kGjK8M
         jrpg==
X-Gm-Message-State: AJIora/YuwHtMff9vYtG26i/P83zHTK73bxD/AVt+s/+gD6wQyXfAXfe
        ZQZ8v0v8SrQYiwU1T4GZ2yYP2Sgw4/svRPMnzVV6+A==
X-Google-Smtp-Source: AGRyM1v6bUugJ8jSFfCOXoA4e3bcYceOswWINVSQzWixUcdobsHBwooNlJ0+5gY/xuIH4Q/UwhfhFiSlnzV4d+KAhlM=
X-Received: by 2002:adf:f146:0:b0:21b:8c7d:7294 with SMTP id
 y6-20020adff146000000b0021b8c7d7294mr1698559wro.582.1656489860013; Wed, 29
 Jun 2022 01:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com> <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
 <CAJD7tkaNnx6ebFrMxWgkJbtx=Qoe+cEwnjtWeY5=EAaVktrenw@mail.gmail.com>
 <CAJD7tkbOztCEWgMzoCOdD+g3whMMQWW2e0gwo9p0tVK=3hqmcw@mail.gmail.com> <59376285-21bc-ff12-3d64-3ea7257becb2@fb.com>
In-Reply-To: <59376285-21bc-ff12-3d64-3ea7257becb2@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Wed, 29 Jun 2022 01:03:43 -0700
Message-ID: <CAJD7tkZ50QanA=2nrg6hBEk3p5oanHtF-6L_x0UQQ7AcZpBKrA@mail.gmail.com>
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

On Tue, Jun 28, 2022 at 11:27 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/22 12:43 AM, Yosry Ahmed wrote:
> > On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> >>
> >> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>>
> >>>
> >>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> >>>> Add a selftest that tests the whole workflow for collecting,
> >>>> aggregating (flushing), and displaying cgroup hierarchical stats.
> >>>>
> >>>> TL;DR:
> >>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
> >>>>     per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> >>>>     have updates.
> >>>> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
> >>>>     the stats, and outputs the stats in text format to userspace (similar
> >>>>     to cgroupfs stats).
> >>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> >>>>     updates, vmscan_flush aggregates cpu readings and propagates updates
> >>>>     to parents.
> >>>>
> >>>> Detailed explanation:
> >>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> >>>>     measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
> >>>>     percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> >>>>     cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> >>>>     rstat updated tree on that cpu.
> >>>>
> >>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> >>>>     each cgroup. Reading this file invokes the program, which calls
> >>>>     cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
> >>>>     cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
> >>>>     the stats are exposed to the user. vmscan_dump returns 1 to terminate
> >>>>     iteration early, so that we only expose stats for one cgroup per read.
> >>>>
> >>>> - An ftrace program, vmscan_flush, is also loaded and attached to
> >>>>     bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
> >>>>     once for each (cgroup, cpu) pair that has updates. cgroups are popped
> >>>>     from the rstat tree in a bottom-up fashion, so calls will always be
> >>>>     made for cgroups that have updates before their parents. The program
> >>>>     aggregates percpu readings to a total per-cgroup reading, and also
> >>>>     propagates them to the parent cgroup. After rstat flushing is over, all
> >>>>     cgroups will have correct updated hierarchical readings (including all
> >>>>     cpus and all their descendants).
> >>>>
> >>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >>>
> >>> There are a selftest failure with test:
> >>>
> >>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
> >>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >>> get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
> >>> get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
> >>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
> >>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
> >>> actual 0 <= expected 0
> >>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
> >>> 781874 != expected 382092
> >>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
> >>> -1 != expected -2
> >>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
> >>> 781874 != expected 781873
> >>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
> >>> expected 781874
> >>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
> >>> destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
> >>> cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
> >>> #33      cgroup_hierarchical_stats:FAIL
> >>>
> >>
> >> The test is passing on my setup. I am trying to figure out if there is
> >> something outside the setup done by the test that can cause the test
> >> to fail.
> >>
> >>>
> >>> Also an existing test also failed.
> >>>
> >>> btf_dump_data:PASS:find type id 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:failed/unexpected type_sz 0 nsec
> >>>
> >>>
> >>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> >>> expected/actual match: actual '(union bpf_iter_link_info){.map =
> >>> (struct){.map_fd = (__u32)1,},.cgroup '
> >>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
> >>>
> >>
> >> Yeah I see what happened there. bpf_iter_link_info was changed by the
> >> patch that introduced cgroup_iter, and this specific union is used by
> >> the test to test the "union with nested struct" btf dumping. I will
> >> add a patch in the next version that updates the btf_dump_data test
> >> accordingly. Thanks.
> >>
> >
> > So I actually tried the attached diff to updated the expected dump of
> > bpf_iter_link_info in this test, but the test still failed:
> >
> > btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> > expected/actual match: actual '(union bpf_iter_link_info){.map =
> > (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> > (__u32)1,},}'  != expected '(union bpf_iter_link_info){.map =
> > (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> > (__u32)1,.traversal_order = (__u32)1},}'
> >
> > It seems to me that the actual output in this case is not right, it is
> > missing traversal_order. Did we accidentally find a bug in btf dumping
> > of unions with nested structs, or am I missing something here?
>
> Probably there is an issue in btf_dump_data() function in
> tools/lib/bpf/btf_dump.c. Could you take a look at it?

I will try to take a look but after I figure out why the selftest
added here is always passing for me and always failing for you :(

>
> > Thanks!
> >
> >>>
> >>> test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0
> >>> nsec
> >>>
> >>> btf_dump_data:PASS:verify prefix match 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:find type id 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:verify prefix match 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:find type id 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
> >>>
> >>>
> >>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
> >>>
> >>>
> >>> #21/14   btf_dump/btf_dump: struct_data:FAIL
> >>>
> >>> please take a look.
> >>>
> >>>> ---
> >>>>    .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
> >>>>    .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
> >>>>    2 files changed, 585 insertions(+)
> >>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> >>>>    create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> >>>>
> [...]
