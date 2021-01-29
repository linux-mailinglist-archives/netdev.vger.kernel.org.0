Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB63308319
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhA2BPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhA2BPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:15:35 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE79C061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:14:54 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id t63so7379664qkc.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JTCX5IGr1BzAjh8I92z82M+hPV8AOuXj68PWQZO0zGQ=;
        b=FcuhuZO5oaH8/L/oIEkBK91zuouY2MCp6ZgC+lKN5MUakWvIx1pQ1iMNF1/JuNnMgD
         3EWjKsor6ybbw31NEXukgtC08p0GtRvyC++JZtD0L3fBJhbPT3HVkxY0cp8U5K9Hb5Q0
         U5T5J50bWdVvrujbNlssEEdrBmSaE0TYt+7tWqids26zUpHF5iBFDo4zz6uuhordDjBw
         sGUZi0EK8vG0qLOCCAQQketkE50GpTmlFeunQ/I1gfwpoc8XuVZ1vQQO+ARWHm7bZjcq
         IEMSNH9ew/WZ2SoMS8/4QV0lAxtvYlPE5mwzg9jKSq/8VyCoGUh/gV4Ha/ufqWiD34sv
         /Zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JTCX5IGr1BzAjh8I92z82M+hPV8AOuXj68PWQZO0zGQ=;
        b=DYwi8/sr41tDmd9rmBZK7w9W3VQ3MKSxPs0H25ETTQDM97xQaDbBN/bK7vpjBPTlSk
         rXecv4aHZom3aWbJCp+RJ1BTfeJt2WzJy6l8GphHteodFm4PZnoyt1QNtJvWNens29sA
         iyH/Bd6KVJ+SxIQPGfC1l9DkgS/wy0pa4Ds+FzCuJ42Ore5k8kmi/0yghbkwkze7hrjg
         q/Xs4eMBhgjKsxz3y83PW5fLQPVt4v7fTy1O1dI6g2H/8Lk6q6gUcqkPCUYzixGJpV29
         KseBTKi4A497Zi7sUauNgjtA9xD4dGsZQPL2wbpTQbQiH0JC0d7Yr9mPWQw5D+MtR2h4
         s/Bw==
X-Gm-Message-State: AOAM530Dqi23qg607JdAupF84Xf/PVOivWNzDRPfMWlDSY2hf5Bd/mXE
        fhCG0xBCZb31lRpqkNXfu8GXj/BB6q8mREXsXYIrQPn9fvs=
X-Google-Smtp-Source: ABdhPJw3LMWQiGPFSALC3PZM/lY7pkeff37vg3xagCxllh8n2yi7Dk78bjylPK6AYgUhh0ddKXIWNAUoZqkGb9uFjlY=
X-Received: by 2002:a37:678b:: with SMTP id b133mr2077959qkc.237.1611882893607;
 Thu, 28 Jan 2021 17:14:53 -0800 (PST)
MIME-Version: 1.0
References: <20210127232853.3753823-1-sdf@google.com> <20210127232853.3753823-5-sdf@google.com>
 <3098d1b1-3438-6646-d466-feed27e9ba6b@iogearbox.net> <CAKH8qBsU+8495AwcCtQ0fQ8B6mrRLULZ4k3A=XUX3BL0gha_cA@mail.gmail.com>
 <d421b6b5-f591-756f-2d73-0fab367a68f5@iogearbox.net>
In-Reply-To: <d421b6b5-f591-756f-2d73-0fab367a68f5@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 28 Jan 2021 17:14:42 -0800
Message-ID: <CAKH8qBvGQ-JpBg3J4uH4oSytmT3anLLLdt4frWiKHDaT3yVfsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_RECVMSG
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 5:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/29/21 1:59 AM, Stanislav Fomichev wrote:
> > On Thu, Jan 28, 2021 at 4:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 1/28/21 12:28 AM, Stanislav Fomichev wrote:
> >>> Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
> >>> a locked socket.
> >>>
> >>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >>> ---
> >>>    net/core/filter.c                                 | 4 ++++
> >>>    tools/testing/selftests/bpf/progs/recvmsg4_prog.c | 5 +++++
> >>>    tools/testing/selftests/bpf/progs/recvmsg6_prog.c | 5 +++++
> >>>    3 files changed, 14 insertions(+)
> >>>
> >>> diff --git a/net/core/filter.c b/net/core/filter.c
> >>> index ba436b1d70c2..e15d4741719a 100644
> >>> --- a/net/core/filter.c
> >>> +++ b/net/core/filter.c
> >>> @@ -7023,6 +7023,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >>>                case BPF_CGROUP_INET6_BIND:
> >>>                case BPF_CGROUP_INET4_CONNECT:
> >>>                case BPF_CGROUP_INET6_CONNECT:
> >>> +             case BPF_CGROUP_UDP4_RECVMSG:
> >>> +             case BPF_CGROUP_UDP6_RECVMSG:
> >>>                case BPF_CGROUP_UDP4_SENDMSG:
> >>>                case BPF_CGROUP_UDP6_SENDMSG:
> >>>                case BPF_CGROUP_INET4_GETPEERNAME:
> >>> @@ -7039,6 +7041,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >>>                case BPF_CGROUP_INET6_BIND:
> >>>                case BPF_CGROUP_INET4_CONNECT:
> >>>                case BPF_CGROUP_INET6_CONNECT:
> >>> +             case BPF_CGROUP_UDP4_RECVMSG:
> >>> +             case BPF_CGROUP_UDP6_RECVMSG:
> >>>                case BPF_CGROUP_UDP4_SENDMSG:
> >>>                case BPF_CGROUP_UDP6_SENDMSG:
> >>>                case BPF_CGROUP_INET4_GETPEERNAME:
> >>
> >> Looks good overall, also thanks for adding the test cases! I was about to apply, but noticed one
> >> small nit that would be good to get resolved before that. Above you now list all the attach hooks
> >> for sock_addr ctx, so we should just remove the whole switch that tests on prog->expected_attach_type
> >> altogether in this last commit.
> > Sure, I can resend tomorrow.
> > But do you think it's safe and there won't ever be another sock_addr
> > hook that runs with an unlocked socket?
>
> Ok, that rationale seems reasonable to keep the series as is. It probably makes sense to add a
> small comment at least to the commit log to explain the reasoning, I can do so while applying.
> So no need for v3, thanks!
Sounds good, thank you!
