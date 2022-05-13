Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A95525C3F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 09:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377761AbiEMHRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 03:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377762AbiEMHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 03:17:08 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052005A090
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 00:17:06 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 1-20020a05600c248100b00393fbf11a05so6405452wms.3
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 00:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D48I44xYYqEiizbHxYfVxOewlUnyPkLWVYQKrLVTxyk=;
        b=JNZxi5R6tanpqpzBjy/0+KFn83Mbu2fosELlnMjWGAYKkVDQXkm2Xl70193Qjf2ga0
         52j3J3BHgC7rjwYmva0ALj4m2NsVRxFSvRHGk0Lf3TNvHZzsV/NwoBCFhA9cD3/p57qy
         2ABMnn9k7IfWcoZUItEyQBfJZIPT2YNX6QaV4ojKb7sWqd5GxaSlFEQXZdaQ4U3bHmc+
         gWTIS+gwZD4L2fFeX38rX6znFh8nn0InKoksnzJQWb+CN02IH0Ps8bsXq9oNK9+rTE1x
         ZapJZW4IUD1qOP1C29YRya0uensA6pKziFrSpmfx+KBojYD6wNTsqiwWoZiRGT6KGfcz
         Dosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D48I44xYYqEiizbHxYfVxOewlUnyPkLWVYQKrLVTxyk=;
        b=h0lXB1PrvGHd4AxVbAWSZI2INBXzn4VM2b53NtYltxX+sN8LpHSD9gMxtzdfcCqPm5
         VyVHNehuzgORdvNoMNOX5opB93A1OPgx8XQpMY61iQ8eL0IBEgBnMRnDSI7t14GPSjdo
         rKFJgju7Rb+4LDq0J0+TLSdZO1nLqAlo+LN2mEBYq7PYWQHqoMaDNu5PaFoIvuES8iSN
         oNp2aLBlOcpB2nTBHDa0iOgnwevzO20j1GUvjOrwCl6/n5eRLLFHKGZMmwzRClw5bFUG
         mwMmEpys0m6vdoIlBDIiHakzCo29TSwLutIgtQrU5oLoO9heDpHnT0nJQmjfsHp/CHI8
         twgQ==
X-Gm-Message-State: AOAM533VDCy8ESavePoHxnDnXSEmnDCMlXaOpQqS+f35s/hkQL7NAQ44
        iUI6HzlkJ2AeFGXK9DoGnOxlU1QRtTMhABVlOGfN6Q==
X-Google-Smtp-Source: ABdhPJwfzU0gfM+uIVwmmYsokip1ll+JhJO2vRFJF7KDw8gmKCduDXHm8eNOQrPQSRYPl1HWVSxQsqTDzdiiAvmuylM=
X-Received: by 2002:a05:600c:1c84:b0:394:5de0:2475 with SMTP id
 k4-20020a05600c1c8400b003945de02475mr3205771wms.27.1652426224436; Fri, 13 May
 2022 00:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220510001807.4132027-1-yosryahmed@google.com>
In-Reply-To: <20220510001807.4132027-1-yosryahmed@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 13 May 2022 00:16:28 -0700
Message-ID: <CAJD7tkaUBDnjL_Mt-t1ictGO552QF31DQ+VrEwkm3gg2DFZ14Q@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/9] bpf: cgroup hierarchical stats collection
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        cgroups@vger.kernel.org
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

I have done some significant changes on the BPF side of this. I will
send a RFC V2 soon with those changes and incorporating the feedback
on the cgroup side that I got from Tejun. Hold off on reviewing this
version.


On Mon, May 9, 2022 at 5:18 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats and
> propagate them through the cgroup hierarchy.
>
> The last patch is a selftest that demonastrates the entire workflow.
> The workflow consists of:
> - bpf programs that collect per-cpu per-cgroup stats (tracing progs).
> - bpf rstat flusher that contains the logic for aggregating stats
>   across cpus and across the cgroup hierarchy.
> - bpf cgroup_iter responsible for outputting the stats to userspace
>   through reading a file in bpffs.
>
> The first 3 patches include the new bpf rstat flusher program type and
> the needed support in rstat code and libbpf. The rstat flusher program
> is a callback that the rstat framework makes to bpf when a stat flush is
> ongoing, similar to the css_rstat_flush() callback that rstat makes to
> cgroup controllers. Each callback is parameterized by a (cgroup, cpu)
> pair that has been updated. The program contains the logic for
> aggregating the stats across cpus and across the cgroup hierarchy.
> These programs can be attached to any cgroup subsystem, not only the
> ones that implement the css_rstat_flush() callback in the kernel. This
> gives bpf programs more flexibility, and more isolation from the kernel
> implementation.
>
> The following 2 patches add necessary helpers for the stats collection
> workflow. Helpers that call into cgroup_rstat_updated() and
> cgroup_rstat_flush() are added to allow bpf programs collecting stats to
> tell the rstat framework that a cgroup has been updated, and to allow
> bpf programs outputting stats to tell the rstat framework to flush the
> stats before they are displayed to the user. An additional
> bpf_map_lookup_percpu_elem is introduced to allow rstat flusher programs
> to access percpu stats of the cpu being flushed.
>
> The following 3 patches add the cgroup_iter program type (v2). This was
> originally introduced by Hao as a part of a different series [1].
> Their usecase is better showcased as part of this patch series. We also
> make cgroup_get_from_id() cgroup v1 friendly to allow cgroup_iter programs
> to display stats for cgroup v1 as well. This small change makes the
> entire workflow cgroup v1 friendly without any other dedicated changes.
>
> The final patch is a selftest demonstrating the entire workflow with a
> set of bpf programs that collect per-cgroup latency of memcg reclaim.
>
> [1]https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo@google.com/
>
>
> Hao Luo (2):
>   cgroup: Add cgroup_put() in !CONFIG_CGROUPS case
>   bpf: Introduce cgroup iter
>
> Yosry Ahmed (7):
>   bpf: introduce CGROUP_SUBSYS_RSTAT program type
>   cgroup: bpf: flush bpf stats on rstat flush
>   libbpf: Add support for rstat progs and links
>   bpf: add bpf rstat helpers
>   bpf: add bpf_map_lookup_percpu_elem() helper
>   cgroup: add v1 support to cgroup_get_from_id()
>   bpf: add a selftest for cgroup hierarchical stats collection
>
>  include/linux/bpf-cgroup-subsys.h             |  35 ++
>  include/linux/bpf.h                           |   4 +
>  include/linux/bpf_types.h                     |   2 +
>  include/linux/cgroup-defs.h                   |   4 +
>  include/linux/cgroup.h                        |   5 +
>  include/uapi/linux/bpf.h                      |  45 +++
>  kernel/bpf/Makefile                           |   3 +-
>  kernel/bpf/arraymap.c                         |  11 +-
>  kernel/bpf/cgroup_iter.c                      | 148 ++++++++
>  kernel/bpf/cgroup_subsys.c                    | 212 +++++++++++
>  kernel/bpf/hashtab.c                          |  25 +-
>  kernel/bpf/helpers.c                          |  56 +++
>  kernel/bpf/syscall.c                          |   6 +
>  kernel/bpf/verifier.c                         |   6 +
>  kernel/cgroup/cgroup.c                        |  16 +-
>  kernel/cgroup/rstat.c                         |  11 +
>  scripts/bpf_doc.py                            |   2 +
>  tools/include/uapi/linux/bpf.h                |  45 +++
>  tools/lib/bpf/bpf.c                           |   3 +
>  tools/lib/bpf/bpf.h                           |   3 +
>  tools/lib/bpf/libbpf.c                        |  35 ++
>  tools/lib/bpf/libbpf.h                        |   3 +
>  tools/lib/bpf/libbpf.map                      |   1 +
>  .../test_cgroup_hierarchical_stats.c          | 335 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>  .../selftests/bpf/progs/cgroup_vmscan.c       | 211 +++++++++++
>  26 files changed, 1212 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/bpf-cgroup-subsys.h
>  create mode 100644 kernel/bpf/cgroup_iter.c
>  create mode 100644 kernel/bpf/cgroup_subsys.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c
>
> --
> 2.36.0.512.ge40c2bad7a-goog
>
