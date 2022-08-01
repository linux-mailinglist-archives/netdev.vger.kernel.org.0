Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC43158741D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 00:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiHAW4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 18:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiHAWz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 18:55:58 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEAD29836
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 15:55:55 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id c24so9515933qkm.4
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 15:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C5gulj3V+LjVOIWRA41K2fBbqvQq1arjIETo1B+W8Bc=;
        b=AvaU/i6IarMIHH8auej+84EEnlucOm6JPsbblnmJsKfFSucB0wbidIBB9ImaoESPuy
         D/vBYWruOWw+txPsHm4S1q/DyUBkvWFghGHvWwre5vgzRWy5XumhQbW4R68er0hrzV2C
         FQ1LAn2CTfvRwIB87bZM1HRFEAck2joY9DuICCp38Khk74qg5BlXOm/YrKr/0vPDdp67
         y55BhBcB1o3ow6/CoLlBtqbUX4T1g7vDBMDuUfkU61w3X1Answ8BhsyYBmVCDvh9fip8
         BmERpPLyRVAB9KcgcuVZbXY+J0fZggzlxmmixfr1NUAwO3k8ScFlbII7wwwMh79rpQcT
         HHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C5gulj3V+LjVOIWRA41K2fBbqvQq1arjIETo1B+W8Bc=;
        b=lkC7vLnx4j0UIh1lp/3QxUlvdqHZ9nDXKwrmy4sYtgr9uVYTdG6B3Mg2OXi6e31EfX
         4L4NO5Td9nCS37serx1FlP+AE9KZw+1qBZroNbwqCyPPPl+1i0fPsA8myAuOEO6CUPbO
         xFLq9U812349zcVKJ6TcPgOArAMmhIcPOQ82O/8M9CDS+hzzyr/UAx0ySsumVBh9FO2O
         7yh2DH3mKYCLPCOb75b1tc7Iloji7gVLHpnahHaWk2r3GYRaEnFLgZ5dBakRmB/1tXck
         HsMgXIvrCHZ7ubQSudWMK5/muE9RiWF2ePvbjy7tonJSx3xlTEyRWjwL3gzJSatWBJFl
         Ntlw==
X-Gm-Message-State: AJIora9WVPIjl6yZFWy9ijDXg7Dc76SH2fCVMxvdtZtHam7syNxNvZbK
        IwByTjZbBKT6QwdOFtSmK2gzwKaL1zgEUCAV/NRSjg==
X-Google-Smtp-Source: AGRyM1tQWSH4FHcIXB/c1Om86xADkwc7GvPByRKGk241cmYYjcVU0Tb3fJawlIkwsscnpXTkE4OTfz6uJf2hwZwkTnY=
X-Received: by 2002:a05:620a:4590:b0:6b5:e884:2d2c with SMTP id
 bp16-20020a05620a459000b006b5e8842d2cmr13691502qkb.267.1659394554140; Mon, 01
 Aug 2022 15:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-6-haoluo@google.com>
 <CAEf4Bzbdz7=Cg-87G2tak1Mr=1wJkqr6g2d=dkHqu0YH+j2unA@mail.gmail.com>
In-Reply-To: <CAEf4Bzbdz7=Cg-87G2tak1Mr=1wJkqr6g2d=dkHqu0YH+j2unA@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 1 Aug 2022 15:55:43 -0700
Message-ID: <CA+khW7jiW=oAHS-N1ADLbqB74jTwAaLqUFFvYgb4xTz9WFwtZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/8] selftests/bpf: Test cgroup_iter.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 2:51 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo@google.com> wrote:
> >
> > Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> > of the following structure:
> >
> >     ROOT (working cgroup)
> >      |
> >    PARENT
> >   /      \
> > CHILD1  CHILD2
> >
> > and tests the following scenarios:
> >
> >  - invalid cgroup fd.
> >  - pre-order walk over descendants from PARENT.
> >  - post-order walk over descendants from PARENT.
> >  - walk of ancestors from PARENT.
> >  - early termination.
> >
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >  .../selftests/bpf/prog_tests/cgroup_iter.c    | 193 ++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
> >  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++++
> >  3 files changed, 239 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> > new file mode 100644
> > index 000000000000..5dc843a3f507
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> > @@ -0,0 +1,193 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2022 Google */
> > +
> > +#include <test_progs.h>
> > +#include <bpf/libbpf.h>
> > +#include <bpf/btf.h>
> > +#include "cgroup_iter.skel.h"
> > +#include "cgroup_helpers.h"
> > +
> > +#define ROOT           0
> > +#define PARENT         1
> > +#define CHILD1         2
> > +#define CHILD2         3
> > +#define NUM_CGROUPS    4
> > +
> > +#define PROLOGUE       "prologue\n"
> > +#define EPILOGUE       "epilogue\n"
> > +
> > +#define format_expected_output1(cg_id1) \
> > +       snprintf(expected_output, sizeof(expected_output), \
> > +                PROLOGUE "%8llu\n" EPILOGUE, (cg_id1))
> > +
> > +#define format_expected_output2(cg_id1, cg_id2) \
> > +       snprintf(expected_output, sizeof(expected_output), \
> > +                PROLOGUE "%8llu\n%8llu\n" EPILOGUE, \
> > +                (cg_id1), (cg_id2))
> > +
> > +#define format_expected_output3(cg_id1, cg_id2, cg_id3) \
> > +       snprintf(expected_output, sizeof(expected_output), \
> > +                PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE, \
> > +                (cg_id1), (cg_id2), (cg_id3))
> > +
>
> you use format_expected_output{1,2} just once and
> format_expected_output3 twice. Is it worth defining macros for that?
>

If not, we'd see this snprintf and format all over the place. It looks
worse than the current one I think, prefer leave as-is.

> > +const char *cg_path[] = {
> > +       "/", "/parent", "/parent/child1", "/parent/child2"
> > +};
> > +
> > +static int cg_fd[] = {-1, -1, -1, -1};
> > +static unsigned long long cg_id[] = {0, 0, 0, 0};
> > +static char expected_output[64];
> > +
> > +int setup_cgroups(void)
> > +{
> > +       int fd, i = 0;
> > +
> > +       for (i = 0; i < NUM_CGROUPS; i++) {
> > +               fd = create_and_get_cgroup(cg_path[i]);
> > +               if (fd < 0)
> > +                       return fd;
> > +
> > +               cg_fd[i] = fd;
> > +               cg_id[i] = get_cgroup_id(cg_path[i]);
> > +       }
> > +       return 0;
> > +}
> > +
> > +void cleanup_cgroups(void)
>
> some more statics to cover (same for setup_cgroups)
>

Oops. Will fix.

> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < NUM_CGROUPS; i++)
> > +               close(cg_fd[i]);
> > +}
> > +
> > +static void read_from_cgroup_iter(struct bpf_program *prog, int cgroup_fd,
> > +                                 int order, const char *testname)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> > +       union bpf_iter_link_info linfo;
> > +       struct bpf_link *link;
> > +       int len, iter_fd;
> > +       static char buf[64];
> > +
> > +       memset(&linfo, 0, sizeof(linfo));
> > +       linfo.cgroup.cgroup_fd = cgroup_fd;
> > +       linfo.cgroup.traversal_order = order;
> > +       opts.link_info = &linfo;
> > +       opts.link_info_len = sizeof(linfo);
> > +
> > +       link = bpf_program__attach_iter(prog, &opts);
> > +       if (!ASSERT_OK_PTR(link, "attach_iter"))
> > +               return;
> > +
> > +       iter_fd = bpf_iter_create(bpf_link__fd(link));
> > +       if (iter_fd < 0)
> > +               goto free_link;
> > +
> > +       memset(buf, 0, sizeof(buf));
> > +       while ((len = read(iter_fd, buf, sizeof(buf))) > 0)
> > +               ;
>
> this is broken, in general, you are overriding buffer content with
> each call to len
>
> I think you intended to advance buf after each read() call (and reduce
> remaining available buf size)?
>

Ah. My bad. Copied from bpf_iter but didn't realize that in the
bpf_iter case, it didn't care about the content read from buffer. Will
fix.

> > +
> > +       ASSERT_STREQ(buf, expected_output, testname);
> > +
> > +       /* read() after iter finishes should be ok. */
> > +       if (len == 0)
> > +               ASSERT_OK(read(iter_fd, buf, sizeof(buf)), "second_read");
> > +
> > +       close(iter_fd);
> > +free_link:
> > +       bpf_link__destroy(link);
> > +}
> > +
> > +/* Invalid cgroup. */
> > +static void test_invalid_cgroup(struct cgroup_iter *skel)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> > +       union bpf_iter_link_info linfo;
> > +       struct bpf_link *link;
> > +
> > +       memset(&linfo, 0, sizeof(linfo));
> > +       linfo.cgroup.cgroup_fd = (__u32)-1;
> > +       opts.link_info = &linfo;
> > +       opts.link_info_len = sizeof(linfo);
> > +
> > +       link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
> > +       if (!ASSERT_ERR_PTR(link, "attach_iter"))
> > +               bpf_link__destroy(link);
>
> nit: you can call bpf_link__destroy() even if link is NULL or IS_ERR
>

Ack. Still need to ASSERT on 'link' though, so the saving is probably
just an indentation. Anyway, will change.

> > +}
> > +
>
> [...]
>
> > diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter.c b/tools/testing/selftests/bpf/progs/cgroup_iter.c
> > new file mode 100644
> > index 000000000000..2a34d146d6df
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/cgroup_iter.c
> > @@ -0,0 +1,39 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2022 Google */
> > +
> > +#include "bpf_iter.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +volatile int terminate_early = 0;
> > +volatile u64 terminal_cgroup = 0;
> > +
>
> nit: you shouldn't need volatile for non-const global variables. Did
> you see any problems without volatile?
>

Nah. I don't know about that and see there are other tests that have
this pattern. Will fix.

> > +static inline u64 cgroup_id(struct cgroup *cgrp)
> > +{
> > +       return cgrp->kn->id;
> > +}
> > +
>
> [...]
