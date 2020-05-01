Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4F01C2057
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgEAWHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgEAWHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:07:40 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630B6C061A0E
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:07:40 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id 59so5407514qva.13
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 15:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7mhOLJrV7pmiMZ+I/NSj0jCIM2BIqm9ntgzvbLdFfQ=;
        b=dl3v71Up7pVb7WbZKlBu/QzhfRMR5t5Nin4rslS57n+QLajuNIfE0I1lB4Ty+LfjqB
         cuojQBtADVsAuqSXB8aqGa5q18d5jQBtEawoaTnxyjQdm5DJik+81OranapognncD2ui
         gy40cB6S2J6mlCGR2ZoiZ4jq27bMtvyOh7MuivEuTk8jJuHN+dcHnaJB0Sh4GtcEtxSv
         092ZUXq4ATycrfRzuSC3Ch2cEAB7L+eUVZOgm2KtTPOQyPpA9+3X6ozySO8Fk5ZE2E9h
         aaogQ/1FO+M7Mhog81EYaAeOdFLEoSluS3CxZFnRdR5evgfmUqteKYsL2lYtiLyY+ORb
         uADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7mhOLJrV7pmiMZ+I/NSj0jCIM2BIqm9ntgzvbLdFfQ=;
        b=dPgxK3mrqsqR9JRgUMwuS3wE6rNYkgQrrW4qZHnjBHj13EOa3CCsZK3B/YPQokvuyR
         +C1JRhp8DElGcxRf6ak4nDOesAlD13vI2h9HDzd8/bKA7XX7S9y3MzeuycyuCVPqTbw1
         aXtqJkoabxQTI7ASMyJTQvdG+B01gJz6RN9OWJ1n6V5o1TywWanuwED8N45HMBGGjahK
         3gFFsduS5ikuc8WuU6SjD706RgJ+ofLOH107X6XNsYO0kjSsghT+ncohlm7ybqUwCVU2
         s4ndIeh/ZkrQTqHauuD8I+xsJ2ssC61gOXV7JZ+fxkBFUXnv+otu1YjMDzpAC/ji8dvA
         Pmvg==
X-Gm-Message-State: AGi0Pub5B9QnLySD4FCQAqXwJbaDmAWygZFWl5Feqdvxj6NWeR2aqR6s
        eHmnoPmkq5I3ieH7+Um42ZiXN1PPr7MOmeh4U8zUzw==
X-Google-Smtp-Source: APiQypKEOoHK8iFM8Z7xzUwIZ2+pHpidA0Bw62wq3uuTjy2e4YBeUm0WLfqMlyMsCJ/G3WbgtCX5xD091sLrXY2viqA=
X-Received: by 2002:a05:6214:1705:: with SMTP id db5mr5879923qvb.225.1588370859234;
 Fri, 01 May 2020 15:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200430233152.199403-1-sdf@google.com> <20200501215202.GA72448@rdna-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200501215202.GA72448@rdna-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 1 May 2020 15:07:28 -0700
Message-ID: <CAKH8qBtcC7PhWOYLZKP7WeGjP4fY0u_DRQcDi51JkY2otcRYiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct bpf_sock_addr
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 1, 2020 at 2:52 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> [Thu, 2020-04-30 16:32 -0700]:
> > Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
> > 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> > Let's generalize them and make them available for 'struct bpf_sock_addr'.
> > That way, in the future, we can allow those helpers in more places.
> >
> > As an example, let's expose those 'struct bpf_sock_addr' based helpers to
> > BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
> > connection is made.
> >
> > v3:
> > * Expose custom helpers for bpf_sock_addr context instead of doing
> >   generic bpf_sock argument (as suggested by Daniel). Even with
> >   try_socket_lock that doesn't sleep we have a problem where context sk
> >   is already locked and socket lock is non-nestable.
> >
> > v2:
> > * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
> ...
>
> >  SEC("cgroup/connect4")
> >  int connect_v4_prog(struct bpf_sock_addr *ctx)
> >  {
> > @@ -66,6 +108,10 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
> >
> >       bpf_sk_release(sk);
> >
> > +     /* Rewrite congestion control. */
> > +     if (ctx->type == SOCK_STREAM && set_cc(ctx))
> > +             return 0;
>
> Hi Stas,
>
> This new check breaks one of tests in test_sock_addr:
>
>         root@arch-fb-vm1:/home/rdna/bpf-next/tools/testing/selftests/bpf ./test_sock_addr.sh
>         ...
>         (test_sock_addr.c:1199: errno: Operation not permitted) Fail to connect to server
>         Test case: connect4: rewrite IP & TCP port .. [FAIL]
>         ...
>         Summary: 34 PASSED, 1 FAILED
>
> What the test does is it sets up TCPv4 server:
>
>         [pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 6
>         [pid   386] bind(6, {sa_family=AF_INET, sin_port=htons(4444), sin_addr=inet_addr("127.0.0.1")}, 128) = 0
>         [pid   386] listen(6, 128)              = 0
>
> Then tries to connect to a fake IPv4:port and this connect4 program
> should redirect it to that TCP server, but only if every field in
> context has expected value.
>
> But after that commit program started denying the connect:
>
>         [pid   386] socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 7
>         [pid   386] connect(7, {sa_family=AF_INET, sin_port=htons(4040), sin_addr=inet_addr("192.168.1.254")}, 128) = -1 EPERM (Operation not permitted)
>         (test_sock_addr.c:1201: errno: Operation not permitted) Fail to connect to server
>         Test case: connect4: rewrite IP & TCP port .. [FAIL]
>
> I verified that commenting out this new `if` fixes the problem, but
> haven't spent time root-causing it. Could you please look at it?
Could you please confirm that you have CONFIG_TCP_CONG_DCTCP=y in your kernel
config? (I've added it to tools/testing/selftests/bpf/config)
The test is now flipping CC to dctcp and back to default cubic. It can
fail if dctcp is not compiled in.
