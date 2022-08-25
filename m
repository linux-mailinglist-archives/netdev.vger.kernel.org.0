Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79785A0771
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiHYCmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiHYCmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:42:08 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30AC9E0E7
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:41:59 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k17so9592716wmr.2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=doFUHdVPTABkZsDuf0MJLhPZVm+o4dycrmtaBb1zaGg=;
        b=ljEZc6yMBm22SLRA96eNiZ8zgNwa6AiCs/mIj4MH8Lu0ITLXCDbw1rPAThOIFT6Hls
         ospWapMqLKqRDIfRiC+dCGUxBR5sBvXQ26YTcthtauabE4uJitMLdbltOEAcI4UYmaD8
         j1f06IYOrOaeiFBdUe+UDv9Lah3WVcDkkdi7vs8AauhaW43RVxrNEy24rmWtaAHHHM+u
         h7B3HLp+8WRyddXXmzTHtWjnkO1iV1aa6u2vo0XFu1N8LA90hsMIcwYJkyIP72cSCzHn
         Oy6w8nNGH41msDEU6rjbzxVYJQG80prf38WQ/d2GRWv/I5OlSZFlOdPtahy7/ehSx+7F
         8fAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=doFUHdVPTABkZsDuf0MJLhPZVm+o4dycrmtaBb1zaGg=;
        b=HlkHFo1fXcVnOqZd8+7nQo8l+ZIVHiaJzNuiZFOcCSPWA7QPZD+AS/QgXUT/U/HMWZ
         HsOnUeWcxk7k49oJfPIVqfe99aCrWr4gqYSY8HrRzm2pkqtA/XrYM+yeGaoKZ7DlcqNT
         AAlqbmnh4CivKQrNaUKp8BQbJH1b6ZnXw7zKlECD0dwVtTIce4g1m8wuWl13FGhPuE3Q
         AeSMS6RakFTBYk6xkvkoiNGf1HBUjiqr4cBCe6RKZlLr9VXXSyObOXSDEJ7BUO3E179W
         wqlLYCay4nu65tCl9ZtPV6IAEJospGBZSxj+bt9cb7Q9iFh5RPQYg2HFVvgJl1MGyFoP
         Ul5g==
X-Gm-Message-State: ACgBeo1pgADDDjbsPexPKUqfkcY9lXqKITg3zng4wELn7uVPIba4LQ0F
        vhkWIlERdiVQW0ACJQS5f1ybEv9JqnDaRWpYnIK1dg==
X-Google-Smtp-Source: AA6agR5GPEqqnND+ToMCQEGITdPdIK1ZE/Wm2wUBTGxdKJhYUMI7lrl6GTXYj8E7Tr2c5EbngEn6ZtlnS1UXQr145V8=
X-Received: by 2002:a05:600c:1e05:b0:3a5:b441:e9c with SMTP id
 ay5-20020a05600c1e0500b003a5b4410e9cmr794100wmb.24.1661395317923; Wed, 24 Aug
 2022 19:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-6-haoluo@google.com>
 <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com>
In-Reply-To: <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Wed, 24 Aug 2022 19:41:21 -0700
Message-ID: <CAJD7tkZGxkV8_3qNy_Q=k-DT2=aGknzT08WiVtESpzur1JxCwA@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 7:09 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> > +
> > +       for (i = 0; i < N_CGROUPS; i++) {
> > +               fd = create_and_get_cgroup(cgroups[i].path);
> > +               if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> > +                       return fd;
> > +
> > +               cgroups[i].fd = fd;
> > +               cgroups[i].id = get_cgroup_id(cgroups[i].path);
> > +
> > +               /*
> > +                * Enable memcg controller for the entire hierarchy.
> > +                * Note that stats are collected for all cgroups in a hierarchy
> > +                * with memcg enabled anyway, but are only exposed for cgroups
> > +                * that have memcg enabled.
> > +                */
> > +               if (i < N_NON_LEAF_CGROUPS) {
> > +                       err = enable_controllers(cgroups[i].path, "memory");
> > +                       if (!ASSERT_OK(err, "enable_controllers"))
> > +                               return err;
> > +               }
> > +       }
>
> It passes BPF CI, but fails in my setup with:
>
> # ./test_progs -t cgroup_hier -vv
> bpf_testmod.ko is already unloaded.
> Loading bpf_testmod.ko...
> Successfully loaded bpf_testmod.ko.
> setup_bpffs:PASS:mount 0 nsec
> setup_cgroups:PASS:setup_cgroup_environment 0 nsec
> setup_cgroups:PASS:get_root_cgroup 0 nsec
> setup_cgroups:PASS:create_and_get_cgroup 0 nsec
> (cgroup_helpers.c:92: errno: No such file or directory) Enabling
> controller memory:
> /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control
> setup_cgroups:FAIL:enable_controllers unexpected error: 1 (errno 2)
> cleanup_bpffs:FAIL:rmdir /sys/fs/bpf/vmscan/ unexpected error: -1 (errno 2)
> #36      cgroup_hierarchical_stats:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> How do I debug it?

The failure with ENOENT happens when we try to write "+memory" to
/mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control, not when
we try to open it. So the file is there. AFAICT, ENOENT can be
returned from this write if the memory controller is not enabled on
this cgroup.

In setup_cgroup_environment(), we should be enabling all available
controllers on /mnt and /mnt/cgroup-test-work-dir6526 by this line:

        if (__enable_controllers(CGROUP_MOUNT_PATH, NULL) ||
              __enable_controllers(cgroup_workdir, NULL))
                  return 1;

The first thing that comes to mind is that maybe the memory controller
is not enabled on your setup at all? Can you check
/sys/fs/cgroup/cgroup.controllers (or wherever your global cgroup
mount is)?

I don't know much about namespaces, so I am not sure if the privately
mounted /mnt directory here would be the same as the cgroup root or
not. Maybe we can add a pause() somewhere and check
/mnt/cgroup.controllers as well?
