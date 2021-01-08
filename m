Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623842EF811
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbhAHTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbhAHTZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 14:25:17 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5636C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 11:23:44 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id q5so11315425ilc.10
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 11:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zou52vkDfpotpl96OFLnojVJMT0aBb8ajwpj6ZURnnM=;
        b=PZ9JHy3cfOxtvNGCQhArUQKDaua2ObhiMEk8XhfNNtqOSrZ21Ja2N2ERgt67rPbXhH
         Mk4vwpWYd4xfrE5LlvclWxpjbpS4H+L63Zqw4u5xmmkbxkDJNmHckOIwsO8r7twBCBSr
         frmGXpq3+lAuBCsngohMXUQ7yO63ZhToGv3N+iy9UB9my+RSSbucxr+Cn3WfzfbtgeUH
         vjqH6m9d8e/87rra/NcQR60lUO6awd6LtkX3IBuKdyBcs3wmkvBtLosBqEALBvVNsGTm
         G4plhXsAmPGeAmRZ9GufaFjJ/VjVCQTFoJ3gdVE8U4D6nHLcK0+xKg/E4Tl6l5zLhS5E
         gnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zou52vkDfpotpl96OFLnojVJMT0aBb8ajwpj6ZURnnM=;
        b=ObQDPyb7mDLdn1+pIFVAcvmTJV7+dIzYcogj2eAmg+fBTuCBKEwgxtLj1uX8O3Q2Y7
         6VSkL6XnrZtJLed0EsPlp2B6cFB8TqkWD5lVozk90ocnrtWviDzkycJH+NLR31jlHgNX
         0nGtkl4H+8jNgv2SQlA6S5t6JPWC0zYZBB6BvuW2VtzitP/TT3IQb9iOOotSGFcx8VmZ
         XHbPIs8N9aPS/SVIdgUN4vd5EVX6ddu+meGaOejfnEIR6ECwJckh4DY4F0/ypohs4L9m
         Mt7xyI+qO2lIaxPX6e20PYg/tBAWvmDNeE2J057X53PbBq/NF/TS0d2B0ltEr4b/agSu
         aB6A==
X-Gm-Message-State: AOAM531EoDj0XcZkJFo/FBHufSMrmaGZ9ovVgXqNIYBqI5Pxqkr/3l04
        3OjXiBidjVRIFL3iTdjiWfxfju5UXvQKV6lkwFP1AhNByC0Dkw==
X-Google-Smtp-Source: ABdhPJycK+LeAGVSya/LsACU1XiZYXapFTWQDqP0nNMBRRpzl5dwNHtyck6HmTj8bfUghCynBslPMifSStdpdAlMl0U=
X-Received: by 2002:a92:da82:: with SMTP id u2mr5219250iln.137.1610133823896;
 Fri, 08 Jan 2021 11:23:43 -0800 (PST)
MIME-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com> <20210108180333.180906-2-sdf@google.com>
 <CANn89i+GvEUmoapF+C0Mf1qw+AuWhU5_MMPz-jy8fND0HmUJ=Q@mail.gmail.com>
 <CAKH8qBsWsKVxAyvhEYqXytTFMGEN=C3ZMKBPLs2RKcEpM4hXXQ@mail.gmail.com>
 <CANn89iKv1aKE3Tcyr-vqv2mHeDompWjUn6txeK-qEO6-G-pBBw@mail.gmail.com> <CAKH8qBuGi_7eFpX0y+HdJznMvUxZsrJtdz2O5P4WK-4H_8s8Xw@mail.gmail.com>
In-Reply-To: <CAKH8qBuGi_7eFpX0y+HdJznMvUxZsrJtdz2O5P4WK-4H_8s8Xw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 20:23:32 +0100
Message-ID: <CANn89iL9L_6MyZ2qYM8pGmNqjfP25mO_wMAtb7ixp+dweBS0vw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 8:08 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Jan 8, 2021 at 10:41 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Jan 8, 2021 at 7:26 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > On Fri, Jan 8, 2021 at 10:10 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Fri, Jan 8, 2021 at 7:03 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > > > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > > > 3% overhead for locking/unlocking the socket.
> > > > >
> > > > > Without this patch:
> > > > >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> > > > >             |
> > > > >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> > > > >                        |
> > > > >                         --0.81%--__kmalloc
> > > > >
> > > > > With the patch applied:
> > > > >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> > > > >
> > > >
> > > >
> > > > OK but we are adding yet another indirect call.
> > > >
> > > > Can you add a patch on top of it adding INDIRECT_CALL_INET() avoidance ?
> > > Sure, but do you think it will bring any benefit?
> >
> > Sure, avoiding an indirect call might be the same gain than the
> > lock_sock() avoidance :)
> >
> > > We don't have any indirect avoidance in __sys_getsockopt for the
> > > sock->ops->getsockopt() call.
> > > If we add it for this new bpf_bypass_getsockopt, we might as well add
> > > it for sock->ops->getsockopt?
> >
> > Well, that is orthogonal to this patch.
> > As you may know, Google kernels do have a mitigation there already and
> > Brian may upstream it.
> I guess my point here was that if I send it out only for bpf_bypass_getsockopt
> it might look a bit strange because the rest of the getsockopt still
> suffers the indirect costs.


Each new indirect call adds a cost. If you focus on optimizing
TCP_ZEROCOPY_RECEIVE,
it is counter intuitive adding an expensive indirect call.

 If Brian has plans to upstream the rest, maybe
> it's better to upstream everything together with some numbers?
> CC'ing him for his opinion.

I am just saying your point about the other indirect call is already taken care.

>
> I'm happy to follow up in whatever form is best. I can also resend
> with INDIRECT_CALL_INET2 if there are no objections in including
> this version from the start.
>

INDIRECT_CALL_INET2 seems a strange name to me.
