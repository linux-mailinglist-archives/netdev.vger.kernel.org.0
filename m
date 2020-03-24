Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567981904AB
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgCXExm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:53:42 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43126 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXExl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:53:41 -0400
Received: by mail-qk1-f193.google.com with SMTP id o10so12306995qki.10;
        Mon, 23 Mar 2020 21:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IvaYJ1XnXGHPe27WQZkUuZhxihBKOs9VY8C07B9yEtc=;
        b=YSofh0ixcItzY1hCTU95+xJJbgvWPrCfXUamGcZffe9LcFlkcNsA3XbO/dOOF+U5X1
         rW6Qv/H3BS3UGsDB9VmQoCdhD/2looREHK/bqvBxsMrrAnheGUQhrGDVx7w36Ij40Jkb
         UO0FpVFiIDsQnZohprjFaM0XzyFA2b7hvX1FJUrRvbg2ga7G3EE2mih3VBZx42gHF0pz
         /Hh/5po0Kz4dNEe3murKclutm1CVkJAHkdvUPSLkZhPO6Bt3jqHbW1VpmV7zV/+p117O
         GyzcUnCA+esI0KByuHVf40W55fyNUr5pDFdgQFvXsNlr/4Y5yRw/7DhcQuXWGwJ/ZvNp
         BRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IvaYJ1XnXGHPe27WQZkUuZhxihBKOs9VY8C07B9yEtc=;
        b=Y7jxq9+62h+neuFSwtxRRNpZsTAZtr1IVdQtHg2uD2P1WbfGgk+0HoiVsXPJzNSMrl
         2q/8xopiqOXlJxlslRID/LPCb4NhYWBmYmqnQv7avpz/bKuMoThwRIYsxZ7IgjNopBld
         BvQghhy9uAGBostEHdIv147SAUZuO1vwQm8G8r4S/USVjodAvqJkkk32QPgyM0vEzYGx
         yrri1D85DE5cuJNylAFSqiLGppWqgvOegyj/r2Kphrp5pzK7tl23+CNB30LXVrRbzQko
         JpnWfQp+3SrESC5Xgon8aKoQNbMUyZVhUcKBKfliy5fINIeS1MHK2ibokrfALj7Px6HJ
         eRag==
X-Gm-Message-State: ANhLgQ0MKejmsoLFDO26t8u/upxNbwSjAOzo9jsARqExeOCgDQFroL6K
        2qKl4bBNuxm44LIiA4jVUVYwckXeVxLDTQLo4+Q=
X-Google-Smtp-Source: ADFU+vtBtT+xud4VWucJrhJxHSb+2W+H0mZLbatGMPMjGuGByp1/zz1tkSu7QMyBfkeG7ZbBNOxst2yEkz18EiAe+z8=
X-Received: by 2002:a37:e40d:: with SMTP id y13mr24084004qkf.39.1585025620414;
 Mon, 23 Mar 2020 21:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <1dfae7b8-4f80-13b8-c67c-82fe0a34f42a@gmail.com>
In-Reply-To: <1dfae7b8-4f80-13b8-c67c-82fe0a34f42a@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Mar 2020 21:53:29 -0700
Message-ID: <CAEf4BzbT=vC8OF8cwFX8H5vphn8-dyWRjRSPq50t0Cg8onmYhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 6:01 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/23/20 1:23 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>>> I agree here. And yes, I've been working on extending bpf_link into
> >>>> cgroup and then to XDP. We are still discussing some cgroup-specific
> >>>> details, but the patch is ready. I'm going to post it as an RFC to g=
et
> >>>> the discussion started, before we do this for XDP.
> >>>
> >>> Well, my reason for being skeptic about bpf_link and proposing the
> >>> netlink-based API is actually exactly this, but in reverse: With
> >>> bpf_link we will be in the situation that everything related to a net=
dev
> >>> is configured over netlink *except* XDP.
>
> +1

Hm... so using **libbpf**'s bpf_set_link_xdp_fd() API (notice "bpf" in
the name of the library and function, and notice no "netlink"), which
exposes absolutely nothing about netlink (it's just an internal
implementation detail and can easily change), is ok. But actually
switching to libbpf's bpf_link would be out of ordinary? Especially
considering that to use freplace programs (for libxdp and chaining)
with libbpf you will use bpf_program and bpf_link abstractions
anyways.

>
> >>
> >> One can argue that everything related to use of BPF is going to be
> >> uniform and done through BPF syscall? Given variety of possible BPF
> >> hooks/targets, using custom ways to attach for all those many cases is
> >> really bad as well, so having a unifying concept and single entry to
> >> do this is good, no?
> >
> > Well, it depends on how you view the BPF subsystem's relation to the
> > rest of the kernel, I suppose. I tend to view it as a subsystem that
> > provides a bunch of functionality, which you can setup (using "internal=
"
> > BPF APIs), and then attach that object to a different subsystem
> > (networking) using that subsystem's configuration APIs.
> >
>
> again, +1.
>
> bpf syscall is used for program related manipulations like load and

bpf syscall is used for way more than that, actually...

> unload. Attaching that program to an object has a type unique solution -
> e.g., netlink for XDP and ioctl for perf_events.

That's not true and hasn't been true for at least a while now. cgroup
programs, flow_dissector, lirc_mode2 (whatever that is, I have no
idea) are attached with BPF_PROG_ATTACH. raw_tracepoint and all the
fentry/fexit/fmod_ret/freplace attachments are done also through bpf
syscall. For perf_event related stuff it's done through ioctls right
now, but with bpf_link unification I wouldn't be surprised if it will
be done through the same LINK_CREATE command soon, as is done for
cgroup and *other* tracing bpf_links. Because consistent API and
semantics is good, rather than having to do it N different ways for N
different subsystems.
