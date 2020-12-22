Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A02E041F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgLVB5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgLVB5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 20:57:55 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40E1C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:57:14 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id l3so9431461qvr.10
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=R+Me/78QC9MGNY142zs6FXYrVvJlP5KajbEKMV2esN8=;
        b=RtD1RW+bnzt1MwmEnVlgqlh5swyYjZwEmdtXZS5RreJNQ6c1qXY1iLZY215+9RgwL/
         J9GJ1PrCGeQ9OOpFzMjkr2qnKRJk7Pk2JuKsUULw9n4OOJ+XM8J77TypxMBUYAXM7z6j
         MPCmGYYNvrklAx4xV+ltqnEQSjJeb8By29uTRhqVPqn0xGKFJkGedeVg/n6EqqoqWu7i
         VtJTqwIwg8BZZLLpZB+K038/w9x+n8evVXxL0dW2eUmHB13ho5Cd7GkuqH4UFe7VOtV6
         NAXtve5ml3jajU47sP+1Oaw/oq/KYRszF014Ff2t6a4Hs91gTpQKCbOacmhHa6QKVl1v
         sq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R+Me/78QC9MGNY142zs6FXYrVvJlP5KajbEKMV2esN8=;
        b=uAdPiefvOixGdEk9yaCp+di+ODFqPTJ+Qz6Hu5MLXNvWYpZMYjve+NacwQjVOJfDSU
         KPi4FGXyEH3gI9oMURKRG+z5B9cgeJsCPLaiiMwYk9IMZRtDGFScac/hZoELrYIoAR9m
         8ZuxvZ1i09tFkYuRyqzZRQF7Kn/KVwQUvAFuACcA08ncufr+3LcKHpjBG7RkIpvjrJiA
         o/7A/HjCtaNhK0fV5nJ2wCnL80LqD9KyzxaqcjhOhilY4xmLF3ZcEMN7Z5OA7JUqioZ6
         pL4/Q1xWtLDK/JvaR93Z1I04lTgAScMVLJZ0Q85Y05535F1W/hLv72zGM8rfjiBblfx2
         jVWg==
X-Gm-Message-State: AOAM531GJc5iAaI0yALeFUYOXiBuU7mk5gXNi94QTqSnceLIspIk1RF9
        CZk6Xme9tqI6CGD4ncERbkdV3yk=
X-Google-Smtp-Source: ABdhPJwQsRO828tY99BYHKRf98l4td5Wps0RnD9Wo1SCAGF3GMjTFqH+i+M6ClxmAjC9LLKC+OSK7Fg=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:43ea:: with SMTP id f10mr20122956qvu.52.1608602233472;
 Mon, 21 Dec 2020 17:57:13 -0800 (PST)
Date:   Mon, 21 Dec 2020 17:57:11 -0800
In-Reply-To: <CAPhsuW63um6NL6QF4E=iYpCeCiavuqYahO1h39Eu=agQU8LL5g@mail.gmail.com>
Message-Id: <X+FSd9IEvxqEXmIr@google.com>
Mime-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-3-sdf@google.com>
 <CAPhsuW63um6NL6QF4E=iYpCeCiavuqYahO1h39Eu=agQU8LL5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: split cgroup_bpf_enabled per attach type
From:   sdf@google.com
To:     Song Liu <song@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21, Song Liu wrote:
> On Thu, Dec 17, 2020 at 9:26 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > When we attach any cgroup hook, the rest (even if unused/unattached)  
> start
> > to contribute small overhead. In particular, the one we want to avoid is
> > __cgroup_bpf_run_filter_skb which does two redirections to get to
> > the cgroup and pushes/pulls skb.
> >
> > Let's split cgroup_bpf_enabled to be per-attach to make sure
> > only used attach types trigger.
> >
> > I've dropped some existing high-level cgroup_bpf_enabled in some
> > places because BPF_PROG_CGROUP_XXX_RUN macros usually have another
> > cgroup_bpf_enabled check.
> >
> > I also had to copy-paste BPF_CGROUP_RUN_SA_PROG_LOCK for
> > GETPEERNAME/GETSOCKNAME because type for cgroup_bpf_enabled[type]
> > has to be constant and known at compile time.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>

> [...]

> > @@ -252,8 +252,10 @@ int bpf_percpu_cgroup_storage_update(struct  
> bpf_map *map, void *key,
> >  #define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk,  
> uaddr)                        \
> >         BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND,  
> NULL)
> >
> > -#define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
> > -                                           sk->sk_prot->pre_connect)
> > +#define  
> BPF_CGROUP_PRE_CONNECT_ENABLED(sk)                                    \
> > +       ((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) | 
> |                      \
> > +         cgroup_bpf_enabled(BPF_CGROUP_INET6_CONNECT))  
> &&                     \
> > +        sk->sk_prot->pre_connect)

> Patchworks highlighted the following (from checkpatch.pl I guess):

> CHECK: Macro argument 'sk' may be better as '(sk)' to avoid precedence  
> issues
> #99: FILE: include/linux/bpf-cgroup.h:255:
> +#define BPF_CGROUP_PRE_CONNECT_ENABLED(sk)       \
> + ((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) ||       \
> +  cgroup_bpf_enabled(BPF_CGROUP_INET6_CONNECT)) &&       \
> + sk->sk_prot->pre_connect)

> Other than, looks good to me.
Good point, will fix in a respin.

> Acked-by: Song Liu <songliubraving@fb.com>
