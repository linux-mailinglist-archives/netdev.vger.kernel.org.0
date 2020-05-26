Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE611E2A21
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgEZSdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgEZSdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:33:41 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D58C03E96D;
        Tue, 26 May 2020 11:33:40 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x29so3790124qtv.4;
        Tue, 26 May 2020 11:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nwMtGvHNh6lLDCA8DTGdQ8UWv5hRqWibFM0Tb1k8GGg=;
        b=fz0CQ3Sf7fjr/WoZrUoM3L3ln6u2rZ/CNEfI2UaruVwWibupI5FKpT5u7ZmSajRjKp
         BVsoG1j2vAl/BgA7aUv8ooSNo9gO4HM6sP8zCTC3Tap+axu3ZLO3mgl4Oi64D/j30G/C
         FM1mndOqwp5G5uzLtlZMIIkgRn9ma9EUHqWCw5Dtt71EWbWfNo8imGEguZQtRCcJQIeJ
         ldIerIKysOxZG53nBs+u4m4js2kf9qsARiw3Rl+lanss519JML1HKWF+G2hY+4gNOqgV
         8Jj5hyoOrDvrM9qZnWZIpb31BDq9dNcUN83/+9dTwl0Uz6n5LvU8xFnkX+qWLX7HDdn1
         CQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nwMtGvHNh6lLDCA8DTGdQ8UWv5hRqWibFM0Tb1k8GGg=;
        b=XPw8dtphHZJkhCu8KE2l4MMcn02XC3q/M44fkOFjkZ0fYXc/XyjL9kkrtFo1tjPTRR
         Vj6JYUQ+7xeWgI65ufaL3bs75YWg64sx8s2UJha0/T7lfkQOx5XdJxtYMIKjFqOVHFHZ
         7B2/tpZp+WOL6/+vZ51X+BUWX/w6/rVHepjOZSsY9v928XPMcctm+euZa7AOQ6NzxioO
         kYGzgQBBw2PfGsH//DThfhfrkeRsXfHkpfDyzMnO9ENE1LZYTZphnUTBRUiMIN8Y7Eg5
         rqX40PiJuEc6evnoD0GIMg2w9yMrQWl8RtPIySY4BtTM3zPS0GNJ0KSqTWQeJznnJSZ+
         qW+A==
X-Gm-Message-State: AOAM533ZNuHFgvNHRv95bMmj9CQun0QCMLN4hjhFsKDfERx8qSsloXt7
        Egs8NvNfum+2r/Z0bPXrpJJkUfOwBeJubbDEoi4=
X-Google-Smtp-Source: ABdhPJwljHp9Sq4fK5IdJ45CMdIOBTFj1C+1x5WsYcf70jKmZDLCYdGKH0ej1/EGcED+mm/yuSRgFa/a8TcW4bjIdVo=
X-Received: by 2002:ac8:71cd:: with SMTP id i13mr134894qtp.93.1590518017811;
 Tue, 26 May 2020 11:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
 <48c47712-bba1-3f53-bbeb-8a7403dab6db@iogearbox.net> <5ecc4d3c78c9e_718d2b15b962e5b845@john-XPS-13-9370.notmuch>
In-Reply-To: <5ecc4d3c78c9e_718d2b15b962e5b845@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 11:33:26 -0700
Message-ID: <CAEf4BzZ0b_UyxzyE-8+3oWSieutWov1UuVJ5Ugpn0yx8qeYNrA@mail.gmail.com>
Subject: Re: [bpf-next PATCH v5 1/5] bpf, sk_msg: add some generic helpers
 that may be useful from sk_msg
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Daniel Borkmann wrote:
> > On 5/24/20 6:50 PM, John Fastabend wrote:
> > > Add these generic helpers that may be useful to use from sk_msg programs.
> > > The helpers do not depend on ctx so we can simply add them here,
> > >
> > >   BPF_FUNC_perf_event_output
> > >   BPF_FUNC_get_current_uid_gid
> > >   BPF_FUNC_get_current_pid_tgid
> > >   BPF_FUNC_get_current_comm
> >
> > Hmm, added helpers below are what you list here except get_current_comm.
> > Was this forgotten to be added here?
>
> Forgot to update commit messages. I dropped it because it wasn't clear to
> me it was very useful or how I would use it from this context. I figure we
> can add it later if its needed.

But it's also not harmful in any way and is in a similar group as
get_current_pid_tgid. So let's add it sooner rather than later. There
is no cost in allowing this, right?

>
> >
> > >   BPF_FUNC_get_current_cgroup_id
> > >   BPF_FUNC_get_current_ancestor_cgroup_id
> > >   BPF_FUNC_get_cgroup_classid
> > >
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---
> > >   net/core/filter.c |   16 ++++++++++++++++
> > >   1 file changed, 16 insertions(+)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 822d662..a56046a 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -6443,6 +6443,22 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > >             return &bpf_msg_push_data_proto;
> > >     case BPF_FUNC_msg_pop_data:
> > >             return &bpf_msg_pop_data_proto;
> > > +   case BPF_FUNC_perf_event_output:
> > > +           return &bpf_event_output_data_proto;
> > > +   case BPF_FUNC_get_current_uid_gid:
> > > +           return &bpf_get_current_uid_gid_proto;
> > > +   case BPF_FUNC_get_current_pid_tgid:
> > > +           return &bpf_get_current_pid_tgid_proto;
> > > +#ifdef CONFIG_CGROUPS
> > > +   case BPF_FUNC_get_current_cgroup_id:
> > > +           return &bpf_get_current_cgroup_id_proto;
> > > +   case BPF_FUNC_get_current_ancestor_cgroup_id:
> > > +           return &bpf_get_current_ancestor_cgroup_id_proto;
> > > +#endif
> > > +#ifdef CONFIG_CGROUP_NET_CLASSID
> > > +   case BPF_FUNC_get_cgroup_classid:
> > > +           return &bpf_get_cgroup_classid_curr_proto;
> > > +#endif
> > >     default:
> > >             return bpf_base_func_proto(func_id);
> > >     }
> > >
> >
>
>
