Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B0306694
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhA0VnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbhA0Vdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:33:39 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C537C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:32:59 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id n3so1818438qvf.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nB36mhe50GjyeA/BjfyL20F/M3CBxc8N3/xYACYJ5lU=;
        b=nndsGpc+WylQa3lNtHEx03OFAolP92vLHdKvZSeBIHWEvPyF0ul3rmxAbIHYmaDTGd
         ef+Uk4pOhEXcJExam6HmXmK0XOgj3EieVhfZnSfO5IooiIT4kyeD4lQSh0JFePIpioq4
         QCB1xF4lT4qt7wJxEL+cbxs543yaKNtxK/2wegIQ2b1L13BtEjNilVhbXGPOlmGxdCkn
         inbH1dV1gpL43IJqYvVpukG65wIraCbWc83oLQi7HsGHiwZtVJ3DnEInqp5pC5gNVAf/
         oRDwPAq/wyBxVzpgZSuRUwfuqwTQf9zAIWl/Mw8PH0YgKI0v3ZWr4i0CjQ7apIlvF/Pk
         Xk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nB36mhe50GjyeA/BjfyL20F/M3CBxc8N3/xYACYJ5lU=;
        b=Omglu1YpJdhecOmQ7AWtPJs5uWrGO0kBJF8rgKvu7PH5hiuOt9jQlD/ACG8KtG9zNz
         WsmUF8UYS0kxc6il79qekaJRtKoj4fq3JpP3WJp00S8D05Jt23FQ36hO9uGtLkVS0aPE
         xrZjxeGoSUvNeF1diWH6Ejs8ucBQu+8kS5KjPEutyIx5LglK5L6PwY5fS5ccu+dSK/9R
         jOx3LXJ9IltTmyD7W/7KSHptOfxVcJDVhTaEhf05SU4Impc0+EFFL7C3E4PiJ2v1UyBp
         ljmsKHg276aorT4QUT2HBjzF1VB3c8vd983enkeq1ejj2ZWJSJVqKgF2/j3lx3yKEBa/
         B8HQ==
X-Gm-Message-State: AOAM532FVfyFFMZpu9ztZgAcFhdCtW2tPgU//5pal28cpIFOHSD/sfl4
        FuXgEewDjtzNdMBWqWTEIRKDgj3iT3kkVasTrKv2wUVDOzk=
X-Google-Smtp-Source: ABdhPJzwNkv7FMJe7epvNR+Gp2aA+mp30pz1WQuWEPswVydA9SzEcoXSOvOJplOg7+XsrqffDUXFZtuMeKphbl45zk4=
X-Received: by 2002:a0c:ab8b:: with SMTP id j11mr12443151qvb.0.1611783178007;
 Wed, 27 Jan 2021 13:32:58 -0800 (PST)
MIME-Version: 1.0
References: <20210127174714.2240395-1-sdf@google.com> <c3bf8a04-818a-248c-fd27-d33b5dc4d826@iogearbox.net>
In-Reply-To: <c3bf8a04-818a-248c-fd27-d33b5dc4d826@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 27 Jan 2021 13:32:47 -0800
Message-ID: <CAKH8qBvx3F+fYE7-heTgxTa7yKPiUOdsLfTQ7TRmJX2bLapmbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_SENDMSG
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 1:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/27/21 6:47 PM, Stanislav Fomichev wrote:
> > Can be used to query/modify socket state for unconnected UDP sendmsg.
> > Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
> > a locked socket.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   net/core/filter.c                                 | 4 ++++
> >   tools/testing/selftests/bpf/progs/sendmsg4_prog.c | 7 +++++++
> >   tools/testing/selftests/bpf/progs/sendmsg6_prog.c | 7 +++++++
> >   3 files changed, 18 insertions(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 9ab94e90d660..3d7f78a19565 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -7023,6 +7023,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >               case BPF_CGROUP_INET6_BIND:
> >               case BPF_CGROUP_INET4_CONNECT:
> >               case BPF_CGROUP_INET6_CONNECT:
> > +             case BPF_CGROUP_UDP4_SENDMSG:
> > +             case BPF_CGROUP_UDP6_SENDMSG:
> >                       return &bpf_sock_addr_setsockopt_proto;
> >               default:
> >                       return NULL;
> > @@ -7033,6 +7035,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >               case BPF_CGROUP_INET6_BIND:
> >               case BPF_CGROUP_INET4_CONNECT:
> >               case BPF_CGROUP_INET6_CONNECT:
> > +             case BPF_CGROUP_UDP4_SENDMSG:
> > +             case BPF_CGROUP_UDP6_SENDMSG:
> >                       return &bpf_sock_addr_getsockopt_proto;
>
> Patch looks good, could we at this point also add all the others that run under
> BPF_CGROUP_RUN_SA_PROG_LOCK while at it, that is v4/v6 flavors of recvmsg as well
> as peername/sockname?
Sounds good, will resend with more hooks added.
