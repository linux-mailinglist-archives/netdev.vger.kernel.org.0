Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823E3531F83
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiEXABq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 20:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiEXABn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:01:43 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0753CFDC;
        Mon, 23 May 2022 17:01:40 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id bs5so7817618vkb.4;
        Mon, 23 May 2022 17:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HrtcpWdVQSaL1bI1SDaUpH9VoRVNHhuKz/vKH4t9i+c=;
        b=jXGbJX0l/dIPktiRmVJl1Zpn2s0E4aBwHkWTyz+v/R1OArc1PooysjcVoamTmv+zr3
         TyDgazy1w2zdhobRpQwqJ3s+CyrwiX8XalPHAI64SU5L0AxXQODfhuIlgwc8rfckQqTq
         zDUsmZOSZlQPE2s33E7ydsCkKhHBZaVl69k4Z3hs01FLGOplve0wjstiau8WpD0CBNKA
         ZrZcOE/jIwqAZsOVSrD5wjfMEAVySXpnW/0rEcEydUbkRt0S4V9L7VaAlFH1SRk9fqHD
         vcOkzw9sG0qSwywyDtsx3HiMRRGccADPP2VbXB0QyDTT16hpBiySBkY9HzCMw4nhQQYG
         PM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HrtcpWdVQSaL1bI1SDaUpH9VoRVNHhuKz/vKH4t9i+c=;
        b=D652u9mTNYiN6BPWGkGHcObDTdSiPAIqxglUbYjWHwrdlz6yNCV0bsitjriBUw7wXC
         QFqm3lpGffUwFVVuVdM5dcccvKgPEJUNRSu/S9EgG2v3/MrfUJxpDRdq/p2kw7O3T8zg
         MPtZR3C4+nWuVx9U0tT1GVZwWSVj250C36tZbXwZXtdTmHSFcdoqJpTS/nsNe+Qtiz8U
         STBoplVlJa50RQTC0Lsr3uJa0X6CtMnegLowTG/1sxEk6zWGH/g1LlwbZlpWAEuww/Pn
         vJf/3U1ILikcHbEwdYwdomzI3/7VO6xoIDGQ8GvKjhltjqC8XiLrEQKBThqnt720tpYs
         OMKQ==
X-Gm-Message-State: AOAM5333qBG0cHWBUgEO3NqkC5CWzmAcbyAZqgK3iVqZZVq4gtfEatP7
        mQof/xm++hHV6/ee+G3/yanGMSXQMk6m4kMeFP8=
X-Google-Smtp-Source: ABdhPJy0E1dIz8uGd/vXactXta+C8vjba64UBrQHO94e9z1/vPaCwKR4+57rUI87a0x6IX1U1CCdg4U7DFJ6yAZkFkE=
X-Received: by 2002:a1f:9f05:0:b0:357:a818:6ac8 with SMTP id
 i5-20020a1f9f05000000b00357a8186ac8mr2631207vke.16.1653350499682; Mon, 23 May
 2022 17:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com> <926b21ee-58e8-18b1-3d60-148d02f1c17a@fb.com>
 <CAJD7tka1HLqyyomPN=a+RW9Z0S9TrNLhbc+tYDwEgDa1rwYggw@mail.gmail.com>
In-Reply-To: <CAJD7tka1HLqyyomPN=a+RW9Z0S9TrNLhbc+tYDwEgDa1rwYggw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 17:01:28 -0700
Message-ID: <CAEf4BzaSadEhRDgLXtsAoezJEF0WqqBBJq5rXRapq_8ABb-s+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 9:19 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Fri, May 20, 2022 at 9:09 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> > > Add a selftest that tests the whole workflow for collecting,
> > > aggregating, and display cgroup hierarchical stats.
> > >
> > > TL;DR:
> > > - Whenever reclaim happens, vmscan_start and vmscan_end update
> > >    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> > >    have updates.
> > > - When userspace tries to read the stats, vmscan_dump calls rstat to flush
> > >    the stats.
> > > - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> > >    updates, vmscan_flush aggregates cpu readings and propagates updates
> > >    to parents.
> > >
> > > Detailed explanation:
> > > - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> > >    measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
> > >    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> > >    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> > >    rstat updated tree on that cpu.
> > >
> > > - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> > >    each cgroup. Reading this file invokes the program, which calls
> > >    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
> > >    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
> > >    the stats are exposed to the user.
> > >
> > > - An ftrace program, vmscan_flush, is also loaded and attached to
> > >    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
> > >    once for each (cgroup, cpu) pair that has updates. cgroups are popped
> > >    from the rstat tree in a bottom-up fashion, so calls will always be
> > >    made for cgroups that have updates before their parents. The program
> > >    aggregates percpu readings to a total per-cgroup reading, and also
> > >    propagates them to the parent cgroup. After rstat flushing is over, all
> > >    cgroups will have correct updated hierarchical readings (including all
> > >    cpus and all their descendants).
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > ---
> > >   .../test_cgroup_hierarchical_stats.c          | 339 ++++++++++++++++++
> > >   tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
> > >   .../selftests/bpf/progs/cgroup_vmscan.c       | 221 ++++++++++++
> > >   3 files changed, 567 insertions(+)
> > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > >   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > > new file mode 100644
> > > index 000000000000..e560c1f6291f
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
> > > @@ -0,0 +1,339 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Functions to manage eBPF programs attached to cgroup subsystems
> > > + *
> > > + * Copyright 2022 Google LLC.
> > > + */
> > > +#include <errno.h>
> > > +#include <sys/types.h>
> > > +#include <sys/mount.h>
> > > +#include <sys/stat.h>
> > > +#include <unistd.h>
> > > +
> > > +#include <bpf/libbpf.h>
> > > +#include <bpf/bpf.h>
> > > +#include <test_progs.h>
> > > +
> > > +#include "cgroup_helpers.h"
> > > +#include "cgroup_vmscan.skel.h"
> > > +
> > > +#define PAGE_SIZE 4096
> > > +#define MB(x) (x << 20)
> > > +
> > > +#define BPFFS_ROOT "/sys/fs/bpf/"
> > > +#define BPFFS_VMSCAN BPFFS_ROOT"vmscan/"
> > > +
> > > +#define CG_ROOT_NAME "root"
> > > +#define CG_ROOT_ID 1
> > > +
> > > +#define CGROUP_PATH(p, n) {.name = #n, .path = #p"/"#n}
> > > +
> > > +static struct {
> > > +     const char *name, *path;
> > > +     unsigned long long id;
> > > +     int fd;
> > > +} cgroups[] = {
> > > +     CGROUP_PATH(/, test),
> > > +     CGROUP_PATH(/test, child1),
> > > +     CGROUP_PATH(/test, child2),
> > > +     CGROUP_PATH(/test/child1, child1_1),
> > > +     CGROUP_PATH(/test/child1, child1_2),
> > > +     CGROUP_PATH(/test/child2, child2_1),
> > > +     CGROUP_PATH(/test/child2, child2_2),
> > > +};
> > > +
> > > +#define N_CGROUPS ARRAY_SIZE(cgroups)
> > > +#define N_NON_LEAF_CGROUPS 3
> > > +
> > > +bool mounted_bpffs;
> > > +static int duration;
> > > +
> > > +static int read_from_file(const char *path, char *buf, size_t size)
> > > +{
> > > +     int fd, len;
> > > +
> > > +     fd = open(path, O_RDONLY);
> > > +     if (fd < 0) {
> > > +             log_err("Open %s", path);
> > > +             return -errno;
> > > +     }
> > > +     len = read(fd, buf, size);
> > > +     if (len < 0)
> > > +             log_err("Read %s", path);
> > > +     else
> > > +             buf[len] = 0;
> > > +     close(fd);
> > > +     return len < 0 ? -errno : 0;
> > > +}
> > > +
> > > +static int setup_bpffs(void)
> > > +{
> > > +     int err;
> > > +
> > > +     /* Mount bpffs */
> > > +     err = mount("bpf", BPFFS_ROOT, "bpf", 0, NULL);
> > > +     mounted_bpffs = !err;
> > > +     if (CHECK(err && errno != EBUSY, "mount bpffs",
> >
> > Please use ASSERT_* macros instead of CHECK.
> > There are similar instances below as well.
>
> CHECK is more flexible in providing a parameterized failure message,
> but I guess we ideally shouldn't see those a lot anyway. Will change
> them to ASSERTs in the next version.

The idea with ASSERT_xxx() is that you express semantically meaningful
assertion/condition/check and the macro provides helpful and
meaningful information for you. E.g., ASSERT_EQ(bla, 123, "bla_value")
will emit something along the lines: "unexpected value of 'bla_value':
345, expected 123". It provides useful info when check fails without
requiring to type all the extra format strings and parameters.

And also CHECK() has an inverted condition which is extremely
confusing. We don't use CHECK() for new code anymore.

>
> >
> > > +           "failed to mount bpffs at %s (%s)\n", BPFFS_ROOT,
> > > +           strerror(errno)))
> > > +             return err;
> > > +
> > > +     /* Create a directory to contain stat files in bpffs */
> > > +     err = mkdir(BPFFS_VMSCAN, 0755);
> > > +     CHECK(err, "mkdir bpffs", "failed to mkdir %s (%s)\n",
> > > +           BPFFS_VMSCAN, strerror(errno));
> > > +     return err;
> > > +}
> > > +

[...]
