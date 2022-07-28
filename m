Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2E658485E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 00:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiG1Wk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 18:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiG1Wk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 18:40:28 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8274D807;
        Thu, 28 Jul 2022 15:40:26 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id fy29so5456979ejc.12;
        Thu, 28 Jul 2022 15:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hU+tIyCTCzDGpvGficmypC59ILjihDtg8eubpS2MB+M=;
        b=ctkKq/5RCTBxi7b2hC6U/JxbSKhpTStnC3sxwMCoIKiqqLX3iHl+Mjod+x+5GWrlPN
         uOpbCuVMRDbn8VF8tARoHGys42Rwb5GLbomrWHrXoNmhWVxSl4InKrDWqIVJ+1L1fdFc
         TVYTN4qbapIYjn/0aepYmiuZawoscrUp6QUgZPDd7a3bNFrPG0lE1J4WRoFsmUlcGSDa
         sXQ9x1FPOapV2tfze3rbwEOXmSfsbNOkQ7y9FEfofkRjYsndo/09VgGjgcnmnVj527Bg
         r0jnZoqYkQq/JqaVh6Xolxu334GPphoza6TH/spkuqrNCRzePL2KnxjabyZSkdgKzvNV
         lh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hU+tIyCTCzDGpvGficmypC59ILjihDtg8eubpS2MB+M=;
        b=VTGNDi+4Ks8rW8S18GRL9MbXlomFS5ixpUbex4xX8Cke76IGCCatQkdoidIt61tlDf
         xXAzllJRJ+hshtr9i+t6QCc/0JhdQ4nWvdv2BUz1UNNPQIdciP1wKVTqyOvF+TVVzTqS
         pJUwZTSeSZvCIPfErBhK7M2c2pjtTVDRPqeMaq4FoY+JLcLlp/FiaAVJIS94NwuiWBUj
         1pjpR++lUJQ3SF/HU7tukxGkpC6bXD561P2HUTHaDgTf5ehHVASV22+MWflIR86L01jO
         IBM29BIqMGE+1CVR3dLxcPG1o8G02jjLaO9D9W1rODIjzaQfq32s9BPDup/bYYYktZ9S
         ejsA==
X-Gm-Message-State: AJIora+Fv+vXktXmQxXO6aee+EXJD6xikW0xxBlWKbBqystGl/BaP6zW
        CK0CEk4yxESy/aFa19KzSyiU9O83y7nZ5iJ4PFs=
X-Google-Smtp-Source: AGRyM1uGomf9rVmJXR5SvFm/ATqlV9ugG14sJmJGwpO1tDoEZ2kp6PTiSt55dmdYCeSZp6mmQkl0FMltt+ilDW+4ZqQ=
X-Received: by 2002:a17:907:2808:b0:72b:4d49:b2e9 with SMTP id
 eb8-20020a170907280800b0072b4d49b2e9mr787212ejc.176.1659048024178; Thu, 28
 Jul 2022 15:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com> <20220722174829.3422466-9-yosryahmed@google.com>
In-Reply-To: <20220722174829.3422466-9-yosryahmed@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Jul 2022 15:40:12 -0700
Message-ID: <CAEf4BzZQwMeJ5xfzEWWRcTf1Hick862x2qSZ3O0DX47Q++2-4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
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
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
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

On Fri, Jul 22, 2022 at 10:49 AM Yosry Ahmed <yosryahmed@google.com> wrote:
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
> ---
>  .../prog_tests/cgroup_hierarchical_stats.c    | 364 ++++++++++++++++++
>  .../bpf/progs/cgroup_hierarchical_stats.c     | 239 ++++++++++++
>  2 files changed, 603 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> new file mode 100644
> index 000000000000..1eafd94af4fe
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> @@ -0,0 +1,364 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Functions to manage eBPF programs attached to cgroup subsystems
> + *
> + * Copyright 2022 Google LLC.
> + */
> +#include <errno.h>
> +#include <sys/types.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/bpf.h>
> +
> +#include "cgroup_helpers.h"
> +#include "cgroup_hierarchical_stats.skel.h"
> +
> +#define PAGE_SIZE 4096
> +#define MB(x) (x << 20)
> +
> +#define BPFFS_ROOT "/sys/fs/bpf/"
> +#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
> +
> +#define CG_ROOT_NAME "root"
> +#define CG_ROOT_ID 1
> +
> +#define CGROUP_PATH(p, n) {.path = #p"/"#n, .name = #n}
> +
> +static struct {
> +       const char *path, *name;
> +       unsigned long long id;
> +       int fd;
> +} cgroups[] = {
> +       CGROUP_PATH(/, test),
> +       CGROUP_PATH(/test, child1),
> +       CGROUP_PATH(/test, child2),
> +       CGROUP_PATH(/test/child1, child1_1),
> +       CGROUP_PATH(/test/child1, child1_2),
> +       CGROUP_PATH(/test/child2, child2_1),
> +       CGROUP_PATH(/test/child2, child2_2),

nit: why are these arguments not explicit string literals?...
CGROUP_PATH("/test/child1", "child1_1") explicitly shows that those
values are used as strings

> +};
> +
> +#define N_CGROUPS ARRAY_SIZE(cgroups)
> +#define N_NON_LEAF_CGROUPS 3
> +
> +int root_cgroup_fd;
> +bool mounted_bpffs;
> +

static?

> +static int read_from_file(const char *path, char *buf, size_t size)
> +{
> +       int fd, len;
> +
> +       fd = open(path, O_RDONLY);
> +       if (fd < 0) {
> +               log_err("Open %s", path);
> +               return 1;
> +       }
> +       len = read(fd, buf, size);
> +       if (len < 0)
> +               log_err("Read %s", path);
> +       else
> +               buf[len] = 0;
> +       close(fd);
> +       return len < 0;
> +}
> +

[...]

> +       /* Also dump stats for root */
> +       err = setup_cgroup_iter(obj, root_cgroup_fd, CG_ROOT_NAME);
> +       if (!ASSERT_OK(err, "setup_cgroup_iter"))
> +               return err;
> +
> +       /* Attach rstat flusher */
> +       link = bpf_program__attach(obj->progs.vmscan_flush);
> +       if (!ASSERT_OK_PTR(link, "attach rstat"))
> +               return libbpf_get_error(link);

this is dangerous, because ASSERT_OK_PTR might overwrite errno by the
time we get to libbpf_get_error() call. link is NULL and
libbpf_get_error() extracts error from errno. It's best to just return
fixed error code here, or otherwise you'd need to remember err before
ASSERT_OK_PTR() call.

> +       obj->links.vmscan_flush = link;
> +
> +       /* Attach tracing programs that will calculate vmscan delays */
> +       link = bpf_program__attach(obj->progs.vmscan_start);
> +       if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
> +               return libbpf_get_error(link);
> +       obj->links.vmscan_start = link;
> +
> +       link = bpf_program__attach(obj->progs.vmscan_end);
> +       if (!ASSERT_OK_PTR(obj, "attach raw_tracepoint"))
> +               return libbpf_get_error(link);
> +       obj->links.vmscan_end = link;
> +
> +       *skel = obj;
> +       return 0;
> +}
> +
> +void destroy_progs(struct cgroup_hierarchical_stats *skel)

static?

> +{
> +       char path[128];
> +       int i;
> +
> +       for (i = 0; i < N_CGROUPS; i++) {
> +               /* Delete files in bpffs that cgroup_iters are pinned in */
> +               snprintf(path, 128, "%s%s", BPFFS_VMSCAN,
> +                        cgroups[i].name);
> +               ASSERT_OK(remove(path), "remove cgroup_iter pin");
> +       }
> +
> +       /* Delete root file in bpffs */
> +       snprintf(path, 128, "%s%s", BPFFS_VMSCAN, CG_ROOT_NAME);
> +       ASSERT_OK(remove(path), "remove cgroup_iter root pin");
> +       cgroup_hierarchical_stats__destroy(skel);
> +}
> +
> +void test_cgroup_hierarchical_stats(void)
> +{
> +       struct cgroup_hierarchical_stats *skel = NULL;
> +
> +       if (setup_hierarchy())
> +               goto hierarchy_cleanup;
> +       if (setup_progs(&skel))
> +               goto cleanup;
> +       if (induce_vmscan())
> +               goto cleanup;
> +       check_vmscan_stats();
> +cleanup:
> +       destroy_progs(skel);
> +hierarchy_cleanup:
> +       destroy_hierarchy();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> new file mode 100644
> index 000000000000..85a65a72482e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> @@ -0,0 +1,239 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Functions to manage eBPF programs attached to cgroup subsystems
> + *
> + * Copyright 2022 Google LLC.
> + */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +/*
> + * Start times are stored per-task, not per-cgroup, as multiple tasks in one
> + * cgroup can perform reclain concurrently.

typo: reclaim?

> + */
> +struct {
> +       __uint(type, BPF_MAP_TYPE_TASK_STORAGE);
> +       __uint(map_flags, BPF_F_NO_PREALLOC);
> +       __type(key, int);
> +       __type(value, __u64);
> +} vmscan_start_time SEC(".maps");
> +

[...]

> +static inline int create_vmscan_percpu_elem(__u64 cg_id, __u64 state)
> +{
> +       struct vmscan_percpu pcpu_init = {.state = state, .prev = 0};
> +       int err;
> +
> +       err = bpf_map_update_elem(&pcpu_cgroup_vmscan_elapsed, &cg_id,
> +                                 &pcpu_init, BPF_NOEXIST);
> +       if (err) {
> +               bpf_printk("failed to create pcpu entry for cgroup %llu: %d\n"
> +                          , cg_id, err);
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +static inline int create_vmscan_elem(__u64 cg_id, __u64 state, __u64 pending)

all those inlines above are not necessary, they don't have to be
actually inlined, right?

> +{
> +       struct vmscan init = {.state = state, .pending = pending};
> +       int err;
> +
> +       err = bpf_map_update_elem(&cgroup_vmscan_elapsed, &cg_id,
> +                                 &init, BPF_NOEXIST);
> +       if (err) {
> +               bpf_printk("failed to create entry for cgroup %llu: %d\n"
> +                          , cg_id, err);
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +SEC("tp_btf/mm_vmscan_memcg_reclaim_begin")
> +int BPF_PROG(vmscan_start, int order, gfp_t gfp_flags)
> +{
> +       struct task_struct *task = bpf_get_current_task_btf();
> +       __u64 *start_time_ptr;
> +
> +       start_time_ptr = bpf_task_storage_get(&vmscan_start_time, task, 0,
> +                                         BPF_LOCAL_STORAGE_GET_F_CREATE);
> +       if (!start_time_ptr) {
> +               bpf_printk("error retrieving storage\n");

does user-space part read these trace_printk messages? If not, let's
remove them from the test

> +               return 0;
> +       }
> +
> +       *start_time_ptr = bpf_ktime_get_ns();
> +       return 0;
> +}
> +

[...]
