Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE1252F069
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351522AbiETQTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbiETQTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:19:31 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B2D7CDFA
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:19:29 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e28so11555049wra.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/EVIv/9CZTu8F4lKjgKh6a8dtu5zA1i+E/pDvfo4hlg=;
        b=CW69hrN5vebSYxMBDMRgCe2w0sM1Iv/pkmxJupl1Uy5H7fz+dBy+VyTDnV6cDj0XsQ
         ZTU5yZdTGKEoXHi1rvM7JRozCWvMYkJbOzVwjLF02CSXWD6y0hDSst8lblSMFtGbptgF
         hi3doqI3y6HsFiSEpUJRCaVvG+kShY9rhBKxttRwvxnk1WgImSjuBxsnLjPDYjsbbz7P
         WpZuqe83DB9/yH18NDhhQLuXwXqrrmFjN9aZZUlc1vUC4umyi61FZ8Oz5JC8kEbcImdD
         IHDD4rCaOJYNoaowNgITdnbRlhcsl78MMEnU+WzFSHYA3Bj+xUiOjQUIQ7GTwaBM0+Vh
         r1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/EVIv/9CZTu8F4lKjgKh6a8dtu5zA1i+E/pDvfo4hlg=;
        b=MEG4qLFY/kgeuUkdj7S3kOFiySSKN+vRrNtxxMpuWBkJB5VfvnqEt0624lLhCzdnt1
         1XJm4HXs3lzvsX6l/q+JYVlene2pFQuiL5UT+tI6RShUIfLmDPzOJdCSS7x54e2FnQm4
         uG+QcqmQYUh6dPBqafHtcR0NQqpAaQCBeYs9nTfHdVZDRfYpU/OGaDHOZJjL5eGba0tL
         QdsZOlVzJLGVzZaGWTkaMZLrOZae0RwrI/81zTc5JUAHy6pSYm4aMlfi/X4trS5eVzm+
         1+V6622YcotEUlkcVlwQfGON8rMuPp+wI6N0Rwf90V6HpQDUPgRkcR4qfP1XJ3oF9ILf
         ecFA==
X-Gm-Message-State: AOAM531/IXr7CdBW4o2I+nxYmwTQBJD3cWzPGq5rj4I5FxlFYNCfvX/t
        6AJ8SerQxqKtrhCCZyx1y87527VSQiUEr/XpPxOCJA==
X-Google-Smtp-Source: ABdhPJzCDuRwDRI99yqqvfQrZmhDnGagNTIez9NJb8UBT5MVHcHFvsRMRynjNYzj/aWuz2Aui5NUW0e3p/S+Nq3sGb8=
X-Received: by 2002:a5d:6146:0:b0:20d:d42:e954 with SMTP id
 y6-20020a5d6146000000b0020d0d42e954mr8984842wrt.372.1653063567330; Fri, 20
 May 2022 09:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com> <926b21ee-58e8-18b1-3d60-148d02f1c17a@fb.com>
In-Reply-To: <926b21ee-58e8-18b1-3d60-148d02f1c17a@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 20 May 2022 09:18:51 -0700
Message-ID: <CAJD7tka1HLqyyomPN=a+RW9Z0S9TrNLhbc+tYDwEgDa1rwYggw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
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
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
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

On Fri, May 20, 2022 at 9:09 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> > Add a selftest that tests the whole workflow for collecting,
> > aggregating, and display cgroup hierarchical stats.
> >
> > TL;DR:
> > - Whenever reclaim happens, vmscan_start and vmscan_end update
> >    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> >    have updates.
> > - When userspace tries to read the stats, vmscan_dump calls rstat to flush
> >    the stats.
> > - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> >    updates, vmscan_flush aggregates cpu readings and propagates updates
> >    to parents.
> >
> > Detailed explanation:
> > - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> >    measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
> >    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> >    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> >    rstat updated tree on that cpu.
> >
> > - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> >    each cgroup. Reading this file invokes the program, which calls
> >    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
> >    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
> >    the stats are exposed to the user.
> >
> > - An ftrace program, vmscan_flush, is also loaded and attached to
> >    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
> >    once for each (cgroup, cpu) pair that has updates. cgroups are popped
> >    from the rstat tree in a bottom-up fashion, so calls will always be
> >    made for cgroups that have updates before their parents. The program
> >    aggregates percpu readings to a total per-cgroup reading, and also
> >    propagates them to the parent cgroup. After rstat flushing is over, all
> >    cgroups will have correct updated hierarchical readings (including all
> >    cpus and all their descendants).
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   .../test_cgroup_hierarchical_stats.c          | 339 ++++++++++++++++++
> >   tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
> >   .../selftests/bpf/progs/cgroup_vmscan.c       | 221 ++++++++++++
> >   3 files changed, 567 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > new file mode 100644
> > index 000000000000..e560c1f6291f
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > @@ -0,0 +1,339 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Functions to manage eBPF programs attached to cgroup subsystems
> > + *
> > + * Copyright 2022 Google LLC.
> > + */
> > +#include <errno.h>
> > +#include <sys/types.h>
> > +#include <sys/mount.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > +
> > +#include <bpf/libbpf.h>
> > +#include <bpf/bpf.h>
> > +#include <test_progs.h>
> > +
> > +#include "cgroup_helpers.h"
> > +#include "cgroup_vmscan.skel.h"
> > +
> > +#define PAGE_SIZE 4096
> > +#define MB(x) (x << 20)
> > +
> > +#define BPFFS_ROOT "/sys/fs/bpf/"
> > +#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
> > +
> > +#define CG_ROOT_NAME "root"
> > +#define CG_ROOT_ID 1
> > +
> > +#define CGROUP_PATH(p, n) {.name = #n, .path = #p"/"#n}
> > +
> > +static struct {
> > +     const char *name, *path;
> > +     unsigned long long id;
> > +     int fd;
> > +} cgroups[] = {
> > +     CGROUP_PATH(/, test),
> > +     CGROUP_PATH(/test, child1),
> > +     CGROUP_PATH(/test, child2),
> > +     CGROUP_PATH(/test/child1, child1_1),
> > +     CGROUP_PATH(/test/child1, child1_2),
> > +     CGROUP_PATH(/test/child2, child2_1),
> > +     CGROUP_PATH(/test/child2, child2_2),
> > +};
> > +
> > +#define N_CGROUPS ARRAY_SIZE(cgroups)
> > +#define N_NON_LEAF_CGROUPS 3
> > +
> > +bool mounted_bpffs;
> > +static int duration;
> > +
> > +static int read_from_file(const char *path, char *buf, size_t size)
> > +{
> > +     int fd, len;
> > +
> > +     fd = open(path, O_RDONLY);
> > +     if (fd < 0) {
> > +             log_err("Open %s", path);
> > +             return -errno;
> > +     }
> > +     len = read(fd, buf, size);
> > +     if (len < 0)
> > +             log_err("Read %s", path);
> > +     else
> > +             buf[len] = 0;
> > +     close(fd);
> > +     return len < 0 ? -errno : 0;
> > +}
> > +
> > +static int setup_bpffs(void)
> > +{
> > +     int err;
> > +
> > +     /* Mount bpffs */
> > +     err = mount("bpf", BPFFS_ROOT, "bpf", 0, NULL);
> > +     mounted_bpffs = !err;
> > +     if (CHECK(err && errno != EBUSY, "mount bpffs",
>
> Please use ASSERT_* macros instead of CHECK.
> There are similar instances below as well.

CHECK is more flexible in providing a parameterized failure message,
but I guess we ideally shouldn't see those a lot anyway. Will change
them to ASSERTs in the next version.

>
> > +           "failed to mount bpffs at %s (%s)\n", BPFFS_ROOT,
> > +           strerror(errno)))
> > +             return err;
> > +
> > +     /* Create a directory to contain stat files in bpffs */
> > +     err = mkdir(BPFFS_VMSCAN, 0755);
> > +     CHECK(err, "mkdir bpffs", "failed to mkdir %s (%s)\n",
> > +           BPFFS_VMSCAN, strerror(errno));
> > +     return err;
> > +}
> > +
> > +static void cleanup_bpffs(void)
> > +{
> > +     /* Remove created directory in bpffs */
> > +     CHECK(rmdir(BPFFS_VMSCAN), "rmdir", "failed to rmdir %s (%s)\n",
> > +           BPFFS_VMSCAN, strerror(errno));
> > +
> > +     /* Unmount bpffs, if it wasn't already mounted when we started */
> > +     if (mounted_bpffs)
> > +             return;
> > +     CHECK(umount(BPFFS_ROOT), "umount", "failed to unmount bpffs (%s)\n",
> > +           strerror(errno));
> > +}
> > +
> > +static int setup_cgroups(void)
> > +{
> > +     int i, err;
> > +
> > +     err = setup_cgroup_environment();
> > +     if (CHECK(err, "setup_cgroup_environment", "failed: %d\n", err))
> > +             return err;
> > +
> > +     for (i = 0; i < N_CGROUPS; i++) {
> > +             int fd;
>
> You can put this to the top declaration 'int i, err'.

Will do in the next version. I thought declaring variables in the
innermost block that uses them is preferable.

>
> > +
> > +             fd = create_and_get_cgroup(cgroups[i].path);
> > +             if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> > +                     return fd;
> > +
> > +             cgroups[i].fd = fd;
> > +             cgroups[i].id = get_cgroup_id(cgroups[i].path);
> > +             if (i < N_NON_LEAF_CGROUPS) {
> > +                     err = enable_controllers(cgroups[i].path, "memory");
> > +                     if (!ASSERT_OK(err, "enable_controllers"))
> > +                             return err;
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> > +static void cleanup_cgroups(void)
> > +{
> > +     for (int i = 0; i < N_CGROUPS; i++)
> > +             close(cgroups[i].fd);
> > +     cleanup_cgroup_environment();
> > +}
> > +
> > +
> > +static int setup_hierarchy(void)
> > +{
> > +     return setup_bpffs() || setup_cgroups();
> > +}
> > +
> > +static void destroy_hierarchy(void)
> > +{
> > +     cleanup_cgroups();
> > +     cleanup_bpffs();
> > +}
> > +
> [...]
> > +
> > +SEC("iter.s/cgroup")
> > +int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp)
> > +{
> > +     struct seq_file *seq = meta->seq;
> > +     struct vmscan *total_stat;
> > +     __u64 cg_id = cgroup_id(cgrp);
> > +
> > +     /* Flush the stats to make sure we get the most updated numbers */
> > +     cgroup_rstat_flush(cgrp);
> > +
> > +     total_stat = bpf_map_lookup_elem(&cgroup_vmscan_elapsed, &cg_id);
> > +     if (!total_stat) {
> > +             bpf_printk("error finding stats for cgroup %llu\n", cg_id);
> > +             BPF_SEQ_PRINTF(seq, "cg_id: -1, total_vmscan_delay: -1\n");
> > +             return 0;
> > +     }
> > +     BPF_SEQ_PRINTF(seq, "cg_id: %llu, total_vmscan_delay: %llu\n",
> > +                    cg_id, total_stat->state);
> > +     return 0;
> > +}
> > +
>
> Empty line here.

Will remove this in the next version.
Thanks for taking a look at this!

>
