Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D99E53EEF1
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 21:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiFFTzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 15:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbiFFTzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 15:55:13 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D13FEF;
        Mon,  6 Jun 2022 12:55:10 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id z17so692857vkb.13;
        Mon, 06 Jun 2022 12:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZAOjVHfWgWEtrCEowhgivo44hpW2jfshzvmdXVjn21k=;
        b=hlrnD/oOe2EaUICZU22+CtvzqiQwTRCk1hZt5dfuUZKWQ6TnntWxIpLy3UzelFS9cM
         JqUXuzLlQHNmUQbBq97na+4N61izImNM97gDNc2FCskjjgz32K3ULMCGs8aMi90i3BgX
         NGicAWUt/wYwrj2Umubv6/Esa/8mctbzH1bx29u2gFPCRKV26ybyDmMYjT0kkiHBBp0p
         NNBjjcS6+pxgvs7Vz72WrCGOC9+DJ7NMwlaDYX3T96ClSIv9MH+tIQ++FCDiu3HJyDKp
         n2WHQTgEEuz7soyrV9UG0cOEhSqOI1BeKDboBDONuPGRxkSCKgohal7cNrEXqCsqn5b+
         5r/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZAOjVHfWgWEtrCEowhgivo44hpW2jfshzvmdXVjn21k=;
        b=LnHEWmG/0LWeq+aelYojvngJzSw9lQoKTfZtg3iYUzHA0f7WmKNbiXvV7W6viEhJIk
         FmY12d7Cbd48XFAtrQIQQ0604HTR/EAoNao6CwbKI8XpOyS23OcsgKloVKsSrcU520gO
         QZ9eeCIKDr7PQ49sOpZCG/261BZE90g8Bbxs7D0zRc3smuRKO9T/nViPcfpgoJ6ueYNk
         dFdvJCtwv5MAEL5VwNeFGVDyqkIMckTBtp8ekoiB254Q3ncIoZHqzrsQm7hhz6/ALFN1
         34JbIzVhYQvK2aJOIdS8MdtVF1wE0+36CwpVdGmbdPgCVbPU4lnT+ksnDfit3NbQPy9W
         1H6Q==
X-Gm-Message-State: AOAM532Yq98nsBv7NC0jkbqcyXkf16DNn/c7toV18/aEItJgp/AKeMMD
        0baXIJwlvsFNAuK1UhV7xGa2S4hLf90=
X-Google-Smtp-Source: ABdhPJzfmjR5YZA2kob+M1kPmdRB5UvulwQDYYgnYqd9ZjNa3CScD42fzqozyBBKtpqx9N3hIiieSA==
X-Received: by 2002:a17:902:ec91:b0:167:6f74:ba73 with SMTP id x17-20020a170902ec9100b001676f74ba73mr10798060plg.141.1654545297849;
        Mon, 06 Jun 2022 12:54:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id t17-20020a170902e1d100b0015e8d4eb282sm10803800pla.204.2022.06.06.12.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 12:54:57 -0700 (PDT)
Date:   Tue, 7 Jun 2022 01:24:54 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
Message-ID: <20220606195454.byivqaarp6ra7dpc@apollo.legion>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz>
 <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
 <20220606123209.GE6928@blackbody.suse.cz>
 <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 01:02:04AM IST, Yosry Ahmed wrote:
> On Mon, Jun 6, 2022 at 5:32 AM Michal Koutný <mkoutny@suse.com> wrote:
> >
> > On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed@google.com> wrote:
> > > In short, think of these bpf maps as equivalents to "struct
> > > memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> > > controller. They are just containers to store the stats in, they do
> > > not have any subgraph structure and they have no use beyond storing
> > > percpu and total stats.
> >
> > Thanks for the explanation.
> >
> > > I run small microbenchmarks that are not worth posting, they compared
> > > the latency of bpf stats collection vs. in-kernel code that adds stats
> > > to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> > > difference was marginal.
> >
> > OK, that's a reasonable comparison.
> >
> > > The main reason for this is to provide data in a similar fashion to
> > > cgroupfs, in text file per-cgroup. I will include this clearly in the
> > > next cover message.
> >
> > Thanks, it'd be great to have that use-case captured there.
> >
> > > AFAIK loading bpf programs requires a privileged user, so someone has
> > > to approve such a program. Am I missing something?
> >
> > A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
> > wrote, this adds a way how to call cgroup_rstat_updated() directly, it's
> > not reserved for privilged users anyhow.
>
> I am not sure if kfuncs have different privilege requirements or if
> there is a way to mark a kfunc as privileged. Maybe someone with more
> bpf knowledge can help here. But I assume if unprivileged_bpf_disabled
> is not set then there is a certain amount of risk/trust that you are
> taking anyway?
>

It requires CAP_BPF or CAP_SYS_ADMIN, see verifier.c:add_subprog_or_kfunc.

> >
> > > bpf_iter_run_prog() is used to run bpf iterator programs, and it grabs
> > > rcu read lock before doing so. So AFAICT we are good on that front.
> >
> > Thanks for the clarification.
> >
> >
> > Michal

--
Kartikeya
