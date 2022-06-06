Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36F53EF13
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 22:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiFFUBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 16:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiFFUBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 16:01:11 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE48153B74
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 13:01:09 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id z9so1422807wmf.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 13:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W5TqJYafwftJ1q16jDwsapCbeMrbhqufuDDjVq8Z1/0=;
        b=dRai72lfgPZVIbcYWbUJgQZW62213vXNScspB3WEJ8uXaErK7Wm69WAfoUX4ybfir5
         hGG+oasznTALQNkRvzo4k3jjOa5QWG4Q7qaLY2vlMOL0HIQvV8DB/wJc4HPztmZJKHQg
         bgjw9FszVQUdeqkBcBCL7z1i3oUV4vGRLv7xGkQN+5dXsdh9YvZWGM8+UsJL45omX6bt
         OJMtAV9tYU83SJwh93SuVYmMkYMj96481RHZ/H7H9FNMPH5GSpI9UOCOvRo+0FZqUHkj
         DF/AA5b1zGXOO1kcS9aRFg/N6xzK0ao4g3Ic4hAsHSIMDrNE5Gmm9zTqm4+LahveQS/A
         nL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W5TqJYafwftJ1q16jDwsapCbeMrbhqufuDDjVq8Z1/0=;
        b=EsCBVKi2+0tP41h/T1hapVTN9pmBKahhMnmZ0geo9OGoAN0ujJPN1Yie0a4wqzRjwJ
         pUqKIW+dNaQn/gpoK3YUDr9RJyCXJbIi4VvzP1qfgmeD0jxqoPgStfX5p6vfsuNE9X6+
         Ec3zrAHtcu47dxwIxQ3zd77tKf+qggaM/ZczplIdmGMD+H0tnT0dJQIjZWkpb80BVu0x
         nyEB2wMzfosLx9iwoVAfkbW+OE2FbAmyJvOtdfybgOdLTwR1d/NtUWL76iLSZEcxhlar
         eSYimprOyW/6K22hvqL75pBuxthQ2ntRONJzJYwqIa6qDlkID5vz07lnnlkJWxJVdkCw
         9UQw==
X-Gm-Message-State: AOAM532sEtkpHwoG6JpUikhWYO1K9b660q449t5WcQSvrafblP+kvro1
        zROSDrm4i/OZIrqwa9SDn/L2Yy5RCvBHzIkLBukG1A==
X-Google-Smtp-Source: ABdhPJyEMUN07Nx+Z6Hur5B7Ckxoi3WjMhd9MJBUwtTUCWQoJCvlJDkV6RZ2FWrtlkbBQxf7z3rq1LujRmEt7yno97I=
X-Received: by 2002:a7b:c7c3:0:b0:398:934f:a415 with SMTP id
 z3-20020a7bc7c3000000b00398934fa415mr25516158wmk.27.1654545667336; Mon, 06
 Jun 2022 13:01:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz> <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
 <20220606123209.GE6928@blackbody.suse.cz> <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw@mail.gmail.com>
 <20220606195454.byivqaarp6ra7dpc@apollo.legion>
In-Reply-To: <20220606195454.byivqaarp6ra7dpc@apollo.legion>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 6 Jun 2022 13:00:30 -0700
Message-ID: <CAJD7tkbOFHW+Z48CbpsG3O8wvh0GYjChDgNhoiVJ=_LZsND8wQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Jun 6, 2022 at 12:55 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, Jun 07, 2022 at 01:02:04AM IST, Yosry Ahmed wrote:
> > On Mon, Jun 6, 2022 at 5:32 AM Michal Koutn=C3=BD <mkoutny@suse.com> wr=
ote:
> > >
> > > On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed@goo=
gle.com> wrote:
> > > > In short, think of these bpf maps as equivalents to "struct
> > > > memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> > > > controller. They are just containers to store the stats in, they do
> > > > not have any subgraph structure and they have no use beyond storing
> > > > percpu and total stats.
> > >
> > > Thanks for the explanation.
> > >
> > > > I run small microbenchmarks that are not worth posting, they compar=
ed
> > > > the latency of bpf stats collection vs. in-kernel code that adds st=
ats
> > > > to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> > > > difference was marginal.
> > >
> > > OK, that's a reasonable comparison.
> > >
> > > > The main reason for this is to provide data in a similar fashion to
> > > > cgroupfs, in text file per-cgroup. I will include this clearly in t=
he
> > > > next cover message.
> > >
> > > Thanks, it'd be great to have that use-case captured there.
> > >
> > > > AFAIK loading bpf programs requires a privileged user, so someone h=
as
> > > > to approve such a program. Am I missing something?
> > >
> > > A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
> > > wrote, this adds a way how to call cgroup_rstat_updated() directly, i=
t's
> > > not reserved for privilged users anyhow.
> >
> > I am not sure if kfuncs have different privilege requirements or if
> > there is a way to mark a kfunc as privileged. Maybe someone with more
> > bpf knowledge can help here. But I assume if unprivileged_bpf_disabled
> > is not set then there is a certain amount of risk/trust that you are
> > taking anyway?
> >
>
> It requires CAP_BPF or CAP_SYS_ADMIN, see verifier.c:add_subprog_or_kfunc=
.

Thanks for the clarification!

>
> > >
> > > > bpf_iter_run_prog() is used to run bpf iterator programs, and it gr=
abs
> > > > rcu read lock before doing so. So AFAICT we are good on that front.
> > >
> > > Thanks for the clarification.
> > >
> > >
> > > Michal
>
> --
> Kartikeya
