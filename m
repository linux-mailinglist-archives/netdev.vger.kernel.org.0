Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F94C3082C9
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhA2BAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhA2BAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:00:17 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66735C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:59:37 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id l11so3790047qvt.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qUpTbec5MOgkF1GzUlkb9771SWgkcTOinoyZuA28hOk=;
        b=MreuopVqD/nnpFdAT5R7HuGaIpThu/UA+yK6OJim3xOHZg1qTHx1cwKBjW6nhtrjJu
         /7uEemqikCDKe527G1nPU/gOKyJZHFxsD+tajMKuL1s00fwovrhjNhBZTKP7idNdnPQB
         19d9RrC0mud3OcDDdi7v7jhmVFZ7X8NzT1g5vBatXcIlaZqWMm+ypEWgVcYK80uSnUmE
         CI3lh7tDJtq6PyoDECjtuOr7+Sk0Tzl8gF7eC7LhAv7xvMiDko15yT8iHzZ35XmVSvAj
         Y7uFfYt38P4MRvhnvKdtVKoFBeQDF4OM0MuT7s6l4TduE6m3DHk38UGTtlKZ/FGxBIla
         dhHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qUpTbec5MOgkF1GzUlkb9771SWgkcTOinoyZuA28hOk=;
        b=ItZY7AuCiXXRMtE3sqt5rkO9p3r7m93Xvf4RtB2+RmJY220+QJSJnLcj/xg93TXkR6
         nm2EF1mwRvOyJaT+4n7vVws/cUT8CLfjnO2S+wQ6sCmRo0DkxTwjvvGt1XsfrEmZcrsK
         n9D1ZBCPOzZK8fBsEzRAL6Lczp0U/hI107wmoFMll6J6EsT4QUsUx+xvwQZ+vV4L3yS1
         Jz6bYXCWQ39ISZ0Rpfi4dYo9/q3iQCsrg3/5/3QACHenoJkebPFaFuqumuVFSFbtbUHj
         MnhVgg1oMLB/+u7VPExcZmK1RCSK77jtAuy0dl3YPBRUtkxiEMm+gGuLXBRe/mH0MvHi
         OZww==
X-Gm-Message-State: AOAM5314P2wboMppbyoqGYkjN/AXI2+HJcZqKzNUq15XbPoAtw0ytlGX
        UiNFXyZFXelGfqIWaPMgueMYinn7LXyF1ziYyVwE6ikEEHw=
X-Google-Smtp-Source: ABdhPJwW/38gNm8ZKrS5BEw+YXWooWOFM1vq5gSyJSXgkDbT2dRkX505dX3wOcRzBsjE5whi4ybYr748IEK2ciia5o4=
X-Received: by 2002:ad4:4047:: with SMTP id r7mr1943709qvp.0.1611881976195;
 Thu, 28 Jan 2021 16:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20210127232853.3753823-1-sdf@google.com> <20210127232853.3753823-5-sdf@google.com>
 <3098d1b1-3438-6646-d466-feed27e9ba6b@iogearbox.net>
In-Reply-To: <3098d1b1-3438-6646-d466-feed27e9ba6b@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 28 Jan 2021 16:59:25 -0800
Message-ID: <CAKH8qBsU+8495AwcCtQ0fQ8B6mrRLULZ4k3A=XUX3BL0gha_cA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_RECVMSG
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 4:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/28/21 12:28 AM, Stanislav Fomichev wrote:
> > Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
> > a locked socket.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   net/core/filter.c                                 | 4 ++++
> >   tools/testing/selftests/bpf/progs/recvmsg4_prog.c | 5 +++++
> >   tools/testing/selftests/bpf/progs/recvmsg6_prog.c | 5 +++++
> >   3 files changed, 14 insertions(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index ba436b1d70c2..e15d4741719a 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -7023,6 +7023,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >               case BPF_CGROUP_INET6_BIND:
> >               case BPF_CGROUP_INET4_CONNECT:
> >               case BPF_CGROUP_INET6_CONNECT:
> > +             case BPF_CGROUP_UDP4_RECVMSG:
> > +             case BPF_CGROUP_UDP6_RECVMSG:
> >               case BPF_CGROUP_UDP4_SENDMSG:
> >               case BPF_CGROUP_UDP6_SENDMSG:
> >               case BPF_CGROUP_INET4_GETPEERNAME:
> > @@ -7039,6 +7041,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >               case BPF_CGROUP_INET6_BIND:
> >               case BPF_CGROUP_INET4_CONNECT:
> >               case BPF_CGROUP_INET6_CONNECT:
> > +             case BPF_CGROUP_UDP4_RECVMSG:
> > +             case BPF_CGROUP_UDP6_RECVMSG:
> >               case BPF_CGROUP_UDP4_SENDMSG:
> >               case BPF_CGROUP_UDP6_SENDMSG:
> >               case BPF_CGROUP_INET4_GETPEERNAME:
>
> Looks good overall, also thanks for adding the test cases! I was about to apply, but noticed one
> small nit that would be good to get resolved before that. Above you now list all the attach hooks
> for sock_addr ctx, so we should just remove the whole switch that tests on prog->expected_attach_type
> altogether in this last commit.
Sure, I can resend tomorrow.
But do you think it's safe and there won't ever be another sock_addr
hook that runs with an unlocked socket?
