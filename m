Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB67300FE6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbhAVWXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730667AbhAVTyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:54:45 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04624C061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 11:54:03 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id d14so6324782qkc.13
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 11:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3+2RrVerjMaWuS5/ui/Sx1ksZD77pxsUnMtE6ueQUw=;
        b=Px2iN2UyfVAQro3oP7tv3xH1JBVH4ZW100K5nazymj8nxitzrw5ztR0doNRZJoGquj
         4DYiTQQ8R+2lEi7xJbRtYD130dRvsEWCBy5Yyzb5QdAJeZEMWY/59xZ8fJGvxTElDTDC
         oBI6LEyj4NjF2vb1+5kICsLCvAM0HjeduezoNCkp6Ks0UbtNunNdAwzjoG99itoPkHnv
         K+JMIobKhFpJNB8kg2pCcFKjjUv4pk635LTHy3HRdxCy4z5Lm6xVq7X/F1A96Ll/SwH9
         kSfAVhI0JcTT6kXBZrodK7i6rSa3vp7gQGfypHDke/xUU1ap2OHfJ0a4Xy+RruVzERak
         3K0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o3+2RrVerjMaWuS5/ui/Sx1ksZD77pxsUnMtE6ueQUw=;
        b=SpXbi5Z2jpxBdsmMP7aMiUQBuL4QmUKLOjEHXuxngzz66q0QsqoV8N6m2HB6bpVEI/
         M+KJf9oQ/gxegF0L2OpGLscOvyf66ZLOjE27FywPC0NdoR1DeQglhQa7czoKpaudL16V
         X9epPCch2JHAfBEsqXT6LqLAnPYBeiZvxfcpMEknxNvZjwIFszWoehkHCsvtExk4Npod
         Wb1Z0DjHIlwGj86CwadGrN/bPGx4r3v3/AtyuP6CwBkxU243liu+KaP+iZoUod7JO7M/
         4dT9mL6PcWLq48FRowFNoonebgTlwfyJJyAi9aMFnGkjdPRHzcoUib3SWCZfHFwVfWuL
         Ra3w==
X-Gm-Message-State: AOAM533y30AMi+V12oYid01NZJNsd6PAgp0svhdSmEMqOm3qeCSz1elu
        N3vtxJMoEBSXLFxVwKLeFNOjV0dot7uMd9R3mlWmWsYOmpY=
X-Google-Smtp-Source: ABdhPJzSM43NTCuGbPUVg21hUwmPCbZ2cc61t0SNIgR0kc0idNF01oQm06wIsE897ym/NCYi1bXoOgg0zr2YcZnX2B0=
X-Received: by 2002:a05:620a:22ab:: with SMTP id p11mr6315334qkh.237.1611345241897;
 Fri, 22 Jan 2021 11:54:01 -0800 (PST)
MIME-Version: 1.0
References: <20210121012241.2109147-1-sdf@google.com> <YAspc5rk2sNWojDQ@rdna-mbp.dhcp.thefacebook.com>
In-Reply-To: <YAspc5rk2sNWojDQ@rdna-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 22 Jan 2021 11:53:51 -0800
Message-ID: <CAKH8qBumq7cHDeCpvA1T_rJyvY8+9uCUyb--YAhvcAx3p58faw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow rewriting to ports under ip_unprivileged_port_start
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 11:37 AM Andrey Ignatov <rdna@fb.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> [Wed, 2021-01-20 18:09 -0800]:
> > At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> > to the privileged ones (< ip_unprivileged_port_start), but it will
> > be rejected later on in the __inet_bind or __inet6_bind.
> >
> > Let's export 'port_changed' event from the BPF program and bypass
> > ip_unprivileged_port_start range check when we've seen that
> > the program explicitly overrode the port. This is accomplished
> > by generating instructions to set ctx->port_changed along with
> > updating ctx->user_port.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> ...
> > @@ -244,17 +245,27 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
> >       if (cgroup_bpf_enabled(type))   {                                      \
> >               lock_sock(sk);                                                 \
> >               __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> > -                                                       t_ctx);              \
> > +                                                       t_ctx, NULL);        \
> >               release_sock(sk);                                              \
> >       }                                                                      \
> >       __ret;                                                                 \
> >  })
> >
> > -#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)                              \
> > -     BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
> > -
> > -#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)                              \
> > -     BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
> > +#define BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr, type, flags)          \
> > +({                                                                          \
> > +     bool port_changed = false;                                             \
>
> I see the discussion with Martin in [0] on the program overriding the
> port but setting exactly same value as it already contains. Commenting
> on this patch since the code is here.
>
> From what I understand there is no use-case to support overriding the
> port w/o changing the value to just bypass the capability. In this case
> the code can be simplified.
>
> Here instead of introducing port_changed you can just remember the
> original ((struct sockaddr_in *)uaddr)->sin_port or
> ((struct sockaddr_in6 *)uaddr)->sin6_port (they have same offset/size so
> it can be simplified same way as in sock_addr_convert_ctx_access() for
> user_port) ...
>
> > +     int __ret = 0;                                                         \
> > +     if (cgroup_bpf_enabled(type))   {                                      \
> > +             lock_sock(sk);                                                 \
> > +             __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> > +                                                       NULL,                \
> > +                                                       &port_changed);      \
> > +             release_sock(sk);                                              \
> > +             if (port_changed)                                              \
>
> ... and then just compare the original and the new ports here.
>
> The benefits will be:
> * no need to introduce port_changed field in struct bpf_sock_addr_kern;
> * no need to do change program instructions;
> * no need to think about compiler optimizing out those instructions;
> * no need to think about multiple programs coordination, the flag will
>   be set only if port has actually changed what is easy to reason about
>   from user perspective.
>
> wdyt?
Martin mentioned in another email that we might want to do that when
we rewrite only the address portion of it.
I think it makes sense. Imagine doing 1.1.1.1:50 -> 2.2.2.2:50 it
seems like it should also work, right?
And in this case, we need to store and compare addresses as well and
it becomes messy :-/
It also seems like it would be nice to have this 'bypass
cap_net_bind_service" without changing the address while we are at it.
