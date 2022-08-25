Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BA15A052C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiHYA36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYA35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:29:57 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5881EAF8;
        Wed, 24 Aug 2022 17:29:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sd33so15212323ejc.8;
        Wed, 24 Aug 2022 17:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ciex1M3iqp5s8wXR0fILlM12xeyVcSZQd9Ahu6CFpUY=;
        b=PnF1b98qcTe7Aisdifeox05zIT2HLoeeBXiQ/PdvRwtGGKzs7ZPZi5t9iltgkrF9lz
         1MBwCYR6xE3rzUIpCJVD8G0KKuiKvrmj/Hkx110eKCrnVFX9+nqJdWmEHn9epXVW9//o
         xsLf9VHdrJRxc3KxLLGOKpHYM7vRP2XP7c5kHOahCxdFb1H5fYSxRV7YPkqXWBvu97JC
         SfRGam+WaqVeGblpnXwbcD6+WZi3legeOsw8Qo3lUsh3XAsh62sLarHqMKR8m7EAaDcE
         CLI0XxIFxd24NjnH7yFnIYDgN70lK0XiFw19oN84Ng7wwaVJLhfrgDT/weuW8ctzDJpP
         6Hmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ciex1M3iqp5s8wXR0fILlM12xeyVcSZQd9Ahu6CFpUY=;
        b=I5CrJs42leoNhgTthkdJcFKPm8F+c32oQweJBKeRwkwedwNZF5IoC3GwyBjqHBgub5
         OuGMaRSC8knNNzRfAZjXtuNT72JXhIBHXJJRisJmfpd/Gc2e9NKNySW2dSSwEGmOsA5R
         UsKcjcE7KKp6qNiPH45ddvgEItMNCZCU2y5q1QCnlmPk8vk5USxZ3+COsz0FhnAXshZw
         03aGZUG6uTT2OSDideEsXVZqzydp04UfAwsnvB3dZ8yNmUHd/kDQ2Epm9iLoIljN9Lty
         IHoJ/G0eTG5lnkiSYJMSK0bJbFbYmnNEMXRmLIP66uI4QzZtpG4mOVSJuM6Ldwxtzj0y
         doBQ==
X-Gm-Message-State: ACgBeo2xIHBvzOs8jTyKc2rbuj38IHl44xpDN9zeVmAI0UjhqZ4Xv/IK
        CbIlI5YvRn75sFfX1INZs+zHs6VQfwNkJwNqywM=
X-Google-Smtp-Source: AA6agR71AsmC5lWezecsMgCiyWe1qe55+o7z/o1o6+A+VfdBz69tWZY5RRGqoDQ3qvNsDZq6jQoUu2UYxBfbXphCcgQ=
X-Received: by 2002:a17:907:7b94:b0:731:1b11:c241 with SMTP id
 ne20-20020a1709077b9400b007311b11c241mr868514ejc.676.1661387394268; Wed, 24
 Aug 2022 17:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220824233117.1312810-1-haoluo@google.com>
In-Reply-To: <20220824233117.1312810-1-haoluo@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Aug 2022 17:29:43 -0700
Message-ID: <CAADnVQLT3JE8LtOYrs30mL88PNs+NaSeXgQqAPEAup5LUC+BPQ@mail.gmail.com>
Subject: Re: [RESEND PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical
To:     Hao Luo <haoluo@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
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

On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
>
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats percpu and
> propagate them through the cgroup hierarchy.
>
> The stats are exposed to userspace in textual form by reading files in
> bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> - walking a cgroup's descendants in pre-order.
> - walking a cgroup's descendants in post-order.
> - walking a cgroup's ancestors.
> - process only a single object.
>
> When attaching cgroup_iter, one needs to set a cgroup to the iter_link
> created from attaching. This cgroup can be passed either as a file
> descriptor or a cgroup id. That cgroup serves as the starting point of
> the walk.
>
> One can also terminate the walk early by returning 1 from the iter
> program.
>
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
>
> ** Background on rstat for stats collection **
> (I am using a subscriber analogy that is not commonly used)
>
> The rstat framework maintains a tree of cgroups that have updates and
> which cpus have updates. A subscriber to the rstat framework maintains
> their own stats. The framework is used to tell the subscriber when
> and what to flush, for the most efficient stats propagation. The
> workflow is as follows:
>
> - When a subscriber updates a cgroup on a cpu, it informs the rstat
>   framework by calling cgroup_rstat_updated(cgrp, cpu).
>
> - When a subscriber wants to read some stats for a cgroup, it asks
>   the rstat framework to initiate a stats flush (propagation) by calling
>   cgroup_rstat_flush(cgrp).
>
> - When the rstat framework initiates a flush, it makes callbacks to
>   subscribers to aggregate stats on cpus that have updates, and
>   propagate updates to their parent.
>
> Currently, the main subscribers to the rstat framework are cgroup
> subsystems (e.g. memory, block). This patch series allow bpf programs to
> become subscribers as well.
>
> Patches in this series are organized as follows:
> * Patches 1-2 introduce cgroup_iter prog, and a selftest.
> * Patches 3-5 allow bpf programs to integrate with rstat by adding the
>   necessary hook points and kfunc. A comprehensive selftest that
>   demonstrates the entire workflow for using bpf and rstat to
>   efficiently collect and output cgroup stats is added.
>
> ---
> Changelog:
> v8 -> v9:
> - Make UNSPEC (an invalid option) as the default order for cgroup_iter.
> - Use enum for specifying cgroup_iter order, instead of u32.
> - Add BPF_ITER_RESHCED to cgroup_iter.
> - Add cgroup_hierarchical_stats to s390x denylist.

What 'RESEND' is for?
It seems to confuse patchwork and BPF CI.

The v9 series made it to patchwork...

Please just bump the version to v10 next time.
Don't add things to subject, since automation cannot recognize
that yet.
