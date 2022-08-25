Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8954B5A18F4
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbiHYSqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHYSqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:46:10 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1977C5F236
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:46:09 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n17so1106385wrm.4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nIUljFBkx0nexRnIBmlsCUVPOXret1NOSFaDab7BEyE=;
        b=k6cregGwdCXEynRFHNQnjLAXb0RFMfFa3FMHdPuHUfi6T8dfpJl4HEIbDYqwcxOel3
         ksJqS6FWaDJApbXU3uJcpWyQbkvpdQSW2R/rFtjn5aDhBWRsI99ESDf3XLfqeqwW+tVU
         Dkv1FS2oCKmHJkt6wXRtQ4rv7corYV1o3nvyYOi0Gs9QqDDzvMk53+PNJ46oz+a9G95G
         ZxvIoGSbblrukcDX0lGfen/S4JaEdakZONRpoX6cJ1lSdnDDIW33z3ifDMacL9p1qE16
         M1JxwcDkSA6vcYd90XZDbW7UbSnga5SIddpxYn/3oewqT4QcarLSQIO36hnkUPHC7QqD
         xiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nIUljFBkx0nexRnIBmlsCUVPOXret1NOSFaDab7BEyE=;
        b=16B33BBJvWCpTYcKhkltssu6TTpMwlOXaxTsW0frHNW1k+9C3VejMPgm/Dxz8uIzqC
         3BZzeMnRVOAlPNYCqLSdfhFGHqnhJIhD9PWedEnhrt18/pf/2L0Wfi/m2vFNCPM+F5Zq
         3UkxmDarkHXRb/ZRuKam55IBrpfqff4LedoADHUTKVY1LSuhFuCpCOjVDZ/xqgh4GoAH
         07hgHo+oLAOksYc5KPsLaEr6n5JiIqwRRfbgohBaoNh2koQLTNIQUdsMtphD9qL3I97o
         Z1ayZGhtTbzEXOSWxgKhnO+172ly/1LLangxxR3X1lQc4YdqeO1euC960FAe0tXAe/gW
         Ks5Q==
X-Gm-Message-State: ACgBeo0oi0dldIlzgjaDJ93YZVv6JX2Jl7MdRQj8BPnDjjeZiU7L9MAR
        BcyNJI1OqMyZkBcsml8E+csleaLqKpb9pu0+H6pNAw==
X-Google-Smtp-Source: AA6agR5LFET4yCFkQ8vwQbxb3eFWAptn2L9E3gpXGgxbfnZMZebQzL/ASi9e2kdBGAZQCqlaOF+AFzYG3fCODNNPjXs=
X-Received: by 2002:adf:9ccf:0:b0:225:4934:53e3 with SMTP id
 h15-20020adf9ccf000000b00225493453e3mr3158455wre.210.1661453167369; Thu, 25
 Aug 2022 11:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-6-haoluo@google.com>
 <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com>
 <CAJD7tkZGxkV8_3qNy_Q=k-DT2=aGknzT08WiVtESpzur1JxCwA@mail.gmail.com> <CAADnVQLD+PcyO1qmxaBxdK1_tLRfBEqth8kzxts_8f+nSqu+hA@mail.gmail.com>
In-Reply-To: <CAADnVQLD+PcyO1qmxaBxdK1_tLRfBEqth8kzxts_8f+nSqu+hA@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 25 Aug 2022 11:45:31 -0700
Message-ID: <CAJD7tkZDw278kApDYKUhnuz5wVcrx9D_k0LLUktT8jgrA5uj-w@mail.gmail.com>
Subject: Re: [RESEND PATCH bpf-next v9 5/5] selftests/bpf: add a selftest for
 cgroup hierarchical stats collection
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, Aug 25, 2022 at 11:43 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 24, 2022 at 7:41 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > On Wed, Aug 24, 2022 at 7:09 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> > > > +
> > > > +       for (i = 0; i < N_CGROUPS; i++) {
> > > > +               fd = create_and_get_cgroup(cgroups[i].path);
> > > > +               if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> > > > +                       return fd;
> > > > +
> > > > +               cgroups[i].fd = fd;
> > > > +               cgroups[i].id = get_cgroup_id(cgroups[i].path);
> > > > +
> > > > +               /*
> > > > +                * Enable memcg controller for the entire hierarchy.
> > > > +                * Note that stats are collected for all cgroups in a hierarchy
> > > > +                * with memcg enabled anyway, but are only exposed for cgroups
> > > > +                * that have memcg enabled.
> > > > +                */
> > > > +               if (i < N_NON_LEAF_CGROUPS) {
> > > > +                       err = enable_controllers(cgroups[i].path, "memory");
> > > > +                       if (!ASSERT_OK(err, "enable_controllers"))
> > > > +                               return err;
> > > > +               }
> > > > +       }
> > >
> > > It passes BPF CI, but fails in my setup with:
> > >
> > > # ./test_progs -t cgroup_hier -vv
> > > bpf_testmod.ko is already unloaded.
> > > Loading bpf_testmod.ko...
> > > Successfully loaded bpf_testmod.ko.
> > > setup_bpffs:PASS:mount 0 nsec
> > > setup_cgroups:PASS:setup_cgroup_environment 0 nsec
> > > setup_cgroups:PASS:get_root_cgroup 0 nsec
> > > setup_cgroups:PASS:create_and_get_cgroup 0 nsec
> > > (cgroup_helpers.c:92: errno: No such file or directory) Enabling
> > > controller memory:
> > > /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control
> > > setup_cgroups:FAIL:enable_controllers unexpected error: 1 (errno 2)
> > > cleanup_bpffs:FAIL:rmdir /sys/fs/bpf/vmscan/ unexpected error: -1 (errno 2)
> > > #36      cgroup_hierarchical_stats:FAIL
> > > Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> > >
> > > How do I debug it?
> >
> > The failure with ENOENT happens when we try to write "+memory" to
> > /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control, not when
> > we try to open it. So the file is there. AFAICT, ENOENT can be
> > returned from this write if the memory controller is not enabled on
> > this cgroup.
> >
> > In setup_cgroup_environment(), we should be enabling all available
> > controllers on /mnt and /mnt/cgroup-test-work-dir6526 by this line:
> >
> >         if (__enable_controllers(CGROUP_MOUNT_PATH, NULL) ||
> >               __enable_controllers(cgroup_workdir, NULL))
> >                   return 1;
> >
> > The first thing that comes to mind is that maybe the memory controller
> > is not enabled on your setup at all? Can you check
> > /sys/fs/cgroup/cgroup.controllers (or wherever your global cgroup
> > mount is)?
>
> Indeed. I didn't have a memory controller in cgroup2.
> My system booted with cgroup v1 and it had cgroup1 memory
> controller enabled which prevented cgroup2 to enable it.
> Without Tejun's help I would have been able to figure this out.
>
> Anyway, pushed the set to bpf-next. Thanks everyone.

Thanks Alexei!
