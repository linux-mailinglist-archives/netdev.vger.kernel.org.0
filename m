Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DD653EEA8
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiFFTcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 15:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiFFTco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 15:32:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724762BB05
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 12:32:42 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k19so21143214wrd.8
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 12:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j/cPLNIZM1LCsTUDc6o0FCtYbw+beYsEKBGs5kqXcMs=;
        b=lzQFh/atdk+9YeyfEh+QiYmsQCHdhCw9He8IoqDkUDh70z79xt9WOeE69lDZxpcNjT
         bR141LudvjepsqtckXsTJExKjujhfBySeXX3lGBZdMyWw9Hj5GReFM3OKFmwi+TUoHQx
         oZsvwJKkDPX7u3JPtJIYSiEXF4g85cRoAjyT5U30WiD4Rahyvl6mTNRbQ2VRSRHhrZnc
         gLT5O+zMpFuaRqq5Q7CgrD1ALwUtROj44xO70cNoml5i78IH05nNERpThsHZQjrORuAS
         J1Hqkgqr3u7D3bTCMmD0YQ1IC4S8CknEj7+oNzqmijDOQei148Z/nshaGmchHBnxO64F
         DUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j/cPLNIZM1LCsTUDc6o0FCtYbw+beYsEKBGs5kqXcMs=;
        b=GnODB1l2+z3YmsEz+ALMGhJnEtGmGpKWjoTpPSZQm9dknyjczk9M7SSVFLSHC7n69W
         toWHPtrc9FqyYAkFe51K3Q8U4VtY+QUZvLXZ+Woo6kU4LvkVjySRgmTKBKsIYG5ZDB7t
         XXs4dZ10zEGMXY+HY3hRM3Yn47fRA60kj7GLaW1CzeZ3+KH5vquQDi+XPgYrgGt1jh3D
         +wn+H0NbF3l3pgc660WMIy/HKdV28EJZe1s7nEzltq+1sXCu7SO/vt+JXRjc8wJP7mFN
         2YXdoFMTTAaeMaby/7eoQXtbbMkUjbH7k8t7U+m3aV74vJxqKMu6wTx4iQamrLdA8r3h
         cGsA==
X-Gm-Message-State: AOAM530jrelCr6gQoq9j7NF31CmV2sWgQKIHMWdIlhi2vSTBgxyeVZCd
        yYiSMhadg9duxar4Iwqdq3LKWhLwy0cl9pz89opFFA==
X-Google-Smtp-Source: ABdhPJzOrH3W8CG5y0UhEiUwZCc/frlgpaMAC/wiDonpCoj3ndzKhQc7jzNy9XpNg/VeI6CYpTOKxRkUoRt6Vw65fS0=
X-Received: by 2002:adf:f688:0:b0:215:6e4d:4103 with SMTP id
 v8-20020adff688000000b002156e4d4103mr16603122wrp.372.1654543960673; Mon, 06
 Jun 2022 12:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz> <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
 <20220606123209.GE6928@blackbody.suse.cz>
In-Reply-To: <20220606123209.GE6928@blackbody.suse.cz>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 6 Jun 2022 12:32:04 -0700
Message-ID: <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Jun 6, 2022 at 5:32 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > In short, think of these bpf maps as equivalents to "struct
> > memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> > controller. They are just containers to store the stats in, they do
> > not have any subgraph structure and they have no use beyond storing
> > percpu and total stats.
>
> Thanks for the explanation.
>
> > I run small microbenchmarks that are not worth posting, they compared
> > the latency of bpf stats collection vs. in-kernel code that adds stats
> > to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> > difference was marginal.
>
> OK, that's a reasonable comparison.
>
> > The main reason for this is to provide data in a similar fashion to
> > cgroupfs, in text file per-cgroup. I will include this clearly in the
> > next cover message.
>
> Thanks, it'd be great to have that use-case captured there.
>
> > AFAIK loading bpf programs requires a privileged user, so someone has
> > to approve such a program. Am I missing something?
>
> A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
> wrote, this adds a way how to call cgroup_rstat_updated() directly, it's
> not reserved for privilged users anyhow.

I am not sure if kfuncs have different privilege requirements or if
there is a way to mark a kfunc as privileged. Maybe someone with more
bpf knowledge can help here. But I assume if unprivileged_bpf_disabled
is not set then there is a certain amount of risk/trust that you are
taking anyway?

>
> > bpf_iter_run_prog() is used to run bpf iterator programs, and it grabs
> > rcu read lock before doing so. So AFAICT we are good on that front.
>
> Thanks for the clarification.
>
>
> Michal
