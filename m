Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781AB5A18F0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbiHYSnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHYSnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:43:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CFC6DAE9;
        Thu, 25 Aug 2022 11:43:17 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m1so2353369edb.7;
        Thu, 25 Aug 2022 11:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=q7xP9HYksRjqLoxLlP1cb34no2b9u1Ll2vr0oi+McwQ=;
        b=XOqJ3TBYRzFpP+cMJKmEBu0B3npy15NaAGmcCArco/3+wGTzzIiiCAu2ZCVZDdFR9G
         /LMjc8Xj9mfBtDxzji8MR4S9z++LHemj90jLEHc+ywrrwlDQs9K56aq6TIMYz7K72xk8
         9TBgT0yobN6qqk9EuDPMxJ2RNd4cioI4dyqqz+ZDXTuNzFU1Y2VNEeO0MEhByoNDKJCJ
         hNvMVU0tVwtDPZlwEG16x3nI4oup6mgWYZpJMin3M/ZvzFz+JmaOQyiUp9Z018nspDcJ
         gs42e1ddt1tlRkHk0f6MPowAyq5PD6qxY9/IFDH5awt2uPRo+TOB8yOhVxqt7U6phjd8
         hPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=q7xP9HYksRjqLoxLlP1cb34no2b9u1Ll2vr0oi+McwQ=;
        b=WfUNq5pUidV0UAUXUhfmj6WRO1MMAILcYjUpSfR+VeHeWs+PoUQ7aMdrAa/dwpJF2Y
         4LqXs0GMpYwxUuun1NVpRU9EseLQ5+Kn/j9CX5Y2LoAnh+119rfqz4aRuy/BoQXgGHDG
         ihAsXpf/tvCzrNwMgPSBU2JsJgBUXNAFKYB4yKzh3jEaTI6g2n0vTSvf9JlplYcKNSuG
         JY+6vOeWcF6ooXr2G0Ql6o8BnjDnGCV8EmHSU0GQr5+QTBqOimTpJg1vXzV/XI/vdn/M
         CIaflQG4rdXKEcsnE8U8EnpDyfZleysTIb13tIHhHz4LunSCFm3SXIBoNrjKX1RSx48O
         v+QA==
X-Gm-Message-State: ACgBeo2DYkw9YCH9zMUe/CSdEWiuY+MKGBXLlOqpWb5RAw9nYMU4eI7U
        AmXReWsTrtc3MnAmVkHO7582xcV5JI88pqiQHGo=
X-Google-Smtp-Source: AA6agR7wowlfpCyGH5pWBsnlYYu7H8yDOs+ogIlvciVB/XtpLsuQeOqRkxiOpNDwkwrm2ulB42xY4peQmP7htJydOas=
X-Received: by 2002:a05:6402:270d:b0:43a:67b9:6eea with SMTP id
 y13-20020a056402270d00b0043a67b96eeamr4211471edd.94.1661452996140; Thu, 25
 Aug 2022 11:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-6-haoluo@google.com>
 <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com> <CAJD7tkZGxkV8_3qNy_Q=k-DT2=aGknzT08WiVtESpzur1JxCwA@mail.gmail.com>
In-Reply-To: <CAJD7tkZGxkV8_3qNy_Q=k-DT2=aGknzT08WiVtESpzur1JxCwA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 25 Aug 2022 11:43:04 -0700
Message-ID: <CAADnVQLD+PcyO1qmxaBxdK1_tLRfBEqth8kzxts_8f+nSqu+hA@mail.gmail.com>
Subject: Re: [RESEND PATCH bpf-next v9 5/5] selftests/bpf: add a selftest for
 cgroup hierarchical stats collection
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Hao Luo <haoluo@google.com>, LKML <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>
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

On Wed, Aug 24, 2022 at 7:41 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Wed, Aug 24, 2022 at 7:09 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> > > +
> > > +       for (i = 0; i < N_CGROUPS; i++) {
> > > +               fd = create_and_get_cgroup(cgroups[i].path);
> > > +               if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> > > +                       return fd;
> > > +
> > > +               cgroups[i].fd = fd;
> > > +               cgroups[i].id = get_cgroup_id(cgroups[i].path);
> > > +
> > > +               /*
> > > +                * Enable memcg controller for the entire hierarchy.
> > > +                * Note that stats are collected for all cgroups in a hierarchy
> > > +                * with memcg enabled anyway, but are only exposed for cgroups
> > > +                * that have memcg enabled.
> > > +                */
> > > +               if (i < N_NON_LEAF_CGROUPS) {
> > > +                       err = enable_controllers(cgroups[i].path, "memory");
> > > +                       if (!ASSERT_OK(err, "enable_controllers"))
> > > +                               return err;
> > > +               }
> > > +       }
> >
> > It passes BPF CI, but fails in my setup with:
> >
> > # ./test_progs -t cgroup_hier -vv
> > bpf_testmod.ko is already unloaded.
> > Loading bpf_testmod.ko...
> > Successfully loaded bpf_testmod.ko.
> > setup_bpffs:PASS:mount 0 nsec
> > setup_cgroups:PASS:setup_cgroup_environment 0 nsec
> > setup_cgroups:PASS:get_root_cgroup 0 nsec
> > setup_cgroups:PASS:create_and_get_cgroup 0 nsec
> > (cgroup_helpers.c:92: errno: No such file or directory) Enabling
> > controller memory:
> > /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control
> > setup_cgroups:FAIL:enable_controllers unexpected error: 1 (errno 2)
> > cleanup_bpffs:FAIL:rmdir /sys/fs/bpf/vmscan/ unexpected error: -1 (errno 2)
> > #36      cgroup_hierarchical_stats:FAIL
> > Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> >
> > How do I debug it?
>
> The failure with ENOENT happens when we try to write "+memory" to
> /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control, not when
> we try to open it. So the file is there. AFAICT, ENOENT can be
> returned from this write if the memory controller is not enabled on
> this cgroup.
>
> In setup_cgroup_environment(), we should be enabling all available
> controllers on /mnt and /mnt/cgroup-test-work-dir6526 by this line:
>
>         if (__enable_controllers(CGROUP_MOUNT_PATH, NULL) ||
>               __enable_controllers(cgroup_workdir, NULL))
>                   return 1;
>
> The first thing that comes to mind is that maybe the memory controller
> is not enabled on your setup at all? Can you check
> /sys/fs/cgroup/cgroup.controllers (or wherever your global cgroup
> mount is)?

Indeed. I didn't have a memory controller in cgroup2.
My system booted with cgroup v1 and it had cgroup1 memory
controller enabled which prevented cgroup2 to enable it.
Without Tejun's help I would have been able to figure this out.

Anyway, pushed the set to bpf-next. Thanks everyone.
